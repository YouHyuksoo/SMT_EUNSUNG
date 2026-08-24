# Process Excel Upload Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 공정관리 화면에서 생산팀 공정 엑셀을 검증·중복제거하여 공정마스터와 공정-라인 관계를 트랜잭션으로 저장하고, 초기 두 파일을 실제 Oracle에 업로드한다.

**Architecture:** 기존 `IP_PRODUCT_WORKSTAGE` 키와 운영 FK는 유지하고 `IP_PRODUCT_WORKSTAGE_LINE` 관계 테이블을 추가한다. 엑셀 파싱은 순수 파서, DB 검증·저장은 트랜잭션 서비스, UI는 전용 업로드 모달로 분리한다. 목록 API는 현재 페이지의 관계를 한 번에 조회해 `appliedLineCodes`를 제공한다.

**Tech Stack:** NestJS 11, TypeORM, Oracle, `xlsx`, Jest, Next.js/React 19, Axios multipart, node:test, pnpm/turborepo

---

## File map

- Create `apps/backend/src/entities/process-line.entity.ts`: 공정-라인 관계 엔티티.
- Modify `apps/backend/src/entities/index.ts`: 신규 엔티티 export.
- Modify `apps/backend/src/database/database.module.ts`: 루트 TypeORM 명시 엔티티 목록에 관계 엔티티 등록.
- Create `apps/backend/src/migrations/2026-08-12_process_workstage_lines.sql`: 관계 테이블과 라인 21~24의 재실행 가능한 DDL/DML.
- Create `apps/backend/src/migrations/process-workstage-lines.structure.test.mjs`: SQL 구조 회귀 테스트.
- Create `apps/backend/src/modules/master/services/process-upload.parser.ts`: 엑셀 헤더/값 정규화와 중복 제거 순수 로직.
- Create `apps/backend/src/modules/master/services/process-upload.parser.spec.ts`: 파서 TDD 테스트.
- Modify `apps/backend/src/modules/master/dto/process.dto.ts`: 업로드 결과·오류·요청 DTO/타입.
- Modify `apps/backend/src/modules/master/services/process.service.ts`: 관계 조회, 충돌 검증, 트랜잭션 저장, 유형 변경 제한.
- Modify `apps/backend/src/modules/master/services/process.service.spec.ts`: 업로드/조회/롤백/변경 제한 테스트.
- Modify `apps/backend/src/modules/master/controllers/process.controller.ts`: 인증된 multipart 업로드 API.
- Create `apps/backend/src/modules/master/controllers/process.controller.spec.ts`: Guard와 조직ID/파일 전달 계약 테스트.
- Modify `apps/backend/src/modules/master/master-process.module.ts`: 신규 엔티티 repository 등록.
- Create `apps/backend/src/modules/master/master-process.module.spec.ts`: repository와 Guard 의존성 컴파일 smoke test.
- Modify `apps/frontend/src/app/(authenticated)/master/process/types.ts`: `appliedLineCodes`와 업로드 결과 타입.
- Create `apps/frontend/src/app/(authenticated)/master/process/components/ProcessUploadModal.tsx`: 드래그앤드롭, 부서선택, 결과/오류 UI.
- Modify `apps/frontend/src/app/(authenticated)/master/process/page.tsx`: 업로드 버튼·모달·목록 재조회.
- Modify `apps/frontend/src/app/(authenticated)/master/process/components/ProcessList.tsx`: 적용라인 코드 열.
- Create `apps/frontend/src/app/(authenticated)/master/process/process-upload.eunsung.structure.test.mjs`: UI/API 계약 구조 테스트.

### Task 1: Oracle relation schema and entity

**Files:**
- Create: `apps/backend/src/migrations/process-workstage-lines.structure.test.mjs`
- Create: `apps/backend/src/migrations/2026-08-12_process_workstage_lines.sql`
- Create: `apps/backend/src/entities/process-line.entity.ts`
- Modify: `apps/backend/src/entities/index.ts`
- Modify: `apps/backend/src/database/database.module.ts`
- Modify: `apps/backend/src/modules/master/master-process.module.ts`

- [ ] **Step 1: Write the failing migration structure test**

Assert that the SQL contains the four-column PK, both tenant-composite FKs, and idempotent inserts for lines `21`–`24` with `W/FIXED/N/N`.

- [ ] **Step 2: Run the test and verify RED**

Run: `pnpm --filter @eunsung/backend exec node --test src/migrations/process-workstage-lines.structure.test.mjs`

Expected: FAIL because the migration file does not exist.

- [ ] **Step 3: Add the minimal SQL and entity**

Use a guarded PL/SQL block for `CREATE TABLE IP_PRODUCT_WORKSTAGE_LINE`, named PK/FKs, and `MERGE` statements for lines `21`–`24`. Map all four PK columns with `@PrimaryColumn`; include audit columns only. Register the entity in exports, the root explicit entity list in `database.module.ts`, and `MasterProcessModule`.

- [ ] **Step 4: Run structure test and backend typecheck**

Run: `pnpm --filter @eunsung/backend exec node --test src/migrations/process-workstage-lines.structure.test.mjs`

Run: `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`

Expected: PASS and zero TypeScript errors.

- [ ] **Step 5: Commit**

```bash
git add apps/backend/src/migrations/2026-08-12_process_workstage_lines.sql apps/backend/src/migrations/process-workstage-lines.structure.test.mjs apps/backend/src/entities/process-line.entity.ts apps/backend/src/entities/index.ts apps/backend/src/database/database.module.ts apps/backend/src/modules/master/master-process.module.ts
git commit -m "feat: add process line relation schema"
```

### Task 2: Pure Excel parser

**Files:**
- Create: `apps/backend/src/modules/master/services/process-upload.parser.spec.ts`
- Create: `apps/backend/src/modules/master/services/process-upload.parser.ts`

- [ ] **Step 1: Write failing parser tests**

Cover exact selection of the sheet named `공정마스터`, rejection when it is absent, required Korean headers, blank-row removal, trimming, `일반/I`, `최종/L`, `검사/Q`, uppercase `Y/N`, process-code numeric sort order, and exact relation-key deduplication. Prove same-process name/type/startYn consistency is checked before relation deduplication by using conflicting rows with the same composite relation key; include the reviewer-requested conflicting `시작공정구분` regression.

- [ ] **Step 2: Run parser tests and verify RED**

Run: `pnpm --filter @eunsung/backend test -- --runInBand src/modules/master/services/process-upload.parser.spec.ts`

Expected: FAIL because `parseProcessWorkbook` is missing.

- [ ] **Step 3: Implement the minimal pure parser**

Expose a typed `parseProcessWorkbook(buffer)` that selects only `공정마스터` and returns `{ inputRows, duplicateRows, processes, relations }`. Throw `BadRequestException` with `{ row, field, value, message }[]` only after collecting all file errors. Run master consistency checks before deduplicating relations.

- [ ] **Step 4: Run tests and verify GREEN**

Run the focused Jest command again.

Expected: PASS with all parser cases green.

- [ ] **Step 5: Commit**

```bash
git add apps/backend/src/modules/master/services/process-upload.parser.ts apps/backend/src/modules/master/services/process-upload.parser.spec.ts
git commit -m "feat: parse process upload workbooks"
```

### Task 3: Transactional upload service

**Files:**
- Modify: `apps/backend/src/modules/master/services/process.service.spec.ts`
- Modify: `apps/backend/src/modules/master/services/process.service.ts`
- Modify: `apps/backend/src/modules/master/dto/process.dto.ts`

- [ ] **Step 1: Write failing service tests**

Test one batch query per reference type, tenant-scoped department/line validation, existing-process reuse only when name/type/startYn/department and `lineCode='*'` match, relationship skip/create counts, transaction rollback propagation, and process-type update rejection while relations exist.

- [ ] **Step 2: Run service tests and verify RED**

Run: `pnpm --filter @eunsung/backend test -- --runInBand src/modules/master/services/process.service.spec.ts`

Expected: FAIL because upload and relation logic are absent.

- [ ] **Step 3: Implement minimal transaction logic**

Inject `DataSource`, `ProcessLine`, `DepartmentMaster`, and `ProdLineMaster` repositories. Parse before opening the transaction; validate all codes before writes; use `dataSource.transaction` and manager repositories for every write. Do not accept organization ID from body/query.

- [ ] **Step 4: Run service tests and typecheck**

Run the focused Jest command, then `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`.

Expected: PASS and zero TypeScript errors.

- [ ] **Step 5: Commit**

```bash
git add apps/backend/src/modules/master/services/process.service.ts apps/backend/src/modules/master/services/process.service.spec.ts apps/backend/src/modules/master/dto/process.dto.ts
git commit -m "feat: upload process masters transactionally"
```

### Task 4: Authenticated upload controller

**Files:**
- Create: `apps/backend/src/modules/master/controllers/process.controller.spec.ts`
- Modify: `apps/backend/src/modules/master/controllers/process.controller.ts`
- Create: `apps/backend/src/modules/master/master-process.module.spec.ts`
- Modify: `apps/backend/src/modules/master/master-process.module.ts`

- [ ] **Step 1: Write failing controller tests**

Assert class-level `JwtAuthGuard`, `FileInterceptor('file')` with memory storage and `.xlsx`/size validation, `@OrganizationId()` use, and forwarding only `{ file.buffer, departmentCode, organizationId, userId }` to the service. Add a module compilation smoke test proving `ProcessLine`, `DepartmentMaster`, `ProdLineMaster`, `IsysUser`, `IsysOrganization`, and `JwtAuthGuard` dependencies resolve.

- [ ] **Step 2: Run controller test and verify RED**

Run: `pnpm --filter @eunsung/backend test -- --runInBand src/modules/master/controllers/process.controller.spec.ts`

Expected: FAIL because the endpoint/guard contract is absent.

- [ ] **Step 3: Add minimal endpoint**

Add `POST /master/processes/upload`, `ApiConsumes('multipart/form-data')`, `UploadedFile`, body `departmentCode`, and authenticated user ID extraction for audit fields. Keep static `upload` route before `:id` routes. Register `ProcessLine`, `DepartmentMaster`, `ProdLineMaster`, `IsysUser`, and `IsysOrganization` in `TypeOrmModule.forFeature(...)`, and provide `JwtAuthGuard` in `MasterProcessModule`.

- [ ] **Step 4: Run controller and service tests**

Run both focused Jest files plus `master-process.module.spec.ts`.

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add apps/backend/src/modules/master/controllers/process.controller.ts apps/backend/src/modules/master/controllers/process.controller.spec.ts apps/backend/src/modules/master/master-process.module.ts apps/backend/src/modules/master/master-process.module.spec.ts
git commit -m "feat: expose process Excel upload API"
```

### Task 5: Applied-line list contract

**Files:**
- Modify: `apps/backend/src/modules/master/services/process.service.spec.ts`
- Modify: `apps/backend/src/modules/master/services/process.service.ts`
- Modify: `apps/frontend/src/app/(authenticated)/master/process/types.ts`

- [ ] **Step 1: Write failing list test**

Assert `findAll` queries relations once for the returned process codes and returns sorted `appliedLineCodes`, including `[]` when no mapping exists.

- [ ] **Step 2: Run and verify RED**

Run the focused process service Jest file.

Expected: FAIL because list rows lack `appliedLineCodes`.

- [ ] **Step 3: Implement batch relation enrichment**

Use one tenant-scoped `In(processCodes)` relation query after the page query; group and sort line codes without N+1 calls. Add the frontend field type.

- [ ] **Step 4: Run focused test and both typechecks**

Run backend Jest, backend tsc, and `pnpm --filter @eunsung/frontend typecheck`.

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add apps/backend/src/modules/master/services/process.service.ts apps/backend/src/modules/master/services/process.service.spec.ts apps/frontend/src/app/'(authenticated)'/master/process/types.ts
git commit -m "feat: return applied lines with processes"
```

### Task 6: Process upload modal and list rendering

**Files:**
- Create: `apps/frontend/src/app/(authenticated)/master/process/process-upload.eunsung.structure.test.mjs`
- Create: `apps/frontend/src/app/(authenticated)/master/process/components/ProcessUploadModal.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/master/process/page.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/master/process/components/ProcessList.tsx`

- [ ] **Step 1: Write failing frontend structure tests**

Assert upload button/modal wiring, `DepartmentSelect` reuse, drag/drop `.xlsx`, browser-side `공정마스터` header and data-row count summary, multipart fields `file` and `departmentCode`, result/error rendering, modal close plus list/selection reconciliation after success, and `appliedLineCodes` column.

- [ ] **Step 2: Run and verify RED**

Run: `pnpm --filter @eunsung/frontend exec node --test 'src/app/(authenticated)/master/process/process-upload.eunsung.structure.test.mjs'`

Expected: FAIL because the modal and wiring are absent.

- [ ] **Step 3: Implement the minimal UI**

Build a focused modal using existing `Modal`, `Button`, `DepartmentSelect`, and project toast/error patterns. Accept one `.xlsx`, support drop and file picker, inspect the `공정마스터` sheet in-browser to show header validity and data-row count, disable submit without a valid file/department, submit `FormData`, and show returned counts/errors. On success close the modal, re-fetch the process list, preserve the selected composite-visible row when it still exists or select the first returned row, then show compact line-code badges in `ProcessList`.

- [ ] **Step 4: Run frontend checks**

Run structure test, `pnpm --filter @eunsung/frontend typecheck`, and `pnpm --filter @eunsung/frontend lint`.

Expected: PASS with no new errors.

- [ ] **Step 5: Commit**

```bash
git add apps/frontend/src/app/'(authenticated)'/master/process
git commit -m "feat: add process Excel upload UI"
```

### Task 7: Apply Oracle migration safely

**Files:**
- Use: `apps/backend/src/migrations/2026-08-12_process_workstage_lines.sql`

- [ ] **Step 1: Capture pre-state**

Read `user_tables`, `user_constraints`, line `21`–`24`, and row counts for `IP_PRODUCT_WORKSTAGE` and the relation table. Preserve any `ORA-*`/`NJS-*` text.

- [ ] **Step 2: Execute the reviewed migration**

Run the `oracle-db` connector `--execute-file` against `ES_JSIDC`; verify `blocks_executed` matches the SQL separators.

- [ ] **Step 3: Verify post-state**

Confirm table columns, four-column PK, both FKs, line names and fixed values, and zero unexpected process/relation rows.

- [ ] **Step 4: Commit only if SQL required a correction**

If live schema exposed an error, first add a failing structure regression, patch the SQL, rerun it, and commit the correction. Otherwise do not create a no-op commit.

### Task 8: Upload the two approved files

**Files (inputs, read-only):**
- `/Users/log/Desktop/99.Temp/은성전장_임시/remes/공정마스터_업로드양식(생산1팀 작성 完).xlsx`
- `/Users/log/Desktop/99.Temp/은성전장_임시/remes/공정마스터_업로드양식(생산2팀 完).xlsx`

- [ ] **Step 1: Confirm authenticated UI and pre-counts**

Verify frontend `3100`, backend `3003`, logged-in organization `1`, process master count `0` (or reconcile current state), and relation count `0` before uploading.

- [ ] **Step 2: Upload production team 1 through the UI**

Select department `1000`, upload the first file, and expect input 60 / duplicate 0 / process created 5 / relation created 60, adjusted only for verified pre-existing identical rows.

- [ ] **Step 3: Verify team 1 end-to-end**

Check Oracle counts and representative keys, authenticated backend list response, frontend network response, and rendered line badges.

- [ ] **Step 4: Upload production team 2 through the UI**

Select department `2500`, upload the second file, and expect input 36 / duplicate 30 / process created 6 / relation created 6, adjusted only for verified pre-existing identical rows.

- [ ] **Step 5: Verify final state**

Confirm 11 process masters and 66 relations for the approved codes, correct type/start/department/sort values, no duplicate composite keys, and correct UI rows. Record that uploaded business data remains intentionally.

### Task 9: Final regression verification

**Files:**
- No new files unless a failure requires a scoped fix.

- [ ] **Step 1: Run backend checks**

Run focused tests, `pnpm --filter @eunsung/backend test`, and backend tsc.

- [ ] **Step 2: Run frontend checks**

Run process structure test, `pnpm --filter @eunsung/frontend test`, typecheck, and lint.

- [ ] **Step 3: Verify repository and runtime state**

Run `git diff --check`, inspect `git status --short`, and confirm dev server logs contain no new runtime error.

- [ ] **Step 4: Create an unfinished report only if necessary**

If browser, API, Oracle, or cleanup verification cannot complete, create `docs/reports/2026-08-12-process-excel-upload-incomplete.md` following the manifest with exact completed/pending state. Do not claim completion.
