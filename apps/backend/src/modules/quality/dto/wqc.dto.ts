import { Type } from 'class-transformer';
import {
  IsDateString, IsInt, IsOptional, IsString, Length, Max, Min,
} from 'class-validator';

/** 공정품질검사 이력 조회 — PB d_qc_wqc_inspect_bad_hst_es */
export class WqcHistoryQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() workstageCode?: string;
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() serialNo?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/** 선택 PID 의 검사내역 — PB d_qc_visual_inspect_bad_lst_es */
export class WqcByPidQueryDto {
  @IsString() @Length(1, 60) serialNo!: string;
}

/**
 * 공정품질검사 등록 — PB rb_inspect 분기.
 * 라인·공정은 PB 도 반드시 고르게 했다. 교대코드·항번·모델·품목은 서버가 채운다.
 */
export class WqcScanDto {
  @IsString() @Length(1, 60) serialNo!: string;
  @IsString() @Length(1, 20) lineCode!: string;
  @IsString() @Length(1, 20) workstageCode!: string;
  /** 'NG' 면 불량수량 1, 그 외는 0 (PB 규칙) */
  @IsString() @Length(1, 20) badReasonCode!: string;

  @IsOptional() @IsString() machineCode?: string;
  @IsOptional() @IsString() comments?: string;
}

/** 공정품질검사 취소 — 같은 PID·라인·공정의 최신 1건을 지운다 */
export class WqcCancelDto {
  @IsString() @Length(1, 60) serialNo!: string;
  @IsString() @Length(1, 20) lineCode!: string;
  @IsString() @Length(1, 20) workstageCode!: string;
}
