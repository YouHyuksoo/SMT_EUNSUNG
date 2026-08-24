import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsIn,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  MaxLength,
  Min,
  MinLength,
} from 'class-validator';

export const OEE_MOBILE_PROCESS_CODES = ['SMT', 'ASSY'] as const;
export type OeeMobileProcessCode = (typeof OEE_MOBILE_PROCESS_CODES)[number];

export const OEE_MOBILE_RESOURCE_TYPES = ['LINE', 'CELL'] as const;
export type OeeMobileResourceType = (typeof OEE_MOBILE_RESOURCE_TYPES)[number];

export interface OeeMobileResource {
  processCode: OeeMobileProcessCode;
  resourceType: OeeMobileResourceType;
  resourceCode: string;
  resourceName: string;
  parentLineCode: string | null;
}

export interface OeeMobileReason {
  reasonCode: string;
  reasonName: string;
}

export class OeeMobileResourcesQueryDto {
  @ApiProperty({ enum: OEE_MOBILE_PROCESS_CODES })
  @IsString()
  @IsNotEmpty()
  @IsIn([...OEE_MOBILE_PROCESS_CODES])
  processCode: OeeMobileProcessCode;
}

export class OeeMobileReasonsQueryDto {
  // Keep class-validator in whitelist/forbidNonWhitelisted mode for an empty query contract.
  @IsOptional()
  @IsString()
  private readonly _validationMarker?: string;
}

export class OeeMobileStatusQueryDto {
  @ApiProperty({ enum: OEE_MOBILE_PROCESS_CODES })
  @IsString()
  @IsNotEmpty()
  @MaxLength(20)
  @IsIn([...OEE_MOBILE_PROCESS_CODES])
  processCode: OeeMobileProcessCode;

  @ApiProperty({ enum: OEE_MOBILE_RESOURCE_TYPES })
  @IsString()
  @IsNotEmpty()
  @MaxLength(10)
  @IsIn([...OEE_MOBILE_RESOURCE_TYPES])
  resourceType: OeeMobileResourceType;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  @MaxLength(50)
  resourceCode: string;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  @MaxLength(50)
  parentLineCode: string;
}

export class OeeMobileStartDowntimeDto {
  @ApiProperty({ enum: OEE_MOBILE_PROCESS_CODES })
  @IsString()
  @IsNotEmpty()
  @MaxLength(20)
  @IsIn([...OEE_MOBILE_PROCESS_CODES])
  processCode: OeeMobileProcessCode;

  @ApiProperty({ enum: OEE_MOBILE_RESOURCE_TYPES })
  @IsString()
  @IsNotEmpty()
  @MaxLength(10)
  @IsIn([...OEE_MOBILE_RESOURCE_TYPES])
  resourceType: OeeMobileResourceType;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  @MaxLength(50)
  resourceCode: string;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  @MaxLength(50)
  parentLineCode: string;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  @MaxLength(20)
  workerId: string;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  reasonCode: string;

  @ApiPropertyOptional({ maxLength: 500 })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  memo?: string;

  @ApiProperty({ minLength: 1, maxLength: 64 })
  @IsString()
  @IsNotEmpty()
  @MinLength(1)
  @MaxLength(64)
  requestId: string;
}

export class OeeMobileEndDowntimeDto {
  @ApiProperty({ minimum: 1 })
  @IsInt()
  @Min(1)
  eventId: number;

  @ApiProperty({ minLength: 1, maxLength: 64 })
  @IsString()
  @IsNotEmpty()
  @MinLength(1)
  @MaxLength(64)
  requestId: string;
}
