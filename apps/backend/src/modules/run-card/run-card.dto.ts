// 작업지시관리 DTO — IP_PRODUCT_RUN_CARD
import { IsIn, IsNumber, IsOptional, IsString, Min, MaxLength } from 'class-validator';

/** 등록/수정 공통 입력 — RUN_NO 는 등록 시 서버가 F_GET_NEW_RUN_NO 로 채번한다. */
export class RunCardUpsertDto {
  /** 수정 시에만 전달 (등록 시 무시) */
  @IsOptional() @IsString() @MaxLength(30) runNo?: string;

  @IsString() runDate: string; // YYYY-MM-DD
  @IsString() @MaxLength(30) lotNo: string;
  @IsString() @MaxLength(30) itemCode: string;
  @IsString() @MaxLength(100) modelName: string;
  @IsString() @MaxLength(10) lineCode: string;
  @IsNumber() @Min(1) lotSize: number;
  @IsString() @MaxLength(30) charger: string;

  @IsOptional() @IsString() @MaxLength(20) shiftCode?: string;
  @IsOptional() @IsString() @MaxLength(30) markingNo?: string;
  @IsOptional() @IsString() @MaxLength(30) pcbSupplierCode?: string;
  @IsOptional() @IsString() @MaxLength(1) runStatus?: string;
  @IsOptional() @IsNumber() carrierSize?: number;
  @IsOptional() @IsString() @MaxLength(1) productRunType?: string;
  @IsOptional() @IsString() @MaxLength(20) arrayType?: string;
  @IsOptional() @IsIn(['Y', 'N']) activeYn?: string;
  @IsOptional() @IsString() @MaxLength(30) parentItemCode?: string;
  @IsOptional() @IsString() @MaxLength(10) pcbItem?: string;
  @IsOptional() @IsString() @MaxLength(50) masterModelName?: string;
  @IsOptional() @IsString() @MaxLength(20) mfsGroupNo?: string;
  @IsOptional() @IsString() @MaxLength(10) revision?: string;
  @IsOptional() @IsString() @MaxLength(20) modelClass?: string;
  @IsOptional() @IsString() @MaxLength(20) pcbWeek?: string;
  @IsOptional() @IsString() @MaxLength(2000) comments?: string;

  @IsOptional() @IsString() userId?: string;
}
