---
menuCode: PLN_WORKSTAGE_PASS
audience: operator
title: 공정통과이력 관리
summary: 공정통과 스캔 화면의 Oracle 데이터와 API 상태 전이를 설명합니다.
tags: [공정수불, 공정통과, 운영]
keywords: [IP_PRODUCT_WORKSTAGE_IO, P_INTERLOCK_CHECK, F_CHECK_PID_STATUS_4_WS]
related: [PLN_MAGAZINE_LABEL_HISTORY]
---
# 공정통과이력 관리 — 운영 가이드

## 시스템 목적·역할

PowerBuilder `W_PLN_PRODUCT_INOUT_SCAN_MASTER`의 공정통과 등록·취소와 5개 조회 모드를 웹으로 이식한 화면입니다.

## 데이터 구조

주 이력은 `IP_PRODUCT_WORKSTAGE_IO`에 저장됩니다. 매거진은 `IP_PRODUCT_RUN_CARD_IO.MAGAZINE_LABEL_NO`, 개별 제품은 `IP_PRODUCT_2D_BARCODE.SERIAL_NO`로 판별하며 모든 조회·DML에 인증 조직 ID를 적용합니다.

## ① 공정통과 이력 — IP_PRODUCT_WORKSTAGE_IO (화면 컬럼)

| 화면 항목 | DB 컬럼 | 역할 / 의미 · 운영 포인트 |
|------|------|------|
| 통과일시 / 순번 | IO_DATE / IO_SEQUENCE | 등록시각과 `SEQ_MAGAZINE_RECEIPT_SEQUENCE` 순번 |
| PID/매거진 | SERIAL_NO | 스캔 식별값 |
| RUN NO / 품목코드 | RUN_NO / ITEM_CODE | 원본 제품 또는 매거진에서 가져온 생산 정보 |
| 라인 / 공정 | LINE_CODE / WORKSTAGE_CODE | 통과 위치 |
| 수불 / 수량 | IO_DEFICIT / IO_QTY | 등록은 `I`, 개별 PID 1, 매거진은 LOT_QTY |
| 모델 / 서픽스 | MODEL_NAME / MODEL_SUFFIX | 스캔 원본의 모델 정보 |
| 출고일시 | OUT_DATE | 후속 공정 이동 시각 |
| 공정유형 / LOT / WIP 순번 | WORKSTAGE_TYPE / LOT_NO / WIP_SEQ | 공정 흐름 추적 필드 |

## 버튼·API·상태 전이

| 버튼/액션 | API 또는 서비스 | 허용 조건 | 결과 상태 / DB 영향 |
|------|------|------|------|
| 조회 / 새로고침 | `GET /process-transaction/workstage-pass` | 인증 및 메뉴 권한 | SELECT 전용 |
| 통과등록 | `POST /process-transaction/workstage-pass/scan` | 인터록 OK, PID 상태 OK, 제품 식별 성공, 중복 아님 | `IP_PRODUCT_WORKSTAGE_IO`에 `IO_DEFICIT='I'` INSERT |
| 재작업 허용 등록 | 같은 POST, `rework=true` | 인터록·PID 상태 정상 | 동일 공정 중복 검사를 생략하고 INSERT |
| 통과취소 | 같은 POST, `cancel=true` | 선택 공정의 현재 입고 이력 존재 | 최대 WIP_SEQ의 `I` 이력 DELETE |

## 판정·조회 로직

- 인터록: `IQ_INTERLOCK_CHECK_CONDITION`의 사용 중인 조건을 순번대로 조회한 후 `P_INTERLOCK_CHECK`를 호출합니다.
- PID 상태: `F_CHECK_PID_STATUS_4_WS` 반환값이 `OK`여야 합니다.
- 입고대기: `IO_DEFICIT='I'`이고 `OUT_DATE IS NULL`인 상세 이력입니다.
- 재공현황: 기준일·공정·모델별 입고수량 합계입니다.
- 공정집계: 공정·모델·수불구분별 수량 합계입니다.

## 사전 설정 (마스터·공통코드)

- 라인·공정 마스터가 로그인 조직에 등록되어 있어야 합니다.
- `IQ_INTERLOCK_CHECK_CONDITION`의 라인·공정별 검사 조건과 순서를 확인합니다.
- 제품은 `IP_PRODUCT_2D_BARCODE`, 매거진은 `IP_PRODUCT_RUN_CARD_IO`에 선행 등록되어야 합니다.

## 운영 절차

1. ESDBEXT에서 조직·기간 조건으로 원본 이력 건수를 확인합니다.
2. 인증된 API의 조회 결과와 화면 행을 대조합니다.
3. 등록 장애는 인터록 결과, PID 상태, 중복 현재 입고 순서로 확인합니다.

## 권한

`JwtAuthGuard` 인증과 `PLN_WORKSTAGE_PASS` 메뉴 권한이 필요합니다. 조직 ID와 작업자는 인증 정보에서만 가져옵니다.

## 문제 해결 (트러블슈팅)

- 인터록 실패: 조건의 `INTERLOCK_CHECK_TYPE`, `USE_YN`, 순서와 프로시저 반환 메시지를 확인합니다.
- PID 없음: 매거진 라벨과 개별 시리얼 원본을 각각 확인합니다.
- 취소 실패: 동일 조직·라인·공정·PID의 현재 `I` 이력과 WIP_SEQ를 확인합니다.
- DB 오류: 서버 로그의 원본 `ORA-*` 또는 `NJS-*`를 보존합니다.

## 데이터·연계

등록과 취소는 Oracle 트랜잭션에서 실행됩니다. 별도의 DB 스키마 변경이나 외부 시스템 전송은 수행하지 않습니다.
