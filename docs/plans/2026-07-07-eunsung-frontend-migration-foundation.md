# Eunsung Frontend Migration Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Convert the current single Next.js monitoring app into a working monorepo foundation with the app running from `apps/frontend`, while preserving the existing display route group and API behavior.

**Architecture:** This plan creates the workspace skeleton first, then moves the current Next.js application into `apps/frontend` without introducing HANES business shell code yet. It keeps monitoring as the active app so each step is reversible and testable before the larger HANES shell/system-page migration.

**Tech Stack:** Next.js 16, React 19, TypeScript 5, Tailwind CSS 4, Oracle `oracledb`, pnpm workspace, Turborepo.

---

## Source Spec

- `docs/specs/2026-07-07-eunsung-frontend-migration-design.md`

## Scope

This is plan 1 of the frontend migration.

In scope:
- Add monorepo workspace files.
- Move the existing app files into `apps/frontend`.
- Keep the existing `(display)` route group and `/api/display/*` API routes working.
- Add structure checks that protect the split between display shell and future business shell.
- Update root scripts to call the app through workspace commands.

Out of scope:
- HANES `MainLayout`, `Header`, `Sidebar`, system pages, login, or stores.
- Backend/NestJS scaffolding.
- Oracle schema, 수불, OEE, auth, role, or menu DB work.
- Deploy workflow changes, unless a later deploy-specific plan is approved.

## Current Constraints

- The current app lives at the repo root (`src`, `public`, `config`, `next.config.ts`, `tsconfig.json`, `eslint.config.mjs`, `postcss.config.mjs`, `next-env.d.ts`, `package.json`).
- `docs/README.md` says implementation plans belong in `docs/plans/`, not `docs/superpowers/plans/`.
- Before executing this plan, run `git status --short`. If unrelated dirty files exist, do not overwrite or stage them.
- If `.github/workflows/deploy.yml` is dirty, leave it untouched in this plan.

## File Structure

| Path | Responsibility |
|---|---|
| `package.json` | Root workspace commands only. No app dependencies after migration. |
| `package-lock.json` | Removed after switching this repo to pnpm workspace. |
| `pnpm-workspace.yaml` | Workspace package discovery for `apps/*` and `packages/*`. |
| `turbo.json` | Shared task graph for dev/build/lint/test. |
| `apps/frontend/package.json` | Existing app dependencies and scripts, renamed to `@eunsung/frontend`. |
| `apps/frontend/src/**` | Existing Next.js source moved from root. |
| `apps/frontend/public/**` | Existing static assets moved from root. |
| `apps/frontend/config/**` | Existing display/database/card config moved from root for app-local access. |
| `apps/frontend/scripts/**` | Existing frontend helper scripts moved from root. |
| `apps/frontend/next.config.ts` | Existing Next config, still using `next-intl` and `oracledb`. |
| `apps/frontend/tsconfig.json` | Existing app TypeScript config, app-local `@/*` alias. |
| `apps/frontend/eslint.config.mjs` | Existing app ESLint config. |
| `apps/frontend/postcss.config.mjs` | Existing app PostCSS config. |
| `apps/frontend/src/app/frontend-foundation.structure.test.mjs` | Structure regression guard for display/business shell separation. |

---

## Task 1: Add Workspace Skeleton

**Files:**
- Create: `pnpm-workspace.yaml`
- Create: `turbo.json`

- [ ] **Step 1: Inspect current dirty tree**

Run:

```powershell
git status --short
```

Expected:
- Any existing dirty files are noted.
- Do not stage unrelated dirty files.

- [ ] **Step 2: Write root `pnpm-workspace.yaml`**

Create:

```yaml
packages:
  - "apps/*"
  - "packages/*"
```

- [ ] **Step 3: Write root `turbo.json`**

Create:

```json
{
  "$schema": "https://turbo.build/schema.json",
  "ui": "stream",
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "inputs": ["$TURBO_DEFAULT$", ".env*"],
      "outputs": [".next/**", "!.next/cache/**", "dist/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "lint": {
      "dependsOn": ["^build"],
      "inputs": ["$TURBO_DEFAULT$"],
      "outputs": []
    },
    "test": {
      "dependsOn": ["^build"],
      "inputs": ["$TURBO_DEFAULT$"],
      "outputs": ["coverage/**"]
    },
    "typecheck": {
      "dependsOn": ["^build"],
      "inputs": ["$TURBO_DEFAULT$"],
      "outputs": []
    }
  }
}
```

- [ ] **Step 4: Do not edit root `package.json` yet**

Keep the current root `package.json` unchanged until `apps/frontend/package.json` is created in Task 2. The current root file is the easiest source of the existing app dependency list.

- [ ] **Step 5: Continue to Task 2**

Do not run install yet. The workspace lockfile should be generated only after root and app package files both exist.

---

## Task 2: Move Existing Next App Into `apps/frontend`

**Files:**
- Modify: `package.json`
- Delete: `package-lock.json`
- Create directory: `apps/frontend`
- Move: `src/` -> `apps/frontend/src/`
- Move: `public/` -> `apps/frontend/public/`
- Move: `config/` -> `apps/frontend/config/`
- Move: `scripts/` -> `apps/frontend/scripts/`
- Move: `next.config.ts` -> `apps/frontend/next.config.ts`
- Move: `tsconfig.json` -> `apps/frontend/tsconfig.json`
- Move: `eslint.config.mjs` -> `apps/frontend/eslint.config.mjs`
- Move: `postcss.config.mjs` -> `apps/frontend/postcss.config.mjs`
- Move: `next-env.d.ts` -> `apps/frontend/next-env.d.ts`
- Create: `apps/frontend/package.json`

- [ ] **Step 1: Create app directory**

Run:

```powershell
New-Item -ItemType Directory -Force -Path apps/frontend
```

Expected:
- `apps/frontend` exists.

- [ ] **Step 2: Move app directories with git history**

Run:

```powershell
git mv src apps/frontend/src
git mv public apps/frontend/public
git mv config apps/frontend/config
git mv scripts apps/frontend/scripts
```

Expected:
- Moved paths show as renames in `git status --short`.

- [ ] **Step 3: Move app config files with git history**

Run:

```powershell
git mv next.config.ts apps/frontend/next.config.ts
git mv tsconfig.json apps/frontend/tsconfig.json
git mv eslint.config.mjs apps/frontend/eslint.config.mjs
git mv postcss.config.mjs apps/frontend/postcss.config.mjs
git mv next-env.d.ts apps/frontend/next-env.d.ts
```

Expected:
- App config files exist under `apps/frontend`.

- [ ] **Step 4: Create `apps/frontend/package.json` from the current app package**

Copy the current root `package.json` content into `apps/frontend/package.json`, then make these changes:

```json
{
  "name": "@eunsung/frontend",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev -H 0.0.0.0 -p 3100",
    "build": "next build",
    "postbuild": "node scripts/verify-build.mjs",
    "verify-build": "node scripts/verify-build.mjs",
    "start": "next start -H 0.0.0.0 -p 3100",
    "lint": "node scripts/eslint-wrapper.mjs",
    "typecheck": "tsc --noEmit --pretty false",
    "test": "node --test \"src/**/*.structure.test.mjs\""
  }
}
```

Then copy the existing app `dependencies` and `devDependencies` from the pre-migration root `package.json` into this file.

- [ ] **Step 5: Replace root `package.json` with workspace scripts**

After `apps/frontend/package.json` exists and contains the app dependencies, replace the root package with:

```json
{
  "name": "eunsung-mes",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "pnpm --filter @eunsung/frontend dev",
    "build": "pnpm --filter @eunsung/frontend build",
    "start": "pnpm --filter @eunsung/frontend start",
    "lint": "pnpm --filter @eunsung/frontend lint",
    "typecheck": "pnpm --filter @eunsung/frontend typecheck",
    "test": "pnpm --filter @eunsung/frontend test"
  },
  "devDependencies": {
    "turbo": "^2.4.4",
    "typescript": "^5"
  },
  "packageManager": "pnpm@10.28.1"
}
```

- [ ] **Step 6: Remove npm lockfile**

Run:

```powershell
git rm package-lock.json
```

Expected:
- `package-lock.json` is removed because the repository now uses `pnpm`.

- [ ] **Step 7: Preserve app-local Next config paths**

Open `apps/frontend/next.config.ts`.

Expected:
- `createNextIntlPlugin('./src/i18n/request.ts')` remains valid because `src` is now app-local.
- `serverExternalPackages: ['oracledb']` remains present.

- [ ] **Step 8: Preserve app-local TypeScript paths**

Open `apps/frontend/tsconfig.json`.

Expected:
- `@/*` maps to `./src/*`.
- `include` still includes `next-env.d.ts`, `**/*.ts`, `**/*.tsx`, `.next/types/**/*.ts`, `.next/dev/types/**/*.ts`, `**/*.mts`.

---

## Task 3: Fix Moved Script and Config Assumptions

**Files:**
- Inspect/modify: `apps/frontend/scripts/verify-build.mjs`
- Inspect/modify: `apps/frontend/scripts/eslint-wrapper.mjs`
- Inspect/modify: `apps/frontend/src/lib/db.ts`
- Inspect/modify: `apps/frontend/src/lib/ai-tables/paths.ts`
- Inspect/modify: `apps/frontend/src/lib/menu/storage.ts`

- [ ] **Step 1: Search for root-relative path assumptions**

Run:

```powershell
rg -n "process\\.cwd\\(|\\.\\/config|config/database|config/cards|oracle_db_scripts|docs/|public/|scripts/" apps/frontend/src apps/frontend/scripts apps/frontend/next.config.ts
```

Expected:
- Identify any paths that assumed the repo root was the Next app root.

- [ ] **Step 2: Fix `config/database.json` lookup only if broken**

Open `apps/frontend/src/lib/db.ts`.

Expected:
- If it reads `config/database.json` from `process.cwd()`, no change is required because `next dev` runs from `apps/frontend`.
- If it walks repo-root manually, update it to app-local `config/database.json`.

- [ ] **Step 3: Fix `config/cards.json` lookup only if broken**

Search result should show whether menu/card config uses app-local `config/cards.json`.

Expected:
- Runtime should resolve `apps/frontend/config/cards.json`.
- Do not move card config back to the repo root.

- [ ] **Step 4: Fix script paths if they reference old root**

Open moved scripts.

Expected:
- `apps/frontend/scripts/verify-build.mjs` uses app-local paths.
- `apps/frontend/scripts/eslint-wrapper.mjs` executes from app root.
- If a script references `src/` relative to current working directory, no change is required.

- [ ] **Step 5: Run path search again**

Run:

```powershell
rg -n "C:\\\\Project|\\.\\.\\/\\.\\.\\/src|\\.\\.\\/\\.\\.\\/config|process\\.cwd\\(\\).*\\.\\.\\/\\.\\." apps/frontend
```

Expected:
- No hardcoded local absolute paths are introduced.

---

## Task 4: Add Structure Tests for Shell Separation

**Files:**
- Create: `apps/frontend/src/app/frontend-foundation.structure.test.mjs`
- Modify: `apps/frontend/package.json`

- [ ] **Step 1: Create structure test**

Create `apps/frontend/src/app/frontend-foundation.structure.test.mjs`:

```js
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import { describe, it } from "node:test";

const appRoot = process.cwd();
const read = (relativePath) => fs.readFileSync(path.join(appRoot, relativePath), "utf8");
const exists = (relativePath) => fs.existsSync(path.join(appRoot, relativePath));

describe("frontend migration foundation", () => {
  it("keeps display routes in the display route group", () => {
    assert.equal(exists("src/app/(display)/display/[screenId]/page.tsx"), true);
    assert.equal(exists("src/components/display/DisplayLayout.tsx"), true);
    assert.equal(exists("src/app/api/display/21/route.ts"), true);
  });

  it("does not couple the display page to the future business shell", () => {
    const displayPage = read("src/app/(display)/display/[screenId]/page.tsx");
    assert.equal(displayPage.includes("@/components/layout/MainLayout"), false);
    assert.equal(displayPage.includes("@/components/layout/Header"), false);
    assert.equal(displayPage.includes("@/components/layout/Sidebar"), false);
  });

  it("keeps monitoring data APIs app-local", () => {
    const route = read("src/app/api/display/21/route.ts");
    assert.match(route, /executeQuery/);
    assert.match(route, /sqlProductLineMonitoring/);
  });
});
```

- [ ] **Step 2: Ensure test script exists**

Confirm `apps/frontend/package.json` contains:

```json
"test": "node --test \"src/**/*.structure.test.mjs\""
```

- [ ] **Step 3: Run structure test**

Run:

```powershell
pnpm.cmd --dir apps/frontend test
```

Expected:
- PASS for `frontend-foundation.structure.test.mjs`.

---

## Task 5: Verify Typecheck, Lint, and Build From Workspace

**Files:**
- Modify only if verification exposes migration errors.

- [ ] **Step 1: Install dependencies**

Run:

```powershell
pnpm.cmd install
```

Expected:
- `pnpm-lock.yaml` is updated.
- `node_modules` workspace layout is valid.

- [ ] **Step 2: Run frontend typecheck**

Run:

```powershell
pnpm.cmd --filter @eunsung/frontend typecheck
```

Expected:
- TypeScript passes.
- If paths fail because files moved, fix imports or config before continuing.

- [ ] **Step 3: Run frontend lint**

Run:

```powershell
pnpm.cmd --filter @eunsung/frontend lint
```

Expected:
- Lint wrapper runs from `apps/frontend`.
- If lint wrapper assumed repo root, fix wrapper path handling.

- [ ] **Step 4: Run workspace build only if no dev server is running**

Check for Next dev server first:

```powershell
Get-Process -Name node -ErrorAction SilentlyContinue | Select-Object Id,ProcessName,Path
```

If no relevant Next dev server is running, run:

```powershell
pnpm.cmd --filter @eunsung/frontend build
```

Expected:
- Next build succeeds.
- `postbuild` verifies moved build output.

- [ ] **Step 5: Start dev server**

Run:

```powershell
pnpm.cmd --filter @eunsung/frontend dev
```

Expected:
- Dev server starts on `http://localhost:3100`.
- Do not silently switch ports if 3100 is unavailable; report the exact failure.

- [ ] **Step 6: Probe display route**

In another shell, run:

```powershell
Invoke-WebRequest -UseBasicParsing http://localhost:3100/display/21 | Select-Object StatusCode
```

Expected:
- HTTP 200.
- If DB connection fails only after client fetch, route shell still renders; record API error separately.

---

## Task 6: Commit Foundation Migration

**Files:**
- Stage only files changed by this plan.

- [ ] **Step 1: Review unstaged and staged changes**

Run:

```powershell
git status --short
git diff --check
```

Expected:
- No whitespace errors.
- Unrelated dirty files remain unstaged.

- [ ] **Step 2: Stage intended files only**

Run:

```powershell
git add package.json pnpm-workspace.yaml turbo.json pnpm-lock.yaml apps/frontend
git add -u src public config scripts next.config.ts tsconfig.json eslint.config.mjs postcss.config.mjs next-env.d.ts package-lock.json
git diff --cached --name-status
```

Expected:
- Staged files are the workspace skeleton and moved frontend files only.
- `.github/workflows/deploy.yml` is not staged in this plan.

- [ ] **Step 3: Commit**

Run:

```powershell
git commit -m "chore(frontend): move display app into workspace"
```

Expected:
- One commit containing only foundation migration files.

---

## Follow-Up Plans

After this plan passes:

1. Plan 2: Import HANES landing, login, providers, layout shell, stores, and shared UI into `apps/frontend`.
2. Plan 3: Import system-management pages with frontend-only service boundaries and empty states.
3. Plan 4: Add 은성 PCB 기준정보/수불관리/OEE placeholder routes and menu config.
4. Plan 5+: Screen-by-screen backend/Oracle reuse designs and implementations.
