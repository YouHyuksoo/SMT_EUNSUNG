import { Type } from 'class-transformer';
import {
  IsBooleanString, IsDateString, IsInt, IsOptional, IsString, Length, Matches, Max, MaxLength, Min,
} from 'class-validator';

/**
 * 온도·습도 원시데이터 조회 — PB d_com_tempreture_raw_lst.
 *
 * `ICOM_TEMPERATURE_RAW` 는 1,700만 행이고 인덱스가 (NODEID, GATHER_DATE) 뿐이다.
 * 그래서 노드ID 와 기간을 **둘 다 필수**로 받는다 — PB 도 노드를 = 로 걸었다.
 */
export class TemperatureRawQueryDto {
  @IsString() @Length(1, 30) nodeId!: string;
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  /** 'true' 면 설비 기준범위를 벗어난 값만 본다 (PB 의 arg_ng = 'NG') */
  @IsOptional() @IsBooleanString() ngOnly?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 1000;
}

/** 온도 점검이력 조회 — PB d_mcn_temerature_check_lst */
export class TemperatureCheckQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() machineCode?: string;
  @IsOptional() @IsString() confirmYn?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/** 'YYYY-MM-DD HH:mm[:ss]' 또는 'YYYY-MM-DDTHH:mm[:ss]' — 화면의 datetime-local 값 */
export const DATE_TIME_TEXT = /^\d{4}-\d{2}-\d{2}[T ]\d{2}:\d{2}(:\d{2})?$/;

/**
 * 이상 점검이력 등록·수정 — PB w_pln_product_tempreture_history_query dw_5 (d_mcn_temerature_check_lst).
 * 이상 시작·종료는 둘 다 넣어야 하고 시작이 종료보다 늦으면 안 된다 (PB UPDATE 검사).
 */
export class TemperatureCheckUpsertDto {
  @IsString() @Length(1, 30) machineCode!: string;
  @Matches(DATE_TIME_TEXT, { message: '이상 시작일시 형식이 올바르지 않습니다.' }) checkStartDate!: string;
  @Matches(DATE_TIME_TEXT, { message: '이상 종료일시 형식이 올바르지 않습니다.' }) checkEndDate!: string;
  @IsOptional() @IsString() @MaxLength(10) ngReasonCode?: string;
  @IsOptional() @IsString() @MaxLength(10) actionCode?: string;
  @IsOptional() @IsString() @MaxLength(1) confirmYn?: string;
  @IsOptional() @IsString() @MaxLength(1000) comments?: string;
}

/** 이상 점검이력 키 — 설비 + 점검항번 (PB key 컬럼 그대로) */
export class TemperatureCheckKeyDto {
  @IsString() @Length(1, 30) machineCode!: string;
  @Type(() => Number) @IsInt() @Min(1) checkSequence!: number;
}

export class TemperatureCheckUpdateDto extends TemperatureCheckUpsertDto {
  @Type(() => Number) @IsInt() @Min(1) checkSequence!: number;
}
