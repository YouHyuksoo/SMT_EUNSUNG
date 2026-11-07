// 설비별 검사실적관리 DTO
import { IsIn, IsInt, IsNotEmpty, IsOptional, IsString, Matches, Min } from 'class-validator';

/** 판정 코드 — ISYS_BASECODE 'INSPECT RESULT' 중 P=합격, R=불합격 만 쓴다 */
export const INSPECT_VERDICTS = ['P', 'R'] as const;

export class InspectResultCreateDto {
  @IsString() @IsNotEmpty() runNo: string;
  @IsString() @IsNotEmpty() machineCode: string;
  @IsIn(INSPECT_VERDICTS) inspectResult: 'P' | 'R';
  @IsInt() @Min(1) inspectQty: number;
  /** 불량원인 (ISYS_CODE_MASTER 'WQC BAD REASON CODE') — 불합격이면 필수, 합격이면 넣지 않는다 */
  @IsOptional() @IsString() badReasonCode?: string;
  @IsOptional() @IsString() inspectorName?: string;
  /** 타임구간 A~J (작업시간 관리 WORKTIME) — 계획 없는 검사실적 화면이 보낸다. 설비별 검사실적관리 화면은 보내지 않는다 */
  @IsOptional() @Matches(/^[A-J]$/, { message: 'timeZone은 A~J 중 하나여야 합니다.' }) timeZone?: string;
}

// 검사실적 취소 — 행은 남기고 RESULT_STATUS='CANCEL'
export class InspectResultCancelDto {
  @IsString() @IsNotEmpty() runNo: string;
  @IsInt() @Min(1) seqNo: number;
}
