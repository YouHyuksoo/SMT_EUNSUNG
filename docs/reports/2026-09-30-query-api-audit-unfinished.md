# 조회 API 전수 점검 — 결과와 미완료 기록 (2026-09-30)

로컬 백엔드(4003)의 GET API를 ADMIN 사용자로 읽기 전용 호출해 런타임 오류·지연·잘림 표시를 점검했다.
대상 DB는 ESDBext.

## 수행한 점검

| 점검 | 범위 | 결과 |
|---|---|---|
| 1차 스모크 | 경로 파라미터 없는 GET 357개, 필수 파라미터와 날짜(최근 7일)만 채움 | 200 283, 400 66, 404 2, 500 4, 시간초과 2 |
| 프론트 호출 경로 대조 | `api.get/post/...` 리터럴 경로 vs Swagger | 불일치 47건 (변수 경로 오탐 포함) |
| 느린 API 단건 측정 | 화면 기본 조건으로 한 번에 하나씩 | 아래 표 |

## 고친 것 (커밋 전)

- **반제품생산계획(SMD 계획) 조회 500:** `IP_ASSEMBLY_ACTUAL_TIME_V` 는 날짜 컬럼이 `RECEIPT_DATE` 인데 `ACTUAL_DATE` 로 조인해 ORA-00904.
  PB `d_pln_smd_master_plan_lst_tree` 조인(RECEIPT_DATE·LINE·MODEL·SUFFIX·PCB_ITEM)을 `PLAN_TABLES.actualJoin` 으로 옮겼다. 9/23~9/30 47행, 실적 연결 30행(DB 조인 결과와 일치).
- **롯트카드 PID 매핑관리 목록 3분 초과:** 카드마다 `IP_PRODUCT_2D_BARCODE`(1.8억 행)를 세는 서브쿼리를 제거했다 (PB 에도 없음). 3분 초과 → 6.8초(38,966행). 선택 카드의 PID 수는 PID 패널이 보여준다.
- **정보조회 목록 5,000행 조용한 잘림:** query 모듈 5개 서비스가 `FETCH FIRST 5000` 뒤 잘림을 알리지 않았다. `meta.truncated`/`meta.rowLimit(5000)` 을 내리고 9개 화면에 `TruncationNotice` 를 붙였다. 마킹 상세 1일 조회에서 `truncated: true` 확인.

## 보고만 한 것 (결정 필요)

| 항목 | 내용 |
|---|---|
| 마킹 이력 조회 46~50초 | `IQ_MACHINE_INSPECT_DATA_MK` 1.06억 행, `DATESET` 인덱스 없음 → 항상 전체 스캔. 후보: `CREATE INDEX ... ON IQ_MACHINE_INSPECT_DATA_MK (DATESET)` (DDL 미실행) |
| 불용재고 28초 | 판정 함수가 롯트마다 실행 (코드 주석에 알려진 사항) |
| 인증 토큰 | Bearer 토큰이 USER_ID 그대로, 비밀번호 평문 비교 |
| SQL 노출 | 모든 GET 응답 `meta.debugSql` 에 실행 SQL 첨부 (환경 조건 없음) |
| 죽은 엔드포인트 | `dashboard/kpi`, `dashboard/recent-productions`(PKG_DASHBOARD 실패), `oee/dashboard/drilldown`(ORA-01722) — 호출하는 화면 없음 |
| 없는 API 를 부르는 화면 | 설비마스터 설비BOM 패널(설비 선택 시 자동 호출), 시스템설정 AI 패널(화면 열 때 `/ai/status`, `/ai/knowledge/status`), 공통 레이아웃 AI 채팅(전송 시), 품목마스터 ERP 동기화 버튼(클릭 시), PDA 앱 스캔 화면 전반 |
| 추적 모듈 조용한 잘림 | `tracking/material-tracking.service.ts`(5,000, 키 단건 조회 안전장치), `tracking/line-dashboard.service.ts`(탭당 최근 2,000행) |

## 미완료

- **2차 스모크(실제 값·선택 필터 단독·경로 파라미터 GET 47개)** 는 시스템 메모리 부족으로 Claude Code 가 중단했다. 결과 없음.
  스크립트: 세션 스크래치 `smoke-real.mjs` (1차 결과의 목록 응답에서 값 수집 → 전체 필터 1회 + 선택 필터 하나씩).
  특히 모델명 필터 공용화(7cbced64)로 실제 모델명이 들어가는 경로와 설비 결과조회의 `F_GET_RUN_MODEL_NAME` 행별 호출 부하는 아직 실측하지 않았다.
- ESLint 는 설치 문제(`Cannot find module '@eslint/eslintrc/universal'`)로 실행 불가.
- 브라우저 화면 확인은 확장 미연결로 하지 못했다.

다음 세션은 메모리 여유를 확인한 뒤 2차 스모크를 재실행하고, 위 표의 결정 필요 항목을 사용자와 정한다.
