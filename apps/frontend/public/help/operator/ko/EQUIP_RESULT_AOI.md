---
menuCode: EQUIP_RESULT_AOI
audience: operator
title: AOI 검사결과조회 운영 가이드
summary: AOI 원판정과 리뷰판정 조회 운영 기준입니다.
tags: [설비, AOI, 운영]
keywords: [IQ_MACHINE_INSPECT_DATA_AOI, REVIEW_RESULT]
related: [EQUIP_RESULT_SPI]
---
# AOI 검사결과조회 — 운영 가이드
## 시스템 목적·역할
PB `w_aoi_header_detail_query`의 원판정·리뷰판정 조회입니다.
## 데이터 구조
`IQ_MACHINE_INSPECT_DATA_AOI`; `RESULT`와 `REVIEW_RESULT`는 전체/OK/NG/USEROK/USERNG 조건을 지원합니다.
## ① 결과 — IQ_MACHINE_INSPECT_DATA_AOI (전체 컬럼)
공통 식별·판정·감사 컬럼에 REVIEW_DATE, REVIEW_RESULT, JOB_FILE을 표시합니다.
## 버튼·API·상태 전이
`GET /equipment/result-queries/aoi`; SELECT-only이며 상태 전이는 없습니다.
## 판정 로직
화면은 값을 재판정하지 않고 원천 RESULT와 REVIEW_RESULT를 그대로 구분합니다.
## 운영 절차
원판정과 리뷰판정 불일치 건을 필터링해 확인합니다.
## 권한
`EQUIP_RESULT_AOI`; JWT 조직 ID 강제.
## 문제 해결 (트러블슈팅)
리뷰가 없으면 REVIEW_DATE/REVIEW_RESULT 원천 적재 여부를 확인합니다.
## 데이터·연계
조회 전용입니다.
