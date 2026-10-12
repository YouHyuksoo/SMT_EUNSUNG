/**
 * @file 자재입출고수불원장 5개 모드의 행 타입과 필터 상태
 *
 * 레거시 PowerBuilder `w_mat_ledger_report`의 라디오 5모드를 옮긴 것이다.
 * 설계: docs/specs/2026-09-16-material-receipt-issue-ledger-design.md
 */

/** 레거시 라디오 버튼에 대응하는 모드 식별자 */
export type LedgerMode = "ledger" | "workstage" | "barcodes" | "feederLayout" | "issueLoss";

export const LEDGER_MODES: LedgerMode[] = ["ledger", "workstage", "barcodes", "feederLayout", "issueLoss"];

/** 모드별 API 경로 (백엔드 material/receipt-issue-ledger 컨트롤러) */
export const LEDGER_MODE_PATH: Record<LedgerMode, string> = {
  ledger: "/material/receipt-issue-ledger",
  workstage: "/material/receipt-issue-ledger/workstage",
  barcodes: "/material/receipt-issue-ledger/barcodes",
  feederLayout: "/material/receipt-issue-ledger/feeder-layout",
  issueLoss: "/material/receipt-issue-ledger/issue-loss",
};

/** 모드 1 — 수불원장 */
export interface LedgerRow {
  rcvIssCode: string | null;
  receiptIssueSequence: number | null;
  receiptIssueDate: string | null;
  receiptIssueDeficit: string | null;
  qty: number | null;
  materialMfs: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  locationAddress: string | null;
  enterDate: string | null;
  barcode: string | null;
  fromSupplierCode: string | null;
  lineCode: string | null;
  workstageCode: string | null;
  locationCode: string | null;
  originMfs: string | null;
  feederLocationCode: string | null;
  feederShaft: string | null;
  modelName: string | null;
  inventoryType: string | null;
  invoiceNo: string | null;
  supplierCode: string | null;
  receiptIssueType: string | null;
  receiptIssueStatus: string | null;
  lotDivideYn: string | null;
  labelType: string | null;
  receiptType: string | null;
  vendorLotno: string | null;
  vendorCode: string | null;
  manufactureWeek: string | null;
  ledRankInfo: string | null;
  feedingDate: string | null;
  reelDestroyDate: string | null;
}

/** 모드 2 — 공정 수불원장 */
export interface WorkstageLedgerRow {
  rcvIssCode: string | null;
  receiptIssueSequence: number | null;
  receiptIssueDate: string | null;
  receiptIssueDeficit: string | null;
  qty: number | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  enterDate: string | null;
  locationAddress: string | null;
}

/** 모드 3 — 입고 바코드 */
export interface ReceiptBarcodeRow {
  itemBarcode: string | null;
  supplierCode: string | null;
  itemCode: string | null;
  scanDate: string | null;
  lotNo: string | null;
  scanQty: number | null;
  supplierBarcode: string | null;
  supplierItemCode: string | null;
  receiptCompareYn: string | null;
  receiptCompareDate: string | null;
  receiptCompareBy: string | null;
  receiptSlipNo: string | null;
  issueCompareYn: string | null;
  issueCompareDate: string | null;
  issueCompareBy: string | null;
  barcodeStatus: string | null;
  receiptType: string | null;
  issueType: string | null;
  fromSupplierCode: string | null;
  lotDivideYn: string | null;
  originItemBarcode: string | null;
  labelType: string | null;
  supplierLotNo: string | null;
  originSupplierCode: string | null;
  locationAddress: string | null;
  vendorLotno: string | null;
  vendorCode: string | null;
}

/** 모드 4 — 라인 피더 레이아웃 */
export interface FeederLayoutRow {
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  locationAddress: string | null;
  mslLevel: string | null;
  inventoryQty: number | null;
  unitQty: number | null;
  workstageInventoryQty: number | null;
}

/** 모드 5 — 출고 로스 */
export interface IssueLossRow {
  issueDate: string | null;
  issueSequence: number | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  materialMfs: string | null;
  lineCode: string | null;
  modelName: string | null;
  issueQty: number | null;
  enterDate: string | null;
  enterBy: string | null;
  lastModifyDate: string | null;
  lastModifyBy: string | null;
  organizationId: number | null;
}

/** 5모드가 공유하는 필터 상태. 모드마다 실제로 전송하는 항목이 다르다. */
export interface LedgerFilterState {
  dateFrom: string;
  dateTo: string;
  itemCode: string;
  lotNo: string;
  locationCode: string;
  inventoryType: string;
  supplierCode: string;
  fromSupplierCode: string;
  lineCode: string;
  workstageCode: string;
  supplierIssue: string;
  issueDeficit: string;
  rcvIssCode: string;
  includeW00: boolean;
  excludeEtcLine: boolean;
  slipNo: string;
  lotDivide: string;
  keyitemYn: string;
  modelName: string;
}

export function createEmptyFilters(dateFrom: string, dateTo: string): LedgerFilterState {
  return {
    dateFrom,
    dateTo,
    itemCode: "",
    lotNo: "",
    locationCode: "",
    inventoryType: "",
    supplierCode: "",
    fromSupplierCode: "",
    lineCode: "",
    workstageCode: "",
    supplierIssue: "",
    issueDeficit: "",
    rcvIssCode: "",
    includeW00: true,
    excludeEtcLine: false,
    slipNo: "",
    lotDivide: "",
    keyitemYn: "",
    modelName: "",
  };
}

/**
 * 모드별로 백엔드에 보낼 쿼리 파라미터를 만든다.
 *
 * 레거시가 전달만 하고 SQL에서 쓰지 않던 파라미터는 보내지 않는다.
 * - arg_keyitem_yn: 모드 1·2의 SQL에 등장하지 않음 (모드 3·4·5는 실사용)
 *
 * arg_etc_line은 레거시 cbx_etc_line 체크박스가 채우는 살아있는 필터다.
 * 배열 대신 excludeEtcLine 플래그로 보내고 백엔드가 서브쿼리로 처리한다.
 */
export function buildLedgerParams(mode: LedgerMode, f: LedgerFilterState, limit: number): Record<string, string> {
  const params: Record<string, string> = { limit: String(limit) };
  const put = (key: string, value: string) => {
    const trimmed = value.trim();
    if (trimmed) params[key] = trimmed;
  };

  if (mode !== "feederLayout") {
    params.dateFrom = f.dateFrom;
    params.dateTo = f.dateTo;
  }

  switch (mode) {
    case "ledger":
      put("itemCode", f.itemCode);
      put("lotNo", f.lotNo);
      put("locationCode", f.locationCode);
      put("inventoryType", f.inventoryType);
      put("supplierCode", f.supplierCode);
      put("fromSupplierCode", f.fromSupplierCode);
      put("lineCode", f.lineCode);
      put("workstageCode", f.workstageCode);
      put("supplierIssue", f.supplierIssue);
      put("issueDeficit", f.issueDeficit);
      put("rcvIssCode", f.rcvIssCode);
      params.includeW00 = f.includeW00 ? "Y" : "N";
      params.excludeEtcLine = f.excludeEtcLine ? "Y" : "N";
      break;
    case "workstage":
      put("itemCode", f.itemCode);
      put("rcvIssCode", f.rcvIssCode);
      break;
    case "barcodes":
      put("itemCode", f.itemCode);
      put("lotNo", f.lotNo);
      put("slipNo", f.slipNo);
      put("lotDivide", f.lotDivide);
      put("supplierCode", f.supplierCode);
      put("keyitemYn", f.keyitemYn);
      break;
    case "feederLayout":
      put("itemCode", f.itemCode);
      put("modelName", f.modelName);
      put("keyitemYn", f.keyitemYn);
      break;
    case "issueLoss":
      put("lineCode", f.lineCode);
      put("modelName", f.modelName);
      put("itemCode", f.itemCode);
      put("materialMfs", f.lotNo);
      put("keyitemYn", f.keyitemYn);
      break;
  }
  return params;
}
