---
menuCode: EQUIP_RESULT_SP
audience: operator
title: SP 작업결과조회 운영 가이드
summary: SP 결과조회 API와 원천 테이블 운영 기준입니다.
tags: [설비, SP, 운영]
keywords: [IQ_MACHINE_INSPECT_DATA_SP, 조직필터]
related: [EQUIP_MASTER]
---
# SP 작업결과조회 — 운영 가이드
## 시스템 목적·역할
PB `w_qc_machine_inspect_data_sp_query`를 웹 조회 화면으로 이식했습니다.
## 데이터 구조
`IQ_MACHINE_INSPECT_DATA_SP`를 기간과 `ORGANIZATION_ID`로 조회하고 `F_GET_RUN_MODEL_NAME(RUN_NO)`로 모델명을 표시합니다.
## ① 결과 — IQ_MACHINE_INSPECT_DATA_SP (전체 컬럼)
화면은 검사일시·라인·설비·RUN_NO·PID·모델·판정·불량과 JOB_FILE, STENCIL_ID, PASTE_ID, SQUEEGEE_ID, PRODUCT_COUNT 및 감사 컬럼을 표시합니다.
## 버튼·API·상태 전이
| 액션 | API | 허용 조건 | DB 영향 |
|---|---|---|---|
| 조회/새로고침 | `GET /equipment/result-queries/sp` | JWT 및 메뉴권한 | SELECT-only |
| 내보내기 | 프론트 DataGrid | 조회 결과 존재 | 없음 |
## 운영 절차
오류 시 백엔드 원문 ORA/NJS 로그와 테이블 컬럼을 확인합니다.
## 권한
`EQUIP_RESULT_SP`; JWT 조직 ID만 사용합니다.
## 문제 해결 (트러블슈팅)
5,000건에 도달하면 기간을 좁힙니다.
## 데이터·연계
원천 수집 프로그램이 INSERT한 결과를 변경하지 않습니다.
