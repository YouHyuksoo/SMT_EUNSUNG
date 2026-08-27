// 설비별 작업 실적관리 DTO
import { IsArray, IsBoolean, IsIn, IsInt, IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class WorkResultUpsertDto {
  @IsString() @IsNotEmpty() runNo: string;
  @IsOptional() @IsString() seqNo?: string; // 신규면 미지정(서버 생성), 수정이면 지정
  @IsString() @IsNotEmpty() machineCode: string;
  @IsString() @IsNotEmpty() workstageCode: string;
  @IsInt() resultQty: number;
  @IsOptional() @IsInt() workTime?: number;
  @IsOptional() @IsInt() workerCount?: number;
  @IsOptional() @IsString() workerName?: string;
  @IsIn(['WIP', 'DONE']) resultStatus: string;
  @IsOptional() @IsString() userId?: string;
}

// 작업지시 대표불량 단일 저장 (실적과 독립)
export class DefectSaveDto {
  @IsString() @IsNotEmpty() runNo: string;
  @IsString() @IsNotEmpty() badCode: string;
  @IsInt() badQty: number;
  @IsOptional() @IsString() remark?: string;
  @IsOptional() @IsString() userId?: string;
}

// 라인/설비 일괄 비가동 시작·종료 (ADR 0002 — 이미 그 상태인 설비는 건너뛴다)
export class DowntimeBulkDto {
  @IsIn(['START', 'END']) action: string;
  @IsOptional() @IsString() lineCode?: string;   // 라인 전체 대상
  @IsOptional() @IsArray() @IsString({ each: true }) machineCodes?: string[]; // 설비 직접 지정
  @IsOptional() @IsString() reasonCode?: string; // 종료 시 필수, 시작 시 선택
  @IsOptional() @IsString() memo?: string;
  @IsOptional() @IsString() worker?: string;
  @IsOptional() @IsString() userId?: string;
}

export class DowntimeUpsertDto {
  @IsOptional() @IsString() runNo?: string; // 작업지시 없이 발생한 비가동은 미지정
  @IsOptional() @IsInt() dtSeq?: number; // 신규(시작)면 미지정, 종료/수정이면 지정
  @IsString() @IsNotEmpty() machineCode: string;
  @IsOptional() @IsString() workstageCode?: string;
  @IsOptional() @IsString() reasonCode?: string;
  @IsOptional() @IsString() startTime?: string; // 'YYYY-MM-DD HH24:MI'
  @IsOptional() @IsString() endTime?: string;
  @IsOptional() @IsBoolean() endNow?: boolean; // true면 종료시각을 DB 현재시각(SYSDATE)으로 — 시작(SYSDATE)과 동일 시계
  @IsOptional() @IsString() memo?: string;
  @IsOptional() @IsString() worker?: string;
  @IsOptional() @IsString() userId?: string;
}
