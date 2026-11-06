// 제품납품계획(출하지시, IP_PRODUCT_DELIVERY_PLAN) 입력 DTO
import { Type } from 'class-transformer';
import { IsIn, IsInt, IsOptional, IsString, Matches, MaxLength, Min } from 'class-validator';

const YMD = /^\d{4}-\d{2}-\d{2}$/;

export class ShippingOrderQueryDto {
  @Matches(YMD) dateFrom!: string;
  @Matches(YMD) dateTo!: string;
  @IsOptional() @IsString() customerCode?: string;
  @IsOptional() @IsString() modelName?: string;
  /** Y 면 완료(C) 지시를 뺀다 — 출고 화면의 지시 선택이 쓴다 */
  @IsOptional() @IsIn(['Y', 'N']) openOnly?: 'Y' | 'N';
}

export class ShippingOrderUpsertDto {
  /** 납기일 */
  @Matches(YMD) planDate!: string;
  @IsString() @MaxLength(30) customerCode!: string;
  @IsString() @MaxLength(100) modelName!: string;
  @Type(() => Number) @IsInt() @Min(1) planQty!: number;
  @IsOptional() @IsString() @MaxLength(2000) comments?: string;
}
