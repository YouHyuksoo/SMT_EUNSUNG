/**
 * @file 메뉴 코드 유효성 검증 — 프론트 menuConfig.ts의 leaf 메뉴 코드와 동기화된 화이트리스트
 * @description 운영 정책상 신규 페이지 추가 시 개발자가 이 파일과 menuConfig.ts를 동시에 수정한다.
 *              자동 동기화 없이 명시적 등록을 유지한다.
 *
 * 초보자 가이드:
 * 1. 새 페이지 추가 시: menuConfig.ts에 leaf 추가 + KNOWN_LEAF_CODES에 코드 추가 (둘 다)
 * 2. menu-category-items API는 이 화이트리스트를 통과한 코드만 받아들임
 * 3. SYS_MENU_CATEGORY는 관리 화면 자체의 메뉴 코드
 */
const KNOWN_LEAF_CODES: ReadonlySet<string> = new Set<string>([
  // OEE
  'OEE_DASHBOARD','OEE_DRILLDOWN','OEE_LOSS','OEE_ENTRY','OEE_MST_RESOURCE','OEE_MST_REASON','OEE_MST_STD_TIME',
  // MASTER
  'MST_PART','MST_BOM','MST_PARTNER','MST_CUSTOMER','EQUIP_MASTER','MST_PROCESS','MST_PROD_LINE',
  'MST_ROUTING','MST_WORK_CALENDAR','MST_WORKER','MST_WORK_INST','MST_WAREHOUSE',
  'SYS_COMPANY','SYS_CODE','MST_LABEL','MST_PURCHASE_PRICE','MST_ITEM_SUPPLIER','MST_SALE_PRICE',
  // SYSTEM
  'SYS_CONFIG','SYS_MENU_CATEGORY','SYS_DEPT','SYS_USER',
  'SYS_SCHEDULER','SYS_ER_VIEW','SYS_IMPR_REQ',
]);

export function isValidMenuCode(code: string): boolean {
  return KNOWN_LEAF_CODES.has(code);
}

export function listKnownMenuCodes(): string[] {
  return Array.from(KNOWN_LEAF_CODES);
}
