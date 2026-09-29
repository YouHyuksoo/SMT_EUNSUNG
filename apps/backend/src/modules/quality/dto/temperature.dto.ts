import { Type } from 'class-transformer';
import {
  IsBooleanString, IsDateString, IsInt, IsOptional, IsString, Length, Max, Min,
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
