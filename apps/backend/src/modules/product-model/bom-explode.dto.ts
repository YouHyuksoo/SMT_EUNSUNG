// 제품 모델 BOM 전개 방식 DTO
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ArrayMaxSize, IsArray, IsIn, IsOptional, IsString, Length } from 'class-validator';

export const BOM_EXPLODE_TYPES = ['TB', 'SUB', 'NEST', 'SINGLE', 'RAW', 'NONE'] as const;

export class UpdateBomExplodeDto {
  @ApiProperty({ description: '모델명 (IP_PRODUCT_MODEL_MASTER 키)' })
  @IsString() @Length(1, 100)
  modelName!: string;

  @ApiProperty({ description: 'BOM 전개 방식 (공통코드 BOM EXPLODE TYPE)', enum: BOM_EXPLODE_TYPES })
  @IsIn(BOM_EXPLODE_TYPES as unknown as string[])
  bomExplodeType!: string;

  @ApiPropertyOptional({ description: 'AOI T면 실적이 만드는 품목' })
  @IsOptional() @IsString() @Length(0, 30)
  topItemCode?: string;

  @ApiPropertyOptional({ description: 'AOI B면 실적이 만드는 품목' })
  @IsOptional() @IsString() @Length(0, 30)
  bottomItemCode?: string;

  @ApiPropertyOptional({ description: 'SUB 공정 품목 (SUB-Assy, INSERT_ITEM_CODE)' })
  @IsOptional() @IsString() @Length(0, 30)
  subItemCode?: string;
}

export class ClassifyBomExplodeDto {
  @ApiPropertyOptional({ description: '이 모델(MODEL_NAME)만 분류한다. 없으면 전체', type: [String] })
  @IsOptional() @IsArray() @ArrayMaxSize(1000) @IsString({ each: true })
  modelNames?: string[];
}

export class BomExplodeModelQueryDto {
  @ApiProperty({ description: '모델명' })
  @IsString() @Length(1, 100)
  modelName!: string;
}
