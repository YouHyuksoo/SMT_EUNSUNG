/**
 * @file src/modules/oee/oee.dto.ts
 * @description OEE 입력 API DTO (리소스/사유 마스터, 가동일지 저장).
 */
import {
  IsArray,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  ValidateNested,
  IsIn,
  MaxLength,
} from 'class-validator';
import { Type } from 'class-transformer';

export const OEE_PROCESS_CODES = ['SMT', 'ASSY'] as const;
export type OeeProcessCode = (typeof OEE_PROCESS_CODES)[number];

export const OEE_RESOURCE_TYPES = ['LINE', 'CELL'] as const;
export type OeeResourceType = (typeof OEE_RESOURCE_TYPES)[number];

/** OEE 리소스 마스터 신규 등록 */
export class ResourceCreateDto {
  @IsString()
  @IsNotEmpty()
  @MaxLength(50)
  lineCode: string;

  @IsString()
  @IsNotEmpty()
  @MaxLength(20)
  @IsIn([...OEE_PROCESS_CODES])
  processCode: OeeProcessCode;

  @IsString()
  @IsNotEmpty()
  @MaxLength(10)
  @IsIn([...OEE_RESOURCE_TYPES])
  resourceType: OeeResourceType;
}

/** OEE 리소스 마스터 수정 — lineCode는 기존 값과 동일해야 한다. */
export class ResourceUpdateDto extends ResourceCreateDto {
  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  resourceName: string;
}

/** OEE 비가동사유 마스터 신규/수정 */
export class ReasonUpsertDto {
  @IsString()
  @IsNotEmpty()
  reasonCode: string;

  @IsOptional()
  @IsString()
  processCode?: string;

  @IsString()
  @IsNotEmpty()
  reasonName: string;

  @IsString()
  @IsNotEmpty()
  lossBucket: string;

  @IsString()
  @IsNotEmpty()
  oeeFactor: string;

  @IsOptional()
  @IsString()
  useYn?: string;

  @IsOptional()
  @IsInt()
  sortOrder?: number;
}

/** 가동일지 구간 */
export class SaveIntervalDto {
  @IsInt()
  startMin: number;

  @IsInt()
  endMin: number;

  @IsIn(['RUN', 'DOWN'])
  status: 'RUN' | 'DOWN';

  @IsOptional()
  @IsString()
  reasonCode?: string | null;

  @IsOptional()
  @IsString()
  runNo?: string | null;

  @IsOptional()
  @IsString()
  remark?: string | null;
}

/** 근무조 가동일지 저장 (기존 replace) */
export class LogSaveDto {
  @IsInt()
  resourceId: number;

  @IsString()
  @IsNotEmpty()
  workDate: string; // YYYY-MM-DD

  @IsString()
  @IsNotEmpty()
  shift: string; // DAY/NIGHT

  @IsInt()
  netLoadMinutes: number;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SaveIntervalDto)
  intervals: SaveIntervalDto[];
}
