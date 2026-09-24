---
sources:
  - apps/frontend/src/config/menuConfig.ts
  - apps/frontend/scripts/data/pb-screen-inventory.json
generator: apps/frontend/scripts/gen-migration-status.mjs
verifiedCommit: 1432d26
---

# PB 윈도우 ↔ 웹 메뉴·경로 연결표 (자동 생성)

> **직접 수정하지 마세요.** 메뉴 클릭 경로와 PB 원본의 연결 계약은 `menuConfig.ts`에서 관리합니다.
> 새 메뉴는 `powerbuilder`, `web-native`, `unresolved` 중 하나를 반드시 선언해야 하며 `pnpm test`가 누락·중복·오타를 차단합니다.

## 연결 현황

| 전체 웹 메뉴 | PB 연결 | 웹 신규 | 미확정 |
|---:|---:|---:|---:|
| 55 | 36 | 17 | 2 |

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
| 공정수불관리 | 공정통과이력 관리 | `PLN_WORKSTAGE_PASS` | `/process-transaction/workstage-pass` | PB 연결 | `w_pln_product_inout_scan_master` | PB 메뉴 인벤토리 |
| 공정수불관리 | 매거진발행이력 | `PLN_MAGAZINE_LABEL_HISTORY` | `/process-transaction/magazine-label-history` | PB 연결 | `w_pln_product_magazine_label_query` | PB 메뉴 인벤토리 |
| 제품재고관리 | 제품재고조회 | `PRD_CURRENT_INVENTORY` | `/product/current-inventory` | PB 연결 | `w_prd_product_fg_inventory` | PB 메뉴 인벤토리 |
| 생산관리 | 작업지시관리 | `PRD_RUN_CARD` | `/production/run-card` | PB 연결 | `w_product_run_card` | `apps/frontend/src/app/(authenticated)/production/run-card/page.tsx` |
| 품질관리 | 공정수리이력조회 | `QC_REPAIR_HISTORY` | `/quality/repair-history` | PB 연결 | `w_pln_product_pcb_repair_master` | PB 메뉴 인벤토리 |
| 품질관리 | 공정폐기관리 | `QC_PRODUCT_DESTROY` | `/quality/product-destroy` | PB 연결 | `w_pln_product_pcb_destroy_master` | PB 메뉴 인벤토리 |
| 시스템관리 | 회사관리 | `SYS_COMPANY` | `/master/company` | PB 연결 | `w_company_master` | PB 메뉴 인벤토리 |
| 시스템관리 | 코드관리 | `SYS_CODE` | `/master/code` | PB 연결 | `w_basecode_master` | PB 메뉴 인벤토리 |
| 시스템관리 | 환경설정 | `SYS_CONFIG` | `/system/config` | PB 연결 | `w_system_config` | PB 메뉴 인벤토리 |
| 시스템관리 | 메뉴 카테고리 관리 | `SYS_MENU_CATEGORY` | `/system/menu-categories` | 웹 신규 |  | PB 대응 없음 |
| 시스템관리 | 부서관리 | `SYS_DEPT` | `/system/department` | PB 연결 | `w_department_master` | PB 메뉴 인벤토리 |
| 시스템관리 | 사용자관리 | `SYS_USER` | `/system/users` | PB 연결 | `w_user_master` | PB 메뉴 인벤토리 |
| 시스템관리 | 스케줄러 | `SYS_SCHEDULER` | `/system/scheduler` | 웹 신규 |  | PB 대응 없음 |
| 시스템관리 | ER VIEW | `SYS_ER_VIEW` | `/system/er-view` | 웹 신규 |  | PB 대응 없음 |
| 시스템관리 | 개선요청 관리 | `SYS_IMPR_REQ` | `/system/improvement-requests` | 웹 신규 |  | PB 대응 없음 |
