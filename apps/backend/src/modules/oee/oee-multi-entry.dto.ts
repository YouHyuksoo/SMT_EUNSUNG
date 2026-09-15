import { Transform, Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayNotEmpty,
  IsArray,
  IsIn,
  IsInt,
  IsNotEmpty,
  IsOptional,
  ValidateIf,
  IsString,
  MaxLength,
  Min,
  ValidateNested,
} from 'class-validator';
import {
  OEE_MOBILE_PROCESS_CODES,
  OeeMobileProcessCode,
} from './oee-mobile.dto';

export const OEE_MULTI_ENTRY_PROCESS_CODES = OEE_MOBILE_PROCESS_CODES;
export type OeeMultiEntryProcessCode = OeeMobileProcessCode;

export class OeeMultiEntryStatusQueryDto {
  @ApiProperty({ enum: OEE_MULTI_ENTRY_PROCESS_CODES })
  @IsString()
  @IsNotEmpty()
  @IsIn([...OEE_MULTI_ENTRY_PROCESS_CODES])
  processCode: OeeMultiEntryProcessCode;

  @ApiProperty({ maxLength: 20 })
  @IsString()
  @IsNotEmpty()
  @MaxLength(20)
  lineCode: string;
}

export class OeeMultiEntryStartDto {
  @ApiProperty({ enum: OEE_MULTI_ENTRY_PROCESS_CODES })
  @IsString()
  @IsNotEmpty()
  @IsIn([...OEE_MULTI_ENTRY_PROCESS_CODES])
  processCode: OeeMultiEntryProcessCode;

  @ApiProperty({ type: [String], minItems: 1 })
  @IsArray()
  @ArrayNotEmpty()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  @MaxLength(20, { each: true })
  lineCodes: string[];

  @ApiProperty({ maxLength: 20 })
  @IsString()
  @IsNotEmpty()
  @MaxLength(20)
  workerId: string;

  @ApiPropertyOptional({ maxLength: 20 })
  @IsOptional()
  @IsString()
  @IsNotEmpty()
  @MaxLength(20)
  reasonCode?: string;

  @ApiPropertyOptional({ maxLength: 500 })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  memo?: string;
}

export class OeeMultiEntryEndItemDto {
  @ApiProperty({ maxLength: 20 })
  @IsString()
  @IsNotEmpty()
  @MaxLength(20)
  lineCode: string;

  @ApiProperty({ minimum: 1 })
  @Transform(({ obj }) => {
    if (typeof obj !== 'object' || obj === null) return undefined;
    return (obj as Record<string, unknown>).dtSeq;
  })
  @IsInt()
  @Min(1)
  dtSeq: number;
}

export class OeeMultiEntryEndDto {
  @ApiProperty({ enum: OEE_MULTI_ENTRY_PROCESS_CODES })
  @IsString()
  @IsNotEmpty()
  @IsIn([...OEE_MULTI_ENTRY_PROCESS_CODES])
  processCode: OeeMultiEntryProcessCode;

  @ApiProperty({ type: [OeeMultiEntryEndItemDto], minItems: 1 })
  @IsArray()
  @ArrayNotEmpty()
  @ValidateNested({ each: true })
  @Type(() => OeeMultiEntryEndItemDto)
  items: OeeMultiEntryEndItemDto[];

  @ApiPropertyOptional({ maxLength: 20 })
  @Transform(({ obj }) => {
    if (typeof obj !== 'object' || obj === null) return undefined;
    return (obj as Record<string, unknown>).reasonCode;
  })
  @ValidateIf((_, value) => value !== undefined)
  @IsString()
  @IsNotEmpty()
  @MaxLength(20)
  reasonCode?: string;
}
