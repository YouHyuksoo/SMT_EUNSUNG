import { IsInt, IsOptional, IsString, Max, Min } from 'class-validator';
import { Type } from 'class-transformer';

export class ProductInventoryQueryDto {
  @IsOptional() @IsString() model?: string;
  @IsOptional() @IsString() locationCode?: string;
  @IsOptional() @IsString() packType?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}
