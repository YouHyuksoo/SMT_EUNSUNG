/**
 * @file src/modules/master/dto/prod-line.dto.ts
 * @description 생산라인마스터(IP_PRODUCT_LINE) 관련 DTO 정의
 */

import { ApiProperty, ApiPropertyOptional, PartialType } from '@nestjs/swagger';
import { IsString, IsOptional, IsNotEmpty, IsNumber, Min, MaxLength, IsIn } from 'class-validator';
import { Type } from 'class-transformer';
import {
  LINE_DIVISION_VALUES,
  LINE_PRODUCT_DIVISION_VALUES,
  LINE_STATUS_VALUES,
  LINE_CAPACITY_UOM_VALUES,
  LINE_ACTIVE_YN_VALUES,
  USE_YN_VALUES,
} from '@smt/shared';
import { PaginationQueryDto } from '../../../common/dto/base-query.dto';

export class CreateProdLineDto {
  @ApiProperty({ description: '라인코드', example: '38' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(20)
  lineCode: string;

  @ApiProperty({ description: '라인명', example: '조립 B라인' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  lineName: string;

  @ApiProperty({ description: '라인구분', enum: LINE_DIVISION_VALUES, example: 'L' })
  @IsString()
  @IsIn([...LINE_DIVISION_VALUES])
  lineDivision: string;

  @ApiPropertyOptional({ description: '라인제품구분', enum: LINE_PRODUCT_DIVISION_VALUES, default: 'FIXED' })
  @IsOptional()
  @IsString()
  @IsIn([...LINE_PRODUCT_DIVISION_VALUES])
  lineProductDivision?: string;

  @ApiPropertyOptional({ description: '라인그룹', example: 'ASM' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  lineCodeGroup?: string;

  @ApiPropertyOptional({ description: '라인상태', enum: LINE_STATUS_VALUES, default: 'N' })
  @IsOptional()
  @IsString()
  @IsIn([...LINE_STATUS_VALUES])
  lineStatus?: string;

  @ApiPropertyOptional({ description: '용량' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  capacity?: number;

  @ApiPropertyOptional({ description: '용량단위', enum: LINE_CAPACITY_UOM_VALUES })
  @IsOptional()
  @IsString()
  @IsIn([...LINE_CAPACITY_UOM_VALUES])
  capacityUom?: string;

  @ApiPropertyOptional({ description: '시간당생산량(UPH)' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  uphValue?: number;

  @ApiPropertyOptional({ description: 'MES 표시유무', enum: USE_YN_VALUES, default: 'N' })
  @IsOptional()
  @IsString()
  @IsIn([...USE_YN_VALUES])
  mesDisplayYn?: string;

  @ApiPropertyOptional({ description: 'MES 표시순서' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  mesDisplaySequence?: number;

  @ApiPropertyOptional({ description: '활성유무 (Y=활성, N=대기)', enum: LINE_ACTIVE_YN_VALUES })
  @IsOptional()
  @IsString()
  @IsIn([...LINE_ACTIVE_YN_VALUES])
  activeYn?: string;

  @ApiPropertyOptional({ description: '설명' })
  @IsOptional()
  @IsString()
  @MaxLength(1000)
  comments?: string;
}

export class UpdateProdLineDto extends PartialType(CreateProdLineDto) {}

export class ProdLineQueryDto extends PaginationQueryDto {
  @ApiPropertyOptional({ description: '라인코드/라인명 검색어' })
  @IsOptional()
  @IsString()
  search?: string;

  @ApiPropertyOptional({ description: '라인구분', enum: LINE_DIVISION_VALUES })
  @IsOptional()
  @IsString()
  @IsIn([...LINE_DIVISION_VALUES])
  lineDivision?: string;

  @ApiPropertyOptional({ description: '활성유무', enum: LINE_ACTIVE_YN_VALUES })
  @IsOptional()
  @IsString()
  @IsIn([...LINE_ACTIVE_YN_VALUES])
  activeYn?: string;
}
