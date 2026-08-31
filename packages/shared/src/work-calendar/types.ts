/**
 * @file packages/shared/src/work-calendar/types.ts
 * @description 생산월력 공유 타입 (IP_ 월력 모델)
 */

/** 근무유형 — 공통코드 WORK_DAY_TYPE */
export type WorkDayType = 'WORK' | 'OFF' | 'HALF' | 'SPECIAL';

/** 단일 교대 구간 */
export interface ShiftTimeSpan {
  /** 'HH:MM' 또는 'HH:MM:SS' */
  start: string;
  /** 'HH:MM' 또는 'HH:MM:SS'. start보다 이르면 자정을 넘긴 것으로 본다. */
  end: string;
  breakMinutes: number;
}

/** 일자별 교대조 작업시간 1건 (IP_PRODUCT_CALENDAR_SHIFT) */
export interface CalendarShift {
  /** 공통코드 'SHIFT CODE' (A=1교대, B=2교대) */
  shiftCode: string;
  /** 'HH:MM'. end가 start보다 이르면 자정을 넘긴 것으로 본다. */
  startTime: string;
  endTime: string;
}

/** 일자별 비작업 시간 1건 (IP_PRODUCT_CALENDAR_BREAK) */
export interface CalendarBreak {
  /** 공통코드 'BREAK TYPE' (REST=휴게시간, MEAL=식사시간) */
  breakType: string;
  breakMinutes: number;
}

/** IP_SHIFT_TIME_MASTER 한 행이 제공하는 2교대 시간 */
export interface ShiftTimeMasterLike {
  dayTimeStart: string | null;
  dayTimeEnd: string | null;
  dayBreakMinutes: number;
  nightTimeStart: string | null;
  nightTimeEnd: string | null;
  nightBreakMinutes: number;
}
