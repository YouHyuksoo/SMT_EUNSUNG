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
  { categoryCode: 'MASTER', labelKey: 'menu.master', sortOrder: 10, menuCodes: ['MST_PART', 'MST_BOM', 'MST_PARTNER', 'EQUIP_MASTER', 'MST_PROCESS', 'MST_PROD_LINE', 'MST_ROUTING', 'MST_WORK_CALENDAR', 'MST_WORKER', 'MST_WORK_INST', 'MST_WAREHOUSE', 'MST_LABEL', 'MST_PROCESS_CAPA'] },
  { categoryCode: 'SYSTEM', labelKey: 'menu.system', sortOrder: 20, menuCodes: ['SYS_COMPANY', 'SYS_CODE', 'SYS_CONFIG', 'SYS_MENU_CATEGORY', 'SYS_DEPT', 'SYS_USER', 'SYS_ROLE', 'SYS_DOCUMENT', 'SYS_SCHEDULER', 'SYS_ER_VIEW', 'SYS_IMPR_REQ'] },
  { categoryCode: 'OEE', labelKey: 'menu.oee', sortOrder: 30, menuCodes: ['OEE_DASHBOARD', 'OEE_DRILLDOWN', 'OEE_LOSS', 'OEE_ENTRY', 'OEE_MST_RESOURCE', 'OEE_MST_REASON'] },
  { categoryCode: 'MATERIAL', labelKey: 'menu.material', sortOrder: 40, menuCodes: [] },
  { categoryCode: 'PROCESS_TRANSACTION', labelKey: 'menu.processTransaction', sortOrder: 50, menuCodes: [] },
  { categoryCode: 'PRODUCT_MGMT', labelKey: 'menu.productMgmt', sortOrder: 60, menuCodes: [] },
  { categoryCode: 'OUTSOURCING', labelKey: 'menu.outsourcing', sortOrder: 70, menuCodes: [] },
];
