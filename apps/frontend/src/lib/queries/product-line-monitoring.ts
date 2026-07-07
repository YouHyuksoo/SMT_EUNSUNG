/**
 * @file product-line-monitoring.ts
 * @description 제품생산현황(메뉴 21) SQL 쿼리.
 * 초보자 가이드: IRPT_PRODUCT_LINE_MONITORING 뷰에서 라인별 생산 모니터링 데이터를 조회한다.
 * RUNNING_LOT_INPUT_QTY는 BJVNSMT_E에서 항상 null이므로 제외.
 */

export function sqlProductLineMonitoring(lineClause = ''): string {
  return `
SELECT
  LINE_NAME,
  LINE_CODE,
  LINE_STATUS,
  MODEL_NAME,
  PRODUCT_RUN_TYPE,
  RUN_DATE,
  ACTUAL_DATE,
  RUNNING_LOT_PLAN_QTY,
  RUNNING_LOT_ACTUAL_QTY,
  RUNNING_LOT_NG_QTY
FROM IRPT_PRODUCT_LINE_MONITORING
WHERE 1 = 1
  ${lineClause}
ORDER BY LINE_CODE
`;
}

export const SQL_PRODUCT_LINE_MONITORING = sqlProductLineMonitoring();
