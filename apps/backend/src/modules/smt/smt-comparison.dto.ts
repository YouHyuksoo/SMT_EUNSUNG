/**
 * @file src/modules/smt/smt-comparison.dto.ts
 * @description 피더레이아웃 비교 DTO — PB w_smt_bom_comparison_master_rpt
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsIn,
  IsOptional,
  IsString,
  Length,
} from 'class-validator';

/** 쉼표로 넘어온 모델 목록을 배열로 바꾼다. 쿼리스트링은 배열을 그대로 못 싣는다. */
const toModelList = ({ value }: { value: unknown }): string[] => {
  if (Array.isArray(value)) return value.map((v) => String(v).trim()).filter(Boolean);
  if (typeof value === 'string') {
    return value.split(',').map((v) => v.trim()).filter(Boolean);
  }
  return [];
};

export class SmtLocationCompareQueryDto {
  @ApiProperty({ description: '라인코드' })
  @IsString() @Length(1, 20)
  lineCode!: string;

  @ApiProperty({
    description: '비교할 모델 목록 (쉼표 구분, 2~10개). PB 는 PARENT_ITEM_CODE||PCB_ITEM 로 묶었다.',
    example: 'MODEL-A,MODEL-B',
  })
  @Transform(toModelList)
  @IsArray() @ArrayMinSize(2) @ArrayMaxSize(10)
  @IsString({ each: true })
  models!: string[];

  @ApiPropertyOptional({ description: "PCB 면. 비우면 양면('%')" })
  @IsOptional() @IsIn(['T', 'B'])
  pcbItem?: 'T' | 'B';
}

export class SmtBomExplodeQueryDto {
  @ApiProperty({ description: '전개할 SET 품목코드 (= 모델명)' })
  @IsString() @Length(1, 50)
  setItemCode!: string;

  @ApiProperty({ description: '피더 위치를 붙일 기준 라인코드' })
  @IsString() @Length(1, 20)
  lineCode!: string;

  @ApiPropertyOptional({ description: "PCB 면. 비우면 양면('%')" })
  @IsOptional() @IsIn(['T', 'B'])
  pcbItem?: 'T' | 'B';
}
