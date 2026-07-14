/**
 * @file packages/shared/src/work-calendar/work-calendar-rules.ts
 * @description 생산월력 도메인 규칙 — 프론트(미리보기)와 백엔드(저장값)가 함께 호출한다.
 *
 * 초보자 가이드:
 * 1. HOLIDAY_YN은 DAY_TYPE의 미러다. 기존 PL/SQL F_GET_DELIVERY_DATE가 HOLIDAY_YN을 읽으므로
 *    DB CHECK 제약으로 정합이 강제되며, 애플리케이션은 holidayYnOf()로만 파생시킨다.
 * 2. 야간 교대는 자정을 넘긴다(20:00~08:00). end < start면 +24h로 계산한다.
 * 3. 공휴일 자동 반영은 양력 고정공휴일만이다. 설·추석·대체공휴일은 담당자가 수정한다.
 */
import type { ShiftTimeMasterLike, ShiftTimeSpan, WorkDayType } from './types';
/** 양력 고정공휴일 [월, 일] */
export declare const FIXED_HOLIDAYS: readonly [number, number][];
/** 교대 구간의 순근무분 = (종료 - 시작) - 휴식. 자정 넘김 처리. 음수는 0. */
export declare function shiftNetMinutes(span: ShiftTimeSpan): number;
/**
 * 근무유형별 기본 근무분.
 * OFF=0 / WORK=주간+야간 / HALF=주간÷2(내림) / SPECIAL=주간(휴일 특근은 주간 1교대)
 * 사용자가 일자편집에서 override할 수 있으며, 저장되는 값은 최종값이다.
 */
export declare function defaultWorkMinutes(dayType: WorkDayType, shift: ShiftTimeMasterLike | null): number;
/** HOLIDAY_YN은 DAY_TYPE에서 파생한다. 직접 입력받지 않는다. */
export declare function holidayYnOf(dayType: WorkDayType): 'Y' | 'N';
/** 'YYYY-MM-DD'가 양력 고정공휴일인지. 음력·대체공휴일은 포함하지 않는다. */
export declare function isFixedHoliday(isoDate: string): boolean;
//# sourceMappingURL=work-calendar-rules.d.ts.map