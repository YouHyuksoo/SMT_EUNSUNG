# CLAUDE.md

This file defines how coding agents should work in this repository.

The document has two layers:

1. **Agent operating rules**: general behavior rules that prevent common LLM coding mistakes.
2. **Project rules**: 은성전장 MES Display-specific facts, workflows, and constraints.

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

은성전장 MES Display는 은성전장 현장 모니터링용 Next.js 애플리케이션입니다.

- **Site**: 은성전장 (EUNSUNG)
- **DB**: Oracle, `config/database.json`의 `activeProfile` 기준 접속
- **UI**: 3D 메뉴 + `/display/[screenId]` 모니터링 화면
- **Languages**: 한국어/영어/스페인어/베트남어
- **Main displays**: SMD 생산현황, 종합 F/P 현황, 제품/라인 생산현황, SPI/AOI/FCT/VISION 분석

Do not treat this repository as another customer/site project.

## Tech Stack

- Next.js 16 App Router
- React 19
- TypeScript
- Tailwind CSS 4
- Oracle `oracledb`
- SWR
- Recharts / ECharts
- Three.js / GSAP for the menu

## Commands

```bash
npm run dev
npm run build
npm run start
npm run lint
npx tsc --noEmit --pretty false
```

Use targeted checks first. For most frontend/API changes, start with:

```bash
npx tsc --noEmit --pretty false
```

## Repository Shape

```text
config/
  cards.json              # menu categories/cards
  database.json           # local DB profiles, ignored by git
docs/
  plans/
  superpowers/
src/
  app/
    (menu)/               # main 3D menu
    (display)/            # display route shell
    api/                  # API Route Handlers
    ai-chat/
    settings/
  components/
    menu/
    display/
    common/
    ui/
  hooks/
  i18n/
  lib/
    db.ts                 # Oracle pool and query helpers
    display-helpers.ts
    screens.ts            # display screen registry
    queries/              # SQL builders by screen/domain
    menu/                 # 3D menu runtime
  styles/
  types/
public/
scripts/
```

## Oracle And Data Rules

Use `src/lib/db.ts`.

| Helper | Use |
|---|---|
| `executeQuery<T>(sql, binds)` | SELECT queries |
| `executeDml(sql, binds)` | INSERT/UPDATE/DELETE with autoCommit |
| `executeQueryByProfile<T>(profileName, sql, binds)` | non-active DB profile |
| `resetPool()` | after DB profile changes |

Rules:

- `config/database.json` contains credentials and must stay untracked.
- Do not change DB schema unless explicitly asked.
- Check live columns before depending on them.
- If a live schema column does not exist, fix the query/UI dependency instead of inventing the field.
- Preserve exact Oracle/driver errors such as `ORA-*` and `NJS-*`.
- If `/api/display/<id>` returns only `Database query failed`, reproduce the SQL through the same helper path or a direct read-only query to expose the real error.
- For large tables, identify usable indexed columns before broad aggregation.
- For monitoring screens, match the business date definition first; optimize query shape after that.

## Display Screen Workflow

`src/lib/screens.ts` is the display screen registry.

When adding or changing a display screen:

1. Register the screen in `SCREENS`.
2. Add/update the API route under `src/app/api/display/<screenId>/route.ts`.
3. Put SQL builders in `src/lib/queries/`.
4. Add screen components under `src/components/display/screens/`.
5. Add/place the menu card in `config/cards.json`.
6. Register SQL viewer entries in `src/lib/queries/sql-registry.ts` when useful.

Current main screens:

- `21`: 제품생산현황
- `24`: SMD 생산현황
- `25`: 종합 F/P 현황
- `26`: 라인별 생산현황
- `27`: SMD 듀얼 생산현황
- `31`: 솔더 페이스트 관리
- `40`: SPI 차트분석
- `41`: AOI 차트분석
- `42`: FCT 기능검사분석
- `43`: VISION 차트분석

## Menu Card Rules

Menu cards come from `config/cards.json` through `/api/settings/cards`.

- `layer: -1` means the card is unassigned and will not appear in the normal category view.
- To show a card in `MONITORING`, set its `layer` to the monitoring category ID.
- The browser caches cards in localStorage key `mes-display-cards-cache`.
- If a card change does not appear, verify `/api/settings/cards`, clear `mes-display-cards-cache`, then reload.

## FCT Screen Rules

`/display/42` uses `IQ_MACHINE_INSPECT_DATA_FCT`.

- Result column: `INSPECT_RESULT`
- FCT has no `ACTUAL_DATE`.
- The business day is `07:30 ~ next day 07:30`, not calendar midnight.
- Workday start:

```sql
TRUNC(SYSDATE - (7.5 / 24)) + (7.5 / 24)
```

- Product model can be looked up with `IP_PRODUCT_2D_BARCODE.SERIAL_NO = PID`.
- If a direct join is too heavy, keep the business definition and change query shape, not the business rule.

## Frontend Rules

- Display pages must fill the existing `DisplayLayout`.
- Use dense operational dashboards, not landing-page layouts.
- Use existing chart/card patterns before creating a new visual language.
- Keep text inside chart panels short enough for display screens.
- For line-filtered screens, preserve localStorage/event behavior used by existing display screens.
- After significant frontend changes, verify the page visually when practical.

## AI Chat

AI chat exists in this repository.

- Route: `/ai-chat`
- Settings: `/settings/ai-models`, `/settings/ai-personas`
- Use the main Oracle pool unless the user explicitly asks for another DB profile.
- SQL generated or executed for AI features must remain SELECT-only unless explicitly approved.

## Encoding

- Store source files as UTF-8.
- Prefer `apply_patch`, `rg`, and Node scripts for edits.
- Do not use PowerShell `Set-Content` without explicit UTF-8 encoding for Korean text.
- For JSON read by Node/Python, prefer UTF-8 without BOM.
