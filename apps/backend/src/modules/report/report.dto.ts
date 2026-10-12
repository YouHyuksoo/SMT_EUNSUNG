/**
 * @file src/modules/report/report.dto.ts
 * @description 리포트(M_REPORT) DTO — 기준정보·바코드·설비·제품·공정 10화면
 *
 * 리포트는 대부분 조회 전용이지만 두 군데가 다르다:
 *   341 캐리어바코드는 **바코드를 발행(INSERT)하는 화면**이다. 리포트 메뉴 아래
 *       있지만 리포트가 아니다 — 라벨 레이아웃만 보고 '인쇄물' 로 분류하면
 *       쓰기 화면이 조용히 빠진다.
 *   340 라인설비바코드의 `DW_1.UPDATE()` 는 무동작이다 (갱신 대상 테이블이 없고
 *       update=yes 컬럼도 line_code 하나뿐이다 — 실측). 조회 전용으로 옮겼다.
 *
 * **기간 조건이 리포트의 유일한 방어선이다.** 추적·조회와 달리 리포트에는 키가
 * 없다 (GROUP BY 집계다). 그래서 구동 원장의 날짜 인덱스를 타도록 기간을 필수로
 * 받는다 — 실측 인덱스:
 *     IQ_MACHINE_INSPECT_PICKUP_QRY  97만행 · ACTUAL_DATE
 *     IP_PRODUCT_FG_ISSUE            57만행 · ISSUE_DATE
 *     IP_PRODUCT_RUN_CARD            3.9만행 · RUN_DATE
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
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

// ───────────────────────────────── 338 품목마스터리포트

export class ItemMasterReportQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '품목명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  itemName?: string;

  @ApiPropertyOptional({ description: '품목분류 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  itemClass?: string;

  @ApiPropertyOptional({ description: '품목유형 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  itemType?: string;

  @ApiPropertyOptional({ description: '라인유형 (구매유형). F 무상구매 · G 국내구매 등' })
  @IsOptional() @IsString() @Length(0, 10)
  lineType?: string;

  @ApiPropertyOptional({
    description: "유효기간 상태. 'RUNNING' 적용중 · 'FUTURE' 적용전 · 'EXPIRED' 만료."
      + ' ID_ITEM 에 STATUS 컬럼은 없다 — 적용시작·종료일로 계산하는 값이다 (PB 와 같은 식).',
    enum: ['RUNNING', 'FUTURE', 'EXPIRED'],
  })
  @IsOptional() @IsIn(['RUNNING', 'FUTURE', 'EXPIRED'])
  status?: string;
}

// ───────────────────────────────── 340 라인설비바코드

export class LineBarcodeQueryDto {
  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  lineCode?: string;

  @ApiPropertyOptional({ description: '설비 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  machine?: string;
}

// ───────────────────────────────── 341 캐리어바코드 (발행)

export class CarrierBarcodeQueryDto {
  @ApiPropertyOptional({ description: '바코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  barcode?: string;
}

/**
 * 캐리어 바코드 발행 (**쓰기** — PB '2D Barcode Create').
 *
 * PB 는 시작번호부터 끝번호까지 한 건씩 INSERT 를 돌렸다 (진행바를 띄우고).
 * 형식은 `접두어 + 3자리 0채움 순번 + 접미어` 다.
 *
 * **PB 는 1000번부터 깨진다.** `TO_CHAR(1000,'000')` 은 '###' 을 돌려준다.
 * 여기서는 LPAD 로 만들어 3자리 미만은 0을 채우고 그 이상은 자연히 늘어난다
 * (1~999 구간은 PB 와 완전히 같다).
 */
export class CarrierBarcodeCreateDto {
  @ApiProperty({ description: '바코드 접두어' })
  @IsString() @Length(1, 30)
  prefix!: string;

  @ApiPropertyOptional({ description: '바코드 접미어' })
  @IsOptional() @IsString() @Length(0, 20)
  suffix?: string;

  @ApiProperty({ description: '시작 순번', minimum: 1 })
  @Type(() => Number) @IsInt() @Min(1)
  startSerial!: number;

  @ApiProperty({ description: '끝 순번 (이 번호까지 포함)', minimum: 1 })
  @Type(() => Number) @IsInt() @Min(1)
  endSerial!: number;
}

export class CarrierBarcodeDeleteDto {
  @ApiProperty({ description: '지울 바코드 (앞부분 일치). 발행 실수를 되돌릴 때 쓴다.' })
  @IsString() @Length(1, 60)
  barcode!: string;
}

// ───────────────────────────────── 343 설비리포트

export class MachineReportQueryDto {
  @ApiPropertyOptional({ description: '설비코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  machineCode?: string;

  @ApiPropertyOptional({ description: '설비유형 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  machineType?: string;
}

export class MachineOperationQueryDto extends MachineReportQueryDto {
  @ApiProperty({ description: '가동일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '가동일 종료 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;
}

// ───────────────────────────────── 344 SMT PICKUP 리포트

export class PickupRateQueryDto {
  @ApiProperty({ description: '실적일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '실적일 종료 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  lineCode?: string;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({
    description: '이 단가 이상만. PB 는 비싼 자재의 미스만 보려고 이 조건을 뒀다.',
    default: 0,
  })
  @IsOptional() @Type(() => Number) @IsNumber() @Min(0)
  minUnitPrice?: number;
}

// ───────────────────────────────── 346 생산계획리포트

export class MasterPlanReportQueryDto {
  @ApiProperty({ description: '계획일 (YYYY-MM-DD). PB 는 하루를 등호로 걸었다.' })
  @IsString() @Matches(DATE_ONLY)
  planDate!: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  modelName?: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  lineCode?: string;

  @ApiPropertyOptional({ description: '고객코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  customerCode?: string;
}

// ───────────────────────────────── 347 런카드리포트

export class RunCardReportQueryDto {
  @ApiProperty({ description: '지시일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '지시일 종료 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  modelName?: string;

  @ApiPropertyOptional({ description: 'Run No (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  runNo?: string;

  @ApiPropertyOptional({ description: '마킹번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  markingNo?: string;

  @ApiPropertyOptional({ description: '롯트번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  lotNo?: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  lineCode?: string;

  @ApiPropertyOptional({ description: '진행상태 (앞부분 일치). 1 대기 ~ 10 출하' })
  @IsOptional() @IsString() @Length(0, 5)
  runStatus?: string;

  /**
   * 합계에 라벨·투입·산출 수량을 포함할지 (기본 false).
   *
   * 그 셋은 PB 와 같은 DB 함수가 센다. **함수 하나가 런카드마다 1억행 넘는 표를
   * 한 번씩 센다** — 실측 함수 본문:
   *     라벨 COUNT(*)          IP_PRODUCT_2D_BARCODE      1.8억행 (RUN_NO 인덱스)
   *     투입 COUNT(DISTINCT PID) IQ_MACHINE_INSPECT_DATA_MK 1억행 (PID IN 서브쿼리)
   *     산출 COUNT(*)          IQ_MACHINE_INSPECT_DATA_AOI 1.75억행 (RUN_NO 인덱스)
   * 25일치 523건에서 **47초**가 걸렸다 (실측). 함수를 TypeScript 로 다시 쓰면 PB 와
   * 숫자가 갈리므로 바꾸지 않고, 대신 **필요할 때만 켜게** 했다.
   * 끄면 건수·롯트수량만 집계해 즉시 나온다.
   */
  @ApiPropertyOptional({
    description: '라벨·투입·산출 수량 포함 여부. 켜면 런카드마다 1억행 표를 세 번 세므로'
      + ' 느리다 (25일치 523건 = 47초 실측). 기본은 끔.',
    default: false,
  })
  @IsOptional()
  @Transform(({ value }) => value === true || value === 'true')
  @IsBoolean()
  withQty?: boolean;
}

// ───────────────────────────────── 348 제품 판매실적

export class FgIssueReportQueryDto {
  @ApiProperty({ description: '출하일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '출하일 종료 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  modelName?: string;

  @ApiPropertyOptional({ description: '제품 바코드 (앞부분 일치). 상세에만 쓴다.' })
  @IsOptional() @IsString() @Length(0, 60)
  barcode?: string;
}

// ───────────────────────────────── 350 공정재공조회 · 352 공정매거진조회

export class WorkstageStockQueryDto {
  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  modelName?: string;

  @ApiPropertyOptional({ description: '모델 SFX (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  modelSuffix?: string;

  @ApiPropertyOptional({ description: '공정코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  workstageCode?: string;

  @ApiPropertyOptional({
    description: '재공수량 부호. 0 이면 0 이상(기본), -1 이면 음수까지 전부.'
      + ' PB SIGN(qty) >= :arg_sign 을 그대로 옮긴 것이다.',
    default: 0,
  })
  @IsOptional() @Type(() => Number) @IsInt() @Min(-1) @Max(1)
  sign?: number;
}

/**
 * 352 공정매거진조회 — 세 갈래를 한 화면에서 본다.
 *
 * 'workstage' 는 재공 스냅샷(IP_PRODUCT_RUN_CARD_INV)이라 날짜가 없다.
 * 'defect'·'destroy' 는 입출고 원장(IP_PRODUCT_RUN_CARD_IO)을 기간으로 집계하므로
 * **그 두 갈래에는 기간이 필수다** — 구동 조건이 RECEIPT_DATE 뿐이다.
 */
export class MagazineStockQueryDto extends WorkstageStockQueryDto {
  @ApiPropertyOptional({
    description: "볼 갈래. 'workstage' 공정재공(스냅샷) · 'defect' 불량 · 'destroy' 폐기",
    enum: ['workstage', 'defect', 'destroy'],
    default: 'workstage',
  })
  @IsOptional() @IsIn(['workstage', 'defect', 'destroy'])
  kind?: 'workstage' | 'defect' | 'destroy';

  @ApiPropertyOptional({ description: "입출고일 시작 (YYYY-MM-DD). 'defect'·'destroy' 에 필수" })
  @IsOptional() @IsString() @Matches(DATE_ONLY)
  dateFrom?: string;

  @ApiPropertyOptional({ description: "입출고일 종료 (YYYY-MM-DD). 'defect'·'destroy' 에 필수" })
  @IsOptional() @IsString() @Matches(DATE_ONLY)
  dateTo?: string;
}
