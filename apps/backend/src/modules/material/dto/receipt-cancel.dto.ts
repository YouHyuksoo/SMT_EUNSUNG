import { Type } from 'class-transformer';
import {
  ArrayMaxSize, ArrayNotEmpty, IsArray, IsIn, IsInt, IsISO8601,
  IsNumber, IsOptional, IsString, Max, Min, ValidateNested,
} from 'class-validator';

/** 조회 모드 — PB rb_cancel / rb_hst 라디오버튼 */
export type ReceiptCancelMode = 'CANCEL' | 'HISTORY';

export class ReceiptCancelQueryDto {
  /** CANCEL = 취소대상(RECEIPT_STATUS='N', LINE_TYPE<>'M'), HISTORY = 입고이력 전체 */
  @IsOptional() @IsIn(['CANCEL', 'HISTORY']) mode: ReceiptCancelMode = 'CANCEL';
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() materialMfs?: string;
  @IsOptional() @IsString() supplierCode?: string;
  @IsOptional() @IsString() locationCode?: string;
  @IsOptional() @IsString() invoiceNo?: string;
  /** 입고일 범위 (PB arg_dateset / arg_dateend) */
  @IsOptional() @IsISO8601() dateFrom?: string;
  @IsOptional() @IsISO8601() dateTo?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/** 취소 대상 1건 — IM_ITEM_RECEIPT PK(RECEIPT_DATE, RECEIPT_SEQUENCE, ORGANIZATION_ID) 중 조직은 토큰에서 온다 */
export class ReceiptCancelTargetDto {
  @IsISO8601() receiptDate!: string;
  @Type(() => Number) @IsNumber() receiptSequence!: number;
}

export class ReceiptCancelExecuteDto {
  /** 상계 행에 찍을 입고일자 (PB uo_cancel_date) */
  @IsISO8601() cancelDate!: string;
  /** 전월 이월분 취소 허용 (PB cbx_allow_last_mm_cancel / Gvs_allow_last_mm_receipt_cancel) */
  @IsOptional() @IsIn(['Y', 'N']) allowLastMonth: 'Y' | 'N' = 'N';
  @IsArray() @ArrayNotEmpty() @ArrayMaxSize(500)
  @ValidateNested({ each: true }) @Type(() => ReceiptCancelTargetDto)
  targets!: ReceiptCancelTargetDto[];
}
