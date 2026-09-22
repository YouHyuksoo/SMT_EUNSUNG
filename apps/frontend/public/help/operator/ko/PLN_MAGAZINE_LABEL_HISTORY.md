---
menuCode: PLN_MAGAZINE_LABEL_HISTORY
audience: operator
title: 매거진발행이력
summary: 매거진 라벨 공정 수불 이력 조회 화면의 운영 구조를 설명합니다.
tags: [공정수불, 매거진, 운영]
keywords: [IP_PRODUCT_RUN_CARD_IO, MAGAZINE_LABEL_NO, RUN_NO]
related: []
---
# 매거진발행이력 — 운영 가이드

## 시스템 목적·역할

PowerBuilder `W_PLN_PRODUCT_MAGAZINE_LABEL_QUERY`의 이력·집계·매트릭스 조회를 웹으로 이식한 읽기 전용 화면입니다.

## 데이터 구조

조회 원본은 `IP_PRODUCT_RUN_CARD_IO`이며 로그인 토큰의 조직 ID를 서버에서 강제 적용합니다.

## ① 조회 결과 — IP_PRODUCT_RUN_CARD_IO (전체 컬럼)

| 화면 항목 | DB 컬럼 | 역할 / 의미 · 운영 포인트 |
|------|------|------|
| 라벨유형 | MAGAZINE_LABEL_TYPE | `ISYS_BASECODE`의 MAGAZINE LABEL TYPE 코드명으로 표시 |
| RUN NO | RUN_NO | 생산 실행 번호 |
| 매거진 라벨번호 | MAGAZINE_LABEL_NO | 매거진 라벨 식별번호 |
| 발행일시 | ENTER_DATE | 원본 이력 등록 시각 |
| 라인 | LINE_CODE | 생산 라인 코드 |
| 공정 | WORKSTAGE_CODE | 작업 공정 코드 |
| 수불일시 | RECEIPT_DATE | 기간 필터 기준 시각 |
| 모델명 / 서픽스 | MODEL_NAME / MODEL_SUFFIX | 생산 모델 정보 |
| 품목코드 / PCB 구분 | ITEM_CODE / PCB_ITEM | 대상 품목 정보 |
| 수량 / 불량수량 | LOT_QTY / BAD_QTY | 공정 수불과 불량 수량 |
| 대체 매거진 라벨번호 | TRANSFER_MAGAZINE_LABEL_NO | 이동·대체 관계 라벨 |

## 버튼·API·상태 전이

| 버튼/액션 | API 또는 서비스 | 허용 조건 | 결과 상태 / DB 영향 |
|------|------|------|------|
| 조회 / 새로고침 | `GET /process-transaction/magazine-label-history` | 로그인 및 메뉴 권한 | SELECT 전용, 상태 변경 없음 |
| 조회 형태 변경 | 프론트 상태 | 화면 접근 가능 | 다음 조회 SQL의 상세·GROUP BY 형태 변경, DB 영향 없음 |

## 집계 로직

- 이력: PB `d_pln_product_run_card_io_lst` 컬럼과 정렬을 유지합니다.
- 집계: 수불일을 일 단위로 절삭하고 주요 생산 식별자별 `LOT_QTY`를 합산합니다.
- 매트릭스: 라인·RUN NO·모델·PCB·수불일·라벨유형별 `LOT_QTY`를 합산합니다.

## 사전 설정 (마스터·공통코드)

- 라인 선택: 생산라인 마스터
- 공정 선택: 공정 마스터
- 라벨유형 표시: `ISYS_BASECODE`, 코드 유형 `MAGAZINE LABEL TYPE`

## 운영 절차

1. 동일 조직과 기간의 원본 건수를 확인합니다.
2. 상세 이력에서 라벨번호와 수불일시를 확인합니다.
3. 합계 차이는 음수 수불과 불량수량을 함께 점검합니다.

## 권한

`JwtAuthGuard` 인증과 `PLN_MAGAZINE_LABEL_HISTORY` 메뉴 권한이 필요합니다. 조직 ID는 요청값을 받지 않고 인증 정보에서 가져옵니다.

## 문제 해결 (트러블슈팅)

- 결과 없음: `RECEIPT_DATE`, 조직 ID, 전방 일치 필터를 확인합니다.
- 코드명이 안 보임: `ISYS_BASECODE`의 `MAGAZINE LABEL TYPE` 등록을 확인합니다.
- DB 오류: 서버 로그의 원본 `ORA-*` 또는 `NJS-*` 메시지를 보존해 확인합니다.

## 데이터·연계

이 화면은 `IP_PRODUCT_RUN_CARD_IO`를 조회만 하며 DML이나 다른 시스템 전송을 수행하지 않습니다.
