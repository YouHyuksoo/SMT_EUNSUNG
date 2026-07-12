import { Transform, Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional, OmitType, PartialType } from '@nestjs/swagger';
import {
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

  @ApiProperty() @RequiredText() @MaxLength(20)
  itemCode: string;

  @ApiProperty() @RequiredText() @MaxLength(200)
  routingName: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(500)
  description?: string;

  @ApiPropertyOptional({ enum: YN_VALUES, default: 'Y' })
  @IsOptional() @IsIn(YN_VALUES)
  useYn?: 'Y' | 'N';
}

export class UpdateRoutingGroupDto extends PartialType(
  OmitType(CreateRoutingGroupDto, ['routingCode', 'itemCode'] as const),
) {}

export class RoutingGroupQueryDto extends PaginationQueryDto {
  @ApiPropertyOptional() @IsOptional() @IsString()
  search?: string;

  @ApiPropertyOptional({ enum: YN_VALUES }) @IsOptional() @IsIn(YN_VALUES)
  useYn?: 'Y' | 'N';
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
  @ApiProperty() @StrictNumber() @IsInt() @Min(1)
  fromSeq: number;

  @ApiProperty() @StrictNumber() @IsInt() @Min(1)
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
  @ApiProperty({ type: [RoutingMaterialUpsertDto] })
  @IsArray() @ValidateNested({ each: true }) @Type(() => RoutingMaterialUpsertDto)
  upserts: RoutingMaterialUpsertDto[];

  @ApiProperty({ type: [RoutingMaterialDeleteDto] })
  @IsArray() @ValidateNested({ each: true }) @Type(() => RoutingMaterialDeleteDto)
  deletes: RoutingMaterialDeleteDto[];
}
