/**
 * @file src/modules/quality/dto/repair-query.dto.ts
 * @description 281 공정수리이력조회 요약 입력 규칙.
 */
import { IsDateString, IsOptional, IsString } from 'class-validator';

export class RepairQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() modelName?: string;
  /** 불량사유 이름을 낼 언어. PB `gvs_language` 에 대응한다. */
  @IsOptional() @IsString() lang?: string;
}
