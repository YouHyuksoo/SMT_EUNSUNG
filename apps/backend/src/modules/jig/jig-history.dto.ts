import { Type } from 'class-transformer';
import { IsDateString, IsIn, IsInt, IsOptional, IsString, Max, Min } from 'class-validator';

/** 지그 투입이력조회 — PB w_mcn_jig_input_history_master 의 DW_1.RETRIEVE 인자와 1:1 */
export class JigInputHistoryQueryDto {
  @IsOptional() @IsDateString() dateFrom?: string;
  @IsOptional() @IsDateString() dateTo?: string;
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() jigType?: string;
  @IsOptional() @IsString() jigLotNo?: string;
  @IsOptional() @IsString() modelItem?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/** 샘플마스터 장착이력조회 — PB w_mcn_sample_input_history_master */
export class SampleInputHistoryQueryDto {
  @IsOptional() @IsDateString() dateFrom?: string;
  @IsOptional() @IsDateString() dateTo?: string;
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() sampleType?: string;
  @IsOptional() @IsString() sampleLotNo?: string;
  @IsOptional() @IsString() modelItem?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/**
 * 샘플마스터 투입이력조회(BCR) — PB w_mcn_sample_bcr_input_history_master
 * PB 라디오버튼 rb_list / rb_ng 묶음을 웹은 탭(mode)으로 만든다.
 */
export class SampleBcrHistoryQueryDto {
  @IsOptional() @IsIn(['ALL', 'NG']) mode: 'ALL' | 'NG' = 'ALL';
  @IsOptional() @IsDateString() dateFrom?: string;
  @IsOptional() @IsDateString() dateTo?: string;
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() sampleType?: string;
  @IsOptional() @IsString() sampleLotNo?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}
