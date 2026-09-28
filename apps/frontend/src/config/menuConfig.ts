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
  Activity,
  Boxes,
  Building2,
  Cable,
  CircuitBoard,
  ClipboardList,
  FileText,
  BadgeCheck,
  Database,
  GitBranch,
  Grip,
  Hammer,
  Network,
  Package,
  ScanSearch,
  Radar,
  Settings,
  Warehouse,
  Wrench,
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
  /**
   * 이 화면 하나가 함께 대체하는 다른 PB 윈도우들.
   *
   * PB 에는 같은 표를 같은 조건으로 보는 창이 둘 이상 있는 경우가 있다 (등록창과
   * 조회창이 따로 있는 식). 웹에서 한 화면으로 합치면 나머지 PB 창은 영원히
   * '미착수' 로 남아 이관 현황이 사실과 달라진다. 그 창들을 여기에 적으면
   * 이관 현황 생성기가 완료로 잡는다.
   *
   * **중복 검사는 pbWindow 와 같은 통에서 한다** — 한 PB 창을 두 화면이 각자
   * 대체했다고 주장할 수 없다.
   */
  pbAlsoCovers?: string[];
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
      { code: "INV_TOTAL", labelKey: "menu.material.totalInventory", path: "/inventory-query/total-inventory", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_total_inventory_query" },
      { code: "INV_CLOSE", labelKey: "menu.material.inventoryClose", path: "/inventory-query/inventory-close", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_inventory_close_report" },
      { code: "INV_CHECK", labelKey: "menu.material.inventoryCheck", path: "/inventory-query/inventory-check", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_inventory_check_master" },
      { code: "INV_BARCODE_CHECK", labelKey: "menu.material.barcodeCheck", path: "/inventory-query/barcode-check", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_barcode_check_master" },
      { code: "MAT_WORKSTAGE_INVENTORY", labelKey: "menu.material.workstageInventory", path: "/material/workstage-inventory", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_workstage_inventory_query", pbEvidence: "apps/backend/src/modules/material/controllers/workstage-inventory.controller.ts" },
      { code: "MAT_RECEIPT_CANCEL", labelKey: "menu.material.receiptCancel", path: "/material/receipt-cancel", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_receipt_cancel_master" },
      { code: "WH_BAKING_STOCK", labelKey: "menu.warehouse.bakingStock", path: "/warehouse/baking-stock", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_baking_scan_query" },
      { code: "WH_VACUUM_STOCK", labelKey: "menu.warehouse.vacuumStock", path: "/warehouse/vacuum-stock", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_vacuum_scan_query" },
      { code: "WH_DEHUMI_STOCK", labelKey: "menu.warehouse.dehumiStock", path: "/warehouse/dehumi-stock", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_dehumi_scan_query" },
      { code: "WH_RECYCLE_CHECK", labelKey: "menu.warehouse.recycleCheck", path: "/warehouse/recycle-check", pbLinkStatus: "powerbuilder", pbWindow: "w_smt_recycle_check_rpt" },
      { code: "WH_SOLDER", labelKey: "menu.warehouse.solder", path: "/warehouse/solder", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_solder_receipt_issue_master" },
      { code: "WH_SOLDER_INPUT", labelKey: "menu.warehouse.solderInput", path: "/warehouse/solder-input", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_solder_input_move_query" },
      { code: "WH_RECEIPT_SLIP", labelKey: "menu.warehouse.receiptSlip", path: "/warehouse/receipt-slip", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_receipt_slip_master" },
      { code: "WH_BARCODE_RECEIPT", labelKey: "menu.warehouse.barcodeReceipt", path: "/warehouse/barcode-receipt", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_other_receipt_barcode_master" },
      { code: "WH_SOLDER_LABEL", labelKey: "menu.warehouse.solderLabel", path: "/warehouse/solder-label", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_receipt_slip_master_onetek_solder" },
      { code: "WH_MATERIAL_RECEIPT", labelKey: "menu.warehouse.materialReceipt", path: "/warehouse/material-receipt", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_receipt_master" },
      { code: "WH_ETC_RECEIPT", labelKey: "menu.warehouse.etcReceipt", path: "/warehouse/etc-receipt", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_other_receipt_master" },
      { code: "WH_ETC_ISSUE", labelKey: "menu.warehouse.etcIssue", path: "/warehouse/etc-issue", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_other_issue_master" },
      { code: "WH_ISSUE_CANCEL", labelKey: "menu.warehouse.issueCancel", path: "/warehouse/issue-cancel", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_mass_issue_cancel_master" },
      { code: "WH_ISSUE_RETURN", labelKey: "menu.warehouse.issueReturn", path: "/warehouse/issue-return", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_other_mass_issue_barcode_return_master" },
      { code: "WH_BARCODE_ISSUE", labelKey: "menu.warehouse.barcodeIssue", path: "/warehouse/barcode-issue", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_other_issue_barcode_master" },
      { code: "WH_BARCODE_DIVIDE", labelKey: "menu.warehouse.barcodeDivide", path: "/warehouse/barcode-divide", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_receipt_barcode_divide_master" },
      { code: "WH_BAKING_SCAN", labelKey: "menu.warehouse.bakingScan", path: "/warehouse/baking-scan", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_baking_dehumi_scan_master" },
      { code: "WH_BARCODE_REPRINT", labelKey: "menu.warehouse.barcodeReprint", path: "/warehouse/barcode-reprint", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_receipt_barcode_reprint_master" },
      { code: "WH_MSL_CHECK", labelKey: "menu.warehouse.mslCheck", path: "/warehouse/msl-check", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_msl_item_check_master" },
      { code: "WH_MANUAL_INPUT", labelKey: "menu.warehouse.manualInput", path: "/warehouse/manual-input", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_manual_input_history_query" },
    ],
  },
  {
    code: "JIG",
    labelKey: "menu.jig",
    icon: Grip,
    children: [
      { code: "JIG_MASTER", labelKey: "menu.jig.master", path: "/jig/master", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_jig_master" },
      { code: "JIG_ISSUE", labelKey: "menu.jig.issue", path: "/jig/issue", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_jig_issue_master" },
      { code: "JIG_REPAIR", labelKey: "menu.jig.repair", path: "/jig/repair", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_jig_repair_master" },
      { code: "JIG_PM", labelKey: "menu.jig.pm", path: "/jig/pm", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_jig_pm_master" },
      { code: "JIG_SQUEEZE_CHECK", labelKey: "menu.jig.squeezeCheck", path: "/jig/squeeze-check", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_jig_squeeze_check_master", pbAlsoCovers: ["w_mcn_jig_squeeze_check_history"] },
      { code: "JIG_MASK_CHECK", labelKey: "menu.jig.maskCheck", path: "/jig/mask-check", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_jig_mask_tension_check_master", pbAlsoCovers: ["w_mcn_jig_mask_check_history"] },
      { code: "JIG_SAMPLE", labelKey: "menu.jig.sample", path: "/jig/sample", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_sample_master" },
      { code: "JIG_INPUT_HISTORY", labelKey: "menu.jig.inputHistory", path: "/jig/input-history", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_jig_input_history_master" },
      { code: "JIG_SAMPLE_INPUT_HISTORY", labelKey: "menu.jig.sampleInputHistory", path: "/jig/sample-input-history", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_sample_input_history_master" },
      { code: "JIG_SAMPLE_BCR_HISTORY", labelKey: "menu.jig.sampleBcrHistory", path: "/jig/sample-bcr-history", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_sample_bcr_input_history_master" },
    ],
  },
  {
    code: "FEEDER",
    labelKey: "menu.feeder",
    icon: Cable,
    children: [
      { code: "FEEDER_MASTER", labelKey: "menu.feeder.master", path: "/feeder/master", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_feeder_master" },
      { code: "FEEDER_REPAIR", labelKey: "menu.feeder.repair", path: "/feeder/repair", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_feeder_repair_master" },
      { code: "FEEDER_ADJUST", labelKey: "menu.feeder.adjust", path: "/feeder/adjust", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_jig_feeder_adjust_master" },
    ],
  },
  {
    code: "MOLD",
    labelKey: "menu.mold",
    icon: Hammer,
    children: [
      { code: "MOLD_MASTER", labelKey: "menu.mold.master", path: "/mold/master", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_mold_master" },
      { code: "MOLD_INVENTORY", labelKey: "menu.mold.inventory", path: "/mold/inventory", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_mold_inventory_master" },
      { code: "MOLD_ORDER", labelKey: "menu.mold.order", path: "/mold/order", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_mold_purchase_order_master" },
      { code: "MOLD_RECEIPT", labelKey: "menu.mold.receipt", path: "/mold/receipt", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_mold_receipt_master" },
      { code: "MOLD_ISSUE", labelKey: "menu.mold.issue", path: "/mold/issue", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_mold_issue_master" },
      { code: "MOLD_REPAIR_REQUEST", labelKey: "menu.mold.repairRequest", path: "/mold/repair-request", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_mold_repair_request_master" },
      { code: "MOLD_REPAIR", labelKey: "menu.mold.repair", path: "/mold/repair", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_mold_repair_master" },
      { code: "MOLD_PRICE", labelKey: "menu.mold.price", path: "/mold/price", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_mold_buy_price_master" },
    ],
  },
  {
    code: "SMT",
    labelKey: "menu.smt",
    icon: CircuitBoard,
    children: [
      { code: "SMT_LINE", labelKey: "menu.smt.line", path: "/smt/line", pbLinkStatus: "powerbuilder", pbWindow: "w_smt_line_master" },
      { code: "SMT_LOCATION", labelKey: "menu.smt.location", path: "/smt/location", pbLinkStatus: "powerbuilder", pbWindow: "w_smt_location_master" },
      { code: "SMT_BOM_REPLACE", labelKey: "menu.smt.bomReplace", path: "/smt/bom-replace", pbLinkStatus: "powerbuilder", pbWindow: "w_smt_bom_replace_master" },
      { code: "SMT_NC_UPLOAD", labelKey: "menu.smt.ncUpload", path: "/smt/nc-upload", pbLinkStatus: "powerbuilder", pbWindow: "w_smt_upload_nc_master" },
      { code: "SMT_BOM", labelKey: "menu.smt.bom", path: "/smt/bom", pbLinkStatus: "powerbuilder", pbWindow: "w_smt_bom_create_master" },
      { code: "SMT_PLAN", labelKey: "menu.smt.plan", path: "/smt/plan", pbLinkStatus: "powerbuilder", pbWindow: "w_smt_plan_master" },
      { code: "SMT_BOM_REPORT", labelKey: "menu.smt.bomReport", path: "/smt/bom-report", pbLinkStatus: "powerbuilder", pbWindow: "w_smt_bom_master_rpt" },
      { code: "SMT_BOM_COMPARISON", labelKey: "menu.smt.bomComparison", path: "/smt/bom-comparison", pbLinkStatus: "powerbuilder", pbWindow: "w_smt_bom_comparison_master_rpt" },
      { code: "SMT_FEEDER_PICKUP", labelKey: "menu.smt.feederPickup", path: "/smt/feeder-pickup", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_feeder_pickup_master" },
    ],
  },
  {
    code: "PROCESS_TRANSACTION",
    labelKey: "menu.processTransaction",
    icon: GitBranch,
    children: [
      { code: "PLN_WORKSTAGE_PASS", labelKey: "menu.workstagePass", path: "/process-transaction/workstage-pass", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_inout_scan_master", pbEvidence: "apps/backend/src/modules/process-transaction/workstage-pass.controller.ts" },
      { code: "PLN_MAGAZINE_LABEL_HISTORY", labelKey: "menu.magazineLabelHistory", path: "/process-transaction/magazine-label-history", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_magazine_label_query", pbEvidence: "apps/backend/src/modules/process-transaction/magazine-label-history.controller.ts" },
      { code: "PLN_MAGAZINE_LABEL", labelKey: "menu.magazineLabel", path: "/process-transaction/magazine-label", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_magazine_label_master2" },
      { code: "PLN_MAGAZINE_SPLIT", labelKey: "menu.magazineSplit", path: "/process-transaction/magazine-split", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_magazine_label_split_master" },
      { code: "PLN_MAGAZINE_PID", labelKey: "menu.magazinePid", path: "/process-transaction/magazine-pid", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_barcode_create_master" },
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
      { code: "PRD_PACK", labelKey: "menu.productMgmt.packing", path: "/product/pack", pbLinkStatus: "powerbuilder", pbWindow: "w_prd_product_packing_create_master" },
      { code: "PRD_PACK_HISTORY", labelKey: "menu.productMgmt.packingHistory", path: "/product/pack-history", pbLinkStatus: "powerbuilder", pbWindow: "w_prd_product_packing_history" },
      { code: "PRD_FG_RECEIPT", labelKey: "menu.productMgmt.fgReceipt", path: "/product/fg-receipt", pbLinkStatus: "powerbuilder", pbWindow: "w_prd_product_fg_receipt" },
      { code: "PRD_FG_MODEL_RECEIPT", labelKey: "menu.productMgmt.fgModelReceipt", path: "/product/fg-model-receipt", pbLinkStatus: "powerbuilder", pbWindow: "w_prd_product_fg_4_model_receipt" },
      { code: "PRD_FG_ISSUE", labelKey: "menu.productMgmt.fgIssue", path: "/product/fg-issue", pbLinkStatus: "powerbuilder", pbWindow: "w_prd_product_fg_issue" },
      { code: "PRD_FG_MODEL_ISSUE", labelKey: "menu.productMgmt.fgModelIssue", path: "/product/fg-model-issue", pbLinkStatus: "powerbuilder", pbWindow: "w_prd_product_fg_4_model_issue" },
    ],
  },
  {
    code: "PRODUCTION",
    labelKey: "menu.production",
    icon: ClipboardList,
    children: [
      { code: "PRD_RUN_CARD", labelKey: "menu.production.runCard", path: "/production/run-card", pbLinkStatus: "powerbuilder", pbWindow: "w_product_run_card_duckil", pbEvidence: "apps/frontend/src/app/(authenticated)/production/run-card/page.tsx" },
      { code: "PRD_MASTER_PLAN", labelKey: "menu.production.masterPlan", path: "/production/master-plan", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_master_plan_master" },
      { code: "PRD_SMD_PLAN", labelKey: "menu.production.smdPlan", path: "/production/smd-plan", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_assembly_master_plan_master" },
      { code: "PRD_SMD_ACTUAL", labelKey: "menu.production.smdActual", path: "/production/smd-actual", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_assembly_actual_master" },
      { code: "PRD_RUN_CARD_PID", labelKey: "menu.production.runCardPid", path: "/production/run-card-pid", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_pcb_kitting_scan_master" },
      { code: "PRD_PCB_RESULT", labelKey: "menu.production.pcbResult", path: "/production/pcb-result", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_pcb_result_query" },
      { code: "PRD_DAILY_REPORT", labelKey: "menu.production.dailyReport", path: "/production/daily-report", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_pcb_result_report" },
    ],
  },
  {
    code: "TRACKING",
    labelKey: "menu.tracking",
    icon: Radar,
    children: [
      { code: "TRK_MATERIAL_LOT", labelKey: "menu.tracking.materialLot", path: "/tracking/material-lot", pbLinkStatus: "powerbuilder", pbWindow: "w_product_pid_tracking_rpt" },
      { code: "TRK_MATERIAL_DYNAMIC", labelKey: "menu.tracking.materialDynamic", path: "/tracking/material-dynamic", pbLinkStatus: "powerbuilder", pbWindow: "w_product_material_tracking_rpt" },
      { code: "TRK_MATERIAL_USAGE", labelKey: "menu.tracking.materialUsage", path: "/tracking/material-usage", pbLinkStatus: "powerbuilder", pbWindow: "w_product_material_tracking_msl_rpt" },
      { code: "TRK_PID", labelKey: "menu.tracking.pid", path: "/tracking/pid", pbLinkStatus: "powerbuilder", pbWindow: "w_product_pid_tracking_fpcb_rpt" },
      { code: "TRK_RUN_NO", labelKey: "menu.tracking.runNo", path: "/tracking/run-no", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_barcode_tracking" },
      { code: "TRK_LOT_ALL", labelKey: "menu.tracking.lotAll", path: "/tracking/lot-all", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_all_barcode_tracking" },
      { code: "TRK_LINE_DASHBOARD", labelKey: "menu.tracking.lineDashboard", path: "/tracking/line-dashboard", pbLinkStatus: "powerbuilder", pbWindow: "w_com_production_status_dashboard" },
    ],
  },
  {
    code: "QUERY",
    labelKey: "menu.query",
    icon: ScanSearch,
    children: [
      { code: "QRY_PID_INFO", labelKey: "menu.query.pidInfo", path: "/query/pid-info", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_barcode_query" },
      { code: "QRY_MARKING", labelKey: "menu.query.marking", path: "/query/marking", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_pcb_marking_query" },
      { code: "QRY_PCB_INPUT", labelKey: "menu.query.pcbInput", path: "/query/pcb-input", pbLinkStatus: "powerbuilder", pbWindow: "w_qc_pcb_input_scan_master" },
      { code: "QRY_PDA_SCAN", labelKey: "menu.query.pdaScan", path: "/query/pda-scan", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_pda_scan_query" },
      { code: "QRY_PDA_NG", labelKey: "menu.query.pdaNg", path: "/query/pda-ng", pbLinkStatus: "powerbuilder", pbWindow: "w_smt_plan_ng_check_master" },
      { code: "QRY_FEEDER_MONITOR", labelKey: "menu.query.feederMonitor", path: "/query/feeder-monitor", pbLinkStatus: "powerbuilder", pbWindow: "w_smt_plan_feeder_monitoring_master" },
      { code: "QRY_SENSOR_ACTUAL", labelKey: "menu.query.sensorActual", path: "/query/sensor-actual", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_sensor_actual_master" },
      { code: "QRY_MATERIAL_BARCODE", labelKey: "menu.query.materialBarcode", path: "/query/material-barcode", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_barcode_status_report" },
      { code: "QRY_NSNP_HISTORY", labelKey: "menu.query.nsnpHistory", path: "/query/nsnp-history", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_nsnp_history_query" },
    ],
  },
  {
    code: "REPORT",
    labelKey: "menu.report",
    icon: FileText,
    children: [
      { code: "RPT_ITEM_MASTER", labelKey: "menu.report.itemMaster", path: "/report/item-master", pbLinkStatus: "powerbuilder", pbWindow: "w_des_item_master_rpt" },
      { code: "RPT_LINE_BARCODE", labelKey: "menu.report.lineBarcode", path: "/report/line-barcode", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_line_barcode_rpt" },
      { code: "RPT_CARRIER_BARCODE", labelKey: "menu.report.carrierBarcode", path: "/report/carrier-barcode", pbLinkStatus: "powerbuilder", pbWindow: "w_product_carrier_barcode" },
      { code: "RPT_MACHINE", labelKey: "menu.report.machine", path: "/report/machine", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_machine_rpt" },
      { code: "RPT_PICKUP_RATE", labelKey: "menu.report.pickupRate", path: "/report/pickup-rate", pbLinkStatus: "powerbuilder", pbWindow: "w_smt_pickup_rate_rpt" },
      { code: "RPT_MASTER_PLAN", labelKey: "menu.report.masterPlan", path: "/report/master-plan", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_master_plan_rpt" },
      { code: "RPT_RUN_CARD", labelKey: "menu.report.runCard", path: "/report/run-card", pbLinkStatus: "powerbuilder", pbWindow: "w_product_run_card_rpt" },
      { code: "RPT_FG_ISSUE", labelKey: "menu.report.fgIssue", path: "/report/fg-issue", pbLinkStatus: "powerbuilder", pbWindow: "w_prd_product_fg_issue_rpt" },
      { code: "RPT_WORKSTAGE_STOCK", labelKey: "menu.report.workstageStock", path: "/report/workstage-stock", pbLinkStatus: "powerbuilder", pbWindow: "w_product_workstage_stock_rpt" },
      { code: "RPT_MAGAZINE_STOCK", labelKey: "menu.report.magazineStock", path: "/report/magazine-stock", pbLinkStatus: "powerbuilder", pbWindow: "w_product_workstage_magazine_stock_rpt" },
      { code: "RPT_MOLD_RECEIPT", labelKey: "menu.report.moldReceipt", path: "/report/mold-receipt", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_mold_receipt_rpt" },
      { code: "RPT_MOLD_ISSUE", labelKey: "menu.report.moldIssue", path: "/report/mold-issue", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_mold_issue_rpt" },
      { code: "RPT_JIG", labelKey: "menu.report.jig", path: "/report/jig", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_jig_rpt" },
      { code: "RPT_MOLD", labelKey: "menu.report.mold", path: "/report/mold", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_mold_rpt" },
      { code: "RPT_FOUR_M", labelKey: "menu.report.fourM", path: "/report/four-m", pbLinkStatus: "powerbuilder", pbWindow: "w_qc_4m_history_rpt" },
      { code: "RPT_MATERIAL_BARCODE_SLIP", labelKey: "menu.report.materialBarcodeSlip", path: "/report/material-barcode-slip", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_receipt_issue_barcode_history_report" },
      { code: "RPT_MATERIAL_RECEIPT", labelKey: "menu.report.materialReceipt", path: "/report/material-receipt", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_receipt_report" },
      { code: "RPT_MATERIAL_RECEIPT_SUM", labelKey: "menu.report.materialReceiptSum", path: "/report/material-receipt-sum", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_receipt_sum_report" },
      { code: "RPT_MATERIAL_ISSUE", labelKey: "menu.report.materialIssue", path: "/report/material-issue", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_issue_report" },
      { code: "RPT_MATERIAL_ISSUE_SUM", labelKey: "menu.report.materialIssueSum", path: "/report/material-issue-sum", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_issue_sum_report" },
      { code: "RPT_MATERIAL_RACK_MOVE", labelKey: "menu.report.materialRackMove", path: "/report/material-rack-move", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_location_address_move_report" },
      { code: "RPT_MATERIAL_LONG_TERM", labelKey: "menu.report.materialLongTerm", path: "/report/material-long-term", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_long_term_inventory_report" },
      { code: "RPT_MATERIAL_INVENTORY", labelKey: "menu.report.materialInventory", path: "/report/material-inventory", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_current_inventory_report" },
    ],
  },
  {
    code: "QUALITY",
    labelKey: "menu.quality",
    icon: Wrench,
    children: [
      { code: "QC_IQC_MASTER", labelKey: "menu.quality.iqc", path: "/quality/iqc", pbLinkStatus: "powerbuilder", pbWindow: "w_qc_iqc_master" },
      { code: "QC_IQC_HISTORY_REG", labelKey: "menu.quality.iqcHistory", path: "/quality/iqc-history", pbLinkStatus: "powerbuilder", pbWindow: "w_qc_iqc_inspect_history_master" },
      { code: "QC_PID_ISSUE_SCAN", labelKey: "menu.quality.pidIssueScan", path: "/quality/pid-issue-scan", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_pid_issue_scan_master" },
      { code: "QC_PID_HOLDING", labelKey: "menu.quality.pidHolding", path: "/quality/pid-holding", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_barcode_holding" },
      { code: "QC_INVENTORY_HOLD", labelKey: "menu.quality.inventoryHold", path: "/quality/inventory-hold", pbLinkStatus: "powerbuilder", pbWindow: "w_qc_inventory_hold_master" },
      { code: "QC_NOTIFY", labelKey: "menu.quality.notify", path: "/quality/notify", pbLinkStatus: "powerbuilder", pbWindow: "w_qc_notify_master" },
      { code: "QC_ECO_NOTIFY", labelKey: "menu.quality.ecoNotify", path: "/quality/eco-notify", pbLinkStatus: "powerbuilder", pbWindow: "w_qc_eco_notify_master" },
      { code: "QC_OQC_PID", labelKey: "menu.quality.oqcPid", path: "/quality/oqc-pid", pbLinkStatus: "powerbuilder", pbWindow: "w_qc_oqc_inspect_history_master" },
      { code: "QC_OQC_LOT", labelKey: "menu.quality.oqcLot", path: "/quality/oqc-lot", pbLinkStatus: "powerbuilder", pbWindow: "w_qc_oqc_inspect_history_4_lot_master" },
      { code: "QC_4M", labelKey: "menu.quality.fourM", path: "/quality/4m", pbLinkStatus: "powerbuilder", pbWindow: "w_qc_4m_master" },
      { code: "QC_WQC", labelKey: "menu.quality.wqc", path: "/quality/wqc", pbLinkStatus: "powerbuilder", pbWindow: "w_qc_workstage_inspect_data_master_es" },
      { code: "QC_TEMPERATURE", labelKey: "menu.quality.temperature", path: "/quality/temperature", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_tempreture_history_query" },
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
    code: "CONFIRM",
    labelKey: "menu.confirm",
    icon: BadgeCheck,
    children: [
      { code: "CFM_BUY_PRICE", labelKey: "menu.confirm.buyPrice", path: "/confirm/buy-price", pbLinkStatus: "powerbuilder", pbWindow: "w_mat_buy_price_confirm" },
      { code: "CFM_SALE_PRICE", labelKey: "menu.confirm.salePrice", path: "/confirm/sale-price", pbLinkStatus: "powerbuilder", pbWindow: "w_sal_sale_price_confirm" },
      { code: "CFM_MOLD_PRICE", labelKey: "menu.confirm.moldPrice", path: "/confirm/mold-price", pbLinkStatus: "powerbuilder", pbWindow: "w_mcn_mold_buy_price_confirm" },
      { code: "CFM_BOM", labelKey: "menu.confirm.bom", path: "/confirm/bom", pbLinkStatus: "powerbuilder", pbWindow: "w_des_bom_confirm_master" },
    ],
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
