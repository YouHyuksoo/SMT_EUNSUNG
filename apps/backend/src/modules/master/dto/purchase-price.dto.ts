import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsDateString, IsIn, IsInt, IsNumber, IsOptional, IsString, MaxLength, Min } from 'class-validator';
import { PaginationQueryDto } from '../../../common/dto/base-query.dto';

export class PurchasePriceQueryDto extends PaginationQueryDto {
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() supplierCode?: string;
  @IsOptional() @IsString() lineType?: string;
  @IsOptional() @IsString() priceType?: string;
  @IsOptional() @IsDateString() baseDate?: string;
  @IsOptional() @IsIn(['Y', 'N']) validOnly?: string;
}

export class PurchasePriceImpactQueryDto {
  @ApiProperty({ enum: ['create', 'update'] })
  @IsIn(['create', 'update'])
  mode: 'create' | 'update';

  @IsString() itemCode: string;
  @IsString() supplierCode: string;
  @IsString() lineType: string;
  @IsDateString() dateset: string;
}

export class CreatePurchasePriceDto {
  @ApiProperty() @IsDateString() dateset: string;
  @ApiProperty() @IsString() @MaxLength(20) itemCode: string;
  @ApiProperty() @IsString() @MaxLength(20) supplierCode: string;
  @ApiProperty() @IsString() @MaxLength(10) lineType: string;
  @ApiProperty() @IsDateString() dateend: string;
  @ApiProperty() @Type(() => Number) @IsNumber() @Min(0) unitPrice: number;
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() @Min(0) standardUnitPrice?: number;
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() @Min(0) taxRate?: number;
  @ApiProperty() @IsString() @MaxLength(3) currency: string;
  @ApiProperty() @IsString() @MaxLength(10) delivery: string;
  @ApiProperty() @IsString() @MaxLength(1) priceType: string;
  @ApiProperty() @IsString() @MaxLength(10) priceChangeReason: string;
}

export class UpdatePurchasePriceDto extends CreatePurchasePriceDto {
  @ApiProperty() @IsDateString() originalDateset: string;
}

export class SupplierQueryDto {
  @ApiPropertyOptional() @IsOptional() @IsString() search?: string;
  @ApiPropertyOptional({ default: 200 }) @IsOptional() @Type(() => Number) @IsInt() @Min(1) limit = 200;
}
