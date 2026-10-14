# 생산지시·생산실적·출하지시 분리 설계

- 작성일: 2026-10-14
- 상태: 결정사항 반영 완료, 사용자 검토 대기
- 관련: `docs/specs/2026-10-13-oee-tables-into-existing-design.md` (REV2 "조립·가공 라인 실적은 WORK_RESULT" 를 이 문서가 이어받는다)

## 1. 배경

- 제품생산계획(IP_PRODUCT_MI_PLAN)의 실적은 지금 공정 통과 이력(IP_PRODUCT_WORKSTAGE_IO → IP_PRODUCT_ACTUAL_TIME_V)에서 온다.
  - 후공정 계획(대부분 W190 2층(후공정), 라인 51~63·34)에 맞는 통과 이력은 9월 이후 0건이다.
  - 후공정 PDA 스캔(ICT 3,330건)은 공용 라인(00)·W090 으로 들어가 계획 조인 키(일자·라인·모델·공정)가 맞지 않는다.
- 설비별 작업실적 화면이 넣는 실적(IP_PRODUCT_WORK_RESULT)은 어느 집계에도 반영되지 않는다.
- 사용자 결정(2026-10-14):
  1. 공정 통과 이력은 실적이 아니다.
  2. 생산지시와 출하지시를 제품생산계획과 별개로 관리한다.
  3. 생산지시 = 기존 IP_PRODUCT_RUN_CARD. SMT·후공정 양쪽에서 발행한다.
  4. 출하지시 = 기존 IP_PRODUCT_DELIVERY_PLAN. 고객 납품 계획(고객·모델·수량·납기)으로 등록한다.
  5. 포장(IP_PRODUCT_PACK_MASTER)은 실적이 아니며 지금처럼 따로 관리한다.
  6. "계획 대비 실적"은 **작업지시(런카드) 대비 실적**을 뜻한다.
  7. 발주계획 화면의 납품계획 원천(salePlan·salePlanByTime)은 유지한다. 처리 여부는 나중에 결정한다.

## 2. 개념과 테이블

| 개념 | 테이블 | 변경 |
|---|---|---|
| 생산계획 | IP_PRODUCT_SMD_PLAN(반제품), IP_PRODUCT_MI_PLAN(제품) | 없음. 계획만 관리한다 |
| 생산지시 | IP_PRODUCT_RUN_CARD | 없음. 지금도 SMD 계획 374장·MI 계획 460장(9월 이후) 발행 중, 계획:런카드 ≈ 1:1 (LOT_NO = 계획 MFS) |
| 생산실적 | IP_PRODUCT_WORK_RESULT (RUN_NO 기준), SMT 는 센서 실적 | 없음 |
| 출하지시 | IP_PRODUCT_DELIVERY_PLAN | 데이터 0건 → 등록 화면 신설 |
| 출고 | IP_PRODUCT_FG_ISSUE + IP_PRODUCT_PACK_MASTER (P_PRODUCT_FG_ISSUE) | 출하지시 연결 추가 |
| 포장 | IP_PRODUCT_PACK_MASTER | 없음 |

새 테이블과 컬럼은 만들지 않는다.

## 3. 생산지시 대비 실적

### 3.1 지시수량
`IP_PRODUCT_RUN_CARD.LOT_SIZE`.

### 3.2 실적수량
| 지시 종류 | 판별 | 실적 |
|---|---|---|
| 후공정(조립·가공) 지시 | LOT_NO 가 IP_PRODUCT_MI_PLAN.MFS | IP_PRODUCT_WORK_RESULT 중 그 RUN_NO, RESULT_STATUS='DONE' 의 RESULT_QTY 합 (CANCEL 제외) |
| SMT 지시 | LOT_NO 가 IP_PRODUCT_SMD_PLAN.MFS | 센서 실적 뷰 IP_ASSEMBLY_ACTUAL_TIME_V 를 원천 계획의 기존 조인 키(일자·라인·모델·서픽스·PCB 면)로 붙인 값 |

- SMT 라인에서 설비별 작업실적 화면으로 넣은 실적은 센서 누적 프로시저로 이미 센서에 들어가므로 WORK_RESULT 쪽은 더하지 않는다(이중 집계 방지).
- 센서 실적에는 런카드 키가 없다. 같은 키의 SMD 계획에 런카드가 2장 이상이면 기존 규칙(우선순위·순번이 가장 앞선 한 장)에만 붙인다.

### 3.3 지시는 공정마다 따로 내려간다 (사용자 결정 2026-10-14)
- 후공정 생산지시(런카드)는 공정 단위다. 코팅 → 라우터면 지시가 2장이다.
- 계획 한 건은 한 공정으로만 지시가 내려간다. 공정마다 계획과 작업지시번호가 따로다(사용자 확인 2026-10-14, 실측 180일 계획당 런카드 공정 1종 2146/2146). 그래서 계획의 남은 수량은 그 계획 런카드 전체를 빼고, 이미 다른 공정으로 지시한 계획에 다른 공정 지시를 내리면 서버가 거부한다.
- 제품생산계획 화면의 실적수량·시간대 실적 = 그 계획(MFS)에서 내려간 런카드들의 확정(DONE) 실적. 합계는 날짜 무관, 시간대 10칸은 작업일(08:30 시작)이 계획일과 같은 실적만 SMTWORKTIME 칸으로 나눈다.
- 런카드 발행 시 공정(RUN_CARD.WORKSTAGE_CODE)을 지정한다. 공정 선택은 공정 마스터의 제조공정(SMT·검사 제외)에서 고른다. 지금은 9월 이후 전부 비어 있다.
- 지시 실적 = 그 런카드의 실적 합. 한 장이 한 공정이라 공정 간 중복 합산이 없다.
- 설비별 작업실적 화면의 작업지시 선택은 고른 공정의 런카드만 보여준다. 실적의 WORKSTAGE_CODE 는 런카드 공정과 같아야 하며, 다르면 서버가 거부한다.
- 공정이 비어 있는 기존 런카드는 공정 필터에서 빠지지 않게 "공정 미지정" 으로 함께 보여준다(전환 기간).
- 제품생산계획의 WORKSTAGE_CODE(대부분 W190 2층(후공정))는 계획 구분 값으로 그대로 두고, 런카드 공정의 기본값으로 쓰지 않는다.

### 3.4 반영 위치
| 화면 | 지금 | 바뀐 뒤 |
|---|---|---|
| 설비별 작업실적 (oee/equip-work-result) | 런카드 지시수량 대비 실적 | 그대로 (이미 지시 기준) |
| 생산 보드 TV (monitoring production-board) — 제품 행 | MI 계획 행 + 공정 통과 뷰 | RUN_DATE 가 당일 작업일인 생산지시(런카드) 행 + 3.2 실적 |
| 대시보드 (dashboard getSummary·insights) — 제품 실적 | 공정 통과 뷰 합 | 3.2 의 후공정 지시 실적 합 (실적 입력 시각의 작업일 기준) |
| 제품생산계획 화면 (production/master-plan) | 계획 + 공정 통과 뷰 실적 칸 | 계획 화면은 손대지 않는다 |

- 공정 통과 이력 화면(공정실적, planning/result)은 이력 조회로 남긴다. 실적 집계에는 쓰지 않는다.
- 시간대(A~J) 칸이 필요한 집계(생산 보드 hourly)는 WORK_RESULT.ENTER_DATE 를 `F_GET_WORKTIME_ZONE(YYYYMMDD, HH24MI, 'ZONE')` 으로 칸에 넣는다. 공정 통과 트리거(TRGIP_PRODUCT_WS_IO_INS)와 같은 함수다.

## 4. 출하지시

### 4.1 등록
- 새 화면 "출하지시" (IP_PRODUCT_DELIVERY_PLAN 등록·수정·삭제).
- 입력: 납기일(PLAN_DATE), 고객(CUSTOMER_CODE, 선택), 모델(MODEL_NAME, 선택)·서픽스, 품목(ITEM_CODE), 수량(PLAN_QTY), 비고.
- 서버가 채움: PLAN_SEQUENCE(일자 내 순번), MFS = 출하지시번호(`DLV` + YYMMDD + 순번, 30자 이내), PLAN_STATUS, ACTUAL_QTY=0, 감사 컬럼.
- LINE_CODE 는 NOT NULL 이지만 출하에는 라인이 없다 → `'*'` 로 채운다.
- 테이블에 PK·UK 가 없다 → 서버가 (ORGANIZATION_ID, MFS) 중복을 막는다.
- 메뉴: ISYS_DYNAMIC_MENU 에 해당 화면이 있는지 먼저 확인하고, 없으면 메뉴 위치를 사용자에게 받는다(메뉴 임의 생성 금지).

### 4.2 출고 연결
- 출고 화면에서 출하지시를 먼저 고르고 박스를 스캔한다.
- 기존 P_PRODUCT_FG_ISSUE(P_COMMIT='N') 호출 뒤 같은 트랜잭션에서:
  - 그 박스의 IP_PRODUCT_FG_ISSUE.SHIP_NO 와 IP_PRODUCT_PACK_MASTER.SHIP_NO 를 출하지시번호(MFS)로 바꾼다. SHIP_NO 는 지금 박스마다 시각으로 만드는 값이고 프로시저 주석에도 "쓸데는 없음" 으로 적혀 있다.
  - IP_PRODUCT_DELIVERY_PLAN.ACTUAL_QTY 에 박스 수량을 더한다.
- 출하지시 모델과 박스 모델이 다르거나, 누적이 지시수량을 넘으면 거부한다.
- 출하지시 없이 출고하는 기존 흐름은 그대로 둔다(전환 기간).
- 출고 취소가 있으면 ACTUAL_QTY 를 되돌린다(출고 취소 경로 확인 후 구현).

### 4.3 발주계획
납품계획 원천은 그대로 둔다. 출하지시를 등록하기 시작하면 발주계획의 "납품계획" 원천에 소요량으로 잡힌다. 이 원천의 처리는 사용자가 나중에 결정한다.

## 5. 변경 범위

| 영역 | 파일 | 내용 |
|---|---|---|
| 백엔드 | run-card/run-card.service.ts, run-card/lot-card.service.ts | 후공정 런카드 발행 시 공정(WORKSTAGE_CODE) 지정 |
| 백엔드 | work-result/work-result.service.ts | 작업지시 목록을 공정으로 거르기, 실적 공정 ≠ 런카드 공정이면 거부 |
| 프론트 | 런카드 발행 화면, oee/equip-work-result | 발행 시 공정 선택, 작업지시 모달 공정 필터 |
| 백엔드 | monitoring/services/production-board.service.ts | 제품 행을 런카드 기준으로, 실적 3.2 |
| 백엔드 | dashboard/dashboard.service.ts, dashboard-insights.sql.ts | 제품 실적 원천 교체 |
| 백엔드 | 새 모듈 또는 product 모듈 | 출하지시 CRUD |
| 백엔드 | product/services/product-fg.service.ts | 출고 시 출하지시 연결 |
| 공용 | 지시 실적 SQL 조각 한 곳 | 생산 보드·대시보드가 같이 쓴다 |
| 프론트 | 새 출하지시 화면, 출고 화면 | 지시 선택 추가 |
| DB | 없음 | 스키마 변경 없음 |

## 6. 검증

- 백엔드 jest: 지시 실적 SQL(취소 제외, SMT/후공정 분기), 출하지시 등록 중복·초과 거부, 출고 연결.
- 실DB 대조: 테스트 런카드(TST34%)에 실적을 넣고 생산 보드·대시보드 수치가 WORK_RESULT 합과 같은지 확인한다.
- 출고 연결은 테스트 출하지시로 박스 1개를 출고하고 SHIP_NO·ACTUAL_QTY 를 확인한 뒤 되돌린다.

## 7. 하지 않는 것

- 제품생산계획·반제품생산계획 화면 변경
- 포장 흐름 변경
- 발주계획 화면 변경
- 공정 통과 이력 삭제

## 8. 결정 필요

1. ~~여러 공정을 거치는 지시의 실적 기준~~ → 3.3 으로 결정됨 (공정마다 지시를 따로 내린다).
2. ~~생산 보드 제품 행의 대상일~~ → 사용자 결정: 당일 기준 지시만 보여준다 (런카드 RUN_DATE = 작업일). 이월 지시는 띄우지 않는다.
