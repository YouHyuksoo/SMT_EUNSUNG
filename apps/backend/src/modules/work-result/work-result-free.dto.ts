// 계획 없이 실적을 넣는 화면(/oee/equip-work-result-free) DTO
import { IsInt, IsNotEmpty, IsOptional, IsString, Matches, Max, MaxLength, Min } from 'class-validator';

export class FreeResultCreateDto {
  @IsString() @IsNotEmpty() @MaxLength(10) lineCode: string;
  @IsString() @IsNotEmpty() @MaxLength(20) workstageCode: string;
  @IsString() @IsNotEmpty() @MaxLength(30) machineCode: string;
  @IsString() @IsNotEmpty() @MaxLength(100) modelName: string;
  @IsString() @IsNotEmpty() @MaxLength(30) itemCode: string;
  /** 타임구간 — 작업시간 관리(ICOM_WORKTIME_RANGES WORKTIME)의 A~J */
  @Matches(/^[A-J]$/, { message: 'timeZone은 A~J 중 하나여야 합니다.' }) timeZone: string;
  @IsInt() @Min(1) @Max(1000000) resultQty: number;
  @IsOptional() @IsInt() @Min(0) workTime?: number;
  @IsOptional() @IsInt() @Min(0) workerCount?: number;
  @IsString() @IsNotEmpty() @MaxLength(30) workerName: string;
}

export class FreeResultCancelDto {
  @IsString() @IsNotEmpty() runNo: string;
  @IsString() @IsNotEmpty() seqNo: string;
}
