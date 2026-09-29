/**
 * @file src/app/(authenticated)/quality/iqc/types.ts
 * @description IQC 관리 행 계약 — PB w_qc_iqc_master
 */

/** PB d_mat_rceipt_barcode_4_iqc_wait_lst / _cancel_lst */
export interface IqcTargetRow {
  itemBarcode: string;
  supplierBarcode: string | null;
  receiptSlipNo: string;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemClass: string | null;
  itemClassName: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  supplierItemCode: string | null;
  scanDate: string | null;
  scanQty: number | null;
  lotNo: string | null;
  inspectResult: string | null;
  inspectResultName: string | null;
  receiptCompareYn: string | null;
  receiptCompareName: string | null;
  receiptCompareDate: string | null;
  receiptCompareBy: string | null;
  barcodeStatus: string | null;
  barcodeStatusName: string | null;
  receiptType: string | null;
  labelType: string | null;
  lotDivideYn: string | null;
  originItemBarcode: string | null;
  manufactureWeek: string | null;
  manufactureDate: string | null;
  pcbCoatingDate: string | null;
  locationAddress: string | null;
  mslLevel: string | null;
  /** 10 이상이면 합격 판정이 막힌다 (PB 규칙) */
  esdCheckCycleValue: number | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** PB d_qc_iqc_lst */
export interface IqcHistoryRow {
  inspectDate: string;
  inspectSequence: number;
  iqcInspectNo: string | null;
  itemCode: string | null;
  itemName: string | null;
  mfs: string | null;
  inspectResult: string | null;
  inspectResultName: string | null;
  badReasonCode: string | null;
  badReasonName: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  arrivalQty: number | null;
  arrivalDate: string | null;
  inspectLotQty: number | null;
  inspectBadLotQty: number | null;
  inspectQty: number | null;
  inspectBadQty: number | null;
  destroyQty: number | null;
  inspectBy: string | null;
  iqcImproveNo: string | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}
