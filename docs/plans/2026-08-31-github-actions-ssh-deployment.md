# GitHub Actions SSH Deployment Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deploy the exact `main` commit to the Jisung development server over SSH, run the Eunsung frontend and backend under a least-privilege PM2 account, and roll back automatically when health verification fails.

**Architecture:** A pinned GitHub-hosted runner packages `${GITHUB_SHA}` and uploads it to a commit-specific Windows release directory. Reviewed PowerShell scripts install and build the release, copy protected server-only configuration, switch two PM2 apps, verify ports and database-aware health, and restore the previous release on failure. A one-time administrator bootstrap creates the non-admin deployment account and performs the initial cutover; normal deployments use only that account.

**Tech Stack:** GitHub Actions, OpenSSH/Ed25519, Windows PowerShell 5.1, pnpm 10.28.1, Turborepo, Next.js, NestJS, PM2, Oracle Thick Client

---

## File map

- Modify `.gitignore`: ignore only the server-local `.deploy/` directory.
- Replace `.github/workflows/deploy.yml`: exact-SHA archive, pinned checkout, protected Environment, strict SSH, upload, remote deployment, and failure diagnostics.
- Modify `ecosystem.config.js`: define `eunsung-frontend` and `eunsung-backend` from an explicit release root.
- Create `scripts/deploy/windows/Deploy-EunsungRelease.ps1`: validate, extract, configure, install, build, switch, verify, and roll back a release.
- Create `scripts/deploy/windows/Initialize-EunsungDeployServer.ps1`: one-time account, ACL, tooling, shared directories, and PM2 service bootstrap.
- Create `scripts/deploy/windows/Test-EunsungDeployment.ps1`: bounded frontend/backend, JSON health, PM2, port, and PID verification.
- Create `scripts/deploy/windows/EunsungDeployment.psm1`: injectable safety, process, health, switch, and rollback functions.
- Create `scripts/deploy/windows/tests/Deployment.Tests.ps1`: executable isolated tests using injected command/HTTP adapters.
- Create `scripts/deploy/deployment-structure.test.mjs`: static regression tests for workflow and deployment safety contracts.

### Task 1: Lock deployment contracts with failing tests

**Files:**
- Create: `scripts/deploy/deployment-structure.test.mjs`
- Test: `.github/workflows/deploy.yml`
- Test: `ecosystem.config.js`
- Test: `scripts/deploy/windows/*.ps1`

- [ ] **Step 1: Write failing structure tests**

Test for: `contents: read`; `environment: jisung-development`; only push-to-main/manual triggers; concurrency; `${GITHUB_SHA}` propagation; strict host-key checking; no password secret; no `reset --hard`; no deployment from `D:\Project\SMT_EUNSUNG` tracked worktree; two PM2 names; release-root validation; `$ErrorActionPreference = 'Stop'`; native exit checks; backend JSON health requirements; bounded retry; rollback function; manual-only `build_only`, `activate_existing`, and `rollback_test` modes.

- [ ] **Step 2: Verify the tests fail against the old workflow**

Run: `node --test scripts/deploy/deployment-structure.test.mjs`

Expected: FAIL because the existing workflow uses a self-hosted runner, `npm ci`, `reset --hard`, and frontend-only PM2.

- [ ] **Step 3: Commit only the test**

```powershell
git add -- scripts/deploy/deployment-structure.test.mjs
git diff --cached --check
git commit -m "test: define protected SSH deployment contract"
```

### Task 2: Define two-app PM2 runtime

**Files:**
- Modify: `ecosystem.config.js`
- Test: `scripts/deploy/deployment-structure.test.mjs`

- [ ] **Step 1: Replace the single `mes-display` definition**

Require an absolute `EUNSUNG_RELEASE_DIR`. Define:

- `eunsung-frontend`: cwd `<release>\apps\frontend`, Next binary, `start -H 0.0.0.0 -p 3100`.
- `eunsung-backend`: cwd `<release>\apps\backend`, Node script `dist\main.js`, `NODE_ENV=production`, `TZ=Asia/Seoul`.
- Shared log root from `EUNSUNG_DEPLOY_ROOT`; Oracle Client path passed explicitly to the backend; existing bounded restart policies retained.

- [ ] **Step 2: Run the structure test**

Run: `node --test scripts/deploy/deployment-structure.test.mjs`

Expected: workflow/script assertions still fail, but PM2 assertions pass.

- [ ] **Step 3: Commit the PM2 definition**

```powershell
git add -- ecosystem.config.js
git diff --cached --check
git commit -m "build: define frontend and backend PM2 apps"
```

### Task 3: Implement health verification and transactional deployment

**Files:**
- Create: `scripts/deploy/windows/Test-EunsungDeployment.ps1`
- Create: `scripts/deploy/windows/Deploy-EunsungRelease.ps1`
- Create: `scripts/deploy/windows/EunsungDeployment.psm1`
- Create: `scripts/deploy/windows/tests/Deployment.Tests.ps1`
- Modify: `.gitignore`
- Test: `scripts/deploy/deployment-structure.test.mjs`

- [ ] **Step 1: Implement injectable deployment primitives**

Put path containment, full-SHA validation, ordinary-file/reparse rejection, native-command execution, bounded HTTP requests, PM2 JSON parsing, PID-to-port ownership, secret-redacted diagnostics, release retention, switch-state capture, and rollback in `EunsungDeployment.psm1`. Accept command and HTTP adapters so tests execute behavior without real PM2, ports, or secrets.

- [ ] **Step 2: Implement the health verifier**

Parameters: deploy root, expected SHA, retry count, delay, frontend/backend URLs, PM2 paths. Verify release marker, PM2 `online`, listening ports `3100/3003`, frontend HTTP success, and backend `/api/v1/health` JSON where `status -eq 'ok'` and `database.status -eq 'connected'`. Fail after bounded retries and print sanitized PM2 diagnostics.

- [ ] **Step 3: Implement release deployment**

Parameters: SHA, optional uploaded archive, `[switch]$BuildOnly`, `[switch]$ActivateExisting`, and `[switch]$InjectHealthFailure`. `BuildOnly` and `ActivateExisting` are mutually exclusive. `InjectHealthFailure` is valid only with `ActivateExisting` and an explicit `-AllowFailureInjection` guard supplied solely by the manual `rollback_test` workflow mode.

For a new release, resolve every destination and require it under `D:\Project\SMT_EUNSUNG\.deploy`. Reject existing/reparse-point release targets. Expand to a new release, copy shared secrets without printing, write the SHA marker, then run with explicit binaries:

```powershell
pnpm install --frozen-lockfile
pnpm --filter @smt/shared build
pnpm --filter @eunsung/backend build
pnpm --filter @eunsung/frontend build
```

Check `$LASTEXITCODE` after every native command. A successful build writes `build.complete.json` containing the exact SHA, build timestamp, expected output paths, and hashes of non-secret deployment scripts/config. `-BuildOnly` stops after validating that marker; it never calls PM2 or probes occupied ports.

`-ActivateExisting` accepts no archive and performs no extraction, install, or build. It requires an existing ordinary release directory, no reparse points anywhere in its resolved ancestry, exact `.commit-sha` and `build.complete.json` SHA match, expected built outputs, unchanged non-secret hashes, ordinary protected config files, and ownership/ACL access for `eunsung-deploy`. It then follows the same captured-state switch/health/rollback transaction.

The workflow exposes a manual `mode` choice (`deploy`, `build_only`, `activate_existing`, `rollback_test`) and optional `target_release_sha`. Push-to-main hard-codes `deploy` and ignores all inputs. Manual `build_only` targets `${GITHUB_SHA}`; `activate_existing` targets `${GITHUB_SHA}`; `rollback_test` requires a different full `target_release_sha` already built on `main`, passes `-ActivateExisting -InjectHealthFailure -AllowFailureInjection`, and can never be selected by a push event.

Before switching, capture the prior current-release marker, both app definitions/env/PIDs, and a copy of the current PM2 dump. Do not run `pm2 save` yet. Start/reload both apps, then run health verification. Only successful health updates the current marker and runs `pm2 save`. On partial switch or health failure, delete/stop both new definitions, restore both prior definitions and env, restore the previous dump, restart and verify the previous release, then save the restored state and exit non-zero. With no prior release, stop both new apps, leave no current marker, preserve the original dump, and fail. If rollback health also fails, preserve both diagnostic sets and return a distinct non-zero rollback-failed code. Retain at most three successful releases only after success.

- [ ] **Step 4: Ignore the server-local deployment directory**

Add root-relative `/.deploy/` to `.gitignore`; do not broaden the ignore rule.

- [ ] **Step 5: Write and run executable safety tests**

Use a fresh temporary root and injected fake native/HTTP adapters. Cover: prefix-confusion containment, reparse release/shared rejection, native non-zero exit, bounded timeout count, backend degraded response, PM2 PID-to-port mismatch, diagnostic redaction, retention only after success, successful two-app switch, frontend-only partial switch rollback, successful rollback, rollback-health failure, no-previous-release cleanup, build marker creation, existing-release activation without rebuild, marker/hash/ACL rejection, failure-injection guard rejection, and injected failure returning to the captured current release.

```powershell
powershell.exe -NoProfile -NonInteractive -File scripts/deploy/windows/tests/Deployment.Tests.ps1
node --test scripts/deploy/deployment-structure.test.mjs
```

- [ ] **Step 6: Run static and syntax checks**

```powershell
node --test scripts/deploy/deployment-structure.test.mjs
$null = [scriptblock]::Create((Get-Content -Raw scripts/deploy/windows/Test-EunsungDeployment.ps1))
$null = [scriptblock]::Create((Get-Content -Raw scripts/deploy/windows/Deploy-EunsungRelease.ps1))
$null = [scriptblock]::Create((Get-Content -Raw scripts/deploy/windows/EunsungDeployment.psm1))
```

Expected: script and PM2 assertions pass; workflow assertions remain failing.

- [ ] **Step 7: Commit deployment scripts**

```powershell
git add -- .gitignore scripts/deploy/windows/EunsungDeployment.psm1 scripts/deploy/windows/Test-EunsungDeployment.ps1 scripts/deploy/windows/Deploy-EunsungRelease.ps1 scripts/deploy/windows/tests/Deployment.Tests.ps1 scripts/deploy/deployment-structure.test.mjs
git diff --cached --check
git commit -m "build: add transactional Windows deployment"
```

### Task 4: Implement one-time least-privilege bootstrap

**Files:**
- Create: `scripts/deploy/windows/Initialize-EunsungDeployServer.ps1`
- Test: `scripts/deploy/deployment-structure.test.mjs`

- [ ] **Step 1: Implement idempotent bootstrap**

Require administrator execution and explicit parameters. Create `eunsung-deploy` only if absent, never print its generated password, deny administrator-group membership, create `.deploy/{incoming,releases,shared,logs,scripts,state}` with scoped Modify access, and keep `.deploy/bootstrap` Administrators/SYSTEM-owned with deployment-account read/execute only. Register the supplied public key in the account's actual registered Windows profile `.ssh\authorized_keys` with Windows ACLs. Validate read/execute access to Node and Oracle Client. Install exactly `pnpm@10.28.1` and `pm2@6.0.6` for the deployment account only when absent.

For reboot restoration use built-in Task Scheduler, not an unpinned PM2 service package. Create a reviewed `.deploy\bootstrap\Resurrect-EunsungPm2.ps1` wrapper that fixes `USERPROFILE` and `PM2_HOME`, then calls the pinned PM2 command and checks its exit code. Windows Server 2019 live proof showed that an `AtStartup` task cannot use the attempted cross-account S4U or nonadministrator self-registration paths, so register `\EunsungMES\EunsungMES-PM2-Resurrect` elevated with the deployment account's `Password` logon and limited run level. Keep the generated password in memory only, pass plaintext only to the in-process scheduler API, and zero/free the conversion buffer. A compliant existing task is reused without password rotation; a noncompliant existing task fails before rotation. Verify with `Start-ScheduledTask`, bounded status/process checks, and `Stop-ScheduledTask`; do not reboot. Rollback unregisters only this exact task and removes only the protected generated wrapper.

- [ ] **Step 2: Add bootstrap safety assertions**

Assert no hard-coded credential, no administrator-group addition, scoped ACL paths, idempotent account/path/task checks, exact scheduled-task path/name, Password/limited principal, zeroed temporary password conversion, checked PM2 exit, task rollback, and no reboot/shutdown command.

- [ ] **Step 3: Run tests and parse the script**

Run: `node --test scripts/deploy/deployment-structure.test.mjs`

Expected: bootstrap, runtime, and deployment script assertions pass.

- [ ] **Step 4: Commit bootstrap**

```powershell
git add -- scripts/deploy/windows/Initialize-EunsungDeployServer.ps1 scripts/deploy/deployment-structure.test.mjs
git diff --cached --check
git commit -m "build: add least privilege deployment bootstrap"
```

### Task 5: Replace the unsafe workflow

**Files:**
- Replace: `.github/workflows/deploy.yml`
- Test: `scripts/deploy/deployment-structure.test.mjs`

- [ ] **Step 1: Implement protected exact-SHA deployment**

Use fixed `ubuntu-24.04`, Bash shell, `permissions: contents: read`, `environment: jisung-development`, `concurrency`, push-to-main and `workflow_dispatch` with the `mode` choice and optional `target_release_sha`. Pin every external Action to a reviewed full commit SHA. Validate `${GITHUB_SHA}` and any target SHA against `^[0-9a-f]{40}$`; confirm a target SHA is an ancestor of `origin/main`. For modes needing a new release, create a PowerShell-5.1-compatible ZIP with `git archive --format=zip --output=eunsung-${GITHUB_SHA}.zip ${GITHUB_SHA}`. Activation modes upload scripts only and never overwrite the release.

Create `known_hosts` from an Environment Secret and a temporary key file with mode 600. Use native `ssh`/`scp` with `BatchMode=yes`, `StrictHostKeyChecking=yes`, `ConnectTimeout=15`, `ServerAliveInterval=15`, and `ServerAliveCountMax=2`. Upload to SHA-specific `.deploy/incoming/<sha>/` paths. Upload reviewed scripts to that incoming directory, invoke exactly `powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File <incoming>\Deploy-EunsungRelease.ps1 -CommitSha <sha> [-BuildOnly]`, and quote every remote Windows path through environment variables rather than shell concatenation. The remote script validates ACL/ownership before execution and removes only its SHA-specific incoming directory in `finally`. Failure diagnostics are sanitized and artifacts are never uploaded.

- [ ] **Step 2: Run all local deployment checks**

```powershell
node --test scripts/deploy/deployment-structure.test.mjs
pnpm --filter @eunsung/backend build
pnpm --filter @eunsung/frontend typecheck
```

Expected: deployment tests pass. Report unrelated existing typecheck failures separately and do not alter unrelated code.

- [ ] **Step 3: Commit workflow**

```powershell
git add -- .github/workflows/deploy.yml scripts/deploy/deployment-structure.test.mjs
git diff --cached --check
git commit -m "ci: deploy exact commits to Jisung over SSH"
```

### Task 6: Bootstrap server and GitHub Environment

**Files/Systems:**
- Local temporary key directory outside the repository
- Jisung server `139.150.82.207:22`
- GitHub Environment `jisung-development`

- [ ] **Step 1: Generate a repository-specific Ed25519 key**

Create it in a new `mktemp`/Windows temporary directory with a descriptive comment. Never write it inside the repository or print the private key.

- [ ] **Step 2: Review and run server bootstrap**

Upload the reviewed bootstrap script through the already registered administrator SSH profile. Run it with the public key. Reconnect in a fresh SSH session as `eunsung-deploy` and verify account identity, scoped write access, inability to write another project, Node/pnpm/PM2 versions, and Oracle Client access.

- [ ] **Step 3: Place protected server configuration**

Copy local `apps/backend/.env` to `.deploy\shared\backend.env` and existing server `apps/frontend/config/database.json` to `.deploy\shared\frontend-database.json`. Apply ACLs for `eunsung-deploy` and Administrators only. Validate existence and JSON syntax without displaying contents.

- [ ] **Step 4: Create and restrict GitHub Environment**

Create `jisung-development`, restrict deployment branches to `main`, and register Environment Secrets:

- `DEPLOY_HOST`
- `DEPLOY_PORT`
- `DEPLOY_USER`
- `DEPLOY_SSH_KEY`
- `DEPLOY_SSH_HOST_KEY`

Confirm secret names only; never read secret values back.

- [ ] **Step 5: Configure and verify branch protection**

Use `gh api` to require pull-request review or the repository's agreed protected-main policy, disallow force pushes/deletions, and confirm the returned rule applies to `main`. Verify the `jisung-development` Environment deployment branch policy contains only `main`. Inspect workflow events and job-level `environment` to prove PR/fork events cannot enter the deployment job and secrets are referenced only there. Search workflow/scripts for secret echoing and artifact upload steps.

- [ ] **Step 6: Remove the temporary private key after GitHub registration**

Delete only the validated temporary key directory and report that the private key remains solely in the GitHub Environment.

### Task 7: First deployment and controlled cutover

**Systems:**
- GitHub Actions
- Administrator PM2 home (legacy frontend)
- `eunsung-deploy` PM2 home (new frontend/backend)

- [ ] **Step 1: Push only intended deployment commits**

Before pushing, run `git status --short`, `git diff`, `git diff --cached --name-only`, and `git log --oneline @{upstream}..HEAD`. Build an explicit allowlist of deployment/spec/plan commits and paths. If the upstream range contains any pre-existing unrelated commit, do not push `main`; stop and obtain approval or publish through a clean deployment-only branch/PR. Intermediate commits are allowed only after each staged-path list matches the task allowlist. Never include the user's unrelated OEE/run-card work.

- [ ] **Step 2: Run the workflow without cutover**

Run `gh workflow run deploy.yml --ref main -f mode=build_only`. The workflow must invoke `Deploy-EunsungRelease.ps1 -CommitSha "${GITHUB_SHA}" -ArchivePath <sha-zip> -BuildOnly`. Confirm the release SHA, `build.complete.json`, and both build outputs, and verify no PM2 command ran and ports/PIDs are unchanged.

- [ ] **Step 3: Perform administrator-assisted cutover**

Using the registered administrator SSH profile, capture Administrator PM2 JSON, confirm `mes-display` owns listening port `3100`, and abort if port `3003` has an unknown owner. Run `pm2 stop mes-display` only when its PID matches `3100`; do not delete or save the legacy definition yet. Then run `gh workflow run deploy.yml --ref main -f mode=activate_existing`; the protected job must invoke exactly `Deploy-EunsungRelease.ps1 -CommitSha "${GITHUB_SHA}" -ActivateExisting`. If the frontend starts but backend/DB/port verification fails, the deploy script stops both new apps and reports failure; the administrator session then runs `pm2 restart mes-display`, verifies its replacement PID owns `3100`, and confirms frontend health. On success, preserve the captured legacy PM2 JSON until rollback testing completes; removal of the legacy definition is a separate confirmed cleanup.

- [ ] **Step 4: Verify end to end**

Confirm GitHub run success, exact SHA, both PM2 apps online, PID-to-port ownership, frontend HTTP, backend database-aware health, and server-only config preservation. Do not claim external internet availability; this proves deployment and server-local health only.

- [ ] **Step 5: Exercise rollback safely**

After two distinct healthy releases exist, choose the older non-current full SHA and run:

```powershell
gh workflow run deploy.yml --ref main -f mode=rollback_test -f target_release_sha=<older-built-sha>
```

The manual protected job validates that SHA is on `main`, then invokes exactly `Deploy-EunsungRelease.ps1 -CommitSha <older-built-sha> -ActivateExisting -InjectHealthFailure -AllowFailureInjection`. The script starts the target, intentionally fails only the post-switch verifier without changing secrets/data/endpoints, restores the captured current release and PM2 dump, verifies current health, and exits non-zero as expected. Confirm the current SHA/PIDs/health are restored; no follow-up deployment is needed unless restoration verification fails.

- [ ] **Step 6: Report completion**

Report workflow URL, deployed SHA, PM2 statuses, health evidence, rollback evidence, and any unverified external proxy/firewall work. Keep deployment and external publication as separate completion criteria.
