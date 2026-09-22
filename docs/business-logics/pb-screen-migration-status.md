---
sources:
  - apps/frontend/src/config/menuConfig.ts
  - apps/frontend/src/app/(authenticated)
verifiedCommit: 0092d3f
---

# PowerBuilder 화면 → 은성 MES 이관 현황

PB 메뉴 전체와 각 메뉴가 여는 PB 윈도우, 그리고 이 프로젝트로 이관(리팩토링)됐는지를 한 파일에서 관리한다.
PB 메뉴 트리 원본 스냅샷(셸 메뉴 포함 전체)은 `docs/reports/2026-09-21-powerbuilder-menu-inventory.md` 에 있다.

> **sync 한계** — frontmatter `sources` 는 `상태`·`MES 메뉴코드` 열의 신선도만 추적한다.
> `PB 윈도우`·`원본` 열의 근거는 repo 밖(Oracle `ISYS_DYNAMIC_MENU`, PBL 내 `m_main_frame_menu`)이라 `managing-docs sync` 가 감지하지 못한다.
> 이 둘이 바뀌면 아래 "갱신 방법"으로 수동 재추출해야 한다.

## 현황

| 상태 | 건수 |
|---|---:|
| 전체 업무 화면 | 275 |
| 완료 | 5 |
| 진행중 | 0 |
| 미착수 | 244 |
| 윈도우 미상 | 26 |

## 상태 표기

| 값 | 의미 |
|---|---|
| `완료` | 은성 MES에 화면이 있고 `menuConfig.ts`에 메뉴가 등록됨 |
| `진행중` | 작업 착수됨 (수기 기록) |
| `보류` | 이관 대상이나 뒤로 미룸 (수기 기록, 사유 함께) |
| `대상아님` | 이관하지 않기로 결정 (수기 기록, 사유 함께) |
| `미착수` | 위 어느 것도 아님 |
| `윈도우미상` | 대상 PB 윈도우를 특정하지 못함 |

**원본** 열: `srw` = `.srw` 있음 · `pbg` = PBL 안에는 있으나 `.srw` 미export (PBORCA export 필요) · `none` = 어디에도 없음

## 갱신 방법

상태(`완료`/`진행중`/`보류`/`대상아님`)는 **이 파일을 직접 수정**해서 기록한다. 아래는 PB 원천 데이터를 다시 뽑을 때만 쓴다.

```bash
# 1) PB 메뉴 트리 (Oracle, site=JSIDCESDB)
#    SELECT MENU_ITEM_ORDER, MENU_ITEM_LEVEL, MENU_ITEM_TEXT, MENU_ITEM_NAME, MENU_TAG
#    FROM ISYS_DYNAMIC_MENU WHERE ORGANIZATION_ID=1 AND MENU_NAME='M_MAIN_FRAME_MENU' ORDER BY MENU_ITEM_ORDER

# 2) 메뉴 오브젝트 export (읽기 전용, 원본 PBL 무변경)
#    스킬 원본 OrcaTool.cs 는 rc=-10(buffertoosmall) 재시도가 없어 실패한다 → 패치 사본으로 빌드할 것
pborca105.exe export "PBL Library 10.5" infinity21 m_main_frame_menu menu out.srm

# 3) out.srm 파싱 규칙 (중요)
#    - 아이템 블록 경계는 다음 'type m_x from menu within m_y' 선언까지다.
#      'on m_x.create' / 'on m_x.destroy' 에서 끊으면 그 뒤에 오는 event clicked 를 놓친다.
#    - 아이템명에 하이픈이 들어간다(m_-38). 정규식 문자클래스에 '-' 를 포함할 것.
#    - clicked 이벤트 안의 Opensheet(w_xxx) 와 f_user_role_check(.., 'w_xxx') 를 읽는다.
```

윈도우명은 **실행 코드(`.srm`)를 DB `MENU_TAG` 보다 우선**한다. 둘이 다른 건 부록 B 참고.

## 대분류별 진행률

| 대분류 | 코드 | 전체 | 완료 | 진행중 | 미착수 | 윈도우미상 |
|---|---|---:|---:|---:|---:|---:|
| 기준정보 | `M_BASIS1` | 20 | 0 | 0 | 20 | 0 |
| 설계 | `M_DESIGN` | 5 | 0 | 0 | 5 | 0 |
| SMT | `M_SMT` | 9 | 0 | 0 | 9 | 0 |
| 설비 | `M_JIG` | 19 | 0 | 0 | 17 | 2 |
| 지그 | `M_JIG0` | 12 | 0 | 0 | 12 | 0 |
| 피더 | `M_FEEDER` | 4 | 0 | 0 | 4 | 0 |
| S-PARTS | `M_MOLD` | 8 | 0 | 0 | 8 | 0 |
| 생산 | `M_PLANNING` | 7 | 0 | 0 | 7 | 0 |
| 공정 | `M_WORKSTAGE0` | 5 | 0 | 0 | 5 | 0 |
| 자재창고 | `M_WAREHOUSE` | 22 | 2 | 0 | 20 | 0 |
| 재고 | `M_INVENTORY` | 5 | 1 | 0 | 4 | 0 |
| 수리 | `M_REPAIR` | 4 | 1 | 0 | 3 | 0 |
| 품질관리 | `M_QC` | 12 | 0 | 0 | 12 | 0 |
| 출하현황 | `M_SHIPPING` | 10 | 1 | 0 | 9 | 0 |
| 추적 | `M_TRACKING` | 7 | 0 | 0 | 7 | 0 |
| 조회 | `M_QUERY` | 11 | 0 | 0 | 11 | 0 |
| 리포트 | `M_REPORT` | 23 | 0 | 0 | 23 | 0 |
| 승인 | `M_CONFIRM` | 6 | 0 | 0 | 6 | 0 |
| 기본정보 | `M_MANAGE` | 10 | 0 | 0 | 10 | 0 |
| 시스템 | `M_SYSTEM` | 76 | 0 | 0 | 52 | 24 |

## 화면 목록

### 기준정보  `M_BASIS1`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 119 | 고객관리 | `w_com_customer_master` | srw | 미착수 |  |  |
| 120 | 협력사관리 | `w_com_supplier_master` | srw | 미착수 |  |  |
| 122 | 품목관리 | `w_des_item_master` | pbg | 미착수 |  |  |
| 123 | 제품모델관리 | `w_pln_product_model_simple_master` | srw | 미착수 |  |  |
| 124 | 품목(공급상)관리 | `w_mat_item_master` | srw | 미착수 |  |  |
| 125 | LED RANK 관리 | `w_com_mat_rank_master` | srw | 미착수 |  |  |
| 126 | 환율관리 | `w_com_exchange_rate_master` | srw | 미착수 |  |  |
| 128 | 제품류관리 | `w_des_product_class_master` | srw | 미착수 |  |  |
| 129 | 라인관리 | `w_pln_line_master` | srw | 미착수 |  |  |
| 130 | 공정관리마스터 | `w_pln_workstage_master` | srw | 미착수 |  |  |
| 131 | 모델별 ST관리 | `w_pln_product_model_st_master` | srw | 미착수 |  |  |
| 132 | 생산월력 | `w_pln_product_calendar` | srw | 미착수 |  |  |
| 133 | 생산라인보유공수관리 | `w_pln_line_capacity_master` | srw | 미착수 |  |  |
| 134 | 제품별 라벨양식 관리 | `w_product_label_master` | srw | 미착수 |  |  |
| 135 | 문서관리 | `w_com_document_master` | srw | 미착수 |  |  |
| 137 | 인터락조건관리 | `w_com_interlock_inspect_condition_master` | srw | 미착수 |  |  |
| 138 | QC 품질판정조건표 | `w_qc_led_inspect_condition_master` | srw | 미착수 |  |  |
| 140 | 풀체크시간관리 | `w_com_full_check_time_master` | srw | 미착수 |  |  |
| 142 | 자재구매단가 | `w_mat_buy_price_master` | srw | 미착수 |  |  |
| 143 | 제(상)품판매단가 | `w_sal_sale_price_master` | srw | 미착수 |  |  |

### 설계  `M_DESIGN`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 145 | 설계BOM관리 | `w_des_bom_modify_master` | srw | 미착수 |  |  |
| 146 | 제조BOM관리 | `w_des_mfs_bom_master` | srw | 미착수 |  |  |
| 147 | 대체BOM관리 | `w_des_replace_bom_master` | srw | 미착수 |  |  |
| 148 | 원단위BOM마스터 | `w_des_raw_bom_master` | srw | 미착수 |  |  |
| 149 | 적용모델관리 | `w_des_apply_item_master` | srw | 미착수 |  |  |

### SMT  `M_SMT`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 151 | SMT 라인관리 | `w_smt_line_master` | srw | 미착수 |  |  |
| 152 | 라인별 테이블 관리 | `w_smt_location_master` | srw | 미착수 |  |  |
| 153 | SMT BOM 대체관리 | `w_smt_bom_replace_master` | srw | 미착수 |  |  |
| 155 | SMT 피더레이아웃 등록 | `w_smt_upload_nc_master` | srw | 미착수 |  |  |
| 156 | SMT BOM 관리 | `w_smt_bom_create_master` | srw | 미착수 |  |  |
| 157 | SMT 계획배포관리 | `w_smt_plan_master` | pbg | 미착수 |  |  |
| 159 | SMT BOM 관리리포트 | `w_smt_bom_master_rpt` | srw | 미착수 |  |  |
| 160 | 피더레이아웃 비교 | `w_smt_bom_comparison_master_rpt` | srw | 미착수 |  |  |
| 162 | 마운터 픽업정보관리 | `w_mcn_feeder_pickup_master` | srw | 미착수 |  |  |

### 설비  `M_JIG`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 164 | AOI 검사결과조회 |  |  | 윈도우미상 |  |  |
| 164 | 설비자주보전관리 | `w_mcn_machine_pm_master` | srw | 미착수 |  |  |
| 165 | 설비관리 | `w_mcn_machine_master` | srw | 미착수 |  |  |
| 166 | 설비수리이력관리 | `w_mcn_machine_repair_request_master` | pbg | 미착수 |  |  |
| 167 | 설비수리관리 | `w_mcn_machine_repair_master` | srw | 미착수 |  |  |
| 168 | 설비자주보전관리 | `w_mcn_machine_pm_master` | srw | 미착수 |  |  |
| 169 | 설비일일운행관리 | `w_mcn_machine_daily_operation` | srw | 미착수 |  |  |
| 171 | SP 작업결과조회 | `w_qc_machine_inspect_data_sp_query` | srw | 미착수 |  |  |
| 172 | SPI 검사결과조회 | `w_spi_time_query` | srw | 미착수 |  |  |
| 173 | ICT 검사결과조회 | `w_qc_machine_inspect_data_ict_query` | srw | 미착수 |  |  |
| 174 | AOI 검사결과조회 | `w_aoi_header_detail_query` | pbg | 미착수 |  |  |
| 175 | Router작업결과조회 | `w_qc_machine_inspect_data_rt_query` | srw | 미착수 |  |  |
| 176 | RomWrite작업결과조회 | `w_qc_machine_inspect_data_rw_query` | srw | 미착수 |  |  |
| 177 | 솔더점도 검사결과조회 | `w_qc_machine_inspect_data_solder_query` | srw | 미착수 |  |  |
| 178 | Reflow 작업결과조회 | `w_qc_machine_inspect_data_reflow_query` | srw | 미착수 |  |  |
| 179 | AE-EV BUSBAR Result Query |  |  | 윈도우미상 |  |  |
| 180 | EOL Result Query | `w_qc_machine_inspect_data_eol_query` | srw | 미착수 |  |  |
| 181 | BMA Result Query | `w_qc_machine_inspect_data_bma_query` | srw | 미착수 |  |  |
| 183 | 라인/설비일일운행일지 | `w_line_machine_daily_operation_rpt` | srw | 미착수 |  |  |

### 지그  `M_JIG0`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 185 | 지그마스터 | `w_mcn_jig_master` | pbg | 미착수 |  |  |
| 186 | 지그출고관리 | `w_mcn_jig_issue_master` | srw | 미착수 |  |  |
| 187 | 지그수리신청 | `w_mcn_jig_repair_request_master` | srw | 미착수 |  |  |
| 188 | 지그수리관리 | `w_mcn_jig_repair_master` | srw | 미착수 |  |  |
| 189 | 지그자주보전관리 | `w_mcn_jig_pm_master` | srw | 미착수 |  |  |
| 191 | 지그마스터 투입이력조회 | `w_mcn_jig_input_history_master` | srw | 미착수 |  |  |
| 193 | 스퀴즈검사관리 | `w_mcn_jig_squeeze_check_master` | srw | 미착수 |  |  |
| 194 | 메탈마스크텐션관리 | `w_mcn_jig_mask_tension_check_master` | pbg | 미착수 |  |  |
| 195 | 스퀴지검사관리 | `w_mcn_jig_squeeze_clean_check_master` | pbg | 미착수 |  |  |
| 197 | 샘플마스터 관리 | `w_mcn_sample_master` | srw | 미착수 |  |  |
| 198 | 샘플마스터 장착이력조회 | `w_mcn_sample_input_history_master` | srw | 미착수 |  |  |
| 199 | 샘플마스터 투입이력조회 | `w_mcn_sample_bcr_input_history_master` | srw | 미착수 |  |  |

### 피더  `M_FEEDER`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 201 | 피더관리 | `w_mcn_feeder_master` | srw | 미착수 |  |  |
| 202 | 피더수리신청 | `w_mcn_feeder_repair_request_master` | srw | 미착수 |  |  |
| 203 | 피더수리관리 | `w_mcn_feeder_repair_master` | srw | 미착수 |  |  |
| 204 | 피더교정관리 | `w_mcn_jig_feeder_adjust_master` | srw | 미착수 |  |  |

### S-PARTS  `M_MOLD`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 206 | S-PARTS관리 | `w_mcn_mold_master` | srw | 미착수 |  |  |
| 207 | S-PARTS주문관리 | `w_mcn_mold_purchase_order_master` | srw | 미착수 |  |  |
| 208 | S-PARTS입고관리 | `w_mcn_mold_receipt_master` | srw | 미착수 |  |  |
| 209 | S-PARTS출고관리 | `w_mcn_mold_issue_master` | srw | 미착수 |  |  |
| 210 | S-PARTS재고관리 | `w_mcn_mold_inventory_master` | srw | 미착수 |  |  |
| 212 | S-PARTS수리신청관리 | `w_mcn_mold_repair_request_master` | srw | 미착수 |  |  |
| 213 | S-PARTS수리관리 | `w_mcn_mold_repair_master` | srw | 미착수 |  |  |
| 215 | S-PARTS구매단가관리 | `w_mcn_mold_buy_price_master` | srw | 미착수 |  |  |

### 생산  `M_PLANNING`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 217 | 제품생산계획 | `w_pln_product_master_plan_master` | srw | 미착수 |  |  |
| 218 | 반제품생산계획 | `w_pln_assembly_master_plan_master` | pbg | 미착수 |  |  |
| 219 | 반제품생산실적관리 | `w_pln_assembly_actual_master` | srw | 미착수 |  |  |
| 221 | 롯트카드관리 | `w_product_run_card_duckil` | srw | 미착수 |  |  |
| 222 | 롯트카드-PID 매핑관리 | `w_pln_product_pcb_kitting_scan_master` | srw | 미착수 |  |  |
| 224 | 기간별 생산실적 조회 | `w_pln_product_pcb_result_query` | srw | 미착수 |  |  |
| 225 | 생산일보 리포트 | `w_pln_product_pcb_result_report` | srw | 미착수 |  |  |

### 공정  `M_WORKSTAGE0`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 227 | 제품공정인아웃스캔관리 | `w_pln_product_inout_scan_master` | srw | 미착수 |  |  |
| 229 | 매거진라벨 발행 | `w_pln_product_magazine_label_master2` | pbg | 미착수 |  |  |
| 230 | 매거진라벨 분할 | `w_pln_product_magazine_label_split_master` | srw | 미착수 |  |  |
| 231 | 매거진-PID 매핑관리 | `w_pln_product_barcode_create_master` | srw | 미착수 |  |  |
| 233 | 매거진라벨이력조회 | `w_pln_product_magazine_label_query` | srw | 미착수 |  |  |

### 자재창고  `M_WAREHOUSE`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 235 | 자재입고전표관리 | `w_mat_receipt_slip_master` | srw | 미착수 |  |  |
| 237 | 자재바코드입고관리 | `w_mat_other_receipt_barcode_master` | pbg | 미착수 |  |  |
| 238 | 자재바코드출고관리 | `w_mat_other_issue_barcode_master` | srw | 미착수 |  |  |
| 239 | IMD 라인 자재투입관리 | `w_mat_manual_input_history_query` | srw | 미착수 |  |  |
| 240 | 자재분할관리 | `w_mat_receipt_barcode_divide_master` | pbg | 미착수 |  |  |
| 241 | 자재바코드재발행 | `w_mat_receipt_barcode_reprint_master` | srw | 미착수 |  |  |
| 243 | 솔더라벨 발행 | `w_mat_receipt_slip_master_onetek_solder` | srw | 미착수 |  |  |
| 244 | 솔더입출고조회 | `w_mat_solder_receipt_issue_master` | srw | 미착수 |  |  |
| 245 | 솔더라인투입이력조회 | `w_mat_solder_input_move_query` | srw | 미착수 |  |  |
| 247 | 자재입출고수불원장 | `w_mat_ledger_report` | pbg | 완료 | `MAT_RECEIPT_ISSUE_LEDGER` | `/material/receipt-issue-ledger` |
| 250 | └ 출고바코드반품(양산/벌크)관리 | `w_mat_other_mass_issue_barcode_return_master` | srw | 미착수 |  |  |
| 253 | └ 자재입고관리 | `w_mat_receipt_master` | srw | 미착수 |  |  |
| 254 | └ 자재기타입고관리 | `w_mat_other_receipt_master` | srw | 미착수 |  |  |
| 255 | └ 자재입고취소 | `w_mat_receipt_cancel_master` | srw | 완료 | `MAT_RECEIPT_CANCEL` | `/material/receipt-cancel` |
| 257 | └ 자재기타출고 | `w_mat_other_issue_master` | srw | 미착수 |  |  |
| 258 | └ 자재출고취소 | `w_mat_mass_issue_cancel_master` | srw | 미착수 |  |  |
| 260 | MSL 이상품목 처리이력관리 | `w_mat_msl_item_check_master` | srw | 미착수 |  |  |
| 261 | 베이킹이력관리 | `w_mat_baking_dehumi_scan_master` | srw | 미착수 |  |  |
| 262 | 베이킹재고조회 | `w_mat_baking_scan_query` | srw | 미착수 |  |  |
| 263 | 진공포장재고조회 | `w_mat_vacuum_scan_query` | srw | 미착수 |  |  |
| 264 | 제습함재고조회 | `w_mat_dehumi_scan_query` | srw | 미착수 |  |  |
| 266 | SMT 공릴체크 | `w_smt_recycle_check_rpt` | pbg | 미착수 |  |  |

### 재고  `M_INVENTORY`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 268 | 현재고조회 | `w_mat_current_inventory_master` | pbg | 완료 | `MAT_CURRENT_INVENTORY` | `/material/current-inventory` |
| 269 | 총재고조회 | `w_mat_total_inventory_query` | srw | 미착수 |  |  |
| 271 | 자재재고마감 | `w_mat_inventory_close_report` | srw | 미착수 |  |  |
| 272 | 자재재고조사 | `w_mat_inventory_check_master` | srw | 미착수 |  |  |
| 274 | 자재바코드스캔실사 | `w_mat_barcode_check_master` | srw | 미착수 |  |  |

### 수리  `M_REPAIR`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 276 | 공정수리관리(PID) | `w_pln_product_pcb_repair_master` | srw | 미착수 |  |  |
| 278 | 공정폐기관리 | `w_pln_product_pcb_destroy_master` | srw | 미착수 |  |  |
| 280 | 수리자재신청 | `w_mat_request_master` | srw | 미착수 |  |  |
| 281 | 공정수리이력조회 | `w_pln_product_pcb_repair_query` | pbg | 완료 | `QC_REPAIR_HISTORY` | `/quality/repair-history` |

### 품질관리  `M_QC`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 283 | IQC 관리 | `w_qc_iqc_master` | pbg | 미착수 |  |  |
| 284 | IQC 이력등록관리 | `w_qc_iqc_inspect_history_master` | srw | 미착수 |  |  |
| 285 | PCB 이슈발생스캔관리 | `w_pln_product_pid_issue_scan_master` | srw | 미착수 |  |  |
| 287 | 재고통제관리 | `w_qc_inventory_hold_master` | srw | 미착수 |  |  |
| 288 | PID 홀딩관리 | `w_pln_product_barcode_holding` | srw | 미착수 |  |  |
| 289 | 품질이상발생관리 | `w_qc_notify_master` | srw | 미착수 |  |  |
| 290 | 품질알림관리 | `w_qc_eco_notify_master` | srw | 미착수 |  |  |
| 291 | 4M 이력관리 | `w_qc_4m_master` | srw | 미착수 |  |  |
| 293 | 공정품질검사이력관리 | `w_qc_workstage_inspect_data_master_es` | pbg | 미착수 |  |  |
| 294 | OQC 검사이력관리(PID) | `w_qc_oqc_inspect_history_master` | srw | 미착수 |  |  |
| 295 | OQC 검사이력관리(LOT) | `w_qc_oqc_inspect_history_4_lot_master` | srw | 미착수 |  |  |
| 297 | 온도상태조회 | `w_pln_product_tempreture_history_query` | pbg | 미착수 |  |  |

### 출하현황  `M_SHIPPING`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 299 | 제품포장관리(PID) | `w_prd_product_packing_create_master` | pbg | 미착수 |  |  |
| 300 | 제품포장관리(LOT) | `w_prd_product_packing_4_magazine_create_master` | srw | 미착수 |  |  |
| 302 | 제품입고관리(PID) | `w_prd_product_fg_receipt` | srw | 미착수 |  |  |
| 303 | 제품입고관리(LOT) | `w_prd_product_fg_4_magazine_receipt` | pbg | 미착수 |  |  |
| 304 | 제품입고관리 (모델단위) | `w_prd_product_fg_4_model_receipt` | srw | 미착수 |  |  |
| 306 | 파렛타이징 관리 | `w_prd_product_fg_palletizing` | srw | 미착수 |  |  |
| 307 | 제품출하관리 | `w_prd_product_fg_issue` | pbg | 미착수 |  |  |
| 308 | 제품출고관리 (모델단위) | `w_prd_product_fg_4_model_issue` | srw | 미착수 |  |  |
| 310 | 제품재고 | `w_prd_product_fg_inventory` | srw | 완료 | `PRD_CURRENT_INVENTORY` | `/product/current-inventory` |
| 311 | 제품패킹이력 | `w_prd_product_packing_history` | srw | 미착수 |  |  |

### 추적  `M_TRACKING`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 313 | 자재 제조번호 기준 추적 | `w_product_pid_tracking_rpt` | srw | 미착수 |  |  |
| 314 | 자재추적조회(동적) | `w_product_material_tracking_rpt` | srw | 미착수 |  |  |
| 315 | 자재사용이력조회 | `w_product_material_tracking_msl_rpt` | srw | 미착수 |  |  |
| 317 | 생산이력조회(PID) | `w_product_pid_tracking_fpcb_rpt` | srw | 미착수 |  |  |
| 318 | 생산이력조회(Run No) | `w_pln_product_barcode_tracking` | srw | 미착수 |  |  |
| 319 | 롯트추적조회(ALL) | `w_pln_product_all_barcode_tracking` | srw | 미착수 |  |  |
| 321 | 생산현황데쉬보드 | `w_com_production_status_dashboard` | srw | 미착수 |  |  |

### 조회  `M_QUERY`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 323 | PID 정보조회 | `w_pln_product_barcode_query` | srw | 미착수 |  |  |
| 324 | 마킹이력조회 | `w_pln_product_pcb_marking_query` | srw | 미착수 |  |  |
| 325 | PCB 투입 리스트조회 | `w_qc_pcb_input_scan_master` | srw | 미착수 |  |  |
| 327 | SMT 오장착 스캔 현황 조회 | `w_pln_product_pda_scan_query` | srw | 미착수 |  |  |
| 328 | PDA 검사오류내역조회 | `w_smt_plan_ng_check_master` | srw | 미착수 |  |  |
| 329 | SMT 피더별 모니터링 | `w_smt_plan_feeder_monitoring_master` | srw | 미착수 |  |  |
| 330 | SMT 제품실적센서이력조회 | `w_pln_product_sensor_actual_master` | srw | 미착수 |  |  |
| 331 | 마스크검사이력조회 | `w_mcn_jig_mask_check_history` | srw | 미착수 |  |  |
| 332 | 스퀴지검사이력조회 | `w_mcn_jig_squeeze_check_history` | srw | 미착수 |  |  |
| 333 | 자재 바코드 상태 조회 | `w_mat_barcode_status_report` | srw | 미착수 |  |  |
| 335 | NSNP 처리이력조회 | `w_pln_product_nsnp_history_query` | pbg | 미착수 |  |  |

### 리포트  `M_REPORT`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 338 | └ 폼목마스터리포트 | `w_des_item_master_rpt` | srw | 미착수 |  |  |
| 340 | └ 라인설비바코드 | `w_pln_line_barcode_rpt` | srw | 미착수 |  |  |
| 341 | └ 캐리어바코드 | `w_product_carrier_barcode` | srw | 미착수 |  |  |
| 343 | └ 설비리포트 | `w_mcn_machine_rpt` | srw | 미착수 |  |  |
| 344 | └ SMT PICKUP 리포트 | `w_smt_pickup_rate_rpt` | srw | 미착수 |  |  |
| 346 | └ 생산계획리포트 | `w_pln_master_plan_rpt` | srw | 미착수 |  |  |
| 347 | └ 런카드리포트 | `w_product_run_card_rpt` | srw | 미착수 |  |  |
| 348 | └ 제품 판매실적 | `w_prd_product_fg_issue_rpt` | srw | 미착수 |  |  |
| 350 | └ 공정재공조회 | `w_product_workstage_stock_rpt` | srw | 미착수 |  |  |
| 352 | └ 공정매거진조회 | `w_product_workstage_magazine_stock_rpt` | srw | 미착수 |  |  |
| 354 | └ S-PARTS입고리포트 | `w_mcn_mold_receipt_rpt` | srw | 미착수 |  |  |
| 355 | └ S-PARTS출고리포트 | `w_mcn_mold_issue_rpt` | srw | 미착수 |  |  |
| 357 | └ 지그리포트 | `w_mcn_jig_rpt` | srw | 미착수 |  |  |
| 358 | └ S-PARTS관리리포트 | `w_mcn_mold_rpt` | srw | 미착수 |  |  |
| 360 | └ 4M 변경이력 | `w_qc_4m_history_rpt` | srw | 미착수 |  |  |
| 362 | └ 자재전표바코드리포트 | `w_mat_receipt_issue_barcode_history_report` | srw | 미착수 |  |  |
| 363 | └ 자재입고리포트 | `w_mat_receipt_report` | srw | 미착수 |  |  |
| 364 | └ 자재입고합계리포트 | `w_mat_receipt_sum_report` | srw | 미착수 |  |  |
| 365 | └ 자재출고리포트 | `w_mat_issue_report` | srw | 미착수 |  |  |
| 366 | └ 자재출고합계리포트 | `w_mat_issue_sum_report` | srw | 미착수 |  |  |
| 367 | └ 자재랙이동리포트 | `w_mat_location_address_move_report` | srw | 미착수 |  |  |
| 368 | └ 자재장기재고리포트 | `w_mat_long_term_inventory_report` | srw | 미착수 |  |  |
| 369 | └ 재고리포트 | `w_mat_current_inventory_report` | srw | 미착수 |  |  |

### 승인  `M_CONFIRM`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 371 | 반출반입승인 | `w_com_carrying_out_bring_in_confirm` | srw | 미착수 |  |  |
| 372 | 반출반입승인(보안) | `w_com_carrying_out_bring_in_security` | srw | 미착수 |  |  |
| 373 | 구매단가승인 | `w_mat_buy_price_confirm` | srw | 미착수 |  |  |
| 374 | 판매단가승인 | `w_sal_sale_price_confirm` | srw | 미착수 |  |  |
| 375 | S-PARTS구매단가승인 | `w_mcn_mold_buy_price_confirm` | srw | 미착수 |  |  |
| 377 | 설계BOM승인 | `w_des_bom_confirm_master` | srw | 미착수 |  |  |

### 기본정보  `M_MANAGE`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 379 | 회사 | `w_company_master` | srw | 미착수 |  |  |
| 380 | 조직 | `w_organization_master` | srw | 미착수 |  |  |
| 381 | 부서 | `w_department_master` | srw | 미착수 |  |  |
| 382 | 사용자 | `w_user_master` | srw | 미착수 |  |  |
| 384 | 애플리케이션창 | `w_window_master` | srw | 미착수 |  |  |
| 385 | 역할 | `w_role_master` | srw | 미착수 |  |  |
| 387 | └ 프로그램사용권한 | `w_privilege_master` | srw | 미착수 |  |  |
| 389 | 메세지에이젼트 | `w_agent_message_master` | srw | 미착수 |  |  |
| 391 | 기초코드관리 | `w_basecode_master` | srw | 미착수 |  |  |
| 392 | 표준코드관리 | `w_standard_code_master` | srw | 미착수 |  |  |

### 시스템  `M_SYSTEM`

| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |
|---:|---|---|:--:|---|---|---|
| 395 | └ 언어텍스트관리 | `w_dual_language` | srw | 미착수 |  |  |
| 396 | └ 메세지텍스트관리 | `w_dual_message` | srw | 미착수 |  |  |
| 398 | └ 용어사전 | `w_word_dictionary` | srw | 미착수 |  |  |
| 400 | └ 윈도우언어변환대상찾기	Alt+F10 |  |  | 윈도우미상 |  |  |
| 401 | └ 메뉴언어변환대상찾기	Alt+F11 |  |  | 윈도우미상 |  |  |
| 403 | └ 시스템환경 | `w_system_config` | srw | 미착수 |  |  |
| 404 | └ 컬럼포맷	F12 | `w_col_info_popup` | srw | 미착수 |  |  |
| 405 | └ 재고마감일자설정 | `w_system_inventory_close_date_setup` | srw | 미착수 |  |  |
| 407 | └ 엔터키탭처럼사용안함 |  |  | 윈도우미상 |  |  |
| 408 | └ 행변경이벤트켜기 |  |  | 윈도우미상 |  |  |
| 410 | └ 언어즉시변경켜기 |  |  | 윈도우미상 |  |  |
| 412 | └ 메뉴재설정 |  |  | 윈도우미상 |  |  |
| 413 | └ 메뉴관리 | `w_menu_master` | srw | 미착수 |  |  |
| 415 | └ SQL 페인터 | `w_sql_painter` | srw | 미착수 |  |  |
| 416 | └ SQL보기 | `w_edit_window` | srw | 미착수 |  |  |
| 417 | └ 기초코드보기	Ctrl+F1 | `w_value_list_popup` | srw | 미착수 |  |  |
| 418 | └ 선택된데이타보기 | `w_edit_window` | srw | 미착수 |  |  |
| 419 | └ 데이타창보기 | `w_show_datawindow_popup` | srw | 미착수 |  |  |
| 420 | └ 테이블컬럼보기 | `w_table_description_rpt` | srw | 미착수 |  |  |
| 421 | └ 오브젝트보기 | `w_db_object_master` | srw | 미착수 |  |  |
| 423 | └ 인터페이스로그보기 |  |  | 윈도우미상 |  |  |
| 424 | └ 시스템오류내역보기 | `w_error_log_trace` | srw | 미착수 |  |  |
| 425 | └ 시스템사용내역 | `w_system_access_master` | srw | 미착수 |  |  |
| 428 | 수정모드켜기 |  |  | 윈도우미상 |  |  |
| 429 | 수정모드끄기 |  |  | 윈도우미상 |  |  |
| 431 | 오브젝트삭제 |  |  | 윈도우미상 |  |  |
| 433 | 라인가운데정렬 |  |  | 윈도우미상 |  |  |
| 435 | 위로정렬 |  |  | 윈도우미상 |  |  |
| 436 | 아래로정렬 |  |  | 윈도우미상 |  |  |
| 437 | 왼쪽정렬 |  |  | 윈도우미상 |  |  |
| 438 | 오른쪽정렬 |  |  | 윈도우미상 |  |  |
| 440 | 가로크기맞춤 |  |  | 윈도우미상 |  |  |
| 441 | 세로크기맞춤 |  |  | 윈도우미상 |  |  |
| 442 | SMT 공릴체크 |  |  | 윈도우미상 |  |  |
| 444 | 왼쪽맞춤 |  |  | 윈도우미상 |  |  |
| 445 | 가운데맞춤 |  |  | 윈도우미상 |  |  |
| 446 | 오른쪽맞춤 |  |  | 윈도우미상 |  |  |
| 448 | 박스보이기 |  |  | 윈도우미상 |  |  |
| 449 | 박스없애기 |  |  | 윈도우미상 |  |  |
| 450 | 그림자보기 |  |  | 윈도우미상 |  |  |
| 451 | └ 런타임데이타창생성 | `w_runtime_dw_generator` | srw | 미착수 |  |  |
| 452 | └ 리포트생성기 | `w_report_generator` | srw | 미착수 |  |  |
| 454 | └ 리포트관리 | `w_dataobject_master` | srw | 미착수 |  |  |
| 457 | IT 자산 현황 | `w_mcn_it_master` | srw | 미착수 |  |  |
| 459 | 리플로우상태조회 | `w_qc_interlock_reflow_status_master` | srw | 미착수 |  |  |
| 460 | 설비 픽업률조회 | `w_smt_pickup_rate_head` | pbg | 미착수 |  |  |
| 461 | SMT 픽업율(최종데이터조회) | `w_smt_pickup_rate_last_data_query` | srw | 미착수 |  |  |
| 463 | 자재전표엑셀업로드관리 | `w_mat_receipt_slip_excel_upload_master` | srw | 미착수 |  |  |
| 464 | 자재(대여/차용)전표등록관리 | `w_mat_receipt_slip_4_rental_borrowing_master` | srw | 미착수 |  |  |
| 465 | 자재(대여/차용상환)관리 | `w_mat_other_receipt_rental_borrowing_barcode_master` | srw | 미착수 |  |  |
| 466 | 자재릴합침관리 ( PCB ) | `w_mat_receipt_barcode_combine_master` | srw | 미착수 |  |  |
| 467 | 출고바코드반품(수리/리볼)관리 | `w_mat_other_issue_barcode_return_master` | srw | 미착수 |  |  |
| 468 | 자재요청조회 | `w_mat_material_request_master` | srw | 미착수 |  |  |
| 469 | 라인별 모니터링 | `w_smt_plan_feeder_monitoring_line_master` | srw | 미착수 |  |  |
| 471 | 자재요청관리 | `w_pln_workstage_material_receipt_check_master` | srw | 미착수 |  |  |
| 473 | 반품수리관리 | `w_sal_shipping_return_repair_master` | srw | 미착수 |  |  |
| 475 | 반제품바코드스캔실사 | `w_pln_barcode_check_master` | srw | 미착수 |  |  |
| 477 | 자재소요량관리 | `w_mat_requirment_plan_master` | srw | 미착수 |  |  |
| 478 | 자재발주계획 | `w_mat_purchase_order_plan_master` | srw | 미착수 |  |  |
| 480 | 자재주문예정관리 | `w_mat_forecast_order_master` | srw | 미착수 |  |  |
| 481 | 자재주문관리 | `w_mat_purchase_order_master` | srw | 미착수 |  |  |
| 483 | 자재출발관리 | `w_mat_departure_master` | srw | 미착수 |  |  |
| 484 | 자재도착관리 | `w_mat_arrival_master` | srw | 미착수 |  |  |
| 486 | 설비검사확인(스캔) | `w_qc_machine_inspect_manual` | srw | 미착수 |  |  |
| 487 | 고객컴플레인관리 | `w_customer_complaints_master` | srw | 미착수 |  |  |
| 488 | 이상발생 모니터링 | `w_pln_product_sound_history_query` | srw | 미착수 |  |  |
| 490 | SMT 파트라이브러리관리 | `w_smt_upload_partlib_master` | srw | 미착수 |  |  |
| 492 | 메탈마스크텐션 수동 관리 | `w_mcn_jig_mask_check_master` | srw | 미착수 |  |  |
| 493 | 픽스쳐검사관리 | `w_mcn_jig_fixture_check_master` | srw | 미착수 |  |  |
| 495 | 제품납품계획 | `w_pln_product_delivery_master` | srw | 미착수 |  |  |
| 496 | 포장바코드중복체크관리 | `w_pln_product_packing_dupulicate_check_master` | srw | 미착수 |  |  |
| 498 | 반출송장 | `w_com_carrying_out_master` | srw | 미착수 |  |  |
| 499 | 반입송장 | `w_com_bring_in_master` | srw | 미착수 |  |  |
| 501 | 워크오더추적조회 | `w_product_material_tracking_4_workorder_rpt` | srw | 미착수 |  |  |
| 502 | 자재추적조회(멀티/동적) | `w_product_material_tracking_multi_rpt` | srw | 미착수 |  |  |
| 503 | 제품 추적 조회 | `w_product_material_tracking_history_rpt` | srw | 미착수 |  |  |

## 부록 A — 윈도우 미상 26건

`MENU_TAG` 도 비었고 `.srm` 의 `clicked` 이벤트에도 `Opensheet` 호출이 없는 항목. 대부분 화면이 아니라 PB 개발자용 레이아웃 편집 토글이다.

| 대분류 | 메뉴명 | `MENU_ITEM_NAME` |
|---|---|---|
| 설비 | AOI 검사결과조회 | `M_AOITIMEQUERY` |
| 설비 | AE-EV BUSBAR Result Query | `M_AE-EVBUSBARRESULTQUERY` |
| 시스템 | 윈도우언어변환대상찾기	Alt+F10 | `M_FINDWINDOWLANGUAGESOURCE` |
| 시스템 | 메뉴언어변환대상찾기	Alt+F11 | `M_FINDMENULANGUAGESOURCE` |
| 시스템 | 엔터키탭처럼사용안함 | `M_ENTERTOTABON` |
| 시스템 | 행변경이벤트켜기 | `M_ROWFOCUSCHANGEON` |
| 시스템 | 언어즉시변경켜기 | `M_LANGUAGEDIRECTCHANGOFF` |
| 시스템 | 메뉴재설정 | `M_MENURELOAD` |
| 시스템 | 인터페이스로그보기 | `M_SHOWINTERFACELOG` |
| 시스템 | 수정모드켜기 | `M_EDITMODEON` |
| 시스템 | 수정모드끄기 | `M_EDITMODEOFF` |
| 시스템 | 오브젝트삭제 | `M_DESTORYOBJECT` |
| 시스템 | 라인가운데정렬 | `M_ALIGNLINECENTER` |
| 시스템 | 위로정렬 | `M_ALIGNTOP` |
| 시스템 | 아래로정렬 | `M_ALIGNBOTTOM` |
| 시스템 | 왼쪽정렬 | `M_ALIGNLEFT` |
| 시스템 | 오른쪽정렬 | `M_ALIGNRIGHT` |
| 시스템 | 가로크기맞춤 | `M_SIZEWIDTHS` |
| 시스템 | 세로크기맞춤 | `M_SIZEHEIGHT` |
| 시스템 | SMT 공릴체크 | `M_CHEKCRECYCLEREEL` |
| 시스템 | 왼쪽맞춤 | `M_ADJUSTLEFT` |
| 시스템 | 가운데맞춤 | `M_ADJUSTCENTER` |
| 시스템 | 오른쪽맞춤 | `M_ADJUSTRIGHT` |
| 시스템 | 박스보이기 | `M_SHOWBOLDER0` |
| 시스템 | 박스없애기 | `M_SHOWNOBOLDER` |
| 시스템 | 그림자보기 | `M_SHOWSHADOW` |

## 부록 B — DB `MENU_TAG` ≠ 실행 코드 7건

**실행 코드가 정본**이다.

| 대분류 | 메뉴명 | DB `MENU_TAG` | 실제 실행(`.srm`) |
|---|---|---|---|
| 기준정보 | 제품모델관리 | `w_pln_product_model_master` | `w_pln_product_model_simple_master` |
| 공정 | 매거진라벨 발행 | `w_pln_product_magazine_label_master` | `w_pln_product_magazine_label_master2` |
| 품질관리 | 공정품질검사이력관리 | `w_qc_workstage_inspect_data_master` | `w_qc_workstage_inspect_data_master_es` |
| 리포트 | 라인설비바코드 | `w_barcode_rpt` | `w_pln_line_barcode_rpt` |
| 리포트 | 생산계획리포트 | `w_pln_master_plan_report` | `w_pln_master_plan_rpt` |
| 시스템 | 설비 픽업률조회 | `w_smt_pickup_rate` | `w_smt_pickup_rate_head` |
| 시스템 | 자재주문관리 | `w_mat_purchase_order_plan_master` | `w_mat_purchase_order_master` |

## 부록 C — `.srw` 미export 23건

PBL 안에는 있으나 `.srw` 미export. 이관 착수 전 PBORCA export가 필요하다.

| 메뉴명 | 윈도우 | 소속 PBL |
|---|---|---|
| 품목관리 | `w_des_item_master` | `infinity21_uw_com.pbl` |
| SMT 계획배포관리 | `w_smt_plan_master` | `infinity21_uw_smt.pbl` |
| 설비수리이력관리 | `w_mcn_machine_repair_request_master` | `infinity21_uw_mac.pbl` |
| AOI 검사결과조회 | `w_aoi_header_detail_query` | `infinity21_uw_iqc.pbl` |
| 지그마스터 | `w_mcn_jig_master` | `infinity21_uw_mac.pbl` |
| 메탈마스크텐션관리 | `w_mcn_jig_mask_tension_check_master` | `infinity21_uw_mac.pbl` |
| 스퀴지검사관리 | `w_mcn_jig_squeeze_clean_check_master` | `infinity21_uw_mac.pbl` |
| 반제품생산계획 | `w_pln_assembly_master_plan_master` | `infinity21_uw_pln.pbl` |
| 매거진라벨 발행 | `w_pln_product_magazine_label_master2` | `infinity21_uw_pln.pbl` |
| 자재바코드입고관리 | `w_mat_other_receipt_barcode_master` | `infinity21_uw_mat.pbl` |
| 자재분할관리 | `w_mat_receipt_barcode_divide_master` | `infinity21_uw_mat.pbl` |
| 자재입출고수불원장 | `w_mat_ledger_report` | `infinity21_uw_mat.pbl` |
| SMT 공릴체크 | `w_smt_recycle_check_rpt` | `infinity21_urw_com.pbl` |
| 현재고조회 | `w_mat_current_inventory_master` | `infinity21_uw_mat.pbl` |
| 공정수리이력조회 | `w_pln_product_pcb_repair_query` | `infinity21_uw_pln.pbl` |
| IQC 관리 | `w_qc_iqc_master` | `infinity21_uw_iqc.pbl` |
| 공정품질검사이력관리 | `w_qc_workstage_inspect_data_master_es` | `infinity21_uw_iqc.pbl` |
| 온도상태조회 | `w_pln_product_tempreture_history_query` | `infinity21_uw_pln.pbl` |
| 제품포장관리(PID) | `w_prd_product_packing_create_master` | `infinity21_uw_pln.pbl` |
| 제품입고관리(LOT) | `w_prd_product_fg_4_magazine_receipt` | `infinity21_uw_pln.pbl` |
| 제품출하관리 | `w_prd_product_fg_issue` | `infinity21_uw_pln.pbl` |
| NSNP 처리이력조회 | `w_pln_product_nsnp_history_query` | `infinity21_uw_pln.pbl` |
| 설비 픽업률조회 | `w_smt_pickup_rate_head` | `infinity21_uw_smt.pbl` |

## 갱신 이력

- 2026-09-21 최초 작성. `.srm` 파서가 아이템 블록을 `on m_x.create/destroy` 에서 끊어 그 뒤의 `event clicked` 를 놓쳤고, 아이템명의 하이픈(`m_-38`)을 정규식이 거부했다. 그 결과 윈도우 206건만 추출돼 '윈도우 미상'을 35건으로 과다 집계했다.
- 2026-09-21 정정. 블록 경계를 다음 `type ... from menu within` 선언까지로 바꾸고 하이픈을 허용해 재추출했다. 윈도우 292건 확보, 업무 화면 기준 미상은 26건(대부분 PB 편집 토글)으로 줄었다. 태그 불일치는 4→7건으로 늘었다.
- 2026-09-21 `MAT_RECEIPT_CANCEL`(자재입고취소) 이관 완료. 화면·사이드바·조회 2모드 브라우저 확인, `MENU_CATEGORY_ITEMS` 등록 확인. `IM_ITEM_RECEIPT` 가 전 조직 0건이라 취소 DML 은 SQL 파싱까지만 검증됨.
- 2026-09-22 `QC_REPAIR_HISTORY`(공정수리이력조회) 이관 완료. 원본은 별도 윈도우 `w_pln_product_pcb_repair_query` 가 아니라 `w_pln_product_pcb_repair_master` 의 dw_3("Repair History", `d_pln_product_work_qc_hst`) 를 이식했다 — 같은 이력 조회다. 조회 전용이며 master 의 수리접수·저장·출고(DML)는 미이식. 실데이터 2,423건으로 검증.
