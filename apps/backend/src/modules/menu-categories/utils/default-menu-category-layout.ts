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
  { categoryCode: 'MASTER', labelKey: 'menu.master', sortOrder: 10, menuCodes: ['MST_PART', 'MST_PRODUCT_MODEL', 'MST_BOM', 'MST_PARTNER', 'MST_CUSTOMER', 'EQUIP_MASTER', 'OEE_MST_STD_TIME', 'OEE_MST_IDLE_REASON', 'OEE_MST_EQUIP_REASON', 'MST_PROCESS', 'MST_PROD_LINE', 'MST_ROUTING', 'MST_WORK_CALENDAR', 'MST_WORKER', 'MST_WORK_INST', 'MST_WAREHOUSE', 'MST_LABEL', 'MST_PURCHASE_PRICE', 'MST_ITEM_SUPPLIER', 'MST_SALE_PRICE'] },
  { categoryCode: 'BOM_MANAGEMENT', labelKey: 'menu.bom', sortOrder: 20, menuCodes: ['BOM_REPLACE'] },
  { categoryCode: 'EQUIPMENT', labelKey: 'menu.equipment', sortOrder: 30, menuCodes: ['EQUIP_RESULT_SP', 'EQUIP_RESULT_SPI', 'EQUIP_RESULT_ICT', 'EQUIP_RESULT_AOI', 'EQUIP_RESULT_ROUTER', 'EQUIP_RESULT_ROM_WRITE', 'EQUIP_RESULT_SOLDER', 'EQUIP_RESULT_REFLOW', 'EQUIP_RESULT_PERFORMANCE'] },
  { categoryCode: 'OEE', labelKey: 'menu.oee', sortOrder: 40, menuCodes: ['OEE_DASHBOARD', 'OEE_MULTI_ENTRY', 'OEE_OVERALL_STATUS', 'OEE_EQUIP_WORK_RESULT', 'OEE_EQUIP_OPS_STATUS', 'OEE_FIELD_OPS'] },
  { categoryCode: 'MATERIAL', labelKey: 'menu.material', sortOrder: 50, menuCodes: ['MAT_RECEIPT_ISSUE_LEDGER', 'MAT_CURRENT_INVENTORY', 'MAT_WORKSTAGE_INVENTORY', 'MAT_RECEIPT_CANCEL'] },
  { categoryCode: 'PROCESS_TRANSACTION', labelKey: 'menu.processTransaction', sortOrder: 60, menuCodes: ['PLN_MAGAZINE_LABEL_HISTORY'] },
  { categoryCode: 'PRODUCT_MGMT', labelKey: 'menu.productMgmt', sortOrder: 70, menuCodes: [] },
  { categoryCode: 'PRODUCT_INVENTORY', labelKey: 'menu.productInventory', sortOrder: 80, menuCodes: ['PRD_CURRENT_INVENTORY'] },
  { categoryCode: 'PRODUCTION', labelKey: 'menu.production', sortOrder: 90, menuCodes: ['PRD_RUN_CARD'] },
  { categoryCode: 'QUALITY', labelKey: 'menu.quality', sortOrder: 100, menuCodes: ['QC_REPAIR_HISTORY', 'QC_PRODUCT_DESTROY'] },
  { categoryCode: 'OUTSOURCING', labelKey: 'menu.outsourcing', sortOrder: 110, menuCodes: [] },
  { categoryCode: 'SYSTEM', labelKey: 'menu.system', sortOrder: 120, menuCodes: ['SYS_COMPANY', 'SYS_CODE', 'SYS_CONFIG', 'SYS_MENU_CATEGORY', 'SYS_DEPT', 'SYS_USER', 'SYS_SCHEDULER', 'SYS_ER_VIEW', 'SYS_IMPR_REQ'] },
];
