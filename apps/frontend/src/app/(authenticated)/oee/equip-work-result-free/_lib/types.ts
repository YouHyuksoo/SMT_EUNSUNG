/**
 * @file oee/equip-work-result-free/_lib/types.ts
 * @description 계획 없는 실적 입력 화면 공용 타입
 */

/** GET /oee/work-result-free/models 한 행 (IP_PRODUCT_MODEL_MASTER) */
export interface ModelRow {
  modelName: string;
  itemCode: string;
  revision: string | null;
  customerName: string | null;
  modelSpec: string | null;
  /** 'Y' = 최근 계획(IP_PRODUCT_MI_PLAN, 계획일이 3일 전보다 큼)에 있는 모델 */
  planned: 'Y' | 'N';
}

/** GET /oee/work-result-free/runs 한 행 — 오늘 업무일에 이 화면이 만든 지시 */
export interface FreeRunRow {
  runNo: string;
  modelName: string;
  itemCode: string;
  /** 계획수량 = 취소 제외 실적 합계 */
  planQty: number;
  resultQty: number;
}

/** GET /oee/work-result-free/time-zones 한 행 — 작업시간 관리(WORKTIME)의 타임구간 */
export interface TimeZoneRow {
  /** A~J */
  code: string;
  /** 'HHMM' */
  startTime: string;
  endTime: string;
}

/** 'HHMM' → 'HH:MM' */
export function hm(t: string | null | undefined) {
  return t && t.length === 4 ? `${t.slice(0, 2)}:${t.slice(2)}` : t ?? '';
}
