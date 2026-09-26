/**
 * @file src/app/(authenticated)/mold/types.ts
 * @description S-PARTS 8화면이 공유하는 행 계약.
 *
 * PB 소스에서 이 도메인은 MOLD(금형)다 — 테이블이 전부 IMCN_MOLD_* 다.
 * 화면 문구만 은성 메뉴를 따라 S-PARTS 로 쓴다. 필드명은 DB 컬럼을 따라간다.
 *
 * 코드컬럼은 코드와 이름을 짝으로 받는다 (`moldGroup` + `moldGroupName`).
 * 그리드에는 이름을 보여주고 코드는 괄호로 함께 둔다 — 원시 값은 필터·전송에 필요하다.
 */

/** PB d_mcn_mold_lst_tree — IMCN_MOLD + 재고 좌측 외부조인 */
export interface MoldMasterRow {
  moldCode: string;
  moldName: string | null;
  moldGroup: string | null;
  moldGroupName: string | null;
  moldSpec: string | null;
  moldUom: string | null;
  moldType: string | null;
  moldTypeName: string | null;
  moldLineType: string | null;
  moldLineTypeName: string | null;
  drawingNo: string | null;
  rawMaterial: string | null;
  punchNo: string | null;
  nationCode: string | null;
  safetyInventory: number | null;
  orderLeadtime: number | null;
  itemCode: string | null;
  itemUnitQty: number | null;
  cycleTime: number | null;
  machineCapacity: number | null;
  gasYn: string | null;
  itemGasQty: number | null;
  autoReceiptYn: string | null;
  barcode: string | null;
  comments: string | null;
  lastReceiptDate: string | null;
  lastIssueDate: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  /** 재고행이 없으면 비어 나온다 — 목록 건수를 마스터 건수로 착각하지 않도록 키를 같이 받는다 */
  moldVersion: number | null;
  moldSetSerial: number | null;
  moldRowQty: number | null;
  moldUsefullRowQty: number | null;
  moldUseStatus: string | null;
  moldUseStatusName: string | null;
  moldInOut: string | null;
  moldInOutName: string | null;
  moldWarehouseCode: string | null;
  moldWarehouseName: string | null;
  locationCode: string | null;
  breakValue: number | null;
  actualValue: number | null;
  moldSetQty: number | null;
  applyModelName: string | null;
  inventoryBarcode: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** PB d_mcn_mold_bill_lst — 소요품목 */
export interface MoldBillRow {
  moldCode: string;
  itemCode: string;
  sequence: number;
  moldVersion: number | null;
  moldSetSerial: number | null;
  breakValue: number | null;
  unitQty: number | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  moldName: string | null;
  moldSpec: string | null;
  /** F_CHECK_BOM_EXISTS — 이 품목이 BOM 에 걸려 있는지 */
  bomCheck: number | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** PB d_mcn_mold_inventory_lst — 재고 */
export interface MoldInventoryRow {
  moldCode: string;
  moldName: string | null;
  moldSpec: string | null;
  moldGroup: string | null;
  moldGroupName: string | null;
  moldVersion: number | null;
  moldSetSerial: number | null;
  moldVersionSpec: string | null;
  inventoryQty: number | null;
  inventoryPrice: number | null;
  inventoryAmt: number | null;
  lineType: string | null;
  lineTypeName: string | null;
  moldUseStatus: string | null;
  moldUseStatusName: string | null;
  moldInOut: string | null;
  moldInOutName: string | null;
  rentStatus: string | null;
  rentStatusName: string | null;
  moldRowQty: number | null;
  moldUsefullRowQty: number | null;
  moldSetQty: number | null;
  moldWarehouseCode: string | null;
  moldWarehouseName: string | null;
  locationCode: string | null;
  moldRentLocationCode: string | null;
  breakValue: number | null;
  actualValue: number | null;
  applyModelName: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  workstageName: string | null;
  machineCode: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  rentSupplierCode: string | null;
  barcode: string | null;
  cycleTime: number | null;
  lastReceiptDate: string | null;
  lastIssueDate: string | null;
  lastAdjustDate: string | null;
  scrapWeight: number | null;
  netWeight: number | null;
  grandWeight: number | null;
  comments: string | null;
  moldImageExistsYn: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** PB d_mcn_mold_purchase_order_lst — 주문 */
export interface MoldOrderRow {
  orderNo: string;
  orderGroupNo: string | null;
  purchaseOrderDate: string | null;
  deliveryDate: string | null;
  moldCode: string;
  moldName: string | null;
  moldSpec: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  orderQty: number | null;
  receiptQty: number | null;
  remainQty: number | null;
  unitPrice: number | null;
  orderAmt: number | null;
  currency: string | null;
  currencyName: string | null;
  lineType: string | null;
  lineTypeName: string | null;
  deliveryMethod: string | null;
  deliveryMethodName: string | null;
  deliveryPlace: string | null;
  attnName: string | null;
  ccName: string | null;
  incidentalExpenseCode: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 주문그룹 집계 */
export interface MoldOrderGroupRow {
  orderGroupNo: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  purchaseOrderDate: string | null;
  deliveryDateFrom: string | null;
  deliveryDateTo: string | null;
  orderCount: number | null;
  orderQty: number | null;
  receiptQty: number | null;
  orderAmt: number | null;
}

/** PB d_mcn_mold_receipt_lst — 입고 */
export interface MoldReceiptRow {
  receiptDate: string;
  receiptSequence: number;
  moldCode: string;
  moldName: string | null;
  moldSpec: string | null;
  moldVersion: number | null;
  moldSetSerial: number | null;
  moldVersionSpec: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  invoiceNo: string | null;
  orderNo: string | null;
  receiptDeficit: string | null;
  receiptDeficitName: string | null;
  receiptQty: number | null;
  unitPrice: number | null;
  receiptAmt: number | null;
  currency: string | null;
  currencyName: string | null;
  receiptStatus: string | null;
  receiptStatusName: string | null;
  locationCode: string | null;
  lineType: string | null;
  lineTypeName: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 입고 대상 목록 — 승인단가를 같이 받는다 */
export interface MoldReceiptTargetRow {
  moldCode: string;
  moldName: string | null;
  moldSpec: string | null;
  moldGroup: string | null;
  moldGroupName: string | null;
  moldUom: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  safetyInventory: number | null;
  orderLeadtime: number | null;
  lastReceiptDate: string | null;
  moldVersion: number | null;
  moldSetSerial: number | null;
  inventoryQty: number | null;
  locationCode: string | null;
  /** 단가가 없으면 -2 다 (PB 반환규약) */
  confirmedUnitPrice: number | null;
  confirmedCurrency: string | null;
}

/** PB d_mcn_mold_issue_lst — 출고 */
export interface MoldIssueRow {
  issueDate: string;
  issueSequence: number;
  moldCode: string;
  moldName: string | null;
  moldSpec: string | null;
  moldVersion: number | null;
  moldSetSerial: number | null;
  issueDeficit: string | null;
  issueDeficitName: string | null;
  issueQty: number | null;
  issuePrice: number | null;
  issueAmt: number | null;
  currency: string | null;
  currencyName: string | null;
  issueStatus: string | null;
  issueStatusName: string | null;
  moldIssueAccount: string | null;
  moldIssueAccountName: string | null;
  workstageCode: string | null;
  workstageName: string | null;
  lineCode: string | null;
  lineName: string | null;
  machineCode: string | null;
  locationCode: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  lineType: string | null;
  lineTypeName: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 출고 대상 재고 목록 */
export interface MoldIssueTargetRow {
  moldCode: string;
  moldName: string | null;
  moldSpec: string | null;
  drawingNo: string | null;
  moldGroup: string | null;
  moldGroupName: string | null;
  moldType: string | null;
  moldTypeName: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  safetyInventory: number | null;
  issueQty: number | null;
  inventoryQty: number | null;
  moldVersion: number | null;
  moldSetSerial: number | null;
  moldRowQty: number | null;
  moldUsefullRowQty: number | null;
  moldUseStatus: string | null;
  moldUseStatusName: string | null;
  moldInOut: string | null;
  moldInOutName: string | null;
  moldWarehouseCode: string | null;
  locationCode: string | null;
  breakValue: number | null;
  actualValue: number | null;
  machineCode: string | null;
  workstageCode: string | null;
  lineCode: string | null;
  unitPrice: number | null;
}

/** PB d_mcn_mold_request_lst / _4_issue_lst — 청구 */
export interface MoldRequestRow {
  moldCode: string;
  moldName?: string | null;
  moldSpec?: string | null;
  moldVersion: number | null;
  moldSetSerial: number | null;
  requestDate: string;
  requestSequence: number;
  requestQty: number | null;
  requestStatus: string | null;
  requestStatusName: string | null;
  issueDate: string | null;
  issueSequence: number | null;
  issueQty: number | null;
  inventoryQty?: number | null;
  locationCode?: string | null;
  supplierCode?: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** PB d_mcn_mold_repair_change_request_lst — 수리 */
export interface MoldRepairRow {
  moldCode: string;
  repairSequence: number;
  moldName: string | null;
  moldGroup: string | null;
  moldGroupName: string | null;
  moldVersion: number | null;
  moldSetSerial: number | null;
  repairRequestDate: string | null;
  repairDate: string | null;
  repairReceiptDate: string | null;
  repairIssueDate: string | null;
  repairStatus: string | null;
  repairStatusName: string | null;
  repairReasonCode: string | null;
  repairReasonName: string | null;
  repairType: string | null;
  repairVendorCode: string | null;
  repairVendorName: string | null;
  repairBy: string | null;
  repairQty: number | null;
  repairAmt: number | null;
  repairTime: number | null;
  currency: string | null;
  currencyName: string | null;
  applyMachineCode: string | null;
  lineCode: string | null;
  lineName: string | null;
  comments: string | null;
  repairComments: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 수리 대상 목록 — 수리주기(오늘 − 마지막 입고일)를 같이 받는다 */
export interface MoldRepairTargetRow {
  moldCode: string;
  moldName: string | null;
  moldSpec: string | null;
  drawingNo: string | null;
  moldGroup: string | null;
  moldGroupName: string | null;
  rawMaterial: string | null;
  punchNo: string | null;
  moldLineType: string | null;
  safetyInventory: number | null;
  orderLeadtime: number | null;
  nationCode: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  lastReceiptDate: string | null;
  lastIssueDate: string | null;
  comments: string | null;
  moldVersion: number | null;
  moldSetSerial: number | null;
  inventoryQty: number | null;
  moldRowQty: number | null;
  breakValue: number | null;
  actualValue: number | null;
  locationCode: string | null;
  moldUseStatus: string | null;
  moldUseStatusName: string | null;
  rentStatus: string | null;
  rentStatusName: string | null;
  moldInOut: string | null;
  moldInOutName: string | null;
  inventoryLastReceiptDate: string | null;
  repairTerm: number | null;
}

/** PB d_mcn_mold_repair_item_lst — 수리품목 */
export interface MoldRepairItemRow {
  moldCode: string;
  repairSequence: number;
  repairItemCode: string;
  repairItemName: string | null;
  repairItemSpec: string | null;
  repairItemUom: string | null;
  repairItemQty: number | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** PB d_mcn_mold_buy_price_lst_tree — 구매단가 */
export interface MoldPriceRow {
  moldCode: string;
  supplierCode: string;
  dateset: string;
  dateend: string | null;
  /** FUTURE / RUNNING / EXPIRED — PB DECODE 계산값 */
  status: string | null;
  currency: string | null;
  currencyName: string | null;
  unitPrice: number | null;
  standardUnitPrice: number | null;
  taxRate: number | null;
  lineType: string | null;
  lineTypeName: string | null;
  delivery: string | null;
  deliveryName: string | null;
  priceType: string | null;
  priceTypeName: string | null;
  approvalNo: string | null;
  priceChangeReason: string | null;
  priceChangeConfirmYn: string | null;
  priceChangeConfirmName: string | null;
  confirmBy: string | null;
  confirmDate: string | null;
  moldName: string | null;
  moldSpec: string | null;
  moldUom: string | null;
  supplierName: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}
