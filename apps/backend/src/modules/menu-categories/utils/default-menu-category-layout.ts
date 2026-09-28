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
  { categoryCode: 'MATERIAL', labelKey: 'menu.material', sortOrder: 50, menuCodes: ['MAT_RECEIPT_ISSUE_LEDGER', 'MAT_CURRENT_INVENTORY', 'INV_TOTAL', 'INV_CLOSE', 'INV_CHECK', 'INV_BARCODE_CHECK', 'MAT_WORKSTAGE_INVENTORY', 'MAT_RECEIPT_CANCEL', 'WH_BAKING_STOCK', 'WH_VACUUM_STOCK', 'WH_DEHUMI_STOCK', 'WH_RECYCLE_CHECK', 'WH_SOLDER', 'WH_SOLDER_INPUT', 'WH_RECEIPT_SLIP', 'WH_BARCODE_RECEIPT', 'WH_SOLDER_LABEL', 'WH_MATERIAL_RECEIPT', 'WH_ETC_RECEIPT', 'WH_ETC_ISSUE', 'WH_ISSUE_CANCEL', 'WH_ISSUE_RETURN', 'WH_BARCODE_ISSUE', 'WH_BARCODE_DIVIDE', 'WH_BAKING_SCAN', 'WH_BARCODE_REPRINT', 'WH_MSL_CHECK', 'WH_MANUAL_INPUT'] },
  { categoryCode: 'JIG', labelKey: 'menu.jig', sortOrder: 60, menuCodes: ['JIG_MASTER', 'JIG_ISSUE', 'JIG_REPAIR', 'JIG_PM', 'JIG_SQUEEZE_CHECK', 'JIG_MASK_CHECK', 'JIG_SAMPLE', 'JIG_INPUT_HISTORY', 'JIG_SAMPLE_INPUT_HISTORY', 'JIG_SAMPLE_BCR_HISTORY'] },
  { categoryCode: 'FEEDER', labelKey: 'menu.feeder', sortOrder: 70, menuCodes: ['FEEDER_MASTER', 'FEEDER_REPAIR', 'FEEDER_ADJUST'] },
  { categoryCode: 'MOLD', labelKey: 'menu.mold', sortOrder: 80, menuCodes: ['MOLD_MASTER', 'MOLD_INVENTORY', 'MOLD_ORDER', 'MOLD_RECEIPT', 'MOLD_ISSUE', 'MOLD_REPAIR_REQUEST', 'MOLD_REPAIR', 'MOLD_PRICE'] },
  { categoryCode: 'SMT', labelKey: 'menu.smt', sortOrder: 90, menuCodes: ['SMT_LINE', 'SMT_LOCATION', 'SMT_BOM_REPLACE', 'SMT_NC_UPLOAD', 'SMT_BOM', 'SMT_PLAN', 'SMT_BOM_REPORT', 'SMT_BOM_COMPARISON', 'SMT_FEEDER_PICKUP'] },
  { categoryCode: 'PROCESS_TRANSACTION', labelKey: 'menu.processTransaction', sortOrder: 100, menuCodes: ['PLN_WORKSTAGE_PASS', 'PLN_MAGAZINE_LABEL_HISTORY'] },
  { categoryCode: 'PRODUCT_MGMT', labelKey: 'menu.productMgmt', sortOrder: 110, menuCodes: [] },
  { categoryCode: 'PRODUCT_INVENTORY', labelKey: 'menu.productInventory', sortOrder: 120, menuCodes: ['PRD_CURRENT_INVENTORY'] },
  { categoryCode: 'PRODUCTION', labelKey: 'menu.production', sortOrder: 130, menuCodes: ['PRD_RUN_CARD', 'PRD_MASTER_PLAN', 'PRD_SMD_PLAN', 'PRD_SMD_ACTUAL', 'PRD_RUN_CARD_PID', 'PRD_PCB_RESULT', 'PRD_DAILY_REPORT'] },
  { categoryCode: 'TRACKING', labelKey: 'menu.tracking', sortOrder: 140, menuCodes: ['TRK_MATERIAL_LOT', 'TRK_MATERIAL_DYNAMIC', 'TRK_MATERIAL_USAGE', 'TRK_PID', 'TRK_RUN_NO', 'TRK_LOT_ALL', 'TRK_LINE_DASHBOARD'] },
  { categoryCode: 'QUERY', labelKey: 'menu.query', sortOrder: 150, menuCodes: ['QRY_PID_INFO', 'QRY_MARKING', 'QRY_PCB_INPUT', 'QRY_PDA_SCAN', 'QRY_PDA_NG', 'QRY_FEEDER_MONITOR', 'QRY_SENSOR_ACTUAL', 'QRY_MATERIAL_BARCODE', 'QRY_NSNP_HISTORY'] },
  { categoryCode: 'REPORT', labelKey: 'menu.report', sortOrder: 160, menuCodes: ['RPT_ITEM_MASTER', 'RPT_LINE_BARCODE', 'RPT_CARRIER_BARCODE', 'RPT_MACHINE', 'RPT_PICKUP_RATE', 'RPT_MASTER_PLAN', 'RPT_RUN_CARD', 'RPT_FG_ISSUE', 'RPT_WORKSTAGE_STOCK', 'RPT_MAGAZINE_STOCK', 'RPT_MOLD_RECEIPT', 'RPT_MOLD_ISSUE', 'RPT_JIG', 'RPT_MOLD', 'RPT_FOUR_M', 'RPT_MATERIAL_BARCODE_SLIP', 'RPT_MATERIAL_RECEIPT', 'RPT_MATERIAL_RECEIPT_SUM', 'RPT_MATERIAL_ISSUE', 'RPT_MATERIAL_ISSUE_SUM', 'RPT_MATERIAL_RACK_MOVE', 'RPT_MATERIAL_LONG_TERM', 'RPT_MATERIAL_INVENTORY'] },
  { categoryCode: 'QUALITY', labelKey: 'menu.quality', sortOrder: 170, menuCodes: ['QC_IQC_MASTER', 'QC_IQC_HISTORY_REG', 'QC_PID_ISSUE_SCAN', 'QC_PID_HOLDING', 'QC_INVENTORY_HOLD', 'QC_NOTIFY', 'QC_ECO_NOTIFY', 'QC_OQC_PID', 'QC_OQC_LOT', 'QC_4M', 'QC_WQC', 'QC_TEMPERATURE', 'QC_REPAIR_HISTORY', 'QC_PRODUCT_DESTROY'] },
  { categoryCode: 'OUTSOURCING', labelKey: 'menu.outsourcing', sortOrder: 180, menuCodes: [] },
  { categoryCode: 'CONFIRM', labelKey: 'menu.confirm', sortOrder: 190, menuCodes: ['CFM_BUY_PRICE', 'CFM_SALE_PRICE', 'CFM_MOLD_PRICE', 'CFM_BOM'] },
  { categoryCode: 'SYSTEM', labelKey: 'menu.system', sortOrder: 200, menuCodes: ['SYS_COMPANY', 'SYS_CODE', 'SYS_CONFIG', 'SYS_MENU_CATEGORY', 'SYS_DEPT', 'SYS_USER', 'SYS_SCHEDULER', 'SYS_ER_VIEW', 'SYS_IMPR_REQ'] },
];
