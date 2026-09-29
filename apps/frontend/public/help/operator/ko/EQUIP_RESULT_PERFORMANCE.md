---
menuCode: EQUIP_RESULT_PERFORMANCE
audience: operator
title: 성능 검사결과조회 운영 가이드
summary: EOL 성능검사 조회 운영 기준입니다.
tags: [설비, EOL, 운영]
keywords: [IQ_MACHINE_INSPECT_DATA_EOL, CURRENT_TEST, CONNECTIVITY_TEST]
related: [EQUIP_RESULT_ICT]
---
# 성능 검사결과조회 — 운영 가이드
## 시스템 목적·역할
화면명은 성능 검사결과조회이며 PB 원본은 `w_qc_machine_inspect_data_eol_query`입니다.
## 데이터 구조
`IQ_MACHINE_INSPECT_DATA_EOL`; 기간은 INSPECT_START_DATE, 조직은 ORGANIZATION_ID입니다.
## ① 결과 — IQ_MACHINE_INSPECT_DATA_EOL (전체 컬럼)
PID, MACHINE_CODE, 검사 시작·종료, RESULT, 감사·조직 컬럼, FILE_NAME, RUN_NO, LINE_CODE, TEST_CHANNEL, CURRENT_TEST_DATA/RESULT1~4, CONNECTIVITY_TEST_DATA/RESULT1~4를 사용합니다.
## 버튼·API·상태 전이
`GET /equipment/result-queries/performance`; SELECT-only.
## 판정 로직
결과를 재계산하지 않고 원천 채널별 값과 판정을 그대로 표시합니다.
## 운영 절차
PID 조회 후 전체 결과와 채널별 전류·통전 결과를 대조합니다.
## 권한
`EQUIP_RESULT_PERFORMANCE`; JWT 조직 범위 강제.
## 문제 해결 (트러블슈팅)
성능 화면과 EOL 테이블의 명칭 차이를 혼동하지 않습니다.
## 데이터·연계
DB 갱신 없음.
