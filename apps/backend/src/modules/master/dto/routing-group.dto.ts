import { Transform, Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional, OmitType, PartialType } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  IsArray,
  IsIn,
  IsInt,
  IsNumber,
  IsNotEmpty,
  IsOptional,
  IsPositive,
  IsString,
  Matches,
  MaxLength,
  Max,
  Min,
  ValidateIf,
  ValidateNested,
} from 'class-validator';
import { PaginationQueryDto } from '../../../common/dto/base-query.dto';

const YN_VALUES = ['Y', 'N'] as const;
const EXECUTION_TYPES = ['INTERNAL', 'SUBCON'] as const;
const ISSUE_METHODS = ['BACKFLUSH', 'PRE_ISSUE'] as const;
const StrictNumber = () => Transform(({ value }) => {
  if (typeof value === 'number') return value;
  if (typeof value === 'string' && value.trim() !== '') return Number(value);
  return value;
});

const RequiredText = () => (target: object, propertyKey: string) => {
  IsString()(target, propertyKey);
  IsNotEmpty()(target, propertyKey);
  Matches(/\S/)(target, propertyKey);
};

export class CreateRoutingGroupDto {
  @ApiProperty() @RequiredText() @MaxLength(50)
  routingCode: string;

  @ApiProperty() @RequiredText() @MaxLength(200)
  routingName: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(500)
  description?: string;

  @ApiPropertyOptional({ enum: YN_VALUES, default: 'Y' })
  @IsOptional() @IsIn(YN_VALUES)
  useYn?: 'Y' | 'N';
}

export class UpdateRoutingGroupDto extends PartialType(
  OmitType(CreateRoutingGroupDto, ['routingCode'] as const),
) {}

export class RoutingGroupQueryDto extends PaginationQueryDto {
  @ApiPropertyOptional() @IsOptional() @IsString()
  search?: string;

  @ApiPropertyOptional({ enum: YN_VALUES }) @IsOptional() @IsIn(YN_VALUES)
  useYn?: 'Y' | 'N';
}

export class RoutingCandidateItemQueryDto extends PaginationQueryDto {
  @ApiPropertyOptional({ description: '품목코드·품명·모델명 검색어' }) @IsOptional() @IsString()
  search?: string;
}

export class AssignRoutingItemsDto {
  @ApiProperty({ type: [String], description: '이 라우팅을 따르게 할 품목코드' })
  @IsArray() @ArrayMaxSize(500) @IsString({ each: true }) @IsNotEmpty({ each: true }) @MaxLength(20, { each: true })
  assign: string[];

  @ApiProperty({ type: [String], description: '이 라우팅에서 뺄 품목코드' })
  @IsArray() @ArrayMaxSize(500) @IsString({ each: true }) @IsNotEmpty({ each: true }) @MaxLength(20, { each: true })
  unassign: string[];
}

export class RoutingMaterialQueryDto {
  @ApiProperty({ description: '투입자재를 보는 품목(상위 품목)' }) @RequiredText() @MaxLength(20)
  itemCode: string;
}

export class CreateRoutingProcessDto {
  @ApiProperty() @StrictNumber() @IsInt() @Min(1)
  seq: number;

  @ApiProperty() @RequiredText() @MaxLength(10)
  workstageCode: string;

  @ApiPropertyOptional({ enum: EXECUTION_TYPES, default: 'INTERNAL' })
  @IsOptional() @IsIn(EXECUTION_TYPES)
  executionType?: 'INTERNAL' | 'SUBCON';

  @ApiPropertyOptional({ enum: YN_VALUES, default: 'Y' }) @IsOptional() @IsIn(YN_VALUES)
  jobOrderYn?: 'Y' | 'N';

  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(20)
  subconSupplierCode?: string;

  @ApiPropertyOptional() @ValidateIf((_, value) => value !== undefined) @StrictNumber() @IsNumber() @Min(0)
  standardTime?: number;

  @ApiPropertyOptional() @ValidateIf((_, value) => value !== undefined) @StrictNumber() @IsNumber() @Min(0)
  setupTime?: number;

  @ApiPropertyOptional({ enum: YN_VALUES, default: 'Y' }) @IsOptional() @IsIn(YN_VALUES)
  useYn?: 'Y' | 'N';
}

export class UpdateRoutingProcessDto {
  @ApiPropertyOptional() @IsOptional() @RequiredText() @MaxLength(10)
  workstageCode?: string;

  @ApiPropertyOptional({ enum: EXECUTION_TYPES }) @IsOptional() @IsIn(EXECUTION_TYPES)
  executionType?: 'INTERNAL' | 'SUBCON';

  @ApiPropertyOptional({ enum: YN_VALUES }) @IsOptional() @IsIn(YN_VALUES)
  jobOrderYn?: 'Y' | 'N';

  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(20)
  subconSupplierCode?: string;

  @ApiPropertyOptional() @ValidateIf((_, value) => value !== undefined) @StrictNumber() @IsNumber() @Min(0)
  standardTime?: number;

  @ApiPropertyOptional() @ValidateIf((_, value) => value !== undefined) @StrictNumber() @IsNumber() @Min(0)
  setupTime?: number;

  @ApiPropertyOptional({ enum: YN_VALUES }) @IsOptional() @IsIn(YN_VALUES)
  useYn?: 'Y' | 'N';
}

export class ReorderRoutingProcessChangeDto {
  @ApiProperty() @StrictNumber() @IsInt() @Min(1) @Max(9_999_999_999)
  fromSeq: number;

  @ApiProperty() @StrictNumber() @IsInt() @Min(1) @Max(9_999_999_999)
  toSeq: number;
}

export class ReorderRoutingProcessesDto {
  @ApiProperty({ type: [ReorderRoutingProcessChangeDto] })
  @IsArray() @ValidateNested({ each: true }) @Type(() => ReorderRoutingProcessChangeDto)
  changes: ReorderRoutingProcessChangeDto[];
}

export class RoutingMaterialUpsertDto {
  @ApiProperty() @RequiredText() @MaxLength(20)
  childItemCode: string;

  @ApiProperty() @StrictNumber() @IsNumber() @IsPositive()
  allocQty: number;

  @ApiPropertyOptional({ enum: ISSUE_METHODS, default: 'BACKFLUSH' })
  @IsOptional() @IsIn(ISSUE_METHODS)
  issueMethod?: 'BACKFLUSH' | 'PRE_ISSUE';
}

export class RoutingMaterialDeleteDto {
  @ApiProperty() @RequiredText() @MaxLength(20)
  childItemCode: string;
}

export class BulkSaveRoutingMaterialDto {
  @ApiProperty({ description: '투입자재를 배정하는 품목(상위 품목). 이 라우팅을 따르는 품목이어야 한다.' })
  @RequiredText() @MaxLength(20)
  itemCode: string;

  @ApiProperty({ type: [RoutingMaterialUpsertDto] })
  @IsArray() @ValidateNested({ each: true }) @Type(() => RoutingMaterialUpsertDto)
  upserts: RoutingMaterialUpsertDto[];

  @ApiProperty({ type: [RoutingMaterialDeleteDto] })
  @IsArray() @ValidateNested({ each: true }) @Type(() => RoutingMaterialDeleteDto)
  deletes: RoutingMaterialDeleteDto[];
}
