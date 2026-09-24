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
  Activity, Boxes, Building2, ClipboardList,
  Database, GitBranch, Network, Package, Settings, Warehouse, Wrench,
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
  /** PB 연결 상태. 경로가 있는 메뉴는 반드시 세 상태 중 하나를 명시한다. */
  pbLinkStatus?: "powerbuilder" | "web-native" | "unresolved";
  /** 이관 원본 PowerBuilder 윈도우명. pbLinkStatus=powerbuilder일 때 필수다. */
  pbWindow?: string;
  /** PB 메뉴 인벤토리에 없는 윈도우를 연결할 때 사용하는 추적 가능한 소스 근거 경로. */
  pbEvidence?: string;
  /** pbLinkStatus=unresolved인 경우 추정하지 않은 이유. */
  pbLinkNote?: string;
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
      { code: "MST_PART", labelKey: "menu.master.part", path: "/master/part", pbLinkStatus: "powerbuilder", pbWindow: "w_des_item_master" },
      { code: "MST_PRODUCT_MODEL", labelKey: "menu.master.productModel", path: "/master/product-model", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_model_simple_master" },
      { code: "MST_BOM", labelKey: "menu.master.bom", path: "/master/bom", pbLinkStatus: "unresolved", pbLinkNote: "PB BOM 메뉴가 설계BOM·제조BOM·원단위BOM으로 분리되어 단일 원본을 확정할 수 없음" },
      { code: "MST_PARTNER", labelKey: "menu.master.partner", path: "/master/partner", pbLinkStatus: "unresolved", pbLinkNote: "웹 거래처가 PB 고객·협력사 화면을 통합하므로 단일 원본을 확정할 수 없음" },
      { code: "MST_CUSTOMER", labelKey: "menu.master.customer", path: "/master/customer", pbLinkStatus: "powerbuilder", pbWindow: "w_com_customer_master" },
      { code: "EQUIP_MASTER", labelKey: "menu.equipment.master", path: "/master/equip", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_machine_master" },
      { code: "OEE_MST_STD_TIME", labelKey: "menu.oee.standardTime", path: "/oee/master/standard-time", pbLinkStatus: "web-native" },
      { code: "OEE_MST_IDLE_REASON", labelKey: "menu.oee.idleReason", path: "/oee/master/idle-reason", pbLinkStatus: "web-native" },
      { code: "OEE_MST_EQUIP_REASON", labelKey: "menu.oee.equipReason", path: "/oee/master/equip-reason-map", pbLinkStatus: "web-native" },
      { code: "MST_PROCESS", labelKey: "menu.master.process", path: "/master/process", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_workstage_master" },
      { code: "MST_PROD_LINE", labelKey: "menu.master.prodLine", path: "/master/prod-line", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_line_master" },
      { code: "MST_ROUTING", labelKey: "menu.master.routing", path: "/master/routing", pbLinkStatus: "web-native" },
      { code: "MST_WORK_CALENDAR", labelKey: "menu.master.workCalendar", path: "/master/work-calendar", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_calendar" },
      { code: "MST_WORKER", labelKey: "menu.master.worker", path: "/master/worker", pbLinkStatus: "web-native" },
      { code: "MST_WORK_INST", labelKey: "menu.master.workInstruction", path: "/master/work-instruction", pbLinkStatus: "web-native" },
      { code: "MST_WAREHOUSE", labelKey: "menu.master.warehouse", path: "/master/warehouse", pbLinkStatus: "web-native" },
      { code: "MST_LABEL", labelKey: "menu.master.label", path: "/master/label", pbLinkStatus: "powerbuilder", pbWindow: "w_product_label_master" },
      { code: "MST_PURCHASE_PRICE", labelKey: "menu.master.purchasePrice", path: "/master/purchase-price", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_buy_price_master" },
      { code: "MST_ITEM_SUPPLIER", labelKey: "menu.master.itemSupplier", path: "/master/item-supplier", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_item_master" },
      { code: "MST_SALE_PRICE", labelKey: "menu.master.salePrice", path: "/master/sale-price", pbLinkStatus: "powerbuilder", pbWindow: "w_sal_sale_price_master" },
    ],
  },
  {
    code: "BOM_MANAGEMENT",
    labelKey: "menu.bom",
    icon: Network,
    children: [
      { code: "BOM_REPLACE", labelKey: "menu.bom.replace", path: "/bom/replace-bom", pbLinkStatus: "powerbuilder", pbWindow: "w_des_replace_bom_master" },
    ],
  },
  {
    code: "EQUIPMENT",
    labelKey: "menu.equipment",
    icon: Wrench,
    children: [
      { code: "EQUIP_RESULT_SP", labelKey: "menu.equipment.resultSp", path: "/equipment/result-query/sp", pbLinkStatus: "powerbuilder", pbWindow: "w_qc_machine_inspect_data_sp_query" },
      { code: "EQUIP_RESULT_SPI", labelKey: "menu.equipment.resultSpi", path: "/equipment/result-query/spi", pbLinkStatus: "powerbuilder", pbWindow: "w_spi_time_query" },
      { code: "EQUIP_RESULT_ICT", labelKey: "menu.equipment.resultIct", path: "/equipment/result-query/ict", pbLinkStatus: "powerbuilder", pbWindow: "w_qc_machine_inspect_data_ict_query" },
      { code: "EQUIP_RESULT_AOI", labelKey: "menu.equipment.resultAoi", path: "/equipment/result-query/aoi", pbLinkStatus: "powerbuilder", pbWindow: "w_aoi_header_detail_query" },
      { code: "EQUIP_RESULT_ROUTER", labelKey: "menu.equipment.resultRouter", path: "/equipment/result-query/router", pbLinkStatus: "powerbuilder", pbWindow: "w_qc_machine_inspect_data_rt_query" },
      { code: "EQUIP_RESULT_ROM_WRITE", labelKey: "menu.equipment.resultRomWrite", path: "/equipment/result-query/rom-write", pbLinkStatus: "powerbuilder", pbWindow: "w_qc_machine_inspect_data_rw_query" },
      { code: "EQUIP_RESULT_SOLDER", labelKey: "menu.equipment.resultSolder", path: "/equipment/result-query/solder", pbLinkStatus: "powerbuilder", pbWindow: "w_qc_machine_inspect_data_solder_query" },
      { code: "EQUIP_RESULT_REFLOW", labelKey: "menu.equipment.resultReflow", path: "/equipment/result-query/reflow", pbLinkStatus: "powerbuilder", pbWindow: "w_qc_machine_inspect_data_reflow_query" },
      { code: "EQUIP_RESULT_PERFORMANCE", labelKey: "menu.equipment.resultPerformance", path: "/equipment/result-query/performance", pbLinkStatus: "powerbuilder", pbWindow: "w_qc_machine_inspect_data_eol_query" },
    ],
  },
  {
    code: "OEE",
    labelKey: "menu.oee",
    icon: Activity,
    children: [
      { code: "OEE_DASHBOARD", labelKey: "menu.oee.dashboard", path: "/oee/dashboard", pbLinkStatus: "web-native" },
      { code: "OEE_MULTI_ENTRY", labelKey: "menu.oee.multiEntry", path: "/oee/multi-entry", pbLinkStatus: "web-native" },
      { code: "OEE_OVERALL_STATUS", labelKey: "menu.oee.overallStatus", path: "/oee/overall-status", pbLinkStatus: "web-native" },
      { code: "OEE_EQUIP_WORK_RESULT", labelKey: "menu.oee.equipWorkResult", path: "/oee/equip-work-result", pbLinkStatus: "web-native" },
      { code: "OEE_EQUIP_OPS_STATUS", labelKey: "menu.oee.equipOpsStatus", path: "/oee/equip-ops-status", pbLinkStatus: "web-native" },
      { code: "OEE_FIELD_OPS", labelKey: "menu.oee.fieldOps", path: "/oee/field-ops", pbLinkStatus: "web-native" },
      // 미사용(2026-08-27): 설비별 운영 현황 및 분석 → 설비 운영 현황(OEE_EQUIP_OPS_STATUS)으로 대체.
      // 화면은 app/(authenticated)/oee/equip-ops-analysis 에 남아 있어 URL 직접 접근은 된다.
      // 되살리려면 OEE_EQUIP_OPS_ANALYSIS 항목을 이 자리에 다시 넣고 gen:menu 를 실행한다.
      // 숨김(2026-09-06): 생산라인관리에서 OEE 속성을 통합 관리한다.
      // 추후 삭제 전까지 직접 URL은 유지한다: { code: "OEE_MST_RESOURCE", labelKey: "menu.oee.resource", path: "/oee/master/resource" }
    ],
  },
  {
    code: "MATERIAL",
    labelKey: "menu.material",
    icon: Package,
    children: [
      { code: "MAT_RECEIPT_ISSUE_LEDGER", labelKey: "menu.material.receiptIssueLedger", path: "/material/receipt-issue-ledger", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_ledger_report" },
      { code: "MAT_CURRENT_INVENTORY", labelKey: "menu.material.currentInventory", path: "/material/current-inventory", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_current_inventory_master" },
      { code: "MAT_WORKSTAGE_INVENTORY", labelKey: "menu.material.workstageInventory", path: "/material/workstage-inventory", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_workstage_inventory_query", pbEvidence: "apps/backend/src/modules/material/controllers/workstage-inventory.controller.ts" },
      { code: "MAT_RECEIPT_CANCEL", labelKey: "menu.material.receiptCancel", path: "/material/receipt-cancel", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_receipt_cancel_master" },
    ],
  },
  {
    code: "PROCESS_TRANSACTION",
    labelKey: "menu.processTransaction",
    icon: GitBranch,
    children: [
      { code: "PLN_WORKSTAGE_PASS", labelKey: "menu.workstagePass", path: "/process-transaction/workstage-pass", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_inout_scan_master", pbEvidence: "apps/backend/src/modules/process-transaction/workstage-pass.controller.ts" },
      { code: "PLN_MAGAZINE_LABEL_HISTORY", labelKey: "menu.magazineLabelHistory", path: "/process-transaction/magazine-label-history", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_magazine_label_query", pbEvidence: "apps/backend/src/modules/process-transaction/magazine-label-history.controller.ts" },
    ],
  },
  {
    code: "PRODUCT_MGMT",
    labelKey: "menu.productMgmt",
    icon: Boxes,
    // 하위 화면 미배정. PB 메뉴(ISYS_DYNAMIC_MENU, M_MAIN_FRAME_MENU)에는 "제품입출고수불원장"이 없고
    // 수불원장은 자재용(M_45 자재입출고수불원장, 자재창고 그룹)만 존재한다 → 대응 화면이 정해지면 추가한다.
    children: [],
  },
  {
    code: "PRODUCT_INVENTORY",
    labelKey: "menu.productInventory",
    icon: Warehouse,
    children: [
      { code: "PRD_CURRENT_INVENTORY", labelKey: "menu.productMgmt.currentInventory", path: "/product/current-inventory", pbLinkStatus: "powerbuilder", pbWindow: "w_prd_product_fg_inventory" },
    ],
  },
  {
    code: "PRODUCTION",
    labelKey: "menu.production",
    icon: ClipboardList,
    children: [
      { code: "PRD_RUN_CARD", labelKey: "menu.production.runCard", path: "/production/run-card", pbLinkStatus: "powerbuilder", pbWindow: "w_product_run_card", pbEvidence: "apps/frontend/src/app/(authenticated)/production/run-card/page.tsx" },
    ],
  },
  {
    code: "QUALITY",
    labelKey: "menu.quality",
    icon: Wrench,
    children: [
      { code: "QC_REPAIR_HISTORY", labelKey: "menu.quality.repairHistory", path: "/quality/repair-history", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_pcb_repair_master" },
      { code: "QC_PRODUCT_DESTROY", labelKey: "menu.quality.productDestroy", path: "/quality/product-destroy", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_pcb_destroy_master" },
    ],
  },
  {
    code: "OUTSOURCING",
    labelKey: "menu.outsourcing",
    icon: Building2,
    children: [],
  },
  {
    code: "SYSTEM",
    labelKey: "menu.system",
    icon: Settings,
    children: [
      { code: "SYS_COMPANY", labelKey: "menu.master.company", path: "/master/company", pbLinkStatus: "powerbuilder", pbWindow: "w_company_master" },
      { code: "SYS_CODE", labelKey: "menu.master.code", path: "/master/code", pbLinkStatus: "powerbuilder", pbWindow: "w_basecode_master" },
      { code: "SYS_CONFIG", labelKey: "menu.system.config", path: "/system/config", pbLinkStatus: "powerbuilder", pbWindow: "w_system_config" },
      { code: "SYS_MENU_CATEGORY", labelKey: "menu.system.menuCategory", path: "/system/menu-categories", pbLinkStatus: "web-native" },
      { code: "SYS_DEPT", labelKey: "menu.system.department", path: "/system/department", pbLinkStatus: "powerbuilder", pbWindow: "w_department_master" },
      { code: "SYS_USER", labelKey: "menu.system.users", path: "/system/users", pbLinkStatus: "powerbuilder", pbWindow: "w_user_master" },
      { code: "SYS_SCHEDULER", labelKey: "menu.system.scheduler", path: "/system/scheduler", pbLinkStatus: "web-native" },
      { code: "SYS_ER_VIEW", labelKey: "menu.system.erView", path: "/system/er-view", pbLinkStatus: "web-native" },
      { code: "SYS_IMPR_REQ", labelKey: "menu.system.improvementRequests", path: "/system/improvement-requests", pbLinkStatus: "web-native" },
    ],
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
