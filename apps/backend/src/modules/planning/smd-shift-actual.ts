/**
 * @file src/modules/planning/smd-shift-actual.ts
 * @description 반제품생산계획 계획별 주간·야간 실적 규칙.
 *
 * 초보자 가이드:
 * 1. **주간/야간은 센서 시간구분(TIME_DIVISION)으로 나눈다.** 센서 프로시저가
 *    ICOM_WORKTIME_RANGES(SMTWORKTIME) 구간으로 A~J 를 찍는다.
 *    A~E = 08:30~20:30(주간), F~J = 20:30~다음날 08:30(야간).
 *    RECEIPT_DATE 는 이미 08:30 기준 업무일이라 야간 실적도 계획일과 같은 날짜로 들어온다.
 *    'Z'(구간 조회 실패)와 빈 값은 어느 근무조에도 넣지 않는다.
 * 2. **실적 = 수기가 있으면 수기, 없으면 자동.** 근무조별로 따로 고른다.
 * 3. **주간 잔량 = 계획 − 주간 실적, 야간 잔량 = 계획 − 주간 실적 − 야간 실적.**
 *    음수(초과 생산)도 그대로 보여 준다.
 */

/** 주간 시간구분 (08:30~20:30) */
export const DAY_TIME_DIVISIONS = ['A', 'B', 'C', 'D', 'E'] as const;
/** 야간 시간구분 (20:30~다음날 08:30) */
export const NIGHT_TIME_DIVISIONS = ['F', 'G', 'H', 'I', 'J'] as const;

/** SQL IN 목록 — 상수에서 만든다(문자 하나씩이라 바인드 없이 넣어도 안전하다). */
export const sqlInList = (values: readonly string[]) => values.map((v) => `'${v}'`).join(', ');

export interface ShiftActualSource {
  planQty: number | string | null;
  dayAutoQty: number | string | null;
  nightAutoQty: number | string | null;
  dayManualQty: number | string | null;
  nightManualQty: number | string | null;
}

export interface ShiftActualResult {
  dayActualQty: number;
  nightActualQty: number;
  dayRemainQty: number;
  nightRemainQty: number;
}

const toNumber = (value: number | string | null | undefined) => {
  if (value === null || value === undefined || value === '') return null;
  const n = Number(value);
  return Number.isFinite(n) ? n : null;
};

/** 근무조 실적(수기 우선)과 잔량을 계산한다. */
export function computeShiftActual(row: ShiftActualSource): ShiftActualResult {
  const planQty = toNumber(row.planQty) ?? 0;
  const dayActualQty = toNumber(row.dayManualQty) ?? toNumber(row.dayAutoQty) ?? 0;
  const nightActualQty = toNumber(row.nightManualQty) ?? toNumber(row.nightAutoQty) ?? 0;
  return {
    dayActualQty,
    nightActualQty,
    dayRemainQty: planQty - dayActualQty,
    nightRemainQty: planQty - dayActualQty - nightActualQty,
  };
}
