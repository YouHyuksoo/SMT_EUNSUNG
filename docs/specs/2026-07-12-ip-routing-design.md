# IP 라우팅 관리 설계

## 1. 목적

은성전장 MES에 품목별 제조 라우팅을 관리하는 기준정보를 추가한다. HANES의 라우팅 관리 방식을 기준으로 삼되, 은성전장 업무에 필요하지 않은 공정 품질조건과 자주검사 품목은 제외한다.

라우팅은 BOM을 대체하지 않는다. `ID_ENG_BOM`은 상위품목을 구성하는 전체 하위품목의 기준이며, 라우팅은 그 하위품목을 어느 공정에 투입하는지 배정한다. 사용자는 현재 유효한 BOM 하위품목을 확인하고 공정별로 선택만 한다.

## 2. 범위

### 포함

- `IP_` 접두사를 쓰는 신규 라우팅 테이블 3개
- 품목별 복수 라우팅 그룹과 단일 활성 라우팅 제약
- 공정 순서, 내작/외주, 외주 공급처 및 표준시간 설정
- 현재 유효 BOM을 후보로 하는 공정별 투입자재 배정
- 동일 하위품목을 한 라우팅 안의 한 공정에만 배정하는 제약
- 신규 테이블에 맞춘 백엔드 엔티티, DTO, 서비스, 컨트롤러
- 기존 라우팅 화면에서 불필요한 품질조건·자주검사 UI 제거 및 BOM 기반 자재 배정 유지
- Oracle 라이브 스키마 적용과 구조·서비스·화면 검증

### 제외

- `IP_PROCESS_QUALITY_CONDITIONS`
- `IP_SELF_INSPECT_ITEMS`
- SG/FG 라벨 발행 플래그와 라우팅 자재 회로 연결
- 레거시 `IP_PRODUCT_ROUTING_MASTER`, `IP_PRODUCT_ROUTING` 정리 또는 데이터 이관
- ECO 연계
- 미래 BOM 버전에 대한 라우팅 선등록
- 초기 라우팅 또는 자재 배정 데이터 시드

## 3. 설계 원칙

1. 신규 구조는 레거시 테이블을 변경하지 않고 병행 도입한다.
2. 품목과 공정의 명칭은 각 마스터에서 조회하며 라우팅 테이블에 권위 있는 복사본으로 저장하지 않는다.
3. 현재 BOM은 `DATESET <= TRUNC(SYSDATE)`이고 `DATEEND >= TRUNC(SYSDATE)`인 `ID_ENG_BOM` 행으로 판단한다. 라이브 스키마에서 두 컬럼은 `NOT NULL`이다. 동일 상위·하위품목은 `DATESET`을 포함한 PK로 기간별 한 행만 허용하며, 같은 날짜에 유효한 행이 복수이면 잘못된 기간 중첩으로 보고 저장 후보 조회를 실패시킨다.
4. BOM 하위품목은 후보 목록의 원천이고, 라우팅 자재 테이블은 공정 배정 관계만 저장한다.
5. 업무 규칙은 서비스와 DB 제약을 함께 사용해 우회 입력도 방지한다.
6. 삭제 연쇄는 사용하지 않는다. 자식 데이터가 있는 기준정보 삭제는 명시적으로 차단한다.

## 4. 데이터 모델

### 4.1 `IP_ROUTING_GROUPS`

품목에 적용할 라우팅 버전 또는 대안을 관리한다.

주요 컬럼:

| 컬럼 | Oracle 정의 | 의미 |
|---|---|---|
| `ORGANIZATION_ID` | `NUMBER NOT NULL` | 조직 ID |
| `ROUTING_CODE` | `VARCHAR2(50) NOT NULL` | 라우팅 코드 |
| `ITEM_CODE` | `VARCHAR2(20) NOT NULL` | 대상 품목 |
| `ROUTING_NAME` | `VARCHAR2(200) NOT NULL` | 라우팅명 |
| `DESCRIPTION` | `VARCHAR2(500) NULL` | 설명 |
| `USE_YN` | `VARCHAR2(1) DEFAULT 'Y' NOT NULL` | 현재 사용 여부 |
| `CREATED_BY` | `VARCHAR2(50) NULL` | 생성 사용자 |
| `CREATED_AT` | `TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL` | 생성 일시 |
| `UPDATED_BY` | `VARCHAR2(50) NULL` | 수정 사용자 |
| `UPDATED_AT` | `TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL` | 수정 일시 |

제약:

- PK: `ORGANIZATION_ID + ROUTING_CODE`
- FK 컬럼은 대상 PK 순서에 맞춰 `ITEM_CODE + ORGANIZATION_ID` → `ID_ITEM(ITEM_CODE, ORGANIZATION_ID)`로 생성한다.
- `USE_YN`은 `Y/N`만 허용한다.
- 동일 조직·품목에는 `USE_YN='Y'`인 라우팅이 하나만 존재하도록 `CASE WHEN USE_YN='Y' THEN ORGANIZATION_ID END`, `CASE WHEN USE_YN='Y' THEN ITEM_CODE END` 두 표현의 함수 기반 유니크 인덱스를 둔다.
- 한 품목에 비활성 라우팅 그룹은 여러 개 존재할 수 있다.

### 4.2 `IP_ROUTING_PROCESSES`

라우팅 그룹의 공정 순서와 실행 속성을 관리한다.

주요 컬럼:

| 컬럼 | Oracle 정의 | 의미 |
|---|---|---|
| `ORGANIZATION_ID` | `NUMBER NOT NULL` | 조직 ID |
| `ROUTING_CODE` | `VARCHAR2(50) NOT NULL` | 상위 라우팅 코드 |
| `PROCESS_SEQ` | `NUMBER(10) NOT NULL` | 공정 순번 |
| `WORKSTAGE_CODE` | `VARCHAR2(10) NOT NULL` | 공정 코드 |
| `EXECUTION_TYPE` | `VARCHAR2(20) DEFAULT 'INTERNAL' NOT NULL` | `INTERNAL` 또는 `SUBCON` |
| `JOB_ORDER_YN` | `VARCHAR2(1) DEFAULT 'Y' NOT NULL` | 작업지시 생성 여부 |
| `SUBCON_SUPPLIER_CODE` | `VARCHAR2(20) NULL` | 외주 공급처 코드 |
| `STANDARD_TIME` | `NUMBER(10,4) NULL` | 표준 작업시간 |
| `SETUP_TIME` | `NUMBER(10,4) NULL` | 준비시간 |
| `USE_YN` | `VARCHAR2(1) DEFAULT 'Y' NOT NULL` | 사용 여부 |
| `CREATED_BY`, `UPDATED_BY` | `VARCHAR2(50) NULL` | 생성·수정 사용자 |
| `CREATED_AT`, `UPDATED_AT` | `TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL` | 생성·수정 일시 |

제약:

- PK: `ORGANIZATION_ID + ROUTING_CODE + PROCESS_SEQ`
- FK: 라우팅 그룹 → `IP_ROUTING_GROUPS`
- FK: `WORKSTAGE_CODE + ORGANIZATION_ID` → `IP_PRODUCT_WORKSTAGE(WORKSTAGE_CODE, ORGANIZATION_ID)`
- FK: `SUBCON_SUPPLIER_CODE + ORGANIZATION_ID` → `ICOM_SUPPLIER(SUPPLIER_CODE, ORGANIZATION_ID)`
- `EXECUTION_TYPE='SUBCON'`이면 공급처가 필수이고, `INTERNAL`이면 공급처를 저장하지 않는다.
- `PROCESS_SEQ > 0`, `STANDARD_TIME >= 0`, `SETUP_TIME >= 0`, 모든 Y/N 컬럼과 열거형 값은 check constraint로 제한한다.
- 공정명은 `IP_PRODUCT_WORKSTAGE`에서 조회한다.
- 품질조건과 자주검사 관련 컬럼은 두지 않는다.

### 4.3 `IP_ROUTING_MATERIALS`

BOM 하위품목을 특정 라우팅 공정에 배정한다.

주요 컬럼:

| 컬럼 | Oracle 정의 | 의미 |
|---|---|---|
| `ORGANIZATION_ID` | `NUMBER NOT NULL` | 조직 ID |
| `ROUTING_CODE` | `VARCHAR2(50) NOT NULL` | 라우팅 코드 |
| `PROCESS_SEQ` | `NUMBER(10) NOT NULL` | 투입 공정 순번 |
| `CHILD_ITEM_CODE` | `VARCHAR2(20) NOT NULL` | BOM 하위품목 |
| `ALLOC_QTY` | `NUMBER(18,6) NOT NULL` | 공정 투입 기준수량 |
| `ISSUE_METHOD` | `VARCHAR2(20) DEFAULT 'BACKFLUSH' NOT NULL` | `BACKFLUSH` 또는 `PRE_ISSUE` |
| `CREATED_BY`, `UPDATED_BY` | `VARCHAR2(50) NULL` | 생성·수정 사용자 |
| `CREATED_AT`, `UPDATED_AT` | `TIMESTAMP(6) DEFAULT SYSTIMESTAMP NOT NULL` | 생성·수정 일시 |

제약:

- PK: `ORGANIZATION_ID + ROUTING_CODE + PROCESS_SEQ + CHILD_ITEM_CODE`
- FK: 공정 → `IP_ROUTING_PROCESSES`
- 공정 FK는 `DEFERRABLE INITIALLY IMMEDIATE`로 생성하며, 공정 순번 변경 트랜잭션에서만 `DEFERRED`로 전환한다.
- FK: `CHILD_ITEM_CODE + ORGANIZATION_ID` → `ID_ITEM(ITEM_CODE, ORGANIZATION_ID)`
- 유니크: `ORGANIZATION_ID + ROUTING_CODE + CHILD_ITEM_CODE`. 같은 라우팅의 동일 하위품목은 여러 공정에 중복 배정할 수 없다.
- `ALLOC_QTY > 0`이고 `ISSUE_METHOD`는 `BACKFLUSH/PRE_ISSUE`만 허용한다.
- 저장 시 서비스가 대상 라우팅의 상위품목과 현재 유효 BOM을 대조한다. DB FK만으로는 BOM 적용기간 규칙을 표현하지 않는다.

## 5. 업무 흐름

### 5.1 라우팅 그룹

1. 사용자가 `ID_ITEM`에서 대상 품목을 선택한다.
2. 라우팅 그룹을 생성한다.
3. 새 그룹을 활성화할 때 동일 품목의 다른 활성 그룹이 있으면 저장을 거부한다. 시스템이 기존 그룹을 암묵적으로 비활성화하지 않는다.

### 5.2 공정 구성

1. 사용자가 `IP_PRODUCT_WORKSTAGE`에서 공정을 선택하고 순번을 지정한다.
2. 내작/외주를 선택한다.
3. 외주 공정이면 `ICOM_SUPPLIER`에서 공급처를 선택한다.
4. 내작으로 변경하면 기존 외주 공급처 값은 제거한다.

### 5.3 공정별 투입자재

1. 선택한 라우팅 그룹의 상위품목으로 현재 유효한 `ID_ENG_BOM` 하위품목을 조회한다.
2. 모든 BOM 하위품목을 체크 목록으로 보여준다.
3. 사용자는 선택한 공정에 투입할 하위품목만 체크한다.
4. 기본 투입수량은 현재 BOM 행의 `ITEM_UNIT_QTY`를 사용한다. 단위는 BOM의 품목 단위 기준이며 사용자가 양수 범위에서 조정할 수 있다.
5. 이미 다른 공정에 배정된 하위품목은 해당 공정 정보를 표시하고 선택할 수 없게 한다.
6. 저장 시 서버가 BOM 소속, 현재 유효성, 공정 중복을 다시 검증한다.

## 6. BOM 변경 처리

BOM 변경이 라우팅 자재를 자동 삭제하거나 이동시키지는 않는다. 현재 BOM에서 사라진 기존 라우팅 자재는 조회 응답에 `bomMatchYn='N'`과 불일치 사유를 포함해 계속 표시한다. 일반 그룹·공정·자재 저장은 이 행을 자동 삭제하지 않으며, 사용자가 특정 키를 명시적으로 삭제 요청한 경우에만 제거한다.

이 방식은 BOM 갱신이 특정 상위품목의 기존 행을 삭제한 뒤 Excel로 재업로드되는 현재 운영 방식에서도 라우팅 배정이 조용히 유실되는 것을 방지한다.

## 7. 오류 처리와 트랜잭션

- 그룹, 공정, 자재의 복합 저장은 트랜잭션으로 처리한다.
- 활성 라우팅 중복은 서비스 사전검사와 DB 유니크 인덱스로 이중 차단한다.
- 자재 변경 요청은 `upserts`와 `deletes`를 구분한다. 요청에 없는 기존 행은 유지하고 명시된 키만 삭제하며, 전체 검증 후 단일 트랜잭션으로 반영한다.
- 중복 배정 오류에는 이미 배정된 공정 순번을 반환한다.
- 현재 BOM에 없는 품목과 존재하지 않거나 조직이 다른 마스터 참조는 저장을 거부한다. 마스터별 활성 컬럼과 의미가 라이브에서 확인되는 경우에만 비활성 참조도 차단한다.
- 공정과 그룹 DELETE는 자식이 있으면 항상 HTTP 409로 거부한다. 사용자는 자재, 공정, 그룹을 각각 명시적으로 삭제한다.
- `PROCESS_SEQ` 단건 수정은 허용하지 않는다. 순서 변경 API는 전체 공정의 기존·신규 순번 매핑을 받아, deferrable 공정 FK를 지연한 단일 트랜잭션에서 공정과 자재 키를 함께 변경한다. 임시 양수 순번은 현재 값·최종 값과 충돌하지 않고 `NUMBER(10)` 범위 안인지 사전 검증한다.
- 마스터 삭제는 FK로 차단하며 cascade delete를 사용하지 않는다.
- Oracle 오류 원문은 서버 로그에 보존하고, API에는 사용자가 조치할 수 있는 업무 오류를 반환한다.
- 활성 라우팅 동시 생성의 `ORA-00001`과 공정·자재 동시 편집 충돌은 HTTP 409로 변환한다. 그 밖의 BOM/업무 검증 실패는 HTTP 422로 반환한다.
- 첫 버전은 낙관적 잠금을 추가하지 않는다. 동일 행의 서로 다른 정상 수정은 마지막 커밋을 적용하되, DB 유니크·FK 및 트랜잭션 규칙으로 무결성 충돌을 차단한다.

## 8. API 계약

기존 기준 경로 `master/routing-groups`를 유지하고 품질조건 API는 제거한다.

| Method / path | 계약 |
|---|---|
| `GET /master/routing-groups` | 검색·사용여부 조건의 그룹 목록 |
| `GET /master/routing-groups/:code` | 그룹과 공정 상세 |
| `POST /master/routing-groups` | 그룹 생성 |
| `PUT /master/routing-groups/:code` | 그룹명·설명·활성여부 수정. 라우팅 코드는 불변 |
| `DELETE /master/routing-groups/:code` | 자식이 없을 때만 그룹 삭제 |
| `GET /master/routing-groups/:code/processes` | 공정 목록 |
| `POST /master/routing-groups/:code/processes` | 공정 추가 |
| `PUT /master/routing-groups/:code/processes/:seq` | 순번을 제외한 공정 속성 수정 |
| `PUT /master/routing-groups/:code/process-order` | `{ changes: [{ fromSeq, toSeq }] }`로 공정·자재 순번 일괄 변경 |
| `DELETE /master/routing-groups/:code/processes/:seq` | 연결 자재가 없을 때 공정 삭제 |
| `GET /master/routing-groups/:code/processes/:seq/materials` | 현재 BOM 후보와 저장 배정을 합쳐 반환. `childItemCode`, `bomQty`, `allocQty`, `bomMatchYn`, `mismatchReason`, `assignedProcessSeq`, `selectableYn`, `issueMethod` 포함 |
| `PUT /master/routing-groups/:code/processes/:seq/materials` | `{ upserts: [...], deletes: [{ childItemCode }] }`를 단일 트랜잭션 적용 |

모든 변경 요청의 조직 ID는 body/query가 아니라 인증 컨텍스트에서 받는다. 자원 없음은 404, 무결성·동시 충돌은 409, 업무 검증 실패는 422를 사용한다.

자재 `upserts`와 `deletes`의 모든 행은 URL의 `routingCode/processSeq`가 소유한 행으로만 처리한다. 같은 자재가 다른 공정에 배정되어 있으면 그 행을 변경하거나 삭제하지 않고 현재 배정 공정 순번과 함께 HTTP 409를 반환한다.

## 9. 애플리케이션 반영 범위

백엔드는 기존 라우팅 모듈의 계약과 화면 흐름을 최대한 유지하면서 엔티티의 실제 테이블명을 `IP_ROUTING_*`로 전환한다. 서비스에는 다음 규칙을 둔다.

- 요청 조직은 인증 컨텍스트에서만 받는다.
- 활성 라우팅 단일성 검증
- 외주 공급처 필수·내작 공급처 제거
- 오늘 기준 BOM 후보 조회
- BOM 소속 및 공정 간 중복 배정 검증
- BOM 불일치 상태 조회

프론트엔드는 기존 라우팅 관리 화면을 사용한다.

- `QualityConditionEditor`, `SelfInspectConfigEditor`와 관련 탭·요청을 제거한다.
- `RoutingMaterialEditor`는 BOM 전체 후보와 공정 배정 상태를 보여준다.
- 공정명과 공급처명은 마스터에서 조회한 표시값을 사용한다.
- 라우팅 화면의 페이지 파일은 조립과 상태 연결만 맡고, 폼·표·규칙은 기존 분리 구조를 유지한다.

## 10. 적용 전략

1. 라이브 `INFINITY21_JSMES`에서 동일 객체명과 참조 키 구조를 사전 확인한다. 현재 추출 기준 참조 PK 순서는 품목 `ITEM_CODE + ORGANIZATION_ID`, 공정 `WORKSTAGE_CODE + ORGANIZATION_ID`, 공급처 `SUPPLIER_CODE + ORGANIZATION_ID`다. DDL 직전에 다시 확인하고 자료형·순서가 다르거나 대응 PK/UK가 없으면 참조 마스터를 임의 변경하지 않고 적용을 중단한다.
2. 구조 테스트를 먼저 추가해 신규 테이블명과 제외 기능을 고정한다.
3. Oracle DDL을 재실행 안전한 형태로 작성한다. 객체가 이미 있으면 단순 건너뛰지 않고 예상 컬럼·제약·인덱스 정의와 일치하는지 검증하며, 불일치 객체는 자동 drop/alter하지 않고 실패로 보고한다.
4. connector로 신규 테이블·제약·인덱스를 실제 적용한다.
5. DDL 직후 애플리케이션 검증 데이터를 만들기 전에 신규 세 테이블 0건과 레거시 라우팅 테이블 건수를 기록한다.
6. 엔티티, DTO, 서비스, 컨트롤러, 화면을 신규 구조에 맞춘다.
7. 런타임 검증은 식별 가능한 테스트 키로 데이터를 생성해 수행하고, 검증 후 자재 → 공정 → 그룹 순서로 정리한다. 최종 건수와 레거시 건수 불변을 다시 확인한다.
8. 신규 테이블은 운영 시드 없이 시작하고 레거시 `IP_PRODUCT_ROUTING_MASTER`, `IP_PRODUCT_ROUTING`은 그대로 둔다.

## 11. 검증 기준

### 데이터베이스

- `USER_TABLES`에서 신규 3개 테이블 확인
- `USER_TAB_COLUMNS`에서 컬럼·자료형·nullable 확인
- `USER_CONSTRAINTS`, `USER_CONS_COLUMNS`에서 PK/FK/check 확인
- `USER_INDEXES`, `USER_IND_COLUMNS`에서 활성 라우팅 및 자재 중복 유니크 확인
- 필수 키의 NOT NULL, 수량·시간 범위, Y/N 및 열거형 check constraint 확인
- 신규 3개 테이블의 초기 건수 `0` 확인
- 레거시 라우팅 테이블 존재 및 기존 건수 불변 확인

### 백엔드

- 엔티티가 신규 `IP_` 테이블을 참조하는 구조 테스트
- 조직 Guard 메타데이터 테스트
- 활성 라우팅 중복, 외주 공급처, BOM 소속, 공정 중복, 트랜잭션 롤백 단위 테스트
- BOM 불일치 행의 일반 저장 시 보존과 명시 삭제 테스트
- 공정 순번 일괄 변경 시 자재 FK 보존 및 실패 시 전체 롤백 테스트
- 다른 공정 소유 자재의 변경·삭제가 현재 배정 공정을 포함한 409를 반환하는 테스트
- `pnpm --filter @eunsung/backend test`
- `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`

### 프론트엔드

- 품질조건·자주검사 UI와 요청이 제거됐는지 구조 테스트
- 현재 BOM 전체 후보, 다른 공정 배정 표시, 불일치 표시 테스트
- 후보 행에 BOM 일치 상태, 현재 배정 공정, 선택 가능 여부, BOM 기본수량이 표시되는지 확인한다. 다른 공정 배정 행은 disabled, stale 행은 경고와 명시적 삭제 동작을 제공한다.
- `pnpm --filter @eunsung/frontend test`
- `pnpm --filter @eunsung/frontend typecheck`

### 런타임

사용자가 기존 3003/3100 서버를 기동한 상태에서 인증된 백엔드 API, 프론트 프록시, 렌더된 라우팅 화면 순으로 확인한다. 임의 포트나 별도 dev 서버는 사용하지 않는다.

## 12. 완료 조건

- 신규 `IP_ROUTING_GROUPS`, `IP_ROUTING_PROCESSES`, `IP_ROUTING_MATERIALS`가 라이브 Oracle에 존재한다.
- 세 테이블의 제약과 FK가 활성 상태다.
- 동일 품목의 활성 라우팅은 하나만 허용된다.
- 동일 BOM 하위품목은 한 라우팅의 한 공정에만 배정된다.
- 공정별 투입자재 후보는 오늘 기준 BOM에서 조회된다.
- 품질조건과 자주검사 기능은 신규 구조와 화면에 포함되지 않는다.
- 신규 테이블은 시드 없이 시작하고 레거시 테이블과 데이터는 유지된다.
- 백엔드·프론트엔드의 대상 테스트와 typecheck가 통과한다.
- 라이브 Oracle 구조·초기 0건·레거시 건수 불변 검증은 필수다.
- 인증된 백엔드 API → 프론트 프록시 → 렌더된 라우팅 화면 검증도 필수다. 기존 서버가 기동되지 않아 수행할 수 없으면 완료로 처리하지 않고 `docs/reports/`에 미완료 기록을 남긴다.
