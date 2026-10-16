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
