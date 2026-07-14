/**
 * @file src/modules/master/dto/part.dto.ts
 * @description ID_ITEM 품목 API DTO
 */

import { ApiProperty, ApiPropertyOptional, PartialType } from '@nestjs/swagger';
import { IsString, IsOptional, IsInt, IsNumber, Min, Max, MaxLength, IsIn, IsBoolean, IsArray, IsNotEmpty } from 'class-validator';
import { Type, Transform } from 'class-transformer';
import { USE_YN_VALUES } from '@smt/shared';
import { PaginationQueryDto } from '../../../common/dto/base-query.dto';

export class CreatePartDto {
  @ApiProperty({ description: '품목 코드', example: 'P-001' })
  @IsString()
  @MaxLength(50)
  itemCode: string;

  @ApiProperty({ description: '품목명', example: '전선 A타입' })
  @IsString()
  @MaxLength(200)
  itemName: string;

  @ApiProperty({ description: 'ID_ITEM.ITEM_TYPE', example: 'T' })
  @IsString()
  @MaxLength(10)
  itemType: string;

  @ApiProperty({ description: '품번 (Part Number)', example: 'WIRE-AWG18-R' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  itemNo: string;

  @ApiPropertyOptional({ description: '고객사 품번', example: 'HMC-001' })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  custPartNo?: string;

  @ApiProperty({ description: 'ID_ITEM.ITEM_CLASS', example: 'PCB' })
  @IsNotEmpty()
  @IsString()
  @MaxLength(20)
  itemClass: string;

  @ApiPropertyOptional({ description: '차종', example: 'CN7' })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  modelName?: string;

  @ApiPropertyOptional({ description: 'ID_ITEM.MODEL_SUFFIX', example: '*' })
  @IsOptional()
  @IsString()
  @MaxLength(50)
  modelSuffix?: string;

  @ApiPropertyOptional({ description: '규격' })
  @IsOptional()
  @IsString()
  @MaxLength(200)
  spec?: string;

  @ApiPropertyOptional({ description: '리비전', example: 'A' })
  @IsOptional()
  @IsString()
  @MaxLength(10)
  rev?: string;

  @ApiPropertyOptional({ description: '마킹 문구', example: 'HNS-001' })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  markingText?: string;

  @ApiPropertyOptional({ description: 'ID_ITEM.ITEM_UOM', default: 'EA' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  itemUom?: string;

  @ApiPropertyOptional({ description: '색상' })
  @IsOptional()
  @IsString()
  @MaxLength(50)
  color?: string;

  @ApiPropertyOptional({ description: '도면 번호' })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  drawNo?: string;

  @ApiPropertyOptional({ description: '리드타임 (일)', default: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  leadTime?: number;

  @ApiPropertyOptional({ description: '안전재고', default: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  safetyStock?: number;

  @ApiPropertyOptional({ description: 'LOT 단위수량' })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  lotUnitQty?: number;

  @ApiPropertyOptional({ description: '박스 입수량', default: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  boxQty?: number;

  @ApiPropertyOptional({ description: '최소포장단위 수량', default: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  minPackQty?: number;

  @ApiPropertyOptional({ description: '택타임 (초)', default: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  tactTime?: number;

  @ApiPropertyOptional({ description: '유효기간 (일)', default: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  expiryDate?: number;

  @ApiPropertyOptional({ description: '유효기간 연장 최대 일수', default: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  expiryExtDays?: number;

  @ApiPropertyOptional({ description: 'PO 수량 오차 허용률 (%)', default: 5.0, minimum: 0, maximum: 100 })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  @Max(100)
  toleranceRate?: number;

  @ApiPropertyOptional({ description: '자재 분할 가능 여부', default: 'Y', enum: USE_YN_VALUES })
  @IsOptional()
  @IsString()
  @IsIn([...USE_YN_VALUES])
  isSplittable?: string;

  @ApiPropertyOptional({ description: '팔레트 구성 단위(팔레트당 박스 수)', example: 40 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  packUnit?: number;

  @ApiPropertyOptional({ description: '적재 로케이션', example: 'A-01-02' })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  storageLocation?: string;

  @ApiPropertyOptional({ description: '품목 이미지 URL' })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  imageUrl?: string;

  @ApiPropertyOptional({ description: '비고' })
  @IsOptional()
  @IsString()
  @MaxLength(4000)
  remark?: string;

  @ApiPropertyOptional({ description: '사용 여부', default: 'Y', enum: USE_YN_VALUES })
  @IsOptional()
  @IsString()
  @IsIn([...USE_YN_VALUES])
  mesDisplayYn?: string;
}

export class UpdatePartDto extends PartialType(CreatePartDto) {}

export class PartQueryDto extends PaginationQueryDto {


  @ApiPropertyOptional({ description: 'ID_ITEM.ITEM_TYPE' })
  @IsOptional()
  @IsString()
  itemType?: string;

  @ApiPropertyOptional({ description: 'ID_ITEM.ITEM_TYPE 다중 필터 (콤마 구분)', example: 'T,S' })
  @IsOptional()
  @Transform(({ value }) =>
    typeof value === 'string'
      ? value.split(',').map((v) => v.trim()).filter(Boolean)
      : value,
  )
  @IsArray()
  itemTypes?: string[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  search?: string;

  @ApiPropertyOptional({ enum: USE_YN_VALUES })
  @IsOptional()
  @IsString()
  @IsIn([...USE_YN_VALUES])
  mesDisplayYn?: string;

}
