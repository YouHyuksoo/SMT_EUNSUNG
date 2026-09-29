import { Type } from 'class-transformer';
import {
  IsDateString, IsInt, IsNumber, IsOptional, IsString, Length, Max, Min,
} from 'class-validator';

/** S-PARTS 입고 조회 — PB d_mcn_mold_receipt_lst 의 retrieve 인자와 1:1 */
export class MoldReceiptQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() moldCode?: string;
  @IsOptional() @IsString() supplierCode?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/** 입고 대상 S-PARTS 목록 — PB d_mcn_mold_4_receipt_lst */
export class MoldReceiptTargetQueryDto {
  @IsOptional() @IsString() moldCode?: string;
  @IsOptional() @IsString() supplierCode?: string;
}

/**
 * 입고 등록 본문.
 * 입고항번(RECEIPT_SEQUENCE)은 받지 않는다 — PB 와 같이 SEQ_MAT_RECEIPT 로 서버가 채번한다.
 * 입출고구분='1'(입고), 입고상태='N'(정상) 도 PB 가 박아둔 기본값이다.
 */
export class MoldReceiptCreateDto {
  @IsString() @Length(1, 30) moldCode!: string;
  @IsString() @Length(1, 20) supplierCode!: string;
  @Type(() => Number) @IsNumber() receiptQty!: number;

  @IsOptional() @IsDateString() receiptDate?: string;
  @IsOptional() @IsString() invoiceNo?: string;
  @IsOptional() @IsString() orderNo?: string;
  @IsOptional() @IsString() locationCode?: string;
  @IsOptional() @IsString() currency?: string;
  @IsOptional() @IsString() lineType?: string;
  @IsOptional() @IsString() moldVersionSpec?: string;
  /** 비우면 승인된 구매단가를 끌어온다 (PB f_get_mold_unit_price_by_confirm) */
  @IsOptional() @Type(() => Number) @IsNumber() unitPrice?: number;
  @IsOptional() @Type(() => Number) @IsNumber() moldVersion?: number;
  @IsOptional() @Type(() => Number) @IsNumber() moldSetSerial?: number;
}

/** 입고 취소 — PB f_mcn_mold_receipt_cancel 과 같은 키 */
export class MoldReceiptCancelDto {
  @IsDateString() receiptDate!: string;
  @Type(() => Number) @IsNumber() receiptSequence!: number;
}
