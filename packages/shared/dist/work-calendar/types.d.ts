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
/** IP_SHIFT_TIME_MASTER 한 행이 제공하는 2교대 시간 */
export interface ShiftTimeMasterLike {
    dayTimeStart: string | null;
    dayTimeEnd: string | null;
    dayBreakMinutes: number;
    nightTimeStart: string | null;
    nightTimeEnd: string | null;
    nightBreakMinutes: number;
}
//# sourceMappingURL=types.d.ts.map