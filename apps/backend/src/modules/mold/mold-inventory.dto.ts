import { Type } from 'class-transformer';
import { IsInt, IsOptional, IsString, Length, Max, Min } from 'class-validator';

/** S-PARTS 재고 조회 — PB d_mcn_mold_inventory_lst 의 retrieve 인자와 1:1 */
export class MoldInventoryQueryDto {
  @IsOptional() @IsString() moldCode?: string;
  @IsOptional() @IsString() moldUseStatus?: string;
  @IsOptional() @IsString() moldGroup?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/** 선택 재고의 출고이력 / 청구목록 조회 */
export class MoldInventoryDetailQueryDto {
  @IsString() @Length(1, 30) moldCode!: string;
}
