---
sources:
  - apps/frontend/scripts/data/pb-function-catalog.json
  - docs/database/generated/pb-function-inventory.json
generator: apps/frontend/scripts/gen-function-status.mjs
verifiedCommit: 6e426a7
---

# PB 함수 처리 현황 (자동 생성)

> **직접 수정하지 마세요.** 함수를 전환하거나 치환하면
> `apps/frontend/scripts/data/pb-function-catalog.json` 에 엔트리를 추가하세요.
> 재생성: `pnpm --filter @eunsung/frontend gen:function-status`

**판별은 이름이 아니라 호출 위치입니다.** PB 함수는 SQL 문장 안에서 호출할 수 없으므로,
SQL 안에서 불린 `f_*` 는 Oracle DB 함수이고 PowerScript 에서 불린 것은 PB 전역함수입니다.
DB 함수는 웹에서도 **그대로 호출**합니다 — 재구현하면 PB 와 번호·판정이 갈립니다.

## 현황

| 구분 | 건수 |
|---|---:|
| PB 창(실측) | 547 |
| SQL 안 호출 = DB 함수 (조치 불필요) | 65 |
| SQL 밖 호출 = PB 함수 | 219 |
| 카탈로그 등록(처리 완료) | 22 |
| 미처리 전환 후보 | 57 |

## 처리 완료 (카탈로그)

### DB 패키지 전환 (`converted`) — 5건

| PB 함수 | 대상 | 비고 |
|---|---|---|
| `f_mat_receipt_cancel` | `PKG_MES_MAT.SP_RECEIPT_CANCEL` | 입고 1건 상계(역분개). PB 반환규약 유지(-1/-3), -2(이미취소)는 웹에서 추가. |
| `f_check_unit_price_dup` | `PKG_MES_MAT.F_CHECK_UNIT_PRICE_DUP` | 유효기간 겹치는 구매단가 중복 검사. 중복 없으면 0, 다중 조합이면 -1. |
| `f_get_marking_yn` | `PKG_MES_PLN.F_GET_MARKING_YN` | 모델 마킹 사용여부. 조회 실패 시 'N'. |
| `f_get_carrier_size` | `PKG_MES_PLN.F_GET_CARRIER_SIZE` | 모델 캐리어 규격. 모델 없으면 -1, 값 없으면 0. |
| `f_get_magazine_lot_qty` | `PKG_MES_PLN.F_GET_MAGAZINE_LOT_QTY` | 매거진 라벨 LOT 수량. 라벨 없으면 0. |

### 웹 수단으로 치환 (`replaced`) — 8건

| PB 함수 | 대상 | 비고 |
|---|---|---|
| `f_msgbox` | `react-hot-toast / @/components/ui ConfirmModal` | 메시지 표시용. alert()/confirm() 금지. 확인이 필요하면 ConfirmModal. |
| `f_msgbox1` | `react-hot-toast / ConfirmModal` | f_msgbox 와 동일 처리. |
| `f_msg` | `react-hot-toast` | 메시지 표시용. |
| `f_msg_st` | `react-hot-toast` | 상태줄 메시지. |
| `f_msg_mdi_help` | `화면 내 안내 문구` | MDI MicroHelp. 웹에는 상태줄이 없다. |
| `f_sql_check` | `NestJS 예외 + 트랜잭션 롤백` | f_sql_check_with_msg 도 동일. |
| `f_set_security_row` | `백엔드 저장 시 감사컬럼 자동 기록` | 권한 가드가 아니다. ARG_TYPE 에 따라 ORGANIZATION_ID / ENTER_BY / ENTER_DATE / LAST_MODIFY_BY / LAST_MODIFY_DATE 를 로그인 사용자·서버시각으로 채우는 함수다. ALL=전체, MODIFY=수정컬럼만, NONORG=조직ID 제외. 웹은 서비스의 INSERT/UPDATE 에서 organizationId·userId·SYSDATE 로 같은 컬럼을 채운다. |
| `f_object_role_check` | `권한 가드` | USER_LEVEL 검사 후 메시지박스. 웹은 가드가 403 을 낸다. |

### 제거 (`dropped`) — 4건

| PB 함수 | 대상 | 비고 |
|---|---|---|
| `f_play_sound` | — | 제거한다. 경고가 필요한 화면만 시각 배너로 대체. |
| `f_retrieve` | — | MDI 활성 시트 조회 트리거. 웹에는 대응물이 없다. |
| `f_menu_control` | — | MDI 프레임 메뉴 활성화 제어. 웹 메뉴 권한이 대신한다. |
| `f_jssetprofilestring` | — | INI 파일 I/O. 설정은 DB(ISYS_CONFIG)·환경변수로 간다. |

### 서비스에 이식 (`inlined`) — 1건

| PB 함수 | 대상 | 비고 |
|---|---|---|
| `f_get_first_day` | `receipt-cancel.service.ts firstDayOfMonth()` | 한 화면 전용 날짜 계산이라 DB 오브젝트를 늘리지 않는다. |

### 웹에서 직접 (`native`) — 3건

| PB 함수 | 대상 | 비고 |
|---|---|---|
| `f_t_sysdate` | `백엔드 서버 시각 (main.ts KST 고정)` | f_sysdate 도 동일. 본문이 SELECT SYSDATE FROM DUAL 뿐이라 전환 무의미. |
| `f_sysdate` | `백엔드 서버 시각` | f_t_sysdate 와 동일. |
| `f_get_sequence` | `시퀀스 직접 호출 (예: SEQ_MAT_RECEIPT.NEXTVAL)` | 동적 SQL 로 임의 시퀀스를 부르던 래퍼. 웹은 대상 시퀀스를 직접 쓴다 (예: SEQ_MAT_RECEIPT.NEXTVAL, SEQ_JIG_CHECK_SEQUENCE.NEXTVAL). |

### 전환 보류 (`blocked`) — 1건

| PB 함수 | 대상 | 비고 |
|---|---|---|
| `f_get_dynamic_report_name` | — | 전환 보류 — 참조 컬럼 QR_PID_DW_NAME / PACKING_LABEL_DW_NAME 이 이 DB 의 IP_PRODUCT_MODEL_MASTER 에 없다. |

## 미처리 전환 후보

본문이 SQL + 분기뿐이라 DB 패키지로 옮길 수 있는 것들입니다.
화면을 이관할 때 그 화면이 부르는 것부터 처리하세요.

| PB 함수 | 호출 | 창 수 | 대표 창 |
|---|---:|---:|---|
| `f_check_item_exists` | 60 | 33 | w_mat_baking_dehumi_scan_master, w_mat_baking_dehumi_scan_query |
| `f_set_layered_window` | 14 | 14 | w_bad_reason_select_popup, w_com_message_popup_lg |
| `f_replace_string` | 143 | 10 | w_default_value_popup, w_main_root |
| `f_get_line_type_from_item` | 13 | 9 | w_des_bom_modify_master, w_mat_other_issue_barcode_master |
| `f_get_tariff_rate` | 7 | 7 | w_mat_departure_4_goods_master, w_mat_departure_master |
| `f_play_mp3` | 23 | 6 | w_pln_product_magazine_label_split_master, w_prd_product_fg_4_model_issue |
| `f_get_token` | 15 | 5 | w_dynamic_graph_popup, w_dynamic_where_condition_popup |
| `f_check_slip_exists` | 6 | 5 | w_mat_other_receipt_rental_borrowing_barcode_master, w_mat_receipt_slip_4_rental_borrowing_master |
| `f_check_supplier_exists` | 5 | 5 | w_mat_material_receipt_excel_form_popup, w_mat_material_unit_price_excel_form_popup |
| `f_get_line_code_by_item` | 8 | 4 | w_mat_inventory_close_excel_import_popup, w_mat_receipt_slip_excel_import_popup |
| `f_get_order_dc_rate` | 5 | 4 | w_mat_item_departure_excel_form_popup, w_mat_item_purchase_excel_form_popup |
| `f_dual_lang_object_count` | 4 | 4 | w_col_info_popup, w_replace_popup |
| `f_get_constraints_table_name` | 21 | 3 | w_graph_root, w_main_root |
| `f_get_purchase_order_qty` | 9 | 3 | w_mat_forecast_order_master, w_mat_purchase_order_4_subcontract_master |
| `f_get_data_window_source` | 5 | 3 | w_report_generator, w_report_master |
| `f_get_mat_inspect_rule` | 4 | 3 | w_mat_departure_4_goods_master, w_mat_departure_master |
| `f_get_item_type_from_item` | 3 | 3 | w_des_bom_modify_master, w_mat_request_issue_master |
| `f_get_item_auto_issue_yn` | 3 | 3 | w_mat_material_receipt_excel_form_popup, w_mat_material_unit_price_excel_form_popup |
| `f_check_mold_exists` | 3 | 3 | w_mcn_mold_buy_price_master, w_mcn_mold_issue_master |
| `f_download_item_image` | 2 | 2 | w_item_image_flat, w_machine_image_flat |
| `f_system_access` | 2 | 2 | w_logon, w_main_root |
| `f_get_computer_name` | 2 | 2 | w_main_frame, w_user_change |
| `f_get_computer_login_user_name` | 2 | 2 | w_main_frame, w_user_change |
| `f_mat_issue_return` | 2 | 2 | w_mat_mass_issue_return_master, w_mat_receipt_barcode_reprint_master |
| `f_mat_receipt_return` | 2 | 2 | w_mat_other_receipt_barcode_return_master, w_mat_receipt_return_master |
| `f_get_run_no_by_serial` | 2 | 2 | w_plan_run_no_status_popup, w_product_pid_tracking_fpcb_rpt |
| `f_get_lot_size_by_run_no` | 2 | 2 | w_pln_product_magazine_label_master, w_pln_product_pcb_kitting_scan_master |
| `f_check_run_no` | 2 | 2 | w_pln_product_magazine_label_master, w_pln_product_magazine_label_split_master |
| `f_get_model_name_by_run_no` | 2 | 2 | w_pln_product_pcb_kitting_scan_master, w_product_pid_tracking_fpcb_rpt |
| `f_get_new_scan_qty` | 6 | 1 | w_mat_other_issue_barcode_master |
| `f_get_product_date_by_model` | 4 | 1 | w_qc_4m_master |
| `f_check_return_request_slip_exists` | 2 | 1 | w_mat_other_receipt_rental_borrowing_barcode_master |
| `f_get_order_property` | 2 | 1 | w_mat_purchase_order_plan_master |
| `f_call_db_sql` | 1 | 1 | w_default_value_popup |
| `f_download_item_eco_image` | 1 | 1 | w_item_eco_notify_image_popup |
| `f_check_is_admin_yn` | 1 | 1 | w_lock_by_admin |
| `f_password_decode` | 1 | 1 | w_logon |
| `f_get_department_name` | 1 | 1 | w_logon |
| `f_get_sale_exchange_rate` | 1 | 1 | w_mat_item_departure_excel_form_popup |
| `f_wqc_complete_cancel` | 1 | 1 | w_mat_mass_issue_cancel_master |
| `f_mat_issue_change_location` | 1 | 1 | w_mat_mass_issue_cancel_master |
| `f_mat_issue_return_confirm` | 1 | 1 | w_mat_mass_issue_return_confirm_master |
| `f_mat_issue_return_request` | 1 | 1 | w_mat_mass_issue_return_request_master |
| `f_mat_issue_return_request_cancel` | 1 | 1 | w_mat_mass_issue_return_request_master |
| `f_mat_receipt_auto_issue` | 1 | 1 | w_mat_other_receipt_master |
| `f_get_to_supplier_by_invoice` | 1 | 1 | w_mat_other_receipt_rental_borrowing_barcode_master |
| `f_mat_receipt_return_auto_order` | 1 | 1 | w_mat_receipt_return_master |
| `f_mat_issue_4_lot_divide_cancel` | 1 | 1 | w_mat_reel_divide_cancel_popup |
| `f_gen_work_order_to_assy_plan` | 1 | 1 | w_mat_workorder_master |
| `f_mcn_jig_issue_cancel` | 1 | 1 | w_mcn_jig_issue_master |
| `f_mcn_mold_issue_cancel` | 1 | 1 | w_mcn_mold_issue_master |
| `f_mcn_mold_receipt_cancel` | 1 | 1 | w_mcn_mold_receipt_master |
| `f_download_mold_image` | 1 | 1 | w_mold_image_flat |
| `f_get_magazine_size` | 1 | 1 | w_pln_product_magazine_label_master |
| `f_get_item_code_by_model_suffix` | 1 | 1 | w_pln_product_master_plan_master |
| `f_get_ip_address` | 1 | 1 | w_user_change |
| `f_get_code_name` | 1 | 1 | w_window_master |
