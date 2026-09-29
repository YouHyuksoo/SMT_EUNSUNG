/**
 * @file src/app/(authenticated)/smt/types.ts
 * @description SMT(M_SMT) 9화면이 공유하는 행 타입.
 *
 * 백엔드가 내리는 키 이름을 그대로 쓴다. 키 컬럼은 수정 폼에서 잠기므로
 * 어느 것이 키인지 주석으로 적어 둔다 — 열어두면 UPDATE 의 WHERE 가 빗나간다.
 */

/** PB d_ib_line_master_lst. 키 = lineCode + machine + 조직 */
export interface SmtLineRow {
  lineCode: string;
  machine: string;
  lineName: string | null;
  machineName: string | null;
  lineDivision: string | null;
  lineStatus: string | null;
  lineStatusName: string | null;
  machineGroup: string | null;
  showTableYn: string | null;
  actionDate: string | null;
  locationCount: number;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** PB d_ib_machine_location_lst / d_ib_location_master_lst. 키 = lineCode + locationCode + 조직 */
export interface SmtLocationRow {
  lineCode: string;
  machine: string;
  locationCode: string;
  tableId: string | null;
  tableNo: string | null;
  comments: string | null;
  lineName?: string | null;
  machineName?: string | null;
  planUseCount?: number;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** PB d_des_bom_smt_replace_lst. 키 = parent + child + replace + lineCode + locationCode + 조직 */
export interface SmtBomReplaceRow {
  parentItemCode: string;
  childItemCode: string;
  replaceItemCode: string;
  lineCode: string;
  locationCode: string;
  machine: string | null;
  modelName: string | null;
  tableId: string | null;
  pcbItem: string | null;
  pcbItemName: string | null;
  dateSet: string | null;
  dateEnd: string | null;
  sortSequence: number | null;
  itemUnitQty: number | null;
  workstageCode: string | null;
  bomLevel: number | null;
  itemType: string | null;
  itemTypeName: string | null;
  lineType: string | null;
  lineTypeName: string | null;
  revision: string | null;
  feederShaft: string | null;
  smtModelName: string | null;
  comments: string | null;
  childItemName: string | null;
  childItemSpec: string | null;
  childItemUom: string | null;
  parentItemName: string | null;
  parentItemSpec: string | null;
  replaceItemName: string | null;
  replaceItemSpec: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** PB d_des_bom_smt_create_lst. 키 = parent + child + dateSet + locationCode + lineCode + machine + pcbItem + 조직 */
export interface SmtBomRow {
  parentItemCode: string;
  childItemCode: string;
  lineCode: string;
  machine: string;
  locationCode: string;
  locationInfo: string | null;
  pcbItem: string;
  pcbItemName: string | null;
  tableId: string | null;
  dateSet: string;
  dateEnd: string;
  sortSequence: number | null;
  itemUnitQty: number | null;
  workstageCode: string | null;
  bomLevel: number | null;
  itemType: string | null;
  itemTypeName: string | null;
  lineType: string | null;
  lineTypeName: string | null;
  revision: string | null;
  feederShaft: string | null;
  feederType: string | null;
  smtModelName: string | null;
  modelName: string | null;
  comments: string | null;
  childItemName: string | null;
  childItemSpec: string | null;
  childItemUom: string | null;
  childItemUomName: string | null;
  parentItemName: string | null;
  parentItemSpec: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** PB d_smt_plandata_lst */
export interface SmtPlanRow {
  modelName: string;
  modelSuffix: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  lineCode: string;
  lineName: string | null;
  machine: string;
  machineName: string | null;
  locationCode: string;
  locationInfo: string | null;
  tableId: string | null;
  pcbItem: string | null;
  pcbItemName: string | null;
  planDate: string | null;
  planDateSequence: number | null;
  itemUnitQty: number | null;
  feedingQty: number | null;
  checkYn: string | null;
  checkStatus: string | null;
  checkStatusName: string | null;
  checkMsg: string | null;
  activeYn: string | null;
  activeYnName: string | null;
  ccsYn: string | null;
  ccsYnName: string | null;
  replaceYn: string | null;
  fullCheckYn: string | null;
  fullCheckTime: string | null;
  revision: string | null;
  feederShaft: string | null;
  lotNo: string | null;
  itemBarcode: string | null;
  feedingDate: string | null;
  feedingEndDate: string | null;
  changeDate: string | null;
  recycleDate: string | null;
  smtModelName: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 라인별 배포 요약 (IP_PRODUCT_LINE 기준) */
export interface SmtPlanLineRow {
  lineCode: string;
  lineName: string | null;
  lineStatus: string | null;
  nsnpStatus: string | null;
  displaySequence: number | null;
  planRows: number;
  activeModelName: string | null;
  activeModelCount: number;
}

/** PB d_smt_plandata_list_rpt — 라벨·바코드 목록 */
export interface SmtBomReportRow {
  replaceYn: string | null;
  modelName: string;
  itemCode: string | null;
  itemUnitQty: number | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  locationAddress: string | null;
  feederType: string | null;
  mslLevel: string | null;
  parentItemName: string | null;
  parentItemSpec: string | null;
  locationCode: string | null;
  lineCode: string | null;
  machine: string | null;
  tableId: string | null;
  pcbItem: string | null;
  revision: string | null;
  lineName: string | null;
  machineName: string | null;
  lineDivision: string | null;
  lineCodeBarcode: string | null;
  locationBarcode: string | null;
  parentItemBarcode: string | null;
  pcbItemCode: string | null;
  pcbItemBarcode: string | null;
  unitPrice: number | null;
}

/** 위치 비교 결과 한 줄 — 모델별 자리 목록을 가로로 펼친 것 */
export interface SmtCompareRow {
  childItemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  byModel: Record<string, string>;
  diff: boolean;
  missingIn: string[];
}

/** BOM 전개 결과 (PKG_DESIGN.BOM_QUERY) */
export interface SmtBomExplodeRow {
  parentItemCode: string;
  childItemCode: string;
  bomLevelIndent: string | null;
  bomLevel: number | null;
  sortSequence: number | null;
  sortOrder: number | null;
  itemUnitQty: number | null;
  modelUnitQty: number | null;
  locationInfo: string | null;
  lineType: string | null;
  parentItemName: string | null;
  parentItemSpec: string | null;
  itemClass: string | null;
  childItemName: string | null;
  childItemSpec: string | null;
  childItemUom: string | null;
  feederLocations: string | null;
}

/** PB IB_MNT_PLANDATA — 적재된 마운터 배치표 */
export interface SmtNcRow {
  lineCode: string | null;
  machineCode: string | null;
  machineGroup: string | null;
  modelName: string | null;
  lotName: string | null;
  tableId: string | null;
  address: string | null;
  position: string | null;
  partName: string | null;
  chipName: string | null;
  pcbItem: string | null;
  itemUnitQty: number | null;
  feederType: string | null;
  locationInfo: string | null;
  planDate: string | null;
  partItemName: string | null;
  partItemSpec: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 중복 적재 검증 결과 */
export interface SmtNcDuplicateRow {
  dupCount: number;
  lineCode: string | null;
  machineCode: string | null;
  lotName: string | null;
  modelName: string | null;
  tableId: string | null;
  address: string | null;
  position: string | null;
  pcbItem: string | null;
  partName: string | null;
  locationInfo: string | null;
}

/** 피더 ↔ BOM 대조 결과 */
export interface SmtNcCompareRow {
  itemCode: string;
  bomQty: number;
  feederQty: number;
  bomRows: number;
  feederRows: number;
  onlyInBom: boolean;
  onlyInFeeder: boolean;
  qtyDiff: number;
  diff: boolean;
}

/** PB d_mcn_feeder_pickup_lst */
export interface SmtPickupRow {
  productDate: string | null;
  lineCode: string | null;
  lineName: string | null;
  modelName: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  feederId: string | null;
  feederType: string | null;
  transferCount: number | null;
  adsorptionErrorCount: number | null;
  pickupRate: number | null;
  pickupStatus: string | null;
  actionPlan: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}
