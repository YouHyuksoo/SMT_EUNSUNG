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
  { categoryCode: 'MATERIAL', labelKey: 'menu.material', sortOrder: 30, menuCodes: [] },
  { categoryCode: 'PROCESS_TRANSACTION', labelKey: 'menu.processTransaction', sortOrder: 40, menuCodes: [] },
  { categoryCode: 'PRODUCT_MGMT', labelKey: 'menu.productMgmt', sortOrder: 50, menuCodes: [] },
  { categoryCode: 'OUTSOURCING', labelKey: 'menu.outsourcing', sortOrder: 60, menuCodes: [] },
];
