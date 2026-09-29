import { Type } from 'class-transformer';
import { IsInt, IsISO8601, IsOptional, IsString, Max, Min } from 'class-validator';

/**
 * PB d_pln_product_work_qc_hst 의 retrieve 인자 10개에 대응한다.
 * ARG_INSPECT_HANDLING 은 PB 화면이 항상 '%' 를 넘겨 조건이 되지 않았지만,
 * 컬럼 자체는 필터 가치가 있어 선택 조건으로 열어 두었다.
 */
export class RepairHistoryQueryDto {
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() serialNo?: string;
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() workstageCode?: string;
  @IsOptional() @IsString() receiptDeficit?: string;
  @IsOptional() @IsString() inspectHandling?: string;
  @IsOptional() @IsString() repairResultCode?: string;
  @IsOptional() @IsISO8601() dateFrom?: string;
  @IsOptional() @IsISO8601() dateTo?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}
