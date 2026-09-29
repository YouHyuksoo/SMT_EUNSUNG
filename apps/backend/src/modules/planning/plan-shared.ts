/**
 * @file src/modules/planning/plan-shared.ts
 * @description 제품생산계획(MI)·반제품생산계획(SMD)이 함께 쓰는 규칙.
 *
 * 두 화면은 테이블만 다르고(IP_PRODUCT_MI_PLAN / IP_PRODUCT_SMD_PLAN)
 * 키·시간대 구조·조회조건이 같다. 규칙을 한 곳에 두고 두 서비스가 호출한다 —
 * 같은 조건을 두 서비스에 복붙하면 한쪽만 고쳐지는 일이 생긴다.
 *
 * 초보자 가이드:
 * 1. **키는 PLAN_DATE + PLAN_SEQUENCE + ORGANIZATION_ID 다.** 모델이나 라인이
 *    아니다. 같은 날 같은 라인에 같은 모델을 두 번 계획할 수 있다.
 * 2. **시간대는 10칸이다.** PLAN_TIME1..10 이 수량, TIME1_DESC..10 이 그 칸의
 *    메모다. 실적은 뷰(IP_PRODUCT_ACTUAL_TIME_V / IP_ASSEMBLY_ACTUAL_TIME_V)의
 *    A_TIME_ACTUAL..J_TIME_ACTUAL 열 개와 1:1로 대응한다 (A=1칸 … J=10칸).
 * 3. **월 계획 테이블은 다루지 않는다.** IP_PRODUCT_MI_MONTH_PLAN 과
 *    IP_PRODUCT_SMD_MONTH_PLAN 이 둘 다 0행이다 — 은성에서 쓴 적이 없다.
 */

/** 시간대 칸 수. PB DataWindow 가 10칸 고정이다. */
export const TIME_SLOTS = 10;

/** 실적 뷰의 시간대 컬럼 접두어. A(1칸) … J(10칸). */
const ACTUAL_PREFIX = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];

/** `p.PLAN_TIME1 AS "planTime1", …` 10칸을 만든다. */
export function planTimeColumns(alias: string): string {
  return Array.from(
    { length: TIME_SLOTS },
    (_, i) => `${alias}.PLAN_TIME${i + 1} AS "planTime${i + 1}"`,
  ).join(', ');
}

/** `p.TIME1_DESC AS "time1Desc", …` 10칸을 만든다. */
export function timeDescColumns(alias: string): string {
  return Array.from(
    { length: TIME_SLOTS },
    (_, i) => `${alias}.TIME${i + 1}_DESC AS "time${i + 1}Desc"`,
  ).join(', ');
}

/** `v.A_TIME_ACTUAL AS "actualTime1", …` 10칸을 만든다. */
export function actualTimeColumns(alias: string): string {
  return ACTUAL_PREFIX.map(
    (p, i) => `${alias}.${p}_TIME_ACTUAL AS "actualTime${i + 1}"`,
  ).join(', ');
}

/** 계획 시간대 10칸의 합. PB 가 컬럼식으로 더하던 PLAN_QTY_CALC 다. */
export function planTimeSumExpression(alias: string): string {
  return Array.from({ length: TIME_SLOTS }, (_, i) => `NVL(${alias}.PLAN_TIME${i + 1}, 0)`)
    .join(' + ');
}

/** 수정 가능한 시간대 컬럼 ↔ DTO 필드 대응. */
export function planTimeFieldPairs(): Array<[column: string, field: string]> {
  const pairs: Array<[string, string]> = [];
  for (let i = 1; i <= TIME_SLOTS; i += 1) {
    pairs.push([`PLAN_TIME${i}`, `planTime${i}`]);
    pairs.push([`TIME${i}_DESC`, `time${i}Desc`]);
  }
  return pairs;
}

/** PB 규약: 빈 값이면 '%' 가 되어 전체를 조회한다. */
export function like(value?: string): string {
  return `${(value ?? '').trim()}%`;
}
