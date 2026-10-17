// 설비별 작업 실적관리 DTO
import {
  ArrayNotEmpty,
  IsArray,
  IsBoolean,
  IsIn,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  Matches,
} from 'class-validator';

export class WorkResultUpsertDto {
  @IsString() @IsNotEmpty() runNo: string;
  @IsOptional() @IsString() seqNo?: string; // 신규면 미지정(서버 생성), 수정이면 지정
  @IsOptional() @IsString() machineCode?: string;
  @IsString() @IsNotEmpty() workstageCode: string;
  @IsInt() resultQty: number;
  @IsOptional() @IsInt() workTime?: number;
  @IsOptional() @IsInt() workerCount?: number;
  @IsOptional() @IsString() workerName?: string;
  @IsIn(['WIP', 'DONE']) resultStatus: string;
}

// 생산실적(조립실적) 반영 재시도 — 완료 상태인데 반영이 실패한 실적 대상
export class ApplySensorDto {
  @IsString() @IsNotEmpty() runNo: string;
  @IsString() @IsNotEmpty() seqNo: string;
}

// 실적 취소 — 행은 남기고 RESULT_STATUS='CANCEL', 센서 누적에서는 그 수량을 뺀다
export class CancelResultDto {
  @IsString() @IsNotEmpty() runNo: string;
  @IsString() @IsNotEmpty() seqNo: string;
}

// 작업지시 대표불량 단일 저장 (실적과 독립)
export class DefectSaveDto {
  @IsString() @IsNotEmpty() runNo: string;
  @IsString() @IsNotEmpty() badCode: string;
  @IsInt() badQty: number;
  @IsOptional() @IsString() remark?: string;
}

// 설비 비가동 시작·종료 — 비가동을 쓰는 유일한 입력 (ADR 0002·0003, 이미 그 상태인 설비는 건너뛴다)
export class DowntimeBulkDto {
  @IsIn(['START', 'END']) action: string;
  @IsOptional() @IsString() lineCode?: string;   // 라인의 비가동 대상 설비 전부
  @IsOptional() @IsArray() @IsString({ each: true }) machineCodes?: string[]; // 설비 직접 지정 (1대도 이걸로)
  @IsOptional() @IsString() runNo?: string; // 비가동이 일어난 작업지시(선택 맥락)
  @IsOptional() @IsString() reasonCode?: string; // 종료 때 없으면 시작 사유 유지, 그것도 없으면 거절
  @IsOptional() @IsString() memo?: string;
  @IsOptional() @IsString() worker?: string;
  @IsOptional() @IsString() userId?: string;
}

/**
 * 계획 비가동 일괄 등록 — 체크한 일자 x 선택한 설비에 같은 사유·시간을 적용한다.
 * 자정 넘김은 허용하지 않는다(종료는 반드시 시작보다 늦다) — 화면과 서버 양쪽에서 막는다.
 */
export class PlanDowntimeCreateDto {
  @IsArray() @ArrayNotEmpty() @IsString({ each: true }) machineCodes: string[];

  @IsString() @IsNotEmpty() reasonCode: string;

  /** 대상 일자 'YYYY-MM-DD' 목록 */
  @IsArray()
  @ArrayNotEmpty()
  @Matches(/^\d{4}-\d{2}-\d{2}$/, { each: true, message: 'dates는 YYYY-MM-DD 형식이어야 합니다.' })
  dates: string[];

  @Matches(/^([01]\d|2[0-3]):[0-5]\d$/, { message: 'startHm은 HH:MM 형식이어야 합니다.' })
  startHm: string;

  @Matches(/^([01]\d|2[0-3]):[0-5]\d$/, { message: 'endHm은 HH:MM 형식이어야 합니다.' })
  endHm: string;

  @IsOptional() @IsString() userId?: string;
}
