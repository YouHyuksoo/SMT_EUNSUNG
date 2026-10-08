/**
 * @file src/modules/inventory-query/inventory-query.dto.ts
 * @description 재고(M_INVENTORY) 대분류 DTO — 269·271·272·274
 *
 * 초보자 가이드:
 * 1. **이 대분류는 "월" 이 기준선이다.** 자재창고가 바코드·롯트 같은 **키**로
 *    좁혔다면, 여기는 수불·마감·실사라 **마감월(`YYYYMM`)** 이 조건의 중심이다.
 *    월이 없으면 입고 22만 / 출고 260만 행을 전 기간 훑는다.
 * 2. **269 총재고조회만 예외다** — 품목 기준정보(2,560행)를 한 줄씩 보는 화면이라
 *    월이 없다.
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsBoolean, IsIn, IsInt, IsNumber, IsOptional, IsString, Length, Matches, Min } from 'class-validator';

/** `YYYYMM` 여섯 자리. 마감월·실사월이 이 형식이다. */
const YYYYMM = /^\d{6}$/;

/** 269 총재고 조회 조건. */
export class TotalInventoryQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '품목구분 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  itemDivision?: string;

  @ApiPropertyOptional({ description: '품목분류 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  itemClass?: string;
}

/** 269 자리별 상세 조회 조건. */
export class TotalInventoryDetailQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({
    description: "창고 이름을 어느 말로 낼지 (공통코드 조회에 쓴다). 기본 'KOR'",
  })
  @IsOptional() @IsString() @Length(0, 10)
  lang?: string;
}

/** 271 원자재 월마감 — 대상 월. */
export class InventoryCloseMonthDto {
  @ApiProperty({ description: '마감월 (YYYYMM)' })
  @IsString() @Matches(YYYYMM)
  yyyymm!: string;
}

/** 272 실사·조정 조회 조건. */
export class InventoryCheckQueryDto {
  @ApiProperty({ description: '마감월 (YYYYMM)' })
  @IsString() @Matches(YYYYMM)
  yyyymm!: string;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '롯트번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  lotNo?: string;

  @ApiPropertyOptional({ description: '창고코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  locationCode?: string;
}

/**
 * 272 재고 조정 (**쓰기**).
 *
 * **차이 = 실사 − 장부.** 양수(실제가 많음)면 구분 4 로 재고가 늘고,
 * 음수(실제가 적음)면 구분 3 으로 재고가 준다.
 */
export class InventoryAdjustDto {
  @ApiProperty({
    description: '마감월 (YYYYMM). 조정은 이 달의 마지막 날짜로 들어간다 —'
      + ' SYSDATE 를 쓰면 다음 달 수불로 새어 나간다.',
  })
  @IsString() @Matches(YYYYMM)
  yyyymm!: string;

  @ApiProperty({ description: '품목코드' })
  @IsString() @Length(1, 50)
  itemCode!: string;

  @ApiProperty({ description: '롯트번호 (자재 롯트 = MATERIAL_MFS)' })
  @IsString() @Length(1, 60)
  lotNo!: string;

  @ApiProperty({
    description: '차이 수량 = 실사 − 장부. **0 이면 거절한다** (조정할 것이 없다).',
  })
  @Type(() => Number) @IsNumber()
  differenceQty!: number;

  @ApiPropertyOptional({ description: '창고코드. 비우면 재고 표의 값을 쓴다.' })
  @IsOptional() @IsString() @Length(0, 20)
  locationCode?: string;
}

/** 바코드 실사 시작 — 그 순간의 장부를 실사표에 고정한다. */
export class StocktakeStartDto {
  @ApiProperty({ description: '실사월 (YYYYMM). 이번 달 또는 지난달만.' })
  @IsString() @Matches(YYYYMM)
  yyyymm!: string;

  @ApiPropertyOptional({ description: '이미 시작한 달의 장부를 다시 고정한다 (스캔은 유지).' })
  @IsOptional() @IsBoolean()
  regenerate?: boolean;
}

/** 바코드 스캔 (진행 중인 실사월에 기록). */
export class StocktakeScanDto {
  @ApiProperty({ description: '자재 바코드' })
  @IsString() @Length(1, 200)
  barcode!: string;

  @ApiPropertyOptional({ description: '센 수량. 비우면 바코드 수량 (일부 쓴 릴·벌크만 입력).' })
  @IsOptional() @Type(() => Number) @IsNumber() @Min(0)
  qty?: number;
}

/** 스캔 취소. */
export class StocktakeCancelDto {
  @ApiProperty({ description: '자재 바코드' })
  @IsString() @Length(1, 200)
  barcode!: string;
}

/** 공정 실사 입력 한 건 — 바코드(또는 롯트번호)나 품목코드. 품목코드로 넣으면 수량이 필요하다. */
export class WipStocktakeCountDto {
  @ApiPropertyOptional({ description: '자재 바코드 (라인에 걸린 릴)' })
  @IsOptional() @IsString() @Length(0, 200)
  barcode?: string;

  @ApiPropertyOptional({ description: '품목코드 (바코드가 없는 자재)' })
  @IsOptional() @IsString() @Length(0, 30)
  itemCode?: string;

  @ApiPropertyOptional({ description: '센 수량. 바코드면 비울 때 라벨 수량.' })
  @IsOptional() @Type(() => Number) @IsNumber() @Min(0)
  qty?: number;

  @ApiPropertyOptional({ description: '센 라인 (기록용)' })
  @IsOptional() @IsString() @Length(0, 20)
  lineCode?: string;
}

/** 274 바코드 실사 조회 조건. */
export class BarcodeCheckQueryDto {
  @ApiPropertyOptional({
    description: '실사월 (YYYYMM, 앞부분 일치). 비우면 전체 —'
      + ' 이 표는 실측 1행뿐이라 전체를 봐도 무겁지 않다.',
  })
  @IsOptional() @IsString() @Length(0, 6)
  yyyymm?: string;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  lineCode?: string;
}

/** 269 롯트별 상세는 품목 하나가 필수다. */
export class TotalInventoryLotQueryDto {
  @ApiProperty({ description: '품목코드 (정확히)' })
  @IsString() @Length(1, 50)
  itemCode!: string;

  @ApiPropertyOptional({ description: "말 (기본 'KOR')" })
  @IsOptional() @IsString() @Length(0, 10)
  lang?: string;

  @ApiPropertyOptional({ description: '사용하지 않는다 (표준 페이지 인자 자리)' })
  @IsOptional() @Type(() => Number) @IsInt()
  page?: number;
}

/** 제품 실사 입력 한 건 — 박스 바코드. 수량을 비우면 장부(없던 박스는 박스 라벨) 수량. */
export class FgStocktakeCountDto {
  @ApiProperty({ description: '제품 박스(PACK) 바코드' })
  @IsString() @Length(1, 100)
  barcode!: string;

  @ApiPropertyOptional({ description: '센 수량 (PCS). 쓰다 만 박스일 때만 넣는다.' })
  @IsOptional() @Type(() => Number) @IsNumber() @Min(0)
  qty?: number;

  @ApiPropertyOptional({ description: '로케이션. 비우면 실사표의 로케이션, 장부에 없던 박스는 P01.' })
  @IsOptional() @IsString() @Length(0, 10)
  locationCode?: string;
}

/** 제품 실사표 조회 조건. */
export class FgStocktakeListDto {
  @ApiProperty({ description: '실사월 (YYYYMM)' })
  @IsString() @Matches(YYYYMM)
  yyyymm!: string;

  @ApiPropertyOptional({ description: 'diff 차이 있는 것만 · unscanned 안 센 것만' })
  @IsOptional() @IsIn(['diff', 'unscanned'])
  status?: 'diff' | 'unscanned';

  @ApiPropertyOptional({ description: '박스 바코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  barcode?: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  modelName?: string;
}

/** 재고마감일자 조회 조건 — 연도. */
export class CloseDateYearDto {
  @ApiProperty({ description: '연도 (YYYY)' })
  @Type(() => Number) @IsInt() @Min(2000)
  year!: number;
}

/** 재고마감일자 한 달 저장. */
export class CloseDateSaveDto {
  @ApiProperty({ description: '마감월 (YYYYMM)' })
  @IsString() @Matches(YYYYMM)
  yyyymm!: string;

  @ApiProperty({ description: '시작일 (YYYY-MM-DD, 그날 0시부터)' })
  @IsString() @Matches(/^\d{4}-\d{2}-\d{2}$/)
  startDate!: string;

  @ApiProperty({ description: '종료일 (YYYY-MM-DD, 그날 끝까지 포함)' })
  @IsString() @Matches(/^\d{4}-\d{2}-\d{2}$/)
  endDate!: string;
}

/** 재고마감일자 연간 생성. */
export class CloseDateGenerateDto {
  @ApiProperty({ description: '연도 (YYYY)' })
  @Type(() => Number) @IsInt() @Min(2000)
  year!: number;

  @ApiProperty({ description: '시작일 (1~28). 1 이면 달력 월, N 이면 전달 N일 ~ 이번 달 N−1일.' })
  @Type(() => Number) @IsInt() @Min(1)
  startDay!: number;
}
