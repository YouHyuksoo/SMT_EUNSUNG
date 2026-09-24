---
sources:
  - packages/shared/src/popups/catalog.ts
  - docs/database/generated/pb-popup-inventory.json
generator: apps/frontend/scripts/gen-popup-status.mjs
verifiedCommit: aba630a
---

# PB 팝업 이관 현황 (자동 생성)

> **직접 수정하지 마세요.** 팝업을 만들거나 연결하면
> `packages/shared/src/popups/catalog.ts` 에 엔트리를 추가하세요.
> 재생성: `pnpm --filter @eunsung/frontend gen:popup-status`

PB 팝업 판정 기준은 파일명이 아니라 호출관계입니다 — 다른 창에서
`Open`/`OpenWithParm` 으로 열리는 창, 그리고 `*_popup` 으로 끝나는 창.

> **분류(`kind`)는 정적 분석 결과입니다.** 값 반환은 두 가지 관용구로 잡습니다 —
> `CloseWithReturn(...)` 과 전역 구조체(`gst_return.gvs_return[n] = ...`).
> 둘 다 아닌 방식으로 값을 넘기는 창은 `조회전용` 으로 잡힐 수 있으니,
> 실제로 연결할 때는 호출처 스크립트를 함께 확인하세요.

## 현황

| 분류 | PB 팝업 | 연결가능 | 정의완료 | 제외 | 미착수 |
|---|---:|---:|---:|---:|---:|
| 검색선택형 | 92 | 8 | 0 | 0 | 84 |
| 조회전용 | 23 | 0 | 0 | 0 | 23 |
| 복합/폼 | 54 | 0 | 0 | 0 | 54 |
| 시스템/유틸 | 52 | 0 | 0 | 0 | 52 |

## 등록된 웹 팝업

| 팝업 id | 상태 | 제목 | 컴포넌트 | 조회 API | 대응 PB 창 | 비고 |
|---|---|---|---|---|---|---|
| `part-search` | 연결가능 | 품목검색 | `@/components/shared/PartSearchModal` | `/master/parts` | `w_des_item_popup`<br>`w_des_set_item_popup` | PB 는 품목/세트품목 팝업이 분리돼 있으나 웹은 itemType 필터로 합쳤다. |
| `model-search` | 연결가능 | 모델검색 | `@/components/shared/ModelSearchModal` | `/master/product-models` | `w_des_model_master_popup` |  |
| `equip-search` | 연결가능 | 설비검색 | `@/components/shared/EquipSearchModal` | `/equipment/equips` | `w_mcn_master_popup` | PB dataobject 는 d_mcn_machine_popup. |
| `line-select` | 연결가능 | 라인선택 | `@/components/common/LineSelectModal` | `/api/display/lines` | `w_plan_line_workstage_popup` | display 계열 Next API Route 를 쓴다. 업무화면에서 재사용할 때 엔드포인트 확인 필요. |
| `supplier-search` | 연결가능 | 공급처검색 | 엔진(SearchSelectModal) | `/popup-search/supplier-search` | `w_com_supplier_popup` | PB d_com_supplier_popup — ARG_SUPPLIER_CODE(앞자리 LIKE) / ARG_SUPPLIER_NAME(부분 LIKE), SUPPLIER_CODE <> '*' 제외 조건 포함. 금형 공급처 팝업은 업종 조건이 달라 별도 엔트리다. |
| `customer-search` | 연결가능 | 고객검색 | 엔진(SearchSelectModal) | `/popup-search/customer-search` | `w_com_customer_popup` | PB d_com_customer_popup — 정렬도 PB 와 같다(BUSINESS_TYPE, CUSTOMER_CODE). CUSTOMER_CODE <> '*' 제외 조건과 NVL(SALE_CHARGE,'*') 비교를 그대로 옮겼다. |
| `mold-supplier-search` | 연결가능 | 금형 공급처검색 | 엔진(SearchSelectModal) | `/popup-search/mold-supplier-search` | `w_com_mold_supplier_popup` | PB d_com_mold_supplier_popup — 공급처 팝업과 필터는 같지만 BUSINESS_CATEGORY = 'M' 조건이 더 있다. 그래서 공급처검색과 합치지 않았다. 은성 DB 는 현재 모든 공급처의 BUSINESS_CATEGORY 가 NULL 이라 결과가 0건이다. |

## 미착수 PB 팝업 (호출 많은 순)

`시스템/유틸` 은 PB 런타임 전용(progress, 대기, 인쇄)이라 웹 이관 대상이 아닙니다.

| 호출수 | PB 창 | 분류 | 반환 방식 | 반환 컬럼 | 참조 테이블 |
|---:|---|---|---|---|---|
| 15 | `w_mat_item_popup` | 검색선택형 | 전역구조체 | item_code, item_name, item_spec, supplier_code, supplier_name, line_type, item_uom, item_type | ICOM_SUPPLIER, ID_ITEM, IM_ITEM_MASTER |
| 15 | `w_mcn_mold_popup` | 검색선택형 | CloseWithReturn | mold_code | ICOM_SUPPLIER, IMCN_MOLD, IMCN_MOLD_INVENTORY |
| 12 | `w_des_bom_query_popup` | 조회전용 |  |  | ID_ENG_BOM_TEMP |
| 12 | `w_plan_run_no_status_popup` | 조회전용 |  |  | IP_PRODUCT_RUN_CARD_IO |
| 10 | `w_edit_window` | 복합/폼 | CloseWithReturn |  |  |
| 7 | `w_user_popup` | 검색선택형 | CloseWithReturn | user_id | ISYS_DEPARTMENT, ISYS_USERS |
| 5 | `w_bad_reason_select_popup` | 복합/폼 | 전역구조체 | code_name, code_mean | ISYS_CODE_MASTER |
| 4 | `w_mat_unit_price_popup` | 검색선택형 | CloseWithReturn | unit_price | ICOM_SUPPLIER, ID_ITEM, IM_ITEM_MASTER, IM_ITEM_UNIT_PRICE |
| 4 | `w_qc_inspect_4_gmes_popup` | 검색선택형 | CloseWithReturn |  | IQ_PID_TRACKING_GMES |
| 4 | `w_sal_sale_price_popup` | 검색선택형 | CloseWithReturn | product_sale_price, customer_code, product_line_type, item_name, item_spec, item_uom |  |
| 4 | `w_set_filter` | 복합/폼 |  |  | ISYS_DATA_FILTER |
| 3 | `w_mat_item_barcode_inventory_popup` | 복합/폼 | 전역구조체 |  | ID_ITEM, IM_ITEM_ISSUE, IM_ITEM_RECEIPT, IM_ITEM_RECEIPT_BARCODE |
| 3 | `w_mat_item_inventory_popup` | 검색선택형 | CloseWithReturn | item_code, item_name, item_spec, supplier_code, supplier_name, line_type, item_uom, item_type | IM_ITEM_INVENTORY |
| 3 | `w_mat_new_item_set_msl_location_popup` | 검색선택형 | CloseWithReturn |  | ID_ITEM |
| 3 | `w_mcn_jig_popup` | 검색선택형 | CloseWithReturn | jig_code | IMCN_JIG |
| 3 | `w_pln_smd_plan_popup` | 검색선택형 | CloseWithReturn | item_code, parent_item_code, model_name, work_order_no, pcb_item, master_model_name, mfs_group_no, shift_code, line_code, production_type | IP_PRODUCT_RUN_CARD, IP_PRODUCT_SMD_PLAN |
| 2 | `w_calendar_popup` | 복합/폼 |  |  |  |
| 2 | `w_clipboard` | 조회전용 |  |  |  |
| 2 | `w_com_inbox_form_popup` | 검색선택형 | CloseWithReturn |  | ISYS_LABEL_FORM |
| 2 | `w_com_label_file_write_popup` | 검색선택형 | 전역구조체 |  | IP_PRODUCT_2D_BARCODE, IP_PRODUCT_RUN_CARD |
| 2 | `w_department_popup` | 검색선택형 | CloseWithReturn | department_code | ISYS_DEPARTMENT |
| 2 | `w_dual_language_popup` | 조회전용 |  |  | ISYS_DUAL_LANGUAGE |
| 2 | `w_dynamic_where_condition_popup` | 복합/폼 |  |  | ISYS_REPORT_WHERE_CONDITION |
| 2 | `w_mat_supplier_by_item_code_popup` | 검색선택형 | CloseWithReturn | supplier_code | ICOM_SUPPLIER, ID_ITEM, IM_ITEM_MASTER, IM_ITEM_UNIT_PRICE |
| 2 | `w_mat_workorder_not_issued_popup` | 조회전용 |  |  | IM_ITEM_WORK_ORDER |
| 2 | `w_plan_master_popup` | 복합/폼 | 전역구조체 | mfs, item_code, item_name, item_spec, item_uom |  |
| 2 | `w_pln_product_model_master` | 복합/폼 |  |  | IB_SMT_SW, IP_PRODUCT_MODEL_MASTER, IP_PRODUCT_SPEC_CONFIRM_DOC |
| 2 | `w_pln_serial_info_popup` | 검색선택형 | CloseWithReturn | serial_no | IP_PRODUCT_2D_BARCODE |
| 2 | `w_qc_repair_item_popup` | 검색선택형 | 전역구조체 |  | IP_PRODUCT_WORK_QC_REPAIR_ITEM |
| 2 | `w_qc_repair_receipt_excel_form_popup` | 복합/폼 |  |  | IP_PRODUCT_WORK_QC_EXCEL |
| 2 | `w_smt_plan_feeder_monitoring_popup` | 조회전용 |  |  | IB_PRODUCT_PLANDATA, IM_ITEM_INVENTORY, IM_ITEM_RECEIPT_BARCODE |
| 2 | `w_user_4_bring_in_out_confirm_popup` | 검색선택형 | CloseWithReturn | user_id | ISYS_DEPARTMENT, ISYS_USERS |
| 2 | `w_window_popup` | 검색선택형 | CloseWithReturn | window_name | ISYS_WINDOW |
| 1 | `w_basecode_select_popup` | 검색선택형 | CloseWithReturn | code_name | ISYS_BASECODE |
| 1 | `w_com_bartneder_fg_receipt_form_popup` | 복합/폼 | CloseWithReturn |  |  |
| 1 | `w_com_bartneder_form_popup` | 복합/폼 | CloseWithReturn |  |  |
| 1 | `w_company_calendar_popup` | 복합/폼 |  |  |  |
| 1 | `w_datawindow_source_popup` | 검색선택형 | CloseWithReturn |  | ISYS_REPORT_SOURCE |
| 1 | `w_des_bom_copy_popup` | 복합/폼 |  |  |  |
| 1 | `w_des_bom_excel_form_eunsung_popup` | 복합/폼 |  |  | ID_ENG_BOM_EXCEL_ES |
| 1 | `w_des_bom_excel_form_lg_4_compare_popup` | 복합/폼 |  |  | ID_ENG_BOM_EXCEL_LG_CPR1, ID_ENG_BOM_EXCEL_LG_CPR2 |
| 1 | `w_des_bom_excel_form_lg_popup` | 복합/폼 |  |  | ID_ENG_BOM_EXCEL_LG, ID_ITEM, ID_MFS_BOM |
| 1 | `w_des_bom_form_popup` | 검색선택형 | 전역구조체 |  | ID_ENG_BOM |
| 1 | `w_des_bom_line_copy_popup` | 복합/폼 |  |  |  |
| 1 | `w_des_bom_replace_item_excel_form_popup` | 복합/폼 |  |  | ID_ITEM_REPLACE |
| 1 | `w_des_bom_replace_select_popup` | 검색선택형 | CloseWithReturn | child_item_code | ID_ENG_BOM_TEMP |
| 1 | `w_des_material_item_popup` | 검색선택형 | CloseWithReturn | item_code | ID_ITEM |
| 1 | `w_des_mfs_bom_copy_popup` | 검색선택형 | 전역구조체 |  |  |
| 1 | `w_des_model_select_from_master_plan_pop` | 조회전용 |  |  |  |
| 1 | `w_des_model_select_from_sale_plan_pop` | 조회전용 |  |  | IP_PRODUCT_DELIVERY_PLAN |
| 1 | `w_des_set_item_select_popup` | 조회전용 |  |  | ID_ITEM |
| 1 | `w_function_select_popup` | 검색선택형 | CloseWithReturn | object_name | USER_OBJECTS, USER_SOURCE |
| 1 | `w_graph_properties_popup` | 복합/폼 |  |  |  |
| 1 | `w_graph_spacing` | 복합/폼 |  |  |  |
| 1 | `w_graph_title` | 복합/폼 |  |  |  |
| 1 | `w_iq_interlock_reult_load_popup` | 검색선택형 | 전역구조체 |  | IQ_INTERLOCK_CHECK_RESULT |
| 1 | `w_item_search_flat` | 검색선택형 | CloseWithReturn |  | ID_ITEM |
| 1 | `w_location_barcode_popup` | 검색선택형 | CloseWithReturn | location_code | IB_MACHINE_LOCATION |
| 1 | `w_logon` | 조회전용 |  |  | ISYS_USERS |
| 1 | `w_mat_free_item_inventory_popup` | 검색선택형 | CloseWithReturn | item_code, item_name, item_spec, supplier_code, supplier_name, line_type, item_uom, item_type | ID_ITEM, IM_ITEM_FREE_INVENTORY |
| 1 | `w_mat_free_subcontract_invoice_no_popup` | 검색선택형 | CloseWithReturn |  |  |
| 1 | `w_mat_item_barcode_checkhist_4_feeder_popup` | 복합/폼 | 전역구조체 |  | IB_SMT_CHECKHIST, IM_ITEM_ISSUE, IM_ITEM_RECEIPT |
| 1 | `w_mat_item_barcode_inventory_4_feeder_popup` | 복합/폼 | 전역구조체 |  | ID_ITEM, IM_ITEM_ISSUE, IM_ITEM_RECEIPT, IM_ITEM_RECEIPT_BARCODE |
| 1 | `w_mat_item_check_popup` | 복합/폼 | 전역구조체 |  | ICOM_SUPPLIER, ID_ITEM, IM_ITEM_MASTER, IM_ITEM_UNIT_PRICE |
| 1 | `w_mat_item_departure_excel_form_popup` | 복합/폼 | 전역구조체 |  | ICOM_SUPPLIER, IM_ITEM_ARRIVAL |
| 1 | `w_mat_item_purchase_excel_form_popup` | 복합/폼 | 전역구조체 |  | ICOM_SUPPLIER, ID_ITEM, IM_ITEM_PURCHASE_ORDER |
| 1 | `w_mat_item_purchase_order_popup` | 검색선택형 | 전역구조체 | item_code, item_name, item_spec, supplier_code, supplier_name, line_type, item_uom, item_type | IM_ITEM_PURCHASE_ORDER |
| 1 | `w_mat_item_safety_inventory_popup` | 검색선택형 | CloseWithReturn | item_code, item_name, item_spec, supplier_code, supplier_name, line_type, item_uom, item_type | IM_ITEM_INVENTORY |
| 1 | `w_mat_item_vendor_popup` | 검색선택형 | CloseWithReturn | vendor_code1 | ID_ITEM |
| 1 | `w_mat_item_workstage_inventory_4_feeder_popup` | 검색선택형 | 전역구조체 |  | IM_ITEM_RECEIPT_BARCODE |
| 1 | `w_mat_item_workstage_inventory_popup` | 검색선택형 | 전역구조체 | item_code, item_name, item_spec, line_type, item_uom | ID_ITEM, IM_ITEM_WORKSTAGE_INVENTORY |
| 1 | `w_mat_material_issue_excel_form_popup` | 복합/폼 |  |  | ID_ITEM, IM_ITEM_ISSUE |
| 1 | `w_mat_material_receipt_excel_form_popup` | 복합/폼 | 전역구조체 |  | IM_ITEM_RECEIPT |
| 1 | `w_mat_material_unit_price_excel_form_popup` | 복합/폼 | 전역구조체 |  | IM_ITEM_UNIT_PRICE |
| 1 | `w_mat_receipt_slip_excel_import_popup` | 검색선택형 | 전역구조체 |  | IM_ITEM_RECEIPT_SLIP_EXCEL |
| 1 | `w_mat_slip_manual_qty_popup` | 검색선택형 | 전역구조체 |  |  |
| 1 | `w_mat_slip_manual_qty_popup_onetek_solder` | 검색선택형 | 전역구조체 |  |  |
| 1 | `w_mat_unit_price_4_free_purchase_order_popup` | 검색선택형 | 전역구조체 |  | ICOM_SUPPLIER, ID_ITEM, IM_ITEM_MASTER, IM_ITEM_UNIT_PRICE |
| 1 | `w_mat_unit_price_4_purchase_order_popup` | 검색선택형 | 전역구조체 |  | ICOM_SUPPLIER, ID_ITEM, IM_ITEM_MASTER, IM_ITEM_UNIT_PRICE |
| 1 | `w_mat_work_price_popup` | 검색선택형 | CloseWithReturn | unit_price | IM_ITEM_UNIT_PRICE |
| 1 | `w_mat_ws_inventory_close_excel_import_popup` | 검색선택형 | 전역구조체 |  | IM_ITEM_WS_INVE_CHECK_EXCEL |
| 1 | `w_mcn_jig_sample_query_popup` | 복합/폼 |  |  | IMCN_JIG_APPLY_MODEL, IMCN_SAMPLE_APPLY_MODEL |
| 1 | `w_mcn_mold_location_popup` | 검색선택형 | CloseWithReturn | mold_location_code | IMCN_MOLD_LOCATION |
| 1 | `w_plan_routing_popup` | 검색선택형 | CloseWithReturn | route_no |  |
| 1 | `w_pln_2d_baarcode_excel_popup` | 검색선택형 | 전역구조체 |  | IP_PRODUCT_2D_BARCODE_EXCEL |
| 1 | `w_pln_nsnp_history_popup` | 검색선택형 | 전역구조체 |  | IQ_MACHINE_INSPECT_NSNP |
| 1 | `w_pln_run_card_popup` | 검색선택형 | CloseWithReturn | run_no | IP_PRODUCT_RUN_CARD |
| 1 | `w_pln_run_no_popup` | 검색선택형 | CloseWithReturn | run_no | IP_PRODUCT_RUN_CARD |
| 1 | `w_pln_smd_plan_append_popup` | 검색선택형 | 전역구조체 |  | IP_PRODUCT_MODEL_MASTER |
| 1 | `w_pln_softwere_excel_load_popup` | 검색선택형 | 전역구조체 |  | IP_PRODUCT_SOFTWARE_EXCEL |
| 1 | `w_prd_fg_magazine_divide` | 복합/폼 | 전역구조체 |  | IP_PRODUCT_FG_INVENTORY, IP_PRODUCT_PACK_MASTER, IP_PRODUCT_PACK_SERIAL |
| 1 | `w_profile_edit_window` | 복합/폼 | CloseWithReturn |  |  |
| 1 | `w_qc_4m_popup` | 복합/폼 | CloseWithReturn |  | IP_PRODUCT_MODEL_MASTER, IQ_4M_MASTER |
| 1 | `w_qc_aoi_review_r_tf_popup` | 검색선택형 | 전역구조체 |  | IQ_MACHINE_INSPECT_AOI_R_TF |
| 1 | `w_qc_wqc_inspect_outside_request_popup` | 검색선택형 | 전역구조체 |  | ID_ITEM, IQ_PRODUCT_WQC |
| 1 | `w_quick_filter` | 복합/폼 |  |  |  |
| 1 | `w_report_menu_insert_popup` | 검색선택형 | 전역구조체 |  | ISYS_REPORT_MENU |
| 1 | `w_report_where_condition_popup` | 조회전용 |  |  | ISYS_REPORT_SOURCE_WHERE |
| 1 | `w_role_popup` | 검색선택형 | CloseWithReturn | role_code | ISYS_ROLE |
| 1 | `w_sal_sale_price_excel_from_popup` | 복합/폼 | 전역구조체 |  | ICOM_CUSTOMER, ID_ITEM, IS_PRODUCT_SALE_PRICE |
| 1 | `w_sequence_select_popup` | 검색선택형 | CloseWithReturn | sequence_name | USER_SEQUENCES |
| 1 | `w_show_datawindow_popup` | 조회전용 |  |  |  |
| 1 | `w_smt_bom_excel_load_popup` | 복합/폼 | 전역구조체 |  | ID_ENG_BOM_EXCEL_2, ID_ENG_BOM_EXCEL_3, ID_ENG_BOM_TEMP |
| 1 | `w_sql_painter` | 조회전용 |  |  |  |
| 1 | `w_user_role_group_popup` | 복합/폼 |  |  | ISYS_DEPARTMENT, ISYS_ROLE, ISYS_USERS |
| 1 | `w_value_list_popup` | 조회전용 |  |  | ISYS_BASECODE |
| 1 | `w_wallpaper` | 복합/폼 | 전역구조체 |  | ISYS_MENU, ISYS_MONITOR, ISYS_PUB_WORK_BOARD, ISYS_USERS |
| 0 | `w_bad_reason_select_4_iqc_popup` | 검색선택형 | 전역구조체 | code_name | ISYS_CODE_MASTER |
| 0 | `w_col_info_popup` | 조회전용 |  |  | ISYS_WINDOW_PROPERTY |
| 0 | `w_default_value_popup` | 조회전용 |  |  | ISYS_DEFAULT_VALUE |
| 0 | `w_des_assembly_item_popup` | 검색선택형 | CloseWithReturn | item_code |  |
| 0 | `w_des_bom_copy_with_shaft_popup` | 복합/폼 |  |  |  |
| 0 | `w_des_bom_excel_form_default_popup` | 복합/폼 |  |  | ID_ENG_BOM_EXCEL_LG |
| 0 | `w_des_bom_excel_form_lg_4_item_popup` | 복합/폼 |  |  | ID_ENG_BOM_EXCEL_LG |
| 0 | `w_des_bom_excel_load_popup` | 검색선택형 | 전역구조체 |  | ID_ENG_BOM_EXCEL_2 |
| 0 | `w_des_bom_merge_popup` | 복합/폼 |  |  |  |
| 0 | `w_des_item_4_all_org_popup` | 검색선택형 | CloseWithReturn | item_code |  |
| 0 | `w_des_item_excel_form_popup` | 복합/폼 |  |  | ID_ITEM |
| 0 | `w_des_parent_item_from_bom_popup` | 검색선택형 | CloseWithReturn | parent_item_code |  |
| 0 | `w_des_work_no_popup` | 검색선택형 | CloseWithReturn | bom_work_no | ID_ENG_BOM_WORKSPACE |
| 0 | `w_drawing_batch_popup` | 복합/폼 | 전역구조체 |  |  |
| 0 | `w_dynamic_graph_popup` | 복합/폼 |  |  |  |
| 0 | `w_find_popup` | 복합/폼 |  |  |  |
| 0 | `w_mat_arrival_invoice_popup` | 조회전용 |  |  | IM_ITEM_ARRIVAL |
| 0 | `w_mat_goods_price_4_purchase_order_popup` | 검색선택형 | 전역구조체 |  | ICOM_SUPPLIER, ID_ITEM, IM_ITEM_MASTER, IS_PRODUCT_BUY_PRICE |
| 0 | `w_mat_inventory_4_lv_analysis_popup` | 검색선택형 | 전역구조체 |  |  |
| 0 | `w_mat_inventory_close_excel_import_popup` | 검색선택형 | 전역구조체 |  | IM_ITEM_INVENTORY_CHECK_EXCEL |
| 0 | `w_mat_item_4_inspect_rule_popup` | 검색선택형 | 전역구조체 | item_code, item_name, item_spec, supplier_code, supplier_name, line_type, item_uom, item_type | ICOM_SUPPLIER, ID_ITEM, IM_ITEM_MASTER |
| 0 | `w_mat_item_barcode_inventory_detail_popup` | 복합/폼 | 전역구조체 |  | IB_SMT_CHECKHIST, ID_ITEM, IM_ITEM_ISSUE, IM_ITEM_RECEIPT |
| 0 | `w_mat_item_receipt_4_distribute_popup` | 검색선택형 | CloseWithReturn |  | ID_ITEM, IM_ITEM_RECEIPT |
| 0 | `w_mat_item_receipt_popup` | 검색선택형 | CloseWithReturn | material_mfs, item_name, item_spec, supplier_code, line_type, item_type, invoice_no, receipt_lot_no, location_code | ID_ITEM, IM_ITEM_RECEIPT |
| 0 | `w_mat_item_set_msl_location_popup` | 검색선택형 | 전역구조체 |  |  |
| 0 | `w_mat_keyitem_popup` | 검색선택형 | CloseWithReturn |  | IF_KEYT_KEYITEM |
| 0 | `w_mat_reel_divide_qty_popup` | 검색선택형 | 전역구조체 |  |  |
| 0 | `w_mat_sale_price_popup` | 검색선택형 | CloseWithReturn | unit_price | IM_ITEM_SALE_PRICE |
| 0 | `w_mat_smt_checkhist_popup` | 검색선택형 | CloseWithReturn | item_code, item_name, item_spec, supplier_code, supplier_name, line_type, item_uom, item_type | IB_SMT_CHECKHIST |
| 0 | `w_mat_unit_price_4_goods_popup` | 검색선택형 | CloseWithReturn | unit_price |  |
| 0 | `w_mcn_jig_pm_result_popup` | 검색선택형 | 전역구조체 |  | IMCN_WEEKLY_PM_RESULT |
| 0 | `w_mrm_excel_form_popup` | 복합/폼 |  |  |  |
| 0 | `w_pln_assembly_plan_popup` | 검색선택형 | CloseWithReturn | item_code, parent_item_code, model_name, customer_order_no | IP_PRODUCT_RUN_CARD, IP_PRODUCT_SMD_PLAN |
| 0 | `w_pln_master_plan_popup` | 검색선택형 | CloseWithReturn | lot_qty |  |
| 0 | `w_privilege_warning_popup` | 조회전용 |  |  | ISYS_PRIVILEGE |
| 0 | `w_qc_bad_reason_popup` | 검색선택형 | CloseWithReturn | product_sale_price, customer_code, product_line_type |  |
| 0 | `w_qc_ifts_ng_popup` | 검색선택형 | 전역구조체 |  | IQ_MACHINE_INSPECT_DATA_IFTS |
| 0 | `w_report_source_manage_popup` | 복합/폼 | 전역구조체 |  | ISYS_REPORT_SOURCE, ISYS_REPORT_SOURCE_WHERE |
| 0 | `w_report_window_where_condition_popup` | 조회전용 |  |  |  |
| 0 | `w_sal_mobile_plan_4_assembly_plan_popup` | 조회전용 |  |  |  |
| 0 | `w_sal_mobile_plan_4_master_plan_popup` | 조회전용 |  |  |  |
| 0 | `w_sal_palette_popup` | 검색선택형 | 전역구조체 |  | ISAL_SHIPPING_LOT_DETAIL, ISAL_SHIPPING_LOT_MASTER |
| 0 | `w_sal_sale_plan_4_master_plan_popup` | 검색선택형 | 전역구조체 |  | IS_PRODUCT_SALE_PLAN |
| 0 | `w_sal_sale_plan_4_mobile_plan_popup` | 검색선택형 | 전역구조체 |  | IS_PRODUCT_SALE_PLAN |
| 0 | `w_sal_sale_price_4_sale_plan_popup` | 검색선택형 | 전역구조체 |  |  |
| 0 | `w_sal_shipping_lot_master_popup` | 복합/폼 | 전역구조체 |  | ISAL_SHIPPING_LOT_DETAIL, ISAL_SHIPPING_LOT_MASTER |
| 0 | `w_sal_work_cost_popup` | 검색선택형 | 전역구조체 | product_work_cost |  |
| 0 | `w_send_mail_popup` | 조회전용 |  |  | ISYS_DEPARTMENT, ISYS_USERS |
| 0 | `w_smt_bom_replace_popup` | 복합/폼 |  |  | ID_ITEM_REPLACE, IP_PRODUCT_MODEL_MASTER |
| 0 | `w_smt_plan_feeder_compare_popup` | 복합/폼 |  |  | IB_PRODUCT_PLANDATA, IM_ITEM_RECEIPT_BARCODE |
| 0 | `w_smt_plan_feeder_list_popup` | 조회전용 |  |  | ID_ENG_BOM_SMT |
| 0 | `w_smt_plan_feeder_running_status_popup` | 복합/폼 |  |  | IB_PRODUCT_PLANDATA, IB_SMT_FEEDER_SHAFT, IM_ITEM_RECEIPT_BARCODE |
| 0 | `w_standard_code_select_popup` | 검색선택형 | CloseWithReturn | code_name | ISYS_CODE_MASTER |
| 0 | `w_table_select_4_where_condition_popup` | 복합/폼 | CloseWithReturn |  | TAB, USER_TAB_COLUMNS |
