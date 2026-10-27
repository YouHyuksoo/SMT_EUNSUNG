# AGENTS.md — 은성전장 MES (eunsung-mes)

공용 작업 규칙은 user-wide `AI-GLOBAL.md`에 있다. 이 파일은 이 저장소 고유의 사실과 규칙만 담는다.

## 프로젝트

- 은성전장 현장용 MES 모노레포(pnpm + turborepo: `apps/backend` NestJS, `apps/frontend` Next.js, `packages/shared` = `@smt/shared`). 다른 고객사/사이트 프로젝트로 취급하지 않는다.
- 프론트 안에 레거시 Display(3D 메뉴 + `/display/[screenId]`)가 남아 있고 규칙이 다르다(아래 "Legacy Display").
- UI 언어: 한국어/영어/스페인어/베트남어.

## 실행·검증

- 패키지 매니저는 `pnpm`만 쓴다. 포트는 프론트 4010, 백엔드 4003(고정, Swagger `/api/docs`). dev 서버는 사용자가 직접 띄운다.
- 백엔드는 `main.ts` 첫 줄에서 `TZ=Asia/Seoul`로 고정한다. 날짜 로직은 이 전제를 유지한다.
- dev 서버가 떠 있으면 `pnpm build`를 돌리지 않는다. 타입만 볼 때는 `pnpm --filter @eunsung/frontend exec tsc --noEmit --pretty false`(backend는 `@eunsung/backend`, registry 생성·검증 없음).
- `apps/frontend/src/app/(authenticated)/**/page.tsx`를 추가·이동·삭제하면 `pnpm --filter @eunsung/frontend typecheck` 또는 `test`를 실행한다. 이 두 명령이 registry를 생성하고 페이지·메뉴·백엔드 메뉴 등록을 전수 검증한다. 생성 파일은 직접 고치지 않는다. `menuConfig.ts`의 주석 예시는 활성 메뉴가 아니다.
- 변경이 프론트·백엔드·shared 중 둘 이상에 걸치면 각 워크스페이스에서 따로 검증한다.
- Oracle 기반 화면은 컴파일·단위 테스트·Swagger·HTTP 200만으로 완료 처리하지 않는다. Oracle 기대 건수 → 인증된 백엔드 API → 프론트 프록시 API → 렌더된 행 순서로 실제 데이터를 확인한다. 절차: `docs/standards/oracle-db-backed-screen-verification.md`.

## 백엔드·Oracle

- 접속은 TypeORM(`apps/backend/src/database/`)과 `apps/backend/.env`. 은성 DB는 구버전 verifier라 thick client 필수(`ORACLE_CLIENT_LIB_DIR`).
- `apps/backend/.env`, `apps/frontend/config/database.json`은 접속정보라 untracked로 둔다.
- DDL/DML 전에 실제 스키마를 확인한다. 라이브 컬럼이 없으면 필드를 지어내지 말고 쿼리/UI 의존성을 고친다. 명시 요청 없이 스키마를 바꾸지 않는다.
- 운영 데이터 DML·스키마 점검은 `oracle-db` connector나 검증된 SQL 파일로 한다. SQL 파일만 만들고 끝내지 않는다. 사용자가 보류를 명시하지 않으면 실제 적용하고 pre/post 결과를 기록한다.
- `oracle-db --execute-file`로 여러 블록을 실행하는 파일은 첫 익명 PL/SQL 블록의 첫 토큰을 `DECLARE`/`BEGIN`으로 둔다(선행 주석이 있으면 connector가 SQL로 오인한다).
- 마이그레이션은 대상 운영 DB에 테이블이 없을 수 있다고 전제한다. 신규 테이블은 `USER_TABLES` 확인 후 `CREATE TABLE`, 기존 테이블은 컬럼 보정까지 한 파일에서 멱등 처리하고 테이블 부재 상태를 잡는 구조 테스트를 둔다. 절차: `docs/standards/oracle-migration-deployment.md`.
- 테이블을 대체·폐기하면 백엔드 전체 SELECT/DML 참조를 새 원장으로 바꾸고, 폐기 테이블이 실행 SQL에 다시 나오면 실패하는 정적 회귀 테스트를 둔다.
- `(tenant_key, nullable_request_id)` 일반 UNIQUE를 부분 unique로 쓰지 않는다. null 요청 ID를 빼는 함수기반 unique index를 쓰고, 같은 tenant의 null 2건 허용·non-null 중복 차단을 DML로 검증한다(`oee-mobile-ddl.spec.ts`가 강제).
- TypeORM Oracle raw query: named bind 객체를 여러 호출에 재사용하지 않는다(드라이버가 첫 bind 객체를 변경한다). 배열 bind는 SQL placeholder 등장 순서로 넘기고, `manager.query()`의 UPDATE 결과는 객체가 아니라 숫자 affected count일 수 있다. 관련 변경에는 실제 드라이버 경계를 재현하는 회귀 테스트를 둔다. 사례: `docs/reports/2026-09-10-oee-multi-entry-batch-verification.md`.
- `@OrganizationId()`를 쓰는 컨트롤러는 `JwtAuthGuard` 적용과 Guard 메타데이터 테스트가 필수다. 서비스는 body/query의 조직 ID를 신뢰하지 않는다.
- `ORA-*`, `NJS-*` 오류는 원문 그대로 보존한다. API가 `Database query failed`만 돌려주면 같은 헬퍼 경로나 read-only 쿼리로 실제 SQL을 재현해 진짜 오류를 드러낸다.
- 대형 테이블은 쓸 수 있는 인덱스 컬럼을 먼저 파악한 뒤 집계한다. 모니터링/집계는 비즈니스 날짜 정의를 먼저 맞추고 쿼리 형태를 최적화한다.

## 프론트 UI·코드 규칙

- `alert()`/`confirm()`/`prompt()` 대신 프로젝트 모달/토스트를 쓴다.
- 코드성 컬럼은 `ISYS_BASECODE` 기준. 컬럼명과 `CODE_TYPE`은 대문자화 후 공백·`_`를 제거한 정규키로 매칭한다. 필터·폼은 `ComCodeSelect`, 그리드는 `ComCodeBadge` 또는 공용 코드명 렌더러를 쓴다. 원시 코드만 표시하지 않는다.
- DB 기반 신규 화면의 엔티티·DTO·API·프론트 타입·폼 상태 이름은 실제 DB 컬럼의 lowerCamelCase(`ITEM_UOM` → `itemUom`). 복사 프로젝트의 별칭·호환 필드(`productType`, `unit`, `useYn` 등)를 새 계약에 유지하지 않는다.
- 프론트·백엔드 양쪽에서 강제할 규칙은 `packages/shared`에 한 번 정의하고 양쪽이 호출한다.
- `catch (error: unknown)`을 유지하고 `as any`를 피한다.

## Legacy Display

- 백엔드 API가 아니라 Next API Route + `apps/frontend/src/lib/db.ts`로 Oracle에 직접 접속한다. 접속은 `apps/frontend/config/database.json`의 `activeProfile`, 없으면 `.env`. DB 프로필을 바꾸면 `resetPool()`.
- 화면 추가/변경: `src/lib/screens.ts`의 `SCREENS` 등록 → `src/app/api/display/<screenId>/route.ts` → SQL 빌더는 `src/lib/queries/` → 메뉴 카드는 `config/cards.json`.
- 메뉴 카드는 `cards.json` → `/api/settings/cards`로 온다. `layer: -1`은 미배정(카테고리 뷰에 안 나옴), MONITORING에 보이려면 `layer`를 모니터링 카테고리 ID로. 브라우저가 localStorage `mes-display-cards-cache`에 캐시하므로 변경이 안 보이면 API 확인 → 캐시 삭제 → 새로고침.
- FCT(`/display/42`): `IQ_MACHINE_INSPECT_DATA_FCT`, 결과 컬럼 `INSPECT_RESULT`, `ACTUAL_DATE` 없음. 업무일은 `07:30 ~ 다음날 07:30`(시작 `TRUNC(SYSDATE - (7.5 / 24)) + (7.5 / 24)`). 제품 모델은 `IP_PRODUCT_2D_BARCODE.SERIAL_NO = PID`. 조인이 무거우면 비즈니스 정의는 유지하고 쿼리 형태만 바꾼다.
- Display 페이지는 기존 `DisplayLayout`을 채우는 밀도 높은 운영 대시보드다(랜딩형 아님). 기존 차트/카드 패턴을 재사용하고 패널 텍스트는 짧게. 라인 필터 화면은 기존 localStorage/이벤트 동작을 보존한다.

## AI 기능

- 백엔드 `ai`, `ai-knowledge` 모듈. 별도 지시가 없으면 메인 Oracle 접속을 쓴다.
- AI 기능이 생성/실행하는 SQL은 명시 승인 전까지 SELECT-only.

## 문서

- `docs/`는 `docs/README.md`(manifest)를 따른다. 프로젝트 전역 규칙은 이 파일, 상세 절차·근거는 `docs/standards/`. 결함 교훈 승격은 `docs/standards/incident-to-standard-process.md`.
- 상시 `.ai-coordination` 보드는 없다.
