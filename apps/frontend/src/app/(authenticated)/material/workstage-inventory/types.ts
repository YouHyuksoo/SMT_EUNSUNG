export interface WorkstageInventoryRow {
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  inventoryQty: number | null;
  enterDate: string | null;
  enterBy: string | null;
  lastModifyDate: string | null;
  lastModifyBy: string | null;
  organizationId: number;
}
