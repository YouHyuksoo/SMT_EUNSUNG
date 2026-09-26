import { Type } from 'class-transformer';
import {
  IsDateString, IsInt, IsNumber, IsOptional, IsString, Length, Matches, Max, Min,
} from 'class-validator';

/**
 * IQC 검사이력 조회 — PB d_iq_iqc_insepct_history / _summary_history.
 *
 * PB 의 두 DataWindow 는 WHERE 절이 없고 화면이 retrieve 인자로 조건을 넘겼다
 * (기간·모델·품목분류·검사유형). 그 인자를 그대로 조회조건으로 받는다.
 */
export class IqcInspectHistoryQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() itemClass?: string;
  @IsOptional() @IsString() inspectType?: string;
  @IsOptional() @IsString() inspectResult?: string;
  @IsOptional() @IsString() lotNo?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/**
 * IQC 검사이력 등록.
 *
 * PB 는 상세/집계 두 모드로 갈라 같은 테이블에 넣었고, 집계 모드에서만
 * 검사일시·검사항번을 채워줬다(상세 모드는 사용자가 직접 입력해 키가 빌 수 있었다).
 * 웹은 한 경로로 합치고 **검사일시와 검사항번은 항상 서버가 채운다** —
 * 항번은 SEQ_IQC_INSPECT_HISTORY_SEQ 로 채번한다(PB 가 부르던 그 시퀀스).
 */
export class IqcInspectHistoryCreateDto {
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() modelSuffix?: string;
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() itemClass?: string;
  @IsOptional() @IsString() lotNo?: string;
  @IsOptional() @IsString() defectCode?: string;
  @IsOptional() @IsString() inspectType?: string;
  @IsOptional() @IsString() inspectResult?: string;
  @IsOptional() @IsString() badReasonCode?: string;
  @IsOptional() @IsString() supplierCode?: string;
  @IsOptional() @IsString() inspector?: string;
  @IsOptional() @IsString() inspectorName?: string;
  @IsOptional() @IsString() comments?: string;

  @IsOptional() @Type(() => Number) @IsNumber() inspectQty?: number;
  @IsOptional() @Type(() => Number) @IsNumber() defectQty?: number;
}

/**
 * 수정·삭제 키 — 이 테이블에 기본키 제약이 없어 서버가 이 셋을 키로 다룬다.
 *
 * ⚠ 검사일시를 ISO 문자열로 왕복시키면 안 된다. JSON 직렬화가 Date 를 UTC 로 바꾸는데
 *   DB 는 KST 로 저장돼 있어 9시간이 밀리고 WHERE 가 한 행도 못 잡는다(실측 확인).
 *   그래서 목록이 내려준 불투명 키(TO_CHAR(INSPECT_DATE,'YYYYMMDDHH24MISS'))를 그대로 받는다.
 */
export class IqcInspectHistoryKeyDto {
  @IsString() @Matches(/^\d{14}$/, { message: 'inspectDateKey 는 YYYYMMDDHH24MISS 14자리입니다.' })
  inspectDateKey!: string;

  @Type(() => Number) @IsNumber() inspectSequence!: number;
}

/** 수정 본문 — 키 + 바꿀 값 */
export class IqcInspectHistoryUpdateDto extends IqcInspectHistoryCreateDto {
  @IsString() @Matches(/^\d{14}$/, { message: 'inspectDateKey 는 YYYYMMDDHH24MISS 14자리입니다.' })
  inspectDateKey!: string;

  @Type(() => Number) @IsNumber() inspectSequence!: number;
}
