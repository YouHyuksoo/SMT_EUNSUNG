# OEE MOBILE 선행계약 설계

**작성일:** 2026-08-06
**상태:** Coach 승인 / 구현 입력
**화면설계:** `eunsung-oee-mobile-approved-scope-design.md` (세션 임시 파일)

## 1. 목적

10인치 Android MOBILE의 OEE 비가동 입력을 구현하기 전에 필요한 인증, 물리 리소스, 작업자, 사유, 근무구간, 이벤트 저장, 중복방지 및 Oracle 스키마 계약을 확정한다.

## 2. 확정 범위

- canonical route는 `/oee/entry`다.
- 1층 SMT OEE 리소스는 LINE이다.
- 2층 조립 OEE 리소스는 `PLANTS` CELL이다.
- 조립 CELL 목록이 없으면 `NO_ASSEMBLY_CELL_MASTER`로 차단하고 라인으로 우회하지 않는다.
- CELL은 실제 목록을 임의 생성하지 않고 기존 공장/라인/CELL 관리기능을 실제 DB 계약에 맞게 복구한 뒤 관리자가 입력한다.
- 생산수량 입력과 오프라인 큐는 이번 선행계약 범위에서 제외한다.

## 3. Oracle 실측 기준

| 기준 | 확정 원천 | 실측 결과 |
|---|---|---|
| 조직 | `ISYS_ORGANIZATION` | `ORGANIZATION_ID=1`, `COMPANY_CODE=EUNSUNG` 1건 |
| 인증 사용자·작업자 | `ISYS_USERS` | 조직 1에 48건. `WORKER_MASTERS`, `ICOM_WORKER`는 0건 |
| SMT 라인 | `IP_PRODUCT_LINE` | `LINE_CODE=01~12`, A~L 라인 |
| 조립 CELL | `PLANTS` | CELL 컬럼은 있으나 전체 0건. 관리 입력 선행 |
| 비가동 사유 | `ISYS_BASECODE` | `CODE_TYPE='MACHINE STATUS CODE'`에 기존 운영 코드 존재 |
| 근무구간 | `ICOM_WORKTIME_RANGES` | `SMTWORKTIME`, `WORKTIME` A~J 구간, 08:30~익일 08:30 |
| OEE 스키마 | `OEE_*` | 테이블 없음. 기존 OEE 뷰·프로시저는 `ORA-00942` INVALID |

## 4. 인증·테넌트 계약

- `OeeController`는 클래스 수준 `@UseGuards(JwtAuthGuard)`를 사용하고 `@Public()`을 제거한다.
- 모든 OEE 조회·저장은 `@OrganizationId()`를 서비스에 전달한다.
- 요청 body/query의 `organizationId`는 제거하거나 무시한다.
- CELL 조회·관리는 `@Company()`와 `@Plant()`를 사용한다.
- 현재 Guard 기준 개발 DB의 company는 `EUNSUNG`, plant fallback은 `1`이다.
- Guard 메타데이터 테스트에서 `JwtAuthGuard` 존재와 `@Public()` 부재를 검증한다.

## 5. 작업자 계약

- 작업자 스캔값은 우선 `ISYS_USERS.USER_ID`다.
- 작업자 확인은 `(ORGANIZATION_ID, USER_ID)` 범위에서 수행하고 `USER_NAME`을 반환한다.
- 로그인 사용자와 스캔 작업자는 다를 수 있다. 로그인 사용자는 API 실행자, 스캔 작업자는 현장 기록 귀속자다.
- 존재하지 않거나 다른 조직의 USER_ID는 404로 처리한다.

## 6. 리소스 계약

### 6.1 SMT

- `IP_PRODUCT_LINE`의 조직 1, `LINE_CODE` 01~12를 OEE LINE 후보로 사용한다.
- 설비 스캔값은 `IMCN_MACHINE.MACHINE_CODE`를 `LINE_CODE`로 해석하는 alias일 뿐 개별 설비 OEE로 귀속하지 않는다.
- 스캔 결과가 없거나 둘 이상이면 자동 선택하지 않는다.

### 6.2 조립

- `PLANTS.PLANT_TYPE='CELL'` 행 자체가 OEE 리소스다.
- 실제 DB 컬럼 `COMPANY`, `PLANT_CD`로 테넌트를 제한한다.
- 응답은 `CELL_CODE`, `PLANT_NAME`(CELL 명칭), `LINE_CODE`를 제공한다.
- `Plant` entity의 존재하지 않는 `ORGANIZATION_ID`를 제거하고 실제 필수 컬럼 `COMPANY`, `PLANT_CD`를 매핑한다.
- 공장/라인/CELL controller는 `JwtAuthGuard`, `@Company()`, `@Plant()`를 사용하고 전체 조회·상세·타입별 조회도 테넌트 범위를 강제한다.

## 7. 비가동 사유 계약

- MOBILE 시작 사유는 `ISYS_BASECODE`의 정규화된 `MACHINE STATUS CODE`를 조회한다.
- 정상 코드 `N`과 wildcard `*`는 제외한다.
- `CODE_NAME`을 저장 코드, `CODE_MEAN_KOR`을 표시명으로 사용한다.
- 기존 Mock `DWN-*` 및 미승인 OEE 사유 seed는 사용하지 않는다.
- OEE factor/loss bucket 분류는 대시보드 분석 계약으로 분리하며 현장 이벤트 저장을 막지 않는다.

## 8. 업무일·근무구간 계약

- 서버 KST가 권위 시각이다.
- 업무일 경계는 실제 근무구간의 시작인 08:30이다. `workDate = local date` if time >= 08:30, otherwise previous local date.
- LINE은 `RANGE_TYPE='SMTWORKTIME'`, CELL은 `RANGE_TYPE='WORKTIME'`을 사용한다.
- `WORK_TYPE` A~J를 `workSegment`로 저장한다.
- `ATTRIBUTE01/ATTRIBUTE02`의 날짜 offset과 `START_TIME/END_TIME`을 사용해 현재 구간을 계산한다.
- 클라이언트는 DAY/NIGHT, `netLoadMinutes=480`, 시작·종료시각을 전송하지 않는다.
- 경계값과 자정 교차를 순수 함수 단위테스트로 검증한다.

## 9. 비가동 이벤트 저장 계약

신규 `OEE_DOWNTIME_EVENT`를 사용한다. 기존 근무조 전체 DELETE+INSERT API는 MOBILE 상태 전이에 재사용하지 않는다.

필수 컬럼:

| 컬럼 | 의미 |
|---|---|
| `EVENT_ID` | identity PK |
| `ORGANIZATION_ID` | 인증 조직 |
| `RESOURCE_TYPE` | `LINE` 또는 `CELL` |
| `RESOURCE_CODE` | LINE_CODE 또는 CELL_CODE |
| `PARENT_LINE_CODE` | CELL의 상위 라인, LINE은 자체 코드 |
| `PROCESS_CODE` | `SMT` 또는 `ASSY` |
| `WORK_DATE` | 서버가 계산한 업무일 |
| `WORK_SEGMENT` | A~J |
| `START_TIME`, `END_TIME` | 서버 시각, END nullable |
| `REASON_CODE`, `MEMO` | 승인 사유와 선택 메모 |
| `WORKER_ID` | 스캔한 `ISYS_USERS.USER_ID` |
| `START_REQUEST_ID`, `END_REQUEST_ID` | idempotency key |
| `STARTED_BY`, `ENDED_BY` | 인증 실행자 USER_ID |
| `CREATED_DATE`, `UPDATED_DATE` | 감사 시각 |

무결성:

- 조직별 `START_REQUEST_ID` unique.
- 조직별 null이 아닌 `END_REQUEST_ID` unique.
- 리소스별 열린 이벤트(`END_TIME IS NULL`)는 최대 1건.
- 시작은 작업자·리소스·사유·현재 근무구간을 모두 검증한다.
- 종료는 같은 조직의 열린 이벤트만 허용한다.
- 같은 request ID 재시도는 기존 결과를 반환한다.
- 다른 request ID로 이미 시작/종료된 상태는 409를 반환한다.

## 10. API 계약

| Method | Route | 목적 |
|---|---|---|
| GET | `/oee/mobile/workers/:workerId` | 조직 범위 작업자 확인 |
| GET | `/oee/mobile/resources?processCode=SMT|ASSY&parentLineCode=` | LINE/CELL 목록 |
| GET | `/oee/mobile/resources/resolve?processCode=&scanCode=` | 설비 alias 또는 CELL 스캔 해석 |
| GET | `/oee/mobile/reasons` | 승인 비가동 사유 |
| GET | `/oee/mobile/status?resourceType=&resourceCode=` | 서버 현재상태와 현재 업무일 이력 |
| POST | `/oee/mobile/downtime/start` | idempotent 비가동 시작 |
| POST | `/oee/mobile/downtime/end` | idempotent 비가동 종료 |

## 11. 데이터베이스 배포

- 기존 `oracle_db_scripts/oee/01_tables.sql`, `03_tables_ext.sql`, `04~06`은 개발 DB 실측 후 순서대로 배포해 누락 테이블과 INVALID 객체를 복구한다.
- `03_tables_ext.sql`의 임시 DAY/NIGHT 근무시간 seed는 제거하고 실제 `ICOM_WORKTIME_RANGES` A~J 계약을 사용한다.
- MOBILE 이벤트용 idempotent DDL은 별도 `07_mobile_prerequisites.sql`에 둔다.
- 배포 전후 `user_tables`, `user_objects`, `user_errors`, seed 건수와 샘플을 기록한다.
- 실제 CELL 목록은 관리기능에서 입력하며 migration에서 가짜 CELL을 생성하지 않는다.

## 12. TDD 완료 기준

1. OEE controller Guard 메타데이터 테스트가 먼저 실패하고 통과한다.
2. controller가 body 조직값 대신 Guard 조직·사용자를 service로 전달하는 테스트가 통과한다.
3. Plant entity 실제 컬럼 매핑과 tenant-scoped service 테스트가 통과한다.
4. A~J 업무일·구간 경계 순수함수 테스트가 통과한다.
5. 작업자·LINE·CELL·사유 조회가 조직/company/plant 범위를 벗어나지 않는 service 테스트가 통과한다.
6. 시작·종료 성공, 같은 request ID 재시도, 중복 시작, 중복 종료, 다른 조직 접근 테스트가 통과한다.
7. CELL 0건 시 빈 목록을 반환하고 프론트가 `NO_ASSEMBLY_CELL_MASTER`로 구분할 수 있다.
8. backend typecheck와 focused Jest가 통과한다.
9. Oracle 배포 후 모든 OEE 객체가 VALID이고 실제 API가 개발 DB 데이터로 검증된다.
