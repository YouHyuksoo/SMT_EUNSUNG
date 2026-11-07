// 계획 없이 검사실적을 넣는 화면(/oee/equip-inspect-result-free) DTO
import { IsIn, IsInt, IsNotEmpty, IsOptional, IsString, Matches, Max, MaxLength, Min } from 'class-validator';
import { INSPECT_VERDICTS } from './inspect-result.dto';

export class FreeInspectCreateDto {
  @IsString() @IsNotEmpty() @MaxLength(10) lineCode: string;
  @IsString() @IsNotEmpty() @MaxLength(30) machineCode: string;
  @IsString() @IsNotEmpty() @MaxLength(100) modelName: string;
  @IsString() @IsNotEmpty() @MaxLength(30) itemCode: string;
  /** 타임구간 — 작업시간 관리(ICOM_WORKTIME_RANGES WORKTIME)의 A~J */
  @Matches(/^[A-J]$/, { message: 'timeZone은 A~J 중 하나여야 합니다.' }) timeZone: string;
  @IsIn(INSPECT_VERDICTS) inspectResult: 'P' | 'R';
  @IsInt() @Min(1) @Max(1000000) inspectQty: number;
  @IsOptional() @IsString() badReasonCode?: string;
  @IsOptional() @IsString() @MaxLength(30) inspectorName?: string;
}

export class FreeInspectCancelDto {
  @IsString() @IsNotEmpty() runNo: string;
  @IsInt() @Min(1) seqNo: number;
}
