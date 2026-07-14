/**
 * @file AUTO-GENERATED — 직접 편집하지 마세요.
 * @description 메뉴 코드 유효성 검증 화이트리스트 (menuConfig leaf 코드)
 * Source: apps/frontend/src/config/menuConfig.ts
 * Regenerate: pnpm --filter @eunsung/frontend gen:menu (또는 pnpm --filter @eunsung/frontend test)
 */
const KNOWN_LEAF_CODES: ReadonlySet<string> = new Set<string>([
  'MST_PART',
  'MST_BOM',
  'MST_PARTNER',
  'MST_CUSTOMER',
  'EQUIP_MASTER',
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
  'OEE_DASHBOARD',
  'OEE_DRILLDOWN',
  'OEE_LOSS',
  'OEE_ENTRY',
  'OEE_MST_RESOURCE',
  'OEE_MST_REASON',
  'OEE_MST_STD_TIME',
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
