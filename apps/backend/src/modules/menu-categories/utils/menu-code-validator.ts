/**
 * @file AUTO-GENERATED — 직접 편집하지 마세요.
 * @description 메뉴 코드 유효성 검증 화이트리스트 (menuConfig leaf 코드)
 * Source: apps/frontend/src/config/menuConfig.ts
 * Regenerate: pnpm --filter @eunsung/frontend gen:menu (또는 pnpm --filter @eunsung/frontend test)
 */
const KNOWN_LEAF_CODES: ReadonlySet<string> = new Set<string>([
  'MST_PART',
  'MST_PRODUCT_MODEL',
  'MST_BOM',
  'MST_PARTNER',
  'MST_CUSTOMER',
  'EQUIP_MASTER',
  'OEE_MST_STD_TIME',
  'OEE_MST_IDLE_REASON',
  'OEE_MST_EQUIP_REASON',
  'MST_PROCESS',
  'MST_PROD_LINE',
  'MST_ROUTING',
  'MST_WORK_CALENDAR',
  'MST_WORKER',
  'MST_WORK_INST',
  'MST_WAREHOUSE',
  'MST_LABEL',
  'MST_PURCHASE_PRICE',
  'MST_ITEM_SUPPLIER',
  'MST_SALE_PRICE',
  'EQUIP_RESULT_SP',
  'EQUIP_RESULT_SPI',
  'EQUIP_RESULT_ICT',
  'EQUIP_RESULT_AOI',
  'EQUIP_RESULT_ROUTER',
  'EQUIP_RESULT_ROM_WRITE',
  'EQUIP_RESULT_SOLDER',
  'EQUIP_RESULT_REFLOW',
  'EQUIP_RESULT_PERFORMANCE',
  'OEE_DASHBOARD',
  'OEE_MULTI_ENTRY',
  'OEE_OVERALL_STATUS',
  'OEE_EQUIP_WORK_RESULT',
  'OEE_EQUIP_OPS_STATUS',
  'OEE_FIELD_OPS',
  'MAT_RECEIPT_ISSUE_LEDGER',
  'MAT_CURRENT_INVENTORY',
  'MAT_RECEIPT_CANCEL',
  'PRD_CURRENT_INVENTORY',
  'PRD_RUN_CARD',
  'QC_REPAIR_HISTORY',
  'QC_PRODUCT_DESTROY',
  'SYS_COMPANY',
  'SYS_CODE',
  'SYS_CONFIG',
  'SYS_MENU_CATEGORY',
  'SYS_DEPT',
  'SYS_USER',
  'SYS_SCHEDULER',
  'SYS_ER_VIEW',
  'SYS_IMPR_REQ',
]);

export function isValidMenuCode(code: string): boolean {
  return KNOWN_LEAF_CODES.has(code);
}

export function listKnownMenuCodes(): string[] {
  return Array.from(KNOWN_LEAF_CODES);
}
