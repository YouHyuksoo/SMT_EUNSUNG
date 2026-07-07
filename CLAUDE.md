# CLAUDE.md

This file defines how coding agents should work in this repository.

The document has three layers:

1. **Agent operating rules**: general behavior rules that prevent common LLM coding mistakes.
2. **Monorepo rules**: how to run, verify, and change the `eunsung-mes` pnpm/turborepo workspace.
3. **Project rules**: 은성전장 MES-specific facts, workflows, and constraints (including the legacy Display subsystem).

## Agent Operating Rules

These rules are intentionally kept in this repo. They reduce recurring LLM coding failures: guessing, overbuilding, touching unrelated code, and claiming completion without verification.

### 1. Think Before Coding

Do not assume. Do not hide confusion. Surface tradeoffs.

- State assumptions explicitly when they affect implementation.
- If multiple interpretations exist, present them instead of silently picking one.
- If the user's business/data 기준 conflicts with a technical shortcut, the business/data 기준 wins.
- If something is unclear enough to change the result, ask before editing.
- Push back when the requested direction would create a wrong or misleading result.

### 2. Simplicity First

Minimum code that solves the requested problem. Nothing speculative.

- Do not add features beyond what was asked.
- Do not add abstractions for single-use code.
- Do not add configurability that was not requested.
- Prefer the existing local pattern over a new framework or structure.
- If the change is becoming much larger than the request, stop and explain the tradeoff.

### 3. Surgical Changes

Touch only what is needed. Clean up only your own mess.

- Do not refactor unrelated code.
- Do not reformat files just because you touched them.
- Match the style of nearby code.
- Remove imports, variables, and functions made unused by your own change.
- Mention unrelated stale/dead code separately; do not delete it unless asked.
- Every changed line should trace back to the user request or required verification.

### 4. Goal-Driven Execution

Define success criteria and verify them.

- For bugs, isolate the failing layer before fixing.
- For DB-backed UI, verify the real API route or SQL path.
- For frontend changes, verify the rendered page when practical.
- Use targeted verification first, then broader checks when the change surface warrants it.
- Do not say "done" unless the requested behavior was checked, or clearly state what could not be verified.

## Project Identity

은성전장 MES(`eunsung-mes`)는 은성전장 현장용 풀스택 MES 모노레포입니다.

- **Site**: 은성전장 (EUNSUNG)
- **Shape**: pnpm + turborepo 모노레포 — NestJS 백엔드 + Next.js 프론트엔드 + 공유 패키지.
- **DB**: Oracle. 백엔드는 TypeORM으로 은성 외부 DB에 접속.
- **Languages**: 한국어/영어/스페인어/베트남어
- **Domains**: 생산/품질/재고/자재/설비/OEE/출하/외주/소모품/메뉴·권한/인터페이스/AI 등.
- **Legacy Display**: 프론트엔드 안에 3D 메뉴 + `/display/[screenId]` 모니터링 화면이 여전히 존재하며 별도 규칙을 따른다 (아래 "Legacy Display Subsystem").

Do not treat this repository as another customer/site project.

## Tech Stack

- **Monorepo**: pnpm `10.28.x` + turborepo, Node `>=20`.
- **Backend** (`@eunsung/backend`, `apps/backend`): NestJS 11, TypeORM, Oracle `oracledb`, Swagger, Jest.
- **Frontend** (`@eunsung/frontend`, `apps/frontend`): Next.js 16 App Router (Turbopack), React 19, TypeScript, Tailwind CSS 4, TanStack Query/Table, ag-grid, Recharts/ECharts, Three.js/GSAP (legacy menu), Playwright (e2e).
- **Shared** (`packages/shared` → `@smt/shared`, `packages/config`): 공용 타입/상수/유틸(예: OEE 계산·검증)을 프론트·백엔드가 함께 사용.

## Commands

Package manager is **pnpm**. Do not use `npm` or `yarn`.

```bash
# 개발 서버 (사용자가 직접 기동한다 — 아래 Execution & Verification 참고)
pnpm dev                                   # turbo run dev (frontend+backend)
pnpm dev:frontend                          # @eunsung/frontend  → http://localhost:3100
pnpm dev:backend                           # @eunsung/backend   → http://localhost:3003

# 검증 (focused typecheck 우선)
pnpm --filter @eunsung/frontend exec tsc --noEmit --pretty false
pnpm --filter @eunsung/backend  exec tsc --noEmit --pretty false
pnpm --filter @eunsung/frontend lint
pnpm --filter @eunsung/frontend test       # node --test 구조 테스트
pnpm --filter @eunsung/backend  test       # jest

# 빌드 (요청 시 또는 dev 서버가 없을 때만)
pnpm build                                 # @eunsung/frontend build
```

- Ports: frontend **3100**, backend **3003** (고정, `apps/backend/src/main.ts`). Swagger는 백엔드에서 제공.
- Backend 시간은 `main.ts`에서 KST로 고정된다. 날짜 관련 로직 변경 시 이 전제를 유지한다.

## Repository Shape

```text
apps/
  backend/                  # @eunsung/backend (NestJS)
    src/
      modules/              # ai, auth, dashboard, equipment, inventory, master,
                            # material, menu-categories, oee, production, quality,
                            # shipping, system, user, workflow, ... (도메인별 모듈)
      database/             # data-source.ts, oracle-data-source.ts (TypeORM)
      seeds/                # seed-roles.ts, menu-config.json 등
      common/               # filters, interceptors (logging/transform/sql-debug)
      main.ts               # 포트 3003, KST 고정
    .env                    # Oracle 접속정보, untracked
  frontend/                 # @eunsung/frontend (Next.js App Router)
    config/                 # cards.json, database.json(untracked), menuConfig.ts
    public/help/            # 화면 도움말 (help manifest 기반)
    src/
      app/
        (authenticated)/    # 인증형 MES 업무 화면
        (display)/          # 레거시 모니터링 display shell
        (menu)/             # 레거시 3D 메뉴
        api/                # Next API Route Handlers (display 등)
        login/  pda/
      components/ hooks/ services/ stores/ contexts/ i18n/ locales/
      lib/
        db.ts               # 레거시 display용 Oracle pool/query 헬퍼
        screens.ts          # display 화면 레지스트리
        queries/            # display SQL 빌더
      types/ utils/
packages/
  shared/                   # @smt/shared (types/constants/utils/oee)
  config/
docs/                       # managing-docs 표준 (docs/README.md manifest 준수)
oracle_db_scripts/          # 주석 처리된 PL/SQL 소스 스냅샷
```

## Execution & Verification

- 패키지 매니저는 `pnpm`만 사용한다. `npm`/`yarn` 명령을 만들지 않는다.
- **dev/백엔드 서버는 사용자가 직접 기동한다.** 임의로 서버를 띄우지 않는다.
- 서버나 포트가 예상과 다르면 임의 대체 포트를 띄우지 말고 실패를 그대로 보고한다.
- 이미 dev 서버가 떠 있으면 `pnpm build`를 실행하지 않는다. typecheck가 필요하면 위 filtered `tsc` 명령을 우선한다.
- focused test와 typecheck를 먼저 수행하고, 변경 범위가 넓을 때만 전체 검사로 확장한다.
- `pnpm build`는 사용자가 요청했거나 dev 서버가 없고 전체 빌드 확인이 필요한 경우에만 실행한다.
- 변경이 프론트·백엔드·shared 중 둘 이상에 걸치면 각 워크스페이스에서 개별 검증한다.

## DB Work

Oracle is the system of record for both backend (TypeORM) and the legacy Display frontend.

- 백엔드 DB 접속은 TypeORM(`apps/backend/src/database/data-source.ts`, `oracle-data-source.ts`)과 `apps/backend/.env`를 기준으로 한다. 은성 DB는 구버전 verifier라 **thick client 필수**(`ORACLE_CLIENT_LIB_DIR`).
- `apps/backend/.env`와 `apps/frontend/config/database.json`은 접속정보를 담으므로 untracked로 유지한다.
- **DDL/DML 실행 전 실제 스키마를 확인한다.** 라이브 컬럼이 없으면 필드를 지어내지 말고 쿼리/UI 의존성을 고친다.
- DB 스키마는 명시 요청이 없으면 변경하지 않는다.
- Raw SQL / 스키마 점검 / 운영 데이터 DML은 `oracle-db` connector 또는 검증된 raw SQL 파일 경로를 우선한다. **SQL 파일만 만들고 끝내지 않는다** — 사용자가 보류를 명시하지 않으면 connector로 실제 적용하고 pre/post 결과를 기록한다.
- Oracle/driver 오류(`ORA-*`, `NJS-*`)는 원문 그대로 보존한다. API가 `Database query failed`만 반환하면 같은 헬퍼 경로나 read-only 쿼리로 실제 SQL을 재현해 진짜 오류를 드러낸다.
- 대형 테이블은 사용 가능한 인덱스 컬럼을 먼저 파악한 뒤 광범위 집계를 한다.
- 모니터링/집계는 비즈니스 날짜 정의를 먼저 맞추고 그 다음 쿼리 형태를 최적화한다.

## UI & Code Quality

- `alert()`, `confirm()`, `prompt()` 대신 프로젝트의 모달/토스트 컴포넌트를 사용한다.
- 코드성/기준정보성 값은 자유 입력 대신 공통코드·기준정보 선택 컴포넌트를 우선한다.
- 새 UI/필터/입력을 만들기 전에 `apps/frontend/src/components`(특히 `shared`/`common`)와 기존 훅·스토어에 재사용 가능한 패턴이 있는지 먼저 확인한다.
- 규칙을 프론트·백엔드 양쪽에서 강제해야 하면 `packages/shared`에 한 번 정의하고 양쪽이 호출한다. 같은 조건을 여러 계층에 복붙하지 않는다.
- `catch (error: unknown)` 형태를 유지하고 `as any` 사용을 피한다.
- 도메인 필드를 추가/변경할 때는 엔티티↔DTO↔서비스↔프론트 타입↔폼↔테이블/컬럼↔라벨/도움말↔테스트까지 경로 전체를 의도적으로 갱신한다.

## Legacy Display Subsystem

프론트엔드 안에 은성 모니터링용 3D 메뉴 + `/display/[screenId]` 화면이 유지된다. 이 서브시스템은 백엔드 API가 아니라 Next API Route + `apps/frontend/src/lib/db.ts`로 Oracle에 직접 접속한다.

### Oracle helpers (display)

Use `apps/frontend/src/lib/db.ts`.

| Helper | Use |
|---|---|
| `executeQuery<T>(sql, binds)` | SELECT queries |
| `executeDml(sql, binds)` | INSERT/UPDATE/DELETE with autoCommit |
| `executeQueryByProfile<T>(profileName, sql, binds)` | non-active DB profile |
| `resetPool()` | after DB profile changes |

`apps/frontend/config/database.json`의 `activeProfile` 기준으로 접속하며, 없으면 `.env`를 사용한다.

### Display screen workflow

`apps/frontend/src/lib/screens.ts`가 display 화면 레지스트리다. 화면 추가/변경 시:

1. `SCREENS`에 등록한다.
2. `apps/frontend/src/app/api/display/<screenId>/route.ts` API를 추가/갱신한다.
3. SQL 빌더는 `apps/frontend/src/lib/queries/`에 둔다.
4. 화면 컴포넌트는 display 컴포넌트 경로에 둔다.
5. 메뉴 카드는 `apps/frontend/config/cards.json`에 배치한다.

Current main display screens: `21` 제품생산현황 · `24` SMD 생산현황 · `25` 종합 F/P 현황 · `26` 라인별 생산현황 · `27` SMD 듀얼 생산현황 · `31` 솔더 페이스트 관리 · `40` SPI · `41` AOI · `42` FCT · `43` VISION.

### Menu card rules

Menu cards come from `apps/frontend/config/cards.json` through `/api/settings/cards`.

- `layer: -1` 이면 카드는 미배정 상태로 일반 카테고리 뷰에 안 나온다.
- `MONITORING`에 표시하려면 `layer`를 모니터링 카테고리 ID로 설정한다.
- 브라우저는 카드를 localStorage `mes-display-cards-cache`에 캐시한다. 변경이 안 보이면 `/api/settings/cards` 확인 → 캐시 삭제 → 새로고침.

### FCT screen rules

`/display/42`는 `IQ_MACHINE_INSPECT_DATA_FCT`를 사용한다.

- 결과 컬럼: `INSPECT_RESULT`. FCT에는 `ACTUAL_DATE`가 없다.
- 업무일은 캘린더 자정이 아니라 `07:30 ~ 다음날 07:30`이다. 시작 기준:

```sql
TRUNC(SYSDATE - (7.5 / 24)) + (7.5 / 24)
```

- 제품 모델은 `IP_PRODUCT_2D_BARCODE.SERIAL_NO = PID`로 조회한다.
- 직접 조인이 무거우면 비즈니스 정의는 유지하고 쿼리 형태를 바꾼다.

### Display frontend rules

- Display 페이지는 기존 `DisplayLayout`을 채운다. 랜딩형이 아니라 밀도 높은 운영 대시보드를 쓴다.
- 기존 차트/카드 패턴을 먼저 재사용하고, 패널 안 텍스트는 display 화면에 맞게 짧게 유지한다.
- 라인 필터 화면은 기존 display의 localStorage/이벤트 동작을 보존한다.
- 큰 프론트 변경 뒤에는 가능하면 렌더된 화면을 직접 확인한다.

## AI Features

- AI 관련 기능은 백엔드 `ai`/`ai-knowledge`/`ai-page-tools` 모듈과 프론트 `ai-page-tools`에 존재한다.
- 별도 지시가 없으면 메인 Oracle 접속을 사용한다.
- AI 기능이 생성/실행하는 SQL은 명시 승인 전까지 **SELECT-only**를 유지한다.

## Unfinished Work

- 작업이 중간에 멈추거나 검증/배포/데이터 정리가 끝나지 않았으면 `docs/` 표준(`docs/README.md` manifest)에 따라 `docs/reports/`에 미완료 기록을 남긴다.
- 다음 세션은 관련 미완료 기록을 현재 코드·DB 상태로 재검증한 뒤 이어간다.

## Browser Automation

- 브라우저 자동화는 `claude-in-chrome`을 기본으로 사용한다. 사용자의 기존 크롬 세션에 붙어 로그인 상태를 유지한 채 화면을 조작/캡처한다.
- devtools 전용 기능(lighthouse, heap snapshot, 정밀 트레이스)이 필요할 때만 예외적으로 다른 도구를 쓴다.

## Docs & Coordination

- `docs/` 아래 문서 생성·이동·삭제는 `docs/README.md` manifest 규정을 먼저 읽고 따른다. 관리 작업은 `managing-docs` 스킬을 사용한다.
- 이 저장소에는 상시 `.ai-coordination` 보드가 없다. multi-AI coordination(lock/handoff/task board)은 사용자가 명시적으로 요청할 때만 `ai-coordination` 스킬로 켠다.

## Encoding

- Store source files as UTF-8.
- Prefer `apply_patch`, `rg`, and Node scripts for edits.
- Do not use PowerShell `Set-Content` without explicit UTF-8 encoding for Korean text.
- For JSON read by Node/Python, prefer UTF-8 without BOM.
