# OEE_ 전용 테이블 제거 — 기존 테이블 기준 OEE 산출 설계

- 작성일: 2026-10-13
- 상태: 설계 승인(2026-10-13, 사용자 "승인해")
- 대체: `docs/specs/2026-07-06-oee-management-design.md`의 "독립 OEE 도메인 신설(B안)"과 REV2 "기존 구조는 참조만, 모두 새로 구현" 결정

## 1. 배경

2026-07-06 설계는 OEE를 독립 도메인으로 두고 `OEE_*` 테이블을 새로 만들었다(커밋 `883aa52b`, `8f29034c`).
그 뒤 현장 입력 화면은 기존 IP_ 테이블로 구현됐다.

- 2026-08-24 설비별 작업실적관리 → `IP_PRODUCT_WORK_RESULT` / `IP_PRODUCT_WORK_DEFECT` / `IP_EQUIP_DOWNTIME_RESULT` (`01fc9ea6`)
- 2026-09-15 다중입력 → `IP_EQUIP_DOWNTIME_RESULT` (`8067cdae`)

대시보드 산식(`V_OEE_LIVE`, `V_OEE_PLAN_TIME`, `P_OEE_BUILD_SUMMARY`)과 그 기준정보는 OEE_ 테이블을 그대로 읽는다.
그래서 현장 입력이 OEE에 반영되지 않는다.

ESDBext 실측(2026-10-13):

- OEE_ 테이블 14개, 모두 0~7건이고 대부분 7월 테스트 데이터다.
- 운영 `V_OEE_LIVE`는 `OEE_OPERATION_LOG`를 읽는다. 레포 `oracle_db_scripts/oee/05_view_live.sql`(`OEE_DOWNTIME_EVENT`)은 배포되지 않았다.

## 2. 목표와 성공 기준

1. DB에 `OEE%` / `V_OEE%` / `P_OEE%` 객체가 0개이고, 제거 후 INVALID 객체가 새로 생기지 않는다.
2. OEE 대시보드가 현장 입력 테이블과 기존 마스터만으로 계산된다.
3. 지난 날짜도 같은 계산으로 조회된다. 마감 배치가 없고, 409 `OEE_SUMMARY_NOT_BUILT`도 없다.
4. 원천이 없는 값은 0이 아니라 "미산출"(null)로 표시된다.
5. 백엔드·프론트 typecheck와 관련 테스트가 통과한다.

## 3. 제거 대상

### 3.1 DB 객체 (18개)

| 객체 | 건수 | 대체 |
|---|---|---|
| `OEE_RESOURCE` | 1 | `IP_PRODUCT_LINE` |
| `OEE_DOWNTIME_REASON` | 7 | `IP_EQUIP_DOWNTIME_REASON` |
| `OEE_PLAN_TIME` | 0 | 생산월력 |
| `OEE_WORK_CALENDAR` | 1 | `IP_PRODUCT_COMPANY_CALENDAR` / `IP_PRODUCT_LINE_CALENDAR` |
| `OEE_WORKTIME_RANGE` | 4 | `IP_PRODUCT_CALENDAR_SHIFT` / `_BREAK`, `IP_SHIFT_TIME_MASTER` |
| `OEE_ROUTING`, `OEE_ROUTING_PROCESS`, `OEE_ROUTING_MACHINE` | 0 | `IP_ROUTING_*` (라우팅 화면). 코드 참조 없음 |
| `OEE_DOWNTIME_EVENT`, `OEE_OPERATION_LOG` | 0, 2 | `IP_EQUIP_DOWNTIME_RESULT` |
| `OEE_PRODUCTION_RESULT` | 1 | `IP_PRODUCT_SENSOR_ACTUAL_TIME` 외 (4장) |
| `OEE_DAILY_SUMMARY` + `P_OEE_BUILD_SUMMARY` | 2 | 스냅샷 없이 즉시 계산 |
| `OEE_MATERIAL_READINESS`, `OEE_CUSTOMER_DEFECT` | 0, 0 | 원천 없음 → 위젯 제거 |
| `V_OEE_LIVE`, `V_OEE_PLAN_TIME` | – | 백엔드 계산으로 대체 |
| `V_OEE_PRODUCT_LINE` | – | 조건을 서비스 SQL에 직접 넣는다 |

사전 점검 결과(2026-10-13): 스케줄러/DBMS 잡, 시노님, 다른 PL/SQL 소스, PB 소스(`PBL Library 10.5`) 어디에도 OEE_ 참조가 없다.

### 3.2 코드

**백엔드**
- 엔티티 `oee-resource`, `oee-downtime-reason`, `oee-operation-log`, `oee-downtime-event`와 `database.module.ts`·`oee.module.ts` 등록
- `oee-master.service.ts`, `oee-log.service.ts`, `smt-close-run-preview.*`(호출 화면 없음)
- `oee.controller.ts` 경로: `resource*`, `reason*`, `log*`, `smt-close-run/preview`, `dashboard/drilldown`, `dashboard/loss`
- `oee-mobile`: `status`, `downtime/start|end`를 지우고 `resources`, `reasons`, `workers`만 남긴다. `resources`는 `V_OEE_PRODUCT_LINE` 대신 `IP_PRODUCT_LINE`을 직접 조회한다.
- `oee-multi-entry.service.ts`: `V_OEE_PRODUCT_LINE` 참조를 같은 조건의 `IP_PRODUCT_LINE` 조회로 바꾼다.
- 테이블명을 검증하는 spec 갱신: `app.module.structure`, `prod-line-ddl`, `oee-mobile-ddl`, `oee-multi-entry`, 그 밖에 지운 서비스의 spec

**프론트**
- `/oee/master/resource` 화면 제거. 메뉴·페이지 제거 정본 절차를 따른다: `deleted-menu-pages.json`과 구조 테스트, 시드·검증기·DB 메뉴코드 동기화.
- `multi-entry/_lib/oee-mobile.ts`의 사용하지 않는 비가동 이벤트 함수·타입
- 대시보드 화면: 원자재 준비율·고객불량 위젯, "마감 스냅샷"·"집계 미생성" 안내

**DB 스크립트**
- `oracle_db_scripts/oee/` 전체를 제거한다. DROP 스크립트와 백업은 `docs/sql/`에 남긴다.

## 4. OEE 계산 원천

계산 단위는 **업무일 × 라인**이다. 공정(SMT/ASSY) 값은 라인 값을 합산해서 구한다(4.3).

### 4.1 라인과 업무일

- 라인: `IP_PRODUCT_LINE`에서 `PROCESS_CODE IN ('SMT','ASSY')`, `RESOURCE_TYPE IN ('LINE','CELL')`, `LINE_CODE`·`LINE_NAME`이 NOT NULL인 행
- 업무일: 08:30 시작. 센서 실적 `RECEIPT_DATE`와 계획 `PLAN_DATE`가 이미 업무일로 저장되어 있으므로 그대로 쓴다.
  - 시각 컬럼(비가동 시각, `QC_DATE`)은 `[업무일 08:30, 다음날 08:30)` 창으로 자른다.

### 4.2 항목별 원천

| 항목 | 원천 | 규칙 |
|---|---|---|
| 근무분 | 생산월력. `IP_PRODUCT_LINE_CALENDAR`(라인 예외)가 있으면 그 행, 없으면 `IP_PRODUCT_COMPANY_CALENDAR`의 `WORK_MINUTES`를 쓴다 | 휴일(`DAY_TYPE='OFF'`)은 0 |
| 근무 구간 | `IP_PRODUCT_CALENDAR_SHIFT`(그날 예외 → `'*'` 전사), 없으면 `IP_SHIFT_TIME_MASTER`(적용기간 기준) 주·야간 시각. 라인 추가 운영 `IP_PRODUCT_CALENDAR_LINE_RUN`을 더한다 | 비가동 시간을 자르는 창과 당일 경과 비율 계산에 쓴다 |
| 계획정지분 | `IP_EQUIP_DOWNTIME_RESULT` ⋈ `IP_EQUIP_DOWNTIME_REASON.REASON_TYPE='PLAN'` | 근무 구간과 겹치는 분만 센다 |
| 비가동 손실분 | 같은 원장 ⋈ 사유 `REASON_TYPE='UNPLAN'` AND `OEE_REFLECT_YN='Y'` | 4.4 |
| 생산수량 | `IP_PRODUCT_SENSOR_ACTUAL_TIME.PRODUCT_ACTUAL_QTY` (`LINE_CODE`, `RECEIPT_DATE`, `MODEL_NAME`) | SMT·ASSY 공통 단일 원천. ASSY 완료(DONE) 실적은 `P_INTERLOCK_SENSOR_ACTUAL_NEO`가 이미 이 테이블에 쌓으므로 `IP_PRODUCT_WORK_RESULT`는 더하지 않는다(이중집계 방지). WIP는 제외된다 |
| 불량수량 | `IP_PRODUCT_WORK_QC`의 `QC_RESULT='N'`(진성) 건수(`LINE_CODE`, `QC_DATE` 창) + `IP_PRODUCT_WORK_DEFECT.BAD_QTY`(`RUN_NO` → 런카드 `LINE_CODE`, `ENTER_DATE` 창) | 서로 다른 입력 경로라 중복이 없다 |
| 이상 C/T(초) | `IP_PRODUCT_ST_MASTER.CT_VALUE` 하나뿐이다. 생산실적의 `MODEL_NAME`으로 바로 찾는다(9장 REV1). 조건 `DATESET <= 업무일 <= DATEEND`(종료일 포함, DATEEND NULL이면 무기한) | 같은 품목에 설비별 행이 여럿이면 **MAX**를 라인 C/T로 쓴다(라인 속도는 가장 느린 설비가 정한다) |
| 계획수량 | SMT `IP_PRODUCT_SMD_PLAN`, ASSY `IP_PRODUCT_MI_PLAN`의 `PLAN_QTY` (`PLAN_DATE`, `LINE_CODE`) | 계획 테이블의 `ACTUAL_QTY`는 갱신되지 않으므로 쓰지 않는다 |
| 픽업률(SMT) | `IQ_MACHINE_INSPECT_PICKUP_RATE` (`ITEM_CODE='HEAD'`) | 픽업률 리포트(`production-report.service.ts`)와 같은 누적차(LAG) 계산식 `(1 − (M+R)/T) × 100`. 기존 함수를 재사용한다 |

### 4.3 계산식

`packages/shared/src/oee/oee-calc.ts`의 함수를 쓴다(계산식 단일 출처).

```
부하분      = 근무분 − 계획정지분                          (당일은 근무 구간 중 경과한 비율만큼)
가동분      = 부하분 − 비가동 손실분
가동률 A    = 가동분 / 부하분
성능률 P    = Σ(C/T × 모델별 생산수량) / (가동분 × 60)
양품률 Q    = (생산수량 − 불량수량) / 생산수량
OEE        = A × P × Q
UPH        = 생산수량 / (가동분 / 60)
계획달성률  = 생산수량 / 계획수량
```

- 공정 집계는 가중 합산이다. A = Σ가동분 / Σ부하분, P = Σ(C/T×수량) / Σ(가동분×60), Q = Σ양품 / Σ생산. 단순 평균(현행 `AVG`)은 쓰지 않는다.
- 미산출(null) 규칙:
  - 부하분 ≤ 0이면 A·P·OEE는 null
  - 생산수량이 0이면 Q는 null
  - C/T를 찾지 못한 모델이 하나라도 있으면 그 라인과 공정의 P·OEE는 null이고, 응답에 C/T 미등록 모델 목록을 담는다
  - 계획수량이 없으면 계획달성률은 null
- 비율은 1 초과도 자르지 않는다. 이상값을 그대로 드러내기 위해서다(기존 shared 규칙).

### 4.4 비가동 시간 산정

- 대상 행:
  - 라인 행: `LINE_CODE` = 라인, `MACHINE_CODE IS NULL` (다중입력)
  - 설비 행: `MACHINE_CODE`가 있고 `LINE_CODE` = 라인이며 `NVL(CAUSE_YN,'Y') <> 'N'` (동반정지는 제외)
- 종료시각이 NULL이면 현재 시각까지 센다.
- 근무 구간과 겹치는 부분만 남긴 뒤 겹치는 시간대는 합집합으로 한 번만 센다. 같은 시간대에 계획정지와 손실이 겹치면 계획정지를 우선한다.
- 휴식 위치는 월력에 분 단위로만 있어서(시각 없음) 비가동 구간에서 따로 빼지 않는다. 휴식은 근무분 단계에서 이미 빠져 있다.

## 5. API와 화면

- `GET /oee/dashboard/overview?date=YYYY-MM-DD`
  - 응답: `{ workDate, live, rows: 공정별[], lines: 라인별[] }`
  - 비율 필드는 `number | null`이다.
  - 공정 행에 `missingCtModels: string[]`을 담는다.
  - `material`, `customerReturnQty`는 제거한다.
- 기본 일자: 프론트 `todayStr()`를 08:30 업무일 기준으로 맞춘다. 지금은 브라우저 달력 날짜라 백엔드와 어긋난다.
- 화면:
  - 공정 카드(OEE·A·P·Q, UPH·계획달성·생산·픽업)에 null이면 "미산출"을 표시하고 C/T 미등록 모델을 안내한다.
  - 그 아래에 라인별 표를 둔다.
  - "마감 스냅샷"·"집계 미생성" 문구와 위젯 2개를 제거한다.
- 계산은 백엔드 서비스가 원천 행을 조회해서 TS로 한다. 새 SQL 뷰는 만들지 않는다.

## 6. 적용 순서

ESDB와 ESDBext는 같은 운영 DB다. 배포된 백엔드가 아직 OEE_를 읽으므로 순서를 지킨다.

1. 코드 변경 → 백엔드·프론트 typecheck와 관련 테스트 통과
2. 사용자 배포
3. 데이터가 있는 7개 테이블(`OEE_DAILY_SUMMARY`, `OEE_DOWNTIME_REASON`, `OEE_OPERATION_LOG`, `OEE_PRODUCTION_RESULT`, `OEE_RESOURCE`, `OEE_WORKTIME_RANGE`, `OEE_WORK_CALENDAR`)의 DDL과 행, 그리고 뷰 3개·프로시저 1개의 원문을 `docs/sql/2026-10-13-oee-objects-backup.sql`에 백업
4. 사용자 확인 후 DROP 실행. FK 자식 → 부모 순서, `PURGE` 없이 휴지통에 남긴다.
5. 검증: `USER_OBJECTS`에 `OEE%`/`V_OEE%`/`P_OEE%` 0건, 새 INVALID 0건, 대시보드 API 응답 확인

## 7. 범위 밖 (후속)

- 목업 화면 실데이터 연결: OEE 종합 현황, `DailyMetrics`(설비 운영 현황·현장 운영)
- 다중입력 라인 비가동(`MACHINE_CODE` NULL)을 현장운영·설비운영현황이 보지 못하는 문제
- 화면별 업무일 기준 통일(자정·07:30·08:30)
- 기준정보 API `@Public` + 조직 1 고정 정리
- 생산일보 OEE(`result.service.ts`)의 로스시간이 `IMCN_MACHINE_DAILY_OPERATION`(PB, 1건)을 읽는 문제

## 8. 미해결 사항

- **`ES-E-038` / `ES-CO-02` / `ES-RT-17` 코드 체계**
  - 표준시간 마스터 3,421건과 설비별 사유 연계 120대가 이 코드를 쓰는데, `IMCN_MACHINE`과 `IMCN_FIXASSET` 어디에도 없다.
  - 이번 설계는 C/T를 품목 기준 MAX로 쓰기 때문에 이 코드와 무관하게 동작한다.
  - 다만 설비별 사유 연계는 계속 전체 사유로 대체된다. 사용자 답을 받은 뒤 별도로 정리한다.
- **C/T 단위**: `CT_VALUE`를 PCS당 초로 가정한다. 센서 수량은 PCS 단위(캐리어 수 곱)다. 구현 중 표본 라인 한 곳의 UPH 대비 성능률로 타당성을 확인한다.
- **C/T 매칭 커버리지**: 최근 30일 생산 모델 50개 중 44개가 매칭된다. 6개는 미산출 대상이고 화면에 목록으로 노출한다.

## 9. 개정 기록

- **REV1 (2026-10-13)**: 사용자 지시 "MODEL_NAME으로 통일. 반제품·제품은 전부 모델명으로 관리한다".
  - 시간대별 생산실적에 `ITEM_CODE`를 넣었던 시도(같은 날)는 되돌렸다. 컬럼을 지우고 `P_INTERLOCK_SENSOR_ACTUAL_NEO`를 원래 본으로 재배포했다.
  - `IP_PRODUCT_ST_MASTER`의 키를 `MODEL_NAME + MACHINE_CODE + DATESET + 조직`으로 바꿨다(`apps/backend/src/migrations/2026-10-13_st_master_model_name.sql`).
  - OEE 계산은 생산실적의 `MODEL_NAME`으로 표준시간 마스터를 바로 조회한다. 같은 모델에 설비별 행이 여럿이면 MAX를 쓴다.
- **REV2 (2026-10-14)**: 4.2의 "ASSY 완료 실적은 센서 실적 테이블에 쌓인다"는 가정이 틀렸다.
  - `P_INTERLOCK_SENSOR_ACTUAL_NEO`는 라인의 활성 피더 계획(`IB_PRODUCT_PLANDATA`)이 있어야 쌓는다. 피더 계획은 SMT(D) 라인 12개에만 있다.
  - 실측: 최근 90일 `IP_PRODUCT_SENSOR_ACTUAL_TIME`에는 SMT 라인 행만 있다. 조립 H라인 테스트 실적은 `NG ACTIVE PLAN NOT FOUND`로 실패했다.
  - 그래서 SMT가 아닌 라인 실적은 센서 반영을 부르지 않고 `SENSOR_APPLY_YN='X'`(해당 없음)로 기록한다.
  - **생산수량 원천 변경:** SMT 라인은 `IP_PRODUCT_SENSOR_ACTUAL_TIME`, 조립·가공 라인은 `IP_PRODUCT_WORK_RESULT`(취소 제외)를 쓴다. 두 원천이 라인으로 나뉘므로 이중집계는 없다.
