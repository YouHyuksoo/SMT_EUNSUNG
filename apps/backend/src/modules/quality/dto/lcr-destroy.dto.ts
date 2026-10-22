import { Type } from 'class-transformer';
import {
  IsISO8601, IsInt, IsNotEmpty, IsOptional, IsString, Matches, Max, MaxLength, Min,
} from 'class-validator';

/** LCR 대상 품번 검색 — BOM 에 L/C/R 위치가 직접 달린 품목(TOP/BOT 면 품목) */
export class LcrItemSearchQueryDto {
  @IsOptional() @IsString() search?: string;
}

/** 품번 하나의 L/C/R 자재 미리보기 */
export class LcrPreviewQueryDto {
  @IsString() @IsNotEmpty() itemCode!: string;
  @IsISO8601() measureDate!: string;
}

/** LCR 폐기 등록 — 실장수·단가·금액은 서버가 BOM·단가표로 계산해 스냅샷으로 남긴다 */
export class LcrDestroyCreateDto {
  @IsISO8601() measureDate!: string;
  @IsString() @IsNotEmpty() itemCode!: string;
  /** LCR 진행 수량 (연배 수) */
  @Type(() => Number) @IsInt() @Min(1) @Max(10000) arrayQty!: number;
  /** 측정자 (수기) */
  @IsString() @IsNotEmpty() @MaxLength(16) measurer!: string;
  @IsOptional() @IsString() @MaxLength(150) comments?: string;
}

/** LCR 폐기 목록 — 월 단위 */
export class LcrDestroyListQueryDto {
  @Matches(/^\d{4}-\d{2}$/) month!: string;
  @IsOptional() @IsString() itemCode?: string;
}

/** 월별 누계 — 연 단위 */
export class LcrDestroyMonthlyQueryDto {
  @Matches(/^\d{4}$/) year!: string;
}
