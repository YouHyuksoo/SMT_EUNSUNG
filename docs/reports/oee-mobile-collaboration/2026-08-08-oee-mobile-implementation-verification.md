# OEE MOBILE 구현·개발 DB 검증 결과

- 작성일: 2026-08-08
- 대상 branch/worktree: 현재 작업 트리
- 개발 DB: `EUNSUNG_DEV_ESDBPDB`, schema `INFINITY21_JSMES`
- 상태: 코드·DDL·직접 Oracle 검증 완료, 인증 HTTP·브라우저 렌더 검증 미완료

## 구현 완료 범위

- 실제 `PLANTS` 스키마의 `COMPANY`, `PLANT_CD` tenant 계약 복구
- Plant 관리 API의 `JwtAuthGuard`, 복합키 CRUD, tenant 범위 적용
- 회사정보 화면의 생산2팀 CELL 관리 UI
  - CELL 명칭, 사용 여부, 표시 순서만 수정
  - 식별키 수정 및 CELL 추가·삭제 제외
- `EUNSUNG / 2F / PROD2` 계층과 조립 CELL 50~64 적재
- 인증 OEE MOBILE API
  - 작업자 확인
  - SMT LINE·ASSY CELL 리소스
  - 비가동 사유
  - 현재 상태·업무일 이력
  - idempotent 비가동 시작·종료
- 서버 `Asia/Seoul` 기준 08:30 업무일과 A~J 근무구간 계산
- canonical `/oee/entry`를 MOBILE 비가동 시작·종료 UI로 교체
- 구형 DAY/NIGHT·날짜·netLoad·interval replace·legacy profile 제거

## 개발 DB 적용 결과

### PLANTS

- 계층 포함 총 18건
- `PLANT_TYPE='CELL'` 15건
- CELL_CODE `50`~`64`
- `IP_PRODUCT_LINE` 원천 코드·명칭과 `MINUS` 차이 0건
- `GP-12`, `REPAIR`, 공정 그룹 CELL 0건
- seed SQL을 두 번 실행해도 총 18건·CELL 15건 유지

### OEE_DOWNTIME_EVENT

- 컬럼 19개, `EVENT_ID` identity 확인
- enabled constraints 20개
- valid indexes 4개
- `UX_OEE_DTE_OPEN`: 함수기반 unique, 리소스별 열린 이벤트 1건
- `UQ_OEE_DTE_START_REQ`: 조직별 시작 request ID unique
- `UX_OEE_DTE_END_REQ`: `END_REQUEST_ID IS NOT NULL`만 포함하는 함수기반 unique
- 잘못된 일반 unique `UQ_OEE_DTE_END_REQ` 0건
- 검증 데이터 정리 후 이벤트 0건
- DDL 최종 재실행 9블록 전부 성공

## Oracle DML 무결성 검증

검증용 `ORGANIZATION_ID=999999`, `VERIFY_*` 데이터로 다음을 확인하고 2건을 모두 삭제했다.

1. 같은 조직의 서로 다른 두 LINE은 `END_REQUEST_ID=NULL` 상태로 동시에 시작 가능
2. 같은 리소스의 두 번째 열린 이벤트는 `ORA-00001 ... UX_OEE_DTE_OPEN`으로 차단
3. 같은 시작 request ID는 `ORA-00001 ... UQ_OEE_DTE_START_REQ`으로 차단
4. 같은 종료 request ID는 `ORA-00001 ... UX_OEE_DTE_END_REQ`으로 차단

## 검증 명령

- backend focused Jest: 12 suites, 71 tests passed
- backend typecheck: passed
- frontend structure tests: 32 tests passed
- frontend typecheck: passed
- `git diff --check`: passed
- Oracle CELL source query: SMT 12건, ASSY CELL 15건
- Oracle DDL dictionary·DML 검증: passed

## 발견·교정한 결함

### 1. execute-file 첫 블록 인식

- 직접 원인: 첫 익명 PL/SQL 블록 앞의 주석 때문에 connector가 PL/SQL로 인식하지 못하고 마지막 `END;`의 세미콜론을 제거함
- 실제 오류: `ORA-06550`, `PLS-00103: end-of-file`
- 교정: SQL 파일 첫 토큰을 `DECLARE`로 변경
- 회귀 방지: `oee-mobile-ddl.spec.ts`가 첫 토큰을 검사하고 실제 재실행으로 확인

### 2. nullable 종료 request ID unique

- 직접 원인: `(ORGANIZATION_ID, END_REQUEST_ID)` 일반 unique가 null 종료 ID를 부분 unique처럼 동작할 것으로 잘못 가정함
- 실제 오류: 서로 다른 열린 리소스 두 번째 INSERT에서 `ORA-00001 ... UQ_OEE_DTE_END_REQ`
- 교정: 일반 unique를 제거하고 `END_REQUEST_ID IS NOT NULL` 함수기반 unique index로 교체
- 회귀 방지: DDL 정적 테스트와 null 2건 허용/non-null 중복 차단 실제 DML 검증

## 미완료 검증

### 인증 HTTP API

- backend port 3003은 실행 중이지 않았으며 저장소 규칙에 따라 임의로 서버를 기동하지 않았다.
- `DatabaseModule + OeeModule` 조회 전용 컨텍스트 검증도 로컬 backend 환경이 `127.0.0.1:1521`을 사용해 실패했다.
- Oracle Client는 64비트 라이브러리를 찾지 못해 `DPI-1047`을 반환했고, thin fallback은 `NJS-503 / ECONNREFUSED 127.0.0.1:1521`을 반환했다.
- 별도 `oracle-db` connector를 통한 실제 개발 DB DDL·SELECT·DML은 성공했다.

### 브라우저 렌더

- frontend port 3100은 실행 중이지 않아 `/master/company` CELL 관리와 `/oee/entry`의 1280×800 실제 렌더를 확인하지 못했다.
- 서버가 사용자가 직접 기동한 다음 인증 API → 프론트 응답 → rendered row/action 순서로 확인해야 한다.

## 다음 검증 순서

1. 사용자가 backend 3003과 frontend 3100을 정상 환경 변수·64비트 Oracle Client로 기동한다.
2. 인증 상태에서 `/api/v1/oee/mobile/resources?processCode=SMT` 12건과 `ASSY` 15건을 확인한다.
3. 작업자 `00`, 사유 목록, 상태 API를 확인한다.
4. 검증용 리소스 하나에서 시작 → 동일 request replay → 종료 → 동일 end replay를 확인한다.
5. `/master/company` CELL 수정과 `/oee/entry` 1280×800 렌더·터치 동작을 확인한다.
6. 검증 이벤트는 종료 상태와 감사 컬럼을 확인한 후 합의된 방식으로 정리한다.
