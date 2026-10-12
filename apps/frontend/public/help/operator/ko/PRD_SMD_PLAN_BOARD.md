---
menuCode: PRD_SMD_PLAN_BOARD
audience: operator
title: 반제품생산계획 현황판
summary: 현황판이 읽는 계획·실적 데이터와 특이사항 테이블 IP_PRODUCT_SMD_PLAN_NOTE 를 설명합니다.
tags: [생산관리, 생산계획, 운영]
keywords: [IP_PRODUCT_SMD_PLAN, IP_ASSEMBLY_ACTUAL_TIME_V, ICOM_WORKTIME_RANGES, IP_PRODUCT_SMD_PLAN_NOTE]
related: [PRD_SMD_PLAN, PRD_SMD_ACTUAL]
---
# 반제품생산계획 현황판 — 운영 가이드

## 시스템 목적·역할

생산 1팀 일일 생산계획 표를 웹으로 옮긴 신규 화면입니다. 계획·실적은 반제품생산계획 화면과 같은 API 를 읽고, 메모만 새 테이블에 씁니다.

## API

| API | 내용 |
|------|------|
| `GET /production/smd-plan?dateFrom=d&dateTo=d` | 계획 행 + 시간대 10칸 계획(PLAN_TIME1..10) / 실적(A..J_TIME_ACTUAL). 반제품생산계획 화면과 같은 API |
| `GET /production/smd-plan-board?date=d` | 시간대 정의, 라인 목록, 계획 외 실적, 특이사항·공지 |
| `PUT /production/smd-plan-board/notes` | `{ date, lineCode, lines[] }`. 그 날짜·라인의 메모를 지우고 1..n 으로 다시 넣음. `lineCode='*'` 는 날짜 공지 |

## 데이터 구조

| 화면 항목 | 원천 | 설명 |
|------|------|------|
| 계획 행 | `IP_PRODUCT_SMD_PLAN` (PLAN_DATE = 조회일) | 라인 → 우선순위 → 계획순번 순 |
| 시간대 실적 | `IP_ASSEMBLY_ACTUAL_TIME_V` | `IP_PRODUCT_SENSOR_ACTUAL_TIME.TIME_DIVISION` A~J 합계. 계획일=RECEIPT_DATE, 라인·모델·서픽스·PCB 면으로 좌측 외부조인 |
| 시간대 구간 | `ICOM_WORKTIME_RANGES` (RANGE_TYPE='SMTWORKTIME') | 센서 프로시저가 `F_GET_WORKTIME_SMT_ZONE` 으로 같은 구간을 찍는다. A~E 주간, F~J 야간 |
| 라인 목록 | `IP_PRODUCT_LINE` | 생산 1팀 = SMT 라인구분(@smt/shared `SMT_LINE_DIVISIONS`, 실데이터 'D') 중 `MES_DISPLAY_YN='Y'` + 그날 계획·실적·메모가 있는 라인. `MES_DISPLAY_SEQUENCE` 순 |
| 계획 외 실적 | `IP_ASSEMBLY_ACTUAL_TIME_V` | RECEIPT_DATE = 조회일 중 같은 날 계획과 조인되지 않는 행 |
| LOT 수량 | `IP_PRODUCT_SMD_PLAN.PLAN_QTY` | 롯트카드 `IP_PRODUCT_RUN_CARD.LOT_SIZE` 와 같은 값 |
| 생산계획 | PLAN_TIME1..10 합 | 대부분의 계획은 시간대 계획을 넣지 않아 0 |
| LOT / OP / AOI / 수삽 / UPH | 없음 | 연결할 원천이 없어 비워 둔다 (UPH 계열 테이블 `IP_PRODUCT_ST`, `IP_PRODUCT_LINE_CAPACITY` 는 0행, `IP_PRODUCT_LINE.UPH_VALUE` 는 전부 비어 있음) |

## ① 특이사항·공지 — IP_PRODUCT_SMD_PLAN_NOTE

| 컬럼 | 설명 |
|------|------|
| PLAN_DATE | 조회일 |
| ORGANIZATION_ID | 조직ID |
| LINE_CODE | 라인코드. `*` = 날짜 전체 공지 |
| NOTE_SEQ | 표시 순서 (1부터) |
| NOTE_TEXT | 메모 한 줄 (500자) |
| ENTER_BY / ENTER_DATE | 마지막으로 저장한 사람·시각 (저장 때 전부 다시 넣으므로) |
| LAST_MODIFY_BY / LAST_MODIFY_DATE | 저장 시각 |

PK: `XPKIP_PRODUCT_SMD_PLAN_NOTE (PLAN_DATE, ORGANIZATION_ID, LINE_CODE, NOTE_SEQ)`. DDL: `oracle_db_scripts/IP_PRODUCT_SMD_PLAN_NOTE.sql`.

## 운영 포인트

- 같은 블록을 동시에 저장하면 뒤 트랜잭션이 `ORA-00001` 로 실패할 수 있습니다. 다시 저장하면 됩니다.
- 현황판의 주간·야간 합계는 센서 실적만 더합니다. 반제품생산실적관리의 주야 수기실적(`IP_PRODUCT_SMD_SHIFT_MANUAL`)은 반영하지 않습니다.
- 업무일은 08:30 에 바뀝니다(`F_GET_WORKTIME_SMT_ZONE`). 화면의 기본 조회일은 달력상 오늘입니다.
