/** PB w_pln_product_pcb_destroy_master 의 두 모드 (rb_destroy / rb_history) + 10/22 요청 요약·LCR 탭 */
export type ProductDestroyMode = 'DESTROY' | 'HISTORY' | 'SUMMARY' | 'LCR';

/** 1=생산1팀(SMT), 2=생산2팀(조립) — 팀마다 불량 입력 양식이 다르다 */
export type DestroyTeam = '1' | '2';

/** 팀별 공통코드형 (ISYS_BASECODE) */
export const TEAM_CODE_GROUPS: Record<DestroyTeam, { badType: string; process: string }> = {
  '1': { badType: 'DESTROY BAD TYPE SMT', process: 'DESTROY PROCESS SMT' },
  '2': { badType: 'DESTROY BAD TYPE ASSY', process: 'DESTROY PROCESS ASSY' },
};

/** IP_PRODUCT_WORK_QC 한 행 (폐기/반품 공용) */
export interface ProductDestroyRow {
  qcSequence: number;
  serialNo: string;
  itemCode: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  lineCode: string | null;
  workstageCode: string | null;
  badReasonCode: string | null;
  /** 불량유형 이름 (팀별 공통코드, 옛 행은 WQC BAD REASON CODE) */
  badReasonName: string | null;
  destroyTeam: DestroyTeam | null;
  destroyProductType: string | null;
  destroyBadCategory: string | null;
  occurProcessCode: string | null;
  occurProcessName: string | null;
  detectProcessCode: string | null;
  detectProcessName: string | null;
  badCauseBy: string | null;
  destroyUnitPrice: number | null;
  destroyAmount: number | null;
  qcResult: string | null;
  receiptDeficit: string | null;
  qcInspectHandling: string | null;
  departmentCode: string | null;
  departmentName: string | null;
  badQty: number | null;
  defectQty: number | null;
  qcDate: string | null;
  repairDate: string | null;
  shiftCode: string | null;
  charger: string | null;
  repairBy: string | null;
  locationCode: string | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
  organizationId: number;
}

/** 폐기 등록 결과 — PB 가 행별로 찍던 OK/FAIL 에 SKIP(이미 처리됨)을 더했다 */
export interface DestroyOutcome {
  serialNo: string;
  status: 'OK' | 'SKIP' | 'FAIL';
  reason?: string;
  qcSequence?: number;
}

export interface DestroyResponse {
  ok: number;
  skip: number;
  fail: number;
  results: DestroyOutcome[];
}

/** 바코드 미각인 제품 — 품번 + 수량 */
export interface DestroyItemEntry {
  itemCode: string;
  qty: number;
}

export interface SummaryBucket {
  key: string;
  name: string;
  qty: number;
  amount: number;
}

export interface DestroySummary {
  byType: { code: string; name: string; qty: number; amount: number }[];
  byShift: SummaryBucket[];
  byCause: SummaryBucket[];
}

/** LCR 대상 품번 (BOM 에 L/C/R 위치가 직접 달린 TOP/BOT 품목) */
export interface LcrItem {
  itemCode: string;
  itemName: string | null;
  modelName: string | null;
  customerCode: string | null;
  customerName: string | null;
  partCount: number;
}

export interface LcrPart {
  childItemCode: string;
  childItemName: string | null;
  locationInfo: string | null;
  mountQty: number;
  unitPrice: number | null;
  amount: number;
}

export interface LcrPreview {
  item: { itemCode: string; itemName: string | null; modelName: string | null; customerName: string | null };
  parts: LcrPart[];
  mountQty: number;
  unitPriceSum: number;
  amountPerArray: number;
  missingPriceCount: number;
}

/** IP_LCR_DESTROY 한 행 */
export interface LcrDestroyRow {
  lcrSeq: number;
  measureDate: string;
  customerCode: string | null;
  customerName: string | null;
  itemCode: string;
  itemName: string | null;
  modelName: string | null;
  arrayQty: number;
  mountQty: number;
  unitPriceSum: number;
  useQty: number;
  destroyAmount: number;
  measurer: string | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

export interface LcrMonthlyRow {
  month: string;
  count: number;
  arrayQty: number;
  useQty: number;
  destroyAmount: number;
}
