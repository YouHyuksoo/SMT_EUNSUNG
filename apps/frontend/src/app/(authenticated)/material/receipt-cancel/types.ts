/** PB w_mat_receipt_cancel_master 의 두 조회 모드 (rb_cancel / rb_hst) */
export type ReceiptCancelMode = 'CANCEL' | 'HISTORY';

export interface ReceiptCancelRow {
  receiptDate: string;
  receiptSequence: number;
  receiptStatus: string | null;
  receiptType: string | null;
  locationCode: string | null;
  lineType: string | null;
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  materialMfs: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  invoiceNo: string | null;
  receiptQty: number | null;
  unitPrice: number | null;
  receiptAmt: number | null;
  currency: string | null;
  receiptLotNo: string | null;
  orderNo: string | null;
  interfaceYn: string | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
  organizationId: number;
  itemBarcode: string | null;
  scanQty: number | null;
}

/** 취소 대상 식별자 — IM_ITEM_RECEIPT PK 중 조직을 뺀 두 컬럼 */
export interface ReceiptCancelTarget {
  receiptDate: string;
  receiptSequence: number;
}

/**
 * 행 선택 키. 바코드 LEFT JOIN 때문에 같은 입고건이 여러 행으로 보일 수 있어
 * 선택은 바코드가 아니라 입고건(PK) 단위로 잡는다 — 한 행을 체크하면 같은 입고건이 함께 선택된다.
 */
export function receiptKey(row: ReceiptCancelRow | ReceiptCancelTarget): string {
  return `${row.receiptDate}|${row.receiptSequence}`;
}
