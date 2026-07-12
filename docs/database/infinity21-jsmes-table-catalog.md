---
sources:
  - tools/database/export-infinity21-schema.py
  - apps/backend/src/entities/
  - apps/backend/src/modules/
  - apps/frontend/src/lib/queries/
verifiedCommit: 0480e7d
---

# INFINITY21_JSMES 테이블 카탈로그

- 추출 대상: `INFINITY21_JSMES` @ `XE` (`ESDBext`)
- 추출 시각: `2026-07-12T18:07:30.614985+09:00`
- 전체 테이블: **558개**
- 행 수는 `USER_TABLES.NUM_ROWS` 통계 추정치이며 NULL이거나 오래되었을 수 있다.
- 도메인은 명명 규칙 기반 1차 분류다. 업무 인터뷰와 코드/데이터 검증 후 확정한다.
- 상세 컬럼·키·관계·참조 목록은 `generated/infinity21-jsmes-schema.json`에 있다.

## 관계 신뢰도

| 등급 | 판정 기준 |
|---|---|
| 확정 | Oracle FK/PK/UK 제약조건으로 확인 |
| 검증 | PL/SQL·애플리케이션 조인과 실제 데이터로 확인 |
| 추정 | 명명·컬럼·값 패턴만 일치 |
| 미확정 | 근거 부족 또는 업무 확인 필요 |

## 1차 도메인 분포

| 도메인 | 테이블 수 |
|---|---:|
| 자재/품목 | 163 |
| 생산 | 106 |
| 미분류 | 94 |
| 품질 | 83 |
| 시스템/기준정보 | 64 |
| 인터페이스 | 32 |
| 이력/로그 | 13 |
| 출하 | 3 |

## 전체 테이블 인벤토리

| 테이블 | 1차 도메인 | 용도 근거 | 행 수 추정 | PK | FK(나감/들어옴) | DB 참조 객체 | 코드 사용처 |
|---|---|---|---:|---|---:|---:|---:|
| A_ITEM | 자재/품목 | 미확정 | 21 | - | 0/0 | 0 | 0 |
| A_LANG | 미분류 | 미확정 | 9639 | - | 0/0 | 0 | 0 |
| A_MASK | 미분류 | 미확정 | 463 | - | 0/0 | 0 | 0 |
| A_MATERIAL | 미분류 | 미확정 | 81 | - | 0/0 | 0 | 0 |
| A_MODEL | 미분류 | 미확정 | 23 | - | 0/0 | 0 | 0 |
| DashboardData | 미분류 | 미확정 | 1 | Oid | 0/0 | 0 | 0 |
| ESEAI_M107_TEMP | 미분류 | 미확정 | 3431809 | - | 0/0 | 3 | 0 |
| IB_LINE_MASTER | 인터페이스 | SMT라인관리마스터 | 39 | - | 0/0 | 0 | 0 |
| IB_MACHINE_LOCATION | 인터페이스 | SMT설비별피더로케이션관리마스터 | 300 | - | 0/0 | 0 | 0 |
| IB_MATERIAL_LOCATION | 인터페이스 | 미확정 | - | - | 0/0 | 0 | 0 |
| IB_MNT_BLOCKDATA | 인터페이스 | 미확정 | - | - | 0/0 | 0 | 0 |
| IB_MNT_CHIPDATA | 인터페이스 | 미확정 | - | - | 0/0 | 0 | 0 |
| IB_MNT_CHIPDATA_NMP | 인터페이스 | 미확정 | - | - | 0/0 | 0 | 0 |
| IB_MNT_PARTLIB_COMPARE_MASTER | 인터페이스 | 미확정 | - | - | 0/0 | 0 | 0 |
| IB_MNT_PARTLIB_MASTER | 인터페이스 | 미확정 | - | - | 0/0 | 2 | 0 |
| IB_MNT_PARTLIB_MASTER_WORK | 인터페이스 | 미확정 | - | - | 0/0 | 0 | 0 |
| IB_MNT_PARTSLIB | 인터페이스 | 미확정 | - | - | 0/0 | 0 | 0 |
| IB_MNT_PARTSLIB_BM | 인터페이스 | 미확정 | - | - | 0/0 | 0 | 0 |
| IB_MNT_PARTSLIB_NMP | 인터페이스 | 미확정 | - | - | 0/0 | 0 | 0 |
| IB_MNT_PART_INFORMATION | 인터페이스 | 미확정 | - | - | 0/0 | 0 | 0 |
| IB_MNT_PLANDATA | 인터페이스 | 미확정 | 7 | - | 0/0 | 0 | 0 |
| IB_MNT_POSITIONDATA | 인터페이스 | 미확정 | - | - | 0/0 | 0 | 0 |
| IB_MNT_POSITIONDATA_NPM | 인터페이스 | 미확정 | - | - | 0/0 | 0 | 0 |
| IB_MNT_STEP_INFOR | 인터페이스 | 미확정 | 160 | - | 0/0 | 0 | 0 |
| IB_MNT_STOCKDATA | 인터페이스 | 미확정 | - | - | 0/0 | 0 | 0 |
| IB_MNT_YAMAHA_CSV | 인터페이스 | 미확정 | - | - | 0/0 | 0 | 0 |
| IB_MONITORING_MST | 인터페이스 | 미확정 | - | LINE_CODE, ORGANIZATION_ID, DAY_GBN | 0/0 | 0 | 0 |
| IB_PRODUCT_PLANDATA | 인터페이스 | 미확정 | 18452 | - | 0/0 | 56 | 0 |
| IB_PRODUCT_PLANDATA_BACKUP | 인터페이스 | 미확정 | 557422 | - | 0/0 | 3 | 0 |
| IB_RECYCLE_CHECKHIST | 인터페이스 | 미확정 | 564 | - | 0/0 | 0 | 0 |
| IB_SMT_BOM_IMAGE | 인터페이스 | 미확정 | 3 | - | 0/0 | 0 | 0 |
| IB_SMT_CHECKHIST | 인터페이스 | 미확정 | 2838100 | - | 0/0 | 29 | 1 |
| IB_SMT_FEEDER_SHAFT | 인터페이스 | 미확정 | - | - | 0/0 | 1 | 0 |
| IB_SMT_FULLCHECK_TIME | 인터페이스 | 미확정 | 2 | - | 0/0 | 6 | 0 |
| IB_SMT_LINE_ONOFF_HISTORY | 인터페이스 | 미확정 | 36411 | LINE_CODE, MODEL_NAME, PCB_ITEM, LINE_ONOFF, LINE_ONOFF_DATE, ORGANIZATION_ID | 0/0 | 3 | 0 |
| IB_SMT_PRODUCT_MASTER_PLAN | 인터페이스 | 미확정 | - | PLAN_DATE, PLAN_DATE_SEQUENCE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IB_SMT_SW | 인터페이스 | 미확정 | - | MODEL_NAME, MODEL_SUFFIX, OUTPUT_VER, ENTER_DATE | 0/0 | 0 | 0 |
| ICOM_CUSTOMER | 미분류 | CUSTOMER MASTER | 18 | CUSTOMER_CODE, ORGANIZATION_ID | 0/3 | 5 | 1 |
| ICOM_CUSTOMER_COMPLAINTS | 미분류 | 미확정 | - | COMPLAINTS_NO, ORGANIZATION_ID, VERSION, ITEM_CODE | 0/0 | 1 | 0 |
| ICOM_CUSTOMER_DOCUMENT | 미분류 | 미확정 | - | CUSTOMER_CODE, SEQUENCE, ORGANIZATION_ID | 1/0 | 0 | 0 |
| ICOM_DISPLAY_MESSAGE | 미분류 | 미확정 | - | - | 0/0 | 0 | 0 |
| ICOM_DOCUMENT | 미분류 | 미확정 | 46 | DOC_ID, ORGANIZATION_ID | 0/0 | 0 | 0 |
| ICOM_EXCEL | 미분류 | 미확정 | - | - | 0/0 | 0 | 0 |
| ICOM_EXCHANGE_RATE | 미분류 | ?????????????? | - | - | 0/0 | 2 | 0 |
| ICOM_GATHERING_STATUS | 미분류 | 미확정 | - | - | 0/0 | 0 | 0 |
| ICOM_GATHERING_STATUS_HIST | 이력/로그 | 미확정 | - | - | 0/0 | 0 | 0 |
| ICOM_MACHINE_INSERT_LOG | 이력/로그 | 미확정 | 966436 | - | 0/0 | 37 | 0 |
| ICOM_MES_MOVIE | 미분류 | 미확정 | - | MOVIE_ID, ORGANIZATION_ID | 0/0 | 0 | 0 |
| ICOM_SUPPLIER | 미분류 | Vendor Master | 15 | SUPPLIER_CODE, ORGANIZATION_ID | 1/16 | 2 | 6 |
| ICOM_SUPPLIER_BARCODE | 미분류 | 미확정 | - | SUPPLIER_CODE, ORGANIZATION_ID, SUPPLIER_BARCODE_T | 0/0 | 0 | 0 |
| ICOM_SUPPLIER_DATA | 미분류 | 미확정 | - | SUPPLIER_CODE, ORGANIZATION_ID, DATESET, ITEM_CODE, LINE_TYPE | 0/0 | 0 | 0 |
| ICOM_SUPPLIER_DOCUMENT | 미분류 | 미확정 | - | SUPPLIER_CODE, SEQUENCE, ORGANIZATION_ID | 1/0 | 0 | 0 |
| ICOM_SYSTEM_ANALYSIS | 미분류 | 미확정 | - | - | 0/0 | 0 | 0 |
| ICOM_TEMPERATURE_DATA | 미분류 | 온습도데이터 | 49 | - | 0/0 | 3 | 0 |
| ICOM_TEMPERATURE_RAW | 미분류 | 미확정 | 16319975 | - | 0/0 | 3 | 0 |
| ICOM_WAREHOUSE | 미분류 | 창고 마스터 | - | ORGANIZATION_ID, WAREHOUSE_CODE | 0/0 | 0 | 2 |
| ICOM_WAREHOUSE_LOCATIONS | 미분류 | 창고 로케이션 마스터 (창고 내 세부위치) | - | ORGANIZATION_ID, WAREHOUSE_CODE, LOCATION_CODE | 0/0 | 0 | 1 |
| ICOM_WORKER | 생산 | 미확정 | - | ORGANIZATION_ID, WORKER_CODE | 0/0 | 0 | 0 |
| ICOM_WORKTIME_RANGES | 생산 | 미확정 | 25 | - | 0/0 | 12 | 0 |
| IDZ_INTERLOCK_NG_HIS_DAY | 미분류 | 미확정 | - | - | 0/0 | 1 | 0 |
| IDZ_INTERLOCK_NG_HIS_LINE | 미분류 | 미확정 | - | - | 0/0 | 1 | 0 |
| IDZ_INTERLOCK_NG_HIS_TOP10 | 미분류 | 미확정 | - | - | 0/0 | 1 | 0 |
| IDZ_INTERLOCK_NG_HIS_WORKSTAGE | 생산 | 미확정 | - | - | 0/0 | 1 | 0 |
| ID_CUSTOMER_SET_BOM | 자재/품목 | 미확정 | - | - | 2/0 | 3 | 0 |
| ID_CUSTOMER_SET_BOM_EXCEL | 자재/품목 | 미확정 | - | - | 0/0 | 1 | 0 |
| ID_ENG_BOM | 자재/품목 | DESIGN BOM | 9976 | PARENT_ITEM_CODE, CHILD_ITEM_CODE, DATESET, ORGANIZATION_ID | 0/0 | 12 | 4 |
| ID_ENG_BOM_CUSTOMER | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| ID_ENG_BOM_DRAWING | 자재/품목 | BOM DRAWING | - | DRAWING_NO, ORGANIZATION_ID, VERSION, ITEM_CODE | 2/0 | 0 | 0 |
| ID_ENG_BOM_ECO_WORKSPACE | 자재/품목 | BOM WORKSPACE | - | BOM_WORK_NO, BEFORE_PARENT_ITEM_CODE, BEFORE_CHILD_ITEM_CODE, DATESET, ORGANIZATION_ID | 1/0 | 1 | 0 |
| ID_ENG_BOM_ECO_WORKSPACE_HIS | 자재/품목 | WORKSPACE HISTORY | - | BOM_WORK_NO, BEFORE_PARENT_ITEM_CODE, BEFORE_CHILD_ITEM_CODE, DATESET, ORGANIZATION_ID | 1/0 | 1 | 0 |
| ID_ENG_BOM_EXCEL | 자재/품목 | 미확정 | - | - | 0/0 | 1 | 0 |
| ID_ENG_BOM_EXCEL_2 | 자재/품목 | 미확정 | - | - | 0/0 | 1 | 0 |
| ID_ENG_BOM_EXCEL_3 | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| ID_ENG_BOM_EXCEL_ES | 자재/품목 | 미확정 | 14 | - | 0/0 | 1 | 0 |
| ID_ENG_BOM_EXCEL_LG | 자재/품목 | 미확정 | - | - | 0/0 | 1 | 0 |
| ID_ENG_BOM_EXCEL_LG_CPR1 | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| ID_ENG_BOM_EXCEL_LG_CPR2 | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| ID_ENG_BOM_IMPORT | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| ID_ENG_BOM_LOOP_CHECK | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| ID_ENG_BOM_MATERIAL_COST | 자재/품목 | 미확정 | - | PLAN_YYYYMM, ITEM_CODE, PARENT_ITEM_CODE, CHILD_ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| ID_ENG_BOM_SMT | 자재/품목 | DESIGN BOM | 27727 | - | 0/0 | 7 | 0 |
| ID_ENG_BOM_SMT_BACKUP | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| ID_ENG_BOM_SMT_BAK | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| ID_ENG_BOM_SMT_EXCEL | 자재/품목 | 미확정 | - | - | 0/0 | 1 | 0 |
| ID_ENG_BOM_SMT_NO_REPLACE | 자재/품목 | 미확정 | - | - | 0/0 | 1 | 0 |
| ID_ENG_BOM_SMT_REPLACE | 자재/품목 | 미확정 | 34 | - | 0/0 | 1 | 0 |
| ID_ENG_BOM_TEMP | 자재/품목 | 미확정 | 3152863 | SESSION_ID, SORT_ORDER, PARENT_ITEM_CODE, CHILD_ITEM_CODE, DATESET, ORGANIZATION_ID | 0/0 | 2 | 0 |
| ID_ENG_BOM_UNIT | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| ID_ENG_BOM_WORKSPACE | 자재/품목 | BOM WORKSPACE | - | BOM_WORK_NO, PARENT_ITEM_CODE, CHILD_ITEM_CODE, DATESET, ORGANIZATION_ID | 1/0 | 4 | 0 |
| ID_ITEM | 자재/품목 | Item Master | 2501 | ITEM_CODE, ORGANIZATION_ID | 0/28 | 79 | 8 |
| ID_ITEM_BACKUP_210320 | 자재/품목 | 미확정 | 1799 | - | 0/0 | 0 | 0 |
| ID_ITEM_CLASS | 자재/품목 | Item Class Master | - | ITEM_CLASS, ORGANIZATION_ID | 1/0 | 0 | 0 |
| ID_ITEM_ES | 자재/품목 | 미확정 | 1662 | - | 0/0 | 0 | 0 |
| ID_ITEM_HISTORY | 이력/로그 | 미확정 | 3103 | - | 0/0 | 1 | 0 |
| ID_ITEM_IMAGE | 자재/품목 | 미확정 | - | ITEM_CODE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| ID_ITEM_REPLACE | 자재/품목 | 미확정 | - | PARENT_ITEM_CODE, CHILD_ITEM_CODE, REPLACE_ITEM_CODE, ORGANIZATION_ID | 1/0 | 1 | 0 |
| ID_MFS_BOM | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| ID_PRODUCT_CLASS | 생산 | 미확정 | - | PRODUCT_CLASS_CODE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| ID_USER | 미분류 | 미확정 | - | P_BARCODE, P_USER | 0/0 | 0 | 0 |
| IF_KEYT_KEYITEM | 인터페이스 | 미확정 | - | - | 0/0 | 0 | 0 |
| IF_KF_MATERIAL_LIST | 인터페이스 | 미확정 | - | - | 0/0 | 1 | 0 |
| IMAN_BRING_IN | 미분류 | 미확정 | - | BRING_IN_DATE, BRING_IN_SEQ, ORGANIZATION_ID | 1/0 | 1 | 0 |
| IMAN_CARRYING_OUT | 미분류 | 미확정 | - | CARRYING_OUT_DATE, CARRYING_OUT_SEQ, ORGANIZATION_ID | 0/1 | 2 | 0 |
| IMCN_FIXASSET | 미분류 | 미확정 | - | - | 0/0 | 0 | 0 |
| IMCN_JIG | 미분류 | 미확정 | 1912 | - | 0/0 | 25 | 0 |
| IMCN_JIG_APPLY_MODEL | 미분류 | 미확정 | 1700 | - | 0/0 | 5 | 0 |
| IMCN_JIG_BACKUPBLOCK_CHECK | 미분류 | 미확정 | 11 | - | 0/0 | 0 | 0 |
| IMCN_JIG_CABLE | 미분류 | 미확정 | - | CABLE_BARCODE, ORGANIZATION_ID | 0/0 | 1 | 0 |
| IMCN_JIG_FEEDER_ADJUST | 미분류 | 미확정 | 327 | - | 0/0 | 1 | 0 |
| IMCN_JIG_INPUT_HIST | 이력/로그 | 미확정 | 72490 | - | 0/0 | 6 | 0 |
| IMCN_JIG_ISSUE | 미분류 | 미확정 | - | ISSUE_SEQUENCE, ISSUE_DATE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IMCN_JIG_MASK_CHECK | 미분류 | 미확정 | 19308 | - | 0/0 | 1 | 0 |
| IMCN_JIG_PM_MASTER | 미분류 | 미확정 | - | - | 0/0 | 1 | 0 |
| IMCN_JIG_PM_MASTER_HIST | 이력/로그 | 미확정 | - | - | 0/0 | 1 | 0 |
| IMCN_JIG_REPAIR | 미분류 | 미확정 | 12 | JIG_CODE, ORGANIZATION_ID, REPAIR_SEQUENCE | 0/0 | 0 | 0 |
| IMCN_JIG_REPAIR_IMAGE | 미분류 | 미확정 | - | - | 0/0 | 0 | 0 |
| IMCN_JIG_SQUEZE_CHECK | 미분류 | 미확정 | 34564 | - | 0/0 | 3 | 0 |
| IMCN_MACHINE | 미분류 | 미확정 | 140 | - | 0/0 | 22 | 13 |
| IMCN_MACHINE_CALIBRATION | 미분류 | 미확정 | - | - | 0/0 | 0 | 0 |
| IMCN_MACHINE_DAILY_OPERATION | 미분류 | 미확정 | 1 | MACHINE_CODE, PLAN_DATE, MACHINE_OPERATION_SEQUENCE, MACHINE_STATUS_CODE, ORGANIZATION_ID | 0/0 | 5 | 0 |
| IMCN_MACHINE_PM_MASTER | 미분류 | 미확정 | 20 | - | 0/0 | 1 | 0 |
| IMCN_MACHINE_PM_MASTER_HIST | 이력/로그 | 미확정 | - | - | 0/0 | 1 | 0 |
| IMCN_MACHINE_REPAIR | 미분류 | 미확정 | 1 | MACHINE_CODE, ORGANIZATION_ID, REPAIR_SEQUENCE | 0/0 | 0 | 0 |
| IMCN_MACHINE_REPAIR_IMAGE | 미분류 | 미확정 | - | - | 0/0 | 0 | 0 |
| IMCN_MACHINE_SOFT_VERSION | 미분류 | 미확정 | - | MACHINE_CODE, CHANGE_DATE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IMCN_MACHINE_WORK_DATA | 생산 | 미확정 | - | WORK_DATE, WORK_SEQUENCE, MACHINE_CODE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IMCN_MOLD | 미분류 | 미확정 | - | MOLD_CODE, ORGANIZATION_ID | 1/0 | 1 | 0 |
| IMCN_MOLD_BILL | 미분류 | 미확정 | - | ITEM_CODE, MOLD_CODE, SEQUENCE, ORGANIZATION_ID | 1/0 | 0 | 0 |
| IMCN_MOLD_CHECK_HISTORY | 이력/로그 | 미확정 | - | - | 0/0 | 0 | 0 |
| IMCN_MOLD_ECO_LINK | 미분류 | 미확정 | - | - | 0/0 | 0 | 0 |
| IMCN_MOLD_INVENTORY | 미분류 | 미확정 | - | MOLD_CODE, ORGANIZATION_ID, MOLD_VERSION, MOLD_SET_SERIAL | 0/0 | 11 | 0 |
| IMCN_MOLD_ISSUE | 미분류 | 미확정 | - | ISSUE_SEQUENCE, ISSUE_DATE, ORGANIZATION_ID | 0/0 | 1 | 0 |
| IMCN_MOLD_LOCATION | 미분류 | 미확정 | - | - | 0/0 | 3 | 0 |
| IMCN_MOLD_PURCHASE_ORDER | 미분류 | 미확정 | - | ORDER_NO, ORGANIZATION_ID | 1/0 | 1 | 0 |
| IMCN_MOLD_RECEIPT | 미분류 | 미확정 | - | RECEIPT_DATE, RECEIPT_SEQUENCE, ORGANIZATION_ID | 1/0 | 1 | 0 |
| IMCN_MOLD_RENT | 미분류 | 미확정 | - | MOLD_CODE, MOLD_RENT_SEQUENCE, SUPPLIER_CODE, RENT_DATE, ORGANIZATION_ID | 1/0 | 1 | 0 |
| IMCN_MOLD_REPAIR | 미분류 | 미확정 | - | MOLD_CODE, REPAIR_SEQUENCE, ORGANIZATION_ID | 0/0 | 3 | 0 |
| IMCN_MOLD_REPAIR_IMAGE | 미분류 | 미확정 | - | - | 0/0 | 0 | 0 |
| IMCN_MOLD_REPAIR_ITEM | 자재/품목 | 미확정 | - | MOLD_CODE, REPAIR_SEQUENCE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IMCN_MOLD_REQUEST | 미분류 | 미확정 | - | - | 0/0 | 0 | 0 |
| IMCN_MOLD_REQUIREMENT_PLAN | 미분류 | ???? ???? ????? | - | REQUIRMENT_PLAN_DATE, PLAN_DATE, MOLD_CODE, ITEM_CODE, CHILD_ITEM_CODE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IMCN_MOLD_REQUIR_PLAN_TEMP | 미분류 | 미확정 | - | - | 0/0 | 0 | 0 |
| IMCN_MOLD_SHORT_HISTORY | 이력/로그 | 미확정 | - | - | 0/0 | 1 | 0 |
| IMCN_MOLD_TEMP | 미분류 | 미확정 | - | MOLD_CODE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IMCN_MOLD_UNIT_PRICE | 미분류 | 미확정 | - | DATESET, MOLD_CODE, SUPPLIER_CODE, ORGANIZATION_ID | 0/0 | 2 | 0 |
| IMCN_PM_CALENDAR | 미분류 | 미확정 | - | PLAN_DATE, PM_OBJECT_CODE, PM_SEQUENCE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IMCN_PM_RESULT | 미분류 | 미확정 | - | PLAN_DATE, PM_SEQUENCE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IMCN_SAMPLE | 미분류 | 미확정 | 321 | - | 0/0 | 13 | 0 |
| IMCN_SAMPLE_APPLY_MODEL | 미분류 | 미확정 | 782 | - | 0/0 | 1 | 0 |
| IMCN_SAMPLE_BCR_INPUT_HIST | 이력/로그 | 미확정 | 36580 | - | 0/0 | 6 | 0 |
| IMCN_SAMPLE_INPUT_HIST | 이력/로그 | 미확정 | 53426 | - | 0/0 | 3 | 0 |
| IMCN_SAMPLE_TEST | 미분류 | 미확정 | - | - | 0/0 | 0 | 0 |
| IMCN_SAMPLE_TEST_OLD | 미분류 | 미확정 | - | - | 0/0 | 0 | 0 |
| IMCN_TEMPERATURE_CHECK_MASTER | 미분류 | 미확정 | 257 | - | 0/0 | 0 | 0 |
| IMCN_WEEKLY_PM_CALENDAR | 미분류 | 미확정 | - | PLAN_YYYY, PLAN_WEEKS, MACHINE_CODE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IMCN_WEEKLY_PM_RESULT | 미분류 | 미확정 | - | PLAN_YYYY, PLAN_WEEKS, MACHINE_CODE, TPM_SEQUENCE, CODE_TYPE, CODE_GROUP, CODE_GROUP_SECOND, CODE_GROUP_THIRD, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ASSY_INVENTORY_CHECK_BCD | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_INVENTORY_CLOSE_SETTING | 자재/품목 | 미확정 | - | CLOSE_YYYYMM | 0/0 | 0 | 0 |
| IM_ITEM_ARRIVAL | 자재/품목 | ITEM ARRIVAL MASTER | - | ARRIVAL_DATE, ARRIVAL_SEQ_NO, ORGANIZATION_ID | 1/0 | 9 | 0 |
| IM_ITEM_ARRIVAL_GEN | 자재/품목 | 미확정 | - | ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_ASSEMBLY_REQUIR_ORDER | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_BAD_INVENTORY | 자재/품목 | 미확정 | - | MATERIAL_MFS, ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_BAKING_MASTER | 자재/품목 | 미확정 | 16957 | - | 0/0 | 11 | 1 |
| IM_ITEM_BILL_COLLECTION | 자재/품목 | 미확정 | - | BILL_COLLECTION_DATE, BILL_COLLECTION_SEQ, ORGANIZATION_ID | 1/0 | 1 | 0 |
| IM_ITEM_BILL_DISBURSE | 자재/품목 | 미확정 | - | BILL_DISBURSE_DATE, BILL_DISBURSE_SEQ, ORGANIZATION_ID | 0/0 | 1 | 0 |
| IM_ITEM_CURRENT_UNIT_PRICE | 자재/품목 | Item Buy Price Master | - | ITEM_CODE, LINE_TYPE, DATESET, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_CURRENT_UNIT_PRICE_4_S | 자재/품목 | Item Buy Price Master | - | SALE_PLAN_YYYY, SEQ_NO, ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 1/0 | 1 | 0 |
| IM_ITEM_DETAIL_4_PROFIT_COST | 자재/품목 | 미확정 | - | PLAN_YYYYMM, MFS, PARENT_ITEM_CODE, CHILD_ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_DIRECT_ORDER | 자재/품목 | 미확정 | - | ORDER_NO, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_DIVIDE_HIST | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_EXPENSE_COST_DISTRIBUT | 자재/품목 | 미확정 | - | INCIDENTAL_EXPENSE_CODE, DATESET, ORGANIZATION_ID | 1/0 | 0 | 0 |
| IM_ITEM_FBACK_INVENTORY | 자재/품목 | 미확정 | - | MATERIAL_MFS, ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 0/0 | 3 | 0 |
| IM_ITEM_FBACK_INVENTORY_CHECK | 자재/품목 | 미확정 | - | CLOSE_YYYYMM, ITEM_CODE, LINE_TYPE, MATERIAL_MFS, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_FBACK_INVENTORY_CLOSE | 자재/품목 | 미확정 | - | CLOSE_YYYYMM, ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_FBACK_INV_CLOSE_MFS | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_FBACK_ISSUE | 자재/품목 | 미확정 | - | ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID | 0/0 | 3 | 0 |
| IM_ITEM_FBACK_RECEIPT | 자재/품목 | 미확정 | - | RECEIPT_SEQUENCE, RECEIPT_DATE, ORGANIZATION_ID | 0/0 | 4 | 0 |
| IM_ITEM_FREE_INVENTORY | 자재/품목 | 미확정 | - | SUPPLIER_CODE, ITEM_CODE, LINE_TYPE, MATERIAL_MFS, ORGANIZATION_ID | 0/0 | 7 | 0 |
| IM_ITEM_FREE_INVENTORY_CHECK | 자재/품목 | Item Inventory Check Master | - | CLOSE_YYYYMM, SUPPLIER_CODE, ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 2/0 | 0 | 0 |
| IM_ITEM_FREE_INVENTORY_CLOSE | 자재/품목 | 미확정 | - | CLOSE_YYYYMM, SUPPLIER_CODE, ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 2/0 | 0 | 0 |
| IM_ITEM_FREE_INVENTORY_MFS | 자재/품목 | 미확정 | - | SUPPLIER_CODE, ITEM_CODE, MATERIAL_MFS, ORDER_GROUP_NO, INVOICE_NO, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_FREE_INV_CLOSE_MFS | 자재/품목 | 미확정 | - | CLOSE_YYYYMM, SUPPLIER_CODE, MATERIAL_MFS, ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_FREE_ISSUE | 자재/품목 | 미확정 | - | SUPPLIER_CODE, ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID | 2/0 | 3 | 0 |
| IM_ITEM_FREE_RCV_4_BASE_INV | 자재/품목 | 미확정 | - | SUPPLIER_CODE, RECEIPT_DATE, RECEIPT_SEQUENCE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_FREE_RECEIPT | 자재/품목 | 미확정 | - | SUPPLIER_CODE, RECEIPT_DATE, RECEIPT_SEQUENCE, ORGANIZATION_ID | 2/0 | 3 | 0 |
| IM_ITEM_INVENTORY | 자재/품목 | Item Inventory Master | 1707494 | - | 1/0 | 28 | 1 |
| IM_ITEM_INVENTORY_4_TIME | 자재/품목 | 미확정 | - | - | 0/0 | 2 | 0 |
| IM_ITEM_INVENTORY_BARCODE | 자재/품목 | 미확정 | - | ITEM_CODE_BARCODE, ORGANIZATION_ID | 0/0 | 2 | 0 |
| IM_ITEM_INVENTORY_CHECK | 자재/품목 | Item Inventory Check Master | - | - | 1/0 | 0 | 0 |
| IM_ITEM_INVENTORY_CHECK_BCD | 자재/품목 | 미확정 | 1 | - | 0/0 | 4 | 0 |
| IM_ITEM_INVENTORY_CHECK_EXCEL | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_INVENTORY_CLOSE | 자재/품목 | Item Inventory Close master | - | CLOSE_YYYYMM, ITEM_CODE, LINE_TYPE, LOCATION_CODE, ORGANIZATION_ID | 0/0 | 3 | 0 |
| IM_ITEM_INVENTORY_CLOSE_MFS | 자재/품목 | 미확정 | - | - | 0/0 | 2 | 0 |
| IM_ITEM_INVENTORY_CLOSE_MV | 자재/품목 | Item Inventory Close master | - | CLOSE_YYYYMM, ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_INVENTORY_GEN | 자재/품목 | 미확정 | - | ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_INVENTORY_HOLD | 자재/품목 | 미확정 | - | - | 0/0 | 1 | 0 |
| IM_ITEM_INVENTORY_LEDGER_REGEN | 자재/품목 | 미확정 | - | MATERIAL_MFS, ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 0/0 | 2 | 0 |
| IM_ITEM_INVENTORY_MOVE_HIST | 자재/품목 | Item Inventory Move History Master | - | MOVE_DATE, MOVE_SEQUENCE, ORGANIZATION_ID | 1/0 | 0 | 0 |
| IM_ITEM_INVENTORY_SCAN | 자재/품목 | 미확정 | - | BARCODE, ACTIVEDATE | 0/0 | 0 | 0 |
| IM_ITEM_INV_CHECK_INPUT_QTY | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_ISSUE | 자재/품목 | Item Issue Master | 2376531 | ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID | 1/0 | 19 | 0 |
| IM_ITEM_ISSUE_LEDGER_REGEN | 자재/품목 | 미확정 | - | ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID | 0/0 | 1 | 0 |
| IM_ITEM_ISSUE_LOSS | 자재/품목 | 미확정 | 32001 | - | 0/0 | 0 | 0 |
| IM_ITEM_ISSUE_RETURN_REQUEST | 자재/품목 | 미확정 | - | ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_LEDGER | 자재/품목 | 미확정 | - | CLOSE_YYYYMM, RECEIPT_ISSUE_SEQUENCE, ORGANIZATION_ID | 0/0 | 6 | 0 |
| IM_ITEM_LOCATION | 자재/품목 | Item Inventory Location | - | LOCATION_CODE, ORGANIZATION_ID | 1/0 | 0 | 0 |
| IM_ITEM_LOCATION_MOVE_HIST | 자재/품목 | 미확정 | - | MOVE_DATE, ORGANIZATION_ID, MATERIAL_MFS | 0/0 | 0 | 0 |
| IM_ITEM_MANUAL_INPUT_HISTORY | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_MASTER | 자재/품목 | 미확정 | 4222 | SUPPLIER_CODE, ITEM_CODE, ORGANIZATION_ID | 2/1 | 8 | 0 |
| IM_ITEM_MASTER_BACKUP | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_MASTER_PLAN_4_PO | 자재/품목 | 미확정 | - | REQUIRMENT_PLAN_DATE, REQUIRMENT_PLAN_SEQ, PLAN_DATE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_MASTER_PLAN_4_REQUIR | 자재/품목 | 미확정 | - | REQUIRMENT_PLAN_DATE, REQUIRMENT_PLAN_SEQ, PLAN_DATE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_MASTER_PLAN_4_REQUIR_S | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_MFS_SHIPPING_4_COST | 자재/품목 | 미확정 | - | SESSION_ID, PLAN_YYYYMM, MFS, ITEM_CODE, PARENT_ITEM_CODE, CHILD_ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_MSL_CHECK_MASTER | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_PURCHASE_ORDER | 자재/품목 | Item Purchase Order master | - | ORDER_NO, ORGANIZATION_ID | 0/0 | 2 | 0 |
| IM_ITEM_PURCHASE_ORDER_GEN | 자재/품목 | 미확정 | - | ITEM_CODE, LINE_TYPE, DELIVERY_DATE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_PURCHASE_ORDER_PLAN | 자재/품목 | 미확정 | - | ORDER_NO, ORGANIZATION_ID | 2/0 | 0 | 0 |
| IM_ITEM_PURCHASE_ORDER_WAIT | 자재/품목 | Item Purchase Order wait master | - | ORDER_NO, ORGANIZATION_ID | 0/0 | 1 | 0 |
| IM_ITEM_PURCHASE_REQUIR_ORDER | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_RANK_MASTER | 자재/품목 | 미확정 | 144 | - | 0/0 | 0 | 0 |
| IM_ITEM_RECEIPT | 자재/품목 | Item Receipt Master | 1380665 | RECEIPT_DATE, RECEIPT_SEQUENCE, ORGANIZATION_ID | 1/0 | 18 | 2 |
| IM_ITEM_RECEIPT_4_BASE_INV | 자재/품목 | 미확정 | - | RECEIPT_SEQUENCE, RECEIPT_DATE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_RECEIPT_BARCODE | 자재/품목 | 미확정 | 1843944 | - | 0/0 | 46 | 1 |
| IM_ITEM_RECEIPT_BARCODE_LOTBK | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_RECEIPT_EXPENSE_COST | 자재/품목 | 미확정 | - | RECEIPT_LOT_NO, ORGANIZATION_ID | 1/0 | 0 | 0 |
| IM_ITEM_RECEIPT_INVOICE_MASTER | 자재/품목 | 미확정 | - | SUPPLIER_CODE, INVOICE_DATE, INVOICE_OPEN_SEQUENCE, ORGANIZATION_ID | 0/0 | 1 | 0 |
| IM_ITEM_RECEIPT_LEDGER_REGEN | 자재/품목 | 미확정 | - | RECEIPT_SEQUENCE, RECEIPT_DATE, ORGANIZATION_ID | 0/0 | 1 | 0 |
| IM_ITEM_RECEIPT_RETURN_REQUEST | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_RECEIPT_SLIP | 자재/품목 | 미확정 | 193079 | - | 0/0 | 0 | 0 |
| IM_ITEM_RECEIPT_TEMP | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_RECYCLE_INVENTORY | 자재/품목 | 미확정 | - | MATERIAL_MFS, ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_REPAIR_INVENTORY | 자재/품목 | 미확정 | - | MATERIAL_MFS, ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 0/0 | 3 | 0 |
| IM_ITEM_REPAIR_INVENTORY_CHECK | 자재/품목 | 미확정 | - | CLOSE_YYYYMM, ITEM_CODE, LINE_TYPE, MATERIAL_MFS, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_REPAIR_INVENTORY_CLOSE | 자재/품목 | 미확정 | - | CLOSE_YYYYMM, ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_REPAIR_INV_CLOSE_MFS | 자재/품목 | 미확정 | - | CLOSE_YYYYMM, MATERIAL_MFS, ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_REPAIR_ISSUE | 자재/품목 | 미확정 | - | ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID | 0/0 | 3 | 0 |
| IM_ITEM_REPAIR_RECEIPT | 자재/품목 | 미확정 | - | RECEIPT_SEQUENCE, RECEIPT_DATE, ORGANIZATION_ID | 0/0 | 4 | 0 |
| IM_ITEM_REQUEST | 자재/품목 | Item Request Master | 7 | REQUEST_DATE, REQUEST_SEQUENCE, ORGANIZATION_ID | 1/0 | 5 | 0 |
| IM_ITEM_REQUIRMENT_LONGTERM | 자재/품목 | 미확정 | - | REQUIRMENT_PLAN_DATE, ITEM_CODE, SUPPLIER_CODE, LINE_TYPE, PLAN_DATE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_REQUIRMENT_ORDER | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_REQUIRMENT_PLAN | 자재/품목 | ???? ???? ????? | - | REQUIRMENT_PLAN_DATE, SUPPLIER_CODE, ITEM_CODE, LINE_TYPE, PLAN_DATE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_REQUIRMENT_PLAN_TEMP | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_REQUIR_PLAN_TEMP | 자재/품목 | 미확정 | - | - | 1/0 | 0 | 0 |
| IM_ITEM_SALE_INVENTORY | 자재/품목 | 미확정 | - | SUPPLIER_CODE, ITEM_CODE, ORGANIZATION_ID | 0/0 | 4 | 0 |
| IM_ITEM_SALE_INVENTORY_CHECK | 자재/품목 | 미확정 | - | CLOSE_YYYYMM, SUPPLIER_CODE, ITEM_CODE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_SALE_INVENTORY_CLOSE | 자재/품목 | 미확정 | - | CLOSE_YYYYMM, SUPPLIER_CODE, ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_SALE_INVOICE_MASTER | 자재/품목 | 미확정 | - | SUPPLIER_CODE, INVOICE_DATE, INVOICE_OPEN_SEQUENCE, ORGANIZATION_ID | 1/0 | 2 | 0 |
| IM_ITEM_SALE_ISSUE | 자재/품목 | 미확정 | - | SUPPLIER_CODE, ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID | 0/0 | 1 | 0 |
| IM_ITEM_SALE_PRICE | 자재/품목 | 미확정 | - | ITEM_CODE, SUPPLIER_CODE, LINE_TYPE, DATESET, ORGANIZATION_ID | 1/0 | 2 | 0 |
| IM_ITEM_SALE_RECEIPT | 자재/품목 | 미확정 | - | SUPPLIER_CODE, RECEIPT_DATE, RECEIPT_SEQUENCE, ORGANIZATION_ID | 1/0 | 2 | 0 |
| IM_ITEM_SAP_DATA | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_SCRAP_INVENTORY_CLOSE | 자재/품목 | 미확정 | - | CLOSE_YYYYMM, ITEM_CODE, LINE_TYPE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_SCRAP_ISSUE | 자재/품목 | Item Issue Master | - | ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID | 1/0 | 1 | 0 |
| IM_ITEM_SCRAP_RECEIPT | 자재/품목 | Item Receipt Master | - | RECEIPT_SEQUENCE, RECEIPT_DATE, ORGANIZATION_ID | 1/0 | 1 | 0 |
| IM_ITEM_SOLDER_INPUT_HIST | 자재/품목 | 미확정 | 76312 | - | 0/0 | 5 | 0 |
| IM_ITEM_SOLDER_MASTER | 자재/품목 | 미확정 | 34040 | - | 0/0 | 12 | 1 |
| IM_ITEM_SOLDER_MASTER_HIS | 자재/품목 | 미확정 | 73384 | - | 0/0 | 1 | 0 |
| IM_ITEM_SOLDER_TIMECHECK | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_TOTAL_4_PROFIT_COST | 자재/품목 | 미확정 | - | PLAN_YYYYMM, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_TOTAL_COST | 자재/품목 | 미확정 | - | PLAN_YYYYMM, ORGANIZATION_ID | 1/0 | 0 | 0 |
| IM_ITEM_TOTAL_INVENTORY | 자재/품목 | 미확정 | - | CLOSE_YYYYMM, ITEM_CODE, LINE_TYPE, TOTAL_INVENTORY_DIVISION, ORGANIZATION_ID, SESSION_ID | 0/0 | 0 | 0 |
| IM_ITEM_TOTAL_INVENTORY_CLOSE | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_TOTAL_INVENTORY_EXP | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_TOTAL_INVENTORY_GEN | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_UNIT_PRICE | 자재/품목 | Item Buy Price Master | 5208 | DATESET, ITEM_CODE, SUPPLIER_CODE, LINE_TYPE, ORGANIZATION_ID | 2/0 | 15 | 3 |
| IM_ITEM_UNIT_PRICE_BACK | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_WEEK | 자재/품목 | 미확정 | - | ITEM_CODE, WEEK_GUBUN, ORGANIZATION_ID | 0/0 | 1 | 0 |
| IM_ITEM_WORKSTAGE_INVENTORY | 자재/품목 | Item Inventory Master | 1232 | ITEM_CODE, ORGANIZATION_ID | 0/0 | 15 | 0 |
| IM_ITEM_WORKSTAGE_INV_CHECK | 자재/품목 | 미확정 | - | CLOSE_YYYYMM, MFS, MATERIAL_MFS, ITEM_CODE, LINE_TYPE, LINE_CODE, WORKSTAGE_CODE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_WORKSTAGE_INV_CLOSE | 자재/품목 | 미확정 | - | - | 0/0 | 3 | 0 |
| IM_ITEM_WORKSTAGE_INV_EXPAND | 자재/품목 | 미확정 | - | SESSION_ID, CLOSE_YYYYMM, MFS, MATERIAL_MFS, SET_ITEM_CODE, PARENT_ITEM_CODE, ITEM_CODE, LINE_TYPE, LINE_CODE, WORKSTAGE_CODE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_WORKSTAGE_ISSUE | 자재/품목 | Item Issue Master | 13589196 | ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID | 1/0 | 8 | 0 |
| IM_ITEM_WORKSTAGE_ISSUE_GEN | 자재/품목 | 미확정 | - | ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID | 0/0 | 1 | 0 |
| IM_ITEM_WORKSTAGE_ISSUE_PLAN | 자재/품목 | Item Issue Master | - | ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID | 1/0 | 1 | 0 |
| IM_ITEM_WORKSTAGE_RECEIPT | 자재/품목 | Item Issue Master | 1890761 | RECEIPT_DATE, RECEIPT_SEQUENCE, ORGANIZATION_ID | 0/0 | 11 | 0 |
| IM_ITEM_WORK_ORDER | 자재/품목 | 미확정 | - | - | 2/0 | 5 | 0 |
| IM_ITEM_WS_INVENTORY_REVERSE | 자재/품목 | 미확정 | - | - | 0/0 | 1 | 0 |
| IM_ITEM_WS_INVENTORY_REV_NOUSE | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_ITEM_WS_INVE_CHECK_EXCEL | 자재/품목 | 미확정 | - | CLOSE_YYYYMM, ITEM_CODE, LINE_TYPE, MFS, LINE_CODE, WORKSTAGE_CODE, LOCATION_CODE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_ITEM_WS_RECEIPT_4_BASE_INV | 자재/품목 | 미확정 | - | RECEIPT_DATE, RECEIPT_SEQUENCE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IM_MATERIAL_REQUEST | 자재/품목 | 미확정 | - | - | 0/0 | 0 | 0 |
| IM_TOTAL_PAYABLE_MASTER | 자재/품목 | 미확정 | - | SUPPLIER_CODE, ORGANIZATION_ID | 1/0 | 0 | 0 |
| IP_ASSEMBLY_ISSUE | 생산 | 미확정 | - | ISSUE_DATE, ISSUE_SEQUENCE, ORGANIZATION_ID | 1/0 | 4 | 0 |
| IP_ASSEMBLY_RESULT | 생산 | Product Actual Result Master | - | PRODUCT_DATE, PRODUCT_SEQUENCE | 3/0 | 5 | 0 |
| IP_ASSEMBLY_RESULT_BARCODE | 생산 | 미확정 | - | - | 0/0 | 2 | 0 |
| IP_ASSEMBLY_RESULT_HISTORY | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_LABEL_MASTER | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_LINE_DAILY_OPERATION | 생산 | 미확정 | - | PLAN_DATE, LINE_OPERATION_SEQUENCE, LINE_CODE, LINE_STATUS_CODE, ORGANIZATION_ID | 0/0 | 3 | 0 |
| IP_LINE_IDLE_TIME | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_MACHINE_DAILY_OPERATION | 생산 | 미확정 | - | PLAN_DATE, MACHINE_OPERATION_SEQUENCE, MACHINE_CODE, MACHINE_STATUS, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IP_PRODUCT_2D_BARCODE | 생산 | 미확정 | 172596557 | RUN_NO, SERIAL_NO | 1/0 | 61 | 2 |
| IP_PRODUCT_BOX_YYYYMMDDNN | 생산 | 미확정 | 131 | - | 0/0 | 1 | 0 |
| IP_PRODUCT_CARRIER_BARCODE | 생산 | 미확정 | - | SERIAL_NO | 0/0 | 0 | 0 |
| IP_PRODUCT_COMPANY_CALENDAR | 생산 | 미확정 | - | PLAN_DATE, ORGANIZATION_ID | 1/0 | 1 | 0 |
| IP_PRODUCT_DAILY_LINE_CAPACITY | 생산 | 미확정 | - | PLAN_DATE, LINE_CODE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IP_PRODUCT_DAILY_MCN_CAPACITY | 생산 | 미확정 | - | PLAN_DATE, MACHINE_CODE, ORGANIZATION_ID | 0/0 | 4 | 0 |
| IP_PRODUCT_DAILY_RESULT | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_DAILY_WS_CAPACITY | 생산 | 미확정 | - | PLAN_DATE, WORKSTAGE_CODE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IP_PRODUCT_DEFECT | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_DELIVERY_MONTH_PLAN | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_DELIVERY_PLAN | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_FG_INVENTORY | 생산 | 미확정 | 562825 | - | 0/0 | 14 | 0 |
| IP_PRODUCT_FG_ISSUE | 생산 | 미확정 | 501116 | ISSUE_DATE, ISSUE_SEQUENCE | 0/0 | 7 | 0 |
| IP_PRODUCT_FG_PALLET | 생산 | 파렛트 작업 마스터 ( 재고테이블을 이용) | - | - | 0/0 | 7 | 0 |
| IP_PRODUCT_FG_RECEIPT | 생산 | 미확정 | 553620 | RECEIPT_DATE, RECEIPT_SEQUENCE | 0/0 | 4 | 0 |
| IP_PRODUCT_INV_4_REQUIREMENT | 생산 | 미확정 | - | ITEM_CODE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IP_PRODUCT_ISSUE_PID_SCAN | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_LASER_MARKING | 생산 | 미확정 | - | - | 0/0 | 1 | 0 |
| IP_PRODUCT_LINE | 생산 | Product Line Master | 56 | LINE_CODE, ORGANIZATION_ID | 1/9 | 60 | 9 |
| IP_PRODUCT_LINE_BARCODE | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_LINE_CALENDAR | 생산 | 미확정 | - | PLAN_DATE, ORGANIZATION_ID, LINE_CODE | 1/0 | 0 | 0 |
| IP_PRODUCT_LINE_CAPACITY | 생산 | 미확정 | - | LINE_CODE, ORGANIZATION_ID | 1/0 | 0 | 0 |
| IP_PRODUCT_LINE_RESULT | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_LINE_TARGET | 생산 | 미확정 | - | - | 0/0 | 2 | 1 |
| IP_PRODUCT_MAGAZINE | 생산 | 미확정 | - | - | 0/0 | 1 | 0 |
| IP_PRODUCT_MAGAZINE_HIS | 생산 | 미확정 | - | - | 0/0 | 2 | 0 |
| IP_PRODUCT_MCN_CALENDAR | 생산 | 미확정 | - | PLAN_DATE, MACHINE_CODE, ORGANIZATION_ID | 1/0 | 0 | 0 |
| IP_PRODUCT_MI_MONTH_PLAN | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_MI_PLAN | 생산 | 미확정 | 18171 | - | 0/0 | 2 | 1 |
| IP_PRODUCT_MOBILIZATION | 생산 | 미확정 | - | - | 3/0 | 0 | 0 |
| IP_PRODUCT_MODEL_MASTER | 생산 | 미확정 | 312 | MODEL_NAME, ORGANIZATION_ID | 0/1 | 74 | 1 |
| IP_PRODUCT_MODEL_ST_MASTER | 생산 | 미확정 | 4018 | - | 0/0 | 5 | 0 |
| IP_PRODUCT_MOLD_CALENDAR | 생산 | 미확정 | - | PLAN_DATE, MOLD_CODE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IP_PRODUCT_PACK_ASSY_MASTER | 생산 | 미확정 | 8 | - | 0/0 | 0 | 0 |
| IP_PRODUCT_PACK_MASTER | 생산 | 미확정 | 566914 | PACK_BARCODE | 0/0 | 18 | 0 |
| IP_PRODUCT_PACK_MASTER_DEL | 생산 | 미확정 | - | - | 0/0 | 1 | 0 |
| IP_PRODUCT_PACK_SERIAL | 생산 | 미확정 | 8448273 | BARCODE | 0/0 | 10 | 0 |
| IP_PRODUCT_PCB_SCAN_MASTER | 생산 | 미확정 | 363385 | - | 0/0 | 9 | 0 |
| IP_PRODUCT_PDA_SCAN_MASTER | 생산 | 미확정 | - | - | 0/0 | 1 | 0 |
| IP_PRODUCT_PIDCHECK_HISTORY | 생산 | 미확정 | 13 | - | 0/0 | 1 | 0 |
| IP_PRODUCT_REINPUT_RESULT | 생산 | 미확정 | - | - | 0/0 | 1 | 0 |
| IP_PRODUCT_REPAIR | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_RESULT | 생산 | Product Actual Result Master | - | PRODUCT_DATE, PRODUCT_SEQUENCE, ORGANIZATION_ID | 4/0 | 11 | 0 |
| IP_PRODUCT_RESULT_BARCODE | 생산 | 미확정 | - | - | 0/0 | 3 | 0 |
| IP_PRODUCT_RESULT_HISTORY | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_REWORK_RESULT | 생산 | Product Actual Result Master | - | PRODUCT_DATE, PRODUCT_SEQUENCE, ORGANIZATION_ID | 3/0 | 3 | 0 |
| IP_PRODUCT_ROUTING | 생산 | 미확정 | - | ROUTE_NO, WORKSTAGE_CODE, ORGANIZATION_ID | 2/0 | 2 | 0 |
| IP_PRODUCT_ROUTING_MASTER | 생산 | 미확정 | - | ROUTE_NO, ORGANIZATION_ID | 1/1 | 0 | 0 |
| IP_PRODUCT_RUNNING_HIST | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_RUN_CARD | 생산 | 미확정 | 36951 | RUN_NO, ORGANIZATION_ID | 0/0 | 36 | 2 |
| IP_PRODUCT_RUN_CARD_CLOSE | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_RUN_CARD_DETAIL | 생산 | 미확정 | 63505 | - | 0/0 | 4 | 0 |
| IP_PRODUCT_RUN_CARD_INV | 생산 | 미확정 | 810 | - | 0/0 | 2 | 0 |
| IP_PRODUCT_RUN_CARD_IO | 생산 | 미확정 | 231144 | - | 0/0 | 6 | 0 |
| IP_PRODUCT_RUN_CARD_IO_BACK | 생산 | 미확정 | 6246 | - | 0/0 | 0 | 0 |
| IP_PRODUCT_RUN_MODEL | 생산 | 미확정 | - | - | 0/0 | 7 | 0 |
| IP_PRODUCT_RUN_MODEL_LOG | 생산 | 미확정 | - | - | 0/0 | 3 | 0 |
| IP_PRODUCT_SCAN_HISTORY | 생산 | 미확정 | 3 | PID | 0/0 | 1 | 0 |
| IP_PRODUCT_SENSOR_ACTUAL | 생산 | 미확정 | 7 | - | 0/0 | 7 | 0 |
| IP_PRODUCT_SENSOR_ACTUAL_BACK | 생산 | 미확정 | 15194 | - | 0/0 | 3 | 0 |
| IP_PRODUCT_SENSOR_ACTUAL_HOUR | 생산 | 미확정 | 233684 | - | 0/0 | 2 | 0 |
| IP_PRODUCT_SENSOR_ACTUAL_TIME | 생산 | 미확정 | 105108 | - | 0/0 | 6 | 0 |
| IP_PRODUCT_SERIAL_RESULT | 생산 | 미확정 | - | - | 0/0 | 1 | 0 |
| IP_PRODUCT_SHIFT_RESULT | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_SMD_MONTH_PLAN | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_SMD_PLAN | 생산 | 미확정 | 18921 | - | 0/0 | 3 | 0 |
| IP_PRODUCT_SMD_PLAN_ISSUE | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_SOFTWARE_EXCEL | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_SOFTWARE_MASTER | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_SPEC_CONFIRM_DOC | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_SSCD_DATA_CHECK | 생산 | 미확정 | - | PID, ORGANIZATION_ID | 0/0 | 3 | 0 |
| IP_PRODUCT_ST | 생산 | 미확정 | - | ITEM_CODE, LINE_CODE, ORGANIZATION_ID | 2/0 | 1 | 0 |
| IP_PRODUCT_WORKORDER_DOCUMENT | 생산 | 미확정 | - | ITEM_CODE, DOCUMENT_SEQ, ORGANIZATION_ID | 1/0 | 0 | 0 |
| IP_PRODUCT_WORKSTAGE | 생산 | 미확정 | 32 | WORKSTAGE_CODE, ORGANIZATION_ID | 1/4 | 10 | 8 |
| IP_PRODUCT_WORKSTAGE_INV | 생산 | 미확정 | - | RUN_NO, LINE_CODE, WORKSTAGE_CODE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IP_PRODUCT_WORKSTAGE_IO | 생산 | 미확정 | 232294 | - | 0/0 | 9 | 3 |
| IP_PRODUCT_WORKSTAGE_RESULT | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_WORK_QC | 생산 | 미확정 | 69471 | SERIAL_NO, QC_SEQUENCE, ORGANIZATION_ID | 0/0 | 12 | 1 |
| IP_PRODUCT_WORK_QC_EXCEL | 생산 | 미확정 | - | SERIAL_NO, WORKSTAGE_CODE, QC_DATE, BAD_REASON_CODE | 0/0 | 0 | 0 |
| IP_PRODUCT_WORK_QC_IMAGE | 생산 | 미확정 | 3 | - | 0/0 | 0 | 0 |
| IP_PRODUCT_WORK_QC_REPAIR_ITEM | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IP_PRODUCT_WORK_TIME | 생산 | 미확정 | - | - | 0/0 | 1 | 0 |
| IP_PRODUCT_WS_CALENDAR | 생산 | 미확정 | - | PLAN_DATE, ORGANIZATION_ID, WORKSTAGE_CODE | 0/0 | 0 | 0 |
| IP_PRODUCT_WS_CAPACITY | 생산 | 미확정 | - | WORKSTAGE_CODE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IP_PRODUCT_YEAR_BASE | 생산 | 미확정 | 273 | MODEL_NAME, YYYY, ORGANIZATION_ID | 0/0 | 6 | 0 |
| IP_PROD_MATERIAL_TRACKING_KFC | 생산 | 미확정 | - | - | 0/0 | 2 | 0 |
| IP_SHIFT_TIME_MASTER | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| IQC_INSPECTION_TEMPLATE | 미분류 | IQC_INSPECTION_TEMPLATE[아이템별 검사항목] | 485 | ORGANIZATION_ID, INSPECT_GROUP, DISPLAY_SEQ | 0/0 | 0 | 0 |
| IQC_INSPECTION_TIME_CHECK | 미분류 | IQC_INSPECTION_TIME_CHECK[타임체크검사결과] | 59924 | - | 0/0 | 0 | 0 |
| IQ_4M_MASTER | 품질 | 미확정 | 11 | - | 0/0 | 0 | 0 |
| IQ_DAILY_DASHBOARD | 품질 | 미확정 | - | - | 0/0 | 0 | 0 |
| IQ_DAILY_NOTIFY | 품질 | 미확정 | - | - | 0/0 | 0 | 0 |
| IQ_INSPECT_MASTER_SAMPLE_LOG | 품질 | 미확정 | - | - | 0/0 | 1 | 0 |
| IQ_INSPECT_MAXPOWER_SPEC | 품질 | 미확정 | - | - | 0/0 | 0 | 0 |
| IQ_INTERLOCK_CHECK_CONDITION | 품질 | 미확정 | 316 | - | 0/0 | 14 | 0 |
| IQ_INTERLOCK_CHECK_COND_LOG | 품질 | 미확정 | 3047 | - | 0/0 | 2 | 0 |
| IQ_INTERLOCK_CHECK_ERROR | 품질 | 미확정 | - | - | 0/0 | 0 | 0 |
| IQ_INTERLOCK_CHECK_RESULT | 품질 | 미확정 | - | - | 0/0 | 20 | 0 |
| IQ_INTERLOCK_CHECK_RESULT_SUM | 품질 | 미확정 | - | - | 0/0 | 0 | 0 |
| IQ_INTERLOCK_REFLOW_DATA | 품질 | 미확정 | - | - | 0/0 | 3 | 0 |
| IQ_INTERLOCK_REFLOW_STATUS | 품질 | 미확정 | - | LINE_CODE, ORGANIZATION_ID | 0/0 | 1 | 0 |
| IQ_INTERLOCK_REQUEST_LOG | 품질 | 미확정 | 5022216 | - | 0/0 | 2 | 0 |
| IQ_IQC_DOCUMENT | 품질 | 미확정 | - | IQC_INSPECT_NO, SEQUENCE, ORGANIZATION_ID | 1/0 | 0 | 0 |
| IQ_IQC_INSPECT_HISTORY | 품질 | 미확정 | - | - | 0/0 | 0 | 0 |
| IQ_ITEM_EQUIPMENT_DETAIL | 품질 | 미확정 | - | INSPECT_EQUIPMENT, INSPECT_EQUIPMENT_NAME, ORGANIZATION_ID | 1/0 | 0 | 0 |
| IQ_ITEM_INSPECT_GROUP | 품질 | 미확정 | - | INSPECT_PROCESS, SEQ_NO, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IQ_ITEM_IQC | 품질 | IQC Inspect Master | 242 | INSPECT_DATE, INSPECT_SEQUENCE, ORGANIZATION_ID | 1/0 | 1 | 0 |
| IQ_ITEM_IQC_BAD | 품질 | IQC Inspect Master | - | IQC_INSPECT_NO, BAD_REASON_CODE, ORGANIZATION_ID | 1/0 | 1 | 0 |
| IQ_ITEM_IQC_CRITERION | 품질 | 미확정 | - | INSPECT_PROCESS, SEQ_NO, ITEM_CODE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| IQ_ITEM_IQC_RANGE | 품질 | IQC Master | - | INSPECT_PROCESS, INSPECT_IQC_STRICT_DGREE, ORGANIZATION_ID | 0/0 | 1 | 0 |
| IQ_ITEM_OQC_CRITERION | 품질 | 미확정 | - | INSPECT_PROCESS, SEQ_NO, ITEM_CODE, ORGANIZATION_ID | 0/0 | 2 | 0 |
| IQ_LED_INSPECT_CONDITION | 품질 | 미확정 | - | - | 0/0 | 0 | 0 |
| IQ_MACHINE_INSPECT_AOI | 품질 | 미확정 | 104792211 | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_AOI_I | 품질 | 미확정 | - | - | 0/0 | 0 | 0 |
| IQ_MACHINE_INSPECT_AOI_I_TF | 품질 | 미확정 | - | - | 0/0 | 0 | 0 |
| IQ_MACHINE_INSPECT_AOI_LOG | 품질 | 미확정 | - | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_AOI_R | 품질 | 미확정 | - | - | 0/0 | 0 | 0 |
| IQ_MACHINE_INSPECT_AOI_R_TF | 품질 | 미확정 | - | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_DATA_AEEV | 품질 | 미확정 | 112805 | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_DATA_AOI | 품질 | 미확정 | 159325766 | - | 0/0 | 16 | 1 |
| IQ_MACHINE_INSPECT_DATA_BMA | 품질 | 미확정 | 54085564 | - | 0/0 | 2 | 0 |
| IQ_MACHINE_INSPECT_DATA_CMA | 품질 | 미확정 | 12820 | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_DATA_DN8 | 품질 | 미확정 | - | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_DATA_ECM | 품질 | 미확정 | - | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_DATA_EOL | 품질 | 미확정 | - | - | 0/0 | 2 | 0 |
| IQ_MACHINE_INSPECT_DATA_EOP | 품질 | 미확정 | 312097 | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_DATA_ETT28 | 품질 | 미확정 | 2502904 | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_DATA_ICT | 품질 | 미확정 | 87943780 | - | 0/0 | 6 | 0 |
| IQ_MACHINE_INSPECT_DATA_ICT2 | 품질 | 미확정 | - | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_DATA_IMPORT | 품질 | 미확정 | - | - | 0/0 | 0 | 0 |
| IQ_MACHINE_INSPECT_DATA_LV | 품질 | 미확정 | - | SERIAL_NO, MEAS_TIME | 0/0 | 0 | 0 |
| IQ_MACHINE_INSPECT_DATA_LX2 | 품질 | 미확정 | - | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_DATA_MASK | 품질 | 미확정 | - | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_DATA_MAXP | 품질 | 미확정 | - | - | 0/0 | 0 | 0 |
| IQ_MACHINE_INSPECT_DATA_MK | 품질 | 미확정 | 101449304 | - | 0/0 | 12 | 0 |
| IQ_MACHINE_INSPECT_DATA_MOC28 | 품질 | 미확정 | - | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_DATA_M_AOI | 품질 | 미확정 | - | - | 0/0 | 0 | 0 |
| IQ_MACHINE_INSPECT_DATA_O1XX | 품질 | 미확정 | 1486315 | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_DATA_PICKUP | 품질 | 미확정 | - | - | 0/0 | 0 | 0 |
| IQ_MACHINE_INSPECT_DATA_REFLOW | 품질 | 미확정 | 6403777 | - | 0/0 | 5 | 0 |
| IQ_MACHINE_INSPECT_DATA_RT | 품질 | 미확정 | - | - | 0/0 | 4 | 0 |
| IQ_MACHINE_INSPECT_DATA_RW | 품질 | 미확정 | - | - | 0/0 | 6 | 0 |
| IQ_MACHINE_INSPECT_DATA_SOLDER | 품질 | 미확정 | 1796 | - | 0/0 | 3 | 0 |
| IQ_MACHINE_INSPECT_DATA_SP | 품질 | 미확정 | 17749479 | - | 0/0 | 5 | 0 |
| IQ_MACHINE_INSPECT_DATA_SPI | 품질 | 미확정 | 96313643 | - | 0/0 | 12 | 1 |
| IQ_MACHINE_INSPECT_DATA_SPLIT | 품질 | 미확정 | 124046 | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_DATA_STWM | 품질 | 미확정 | 2256 | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_DATA_TILT | 품질 | 미확정 | - | SERIAL_NO | 0/0 | 0 | 0 |
| IQ_MACHINE_INSPECT_DATA_TTM28 | 품질 | 미확정 | - | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_DATA_WAVE1 | 품질 | 미확정 | - | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_DATA_WAVE2 | 품질 | 미확정 | - | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_MANUAL | 품질 | 미확정 | - | INSPECT_DATE, PRODUCT_ID | 0/0 | 0 | 0 |
| IQ_MACHINE_INSPECT_MAXP_HIST | 품질 | 미확정 | - | - | 0/0 | 0 | 0 |
| IQ_MACHINE_INSPECT_NPM1_RAW | 품질 | 미확정 | - | - | 0/0 | 2 | 0 |
| IQ_MACHINE_INSPECT_NPM2_RAW | 품질 | 미확정 | - | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_NPM3_RAW | 품질 | 미확정 | - | - | 0/0 | 2 | 0 |
| IQ_MACHINE_INSPECT_NSNP | 품질 | 미확정 | 475276 | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_PICKUP | 품질 | 미확정 | 1773 | LINE_CODE, MACHINE_CODE, FEEDERBASEID, SLOTNO | 0/0 | 3 | 0 |
| IQ_MACHINE_INSPECT_PICKUP_QRY | 품질 | 미확정 | 895372 | - | 0/0 | 1 | 0 |
| IQ_MACHINE_INSPECT_PICKUP_RATE | 품질 | 미확정 | 13312161 | - | 0/0 | 10 | 0 |
| IQ_MACHINE_INSPECT_PMNT1 | 품질 | 미확정 | - | - | 0/0 | 2 | 0 |
| IQ_MACHINE_INSPECT_PMNT2 | 품질 | 미확정 | - | - | 0/0 | 2 | 0 |
| IQ_MACHINE_INSPECT_PMNT3 | 품질 | 미확정 | - | - | 0/0 | 2 | 0 |
| IQ_MACHINE_INSPECT_PMNT4 | 품질 | 미확정 | - | - | 0/0 | 2 | 0 |
| IQ_MACHINE_INSPECT_SMNT1 | 품질 | 미확정 | 378309868 | - | 0/0 | 2 | 0 |
| IQ_MACHINE_INSPECT_SMNT2 | 품질 | 미확정 | 362684234 | ORGANIZATION_ID, RUN_NO, LINE_CODE, MACHINE_CODE, FEEDERBASEID, SLOTNO | 0/0 | 3 | 0 |
| IQ_MACHINE_INSPECT_SPI | 품질 | 미확정 | 88176503 | - | 0/0 | 2 | 0 |
| IQ_MACHINE_INSPECT_SPI_COUNT | 품질 | 미확정 | - | - | 0/0 | 0 | 0 |
| IQ_MACHINE_INSPECT_SPI_NG | 품질 | 미확정 | - | - | 0/0 | 0 | 0 |
| IQ_OQC_INSPECT_HISTORY | 품질 | 미확정 | - | - | 0/0 | 1 | 0 |
| IQ_PRODUCT_WQC | 품질 | 미확정 | 50 | - | 0/0 | 11 | 0 |
| IQ_SUPPLIER_LOT_BLOKING | 품질 | 미확정 | - | - | 0/0 | 1 | 0 |
| ISAL_PRODUCT_INVENTORY | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| ISAL_PRODUCT_RECEIPT | 생산 | 미확정 | - | - | 0/0 | 0 | 0 |
| ISAL_PRODUCT_SHIPPING | 출하 | 미확정 | - | - | 0/0 | 0 | 0 |
| ISAL_SHIPPING_LOT_DETAIL | 출하 | 미확정 | - | LOT_NO, LOT_SEQUENCE, ORGANIZATION_ID | 0/0 | 2 | 0 |
| ISAL_SHIPPING_LOT_MASTER | 출하 | 미확정 | - | LOT_NO, ORGANIZATION_ID | 0/0 | 3 | 0 |
| ISYS_ALERT_MASTER | 시스템/기준정보 | 미확정 | - | DATESET, ORGANIZATION_ID | 1/0 | 0 | 0 |
| ISYS_AUDIT_MESSAGE | 시스템/기준정보 | 미확정 | - | AUDIT_MESSAGE_ID, AUDIT_DATE, ORGANIZATION_ID | 2/0 | 3 | 0 |
| ISYS_AUDIT_MESSAGE_CODE | 시스템/기준정보 | 미확정 | - | MSG_ID, ORGANIZATION_ID | 2/2 | 1 | 0 |
| ISYS_AUDIT_MESSAGE_FILTER | 시스템/기준정보 | 미확정 | - | USER_ID, MSG_ID, ORGANIZATION_ID | 1/0 | 0 | 0 |
| ISYS_AUDIT_MESSAGE_HISTORY | 시스템/기준정보 | 미확정 | - | AUDIT_MESSAGE_ID, AUDIT_DATE, ORGANIZATION_ID | 1/0 | 1 | 0 |
| ISYS_BASECODE | 시스템/기준정보 | Base code Master Table | 2249 | CODE_TYPE, CODE_NAME, ORGANIZATION_ID | 1/0 | 5 | 10 |
| ISYS_BASECODE_YTMES | 시스템/기준정보 | 미확정 | 3898 | - | 0/0 | 0 | 0 |
| ISYS_BATCHJOBERRLOG | 시스템/기준정보 | 미확정 | 5960 | - | 0/0 | 9 | 0 |
| ISYS_CODE_MASTER | 시스템/기준정보 | 미확정 | 248 | CODE_TYPE, CODE_GROUP, CODE_NAME, CODE_GROUP_SECOND, CODE_GROUP_THIRD, ORGANIZATION_ID | 1/0 | 1 | 0 |
| ISYS_COMM_CONFIGS | 시스템/기준정보 | 미확정 | - | CONFIG_NAME | 0/0 | 0 | 7 |
| ISYS_COMPANY | 시스템/기준정보 | 미확정 | 1 | COMPANY_CODE | 0/0 | 0 | 3 |
| ISYS_CONFIG | 시스템/기준정보 | 미확정 | 90 | CONFIG_NAME, ORGANIZATION_ID | 1/0 | 23 | 2 |
| ISYS_DATAOBJECT | 시스템/기준정보 | 미확정 | 16 | ORGANIZATION_ID, WINDOW_NAME, DATAOBJECT_NAME | 0/0 | 0 | 0 |
| ISYS_DATA_FILTER | 시스템/기준정보 | 미확정 | - | WINDOW_NAME, DATAWINDOW_NAME, FILTER_TEXT, ORGANIZATION_ID | 2/0 | 0 | 0 |
| ISYS_DEFAULT_12_MONTHS | 시스템/기준정보 | 미확정 | - | - | 0/0 | 0 | 0 |
| ISYS_DEFAULT_VALUE | 시스템/기준정보 | 미확정 | 57 | WINDOW_NAME, DATAWINDOW_NAME, COLUMN_NAME, ORGANIZATION_ID | 0/0 | 0 | 0 |
| ISYS_DEPARTMENT | 시스템/기준정보 | Department Master | 12 | DEPARTMENT_CODE, ORGANIZATION_ID | 1/1 | 1 | 5 |
| ISYS_DUAL_LANGUAGE | 시스템/기준정보 | Dual Language Master | 9621 | ENGLISH_TEXT, ORGANIZATION_ID | 1/0 | 3 | 2 |
| ISYS_DUAL_LANGUAGE2 | 시스템/기준정보 | 미확정 | - | - | 0/0 | 0 | 0 |
| ISYS_DUAL_LANGUAGE_YTMES | 시스템/기준정보 | 미확정 | 6990 | - | 0/0 | 0 | 0 |
| ISYS_DUAL_MESSAGE | 시스템/기준정보 | Dual Message Master | 212 | MSG_ID | 0/1 | 0 | 0 |
| ISYS_DUAL_MESSAGE_DIRECT | 시스템/기준정보 | 미확정 | 566 | - | 0/0 | 1 | 0 |
| ISYS_DUAL_MESSAGE_YTMES | 시스템/기준정보 | 미확정 | 414 | - | 0/0 | 0 | 0 |
| ISYS_DWZOOM | 시스템/기준정보 | Data Window Print Size Master | - | WINDOW_NAME, DATAWINDOW_NAME, ORGANIZATION_ID | 1/1 | 0 | 0 |
| ISYS_DYNAMIC_MENU | 시스템/기준정보 | 미확정 | 522 | MENU_NAME, MENU_ITEM_NAME, ORGANIZATION_ID | 1/0 | 0 | 0 |
| ISYS_DYNAMIC_MENU_SHS | 시스템/기준정보 | 미확정 | - | MENU_NAME, MENU_ITEM_NAME, ORGANIZATION_ID | 0/0 | 0 | 0 |
| ISYS_ERROR | 시스템/기준정보 | 미확정 | - | APPLICATION_INITIAL, APPLICATION_NAME, ORIGINAL_ERROR_CODE, ORGANIZATION_ID | 1/0 | 0 | 0 |
| ISYS_ERROR_TRACE | 시스템/기준정보 | 미확정 | 6087 | APPLICATION_NAME, WINDOW_NAME, COMPUTER_NAME, ERROR_ACTIVE_DATE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| ISYS_EXCHANGE_RATE | 시스템/기준정보 | 미확정 | - | DATESET, CURRENCY, ORGANIZATION_ID | 1/0 | 0 | 0 |
| ISYS_HELP_VIDEO | 시스템/기준정보 | 미확정 | - | HELP_ID, ORGANIZATION_ID | 1/0 | 0 | 0 |
| ISYS_INVENTORY_CLOSE_DATE | 시스템/기준정보 | 미확정 | 24 | - | 0/0 | 1 | 0 |
| ISYS_JOB_TIMECHECK | 시스템/기준정보 | 미확정 | 26 | - | 0/0 | 1 | 0 |
| ISYS_LABEL_FORM | 시스템/기준정보 | 미확정 | 229 | - | 0/0 | 1 | 0 |
| ISYS_MENU | 시스템/기준정보 | 미확정 | 3 | USER_ID, APPLICATION_NAME, WINDOW_NAME, ORGANIZATION_ID | 0/0 | 0 | 0 |
| ISYS_MONITOR | 시스템/기준정보 | 미확정 | - | MONITOR_ITEM, MONITOR_DATE, ORGANIZATION_ID | 1/0 | 1 | 0 |
| ISYS_OBJECT | 시스템/기준정보 | 미확정 | 1865 | OBJECT_NAME, OBJECT_TYPE, ORGANIZATION_ID | 1/0 | 0 | 0 |
| ISYS_OBJECT_SOURCE | 시스템/기준정보 | 미확정 | - | - | 0/0 | 0 | 0 |
| ISYS_ORGANIZATION | 시스템/기준정보 | Organization Master | 1 | ORGANIZATION_ID | 0/51 | 1 | 10 |
| ISYS_PRIVILEGE | 시스템/기준정보 | Privilege Master | 41127 | ROLE_CODE, USER_ID, WINDOW_NAME, ORGANIZATION_ID | 3/0 | 0 | 0 |
| ISYS_PUB_BOARD | 시스템/기준정보 | Bulletin Board Master | - | SEQ_NO, REG_DATE, ORGANIZATION_ID | 1/0 | 0 | 0 |
| ISYS_PUB_WORK_BOARD | 시스템/기준정보 | 미확정 | 5 | SEQ_NO, REG_DATE, ORGANIZATION_ID | 0/0 | 0 | 0 |
| ISYS_REPORT_MENU | 시스템/기준정보 | 미확정 | - | REPORT_DIVISION, REPORT_GROUP, REPORT_TITLE, ORGANIZATION_ID | 0/0 | 1 | 0 |
| ISYS_REPORT_SOURCE | 시스템/기준정보 | 미확정 | - | DATAWINDOW_NAME, ORGANIZATION_ID | 0/0 | 0 | 0 |
| ISYS_REPORT_SOURCE_WHERE | 시스템/기준정보 | 미확정 | - | DATAWINDOW_NAME, ARGUMENT_NAME, ORGANIZATION_ID | 0/0 | 0 | 0 |
| ISYS_REPORT_WHERE_CONDITION | 시스템/기준정보 | 미확정 | - | WINDOW_NAME, ORGANIZATION_ID, DATAWINDOW_NAME, COLUMN_NAME | 0/0 | 0 | 0 |
| ISYS_REPORT_WINDOW_MASTER | 시스템/기준정보 | 미확정 | - | WINDOW_NAME, DATAWINDOW_NAME, ORGANIZATION_ID | 0/0 | 0 | 0 |
| ISYS_REPORT_WINDOW_PROPERTY | 시스템/기준정보 | 미확정 | - | - | 0/0 | 0 | 0 |
| ISYS_ROLE | 시스템/기준정보 | User Role Master | 2224 | ROLE_CODE, WINDOW_NAME, ORGANIZATION_ID | 1/1 | 0 | 0 |
| ISYS_SCHEDULER_JOBS | 시스템/기준정보 | 스케줄러 작업 정의 | - | ORGANIZATION_ID, JOB_CODE | 0/2 | 0 | 4 |
| ISYS_SCHEDULER_LOGS | 시스템/기준정보 | 스케줄러 실행 로그 | - | ORGANIZATION_ID, LOG_ID | 1/0 | 0 | 4 |
| ISYS_SCHEDULER_NOTIFICATIONS | 시스템/기준정보 | 스케줄러 알림 | - | ORGANIZATION_ID, NOTI_ID | 1/0 | 0 | 3 |
| ISYS_SOUND_MENT | 시스템/기준정보 | 미확정 | - | - | 0/0 | 3 | 1 |
| ISYS_SYSTEM_ACCESS | 시스템/기준정보 | 미확정 | 475019 | APPLICATION_NAME, WINDOW_NAME, EXECUTION_OBJECT_NAME, ACCESS_DATE, ACCESS_BY, MAC_ADDRESS, ORGANIZATION_ID | 1/0 | 1 | 0 |
| ISYS_SYSTEM_INTERFACE | 시스템/기준정보 | 미확정 | - | INTERFACE_CODE, ORGANIZATION_ID | 1/0 | 0 | 0 |
| ISYS_USERS | 시스템/기준정보 | User Master | 48 | USER_ID, ORGANIZATION_ID | 2/0 | 2 | 13 |
| ISYS_USER_WAREHOUSE | 시스템/기준정보 | 미확정 | - | - | 0/0 | 0 | 0 |
| ISYS_VERSION | 시스템/기준정보 | 미확정 | 2 | SEQ_NO, APPLICATION_NAME, ORGANIZATION_ID | 1/0 | 0 | 0 |
| ISYS_VERSION_HISTORY | 시스템/기준정보 | 미확정 | - | NEW_VERSION, APPLICATION_NAME, ORGANIZATION_ID | 1/0 | 0 | 0 |
| ISYS_WINDOW | 시스템/기준정보 | Application Window Master | 557 | WINDOW_NAME, ORGANIZATION_ID | 1/1 | 0 | 0 |
| ISYS_WINDOW_ISO_TAG | 시스템/기준정보 | 미확정 | - | - | 0/0 | 0 | 0 |
| ISYS_WINDOW_PROPERTY | 시스템/기준정보 | 미확정 | - | WINDOW_NAME, DATAWINDOW_NAME, COLUMN_NAME, ORGANIZATION_ID | 0/0 | 0 | 0 |
| ISYS_WINDOW_SHS | 시스템/기준정보 | 미확정 | - | WINDOW_NAME, ORGANIZATION_ID | 0/0 | 0 | 0 |
| ISYS_WORD_DICTIONARY | 시스템/기준정보 | 미확정 | - | - | 0/0 | 0 | 0 |
| ISYS_WORK_BOARD | 시스템/기준정보 | 미확정 | - | WORK_BOARD_SEQUENCE, ORGANIZATION_ID | 1/0 | 0 | 0 |
| IS_PRODUCT_SALE_PRICE | 생산 | Product Work Cost Master | 132 | CUSTOMER_CODE, ITEM_CODE, PRODUCT_LINE_TYPE, DATESET, ORGANIZATION_ID | 1/0 | 6 | 2 |
| MENU_CATEGORIES | 미분류 | 미확정 | 14 | ORGANIZATION_ID, CATEGORY_CODE | 0/1 | 0 | 9 |
| MENU_CATEGORY_ITEMS | 자재/품목 | 미확정 | 132 | ORGANIZATION_ID, MENU_CODE | 1/0 | 0 | 31 |
| OEE_CUSTOMER_DEFECT | 미분류 | 미확정 | - | DEFECT_ID | 0/0 | 0 | 1 |
| OEE_DAILY_SUMMARY | 미분류 | 미확정 | 2 | SUMMARY_ID | 1/0 | 1 | 1 |
| OEE_DOWNTIME_REASON | 미분류 | 미확정 | 7 | REASON_CODE | 0/1 | 0 | 2 |
| OEE_MATERIAL_READINESS | 미분류 | 미확정 | - | READINESS_ID | 0/0 | 0 | 1 |
| OEE_OPERATION_LOG | 이력/로그 | 미확정 | 2 | LOG_ID | 2/0 | 1 | 3 |
| OEE_PLAN_TIME | 미분류 | 미확정 | - | PLAN_TIME_ID | 1/0 | 1 | 0 |
| OEE_PRODUCTION_RESULT | 생산 | 미확정 | 1 | RESULT_ID | 1/0 | 1 | 0 |
| OEE_RESOURCE | 미분류 | 미확정 | 1 | RESOURCE_ID | 0/4 | 2 | 2 |
| OEE_WORKTIME_RANGE | 생산 | 미확정 | 4 | RANGE_ID | 0/0 | 1 | 0 |
| OEE_WORK_CALENDAR | 생산 | 미확정 | 1 | ORGANIZATION_ID, WORK_DATE | 0/0 | 1 | 0 |
| PBCATCOL | 미분류 | 미확정 | - | - | 0/0 | 0 | 0 |
| PBCATEDT | 미분류 | 미확정 | - | - | 0/0 | 0 | 0 |
| PBCATFMT | 미분류 | 미확정 | - | - | 0/0 | 0 | 0 |
| PBCATTBL | 미분류 | 미확정 | - | - | 0/0 | 0 | 0 |
| PBCATVLD | 미분류 | 미확정 | - | - | 0/0 | 0 | 0 |
| SMART_FACTORY_USE_LOG_IF | 이력/로그 | 미확정 | 113143 | - | 0/0 | 1 | 0 |
| TB_ADM_BATCHJOBERRORLOG | 이력/로그 | 미확정 | 456 | - | 0/0 | 1 | 0 |
| TB_AREA_MST | 미분류 | 미확정 | - | - | 0/0 | 1 | 0 |
| TEST_DATA_RAW | 미분류 | 미확정 | 65658 | - | 0/0 | 0 | 0 |
| XPObjectType | 미분류 | 미확정 | 1 | OID | 0/0 | 0 | 0 |
| XXADM_TEMPRATURE_CHECK_IN | 미분류 | 미확정 | 95781 | - | 0/0 | 1 | 0 |
| XXADM_TEMPRATURE_DATA_IN | 미분류 | 미확정 | 15453881 | - | 0/0 | 1 | 0 |
| XXADM_XML_TEST | 미분류 | 미확정 | 5 | - | 0/0 | 3 | 0 |
