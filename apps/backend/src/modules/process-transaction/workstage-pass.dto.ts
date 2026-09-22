import { Type } from 'class-transformer';
import { IsBoolean, IsDateString, IsIn, IsInt, IsOptional, IsString, Max, Min } from 'class-validator';

export type WorkstagePassMode = 'wait' | 'history' | 'inventory' | 'today' | 'workstageSummary';

export class WorkstagePassQueryDto {
  @IsOptional() @IsIn(['wait', 'history', 'inventory', 'today', 'workstageSummary']) mode: WorkstagePassMode = 'history';
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() workstageCode?: string;
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() serialNo?: string;
  @IsOptional() @IsDateString() dateFrom?: string;
  @IsOptional() @IsDateString() dateTo?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

export class WorkstagePassScanDto {
  @IsString() pid!: string;
  @IsString() lineCode!: string;
  @IsString() workstageCode!: string;
  @IsOptional() @IsString() workstageType?: string;
  @IsOptional() @IsBoolean() cancel = false;
  @IsOptional() @IsBoolean() rework = false;
}
