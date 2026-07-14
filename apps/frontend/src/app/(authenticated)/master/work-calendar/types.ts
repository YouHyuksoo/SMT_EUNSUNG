/**
 * @file master/work-calendar/types.ts
 * @description 생산월력 화면 타입 (백엔드 IP_ 모델 응답과 1:1)
 */
import type { WorkDayType } from "@smt/shared";

export type { WorkDayType };

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
}

/** GET /master/shift-times 응답 1건 */
export interface ShiftTimeItem {
  dateset: string;
  dateend: string | null;
  dayTimeStart: string | null;
  dayTimeEnd: string | null;
  dayBreakMinutes: number;
  nightTimeStart: string | null;
  nightTimeEnd: string | null;
  nightBreakMinutes: number;
}

/** 연간 요약 */
export interface WorkCalendarSummary {
  workDays: number;
  offDays: number;
  halfDays: number;
  specialDays: number;
  totalMinutes: number;
}
