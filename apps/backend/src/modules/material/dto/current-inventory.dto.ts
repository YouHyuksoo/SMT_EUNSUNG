import { IsIn, IsInt, IsOptional, IsString, Max, Min } from 'class-validator';
import { Type } from 'class-transformer';

export class CurrentInventoryQueryDto {
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() locationCode?: string;
  @IsOptional() @IsString() lineType?: string;
  @IsOptional() @IsString() inventoryStatus?: string;
  @IsOptional() @IsString() inventoryHold?: string;
  @IsOptional() @IsIn(['Y', 'N']) includeZero?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}
