/**
 * @file src/modules/planning/order-result.sql.ts
 * @description 후공정 생산지시(런카드) 대비 실적 SQL 조각 — 생산 보드·대시보드가 같이 쓴다
 *
 * 초보자 가이드:
 * 1. 생산지시 = IP_PRODUCT_RUN_CARD. 런카드 LOT_NO 는 원천 계획의 MFS 다.
 *    LOT_NO 가 제품생산계획(IP_PRODUCT_MI_PLAN) MFS 이면 후공정 지시, 반제품생산계획 MFS 이면 SMT 지시다.
 * 2. 후공정 지시 실적 = IP_PRODUCT_WORK_RESULT 의 확정(DONE) 실적 합. 진행(WIP)·취소 실적은 세지 않는다.
 * 3. SMT 지시 실적은 센서 실적 뷰(IP_ASSEMBLY_ACTUAL_TIME_V)를 그대로 쓴다. SMT 라인에서 넣은 실적은
 *    센서 누적 프로시저로 이미 센서에 들어가 있어 여기서 더하면 두 번 센다.
 * 4. 공정 통과 이력은 실적이 아니다 (설계 docs/specs/2026-10-14-production-order-and-shipping-order-design.md).
 */

/** 런카드(alias)가 제품생산계획에서 내려간 후공정 지시인가 */
export const MI_ORDER_EXISTS = (alias: string): string =>
  `EXISTS (SELECT 1 FROM IP_PRODUCT_MI_PLAN mip
            WHERE mip.MFS = ${alias}.LOT_NO
              AND mip.MFS <> '*'
              AND mip.ORGANIZATION_ID = ${alias}.ORGANIZATION_ID)`;

/** 후공정 지시의 확정 실적 행. 날짜 조건은 쓰는 쪽이 ENTER_DATE 로 붙인다. */
export const MI_ORDER_RESULTS_SQL = `
  SELECT wr.RUN_NO, wr.ORGANIZATION_ID, r.LOT_NO, r.LINE_CODE, r.MODEL_NAME, wr.RESULT_QTY, wr.ENTER_DATE
    FROM IP_PRODUCT_WORK_RESULT wr
    JOIN IP_PRODUCT_RUN_CARD r ON r.RUN_NO = wr.RUN_NO AND r.ORGANIZATION_ID = wr.ORGANIZATION_ID
   WHERE wr.RESULT_STATUS = 'DONE'
     AND ${MI_ORDER_EXISTS('r')}`;

/** 후공정 생산지시(런카드)의 지시수량. 공정마다 지시가 따로라 지시 대비 실적은 이 수량과 비교한다. */
export const MI_ORDERS_SQL = `
  SELECT r.RUN_NO, r.ORGANIZATION_ID, r.LINE_CODE, r.RUN_DATE, r.LOT_SIZE
    FROM IP_PRODUCT_RUN_CARD r
   WHERE ${MI_ORDER_EXISTS('r')}`;

const SLOT_KEYS = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'] as const;

/**
 * 제품생산계획 목록의 실적 조인 두 개 (계획 alias 는 p).
 * 계획 한 건은 한 공정으로만 지시가 내려간다 (실측 180일: 계획당 런카드 공정 1종 2146/2146).
 * 그래서 그 계획(MFS)에서 내려간 런카드들의 확정 실적을 그대로 더한다.
 * - ma.ACTUAL_QTY: 날짜와 관계없는 합계. 지시는 다음 날까지 이어서 끝낼 수 있다.
 * - v.A_TIME_ACTUAL~J_TIME_ACTUAL: 작업일(SMTWORKTIME 'A' 시작, 08:30)이 계획일과 같은 실적만 시간대 칸으로.
 *   생산 보드와 같은 ICOM_WORKTIME_RANGES(SMTWORKTIME) 칸 정의를 쓴다. 자정을 넘는 칸(G 2230~0030)도 맞춘다.
 * planMfsFilter 는 계산할 MFS 를 조회 범위의 계획으로 좁히는 서브쿼리다 (실적 전체를 매번 모으지 않도록).
 */
export function miPlanActualJoins(planMfsFilter: string): string {
  const results = `SELECT o.* FROM (${MI_ORDER_RESULTS_SQL}) o WHERE o.LOT_NO IN (${planMfsFilter})`;
  const slotSums = SLOT_KEYS
    .map((k) => `SUM(CASE WHEN z.WORK_TYPE = '${k}' THEN x.RESULT_QTY ELSE 0 END) AS ${k}_TIME_ACTUAL`)
    .join(',\n                ');
  return `
         LEFT JOIN (SELECT x.LOT_NO, x.ORGANIZATION_ID, SUM(x.RESULT_QTY) AS ACTUAL_QTY
                      FROM (${results}) x
                     GROUP BY x.LOT_NO, x.ORGANIZATION_ID) ma
                ON ma.LOT_NO = p.MFS AND ma.ORGANIZATION_ID = p.ORGANIZATION_ID AND p.MFS <> '*'
         LEFT JOIN (SELECT x.LOT_NO, x.ORGANIZATION_ID, TRUNC(x.ENTER_DATE - ws.START_FRAC) AS WORK_DAY,
                           ${slotSums}
                      FROM (${results}) x
                     CROSS JOIN (SELECT NVL(MAX((TO_NUMBER(SUBSTR(r.START_TIME, 1, 2)) + TO_NUMBER(SUBSTR(r.START_TIME, 3, 2)) / 60) / 24), 8.5 / 24) AS START_FRAC
                                   FROM ICOM_WORKTIME_RANGES r WHERE r.RANGE_TYPE = 'SMTWORKTIME' AND r.WORK_TYPE = 'A') ws
                      JOIN ICOM_WORKTIME_RANGES z
                        ON z.RANGE_TYPE = 'SMTWORKTIME' AND z.ORGANIZATION_ID = x.ORGANIZATION_ID
                       AND ((z.START_TIME <= z.END_TIME AND TO_CHAR(x.ENTER_DATE, 'HH24MI') >= z.START_TIME AND TO_CHAR(x.ENTER_DATE, 'HH24MI') < z.END_TIME)
                         OR (z.START_TIME > z.END_TIME AND (TO_CHAR(x.ENTER_DATE, 'HH24MI') >= z.START_TIME OR TO_CHAR(x.ENTER_DATE, 'HH24MI') < z.END_TIME)))
                     GROUP BY x.LOT_NO, x.ORGANIZATION_ID, TRUNC(x.ENTER_DATE - ws.START_FRAC)) v
                ON v.LOT_NO = p.MFS AND v.ORGANIZATION_ID = p.ORGANIZATION_ID AND v.WORK_DAY = p.PLAN_DATE AND p.MFS <> '*'`;
}
