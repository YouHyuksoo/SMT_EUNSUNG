# PowerBuilder 메뉴·화면 등록 현황

- 기준 DB: EUNSUNG_DEV_ESDBPDB
- 조직: 1
- 기준일: 2026-08-25
- 원본 화면: `w_menu_master.srw` / DataWindow `d_dynamic_menu`

## 요약

- 동적 메뉴: 522행, 메뉴 오브젝트 1개
- 화면 태그: 231행, 고유 태그 228개
- 화면 마스터: 557개
- 메뉴 태그와 화면 마스터 일치: 228행 / 고유 화면 225개
- 불일치 태그: 3행
- 메뉴에 없는 화면 마스터: 332개

<!-- MAIN_TABLE_SUMMARY:START -->
- 메인 DB 테이블 자동 확인: 단일 193행, 복수 6행
- 확인 보류: 동적 1행, DB 소스 없음 5행, 소스 미확인 26행
<!-- MAIN_TABLE_SUMMARY:END -->

## 최상위 메뉴

| 최상위 메뉴 | 전체 항목 | 화면 태그 | 화면 일치 | 불일치 |
|---|---:|---:|---:|---:|
| 화일 | 61 | 1 | 0 | 1 |
| 수정 | 23 | 0 | 0 | 0 |
| 조작 | 33 | 0 | 0 | 0 |
| 기준정보 | 26 | 19 | 19 | 0 |
| 설계 | 6 | 5 | 5 | 0 |
| SMT | 13 | 9 | 9 | 0 |
| 설비 | 22 | 14 | 14 | 0 |
| 지그 | 16 | 12 | 12 | 0 |
| 피더 | 5 | 4 | 4 | 0 |
| S-PARTS | 11 | 8 | 8 | 0 |
| 생산 | 10 | 7 | 7 | 0 |
| 공정 | 8 | 5 | 5 | 0 |
| 자재창고 | 33 | 19 | 19 | 0 |
| 재고 | 8 | 5 | 5 | 0 |
| 수리 | 7 | 3 | 3 | 0 |
| 품질관리 | 16 | 13 | 13 | 0 |
| 출하현황 | 14 | 8 | 8 | 0 |
| 추적 | 10 | 7 | 7 | 0 |
| 조회 | 14 | 10 | 10 | 0 |
| 리포트 | 34 | 19 | 17 | 2 |
| 승인 | 8 | 6 | 6 | 0 |
| 기본정보 | 15 | 10 | 10 | 0 |
| 시스템 | 112 | 43 | 43 | 0 |
| 윈도우 | 7 | 0 | 0 | 0 |
| 도움말 | 10 | 4 | 4 | 0 |

## 불일치 화면 태그

| 순서 | 메뉴 경로 | 메뉴 항목명 | MENU_TAG |
|---:|---|---|---|
| 11 | 화일 > 언어변경 > 中国语 | M_CHINESS | Chinese |
| 340 | 리포트 > 바코드 > 라인설비바코드 | M_LINEBARCODE | w_barcode_rpt |
| 346 | 리포트 > 제품 > 생산계획리포트 | M_PRODUCTMASTERPLANREPORT | w_pln_master_plan_report |

## 중복 화면 태그

| MENU_TAG | 메뉴 사용 횟수 |
|---|---:|
| W_MCN_MACHINE_PM_MASTER | 2 |
| W_QC_4M_MASTER | 2 |
| W_MAT_PURCHASE_ORDER_PLAN_MASTER | 2 |

## 메뉴별 화면 목록

### 화일

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 11 | 화일 > 언어변경 > 中国语 | M_CHINESS | Chinese |  | 소스 미확인 | UNMATCHED |

### 기준정보

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 119 | 기준정보 > 고객관리 | M_CUSTOMERMASTER | w_com_customer_master | 고객관리 | `ICOM_CUSTOMER` | MATCHED |
| 120 | 기준정보 > 협력사관리 | M_SUPPLIERMASTER | w_com_supplier_master | 협력사관리 | `ICOM_SUPPLIER` | MATCHED |
| 122 | 기준정보 > 품목관리 | M_ITEMMASTER | w_des_item_master | 품목관리 | 소스 미확인 | MATCHED |
| 123 | 기준정보 > 제품모델관리 | M_PRODUCTMODELMASTER | w_pln_product_model_master | 승인원의모델에 대한 특성을 관리 | `IP_PRODUCT_MODEL_MASTER` | MATCHED |
| 124 | 기준정보 > 품목(공급상)관리 | M_MATEIALMASTER | w_mat_item_master | 품목(공급상)관리 | `IM_ITEM_MASTER` | MATCHED |
| 125 | 기준정보 > LED RANK 관리 | M_LEDRANKMASTER | w_com_mat_rank_master | LED RANK 관리 | `IM_ITEM_RANK_MASTER` | MATCHED |
| 126 | 기준정보 > 환율관리 | M_1 | w_com_exchange_rate_master | EXCHANGE RATE MASTER WINDOW | `ICOM_EXCHANGE_RATE` | MATCHED |
| 128 | 기준정보 > 제품류관리 | M_PRODUCTCLASSMASTER | w_des_product_class_master | 제품류관리 | `ID_PRODUCT_CLASS` | MATCHED |
| 129 | 기준정보 > 라인관리 | M_PRODUCTLINEMASTER | w_pln_line_master | 라인관리 | `IP_PRODUCT_LINE` | MATCHED |
| 130 | 기준정보 > 공정관리마스터 | M_PRODUCTWOKSTAGEMASTER | w_pln_workstage_master | 공정관리마스터 | `IP_PRODUCT_WORKSTAGE` | MATCHED |
| 131 | 기준정보 > 모델별 ST관리 | M_PRODUCTSTMASTER | w_pln_product_model_st_master | 모델별 ST관리 | `IP_PRODUCT_MODEL_ST_MASTER` | MATCHED |
| 132 | 기준정보 > 생산월력 | M_PRODUCTCARENDAR | w_pln_product_calendar | 생산월력 | `IP_PRODUCT_WORK_TIME`, `IP_PRODUCT_YEAR_BASE` | MATCHED |
| 133 | 기준정보 > 생산라인보유공수관리 | M_20 | w_pln_line_capacity_master | 생산라인보유공수관리 | `IP_PRODUCT_DAILY_LINE_CAPACITY` | MATCHED |
| 134 | 기준정보 > 제품별 라벨양식 관리 | M_PRODUCTLABELMASTER | w_product_label_master | 제품별 라벨양식 관리 | `ISYS_LABEL_FORM` | MATCHED |
| 135 | 기준정보 > 문서관리 | M_DOCUMENTMASTER | w_com_document_master | 문서관리 | `ICOM_DOCUMENT` | MATCHED |
| 137 | 기준정보 > 인터락조건관리 | M_INTERLOCKINSEPCTCONDITIONMASTER | w_com_interlock_inspect_condition_master | 인터락조건관리 | `IQ_INTERLOCK_CHECK_CONDITION` | MATCHED |
| 140 | 기준정보 > 풀체크시간관리 | M_FULLCHECKTIMEMASTER | w_com_full_check_time_master | 풀체크시간관리 | `IB_SMT_FULLCHECK_TIME` | MATCHED |
| 142 | 기준정보 > 자재구매단가 | M_MATERIALPRICEMASTER | w_mat_buy_price_master | 자재구매단가 | `IM_ITEM_UNIT_PRICE` | MATCHED |
| 143 | 기준정보 > 제(상)품판매단가 | M_PRODUCTSALEPRICE | w_sal_sale_price_master | 제(상)품판매단가 | `IS_PRODUCT_SALE_PRICE` | MATCHED |

### 설계

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 145 | 설계 > 설계BOM관리 | M_BOMMASTER | w_des_bom_modify_master | 설계BOM관리 | `ID_ENG_BOM` | MATCHED |
| 146 | 설계 > 제조BOM관리 | M_MFSBOMMASTER | w_des_mfs_bom_master | BOM 수정관리 | `ID_MFS_BOM` | MATCHED |
| 147 | 설계 > 대체BOM관리 | M_ENGBOMREPLACEMASTER | w_des_replace_bom_master | 대체BOM관리 | `ID_ITEM_REPLACE` | MATCHED |
| 148 | 설계 > 원단위BOM마스터 | M_ENGBOMRAWMASTER | w_des_raw_bom_master | 원단위BOM마스터 | `ID_ENG_BOM` | MATCHED |
| 149 | 설계 > 적용모델관리 | M_APPLYMODELMASTER | w_des_apply_item_master | 적용모델관리 | `ID_ITEM` | MATCHED |

### SMT

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 151 | SMT > SMT 라인관리 | M_SMTLINEMASTER | w_smt_line_master | SMT 라인관리 | `IB_MACHINE_LOCATION` | MATCHED |
| 152 | SMT > 라인별 테이블 관리 | M_SMTLOCATIONMASTER | w_smt_location_master | 라인별 테이블 관리 | `IB_MACHINE_LOCATION` | MATCHED |
| 153 | SMT > SMT BOM 대체관리 | M_SMTBOMREPLACEMASTER | w_smt_bom_replace_master | SMT BOM 대체관리 | `ID_ENG_BOM_SMT_REPLACE` | MATCHED |
| 155 | SMT > SMT 피더레이아웃 등록 | M_SMTUPLOADNCMASTER | w_smt_upload_nc_master | SMT 피더레이아웃 등록 | `IB_MNT_YAMAHA_CSV`, `IB_MNT_PLANDATA` | MATCHED |
| 156 | SMT > SMT BOM 관리 | M_MESBOMMASTER | w_smt_bom_create_master | SMT BOM 관리 | `ID_ENG_BOM_SMT` | MATCHED |
| 157 | SMT > SMT 계획배포관리 | M_SMTPLANDATA | w_smt_plan_master | SMT 계획배포관리 | 소스 미확인 | MATCHED |
| 159 | SMT > SMT BOM 관리리포트 | M_SMTBOMMASTERREPORT | w_smt_bom_master_rpt | SMT BOM 관리리포트 | `IB_PRODUCT_PLANDATA` | MATCHED |
| 160 | SMT > 피더레이아웃 비교 | M_SMTBOMCOMPARISIONREPORT | w_smt_bom_comparison_master_rpt | 피더레이아웃 비교 | `ID_ENG_BOM_SMT` | MATCHED |
| 162 | SMT > 마운터 픽업정보관리 | M_MOUNTPICKUPMASTER0 | w_mcn_feeder_pickup_master | 피더 낙점율 관리 | `IQ_MACHINE_INSPECT_DATA_PICKUP` | MATCHED |

### 설비

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 164 | 설비 > 설비자주보전관리 | M_MACHINEPMMASTER | w_mcn_machine_pm_master | 설비자주보전관리 | `IMCN_MACHINE_PM_MASTER` | MATCHED |
| 165 | 설비 > 설비관리 | M_MACHINEMASTER | w_mcn_machine_master | 설비관리 | `IMCN_MACHINE` | MATCHED |
| 166 | 설비 > 설비수리이력관리 | M_MACHINEREPAIRREQUESTMASTER | w_mcn_machine_repair_request_master | 설비수리이력관리 | 소스 미확인 | MATCHED |
| 167 | 설비 > 설비수리관리 | M_MACHINEREPAIRMASTER | w_mcn_machine_repair_master | 설비수리관리 | `IMCN_MACHINE_REPAIR` | MATCHED |
| 168 | 설비 > 설비자주보전관리 | M_MACHINEPMMASTER0 | w_mcn_machine_pm_master | 설비자주보전관리 | `IMCN_MACHINE_PM_MASTER` | MATCHED |
| 169 | 설비 > 설비일일운행관리 | M_MACHINELOSSMASTER | w_mcn_machine_daily_operation | 설비일일운행관리 | `IMCN_MACHINE_DAILY_OPERATION` | MATCHED |
| 171 | 설비 > SP 작업결과조회 | M_SPRESULTQUERY | w_qc_machine_inspect_data_sp_query | SP 작업결과조회 | `IQ_MACHINE_INSPECT_DATA_SP` | MATCHED |
| 172 | 설비 > SPI 검사결과조회 | M_SPITIMEQUERY | w_spi_time_query | SPI 검사결과조회 | `IQ_MACHINE_INSPECT_DATA_SPI` | MATCHED |
| 173 | 설비 > ICT 검사결과조회 | M_IICTRESULTQUERY | w_qc_machine_inspect_data_ict_query | ICT 검사결과조회 | `IQ_MACHINE_INSPECT_DATA_ICT` | MATCHED |
| 174 | 설비 > AOI 검사결과조회 | M_AOIRESULTQUERY | w_aoi_header_detail_query | AOI 검사결과조회 | 소스 미확인 | MATCHED |
| 175 | 설비 > Router작업결과조회 | M_ROUTERRSULTQUERY | w_qc_machine_inspect_data_rt_query | ROUTER 작업결과조회 | `IQ_MACHINE_INSPECT_DATA_RT` | MATCHED |
| 180 | 설비 > EOL Result Query | M_EOLRESULTQUERY | w_qc_machine_inspect_data_eol_query | EOL | `IQ_MACHINE_INSPECT_DATA_EOL` | MATCHED |
| 181 | 설비 > BMA Result Query | M_BMARESULTQUERY | w_qc_machine_inspect_data_bma_query | BMA | `IQ_MACHINE_INSPECT_DATA_BMA` | MATCHED |
| 183 | 설비 > 라인/설비일일운행일지 | M_LINEMACHINEDAILYOPERATIONREPORT | w_line_machine_daily_operation_rpt | 라인/설비일일운행일지 | `IMCN_MACHINE` | MATCHED |

### 지그

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 185 | 지그 > 지그마스터 | M_JIGMASTER | w_mcn_jig_master | 지그마스터 | 소스 미확인 | MATCHED |
| 186 | 지그 > 지그출고관리 | M_JIGISSUEMASTER | w_mcn_jig_issue_master | 지그출고관리 | `IMCN_JIG` | MATCHED |
| 187 | 지그 > 지그수리신청 | M_JIGREPAIRREQUESTMASTER | w_mcn_jig_repair_request_master | 지그수리신청 | `IMCN_JIG_REPAIR` | MATCHED |
| 188 | 지그 > 지그수리관리 | M_JIGREPAIRMASTER | w_mcn_jig_repair_master | 지그수리관리 | `IMCN_JIG_REPAIR` | MATCHED |
| 189 | 지그 > 지그자주보전관리 | M_JIGPMMASTER | w_mcn_jig_pm_master | 지그자주보전관리 | `IMCN_JIG_PM_MASTER_HIST` | MATCHED |
| 191 | 지그 > 지그마스터 투입이력조회 | M_JIGINPUTHISTORY | w_mcn_jig_input_history_master | 지그마스터 투입이력조회 | `IMCN_JIG_INPUT_HIST` | MATCHED |
| 193 | 지그 > 스퀴즈검사관리 | M_JIGSQUEEZECHECKMASTER | w_mcn_jig_squeeze_check_master | 금형검사이력관리 | `IMCN_JIG` | MATCHED |
| 194 | 지그 > 메탈마스크텐션관리 | M_MASKTENSIONCHECKMASTER | w_mcn_jig_mask_tension_check_master | 메탈마스크텐션관리 | 소스 미확인 | MATCHED |
| 195 | 지그 > 스퀴지검사관리 | M_SQUEEZECLEANCHECKMASTER | w_mcn_jig_squeeze_clean_check_master | 스퀴지검사관리 | 소스 미확인 | MATCHED |
| 197 | 지그 > 샘플마스터 관리 | M_SAMPLEMASTER | w_mcn_sample_master | 샘플마스터 관리 | `IMCN_SAMPLE` | MATCHED |
| 198 | 지그 > 샘플마스터 장착이력조회 | M_SAMPLEINPUTHISTORY | w_mcn_sample_input_history_master | 샘플마스터 장착이력조회 | `IMCN_SAMPLE_INPUT_HIST` | MATCHED |
| 199 | 지그 > 샘플마스터 투입이력조회 | M_SAMPLEINPUTHISTORY0 | w_mcn_sample_bcr_input_history_master | 샘플마스터 투입이력조회 | `IMCN_SAMPLE_BCR_INPUT_HIST` | MATCHED |

### 피더

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 201 | 피더 > 피더관리 | M_FEEDERMASTER | w_mcn_feeder_master | 피더관리 | `IMCN_JIG` | MATCHED |
| 202 | 피더 > 피더수리신청 | M_FEEDERREPAIRREQUESTMASTER | w_mcn_feeder_repair_request_master | 피더수리신청 | `IMCN_JIG_REPAIR` | MATCHED |
| 203 | 피더 > 피더수리관리 | M_FEEDERREPAIRMASTER | w_mcn_feeder_repair_master | 피더수리관리 | `IMCN_JIG_REPAIR` | MATCHED |
| 204 | 피더 > 피더교정관리 | M_JIGFEEDERADJUST | w_mcn_jig_feeder_adjust_master | 피더교정관리 | `IMCN_JIG` | MATCHED |

### S-PARTS

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 206 | S-PARTS > S-PARTS관리 | M_MOLDMASTER | w_mcn_mold_master | CUSTOMER INFROMATION MANAGE | `IMCN_MOLD` | MATCHED |
| 207 | S-PARTS > S-PARTS주문관리 | M_MOLDPURCHASEORDERMASTER | w_mcn_mold_purchase_order_master | MATERIAL PURCHASE ORDER MASTER | `IMCN_MOLD_PURCHASE_ORDER` | MATCHED |
| 208 | S-PARTS > S-PARTS입고관리 | M_MOLDRECEIPTMASTER | w_mcn_mold_receipt_master | MATERIAL RECEIPT MASTER | `IMCN_MOLD_RECEIPT` | MATCHED |
| 209 | S-PARTS > S-PARTS출고관리 | M_MOLDISSUEMASTER | w_mcn_mold_issue_master | MATERIAL RECEIPT MASTER | `IMCN_MOLD_ISSUE` | MATCHED |
| 210 | S-PARTS > S-PARTS재고관리 | M_MOLDINVENTORYMASTER | w_mcn_mold_inventory_master | CUSTOMER INFROMATION MANAGE | `IMCN_MOLD_REQUEST` | MATCHED |
| 212 | S-PARTS > S-PARTS수리신청관리 | M_MOLDREPAIRREQUESTMASTER | w_mcn_mold_repair_request_master | MATERIAL RECEIPT MASTER | `IMCN_MOLD_REPAIR` | MATCHED |
| 213 | S-PARTS > S-PARTS수리관리 | M_MOLDREPAIRMASTER | w_mcn_mold_repair_master | MATERIAL RECEIPT MASTER | `IMCN_MOLD_REPAIR` | MATCHED |
| 215 | S-PARTS > S-PARTS구매단가관리 | M_MOLDUNITPRICEMASTER | w_mcn_mold_buy_price_master | CUSTOMER INFROMATION MANAGE | `IMCN_MOLD_UNIT_PRICE` | MATCHED |

### 생산

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 217 | 생산 > 제품생산계획 | M_PRODUCTMASTERPLAN | w_pln_product_master_plan_master | 제품생산계획 | 소스 미확인 | MATCHED |
| 218 | 생산 > 반제품생산계획 | M_ASSEMBLYMASERPLAN | w_pln_assembly_master_plan_master | 반제품생산계획 | 소스 미확인 | MATCHED |
| 219 | 생산 > 반제품생산실적관리 | M_ASSEMBLYACTUALMASTER | w_pln_assembly_actual_master | 반제품생산실적관리 | `IP_PRODUCT_SENSOR_ACTUAL_TIME` | MATCHED |
| 221 | 생산 > 롯트카드관리 | M_MASTERPLAN | w_product_run_card_duckil | 롯트카드관리 | 소스 미확인 | MATCHED |
| 222 | 생산 > 롯트카드-PID 매핑관리 | M_PCBPIDINSPECTSCANMASTER | w_pln_product_pcb_kitting_scan_master | LINE MASTER | `IP_PRODUCT_2D_BARCODE` | MATCHED |
| 224 | 생산 > 기간별 생산실적 조회 | M_PRODUCTIONRESULTS | w_pln_product_pcb_result_query | 기간별 생산실적 조회 | `IP_PRODUCT_WORKSTAGE_IO` | MATCHED |
| 225 | 생산 > 생산일보 리포트 | M_DAILYPRODUCTIONREPORT | w_pln_product_pcb_result_report | 생산일보 리포트 | `IP_PRODUCT_RUN_CARD` | MATCHED |

### 공정

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 227 | 공정 > 제품공정인아웃스캔관리 | M_PRODUCWORKSTAGEINOUTSCANMASTER | w_pln_product_inout_scan_master | 제품공정인아웃스캔관리 | `IP_PRODUCT_WORKSTAGE_IO` | MATCHED |
| 229 | 공정 > 매거진라벨 발행 | M_SMTMAGEZINELABELMASTER | w_pln_product_magazine_label_master | 매거진라벨 발행 | `IP_PRODUCT_RUN_CARD_IO` | MATCHED |
| 230 | 공정 > 매거진라벨 분할 | M_MAGAZINELABELSPLITMASTER | w_pln_product_magazine_label_split_master | 매거진라벨 분할 | `IP_PRODUCT_RUN_CARD_IO` | MATCHED |
| 231 | 공정 > 매거진-PID 매핑관리 | M_PIDCREATEMATER | w_pln_product_barcode_create_master | 매거진-PID 매핑관리 | `IP_PRODUCT_2D_BARCODE` | MATCHED |
| 233 | 공정 > 매거진라벨이력조회 | M_MAGAZINELABELQUERY | w_pln_product_magazine_label_query | 매거진라벨이력조회 | `IP_PRODUCT_RUN_CARD_IO` | MATCHED |

### 자재창고

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 235 | 자재창고 > 자재입고전표관리 | M_19 | w_mat_receipt_slip_master | 자재입고전표관리 | 소스 미확인 | MATCHED |
| 239 | 자재창고 > IMD 라인 자재투입관리 | M_MANUALINPUTMATERIAL | w_mat_manual_input_history_query | IMD 라인 자재투입관리 | `IM_ITEM_MANUAL_INPUT_HISTORY` | MATCHED |
| 240 | 자재창고 > 자재분할관리 | M_49 | w_mat_receipt_barcode_divide_master | 자재분할관리 | 소스 미확인 | MATCHED |
| 241 | 자재창고 > 자재바코드재발행 | M_MATERIALBARCODEREPRINT | w_mat_receipt_barcode_reprint_master | 자재바코드재발행 | `IM_ITEM_RECEIPT_BARCODE` | MATCHED |
| 243 | 자재창고 > 솔더라벨 발행 | M_SOLDERLABELPRINT | w_mat_receipt_slip_master_onetek_solder | 솔더라벨 발행 | `IM_ITEM_RECEIPT_BARCODE` | MATCHED |
| 244 | 자재창고 > 솔더입출고조회 | M_SOLDERRECEIPTISSUEQUERY | w_mat_solder_receipt_issue_master | 솔더입출고조회 | `IM_ITEM_SOLDER_MASTER` | MATCHED |
| 245 | 자재창고 > 솔더라인투입이력조회 | M_SOLDERINPUTHISTORY | w_mat_solder_input_move_query | 솔더라인투입이력조회 | `IM_ITEM_SOLDER_MASTER` | MATCHED |
| 247 | 자재창고 > 자재입출고수불원장 | M_45 | w_mat_ledger_report | 자재입출고수불원장 | 소스 미확인 | MATCHED |
| 250 | 자재창고 > 바코드 > 출고바코드반품(양산/벌크)관리 | M_61 | w_mat_other_mass_issue_barcode_return_master | MATERIAL MASS ISSUE RETURN MASTER | `IM_ITEM_RECEIPT_BARCODE` | MATCHED |
| 253 | 자재창고 > 정상 > 자재입고관리 | M_30 | w_mat_receipt_master | 자재입고관리 | `IM_ITEM_RECEIPT` | MATCHED |
| 254 | 자재창고 > 정상 > 자재기타입고관리 | M_31 | w_mat_other_receipt_master | 자재기타입고관리 | `IM_ITEM_RECEIPT` | MATCHED |
| 257 | 자재창고 > 정상 > 자재기타출고 | M_52 | w_mat_other_issue_master | 자재기타출고 | `IM_ITEM_ISSUE` | MATCHED |
| 258 | 자재창고 > 정상 > 자재출고취소 | M_56 | w_mat_mass_issue_cancel_master | 자재출고취소 | `IM_ITEM_ISSUE` | MATCHED |
| 260 | 자재창고 > MSL 이상품목 처리이력관리 | M_MSLITEMCHECKMASTER | w_mat_msl_item_check_master | MSL 이상품목 처리이력관리 | `IM_ITEM_MSL_CHECK_MASTER` | MATCHED |
| 261 | 자재창고 > 베이킹이력관리 | M_BAKINGHISTORYQUERY | w_mat_baking_dehumi_scan_master | 베이킹이력관리 | `IM_ITEM_BAKING_MASTER` | MATCHED |
| 262 | 자재창고 > 베이킹재고조회 | M_BAKINGSTOCKQUERY | w_mat_baking_scan_query | 베이킹재고조회 | `IM_ITEM_BAKING_MASTER` | MATCHED |
| 263 | 자재창고 > 진공포장재고조회 | M_VACUUMSTOCKQUERY | w_mat_vacuum_scan_query | 진공포장재고조회 | `IM_ITEM_BAKING_MASTER` | MATCHED |
| 264 | 자재창고 > 제습함재고조회 | M_DEHUMISTOCKQUERY | w_mat_dehumi_scan_query | 제습함재고조회 | `IM_ITEM_BAKING_MASTER` | MATCHED |
| 266 | 자재창고 > SMT 공릴체크 | M_CHECKRECYCLEREEL | w_smt_recycle_check_rpt | SMT 공릴체크 | 소스 미확인 | MATCHED |

### 재고

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 268 | 재고 > 현재고조회 | M_CURRENTINVENTORYQUERY | w_mat_current_inventory_master | 현재고조회 | 소스 미확인 | MATCHED |
| 269 | 재고 > 총재고조회 | M_TOTALINVENTORYQUERY | w_mat_total_inventory_query | 총재고조회 | `ID_ITEM` | MATCHED |
| 271 | 재고 > 자재재고마감 | M_62 | w_mat_inventory_close_report | 자재재고마감 | `IM_ITEM_INVENTORY_CLOSE_MFS` | MATCHED |
| 272 | 재고 > 자재재고조사 | M_63 | w_mat_inventory_check_master | 자재재고조사 | `IM_ITEM_INVENTORY_CHECK` | MATCHED |
| 274 | 재고 > 자재바코드스캔실사 | M_64 | w_mat_barcode_check_master | MATERIAL MASS ISSUE RETURN MASTER | `IM_ITEM_INVENTORY_CHECK_BCD` | MATCHED |

### 수리

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 276 | 수리 > 공정수리관리(PID) | M_WQCMANAGER | w_pln_product_pcb_repair_master | 공정수리관리(PID) | 소스 미확인 | MATCHED |
| 278 | 수리 > 공정폐기관리 | M_WQCDESTROYMASTER | w_pln_product_pcb_destroy_master | 공정폐기관리 | `IP_PRODUCT_WORK_QC` | MATCHED |
| 280 | 수리 > 수리자재신청 | M_MATERIALREQUEST | w_mat_request_master | 수리자재신청 | `IM_ITEM_REQUEST` | MATCHED |

### 품질관리

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 282 | 품질관리 | M_QC | w_qc_4m_master | 4M 이력관리 | `IQ_4M_MASTER` | MATCHED |
| 283 | 품질관리 > IQC 관리 | M_IQCMASTER | w_qc_iqc_master | IQC 관리 | 소스 미확인 | MATCHED |
| 284 | 품질관리 > IQC 이력등록관리 | M_IQCINSPECTHISTORYMASTERPID | w_qc_iqc_inspect_history_master | IQC 이력등록관리 | `IQ_IQC_INSPECT_HISTORY` | MATCHED |
| 285 | 품질관리 > PCB 이슈발생스캔관리 | M_PCBISSUESCANQUERY | w_pln_product_pid_issue_scan_master | LINE MASTER | `IP_PRODUCT_ISSUE_PID_SCAN` | MATCHED |
| 287 | 품질관리 > 재고통제관리 | M_INVENTORYHOLDMANAGER | w_qc_inventory_hold_master | 재고통제관리 | `IM_ITEM_INVENTORY_HOLD` | MATCHED |
| 288 | 품질관리 > PID 홀딩관리 | M_PIDBLOCKINGMASTER | w_pln_product_barcode_holding | PID 홀딩관리 | `IP_PRODUCT_2D_BARCODE` | MATCHED |
| 289 | 품질관리 > 품질이상발생관리 | M_QCNOTIFYMASTER | w_qc_notify_master | 품질이상발생관리 | `IQ_DAILY_NOTIFY` | MATCHED |
| 290 | 품질관리 > 품질알림관리 | M_ECONOTIFYMASTER | w_qc_eco_notify_master | 품질알림관리 | `ID_ITEM` | MATCHED |
| 291 | 품질관리 > 4M 이력관리 | M_4MHISTORYMASTER | w_qc_4m_master | 4M 이력관리 | `IQ_4M_MASTER` | MATCHED |
| 293 | 품질관리 > 공정품질검사이력관리 | M_WORKSTAGEINSPECTHISTORYMASTER | w_qc_workstage_inspect_data_master | 공정품질검사이력관리 | 소스 미확인 | MATCHED |
| 294 | 품질관리 > OQC 검사이력관리(PID) | M_OQCINSPECTHISTORYMASTER | w_qc_oqc_inspect_history_master | 승인원의모델에 대한 특성을 관리 | `IQ_OQC_INSPECT_HISTORY` | MATCHED |
| 295 | 품질관리 > OQC 검사이력관리(LOT) | M_23 | w_qc_oqc_inspect_history_4_lot_master | 승인원의모델에 대한 특성을 관리 | `IQ_OQC_INSPECT_HISTORY` | MATCHED |
| 297 | 품질관리 > 온도상태조회 | M_TEMPRETURESTATUSQUERY | w_pln_product_tempreture_history_query | 온도상태조회 | 소스 미확인 | MATCHED |

### 출하현황

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 299 | 출하현황 > 제품포장관리(PID) | M_CELLBIZPACKING | w_prd_product_packing_create_master | 제품포장관리(PID) | 소스 미확인 | MATCHED |
| 300 | 출하현황 > 제품포장관리(LOT) | M_PRODUCTMAGAZINEPACKINGMASTER | w_prd_product_packing_4_magazine_create_master | 승인원의모델에 대한 특성을 관리 | `IP_PRODUCT_PACK_MASTER` | MATCHED |
| 303 | 출하현황 > 제품입고관리(LOT) | M_PRODUCTMAGAZINERECEIPTMASTER | w_prd_product_fg_4_magazine_receipt | 제품입고관리(LOT) | 소스 미확인 | MATCHED |
| 304 | 출하현황 > 제품입고관리 (모델단위) | M_PRODUCTMODELRECEIPTMASTER | w_prd_product_fg_4_model_receipt | 제품입고관리 (모델단위) | `IP_PRODUCT_FG_RECEIPT` | MATCHED |
| 306 | 출하현황 > 파렛타이징 관리 | M_PRODUCTPALLETEMASTER | w_prd_product_fg_palletizing | 파렛타이징 관리 | `IP_PRODUCT_FG_INVENTORY` | MATCHED |
| 307 | 출하현황 > 제품출하관리 | M_PRODUCTSHIPPINGQUERY | w_prd_product_fg_issue | 제품출하관리 | 소스 미확인 | MATCHED |
| 308 | 출하현황 > 제품출고관리 (모델단위) | M_PRODUCTMODELISSUEMASTE | w_prd_product_fg_4_model_issue | 제품출고관리 (모델단위) | `IP_PRODUCT_FG_ISSUE` | MATCHED |
| 311 | 출하현황 > 제품패킹이력 | M_PRODUCTPACKINGHISORY | w_prd_product_packing_history | 제품패킹이력 | `IP_PRODUCT_PACK_SERIAL` | MATCHED |

### 추적

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 313 | 추적 > 자재 제조번호 기준 추적 | M_PIDTRACKINGQUERY | w_product_pid_tracking_rpt | 자재 제조번호 기준 추적 | DB 소스 없음 | MATCHED |
| 314 | 추적 > 자재추적조회(동적) | M_MATERIALTRACKINGQUERY | w_product_material_tracking_rpt | 자재추적조회(동적) | `IB_SMT_CHECKHIST` | MATCHED |
| 315 | 추적 > 자재사용이력조회 | M_MATERIALUSEDHISTORY | w_product_material_tracking_msl_rpt | 자재사용이력조회 | `IB_SMT_CHECKHIST` | MATCHED |
| 317 | 추적 > 생산이력조회(PID) | M_PIDTRACKING | w_product_pid_tracking_fpcb_rpt | 생산이력조회(PID) | `IP_PRODUCT_2D_BARCODE` | MATCHED |
| 318 | 추적 > 생산이력조회(Run No) | M_PIDTRACKINGFORTHEPRODUCTION | w_pln_product_barcode_tracking | 생산이력조회(Run No) | `IP_PRODUCT_RUN_CARD` | MATCHED |
| 319 | 추적 > 롯트추적조회(ALL) | M_ALLTRACKINGFORTHEPRODUCTION | w_pln_product_all_barcode_tracking | 롯트추적조회(ALL) | `IP_PRODUCT_RUN_CARD` | MATCHED |
| 321 | 추적 > 생산현황데쉬보드 | M_PRODUCTIONSTATUSDASHBOARD | w_com_production_status_dashboard | 생산현황데쉬보드 | 소스 미확인 | MATCHED |

### 조회

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 324 | 조회 > 마킹이력조회 | M_MARKINGHISTORYQUERY | w_pln_product_pcb_marking_query | 마킹이력조회 | `IQ_MACHINE_INSPECT_DATA_MK` | MATCHED |
| 325 | 조회 > PCB 투입 리스트조회 | M_PCBINPUTSCANLISTQUERY | w_qc_pcb_input_scan_master | PCB 투입 리스트조회 | `IP_PRODUCT_PCB_SCAN_MASTER` | MATCHED |
| 327 | 조회 > SMT 오장착 스캔 현황 조회 | M_PDASCANLISTQUERY | w_pln_product_pda_scan_query | SMT 오장착 스캔 현황 조회 | `IB_SMT_CHECKHIST` | MATCHED |
| 328 | 조회 > PDA 검사오류내역조회 | M_PDASCANNGLISTQUERY | w_smt_plan_ng_check_master | PDA 검사오류내역조회 | `IB_PRODUCT_PLANDATA` | MATCHED |
| 329 | 조회 > SMT 피더별 모니터링 | M_SMTFEEDERMONITORING0 | w_smt_plan_feeder_monitoring_master | SMT 피더별 모니터링 | `IB_PRODUCT_PLANDATA` | MATCHED |
| 330 | 조회 > SMT 제품실적센서이력조회 | M_SMTPRODUCTSENSORACTUALQUERY | w_pln_product_sensor_actual_master | SMT 제품실적센서이력조회 | `IP_PRODUCT_SENSOR_ACTUAL` | MATCHED |
| 331 | 조회 > 마스크검사이력조회 | M_MASKCHECKHISTORYQUERY | w_mcn_jig_mask_check_history | 마스크검사이력조회 | `IMCN_JIG_MASK_CHECK` | MATCHED |
| 332 | 조회 > 스퀴지검사이력조회 | M_SQUEEZECHECKHISTORYQUERY | w_mcn_jig_squeeze_check_history | 스퀴지검사이력조회 | DB 소스 없음 | MATCHED |
| 333 | 조회 > 자재 바코드 상태 조회 | M_MATERIALBARCODESTATUSQUERY | w_mat_barcode_status_report | 자재 바코드 상태 조회 | `IM_ITEM_RECEIPT_BARCODE` | MATCHED |
| 335 | 조회 > NSNP 처리이력조회 | M_NSNPPROESSHISTORYMASTER | w_pln_product_nsnp_history_query | NSNP 처리이력조회 | 소스 미확인 | MATCHED |

### 리포트

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 338 | 리포트 > 기준정보 > 폼목마스터리포트 | M_ITEMMASTERREPORT | w_des_item_master_rpt | BOM리포트 | `ID_ITEM` | MATCHED |
| 340 | 리포트 > 바코드 > 라인설비바코드 | M_LINEBARCODE | w_barcode_rpt |  | `IB_LINE_MASTER` | UNMATCHED |
| 341 | 리포트 > 바코드 > 캐리어바코드 | M_CARRIERBARCODE | w_product_carrier_barcode | NEW A LED PROJECT | `IP_PRODUCT_CARRIER_BARCODE` | MATCHED |
| 343 | 리포트 > 설비 > 설비리포트 | M_MACHINEREPAIRREPORT | w_mcn_machine_rpt |  | `IMCN_MACHINE` | MATCHED |
| 344 | 리포트 > 설비 > SMT PICKUP 리포트 | M_PICKUPRATEREPORT | w_smt_pickup_rate_rpt | SMT 픽업율 리포트 | `IQ_MACHINE_INSPECT_PICKUP_QRY` | MATCHED |
| 346 | 리포트 > 제품 > 생산계획리포트 | M_PRODUCTMASTERPLANREPORT | w_pln_master_plan_report |  | 소스 미확인 | UNMATCHED |
| 347 | 리포트 > 제품 > 런카드리포트 | M_PRODUCTRUNCARDREPORT | w_product_run_card_rpt | NEW A LED PROJECT | `IP_PRODUCT_RUN_CARD` | MATCHED |
| 350 | 리포트 > 공정 > 공정재공조회 | M_50 | w_product_workstage_stock_rpt |  | `IP_PRODUCT_WORKSTAGE_INV` | MATCHED |
| 352 | 리포트 > 공정 > 공정매거진조회 | M_91 | w_product_workstage_magazine_stock_rpt |  | `IP_PRODUCT_RUN_CARD_INV` | MATCHED |
| 354 | 리포트 > S-PARTS/지그 > S-PARTS입고리포트 | M_MOLDRECEIPTREPORT | w_mcn_mold_receipt_rpt |  | DB 소스 없음 | MATCHED |
| 355 | 리포트 > S-PARTS/지그 > S-PARTS출고리포트 | M_MOLDISSUEREPORT | w_mcn_mold_issue_rpt |  | DB 소스 없음 | MATCHED |
| 357 | 리포트 > S-PARTS/지그 > 지그리포트 | M_JIGMASTERREPORT | w_mcn_jig_rpt |  | `IMCN_JIG` | MATCHED |
| 358 | 리포트 > S-PARTS/지그 > S-PARTS관리리포트 | M_MOLDMASTERREPORT | w_mcn_mold_rpt |  | `IMCN_MOLD_INVENTORY` | MATCHED |
| 360 | 리포트 > 품질관리 > 4M 변경이력 | M_4MCHANGEHISTORY | w_qc_4m_history_rpt | NEW A LED PROJECT | `IQ_DAILY_NOTIFY` | MATCHED |
| 363 | 리포트 > 자재창고 > 자재입고리포트 | M_40 | w_mat_receipt_report | MATERIAL PURCHASE ORDER REPORT | `IM_ITEM_RECEIPT` | MATCHED |
| 364 | 리포트 > 자재창고 > 자재입고합계리포트 | M_41 | w_mat_receipt_sum_report | MATERIAL RECEIPT SUM REPORT | `IM_ITEM_RECEIPT` | MATCHED |
| 365 | 리포트 > 자재창고 > 자재출고리포트 | M_42 | w_mat_issue_report | MATERIAL ISSUE REPORT | `IM_ITEM_ISSUE` | MATCHED |
| 366 | 리포트 > 자재창고 > 자재출고합계리포트 | M_44 | w_mat_issue_sum_report | MATERIAL ISSUE SUM REPORT | `IM_ITEM_ISSUE` | MATCHED |
| 369 | 리포트 > 자재창고 > 재고리포트 | M_ITEMINVENTORYREPORT | w_mat_current_inventory_report | MATERIAL CURRENT MATERIAL REPORT | `IM_ITEM_INVENTORY` | MATCHED |

### 승인

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 371 | 승인 > 반출반입승인 | M_6 | w_com_carrying_out_bring_in_confirm | MATERIAL BUY PRICE MASTER | `IMAN_CARRYING_OUT` | MATCHED |
| 372 | 승인 > 반출반입승인(보안) | M_7 | w_com_carrying_out_bring_in_security | MATERIAL BUY PRICE MASTER | `IMAN_CARRYING_OUT` | MATCHED |
| 373 | 승인 > 구매단가승인 | M_BUYPRICECONFIRM | w_mat_buy_price_confirm | 구매단가승인 | `IM_ITEM_UNIT_PRICE` | MATCHED |
| 374 | 승인 > 판매단가승인 | M_SALEPRICECONFIRM | w_sal_sale_price_confirm | 판매단가승인 | `IS_PRODUCT_SALE_PRICE` | MATCHED |
| 375 | 승인 > S-PARTS구매단가승인 | M_MOLDBUYPRICECONFIRM | w_mcn_mold_buy_price_confirm | MATERIAL BUY PRICE MASTER | `IMCN_MOLD_UNIT_PRICE` | MATCHED |
| 377 | 승인 > 설계BOM승인 | M_ENGBOMCONFIRM | w_des_bom_confirm_master | 설계BOM승인 | `ID_ENG_BOM_WORKSPACE` | MATCHED |

### 기본정보

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 379 | 기본정보 > 회사 | M_COMPANYMANAGEMENT | w_company_master | 회사 | `ISYS_COMPANY` | MATCHED |
| 380 | 기본정보 > 조직 | M_ORGANIZATION | w_organization_master | 조직 | `ISYS_ORGANIZATION` | MATCHED |
| 381 | 기본정보 > 부서 | M_DEPARTMENT | w_department_master | 부서 | `ISYS_DEPARTMENT` | MATCHED |
| 382 | 기본정보 > 사용자 | M_USER | w_user_master | 사용자 | `ISYS_USERS` | MATCHED |
| 384 | 기본정보 > 애플리케이션창 | M_APPLICATIONWINDOW | w_window_master | 애플리케이션창 | `ISYS_WINDOW` | MATCHED |
| 385 | 기본정보 > 역할 | M_ROLE | w_role_master | 역할 | `ISYS_ROLE` | MATCHED |
| 387 | 기본정보 > 권한 > 프로그램사용권한 | M_APPLICATIONPLIBILEGE | w_privilege_master | 프로그램사용권한 | `ISYS_PRIVILEGE` | MATCHED |
| 389 | 기본정보 > 메세지에이젼트 | M_MESSAGEAGENT | w_agent_message_master | 메세지에이젼트 | `ISYS_AUDIT_MESSAGE`, `ISYS_AUDIT_MESSAGE_FILTER` | MATCHED |
| 391 | 기본정보 > 기초코드관리 | M_BASECODE | w_basecode_master | 기초코드관리 | `ISYS_BASECODE` | MATCHED |
| 392 | 기본정보 > 표준코드관리 | M_STANDARDCODEMANAGE | w_standard_code_master | 표준코드관리 | `ISYS_CODE_MASTER` | MATCHED |

### 시스템

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 395 | 시스템 > 언어관리 > 언어텍스트관리 | M_LANGUAGESOURCEMANAGE | w_dual_language | 언어텍스트관리 | `ISYS_DUAL_LANGUAGE` | MATCHED |
| 396 | 시스템 > 언어관리 > 메세지텍스트관리 | M_MESSAGESOURCEMANAGE | w_dual_message | 메세지텍스트관리 | `ISYS_DUAL_MESSAGE`, `ISYS_DUAL_MESSAGE_DIRECT` | MATCHED |
| 398 | 시스템 > 언어관리 > 용어사전 | M_WORDDICTIONARY | w_word_dictionary | 용어사전 | `ISYS_WORD_DICTIONARY` | MATCHED |
| 403 | 시스템 > 시스템특성 > 시스템환경 | M_SYSYTEMENVIRONMENT | w_system_config | 시스템환경 | `ISYS_CONFIG` | MATCHED |
| 405 | 시스템 > 시스템특성 > 재고마감일자설정 | M_INVENTORYCLOSEDATESETUP | w_system_inventory_close_date_setup | DUAL LANGUAGE INFORMATION MANAGE | `ISYS_INVENTORY_CLOSE_DATE` | MATCHED |
| 413 | 시스템 > 메뉴관리모드 > 메뉴관리 | M_MENUMANAGE | w_menu_master | 메뉴관리 | `ISYS_DYNAMIC_MENU` | MATCHED |
| 421 | 시스템 > 시스템데이타보기 > 오브젝트보기 | M_SHOWSYSTEMOBJECT | w_db_object_master | DB OBJECT  INFORMATION MANAGE | `ISYS_OBJECT` | MATCHED |
| 424 | 시스템 > 시스템데이타보기 > 시스템오류내역보기 | M_SHOWERRORLOG | w_error_log_trace | 시스템오류내역보기 | `ISYS_ERROR_TRACE` | MATCHED |
| 425 | 시스템 > 시스템데이타보기 > 시스템사용내역 | M_SHOWSYSTEMACCESS | w_system_access_master | 시스템사용내역 | `ISYS_SYSTEM_ACCESS` | MATCHED |
| 451 | 시스템 > 리포트관리 > 런타임데이타창생성 | M_RUNTIMEDWGENERATOR | w_runtime_dw_generator | DUAL LANGUAGE INFORMATION MANAGE | 동적 확인 필요 | MATCHED |
| 452 | 시스템 > 리포트관리 > 리포트생성기 | M_REPORTGENERATOR | w_report_generator | 조건절생성용윈도우 | `ISYS_REPORT_SOURCE` | MATCHED |
| 454 | 시스템 > 리포트관리 > 리포트관리 | M_REPORTMASTER | w_dataobject_master | 리포트관리 | `ISYS_DATAOBJECT` | MATCHED |
| 457 | 시스템 > Unuse Program > 기준정보 > IT 자산 현황 | M_ITATSETMANAGEMENT | w_mcn_it_master | CUSTOMER INFROMATION MANAGE | `IMCN_FIXASSET` | MATCHED |
| 459 | 시스템 > Unuse Program > 설비 > 리플로우상태조회 | M_REFLOWSTATUSQUERY | w_qc_interlock_reflow_status_master | 리플로우상태조회 | `IQ_INTERLOCK_REFLOW_STATUS` | MATCHED |
| 460 | 시스템 > Unuse Program > 설비 > 설비 픽업률조회 | M_SMTPICKUPINQUERY | w_smt_pickup_rate | 설비 픽업률조회 | `IQ_MACHINE_INSPECT_PICKUP_RATE` | MATCHED |
| 461 | 시스템 > Unuse Program > 설비 > SMT 픽업율(최종데이터조회) | M_SMTPICKUPLASTDATAINQUERY | w_smt_pickup_rate_last_data_query | SMT 픽업율 (최종데이터조회) | `IQ_MACHINE_INSPECT_PICKUP_RATE` | MATCHED |
| 463 | 시스템 > Unuse Program > 자재창고 > 자재전표엑셀업로드관리 | M_14 | w_mat_receipt_slip_excel_upload_master | MATERIAL MASS ISSUE RETURN MASTER | `IM_ITEM_RECEIPT_SLIP_EXCEL` | MATCHED |
| 464 | 시스템 > Unuse Program > 자재창고 > 자재(대여/차용)전표등록관리 | M_28 | w_mat_receipt_slip_4_rental_borrowing_master | MATERIAL MASS ISSUE RETURN MASTER | `IM_ITEM_RECEIPT_BARCODE` | MATCHED |
| 465 | 시스템 > Unuse Program > 자재창고 > 자재(대여/차용상환)관리 | M_35 | w_mat_other_receipt_rental_borrowing_barcode_master | MATERIAL MASS ISSUE RETURN MASTER | `IM_ITEM_RECEIPT_RETURN_REQUEST` | MATCHED |
| 468 | 시스템 > Unuse Program > 자재창고 > 자재요청조회 | M_MATERIALREQUESTQUERY | w_mat_material_request_master | 자재요청조회 | `IM_ITEM_REQUEST` | MATCHED |
| 469 | 시스템 > Unuse Program > 자재창고 > 라인별 모니터링 | M_SMTFEEDERMONITORINGLINEMASTER | w_smt_plan_feeder_monitoring_line_master | 라인별 모니터링 | `IB_PRODUCT_PLANDATA` | MATCHED |
| 471 | 시스템 > Unuse Program > 생산 > 자재요청관리 | M_WORKSTAGEMATERIALRECEIPTCHECKMASTER | w_pln_workstage_material_receipt_check_master | 부품 마스터 | `IM_ITEM_REQUEST` | MATCHED |
| 473 | 시스템 > Unuse Program > 수리 > 반품수리관리 | M_SHIPPINGRETURNREPAIRMASTER | w_sal_shipping_return_repair_master | LINE MASTER | `IP_PRODUCT_WORK_QC` | MATCHED |
| 475 | 시스템 > Unuse Program > 재고 > 반제품바코드스캔실사 | M_65 | w_pln_barcode_check_master | MATERIAL MASS ISSUE RETURN MASTER | `IM_ASSY_INVENTORY_CHECK_BCD` | MATCHED |
| 477 | 시스템 > Unuse Program > 발주 > 자재소요량관리 | M_59 | w_mat_requirment_plan_master | 총소요량관리 | `IM_ITEM_MASTER_PLAN_4_REQUIR` | MATCHED |
| 478 | 시스템 > Unuse Program > 발주 > 자재발주계획 | M_67 | w_mat_purchase_order_plan_master | 자재발주계획 | `IM_ITEM_PURCHASE_ORDER_PLAN` | MATCHED |
| 480 | 시스템 > Unuse Program > 발주 > 자재주문예정관리 | M_71 | w_mat_forecast_order_master | MATERIAL PURCHASE ORDER MASTER | `IM_ITEM_PURCHASE_ORDER_WAIT` | MATCHED |
| 481 | 시스템 > Unuse Program > 발주 > 자재주문관리 | M_73 | w_mat_purchase_order_plan_master | 자재발주계획 | `IM_ITEM_PURCHASE_ORDER_PLAN` | MATCHED |
| 483 | 시스템 > Unuse Program > 발주 > 자재출발관리 | M_82 | w_mat_departure_master | MATERIAL DEPARTURE MASTER | `IM_ITEM_ARRIVAL` | MATCHED |
| 484 | 시스템 > Unuse Program > 발주 > 자재도착관리 | M_84 | w_mat_arrival_master | MATERIAL ARRIVAL MASTER | `IM_ITEM_ARRIVAL` | MATCHED |
| 486 | 시스템 > Unuse Program > 품질관리 > 설비검사확인(스캔) | M_MACHINEINSPECTMANUAL | w_qc_machine_inspect_manual | 검사기록 수작업 등록 ( PID 기준 ) | `IQ_MACHINE_INSPECT_MANUAL` | MATCHED |
| 487 | 시스템 > Unuse Program > 품질관리 > 고객컴플레인관리 | M_CUSTOMERCOMPLAINTSMANAGER | w_customer_complaints_master | 도면관리 | `ICOM_CUSTOMER_COMPLAINTS` | MATCHED |
| 488 | 시스템 > Unuse Program > 품질관리 > 이상발생 모니터링 | M_ACTIONHISTORYFORNGSOUND | w_pln_product_sound_history_query | NG SOUND HISTORY MANAGEMENT | `ISYS_SOUND_MENT` | MATCHED |
| 490 | 시스템 > Unuse Program > SMT > SMT 파트라이브러리관리 | M_SMTUPLOADPARTLIBMASTER | w_smt_upload_partlib_master | 생산계획 | `IB_MNT_PARTLIB_MASTER`, `IB_MNT_PARTSLIB_NMP` | MATCHED |
| 492 | 시스템 > Unuse Program > 지그 > 메탈마스크텐션 수동 관리 | M_MASKTENSIONMANUALCHECKMASTER | w_mcn_jig_mask_check_master | 금형검사이력관리 | `IMCN_JIG_MASK_CHECK` | MATCHED |
| 493 | 시스템 > Unuse Program > 지그 > 픽스쳐검사관리 | M_JIGFIXTURECHECKMASTER | w_mcn_jig_fixture_check_master | 금형검사이력관리 | `IMCN_JIG_SQUEZE_CHECK` | MATCHED |
| 495 | 시스템 > Unuse Program > 출하현황 > 제품납품계획 | M_PRODUCTSALEPLAN | w_pln_product_delivery_master | 제품납품계획 | `IP_PRODUCT_DELIVERY_MONTH_PLAN`, `IP_PRODUCT_DELIVERY_PLAN` | MATCHED |
| 496 | 시스템 > Unuse Program > 출하현황 > 포장바코드중복체크관리 | M_PACKINGDUPULICATECHECKMASTER | w_pln_product_packing_dupulicate_check_master | 포장바코드중복체크관리 | `IP_PRODUCT_PACK_SERIAL` | MATCHED |
| 498 | 시스템 > Unuse Program > 통문관리 > 반출송장 | M_17 | w_com_carrying_out_master | MATERIAL RECEIPT MASTER | `IMAN_CARRYING_OUT` | MATCHED |
| 499 | 시스템 > Unuse Program > 통문관리 > 반입송장 | M_22 | w_com_bring_in_master | MATERIAL RECEIPT MASTER | `IMAN_CARRYING_OUT` | MATCHED |
| 501 | 시스템 > Unuse Program > 추적 > 워크오더추적조회 | M_WORKORDERTRACKINGQUERY | w_product_material_tracking_4_workorder_rpt | NEW A LED PROJECT | `IP_PROD_MATERIAL_TRACKING_KFC` | MATCHED |
| 502 | 시스템 > Unuse Program > 추적 > 자재추적조회(멀티/동적) | M_MATERIALTRACKINGMULTIQUERY | w_product_material_tracking_multi_rpt | NEW A LED PROJECT | `IB_SMT_CHECKHIST` | MATCHED |
| 503 | 시스템 > Unuse Program > 추적 > 제품 추적 조회 | M_MATERIALTRACKINGQUERYHISTORY | w_product_material_tracking_history_rpt | NEW A LED PROJECT | `IP_PROD_MATERIAL_TRACKING_KFC` | MATCHED |

### 도움말

| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |
|---:|---|---|---|---|---|---|
| 513 | 도움말 > 도움말동영상보기 | M_HELPSHOWVIDEO | w_help_video | 도움말동영상보기 | `ISYS_HELP_VIDEO` | MATCHED |
| 517 | 도움말 > 컬럼설명 | M_COLUMNEXPLANATION | w_column_explanation | COLUMN EXPLANATION HELP POPUP | `ISYS_WORD_DICTIONARY` | MATCHED |
| 519 | 도움말 > 애플리케이션에관하여 | M_ABOUTAPPLICATION | w_who_am_i | 애플리케이션에대하여 | `ISYS_WINDOW` | MATCHED |
| 520 | 도움말 > &Infinity21에 대하여 | M_ABOUT | w_about | ABOUT WINDOW | DB 소스 없음 | MATCHED |

## 해석 기준

- `MENU_ITEM_TEXT`: 사용자에게 보이는 PowerBuilder 메뉴명.
- `MENU_ITEM_NAME`: PowerBuilder 메뉴 항목 오브젝트명.
- `MENU_TAG`: 메뉴 클릭 대상 화면 오브젝트명 후보. 개발 DB 확장 컬럼이며 PBL 10.5의 `d_dynamic_menu.srd`에는 포함되지 않는다.
- `WINDOW_NAME`: `ISYS_WINDOW`에 등록된 PowerBuilder 화면 오브젝트명.
- `WINDOW_DESCRIPTION_KOR`: 화면의 한글 표시명.
- `MATCHED`: 같은 조직에서 `UPPER(TRIM(MENU_TAG)) = UPPER(WINDOW_NAME)`가 성립.
- `UNMATCHED`: 메뉴 태그는 있으나 `ISYS_WINDOW`에 같은 화면명이 없음.

- `메인 DB 테이블`: 화면 SRW의 직접 DML과 저장 DataWindow의 SRD `update=`를 우선하고, 조회 화면은 직접 연결된 SRD의 중심 조회 테이블을 사용한다.
- 복수 테이블은 점수가 비슷한 공동 fact를 함께 표시한다. `동적 확인 필요`, `DB 소스 없음`, `소스 미확인`은 각각 런타임 결정, 비DB 화면, 원본 파일 부재를 뜻한다.

## 생성 파일

- `menu-hierarchy-dev-db.csv`: 동적 메뉴 522행 전체와 계산된 계층 경로.
- `menu-screen-map-dev-db.csv`: MENU_TAG가 있는 231행의 메뉴-화면 매핑.
- `window-master-dev-db.csv`: ISYS_WINDOW 557행 전체와 메뉴 등록 여부.
