// 설비별 작업 실적관리 DTO
import { IsIn, IsInt, IsNotEmpty, IsOptional, IsString } from 'class-validator';

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
}

// 작업지시 대표불량 단일 저장 (실적과 독립)
export class DefectSaveDto {
  @IsString() @IsNotEmpty() runNo: string;
  @IsString() @IsNotEmpty() badCode: string;
  @IsInt() badQty: number;
  @IsOptional() @IsString() remark?: string;
}

export class DowntimeUpsertDto {
  @IsString() @IsNotEmpty() runNo: string;
  @IsOptional() @IsInt() dtSeq?: number; // 신규(시작)면 미지정, 종료/수정이면 지정
  @IsString() @IsNotEmpty() machineCode: string;
  @IsOptional() @IsString() workstageCode?: string;
  @IsOptional() @IsString() reasonCode?: string;
  @IsOptional() @IsString() startTime?: string; // 'YYYY-MM-DD HH24:MI'
  @IsOptional() @IsString() endTime?: string;
  @IsOptional() @IsString() memo?: string;
  @IsOptional() @IsString() worker?: string;
}
