---
menuCode: EQUIP_RESULT_SOLDER
audience: operator
title: 솔더점도 검사결과조회 운영 가이드
summary: 솔더 점도 측정 조회 운영 기준입니다.
tags: [설비, 솔더, 운영]
keywords: [IQ_MACHINE_INSPECT_DATA_SOLDER, VISCOSITY]
related: [EQUIP_RESULT_SP]
---
# 솔더점도 검사결과조회 — 운영 가이드
## 시스템 목적·역할
PB `w_qc_machine_inspect_data_solder_query`를 이식했습니다.
## 데이터 구조
`IQ_MACHINE_INSPECT_DATA_SOLDER`; 기간 컬럼은 MEASURE_DATE이며 PID 입력은 SOLDER_NO에 대응합니다.
## ① 결과 — IQ_MACHINE_INSPECT_DATA_SOLDER (전체 컬럼)
MEASURE_DATE, SOLDER_NO, SOLDER_LOT_NO, RPM, TIME, VISCOSITY, TEMP, FILE_NAME, LINE_CODE, MACHINE_CODE와 감사·조직 컬럼을 사용합니다.
## 버튼·API·상태 전이
`GET /equipment/result-queries/solder`; SELECT-only.
## 운영 절차
Lot별 점도·온도·RPM을 비교합니다.
## 권한
`EQUIP_RESULT_SOLDER`; JWT 조직 범위 강제.
## 문제 해결 (트러블슈팅)
날짜 문자열 형식이 다르면 원천 MEASURE_DATE 형식을 확인합니다.
## 데이터·연계
DB 갱신 없음.
