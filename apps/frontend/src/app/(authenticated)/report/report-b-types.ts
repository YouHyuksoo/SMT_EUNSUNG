/**
 * @file src/app/(authenticated)/report/report-b-types.ts
 * @description 리포트 B그룹 행 타입 — 자재 원장 7화면 + S-PARTS·지그·4M 6화면
 *
 * 전부 조회 전용이다 (13화면 모두 PB 에 쓰기 경로가 없다 — 실측).
 * 시각은 서버가 'YYYY-MM-DD HH24:MI:SS' 문자열로 만들어 보낸다 (KST 보존).
 *
 * **0행인 표가 많다** (실측): S-PARTS 계열 전부 · 지그출고 · 자재랙이동 ·
 * 자재작업지시 · 모델 S/W 마스터. 화면은 동작하지만 볼 것이 없다.
 */

/** 362 자재 바코드 스캔 이력 한 줄 */
export interface MaterialBarcodeSlipRow {
  itemBarcode: string;
  supplierBarcode: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  itemCode: string | null;
  supplierItemCode: string | null;
  lotNo: string | null;
  supplierLotNo: string | null;
  scanQty: number | null;
  scanDate: string | null;
  receiptSlipNo: string | null;
  receiptType: string | null;
  receiptCompareYn: string | null;
  receiptCompareDate: string | null;
  receiptCompareBy: string | null;
  issueType: string | null;
  issueCompareYn: string | null;
  issueCompareDate: string | null;
  issueCompareBy: string | null;
  barcodeStatus: string | null;
  labelType: string | null;
  /** 'Y' 면 롯트를 쪼갠 바코드다. PB 는 이 값만 봤다. */
  lotDivideYn: string | null;
  originItemBarcode: string | null;
  originSupplierCode: string | null;
  fromSupplierCode: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 363 입고 상세 한 줄 */
export interface MaterialReceiptRow {
  receiptDate: string | null;
  receiptSequence: number | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  itemClass: string | null;
  locationAddress: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  fromSupplierCode: string | null;
  locationCode: string | null;
  receiptDeficit: string | null;
  receiptType: string | null;
  orderType: string | null;
  lineType: string | null;
  receiptQty: number | null;
  unitPrice: number | null;
  /** 기준단가. 입고단가와 다르면 단가확인이 안 된 입고다 (DB 함수가 계산). */
  checkUnitPrice: number | null;
  receiptAmt: number | null;
  materialCostAmt: number | null;
  exchangeRate: number | null;
  foreignReceiptAmt: number | null;
  currency: string | null;
  invoiceNo: string | null;
  subcontractInvoiceNo: string | null;
  mfs: string | null;
  materialMfs: string | null;
  originMfs: string | null;
  receiptLotNo: string | null;
  barcode: string | null;
  receiptStatus: string | null;
  confirmYn: string | null;
  confirmDate: string | null;
  comments: string | null;
  receiptCompareYn: string | null;
  receiptSlipNo: string | null;
  barcodeEnterDate: string | null;
  vendorLotNo: string | null;
  vendorCode: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 363 협력사별·반품 한 줄 (상세보다 열이 적다) */
export interface MaterialReceiptSupplierRow {
  receiptDate: string | null;
  receiptSequence: number | null;
  supplierCode: string | null;
  supplierName: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  locationCode: string | null;
  receiptDeficit: string | null;
  receiptType: string | null;
  orderType: string | null;
  lineType: string | null;
  receiptQty: number | null;
  unitPrice: number | null;
  receiptAmt: number | null;
  materialCostAmt: number | null;
  exchangeRate: number | null;
  foreignReceiptAmt: number | null;
  currency: string | null;
  invoiceNo: string | null;
  mfs: string | null;
  materialMfs: string | null;
  receiptLotNo: string | null;
  barcode: string | null;
  receiptStatus: string | null;
  confirmYn: string | null;
  confirmDate: string | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/**
 * 363 매트릭스 원자료 한 줄 (품목 × 일자).
 * 열 집합(일자)이 기간에 따라 달라지므로 피벗은 화면에서 한다.
 */
export interface MaterialReceiptMatrixRow {
  receiptDate: string;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  receiptQty: number | null;
  receiptAmt: number | null;
  foreignReceiptAmt: number | null;
}

/** 364 품목별 입고합계 한 줄. 연락처 세 칸은 '협력사용' 탭에만 채워진다. */
export interface MaterialReceiptSumItemRow {
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  virtualReceiptYn: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  supplierAddress: string | null;
  supplierTelNo: string | null;
  supplierFaxNo: string | null;
  receiptType: string | null;
  invoiceNo: string | null;
  receiptQty: number | null;
  /** PB 와 같이 단순 평균이다 (수량 가중이 아니다). */
  receiptPrice: number | null;
  receiptAmt: number | null;
  foreignReceiptAmt: number | null;
}

/** 364 협력사별 입고합계 한 줄 */
export interface MaterialReceiptSumSupplierRow {
  supplierCode: string | null;
  supplierName: string | null;
  receiptType: string | null;
  invoiceNo: string | null;
  receiptQty: number | null;
  receiptAmt: number | null;
  foreignReceiptAmt: number | null;
}

/** 364 창고별 입고합계 한 줄 */
export interface MaterialReceiptSumWarehouseRow {
  locationCode: string | null;
  locationName: string | null;
  receiptType: string | null;
  receiptQty: number | null;
  receiptAmt: number | null;
  foreignReceiptAmt: number | null;
}

/** 364 입출고 매트릭스 원자료 한 줄. `txnKind` 로 입고·출고를 가른다. */
export interface MaterialTxnMatrixRow {
  txnDate: string;
  txnKind: 'RECEIPT' | 'ISSUE';
  itemCode: string | null;
  locationCode: string | null;
  locationName: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  deficit: string | null;
  deficitName: string | null;
  qty: number | null;
}

/**
 * 365 출고 상세 한 줄.
 *
 * **풀체크 시각은 이 행에 없다.** 목록 열로 붙이면 1만행에 367초가 걸려
 * (LIKE 접두어가 컬럼 연결식이라 인덱스를 못 쓴다 — 실측) 행을 고를 때
 * `/report/material-issue/full-check` 로 한 건만 조회한다. 그 조회에
 * `issueDateKey` 를 그대로 되돌려 보낸다.
 */
export interface MaterialIssueRow {
  issueDate: string | null;
  issueSequence: number | null;
  /** 풀체크 단건 조회에 되돌려 줄 불투명 키 (YYYYMMDDHH24MISS). */
  issueDateKey: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  abcGrade: string | null;
  locationAddress: string | null;
  virtualReceiptYn: string | null;
  parentItemCode: string | null;
  itemType: string | null;
  lineCode: string | null;
  workstageCode: string | null;
  locationCode: string | null;
  issueDeficit: string | null;
  issueType: string | null;
  issueAccount: string | null;
  issueStatus: string | null;
  lineType: string | null;
  issueQty: number | null;
  issueAmt: number | null;
  unitPrice: number | null;
  mfs: string | null;
  materialMfs: string | null;
  modelName: string | null;
  barcode: string | null;
  invoiceNo: string | null;
  supplierCode: string | null;
  feederLocationCode: string | null;
  feederShaft: string | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 365 미출고 한 줄. 이 표(IM_ITEM_WORK_ORDER)는 현재 0행이다. */
export interface MaterialNotIssuedRow {
  issueDate: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  parentItemCode: string | null;
  itemType: string | null;
  lineCode: string | null;
  workstageCode: string | null;
  mfs: string | null;
  planYyyymm: string | null;
  issuePlanQty: number | null;
  issueQty: number | null;
  remainQty: number | null;
  issueStatus: string | null;
  issueAccount: string | null;
  lineType: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 365 SMT 풀체크 이력 한 줄 */
export interface SmtCheckHistoryRow {
  checkDate: string | null;
  lotName: string | null;
  partName: string | null;
  scanPartName: string | null;
  lineCode: string | null;
  locationCode: string | null;
  pcbItem: string | null;
  oldBarcode: string | null;
  checkType: string | null;
  checkSequence: number | null;
  checkStatus: string | null;
  /** 재활용 시각. 모든 줄에 같은 값이 온다 (PB 와 같은 형태). */
  recycleDate: string | null;
}

/** 366 품목별 출고합계 한 줄 */
export interface MaterialIssueSumItemRow {
  itemCode: string | null;
  lineType: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  issueQty: number | null;
  issueAmt: number | null;
}

/** 366 출고계정별 합계 한 줄 */
export interface MaterialIssueSumAccountRow {
  issueAccount: string | null;
  itemCode: string | null;
  lineType: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  issueQty: number | null;
  issueAmt: number | null;
}

/** 367 랙 이동 한 줄. 이 표는 현재 0행이다. */
export interface MaterialRackMoveRow {
  moveDate: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  materialMfs: string | null;
  fromRack: string | null;
  toRack: string | null;
}

/** 368 장기재고 한 줄. `idleDays` 는 기준일에서 마지막 입고까지의 일수다. */
export interface MaterialLongTermRow {
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  materialMfs: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  inventoryQty: number | null;
  locationAddressRack: string | null;
  lastReceiptDate: string | null;
  idleDays: number | null;
}

/** 369 롯트별 재고 상세 한 줄 */
export interface MaterialInventoryRow {
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  safetyInventory: number | null;
  materialMfs: string | null;
  lineType: string | null;
  locationCode: string | null;
  inventoryQty: number | null;
  inventoryPrice: number | null;
  inventoryAmt: number | null;
  inventoryHold: string | null;
  inventoryStatus: string | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 369 품목별 재고합계 한 줄 */
export interface MaterialInventorySummaryRow {
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  itemClass: string | null;
  lineType: string | null;
  inventoryStatus: string | null;
  inventoryQty: number | null;
  inventoryAmt: number | null;
  inventoryPrice: number | null;
}

/**
 * 369 일일 재고 한 줄.
 *
 * `workstageInventoryQty` 는 **PB 와 집계 기준이 다르다.** PB 가 부르는
 * `F_GET_MAT_WS_ITEM_INV_QTY` 는 INVALID 상태라 (없는 컬럼을 참조한다) 쓸 수
 * 없어 (품목 + 조직) 으로 직접 합산한다. PB 는 (품목 + 구매유형) 으로 불렀다.
 */
export interface MaterialInventoryDailyRow {
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  lineType: string | null;
  locationCode: string | null;
  inventoryStatus: string | null;
  inventoryQty: number | null;
  receiptQty: number | null;
  issueQty: number | null;
  workstageInventoryQty: number | null;
}

/** 369 불용재고 한 줄 */
export interface MaterialDisusedRow {
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  safetyInventory: number | null;
  materialMfs: string | null;
  lineType: string | null;
  locationCode: string | null;
  inventoryQty: number | null;
  inventoryPrice: number | null;
  inventoryAmt: number | null;
  inventoryHold: string | null;
  inventoryStatus: string | null;
  comments: string | null;
  /** 개월수 안의 출고량. 0 이면 그 기간에 한 번도 안 나갔다. */
  issueQty: number | null;
  lastIssueDate: string | null;
}

/** 354 S-PARTS 입고 한 줄. 이 표는 현재 0행이다. */
export interface MoldReceiptRow {
  receiptDate: string | null;
  receiptSequence: number | null;
  moldCode: string | null;
  moldName: string | null;
  moldSpec: string | null;
  moldGroup: string | null;
  itemCode: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  invoiceNo: string | null;
  orderNo: string | null;
  receiptDeficit: string | null;
  receiptQty: number | null;
  unitPrice: number | null;
  receiptAmt: number | null;
  currency: string | null;
  receiptStatus: string | null;
  locationCode: string | null;
  lineType: string | null;
  moldVersion: string | null;
  moldSetSerial: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 355 S-PARTS 출고 한 줄. 이 표는 현재 0행이다. */
export interface MoldIssueRow {
  issueDate: string | null;
  issueSequence: number | null;
  moldCode: string | null;
  moldName: string | null;
  moldSpec: string | null;
  moldGroup: string | null;
  workstageCode: string | null;
  lineCode: string | null;
  machineCode: string | null;
  issueDeficit: string | null;
  moldIssueAccount: string | null;
  issueQty: number | null;
  issuePrice: number | null;
  issueAmt: number | null;
  currency: string | null;
  issueStatus: string | null;
  moldVersion: string | null;
  moldSetSerial: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 357 지그 한 줄. `barcodeText` 는 라벨에 찍는 값이다 (라벨 자체는 CSV 로 낸다). */
export interface JigReportRow {
  jigCode: string;
  jigLotNo: string | null;
  barcodeText: string | null;
  jigName: string | null;
  jigSpec: string | null;
  jigType: string | null;
  jigStatus: string | null;
  jigModelName: string | null;
  useStatus: string | null;
  workstageCode: string | null;
  nationCode: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  acquisitionType: string | null;
  acquisitionDate: string | null;
  breakValue: number | null;
  hitValue: number | null;
}

/** 357 지그 이력카드 한 줄. 수리 기록이 없는 지그는 수리 칸이 비어 있다. */
export interface JigCardRow {
  jigCode: string;
  jigLotNo: string | null;
  jigName: string | null;
  jigType: string | null;
  jigStatus: string | null;
  jigModelName: string | null;
  workstageCode: string | null;
  acquisitionType: string | null;
  acquisitionDate: string | null;
  repairSequence: number | null;
  repairStatus: string | null;
  repairReasonCode: string | null;
  repairDate: string | null;
  repairTime: number | null;
  repairBy: string | null;
  repairComments: string | null;
}

/** 357 지그 출고 한 줄. 이 표는 현재 0행이다. */
export interface JigIssueReportRow {
  issueDate: string | null;
  issueSequence: number | null;
  jigCode: string | null;
  jigLotNo: string | null;
  jigType: string | null;
  jigStatus: string | null;
  workstageCode: string | null;
  machineCode: string | null;
  issueDeficit: string | null;
  issueAccount: string | null;
  issueQty: number | null;
  issueStatus: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 358 S-PARTS 마스터 + 재고 한 줄. 두 표 모두 현재 0행이다. */
export interface MoldReportRow {
  moldCode: string;
  moldName: string | null;
  moldSpec: string | null;
  moldGroup: string | null;
  moldType: string | null;
  drawingNo: string | null;
  rawMaterial: string | null;
  punchNo: string | null;
  moldLineType: string | null;
  itemCode: string | null;
  itemUnitQty: number | null;
  gasYn: string | null;
  itemGasQty: number | null;
  safetyInventory: number | null;
  orderLeadtime: number | null;
  nationCode: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  comments: string | null;
  barcodeText: string | null;
  moldVersion: string | null;
  moldSetSerial: string | null;
  moldSetQty: number | null;
  moldRowQty: number | null;
  moldUsefullRowQty: number | null;
  moldUseStatus: string | null;
  inventoryQty: number | null;
  locationCode: string | null;
  moldWarehouseCode: string | null;
  applyModelName: string | null;
  breakValue: number | null;
  actualValue: number | null;
  rentStatus: string | null;
  inventorySupplierCode: string | null;
  lastReceiptDate: string | null;
  lastIssueDate: string | null;
}

/** 358 S-PARTS 이력카드 한 줄. 현재 0행이다. */
export interface MoldCardRow {
  moldCode: string;
  moldName: string | null;
  moldSpec: string | null;
  moldGroup: string | null;
  moldType: string | null;
  itemCode: string | null;
  supplierCode: string | null;
  moldVersion: string | null;
  moldSetSerial: string | null;
  moldRowQty: number | null;
  moldUsefullRowQty: number | null;
  moldUseStatus: string | null;
  moldWarehouseCode: string | null;
  breakValue: number | null;
  actualValue: number | null;
  rentSupplierCode: string | null;
  comments: string | null;
  lastReceiptDate: string | null;
  lastAdjustDate: string | null;
  repairSequence: number | null;
  repairStatus: string | null;
  repairReasonCode: string | null;
  repairDate: string | null;
  repairTime: number | null;
  repairBy: string | null;
  repairComments: string | null;
}

/**
 * 360 4M 변경이력 한 줄.
 * S/W 두 칸은 원천 표(IP_PRODUCT_SOFTWARE_MASTER)가 0행이라 항상 비어 있다.
 */
export interface FourMHistoryRow {
  modelName: string | null;
  modelSuffix: string | null;
  version: string | null;
  itemCode: string | null;
  hwVersion: string | null;
  swVersionOut: string | null;
  swVersionIn: string | null;
}
