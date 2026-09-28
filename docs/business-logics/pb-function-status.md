---
sources:
  - apps/frontend/scripts/data/pb-function-catalog.json
  - docs/database/generated/pb-function-inventory.json
generator: apps/frontend/scripts/gen-function-status.mjs
verifiedCommit: ef8d1baa
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
| PB 창(실측) | 596 |
| SQL 안 호출 = DB 함수 (조치 불필요) | 196 |
| SQL 밖 호출 = PB 함수 | 226 |
| 카탈로그 등록(처리 완료) | 63 |
| 미처리 전환 후보 | 51 |

## 처리 완료 (카탈로그)

### DB 패키지 전환 (`converted`) — 11건

| PB 함수 | 대상 | 비고 |
|---|---|---|
| `f_mat_receipt_cancel` | `PKG_MES_MAT.SP_RECEIPT_CANCEL` | 입고 1건 상계(역분개). PB 반환규약 유지(-1/-3), -2(이미취소)는 웹에서 추가. |
| `f_check_unit_price_dup` | `PKG_MES_MAT.F_CHECK_UNIT_PRICE_DUP` | 유효기간 겹치는 구매단가 중복 검사. 중복 없으면 0, 다중 조합이면 -1. |
| `f_get_marking_yn` | `PKG_MES_PLN.F_GET_MARKING_YN` | 모델 마킹 사용여부. 조회 실패 시 'N'. |
| `f_get_carrier_size` | `PKG_MES_PLN.F_GET_CARRIER_SIZE` | 모델 캐리어 규격. 모델 없으면 -1, 값 없으면 0. |
| `f_get_magazine_lot_qty` | `PKG_MES_PLN.F_GET_MAGAZINE_LOT_QTY` | 매거진 라벨 LOT 수량. 라벨 없으면 0. |
| `f_check_mold_exists` | `PKG_MES_MAC.F_CHECK_MOLD_EXISTS` | S-PARTS 코드 존재 검사. PB 반환규약 유지 — 없으면 -1, 있으면 건수. |
| `f_check_supplier_exists` | `PKG_MES_MAC.F_CHECK_SUPPLIER_EXISTS` | 공급처 코드 존재 검사. 없으면 -1, 있으면 건수. |
| `f_get_mold_unit_price` | `PKG_MES_MAC.F_GET_MOLD_UNIT_PRICE` | 오늘 유효한 S-PARTS 구매단가. 없으면 -2. PB 는 통화를 전역구조체로 같이 넘겼으나 함수는 값이 하나뿐이라 통화는 F_GET_MOLD_UNIT_PRICE_CURR 로 나눴다. |
| `f_get_mold_unit_price_by_confirm` | `PKG_MES_MAC.F_GET_MOLD_UNIT_PRICE(..., 'Y')` | 승인된 단가만 보는 변형. 별도 함수를 만들지 않고 p_confirm_only 인자로 합쳤다. |
| `f_mcn_mold_receipt_cancel` | `PKG_MES_MAC.SP_MOLD_RECEIPT_CANCEL` | S-PARTS 입고 1건 상계(역분개). 항번은 SEQ_MAT_RECEIPT. PB 반환규약 유지(-1/-3), -2(이미취소)는 웹에서 추가. |
| `f_mcn_mold_issue_cancel` | `PKG_MES_MAC.SP_MOLD_ISSUE_CANCEL` | S-PARTS 출고 1건 상계 + 청구를 미처리('R')로 되돌림. 항번은 SEQ_MAT_ISSUE. |

### 웹 수단으로 치환 (`replaced`) — 10건

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
| `f_msg1` | `react-hot-toast` | f_msg 계열과 같다. 메시지 표시용. |
| `f_get_run_no_by_serial` | `IP_PRODUCT_2D_BARCODE 직접 조회` | PID → Run No. PB 스크립트(화면 밖)에서만 불러 PB 전역함수이며 이 DB 에 같은 이름의 함수가 없다(실측). 2D바코드를 등호로 직접 읽어 치환했다. |

### 제거 (`dropped`) — 7건

| PB 함수 | 대상 | 비고 |
|---|---|---|
| `f_play_sound` | — | 제거한다. 경고가 필요한 화면만 시각 배너로 대체. |
| `f_retrieve` | — | MDI 활성 시트 조회 트리거. 웹에는 대응물이 없다. |
| `f_menu_control` | — | MDI 프레임 메뉴 활성화 제어. 웹 메뉴 권한이 대신한다. |
| `f_jssetprofilestring` | — | INI 파일 I/O. 설정은 DB(ISYS_CONFIG)·환경변수로 간다. |
| `f_insert` | — | PB DataWindow InsertRow 래퍼. 웹은 우측 폼 패널이 대신한다. |
| `f_update` | — | PB DataWindow Update 래퍼. 웹은 백엔드 저장 API 가 대신한다. |
| `f_set_column_dddw` | — | PB DataWindow 의 드롭다운 목록을 런타임에 채우는 유틸. 웹은 기초코드 선택 컴포넌트가 대신한다. |

### 서비스에 이식 (`inlined`) — 3건

| PB 함수 | 대상 | 비고 |
|---|---|---|
| `f_get_first_day` | `receipt-cancel.service.ts firstDayOfMonth()` | 한 화면 전용 날짜 계산이라 DB 오브젝트를 늘리지 않는다. |
| `f_replace_string` | `String.prototype.replaceAll (대소문자 무시)` | SQL 없는 순수 문자열 치환. PB 는 소문자·대문자를 번갈아 찾는 방식이라 대소문자 무시 치환과 같다. |
| `f_check_item_exists` | `ID_ITEM 유효기간 조건 (DATESET <= TRUNC(SYSDATE) AND DATEEND >= TRUNC(SYSDATE))` | **DB 동명 함수와 뜻이 다르다.** PB 는 ID_ITEM 품목 유효기간을 보고, DB F_CHECK_ITEM_EXISTS(p_set_item,p_org) 는 ID_CUSTOMER_SET_BOM 세트 BOM 유무를 보며 'EXISTS'/'NOTFOUND' 를 낸다. 인자도 (품목,조직) 이라 PB 가 넘기던 날짜 자리와 맞지 않는다 (실측 ORA-06553 PLS-306). PB 쪽 SQL 을 인라인한다. |

### 웹에서 직접 (`native`) — 22건

| PB 함수 | 대상 | 비고 |
|---|---|---|
| `f_t_sysdate` | `백엔드 서버 시각 (main.ts KST 고정)` | f_sysdate 도 동일. 본문이 SELECT SYSDATE FROM DUAL 뿐이라 전환 무의미. |
| `f_sysdate` | `백엔드 서버 시각` | f_t_sysdate 와 동일. |
| `f_get_sequence` | `시퀀스 직접 호출 (예: SEQ_MAT_RECEIPT.NEXTVAL)` | 동적 SQL 로 임의 시퀀스를 부르던 래퍼. 웹은 대상 시퀀스를 직접 쓴다 (예: SEQ_MAT_RECEIPT.NEXTVAL, SEQ_JIG_CHECK_SEQUENCE.NEXTVAL). |
| `f_get_supplier_name` | `F_GET_SUPPLIER_NAME` | 이미 DB 함수로 존재한다(VALID). PB 가 SQL 밖에서 SELECT ... FROM DUAL 로 감싸 불렀을 뿐이라 전환 대상이 아니다. |
| `f_get_dual_lang_text` | `F_GET_DUAL_LANG_TEXT` | 이미 DB 함수로 존재한다(VALID). 웹은 화면 문구를 i18n 으로 내므로 호출할 일은 없다. |
| `f_get_work_shift_code` | `F_GET_WORK_SHIFT_CODE` | 이미 DB 함수로 존재한다(VALID). PB 가 SQL 밖에서 DUAL 로 감싸 불렀을 뿐이라 전환 대상이 아니다. 업무일·교대 판정은 PB 와 값이 갈리면 안 되므로 반드시 이 함수를 쓴다. |
| `f_bom_query_prc` | `PKG_DESIGN.BOM_QUERY(p_parent_item_code, p_dateset, p_org)` | PB 는 SQLCA.BOM_QUERY 를 감싸기만 했다. 웹은 패키지 함수를 그대로 부른다. 세션번호를 돌려주고 ID_ENG_BOM_TEMP 에 전개행을 깐다 — 읽은 뒤 그 세션 행만 지운다 (이 표는 3,357,661행 / 세션 70,117개가 2020년부터 쌓여 있다). |
| `f_get_listagg_location` | `F_GET_LISTAGG_LOCATION(p_line_code, p_model_name, p_item_code, p_pcb_item)` | SQL 안에서 불리던 DB 함수. 부품이 물린 피더 자리를 한 줄로 모아 준다. 그대로 호출한다. |
| `f_get_mat_max_unit_price_cfm` | `F_GET_MAT_MAX_UNIT_PRICE_CFM(p_item_code, p_line_type, p_date, p_org)` | SQL 안에서 불리던 DB 함수. 확정단가. 그대로 호출한다. |
| `f_get_pcb_item_by_name` | `F_GET_PCB_ITEM_BY_NAME(p_set_item_code)` | SQL 안에서 불리던 DB 함수. SET 품목의 PCB 면 코드. 라벨 바코드에 쓴다. |
| `f_get_run_lot_qty` | `F_GET_RUN_LOT_QTY(p_run_no)` | SQL 안에서 불리던 DB 함수. 작업지시의 LOT 수량. 그대로 호출한다. |
| `f_get_model_product_st` | `F_GET_MODEL_PRODUCT_ST(p_model, p_line, p_pcb_item, p_workstage, p_org)` | 모델 표준시간. SQL 안에서 불린다. 계획 목록에 넣을 때 그대로 호출한다. |
| `f_get_work_breaktime_min` | `F_GET_WORK_BREAKTIME_MIN(p_start, p_end)` | 생산일보 휴게시간(분). 가용시간 = 생산 - 휴게 계산에 쓴다. TypeScript 로 다시 구현하면 일보 숫자가 갈린다. |
| `f_get_work_losstime_min` | `F_GET_WORK_LOSSTIME_MIN(p_line_code, p_start, p_end)` | 생산일보 로스시간(분). 실가동 = 가용 - 로스. |
| `f_get_run_line_actual_qty` | `F_GET_RUN_LINE_ACTUAL_QTY(p_run_no, p_line_code, p_org)` | 생산일보 실적수량. 성능가동률·양품률의 분자·분모다. |
| `f_get_run_ng_qty` | `F_GET_RUN_NG_QTY(p_run_no, p_org)` | 생산일보 불량수량. 불량PPM 과 양품률에 쓴다. |
| `f_get_run_line_pda_on` | `F_GET_RUN_LINE_PDA_ON(p_run_no, p_line_code, p_org)` | 생산 시작시각(PDA ON). 생산시간 계산의 시작점. |
| `f_get_run_line_pda_off` | `F_GET_RUN_LINE_PDA_OFF(p_run_no, p_line_code, p_org)` | 생산 종료시각(PDA OFF). NULL 이면 생산시간 0 으로 본다 (PB DECODE 규약). |
| `f_get_model_name_by_run_no` | `F_GET_MODEL_NAME_BY_RUN_NO` | 이름은 PB 함수처럼 보이지만 같은 이름의 DB 함수가 실제로 있다(VALID). 317 머리글은 2D바코드에서 모델명을 함께 읽어 이 함수 호출이 불필요했다. |
| `f_ymd_sysdate` | `SUBSTR(TO_CHAR(SYSDATE,'YYYY'),4,1) || F_GET_MONTH_CODE2(TO_CHAR(SYSDATE,'MM')) || F_GET_DAY_CODE(TO_CHAR(SYSDATE,'DD'))` | 롯트번호 날짜접두어. YYYYMMDD 가 아니라 3글자 코드다 (2026-09-28 → 69S). DB 에 동명 함수가 없고 PB 본문이 쓰는 F_GET_MONTH_CODE2·F_GET_DAY_CODE 는 DB 함수라 그대로 부른다. 실측 롯트번호 303,081건이 8자(3+5). |
| `f_get_line_type_from_item` | `F_GET_LINE_TYPE_FROM_ITEM(item_code, organization_id)` | DB 함수와 본문이 같고 유효기간 조건만 DB 쪽에서 주석 처리돼 있다. 호출 전에 유효기간을 이미 확인하므로 결과가 같다. 인자 2개다 (PB 래퍼는 1개). |
| `f_get_any_no` | `F_GET_ANY_NO(UPPER(name), organization_id)` | PB 래퍼 본문이 같은 이름의 DB 함수를 부르는 것뿐이라 직접 불러도 값이 같다 (실측 f_get_any_no.srf). |

### 전환 보류 (`blocked`) — 10건

| PB 함수 | 대상 | 비고 |
|---|---|---|
| `f_get_dynamic_report_name` | — | 전환 보류 — 참조 컬럼 QR_PID_DW_NAME / PACKING_LABEL_DW_NAME 이 이 DB 의 IP_PRODUCT_MODEL_MASTER 에 없다. |
| `f_download_mold_rtn_filename` | — | 전환 불가 — PB 파일 I/O(SETPOINTER + 파일 다운로드). 첨부 기능은 S-PARTS 이관 범위에서 제외했다. |
| `f_get_product_date_by_model` | — | 전환 불가 — 참조 테이블 TB_VIS_TSTRSLT(VISION 검사결과)가 이 DB 에 없다. |
| `f_shell_execute_by_extention` | — | 전환 불가 — 확장자로 OS 연결 프로그램을 띄운다. 첨부파일 열기 기능은 품질관리 이관 범위에서 제외했다. |
| `f_download_qc_document_data` | — | 전환 불가 — PB 파일 I/O(첨부파일 다운로드). 품질 첨부·이미지 기능은 이관 범위에서 제외했다. |
| `f_download_qc_inspect_data` | — | 전환 불가 — PB 파일 I/O(첨부파일 다운로드). 품질 첨부·이미지 기능은 이관 범위에서 제외했다. |
| `f_download_qc_ng_image_data` | — | 전환 불가 — PB 파일 I/O(첨부파일 다운로드). 품질 첨부·이미지 기능은 이관 범위에서 제외했다. |
| `f_download_qc_notify_rtn_multi_filename` | — | 전환 불가 — PB 파일 I/O(첨부파일 다운로드). 품질 첨부·이미지 기능은 이관 범위에서 제외했다. |
| `f_download_eco_rtn_filename` | — | 전환 불가 — PB 파일 I/O(첨부파일 다운로드). 품질 첨부·이미지 기능은 이관 범위에서 제외했다. |
| `f_download_qc_4m_data` | — | 전환 불가 — PB 파일 I/O(첨부파일 다운로드). 품질 첨부·이미지 기능은 이관 범위에서 제외했다. |

## 미처리 전환 후보

본문이 SQL + 분기뿐이라 DB 패키지로 옮길 수 있는 것들입니다.
화면을 이관할 때 그 화면이 부르는 것부터 처리하세요.

| PB 함수 | 호출 | 창 수 | 대표 창 |
|---|---:|---:|---|
| `f_set_layered_window` | 14 | 14 | w_bad_reason_select_popup, w_com_message_popup_lg |
| `f_play_mp3` | 45 | 9 | w_pln_product_magazine_label_split_master, w_prd_product_fg_4_magazine_receipt |
| `f_get_tariff_rate` | 7 | 7 | w_mat_departure_4_goods_master, w_mat_departure_master |
| `f_get_token` | 15 | 5 | w_dynamic_graph_popup, w_dynamic_where_condition_popup |
| `f_check_slip_exists` | 6 | 5 | w_mat_other_receipt_rental_borrowing_barcode_master, w_mat_receipt_slip_4_rental_borrowing_master |
| `f_get_line_code_by_item` | 8 | 4 | w_mat_inventory_close_excel_import_popup, w_mat_receipt_slip_excel_import_popup |
| `f_get_order_dc_rate` | 5 | 4 | w_mat_item_departure_excel_form_popup, w_mat_item_purchase_excel_form_popup |
| `f_dual_lang_object_count` | 4 | 4 | w_col_info_popup, w_replace_popup |
| `f_get_constraints_table_name` | 21 | 3 | w_graph_root, w_main_root |
| `f_get_purchase_order_qty` | 9 | 3 | w_mat_forecast_order_master, w_mat_purchase_order_4_subcontract_master |
| `f_get_data_window_source` | 5 | 3 | w_report_generator, w_report_master |
| `f_get_mat_inspect_rule` | 4 | 3 | w_mat_departure_4_goods_master, w_mat_departure_master |
| `f_get_lot_size_by_run_no` | 4 | 3 | w_pln_product_magazine_label_master, w_pln_product_magazine_label_master2 |
| `f_check_run_no` | 4 | 3 | w_pln_product_magazine_label_master, w_pln_product_magazine_label_master2 |
| `f_get_item_type_from_item` | 3 | 3 | w_des_bom_modify_master, w_mat_request_issue_master |
| `f_download_item_image` | 3 | 3 | w_des_item_master, w_item_image_flat |
| `f_get_item_auto_issue_yn` | 3 | 3 | w_mat_material_receipt_excel_form_popup, w_mat_material_unit_price_excel_form_popup |
| `f_get_magazine_size` | 3 | 2 | w_pln_product_magazine_label_master, w_pln_product_magazine_label_master2 |
| `f_system_access` | 2 | 2 | w_logon, w_main_root |
| `f_get_computer_name` | 2 | 2 | w_main_frame, w_user_change |
| `f_get_computer_login_user_name` | 2 | 2 | w_main_frame, w_user_change |
| `f_mat_issue_return` | 2 | 2 | w_mat_mass_issue_return_master, w_mat_receipt_barcode_reprint_master |
| `f_mat_receipt_return` | 2 | 2 | w_mat_other_receipt_barcode_return_master, w_mat_receipt_return_master |
| `f_get_line_division` | 2 | 2 | w_product_run_card, w_product_run_card_duckil |
| `f_get_new_scan_qty` | 6 | 1 | w_mat_other_issue_barcode_master |
| `f_get_line_code_group` | 6 | 1 | w_pln_assembly_master_plan_master |
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
| `f_mat_receipt_slip_cancel` | 1 | 1 | w_mat_slip_cancel_popup |
| `f_gen_work_order_to_assy_plan` | 1 | 1 | w_mat_workorder_master |
| `f_mcn_jig_issue_cancel` | 1 | 1 | w_mcn_jig_issue_master |
| `f_download_mold_image` | 1 | 1 | w_mold_image_flat |
| `f_get_master_model_name_by_model_name` | 1 | 1 | w_pln_assembly_master_plan_master |
| `f_get_item_code_by_model_suffix` | 1 | 1 | w_pln_product_master_plan_master |
| `f_get_ip_address` | 1 | 1 | w_user_change |
| `f_get_code_name` | 1 | 1 | w_window_master |
