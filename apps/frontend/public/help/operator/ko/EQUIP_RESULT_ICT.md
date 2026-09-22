---
menuCode: EQUIP_RESULT_ICT
audience: operator
title: ICT 검사결과조회 운영 가이드
summary: ICT 측정 결과조회 운영 기준입니다.
tags: [설비, ICT, 운영]
keywords: [IQ_MACHINE_INSPECT_DATA_ICT, 상한, 하한]
related: [EQUIP_RESULT_PERFORMANCE]
---
# ICT 검사결과조회 — 운영 가이드
## 시스템 목적·역할
PB `w_qc_machine_inspect_data_ict_query`의 ICT 상세 측정 조회입니다.
## 데이터 구조
`IQ_MACHINE_INSPECT_DATA_ICT`; 기간 기준은 `INSPECT_DATE`, 조직 범위는 `ORGANIZATION_ID`입니다.
## ① 결과 — IQ_MACHINE_INSPECT_DATA_ICT (전체 컬럼)
공통 식별·판정 컬럼과 FILE_PATH, STEP_NO, PARTS_NAME, OP_MODE, C0R0/UNIT, ACTUAL/UNIT, STANDARD/UNIT, MEASURE/UNIT, HI_LIMIT/UNIT, LO_LIMIT/UNIT를 원천으로 사용합니다.
## 버튼·API·상태 전이
`GET /equipment/result-queries/ict`는 SELECT-only이며 DataGrid 내보내기도 DB 영향이 없습니다.
## 운영 절차
NG 행은 ACTUAL과 HI_LIMIT/LO_LIMIT를 함께 대조합니다.
## 권한
`EQUIP_RESULT_ICT`; JWT 조직 ID 강제.
## 문제 해결 (트러블슈팅)
측정 단위가 다르면 각 `_UNIT` 원천값을 확인합니다.
## 데이터·연계
레거시 수집 결과를 읽기만 합니다.
