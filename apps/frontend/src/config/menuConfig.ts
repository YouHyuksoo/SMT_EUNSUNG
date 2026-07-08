/**
 * @file src/config/menuConfig.ts
 * @description 사이드바 메뉴 설정 - RBAC 권한 관리용 고유 코드 포함
 *
 * 초보자 가이드:
 * 1. **MenuConfigItem**: 메뉴 항목 인터페이스 (code, labelKey, path, icon, children)
 * 2. **code**: RBAC 권한 체크에 사용되는 고유 코드 (대문자_언더스코어)
 * 3. **유틸 함수**: getAllMenuCodes, findMenuCodeByPath, getParentCodes
 * 4. 새 메뉴 추가 시 반드시 고유 code를 부여할 것
 */
import {
  Activity, Boxes, Building2,
  Database, GitBranch, Package,
} from "lucide-react";

/** 메뉴 설정 항목 인터페이스 */
export interface MenuConfigItem {
  /** RBAC 권한 체크용 고유 코드 (대문자_언더스코어) */
  code: string;
  /** i18n 번역 키 */
  labelKey: string;
  /** 라우트 경로 (하위 메뉴가 있는 경우 생략 가능) */
  path?: string;
  /** 아이콘 컴포넌트 (최상위 메뉴만 사용) */
  icon?: React.ComponentType<{ className?: string }>;
  /** 하위 메뉴 항목 */
  children?: MenuConfigItem[];
}

/** 사이드바 메뉴 설정 배열 */
export const menuConfig: MenuConfigItem[] = [
  {
    code: "MASTER",
    labelKey: "menu.master",
    icon: Database,
    children: [
      { code: "MST_PART", labelKey: "menu.master.part", path: "/master/part" },
      { code: "MST_BOM", labelKey: "menu.master.bom", path: "/master/bom" },
      { code: "MST_PARTNER", labelKey: "menu.master.partner", path: "/master/partner" },
      { code: "EQUIP_MASTER", labelKey: "menu.equipment.master", path: "/master/equip" },
      { code: "MST_PROCESS", labelKey: "menu.master.process", path: "/master/process" },
      { code: "MST_PROD_LINE", labelKey: "menu.master.prodLine", path: "/master/prod-line" },
      { code: "MST_ROUTING", labelKey: "menu.master.routing", path: "/master/routing" },
      { code: "MST_WORK_CALENDAR", labelKey: "menu.master.workCalendar", path: "/master/work-calendar" },
      { code: "MST_WORKER", labelKey: "menu.master.worker", path: "/master/worker" },
      { code: "MST_WORK_INST", labelKey: "menu.master.workInstruction", path: "/master/work-instruction" },
      { code: "MST_WAREHOUSE", labelKey: "menu.master.warehouse", path: "/master/warehouse" },
      { code: "SYS_COMPANY", labelKey: "menu.master.company", path: "/master/company" },
      { code: "SYS_CODE", labelKey: "menu.master.code", path: "/master/code" },
      { code: "MST_LABEL", labelKey: "menu.master.label", path: "/master/label" },
      { code: "MST_PROCESS_CAPA", labelKey: "menu.master.processCapa", path: "/master/process-capa" },
      { code: "SYS_DOCUMENT", labelKey: "menu.system.document", path: "/system/document" },
    ],
  },
  {
    code: "OEE",
    labelKey: "menu.oee",
    icon: Activity,
    children: [
      { code: "OEE_DASHBOARD", labelKey: "menu.oee.dashboard", path: "/oee/dashboard" },
      { code: "OEE_DRILLDOWN", labelKey: "menu.oee.drilldown", path: "/oee/dashboard/drilldown" },
      { code: "OEE_LOSS", labelKey: "menu.oee.loss", path: "/oee/dashboard/loss" },
      { code: "OEE_ENTRY", labelKey: "menu.oee.entry", path: "/oee/entry" },
      { code: "OEE_MST_RESOURCE", labelKey: "menu.oee.resource", path: "/oee/master/resource" },
      { code: "OEE_MST_REASON", labelKey: "menu.oee.reason", path: "/oee/master/reason" },
    ],
  },
  {
    code: "MATERIAL",
    labelKey: "menu.material",
    icon: Package,
    children: [
      /* ── 자재 수불 ── */
      { code: "MAT_REQUEST", labelKey: "menu.material.request", path: "/material/request" },
      { code: "MAT_REQUEST_OTHER", labelKey: "menu.material.requestOther", path: "/material/request-other" },
      { code: "MAT_ISSUE", labelKey: "menu.material.issue", path: "/material/issue" },
      { code: "MAT_ISSUE_OTHER", labelKey: "menu.material.issueOther", path: "/material/issue-other" },
      { code: "MAT_ISSUE_HIST", labelKey: "menu.material.issueHistory", path: "/material/issue-history" },
      { code: "MAT_LOT", labelKey: "menu.material.lot", path: "/material/lot" },
      { code: "MAT_LOT_SPLIT", labelKey: "menu.material.lotSplit", path: "/material/lot-split" },
      { code: "MAT_LOT_MERGE", labelKey: "menu.material.lotMerge", path: "/material/lot-merge" },
      { code: "MAT_SHELF_LIFE", labelKey: "menu.material.shelfLife", path: "/material/shelf-life" },
      { code: "MAT_SHELF_LIFE_REINSPECT", labelKey: "menu.material.shelfLifeReinspect", path: "/material/shelf-life-reinspect" },
      { code: "MAT_SHELF_LIFE_HISTORY", labelKey: "menu.material.shelfLifeHistory", path: "/material/shelf-life-history" },
      { code: "MAT_SCRAP", labelKey: "menu.material.scrap", path: "/material/scrap" },
      { code: "MAT_STOCK_TRANSFER", labelKey: "menu.material.stockTransfer", path: "/material/stock-transfer" },
      { code: "MAT_ADJUSTMENT", labelKey: "menu.material.adjustment", path: "/material/adjustment" },
      { code: "MAT_MISC_RECEIPT", labelKey: "menu.material.miscReceipt", path: "/material/misc-receipt" },
      { code: "MAT_RECEIPT_CANCEL", labelKey: "menu.material.receiptCancel", path: "/material/receipt-cancel" },
      /* ── 자재 재고 ── */
      { code: "INV_MAT_STOCK", labelKey: "menu.inventory.matStock", path: "/inventory/material-stock" },
      { code: "INV_TRANSACTION", labelKey: "menu.inventory.transaction", path: "/inventory/transaction" },
      { code: "INV_MAT_PHYSICAL_INV", labelKey: "menu.inventory.matPhysicalInv", path: "/inventory/material-physical-inv" },
      { code: "INV_MAT_PHYSICAL_INV_APPLY", labelKey: "menu.inventory.matPhysicalInvApply", path: "/inventory/material-physical-inv-apply" },
      { code: "INV_MAT_PHYSICAL_INV_HISTORY", labelKey: "menu.inventory.matPhysicalInvHistory", path: "/inventory/material-physical-inv-history" },
      { code: "MAT_HOLD", labelKey: "menu.material.hold", path: "/material/hold" },
    ],
  },
  {
    code: "PROCESS_TRANSACTION",
    labelKey: "menu.processTransaction",
    icon: GitBranch,
    children: [],
  },
  {
    code: "PRODUCT_MGMT",
    labelKey: "menu.productMgmt",
    icon: Boxes,
    children: [],
  },
  {
    code: "OUTSOURCING",
    labelKey: "menu.outsourcing",
    icon: Building2,
    children: [],
  },
];

// ---------------------------------------------------------------------------
// 유틸리티 함수
// ---------------------------------------------------------------------------

/**
 * 모든 메뉴 코드를 플랫하게 추출
 * @returns 최상위 + 하위 메뉴의 code 배열
 */
export function getAllMenuCodes(): string[] {
  const codes: string[] = [];
  for (const item of menuConfig) {
    codes.push(item.code);
    if (item.children) {
      for (const child of item.children) {
        codes.push(child.code);
      }
    }
  }
  return codes;
}

/**
 * path로 메뉴 코드를 찾기
 * @param path - 라우트 경로 (예: "/dashboard")
 * @returns 해당 경로의 메뉴 code 또는 undefined
 */
export function findMenuCodeByPath(path: string): string | undefined {
  for (const item of menuConfig) {
    if (item.path === path) return item.code;
    if (item.children) {
      for (const child of item.children) {
        if (child.path === path) return child.code;
      }
    }
  }
  return undefined;
}

/**
 * path로 메뉴 항목과 부모 코드를 찾기 (탭 자동 생성용)
 * @param path - 라우트 경로 (예: "/dashboard")
 * @returns 해당 경로의 메뉴 항목과 부모 code 또는 undefined
 */
export function findMenuItemByPath(
  path: string
): { item: MenuConfigItem; parentCode: string } | undefined {
  for (const item of menuConfig) {
    if (item.path === path) return { item, parentCode: item.code };
    if (item.children) {
      for (const child of item.children) {
        if (child.path === path) return { item: child, parentCode: item.code };
      }
    }
  }
  return undefined;
}

/**
 * 허용된 하위 메뉴 코드로부터 부모 코드를 자동 추출
 * @param allowedCodes - 사용자에게 허용된 메뉴 코드 배열
 * @returns 부모 메뉴 코드 배열 (중복 제거)
 */
export function getParentCodes(allowedCodes: string[]): string[] {
  const parentCodes = new Set<string>();
  const codeSet = new Set(allowedCodes);

  for (const item of menuConfig) {
    // 최상위 메뉴 자체가 허용된 경우
    if (codeSet.has(item.code)) {
      parentCodes.add(item.code);
      continue;
    }
    // 하위 메뉴 중 하나라도 허용된 경우 부모 코드 추가
    if (item.children?.some((child) => codeSet.has(child.code))) {
      parentCodes.add(item.code);
    }
  }

  return Array.from(parentCodes);
}
