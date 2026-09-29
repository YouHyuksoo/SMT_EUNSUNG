import { Type } from 'class-transformer';
import {
  IsDateString, IsInt, IsOptional, IsString, Length, Max, Min,
} from 'class-validator';

/**
 * 4M 이력 조회 — PB d_qc_4m_lst(모델별) / d_qc_4m_hist(기간·키워드) 를 하나로 합쳤다.
 * PB 는 DataWindow 를 둘로 나눴지만 조건의 합집합이라 한 쿼리로 덮인다.
 */
export class Qc4mQueryDto {
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() workstageCode?: string;
  @IsOptional() @IsString() ecoStatus?: string;
  @IsOptional() @IsString() ecoType?: string;
  @IsOptional() @IsString() ecoDivision?: string;
  /** PB 는 변경점·변경내용·변경사유 세 컬럼을 OR 로 훑는다 */
  @IsOptional() @IsString() keyword?: string;
  @IsOptional() @IsDateString() dateFrom?: string;
  @IsOptional() @IsDateString() dateTo?: string;

  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/**
 * 4M 등록·수정 본문.
 * 키는 모델명 + 모델서픽스 + 변경일자 + ORGANIZATION_ID 다 (이 테이블에 기본키 제약은 없다).
 * 첨부 이미지(ECO_IMAGE / ECO_IMAGE2)는 본문으로 받지 않는다 — 첨부는 이관 범위에서 제외했다.
 */
export class Qc4mUpsertDto {
  @IsString() @Length(1, 30) modelName!: string;
  @IsString() @Length(1, 10) modelSuffix!: string;
  @IsDateString() ecoDate!: string;

  @IsOptional() @IsDateString() applyDate?: string;
  @IsOptional() @IsDateString() firstProductDate?: string;
  @IsOptional() @IsDateString() lastProductDate?: string;
  @IsOptional() @IsString() workstageCode?: string;
  @IsOptional() @IsString() ecoStatus?: string;
  @IsOptional() @IsString() ecoType?: string;
  @IsOptional() @IsString() ecoDivision?: string;
  @IsOptional() @IsString() pcbItem?: string;
  @IsOptional() @IsString() hwRevision?: string;
  @IsOptional() @IsString() swRevision?: string;
  @IsOptional() @IsString() ecoPoint?: string;
  @IsOptional() @IsString() ecoComments?: string;
  @IsOptional() @IsString() ecoReason?: string;
}

/** 단건 지정 (삭제) */
export class Qc4mKeyDto {
  @IsString() @Length(1, 30) modelName!: string;
  @IsString() @Length(1, 10) modelSuffix!: string;
  @IsDateString() ecoDate!: string;
}
