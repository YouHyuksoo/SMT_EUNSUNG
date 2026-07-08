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
  { categoryCode: '__ROOT__', labelKey: 'menu.root', sortOrder: 0, menuCodes: ['DASHBOARD', 'WORKFLOW'] },
  { categoryCode: 'MONITORING', labelKey: 'menu.monitoring', sortOrder: 30, menuCodes: ['MON_EQUIP_STATUS'] },
  { categoryCode: 'OEE', labelKey: 'menu.oee', sortOrder: 40, menuCodes: ['OEE_DASHBOARD', 'OEE_DRILLDOWN', 'OEE_LOSS', 'OEE_ENTRY', 'OEE_MST_RESOURCE', 'OEE_MST_REASON'] },
  { categoryCode: 'MASTER', labelKey: 'menu.master', sortOrder: 50, menuCodes: ['MST_PART', 'MST_BOM', 'MST_PARTNER', 'EQUIP_MASTER', 'MST_PROCESS', 'MST_PROD_LINE', 'MST_ROUTING', 'MST_WORK_CALENDAR', 'MST_WORKER', 'MST_WORK_INST', 'MST_WAREHOUSE', 'MST_LABEL', 'MST_VENDOR_BARCODE', 'MST_PROCESS_CAPA', 'SYS_DOCUMENT'] },
  { categoryCode: 'MATERIAL', labelKey: 'menu.materialMgmt', sortOrder: 60, menuCodes: ['MAT_REQUEST', 'MAT_REQUEST_OTHER', 'MAT_ISSUE', 'MAT_ISSUE_OTHER', 'MAT_ISSUE_HIST', 'MAT_LOT', 'MAT_LOT_SPLIT', 'MAT_LOT_MERGE', 'MAT_SHELF_LIFE', 'MAT_SHELF_LIFE_REINSPECT', 'MAT_SHELF_LIFE_HISTORY', 'MAT_SCRAP', 'MAT_STOCK_TRANSFER', 'MAT_ADJUSTMENT', 'MAT_MISC_RECEIPT', 'MAT_RECEIPT_CANCEL', 'INV_MAT_STOCK', 'INV_TRANSACTION', 'INV_MAT_PHYSICAL_INV', 'INV_MAT_PHYSICAL_INV_APPLY', 'INV_MAT_PHYSICAL_INV_HISTORY', 'MAT_HOLD'] },
  { categoryCode: 'PRODUCT_INVENTORY', labelKey: 'menu.productInventory', sortOrder: 70, menuCodes: ['INV_PRODUCT_STOCK', 'INV_PRODUCT_PHYSICAL_INV', 'INV_PRODUCT_PHYSICAL_INV_HISTORY', 'PROD_HOLD'] },
  { categoryCode: 'PRODUCT_MGMT', labelKey: 'menu.productMgmt', sortOrder: 80, menuCodes: ['PROD_RECEIVE', 'PROD_RECEIPT_CANCEL', 'PROD_ISSUE', 'PROD_ISSUE_CANCEL', 'PROD_DEFECT_TRANSFER'] },
  { categoryCode: 'PRODUCTION', labelKey: 'menu.production', sortOrder: 90, menuCodes: ['PROD_MONTHLY_PLAN', 'PROD_SIMULATION', 'PROD_SPEC_SETUP', 'PROD_KITTING', 'PROD_INPUT_ASSEMBLY', 'PROD_ORDER', 'PROD_RESULT', 'PROD_ORDER_RESULT', 'PROD_PROGRESS', 'PROD_INPUT_KIOSK', 'PROD_INPUT_INSPECT', 'PROD_INPUT_EQUIP', 'PROD_RESULT_SUMMARY', 'PROD_WIP_STOCK', 'PROD_FG_STOCK', 'PROD_WIP_MAT_STOCK', 'PROD_WIP_MAT_TRANS', 'QC_REWORK', 'QC_REWORK_HISTORY', 'PROD_REPAIR'] },
  { categoryCode: 'QUALITY', labelKey: 'menu.quality', sortOrder: 100, menuCodes: ['QC_IQC_ITEM', 'QC_IQC_PART_SPEC', 'QC_AQL', 'QC_IQC', 'QC_IQC_HISTORY', 'QC_CONCESSION', 'QC_DEFECT', 'QC_DEFECT_CODE', 'QC_REWORK_INSPECT', 'QC_INSPECT', 'QC_REQUEST_INSPECT', 'QC_SELF_INSPECT_HISTORY', 'QC_SAMPLE_INSPECT', 'QC_OQC', 'QC_OQC_HISTORY', 'QC_TRACE', 'QC_CHANGE', 'QC_COMPLAINT', 'QC_CAPA', 'QC_FAI', 'QC_PPAP', 'QC_SPC', 'QC_CONTROL_PLAN', 'QC_AUDIT', 'SYS_TRAINING'] },
  { categoryCode: 'EQUIPMENT', labelKey: 'menu.equipment', sortOrder: 110, menuCodes: ['EQ_MOLD_MGMT', 'EQUIP_INSPECT_ITEM_MASTER', 'EQUIP_INSPECT_ITEM', 'EQUIP_INSPECT_CALENDAR', 'EQUIP_DAILY', 'EQUIP_PERIODIC_CALENDAR', 'EQUIP_PERIODIC', 'EQUIP_HISTORY', 'EQUIP_PM_PLAN', 'EQUIP_PM_CALENDAR', 'EQUIP_PM_RESULT'] },
  { categoryCode: 'SHIPPING', labelKey: 'menu.shipping', sortOrder: 120, menuCodes: ['SHIP_PACK_RESULT', 'SHIP_PACK', 'SHIP_ORDER', 'SHIP_BOX_STOCK', 'SHIP_CONFIRM', 'SHIP_PALLET', 'SHIP_PALLET_SHIP', 'SHIP_HISTORY', 'SHIP_RETURN'] },
  { categoryCode: 'CONSUMABLES', labelKey: 'menu.consumables', sortOrder: 130, menuCodes: ['CONS_MASTER', 'CONS_LABEL', 'CONS_RECEIVING', 'CONS_ISSUING', 'CONS_STOCK', 'CONS_LIFE', 'CONS_MOUNT'] },
  { categoryCode: 'OUTSOURCING', labelKey: 'menu.outsourcing', sortOrder: 140, menuCodes: ['OUT_VENDOR', 'OUT_ORDER', 'OUT_RECEIVE'] },
  { categoryCode: 'INTERFACE', labelKey: 'menu.interface', sortOrder: 150, menuCodes: ['IF_DASHBOARD', 'IF_LOG', 'IF_MANUAL'] },
  { categoryCode: 'SYSTEM', labelKey: 'menu.system', sortOrder: 160, menuCodes: ['SYS_COMPANY', 'SYS_DEPT', 'SYS_USER', 'SYS_ROLE', 'SYS_PDA_ROLE', 'SYS_COMM', 'SYS_CONFIG', 'SYS_CODE', 'SYS_SCHEDULER', 'SYS_ER_VIEW', 'SYS_MENU_CATEGORY', 'SYS_IMPR_REQ'] },
];
