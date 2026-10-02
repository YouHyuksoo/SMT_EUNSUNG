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
  @IsIn([...CHAMBER_TYPES])
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
  @IsIn([...CHAMBER_TYPES])
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
  @IsIn([...SOLDER_FACTORIES])
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

// ══════════════════════════════════ 253 자재입고관리 · 254 자재기타입고관리

/** 253·254 입고 이력 조회 조건 (PB `d_mat_receipt_hst` 인자 그대로). */
export class ReceiptHistoryQueryDto {
  @ApiProperty({ description: '입고일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '입고일 종료 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '자재 롯트 = MATERIAL_MFS (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  materialMfs?: string;

  @ApiPropertyOptional({ description: '협력사코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  supplierCode?: string;

  @ApiPropertyOptional({ description: '창고코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  locationCode?: string;

  @ApiPropertyOptional({ description: '전표번호 = INVOICE_NO (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  invoiceNo?: string;

  @ApiPropertyOptional({
    description: "입고유형. 'E' 기타입고 · 'N' 일반입고. 비우면 전체.",
  })
  @IsOptional() @IsString() @Length(0, 5)
  receiptType?: string;
}

/** 254 현재고 목록 조건. */
export class ReceiptInventoryQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '자재 롯트 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  materialMfs?: string;

  @ApiPropertyOptional({ description: '창고코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  locationCode?: string;

  @ApiPropertyOptional({
    description: '재고가 0 이하인 것도 함께 본다 (PB 라디오버튼 "전체").'
      + ' **기본은 재고 있는 것만이다** — 전체는 1,837,572행이라 상한에서 잘린'
      + ' 임의의 10,000행이 되고 실측 7.6초가 걸린다 (재고 있는 것은 3,446행 / 1.2초).',
  })
  @IsOptional() @Transform(({ value }) => value === true || value === 'true')
  @IsBoolean()
  includeZero?: boolean;
}

/** 254 기타입고 한 건을 가리키는 키 (실측 XPKIM_ITEM_RECEIPT 3개 열). */
export class EtcReceiptKeyDto {
  @ApiProperty({ description: '입고일 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  receiptDate!: string;

  @ApiProperty({ description: '입고순번' })
  @Type(() => Number) @IsInt()
  receiptSequence!: number;
}

/** 254 기타입고 등록 (**쓰기**). */
export class EtcReceiptCreateDto {
  @ApiProperty({ description: '품목코드' })
  @IsString() @Length(1, 50)
  itemCode!: string;

  @ApiProperty({
    description: '수량. **음수면 차감이다** — PB 가 수량 부호로 RECEIPT_DEFICIT 을'
      + " 정한다 (실측 유형 'E' 1,829건이 정확히 그 규칙을 따른다).",
  })
  @Type(() => Number) @IsNumber()
  receiptQty!: number;

  @ApiPropertyOptional({ description: '구매유형. 비우면 품목 기준정보에서 가져온다.' })
  @IsOptional() @IsString() @Length(0, 10)
  lineType?: string;

  @ApiPropertyOptional({ description: '협력사코드' })
  @IsOptional() @IsString() @Length(0, 30)
  supplierCode?: string;

  @ApiPropertyOptional({ description: '창고코드' })
  @IsOptional() @IsString() @Length(0, 20)
  locationCode?: string;

  @ApiPropertyOptional({ description: '자재 롯트 (MATERIAL_MFS). 비우면 *' })
  @IsOptional() @IsString() @Length(0, 60)
  materialMfs?: string;

  @ApiPropertyOptional({ description: '단가. 비우면 0' })
  @IsOptional() @Type(() => Number) @IsNumber()
  unitPrice?: number;

  @ApiPropertyOptional({ description: '통화. 비우면 ISYS_CONFIG.CURRENCY (실측 KRW)' })
  @IsOptional() @IsString() @Length(0, 10)
  currency?: string;

  @ApiPropertyOptional({ description: '전표번호. 비우면 YYYYMMDD + 입고순번' })
  @IsOptional() @IsString() @Length(0, 60)
  invoiceNo?: string;

  @ApiPropertyOptional({ description: '입고 롯트번호. 비우면 F_GET_ANY_NO 채번' })
  @IsOptional() @IsString() @Length(0, 60)
  receiptLotNo?: string;

  @ApiPropertyOptional({ description: '비고' })
  @IsOptional() @IsString() @Length(0, 200)
  comments?: string;
}

/**
 * 254 기타입고 수정 (**쓰기**).
 *
 * 여기 있는 항목만 바꿀 수 있다 — 서비스의 화이트리스트와 짝이다.
 * **수량은 없다.** PB DataWindow 도 수량을 편집 대상으로 두지 않는다 (실측).
 */
export class EtcReceiptUpdateDto extends EtcReceiptKeyDto {
  @ApiPropertyOptional({ description: '품목코드' })
  @IsOptional() @IsString() @Length(1, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '구매유형' })
  @IsOptional() @IsString() @Length(0, 10)
  lineType?: string;

  @ApiPropertyOptional({ description: '창고코드' })
  @IsOptional() @IsString() @Length(0, 20)
  locationCode?: string;

  @ApiPropertyOptional({ description: '자재 롯트 (MATERIAL_MFS)' })
  @IsOptional() @IsString() @Length(0, 60)
  materialMfs?: string;

  @ApiPropertyOptional({ description: '협력사 롯트 (MFS)' })
  @IsOptional() @IsString() @Length(0, 60)
  mfs?: string;

  @ApiPropertyOptional({ description: '전표번호' })
  @IsOptional() @IsString() @Length(0, 60)
  invoiceNo?: string;

  @ApiPropertyOptional({ description: '입고 롯트번호' })
  @IsOptional() @IsString() @Length(0, 60)
  receiptLotNo?: string;

  @ApiPropertyOptional({ description: '단가. 바꾸면 입고금액도 함께 다시 계산한다.' })
  @IsOptional() @Type(() => Number) @IsNumber()
  unitPrice?: number;

  @ApiPropertyOptional({ description: '통화' })
  @IsOptional() @IsString() @Length(0, 10)
  currency?: string;

  @ApiPropertyOptional({ description: '환율' })
  @IsOptional() @Type(() => Number) @IsNumber()
  exchangeRate?: number;

  @ApiPropertyOptional({ description: '발주번호' })
  @IsOptional() @IsString() @Length(0, 60)
  orderNo?: string;

  @ApiPropertyOptional({ description: '발주유형' })
  @IsOptional() @IsString() @Length(0, 10)
  orderType?: string;

  @ApiPropertyOptional({ description: '원 협력사코드' })
  @IsOptional() @IsString() @Length(0, 30)
  originSupplierCode?: string;

  @ApiPropertyOptional({ description: '부대비용코드' })
  @IsOptional() @IsString() @Length(0, 20)
  incidentalExpenseCode?: string;

  @ApiPropertyOptional({ description: '관세율' })
  @IsOptional() @Type(() => Number) @IsNumber()
  tariffRate?: number;

  @ApiPropertyOptional({ description: '관세액' })
  @IsOptional() @Type(() => Number) @IsNumber()
  tariffAmt?: number;

  @ApiPropertyOptional({ description: '비고' })
  @IsOptional() @IsString() @Length(0, 200)
  comments?: string;
}

// ══════════════════════════════════ 257 자재기타출고 · 258 자재출고취소

/** 257·258 출고 이력 조회 조건 (PB `d_mat_issue_lst` 인자 그대로). */
export class IssueHistoryQueryDto {
  @ApiProperty({ description: '출고일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '출고일 종료 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '협력사 롯트 = MFS (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  mfs?: string;

  @ApiPropertyOptional({ description: '자재 롯트 = MATERIAL_MFS (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  materialMfs?: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  lineCode?: string;

  @ApiPropertyOptional({ description: '공정코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  workstageCode?: string;

  @ApiPropertyOptional({ description: '전표번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  invoiceNo?: string;

  @ApiPropertyOptional({
    description: "출고상태. 'N' 정상 · 'C' 취소. 비우면 전체.",
  })
  @IsOptional() @IsString() @Length(0, 5)
  issueStatus?: string;
}

/** 257 현재고 목록 조건 (254 입고 쪽과 같은 표·같은 조건식). */
export class IssueInventoryQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '자재 롯트 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  materialMfs?: string;

  @ApiPropertyOptional({ description: '창고코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  locationCode?: string;

  @ApiPropertyOptional({
    description: '재고가 0 이하인 것도 함께 본다. **기본은 재고 있는 것만이다** —'
      + ' 전체는 1,837,572행이라 상한에서 잘린 임의의 10,000행이 된다.',
  })
  @IsOptional() @Transform(({ value }) => value === true || value === 'true')
  @IsBoolean()
  includeZero?: boolean;
}

/**
 * 257 기타출고 등록 (**쓰기**).
 *
 * PB 가 요구하던 대로 **라인·공정·설비는 반드시 있어야 한다** — 하나라도 비면
 * 어디로 나갔는지 모르는 출고가 생긴다.
 */
export class EtcIssueCreateDto {
  @ApiProperty({ description: '출고일 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  issueDate!: string;

  @ApiProperty({ description: '품목코드' })
  @IsString() @Length(1, 50)
  itemCode!: string;

  @ApiProperty({
    description: '수량. **음수면 반납이다** — PB 가 수량 부호로 ISSUE_DEFICIT 을'
      + ' 정한다 (3 출고 · 4 반납).',
  })
  @Type(() => Number) @IsNumber()
  issueQty!: number;

  @ApiProperty({ description: '라인코드 (필수)' })
  @IsString() @Length(1, 20)
  lineCode!: string;

  @ApiProperty({ description: '공정코드 (필수)' })
  @IsString() @Length(1, 20)
  workstageCode!: string;

  @ApiProperty({ description: '설비코드 (필수)' })
  @IsString() @Length(1, 20)
  machineCode!: string;

  @ApiPropertyOptional({
    description: '포장 단위로 올려서 출고한다 (PB 체크박스).'
      + ' **음수 수량과 같이 쓸 수 없다** — PB 가 양수를 내놓아 반납이 출고로 뒤집힌다.',
  })
  @IsOptional() @Transform(({ value }) => value === true || value === 'true')
  @IsBoolean()
  applyPackingQty?: boolean;

  @ApiPropertyOptional({ description: '창고코드' })
  @IsOptional() @IsString() @Length(0, 20)
  locationCode?: string;

  @ApiPropertyOptional({ description: '자재 롯트 (MATERIAL_MFS)' })
  @IsOptional() @IsString() @Length(0, 60)
  materialMfs?: string;

  @ApiPropertyOptional({ description: '구매유형. 비우면 품목 기준정보에서 가져온다.' })
  @IsOptional() @IsString() @Length(0, 10)
  lineType?: string;

  @ApiPropertyOptional({ description: '협력사코드' })
  @IsOptional() @IsString() @Length(0, 30)
  supplierCode?: string;

  @ApiPropertyOptional({ description: '재고유형' })
  @IsOptional() @IsString() @Length(0, 10)
  inventoryType?: string;

  @ApiPropertyOptional({ description: '출고단가. 비우면 0' })
  @IsOptional() @Type(() => Number) @IsNumber()
  issuePrice?: number;

  @ApiPropertyOptional({ description: '출고계정 (공통코드)' })
  @IsOptional() @IsString() @Length(0, 20)
  issueAccount?: string;

  @ApiPropertyOptional({ description: '전표번호. 비우면 시퀀스로 채번한다.' })
  @IsOptional() @IsString() @Length(0, 60)
  invoiceNo?: string;

  @ApiPropertyOptional({ description: '비고' })
  @IsOptional() @IsString() @Length(0, 200)
  comments?: string;
}

/** 258 출고취소 (**쓰기**). 원장을 지우지 않고 부호를 뒤집은 행을 넣는다. */
export class IssueCancelDto {
  @ApiProperty({ description: '취소할 출고의 출고일 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  issueDate!: string;

  @ApiProperty({ description: '취소할 출고의 순번' })
  @Type(() => Number) @IsInt()
  issueSequence!: number;

  @ApiProperty({
    description: '취소일 (YYYY-MM-DD). 취소 행의 출고일이 된다 — PB 가 이 값을 쓴다.',
  })
  @IsString() @Matches(DATE_ONLY)
  cancelDate!: string;
}

// ══════════════════════════════════ 250 출고바코드반품

/** 250 반품 이력 조회 조건. */
export class IssueReturnQueryDto {
  @ApiProperty({ description: '반품일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '반품일 종료 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '롯트번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  lotNo?: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  lineCode?: string;
}

/** 250 찍은 바코드를 풀어 본다 (읽기 전용). */
export class IssueReturnLookupDto {
  @ApiProperty({ description: '자재 바코드' })
  @IsString() @Length(1, 100)
  barcode!: string;
}

/**
 * 250 양산반품 (**쓰기**).
 *
 * **반품하면 바코드의 수량이 바뀐다** — 남은 수량으로 `품목-롯트-수량` 바코드를
 * 다시 만든다 (PB 그대로).
 */
export class IssueReturnDto {
  @ApiProperty({ description: '자재 바코드' })
  @IsString() @Length(1, 100)
  barcode!: string;

  @ApiProperty({ description: '반품 수량 (되돌려 받는 수량). 1 이상이어야 한다.' })
  @Type(() => Number) @IsNumber() @Min(1)
  returnQty!: number;

  @ApiPropertyOptional({
    description: '실사 수량. 반품 수량과의 차이가 로스로 기록된다'
      + ' (IM_ITEM_ISSUE_LOSS). 비우면 반품 수량과 같게 보아 로스 0 이다.',
  })
  @IsOptional() @Type(() => Number) @IsNumber() @Min(0)
  actualQty?: number;

  @ApiProperty({
    description: '라인코드. 화면이 마지막 출고 라인을 찾아 채워 준다'
      + ' (못 찾으면 직접 넣는다).',
  })
  @IsString() @Length(1, 20)
  lineCode!: string;

  @ApiPropertyOptional({ description: '창고코드' })
  @IsOptional() @IsString() @Length(0, 20)
  locationCode?: string;
}

// ══════════════════════════════════ 238 자재바코드출고관리

/** 238 출고 이력 조회 조건. */
export class BarcodeIssueHistoryQueryDto {
  @ApiProperty({ description: '출고일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '출고일 종료 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '롯트번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  lotNo?: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  lineCode?: string;

  @ApiPropertyOptional({ description: '공정코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  workstageCode?: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  modelName?: string;
}

/** 238 출고 대기 바코드 조회 조건. */
export class BarcodeIssueWaitingQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '자재 바코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  barcode?: string;

  @ApiPropertyOptional({ description: '롯트번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  lotNo?: string;
}

/** 238 키팅 BOM 조회 조건. */
export class KittingBomQueryDto {
  @ApiProperty({ description: '모델명' })
  @IsString() @Length(1, 50)
  modelName!: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  lineCode?: string;
}

/**
 * 238 스캔 판정 (읽기 전용).
 *
 * 켜고 끄는 검사의 기본값은 **PB 체크박스 기본값 그대로**다 —
 * FIFO·MSL 시간·PCB 코팅이 ON, 장기재고·수명주기가 OFF.
 */
export class BarcodeIssueScanDto {
  @ApiProperty({ description: '자재 바코드' })
  @IsString() @Length(1, 100)
  barcode!: string;

  @ApiProperty({ description: '라인코드 (필수 — PB 도 비면 거절한다)' })
  @IsString() @Length(1, 20)
  lineCode!: string;

  @ApiProperty({ description: '공정코드 (필수)' })
  @IsString() @Length(1, 20)
  workstageCode!: string;

  @ApiPropertyOptional({
    description: 'FIFO(선입선출) 검사. **PB 기본 ON.** 먼저 들어온 릴이 창고에 남아'
      + ' 있으면 거절한다. PB 에는 평문 비밀번호로 뚫는 장치가 있었지만 옮기지 않았다.',
    default: true,
  })
  @IsOptional() @Transform(({ value }) => value !== false && value !== 'false')
  @IsBoolean()
  checkFifo?: boolean;

  @ApiPropertyOptional({ description: 'MSL 허용시간 검사. **PB 기본 ON.**', default: true })
  @IsOptional() @Transform(({ value }) => value !== false && value !== 'false')
  @IsBoolean()
  checkMslTime?: boolean;

  @ApiPropertyOptional({ description: 'PCB 코팅일 검사. **PB 기본 ON.**', default: true })
  @IsOptional() @Transform(({ value }) => value !== false && value !== 'false')
  @IsBoolean()
  checkPcbCoating?: boolean;

  @ApiPropertyOptional({
    description: '장기재고 검사 (12개월 넘은 재고 거절). PB 기본 OFF.',
  })
  @IsOptional() @Transform(({ value }) => value === true || value === 'true')
  @IsBoolean()
  checkLongTermInventory?: boolean;

  @ApiPropertyOptional({ description: '수명주기 검사. PB 기본 OFF.' })
  @IsOptional() @Transform(({ value }) => value === true || value === 'true')
  @IsBoolean()
  checkLifeCycle?: boolean;
}

/** 238 출고대조 + 출고 기록 (**쓰기**). 판정 항목은 스캔과 같다. */
export class BarcodeIssueDto extends BarcodeIssueScanDto {
  @ApiPropertyOptional({ description: '모델명 (FEEDING_MODEL · MODEL_NAME 으로 들어간다)' })
  @IsOptional() @IsString() @Length(0, 50)
  modelName?: string;

  @ApiPropertyOptional({ description: '피더 위치 (바코드의 LOCATION_CODE 로도 들어간다)' })
  @IsOptional() @IsString() @Length(0, 30)
  feederLocationCode?: string;

  @ApiPropertyOptional({ description: '창고코드 (출고 원장의 LOCATION_CODE)' })
  @IsOptional() @IsString() @Length(0, 20)
  locationCode?: string;

  @ApiPropertyOptional({ description: '협력사 롯트 (MFS). 비우면 *' })
  @IsOptional() @IsString() @Length(0, 60)
  mfs?: string;

  @ApiPropertyOptional({ description: '협력사 바코드 (ORIGIN_MFS 로 들어간다)' })
  @IsOptional() @IsString() @Length(0, 100)
  supplierBarcode?: string;

  @ApiPropertyOptional({
    description: "키팅 모드. 켜면 출고구분이 'K' 로 들어간다 (PB rb_kitting).",
  })
  @IsOptional() @Transform(({ value }) => value === true || value === 'true')
  @IsBoolean()
  kitting?: boolean;

  @ApiPropertyOptional({ description: '출고구분 (키팅이 아닐 때 직접 넣는다)' })
  @IsOptional() @IsString() @Length(0, 10)
  issueDivision?: string;
}

// ══════════════════════════════════ 240 자재분할관리 · 261 베이킹이력관리

/** 240 분할 이력 조회 조건. */
export class BarcodeDivideQueryDto {
  @ApiProperty({ description: '분할일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '분할일 종료 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '롯트번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  lotNo?: string;

  @ApiPropertyOptional({ description: '원본 롯트번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  originLotNo?: string;
}

/**
 * 240 릴 분할 (**쓰기**).
 *
 * **조각 N개 중 앞 N-1개만 새 바코드가 되고 마지막 조각은 원본 바코드가 된다.**
 * 규칙은 `@smt/shared` 의 `planLotDivide` 에 있고 단위테스트로 못 박혀 있다.
 */
export class BarcodeDivideDto {
  @ApiProperty({ description: '나눌 릴의 자재 바코드' })
  @IsString() @Length(1, 100)
  barcode!: string;

  @ApiProperty({
    description: '조각 수량 목록. **2개 이상**이어야 하고 합이 릴 수량과 같아야 한다'
      + ' (PB 는 합을 검사하지 않아 재고가 늘거나 줄었다).',
    type: [Number],
  })
  @IsArray() @Type(() => Number) @IsNumber({}, { each: true })
  divideQty!: number[];

  @ApiPropertyOptional({
    description: "릴 분할이면 true (분할사유에 ' REEL' 이 붙는다). 기본은 롯트 분할.",
  })
  @IsOptional() @Transform(({ value }) => value === true || value === 'true')
  @IsBoolean()
  reel?: boolean;

  @ApiPropertyOptional({ description: '분할사유. 비우면 *' })
  @IsOptional() @IsString() @Length(0, 60)
  divideReason?: string;

  @ApiPropertyOptional({ description: '창고코드 (출고 원장의 LOCATION_CODE)' })
  @IsOptional() @IsString() @Length(0, 20)
  locationCode?: string;
}

/** 261 챔버 입출고 이력 조회 조건. */
export class BakingHistoryQueryDto {
  @ApiProperty({ description: '넣은 날 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '넣은 날 종료 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({
    description: "챔버 종류. 'B' 베이킹실 · 'V' 진공포장 · 'D' 제습함. 비우면 전체.",
    enum: CHAMBER_TYPES,
  })
  @IsOptional() @IsString() @Length(0, 1)
  chamberType?: string;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '롯트번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  lotNo?: string;

  @ApiPropertyOptional({ description: '챔버 번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  chamberCode?: string;
}

/**
 * 261 챔버에 넣기·꺼내기 (**쓰기**).
 *
 * **MSL 시계가 챔버 종류마다 다르게 움직인다** — 서비스 파일 머리 2번 참고.
 */
export class BakingScanDto {
  @ApiProperty({ description: '자재 바코드' })
  @IsString() @Length(1, 100)
  barcode!: string;

  @ApiProperty({
    description: "챔버 종류. 'B' 베이킹실 · 'V' 진공포장 · 'D' 제습함.",
    enum: CHAMBER_TYPES,
  })
  @IsIn([...CHAMBER_TYPES])
  chamberType!: string;

  @ApiProperty({ description: '챔버 번호' })
  @IsString() @Length(1, 20)
  chamberCode!: string;

  @ApiProperty({ description: "방향. 'IN' 넣기 · 'OUT' 꺼내기", enum: ['IN', 'OUT'] })
  @IsIn(['IN', 'OUT'])
  direction!: 'IN' | 'OUT';

  @ApiPropertyOptional({ description: '챔버 안 자리 (넣을 때만 쓴다)' })
  @IsOptional() @IsString() @Length(0, 30)
  chamberLocation?: string;
}

// ══════════════ 241 자재바코드재발행 · 260 MSL 이상품목 · 239 IMD 라인 자재투입

/** 241 재발행 대상 조회 조건. */
export class BarcodeReprintQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '전표번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  slipNo?: string;

  @ApiPropertyOptional({ description: '협력사 바코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  supplierBarcode?: string;

  @ApiPropertyOptional({ description: '자재 바코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  barcode?: string;

  @ApiPropertyOptional({ description: '롯트번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  lotNo?: string;
}

/**
 * 241 바코드 재발행 (**쓰기**).
 *
 * **원장은 건드리지 않는다.** 수량이 실제로 줄어 재고에 반영해야 하면 250
 * 출고바코드반품을 써야 한다.
 */
export class BarcodeReprintDto {
  @ApiProperty({ description: '다시 만들 자재 바코드' })
  @IsString() @Length(1, 100)
  barcode!: string;

  @ApiProperty({ description: '새 수량. 1 이상이어야 한다.' })
  @Type(() => Number) @IsNumber() @Min(1)
  newQty!: number;
}

/** 260 MSL 초과 조회 조건 (재고·투입 공용). */
export class MslOverQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({
    description: "MSL 등급 하한 (문자 비교). 기본 '2' — 실측 등급은 1·2·2A·3 이다.",
  })
  @IsOptional() @IsString() @Length(0, 5)
  mslLevel?: string;

  @ApiPropertyOptional({
    description: '경과율 하한 (%). 기본 100 — 허용시간을 이미 넘긴 것만 본다.',
  })
  @IsOptional() @Type(() => Number) @IsNumber() @Min(0)
  passedRate?: number;
}

/** 260 현황·처리이력 조회 조건. */
export class MslCheckQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '자재 바코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  barcode?: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  lineCode?: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  modelName?: string;
}

/** 260 MSL 처리이력 등록 (**쓰기**). */
export class MslCheckCreateDto {
  @ApiProperty({ description: '자재 바코드 (품목·롯트·수량은 원장에서 가져온다)' })
  @IsString() @Length(1, 100)
  barcode!: string;

  @ApiProperty({ description: '처리코드 (공통코드). 베이킹·폐기 등' })
  @IsString() @Length(1, 20)
  mslActionCode!: string;

  @ApiPropertyOptional({ description: '비고' })
  @IsOptional() @IsString() @Length(0, 200)
  comments?: string;
}

/** 239 수동 투입 이력 조회 조건. */
export class ManualInputQueryDto {
  @ApiProperty({ description: '투입일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '투입일 종료 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  lineCode?: string;

  @ApiPropertyOptional({ description: '공정코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  workstageCode?: string;

  @ApiPropertyOptional({ description: '런번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 40)
  runNo?: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  modelName?: string;
}

/** 239 수동 투입 등록 (**쓰기**). */
export class ManualInputCreateDto {
  @ApiProperty({ description: '투입일 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  inputDate!: string;

  @ApiProperty({ description: '라인코드' })
  @IsString() @Length(1, 20)
  lineCode!: string;

  @ApiProperty({ description: '공정코드' })
  @IsString() @Length(1, 20)
  workstageCode!: string;

  @ApiProperty({ description: '자재 롯트번호' })
  @IsString() @Length(1, 60)
  materialLot!: string;

  @ApiPropertyOptional({ description: '런번호 (작업지시). 넣으면 모델명이 붙는다.' })
  @IsOptional() @IsString() @Length(0, 40)
  runNo?: string;

  @ApiPropertyOptional({ description: '비고' })
  @IsOptional() @IsString() @Length(0, 200)
  comments?: string;
}
