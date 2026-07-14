import { Type } from 'class-transformer';
import { IsDateString, IsIn, IsInt, IsNumber, IsOptional, IsString, MaxLength, Min } from 'class-validator';
import { PaginationQueryDto } from '../../../common/dto/base-query.dto';

export class SalePriceQueryDto extends PaginationQueryDto {
  @IsOptional() @IsString() customerCode?: string;
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() productLineType?: string;
  @IsOptional() @IsString() priceType?: string;
  @IsOptional() @IsDateString() baseDate?: string;
  @IsOptional() @IsIn(['Y', 'N']) validOnly?: string;
}

export class SalePriceImpactQueryDto {
  @IsIn(['create', 'update']) mode: 'create' | 'update';
  @IsString() customerCode: string;
  @IsString() itemCode: string;
  @IsString() productLineType: string;
  @IsDateString() dateset: string;
}

export class CreateSalePriceDto {
  @IsString() @MaxLength(20) customerCode: string;
  @IsString() @MaxLength(20) itemCode: string;
  @IsString() @MaxLength(1) productLineType: string;
  @IsDateString() dateset: string;
  @IsOptional() @IsDateString() dateend?: string;
  @IsOptional() @Type(() => Number) @IsNumber() @Min(0) salePrice?: number;
  @IsOptional() @Type(() => Number) @IsNumber() @Min(0) standardSalePrice?: number;
  @IsOptional() @Type(() => Number) @IsNumber() @Min(0) foreignSalePrice?: number;
  @IsOptional() @IsString() @MaxLength(3) saleCurrency?: string;
  @IsOptional() @IsString() @MaxLength(3) foreignSaleCurrency?: string;
  @IsOptional() @Type(() => Number) @IsNumber() @Min(0) taxRate?: number;
  @IsOptional() @IsString() @MaxLength(1) priceType?: string;
  @IsOptional() @IsString() @MaxLength(10) priceChangeReason?: string;
  @IsOptional() @IsString() @MaxLength(20) saleCharge?: string;
  @IsOptional() @IsString() @MaxLength(100) modelName?: string;
}

export class UpdateSalePriceDto extends CreateSalePriceDto {
  @IsDateString() originalDateset: string;
}

export class CustomerQueryDto {
  @IsOptional() @IsString() search?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) limit = 200;
}
