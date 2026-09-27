/**
 * @file src/modules/planning/result.dto.ts
 * @description 기간별 생산실적 조회 / 생산일보 리포트 DTO
 *              PB w_pln_product_pcb_result_query / w_pln_product_pcb_result_report
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsOptional, IsString, Length, Matches } from 'class-validator';

const DATE_ONLY = /^\d{4}-\d{2}-\d{2}$/;

/** 공정별 실적 집계 — IP_PRODUCT_WORKSTAGE_IO 245,717행이라 기간이 필수다. */
export class ResultQueryDto {
  @ApiProperty({ description: '생산일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '생산일 끝 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  modelName?: string;

  @ApiPropertyOptional({ description: '작업지시번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  runNo?: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  lineCode?: string;

  @ApiPropertyOptional({ description: '공정코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  workstageCode?: string;
}

/** 작업지시 하나의 공정별 실적 — PB d_pln_product_pcb_run_result_lst. */
export class ResultByRunQueryDto {
  @ApiProperty({ description: '작업지시번호. 필수 — 기간 없이 훑지 않는다.' })
  @IsString() @Length(1, 30)
  runNo!: string;
}

/** 작업지시 + 라인 + 공정의 PID 목록 — PB d_pln_product_pcb_serial_lst. */
export class ResultSerialQueryDto {
  @ApiProperty() @IsString() @Length(1, 30)
  runNo!: string;

  @ApiProperty() @IsString() @Length(1, 30)
  lineCode!: string;

  @ApiProperty() @IsString() @Length(1, 30)
  workstageCode!: string;
}

/**
 * 생산일보 — PB w_pln_product_pcb_result_report.
 *
 * PB 는 DataWindow 두 개로 기준일 컬럼만 바꿨다 (RUN_DATE / ACTUAL_DATE).
 * 웹은 한 경로로 합치고 `dateBasis` 로 고른다.
 */
export class DailyReportQueryDto {
  @ApiProperty({ description: '기준일 (YYYY-MM-DD). PB 와 같이 하루 단위다.' })
  @IsString() @Matches(DATE_ONLY)
  reportDate!: string;

  @ApiPropertyOptional({
    description:
      "기준: 'run'(작업지시일 RUN_DATE, 기본) | 'actual'(PDA ON 시각의 날짜)."
      + ' actual 은 RUN_DATE 30일 창을 선필터로 걸고 PDA ON 날짜로 맞춘다 (PB 원본과 같다).',
  })
  @IsOptional() @IsIn(['run', 'actual'])
  dateBasis?: 'run' | 'actual';

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  lineCode?: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  modelName?: string;

  @ApiPropertyOptional({ description: '작업지시번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  runNo?: string;
}
