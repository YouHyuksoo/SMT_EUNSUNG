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
} from 'class-validator';
import { Type } from 'class-transformer';

/** OEE 리소스 마스터 신규/수정 */
export class ResourceUpsertDto {
  @IsOptional()
  @IsInt()
  resourceId?: number; // 있으면 수정

  @IsInt()
  organizationId: number;

  @IsString()
  @IsNotEmpty()
  processCode: string;

  @IsString()
  @IsNotEmpty()
  resourceType: string;

  @IsOptional()
  @IsString()
  refCode?: string | null;

  @IsString()
  @IsNotEmpty()
  resourceName: string;

  @IsOptional()
  idealCt?: number | null;

  @IsOptional()
  @IsString()
  useYn?: string;

  @IsOptional()
  @IsInt()
  sortOrder?: number;
}

/** OEE 비가동사유 마스터 신규/수정 */
export class ReasonUpsertDto {
  @IsString()
  @IsNotEmpty()
  reasonCode: string;

  @IsInt()
  organizationId: number;

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
  organizationId: number;

  @IsInt()
  resourceId: number;

  @IsString()
  @IsNotEmpty()
  processCode: string;

  @IsString()
  @IsNotEmpty()
  workDate: string; // YYYY-MM-DD

  @IsString()
  @IsNotEmpty()
  shift: string; // DAY/NIGHT

  @IsInt()
  netLoadMinutes: number;

  @IsString()
  @IsNotEmpty()
  createdBy: string; // 작업자 사번

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SaveIntervalDto)
  intervals: SaveIntervalDto[];
}
