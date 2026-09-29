---
menuCode: EQUIP_RESULT_ROUTER
audience: operator
title: ROUTER 작업결과조회 운영 가이드
summary: Router 결과와 가공조건 조회 운영 기준입니다.
tags: [설비, ROUTER, 운영]
keywords: [IQ_MACHINE_INSPECT_DATA_RT, RPM_VALUE, BIT_VALUE]
related: [EQUIP_MASTER]
---
# ROUTER 작업결과조회 — 운영 가이드
## 시스템 목적·역할
PB `w_qc_machine_inspect_data_rt_query`를 이식했습니다.
## 데이터 구조
`IQ_MACHINE_INSPECT_DATA_RT`; `INSPECT_DATE` 기간과 `ORGANIZATION_ID` 조직 조건을 강제합니다.
## ① 결과 — IQ_MACHINE_INSPECT_DATA_RT (전체 컬럼)
공통 식별·판정·감사 컬럼과 RPM_VALUE, BIT_VALUE를 사용합니다.
## 버튼·API·상태 전이
`GET /equipment/result-queries/router`; SELECT-only.
## 운영 절차
PID별 판정과 RPM/Bit 조건을 대조합니다.
## 권한
`EQUIP_RESULT_ROUTER`; JWT 필요.
## 문제 해결 (트러블슈팅)
라인 미지정 원천은 라인 조건 사용 시 제외될 수 있습니다.
## 데이터·연계
수집 데이터 변경 없음.
