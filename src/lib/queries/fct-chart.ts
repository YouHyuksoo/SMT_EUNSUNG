/**
 * @file fct-chart.ts
 * @description FCT 기능검사 분석 화면(메뉴 42) SQL 쿼리 모음.
 */

const PASS_CONDITION = `
UPPER(TRIM(NVL(INSPECT_RESULT, 'NG'))) IN ('GOOD', 'OK', 'PASS', 'P', 'Y', 'TRUE', '1')
`;

const WORKDAY_START = `TRUNC(SYSDATE - (7.5 / 24)) + (7.5 / 24)`;
const TODAY_WORKDAY_START = `TO_CHAR(${WORKDAY_START}, 'YYYY/MM/DD HH24:MI:SS')`;
const NEXT_WORKDAY_START = `TO_CHAR(${WORKDAY_START} + 1, 'YYYY/MM/DD HH24:MI:SS')`;
const WEEK_WORKDAY_START = `TO_CHAR(${WORKDAY_START} - 6, 'YYYY/MM/DD HH24:MI:SS')`;
const WORKDAY_LABEL = `TO_CHAR(TRUNC(TO_DATE(SUBSTR(f.INSPECT_DATE, 1, 19), 'YYYY/MM/DD HH24:MI:SS') - (7.5 / 24)), 'MM/DD')`;

export function sqlFctRecentRows(lineClause: string): string {
  return `
SELECT
  f.PID,
  f.MODEL,
  f.LINE_CODE,
  f.INSPECT_RESULT,
  f.INSPECT_DATE,
  f.ENTER_DATE
FROM IQ_MACHINE_INSPECT_DATA_FCT f
WHERE f.PID IS NOT NULL
  AND f.INSPECT_DATE >= ${WEEK_WORKDAY_START}
  AND f.INSPECT_DATE < ${NEXT_WORKDAY_START}
  AND ROWNUM <= 10000
  ${lineClause}
`;
}

export function sqlFctByModel(lineClause: string): string {
  return `
SELECT * FROM (
  SELECT
    NVL(f.MODEL, 'UNKNOWN') AS MODEL_NAME,
    MIN(f.PID) AS SAMPLE_PID,
    COUNT(*) AS TOTAL_CNT,
    SUM(CASE WHEN ${PASS_CONDITION} THEN 1 ELSE 0 END) AS GOOD_CNT,
    SUM(CASE WHEN NOT (${PASS_CONDITION}) THEN 1 ELSE 0 END) AS NG_CNT,
    ROUND(
      SUM(CASE WHEN NOT (${PASS_CONDITION}) THEN 1 ELSE 0 END)
      / NULLIF(COUNT(*), 0) * 100, 2
    ) AS NG_RATE
  FROM IQ_MACHINE_INSPECT_DATA_FCT f
  WHERE f.PID IS NOT NULL
    AND f.INSPECT_DATE >= ${TODAY_WORKDAY_START}
    AND f.INSPECT_DATE < ${NEXT_WORKDAY_START}
    ${lineClause}
  GROUP BY NVL(f.MODEL, 'UNKNOWN')
  ORDER BY NG_RATE DESC, NG_CNT DESC, TOTAL_CNT DESC
)
WHERE ROWNUM <= 8
`;
}

export function sqlFctFpyTrend(lineClause: string): string {
  return `
SELECT
  ${WORKDAY_LABEL} AS WORK_DATE,
  COUNT(*) AS TOTAL_CNT,
  SUM(CASE WHEN ${PASS_CONDITION} THEN 1 ELSE 0 END) AS GOOD_CNT,
  SUM(CASE WHEN NOT (${PASS_CONDITION}) THEN 1 ELSE 0 END) AS NG_CNT,
  ROUND(
    SUM(CASE WHEN ${PASS_CONDITION} THEN 1 ELSE 0 END)
    / NULLIF(COUNT(*), 0) * 100, 1
  ) AS FPY,
  ROUND(
    SUM(CASE WHEN NOT (${PASS_CONDITION}) THEN 1 ELSE 0 END)
    / NULLIF(COUNT(*), 0) * 100, 2
  ) AS NG_RATE
FROM IQ_MACHINE_INSPECT_DATA_FCT f
WHERE f.PID IS NOT NULL
  AND f.INSPECT_DATE >= ${WEEK_WORKDAY_START}
  AND f.INSPECT_DATE < ${NEXT_WORKDAY_START}
  ${lineClause}
GROUP BY ${WORKDAY_LABEL}
ORDER BY ${WORKDAY_LABEL}
`;
}

export function sqlFctSummary(lineClause: string): string {
  return `
SELECT
  COUNT(*) AS TOTAL_INSPECTED,
  SUM(CASE WHEN ${PASS_CONDITION} THEN 1 ELSE 0 END) AS TOTAL_GOOD,
  SUM(CASE WHEN NOT (${PASS_CONDITION}) THEN 1 ELSE 0 END) AS TOTAL_DEFECTS,
  ROUND(
    SUM(CASE WHEN NOT (${PASS_CONDITION}) THEN 1 ELSE 0 END)
    / NULLIF(COUNT(*), 0) * 100, 2
  ) AS DEFECT_RATE,
  ROUND(
    SUM(CASE WHEN ${PASS_CONDITION} THEN 1 ELSE 0 END)
    / NULLIF(COUNT(*), 0) * 100, 1
  ) AS FPY_RATE
FROM IQ_MACHINE_INSPECT_DATA_FCT f
WHERE f.PID IS NOT NULL
  AND f.INSPECT_DATE >= ${TODAY_WORKDAY_START}
  AND f.INSPECT_DATE < ${NEXT_WORKDAY_START}
  ${lineClause}
`;
}

export function sqlFctTopModels(lineClause: string): string {
  return `
SELECT * FROM (
  SELECT
    NVL(f.MODEL, 'UNKNOWN') AS MODEL_NAME,
    MIN(f.PID) AS SAMPLE_PID,
    SUM(CASE WHEN NOT (${PASS_CONDITION}) THEN 1 ELSE 0 END) AS NG_CNT,
    COUNT(*) AS TOTAL_CNT,
    ROUND(
      SUM(CASE WHEN NOT (${PASS_CONDITION}) THEN 1 ELSE 0 END)
      / NULLIF(COUNT(*), 0) * 100, 1
    ) AS NG_RATE
  FROM IQ_MACHINE_INSPECT_DATA_FCT f
  WHERE f.PID IS NOT NULL
    AND f.INSPECT_DATE >= ${WEEK_WORKDAY_START}
    AND f.INSPECT_DATE < ${NEXT_WORKDAY_START}
    ${lineClause}
  GROUP BY NVL(f.MODEL, 'UNKNOWN')
  HAVING SUM(CASE WHEN NOT (${PASS_CONDITION}) THEN 1 ELSE 0 END) > 0
  ORDER BY NG_CNT DESC, NG_RATE DESC
)
WHERE ROWNUM <= 5
`;
}

export function sqlFctTodayLineCompare(lineClause: string): string {
  return `
SELECT
  f.LINE_CODE,
  F_GET_LINE_NAME(f.LINE_CODE, 1) AS LINE_NAME,
  COUNT(*) AS TOTAL_CNT,
  SUM(CASE WHEN ${PASS_CONDITION} THEN 1 ELSE 0 END) AS GOOD_CNT,
  SUM(CASE WHEN NOT (${PASS_CONDITION}) THEN 1 ELSE 0 END) AS NG_CNT,
  ROUND(
    SUM(CASE WHEN NOT (${PASS_CONDITION}) THEN 1 ELSE 0 END)
    / NULLIF(COUNT(*), 0) * 100, 2
  ) AS NG_RATE
FROM IQ_MACHINE_INSPECT_DATA_FCT f
WHERE f.PID IS NOT NULL
  AND f.LINE_CODE IS NOT NULL
  AND f.INSPECT_DATE >= ${TODAY_WORKDAY_START}
  AND f.INSPECT_DATE < ${NEXT_WORKDAY_START}
  ${lineClause}
GROUP BY f.LINE_CODE, F_GET_LINE_NAME(f.LINE_CODE, 1)
ORDER BY NG_RATE DESC, NG_CNT DESC, TOTAL_CNT DESC
`;
}

export function sqlFctWeeklyLineCompare(lineClause: string): string {
  return `
SELECT * FROM (
  SELECT
    f.LINE_CODE,
    F_GET_LINE_NAME(f.LINE_CODE, 1) AS LINE_NAME,
    COUNT(*) AS TOTAL_CNT,
    SUM(CASE WHEN NOT (${PASS_CONDITION}) THEN 1 ELSE 0 END) AS NG_CNT,
    ROUND(
      SUM(CASE WHEN NOT (${PASS_CONDITION}) THEN 1 ELSE 0 END)
      / NULLIF(COUNT(*), 0) * 100, 2
    ) AS NG_RATE
  FROM IQ_MACHINE_INSPECT_DATA_FCT f
  WHERE f.PID IS NOT NULL
    AND f.LINE_CODE IS NOT NULL
    AND f.INSPECT_DATE >= ${WEEK_WORKDAY_START}
    AND f.INSPECT_DATE < ${NEXT_WORKDAY_START}
    ${lineClause}
  GROUP BY f.LINE_CODE, F_GET_LINE_NAME(f.LINE_CODE, 1)
  ORDER BY NG_CNT DESC, NG_RATE DESC, TOTAL_CNT DESC
)
WHERE ROWNUM <= 8
`;
}

export interface FctModelRow {
  MODEL_NAME: string;
  SAMPLE_PID?: string;
  TOTAL_CNT: number;
  GOOD_CNT: number;
  NG_CNT: number;
  NG_RATE: number;
}

export interface FctFpyRow {
  WORK_DATE: string;
  TOTAL_CNT: number;
  GOOD_CNT: number;
  NG_CNT: number;
  FPY: number | null;
  NG_RATE: number | null;
}

export interface FctSummaryRow {
  TOTAL_INSPECTED: number;
  TOTAL_GOOD: number;
  TOTAL_DEFECTS: number;
  DEFECT_RATE: number | null;
  FPY_RATE: number | null;
}

export interface FctTopModelRow {
  MODEL_NAME: string;
  SAMPLE_PID?: string;
  NG_CNT: number;
  TOTAL_CNT: number;
  NG_RATE: number;
}

export interface FctLineCompareRow {
  LINE_CODE: string;
  LINE_NAME: string;
  TOTAL_CNT: number;
  GOOD_CNT?: number;
  NG_CNT: number;
  NG_RATE: number;
}

export interface FctRecentRawRow {
  PID: string;
  MODEL: string | null;
  LINE_CODE: string | null;
  INSPECT_RESULT: string | null;
  INSPECT_DATE: string | null;
  ENTER_DATE: Date | string | null;
}

export interface FctChartApiResponse {
  byModel: FctModelRow[];
  fpyTrend: FctFpyRow[];
  summary: FctSummaryRow;
  topModels: FctTopModelRow[];
  todayLines: FctLineCompareRow[];
  weeklyLines: FctLineCompareRow[];
  timestamp: string;
}
