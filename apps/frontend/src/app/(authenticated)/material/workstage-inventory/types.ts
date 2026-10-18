export interface WorkstageInventoryRow {
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  itemDivision: string | null;
  itemClass: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  modelName: string | null;
  locationAddress: string | null;
  inventoryQty: number | null;
  enterDate: string | null;
  enterBy: string | null;
  lastModifyDate: string | null;
  lastModifyBy: string | null;
  organizationId: number;
}

/** 공정별 공정재고 (공정이 정해진 행) */
export interface WorkstageByWsRow {
  workstageCode: string;
  workstageName: string | null;
  itemCode: string;
  itemName: string | null;
  itemDivision: string | null;
  inventoryQty: number;
  lastModifyDate: string | null;
  lastModifyBy: string | null;
}

/** 공정간 이동 — 후공정 매거진 스캔 */
export interface WorkstageMoveRow {
  moveDate: string;
  magazineLabelNo: string;
  fromWorkstageCode: string;
  fromWorkstageName: string | null;
  toWorkstageCode: string;
  toWorkstageName: string | null;
  itemCode: string;
  itemName: string | null;
  moveQty: number;
  runNo: string | null;
  lineCode: string | null;
  enterBy: string | null;
}

export interface WorkstageProductRow {
  modelName: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemDivision: string | null;
  boxCount: number;
  packQty: number | null;
  firstPackDate: string | null;
  lastPackDate: string | null;
}
