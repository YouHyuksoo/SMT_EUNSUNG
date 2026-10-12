---
menuCode: PRD_SMD_ACTUAL
audience: operator
title: 반제품생산실적관리
summary: 계획별 주야 실적의 자동 집계 근거, 수기실적 테이블, API를 설명합니다.
tags: [생산관리, 반제품, 운영]
keywords: [IP_PRODUCT_SENSOR_ACTUAL_TIME, IP_PRODUCT_SMD_PLAN, IP_PRODUCT_SMD_SHIFT_MANUAL, ICOM_WORKTIME_RANGES]
related: []
---
# 반제품생산실적관리 — 운영 가이드

## 시스템 목적·역할

라인 센서 실적(`IP_PRODUCT_SENSOR_ACTUAL_TIME`)을 반제품생산계획(`IP_PRODUCT_SMD_PLAN`)과 맞춰 계획별 주간·야간 실적과 잔량을 보여 주고, 근무조별 수기 실적(`IP_PRODUCT_SMD_SHIFT_MANUAL`)으로 자동 집계를 대신할 수 있게 합니다. 센서 실적 행 조회·수정·삭제 탭도 함께 있습니다.

## 데이터 구조

- 센서 실적: 센서 프로시저(`P_INTERLOCK_SENSOR_ACTUAL_NEO`)가 카운트마다 `IP_PRODUCT_SENSOR_ACTUAL_TIME` 의 `PRODUCT_ACTUAL_QTY` 를 늘립니다. 수량에는 캐리어 배수가 이미 곱해져 있습니다.
- `RECEIPT_DATE` 는 `F_GET_WORK_ACTUAL_DATE(SYSDATE,'A')` 업무일입니다. 08:30 이전 생산분은 전날 날짜로 들어갑니다.
- `TIME_DIVISION` 은 `F_GET_WORKTIME_SMT_ZONE` 이 `ICOM_WORKTIME_RANGES`(RANGE_TYPE='SMTWORKTIME') 구간으로 찍습니다. A~E = 08:30~20:30(주간), F~J = 20:30~08:30(야간). 'Z'(구간 조회 실패)와 빈 값은 어느 근무조에도 넣지 않습니다.

## ① 계획별 주야 실적 (화면 컬럼)

| 화면 항목 | DB 근거 | 역할 / 의미 · 운영 포인트 |
|------|------|------|
| 계획일 / 순번 | IP_PRODUCT_SMD_PLAN.PLAN_DATE / PLAN_SEQUENCE | 계획 키 (+ ORGANIZATION_ID) |
| 계획수량 | PLAN_QTY | 잔량 계산 기준 |
| 주간실적(자동) | SUM(PRODUCT_ACTUAL_QTY) where TIME_DIVISION A~E | 조인: RECEIPT_DATE=PLAN_DATE, LINE_CODE, MODEL_NAME, MODEL_SUFFIX, PCB_ITEM (계획 화면과 같은 키) |
| 야간실적(자동) | SUM(PRODUCT_ACTUAL_QTY) where TIME_DIVISION F~J | 같은 조인 |
| 주간실적(수기) / 야간실적(수기) | IP_PRODUCT_SMD_SHIFT_MANUAL.MANUAL_QTY (SHIFT_SLOT DAY/NIGHT) | 행이 있으면 그 근무조 실적으로 씁니다 |
| 주간 잔량 | PLAN_QTY − 주간 실적 | 서버(smd-shift-actual.ts)에서 계산 |
| 야간 잔량 | PLAN_QTY − 주간 실적 − 야간 실적 | 서버에서 계산 |
| 같은 모델 계획 | COUNT(*) OVER (계획일·라인·모델·서픽스·PCB면) | 2 이상이면 자동 실적이 계획마다 중복으로 붙습니다 |
| 최종 센서 집계 | MAX(LAST_RECEIPT_DATE) | 센서가 마지막으로 올린 시각 |
| 주간/야간 수기 입력 | NVL(LAST_MODIFY_BY, ENTER_BY), NVL(LAST_MODIFY_DATE, ENTER_DATE) | 수기 실적 이력 |

## 수기실적 테이블 — IP_PRODUCT_SMD_SHIFT_MANUAL

| 컬럼 | 의미 |
|------|------|
| PLAN_DATE / PLAN_SEQUENCE / ORGANIZATION_ID | 반제품생산계획 키 |
| SHIFT_SLOT | DAY=주간, NIGHT=야간 (CHECK 제약) |
| MANUAL_QTY | 수기 실적수량 (0 이상) |
| ENTER_BY / ENTER_DATE | 처음 입력한 사람·시각 |
| LAST_MODIFY_BY / LAST_MODIFY_DATE | 마지막 수정한 사람·시각 |

- PK: PLAN_DATE + PLAN_SEQUENCE + ORGANIZATION_ID + SHIFT_SLOT.
- 계획 테이블에 PK 제약이 없어 FK 는 없습니다. 계획을 지워도 수기 행은 남지만 계획 키로만 조인하므로 화면에는 나오지 않습니다.
- DDL: `oracle_db_scripts/IP_PRODUCT_SMD_SHIFT_MANUAL.sql`

## 버튼·API·상태 전이

| 버튼/액션 | API | 허용 조건 | 결과 / DB 영향 |
|------|------|------|------|
| 조회 (계획별 주야 실적) | `GET /production/smd-actual/shift` | 계획일 범위 필수 | SELECT 전용. 기간 안 센서 행만 먼저 접어 계획에 붙입니다 |
| 수기실적 저장 | `PUT /production/smd-actual/shift-manual` | 계획이 있어야 함 | 값이 있는 근무조는 MERGE, 비운 근무조는 DELETE |
| 수기 모두 지우기 | `DELETE /production/smd-actual/shift-manual` | — | 그 계획의 수기 행 DELETE (shiftSlot 지정 시 한 근무조만) |
| 조회 (실적 목록 / 합계) | `GET /production/smd-actual`, `GET /production/smd-actual/summary` | 집계일 범위 필수 | SELECT 전용 |
| 수정 / 삭제 (실적 목록) | `PUT` / `DELETE /production/smd-actual` | 행 선택 | 센서 실적 행의 PRODUCT_ACTUAL_QTY·ADJUST_QTY UPDATE 또는 DELETE |

## 운영 포인트

- 자동 실적은 계획일과 같은 업무일의 센서 실적만 붙습니다. 계획일보다 앞당기거나 다음날 이어서 생산한 수량은 해당 계획에 붙지 않습니다.
- `ADJUST_QTY`(보정수량)는 자동 실적에 더하지 않습니다. 계획 화면의 실적 뷰(`IP_ASSEMBLY_ACTUAL_TIME_V`)와 같이 `PRODUCT_ACTUAL_QTY` 만 씁니다.
