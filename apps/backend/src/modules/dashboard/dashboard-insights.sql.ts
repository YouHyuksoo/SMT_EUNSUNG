/**
 * @file src/modules/dashboard/dashboard-insights.sql.ts
 * @description 대시보드 차트용 SQL — 선택일 포함 최근 7일의 날짜·라인별 계획/실적
 *
 * 초보자 가이드:
 * 1. 바인드는 :day 하나(YYYY-MM-DD, 비면 오늘). 선택일 포함 7일을 달력(calendar)으로 만들어 빈 날도 행이 나온다
 * 2. 계획: SMD 는 IP_PRODUCT_SMD_PLAN 의 PLAN_QTY 합, 제품은 후공정 생산지시(런카드) 지시수량 합(공정마다 지시가 따로라 지시 대비로 본다)
 * 3. 실적: SMD 는 IP_ASSEMBLY_ACTUAL_TIME_V 시간대 10칸(A~J) 합, 제품은 후공정 생산지시 확정 실적
 *    (IP_PRODUCT_RESULT, planning/order-result.sql.ts)을 입력 시각의 작업일(08:30 시작)로 묶는다
 * 4. 실적만 있고 계획이 없는 라인도 UNION ALL 로 합쳐서 남긴다 (한쪽만 JOIN 하면 사라진다)
 * 5. 조직(ORGANIZATION_ID)은 getSummary 와 같이 1 이다. 실적 뷰에는 조직 컬럼이 없다
 */

import { MI_ORDER_RESULTS_SQL, MI_ORDERS_SQL } from '../planning/order-result.sql';

/** 실적 뷰의 시간대 10칸(A~J) 합 */
export const DASHBOARD_ACTUAL_SUM = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J']
  .map((p) => `NVL(v.${p}_TIME_ACTUAL, 0)`)
  .join(' + ');

export const DASHBOARD_INSIGHTS_SQL = `
  WITH bounds AS (
    SELECT NVL(TO_DATE(:day, 'YYYY-MM-DD'), TRUNC(SYSDATE)) AS selected_day FROM DUAL
  ), calendar AS (
    SELECT b.selected_day - 7 + LEVEL AS work_day, b.selected_day
      FROM bounds b CONNECT BY LEVEL <= 7
  ), movements AS (
    SELECT p.PLAN_DATE AS work_day, p.LINE_CODE, 'SMD' AS production_type,
           SUM(NVL(p.PLAN_QTY, 0)) AS plan_qty, 0 AS actual_qty
      FROM IP_PRODUCT_SMD_PLAN p CROSS JOIN bounds b
     WHERE p.ORGANIZATION_ID = 1 AND p.PLAN_DATE >= b.selected_day - 6 AND p.PLAN_DATE < b.selected_day + 1
     GROUP BY p.PLAN_DATE, p.LINE_CODE
    UNION ALL
    SELECT v.RECEIPT_DATE, v.LINE_CODE, 'SMD', 0, SUM(${DASHBOARD_ACTUAL_SUM})
      FROM IP_ASSEMBLY_ACTUAL_TIME_V v CROSS JOIN bounds b
     WHERE v.RECEIPT_DATE >= b.selected_day - 6 AND v.RECEIPT_DATE < b.selected_day + 1
     GROUP BY v.RECEIPT_DATE, v.LINE_CODE
    UNION ALL
    SELECT o.RUN_DATE, o.LINE_CODE, 'MI', SUM(NVL(o.LOT_SIZE, 0)), 0
      FROM (${MI_ORDERS_SQL}) o CROSS JOIN bounds b
     WHERE o.ORGANIZATION_ID = 1 AND o.RUN_DATE >= b.selected_day - 6 AND o.RUN_DATE < b.selected_day + 1
     GROUP BY o.RUN_DATE, o.LINE_CODE
    UNION ALL
    SELECT F_GET_WORK_ACTUAL_DATE(x.ENTER_DATE, 'A'), x.LINE_CODE, 'MI', 0, SUM(x.RESULT_QTY)
      FROM (${MI_ORDER_RESULTS_SQL}) x CROSS JOIN bounds b
     WHERE x.ORGANIZATION_ID = 1
       AND x.ENTER_DATE >= b.selected_day - 7 AND x.ENTER_DATE < b.selected_day + 2
       AND F_GET_WORK_ACTUAL_DATE(x.ENTER_DATE, 'A') >= b.selected_day - 6
       AND F_GET_WORK_ACTUAL_DATE(x.ENTER_DATE, 'A') < b.selected_day + 1
     GROUP BY F_GET_WORK_ACTUAL_DATE(x.ENTER_DATE, 'A'), x.LINE_CODE
  ), daily_lines AS (
    SELECT work_day, LINE_CODE, production_type, SUM(plan_qty) AS plan_qty, SUM(actual_qty) AS actual_qty
      FROM movements GROUP BY work_day, LINE_CODE, production_type
  )
  SELECT TO_CHAR(c.selected_day, 'YYYY-MM-DD') AS "selectedDate",
         TO_CHAR(c.work_day, 'YYYY-MM-DD') AS "date",
         d.production_type AS "productionType", d.LINE_CODE AS "lineCode",
         NVL(l.LINE_NAME, d.LINE_CODE) AS "lineName",
         NVL(d.plan_qty, 0) AS "planQty", NVL(d.actual_qty, 0) AS "actualQty"
    FROM calendar c
    LEFT JOIN daily_lines d ON d.work_day = c.work_day
    LEFT JOIN IP_PRODUCT_LINE l ON l.LINE_CODE = d.LINE_CODE AND l.ORGANIZATION_ID = 1
   ORDER BY c.work_day, d.production_type DESC, d.LINE_CODE`;