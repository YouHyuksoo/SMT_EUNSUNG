import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional, OmitType, PartialType } from '@nestjs/swagger';
import {
  IsArray,
  IsIn,
  IsInt,
  IsNumber,
  IsOptional,
  IsPositive,
  IsString,
  MaxLength,
  Min,
  ValidateNested,
} from 'class-validator';
import { PaginationQueryDto } from '../../../common/dto/base-query.dto';

const YN_VALUES = ['Y', 'N'] as const;
const EXECUTION_TYPES = ['INTERNAL', 'SUBCON'] as const;
const ISSUE_METHODS = ['BACKFLUSH', 'PRE_ISSUE'] as const;

export class CreateRoutingGroupDto {
  @ApiProperty() @IsString() @MaxLength(50)
  routingCode: string;

  @ApiProperty() @IsString() @MaxLength(20)
  itemCode: string;

  @ApiProperty() @IsString() @MaxLength(200)
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
  @ApiProperty() @Type(() => Number) @IsInt() @Min(1)
  seq: number;

  @ApiProperty() @IsString() @MaxLength(10)
  workstageCode: string;

  @ApiPropertyOptional({ enum: EXECUTION_TYPES, default: 'INTERNAL' })
  @IsOptional() @IsIn(EXECUTION_TYPES)
  executionType?: 'INTERNAL' | 'SUBCON';

  @ApiPropertyOptional({ enum: YN_VALUES, default: 'Y' }) @IsOptional() @IsIn(YN_VALUES)
  jobOrderYn?: 'Y' | 'N';

  @ApiPropertyOptional() @IsOptional() @IsString() @MaxLength(20)
  subconSupplierCode?: string;

  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() @Min(0)
  standardTime?: number;

  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() @Min(0)
  setupTime?: number;

  @ApiPropertyOptional({ enum: YN_VALUES, default: 'Y' }) @IsOptional() @IsIn(YN_VALUES)
  useYn?: 'Y' | 'N';
}

export class UpdateRoutingProcessDto extends PartialType(
  OmitType(CreateRoutingProcessDto, ['seq'] as const),
) {}

export class ReorderRoutingProcessChangeDto {
  @ApiProperty() @Type(() => Number) @IsInt() @Min(1)
  fromSeq: number;

  @ApiProperty() @Type(() => Number) @IsInt() @Min(1)
  toSeq: number;
}

export class ReorderRoutingProcessesDto {
  @ApiProperty({ type: [ReorderRoutingProcessChangeDto] })
  @IsArray() @ValidateNested({ each: true }) @Type(() => ReorderRoutingProcessChangeDto)
  changes: ReorderRoutingProcessChangeDto[];
}

export class RoutingMaterialUpsertDto {
  @ApiProperty() @IsString() @MaxLength(20)
  childItemCode: string;

  @ApiProperty() @Type(() => Number) @IsNumber() @IsPositive()
  allocQty: number;

  @ApiPropertyOptional({ enum: ISSUE_METHODS, default: 'BACKFLUSH' })
  @IsOptional() @IsIn(ISSUE_METHODS)
  issueMethod?: 'BACKFLUSH' | 'PRE_ISSUE';
}

export class RoutingMaterialDeleteDto {
  @ApiProperty() @IsString() @MaxLength(20)
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
