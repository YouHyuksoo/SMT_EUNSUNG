// 설비별 검사실적관리 DTO
import { IsIn, IsInt, IsNotEmpty, IsOptional, IsString, Min } from 'class-validator';

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
}

// 검사실적 취소 — 행은 남기고 RESULT_STATUS='CANCEL'
export class InspectResultCancelDto {
  @IsString() @IsNotEmpty() runNo: string;
  @IsInt() @Min(1) seqNo: number;
}
