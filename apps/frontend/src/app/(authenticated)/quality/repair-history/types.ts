/** PB d_pln_product_work_qc_hst 한 행 (IP_PRODUCT_WORK_QC) */
export interface RepairHistoryRow {
  qcSequence: number;
  lineCode: string | null;
  workstageCode: string | null;
  serialNo: string | null;
  qcResult: string | null;
  badReasonCode: string | null;
  badQty: number | null;
  defectQty: number | null;
  charger: string | null;
  repairBy: string | null;
  qcDate: string | null;
  repairDate: string | null;
  qcInspectHandling: string | null;
  receiptDeficit: string | null;
  repairResultCode: string | null;
  repairMethod: string | null;
  repairLineCode: string | null;
  repairWorkstageCode: string | null;
  badCauseBy: string | null;
  lcrMeasure: string | null;
  machineCode: string | null;
  shiftCode: string | null;
  itemCode: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  locationCode: string | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
  organizationId: number;
  /** PB 계산컬럼 TAT_TIME — QC 등록 후 경과 시간(시간 단위) */
  tatTime: number | null;
}
