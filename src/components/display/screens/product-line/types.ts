/**
 * @file types.ts
 * @description 제품생산현황(메뉴 21) 타입 정의.
 * 초보자 가이드: API 응답 행 타입과 달성률 계산 결과 타입을 정의한다.
 */

/** API /api/display/21 응답 행 타입 */
export interface ProductionLineRow {
  LINE_NAME: string;
  LINE_CODE: string;
  LINE_STATUS: string;
  MODEL_NAME: string | null;
  PRODUCT_RUN_TYPE: string | null;
  RUN_DATE: string | null;
  ACTUAL_DATE: string | null;
  RUNNING_LOT_PLAN_QTY: number | null;
  RUNNING_LOT_ACTUAL_QTY: number | null;
  RUNNING_LOT_NG_QTY: number | null;
}

/** 달성률이 계산된 행 타입 */
export interface ProductionLineRowWithRate extends ProductionLineRow {
  /** 달성률 0~100+ (PLAN=0이면 0) */
  achieveRate: number;
}

/** API /api/display/21 전체 응답 타입 */
export interface ProductionLineApiResponse {
  lines: ProductionLineRow[];
  timestamp: string;
  error?: string;
}
