export type MagazineLabelViewMode = 'history' | 'summary' | 'matrix';

export interface MagazineLabelHistoryRow {
  [key: string]: string | number | null | undefined;
  magazineLabelType: string | null;
  runNo: string | null;
  magazineLabelNo?: string | null;
  enterDate?: string | null;
  lineCode: string | null;
  workstageCode?: string | null;
  receiptDate: string | null;
  modelName: string | null;
  modelSuffix?: string | null;
  itemCode?: string | null;
  pcbItem: string | null;
  lotQty: number | null;
  badQty?: number | null;
  transferMagazineLabelNo?: string | null;
  receiptSequence?: number | null;
  organizationId?: number;
}
