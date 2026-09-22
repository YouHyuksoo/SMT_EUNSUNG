import { Type } from 'class-transformer';
import { IsDateString, IsIn, IsInt, IsOptional, IsString, Max, Min } from 'class-validator';

export class MagazineLabelHistoryQueryDto {
  @IsOptional() @IsIn(['history', 'summary', 'matrix']) viewMode: 'history' | 'summary' | 'matrix' = 'history';
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() workstageCode?: string;
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() magazineLabelNo?: string;
  @IsOptional() @IsString() runNo?: string;
  @IsOptional() @IsDateString() dateFrom?: string;
  @IsOptional() @IsDateString() dateTo?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}
