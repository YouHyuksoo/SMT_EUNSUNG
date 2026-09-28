/**
 * @file src/modules/warehouse/warehouse.dto.ts
 * @description 자재창고(M_WAREHOUSE) DTO — 1단계: 챔버 재고조회 3화면 + SMT 공릴체크
 *
 * 초보자 가이드:
 * 1. **자재창고는 바코드 스캔 업무다.** 리포트처럼 "기간이 유일한 방어선" 이 아니라
 *    바코드·롯트·전표번호 같은 **키**가 있다. 조건 설계가 리포트와 다르다.
 * 2. **262·263·264 는 같은 화면이다.** 베이킹실·진공포장·제습함 세 화면의
 *    DataWindow SQL 이 **글자까지 동일**하고 `chamber_type` 인자만 'B'/'V'/'D' 로
 *    다르다 (실측). 그래서 서비스는 하나이고 갈래 인자로 가른다.
 * 3. **'재고' 의 정의는 `넣었고 아직 안 꺼낸 것` 이다**
 *    (`INPUT_SCAN_DATE IS NOT NULL AND OUTPUT_SCAN_DATE IS NULL` — PB 고정조건).
 *    이 두 조건을 빠뜨리면 지나간 이력이 전부 재고로 잡힌다.
 *    실측 재고: 베이킹 4건 · 진공포장 0건 · 제습함 55건 (전체 이력 18,352건 중 59건).
 * 4. **266 SMT 공릴체크는 조회 전용이다.** PB 에 `dw_1.update()` + commit 이 있지만
 *    12개 컬럼이 **모두 `tabsequence=32766`(편집 불가)** 이라 바뀔 값이 없다 —
 *    무동작이다 (340 라인설비바코드와 같은 유형).
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { SOLDER_FACTORIES } from '@smt/shared';
import { Transform, Type } from 'class-transformer';
import {
  IsArray,
  IsBoolean,
  IsIn,
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
  Length,
  Matches,
  Max,
  Min,
} from 'class-validator';

const DATE_ONLY = /^\d{4}-\d{2}-\d{2}$/;

/**
 * 챔버 종류. PB 가 화면마다 고정으로 넘기던 값이다 (실측 분포):
 *   'B' 베이킹실 233건 · 'V' 진공포장 9,343건 · 'D' 제습함 8,776건
 *
 * `ISYS_BASECODE` 에 'CHAMBER TYPE' 코드표는 **없다** — 화면마다 고정값이라
 * 코드표가 필요 없었다. 그래서 여기서도 문자 상수로 둔다.
 */
export const CHAMBER_TYPES = ['B', 'V', 'D'] as const;
export type ChamberType = (typeof CHAMBER_TYPES)[number];

/** 262·263·264 — 챔버에 들어가 있는 자재 (요약·상세 공통 조건). */
export class ChamberStockQueryDto {
  @ApiProperty({
    description: "챔버 종류. 'B' 베이킹실 · 'V' 진공포장 · 'D' 제습함."
      + ' 화면마다 고정이며 이 값으로 세 화면이 갈린다.',
    enum: CHAMBER_TYPES,
  })
  @IsIn(CHAMBER_TYPES as unknown as string[])
  chamberType!: ChamberType;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '자재 롯트(LOT_NO, 앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  lotNo?: string;

  @ApiPropertyOptional({ description: '챔버(설비)코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  chamberCode?: string;
}

/**
 * 262·263·264 상세 — 요약에서 고른 (챔버, 품목) 한 묶음의 자재 목록.
 *
 * PB 는 요약 그리드에서 행을 고르면 상세를 다시 조회한다 (마스터-디테일).
 * 상세의 품목·챔버 조건은 **등호**다 — 요약이 돌려준 값을 그대로 넘긴다.
 */
export class ChamberStockDetailQueryDto {
  @ApiProperty({ description: "챔버 종류 ('B'·'V'·'D')", enum: CHAMBER_TYPES })
  @IsIn(CHAMBER_TYPES as unknown as string[])
  chamberType!: ChamberType;

  @ApiProperty({ description: '품목코드 (요약이 돌려준 값 그대로 — 등호로 걸린다)' })
  @IsString() @Length(1, 50)
  itemCode!: string;

  @ApiProperty({ description: '챔버(설비)코드 (요약이 돌려준 값 그대로 — 등호로 걸린다)' })
  @IsString() @Length(1, 30)
  chamberCode!: string;
}

/**
 * 266 SMT 공릴체크.
 *
 * `IB_RECYCLE_CHECKHIST` 는 577행이고 **CHECK_DATE 인덱스가 없다**
 * (SCAN_PARTNAME 단독 인덱스뿐 — 실측). 표가 작아 전체 스캔이어도 무관하지만,
 * 기간을 필수로 두는 이유는 성능이 아니라 화면의 뜻이다 (언제의 체크인가).
 */
export class RecycleCheckQueryDto {
  @ApiProperty({ description: '체크일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '체크일 종료 (YYYY-MM-DD, 이 날짜 포함)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  lineCode?: string;

  @ApiPropertyOptional({
    description: "체크상태 (앞부분 일치). 실측 분포 'P' 통과 419건 · 'E' 오류 158건.",
  })
  @IsOptional() @IsString() @Length(0, 5)
  checkStatus?: string;

  @ApiPropertyOptional({ description: '스캔 바코드 (앞부분 일치). 이 표의 유일한 인덱스 컬럼이다.' })
  @IsOptional() @IsString() @Length(0, 60)
  scanPartName?: string;
}

// ───────────────────────────────── 244 솔더입출고관리 · 245 솔더라인투입이력

/**
 * 솔더 페이스트 종류. 실측 분포 'F' 35,629건 · 'P' 131건.
 * PB 는 드롭다운으로 골랐고 코드표가 따로 없다.
 */
export const SOLDER_TYPES = ['F', 'P'] as const;

/**
 * 244 솔더 통 목록 조건.
 *
 * `runningOnly` 가 PB 의 Running/All 라디오다. 두 DataWindow 의 SQL 차이가
 * **딱 두 조건**이다 (실측): 켜면 `ISSUE_DATE IS NOT NULL AND DESTROY_DATE IS NULL`
 * — 냉장고에서 꺼냈고 아직 버리지 않은 통, 즉 **지금 쓰이고 있는 것**이다.
 */
export class SolderListQueryDto {
  @ApiProperty({ description: '입고일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '입고일 종료 (YYYY-MM-DD, 이 날짜 포함)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({
    description: '지금 쓰이는 통만 볼지 (PB Running 라디오).'
      + ' 켜면 꺼냈고 아직 버리지 않은 것만 나온다.',
    default: false,
  })
  @IsOptional()
  @Transform(({ value }) => value === true || value === 'true')
  @IsBoolean()
  runningOnly?: boolean;

  @ApiPropertyOptional({ description: '솔더 롯트번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  solderLotNo?: string;

  @ApiPropertyOptional({ description: '솔더 바코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  itemBarcode?: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  lineCode?: string;

  @ApiPropertyOptional({ description: "솔더 종류 (앞부분 일치). 'F'·'P'" })
  @IsOptional() @IsString() @Length(0, 5)
  solderType?: string;

  @ApiPropertyOptional({
    description: '설비(공장)코드 (앞부분 일치). PB 의 Factory 드롭다운이다 —'
      + ' 이 표의 MACHINE_CODE 가 공장을 가르는 값으로 쓰인다.',
  })
  @IsOptional() @IsString() @Length(0, 30)
  machineCode?: string;
}

/** 244 단계별 대기 수량 집계 조건. */
export class SolderStageCountQueryDto {
  @ApiPropertyOptional({ description: '설비(공장)코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  machineCode?: string;
}

/**
 * 244 입고·출고 (**쓰기**).
 *
 * PB `wf_insert(arg_solder_lot_no, arg_type)` 를 그대로 옮긴다.
 *   'R' 입고 — 자재 바코드 표에서 품목코드를 찾아 새 통을 등록한다
 *   'I' 출고 — 그 통의 ISSUE_DATE 를 지금으로 적는다 (냉장고에서 꺼냄)
 */
export class SolderScanDto {
  @ApiProperty({ description: '솔더 롯트번호 (스캔한 값)' })
  @IsString() @Length(1, 60)
  solderLotNo!: string;

  @ApiProperty({
    description: "'R' 입고 (냉장고에 넣음) · 'I' 출고 (냉장고에서 꺼냄)",
    enum: ['R', 'I'],
  })
  @IsIn(['R', 'I'])
  scanType!: 'R' | 'I';
}

/** 245 솔더 라인투입 이력 조건. */
export class SolderInputHistoryQueryDto {
  @ApiProperty({ description: '투입일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '투입일 종료 (YYYY-MM-DD, 이 날짜 포함)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '솔더 롯트번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  solderLotNo?: string;

  @ApiPropertyOptional({ description: '설비코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  machineCode?: string;
}

// ───────────────────────────────── 235 자재입고전표관리

/** 235 입고전표 목록 조건. */
export class ReceiptSlipQueryDto {
  @ApiProperty({ description: '전표일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '전표일 종료 (YYYY-MM-DD, 이 날짜 포함)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '전표번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  slipNo?: string;

  @ApiPropertyOptional({
    description: "입고유형 (앞부분 일치). 실측 전표는 'N' 하나뿐이다"
      + " (PB 는 'B'·'T' 를 고정으로 제외한다).",
  })
  @IsOptional() @IsString() @Length(0, 10)
  receiptType?: string;

  @ApiPropertyOptional({ description: '전표상태 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  receiptStatus?: string;
}

/** 235 고른 전표의 바코드 목록 조건 (목록이 돌려준 값을 그대로 받는다 — 등호). */
export class ReceiptSlipBarcodeQueryDto {
  @ApiProperty({ description: '전표번호' })
  @IsString() @Length(1, 60)
  slipNo!: string;

  @ApiProperty({ description: '품목코드' })
  @IsString() @Length(1, 50)
  itemCode!: string;
}

/**
 * 235 바코드 발행 (**쓰기**).
 *
 * 분할은 두 갈래다 (PB `cbx_manual_slip`):
 *   수동 — `divideQty` 에 장별 수량을 적는다. 장수 = 적은 개수
 *   균등 — `reelQty` 장을 만들고 모두 `unitQty` 를 넣는다
 * 규칙과 판정은 `@smt/shared` 의 `checkReelPlan`·`planReelBarcodes` 가 갖고 있고
 * 단위테스트로 못 박혀 있다 — 화면과 서버가 같은 함수를 쓴다.
 */
export class ReceiptSlipIssueDto {
  @ApiProperty({ description: '전표번호' })
  @IsString() @Length(1, 60)
  slipNo!: string;

  @ApiProperty({ description: '품목코드' })
  @IsString() @Length(1, 50)
  itemCode!: string;

  @ApiPropertyOptional({ description: '릴 장수 (균등 분할). divideQty 가 없으면 필수' })
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(1000)
  reelQty?: number;

  @ApiPropertyOptional({
    description: '한 장 수량 (균등 분할). PB 는 이 값이 비면 발행을 거절한다.',
  })
  @IsOptional() @Type(() => Number) @IsNumber() @Min(1)
  unitQty?: number;

  @ApiPropertyOptional({
    description: '장별 수량 목록 (수동 분할). 있으면 이 값이 우선한다.',
    type: [Number],
  })
  @IsOptional() @IsArray() @Type(() => Number) @IsNumber({}, { each: true })
  divideQty?: number[];

  @ApiPropertyOptional({ description: '구매유형 (LINE_TYPE). F 무상구매 · G 국내구매 등' })
  @IsOptional() @IsString() @Length(0, 10)
  lineType?: string;

  @ApiPropertyOptional({ description: '협력사 바코드 (ORIGIN_MFS 로 들어간다)' })
  @IsOptional() @IsString() @Length(0, 60)
  supplierBarcode?: string;

  @ApiPropertyOptional({ description: '협력사 롯트번호 (MFS 로 들어간다)' })
  @IsOptional() @IsString() @Length(0, 60)
  supplierLotNo?: string;

  @ApiPropertyOptional({ description: '원 협력사코드' })
  @IsOptional() @IsString() @Length(0, 30)
  originSupplierCode?: string;

  @ApiPropertyOptional({ description: '출하 협력사코드' })
  @IsOptional() @IsString() @Length(0, 30)
  fromSupplierCode?: string;

  @ApiPropertyOptional({ description: '제조주차' })
  @IsOptional() @IsString() @Length(0, 20)
  manufactureWeek?: string;

  @ApiPropertyOptional({ description: '재고유형' })
  @IsOptional() @IsString() @Length(0, 10)
  inventoryType?: string;

  @ApiPropertyOptional({ description: 'PCB 코팅일 (YYYY-MM-DD)' })
  @IsOptional() @IsString() @Matches(DATE_ONLY)
  coatingDate?: string;

  @ApiPropertyOptional({ description: '제조일 (YYYY-MM-DD)' })
  @IsOptional() @IsString() @Matches(DATE_ONLY)
  manufactureDate?: string;
}

// ══════════════════════════════════ 237 자재바코드입고관리

/**
 * 237 대조 대기 / 바코드 이력 목록 조건.
 *
 * PB 는 이 두 목록을 별도 DataWindow 로 두었지만 조건이 거의 같다
 * (`d_mat_rceipt_barcode_4_receipt_wait_lst` · `d_mat_receipt_barcode_all_lst`).
 * 대기 목록만 `receiptCompareYn` 갈래와 PB 고정조건 3개가 더 붙는다.
 */
export class BarcodeCompareQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '자재 바코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  barcode?: string;

  @ApiPropertyOptional({ description: '롯트번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  lotNo?: string;

  @ApiPropertyOptional({ description: '전표번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  slipNo?: string;

  @ApiPropertyOptional({
    description: "입고대조 여부. 'N' 대조 대기 · 'Y' 대조 완료."
      + ' 비우면 둘 다 본다 (PB 공통코드 RECEIPT COMPARE YN).',
  })
  @IsOptional() @IsString() @Length(0, 1)
  receiptCompareYn?: string;
}

/** 237 입고 이력 목록 조건 (IM_ITEM_RECEIPT — 기간이 필수다). */
export class BarcodeReceiptHistoryQueryDto {
  @ApiProperty({ description: '입고일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '입고일 종료 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '전표번호 = INVOICE_NO (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  slipNo?: string;

  @ApiPropertyOptional({ description: '자재 롯트번호 = MATERIAL_MFS (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  lotNo?: string;
}

/**
 * 237 스캔한 자사 바코드를 풀어 본다 (읽기 전용).
 *
 * **왜 별도 단계가 있나.** PB 는 바코드를 입력하는 순간 DB 함수 세 개로 품목·롯트·
 * 수량을 뽑고, 품목 기준정보를 읽어 **협력사 롯트를 요구할지** 정한다
 * (`ID_ITEM.RECEIPT_LOT_CHECK_YN`). 화면이 그 판정을 알아야 입력칸을 열 수 있다.
 */
export class BarcodeScanLookupDto {
  @ApiProperty({ description: '자사(자재) 바코드' })
  @IsString() @Length(1, 100)
  barcode!: string;

  @ApiPropertyOptional({
    description: '협력사 바코드. 넣으면 협력사 품목코드까지 같이 풀어 대조한다.',
  })
  @IsOptional() @IsString() @Length(0, 100)
  supplierBarcode?: string;

}

/**
 * 237 입고대조 + 입고 기록 (**쓰기**).
 *
 * PB `wf_receipt_barcode('N')` 한 번에 대응한다.
 */
export class BarcodeCompareReceiveDto {
  @ApiProperty({ description: '협력사 바코드 (ORIGIN_MFS 로 들어간다)' })
  @IsString() @Length(1, 100)
  supplierBarcode!: string;

  @ApiProperty({ description: '자사 바코드' })
  @IsString() @Length(1, 100)
  barcode!: string;

  @ApiPropertyOptional({
    description: '협력사 롯트번호 (MFS · VENDOR_LOTNO 로 들어간다).'
      + ' 품목의 RECEIPT_LOT_CHECK_YN 이 Y 면 필수다.',
  })
  @IsOptional() @IsString() @Length(0, 60)
  supplierLotNo?: string;

  @ApiPropertyOptional({ description: '원 협력사코드 (ORIGIN_SUPPLIER_CODE · VENDOR_CODE)' })
  @IsOptional() @IsString() @Length(0, 30)
  originSupplierCode?: string;

  @ApiPropertyOptional({
    description: '협력사 바코드와 자사 바코드가 같아도 통과시킨다'
      + ' (PB cbx_ignore_sup_bcd 체크박스).',
  })
  @IsOptional() @Transform(({ value }) => value === true || value === 'true')
  @IsBoolean()
  ignoreSupplierBarcode?: boolean;
}

// ══════════════════════════════════ 243 솔더라벨 발행

/** 243 솔더 전표 목록 조건. */
export class SolderLabelSlipQueryDto {
  @ApiProperty({ description: '전표일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '전표일 종료 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '전표번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  slipNo?: string;
}

/** 243 전표로 발행된 라벨 목록 조건. */
export class SolderLabelBarcodeQueryDto {
  @ApiProperty({ description: '전표번호' })
  @IsString() @Length(1, 60)
  slipNo!: string;

  @ApiProperty({ description: '품목코드' })
  @IsString() @Length(1, 50)
  itemCode!: string;
}

/**
 * 243 솔더 라벨 발행 (**쓰기**).
 *
 * 장수·수량 규칙은 235 와 같다 (`divideQty` 가 있으면 수동, 없으면 릴 장수 × 단위수량).
 * 바코드 형식만 다르다 — `@smt/shared` 의 `solder-label.ts` 참고.
 */
export class SolderLabelIssueDto {
  @ApiProperty({ description: '품목코드 (ID_ITEM.ITEM_CLASS = SOLDER 여야 한다)' })
  @IsString() @Length(1, 50)
  itemCode!: string;

  @ApiProperty({
    description: "공장코드. 바코드 마지막 1자로 들어간다 (PB ddlb_factory: 'A'·'B').",
    enum: SOLDER_FACTORIES,
  })
  @IsIn(SOLDER_FACTORIES as unknown as string[])
  factory!: string;

  @ApiPropertyOptional({ description: '릴 장수 (균등 분할). divideQty 가 없으면 필수' })
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(1000)
  reelQty?: number;

  @ApiPropertyOptional({ description: '한 통 수량 (균등 분할)' })
  @IsOptional() @Type(() => Number) @IsNumber() @Min(1)
  unitQty?: number;

  @ApiPropertyOptional({
    description: '장별 수량 목록 (수동 분할). 있으면 이 값이 우선한다.',
    type: [Number],
  })
  @IsOptional() @IsArray() @Type(() => Number) @IsNumber({}, { each: true })
  divideQty?: number[];

  @ApiPropertyOptional({
    description: '총수량. 넣으면 라벨 수량 합과 같은지 확인한다 —'
      + ' PB 는 따로 적게 하고 맞는지 보지 않았다.',
  })
  @IsOptional() @Type(() => Number) @IsNumber() @Min(0)
  totalQty?: number;

  @ApiPropertyOptional({ description: '유효기한 (YYYY-MM-DD)' })
  @IsOptional() @IsString() @Matches(DATE_ONLY)
  validDate?: string;

  @ApiPropertyOptional({ description: '협력사코드' })
  @IsOptional() @IsString() @Length(0, 30)
  supplierCode?: string;

  @ApiPropertyOptional({ description: '협력사 바코드 (전표의 RECEIPT_BARCODE 로 들어간다)' })
  @IsOptional() @IsString() @Length(0, 100)
  supplierBarcode?: string;
}
