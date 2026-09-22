/** PB w_pln_product_pcb_destroy_master 의 두 모드 (rb_destroy / rb_history) */
export type ProductDestroyMode = 'DESTROY' | 'HISTORY';

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
  qcResult: string | null;
  receiptDeficit: string | null;
  qcInspectHandling: string | null;
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
