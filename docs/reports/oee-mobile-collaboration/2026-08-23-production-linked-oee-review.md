# OEE_RESOURCE 범위 생산연계 OEE 검토

- 검토일: 2026-08-23~2026-08-24
- 대상: OEE 리소스, BOM, 라우팅, 생산실적, 품목 CT, OEE 대시보드
- 개발 DB: `EUNSUNG_DEV_ESDBPDB`
- 상태: 사용자 추가 기준 반영 완료, 상세 업무정책 확정 전

## 1. 사용자 확정 기준

1. SMT는 기존 MES에서 계속 생산해 온 생산라인이다.
2. ASSY의 OEE 리소스는 이 프로젝트에서 생산관리를 추가할 CELL이다.
3. OEE 대상은 `OEE_RESOURCE`에 등록된 LINE/CELL로 한정한다.
4. `OEE_RESOURCE` 밖의 LINE/CELL은 생산 데이터가 있어도 OEE 대상이 아니다.
5. OEE 리소스의 생산방식은 BOM-only, BOM+라우팅, 라우팅-only 중 하나로 구분해야 한다.
6. 실제 생산되는 OEE LINE/CELL의 생산실적과 생산품 CT를 이용해 OEE를 계산해야 한다.

본 문서는 위 기준에 맞춰 현재 구조의 문제와 목표 계약을 정리한다.

## 2. 기존 검토에서 교정한 내용

이전 분석에서는 `IP_PRODUCT_RUN_CARD.LINE_CODE` 50~64에 생산 이력이 있다는 이유로 현재 ASSY OEE 리소스 19~24와 생산 CELL이 불일치한다고 판단했다.

사용자 확인에 따라 이 판단을 폐기한다.

```text
50~64 등 OEE_RESOURCE 밖 코드
→ 기존 생산 이력이 있어도 이번 OEE 대상이 아님

ASSY OEE_RESOURCE 19~24
→ 이 프로젝트에서 생산관리를 신규 적용할 CELL
```

따라서 외부 생산이력 코드와 OEE 리소스를 자동 교체하거나 합치는 방향으로 변경하지 않는다.

또한 CELL을 부모 생산라인으로 자동 roll-up해야 한다는 전제도 확정하지 않는다. OEE는 `OEE_RESOURCE`에 등록된 각 LINE/CELL을 계산 리소스로 사용하며, 공정 전체 집계만 합계 피연산자로 계산한다.

## 3. 핵심 결론

OEE 계산 후보는 항상 다음 조건에서 시작해야 한다.

```text
OEE_RESOURCE.ORGANIZATION_ID = 인증 조직
AND OEE_RESOURCE.USE_YN = 'Y'
AND OEE_RESOURCE.PROCESS_CODE IN ('SMT', 'ASSY')
AND OEE_RESOURCE.RESOURCE_TYPE IN ('LINE', 'CELL')
```

이 후보 중 생산자격과 생산근거가 확인된 리소스만 숫자 OEE를 계산한다.

```text
활성 OEE_RESOURCE
→ 리소스에 배정된 생산품/라우팅 확인
→ 명시적 생산방식 확인
→ BOM_ONLY, BOM_ROUTE 또는 ROUTE_ONLY 규칙 검증
→ 실제 생산계획/RUN 확인
→ 실제 생산실적 확인
→ 생산품 CT snapshot 확인
→ LINE/CELL 리소스 OEE 계산
```

등록만 되어 있고 생산하지 않은 리소스를 무조건 OEE 0으로 계산하지 않는다.

## 4. 현재 개발 DB 상태

### 4.1 OEE 리소스

| 공정 | 유형 | 코드 | 건수 |
|---|---|---|---:|
| SMT | LINE | 01~12 | 12 |
| ASSY | CELL | 19~24 | 6 |

이 18건만 OEE 범위다. 다른 LINE/CELL 코드는 현재 OEE 집계·평균·분모에 포함하지 않는다.

### 4.2 OEE 생산실적

```text
OEE_PRODUCTION_RESULT = 0건
```

현재 애플리케이션에는 `OEE_PRODUCTION_RESULT`를 실제로 생성하는 entity, DTO, service, API, 자동 adapter가 없다.

`/oee/equip-work-result`는 DB 저장이 없는 Mock 화면이므로 생산실적 원장으로 사용할 수 없다.

### 4.3 라우팅

현재 코드의 라우팅 화면은 다음 신규 테이블 계약을 사용한다.

```text
IP_ROUTING_GROUPS
IP_ROUTING_PROCESSES
IP_ROUTING_MATERIALS
```

개발 DB에는 위 테이블이 없다. 개발 DB에 존재하는 다음 라우팅 테이블은 모두 0건이다.

```text
ROUTING_GROUPS
ROUTING_PROCESSES
ROUTING_MATERIALS
PROCESS_MAPS
IP_PRODUCT_ROUTING
IP_PRODUCT_ROUTING_MASTER
```

생산연계 OEE 구현 전에 코드와 실제 DB의 라우팅 테이블 계약을 먼저 통일해야 한다.

### 4.4 품목 CT

`IP_PRODUCT_ST_MASTER` 현황:

| 항목 | 결과 |
|---|---:|
| CT 행 | 212 |
| 품목 수 | 212 |
| NULL 또는 0 이하 CT | 0 |
| 최소 적용일 | 2026-08-19 |
| 최대 종료일 | 9999-12-31 |

현재 CT는 향후 생산에는 사용할 수 있다. 2026-08-19 이전 OEE가 필요하면 과거 CT backfill 기준이 별도로 필요하다.

## 5. 현재 OEE 0의 문제

현재 Oracle 계산 경로:

```text
활성 OEE_RESOURCE
× 업무일
× A~J 업무시간
→ OEE_PRODUCTION_RESULT LEFT JOIN
→ 생산실적 없음 = 생산수량 0
→ Performance 0
→ Quality 0
→ OEE 0
```

생산·비가동 데이터가 모두 없으면 다음과 같은 오해 가능한 결과가 생긴다.

```text
Availability = 100%
Performance  = 0%
Quality      = 0%
OEE          = 0%
```

이 결과는 실제로 100% 가동 후 생산이 0이었다는 뜻이 아니라 생산계획·실적수집·라우팅 연결이 없다는 뜻일 수 있다.

따라서 다음 상태를 분리해야 한다.

- 생산계획 없음
- 생산계획은 있으나 실적수집 여부 불명
- 계획된 생산 결과가 실제 0
- 라우팅 없음
- 생산방식 미지정
- BOM 누락
- 생산 리소스 배정 누락
- CT 누락
- 생산수량은 있으나 양품 0

## 6. 생산방식 계약

### 6.1 생산방식은 명시적으로 등록

확정 코드:

```text
BOM_ONLY
BOM_ROUTE
ROUTE_ONLY
```

#### `BOM_ONLY`

생산시점에 다음 조건을 만족해야 한다.

1. 생산일 기준 유효 BOM이 존재한다.
2. 라우팅 존재를 필수로 요구하지 않는다.
3. 품목·모델·고객 조건이 대상 `OEE_RESOURCE`에 직접 배정돼 있다.
4. 실제 생산실적이 같은 리소스·품목·RUN에 귀속된다.

#### `BOM_ROUTE`

생산시점에 다음 조건을 모두 만족해야 한다.

1. 활성 라우팅이 정확히 한 건 존재한다.
2. 생산일 기준 유효 BOM이 존재한다.
3. BOM 자재와 라우팅 공정별 투입자재 배정이 유효하다.
4. 생산 라우팅 공정이 대상 `OEE_RESOURCE`에 배정돼 있다.
5. 실제 생산실적이 같은 리소스·품목·RUN에 귀속된다.

SMT와 ASSY 모두 품목·모델·고객별 실제 기준에 따라 이 방식을 선택할 수 있다.

#### `ROUTE_ONLY`

생산시점에 다음 조건을 만족해야 한다.

1. 활성 라우팅이 정확히 한 건 존재한다.
2. BOM 존재를 필수로 요구하지 않는다.
3. 생산 라우팅 공정이 대상 `OEE_RESOURCE`에 배정돼 있다.
4. 실제 생산실적이 같은 리소스·품목·RUN에 귀속된다.

SMT와 ASSY 모두 품목·모델·고객별 실제 기준에 따라 이 방식을 선택할 수 있다.

### 6.2 BOM·라우팅 부재로 생산방식을 추론하지 않음

다음 추론은 금지한다.

```text
BOM 있음 + 라우팅 없음 → BOM_ONLY
BOM 있음 + 라우팅 있음 → BOM_ROUTE
BOM 없음 → ROUTE_ONLY
```

BOM이 없는 상태는 정상 라우팅-only 생산이 아니라 BOM 기준정보 누락이나 유효기간 만료일 수 있다.

따라서 `PRODUCTION_BASIS`를 명시적으로 저장해야 한다. `BOM_ONLY`와 `BOM_ROUTE`에서 BOM이 없으면 오류로 처리하고, `BOM_ROUTE`와 `ROUTE_ONLY`에서 라우팅이 없으면 오류로 처리한다.

### 6.3 기존 필드 재사용 금지

다음 필드는 생산방식 의미가 아니므로 `BOM_ONLY`/`BOM_ROUTE`/`ROUTE_ONLY` 판정에 재사용하지 않는다.

- `ID_ITEM.ITEM_CLASS`
- `ID_ITEM.ITEM_TYPE`
- `ID_ITEM.ITEM_DIVISION`
- `ID_ITEM.LINE_TYPE`
- `IP_ROUTING_PROCESSES.JOB_ORDER_YN`
- `IP_PRODUCT_LINE.PRODUCTION_TYPE`
- `WORK_ORDER_TYPE`

`JOB_ORDER_YN`은 라우팅 공정에서 작업지시를 생성할지 나타내는 값이며 품목 전체의 생산방식이 아니다.

## 7. BOM 유효성

현재 BOM 원장은 `ID_ENG_BOM`이다.

생산일 기준 유효 BOM:

```sql
PARENT_ITEM_CODE = :itemCode
AND DATESET <= TRUNC(:productionDate)
AND NVL(DATEEND, DATE '9999-12-31') >= TRUNC(:productionDate)
```

검증 항목:

1. 생산품이 W/F 등 승인된 생산품 유형인지 확인한다.
2. 동일 자품목의 유효기간 중복을 허용하지 않는다.
3. 라우팅 자재 배정이 유효 BOM에 존재하는지 확인한다.
4. 생산일을 기준으로 검증하고 현재 `SYSDATE`만 사용하지 않는다.
5. BOM 변경 후에도 이미 생성된 생산실적의 생산방식과 자재 근거가 바뀌지 않도록 snapshot한다.

`ROUTE_ONLY`는 BOM 검증을 생략하지만 생산방식이 명시적으로 `ROUTE_ONLY`여야 한다. `BOM_ONLY`는 라우팅 검증을 생략하지만 품목·모델·고객과 OEE 리소스의 직접 배정이 유효해야 한다.

## 8. 라우팅 유효성

현재 목표 라우팅 구조:

```text
품목·모델·고객
→ BOM_ONLY: OEE_RESOURCE 직접 생산 배정
→ BOM_ROUTE/ROUTE_ONLY: 활성 라우팅 그룹·공정
→ OEE_RESOURCE 생산 배정
```

유효 라우팅 조건 후보:

```text
IP_ROUTING_GROUPS.ORGANIZATION_ID = 인증 조직
IP_ROUTING_GROUPS.ITEM_CODE = 생산품
IP_ROUTING_GROUPS.USE_YN = 'Y'

IP_ROUTING_PROCESSES.ROUTING_CODE = 라우팅
IP_ROUTING_PROCESSES.PROCESS_SEQ = 생산 공정
IP_ROUTING_PROCESSES.USE_YN = 'Y'
IP_ROUTING_PROCESSES.EXECUTION_TYPE = 'INTERNAL'
IP_ROUTING_PROCESSES.JOB_ORDER_YN = 'Y'
```

외주 `SUBCON` 공정을 내부 OEE LINE/CELL에 자동 귀속하지 않는다. 외주 공정 OEE가 필요하면 별도 정책이 필요하다.

`BOM_ROUTE`와 `ROUTE_ONLY`에서 라우팅이 없거나 활성 라우팅이 중복되면 임의 선택하지 않는다. `BOM_ONLY`에는 이 조건을 적용하지 않는다.

## 9. OEE_RESOURCE 생산 배정

### 9.1 OEE_RESOURCE에 품목·라우팅 컬럼을 직접 추가하지 않음

한 LINE/CELL은 여러 품목과 라우팅을 생산할 수 있다.

다음 필드를 `OEE_RESOURCE` 단일 행에 직접 추가하면 리소스당 하나의 품목만 표현하게 된다.

```text
ITEM_CODE
ROUTING_CODE
PROCESS_SEQ
PRODUCTION_BASIS
```

따라서 반복 가능한 별도 관계가 필요하다.

### 9.2 후보 관계 테이블

후보 이름:

```text
OEE_RESOURCE_PRODUCTION_RULE
```

후보 필드:

| 필드 | 설명 |
|---|---|
| `RULE_ID` | 내부 PK |
| `ORGANIZATION_ID` | 조직 |
| `RESOURCE_ID` | OEE 대상 LINE/CELL |
| `ITEM_CODE` | 생산품 |
| `MODEL_NAME` | 모델 조건, 필요 시 |
| `CUSTOMER_CODE` | 고객 조건, 필요 시 |
| `PRODUCTION_BASIS` | `BOM_ONLY`, `BOM_ROUTE`, `ROUTE_ONLY` |
| `ROUTING_CODE` | 적용 라우팅, `BOM_ONLY`는 NULL |
| `PROCESS_SEQ` | 생산 완료/실적 공정, `BOM_ONLY`는 NULL |
| `EFFECTIVE_FROM` | 적용 시작일 |
| `EFFECTIVE_TO` | 적용 종료일 |
| `USE_YN` | 사용 여부 |

`RESOURCE_ID`로 연결하므로 OEE 범위 밖 LINE/CELL은 생산규칙에 등록할 수 없다.

### 9.3 유효기간

```text
EFFECTIVE_FROM <= 생산일 <= EFFECTIVE_TO
```

같은 조직·리소스·품목·모델·고객·라우팅 공정의 유효기간 중복을 차단한다.

모델·고객에 따라 생산 CELL이 달라지면 해당 조건별로 다른 `RESOURCE_ID` 규칙을 등록한다.

문자열 모델명만으로 연결하기보다 `ITEM_CODE`를 기본 식별자로 사용하고 모델·고객은 검증 또는 예외 조건으로 사용하는 것이 안전하다.

SMT 원천에서는 다음 기준으로 snapshot할 수 있다.

```text
ITEM_CODE     = IP_PRODUCT_RUN_CARD.ITEM_CODE
MODEL_NAME    = IP_PRODUCT_RUN_CARD.MODEL_NAME
CUSTOMER_CODE = ID_ITEM.CUSTOMER_CODE
```

2026-08-24 운영 표본 13개 RUN은 RUN 모델명과 `ID_ITEM.MODEL_NAME`이 일치했고 고객코드도 모두 존재했다. 다만 이 표본만으로 전체 데이터의 일치·필수성을 보장하지 않으므로 adapter에서 불일치를 검증상태로 남긴다.

## 10. OEE 포함 상태

| 상태 | 조건 | 숫자 OEE |
|---|---|---|
| `OUT_OF_SCOPE` | OEE_RESOURCE 밖 LINE/CELL | 제외 |
| `NOT_SCHEDULED` | 생산규칙은 있으나 해당 일자 계획/RUN 없음 | 제외 |
| `NOT_RECORDED` | 계획/RUN은 있으나 실적수집 여부 불명 | 계산불가 |
| `ZERO_PRODUCTION` | 계획/RUN이 있고 수집 결과가 실제 0으로 확정 | 성능율 0 반영 |
| `PRODUCTION_BASIS_MISSING` | 생산방식 미지정 | 계산불가 |
| `BOM_MISSING` | BOM 필수 생산방식이나 유효 BOM 없음 | 계산불가 |
| `ROUTING_MISSING` | 라우팅 필수 생산방식이나 활성 라우팅 없음 | 계산불가 |
| `ROUTING_AMBIGUOUS` | 활성 라우팅 또는 생산규칙 중복 | 계산불가 |
| `RESOURCE_UNASSIGNED` | 라우팅 공정의 OEE 리소스 배정 없음 | 계산불가 |
| `RESOURCE_MISMATCH` | 실제 생산 리소스가 배정 리소스와 다름 | 계산불가 |
| `CT_MISSING` | 생산일 기준 품목 CT 없음 | 계산불가 |
| `CT_INVALID` | CT 0 이하 또는 기간 중복 | 계산불가 |
| `SOURCE_AMBIGUOUS` | 같은 PID의 최신 판정이 서로 충돌 | 계산불가 |
| `PARTIAL` | 일부 생산실적만 정상 | 부분 상태 |
| `CALCULABLE` | 생산방식·BOM/라우팅·리소스·실적·CT 정상 | 계산 |

중요한 구분:

```text
계획 없음 + 생산 없음
→ NOT_SCHEDULED, OEE 0 아님

계획 있음 + 수집 결과 생산 0
→ ZERO_PRODUCTION, 의미 있는 성능 손실

생산수량 > 0 + 양품수량 0
→ 실제 Quality 0
```

## 11. 생산실적 원장

### 11.1 현재 한계

현재 `OEE_PRODUCTION_RESULT`에는 다음 값이 없다.

- 품목
- 모델
- 고객
- 생산방식
- 라우팅
- 라우팅 공정
- CT snapshot
- 원천 고유키
- 생산시각
- 계산상태

### 11.2 권장 필드

```text
ORGANIZATION_ID
RESOURCE_ID
PROCESS_CODE
RESOURCE_TYPE_SNAPSHOT
WORK_DATE
SHIFT
RUN_NO
ITEM_CODE
MODEL_NAME
CUSTOMER_CODE
PRODUCTION_BASIS
ROUTING_CODE
PROCESS_SEQ
PLAN_QTY
INPUT_QTY
OUTPUT_QTY
GOOD_QTY
DEFECT_QTY
CT_SNAPSHOT_SEC
CT_SOURCE
SOURCE
SOURCE_REF_ID
SOURCE_EVENT_TIME
SOURCE_STATUS
CALC_STATUS
ENTER_BY
ENTER_DATE
UPDATED_BY
UPDATED_DATE
```

무결성:

```text
GOOD_QTY + DEFECT_QTY = OUTPUT_QTY
OUTPUT_QTY >= 0
CT_SNAPSHOT_SEC > 0 when CALC_STATUS = CALCULABLE
RESOURCE_ID는 인증 조직의 활성 OEE_RESOURCE
생산실적의 품목·라우팅·리소스는 생산시점 규칙과 일치
```

자동 원천 중복 방지:

```text
UNIQUE (ORGANIZATION_ID, SOURCE, SOURCE_REF_ID)
```

수동 실적과 자동 실적의 nullable source reference 계약은 분리해야 한다.

## 12. 품목 CT

성능율 CT의 권위는 생산품의 `IP_PRODUCT_ST_MASTER.CT_VALUE`다.

```text
ITEM_CODE
+ 생산일
→ 유효 CT_VALUE 정확히 한 건
→ CT_SNAPSHOT_SEC 저장
```

다음 값은 자동 fallback으로 사용하지 않는다.

- `OEE_RESOURCE.IDEAL_CT`
- 라우팅 `STANDARD_TIME`
- 공정 `ST_VALUE`
- 라인 UPH 역산
- 임의 20초

라우팅 `STANDARD_TIME`은 공정 표준시간이며 품목 Cycle Time과 동일하다고 확정되지 않았다.

다품목 생산 성능율:

```text
CT_OUTPUT_SEC = Σ(CT_SNAPSHOT_SEC × OUTPUT_QTY)
Performance   = CT_OUTPUT_SEC / RUN_SEC
```

CT를 생산실적에 snapshot하므로 이후 표준시간 변경이 과거 OEE를 바꾸지 않는다.

## 13. SMT와 ASSY 생산연계

### 13.1 SMT

SMT는 기존 검사 원장을 생산수량 원천으로 사용한다.

사용자 확정 원천:

```text
투입수량 = IQ_MACHINE_INSPECT_SPI
생산실적 = IQ_MACHINE_INSPECT_AOI
```

후보 흐름:

```text
IP_PRODUCT_RUN_CARD 계획/RUN
→ OEE_RESOURCE SMT LINE 01~12 범위 확인
→ 품목·모델·고객의 생산방식과 생산규칙 확인
→ SPI 투입 PID 집계
→ AOI 생산 PID와 최종 판정 집계
→ 품목 CT snapshot
→ OEE_PRODUCTION_RESULT
```

기존 생산 데이터가 OEE_RESOURCE 밖 라인에 존재해도 이번 OEE에 포함하지 않는다.

운영 DB 2026-08-24 00:00~24:00 표본:

| 원천 | 행 수 | 고유 PID | RUN_NO NULL | RUN 수 |
|---|---:|---:|---:|---:|
| `IQ_MACHINE_INSPECT_SPI` | 30,118 | 30,116 | 0 | 14 |
| `IQ_MACHINE_INSPECT_AOI` | 30,462 | 29,455 | 0 | 35 |

검증 결과:

- SPI의 동일 PID 반복은 표본에서 2행이었다.
- AOI는 동일 PID가 최대 5회 반복됐다.
- AOI에는 `OK`, `NG`, `USEROK`, `USERNG`, `MasterOK`, `MasterNG`가 존재한다.
- AOI `REVIEW_RESULT`가 있으면 최초 `RESULT`와 최종 판정이 다를 수 있다.
- `PID='NULL'`, `RUN_NO='*'`인 설비성 행이 존재한다.
- 기존 `F_GET_AOI_PASS_RATE_BY_RUNNO`는 `MasterOK`/`MasterNG`를 제외하지만 serial 중복은 허용한다.
- 생산수량 OEE에는 재검 행 중복을 그대로 허용하면 실제 생산품보다 과대계상될 수 있다.

확정 집계 grain:

```text
SPI 투입 1건 = ORGANIZATION_ID + RUN_NO + LINE_CODE + PID 고유 건
AOI 생산 1건 = ORGANIZATION_ID + RUN_NO + LINE_CODE + PID 고유 건
```

제외 조건:

```text
PID IS NULL
PID = 'NULL'
RUN_NO IS NULL
RUN_NO = '*'
RESULT IN ('MasterOK', 'MasterNG')
```

AOI 최종 판정:

1. 같은 grain에서 `INSPECT_DATE`가 가장 최신인 검사행을 선택한다.
2. 최신 행의 `REVIEW_RESULT`가 있으면 `REVIEW_RESULT`를 사용한다.
3. `REVIEW_RESULT`가 없으면 `RESULT`를 사용한다.
4. 최종값의 대소문자를 정규화한다.
5. `OK`, `GOOD`, `PASS`, `USEROK`는 양품으로 처리한다.
6. `NG`, `NO`, `USERNG`는 불량으로 처리한다.
7. 알려지지 않은 값은 임의로 불량 처리하지 않고 계산 오류로 남긴다.
8. 같은 최신시각에 상충하는 판정이 둘 이상이면 `SOURCE_AMBIGUOUS`로 계산하지 않는다.

`INSPECT_DATE`가 `VARCHAR2`이므로 형식 오류를 별도로 검출하고, 정상값은 `YYYY/MM/DD HH24:MI:SS`로 명시 변환한다.

`IP_PRODUCT_RUN_CARD.RUN_STATUS=5`는 작업 마감이 아니다. AOI insert trigger가 첫 AOI 입력 시 RUN 상태를 QC 단계 5로 올리므로 생산 도중에도 5가 된다.

```text
1 CREATE
2 MATERIAL ISSUE
3 KITTING
4 SMT SCAN
5 QC
6 BOX LABEL
7 RECEIPT
8 SHIPPING
```

SMT 작업 마감은 다음으로 확정한다.

```text
IP_PRODUCT_RUN_CARD.RUN_STATUS IN ('6', '7', '8')
```

즉 BOX LABEL 이상 진행된 RUN만 마감된 것으로 간주한다. 마감된 RUN의 AOI 고유 PID가 0건일 때만 `ZERO_PRODUCTION`으로 성능 손실을 반영한다. `RUN_STATUS=5`만으로 `ZERO_PRODUCTION`을 만들지 않는다.

### 13.2 ASSY

ASSY CELL 19~24는 이 프로젝트의 신규 생산관리 흐름을 사용한다.

후보 흐름:

```text
ASSY 생산계획/작업지시
→ BOM_ONLY, BOM_ROUTE 또는 ROUTE_ONLY 명시
→ 생산방식에 필요한 BOM·라우팅 검증
→ OEE_RESOURCE CELL 19~24 중 유효 배정
→ 생산실적 입력/수집
→ 품목 CT snapshot
→ OEE_PRODUCTION_RESULT
```

ASSY를 무조건 `ROUTE_ONLY`로 고정하지 않는다. 품목·모델·고객별로 `BOM_ONLY`, `BOM_ROUTE`, `ROUTE_ONLY` 중 실제 생산방식을 등록한다.

## 14. OEE 계산식

각 OEE LINE/CELL·업무일·A~J 구간의 피연산자:

```text
NET_LOAD_SEC
RUN_SEC
CT_OUTPUT_SEC = Σ(CT_SNAPSHOT_SEC × OUTPUT_QTY)
INPUT_QTY     = Σ INPUT_QTY
OUTPUT_QTY    = Σ OUTPUT_QTY
GOOD_QTY      = Σ GOOD_QTY
```

리소스 OEE:

```text
Availability = RUN_SEC / NET_LOAD_SEC
Performance  = CT_OUTPUT_SEC / RUN_SEC
Quality      = GOOD_QTY / OUTPUT_QTY
OEE          = Availability × Performance × Quality
```

공정 전체 OEE:

```text
Availability = Σ RUN_SEC / Σ NET_LOAD_SEC
Performance  = Σ CT_OUTPUT_SEC / Σ RUN_SEC
Quality      = Σ GOOD_QTY / Σ OUTPUT_QTY
OEE          = Availability × Performance × Quality
```

다음 단순 평균은 사용하지 않는다.

```text
AVG(resource availability)
AVG(resource performance)
AVG(resource quality)
AVG(resource OEE)
```

규모가 다른 LINE/CELL과 구간을 같은 가중치로 평균하면 공정 OEE가 왜곡된다.

## 15. Oracle View 변경

### 15.1 `V_OEE_PLAN_TIME`

현재는 모든 활성 OEE 리소스에 계획시간을 생성한다.

목표:

- OEE_RESOURCE 밖 리소스는 계속 제외
- 해당 업무일 생산계획/RUN이 없는 리소스는 `NOT_SCHEDULED`
- 계획/RUN이 있는 리소스만 숫자 OEE의 시간 분모 후보
- 계획시간 override 유지

### 15.2 `V_OEE_LIVE`

현재 생산실적 부재를 0으로만 치환하는 로직을 변경한다.

추가 피연산자·상태 후보:

- `PRODUCTION_ROW_COUNT`
- `CT_OUTPUT_SEC`
- `CT_MISSING_COUNT`
- `BOM_ERROR_COUNT`
- `ROUTING_ERROR_COUNT`
- `RESOURCE_RULE_COUNT`
- `CALC_STATUS`

생산방식별 검증 결과를 유지한 뒤 `CALCULABLE`과 확정된 `ZERO_PRODUCTION`만 숫자 계산에 사용한다.

### 15.3 `OEE_DAILY_SUMMARY`

마감 snapshot에 다음 값을 추가한다.

- 순부하시간
- 가동시간
- CT 이상생산시간
- SPI/공정 투입수량
- 생산수량
- 양품수량
- 불량수량
- 생산실적 건수
- 생산방식
- 계산상태
- BOM/라우팅/CT 오류 건수

과거 summary는 현재 BOM·라우팅·CT 변경에 영향을 받지 않아야 한다.

## 16. API와 화면 변경

### 16.1 OEE 리소스 관리

현재 LINE/CELL 등록 기능은 유지한다.

추가 기능:

- 리소스별 생산규칙 목록
- 품목·모델·고객 선택
- `BOM_ONLY`/`BOM_ROUTE`/`ROUTE_ONLY` 선택
- 라우팅·생산공정 선택
- 적용기간 관리
- BOM/라우팅/CT 사전 검증상태

### 16.2 라우팅 관리

필요 변경:

- 코드와 실제 DB의 라우팅 테이블 계약 통일
- 생산공정과 OEE 리소스 배정 관리 또는 OEE 생산규칙 화면과 연계
- 생산일 기준 라우팅 유효성
- `BOM_ONLY`/`BOM_ROUTE` 유효 BOM 검증
- `BOM_ROUTE` 자재 배정 검증
- `ROUTE_ONLY`의 명시적 허용

### 16.3 생산실적 관리

필요 화면:

- OEE 리소스
- 생산품
- 생산방식
- 라우팅·공정
- RUN/작업지시
- 계획·생산·양품·불량수량
- CT snapshot
- 원천·수집상태
- 계산 제외 사유

### 16.4 OEE 대시보드

필요 변경:

- 무생산 리소스를 숫자 0으로 표시하지 않음
- `NOT_SCHEDULED`, `NOT_RECORDED`, `ZERO_PRODUCTION` 구분
- 계산 가능 리소스 수와 제외 사유 건수 표시
- 공정 OEE를 합계 피연산자로 계산
- drilldown에서 품목별 `CT×수량`, 생산방식, BOM/라우팅 근거 표시

## 17. 단계별 전환 계획

### 단계 0. 라우팅 계약 통일

1. `IP_ROUTING_*`와 개발 DB `ROUTING_*` 중 공식 계약을 결정한다.
2. 실제 DB DDL과 코드 entity를 일치시킨다.
3. 라우팅 데이터 등록·조회·수정 경로를 Oracle까지 검증한다.

완료 기준:

- 라우팅 화면·API·DB가 같은 테이블을 사용한다.
- 활성 라우팅과 공정 순서를 실제 DB에서 확인할 수 있다.

### 단계 1. 생산방식과 리소스 생산규칙

1. `BOM_ONLY`/`BOM_ROUTE`/`ROUTE_ONLY` 생산방식을 정의한다.
2. `OEE_RESOURCE_PRODUCTION_RULE` 계약을 추가한다.
3. 품목·모델·고객·라우팅 공정·리소스·적용기간을 관리한다.
4. 유효기간 중복과 타 조직 리소스를 차단한다.

완료 기준:

- 한 생산품의 생산일 기준 생산방식과 허용 OEE 리소스를 결정할 수 있다.
- BOM·라우팅 누락과 정상 `BOM_ONLY`/`ROUTE_ONLY`를 구분할 수 있다.

### 단계 2. 생산실적 원장

1. `OEE_PRODUCTION_RESULT`를 확장한다.
2. 공통 `ProductionResultService`를 구현한다.
3. 수동 생산실적 저장 경로를 우선 연결한다.
4. 생산방식별 필수 BOM·라우팅과 리소스·수량을 검증한다.
5. source idempotency를 적용한다.

완료 기준:

- Oracle 행 → 인증 Backend API → Frontend proxy → 렌더 행이 일치한다.
- OEE_RESOURCE 밖 생산실적은 OEE 원장에 저장되지 않는다.

### 단계 3. 품목 CT snapshot

1. 생산일 기준 유효 CT를 조회한다.
2. 정확히 한 건이고 양수인 CT만 적용한다.
3. `CT_SNAPSHOT_SEC`를 생산실적에 저장한다.
4. CT 누락·중복을 별도 오류로 노출한다.

완료 기준:

- 다품목 생산에서 `Σ(CT×수량)`을 재현한다.
- 표준시간 변경 후에도 과거 OEE가 변하지 않는다.

### 단계 4. SMT·ASSY adapter

1. SMT SPI 투입·AOI 생산실적 adapter를 OEE_RESOURCE 01~12 범위에 연결한다.
2. ASSY 신규 생산관리 저장 경로를 CELL 19~24에 연결한다.
3. 자동·수동 경로 모두 공통 service를 사용한다.

완료 기준:

- 원천 기대 건수와 OEE 생산실적 건수·수량이 일치한다.
- OEE_RESOURCE 밖 원천은 집계되지 않는다.

### 단계 5. OEE 계산 전환

1. 생산상태 기반 View로 변경한다.
2. 품목 CT 가중 성능율을 적용한다.
3. Backend 단순 AVG를 합계 피연산자 계산으로 교체한다.
4. summary snapshot을 확장한다.
5. 화면에 상태와 근거를 노출한다.

완료 기준:

- 생산계획 없는 OEE 리소스는 숫자 OEE에서 제외된다.
- 작업 마감 후 확정된 0생산은 성능 손실로 반영된다.
- Overview와 drilldown 피연산자 합계가 일치한다.

## 18. 테스트 가능한 수락 기준

1. OEE_RESOURCE 밖 LINE/CELL의 RUN·생산실적은 OEE에 포함되지 않는다.
2. 활성 OEE_RESOURCE라도 생산규칙이 없으면 숫자 OEE를 계산하지 않는다.
3. 생산방식이 없으면 BOM·라우팅 유무로 자동 추론하지 않는다.
4. `BOM_ONLY`는 생산일 기준 유효 BOM과 직접 리소스 배정을 요구하고 라우팅은 요구하지 않는다.
5. `BOM_ROUTE`는 생산일 기준 유효 BOM과 활성 라우팅을 모두 요구한다.
6. `ROUTE_ONLY`는 BOM을 요구하지 않지만 활성 라우팅과 리소스 배정을 요구한다.
7. 라우팅 필수 생산방식에서 라우팅이 없으면 `ROUTING_MISSING`으로 표시된다.
8. 실제 생산 리소스와 생산규칙 리소스가 다르면 `RESOURCE_MISMATCH`가 된다.
9. 생산계획이 없으면 `NOT_SCHEDULED`이며 OEE 0으로 표시하지 않는다.
10. 계획은 있으나 실적수집 여부가 불명확하면 `NOT_RECORDED`이며 0으로 대체하지 않는다.
11. 작업 마감 전 생산 0은 `NOT_RECORDED`이고, 마감 후 확정된 생산 0만 `ZERO_PRODUCTION`이다.
12. `RUN_STATUS=5`만으로 작업 마감을 판정하지 않는다.
13. SMT RUN은 `RUN_STATUS IN ('6','7','8')`일 때만 작업 마감으로 인정한다.
14. SPI 투입수량과 AOI 생산수량을 별도 피연산자로 보존한다.
15. SPI/AOI 수량은 조직·RUN·라인·PID 고유 건수이며 재검 행은 중복수량으로 계산하지 않는다.
16. AOI는 최신 검사행의 review 결과를 우선해 최종 판정한다.
17. `MasterOK`/`MasterNG`, NULL/`'NULL'` PID, NULL/`'*'` RUN은 생산실적에서 제외한다.
18. 같은 최신시각의 AOI 판정이 충돌하면 `SOURCE_AMBIGUOUS`로 계산하지 않는다.
19. 생산수량이 있고 양품수량 0이면 Quality 0으로 계산한다.
20. 품목 A CT 10초×100개와 B CT 30초×100개는 `CT_OUTPUT_SEC=4,000초`다.
21. CT 누락 시 리소스 CT·라우팅 표준시간·임의 기본값을 사용하지 않는다.
22. CT 변경 후에도 과거 생산실적 snapshot과 OEE가 변하지 않는다.
23. 공정 OEE는 리소스 OEE 단순 평균이 아니라 합계 시간·수량으로 재계산한다.
24. 같은 자동 source event를 재수집해도 생산수량이 중복되지 않는다.

## 19. 추가 확정이 필요한 기준

1. `ROUTE_ONLY`가 무자재 생산인지, 자재는 있으나 BOM 원장을 사용하지 않는 생산인지
2. 한 품목·모델·고객이 여러 OEE LINE/CELL에서 생산 가능한지
3. ASSY 신규 생산관리의 작업지시·완료·양품·불량 저장 기준
4. 2026-08-19 이전 CT와 OEE 산출 여부
5. CELL별 OEE를 공정 전체에만 합산할지 별도 생산라인 roll-up도 필요한지

## 20. 권장 결정안

| 항목 | 권장안 |
|---|---|
| OEE 범위 | 활성 `OEE_RESOURCE`만 |
| 비대상 생산 | `OUT_OF_SCOPE`, 완전 제외 |
| 생산방식 | `BOM_ONLY`/`BOM_ROUTE`/`ROUTE_ONLY` 명시 |
| 생산방식 추론 | BOM·라우팅 부재로 자동 추론 금지 |
| 생산 리소스 연결 | 품목·모델·고객·라우팅 조건의 다건 생산규칙 → `RESOURCE_ID` |
| BOM 기준 | 생산일 기준 유효 BOM |
| 라우팅 기준 | 활성 INTERNAL + 작업지시 대상 공정 |
| CT | 생산품 `IP_PRODUCT_ST_MASTER.CT_VALUE` snapshot |
| 무계획 | `NOT_SCHEDULED`, 숫자 OEE 제외 |
| 계획된 생산 0 | 작업 마감 후 `ZERO_PRODUCTION`, 성능 손실 반영 |
| SMT 투입/실적 | SPI 투입, AOI 생산실적 |
| SMT 수량 grain | 조직·RUN·라인·PID 고유 건 |
| AOI 최종 판정 | 최신 검사행의 `REVIEW_RESULT` 우선 |
| SMT 마감 | `RUN_STATUS IN ('6','7','8')` |
| 특수 검사 | Master 및 placeholder 제외 |
| 리소스 OEE | LINE/CELL 각각 계산 |
| 공정 OEE | 합계 피연산자로 재계산 |
| 과거 재현 | 생산방식·라우팅·리소스·CT snapshot |

## 21. 관련 소스

- `oracle_db_scripts/oee/01_tables.sql`
- `oracle_db_scripts/oee/03_tables_ext.sql`
- `oracle_db_scripts/oee/04_view_plan_time.sql`
- `oracle_db_scripts/oee/05_view_live.sql`
- `oracle_db_scripts/oee/06_proc_build_summary.sql`
- `apps/backend/src/modules/oee/oee-dashboard.service.ts`
- `apps/backend/src/modules/oee/oee-master.service.ts`
- `apps/backend/src/modules/oee/oee-mobile.service.ts`
- `apps/backend/src/modules/master/services/bom.service.ts`
- `apps/backend/src/modules/master/services/routing-group.service.ts`
- `apps/backend/src/modules/master/dto/routing-group.dto.ts`
- `apps/backend/src/entities/bom-master.entity.ts`
- `apps/backend/src/entities/routing-group.entity.ts`
- `apps/backend/src/entities/routing-process.entity.ts`
- `apps/backend/src/entities/routing-material.entity.ts`
- `apps/backend/src/entities/product-st-master.entity.ts`
- `apps/frontend/src/app/(authenticated)/master/routing/`
- `apps/frontend/src/app/(authenticated)/oee/dashboard/`
- `apps/frontend/src/app/(authenticated)/oee/master/resource/page.tsx`
- `apps/frontend/src/app/(authenticated)/oee/master/standard-time/page.tsx`
- `packages/shared/src/oee/oee-calc.ts`
