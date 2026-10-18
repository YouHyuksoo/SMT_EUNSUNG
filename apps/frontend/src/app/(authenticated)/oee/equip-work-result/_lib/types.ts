/**
 * @file oee/equip-work-result/_lib/types.ts
 * @description 설비별 작업 실적관리 공용 타입 — GET /oee/work-result 목록 행과 실적 이력 행
 */

/** GET /oee/work-result 한 행 (작업지시 = IP_PRODUCT_RUN_CARD) */
export interface RunRow {
  /** 롯트카드 번호 — 실적 원장(IP_PRODUCT_WORK_RESULT)의 키 */
  runNo: string;
  /** 제품생산계획(작업지시)의 작업지시번호 — /production/master-plan 에서 정해진다. 계획과 안 이어지면 null */
  workOrderNo: string | null;
  machineCode: string | null; machineName: string | null;
  workstageCode: string | null; workstageName: string | null; workstageGroup: string | null;
  runDate: string; lineCode: string | null; shiftCode: string | null;
  itemCode: string | null; revision: string | null; modelName: string | null; itemName?: string | null;
  unit: string | null; itemClass: string | null; carModel: string | null;
  ct: number | null; planQty: number | null; resultQty: number; defectQty: number; openDowntime: number;
  /** 취소 제외 실적 건수 */
  resultCount: number;
  wipCount: number;
}

/** GET /oee/work-result/results?runNo 한 행 */
export interface ResultHistoryRow {
  seqNo: string;
  machineCode: string | null;
  resultQty: number;
  workTime: number;
  workerCount: number;
  workerName: string | null;
  /** WIP | DONE | CANCEL */
  resultStatus: string;
  /** 공정재고 반영: Y=반영 / N=미반영 / X=대상 아님 / C=취소로 되돌림 */
  sensorApplyYn: string;
  sensorApplyMsg: string | null;
  /** 'YYYY-MM-DD HH24:MI:SS' */
  enteredAt: string | null;
}

/** 작업지시 진행 상태 — 실적 없음=대기, 실적이 계획에 닿으면 완료, 그 사이는 생산중 */
export function runState(r: Pick<RunRow, 'resultQty' | 'planQty'>): 'WAIT' | 'RUN' | 'DONE' {
  if (!r.resultQty) return 'WAIT';
  return r.planQty && r.resultQty >= r.planQty ? 'DONE' : 'RUN';
}

export const RUN_STATE_LABEL = { WAIT: '대기', RUN: '생산중', DONE: '완료' } as const;
export const RUN_STATE_CLASS = {
  WAIT: 'bg-slate-500/15 text-text-muted',
  RUN: 'bg-amber-500/15 text-amber-600 dark:text-amber-400',
  DONE: 'bg-blue-500/15 text-blue-600 dark:text-blue-400',
} as const;
