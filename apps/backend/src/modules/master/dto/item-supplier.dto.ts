import { ApiProperty, ApiPropertyOptional, PartialType } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsIn, IsInt, IsNumber, IsOptional, IsString, MaxLength, Min } from 'class-validator';
import { PaginationQueryDto } from '../../../common/dto/base-query.dto';

export class CreateItemSupplierDto {
  @ApiProperty() @IsString() @MaxLength(20) supplierCode: string;
  @ApiProperty() @IsString() @MaxLength(20) itemCode: string;
  @ApiProperty() @IsString() dateset: string;
  @ApiProperty() @IsString() dateend: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(1) orderType?: string;
  @ApiProperty({ default: 100 }) @Type(() => Number) @IsNumber() @Min(0) orderRate: number;
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsInt() @Min(0) orderLeadtime?: number;
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() @Min(0) orderBadRate?: number;
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() @Min(0) mimOrderQty?: number;
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() @Min(0) packingQty?: number;
  @ApiPropertyOptional() @IsOptional() @IsIn(['Y', 'N']) longtermDeliveryYn?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(30) warehouseCharge?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(30) orderCharge?: string;
  @ApiPropertyOptional() @IsOptional() @IsIn(['Y', 'N']) mainVendorYn?: string;
  @ApiProperty() @IsString() @MaxLength(20) paymentType: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(1) inspectMethod?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(1) inspectRule?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(3) incidentalExpenseCode?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(20) inspectProcess?: string;
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() @Min(0) esdCheckCycleValue?: number;
}

export class UpdateItemSupplierDto extends PartialType(CreateItemSupplierDto) {
  @ApiProperty() @IsString() originalDateset: string;
}

export class ItemSupplierQueryDto extends PaginationQueryDto {
  @ApiPropertyOptional() @IsOptional() @IsString() itemCode?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() supplierCode?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() orderType?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() inspectRule?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() search?: string;
}
