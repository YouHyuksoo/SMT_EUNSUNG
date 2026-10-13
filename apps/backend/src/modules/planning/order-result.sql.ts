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
              AND mip.ORGANIZATION_ID = ${alias}.ORGANIZATION_ID)`;

/** 후공정 지시의 확정 실적 행. 날짜 조건은 쓰는 쪽이 ENTER_DATE 로 붙인다. */
export const MI_ORDER_RESULTS_SQL = `
  SELECT wr.RUN_NO, wr.ORGANIZATION_ID, r.LINE_CODE, r.MODEL_NAME, wr.RESULT_QTY, wr.ENTER_DATE
    FROM IP_PRODUCT_WORK_RESULT wr
    JOIN IP_PRODUCT_RUN_CARD r ON r.RUN_NO = wr.RUN_NO AND r.ORGANIZATION_ID = wr.ORGANIZATION_ID
   WHERE wr.RESULT_STATUS = 'DONE'
     AND ${MI_ORDER_EXISTS('r')}`;
