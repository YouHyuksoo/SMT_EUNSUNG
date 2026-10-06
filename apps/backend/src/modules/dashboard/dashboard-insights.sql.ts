/**
 * @file src/modules/dashboard/dashboard-insights.sql.ts
 * @description 대시보드 차트용 SQL — 선택일 포함 최근 7일의 날짜·라인별 계획/실적
 *
 * 초보자 가이드:
 * 1. 바인드는 :day 하나(YYYY-MM-DD, 비면 오늘). 선택일 포함 7일을 달력(calendar)으로 만들어 빈 날도 행이 나온다
 * 2. 계획: IP_PRODUCT_SMD_PLAN / IP_PRODUCT_MI_PLAN 의 PLAN_QTY 합 (계획 테이블 ACTUAL_QTY 는 갱신되지 않는다)
 * 3. 실적: IP_ASSEMBLY_ACTUAL_TIME_V(SMD) / IP_PRODUCT_ACTUAL_TIME_V(제품) 시간대 10칸(A~J) 합
 * 4. 실적만 있고 계획이 없는 라인도 UNION ALL 로 합쳐서 남긴다 (한쪽만 JOIN 하면 사라진다)
 * 5. 조직(ORGANIZATION_ID)은 getSummary 와 같이 1 이다. 실적 뷰에는 조직 컬럼이 없다
 */

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
    SELECT p.PLAN_DATE, p.LINE_CODE, 'MI', SUM(NVL(p.PLAN_QTY, 0)), 0
      FROM IP_PRODUCT_MI_PLAN p CROSS JOIN bounds b
     WHERE p.ORGANIZATION_ID = 1 AND p.PLAN_DATE >= b.selected_day - 6 AND p.PLAN_DATE < b.selected_day + 1
     GROUP BY p.PLAN_DATE, p.LINE_CODE
    UNION ALL
    SELECT v.ACTUAL_DATE, v.LINE_CODE, 'MI', 0, SUM(${DASHBOARD_ACTUAL_SUM})
      FROM IP_PRODUCT_ACTUAL_TIME_V v CROSS JOIN bounds b
     WHERE v.ACTUAL_DATE >= b.selected_day - 6 AND v.ACTUAL_DATE < b.selected_day + 1
     GROUP BY v.ACTUAL_DATE, v.LINE_CODE
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