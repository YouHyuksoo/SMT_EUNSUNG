import { Transform } from 'class-transformer';
import { IsDateString, IsInt, IsOptional, IsString, Max, Min } from 'class-validator';

export class EquipmentResultQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() pid?: string;
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() runNo?: string;
  @IsOptional() @IsString() result?: string;
  @IsOptional() @IsString() reviewResult?: string;
  @IsOptional() @IsString() jobFile?: string;

  @IsOptional()
  @Transform(({ value }) => Number(value))
  @IsInt()
  @Min(1)
  @Max(5000)
  limit = 1000;
}
