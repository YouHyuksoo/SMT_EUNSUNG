# OEE 관리기능 설계 (Design Spec)

- 작성일: 2026-07-06
- 근거: `260526_MES 고도화 제안서_REV1.pdf` (은성전자 홍성공장 MES 고도화 — Vision 2030)
- 참조: `설비로그테이블_ESFA.xlsx` (ESFA 설비 자동수집 로그/프로시저 매핑)
- 대상 저장소: Infinity21 MES SMT_EUNSUNG (은성 Oracle MES 위 Next.js WebDisplay)
- 상태: 구현 전 설계 (specs)

---

## 1. 목적과 범위

### 1.1 목적
제안서(표지=0페이지, 1페이지=MES As-Is/To-Be)는 현재 MES의 핵심 문제로
**시간가동율·성능율·양품율 관리 미흡**을 지적하며, 특히
**각 공정별 실제 가동 시간 대비 계획 가동 시간 체계화**가 불가능한 상황을 전제로 한다.
즉, 가동율 계산에 필요한 실제가동시간·계획가동시간·비가동사유 데이터가 현재 MES에
체계화되어 있지 않으며, 이 문제를 해결하는 것이 본 설계의 출발점이다.

이에 따라 본 설계는 제안서의 **OEE(생산종합효율) 관리 효율화** 요구를 이 저장소에 구현한다.

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

이 원칙의 이유는 제안서 1페이지(MES As-Is/To-Be) 진단과 같다. 현재 MES는 가동율 계산의
원천 데이터인 실제가동시간·비가동시간·비가동사유·계획가동시간을 하나의 체계로 관리하지 않는다.
따라서 가동율 데이터는 기존 MES 조회로는 확보할 수 없으며, **OEE 도메인에서 신규 수집·관리하는
것만이 제안서가 요구하는 가동율 관리 체계화를 달성하는 유일한 방법이다.**

| 용도(설계 참고) | 기존 자산(참조만) | OEE 도메인 대응(신규 구현) |
|---|---|---|
| 설비/라인 식별 구조 | `IMCN_MACHINE`, `IP_PRODUCT_LINE` | `OEE_RESOURCE.ref_code` (문자 참조값, FK 아님) |
| 표준시간 구조 | `IP_PRODUCT_MODEL_ST_MASTER` | `OEE_RESOURCE.ideal_ct` |
| 생산수량/양품/불량 구조 | 기존 집계 함수(`F_GET_RUN_ACTUAL_QTY`, `F_GET_RUN_NG_QTY` 등) | `OEE_PRODUCTION_RESULT` (신규, §3-⑥, 집계 적재) |
| 근무일 구조 | `IP_PRODUCT_COMPANY_CALENDAR` | `OEE_WORK_CALENDAR` (신규, §3-⑦) |
| 근무시간대·휴식 구조 | `ICOM_WORKTIME_RANGES` (`RANGE_TYPE`, `START_TIME/END_TIME`, 휴식) | `OEE_WORKTIME_RANGE` (신규, §3-⑦) |

### 2.1 자동수집 설비 검사 데이터 참조
ESFA_EXTDB 확인 결과, `설비로그테이블_ESFA.xlsx`의 `P_INSERT_*` 프로시저들은 대부분 `IQ_MACHINE_INSPECT_DATA_*` 테이블에 자동수집 데이터를 저장한다. 이 데이터는 **생산수량·양품·불량 산출 원천으로 직접 사용하지 않는다.** OEE 생산/양품/불량 수량은 기존 집계 함수 결과를 사용하고, 설비 자동수집 데이터는 공정별 대상 설비 확인, 자동수집 여부 확인, 검사결과/검사일자 참조에만 사용한다.

| 공정 구분 | 프로시저/설비 | 대상 테이블 | 결과 컬럼 | 일자 컬럼 | OEE 활용 |
|---|---|---|---|---|---|
| SMT | REFLOW | `IQ_MACHINE_INSPECT_DATA_REFLOW` | 없음 | `MEASURE_DATE` | 설비조건/가동 참고 후보 |
| SMT | AOI | `IQ_MACHINE_INSPECT_DATA_AOI` | `RESULT`, `REVIEW_RESULT` | `INSPECT_DATE` | 검사결과/검사일자 참조 |
| SMT | SPI | `IQ_MACHINE_INSPECT_DATA_SPI` | `RESULT`, `REVIEW_RESULT` | `INSPECT_DATE` | 검사결과/검사일자 참조 |
| SMT | ICT | `IQ_MACHINE_INSPECT_DATA_ICT` | `RESULT` | `INSPECT_DATE` | 검사결과/검사일자 참조 |
| SMT | LMS/Marking | `IQ_MACHINE_INSPECT_DATA_MK` | `RESULT_CODE` | `DATESET` | 검사/마킹 결과 후보 |
| SMT | SOLDER | `IQ_MACHINE_INSPECT_DATA_SOLDER` | 없음 | `MEASURE_DATE`, `TIME` | 설비조건 참고 후보 |
| SMT | SP | `IQ_MACHINE_INSPECT_DATA_SP` | `RESULT` | `INSPECT_DATE` | 검사결과/검사일자 참조 |
| SMT 후보 | SPLIT(MOUNTER 작업) | `IQ_MACHINE_INSPECT_DATA_SPLIT` | 없음 | `SPLIT_DATE`, `SPLIT_TIME` | 대상 설비 여부 재확인 |
| IMD | WAVE/WAVE FLUX | `IQ_MACHINE_INSPECT_DATA_WAVE1`, `IQ_MACHINE_INSPECT_DATA_WAVE2` | `RESULT` | `INSPECT_DATE` | 검사/설비결과 후보 |
| IMD | ICT2 | `IQ_MACHINE_INSPECT_DATA_ICT2` | `RESULT` | `INSPECT_DATE` | 검사결과/검사일자 참조 |
| 성능검사 | AE-EV/CMA/DN8/ECM/ETT28/STWM/O1XX/LX2/EOP/MOC28/TTM28 | `IQ_MACHINE_INSPECT_DATA_AEEV`, `CMA`, `DN8`, `ECM`, `ETT28`, `STWM`, `O1XX`, `LX2`, `EOP`, `MOC28`, `TTM28` | `RESULT` | `INSPECT_DATE` | 검사결과/검사일자 참조 |

주의: 엑셀의 `P_INSERT_PERFORM_DN8_RAW`는 오타이며, 실제 프로시저는 `P_INSERT_PERFORM_DN8A_RAW`, 대상 테이블은 `IQ_MACHINE_INSPECT_DATA_DN8`이다. 자동수집 테이블의 결과 컬럼명은 대부분 `INSPECT_RESULT`가 아니라 `RESULT`이며, AOI/SPI는 `REVIEW_RESULT`, LMS/Marking은 `RESULT_CODE`도 함께 검토한다. IMD 시트는 SMT 복사본 성격이 있으므로 IMD 대상 산정 시 SMT 설비를 제외한다.

> ⚠️ 구현 착수 시 확인: 작업자 사번 체계(문자열 저장), 공정별 근무패턴(주/야 정의), 자동수집 결과값의 합격/불합격 코드 표준화, 설비별 OEE 대상 여부.

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

### ② `OEE_LOSS_REASON` — OEE 저하요인 코드마스터
제안서 2페이지의 OEE 저하요인(고장정지·셋업/단품교체·자재대기·미세정지·속도저하·불량·Rework·시작품 손실)을 코드화한다. 계산 귀속은 `oee_factor` 하나로만 강제하고, 분석 분류는 `loss_category`로 별도 관리한다. 한 사유가 가동율·성능율·양품율에 중복 귀속되면 OEE 손실이 이중 계산될 수 있으므로 허용하지 않는다.
```
reason_code       PK
organization_id
process_code      -- 공통='*' 또는 공정별
reason_name
oee_factor        -- AVAILABILITY / PERFORMANCE / QUALITY 중 하나만 허용
loss_category     -- MATERIAL / SETUP / MACHINE / LABOR / MINOR_STOP / SPEED / DEFECT / REWORK / STARTUP / ...
input_type        -- TIME / QTY / BOTH (계산 반영 단위 안내)
use_yn
sort_order
```

| oee_factor | 제안서 저하요인 | 대표 loss_category | 계산 반영 |
|---|---|---|---|
| AVAILABILITY | 고장정지, 셋업/단품교체, 자재대기 | MACHINE, SETUP, MATERIAL, LABOR | 실제가동시간/비가동시간 |
| PERFORMANCE | 미세정지, 속도저하 | MINOR_STOP, SPEED | 성능 손실 분석, 표준 CT 대비 생산성 |
| QUALITY | 불량, Rework, 시작품 손실 | DEFECT, REWORK, STARTUP | 양품/불량 수량 |

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
reason_code       -- DOWN일 때 필수 → OEE_LOSS_REASON(oee_factor='AVAILABILITY')
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
기존 집계 함수(`F_GET_RUN_ACTUAL_QTY`, `F_GET_RUN_NG_QTY` 등)를 수집/마감 단계에서 호출해 OEE 도메인에 수량을 적재한다. 대시보드는 기존 함수나 설비 검사 테이블을 직접 실시간 조인하지 않고, `OEE_PRODUCTION_RESULT`만 조회한다.
```
result_id         PK
organization_id
resource_id       -- → OEE_RESOURCE
process_code
work_date
shift
run_no            -- LOT 연계 (nullable)
plan_qty          -- LOT 생산계획 수량 (계획/실적 대비)
output_qty        -- 총생산수량(=검사공정은 검사수량)
good_qty          -- 양품수량
defect_qty        -- 불량수량
pickup_rate       -- SMT 픽업율(%) (SMT 전용, nullable)
source            -- MANUAL / EQUIP / PDA (수집 경로)
created_by
created_date
```
- 수집 경로: 기존 집계 함수 결과를 기본 원천으로 사용한다. 설비 자동수집 데이터(`IQ_MACHINE_INSPECT_DATA_*`)는 수량 산출에 직접 사용하지 않고, 공정별 대상 설비 확인 및 검사결과/검사일자 참조 자료로만 사용한다. 자동 집계 불가/보정 구간은 MANUAL 입력으로 보완한다.
- **계획달성률** = output_qty / plan_qty. **UPH** = output_qty / (실가동분/60), **UPD** = 일자 output_qty 합. (파생 지표)
- **pickup_rate**는 SMT 공정만 사용, 대시보드에서 SMT일 때만 표시.

### ⑦ 근무 마스터 (신규, 계획가동 파생 원천) — 관리화면으로 등록
`OEE_WORK_CALENDAR` — 근무일 달력
```
organization_id, work_date, holiday_yn ('Y'=휴무), remark
```
`OEE_WORKTIME_RANGE` — 근무/휴식 시간대 (**공정별 · 2교대**)
```
range_id PK, organization_id, process_code, shift (DAY/NIGHT), range_type (WORK/BREAK),
start_hhmm (VARCHAR2(4)), end_hhmm (VARCHAR2(4)), sort_order
```
- **2교대**(DAY/NIGHT) 운영. 근무시간은 **공정마다 다를 수 있어** `process_code`로 구분한다.
- 시드 하드코딩이 아니라 **근무시간 마스터 관리 화면**(`/oee/master/worktime`)에서 등록·수정.
- 계획가동 파생 시 리소스의 `process_code`와 매칭되는 근무시간대를 사용한다.

> 단일 사업장(`organization_id = 1`)만 존재. 작업자 사번은 숫자·문자 조합 문자열(`VARCHAR2(50)`).

### ⑧ `OEE_MATERIAL_READINESS` — 원자재 준비율 (원자재 입고/보관/출고)
"생산계획 대비 원자재 준비" 지표. OEE 3요소 밖의 선행 KPI.
```
readiness_id PK, organization_id, work_date, process_code (기본 SMT),
plan_qty (생산계획), ready_qty (준비완료), readiness_rate (=ready/plan), created_by, created_date
```

### ⑨ `OEE_CUSTOMER_DEFECT` — 고객불량 반입 (완제품 창고)
완제품 창고의 "고객사 불량 반입 수량".
```
defect_id PK, organization_id, work_date, model_code (nullable), return_qty, remark, created_by, created_date
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

부가지표(체계도 명시)
  계획달성률 = Σ output_qty / Σ plan_qty
  UPH        = Σ output_qty / (실가동분 / 60)
  UPD        = 일자별 Σ output_qty
  픽업율      = OEE_PRODUCTION_RESULT.pickup_rate (SMT 전용)
  원자재준비율 = OEE_MATERIAL_READINESS.readiness_rate (선행 KPI, OEE 곱셈엔 미포함)
  고객불량    = OEE_CUSTOMER_DEFECT.return_qty (완제품, 사후 지표)

OEE = 가동율 × 성능율 × 양품율
```

### 4.1.1 가동율 데이터 확보 방안 — 신규 수집의 근거
제안서 1페이지(MES As-Is/To-Be)는 현재 MES에 가동율 관리를 위한 데이터가
체계화되어 있지 않다고 진단한다. 이에 따라 본 설계는 가동율 3요소를
모두 OEE 도메인에서 신규 수집·관리한다.

| 가동율 요소 | 데이터 원천 | 확보 방식 |
|---|---|---|
| 실제가동시간 | `OEE_OPERATION_LOG.status='RUN'` (실가동 구간 집계) | OEE 입력화면(/oee/entry)에서 작업자가 구간 등록 |
| 비가동시간 | `OEE_OPERATION_LOG.status='DOWN'` (비가동 구간 집계) | 동일 입력화면, `oee_factor='AVAILABILITY'` 손실사유(`reason_code`) 필수 선택 |
| 계획가동시간(순부하) | `OEE_WORK_CALENDAR × OEE_WORKTIME_RANGE` (근무마스터 파생) | 관리화면(/oee/master/worktime)에서 공정별·2교대 등록 |

결론: 위 3요소가 모두 갖춰져야 비로소 공정별 가동율이 산출된다.
기존 MES가 가동율을 제공하지 않으므로, 모든 요소를 OEE 입력/마스터 단에서
직접 수집·저장·파생하는 것이 본 설계의 핵심 결정이다.

### 4.2 집계 전략 (2계층 + 폴백 없음)
1. **`V_OEE_LIVE` (실시간 계층)** — **진행 중인 당일/현재 근무조에 한해** OEE_OPERATION_LOG + V_OEE_PLAN_TIME + OEE_PRODUCTION_RESULT에서 on-the-fly 계산(모두 자체 도메인). 마감 전 실시간 표시 전용.
2. **`OEE_DAILY_SUMMARY` (확정 계층)** — **오직 `P_OEE_BUILD_SUMMARY`(Oracle 스케줄러 프로시저)만** 근무조 마감 시점에 스냅샷 생성. 과거 이력은 전적으로 이 스냅샷에서만 조회.
3. **폴백 없음** — 마감된 과거 기간을 조회했는데 스냅샷이 없으면 API는 즉석 계산·저장하지 않고 **`OEE_SUMMARY_NOT_BUILT` 오류** 반환. 대시보드는 "집계 미생성(마감 필요)" 오류 상태로 표시. 누락을 정상값처럼 보이게 하지 않는다.

**경계 규칙**: 당일 진행조 = 실시간 뷰 / 마감된 과거 = 스냅샷 전용 / 스냅샷 부재 = 오류.

---

## 5. 입력 UI (Next.js 신규 write)

이 앱은 인증/미들웨어가 없다. 기존 라인필터의 **localStorage 단말 프로파일** 패턴을 재사용한다.

### 5.1 라우트
모니터링(display)과 분리된 신규 그룹 `/oee`:
- `/oee/entry` — 가동/비가동 일지 + 생산수량(계획/실적/양품/불량/픽업) 입력 (핵심, 태블릿)
- `/oee/master/resource` — 리소스 마스터
- `/oee/master/reason` — OEE 저하요인 코드 (`AVAILABILITY`/`PERFORMANCE`/`QUALITY` 단일 귀속)
- `/oee/master/worktime` — 근무시간 마스터(공정별·2교대)
- `/oee/master/plan-time` — 계획가동시간 예외 보정(override)
- `/oee/input/material` — 원자재 준비율 입력 (원자재 공정)
- `/oee/input/customer` — 고객불량 반입 입력 (완제품 창고)

### 5.2 가동일지 입력 `/oee/entry`
- 상단: **단말 프로파일**(공정·리소스·근무조) — localStorage 저장, 최초 1회 선택 후 고정.
- 본문: 해당 근무조 **타임라인**. 구간 추가 = `start~end` + 상태(RUN/DOWN) + DOWN이면 가동율 손실사유(`oee_factor='AVAILABILITY'`, 前공정대기 포함) + RUN_NO 연계(선택).
- **생산수량 섹션**: LOT별 계획수량·생산(검사)수량·양품·불량, SMT면 픽업율. → `OEE_PRODUCTION_RESULT`.
- **작업자 식별**: 입력·저장 시 작업자 사번 선택/스캔 → `created_by`.
- 태블릿 친화: 큰 버튼, 시간 스텝퍼/슬라이더.

### 5.3 검증 규칙 (프론트 + API 공유)
- 구간 겹침 금지
- 구간 합 ≤ 계획가동시간(근무시간)
- `status='DOWN'` → `oee_factor='AVAILABILITY'`인 `reason_code` 필수
- 미래시간/역전(start>end) 금지
- 저장: 근무조 replace를 `executeTransaction`으로 원자화

### 5.4 마스터 화면
리소스/OEE 저하요인/근무시간/예외보정 표준 CRUD + 원자재준비·고객불량 입력.

---

## 6. 대시보드 (모니터링 display)

기존 display 패턴(`DisplayLayout`, `screens.ts`, Recharts/ECharts, 밀도 높은 대시보드) 준수. screenId 43번까지 존재 → **신규 44~46 부여**.

| screenId | 화면 | 내용 | 데이터 |
|---|---|---|---|
| 44 | 공정별 OEE 종합 현황 | 6공정 카드, OEE 대형 수치 + 가동/성능/양품 3게이지 + UPH/UPD·계획달성률, SMT는 픽업율 | 당일=`V_OEE_LIVE` / 과거=`OEE_DAILY_SUMMARY` |
| 45 | 리소스 드릴다운 | 공정 선택 → 설비/라인/작업그룹별 OEE 순위·비교, 리소스 실시간 상태 | 동일 |
| 46 | 로스 분석 파레토 | `oee_factor`별 손실요인 파레토. 가동율은 시간(前공정대기·자재·셋업·고장·부재), 성능율은 미세정지·속도저하, 양품율은 불량·Rework·시작품 손실 | `OEE_OPERATION_LOG` + `OEE_PRODUCTION_RESULT` + `OEE_LOSS_REASON` |

- 44 카드에 부가지표(UPH/UPD/계획달성률) 표기, SMT 카드에만 픽업율 노출.
- 원자재 준비율(`OEE_MATERIAL_READINESS`)·고객불량(`OEE_CUSTOMER_DEFECT`)은 44 상/하단 보조 위젯으로 표시(선행/사후 KPI).
- OEE 트렌드(일/주/월)는 44~46 내 탭 또는 별도로 `OEE_DAILY_SUMMARY` 스냅샷 전용.
- 라인/공정 필터: 기존 display의 localStorage/이벤트 방식 준수. 스냅샷 부재 시 오류 배지.

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
- [x] 작업자 사번 체계 → 숫자·문자 조합 문자열 (`VARCHAR2(50)`)
- [x] 사업장 → `organization_id = 1` 단일 (다중사업장 고려 제거)
- [x] 근무패턴 → **2교대(DAY/NIGHT)**, 근무시간은 **공정별 상이 가능** → `OEE_WORKTIME_RANGE.process_code` + 관리화면(`/oee/master/worktime`)
- [x] 가동율 원천 데이터 → 기존 MES에 없음 → **OEE 신규 입력/마스터로 확보** (`OEE_OPERATION_LOG`·`OEE_WORK_CALENDAR`·`OEE_WORKTIME_RANGE`)
- [x] 생산수량/양품/불량 원천 → 기존 집계 함수 사용 (`F_GET_RUN_ACTUAL_QTY`, `F_GET_RUN_NG_QTY` 등)
- [x] 설비 자동수집 데이터 → ESFA_EXTDB의 `IQ_MACHINE_INSPECT_DATA_*` 테이블로 확인 (`RESULT`/`REVIEW_RESULT`/`RESULT_CODE`, `INSPECT_DATE` 등). 수량 원천이 아니라 대상 설비/검사결과 참조용
- [ ] 공정별 실제 근무시간·휴식 값 (관리화면 등록 데이터, 개발 후 실무 입력)
- [ ] 공정별 리소스 실제 단위 확정 (성능검사/코팅/라우팅/조립/검사·포장)
- [ ] Oracle 스케줄러 사용 가능 여부 및 근무조 마감 시점 정의
- [ ] OEE 저하요인 코드 매핑 실무 확정 (`oee_factor` 단일 귀속: AVAILABILITY/PERFORMANCE/QUALITY, `loss_category` 분석 분류)
- [ ] 기존 집계 함수의 공정별 입력 파라미터와 반환 기준 확인
- [ ] 자동수집 결과 코드 표준화 (OK/PASS/GOOD 등 양품, NG/FAIL 등 불량) — 수량 산출용이 아니라 검사결과 참조/상세분석용
- [ ] SPLIT(MOUNTER 작업)의 OEE 대상 설비 여부 재확인 (현재 SMT 후보, 확정 아님)
- [ ] 자동수집 불가/누락 구간의 MANUAL 보정 운영 기준 확정

---

## 12. 개정 이력
- **REV1 (2026-07-06)**: 초기 설계 — 접근 B(독립 OEE 도메인), 단 계획가동·성능·양품 원천은 기존 MES 자산 런타임 참조.
- **REV2 (2026-07-06)**: 사용자 지시 "기존 구조는 참조만, 모두 새로 구현" 반영. 기존 MES 테이블·함수 **런타임 의존 전면 제거**. 생산수량은 `OEE_PRODUCTION_RESULT`(⑥), 근무/계획가동은 `OEE_WORK_CALENDAR`·`OEE_WORKTIME_RANGE`(⑦)로 **자체 신규 구현**. §2는 "설계 참조 전용"으로 재정의.
  - 영향: 플랜 1(테이블 5종)은 그대로 유효, 신규 테이블(⑥⑦)은 **플랜 3에서 추가 DDL**로 편입. 플랜 2(입력)는 자립적이라 변동 없음(생산수량 입력 섹션은 플랜 3에서 입력화면에 추가).
- **REV3 (2026-07-06)**: 근무패턴 실무 확정. 2교대(DAY/NIGHT), `OEE_WORKTIME_RANGE`에 **`process_code` 추가**(공정별 근무시간 상이), **근무시간 마스터 관리화면**(`/oee/master/worktime`) 도입. `organization_id=1` 단일 확정. `V_OEE_PLAN_TIME` 파생 조인에 `process_code` 추가.
- **REV4 (2026-07-06)**: OEE 관리 체계도(제안서 10쪽) 재점검 반영 — 부가지표 4종 전부 포함. ①前공정대기 사유 시드 + UPH/UPD 파생, ②`OEE_PRODUCTION_RESULT.plan_qty`(LOT 계획/실적)·`pickup_rate`(SMT), ③원자재준비율 `OEE_MATERIAL_READINESS`(⑧), ④고객불량 `OEE_CUSTOMER_DEFECT`(⑨). 원자재준비율·고객불량은 OEE 곱셈식에는 미포함되는 선행/사후 KPI로 대시보드에만 노출.
- **REV5 (2026-07-07)**: 제안서 2페이지의 OEE 저하요인 설계 보강. `OEE_DOWNTIME_REASON`을 `OEE_LOSS_REASON` 개념으로 확장하고, 각 사유는 `oee_factor`(AVAILABILITY/PERFORMANCE/QUALITY) 중 하나에만 귀속하도록 정의. 중복 귀속은 금지하고, 현상 분석은 `loss_category`, 입력 단위는 `input_type`으로 분리.
- **REV6 (2026-07-07)**: `설비로그테이블_ESFA.xlsx`와 ESFA_EXTDB 조회 결과 반영. `IQ_MACHINE_INSPECT_DATA_*` 테이블은 생산수량·양품·불량 산출 원천이 아니라 공정별 대상 설비 확인 및 검사결과/검사일자 참조 자료로 정리했다. OEE 수량 원천은 기존 집계 함수(`F_GET_RUN_ACTUAL_QTY`, `F_GET_RUN_NG_QTY` 등)를 사용한다. 자동수집 결과 컬럼은 대부분 `INSPECT_RESULT`가 아니라 `RESULT`이며, AOI/SPI는 `REVIEW_RESULT`, LMS/Marking은 `RESULT_CODE`를 함께 확인한다. `SPLIT`는 IMD가 아니라 SMT/MOUNTER 작업 후보로 재분류하되 OEE 대상 여부는 추후 확인으로 남김.
