import { Type } from 'class-transformer';
import {
  IsDateString, IsInt, IsNumber, IsOptional, IsString, Length, Max, Min,
} from 'class-validator';

/** S-PARTS 주문 조회 — PB d_mcn_mold_purchase_order_lst 의 retrieve 인자와 1:1 */
export class MoldOrderQueryDto {
  /** PB 는 납기일 기준으로 기간을 건다 */
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() supplierCode?: string;
  @IsOptional() @IsString() moldCode?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/**
 * 주문 등록 본문.
 * 주문번호(ORDER_NO)는 받지 않는다 — PB 와 같이 주문일자 + SEQ_PURCHASE_ORDER_NO 로 서버가 만든다.
 */
export class MoldOrderCreateDto {
  @IsString() @Length(1, 30) moldCode!: string;
  @IsString() @Length(1, 20) supplierCode!: string;
  @IsDateString() purchaseOrderDate!: string;
  @IsDateString() deliveryDate!: string;
  @Type(() => Number) @IsNumber() orderQty!: number;

  @IsOptional() @IsString() orderGroupNo?: string;
  @IsOptional() @IsString() currency?: string;
  @IsOptional() @IsString() lineType?: string;
  @IsOptional() @IsString() deliveryMethod?: string;
  @IsOptional() @IsString() deliveryPlace?: string;
  @IsOptional() @IsString() attnName?: string;
  @IsOptional() @IsString() ccName?: string;
  @IsOptional() @IsString() incidentalExpenseCode?: string;
  /** 비우면 PKG_MES_MAC.F_GET_MOLD_UNIT_PRICE 로 채운다 (PB 와 같다) */
  @IsOptional() @Type(() => Number) @IsNumber() unitPrice?: number;
}

/** 주문 수정 — 주문번호로 잡는다 */
export class MoldOrderUpdateDto {
  @IsString() @Length(1, 30) orderNo!: string;

  @IsOptional() @IsDateString() deliveryDate?: string;
  @IsOptional() @Type(() => Number) @IsNumber() orderQty?: number;
  @IsOptional() @Type(() => Number) @IsNumber() unitPrice?: number;
  @IsOptional() @IsString() currency?: string;
  @IsOptional() @IsString() lineType?: string;
  @IsOptional() @IsString() deliveryMethod?: string;
  @IsOptional() @IsString() deliveryPlace?: string;
  @IsOptional() @IsString() attnName?: string;
  @IsOptional() @IsString() ccName?: string;
  @IsOptional() @IsString() incidentalExpenseCode?: string;
}

/** 주문 삭제 */
export class MoldOrderKeyDto {
  @IsString() @Length(1, 30) orderNo!: string;
}
