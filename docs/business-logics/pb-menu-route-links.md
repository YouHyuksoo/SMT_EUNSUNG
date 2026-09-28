---
sources:
  - apps/frontend/src/config/menuConfig.ts
  - apps/frontend/scripts/data/pb-screen-inventory.json
generator: apps/frontend/scripts/gen-migration-status.mjs
verifiedCommit: 138d6671
---

# PB 윈도우 ↔ 웹 메뉴·경로 연결표 (자동 생성)

> **직접 수정하지 마세요.** 메뉴 클릭 경로와 PB 원본의 연결 계약은 `menuConfig.ts`에서 관리합니다.
> 새 메뉴는 `powerbuilder`, `web-native`, `unresolved` 중 하나를 반드시 선언해야 하며 `pnpm test`가 누락·중복·오타를 차단합니다.

## 연결 현황

| 전체 웹 메뉴 | PB 연결 | 웹 신규 | 미확정 |
|---:|---:|---:|---:|
| 163 | 144 | 17 | 2 |

## 전체 연결표

| 그룹 | 웹 메뉴 | 메뉴코드 | 웹 경로 | 연결 상태 | PB 윈도우 | 근거/사유 |
|---|---|---|---|---|---|---|
| 기준정보 | 품목관리 | `MST_PART` | `/master/part` | PB 연결 | `w_des_item_master` | PB 메뉴 인벤토리 |
| 기준정보 | 제품모델 관리 | `MST_PRODUCT_MODEL` | `/master/product-model` | PB 연결 | `w_pln_product_model_simple_master` | PB 메뉴 인벤토리 |
| 기준정보 | BOM관리 | `MST_BOM` | `/master/bom` | 미확정 |  | PB BOM 메뉴가 설계BOM·제조BOM·원단위BOM으로 분리되어 단일 원본을 확정할 수 없음 |
| 기준정보 | 거래처관리 | `MST_PARTNER` | `/master/partner` | 미확정 |  | 웹 거래처가 PB 고객·협력사 화면을 통합하므로 단일 원본을 확정할 수 없음 |
| 기준정보 | 고객마스터 | `MST_CUSTOMER` | `/master/customer` | PB 연결 | `w_com_customer_master` | PB 메뉴 인벤토리 |
| 기준정보 | 설비마스터 | `EQUIP_MASTER` | `/master/equip` | PB 연결 | `w_mcn_machine_master` | PB 메뉴 인벤토리 |
| 기준정보 | 표준시간 관리 | `OEE_MST_STD_TIME` | `/oee/master/standard-time` | 웹 신규 |  | PB 대응 없음 |
| 기준정보 | 설비 비가동 사유코드 | `OEE_MST_IDLE_REASON` | `/oee/master/idle-reason` | 웹 신규 |  | PB 대응 없음 |
| 기준정보 | 설비별 비가동 사유 연계 | `OEE_MST_EQUIP_REASON` | `/oee/master/equip-reason-map` | 웹 신규 |  | PB 대응 없음 |
| 기준정보 | 공정관리 | `MST_PROCESS` | `/master/process` | PB 연결 | `w_pln_workstage_master` | PB 메뉴 인벤토리 |
| 기준정보 | 생산라인관리 | `MST_PROD_LINE` | `/master/prod-line` | PB 연결 | `w_pln_line_master` | PB 메뉴 인벤토리 |
| 기준정보 | 라우팅관리 | `MST_ROUTING` | `/master/routing` | 웹 신규 |  | PB 대응 없음 |
| 기준정보 | 생산월력관리 | `MST_WORK_CALENDAR` | `/master/work-calendar` | PB 연결 | `w_pln_product_calendar` | PB 메뉴 인벤토리 |
| 기준정보 | 작업자관리 | `MST_WORKER` | `/master/worker` | 웹 신규 |  | PB 대응 없음 |
| 기준정보 | 작업지도서관리 | `MST_WORK_INST` | `/master/work-instruction` | 웹 신규 |  | PB 대응 없음 |
| 기준정보 | 창고관리 | `MST_WAREHOUSE` | `/master/warehouse` | 웹 신규 |  | PB 대응 없음 |
| 기준정보 | 라벨다자인관리 | `MST_LABEL` | `/master/label` | PB 연결 | `w_product_label_master` | PB 메뉴 인벤토리 |
| 기준정보 | 구매단가관리 | `MST_PURCHASE_PRICE` | `/master/purchase-price` | PB 연결 | `w_mat_buy_price_master` | PB 메뉴 인벤토리 |
| 기준정보 | 품목별 공급처 관리 | `MST_ITEM_SUPPLIER` | `/master/item-supplier` | PB 연결 | `w_mat_item_master` | PB 메뉴 인벤토리 |
| 기준정보 | 제품판매단가관리 | `MST_SALE_PRICE` | `/master/sale-price` | PB 연결 | `w_sal_sale_price_master` | PB 메뉴 인벤토리 |
| BOM 관리 | 대체BOM관리 | `BOM_REPLACE` | `/bom/replace-bom` | PB 연결 | `w_des_replace_bom_master` | PB 메뉴 인벤토리 |
| 설비관리 | SP 작업결과조회 | `EQUIP_RESULT_SP` | `/equipment/result-query/sp` | PB 연결 | `w_qc_machine_inspect_data_sp_query` | PB 메뉴 인벤토리 |
| 설비관리 | SPI 검사결과조회 | `EQUIP_RESULT_SPI` | `/equipment/result-query/spi` | PB 연결 | `w_spi_time_query` | PB 메뉴 인벤토리 |
| 설비관리 | ICT 검사결과조회 | `EQUIP_RESULT_ICT` | `/equipment/result-query/ict` | PB 연결 | `w_qc_machine_inspect_data_ict_query` | PB 메뉴 인벤토리 |
| 설비관리 | AOI 검사결과조회 | `EQUIP_RESULT_AOI` | `/equipment/result-query/aoi` | PB 연결 | `w_aoi_header_detail_query` | PB 메뉴 인벤토리 |
| 설비관리 | ROUTER 작업결과조회 | `EQUIP_RESULT_ROUTER` | `/equipment/result-query/router` | PB 연결 | `w_qc_machine_inspect_data_rt_query` | PB 메뉴 인벤토리 |
| 설비관리 | ROM WRITE 작업결과조회 | `EQUIP_RESULT_ROM_WRITE` | `/equipment/result-query/rom-write` | PB 연결 | `w_qc_machine_inspect_data_rw_query` | PB 메뉴 인벤토리 |
| 설비관리 | 솔더점도 검사결과조회 | `EQUIP_RESULT_SOLDER` | `/equipment/result-query/solder` | PB 연결 | `w_qc_machine_inspect_data_solder_query` | PB 메뉴 인벤토리 |
| 설비관리 | REFLOW 작업결과조회 | `EQUIP_RESULT_REFLOW` | `/equipment/result-query/reflow` | PB 연결 | `w_qc_machine_inspect_data_reflow_query` | PB 메뉴 인벤토리 |
| 설비관리 | 성능 검사결과조회 | `EQUIP_RESULT_PERFORMANCE` | `/equipment/result-query/performance` | PB 연결 | `w_qc_machine_inspect_data_eol_query` | PB 메뉴 인벤토리 |
| OEE 관리 | 공정별 OEE 종합 | `OEE_DASHBOARD` | `/oee/dashboard` | 웹 신규 |  | PB 대응 없음 |
| OEE 관리 | OEE 비가동 입력 | `OEE_MULTI_ENTRY` | `/oee/multi-entry` | 웹 신규 |  | PB 대응 없음 |
| OEE 관리 | OEE 종합 현황 | `OEE_OVERALL_STATUS` | `/oee/overall-status` | 웹 신규 |  | PB 대응 없음 |
| OEE 관리 | 설비별 작업 실적관리 | `OEE_EQUIP_WORK_RESULT` | `/oee/equip-work-result` | 웹 신규 |  | PB 대응 없음 |
| OEE 관리 | 설비 운영 현황 | `OEE_EQUIP_OPS_STATUS` | `/oee/equip-ops-status` | 웹 신규 |  | PB 대응 없음 |
| OEE 관리 | 설비 운영 및 실적관리(현장) | `OEE_FIELD_OPS` | `/oee/field-ops` | 웹 신규 |  | PB 대응 없음 |
| 자재수불관리 | 자재입출고수불원장 | `MAT_RECEIPT_ISSUE_LEDGER` | `/material/receipt-issue-ledger` | PB 연결 | `w_mat_ledger_report` | PB 메뉴 인벤토리 |
| 자재수불관리 | 현재고조회 | `MAT_CURRENT_INVENTORY` | `/material/current-inventory` | PB 연결 | `w_mat_current_inventory_master` | PB 메뉴 인벤토리 |
| 자재수불관리 | 공정재고조회 | `MAT_WORKSTAGE_INVENTORY` | `/material/workstage-inventory` | PB 연결 | `w_mat_workstage_inventory_query` | `apps/backend/src/modules/material/controllers/workstage-inventory.controller.ts` |
| 자재수불관리 | 자재입고취소 | `MAT_RECEIPT_CANCEL` | `/material/receipt-cancel` | PB 연결 | `w_mat_receipt_cancel_master` | PB 메뉴 인벤토리 |
| 자재수불관리 | 베이킹재고조회 | `WH_BAKING_STOCK` | `/warehouse/baking-stock` | PB 연결 | `w_mat_baking_scan_query` | PB 메뉴 인벤토리 |
| 자재수불관리 | 진공포장재고조회 | `WH_VACUUM_STOCK` | `/warehouse/vacuum-stock` | PB 연결 | `w_mat_vacuum_scan_query` | PB 메뉴 인벤토리 |
| 자재수불관리 | 제습함재고조회 | `WH_DEHUMI_STOCK` | `/warehouse/dehumi-stock` | PB 연결 | `w_mat_dehumi_scan_query` | PB 메뉴 인벤토리 |
| 자재수불관리 | SMT 공릴체크 | `WH_RECYCLE_CHECK` | `/warehouse/recycle-check` | PB 연결 | `w_smt_recycle_check_rpt` | PB 메뉴 인벤토리 |
| 자재수불관리 | 솔더입출고조회 | `WH_SOLDER` | `/warehouse/solder` | PB 연결 | `w_mat_solder_receipt_issue_master` | PB 메뉴 인벤토리 |
| 자재수불관리 | 솔더라인투입이력조회 | `WH_SOLDER_INPUT` | `/warehouse/solder-input` | PB 연결 | `w_mat_solder_input_move_query` | PB 메뉴 인벤토리 |
| 자재수불관리 | 자재입고전표관리 | `WH_RECEIPT_SLIP` | `/warehouse/receipt-slip` | PB 연결 | `w_mat_receipt_slip_master` | PB 메뉴 인벤토리 |
| 자재수불관리 | 자재바코드입고관리 | `WH_BARCODE_RECEIPT` | `/warehouse/barcode-receipt` | PB 연결 | `w_mat_other_receipt_barcode_master` | PB 메뉴 인벤토리 |
| 자재수불관리 | 솔더라벨 발행 | `WH_SOLDER_LABEL` | `/warehouse/solder-label` | PB 연결 | `w_mat_receipt_slip_master_onetek_solder` | PB 메뉴 인벤토리 |
| 자재수불관리 | 자재입고관리 | `WH_MATERIAL_RECEIPT` | `/warehouse/material-receipt` | PB 연결 | `w_mat_receipt_master` | PB 메뉴 인벤토리 |
| 자재수불관리 | 자재기타입고관리 | `WH_ETC_RECEIPT` | `/warehouse/etc-receipt` | PB 연결 | `w_mat_other_receipt_master` | PB 메뉴 인벤토리 |
| 자재수불관리 | 자재기타출고 | `WH_ETC_ISSUE` | `/warehouse/etc-issue` | PB 연결 | `w_mat_other_issue_master` | PB 메뉴 인벤토리 |
| 자재수불관리 | 자재출고취소 | `WH_ISSUE_CANCEL` | `/warehouse/issue-cancel` | PB 연결 | `w_mat_mass_issue_cancel_master` | PB 메뉴 인벤토리 |
| 자재수불관리 | 출고바코드반품 | `WH_ISSUE_RETURN` | `/warehouse/issue-return` | PB 연결 | `w_mat_other_mass_issue_barcode_return_master` | PB 메뉴 인벤토리 |
| 자재수불관리 | 자재바코드출고관리 | `WH_BARCODE_ISSUE` | `/warehouse/barcode-issue` | PB 연결 | `w_mat_other_issue_barcode_master` | PB 메뉴 인벤토리 |
| 자재수불관리 | 자재분할관리 | `WH_BARCODE_DIVIDE` | `/warehouse/barcode-divide` | PB 연결 | `w_mat_receipt_barcode_divide_master` | PB 메뉴 인벤토리 |
| 자재수불관리 | 베이킹이력관리 | `WH_BAKING_SCAN` | `/warehouse/baking-scan` | PB 연결 | `w_mat_baking_dehumi_scan_master` | PB 메뉴 인벤토리 |
| 지그관리 | 지그마스터 | `JIG_MASTER` | `/jig/master` | PB 연결 | `w_mcn_jig_master` | PB 메뉴 인벤토리 |
| 지그관리 | 지그출고관리 | `JIG_ISSUE` | `/jig/issue` | PB 연결 | `w_mcn_jig_issue_master` | PB 메뉴 인벤토리 |
| 지그관리 | 지그수리관리 | `JIG_REPAIR` | `/jig/repair` | PB 연결 | `w_mcn_jig_repair_master` | PB 메뉴 인벤토리 |
| 지그관리 | 지그자주보전관리 | `JIG_PM` | `/jig/pm` | PB 연결 | `w_mcn_jig_pm_master` | PB 메뉴 인벤토리 |
| 지그관리 | 스퀴즈검사관리 | `JIG_SQUEEZE_CHECK` | `/jig/squeeze-check` | PB 연결 | `w_mcn_jig_squeeze_check_master` | PB 메뉴 인벤토리 |
| 지그관리 | 메탈마스크 텐션검사 | `JIG_MASK_CHECK` | `/jig/mask-check` | PB 연결 | `w_mcn_jig_mask_tension_check_master` | PB 메뉴 인벤토리 |
| 지그관리 | 샘플마스터 관리 | `JIG_SAMPLE` | `/jig/sample` | PB 연결 | `w_mcn_sample_master` | PB 메뉴 인벤토리 |
| 지그관리 | 지그 투입이력조회 | `JIG_INPUT_HISTORY` | `/jig/input-history` | PB 연결 | `w_mcn_jig_input_history_master` | PB 메뉴 인벤토리 |
| 지그관리 | 샘플마스터 장착이력조회 | `JIG_SAMPLE_INPUT_HISTORY` | `/jig/sample-input-history` | PB 연결 | `w_mcn_sample_input_history_master` | PB 메뉴 인벤토리 |
| 지그관리 | 샘플마스터 투입이력조회 | `JIG_SAMPLE_BCR_HISTORY` | `/jig/sample-bcr-history` | PB 연결 | `w_mcn_sample_bcr_input_history_master` | PB 메뉴 인벤토리 |
| 피더관리 | 피더관리 | `FEEDER_MASTER` | `/feeder/master` | PB 연결 | `w_mcn_feeder_master` | PB 메뉴 인벤토리 |
| 피더관리 | 피더수리관리 | `FEEDER_REPAIR` | `/feeder/repair` | PB 연결 | `w_mcn_feeder_repair_master` | PB 메뉴 인벤토리 |
| 피더관리 | 피더교정관리 | `FEEDER_ADJUST` | `/feeder/adjust` | PB 연결 | `w_mcn_jig_feeder_adjust_master` | PB 메뉴 인벤토리 |
| S-PARTS관리 | S-PARTS관리 | `MOLD_MASTER` | `/mold/master` | PB 연결 | `w_mcn_mold_master` | PB 메뉴 인벤토리 |
| S-PARTS관리 | S-PARTS재고관리 | `MOLD_INVENTORY` | `/mold/inventory` | PB 연결 | `w_mcn_mold_inventory_master` | PB 메뉴 인벤토리 |
| S-PARTS관리 | S-PARTS주문관리 | `MOLD_ORDER` | `/mold/order` | PB 연결 | `w_mcn_mold_purchase_order_master` | PB 메뉴 인벤토리 |
| S-PARTS관리 | S-PARTS입고관리 | `MOLD_RECEIPT` | `/mold/receipt` | PB 연결 | `w_mcn_mold_receipt_master` | PB 메뉴 인벤토리 |
| S-PARTS관리 | S-PARTS출고관리 | `MOLD_ISSUE` | `/mold/issue` | PB 연결 | `w_mcn_mold_issue_master` | PB 메뉴 인벤토리 |
| S-PARTS관리 | S-PARTS수리신청관리 | `MOLD_REPAIR_REQUEST` | `/mold/repair-request` | PB 연결 | `w_mcn_mold_repair_request_master` | PB 메뉴 인벤토리 |
| S-PARTS관리 | S-PARTS수리관리 | `MOLD_REPAIR` | `/mold/repair` | PB 연결 | `w_mcn_mold_repair_master` | PB 메뉴 인벤토리 |
| S-PARTS관리 | S-PARTS구매단가관리 | `MOLD_PRICE` | `/mold/price` | PB 연결 | `w_mcn_mold_buy_price_master` | PB 메뉴 인벤토리 |
| SMT관리 | SMT 라인관리 | `SMT_LINE` | `/smt/line` | PB 연결 | `w_smt_line_master` | PB 메뉴 인벤토리 |
| SMT관리 | 라인별 테이블 관리 | `SMT_LOCATION` | `/smt/location` | PB 연결 | `w_smt_location_master` | PB 메뉴 인벤토리 |
| SMT관리 | SMT BOM 대체관리 | `SMT_BOM_REPLACE` | `/smt/bom-replace` | PB 연결 | `w_smt_bom_replace_master` | PB 메뉴 인벤토리 |
| SMT관리 | SMT 피더레이아웃 등록 | `SMT_NC_UPLOAD` | `/smt/nc-upload` | PB 연결 | `w_smt_upload_nc_master` | PB 메뉴 인벤토리 |
| SMT관리 | SMT BOM 관리 | `SMT_BOM` | `/smt/bom` | PB 연결 | `w_smt_bom_create_master` | PB 메뉴 인벤토리 |
| SMT관리 | SMT 계획배포관리 | `SMT_PLAN` | `/smt/plan` | PB 연결 | `w_smt_plan_master` | PB 메뉴 인벤토리 |
| SMT관리 | SMT BOM 관리리포트 | `SMT_BOM_REPORT` | `/smt/bom-report` | PB 연결 | `w_smt_bom_master_rpt` | PB 메뉴 인벤토리 |
| SMT관리 | 피더레이아웃 비교 | `SMT_BOM_COMPARISON` | `/smt/bom-comparison` | PB 연결 | `w_smt_bom_comparison_master_rpt` | PB 메뉴 인벤토리 |
| SMT관리 | 마운터 픽업정보관리 | `SMT_FEEDER_PICKUP` | `/smt/feeder-pickup` | PB 연결 | `w_mcn_feeder_pickup_master` | PB 메뉴 인벤토리 |
| 공정수불관리 | 공정통과이력 관리 | `PLN_WORKSTAGE_PASS` | `/process-transaction/workstage-pass` | PB 연결 | `w_pln_product_inout_scan_master` | PB 메뉴 인벤토리 |
| 공정수불관리 | 매거진발행이력 | `PLN_MAGAZINE_LABEL_HISTORY` | `/process-transaction/magazine-label-history` | PB 연결 | `w_pln_product_magazine_label_query` | PB 메뉴 인벤토리 |
| 제품재고관리 | 제품재고조회 | `PRD_CURRENT_INVENTORY` | `/product/current-inventory` | PB 연결 | `w_prd_product_fg_inventory` | PB 메뉴 인벤토리 |
| 생산관리 | 작업지시관리 | `PRD_RUN_CARD` | `/production/run-card` | PB 연결 | `w_product_run_card_duckil` | PB 메뉴 인벤토리 |
| 생산관리 | 제품생산계획 | `PRD_MASTER_PLAN` | `/production/master-plan` | PB 연결 | `w_pln_product_master_plan_master` | PB 메뉴 인벤토리 |
| 생산관리 | 반제품생산계획 | `PRD_SMD_PLAN` | `/production/smd-plan` | PB 연결 | `w_pln_assembly_master_plan_master` | PB 메뉴 인벤토리 |
| 생산관리 | 반제품생산실적관리 | `PRD_SMD_ACTUAL` | `/production/smd-actual` | PB 연결 | `w_pln_assembly_actual_master` | PB 메뉴 인벤토리 |
| 생산관리 | 롯트카드-PID 매핑관리 | `PRD_RUN_CARD_PID` | `/production/run-card-pid` | PB 연결 | `w_pln_product_pcb_kitting_scan_master` | PB 메뉴 인벤토리 |
| 생산관리 | 기간별 생산실적 조회 | `PRD_PCB_RESULT` | `/production/pcb-result` | PB 연결 | `w_pln_product_pcb_result_query` | PB 메뉴 인벤토리 |
| 생산관리 | 생산일보 리포트 | `PRD_DAILY_REPORT` | `/production/daily-report` | PB 연결 | `w_pln_product_pcb_result_report` | PB 메뉴 인벤토리 |
| 추적 | 자재 제조번호 기준 추적 | `TRK_MATERIAL_LOT` | `/tracking/material-lot` | PB 연결 | `w_product_pid_tracking_rpt` | PB 메뉴 인벤토리 |
| 추적 | 자재추적조회(동적) | `TRK_MATERIAL_DYNAMIC` | `/tracking/material-dynamic` | PB 연결 | `w_product_material_tracking_rpt` | PB 메뉴 인벤토리 |
| 추적 | 자재사용이력조회 | `TRK_MATERIAL_USAGE` | `/tracking/material-usage` | PB 연결 | `w_product_material_tracking_msl_rpt` | PB 메뉴 인벤토리 |
| 추적 | 생산이력조회(PID) | `TRK_PID` | `/tracking/pid` | PB 연결 | `w_product_pid_tracking_fpcb_rpt` | PB 메뉴 인벤토리 |
| 추적 | 생산이력조회(Run No) | `TRK_RUN_NO` | `/tracking/run-no` | PB 연결 | `w_pln_product_barcode_tracking` | PB 메뉴 인벤토리 |
| 추적 | 롯트추적조회(ALL) | `TRK_LOT_ALL` | `/tracking/lot-all` | PB 연결 | `w_pln_product_all_barcode_tracking` | PB 메뉴 인벤토리 |
| 추적 | 생산현황데쉬보드 | `TRK_LINE_DASHBOARD` | `/tracking/line-dashboard` | PB 연결 | `w_com_production_status_dashboard` | PB 메뉴 인벤토리 |
| 조회 | PID 정보조회 | `QRY_PID_INFO` | `/query/pid-info` | PB 연결 | `w_pln_product_barcode_query` | PB 메뉴 인벤토리 |
| 조회 | 마킹이력조회 | `QRY_MARKING` | `/query/marking` | PB 연결 | `w_pln_product_pcb_marking_query` | PB 메뉴 인벤토리 |
| 조회 | PCB 투입 리스트조회 | `QRY_PCB_INPUT` | `/query/pcb-input` | PB 연결 | `w_qc_pcb_input_scan_master` | PB 메뉴 인벤토리 |
| 조회 | SMT 오장착 스캔 현황 조회 | `QRY_PDA_SCAN` | `/query/pda-scan` | PB 연결 | `w_pln_product_pda_scan_query` | PB 메뉴 인벤토리 |
| 조회 | PDA 검사오류내역조회 | `QRY_PDA_NG` | `/query/pda-ng` | PB 연결 | `w_smt_plan_ng_check_master` | PB 메뉴 인벤토리 |
| 조회 | SMT 피더별 모니터링 | `QRY_FEEDER_MONITOR` | `/query/feeder-monitor` | PB 연결 | `w_smt_plan_feeder_monitoring_master` | PB 메뉴 인벤토리 |
| 조회 | SMT 제품실적센서이력조회 | `QRY_SENSOR_ACTUAL` | `/query/sensor-actual` | PB 연결 | `w_pln_product_sensor_actual_master` | PB 메뉴 인벤토리 |
| 조회 | 자재 바코드 상태 조회 | `QRY_MATERIAL_BARCODE` | `/query/material-barcode` | PB 연결 | `w_mat_barcode_status_report` | PB 메뉴 인벤토리 |
| 조회 | NSNP 처리이력조회 | `QRY_NSNP_HISTORY` | `/query/nsnp-history` | PB 연결 | `w_pln_product_nsnp_history_query` | PB 메뉴 인벤토리 |
| 리포트 | 품목마스터리포트 | `RPT_ITEM_MASTER` | `/report/item-master` | PB 연결 | `w_des_item_master_rpt` | PB 메뉴 인벤토리 |
| 리포트 | 라인설비바코드 | `RPT_LINE_BARCODE` | `/report/line-barcode` | PB 연결 | `w_pln_line_barcode_rpt` | PB 메뉴 인벤토리 |
| 리포트 | 캐리어바코드 | `RPT_CARRIER_BARCODE` | `/report/carrier-barcode` | PB 연결 | `w_product_carrier_barcode` | PB 메뉴 인벤토리 |
| 리포트 | 설비리포트 | `RPT_MACHINE` | `/report/machine` | PB 연결 | `w_mcn_machine_rpt` | PB 메뉴 인벤토리 |
| 리포트 | SMT PICKUP 리포트 | `RPT_PICKUP_RATE` | `/report/pickup-rate` | PB 연결 | `w_smt_pickup_rate_rpt` | PB 메뉴 인벤토리 |
| 리포트 | 생산계획리포트 | `RPT_MASTER_PLAN` | `/report/master-plan` | PB 연결 | `w_pln_master_plan_rpt` | PB 메뉴 인벤토리 |
| 리포트 | 런카드리포트 | `RPT_RUN_CARD` | `/report/run-card` | PB 연결 | `w_product_run_card_rpt` | PB 메뉴 인벤토리 |
| 리포트 | 제품 판매실적 | `RPT_FG_ISSUE` | `/report/fg-issue` | PB 연결 | `w_prd_product_fg_issue_rpt` | PB 메뉴 인벤토리 |
| 리포트 | 공정재공조회 | `RPT_WORKSTAGE_STOCK` | `/report/workstage-stock` | PB 연결 | `w_product_workstage_stock_rpt` | PB 메뉴 인벤토리 |
| 리포트 | 공정매거진조회 | `RPT_MAGAZINE_STOCK` | `/report/magazine-stock` | PB 연결 | `w_product_workstage_magazine_stock_rpt` | PB 메뉴 인벤토리 |
| 리포트 | S-PARTS입고리포트 | `RPT_MOLD_RECEIPT` | `/report/mold-receipt` | PB 연결 | `w_mcn_mold_receipt_rpt` | PB 메뉴 인벤토리 |
| 리포트 | S-PARTS출고리포트 | `RPT_MOLD_ISSUE` | `/report/mold-issue` | PB 연결 | `w_mcn_mold_issue_rpt` | PB 메뉴 인벤토리 |
| 리포트 | 지그리포트 | `RPT_JIG` | `/report/jig` | PB 연결 | `w_mcn_jig_rpt` | PB 메뉴 인벤토리 |
| 리포트 | S-PARTS관리리포트 | `RPT_MOLD` | `/report/mold` | PB 연결 | `w_mcn_mold_rpt` | PB 메뉴 인벤토리 |
| 리포트 | 4M 변경이력 | `RPT_FOUR_M` | `/report/four-m` | PB 연결 | `w_qc_4m_history_rpt` | PB 메뉴 인벤토리 |
| 리포트 | 자재전표바코드리포트 | `RPT_MATERIAL_BARCODE_SLIP` | `/report/material-barcode-slip` | PB 연결 | `w_mat_receipt_issue_barcode_history_report` | PB 메뉴 인벤토리 |
| 리포트 | 자재입고리포트 | `RPT_MATERIAL_RECEIPT` | `/report/material-receipt` | PB 연결 | `w_mat_receipt_report` | PB 메뉴 인벤토리 |
| 리포트 | 자재입고합계리포트 | `RPT_MATERIAL_RECEIPT_SUM` | `/report/material-receipt-sum` | PB 연결 | `w_mat_receipt_sum_report` | PB 메뉴 인벤토리 |
| 리포트 | 자재출고리포트 | `RPT_MATERIAL_ISSUE` | `/report/material-issue` | PB 연결 | `w_mat_issue_report` | PB 메뉴 인벤토리 |
| 리포트 | 자재출고합계리포트 | `RPT_MATERIAL_ISSUE_SUM` | `/report/material-issue-sum` | PB 연결 | `w_mat_issue_sum_report` | PB 메뉴 인벤토리 |
| 리포트 | 자재랙이동리포트 | `RPT_MATERIAL_RACK_MOVE` | `/report/material-rack-move` | PB 연결 | `w_mat_location_address_move_report` | PB 메뉴 인벤토리 |
| 리포트 | 자재장기재고리포트 | `RPT_MATERIAL_LONG_TERM` | `/report/material-long-term` | PB 연결 | `w_mat_long_term_inventory_report` | PB 메뉴 인벤토리 |
| 리포트 | 재고리포트 | `RPT_MATERIAL_INVENTORY` | `/report/material-inventory` | PB 연결 | `w_mat_current_inventory_report` | PB 메뉴 인벤토리 |
| 품질관리 | IQC 관리 | `QC_IQC_MASTER` | `/quality/iqc` | PB 연결 | `w_qc_iqc_master` | PB 메뉴 인벤토리 |
| 품질관리 | IQC 이력등록관리 | `QC_IQC_HISTORY_REG` | `/quality/iqc-history` | PB 연결 | `w_qc_iqc_inspect_history_master` | PB 메뉴 인벤토리 |
| 품질관리 | PCB 이슈발생스캔 | `QC_PID_ISSUE_SCAN` | `/quality/pid-issue-scan` | PB 연결 | `w_pln_product_pid_issue_scan_master` | PB 메뉴 인벤토리 |
| 품질관리 | PID 홀딩관리 | `QC_PID_HOLDING` | `/quality/pid-holding` | PB 연결 | `w_pln_product_barcode_holding` | PB 메뉴 인벤토리 |
| 품질관리 | 재고통제관리 | `QC_INVENTORY_HOLD` | `/quality/inventory-hold` | PB 연결 | `w_qc_inventory_hold_master` | PB 메뉴 인벤토리 |
| 품질관리 | 품질이상발생관리 | `QC_NOTIFY` | `/quality/notify` | PB 연결 | `w_qc_notify_master` | PB 메뉴 인벤토리 |
| 품질관리 | 품질알림관리 | `QC_ECO_NOTIFY` | `/quality/eco-notify` | PB 연결 | `w_qc_eco_notify_master` | PB 메뉴 인벤토리 |
| 품질관리 | OQC 검사이력(PID) | `QC_OQC_PID` | `/quality/oqc-pid` | PB 연결 | `w_qc_oqc_inspect_history_master` | PB 메뉴 인벤토리 |
| 품질관리 | OQC 검사이력(LOT) | `QC_OQC_LOT` | `/quality/oqc-lot` | PB 연결 | `w_qc_oqc_inspect_history_4_lot_master` | PB 메뉴 인벤토리 |
| 품질관리 | 4M 이력관리 | `QC_4M` | `/quality/4m` | PB 연결 | `w_qc_4m_master` | PB 메뉴 인벤토리 |
| 품질관리 | 공정품질검사이력 | `QC_WQC` | `/quality/wqc` | PB 연결 | `w_qc_workstage_inspect_data_master_es` | PB 메뉴 인벤토리 |
| 품질관리 | 온도상태조회 | `QC_TEMPERATURE` | `/quality/temperature` | PB 연결 | `w_pln_product_tempreture_history_query` | PB 메뉴 인벤토리 |
| 품질관리 | 공정수리이력조회 | `QC_REPAIR_HISTORY` | `/quality/repair-history` | PB 연결 | `w_pln_product_pcb_repair_master` | PB 메뉴 인벤토리 |
| 품질관리 | 공정폐기관리 | `QC_PRODUCT_DESTROY` | `/quality/product-destroy` | PB 연결 | `w_pln_product_pcb_destroy_master` | PB 메뉴 인벤토리 |
| 승인 | 구매단가승인 | `CFM_BUY_PRICE` | `/confirm/buy-price` | PB 연결 | `w_mat_buy_price_confirm` | PB 메뉴 인벤토리 |
| 승인 | 판매단가승인 | `CFM_SALE_PRICE` | `/confirm/sale-price` | PB 연결 | `w_sal_sale_price_confirm` | PB 메뉴 인벤토리 |
| 승인 | S-PARTS구매단가승인 | `CFM_MOLD_PRICE` | `/confirm/mold-price` | PB 연결 | `w_mcn_mold_buy_price_confirm` | PB 메뉴 인벤토리 |
| 승인 | 설계BOM승인 | `CFM_BOM` | `/confirm/bom` | PB 연결 | `w_des_bom_confirm_master` | PB 메뉴 인벤토리 |
| 시스템관리 | 회사관리 | `SYS_COMPANY` | `/master/company` | PB 연결 | `w_company_master` | PB 메뉴 인벤토리 |
| 시스템관리 | 코드관리 | `SYS_CODE` | `/master/code` | PB 연결 | `w_basecode_master` | PB 메뉴 인벤토리 |
| 시스템관리 | 환경설정 | `SYS_CONFIG` | `/system/config` | PB 연결 | `w_system_config` | PB 메뉴 인벤토리 |
| 시스템관리 | 메뉴 카테고리 관리 | `SYS_MENU_CATEGORY` | `/system/menu-categories` | 웹 신규 |  | PB 대응 없음 |
| 시스템관리 | 부서관리 | `SYS_DEPT` | `/system/department` | PB 연결 | `w_department_master` | PB 메뉴 인벤토리 |
| 시스템관리 | 사용자관리 | `SYS_USER` | `/system/users` | PB 연결 | `w_user_master` | PB 메뉴 인벤토리 |
| 시스템관리 | 스케줄러 | `SYS_SCHEDULER` | `/system/scheduler` | 웹 신규 |  | PB 대응 없음 |
| 시스템관리 | ER VIEW | `SYS_ER_VIEW` | `/system/er-view` | 웹 신규 |  | PB 대응 없음 |
| 시스템관리 | 개선요청 관리 | `SYS_IMPR_REQ` | `/system/improvement-requests` | 웹 신규 |  | PB 대응 없음 |
