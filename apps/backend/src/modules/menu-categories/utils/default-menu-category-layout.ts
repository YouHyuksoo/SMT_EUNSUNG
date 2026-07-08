/**
 * Default menu category layout copied from the frontend sidebar menuConfig.
 * Keep this file in sync with apps/frontend/src/config/menuConfig.ts.
 */
export interface DefaultMenuCategoryLayout {
  categoryCode: string;
  labelKey: string;
  sortOrder: number;
  menuCodes: readonly string[];
}

export const DEFAULT_MENU_CATEGORY_LAYOUT: readonly DefaultMenuCategoryLayout[] = [
  { categoryCode: 'MASTER', labelKey: 'menu.master', sortOrder: 10, menuCodes: ['MST_PART', 'MST_BOM', 'MST_PARTNER', 'EQUIP_MASTER', 'MST_PROCESS', 'MST_PROD_LINE', 'MST_ROUTING', 'MST_WORK_CALENDAR', 'MST_WORKER', 'MST_WORK_INST', 'MST_WAREHOUSE', 'SYS_COMPANY', 'SYS_CODE', 'MST_LABEL', 'MST_PROCESS_CAPA', 'SYS_DOCUMENT'] },
  { categoryCode: 'OEE', labelKey: 'menu.oee', sortOrder: 20, menuCodes: ['OEE_DASHBOARD', 'OEE_DRILLDOWN', 'OEE_LOSS', 'OEE_ENTRY', 'OEE_MST_RESOURCE', 'OEE_MST_REASON'] },
  { categoryCode: 'MATERIAL', labelKey: 'menu.material', sortOrder: 30, menuCodes: ['MAT_REQUEST', 'MAT_REQUEST_OTHER', 'MAT_ISSUE', 'MAT_ISSUE_OTHER', 'MAT_ISSUE_HIST', 'MAT_LOT', 'MAT_LOT_SPLIT', 'MAT_LOT_MERGE', 'MAT_SHELF_LIFE', 'MAT_SHELF_LIFE_REINSPECT', 'MAT_SHELF_LIFE_HISTORY', 'MAT_SCRAP', 'MAT_STOCK_TRANSFER', 'MAT_ADJUSTMENT', 'MAT_MISC_RECEIPT', 'MAT_RECEIPT_CANCEL', 'INV_MAT_STOCK', 'INV_TRANSACTION', 'INV_MAT_PHYSICAL_INV', 'INV_MAT_PHYSICAL_INV_APPLY', 'INV_MAT_PHYSICAL_INV_HISTORY', 'MAT_HOLD'] },
  { categoryCode: 'PROCESS_TRANSACTION', labelKey: 'menu.processTransaction', sortOrder: 40, menuCodes: [] },
  { categoryCode: 'PRODUCT_MGMT', labelKey: 'menu.productMgmt', sortOrder: 50, menuCodes: [] },
  { categoryCode: 'OUTSOURCING', labelKey: 'menu.outsourcing', sortOrder: 60, menuCodes: [] },
];
