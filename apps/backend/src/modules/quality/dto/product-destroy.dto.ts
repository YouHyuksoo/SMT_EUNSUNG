import { Type } from 'class-transformer';
import {
  ArrayMaxSize, ArrayNotEmpty, IsArray, IsInt, IsISO8601,
  IsNotEmpty, IsNumber, IsOptional, IsString, Max, Min,
} from 'class-validator';

/** 폐기이력 조회 — PB d_pln_product_destroy_hst (QC_INSPECT_HANDLING='D' 고정) */
export class ProductDestroyHistoryQueryDto {
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() workstageCode?: string;
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() serialNo?: string;
  @IsOptional() @IsISO8601() dateFrom?: string;
  @IsOptional() @IsISO8601() dateTo?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/** 시리얼 단건 현황 — PB dw_1(RECEIPT_DEFICIT='1') / dw_2(='2') */
export class ProductDestroySerialQueryDto {
  @IsString() @IsNotEmpty() serialNo!: string;
}

/** 폐기 등록 — PB cb_2(Destroy) 가 시리얼 목록을 순회하며 실행한다 */
export class ProductDestroyExecuteDto {
  @IsString() @IsNotEmpty() badReasonCode!: string;
  /** IP_PRODUCT_WORKSTAGE_IO 에 이력이 없을 때 쓰는 대체값 (PB 드롭다운). 없으면 '*' */
  @IsOptional() @IsString() fallbackLineCode?: string;
  @IsOptional() @IsString() fallbackWorkstageCode?: string;
  @IsArray() @ArrayNotEmpty() @ArrayMaxSize(1000) @IsString({ each: true })
  serialNos!: string[];
}

/** 반품처리(Issue) / 반품취소(Issue Cancel) — RECEIPT_DEFICIT 를 1 ↔ 2 로 토글 */
export class ProductDestroyIssueDto {
  @IsString() @IsNotEmpty() serialNo!: string;
  @Type(() => Number) @IsNumber() qcSequence!: number;
}
