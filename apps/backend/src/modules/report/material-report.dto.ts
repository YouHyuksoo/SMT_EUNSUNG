/**
 * @file src/modules/report/material-report.dto.ts
 * @description 리포트 B DTO — 자재 원장 7화면 + S-PARTS·지그·4M 6화면
 *
 * 초보자 가이드:
 * 1. **기간이 유일한 방어선이다.** 자재 리포트는 전부 GROUP BY 집계라 키가 없다.
 *    구동 원장의 날짜 인덱스를 타도록 기간을 필수로 받는다 — 실측 인덱스:
 *        IM_ITEM_RECEIPT          150만행 · PK 선두 RECEIPT_DATE
 *        IM_ITEM_ISSUE            261만행 · PK 선두 ISSUE_DATE
 *        IM_ITEM_RECEIPT_BARCODE  193만행 · SCAN_DATE 단독 인덱스
 *        IB_SMT_CHECKHIST         312만행 · (CHECK_DATE, SCAN_PARTNAME)
 * 2. **IM_ITEM_INVENTORY 에는 날짜 인덱스가 없다** (183만행 · 실측). 그래서
 *    369 재고는 기간이 아니라 **품목·위치 가드**로 막는다. 수량 > 0 인 행은
 *    3,540행뿐이므로 (실측) 불용·장기재고 갈래는 가볍다.
 * 3. **365 출고 상세의 기간 컬럼은 ENTER_DATE 다** (ISSUE_DATE 가 아니다 — PB 그대로).
 *    ENTER_DATE 에는 인덱스가 없어 구간을 좁혀도 빨라지지 않는다 (7일 1.77s /
 *    31일도 비슷 — 실측). 정확성을 위해 PB 정의를 유지한다. 전체 262만건에서
 *    두 날짜의 날짜부가 다른 건은 348건이고 최대 650일 차이라, ISSUE_DATE 로
 *    바꾸거나 여유폭을 고정하면 그 건들이 조용히 빠진다.
 * 4. **0행 표가 많다** (실측): IMCN_MOLD·IMCN_MOLD_RECEIPT·IMCN_MOLD_ISSUE·
 *    IMCN_MOLD_INVENTORY·IMCN_JIG_ISSUE·IM_ITEM_LOCATION_MOVE_HIST·
 *    IM_ITEM_WORK_ORDER·IP_PRODUCT_SOFTWARE_MASTER 가 모두 0행이다.
 *    화면은 동작하지만 볼 것이 없다 — 조건이 틀린 게 아니다.
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
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

/** 기간 필수 리포트의 공통 조건. */
export class DateRangeReportQueryDto {
  @ApiProperty({ description: '시작일 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '종료일 (YYYY-MM-DD, 이 날짜 포함)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;
}

// ───────────────────────────────── 362 자재전표바코드리포트

/**
 * 362 — IM_ITEM_RECEIPT_BARCODE 의 스캔 이력.
 *
 * **PB 는 `LOT_DIVIDE_YN = 'Y'` 를 고정으로 걸었다** (롯트를 쪼갠 바코드만 본다).
 * 구조에서 SQL 을 새로 쓸 때 이 상수 조건이 제일 먼저 사라지는데, 빠지면 193만행이
 * 통째로 대상이 된다. 화면에서 끌 수 있게 해 두되 기본은 PB 와 같이 켬이다.
 */
export class MaterialBarcodeSlipQueryDto extends DateRangeReportQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '자재 롯트(LOT_NO, 앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  lotNo?: string;

  @ApiPropertyOptional({
    description: "롯트 분할 바코드만 볼지 (PB 고정조건 LOT_DIVIDE_YN='Y'). 기본 켬.",
    default: true,
  })
  @IsOptional() @IsIn(['Y', 'N', 'ALL'])
  lotDivideYn?: 'Y' | 'N' | 'ALL';
}

// ───────────────────────────────── 363 자재입고리포트

export class MaterialReceiptReportQueryDto extends DateRangeReportQueryDto {
  @ApiPropertyOptional({ description: '협력사코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  supplierCode?: string;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '품목분류 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  itemClass?: string;

  @ApiPropertyOptional({ description: '입고유형 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  receiptType?: string;

  @ApiPropertyOptional({ description: '창고(위치)코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  locationCode?: string;

  @ApiPropertyOptional({ description: '발주유형 (앞부분 일치). 협력사별 탭에만 쓴다.' })
  @IsOptional() @IsString() @Length(0, 10)
  orderType?: string;
}

// ───────────────────────────────── 364 자재입고합계리포트

export class MaterialReceiptSumQueryDto extends DateRangeReportQueryDto {
  @ApiPropertyOptional({ description: '협력사코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  supplierCode?: string;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '전표번호(INVOICE_NO, 앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  invoiceNo?: string;

  @ApiPropertyOptional({ description: '창고(위치)코드 (앞부분 일치). 창고별 탭에만 쓴다.' })
  @IsOptional() @IsString() @Length(0, 30)
  locationCode?: string;

  @ApiPropertyOptional({
    description: '코드표 표시 언어. 매트릭스 탭의 위치·구분 이름에 쓴다 (PB :ARG_LANG).',
    default: 'KOR',
  })
  @IsOptional() @IsString() @Length(0, 10)
  lang?: string;
}

// ───────────────────────────────── 365 자재출고리포트

export class MaterialIssueReportQueryDto extends DateRangeReportQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  lineCode?: string;

  @ApiPropertyOptional({ description: '자재 롯트(MATERIAL_MFS, 앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  materialMfs?: string;

  @ApiPropertyOptional({ description: '제조지시(MFS, 앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  mfs?: string;

  @ApiPropertyOptional({ description: 'ABC 등급 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  abcGrade?: string;

  @ApiPropertyOptional({ description: '창고(위치)코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  locationCode?: string;

  @ApiPropertyOptional({
    description: '이 단가 이상만 (PB 간이 탭의 :ARG_PRICE). 단가는 DB 함수가 계산한다.',
    default: 0,
  })
  @IsOptional() @Type(() => Number) @IsNumber() @Min(0)
  minUnitPrice?: number;
}

/** 365 의 SMT 체크이력 탭 — 바코드 하나로 훑는다. */
export class SmtCheckBarcodeQueryDto {
  @ApiProperty({
    description: '자재 바코드 (앞부분 일치). IB_SMT_CHECKHIST 는 312만행이고'
      + ' 이 탭에는 기간 조건이 없어 바코드가 필수다.',
  })
  @IsString() @Length(1, 60)
  barcode!: string;
}

/**
 * 365 풀체크 시각 단건 조회.
 *
 * 목록에 열로 붙이면 1만행에 367초가 걸린다 (LIKE 접두어가 컬럼 연결식이라
 * 인덱스를 못 쓴다 — 실측). 그래서 고른 한 건만 조회한다. 값의 정의는 PB 와 같다.
 */
export class FullCheckDateQueryDto {
  @ApiProperty({ description: '품목코드' })
  @IsString() @Length(1, 50)
  itemCode!: string;

  @ApiProperty({ description: '자재 롯트(MATERIAL_MFS)' })
  @IsString() @Length(1, 60)
  materialMfs!: string;

  @ApiProperty({
    description: '출고시각 키 (YYYYMMDDHH24MISS). 목록이 돌려준 값을 그대로 보낸다 —'
      + ' Oracle DATE 를 JSON 으로 내보내면 UTC 로 바뀌어 9시간 틀어진다.',
  })
  @IsString() @Matches(/^\d{14}$/)
  issueDateKey!: string;
}

// ───────────────────────────────── 366 자재출고합계리포트

export class MaterialIssueSumQueryDto extends DateRangeReportQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '협력사코드 (앞부분 일치). 품목별 탭에만 쓴다.' })
  @IsOptional() @IsString() @Length(0, 30)
  supplierCode?: string;

  @ApiPropertyOptional({ description: '출고계정 (앞부분 일치). 계정별 탭에만 쓴다.' })
  @IsOptional() @IsString() @Length(0, 30)
  issueAccount?: string;
}

// ───────────────────────────────── 367 자재랙이동리포트

export class MaterialRackMoveQueryDto extends DateRangeReportQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '자재 롯트(MATERIAL_MFS, 앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  materialMfs?: string;
}

// ───────────────────────────────── 368 자재장기재고리포트

/**
 * 368 — 마지막 입고가 N개월 이전인 재고.
 *
 * PB: `LAST_RECEIPT_DATE <= ADD_MONTHS(TO_DATE(:arg_date), :arg_term * -1)`
 * 기준일에서 개월수를 거꾸로 세는 것이므로 기간이 아니라 **기준일 + 개월수**다.
 */
export class MaterialLongTermQueryDto {
  @ApiProperty({ description: '기준일 (YYYY-MM-DD). 이 날짜에서 개월수를 거꾸로 센다.' })
  @IsString() @Matches(DATE_ONLY)
  baseDate!: string;

  @ApiProperty({ description: '개월수. 이 개월수보다 오래 입고가 없는 재고를 본다.', minimum: 1 })
  @Type(() => Number) @IsInt() @Min(1) @Max(120)
  termMonths!: number;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '자재 롯트(MATERIAL_MFS, 앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  materialMfs?: string;

  @ApiPropertyOptional({ description: '협력사코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  supplierCode?: string;
}

// ───────────────────────────────── 369 재고리포트

export class MaterialInventoryQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '창고(위치)코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  locationCode?: string;

  @ApiPropertyOptional({ description: '품목분류 (앞부분 일치). 합계·일일 탭에 쓴다.' })
  @IsOptional() @IsString() @Length(0, 30)
  itemClass?: string;

  @ApiPropertyOptional({
    description: '재고수량 부호. 0 이면 0 이상(기본), -1 이면 음수까지 전부.'
      + ' PB SIGN(qty) >= :arg_sign 그대로다.',
    default: 0,
  })
  @IsOptional() @Type(() => Number) @IsInt() @Min(-1) @Max(1)
  sign?: number;
}

/** 369 일일 탭 — 하루치 입고·출고를 DB 함수가 센다. */
export class MaterialInventoryDailyQueryDto extends MaterialInventoryQueryDto {
  @ApiProperty({ description: '기준일 (YYYY-MM-DD). 이 날짜의 입고·출고를 센다.' })
  @IsString() @Matches(DATE_ONLY)
  baseDate!: string;
}

/**
 * 369 불용재고 탭 — 개월수 안의 출고가 없거나 출고율이 낮은 재고.
 *
 * PB 는 WHERE 안에서 `F_GET_MAT_ISSUE_QTY_4_DISUSED` 를 행마다 최대 3번 호출한다.
 * 같은 인자로 같은 값이 나오므로 한 번만 계산해 바깥에서 거른다 (결과는 같다).
 */
export class MaterialDisusedQueryDto {
  @ApiProperty({ description: '개월수. 0 이면 출고량 조건을 걸지 않는다 (PB DECODE 그대로).' })
  @Type(() => Number) @IsInt() @Min(0) @Max(120)
  termMonths!: number;

  @ApiPropertyOptional({
    description: '이 출고율(%) 이하만. 재고 대비 출고량 비율이다.',
    default: 0,
  })
  @IsOptional() @Type(() => Number) @IsNumber() @Min(0) @Max(100)
  maxIssueRate?: number;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;
}

// ───────────────────────────────── 354·355·357·358 S-PARTS·지그

export class MoldReceiptReportQueryDto extends DateRangeReportQueryDto {
  @ApiPropertyOptional({ description: 'S-PARTS 코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  moldCode?: string;

  @ApiPropertyOptional({ description: '협력사코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  supplierCode?: string;
}

export class MoldIssueReportQueryDto extends DateRangeReportQueryDto {
  @ApiPropertyOptional({ description: 'S-PARTS 코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  moldCode?: string;
}

export class MoldMasterReportQueryDto {
  @ApiPropertyOptional({ description: 'S-PARTS 코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  moldCode?: string;

  @ApiPropertyOptional({ description: 'S-PARTS 그룹 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  moldGroup?: string;
}

export class JigReportQueryDto {
  @ApiPropertyOptional({ description: '지그코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  jigCode?: string;
}

export class JigIssueReportQueryDto extends DateRangeReportQueryDto {
  @ApiPropertyOptional({ description: '지그코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  jigCode?: string;

  @ApiPropertyOptional({ description: '지그유형 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  jigType?: string;

  @ApiPropertyOptional({ description: '출고상태 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  issueStatus?: string;
}

// ───────────────────────────────── 360 4M 변경이력

/**
 * 360 — 모델의 H/W·S/W 버전 이력.
 *
 * **PB 는 모델명을 등호로 걸었다** (`a.model_name = :arg_model_name`).
 * 모델 마스터는 327행뿐이라 앞부분 일치로 넓혀도 비용이 없고, 모델명을 정확히
 * 모르면 아무것도 못 보는 PB 의 불편을 없앤다.
 *
 * S/W 버전을 붙이는 서브쿼리가 읽는 IP_PRODUCT_SOFTWARE_MASTER 는 **0행이다**
 * (실측) — S/W 두 칸은 항상 비어 보인다.
 */
export class FourMHistoryQueryDto {
  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  modelName?: string;

  @ApiPropertyOptional({ description: '모델 SFX (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  modelSuffix?: string;
}
