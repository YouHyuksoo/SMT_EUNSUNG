---
menuCode: PRD_SMD_ACTUAL
audience: operator
title: 반제품생산실적관리
summary: 생산실적(조립실적) 원천, 계획별 주야 실적의 자동 집계 근거, 보정 방식, 수기실적 테이블, API를 설명합니다.
tags: [생산관리, 반제품, 운영]
keywords: [IP_ASSEMBLY_RESULT, IP_ASSEMBLY_RESULT_SENSOR_V, P_ASSY_RESULT_ADD, TRG_IQ_AOI_ASSY_RESULT, IP_PRODUCT_SMD_PLAN, IP_PRODUCT_SMD_SHIFT_MANUAL, ICOM_WORKTIME_RANGES]
related: []
---
# 반제품생산실적관리 — 운영 가이드

## 시스템 목적·역할

생산실적(조립실적 `IP_ASSEMBLY_RESULT`, 화면은 뷰 `IP_ASSEMBLY_RESULT_SENSOR_V`)을 반제품생산계획(`IP_PRODUCT_SMD_PLAN`)과 맞춰 계획별 주간·야간 실적과 잔량을 보여 주고, 근무조별 수기 실적(`IP_PRODUCT_SMD_SHIFT_MANUAL`)으로 자동 집계를 대신할 수 있게 합니다. 생산실적 행 조회와 보정(보정 등록·수정·삭제) 탭도 함께 있습니다.

2026-10-17부터 생산실적 원천이 센서실적(`IP_PRODUCT_SENSOR_ACTUAL*`)에서 조립실적으로 바뀌었습니다. 이전 정의: `docs/sql/sensor-actual-views-before-2026-10-17.sql`.

## 데이터 구조

- 모든 생산실적 쓰기는 `P_ASSY_RESULT_ADD(p_run_no, p_line_code, p_time, p_qty, p_source, p_remark, p_user, …)` 하나를 거칩니다.
  - 생산 품목: 런카드(`IP_PRODUCT_RUN_CARD`)의 MODEL_NAME·PCB_ITEM(T/B) → `IP_PRODUCT_MODEL_MASTER.TOP_ITEM_CODE`/`BOTTOM_ITEM_CODE`.
  - `PRODUCT_DATE` = `F_GET_WORK_ACTUAL_DATE(p_time,'A')` 작업일, `TIME_DIVISION` = `F_GET_WORKTIME_ZONE` 시간대(A~E 주간, F~J 야간).
  - 전환 시각(`ISYS_CONFIG.WIP_DIRECT_CONSUME_FROM`) 이후 실적은 같은 트랜잭션에서 공정입고(반제품)·공정출고(직속 자품목)를 만들고 `WORKSTAGE_ISSUE_YN='Y'` 로 남깁니다.
- 구분(`ENTER_BY`, 뷰 `ACTUAL_SOURCE`):
  - `AOI_JOB` — `TRG_IQ_AOI_ASSY_RESULT` 가 AOI 양품 PID 를 실시간으로 더합니다(`P_ASSY_RESULT_ADD_PID`, PID·면 중복 제거, 수량 = 모델 `PCB_TOTAL_QTY` 또는 1). 같은 시간·시간대 행에 누적합니다. 놓친 PID 는 매일 07:40 잡(`P_ASSY_RESULT_FROM_AOI(48)`)이 채웁니다. 실패는 `ISYS_BATCHJOBERRLOG`(BATCH_JOB_OBJECT_NAME=`TRG_IQ_AOI_ASSY_RESULT`, NG)에 남습니다.
  - `WORK_RESULT` — 작업실적 완료(SMT 라인) 시 MANUAL 로 넣습니다. REMARK = `런-순번`, 취소는 같은 실적 시각의 음수 행(REMARK `… 취소`).
  - `ASSY_ADJUST` — 보정. REMARK = 사유. 뷰의 `ADJUST_QTY` 는 보정 행의 수량입니다.
- 뷰의 `RECEIPT_DATE` = 작업일(PRODUCT_DATE), `LAST_RECEIPT_DATE` = 실적 시각(PRODUCT_ACTUAL_TIME).

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
| 최종 실적 시각 | MAX(LAST_RECEIPT_DATE) | 마지막 실적 시각 |
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
| 조회 (계획별 주야 실적) | `GET /production/smd-actual/shift` | 계획일 범위 필수 | SELECT 전용. 기간 안 생산실적만 먼저 접어 계획에 붙입니다 |
| 수기실적 저장 | `PUT /production/smd-actual/shift-manual` | 계획이 있어야 함 | 값이 있는 근무조는 MERGE, 비운 근무조는 DELETE |
| 수기 모두 지우기 | `DELETE /production/smd-actual/shift-manual` | — | 그 계획의 수기 행 DELETE (shiftSlot 지정 시 한 근무조만) |
| 조회 (실적 목록 / 합계) | `GET /production/smd-actual`, `GET /production/smd-actual/summary` | 작업일 범위 필수 | SELECT 전용 |
| 보정 등록 | `POST /production/assembly-results/adjust` | runNo·actualTime(YYYY-MM-DD HH:mm)·qty≠0·reason | `P_ASSY_RESULT_ADD(source=ADJUST)` — ASSY_ADJUST 행 INSERT (+ 공정재고) |
| 수정 (실적 목록) | `PUT /production/smd-actual` | 행 선택, productActualQty·reason | (새 수량 − 지금 수량) 보정 행 INSERT. 원래 행은 UPDATE 하지 않습니다 |
| 삭제 (실적 목록) | `DELETE /production/smd-actual` | 행 선택, reason | −지금 수량 보정 행 INSERT. 원래 행은 DELETE 하지 않습니다 |

## 운영 포인트

- 자동 실적은 계획일과 같은 작업일의 생산실적만 붙습니다. 계획일보다 앞당기거나 다음날 이어서 생산한 수량은 해당 계획에 붙지 않습니다.
- AOI 자동 실적이 안 생기면 순서대로 확인합니다: AOI 행 RUN_NO 가 `*`/빈 값인지 → 런카드 PCB_ITEM 이 T/B 인지 → 모델 마스터의 그 면 품목(TOP/BOTTOM_ITEM_CODE)이 있는지 → `ID_ITEM` 에 품목이 있는지 → `ISYS_BATCHJOBERRLOG` NG 로그.
- 전환 이전(`WORKSTAGE_ISSUE_YN='N'`) 실적을 보정하면 공정재고는 움직이지 않습니다.
