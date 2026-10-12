/** PB w_des_replace_bom_master 의 두 모드 (rb_replace_manage / rb_replace_list) */
export type ReplaceBomMode = 'MANAGE' | 'LIST';

/** BOM 전개 한 행 (ID_ENG_BOM_TEMP, PKG_DESIGN.BOM_QUERY 결과) */
export interface BomExpandRow {
  bomLevel: string | null;
  bomLevelNo: number | null;
  sortOrder: number | null;
  parentItemCode: string | null;
  parentItemName: string | null;
  childItemCode: string | null;
  childItemName: string | null;
  childItemSpec: string | null;
  childItemUom: string | null;
  childItemType: string | null;
  itemUnitQty: number | null;
  itemUnitQtyExt: number | null;
  modelUnitQty: number | null;
  workstageCode: string | null;
  workstageName: string | null;
  locationInfo: string | null;
  assyExplosionYn: string | null;
  lossRate: number | null;
  scrapRate: number | null;
  dateset: string | null;
  dateend: string | null;
}

/** 대체품 한 행 (ID_ITEM_REPLACE) */
export interface ReplaceRow {
  parentItemCode: string;
  childItemCode: string;
  replaceItemCode: string;
  replaceItemName: string | null;
  replaceItemSpec: string | null;
  replaceItemUom: string | null;
  replaceSequence: number | null;
  itemUnitQty: number | null;
  itemUnitQtyExt: number | null;
  workstageCode: string | null;
  workstageName: string | null;
  bomLocationCode: string | null;
  dateset: string | null;
  dateend: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
  organizationId: number;
}

/** 대체품 등록/수정 폼 */
export interface ReplaceForm {
  parentItemCode: string;
  childItemCode: string;
  replaceItemCode: string;
  workstageCode: string;
  itemUnitQty: number;
  dateset: string;
  dateend: string;
  bomLocationCode: string;
}
