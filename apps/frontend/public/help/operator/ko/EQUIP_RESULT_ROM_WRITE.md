---
menuCode: EQUIP_RESULT_ROM_WRITE
audience: operator
title: ROM WRITE 작업결과조회 운영 가이드
summary: ROM 기록 결과조회 운영 기준입니다.
tags: [설비, ROM WRITE, 운영]
keywords: [IQ_MACHINE_INSPECT_DATA_RW, CHECK_SUM]
related: [EQUIP_RESULT_PERFORMANCE]
---
# ROM WRITE 작업결과조회 — 운영 가이드
## 시스템 목적·역할
PB `w_qc_machine_inspect_data_rw_query`의 ROM 기록 결과를 제공합니다.
## 데이터 구조
`IQ_MACHINE_INSPECT_DATA_RW`; 기간은 INSPECT_DATE, 조직은 ORGANIZATION_ID입니다.
## ① 결과 — IQ_MACHINE_INSPECT_DATA_RW (전체 컬럼)
공통 컬럼과 ROUTE_PROGRAM, CHECK_SUM, WORK_TIME, PIN_COUNT를 사용합니다.
## 버튼·API·상태 전이
`GET /equipment/result-queries/rom-write`; SELECT-only.
## 운영 절차
모델/작업지시별 프로그램과 Check Sum을 대조합니다.
## 권한
`EQUIP_RESULT_ROM_WRITE`; JWT 조직 범위 강제.
## 문제 해결 (트러블슈팅)
Check Sum 불일치 시 원천 적재 파일과 프로그램 정보를 확인합니다.
## 데이터·연계
DB 갱신 없음.
