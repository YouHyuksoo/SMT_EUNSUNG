/**
 * @file master/work-calendar/types.ts
 * @description 생산월력 화면 타입 (백엔드 IP_ 모델 응답과 1:1)
 */
import type { CalendarBreak, CalendarShift, WorkDayType } from "@smt/shared";

export type { CalendarBreak, CalendarShift, WorkDayType };

/** GET /master/work-calendar/days 응답 1건 */
export interface WorkCalendarDay {
  workDate: string;
  dayType: WorkDayType;
  offReason: string | null;
  workMinutes: number;
  otMinutes: number;
  comment: string | null;
  confirmYn: "Y" | "N";
  /** 라인 예외 행이 이겼는지 */
  source: "COMPANY" | "LINE";
  /** 그 일자에 저장된 교대조 작업시간. 비어 있으면 교대시간 마스터를 따른다. */
  shifts: CalendarShift[];
  /** 그 일자에 저장된 비작업(휴게/식사) 시간. 비어 있으면 0분. */
  breaks: CalendarBreak[];
}

/** 교대시간 마스터의 슬롯별 비작업 시간 1건 (IP_SHIFT_TIME_BREAK) */
export interface ShiftTimeBreakItem {
  /** 공통코드 'BREAK TYPE' (REST=휴게시간, MEAL=식사시간) */
  breakType: string;
  breakMinutes: number;
}

/** GET /master/shift-times 응답 1건 */
export interface ShiftTimeItem {
  dateset: string;
  dateend: string | null;
  dayTimeStart: string | null;
  dayTimeEnd: string | null;
  /** 주간 비작업분 합 — dayBreaks의 롤업이라 직접 입력하지 않는다. */
  dayBreakMinutes: number;
  nightTimeStart: string | null;
  nightTimeEnd: string | null;
  /** 야간 비작업분 합 — nightBreaks의 롤업. */
  nightBreakMinutes: number;
  dayBreaks: ShiftTimeBreakItem[];
  nightBreaks: ShiftTimeBreakItem[];
}

/** 연간 요약 */
export interface WorkCalendarSummary {
  workDays: number;
  offDays: number;
  halfDays: number;
  specialDays: number;
  totalMinutes: number;
}

/** GET /oee/equip-ops/machines 응답 중 이 화면이 쓰는 필드 */
export interface PlanMachine {
  machineCode: string;
  machineName: string | null;
  lineCode: string | null;
}

/** GET /oee/equip-ops/lines */
export interface PlanLine {
  lineCode: string;
  lineName: string | null;
  machineCount: number;
}

/** 비가동 사유 (REASON_TYPE='PLAN') */
export interface PlanReason {
  code: string;
  name: string;
}

/** GET /oee/work-result/downtimes/plan 응답 1건 */
export interface PlanDowntime {
  dtSeq: number;
  machineCode: string;
  machineName: string | null;
  reasonCode: string;
  reasonName: string | null;
  /** 'YYYY-MM-DD' */
  planDate: string;
  startHm: string;
  endHm: string;
}
