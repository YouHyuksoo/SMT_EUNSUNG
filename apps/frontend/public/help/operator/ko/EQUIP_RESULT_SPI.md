---
menuCode: EQUIP_RESULT_SPI
audience: operator
title: SPI 검사결과조회 운영 가이드
summary: SPI 결과조회 API와 원천 테이블 운영 기준입니다.
tags: [설비, SPI, 운영]
keywords: [IQ_MACHINE_INSPECT_DATA_SPI, F_GET_RUN_MODEL_NAME]
related: [EQUIP_RESULT_SP]
---
# SPI 검사결과조회 — 운영 가이드
## 시스템 목적·역할
PB `w_spi_time_query`의 조회 흐름을 제공합니다.
## 데이터 구조
`IQ_MACHINE_INSPECT_DATA_SPI`를 기간·조직·선택조건으로 조회하고 RUN_NO의 모델명을 계산합니다.
## ① 결과 — IQ_MACHINE_INSPECT_DATA_SPI (전체 컬럼)
CSTID, SEQ_NO, PID, MACHINE_CODE, INSPECT_DATE, RESULT, DEFECT_CODE, 감사 컬럼, FILE_NAME, ARRAY_NO, RUN_NO, LINE_CODE를 원천으로 하며 화면에는 주요 식별·판정 컬럼을 표시합니다.
## 버튼·API·상태 전이
조회/새로고침은 `GET /equipment/result-queries/spi`, 내보내기는 클라이언트 기능이며 모두 DB 변경이 없습니다.
## 운영 절차
원천 건수와 API 건수를 같은 조직·기간으로 비교합니다.
## 권한
`EQUIP_RESULT_SPI`; `JwtAuthGuard` 적용.
## 문제 해결 (트러블슈팅)
모델명이 비면 RUN_NO와 DB 함수 결과를 확인합니다.
## 데이터·연계
SELECT-only입니다.
