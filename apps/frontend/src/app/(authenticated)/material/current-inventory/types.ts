export interface CurrentInventoryRow {
  materialMfs: string | null;
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  itemDivision: string | null;
  locationAddress: string | null;
  lineType: string | null;
  inventoryStatus: string | null;
  inventoryHold: string | null;
  inventoryPrice: number | null;
  inventoryQty: number | null;
  inventoryAmt: number | null;
  locationCode: string | null;
  comments: string | null;
  manufactureWeek: string | null;
  lastReceiptDate: string | null;
  bakingDate: string | null;
  enterDate: string | null;
  enterBy: string | null;
  lastModifyDate: string | null;
  lastModifyBy: string | null;
  organizationId: number;
}
