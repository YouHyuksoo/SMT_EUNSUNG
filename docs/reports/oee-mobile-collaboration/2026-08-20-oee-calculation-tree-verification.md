# OEE 계산 원천 추적 및 연결 보완 설계

- 작성일: 2026-08-20
- 대상 DB: `EUNSUNG_DEV_ESDBPDB`, schema `INFINITY21_JSMES`
- 대상 범위: OEE 대시보드, 가동율, 성능율, 양품율, 실시간 계산, 마감 스냅샷
- 문서 성격: 현재 구현 검증 기록과 끊어진 데이터 경로의 보완 설계
- DB 작업: 이 문서를 작성하면서 DDL/DML은 실행하지 않았다. 현재 상태 확인은 읽기 전용 조회만 사용했다.

## 1. 문서 목적

이 문서는 OEE 화면에 표시되는 최종 숫자가 어디에서 왔는지를 사람이 순서대로 따라갈 수 있도록 작성한 검증 문서다.

각 지표는 다음 순서로 설명한다.

1. 화면에서 보이는 값
2. 프론트엔드 요청과 표시 방식
3. 백엔드 API와 집계 방식
4. Oracle View와 계산식
5. 중간 테이블과 함수
6. 사용자가 입력하거나 시스템이 수집하는 경로
7. 최종 말단 DB 테이블과 컬럼
8. 현재 연결 여부
9. 끊어진 경로의 보완 설계
10. DB부터 화면까지의 검증 절차

문서에서 사용하는 상태는 다음과 같다.

| 상태 | 의미 |
|---|---|
| **연결됨** | 화면, API, 서비스, DB 저장, 계산 View까지 실제 실행 경로가 존재한다. |
| **부분 연결** | DB 객체와 계산 경로는 있지만 입력 화면, 저장 API 또는 운영 실행 경로가 없다. |
| **연결 끊김** | 기준정보나 원천 데이터는 존재하지만 현재 OEE 계산에 전달되지 않는다. |
| **보완 설계** | 앞으로 연결할 목표 계약이다. 아직 구현된 기능으로 해석하면 안 된다. |

## 2. OEE 전체 구조

### 2.1 OEE의 의미

OEE는 다음 세 비율을 곱한 값이다.

```text
OEE = 가동율 × 성능율 × 양품율
```

| 지표 | 업무 의미 | 필요한 말단 원천 |
|---|---|---|
| 가동율 | 생산 가능한 시간 중 실제 가동한 시간의 비율 | 업무구간 시작·종료시각, 계획정지, 비가동 시작·종료시각 |
| 성능율 | 실제 가동시간 동안 이론적으로 생산할 수 있는 수량 대비 실제 생산 수준 | 품목별 CT, 생산수량, 가동시간 |
| 양품율 | 전체 생산수량 중 양품수량의 비율 | 생산수량, 양품수량, 불량수량 |

비율은 Oracle과 API에서 `0~1` 스케일로 전달한다. 화면은 `pct()`에서 100을 곱하고 소수점 한 자리의 `%`로 표시한다.

- 화면: `apps/frontend/src/app/(authenticated)/oee/dashboard/page.tsx`
- 표시 함수: `apps/frontend/src/app/(authenticated)/oee/dashboard/_lib/fetcher.ts`
- 공용 계산 함수: `packages/shared/src/oee/oee-calc.ts`
- Oracle 계산 View: `oracle_db_scripts/oee/05_view_live.sql`

### 2.2 화면에서 Oracle까지의 공통 조회 경로

```text
/oee/dashboard
→ Frontend SWR 요청
→ /api/oee/dashboard/overview?date=YYYY-MM-DD
→ Next.js rewrite
→ /api/v1/oee/dashboard/overview
→ OeeController.dashboardOverview()
→ OeeDashboardService.overview()
→ 당일: V_OEE_LIVE
→ 과거: OEE_DAILY_SUMMARY
→ API 응답의 AVAILABILITY / PERFORMANCE / QUALITY / OEE
→ 화면 백분율 표시
```

리소스·A~J 구간별 계산 근거는 다음 경로로 조회한다.

```text
/oee/dashboard/drilldown
→ /api/v1/oee/dashboard/drilldown
→ OeeDashboardService.drilldown()
→ V_OEE_LIVE 또는 OEE_DAILY_SUMMARY
→ NET_LOAD_MIN / RUN_MIN / DOWNTIME_MIN
→ IDEAL_CT / OUTPUT_QTY / GOOD_QTY / TOTAL_QTY
→ 저장 계산값과 프론트 재계산값 비교
```

### 2.3 실시간과 과거 데이터

| 조회 구분 | 원천 | 동작 |
|---|---|---|
| 현재 업무일 | `V_OEE_LIVE` | 현재 KST 시각까지 매번 다시 계산한다. |
| 과거 업무일 | `OEE_DAILY_SUMMARY` | 마감 시 저장한 피연산자와 비율을 조회한다. |
| 과거 summary 없음 | 없음 | `OEE_SUMMARY_NOT_BUILT` HTTP 409를 반환한다. |

`P_OEE_BUILD_SUMMARY(p_work_date)`는 `V_OEE_LIVE` 결과를 `OEE_DAILY_SUMMARY`에 복사한다. 저장소에는 프로시저가 있지만 운영 스케줄러가 실제로 등록되어 주기적으로 실행된다는 근거는 확인되지 않았다.

### 2.4 현재 공정 집계의 주의점

현재 `OeeDashboardService.overview()`는 다음 값을 단순 평균한다.

```sql
AVG(AVAILABILITY)
AVG(PERFORMANCE)
AVG(QUALITY)
AVG(OEE)
```

이 방식은 생산시간과 수량이 다른 라인·구간을 동일한 비중으로 취급한다. 따라서 공정 전체의 실제 시간가중·수량가중 비율과 다를 수 있다.

보완 설계에서는 다음 공식으로 변경한다.

```text
공정 가동율   = ΣRUN_MIN / ΣNET_LOAD_MIN
공정 성능율   = ΣCT_OUTPUT_SECONDS / (ΣRUN_MIN × 60)
공정 양품율   = ΣGOOD_QTY / ΣOUTPUT_QTY
공정 OEE      = 공정 가동율 × 공정 성능율 × 공정 양품율
```

## 3. 가동율

### 3.1 가동율의 업무 의미

```text
가동율 = 실제 가동시간 / 유효 순부하시간
```

현재 시스템에는 PLC RUN 신호나 RUN 시작·종료 원장을 OEE 계산에 직접 연결한 경로가 없다. 대신 다음과 같이 계산한다.

```text
실제 가동시간
= 현재까지 경과한 유효 순부하시간
- 같은 업무구간과 겹친 비가동시간
```

따라서 비가동 이벤트가 없다는 것은 실제 RUN 신호가 확인됐다는 의미가 아니다. 계산상 해당 경과시간을 가동한 것으로 추정한다는 의미다.

### 3.2 화면과 API

공정 카드의 가동율 표시 경로는 다음과 같다.

| 단계 | 구현 |
|---|---|
| 화면 | `apps/frontend/src/app/(authenticated)/oee/dashboard/page.tsx` |
| 요청 | `GET /oee/dashboard/overview?date=...` |
| Controller | `OeeController.dashboardOverview()` |
| Service | `OeeDashboardService.overview()` |
| 실시간 컬럼 | `V_OEE_LIVE.AVAILABILITY` |
| 과거 컬럼 | `OEE_DAILY_SUMMARY.AVAILABILITY` |

Drilldown은 `NET_LOAD_MIN`, `RUN_MIN`, `DOWNTIME_MIN`, `AVAILABILITY`를 반환한다. 화면은 `RUN_MIN / NET_LOAD_MIN`을 다시 계산해 View의 값과 비교한다.

### 3.3 가동율 계산식

현재 Oracle 계산은 다음 순서다.

```text
EFFECTIVE_END_TIME
= min(업무구간 종료시각, 현재 KST 시각)

EFFECTIVE_NET_LOAD_MIN
= min(
    설정된 NET_LOAD_MINUTES,
    max(0, EFFECTIVE_END_TIME - 업무구간 시작시각)
  )

DOWNTIME_MIN
= 업무구간과 비가동 이벤트가 겹치는 분의 합계

RUN_MIN
= max(0, EFFECTIVE_NET_LOAD_MIN - DOWNTIME_MIN)

AVAILABILITY
= RUN_MIN / EFFECTIVE_NET_LOAD_MIN
```

`EFFECTIVE_NET_LOAD_MIN <= 0`이면 가동율은 0이다. 아직 시작하지 않은 A~J 구간은 `V_OEE_LIVE`에서 행 자체가 생성되지 않는다.

### 3.4 기본 업무시간의 최종 말단

기본 업무시간은 `ICOM_WORKTIME_RANGES`에 저장된다.

| 컬럼 | 의미 | 단위·형식 | 계산 사용처 |
|---|---|---|---|
| `ORGANIZATION_ID` | 조직 | 숫자 | OEE 리소스 조직과 결합 |
| `RANGE_TYPE` | 시간표 종류 | `SMTWORKTIME`, `WORKTIME` | SMT와 ASSY 시간표 선택 |
| `WORK_TYPE` | 업무구간 | `A~J` | API 호환상 `SHIFT`로 전달 |
| `START_TIME` | 구간 시작 | `HHMM` 또는 `HHMMSS` | `SEGMENT_START_TIME` 생성 |
| `END_TIME` | 구간 종료 | `HHMM` 또는 `HHMMSS` | `SEGMENT_END_TIME` 생성 |
| `ATTRIBUTE01` | 시작일 offset | 일수 | 자정 전후 실제 timestamp 계산 |
| `ATTRIBUTE02` | 종료일 offset | 일수 | 익일 종료 timestamp 계산 |

SMT LINE은 `RANGE_TYPE='SMTWORKTIME'`, ASSY LINE은 `RANGE_TYPE='WORKTIME'`을 사용한다.

중간 View인 `V_OEE_PLAN_TIME`은 다음 값을 만든다.

| View 컬럼 | 계산 |
|---|---|
| `SEGMENT_START_TIME` | 업무일 + 시작 offset + 시작시각 |
| `SEGMENT_END_TIME` | 업무일 + 종료 offset + 종료시각 |
| `PLANNED_MINUTES` | 기본값은 구간 종료-시작의 분 차이 |
| `NET_LOAD_MINUTES` | override가 없으면 기본 구간 길이 |

현재 연결 상태는 **부분 연결**이다.

- `ICOM_WORKTIME_RANGES` → `V_OEE_PLAN_TIME` → `V_OEE_LIVE`는 연결되어 있다.
- OEE 애플리케이션에서 `ICOM_WORKTIME_RANGES`를 관리하는 화면과 write API는 없다.
- OEE 모바일 서비스는 이 테이블을 읽어 현재 A~J 구간을 판정한다.

### 3.5 08:30 업무일과 A~J

업무일 경계는 KST 08:30이다.

```text
08:30:00 이상 → 해당 캘린더 날짜의 업무일
08:30:00 미만 → 전날 업무일
```

테스트는 다음 경계를 검증한다.

- `08:29:59` → 전 업무일의 J구간
- `08:30:00` → 새 업무일의 A구간

관련 구현:

- `apps/backend/src/modules/oee/oee-mobile-worktime.ts`
- `apps/backend/src/modules/oee/oee-mobile-worktime.spec.ts`
- `oracle_db_scripts/oee/04_view_plan_time.sql`

현재 프론트 대시보드의 기본 날짜는 브라우저 캘린더 날짜를 사용한다. 따라서 KST 단말에서도 자정부터 08:29까지 화면 기본 날짜와 서버 업무일이 다를 수 있다. 문서 검증 시 반드시 포함해야 하는 계약 불일치다.

### 3.6 계획시간 예외의 최종 말단

날짜별 계획시간 보정은 `OEE_PLAN_TIME`에 저장하도록 설계되어 있다.

| 컬럼 | 의미 |
|---|---|
| `RESOURCE_ID` | 보정 대상 OEE 리소스 |
| `ORGANIZATION_ID` | 조직 |
| `WORK_DATE` | 업무일 |
| `SHIFT` | A~J 업무구간 |
| `PLANNED_MINUTES` | 계획시간 |
| `PLANNED_STOP_MINUTES` | 계획정지시간 |
| `NET_LOAD_MINUTES` | 계산에 사용할 최종 순부하시간 |
| `OVERRIDE_YN` | 보정값 사용 여부 |

`V_OEE_PLAN_TIME`은 같은 리소스·조직·업무일·A~J이고 `OVERRIDE_YN='Y'`인 행만 사용한다.

현재 연결 상태는 **부분 연결**이다.

- 테이블과 View 적용 경로는 존재한다.
- Backend entity, 저장 API, 관리 화면은 없다.
- `PLANNED_STOP_MINUTES`는 현재 View에서 직접 차감하지 않는다.
- 계획정지를 반영하려면 최종 `NET_LOAD_MINUTES`가 이미 조정되어 있어야 한다.

### 3.7 계획시간 보완 설계

`ICOM_WORKTIME_RANGES`는 여러 업무에서 공유하는 기준정보이므로 OEE 화면이 직접 수정하지 않는다. OEE에서는 읽기·검증만 수행한다.

보완 대상은 다음과 같다.

```text
/oee/master/plan-time
→ 업무일 선택
→ 공정·라인 선택
→ A~J 기본시간 조회
→ 계획정지 입력
→ 순부하시간 계산·검증
→ 인증된 저장 API
→ OEE_PLAN_TIME 저장
→ V_OEE_PLAN_TIME 반영
→ V_OEE_LIVE 가동율 반영
```

화면에서 함께 보여야 하는 값:

| 구분 | 표시값 |
|---|---|
| 기본값 | `ICOM_WORKTIME_RANGES`에서 계산한 시작·종료·구간 분 |
| 보정값 | `OEE_PLAN_TIME.PLANNED_MINUTES` |
| 계획정지 | `OEE_PLAN_TIME.PLANNED_STOP_MINUTES` |
| 최종 순부하 | `OEE_PLAN_TIME.NET_LOAD_MINUTES` |
| 적용 상태 | 기본값, override, 누락, 오류 |

저장 규칙은 다음으로 확정한다.

```text
NET_LOAD_MINUTES = PLANNED_MINUTES - PLANNED_STOP_MINUTES
```

- 모든 시간은 0 이상이어야 한다.
- 계획정지는 계획시간보다 클 수 없다.
- 순부하시간은 A~J 구간 길이를 초과할 수 없다.
- 조직은 인증 사용자에서 주입한다.
- 같은 리소스·업무일·A~J에는 한 건만 허용한다.

### 3.8 비가동 입력 화면부터 최종 시간 컬럼까지

비가동 입력은 현재 실제로 연결되어 있다.

```text
/oee/entry
→ 작업자 확인
→ 공정·라인 선택
→ 비가동 사유 선택
→ POST /oee/mobile/downtime/start
→ OeeMobileService.startDowntime()
→ 서버 new Date()
→ OEE_DOWNTIME_EVENT.START_TIME

/oee/entry
→ 비가동 종료
→ POST /oee/mobile/downtime/end
→ OeeMobileService.endDowntime()
→ 서버 new Date()
→ OEE_DOWNTIME_EVENT.END_TIME
```

최종 말단 컬럼:

| 컬럼 | 역할 |
|---|---|
| `ORGANIZATION_ID` | 인증 조직 |
| `PROCESS_CODE` | SMT 또는 ASSY |
| `RESOURCE_TYPE` | 현재는 LINE |
| `RESOURCE_CODE` | 라인코드 |
| `PARENT_LINE_CODE` | 저장 문맥 |
| `WORK_DATE` | 08:30 기준 업무일 |
| `WORK_SEGMENT` | A~J |
| `START_TIME` | 비가동 시작 서버 timestamp |
| `END_TIME` | 비가동 종료 서버 timestamp, 진행 중이면 NULL |
| `REASON_CODE` | 비가동 사유 |
| `WORKER_ID` | 현장 작업자 |
| `STARTED_BY`, `ENDED_BY` | 인증 실행자 |

`V_OEE_LIVE`의 이벤트 조인 키는 조직, 공정, 리소스 유형, 리소스 코드와 시간 겹침이다. 저장된 `WORK_DATE`, `WORK_SEGMENT`, `PARENT_LINE_CODE`는 현재 overlap 조인 조건에 직접 사용하지 않는다.

### 3.9 비가동 겹침 계산

이벤트가 구간을 넘어가더라도 전체 이벤트 시간을 차감하지 않고 업무구간과 겹치는 부분만 차감한다.

```text
겹침 시작 = max(이벤트 시작, 업무구간 시작)
겹침 종료 = min(이벤트 종료 또는 현재시각, 유효 업무구간 종료)
겹침 분   = max(0, 겹침 종료 - 겹침 시작)
```

주의사항:

- 열린 이벤트의 `END_TIME=NULL`은 현재 KST까지 계산한다.
- 종료된 이벤트끼리 시간이 겹치면 현재 SQL은 합집합을 만들지 않고 각각 합산한다.
- 중복 합산으로 비가동이 순부하보다 커지면 RUN은 0으로 잘린다.
- `DOWNTIME_MIN` 표시값도 순부하시간으로 제한되어 원천 중복이 화면에서 숨겨질 수 있다.

### 3.10 가동율과 연결되지 않은 경로

| 경로 | 상태 | 이유 |
|---|---|---|
| `/oee/entry` | 연결됨 | `OEE_DOWNTIME_EVENT`를 실제 저장한다. |
| `/oee/equip-downtime-mobile` | 연결 끊김 | 현재 설비 조회 전용이며 비가동 저장을 하지 않는다. |
| `/oee/log` | 연결 끊김 | `OEE_OPERATION_LOG`에 저장하지만 `V_OEE_LIVE`는 이 테이블을 읽지 않는다. |
| `IMCN_MACHINE` | 연결 끊김 | 현재 OEE는 개별 설비가 아니라 `IP_PRODUCT_LINE` 기반 LINE 리소스를 사용한다. |
| PLC RUN 신호 | 연결 없음 | 현재 가동시간은 비가동 이외의 경과시간으로 추정한다. |

### 3.11 가동율 검증 절차

1. `OEE_RESOURCE`에서 대상 라인과 `RESOURCE_ID`를 확인한다.
2. `ICOM_WORKTIME_RANGES`에서 공정에 맞는 `RANGE_TYPE`과 A~J를 확인한다.
3. `START_TIME`, `END_TIME`, `ATTRIBUTE01`, `ATTRIBUTE02`로 실제 timestamp를 수기 계산한다.
4. `V_OEE_PLAN_TIME`의 `SEGMENT_START_TIME`, `SEGMENT_END_TIME`과 비교한다.
5. `OEE_PLAN_TIME` override 존재 여부를 확인한다.
6. `OEE_DOWNTIME_EVENT.START_TIME`, `END_TIME`을 확인한다.
7. 각 이벤트와 업무구간의 겹침시간을 수기 계산한다.
8. `V_OEE_LIVE.NET_LOAD_MIN`, `DOWNTIME_MIN`, `RUN_MIN`과 비교한다.
9. `RUN_MIN / NET_LOAD_MIN`을 재계산한다.
10. 인증 Backend API의 drilldown 값과 비교한다.
11. Frontend proxy 응답과 비교한다.
12. 대시보드와 drilldown의 표시값을 비교한다.

## 4. 성능율

### 4.1 성능율의 업무 의미

성능율은 실제 가동시간 동안 이론적으로 생산할 수 있는 수준과 실제 생산실적을 비교한다.

현재 공식은 다음과 같다.

```text
성능율
= 이론 CT(초/개) × 생산수량(개)
/ 실제 가동시간(분) × 60
```

정확한 식은 다음과 같다.

```text
PERFORMANCE = (IDEAL_CT × OUTPUT_QTY) / (RUN_MIN × 60)
```

`RUN_MIN <= 0`이거나 `IDEAL_CT IS NULL`이면 현재 SQL은 성능율을 0으로 반환한다. 계산 불가와 실제 성능 0을 숫자만으로 구분하지 못한다.

### 4.2 화면과 API

| 단계 | 구현 |
|---|---|
| 공정 카드 | `dashboard/page.tsx`의 `PERFORMANCE` |
| Drilldown | `IDEAL_CT`, `OUTPUT_QTY`, `TOTAL_QTY`, `RUN_MIN`, `PERFORMANCE` |
| Controller | `OeeController.dashboardOverview()`, `dashboardDrilldown()` |
| Service | `OeeDashboardService` |
| 실시간 | `V_OEE_LIVE.PERFORMANCE` |
| 과거 | `OEE_DAILY_SUMMARY.PERFORMANCE` |

Drilldown은 공용 함수 `performance(idealCt, totalQty, runMinutes)`로 값을 다시 계산한다.

### 4.3 현재 CT의 최종 말단

현재 `V_OEE_LIVE`가 실제로 읽는 CT는 다음 하나다.

```text
OEE_RESOURCE.IDEAL_CT
```

관련 컬럼:

| 컬럼 | 역할 |
|---|---|
| `RESOURCE_ID` | OEE 리소스 식별자 |
| `ORGANIZATION_ID` | 조직 |
| `PROCESS_CODE` | SMT 또는 ASSY |
| `RESOURCE_TYPE` | LINE |
| `REF_CODE` | `IP_PRODUCT_LINE.LINE_CODE` |
| `IDEAL_CT` | 리소스 단위 이론 CT, 초/개 |
| `USE_YN` | 계산 대상 여부 |

리소스 seed인 `09_seed_dashboard_resources.sql`은 신규 행의 `IDEAL_CT`를 NULL로 저장한다. 기존 리소스가 매칭되면 이름, 정렬순서, 사용여부만 갱신하고 `IDEAL_CT`는 덮어쓰지 않는다.

현재 연결 상태는 **부분 연결**이다.

- `/api/v1/oee/resource` API는 `IDEAL_CT`를 저장할 수 있다.
- 현재 프론트에는 이 API를 사용하는 리소스 관리 화면이 없다.
- 하나의 라인에서 여러 품목을 생산하는 경우 리소스 CT 하나로는 제품별 차이를 표현할 수 없다.

### 4.4 업로드된 표준시간의 최종 말단

품목별 표준시간은 `IP_PRODUCT_ST_MASTER`에 저장되어 있다.

실제 관리 경로:

```text
/oee/master/standard-time
→ StandardTimeController
→ StandardTimeService
→ IP_PRODUCT_ST_MASTER
```

말단 컬럼:

| 컬럼 | 의미 | 단위 |
|---|---|---|
| `ITEM_CODE` | 품목 | 코드 |
| `DATESET` | 적용 시작일 | DATE |
| `DATEEND` | 적용 종료일 | DATE |
| `ST_VALUE` | Standard Time | 초 |
| `CT_VALUE` | Cycle Time | 초/개 |
| `NT_VALUE` | Neck Time | 초 |
| `TT_VALUE` | Takt Time | 초 |
| `REMARK` | 비고 | 문자열 |

2026-08-20 읽기 전용 확인 기준 `IP_PRODUCT_ST_MASTER`는 212건이다.

현재 연결 상태는 **연결 끊김**이다.

```text
IP_PRODUCT_ST_MASTER.CT_VALUE
→ OEE 생산실적 또는 리소스와 연결하는 SQL·서비스 없음
→ V_OEE_LIVE는 읽지 않음
→ 대시보드 성능율에 반영되지 않음
```

추가 문제:

- Standard Time backend controller는 현재 `@Public()`이다.
- 서비스는 조직 `1`과 기본 사용자 `ADMIN`을 사용한다.
- 클라이언트 입력 사용자 ID를 감사정보에 사용할 수 있다.
- OEE 연결 전에 인증 조직과 실행자 기준으로 보안 계약을 정리해야 한다.

### 4.5 현재 생산수량의 최종 말단

현재 성능율 생산수량 원천은 `OEE_PRODUCTION_RESULT.OUTPUT_QTY`다.

| 컬럼 | 역할 |
|---|---|
| `ORGANIZATION_ID` | 조직 |
| `RESOURCE_ID` | OEE 라인 |
| `PROCESS_CODE` | 공정 |
| `WORK_DATE` | 08:30 기준 업무일 |
| `SHIFT` | A~J 업무구간 |
| `RUN_NO` | 생산 RUN |
| `PLAN_QTY` | 계획수량 |
| `OUTPUT_QTY` | 생산수량 |
| `GOOD_QTY` | 양품수량 |
| `DEFECT_QTY` | 불량수량 |
| `PICKUP_RATE` | SMT 보조 KPI |
| `SOURCE` | 입력 원천 |

`V_OEE_LIVE`는 다음 기준으로 합산한다.

```text
ORGANIZATION_ID
+ RESOURCE_ID
+ WORK_DATE
+ SHIFT(A~J)
```

현재 연결 상태는 **연결 끊김**이다.

- 테이블과 계산 View는 있다.
- `OEE_PRODUCTION_RESULT` TypeORM entity가 없다.
- 생산실적 DTO, 저장 서비스, Controller, 실제 저장 화면이 없다.
- 현재 `/oee/equip-work-result`는 빈 React state를 사용하는 Mock이다.
- 화면에서 저장해도 `OEE_PRODUCTION_RESULT`에 반영되지 않는다.
- 2026-08-20 확인 기준 `OEE_PRODUCTION_RESULT`는 0건이다.

### 4.6 실제 MES 생산 원천 후보

자동 취합 후보는 존재하지만 업무 의미가 완전히 확정되지 않았다.

#### SMT 후보

| 후보 | 사용할 수 있는 값 | 주의사항 |
|---|---|---|
| `IP_PRODUCT_RUN_CARD` | RUN, 라인, 품목, 모델, 계획수량 | 실제 생산일과 계획일 구분 필요 |
| `F_GET_RUN_LINE_ACTUAL_QTY` | AOI PID 기반 생산수량 | 라인·조직 파라미터가 실제 SQL 필터에 사용되지 않는 구현이 있음 |
| `F_GET_RUN_NG_QTY` | QC 행 기반 NG 수량 | 불량수량이 아니라 QC 행 수일 가능성 |
| `IP_PRODUCT_WORK_QC.BAD_QTY` | 불량수량 후보 | 수리·재검·불량 포인트와 구분 필요 |
| `IRPT_PRODUCT_LINE_MONITORING` | 일 계획·실적·NG | View 내부 SQL과 A~J 매핑 검증 필요 |
| `IP_PRODUCT_SENSOR_ACTUAL_TIME` | A~J 형태의 생산수량 후보 | 품질수량이 없고 현재 데이터 분포 확인 필요 |

개발 DB에서 `IP_PRODUCT_RUN_CARD`는 SMT `01~12`에 실제 데이터가 있다. 같은 조회에서 ASSY `19~24`는 확인되지 않았다.

#### ASSY 후보

| 후보 | 사용할 수 있는 값 | 현재 판단 |
|---|---|---|
| `IP_PRODUCT_WORKSTAGE_IO` | 라인·공정·품목·수량·시간대 | ASSY 완료 공정이 확정되지 않았고 현재 19~24 조회 결과가 없다. |
| `IP_PRODUCT_RUN_CARD_IO/CLOSE` | RUN·수량·불량 후보 | 현재 통계상 데이터가 없고 입출고 의미 확정 필요 |
| `IQ_MACHINE_INSPECT_DATA_FCT` | PID·검사결과 | 07:30 업무일, 재검 처리, 19~24 귀속이 미확정 |
| `IP_PRODUCT_RESULT` | 라인·공정·생산수량 | 현재 통계상 0건 |
| `IP_ASSEMBLY_ACTUAL_TIME_V` | A~J 생산수량 컬럼 | 기반 테이블이 `IP_PRODUCT_SENSOR_ACTUAL_TIME`; 품질수량 없음 |

ASSY는 공식 생산 완료 공정과 최종 품질 판정 원천을 업무 담당자가 확정하기 전에는 자동 취합을 구현하지 않는다.

### 4.7 성능율 연결 보완 설계

확정한 전략은 단계적 혼합 방식이다.

```text
1단계
인증된 OEE 생산실적 입력 화면
→ 공통 저장 API
→ OEE_PRODUCTION_RESULT
→ V_OEE_LIVE

2단계
승인된 SMT/ASSY 원천 adapter
→ 같은 공통 저장 계약으로 정규화
→ OEE_PRODUCTION_RESULT
→ V_OEE_LIVE
```

자동 원천과 수동 입력이 서로 다른 계산식을 사용하면 안 된다. 둘 다 동일한 검증과 저장 계약을 거쳐야 한다.

### 4.8 생산실적 보완 필드

`OEE_PRODUCTION_RESULT`에 다음 계약이 필요하다.

| 필드 | 필요성 |
|---|---|
| `ITEM_CODE` | 품목별 CT 리비전을 찾기 위한 필수 키 |
| `CT_SNAPSHOT_SEC` | 저장 시점에 확정한 CT를 과거에도 재현하기 위한 값 |
| `SOURCE_REF_ID` | 자동 원천 RUN/작업지시/검사집계 식별자 |
| `SOURCE_STATUS` | 수동, 자동, 미수집, 오류 상태 구분 |
| 수정자·수정일 | 정정 이력 확인 |

권장 row grain은 다음과 같다.

```text
조직
+ 리소스
+ 업무일
+ A~J 구간
+ 품목
+ RUN 또는 source reference
```

### 4.9 CT snapshot 설계

생산실적을 저장할 때 다음 순서로 CT를 확정한다.

```text
ITEM_CODE + WORK_DATE
→ IP_PRODUCT_ST_MASTER 조회
→ DATESET <= WORK_DATE
→ DATEEND >= WORK_DATE
→ 유효한 CT_VALUE 한 건 선택
→ CT_SNAPSHOT_SEC 저장
```

검증 규칙:

- `CT_VALUE`는 초/개 단위다.
- 유효한 CT가 없으면 저장하지 않는다.
- 같은 품목·업무일에 두 리비전이 겹치면 저장하지 않는다.
- `CT_VALUE <= 0`이면 계산 불가다.
- 표준시간을 나중에 변경해도 기존 생산실적의 snapshot은 자동 변경하지 않는다.
- 과거 summary도 snapshot 기반 성능 분자를 보존한다.

### 4.10 보완된 성능율 공식

같은 라인·A~J에 여러 품목이 생산될 수 있으므로 CT의 단순 평균을 사용하지 않는다.

```text
CT_OUTPUT_SECONDS
= Σ(CT_SNAPSHOT_SEC × OUTPUT_QTY)

PERFORMANCE
= CT_OUTPUT_SECONDS / (RUN_MIN × 60)
```

공정 집계도 다음처럼 계산한다.

```text
공정 성능율
= ΣCT_OUTPUT_SECONDS / (ΣRUN_MIN × 60)
```

### 4.11 성능율 검증 절차

1. `OEE_PRODUCTION_RESULT`의 조직, 리소스, 업무일, A~J, 품목을 확인한다.
2. 같은 품목·업무일에 유효한 `IP_PRODUCT_ST_MASTER` 리비전을 확인한다.
3. `CT_VALUE`와 `CT_SNAPSHOT_SEC`가 같은지 확인한다.
4. 품목별 `OUTPUT_QTY`를 확인한다.
5. 각 행의 `CT_SNAPSHOT_SEC × OUTPUT_QTY`를 계산한다.
6. 같은 리소스·업무일·A~J의 `CT_OUTPUT_SECONDS`를 합산한다.
7. 가동율에서 계산된 `RUN_MIN`을 확인한다.
8. `CT_OUTPUT_SECONDS / (RUN_MIN × 60)`을 재계산한다.
9. `V_OEE_LIVE.PERFORMANCE`와 비교한다.
10. Backend drilldown API와 비교한다.
11. Frontend 재계산값과 비교한다.
12. 공정 전체 합계 기반 성능율과 overview를 비교한다.

## 5. 양품율

### 5.1 양품율의 업무 의미

```text
양품율 = 양품수량 / 전체 생산수량
```

현재 SQL은 다음 공식을 사용한다.

```text
QUALITY = GOOD_QTY / TOTAL_QTY
TOTAL_QTY = OUTPUT_QTY
```

`TOTAL_QTY <= 0`이면 양품율은 0이다.

### 5.2 화면과 API

| 단계 | 구현 |
|---|---|
| 공정 카드 | `dashboard/page.tsx`의 `QUALITY` |
| Drilldown | `GOOD_QTY`, `TOTAL_QTY`, `OUTPUT_QTY`, `QUALITY` |
| Controller | `OeeController.dashboardOverview()`, `dashboardDrilldown()` |
| Service | `OeeDashboardService` |
| 실시간 | `V_OEE_LIVE.QUALITY` |
| 과거 | `OEE_DAILY_SUMMARY.QUALITY` |

Drilldown은 공용 함수 `quality(goodQty, totalQty)`로 값을 다시 계산한다.

### 5.3 양품율의 최종 말단

현재 계산에 필요한 말단은 `OEE_PRODUCTION_RESULT`다.

| 컬럼 | 의미 | 계산 사용 여부 |
|---|---|---|
| `OUTPUT_QTY` | 전체 생산수량 | 양품율 분모 |
| `GOOD_QTY` | 양품수량 | 양품율 분자 |
| `DEFECT_QTY` | 불량수량 | View에서 직접 읽지 않지만 DB 무결성에 사용 |
| `ITEM_CODE` | 보완 설계의 품목 키 | 현재 컬럼 없음 |
| `RUN_NO` | 생산 RUN | 저장되지만 현재 View 집계 차원에서 사라짐 |
| `RESOURCE_ID` | OEE 라인 | 집계 키 |
| `WORK_DATE` | 업무일 | 집계 키 |
| `SHIFT` | A~J | 집계 키 |

DB 제약은 다음을 검사한다.

```text
GOOD_QTY + DEFECT_QTY = OUTPUT_QTY
```

하지만 현재 `V_OEE_LIVE`는 `DEFECT_QTY`를 집계하지 않는다. `OEE_DAILY_SUMMARY`도 불량수량을 보존하지 않는다.

### 5.4 현재 입력 경로

현재 연결 상태는 **연결 끊김**이다.

- `OEE_PRODUCTION_RESULT` 저장 API가 없다.
- 실제 생산·양품·불량 입력 화면이 없다.
- `/oee/equip-work-result`는 로컬 React state만 변경한다.
- `/oee/equip-ops-analysis`는 빈 Mock 데이터만 조회한다.
- `/oee/entry`는 비가동 이벤트만 저장한다.
- `/oee/log`는 생산수량이 아니라 구형 가동일지를 저장한다.
- SPI/AOI/FCT Display는 Oracle 데이터를 읽지만 OEE 생산실적을 저장하지 않는다.

생산행이 없으면 현재 View는 `OUTPUT_QTY`, `GOOD_QTY`, `TOTAL_QTY`를 모두 0으로 치환한다. 따라서 다음 상태가 화면에서 모두 `0.0%`로 보일 수 있다.

- 실제 생산량이 0
- 실적 인터페이스가 끊김
- 아직 수집되지 않음
- 입력 화면이 없음

### 5.5 생산·품질 입력 보완 설계

성능율과 양품율은 같은 생산 원장을 사용해야 한다. 별도 품질 비율을 직접 입력하지 않는다.

```text
/oee/production-result
→ 업무일 선택
→ 공정·라인·A~J 선택
→ 품목·RUN 선택
→ 계획수량 입력 또는 자동 조회
→ 생산수량 입력
→ 양품수량 입력
→ 불량수량 입력
→ 수량 무결성 검증
→ CT snapshot 조회
→ 인증 저장 API
→ OEE_PRODUCTION_RESULT 저장
→ V_OEE_LIVE 반영
```

필수 저장 검증:

```text
PLAN_QTY >= 0
OUTPUT_QTY >= 0
GOOD_QTY >= 0
DEFECT_QTY >= 0
GOOD_QTY + DEFECT_QTY = OUTPUT_QTY
```

검증은 세 계층에서 동일하게 적용한다.

| 계층 | 검증 |
|---|---|
| Frontend | 즉시 합계 안내와 저장 버튼 제어 |
| Backend | 인증 조직, 리소스, A~J, 품목, 수량 검증 |
| Oracle | CHECK constraint와 source key 중복 방지 |

### 5.6 자동 품질 취합 전에 확정할 업무 규칙

AOI, FCT, QC 행을 그대로 불량수량으로 사용하면 안 된다. 다음 내용을 먼저 확정해야 한다.

1. 동일 PID의 재검사는 한 개 생산품인가 여러 검사 건인가
2. 최초 결과와 최종 결과 중 어떤 결과를 사용할 것인가
3. 수리 후 양품 전환을 어떻게 처리할 것인가
4. `BAD_QTY`는 불량 제품 수량인가 불량 포인트 수인가
5. `DEFECT_QTY`는 제품 수량인가 결점 수인가
6. SMT 최종 품질 원천은 AOI인가 별도 QC인가
7. ASSY 최종 품질 원천은 FCT인가 다른 완료 공정인가
8. 업무일 08:30과 FCT 07:30 기준을 어떻게 통일할 것인가

이 규칙이 확정되기 전에는 인증된 수동 입력을 공식 OEE 원천으로 사용한다. 자동 adapter는 승인된 규칙을 동일한 `OEE_PRODUCTION_RESULT` 계약으로 변환해야 한다.

### 5.7 보완된 양품율 공식

리소스·A~J 행별 공식은 유지한다.

```text
QUALITY = GOOD_QTY / OUTPUT_QTY
```

공정 집계는 단순 평균을 사용하지 않는다.

```text
공정 양품율 = ΣGOOD_QTY / ΣOUTPUT_QTY
```

예를 들어 다음 두 행이 있다고 가정한다.

| 행 | 양품 | 생산 | 행별 양품율 |
|---|---:|---:|---:|
| 대형 라인 | 900 | 1,000 | 90% |
| 소형 라인 | 10 | 10 | 100% |

현재 단순 평균은 95%지만 수량가중 공정 양품율은 `910 / 1,010 = 약 90.10%`다.

### 5.8 양품율 검증 절차

1. `OEE_PRODUCTION_RESULT`의 원본 행을 확인한다.
2. `GOOD_QTY + DEFECT_QTY = OUTPUT_QTY`를 확인한다.
3. 리소스·업무일·A~J별 `OUTPUT_QTY` 합계를 계산한다.
4. 같은 기준의 `GOOD_QTY` 합계를 계산한다.
5. `V_OEE_LIVE.TOTAL_QTY = OUTPUT_QTY`인지 확인한다.
6. `GOOD_QTY / TOTAL_QTY`를 재계산한다.
7. `V_OEE_LIVE.QUALITY`와 비교한다.
8. Backend drilldown API와 비교한다.
9. Frontend 원천값과 재계산값을 비교한다.
10. 공정 전체 `ΣGOOD_QTY / ΣOUTPUT_QTY`와 overview를 비교한다.
11. 생산행 없음과 실제 생산 0이 별도 상태로 표시되는지 확인한다.

## 6. 최종 OEE 계산

### 6.1 리소스·A~J 행의 OEE

```text
OEE = AVAILABILITY × PERFORMANCE × QUALITY
```

세 값 중 하나가 0이면 OEE도 0이다. 현재 구현은 다음 상태를 모두 숫자 0으로 만들 수 있다.

- CT 미등록
- 생산실적 미수집
- 생산량 0
- 가동시간 0
- 양품수량 0
- 실제 성능 또는 품질 0

따라서 숫자 외에 계산 상태를 함께 반환해야 한다.

### 6.2 보완 상태값

| 상태 | 의미 |
|---|---|
| `CALCULABLE` | 업무시간, CT, 생산실적이 모두 있어 계산할 수 있다. |
| `NOT_CONFIGURED` | 업무시간 또는 CT 기준정보가 없다. |
| `NOT_RECORDED` | 생산실적이 수집되지 않았다. |
| `ZERO_PRODUCTION` | 실적은 정상 수집됐지만 생산수량이 0이다. |
| `PARTIAL` | 일부 품목·구간만 수집됐다. |
| `LIVE` | 현재 업무일 실시간 계산이다. |
| `CLOSED` | 마감 snapshot이 생성됐다. |
| `NOT_BUILT` | 과거 summary가 없다. |

### 6.3 보완된 공정 집계

공정 카드는 원천 피연산자의 합계로 다시 계산한다.

```text
Availability = ΣRUN_MIN / ΣNET_LOAD_MIN

Performance
= Σ(CT_SNAPSHOT_SEC × OUTPUT_QTY)
/ (ΣRUN_MIN × 60)

Quality = ΣGOOD_QTY / ΣOUTPUT_QTY

OEE = Availability × Performance × Quality
```

`AVG(OEE)`는 사용하지 않는다. 공정 OEE는 공정 단위로 재계산한 A, P, Q를 곱한다.

## 7. 마감 스냅샷

### 7.1 현재 경로

```text
V_OEE_LIVE
→ P_OEE_BUILD_SUMMARY(p_work_date)
→ OEE_DAILY_SUMMARY
→ 과거 대시보드 조회
```

현재 summary는 `IDEAL_CT`, `OUTPUT_QTY`, `GOOD_QTY`, `TOTAL_QTY`, 세 비율과 OEE를 저장한다. `DEFECT_QTY`는 저장하지 않는다.

### 7.2 보완할 snapshot 피연산자

과거 값을 동일하게 재현하려면 다음 값을 보존해야 한다.

| 값 | 이유 |
|---|---|
| `NET_LOAD_MIN` | 가동율 분모 |
| `RUN_MIN` | 가동율 분자·성능율 분모 |
| `DOWNTIME_MIN` | 비가동 근거 |
| `CT_OUTPUT_SECONDS` | 다품목 성능율 분자 |
| `OUTPUT_QTY` | 생산량·양품율 분모 |
| `GOOD_QTY` | 양품율 분자 |
| `DEFECT_QTY` | 수량 무결성 역검증 |
| `TOTAL_QTY` | 당시 계산 분모 |
| `AVAILABILITY` | 마감 당시 비율 |
| `PERFORMANCE` | 마감 당시 비율 |
| `QUALITY` | 마감 당시 비율 |
| `OEE` | 마감 당시 종합값 |

과거 summary를 조회할 때 현재 `IP_PRODUCT_ST_MASTER`를 다시 조인하지 않는다. 당시 생산실적에 저장한 CT snapshot을 사용한다.

### 7.3 마감 실행의 주의점

- 프로시저는 내부에서 `COMMIT`한다.
- 저장소에서 운영 scheduler 등록은 확인되지 않았다.
- `V_OEE_PLAN_TIME`의 날짜 집합은 현재 업무일, plan override, production result, downtime event에서 온다.
- 과거 날짜에 관련 행이 전혀 없으면 프로시저 인자만으로 A~J 행이 생성되지 않을 수 있다.
- 마감 전 live 피연산자와 마감 후 summary 피연산자를 행 단위로 비교해야 한다.

## 8. 현재 개발 DB 관측 상태

### 8.1 현재 OEE 기준선

| 대상 | 관측 또는 기록 상태 | 의미 |
|---|---|---|
| `OEE_RESOURCE` | SMT LINE 12건, ASSY LINE 6건 기준 | 현재 OEE는 18개 LINE 리소스 계약이다. |
| `OEE_RESOURCE.IDEAL_CT` | 기존 검증 기록상 전건 NULL | 현재 CT 방식으로 성능율을 계산할 수 없다. |
| `IP_PRODUCT_ST_MASTER` | 212건 | 품목별 표준시간은 존재하지만 OEE와 끊겨 있다. |
| `OEE_PRODUCTION_RESULT` | 0건 | 성능율·양품율의 실제 생산 원천이 없다. |
| `OEE_PLAN_TIME` | 기존 검증 기록상 0건 | 기본 A~J 시간만 사용한다. |
| `OEE_DAILY_SUMMARY` | 기존 검증 기록상 0건 | 과거 조회는 마감 미생성 상태다. |

### 8.2 실제 생산 원천 후보의 상태

| 대상 | 확인 내용 |
|---|---|
| `IP_PRODUCT_RUN_CARD` | SMT 01~12에 데이터가 존재한다. |
| `IP_PRODUCT_RUN_CARD` ASSY 19~24 | 같은 조회에서 확인되지 않았다. |
| `IP_PRODUCT_WORKSTAGE_IO` ASSY 19~24 | 실제 조회 결과가 없었다. |
| `IRPT_PRODUCT_LINE_MONITORING` 대상 18개 라인 | 현재 조회 결과가 없었다. |
| `IP_ASSEMBLY_ACTUAL_TIME_V` | View와 A~J 컬럼은 존재한다. |
| `IP_ASSEMBLY_ACTUAL_DAY_V` | View는 존재한다. |
| `IP_PRODUCT_SENSOR_ACTUAL_TIME` | assembly View의 기반 테이블이지만 현재 통계상 데이터가 없다. |

이 상태는 자동 취합 원천을 아직 확정할 수 없다는 근거다. 특히 ASSY 생산실적을 테이블 이름만 보고 임의 연결하면 안 된다.

## 9. 입력·관리 화면 설계 요약

### 9.1 유지할 화면

| 화면 | 역할 |
|---|---|
| `/oee/entry` | 비가동 시작·종료 입력 |
| `/oee/master/standard-time` | 품목별 ST/CT/NT/TT 관리 |
| `/oee/dashboard` | 공정 가중 OEE 조회 |
| `/oee/dashboard/drilldown` | 피연산자와 말단 원천 검증 |

### 9.2 추가할 화면

| 화면 | 역할 | 최종 저장 테이블 |
|---|---|---|
| `/oee/master/plan-time` | 업무일·라인·A~J별 계획정지와 순부하 보정 | `OEE_PLAN_TIME` |
| `/oee/production-result` | 품목별 계획·생산·양품·불량 입력 | `OEE_PRODUCTION_RESULT` |

### 9.3 직접 사용하지 않을 현재 화면

| 화면 | 이유 |
|---|---|
| `/oee/equip-work-result` | 현재 Mock이며 개별 설비·작업지시 grain이 LINE OEE 계약과 다르다. |
| `/oee/equip-ops-analysis` | 빈 Mock 데이터 기반이다. |
| `/oee/equip-downtime-mobile` | 설비 조회 전용이다. |
| `/oee/log` | `OEE_OPERATION_LOG`는 현재 live OEE 원천이 아니다. |

## 10. Backend API 보완 요약

### 10.1 계획시간

```text
GET  /api/v1/oee/plan-times
PUT  /api/v1/oee/plan-times
```

필수 검증:

- `JwtAuthGuard`
- 인증 `organizationId`
- 리소스 조직 일치
- A~J만 허용
- 계획시간·계획정지·순부하 수식 검증
- 같은 리소스·업무일·A~J의 중복 방지

### 10.2 생산실적

```text
GET  /api/v1/oee/production-results
PUT  /api/v1/oee/production-results
```

필수 검증:

- 인증 조직과 실행자만 사용
- 리소스와 공정 일치
- 업무일과 A~J 유효성
- 품목 존재 여부
- 유효 CT 리비전 한 건
- CT snapshot 저장
- `GOOD_QTY + DEFECT_QTY = OUTPUT_QTY`
- source reference 멱등성

### 10.3 표준시간 보안

현재 Standard Time API의 `@Public()`을 제거하고 인증 조직·실행자를 사용하도록 보완해야 한다.

서비스는 요청 body의 조직과 사용자 ID를 신뢰하지 않는다.

## 11. 전체 검증 실행 순서

검증은 컴파일이나 HTTP 200으로 끝내지 않는다. 다음 순서를 지킨다.

### 11.1 말단 DB 원천

1. 대상 조직과 업무일을 정한다.
2. `OEE_RESOURCE` 리소스를 확인한다.
3. `ICOM_WORKTIME_RANGES` A~J를 확인한다.
4. `OEE_PLAN_TIME` override를 확인한다.
5. `OEE_DOWNTIME_EVENT`의 시작·종료를 확인한다.
6. `OEE_PRODUCTION_RESULT`의 품목·수량·CT snapshot을 확인한다.
7. `IP_PRODUCT_ST_MASTER` 리비전과 snapshot을 비교한다.

### 11.2 Oracle 계산 객체

1. `V_OEE_PLAN_TIME`의 구간 timestamp를 확인한다.
2. 비가동 겹침시간을 수기 계산한다.
3. `V_OEE_LIVE`의 피연산자를 확인한다.
4. 가동율을 재계산한다.
5. 성능율을 재계산한다.
6. 양품율을 재계산한다.
7. OEE를 재계산한다.
8. 공정 합계 기반 가중 비율을 계산한다.

### 11.3 API

1. 인증된 Backend overview API를 호출한다.
2. 인증된 Backend drilldown API를 호출한다.
3. Oracle 결과와 행 수·값·순서를 비교한다.
4. 과거 summary가 없으면 409인지 확인한다.
5. 다른 조직 데이터가 섞이지 않는지 확인한다.

### 11.4 Frontend proxy와 렌더

1. `http://localhost:3100/api/oee/dashboard/overview`를 확인한다.
2. Backend direct 응답과 비교한다.
3. `/oee/dashboard` 공정 카드를 확인한다.
4. `/oee/dashboard/drilldown` 원천값을 확인한다.
5. 저장 계산값과 프론트 재계산값을 비교한다.
6. `NOT_CONFIGURED`, `NOT_RECORDED`, `ZERO_PRODUCTION`이 서로 다르게 보이는지 확인한다.

### 11.5 마감

1. 마감 직전 `V_OEE_LIVE` 피연산자를 저장한다.
2. 승인된 환경에서만 `P_OEE_BUILD_SUMMARY`를 실행한다.
3. `OEE_DAILY_SUMMARY`와 live 값을 비교한다.
4. 과거 API가 `live=false`를 반환하는지 확인한다.
5. 화면에 마감 스냅샷으로 표시되는지 확인한다.

## 12. 주요 위험과 확인 필요사항

### 12.1 가동율

- 실제 RUN 신호가 아니라 비가동 이외 시간을 RUN으로 추정한다.
- 종료 이벤트 중첩 시 비가동이 이중 합산될 수 있다.
- 브라우저 날짜와 08:30 업무일이 다를 수 있다.
- 정확히 구간 시작시각에는 모바일 구간 판정과 live View 행 생성 조건이 순간적으로 다를 수 있다.

### 12.2 성능율

- 현재 품목별 표준시간이 OEE에 연결되지 않았다.
- `IDEAL_CT=NULL`과 실제 성능 0이 같은 숫자로 보인다.
- 자동 생산실적 원천의 수량 정의가 공정별로 다르다.
- ASSY 완료 공정이 확정되지 않았다.
- CT를 조회 시점에 재조인하면 과거 값이 변경될 수 있으므로 snapshot이 필요하다.

### 12.3 양품율

- 검사행 수와 생산수량이 같은 grain인지 확정되지 않았다.
- AOI/FCT 재검사를 중복 생산으로 셀 수 있다.
- 불량 제품 수량과 불량 포인트 수량이 혼재한다.
- 생산 미수집과 실제 생산 0이 현재 같은 0으로 보인다.
- summary에 불량수량이 없어 마감 후 원인을 역검증하기 어렵다.

### 12.4 공정 집계

- 현재 단순 평균은 시간·수량 가중치가 없다.
- 생산 없는 0값 행이 평균을 낮출 수 있다.
- `AVG(OEE)`는 공정 전체 `A×P×Q`와 같지 않다.

## 13. 현재 구현과 목표 상태 비교

| 항목 | 현재 | 보완 후 |
|---|---|---|
| 비가동 입력 | `/oee/entry` 연결됨 | 유지 |
| 업무시간 | DB 읽기만 가능 | 조회·검증 상태 제공 |
| 계획시간 예외 | 테이블만 존재 | 관리 화면·인증 API 연결 |
| 표준시간 | 품목별 CRUD 존재 | 인증 보완 + 생산실적 CT snapshot 연결 |
| 생산실적 | 계산 테이블만 존재 | 수동 입력 + 자동 adapter 공통 계약 |
| 양품·불량 | 실제 저장 경로 없음 | 생산실적과 함께 저장 |
| 성능율 집계 | 리소스 CT와 행별 비율 | 품목별 CT×수량 가중식 |
| 양품율 집계 | 행별 비율 평균 | 양품·생산 합계 비율 |
| OEE 집계 | `AVG(OEE)` | 공정 A×P×Q 재계산 |
| 누락 상태 | 숫자 0과 혼합 | 계산불가·미수집·실제 0 구분 |
| 과거 계산 | summary 피연산자 일부 저장 | CT 분자·불량수량까지 보존 |

## 14. 소스와 DB 객체 색인

### 계산 SQL

- `oracle_db_scripts/oee/01_tables.sql`
  - `OEE_RESOURCE`
  - `OEE_PLAN_TIME`
  - `OEE_DAILY_SUMMARY`
- `oracle_db_scripts/oee/03_tables_ext.sql`
  - `OEE_PRODUCTION_RESULT`
- `oracle_db_scripts/oee/04_view_plan_time.sql`
  - `V_OEE_PLAN_TIME`
- `oracle_db_scripts/oee/05_view_live.sql`
  - `V_OEE_LIVE`
- `oracle_db_scripts/oee/06_proc_build_summary.sql`
  - `P_OEE_BUILD_SUMMARY`
- `oracle_db_scripts/oee/07_mobile_prerequisites.sql`
  - `OEE_DOWNTIME_EVENT`
- `oracle_db_scripts/oee/09_seed_dashboard_resources.sql`
  - SMT 01~12, ASSY 19~24 LINE 리소스

### Backend

- `apps/backend/src/modules/oee/oee.controller.ts`
- `apps/backend/src/modules/oee/oee-dashboard.service.ts`
- `apps/backend/src/modules/oee/oee-mobile.controller.ts`
- `apps/backend/src/modules/oee/oee-mobile.service.ts`
- `apps/backend/src/modules/oee/oee-mobile-worktime.ts`
- `apps/backend/src/modules/oee/oee-master.service.ts`
- `apps/backend/src/entities/oee-resource.entity.ts`
- `apps/backend/src/entities/oee-downtime-event.entity.ts`
- `apps/backend/src/entities/worktime-range.entity.ts`
- `apps/backend/src/modules/standard-time/standard-time.controller.ts`
- `apps/backend/src/modules/standard-time/standard-time.service.ts`
- `apps/backend/src/entities/product-st-master.entity.ts`

### Frontend

- `apps/frontend/src/app/(authenticated)/oee/dashboard/page.tsx`
- `apps/frontend/src/app/(authenticated)/oee/dashboard/drilldown/page.tsx`
- `apps/frontend/src/app/(authenticated)/oee/dashboard/_lib/fetcher.ts`
- `apps/frontend/src/app/(authenticated)/oee/entry/page.tsx`
- `apps/frontend/src/app/(authenticated)/oee/entry/_lib/oee-entry.ts`
- `apps/frontend/src/app/(authenticated)/oee/master/standard-time/page.tsx`
- `apps/frontend/src/app/(authenticated)/oee/equip-work-result/page.tsx`
- `apps/frontend/src/app/(authenticated)/oee/equip-ops-analysis/page.tsx`

### 공유 계산 함수

- `packages/shared/src/oee/oee-calc.ts`
- `packages/shared/src/oee/oee-calc.test.ts`

### 실제 생산·검사 원천 후보

- `IP_PRODUCT_RUN_CARD`
- `IP_PRODUCT_WORK_QC`
- `IP_PRODUCT_WORKSTAGE_IO`
- `IP_PRODUCT_RUN_CARD_IO`
- `IP_PRODUCT_RUN_CARD_CLOSE`
- `IP_PRODUCT_SENSOR_ACTUAL_TIME`
- `IP_PRODUCT_SMD_PLAN`
- `IP_PRODUCT_RESULT`
- `IRPT_PRODUCT_LINE_MONITORING`
- `IP_ASSEMBLY_ACTUAL_TIME_V`
- `IP_ASSEMBLY_ACTUAL_DAY_V`
- `IQ_MACHINE_INSPECT_DATA_AOI`
- `IQ_MACHINE_INSPECT_DATA_FCT`
- `IP_PRODUCT_2D_BARCODE`

## 15. 최종 판단

가동율은 기본 업무시간과 비가동 이벤트가 실제 계산 View까지 연결되어 있다. 다만 업무시간 검증 화면과 계획시간 예외 입력 경로가 없고, 실제 RUN 신호가 아닌 비가동 이외 시간을 RUN으로 추정한다.

성능율은 계산 공식과 화면 검증 기능은 존재하지만, 품목별 표준시간과 생산수량을 OEE 계산에 공급하는 경로가 끊겨 있다. `IP_PRODUCT_ST_MASTER`의 212건은 현재 대시보드 성능율에 영향을 주지 않는다.

양품율도 계산 공식과 DB 제약은 존재하지만 실제 생산·양품·불량 저장 경로가 없다. 따라서 현재 0%는 실제 품질 0이 아니라 실적 미수집을 의미할 수 있다.

보완 설계의 핵심은 다음 네 가지다.

1. `OEE_PLAN_TIME` 관리 경로를 연결한다.
2. 인증된 `OEE_PRODUCTION_RESULT` 입력 경로를 먼저 연결한다.
3. 생산실적 저장 시 품목별 CT를 snapshot한다.
4. 공정 카드는 합계 피연산자로 가중 재계산한다.

자동 생산·품질 취합은 SMT와 ASSY의 공식 원천, 완료 공정, 재검사 처리, 불량수량 의미를 확정한 뒤 같은 생산실적 계약에 adapter로 연결한다. 확정되지 않은 테이블이나 함수는 이름만 보고 OEE 원천으로 사용하지 않는다.
