# PowerBuilder 메뉴 목록 (Infinity21 → 은성 MES 이관 기준)

- 작성일: 2026-09-21
- 작성 계기: 은성 MES 신규 메뉴는 PowerBuilder 메뉴를 기준으로 생성한다. 그 기준 목록이 필요해서 추출했다.
- 이관 진행 상태는 이 문서가 아니라 `docs/business-logics/pb-screen-migration-status.md` 에서 관리한다. 이 문서는 **PB 메뉴 전체 구조 스냅샷**이다.

## 요약 (결론 먼저)

PB 메뉴는 PBL 소스가 아니라 **Oracle 테이블 `ISYS_DYNAMIC_MENU`** 에 있다. PBL의 `d_dynamic_menu.srd`가 이 테이블을 읽는 DataWindow다.
다만 각 메뉴가 여는 윈도우는 절반 이상이 이 테이블의 `MENU_TAG`에 없고, **메뉴 오브젝트 `m_main_frame_menu` 의 `clicked` 이벤트**(`Opensheet(w_xxx)`)에 하드코딩돼 있다. 두 출처를 합쳐야 목록이 완성된다.

| 항목 | 값 |
|---|---|
| 메뉴 트리 출처 | `ISYS_DYNAMIC_MENU` (`MENU_NAME='M_MAIN_FRAME_MENU'`, `ORGANIZATION_ID=1`) |
| 윈도우명 출처 | 위 테이블의 `MENU_TAG` + `infinity21.pbl` 의 `m_main_frame_menu` 오브젝트 |
| 접속 DB | JSIDCESDB — 139.150.82.207 / ESDBPDB (`apps/backend/.env` 와 동일) |
| 전체 행 | 522 |
| 구분선(`-`) | 88 |
| 실제 메뉴 | 434 (대분류 25 / 중분류 243 / 소분류 106) |
| 실행 가능한 화면(리프) | 366 |
| └ 그중 **업무 화면** (셸 메뉴 제외) | **275** |
| &nbsp;&nbsp;&nbsp;├ ✅ `.srw` 원본 있음 | 226 |
| &nbsp;&nbsp;&nbsp;├ 📦 PBL에는 있으나 `.srw` 미export | 23 |
| &nbsp;&nbsp;&nbsp;├ ❌ 어디에도 없음 | 0 |
| &nbsp;&nbsp;&nbsp;└ — 윈도우 미상 | 26 |
| `MENU_VISIBLE_YN` = 'N' | 0 (전부 'Y') |

### 컬럼 의미

| 컬럼 | 의미 |
|---|---|
| `MENU_ITEM_ORDER` | 메뉴 표시 순서 (정렬 키) |
| `MENU_ITEM_LEVEL` | 1=대분류 / 2=중분류 / 3=소분류 |
| `MENU_ITEM_TEXT` | 화면에 보이는 메뉴명. `-` 는 구분선 |
| `MENU_ITEM_NAME` | PB 메뉴 아이템 오브젝트명 (`M_xxx`) — `.srm` 과의 조인 키 |
| `MENU_TAG` | 여는 윈도우명. **비어 있는 경우가 많고**, 윈도우가 아닌 값도 있다(`Chinese` = 언어전환) |
| `MENU_VISIBLE_YN` | 표시 여부 |

### 원본 판정 기준

`.srw` 파일 유무만으로 판정하면 안 된다. `PBL Library 10.5/`의 `.srw` 546개는 **부분 export**이고, 실제 라이브러리는 31개 `.pbl`이며 오브젝트 목록은 같은 폴더의 31개 `.pbg` 매니페스트에 있다.

| 표기 | 의미 | 조치 |
|:--:|---|---|
| ✅ | `.srw` 원본 있음 | 바로 분석·이관 가능 |
| 📦 | `.pbg`에는 있으나 `.srw` 미export | PBORCA로 export 후 이관 |
| ❌ | 어디에도 없음 | 폐기 또는 타 라이브러리. 개별 확인 필요 |
| — | 윈도우 미상 | `MENU_TAG`도 비었고 `.srm` 에서도 `Opensheet` 를 못 찾음 |

`w_mat_ledger_report`(자재입출고수불원장)가 📦 의 대표 사례다. `.srw`는 없지만 `infinity21_uw_mat.pbg`에 등재돼 있고 이미 은성 MES로 이관까지 됐다.

## 상세 — 전체 메뉴 트리

`MENU_TAG` 열과 `.srm` 열이 다르면 **`.srm`(실제 실행 코드)이 정본**이다.


### 화일  `M_FILE` *(PB 셸 메뉴 — 업무 메뉴 아님)*

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 2 | L2 | 작업탭 |  |  | — |
| 3 | L2 | 게시판 |  | `w_bulletin_board` | ✅ |
| 4 | L2 | 경보 |  |  | — |
| 5 | L3 | └ 경보쓰기 |  | `w_alert_master` | ✅ |
| 6 | L3 | └ 경보보기 |  | `w_alert` | ✅ |
| 8 | L2 | 사용자변경 |  | `w_user_change` | ✅ |
| 9 | L2 | 언어변경 |  |  | — |
| 10 | L3 | └ 한국어 |  |  | — |
| 11 | L3 | └ 中国语 |  |  | — |
| 12 | L3 | └ にほんご프 |  |  | — |
| 13 | L3 | └ 영어 |  |  | — |
| 14 | L2 | 조직변경 |  | `w_wallpaper` | ✅ |
| 16 | L2 | 시스템잠금 |  | `w_lock_system` | ✅ |
| 17 | L2 | 내메뉴 |  |  | — |
| 18 | L3 | └ 즐겨찾기 |  |  | — |
| 19 | L3 | └ 자동등록 |  |  | — |
| 20 | L3 | └ 메뉴갱신 |  |  | — |
| 21 | L3 | └ 메뉴추가 |  |  | — |
| 22 | L3 | └ 메뉴삭제 |  |  | — |
| 23 | L3 | └ 메뉴변경 |  |  | — |
| 24 | L2 | 프린트 |  |  | — |
| 25 | L3 | └ 조정 |  |  | — |
| 26 | L4 | 가로 |  |  | — |
| 27 | L4 | 세로 |  |  | — |
| 29 | L4 | 여백 |  |  | — |
| 31 | L4 | 작게 |  |  | — |
| 32 | L4 | 크게 |  |  | — |
| 33 | L4 | 크기조절 |  | `w_set_zoom` | ✅ |
| 34 | L3 | └ 미리보기 |  |  | — |
| 35 | L4 | 설정값으로미리보기 |  | `w_set_zoom` | ✅ |
| 37 | L4 | 미리보기(예) |  |  | — |
| 38 | L4 | 미리보기(아니오) |  |  | — |
| 39 | L3 | └ 프린트... |  | `w_zetprint` | ✅ |
| 40 | L2 | 프린터설정... |  |  | — |
| 42 | L2 | 저장/열기 |  |  | — |
| 43 | L3 | └ PSR리포트열기 |  | `w_psr_viewer` | ✅ |
| 44 | L3 | └ 엑셀로열기 |  |  | — |
| 46 | L3 | └ 다른이름으로저장... |  |  | — |
| 48 | L3 | └ PDF 로저장 |  |  | — |
| 49 | L3 | └ 엑셀에서가져오기 |  | `w_excel_import_popup` | ❌ |
| 50 | L3 | └ XML에서불러오기 |  |  | — |
| 52 | L3 | └ 워드로저장 |  |  | — |
| 53 | L3 | └ Save Form As Excel |  |  | — |
| 55 | L2 | 브라우져열기 |  | `w_web_browser` | ✅ |
| 56 | L2 | 메일보내기 |  | `w_send_mail_popup` | ✅ |
| 58 | L2 | 재시작 |  |  | — |
| 59 | L2 | 닫기 |  |  | — |
| 61 | L2 | 나가기	Alt+F4 |  |  | — |

### 수정  `M_EDIT` *(PB 셸 메뉴 — 업무 메뉴 아님)*

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 63 | L2 | 행복사	Ctrl+D |  |  | — |
| 64 | L2 | 컬럼값복사	F8 |  | `w_clipboard` | ✅ |
| 65 | L2 | 컬럼값붙여넣기	F9 |  |  | — |
| 66 | L2 | 클립보드에서불러오기 |  |  | — |
| 68 | L2 | 데이타그룹	Ctrl+G |  | `w_data_group_popup` | ✅ |
| 69 | L2 | 데이타정렬	Ctrl+T |  |  | — |
| 70 | L2 | 데이타필터 |  |  | — |
| 72 | L2 | 그룹보기/감추기	Ctrl+S |  |  | — |
| 73 | L2 | 상세내역보기/감추기	Ctrl+A |  |  | — |
| 75 | L2 | 찾기...	Ctrl+F |  | `w_find_popup` | ✅ |
| 76 | L2 | 바꾸기...	Ctrl+R |  | `w_replace_popup` | ✅ |
| 78 | L2 | 편집창	Ctrl+E |  | `w_edit_window` | ✅ |
| 79 | L2 | 클립보드...	CTRL+L |  | `w_clipboard` | ✅ |
| 81 | L2 | 그래프보기 |  |  | — |
| 82 | L3 | └ 보기 |  | `w_graph_report` | ✅ |
| 83 | L3 | └ 추가 |  | `w_dynamic_graph_popup` | ✅ |
| 84 | L3 | └ 삭제 |  |  | — |

### 조작  `M_CONTROL` *(PB 셸 메뉴 — 업무 메뉴 아님)*

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 86 | L2 | 조회	F1 |  |  | — |
| 87 | L2 | 동적조회 |  |  | — |
| 88 | L2 | 중지	F2 |  |  | — |
| 90 | L2 | 입력	F3 |  |  | — |
| 91 | L2 | 추가	F4 |  |  | — |
| 93 | L2 | 삭제	F5 |  |  | — |
| 94 | L2 | 삭제취소 |  |  | — |
| 95 | L2 | 일괄삭제 |  |  | — |
| 97 | L2 | 저장	F6 |  |  | — |
| 99 | L2 | 전체확장 |  |  | — |
| 100 | L2 | 전체축소 |  |  | — |
| 101 | L2 | 크기조절 |  | `w_set_zoom` | ✅ |
| 103 | L2 | 기본값	F7 |  | `w_default_value_popup` | ✅ |
| 104 | L2 | 선택/체크 |  |  | — |
| 105 | L3 | └ 모든행선택 |  |  | — |
| 106 | L3 | └ 모든행해제 |  |  | — |
| 108 | L3 | └ 전부선택 |  |  | — |
| 109 | L3 | └ 전부해제 |  |  | — |
| 110 | L2 | 오른쪽버튼메뉴 |  |  | — |
| 111 | L3 | └ 복사 |  |  | — |
| 112 | L3 | └ 행복사 |  |  | — |
| 113 | L3 | └ Show Summary |  | `w_clipboard_info` | ✅ |
| 114 | L3 | └ 컬럼숨기기 |  |  | — |
| 115 | L3 | └ 동적필터 |  | `w_quick_filter` | ✅ |
| 117 | L2 | 기초정보재설정 |  |  | — |

### 기준정보  `M_BASIS1`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 119 | L2 | 고객관리 | `w_com_customer_master` | `w_com_customer_master` | ✅ |
| 120 | L2 | 협력사관리 | `w_com_supplier_master` | `w_com_supplier_master` | ✅ |
| 122 | L2 | 품목관리 | `w_des_item_master` | `w_des_item_master` | 📦 |
| 123 | L2 | 제품모델관리 | `w_pln_product_model_master` | `w_pln_product_model_simple_master` ⚠️ | ✅ |
| 124 | L2 | 품목(공급상)관리 | `w_mat_item_master` | `w_mat_item_master` | ✅ |
| 125 | L2 | LED RANK 관리 | `w_com_mat_rank_master` | `w_com_mat_rank_master` | ✅ |
| 126 | L2 | 환율관리 | `w_com_exchange_rate_master` | `w_com_exchange_rate_master` | ✅ |
| 128 | L2 | 제품류관리 | `w_des_product_class_master` | `w_des_product_class_master` | ✅ |
| 129 | L2 | 라인관리 | `w_pln_line_master` | `w_pln_line_master` | ✅ |
| 130 | L2 | 공정관리마스터 | `w_pln_workstage_master` | `w_pln_workstage_master` | ✅ |
| 131 | L2 | 모델별 ST관리 | `w_pln_product_model_st_master` | `w_pln_product_model_st_master` | ✅ |
| 132 | L2 | 생산월력 | `w_pln_product_calendar` | `w_pln_product_calendar` | ✅ |
| 133 | L2 | 생산라인보유공수관리 | `w_pln_line_capacity_master` | `w_pln_line_capacity_master` | ✅ |
| 134 | L2 | 제품별 라벨양식 관리 | `w_product_label_master` | `w_product_label_master` | ✅ |
| 135 | L2 | 문서관리 | `w_com_document_master` | `w_com_document_master` | ✅ |
| 137 | L2 | 인터락조건관리 | `w_com_interlock_inspect_condition_master` | `w_com_interlock_inspect_condition_master` | ✅ |
| 138 | L2 | QC 품질판정조건표 |  | `w_qc_led_inspect_condition_master` | ✅ |
| 140 | L2 | 풀체크시간관리 | `w_com_full_check_time_master` | `w_com_full_check_time_master` | ✅ |
| 142 | L2 | 자재구매단가 | `w_mat_buy_price_master` | `w_mat_buy_price_master` | ✅ |
| 143 | L2 | 제(상)품판매단가 | `w_sal_sale_price_master` | `w_sal_sale_price_master` | ✅ |

### 설계  `M_DESIGN`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 145 | L2 | 설계BOM관리 | `w_des_bom_modify_master` | `w_des_bom_modify_master` | ✅ |
| 146 | L2 | 제조BOM관리 | `w_des_mfs_bom_master` | `w_des_mfs_bom_master` | ✅ |
| 147 | L2 | 대체BOM관리 | `w_des_replace_bom_master` | `w_des_replace_bom_master` | ✅ |
| 148 | L2 | 원단위BOM마스터 | `w_des_raw_bom_master` | `w_des_raw_bom_master` | ✅ |
| 149 | L2 | 적용모델관리 | `w_des_apply_item_master` | `w_des_apply_item_master` | ✅ |

### SMT  `M_SMT`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 151 | L2 | SMT 라인관리 | `w_smt_line_master` | `w_smt_line_master` | ✅ |
| 152 | L2 | 라인별 테이블 관리 | `w_smt_location_master` | `w_smt_location_master` | ✅ |
| 153 | L2 | SMT BOM 대체관리 | `w_smt_bom_replace_master` | `w_smt_bom_replace_master` | ✅ |
| 155 | L2 | SMT 피더레이아웃 등록 | `w_smt_upload_nc_master` | `w_smt_upload_nc_master` | ✅ |
| 156 | L2 | SMT BOM 관리 | `w_smt_bom_create_master` | `w_smt_bom_create_master` | ✅ |
| 157 | L2 | SMT 계획배포관리 | `w_smt_plan_master` | `w_smt_plan_master` | 📦 |
| 159 | L2 | SMT BOM 관리리포트 | `w_smt_bom_master_rpt` | `w_smt_bom_master_rpt` | ✅ |
| 160 | L2 | 피더레이아웃 비교 | `w_smt_bom_comparison_master_rpt` | `w_smt_bom_comparison_master_rpt` | ✅ |
| 162 | L2 | 마운터 픽업정보관리 | `w_mcn_feeder_pickup_master` | `w_mcn_feeder_pickup_master` | ✅ |

### 설비  `M_JIG`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 164 | L2 | AOI 검사결과조회 |  |  | — |
| 164 | L2 | 설비자주보전관리 | `w_mcn_machine_pm_master` | `w_mcn_machine_pm_master` | ✅ |
| 165 | L2 | 설비관리 | `w_mcn_machine_master` | `w_mcn_machine_master` | ✅ |
| 166 | L2 | 설비수리이력관리 | `w_mcn_machine_repair_request_master` | `w_mcn_machine_repair_request_master` | 📦 |
| 167 | L2 | 설비수리관리 | `w_mcn_machine_repair_master` | `w_mcn_machine_repair_master` | ✅ |
| 168 | L2 | 설비자주보전관리 | `w_mcn_machine_pm_master` | `w_mcn_machine_pm_master` | ✅ |
| 169 | L2 | 설비일일운행관리 | `w_mcn_machine_daily_operation` | `w_mcn_machine_daily_operation` | ✅ |
| 171 | L2 | SP 작업결과조회 | `w_qc_machine_inspect_data_sp_query` | `w_qc_machine_inspect_data_sp_query` | ✅ |
| 172 | L2 | SPI 검사결과조회 | `w_spi_time_query` | `w_spi_time_query` | ✅ |
| 173 | L2 | ICT 검사결과조회 | `w_qc_machine_inspect_data_ict_query` | `w_qc_machine_inspect_data_ict_query` | ✅ |
| 174 | L2 | AOI 검사결과조회 | `w_aoi_header_detail_query` | `w_aoi_header_detail_query` | 📦 |
| 175 | L2 | Router작업결과조회 | `w_qc_machine_inspect_data_rt_query` | `w_qc_machine_inspect_data_rt_query` | ✅ |
| 176 | L2 | RomWrite작업결과조회 |  | `w_qc_machine_inspect_data_rw_query` | ✅ |
| 177 | L2 | 솔더점도 검사결과조회 |  | `w_qc_machine_inspect_data_solder_query` | ✅ |
| 178 | L2 | Reflow 작업결과조회 |  | `w_qc_machine_inspect_data_reflow_query` | ✅ |
| 179 | L2 | AE-EV BUSBAR Result Query |  |  | — |
| 180 | L2 | EOL Result Query | `w_qc_machine_inspect_data_eol_query` |  | ✅ |
| 181 | L2 | BMA Result Query | `w_qc_machine_inspect_data_bma_query` |  | ✅ |
| 183 | L2 | 라인/설비일일운행일지 | `w_line_machine_daily_operation_rpt` | `w_line_machine_daily_operation_rpt` | ✅ |

### 지그  `M_JIG0`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 185 | L2 | 지그마스터 | `w_mcn_jig_master` | `w_mcn_jig_master` | 📦 |
| 186 | L2 | 지그출고관리 | `w_mcn_jig_issue_master` | `w_mcn_jig_issue_master` | ✅ |
| 187 | L2 | 지그수리신청 | `w_mcn_jig_repair_request_master` | `w_mcn_jig_repair_request_master` | ✅ |
| 188 | L2 | 지그수리관리 | `w_mcn_jig_repair_master` | `w_mcn_jig_repair_master` | ✅ |
| 189 | L2 | 지그자주보전관리 | `w_mcn_jig_pm_master` | `w_mcn_jig_pm_master` | ✅ |
| 191 | L2 | 지그마스터 투입이력조회 | `w_mcn_jig_input_history_master` | `w_mcn_jig_input_history_master` | ✅ |
| 193 | L2 | 스퀴즈검사관리 | `w_mcn_jig_squeeze_check_master` | `w_mcn_jig_squeeze_check_master` | ✅ |
| 194 | L2 | 메탈마스크텐션관리 | `w_mcn_jig_mask_tension_check_master` | `w_mcn_jig_mask_tension_check_master` | 📦 |
| 195 | L2 | 스퀴지검사관리 | `w_mcn_jig_squeeze_clean_check_master` | `w_mcn_jig_squeeze_clean_check_master` | 📦 |
| 197 | L2 | 샘플마스터 관리 | `w_mcn_sample_master` | `w_mcn_sample_master` | ✅ |
| 198 | L2 | 샘플마스터 장착이력조회 | `w_mcn_sample_input_history_master` | `w_mcn_sample_input_history_master` | ✅ |
| 199 | L2 | 샘플마스터 투입이력조회 | `w_mcn_sample_bcr_input_history_master` | `w_mcn_sample_bcr_input_history_master` | ✅ |

### 피더  `M_FEEDER`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 201 | L2 | 피더관리 | `w_mcn_feeder_master` | `w_mcn_feeder_master` | ✅ |
| 202 | L2 | 피더수리신청 | `w_mcn_feeder_repair_request_master` | `w_mcn_feeder_repair_request_master` | ✅ |
| 203 | L2 | 피더수리관리 | `w_mcn_feeder_repair_master` | `w_mcn_feeder_repair_master` | ✅ |
| 204 | L2 | 피더교정관리 | `w_mcn_jig_feeder_adjust_master` | `w_mcn_jig_feeder_adjust_master` | ✅ |

### S-PARTS  `M_MOLD`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 206 | L2 | S-PARTS관리 | `w_mcn_mold_master` | `w_mcn_mold_master` | ✅ |
| 207 | L2 | S-PARTS주문관리 | `w_mcn_mold_purchase_order_master` | `w_mcn_mold_purchase_order_master` | ✅ |
| 208 | L2 | S-PARTS입고관리 | `w_mcn_mold_receipt_master` | `w_mcn_mold_receipt_master` | ✅ |
| 209 | L2 | S-PARTS출고관리 | `w_mcn_mold_issue_master` | `w_mcn_mold_issue_master` | ✅ |
| 210 | L2 | S-PARTS재고관리 | `w_mcn_mold_inventory_master` | `w_mcn_mold_inventory_master` | ✅ |
| 212 | L2 | S-PARTS수리신청관리 | `w_mcn_mold_repair_request_master` | `w_mcn_mold_repair_request_master` | ✅ |
| 213 | L2 | S-PARTS수리관리 | `w_mcn_mold_repair_master` | `w_mcn_mold_repair_master` | ✅ |
| 215 | L2 | S-PARTS구매단가관리 | `w_mcn_mold_buy_price_master` | `w_mcn_mold_buy_price_master` | ✅ |

### 생산  `M_PLANNING`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 217 | L2 | 제품생산계획 | `w_pln_product_master_plan_master` | `w_pln_product_master_plan_master` | ✅ |
| 218 | L2 | 반제품생산계획 | `w_pln_assembly_master_plan_master` | `w_pln_assembly_master_plan_master` | 📦 |
| 219 | L2 | 반제품생산실적관리 | `w_pln_assembly_actual_master` | `w_pln_assembly_actual_master` | ✅ |
| 221 | L2 | 롯트카드관리 | `w_product_run_card_duckil` | `w_product_run_card_duckil` | ✅ |
| 222 | L2 | 롯트카드-PID 매핑관리 | `w_pln_product_pcb_kitting_scan_master` | `w_pln_product_pcb_kitting_scan_master` | ✅ |
| 224 | L2 | 기간별 생산실적 조회 | `w_pln_product_pcb_result_query` | `w_pln_product_pcb_result_query` | ✅ |
| 225 | L2 | 생산일보 리포트 | `w_pln_product_pcb_result_report` | `w_pln_product_pcb_result_report` | ✅ |

### 공정  `M_WORKSTAGE0`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 227 | L2 | 제품공정인아웃스캔관리 | `w_pln_product_inout_scan_master` | `w_pln_product_inout_scan_master` | ✅ |
| 229 | L2 | 매거진라벨 발행 | `w_pln_product_magazine_label_master` | `w_pln_product_magazine_label_master2` ⚠️ | 📦 |
| 230 | L2 | 매거진라벨 분할 | `w_pln_product_magazine_label_split_master` | `w_pln_product_magazine_label_split_master` | ✅ |
| 231 | L2 | 매거진-PID 매핑관리 | `w_pln_product_barcode_create_master` | `w_pln_product_barcode_create_master` | ✅ |
| 233 | L2 | 매거진라벨이력조회 | `w_pln_product_magazine_label_query` | `w_pln_product_magazine_label_query` | ✅ |

### 자재창고  `M_WAREHOUSE`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 235 | L2 | 자재입고전표관리 | `w_mat_receipt_slip_master` | `w_mat_receipt_slip_master` | ✅ |
| 237 | L2 | 자재바코드입고관리 |  | `w_mat_other_receipt_barcode_master` | 📦 |
| 238 | L2 | 자재바코드출고관리 |  | `w_mat_other_issue_barcode_master` | ✅ |
| 239 | L2 | IMD 라인 자재투입관리 | `w_mat_manual_input_history_query` | `w_mat_manual_input_history_query` | ✅ |
| 240 | L2 | 자재분할관리 | `w_mat_receipt_barcode_divide_master` | `w_mat_receipt_barcode_divide_master` | 📦 |
| 241 | L2 | 자재바코드재발행 | `w_mat_receipt_barcode_reprint_master` | `w_mat_receipt_barcode_reprint_master` | ✅ |
| 243 | L2 | 솔더라벨 발행 | `w_mat_receipt_slip_master_onetek_solder` | `w_mat_receipt_slip_master_onetek_solder` | ✅ |
| 244 | L2 | 솔더입출고조회 | `w_mat_solder_receipt_issue_master` | `w_mat_solder_receipt_issue_master` | ✅ |
| 245 | L2 | 솔더라인투입이력조회 | `w_mat_solder_input_move_query` | `w_mat_solder_input_move_query` | ✅ |
| 247 | L2 | 자재입출고수불원장 | `w_mat_ledger_report` | `w_mat_ledger_report` | 📦 |
| 248 | L2 | 바코드 |  |  | — |
| 250 | L3 | └ 출고바코드반품(양산/벌크)관리 | `w_mat_other_mass_issue_barcode_return_master` | `w_mat_other_mass_issue_barcode_return_master` | ✅ |
| 252 | L2 | 정상 |  |  | — |
| 253 | L3 | └ 자재입고관리 | `w_mat_receipt_master` | `w_mat_receipt_master` | ✅ |
| 254 | L3 | └ 자재기타입고관리 | `w_mat_other_receipt_master` | `w_mat_other_receipt_master` | ✅ |
| 255 | L3 | └ 자재입고취소 |  | `w_mat_receipt_cancel_master` | ✅ |
| 257 | L3 | └ 자재기타출고 | `w_mat_other_issue_master` | `w_mat_other_issue_master` | ✅ |
| 258 | L3 | └ 자재출고취소 | `w_mat_mass_issue_cancel_master` | `w_mat_mass_issue_cancel_master` | ✅ |
| 260 | L2 | MSL 이상품목 처리이력관리 | `w_mat_msl_item_check_master` | `w_mat_msl_item_check_master` | ✅ |
| 261 | L2 | 베이킹이력관리 | `w_mat_baking_dehumi_scan_master` | `w_mat_baking_dehumi_scan_master` | ✅ |
| 262 | L2 | 베이킹재고조회 | `w_mat_baking_scan_query` | `w_mat_baking_scan_query` | ✅ |
| 263 | L2 | 진공포장재고조회 | `w_mat_vacuum_scan_query` | `w_mat_vacuum_scan_query` | ✅ |
| 264 | L2 | 제습함재고조회 | `w_mat_dehumi_scan_query` | `w_mat_dehumi_scan_query` | ✅ |
| 266 | L2 | SMT 공릴체크 | `w_smt_recycle_check_rpt` | `w_smt_recycle_check_rpt` | 📦 |

### 재고  `M_INVENTORY`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 268 | L2 | 현재고조회 | `w_mat_current_inventory_master` | `w_mat_current_inventory_master` | 📦 |
| 269 | L2 | 총재고조회 | `w_mat_total_inventory_query` | `w_mat_total_inventory_query` | ✅ |
| 271 | L2 | 자재재고마감 | `w_mat_inventory_close_report` | `w_mat_inventory_close_report` | ✅ |
| 272 | L2 | 자재재고조사 | `w_mat_inventory_check_master` | `w_mat_inventory_check_master` | ✅ |
| 274 | L2 | 자재바코드스캔실사 | `w_mat_barcode_check_master` | `w_mat_barcode_check_master` | ✅ |

### 수리  `M_REPAIR`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 276 | L2 | 공정수리관리(PID) | `w_pln_product_pcb_repair_master` | `w_pln_product_pcb_repair_master` | ✅ |
| 278 | L2 | 공정폐기관리 | `w_pln_product_pcb_destroy_master` | `w_pln_product_pcb_destroy_master` | ✅ |
| 280 | L2 | 수리자재신청 | `w_mat_request_master` | `w_mat_request_master` | ✅ |
| 281 | L2 | 공정수리이력조회 |  | `w_pln_product_pcb_repair_query` | 📦 |

### 품질관리  `M_QC`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 283 | L2 | IQC 관리 | `w_qc_iqc_master` | `w_qc_iqc_master` | 📦 |
| 284 | L2 | IQC 이력등록관리 | `w_qc_iqc_inspect_history_master` | `w_qc_iqc_inspect_history_master` | ✅ |
| 285 | L2 | PCB 이슈발생스캔관리 | `w_pln_product_pid_issue_scan_master` | `w_pln_product_pid_issue_scan_master` | ✅ |
| 287 | L2 | 재고통제관리 | `w_qc_inventory_hold_master` | `w_qc_inventory_hold_master` | ✅ |
| 288 | L2 | PID 홀딩관리 | `w_pln_product_barcode_holding` | `w_pln_product_barcode_holding` | ✅ |
| 289 | L2 | 품질이상발생관리 | `w_qc_notify_master` | `w_qc_notify_master` | ✅ |
| 290 | L2 | 품질알림관리 | `w_qc_eco_notify_master` | `w_qc_eco_notify_master` | ✅ |
| 291 | L2 | 4M 이력관리 | `w_qc_4m_master` | `w_qc_4m_master` | ✅ |
| 293 | L2 | 공정품질검사이력관리 | `w_qc_workstage_inspect_data_master` | `w_qc_workstage_inspect_data_master_es` ⚠️ | 📦 |
| 294 | L2 | OQC 검사이력관리(PID) | `w_qc_oqc_inspect_history_master` | `w_qc_oqc_inspect_history_master` | ✅ |
| 295 | L2 | OQC 검사이력관리(LOT) | `w_qc_oqc_inspect_history_4_lot_master` | `w_qc_oqc_inspect_history_4_lot_master` | ✅ |
| 297 | L2 | 온도상태조회 | `w_pln_product_tempreture_history_query` | `w_pln_product_tempreture_history_query` | 📦 |

### 출하현황  `M_SHIPPING`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 299 | L2 | 제품포장관리(PID) | `w_prd_product_packing_create_master` | `w_prd_product_packing_create_master` | 📦 |
| 300 | L2 | 제품포장관리(LOT) | `w_prd_product_packing_4_magazine_create_master` | `w_prd_product_packing_4_magazine_create_master` | ✅ |
| 302 | L2 | 제품입고관리(PID) |  | `w_prd_product_fg_receipt` | ✅ |
| 303 | L2 | 제품입고관리(LOT) | `w_prd_product_fg_4_magazine_receipt` | `w_prd_product_fg_4_magazine_receipt` | 📦 |
| 304 | L2 | 제품입고관리 (모델단위) | `w_prd_product_fg_4_model_receipt` | `w_prd_product_fg_4_model_receipt` | ✅ |
| 306 | L2 | 파렛타이징 관리 | `w_prd_product_fg_palletizing` | `w_prd_product_fg_palletizing` | ✅ |
| 307 | L2 | 제품출하관리 | `w_prd_product_fg_issue` | `w_prd_product_fg_issue` | 📦 |
| 308 | L2 | 제품출고관리 (모델단위) | `w_prd_product_fg_4_model_issue` | `w_prd_product_fg_4_model_issue` | ✅ |
| 310 | L2 | 제품재고 |  | `w_prd_product_fg_inventory` | ✅ |
| 311 | L2 | 제품패킹이력 | `w_prd_product_packing_history` | `w_prd_product_packing_history` | ✅ |

### 추적  `M_TRACKING`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 313 | L2 | 자재 제조번호 기준 추적 | `w_product_pid_tracking_rpt` | `w_product_pid_tracking_rpt` | ✅ |
| 314 | L2 | 자재추적조회(동적) | `w_product_material_tracking_rpt` | `w_product_material_tracking_rpt` | ✅ |
| 315 | L2 | 자재사용이력조회 | `w_product_material_tracking_msl_rpt` | `w_product_material_tracking_msl_rpt` | ✅ |
| 317 | L2 | 생산이력조회(PID) | `w_product_pid_tracking_fpcb_rpt` | `w_product_pid_tracking_fpcb_rpt` | ✅ |
| 318 | L2 | 생산이력조회(Run No) | `w_pln_product_barcode_tracking` | `w_pln_product_barcode_tracking` | ✅ |
| 319 | L2 | 롯트추적조회(ALL) | `w_pln_product_all_barcode_tracking` | `w_pln_product_all_barcode_tracking` | ✅ |
| 321 | L2 | 생산현황데쉬보드 | `w_com_production_status_dashboard` | `w_com_production_status_dashboard` | ✅ |

### 조회  `M_QUERY`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 323 | L2 | PID 정보조회 |  | `w_pln_product_barcode_query` | ✅ |
| 324 | L2 | 마킹이력조회 | `w_pln_product_pcb_marking_query` | `w_pln_product_pcb_marking_query` | ✅ |
| 325 | L2 | PCB 투입 리스트조회 | `w_qc_pcb_input_scan_master` | `w_qc_pcb_input_scan_master` | ✅ |
| 327 | L2 | SMT 오장착 스캔 현황 조회 | `w_pln_product_pda_scan_query` | `w_pln_product_pda_scan_query` | ✅ |
| 328 | L2 | PDA 검사오류내역조회 | `w_smt_plan_ng_check_master` | `w_smt_plan_ng_check_master` | ✅ |
| 329 | L2 | SMT 피더별 모니터링 | `w_smt_plan_feeder_monitoring_master` | `w_smt_plan_feeder_monitoring_master` | ✅ |
| 330 | L2 | SMT 제품실적센서이력조회 | `w_pln_product_sensor_actual_master` | `w_pln_product_sensor_actual_master` | ✅ |
| 331 | L2 | 마스크검사이력조회 | `w_mcn_jig_mask_check_history` | `w_mcn_jig_mask_check_history` | ✅ |
| 332 | L2 | 스퀴지검사이력조회 | `w_mcn_jig_squeeze_check_history` | `w_mcn_jig_squeeze_check_history` | ✅ |
| 333 | L2 | 자재 바코드 상태 조회 | `w_mat_barcode_status_report` | `w_mat_barcode_status_report` | ✅ |
| 335 | L2 | NSNP 처리이력조회 | `w_pln_product_nsnp_history_query` | `w_pln_product_nsnp_history_query` | 📦 |

### 리포트  `M_REPORT`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 337 | L2 | 기준정보 |  |  | — |
| 338 | L3 | └ 폼목마스터리포트 | `w_des_item_master_rpt` | `w_des_item_master_rpt` | ✅ |
| 339 | L2 | 바코드 |  |  | — |
| 340 | L3 | └ 라인설비바코드 | `w_barcode_rpt` | `w_pln_line_barcode_rpt` ⚠️ | ✅ |
| 341 | L3 | └ 캐리어바코드 | `w_product_carrier_barcode` | `w_product_carrier_barcode` | ✅ |
| 342 | L2 | 설비 |  |  | — |
| 343 | L3 | └ 설비리포트 | `w_mcn_machine_rpt` | `w_mcn_machine_rpt` | ✅ |
| 344 | L3 | └ SMT PICKUP 리포트 | `w_smt_pickup_rate_rpt` |  | ✅ |
| 345 | L2 | 제품 |  |  | — |
| 346 | L3 | └ 생산계획리포트 | `w_pln_master_plan_report` | `w_pln_master_plan_rpt` ⚠️ | ✅ |
| 347 | L3 | └ 런카드리포트 | `w_product_run_card_rpt` | `w_product_run_card_rpt` | ✅ |
| 348 | L3 | └ 제품 판매실적 |  | `w_prd_product_fg_issue_rpt` | ✅ |
| 349 | L2 | 공정 |  |  | — |
| 350 | L3 | └ 공정재공조회 | `w_product_workstage_stock_rpt` | `w_product_workstage_stock_rpt` | ✅ |
| 352 | L3 | └ 공정매거진조회 | `w_product_workstage_magazine_stock_rpt` | `w_product_workstage_magazine_stock_rpt` | ✅ |
| 353 | L2 | S-PARTS/지그 |  |  | — |
| 354 | L3 | └ S-PARTS입고리포트 | `w_mcn_mold_receipt_rpt` | `w_mcn_mold_receipt_rpt` | ✅ |
| 355 | L3 | └ S-PARTS출고리포트 | `w_mcn_mold_issue_rpt` | `w_mcn_mold_issue_rpt` | ✅ |
| 357 | L3 | └ 지그리포트 | `w_mcn_jig_rpt` | `w_mcn_jig_rpt` | ✅ |
| 358 | L3 | └ S-PARTS관리리포트 | `w_mcn_mold_rpt` | `w_mcn_mold_rpt` | ✅ |
| 359 | L2 | 품질관리 |  |  | — |
| 360 | L3 | └ 4M 변경이력 | `w_qc_4m_history_rpt` | `w_qc_4m_history_rpt` | ✅ |
| 361 | L2 | 자재창고 |  |  | — |
| 362 | L3 | └ 자재전표바코드리포트 |  | `w_mat_receipt_issue_barcode_history_report` | ✅ |
| 363 | L3 | └ 자재입고리포트 | `w_mat_receipt_report` | `w_mat_receipt_report` | ✅ |
| 364 | L3 | └ 자재입고합계리포트 | `w_mat_receipt_sum_report` | `w_mat_receipt_sum_report` | ✅ |
| 365 | L3 | └ 자재출고리포트 | `w_mat_issue_report` | `w_mat_issue_report` | ✅ |
| 366 | L3 | └ 자재출고합계리포트 | `w_mat_issue_sum_report` | `w_mat_issue_sum_report` | ✅ |
| 367 | L3 | └ 자재랙이동리포트 |  | `w_mat_location_address_move_report` | ✅ |
| 368 | L3 | └ 자재장기재고리포트 |  | `w_mat_long_term_inventory_report` | ✅ |
| 369 | L3 | └ 재고리포트 | `w_mat_current_inventory_report` | `w_mat_current_inventory_report` | ✅ |

### 승인  `M_CONFIRM`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 371 | L2 | 반출반입승인 | `w_com_carrying_out_bring_in_confirm` | `w_com_carrying_out_bring_in_confirm` | ✅ |
| 372 | L2 | 반출반입승인(보안) | `w_com_carrying_out_bring_in_security` | `w_com_carrying_out_bring_in_security` | ✅ |
| 373 | L2 | 구매단가승인 | `w_mat_buy_price_confirm` | `w_mat_buy_price_confirm` | ✅ |
| 374 | L2 | 판매단가승인 | `w_sal_sale_price_confirm` | `w_sal_sale_price_confirm` | ✅ |
| 375 | L2 | S-PARTS구매단가승인 | `w_mcn_mold_buy_price_confirm` | `w_mcn_mold_buy_price_confirm` | ✅ |
| 377 | L2 | 설계BOM승인 | `w_des_bom_confirm_master` | `w_des_bom_confirm_master` | ✅ |

### 기본정보  `M_MANAGE`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 379 | L2 | 회사 | `w_company_master` | `w_company_master` | ✅ |
| 380 | L2 | 조직 | `w_organization_master` | `w_organization_master` | ✅ |
| 381 | L2 | 부서 | `w_department_master` | `w_department_master` | ✅ |
| 382 | L2 | 사용자 | `w_user_master` | `w_user_master` | ✅ |
| 384 | L2 | 애플리케이션창 | `w_window_master` | `w_window_master` | ✅ |
| 385 | L2 | 역할 | `w_role_master` | `w_role_master` | ✅ |
| 386 | L2 | 권한 |  |  | — |
| 387 | L3 | └ 프로그램사용권한 | `w_privilege_master` | `w_privilege_master` | ✅ |
| 389 | L2 | 메세지에이젼트 | `w_agent_message_master` | `w_agent_message_master` | ✅ |
| 391 | L2 | 기초코드관리 | `w_basecode_master` | `w_basecode_master` | ✅ |
| 392 | L2 | 표준코드관리 | `w_standard_code_master` | `w_standard_code_master` | ✅ |

### 시스템  `M_SYSTEM`

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 394 | L2 | 언어관리 |  |  | — |
| 395 | L3 | └ 언어텍스트관리 | `w_dual_language` | `w_dual_language` | ✅ |
| 396 | L3 | └ 메세지텍스트관리 | `w_dual_message` | `w_dual_message` | ✅ |
| 398 | L3 | └ 용어사전 | `w_word_dictionary` | `w_word_dictionary` | ✅ |
| 400 | L3 | └ 윈도우언어변환대상찾기	Alt+F10 |  |  | — |
| 401 | L3 | └ 메뉴언어변환대상찾기	Alt+F11 |  |  | — |
| 402 | L2 | 시스템특성 |  |  | — |
| 403 | L3 | └ 시스템환경 | `w_system_config` | `w_system_config` | ✅ |
| 404 | L3 | └ 컬럼포맷	F12 |  | `w_col_info_popup` | ✅ |
| 405 | L3 | └ 재고마감일자설정 | `w_system_inventory_close_date_setup` | `w_system_inventory_close_date_setup` | ✅ |
| 407 | L3 | └ 엔터키탭처럼사용안함 |  |  | — |
| 408 | L3 | └ 행변경이벤트켜기 |  |  | — |
| 410 | L3 | └ 언어즉시변경켜기 |  |  | — |
| 411 | L2 | 메뉴관리모드 |  |  | — |
| 412 | L3 | └ 메뉴재설정 |  |  | — |
| 413 | L3 | └ 메뉴관리 | `w_menu_master` | `w_menu_master` | ✅ |
| 414 | L2 | 시스템데이타보기 |  |  | — |
| 415 | L3 | └ SQL 페인터 |  | `w_sql_painter` | ✅ |
| 416 | L3 | └ SQL보기 |  | `w_edit_window` | ✅ |
| 417 | L3 | └ 기초코드보기	Ctrl+F1 |  | `w_value_list_popup` | ✅ |
| 418 | L3 | └ 선택된데이타보기 |  | `w_edit_window` | ✅ |
| 419 | L3 | └ 데이타창보기 |  | `w_show_datawindow_popup` | ✅ |
| 420 | L3 | └ 테이블컬럼보기 |  | `w_table_description_rpt` | ✅ |
| 421 | L3 | └ 오브젝트보기 | `w_db_object_master` | `w_db_object_master` | ✅ |
| 423 | L3 | └ 인터페이스로그보기 |  |  | — |
| 424 | L3 | └ 시스템오류내역보기 | `w_error_log_trace` | `w_error_log_trace` | ✅ |
| 425 | L3 | └ 시스템사용내역 | `w_system_access_master` | `w_system_access_master` | ✅ |
| 426 | L2 | 리포트관리 |  |  | — |
| 427 | L3 | └ 리포트수정모드 |  |  | — |
| 428 | L4 | 수정모드켜기 |  |  | — |
| 429 | L4 | 수정모드끄기 |  |  | — |
| 431 | L4 | 오브젝트삭제 |  |  | — |
| 433 | L4 | 라인가운데정렬 |  |  | — |
| 435 | L4 | 위로정렬 |  |  | — |
| 436 | L4 | 아래로정렬 |  |  | — |
| 437 | L4 | 왼쪽정렬 |  |  | — |
| 438 | L4 | 오른쪽정렬 |  |  | — |
| 440 | L4 | 가로크기맞춤 |  |  | — |
| 441 | L4 | 세로크기맞춤 |  |  | — |
| 442 | L4 | SMT 공릴체크 |  |  | — |
| 443 | L4 | 조정 |  |  | — |
| 444 | L5 | 왼쪽맞춤 |  |  | — |
| 445 | L5 | 가운데맞춤 |  |  | — |
| 446 | L5 | 오른쪽맞춤 |  |  | — |
| 447 | L3 | └ 박스보이기 |  |  | — |
| 448 | L4 | 박스보이기 |  |  | — |
| 449 | L4 | 박스없애기 |  |  | — |
| 450 | L4 | 그림자보기 |  |  | — |
| 451 | L3 | └ 런타임데이타창생성 | `w_runtime_dw_generator` | `w_runtime_dw_generator` | ✅ |
| 452 | L3 | └ 리포트생성기 | `w_report_generator` | `w_report_generator` | ✅ |
| 454 | L3 | └ 리포트관리 | `w_dataobject_master` | `w_dataobject_master` | ✅ |
| 455 | L2 | Unuse Program |  |  | — |
| 456 | L3 | └ 기준정보 |  |  | — |
| 457 | L4 | IT 자산 현황 | `w_mcn_it_master` | `w_mcn_it_master` | ✅ |
| 458 | L3 | └ 설비 |  |  | — |
| 459 | L4 | 리플로우상태조회 | `w_qc_interlock_reflow_status_master` | `w_qc_interlock_reflow_status_master` | ✅ |
| 460 | L4 | 설비 픽업률조회 | `w_smt_pickup_rate` | `w_smt_pickup_rate_head` ⚠️ | 📦 |
| 461 | L4 | SMT 픽업율(최종데이터조회) | `w_smt_pickup_rate_last_data_query` |  | ✅ |
| 462 | L3 | └ 자재창고 |  |  | — |
| 463 | L4 | 자재전표엑셀업로드관리 | `w_mat_receipt_slip_excel_upload_master` | `w_mat_receipt_slip_excel_upload_master` | ✅ |
| 464 | L4 | 자재(대여/차용)전표등록관리 | `w_mat_receipt_slip_4_rental_borrowing_master` | `w_mat_receipt_slip_4_rental_borrowing_master` | ✅ |
| 465 | L4 | 자재(대여/차용상환)관리 | `w_mat_other_receipt_rental_borrowing_barcode_master` | `w_mat_other_receipt_rental_borrowing_barcode_master` | ✅ |
| 466 | L4 | 자재릴합침관리 ( PCB ) |  | `w_mat_receipt_barcode_combine_master` | ✅ |
| 467 | L4 | 출고바코드반품(수리/리볼)관리 |  | `w_mat_other_issue_barcode_return_master` | ✅ |
| 468 | L4 | 자재요청조회 | `w_mat_material_request_master` | `w_mat_material_request_master` | ✅ |
| 469 | L4 | 라인별 모니터링 | `w_smt_plan_feeder_monitoring_line_master` | `w_smt_plan_feeder_monitoring_line_master` | ✅ |
| 470 | L3 | └ 생산 |  |  | — |
| 471 | L4 | 자재요청관리 | `w_pln_workstage_material_receipt_check_master` | `w_pln_workstage_material_receipt_check_master` | ✅ |
| 472 | L3 | └ 수리 |  |  | — |
| 473 | L4 | 반품수리관리 | `w_sal_shipping_return_repair_master` | `w_sal_shipping_return_repair_master` | ✅ |
| 474 | L3 | └ 재고 |  |  | — |
| 475 | L4 | 반제품바코드스캔실사 | `w_pln_barcode_check_master` | `w_pln_barcode_check_master` | ✅ |
| 476 | L3 | └ 발주 |  |  | — |
| 477 | L4 | 자재소요량관리 | `w_mat_requirment_plan_master` | `w_mat_requirment_plan_master` | ✅ |
| 478 | L4 | 자재발주계획 | `w_mat_purchase_order_plan_master` | `w_mat_purchase_order_plan_master` | ✅ |
| 480 | L4 | 자재주문예정관리 | `w_mat_forecast_order_master` | `w_mat_forecast_order_master` | ✅ |
| 481 | L4 | 자재주문관리 | `w_mat_purchase_order_plan_master` | `w_mat_purchase_order_master` ⚠️ | ✅ |
| 483 | L4 | 자재출발관리 | `w_mat_departure_master` | `w_mat_departure_master` | ✅ |
| 484 | L4 | 자재도착관리 | `w_mat_arrival_master` | `w_mat_arrival_master` | ✅ |
| 485 | L3 | └ 품질관리 |  |  | — |
| 486 | L4 | 설비검사확인(스캔) | `w_qc_machine_inspect_manual` | `w_qc_machine_inspect_manual` | ✅ |
| 487 | L4 | 고객컴플레인관리 | `w_customer_complaints_master` | `w_customer_complaints_master` | ✅ |
| 488 | L4 | 이상발생 모니터링 | `w_pln_product_sound_history_query` | `w_pln_product_sound_history_query` | ✅ |
| 489 | L3 | └ SMT |  |  | — |
| 490 | L4 | SMT 파트라이브러리관리 | `w_smt_upload_partlib_master` | `w_smt_upload_partlib_master` | ✅ |
| 491 | L3 | └ 지그 |  |  | — |
| 492 | L4 | 메탈마스크텐션 수동 관리 | `w_mcn_jig_mask_check_master` | `w_mcn_jig_mask_check_master` | ✅ |
| 493 | L4 | 픽스쳐검사관리 | `w_mcn_jig_fixture_check_master` | `w_mcn_jig_fixture_check_master` | ✅ |
| 494 | L3 | └ 출하현황 |  |  | — |
| 495 | L4 | 제품납품계획 | `w_pln_product_delivery_master` | `w_pln_product_delivery_master` | ✅ |
| 496 | L4 | 포장바코드중복체크관리 | `w_pln_product_packing_dupulicate_check_master` | `w_pln_product_packing_dupulicate_check_master` | ✅ |
| 497 | L3 | └ 통문관리 |  |  | — |
| 498 | L4 | 반출송장 | `w_com_carrying_out_master` | `w_com_carrying_out_master` | ✅ |
| 499 | L4 | 반입송장 | `w_com_bring_in_master` | `w_com_bring_in_master` | ✅ |
| 500 | L3 | └ 추적 |  |  | — |
| 501 | L4 | 워크오더추적조회 | `w_product_material_tracking_4_workorder_rpt` | `w_product_material_tracking_4_workorder_rpt` | ✅ |
| 502 | L4 | 자재추적조회(멀티/동적) | `w_product_material_tracking_multi_rpt` | `w_product_material_tracking_multi_rpt` | ✅ |
| 503 | L4 | 제품 추적 조회 | `w_product_material_tracking_history_rpt` | `w_product_material_tracking_history_rpt` | ✅ |

### 윈도우  `M_WINDOW` *(PB 셸 메뉴 — 업무 메뉴 아님)*

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 505 | L2 | 세로 |  |  | — |
| 506 | L2 | 가로 |  |  | — |
| 507 | L2 | 겹치기 |  |  | — |
| 508 | L2 | 계단식보기 |  |  | — |
| 510 | L2 | 전부닫기 |  |  | — |

### 도움말  `M_HELP` *(PB 셸 메뉴 — 업무 메뉴 아님)*

| 순서 | 계층 | 메뉴명 | `MENU_TAG` | `.srm` Opensheet | 원본 |
|---:|---|---|---|---|:--:|
| 512 | L2 | 도움말내역 |  |  | — |
| 513 | L2 | 도움말동영상보기 | `w_help_video` | `w_help_video` | ✅ |
| 515 | L2 | 기성기술방문 |  |  | — |
| 517 | L2 | 컬럼설명 | `w_column_explanation` | `w_column_explanation` | ✅ |
| 519 | L2 | 애플리케이션에관하여 | `w_who_am_i` | `w_who_am_i` | ✅ |
| 520 | L2 | &Infinity21에 대하여 | `w_about` | `w_about` | ✅ |

## 후속 조치

1. 은성 MES 메뉴 신설은 이 목록에 있는 항목만 대상으로 한다. 목록에 없는 화면은 임의로 만들지 않는다.
2. 대분류 25개 중 `화일`·`수정`·`조작`·`윈도우`·`도움말` 5개는 PowerBuilder 셸 메뉴다. 이관 대상은 나머지 **20개 대분류 / 업무 화면 275건**이다.
3. 📦 23건은 이관 착수 시 PBORCA로 먼저 export한다. ❌ 0건은 개별 확인이 필요하다.
4. 업무 화면 중 **26건은 아직 윈도우 미상**이다(대부분 `시스템` 대분류). `MENU_TAG`도 비었고 `.srm` 의 `clicked` 이벤트에서도 `Opensheet` 호출을 찾지 못했다. 해당 화면 이관 시점에 개별 추적이 필요하다.
5. `⚠️` 표시는 `MENU_TAG` 와 `.srm` 이 가리키는 윈도우가 다른 경우다. 목록은 이관 현황 문서 부록 B 에 정리돼 있다.
6. PB 대분류 체계(자재창고/재고/출하현황 등)와 은성 MES `menuConfig.ts` 그룹 체계는 1:1이 아니다. 그룹 배치는 별도 판단이 필요하다.

## 갱신 이력

- 2026-09-21 최초 작성. `.srw` 유무만으로 원본을 판정해 21건을 "원본 없음"으로 잘못 분류했고, `제품재고`의 윈도우를 추정으로 표기했다.
- 2026-09-21 2차 정정. `.srm` 파서가 아이템 블록을 `on m_x.create/destroy` 에서 끊어 그 뒤의 `event clicked` 를 놓쳤고, 하이픈 아이템명(`m_-38`)을 거부했다. 경계를 다음 `type ... from menu within` 선언까지로 바꾸고 하이픈을 허용해 재추출 → 윈도우 206→292건, 업무화면 미상 35→26건, 태그 불일치 4→7건.
- 2026-09-21 1차 정정. `.pbg` 매니페스트를 대조해 ✅/📦/❌ 3단계로 재분류했고(진짜 없는 것은 1건), `m_main_frame_menu` 를 PBORCA로 export해 `MENU_TAG` 가 비어 있던 항목의 윈도우를 확보했다. `제품재고 → w_prd_product_fg_inventory` 는 **확정**이다.
