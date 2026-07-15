/**
 * @file AUTO-GENERATED — 직접 편집하지 마세요.
 * @description 기본 메뉴 카테고리 레이아웃 (menuConfig 카테고리 구조)
 * Source: apps/frontend/src/config/menuConfig.ts
 * Regenerate: pnpm --filter @eunsung/frontend gen:menu (또는 pnpm --filter @eunsung/frontend test)
 */
export interface DefaultMenuCategoryLayout {
  categoryCode: string;
  labelKey: string;
  sortOrder: number;
  menuCodes: readonly string[];
}

export const DEFAULT_MENU_CATEGORY_LAYOUT: readonly DefaultMenuCategoryLayout[] = [
  { categoryCode: 'MASTER', labelKey: 'menu.master', sortOrder: 10, menuCodes: ['MST_PART', 'MST_BOM', 'MST_PARTNER', 'MST_CUSTOMER', 'EQUIP_MASTER', 'MST_PROCESS', 'MST_PROD_LINE', 'MST_ROUTING', 'MST_WORK_CALENDAR', 'MST_WORKER', 'MST_WORK_INST', 'MST_WAREHOUSE', 'MST_LABEL', 'MST_PURCHASE_PRICE', 'MST_ITEM_SUPPLIER', 'MST_SALE_PRICE'] },
  { categoryCode: 'OEE', labelKey: 'menu.oee', sortOrder: 20, menuCodes: ['OEE_DASHBOARD', 'OEE_DRILLDOWN', 'OEE_LOSS', 'OEE_ENTRY', 'OEE_MST_RESOURCE', 'OEE_MST_STD_TIME', 'OEE_MST_IDLE_REASON', 'OEE_MST_EQUIP_REASON'] },
  { categoryCode: 'MATERIAL', labelKey: 'menu.material', sortOrder: 30, menuCodes: [] },
  { categoryCode: 'PROCESS_TRANSACTION', labelKey: 'menu.processTransaction', sortOrder: 40, menuCodes: [] },
  { categoryCode: 'PRODUCT_MGMT', labelKey: 'menu.productMgmt', sortOrder: 50, menuCodes: [] },
  { categoryCode: 'OUTSOURCING', labelKey: 'menu.outsourcing', sortOrder: 60, menuCodes: [] },
  { categoryCode: 'SYSTEM', labelKey: 'menu.system', sortOrder: 70, menuCodes: ['SYS_COMPANY', 'SYS_CODE', 'SYS_CONFIG', 'SYS_MENU_CATEGORY', 'SYS_DEPT', 'SYS_USER', 'SYS_SCHEDULER', 'SYS_ER_VIEW', 'SYS_IMPR_REQ'] },
];
