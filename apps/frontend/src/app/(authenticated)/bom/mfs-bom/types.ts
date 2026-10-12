/** 제품모델 한 행 (IP_PRODUCT_MODEL_MASTER) */
export interface MfsModelRow {
  modelName: string;
  modelSpec: string | null;
  modelType: string | null;
  partNo: string | null;
  customerCode: string | null;
  customerName: string | null;
  modelDivision: string | null;
  revision: string | null;
  modelSuffix: string | null;
  itemCode: string | null;
  masterModelName: string | null;
  smtModelName: string | null;
  carrierSize: string | null;
}

/** MFS 목록 한 행 — ID_MFS_BOM 을 품목+MFS 로 묶은 요약 */
export interface MfsSummaryRow {
  mfs: string;
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  rowCount: number;
  confirmedCount: number;
  usedCount: number;
  planDate: string | null;
  confirmDate: string | null;
  confirmBy: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
  comments: string | null;
}

/** MFS 상세 한 행 (ID_MFS_BOM) */
export interface MfsDetailRow {
  mfs: string;
  itemCode: string;
  parentItemCode: string;
  childItemCode: string;
  childItemName: string | null;
  childItemSpec: string | null;
  childItemUom: string | null;
  bomLevel: number | null;
  itemType: string | null;
  lineType: string | null;
  modelUnitQty: number | null;
  itemUnitQty: number | null;
  sortOrder: string | null;
  sortSequence: string | null;
  pcbItem: string | null;
  confirmYn: string | null;
  usedYn: string | null;
  dateset: string | null;
  dateend: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 피더 레이아웃 한 행 (ID_ENG_BOM_SMT 묶음) */
export interface MfsFeederRow {
  lineCode: string | null;
  lineName: string | null;
  parentItemCode: string;
  pcbItem: string | null;
  revision: string | null;
  feederShaft: string | null;
  feederShaftStatus: string | null;
  partCount: number;
}

/** 우측 패널 작업 종류 */
export type MfsPanelMode = 'generate' | 'copy';

/** 확인 모달로 실행하는 작업 */
export type MfsConfirmAction = 'drop' | 'confirm' | 'unconfirm' | 'usedY' | 'usedN';
