import { Type } from 'class-transformer';
import { IsIn, IsInt, IsOptional, IsString, Max, Min } from 'class-validator';

export class WorkstageInventoryQueryDto {
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsIn(['Y', 'N']) includeZero = 'Y';
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}
