# OEE 관리기능 설계 (Design Spec)

- 작성일: 2026-07-06
- 근거: `260526_MES 고도화 제안서_REV1.pdf` (은성전자 홍성공장 MES 고도화 — Vision 2030)
- 대상 저장소: Infinity21 MES SMT_EUNSUNG (은성 Oracle MES 위 Next.js WebDisplay)
- 상태: 구현 전 설계 (specs)

---

## 1. 목적과 범위

### 1.1 목적
제안서의 **OEE(생산종합효율) 관리 효율화** 요구를 이 저장소에 구현한다.

```
OEE = 가동율 × 성능율 × 양품율
- 가동율(Availability) = 실제 가동시간 / 계획 가동시간   (고장정지·셋업/단품교체·자재대기)
- 성능율(Performance)  = (이론 CT × 총생산수량) / 실제 가동시간   (미세정지·속도저하)
- 양품율(Quality)      = 양품 수량 / 총 생산 수량   (불량·Rework·시작품 손실)
```

6개 공정(SMT / 성능검사 / 코팅 / 라우팅 / 조립 / 검사·포장)을 대상으로 한다.

### 1.2 확정된 범위 결정 (브레인스토밍 결과)
| 항목 | 결정 |
|---|---|
| 구현 계층 | **입력 ~ 계산 ~ 대시보드 전체** |
| 입력 플랫폼 | **Next.js 웹 입력화면 신규** (이 저장소) |
| 공정 범위 | **6공정 동시 설계** (구현은 단계적) |
| 집계 기준 단위 | **공정별로 다름** → 리소스 추상화로 흡수 |
| 도메인 방식 | **B. 독립 OEE 도메인 신설** (기존 실적·표준시간은 참조, 가동율은 신규 테이블) |
| 계획가동시간 원천 | **(a) 근무캘린더/보유공수 자동 산출** + 예외 override |
| 스냅샷 폴백 | **없음** — 스냅샷 부재 시 명시적 오류 |
| 입력 주체(created_by) | **작업자 사번 선택/스캔** (단말 프로파일은 UX 자동채움) |

### 1.3 비범위 (YAGNI)
- PowerBuilder MES 측 입력화면 신규 개발 (이번 대상 아님).
- 전사 인증/로그인 시스템 도입 (앱에 인증 없음 — 작업자 식별은 사번 스캔으로 대체).
- 수불관리·BOM·기준정보 고도화 등 제안서의 OEE 외 항목.

---

## 2. 기존 DB 자산 (설계 참조 전용 — 런타임 의존 없음)

> **원칙(2026-07-06 REV2 확정)**: 기존 MES 테이블·함수는 **설계 참조용으로만** 본다. OEE 도메인은
> 계획가동·가동/비가동·생산수량·표준CT를 **모두 자체 테이블로 신규 구현**하며, 아래 기존 자산을
> **런타임에 조회·조인하지 않는다**. 아래 표는 "우리가 무엇을 새로 만들어야 하는지"의 구조 참고일 뿐이다.

| 용도(설계 참고) | 기존 자산(참조만) | OEE 도메인 대응(신규 구현) |
|---|---|---|
| 설비/라인 식별 구조 | `IMCN_MACHINE`, `IP_PRODUCT_LINE` | `OEE_RESOURCE.ref_code` (문자 참조값, FK 아님) |
| 표준시간 구조 | `IP_PRODUCT_MODEL_ST_MASTER` | `OEE_RESOURCE.ideal_ct` |
| 생산수량/양품/불량 구조 | `F_GET_RUN_ACTUAL_QTY`, `F_GET_RUN_NG_QTY` 등 | `OEE_PRODUCTION_RESULT` (신규, §3-⑥) |
| 근무일 구조 | `IP_PRODUCT_COMPANY_CALENDAR` | `OEE_WORK_CALENDAR` (신규, §3-⑦) |
| 근무시간대·휴식 구조 | `ICOM_WORKTIME_RANGES` (`RANGE_TYPE`, `START_TIME/END_TIME`, 휴식) | `OEE_WORKTIME_RANGE` (신규, §3-⑦) |

> ⚠️ 구현 착수 시 확인: 작업자 사번 체계(문자열 저장), 공정별 근무패턴(주/야 정의), 생산수량 수집 경로(설비/PDA 신호 또는 입력).

---

## 3. 도메인 데이터 모델 (신규 테이블)

공정별 기준 단위가 다르다는 요구를 **리소스 추상화**로 흡수한다.

### ① `OEE_RESOURCE` — OEE 리소스 마스터
공정별 관리 단위를 하나로 추상화. SMT는 설비/라인, 조립은 작업그룹/테이블을 리소스로 등록.
```
resource_id       PK
organization_id
process_code      -- SMT / PERF / COAT / ROUTER / ASSY / PACK
resource_type     -- MACHINE / LINE / WORKGROUP
ref_code          -- IMCN_MACHINE.machine_code 또는 IP_PRODUCT_LINE 코드 (nullable)
resource_name
ideal_ct          -- 리소스 기본 이론 CT (nullable; 없으면 모델 ST 사용)
use_yn
sort_order
```

### ② `OEE_DOWNTIME_REASON` — 비가동사유 코드마스터
제안서 로스 분류(자재대기·셋업/단품교체·설비고장·작업자부재·미세정지·속도저하 등)를 코드화, 6대 로스 버킷으로 그룹핑.
```
reason_code       PK
organization_id
process_code      -- 공통='*' 또는 공정별
reason_name
loss_bucket       -- AVAIL_DOWN / SETUP / MATERIAL / PERF_MINOR_STOP / PERF_SPEED / ...
oee_factor        -- 가동율 / 성능율 귀속
use_yn
sort_order
```

### ③ `OEE_OPERATION_LOG` — 가동/비가동 일지 (핵심 입력 테이블)
한 행 = 한 리소스가 특정 상태로 머문 구간(interval).
```
log_id            PK
organization_id
resource_id       -- → OEE_RESOURCE
process_code
work_date
shift             -- 주 / 야
start_time
end_time
duration_min
status            -- RUN / DOWN
reason_code       -- DOWN일 때 필수 → OEE_DOWNTIME_REASON
run_no            -- 생산 LOT 연계 (nullable)
remark
created_by        -- 작업자 사번
created_date
```

### ④ `OEE_PLAN_TIME` — 계획가동시간(부하시간)
가동율 분모. **자체 근무마스터(⑦)에서 파생**(뷰), 예외만 이 테이블에 override.
```
resource_id
organization_id
work_date
shift
planned_minutes        -- 근무시간 (파생 기본값)
planned_stop_minutes   -- 휴식 + 계획정지
net_load_minutes       -- 순부하시간 = planned - planned_stop
override_yn            -- 수동 보정 여부
```
- 자동 산출: `OEE_WORK_CALENDAR`(근무일) × `OEE_WORKTIME_RANGE`(근무시간·휴식) — 모두 신규(⑦).
- override_yn='Y'인 행이 있으면 그 값을 우선.

### ⑥ `OEE_PRODUCTION_RESULT` — OEE 전용 생산실적 (신규, 성능·양품 원천)
기존 RUN 실적을 런타임 조회하지 않고, OEE 도메인이 수량을 자체 보유.
```
result_id         PK
organization_id
resource_id       -- → OEE_RESOURCE
process_code
work_date
shift
run_no            -- LOT 연계 (nullable)
output_qty        -- 총생산수량
good_qty          -- 양품수량
defect_qty        -- 불량수량
source            -- MANUAL / EQUIP / PDA (수집 경로)
created_by
created_date
```
- 수집 경로: 가동일지 입력화면의 수량 섹션(MANUAL) 또는 설비/PDA 신호(EQUIP/PDA) — 후자는 후속 자동화.

### ⑦ 근무 마스터 (신규, 계획가동 파생 원천)
`OEE_WORK_CALENDAR` — 근무일 달력
```
organization_id, work_date, holiday_yn ('Y'=휴무), remark
```
`OEE_WORKTIME_RANGE` — 근무/휴식 시간대
```
range_id PK, organization_id, shift (DAY/NIGHT), range_type (WORK/BREAK),
start_hhmm (VARCHAR2(4)), end_hhmm (VARCHAR2(4)), sort_order
```

### ⑤ `OEE_DAILY_SUMMARY` — OEE 집계 스냅샷 (확정 계층)
대시보드/트렌드용. **오직 마감 프로세스만 생성.**
```
resource_id
process_code
organization_id
work_date
shift
net_load_min
run_min
downtime_min
availability
ideal_ct
output_qty
performance
good_qty
total_qty
quality
oee
```

---

## 4. 계산 정의 & 집계 전략

### 4.1 계산식 (원천 매핑)
```
가동율 = 실제가동시간 / 계획가동시간(순부하시간)
  실제가동시간 = Σ OEE_OPERATION_LOG.duration_min (status='RUN')
  계획가동시간 = OEE_PLAN_TIME.net_load_minutes
               (파생: OEE_WORK_CALENDAR × OEE_WORKTIME_RANGE — 모두 신규)
  비가동시간   = Σ duration_min (status='DOWN')  -- 사유별 파레토는 reason_code 집계

성능율 = (이론CT × 총생산수량) / 실제가동시간
  이론CT      = OEE_RESOURCE.ideal_ct (자체 보유)
  총생산수량  = Σ OEE_PRODUCTION_RESULT.output_qty (자체 보유, 신규)

양품율 = 양품수량 / 총생산수량
  양품/불량   = Σ OEE_PRODUCTION_RESULT.good_qty / defect_qty (자체 보유, 신규)

OEE = 가동율 × 성능율 × 양품율
```

### 4.2 집계 전략 (2계층 + 폴백 없음)
1. **`V_OEE_LIVE` (실시간 계층)** — **진행 중인 당일/현재 근무조에 한해** OPERATION_LOG + 월력 + RUN실적에서 on-the-fly 계산. 마감 전 실시간 표시 전용.
2. **`OEE_DAILY_SUMMARY` (확정 계층)** — **오직 `P_OEE_BUILD_SUMMARY`(Oracle 스케줄러 프로시저)만** 근무조 마감 시점에 스냅샷 생성. 과거 이력은 전적으로 이 스냅샷에서만 조회.
3. **폴백 없음** — 마감된 과거 기간을 조회했는데 스냅샷이 없으면 API는 즉석 계산·저장하지 않고 **`OEE_SUMMARY_NOT_BUILT` 오류** 반환. 대시보드는 "집계 미생성(마감 필요)" 오류 상태로 표시. 누락을 정상값처럼 보이게 하지 않는다.

**경계 규칙**: 당일 진행조 = 실시간 뷰 / 마감된 과거 = 스냅샷 전용 / 스냅샷 부재 = 오류.

---

## 5. 입력 UI (Next.js 신규 write)

이 앱은 인증/미들웨어가 없다. 기존 라인필터의 **localStorage 단말 프로파일** 패턴을 재사용한다.

### 5.1 라우트
모니터링(display)과 분리된 신규 그룹 `/oee`:
- `/oee/entry` — 가동/비가동 일지 입력 (핵심, 태블릿)
- `/oee/master/resource` — 리소스 마스터
- `/oee/master/reason` — 비가동사유 코드
- `/oee/master/plan-time` — 계획가동시간 예외 보정(override)

### 5.2 가동일지 입력 `/oee/entry`
- 상단: **단말 프로파일**(공정·리소스·근무조) — localStorage 저장, 최초 1회 선택 후 고정.
- 본문: 해당 근무조 **타임라인**. 구간 추가 = `start~end` + 상태(RUN/DOWN) + DOWN이면 비가동사유(6대 로스 그룹핑 그리드) + RUN_NO 연계(선택).
- **작업자 식별**: 입력·저장 시 작업자 사번 선택/스캔 → `created_by`.
- 태블릿 친화: 큰 버튼, 시간 스텝퍼/슬라이더.

### 5.3 검증 규칙 (프론트 + API 공유)
- 구간 겹침 금지
- 구간 합 ≤ 계획가동시간(근무시간)
- `status='DOWN'` → `reason_code` 필수
- 미래시간/역전(start>end) 금지
- 저장: `executeDml` INSERT/UPDATE, 트랜잭션 단위 = 근무조 저장

### 5.4 마스터 화면
리소스/사유/예외보정 표준 CRUD.

---

## 6. 대시보드 (모니터링 display)

기존 display 패턴(`DisplayLayout`, `screens.ts`, Recharts/ECharts, 밀도 높은 대시보드) 준수. screenId 43번까지 존재 → **신규 44~46 부여**.

| screenId | 화면 | 내용 | 데이터 |
|---|---|---|---|
| 44 | 공정별 OEE 종합 현황 | 6공정 카드, OEE 대형 수치 + 가동/성능/양품 3게이지 + 당일 스파크라인 | 당일=`V_OEE_LIVE` / 과거=`OEE_DAILY_SUMMARY` |
| 45 | 리소스 드릴다운 | 공정 선택 → 설비/라인/작업그룹별 OEE 순위·비교, 리소스 실시간 상태 | 동일 |
| 46 | 로스 분석 파레토 | 비가동사유별 시간 파레토(가동율 로스), 성능/양품 로스, 6대 로스 버킷 | 동일 |

- OEE 트렌드(일/주/월)는 44~46 내 탭 또는 별도로 `OEE_DAILY_SUMMARY` 스냅샷 전용.
- 라인/공정 필터: 기존 display의 localStorage/이벤트 방식 준수.
- 스냅샷 부재 시 오류 배지.

---

## 7. 아키텍처 · 파일 배치

### 7.1 엔드투엔드 흐름
```
[입력] /oee/entry (작업자 사번)
   └─ POST /api/oee/log  ──executeDml──▶ OEE_OPERATION_LOG (트랜잭션=근무조)
                                            │
[집계] P_OEE_BUILD_SUMMARY (Oracle 스케줄러, 근무조 마감)
       IP_PRODUCT_COMPANY_CALENDAR × ICOM_WORKTIME_RANGES (계획가동)
       + OEE_OPERATION_LOG (가동/비가동)
       + RUN실적함수 (성능/양품)  ──▶ OEE_DAILY_SUMMARY (확정 스냅샷)
                                            │
[조회] 당일진행조 → V_OEE_LIVE      과거 → OEE_DAILY_SUMMARY (없으면 오류)
   └─ GET /api/display/44~46 ──▶ 대시보드
```

### 7.2 파일/모듈
```
oracle_db_scripts/oee/           # 신규 DDL·PLSQL: 테이블5 + V_OEE_LIVE + P_OEE_BUILD_SUMMARY
docs/sql/                        # 개발 근거 SQL 스냅샷 (규정: 특화 폴더 sql/)
src/lib/oee/
  oee-calc.ts                    # ★공유 계산규칙: availability/performance/quality/oee (단일 정의)
  oee-validation.ts              # ★공유 검증규칙: 구간겹침·시간합·DOWN사유필수 (프론트+API 공용)
  types.ts
src/lib/queries/oee/
  operation-log.ts  resource.ts  reason.ts  plan-time.ts  live.ts  summary.ts
src/app/api/oee/                 # 입력·마스터 write API (log, resource, reason, plan-time)
src/app/api/display/44|45|46/route.ts
src/app/(oee)/oee/entry|master/… # 입력·마스터 화면
src/components/display/screens/oee-*/  # 대시보드 3종
src/lib/screens.ts               # screenId 44~46 등록
config/cards.json                # MONITORING 레이어 카드
src/lib/queries/sql-registry.ts  # SQL 뷰어 등록
```

### 7.3 핵심 원칙
가동율·성능율·양품율·OEE 계산식과 검증식은 `src/lib/oee/`에 **한 번만 정의**하고 프론트 검증·API가 동일 정의를 참조한다. 계산식 중복 금지 (AI-GLOBAL 규칙).

---

## 8. 에러처리

- `OEE_SUMMARY_NOT_BUILT` — 과거 스냅샷 부재 시 명시적 오류(폴백 없음). 대시보드 "집계 미생성(마감 필요)" 상태.
- 입력 검증 실패 → 4xx + 사유코드, 화면 필드별 표시.
- Oracle 오류(`ORA-*`/`NJS-*`) 원문 보존 (CLAUDE.md 규칙).

---

## 9. 테스트 전략

- `oee-calc.ts` · `oee-validation.ts` **유닛테스트** — 경계값(0가동, 구간겹침, 시간초과, 사유누락).
- 집계 정합성 — 동일 입력에 대해 `V_OEE_LIVE` == 마감 후 `OEE_DAILY_SUMMARY` 일치 검증.
- `npx tsc --noEmit --pretty false` + 대시보드 시각 확인.

---

## 10. 구현 순서 (6공정 동시 설계, 구현은 단계)

```
① DDL/PLSQL (테이블5 + V_OEE_LIVE + P_OEE_BUILD_SUMMARY)
② 마스터 (리소스·사유) + 관리화면
③ 공유 계산·검증 모듈 (src/lib/oee) + 유닛테스트
④ 입력화면 /oee/entry + write API
⑤ 계획가동시간 파생(OEE_PLAN_TIME) + 집계 프로시저
⑥ 대시보드 3종 (screenId 44~46)
⑦ 스냅샷 스케줄 등록 + 정합성 검증
```

---

## 11. 착수 전 검증 항목 (Open Items)
- [ ] 작업자 사번 체계(문자열) 확인
- [ ] 공정별 근무패턴(주/야 시간대) 실무값 확정 → `OEE_WORKTIME_RANGE` 시드
- [ ] 공정별 리소스 실제 단위 확정 (성능검사/코팅/라우팅/조립/검사·포장)
- [ ] Oracle 스케줄러 사용 가능 여부 및 근무조 마감 시점 정의
- [ ] 비가동사유 코드 6대 로스 매핑 실무 확정
- [ ] 생산수량 수집 경로 확정 (MANUAL 입력 우선, EQUIP/PDA 자동화는 후속)
- [ ] 신규 테이블 organization_id 다중사업장 정책 확인

---

## 12. 개정 이력
- **REV1 (2026-07-06)**: 초기 설계 — 접근 B(독립 OEE 도메인), 단 계획가동·성능·양품 원천은 기존 MES 자산 런타임 참조.
- **REV2 (2026-07-06)**: 사용자 지시 "기존 구조는 참조만, 모두 새로 구현" 반영. 기존 MES 테이블·함수 **런타임 의존 전면 제거**. 생산수량은 `OEE_PRODUCTION_RESULT`(⑥), 근무/계획가동은 `OEE_WORK_CALENDAR`·`OEE_WORKTIME_RANGE`(⑦)로 **자체 신규 구현**. §2는 "설계 참조 전용"으로 재정의.
  - 영향: 플랜 1(테이블 5종)은 그대로 유효, 신규 테이블(⑥⑦)은 **플랜 3에서 추가 DDL**로 편입. 플랜 2(입력)는 자립적이라 변동 없음(생산수량 입력 섹션은 플랜 3에서 입력화면에 추가).
