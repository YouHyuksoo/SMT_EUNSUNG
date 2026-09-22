---
menuCode: EQUIP_RESULT_REFLOW
audience: operator
title: REFLOW 작업결과조회 운영 가이드
summary: Reflow 온도 프로파일 조회 운영 기준입니다.
tags: [설비, REFLOW, 운영]
keywords: [IQ_MACHINE_INSPECT_DATA_REFLOW, TOP, BOTTOM]
related: [EQUIP_MASTER]
---
# REFLOW 작업결과조회 — 운영 가이드
## 시스템 목적·역할
PB `w_qc_machine_inspect_data_reflow_query`의 프로파일 조회입니다.
## 데이터 구조
`IQ_MACHINE_INSPECT_DATA_REFLOW`; 기간은 MEASURE_DATE, 선택 조건은 LINE_CODE와 JOB_FILE입니다.
## ① 결과 — IQ_MACHINE_INSPECT_DATA_REFLOW (전체 컬럼)
MEASURE_DATE, LINE_CODE, MACHINE_CODE, BELT_SPEED, OXYGEN_CONCENTRATION, TOP1~13, BOTTOM1~13, FILE_NAME, 감사·조직 컬럼, JOB_FILE을 사용합니다.
## 버튼·API·상태 전이
`GET /equipment/result-queries/reflow`; SELECT-only.
## 운영 절차
Job File별 벨트 속도·산소농도·존 온도를 비교합니다.
## 권한
`EQUIP_RESULT_REFLOW`; JWT 조직 범위 강제.
## 문제 해결 (트러블슈팅)
열이 누락되면 해당 TOP/BOTTOM 원천 컬럼 적재를 확인합니다.
## 데이터·연계
DB 갱신 없음.
