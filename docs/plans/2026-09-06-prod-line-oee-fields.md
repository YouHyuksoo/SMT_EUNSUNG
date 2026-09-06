# Production Line OEE Fields Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Store and manage workplace, OEE type, and parent-line information directly on `IP_PRODUCT_LINE`, while hiding the legacy OEE line-management menu and leaving `OEE_RESOURCE` untouched.

**Architecture:** Extend the existing `ProdLineMaster` entity and `/master/prod-lines` CRUD contract with three nullable Oracle columns. Enforce `LINE → parent=self` and `CELL → required same-organization different parent` in `ProdLineService`, then expose the fields through the existing `ProdLineTab` select/grid patterns; menu registration is removed only from generated navigation inputs, not from the legacy page or APIs.

**Tech Stack:** Oracle, TypeORM, NestJS 11, class-validator, Next.js 16, React 19, TypeScript, TanStack Table, i18next, Node structure tests, Jest, pnpm/turborepo.

---

## File map

- Create `oracle_db_scripts/13_prod_line_oee_fields.sql`: idempotent `IP_PRODUCT_LINE` column and check-constraint deployment.
- Create `apps/backend/src/modules/master/prod-line-ddl.spec.ts`: static regression contract for the Oracle deployment script.
- Modify `apps/backend/src/entities/prod-line-master.entity.ts`: map the three real Oracle columns.
- Modify `apps/backend/src/modules/master/dto/prod-line.dto.ts`: validate the new API fields.
- Modify `apps/backend/src/modules/master/services/prod-line.service.ts`: defaults, normalization, and tenant-scoped parent validation.
- Modify `apps/backend/src/modules/master/services/prod-line.service.spec.ts`: service behavior tests.
- Create `apps/backend/src/modules/master/dto/prod-line.dto.spec.ts`: DTO code-domain tests.
- Modify `apps/backend/src/modules/master/controllers/prod-line.controller.ts`: require authenticated organization context.
- Create `apps/backend/src/modules/master/controllers/prod-line.controller.spec.ts`: guard-metadata regression test.
- Create `apps/frontend/src/app/(authenticated)/master/prod-line/prod-line-oee-fields.eunsung.structure.test.mjs`: frontend form/grid contract.
- Create `apps/frontend/src/config/oee-resource-menu-hidden.eunsung.structure.test.mjs`: hidden-menu contract while preserving the legacy route.
- Modify `apps/frontend/src/components/master/ProdLineTab.tsx`: types, payload, selects, grid columns, and state transitions.
- Modify `apps/frontend/src/app/(authenticated)/master/prod-line/components/ProdLineFieldHelp.tsx`: DB-backed help metadata.
- Modify `apps/frontend/src/locales/{ko,en,vi,zh}.json`: field labels, option labels, help, and validation message text.
- Modify `apps/frontend/src/config/menuConfig.ts`: hide `OEE_MST_RESOURCE` without deleting its route.
- Regenerate `apps/backend/src/seeds/menu-config.json`, `apps/backend/src/modules/menu-categories/utils/default-menu-category-layout.ts`, and `apps/backend/src/modules/menu-categories/utils/menu-code-validator.ts` with the existing generator; never edit those files by hand.

### Task 1: Specify and deploy the Oracle schema contract

**Files:**
- Create: `oracle_db_scripts/13_prod_line_oee_fields.sql`
- Create: `apps/backend/src/modules/master/prod-line-ddl.spec.ts`

- [ ] **Step 1: Record the implementation baseline**

```bash
git rev-parse HEAD
```

Record the exact output as `<base-sha>` in the execution notes. Every final scope check uses `<base-sha>..HEAD`, because ordinary `git diff` would miss mistakes already committed by an earlier task.

- [ ] **Step 2: Inspect the live schema before authoring DDL**

Use the `oracle-db` skill/connector against the backend `.env` profile and query `USER_TAB_COLUMNS` and `USER_CONSTRAINTS`/`USER_CONS_COLUMNS` for `IP_PRODUCT_LINE`. Confirm the real length of `LINE_CODE`, whether all three proposed columns are absent, and that the planned constraint names are unused. Do not infer the live schema from the entity alone.

- [ ] **Step 3: Write the failing DDL contract test**

Create a Jest test that reads `oracle_db_scripts/13_prod_line_oee_fields.sql` and requires:

```ts
expect(sql).toContain('ALTER TABLE IP_PRODUCT_LINE ADD PROCESS_CODE VARCHAR2(20)');
expect(sql).toContain('ALTER TABLE IP_PRODUCT_LINE ADD RESOURCE_TYPE VARCHAR2(20)');
expect(sql).toContain('ALTER TABLE IP_PRODUCT_LINE ADD PARENT_LINE_CODE VARCHAR2(20)');
expect(sql).toContain("PROCESS_CODE IS NULL OR PROCESS_CODE IN ('SMT', 'ASSY')");
expect(sql).toContain("RESOURCE_TYPE IS NULL OR RESOURCE_TYPE IN ('LINE', 'CELL')");
expect(sql).not.toMatch(/OEE_RESOURCE/i);
```

Also strip leading whitespace and assert the first token is `DECLARE` or `BEGIN`; count catalog existence guards for all three columns and both constraints; and reject `INSERT`, `UPDATE`, `DELETE`, `MERGE`, `DEFAULT`, and `FOREIGN KEY` tokens. This makes the static test enforce the deployment rules rather than merely checking column names.

- [ ] **Step 4: Run the test and verify RED**

Run:

```bash
pnpm --filter @eunsung/backend test -- --runInBand src/modules/master/prod-line-ddl.spec.ts
```

Expected: FAIL because the deployment script does not exist.

- [ ] **Step 5: Add the minimal idempotent Oracle script**

Make the file start with `DECLARE` and use `USER_TAB_COLUMNS`/`USER_CONSTRAINTS` guards before each `EXECUTE IMMEDIATE`. Add nullable columns `PROCESS_CODE`, `RESOURCE_TYPE`, `PARENT_LINE_CODE`, then nullable-aware checks named `CK_IP_PROD_LINE_PROCESS` and `CK_IP_PROD_LINE_RESOURCE`. Include no DML, defaults, foreign keys, or `OEE_RESOURCE` statements.

- [ ] **Step 6: Run the focused test and deploy the script**

Run the focused Jest command again; expected: PASS. Then execute the file through the `oracle-db --execute-file` workflow and query the live catalog again. Expected: three nullable `VARCHAR2(20)` columns and two enabled check constraints. Re-run the script once to prove idempotence.

- [ ] **Step 7: Commit the schema contract**

```bash
git add oracle_db_scripts/13_prod_line_oee_fields.sql apps/backend/src/modules/master/prod-line-ddl.spec.ts
git commit -m "feat: add production line OEE columns"
```

### Task 2: Specify the backend production-line contract

**Files:**
- Create: `apps/backend/src/modules/master/dto/prod-line.dto.spec.ts`
- Modify: `apps/backend/src/modules/master/services/prod-line.service.spec.ts`
- Modify later: `apps/backend/src/entities/prod-line-master.entity.ts`
- Modify later: `apps/backend/src/modules/master/dto/prod-line.dto.ts`
- Modify later: `apps/backend/src/modules/master/services/prod-line.service.ts`
- Modify later: `apps/backend/src/modules/master/controllers/prod-line.controller.ts`
- Create: `apps/backend/src/modules/master/controllers/prod-line.controller.spec.ts`

- [ ] **Step 1: Write failing DTO tests**

Use `plainToInstance` plus `validateSync` to assert `SMT|ASSY` and `LINE|CELL` are accepted, other values are rejected, and each field remains omittable for legacy rows/partial updates. Assert `parentLineCode` rejects strings longer than 20 characters.

- [ ] **Step 2: Write failing service tests**

Extend `prod-line.service.spec.ts` with these exact behaviors:

- create without OEE fields persists `processCode: 'SMT'`, `resourceType: 'LINE'`, `parentLineCode: dto.lineCode`;
- create/update with `resourceType: 'LINE'` ignores a supplied parent and writes the current line code;
- `CELL` create/update resolves its parent with `findOne({ where: { lineCode: parent, organizationId } })`;
- valid `CELL` writes the selected other parent;
- missing parent, self-parent, or nonexistent same-tenant parent throws `BadRequestException`;
- a parent existing only in another organization is treated as nonexistent because the repository lookup is tenant scoped.

- [ ] **Step 3: Write a failing controller guard test**

Use Nest's `GUARDS_METADATA` and assert:

```ts
const guards = Reflect.getMetadata(GUARDS_METADATA, ProdLineController) ?? [];
expect(guards).toContain(JwtAuthGuard);
```

This is required because every controller method uses `@OrganizationId()` and parent validation must never run with an undefined tenant.

- [ ] **Step 4: Run focused tests and verify RED**

```bash
pnpm --filter @eunsung/backend test -- --runInBand src/modules/master/dto/prod-line.dto.spec.ts src/modules/master/services/prod-line.service.spec.ts src/modules/master/controllers/prod-line.controller.spec.ts
```

Expected: FAIL because the new DTO fields and service rules are absent.

- [ ] **Step 5: Commit the failing backend tests**

```bash
git add apps/backend/src/modules/master/dto/prod-line.dto.spec.ts apps/backend/src/modules/master/services/prod-line.service.spec.ts apps/backend/src/modules/master/controllers/prod-line.controller.spec.ts
git commit -m "test: specify production line OEE fields"
```

### Task 3: Implement the backend contract

**Files:**
- Modify: `apps/backend/src/entities/prod-line-master.entity.ts`
- Modify: `apps/backend/src/modules/master/dto/prod-line.dto.ts`
- Modify: `apps/backend/src/modules/master/services/prod-line.service.ts`
- Modify: `apps/backend/src/modules/master/controllers/prod-line.controller.ts`

- [ ] **Step 1: Map the Oracle columns**

Add nullable entity properties immediately after `lineStatus`:

```ts
@Column({ type: 'varchar2', name: 'PROCESS_CODE', length: 20, nullable: true })
processCode: string | null;

@Column({ type: 'varchar2', name: 'RESOURCE_TYPE', length: 20, nullable: true })
resourceType: string | null;

@Column({ type: 'varchar2', name: 'PARENT_LINE_CODE', length: 20, nullable: true })
parentLineCode: string | null;
```

- [ ] **Step 2: Add DTO validation**

Define local constants `PROD_LINE_PROCESS_CODES = ['SMT', 'ASSY'] as const` and `PROD_LINE_RESOURCE_TYPES = ['LINE', 'CELL'] as const` in `prod-line.dto.ts`. Add optional `@IsString()`, `@IsIn(...)`, and `@MaxLength(20)` fields with Swagger metadata. Do not import or alter the OEE mobile DTO; `IP_PRODUCT_LINE` owns this contract.

- [ ] **Step 3: Normalize and validate parent relationships once**

Add a private helper receiving `lineCode`, proposed `resourceType`, proposed `parentLineCode`, and `organizationId`. It returns self for `LINE`; for `CELL`, rejects blank/self and uses a new tenant-scoped `findOne` bind object to verify the parent. In create, apply defaults `SMT` and `LINE`. In update, merge omitted OEE fields with the existing row before validation so partial updates retain values, then include all three normalized fields in `updateData` only when the resulting contract requires them.

- [ ] **Step 4: Require authenticated tenant context**

Add `@UseGuards(JwtAuthGuard)` to `ProdLineController`, following the existing master-controller pattern. Do not accept organization IDs from request body/query.

- [ ] **Step 5: Run focused tests and verify GREEN**

Run the Task 2 test command. Expected: all tests pass.

- [ ] **Step 6: Commit the backend implementation**

```bash
git add apps/backend/src/entities/prod-line-master.entity.ts apps/backend/src/modules/master/dto/prod-line.dto.ts apps/backend/src/modules/master/services/prod-line.service.ts apps/backend/src/modules/master/controllers/prod-line.controller.ts
git commit -m "feat: manage OEE fields on production lines"
```

### Task 4: Specify the production-line UI and hidden-menu behavior

**Files:**
- Create: `apps/frontend/src/app/(authenticated)/master/prod-line/prod-line-oee-fields.eunsung.structure.test.mjs`
- Modify later: `apps/frontend/src/components/master/ProdLineTab.tsx`
- Modify later: `apps/frontend/src/app/(authenticated)/master/prod-line/components/ProdLineFieldHelp.tsx`
- Modify later: `apps/frontend/src/config/menuConfig.ts`

- [ ] **Step 1: Write a failing structure test**

Read the component and help metadata. Assert:

```js
for (const field of ['processCode', 'resourceType', 'parentLineCode']) {
  assert.match(component, new RegExp(`accessorKey: "${field}"`));
  assert.match(help, new RegExp(`${field}:`));
}
assert.ok(component.indexOf('accessorKey: "lineStatus"') < component.indexOf('accessorKey: "processCode"'));
assert.ok(component.indexOf('accessorKey: "processCode"') < component.indexOf('accessorKey: "resourceType"'));
assert.ok(component.indexOf('accessorKey: "resourceType"') < component.indexOf('accessorKey: "parentLineCode"'));
```

Also assert the form contains `FieldSelect` controls for all three fields, the create defaults include `SMT` and `LINE`, the parent options exclude `formData.lineCode`, and the SQL help string lists all three columns. Menu behavior is deliberately tested separately in Task 6 so this UI test can complete a RED→GREEN cycle independently.

- [ ] **Step 2: Run the focused frontend test and verify RED**

```bash
pnpm --filter @eunsung/frontend exec node --test 'src/app/(authenticated)/master/prod-line/prod-line-oee-fields.eunsung.structure.test.mjs'
```

Expected: FAIL because the production-line UI lacks the fields and the menu is still registered.

- [ ] **Step 3: Commit the failing frontend test**

```bash
git add 'apps/frontend/src/app/(authenticated)/master/prod-line/prod-line-oee-fields.eunsung.structure.test.mjs'
git commit -m "test: specify production line OEE controls"
```

### Task 5: Implement the production-line UI

**Files:**
- Modify: `apps/frontend/src/components/master/ProdLineTab.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/master/prod-line/components/ProdLineFieldHelp.tsx`
- Modify: `apps/frontend/src/locales/ko.json`
- Modify: `apps/frontend/src/locales/en.json`
- Modify: `apps/frontend/src/locales/vi.json`
- Modify: `apps/frontend/src/locales/zh.json`

- [ ] **Step 1: Extend the frontend data contract and option lists**

Add nullable `processCode`, `resourceType`, and `parentLineCode` to `ProdLine`, include them in `toPayload`, and define translated options for `SMT/ASSY` and `LINE/CELL`. Derive parent options with `useMemo` from the already tenant-scoped `lines`, excluding `formData.lineCode`; labels use `lineCode · lineName`.

- [ ] **Step 2: Implement deterministic form transitions**

Initialize create with `processCode: 'SMT'`, `resourceType: 'LINE'`, and an empty parent until the user types the new line code. When line code changes under `LINE`, update parent to the same value. When OEE type becomes `LINE`, set parent to self; when it becomes `CELL`, clear a self/invalid parent. Disable the parent select for `LINE`, require it for `CELL`, and include the same rule in the save-button/handler guard.

- [ ] **Step 3: Add form controls and grid columns in approved order**

Immediately after the product/status pair, render worksite and OEE-type selects, then render the parent-line select using a two-column-span wrapper so all three are visually grouped. Immediately after the `lineStatus` grid column add `processCode`, `resourceType`, and `parentLineCode`; render translated names for the two code fields and `-` for legacy nulls. Add the three columns to the displayed SQL query.

- [ ] **Step 4: Add field help and four-locale translations**

Map the three fields to `IP_PRODUCT_LINE.PROCESS_CODE`, `.RESOURCE_TYPE`, and `.PARENT_LINE_CODE`. Add `master.prodLine.processCode`, `resourceType`, `parentLineCode`, option-name keys, validation text, and `fieldHelp` entries without changing unrelated translations.

- [ ] **Step 5: Run the focused test and verify GREEN**

Run the Task 4 focused command. Expected: PASS.

- [ ] **Step 6: Commit the UI implementation**

```bash
git add apps/frontend/src/components/master/ProdLineTab.tsx 'apps/frontend/src/app/(authenticated)/master/prod-line/components/ProdLineFieldHelp.tsx' apps/frontend/src/locales/ko.json apps/frontend/src/locales/en.json apps/frontend/src/locales/vi.json apps/frontend/src/locales/zh.json
git commit -m "feat: add OEE controls to production lines"
```

### Task 6: Hide the legacy OEE line-management menu

**Files:**
- Create: `apps/frontend/src/config/oee-resource-menu-hidden.eunsung.structure.test.mjs`
- Modify: `apps/frontend/src/config/menuConfig.ts`
- Regenerate: `apps/backend/src/seeds/menu-config.json`
- Regenerate: `apps/backend/src/modules/menu-categories/utils/default-menu-category-layout.ts`
- Regenerate: `apps/backend/src/modules/menu-categories/utils/menu-code-validator.ts`

- [ ] **Step 1: Write and run the failing hidden-menu test**

Read `menuConfig.ts`, the three generated backend menu artifacts, and `apps/frontend/src/app/(authenticated)/oee/master/resource/page.tsx`. Assert `OEE_MST_RESOURCE` is absent from registration sources/artifacts while the legacy page still contains its existing OEE resource API/table reference. Run:

```bash
pnpm --filter @eunsung/frontend exec node --test src/config/oee-resource-menu-hidden.eunsung.structure.test.mjs
```

Expected: FAIL because the menu is still registered.

- [ ] **Step 2: Remove only the navigation entry**

Delete the `OEE_MST_RESOURCE` child from `menuConfig.ts` and add a nearby dated comment stating that production-line management replaces the menu while the direct route remains pending later deletion. Do not delete `apps/frontend/src/app/(authenticated)/oee/master/resource/page.tsx`, its backend controller/service, or any `OEE_RESOURCE` SQL.

- [ ] **Step 3: Regenerate menu artifacts**

```bash
pnpm --filter @eunsung/frontend gen:menu
```

Expected: `OEE_MST_RESOURCE` disappears from the three generated backend registration files while the legacy page remains unchanged.

- [ ] **Step 4: Run both focused structure tests and verify GREEN**

Run the Task 4 focused command and the hidden-menu command above. Expected: both PASS.

- [ ] **Step 5: Commit the menu change**

```bash
git add apps/frontend/src/config/oee-resource-menu-hidden.eunsung.structure.test.mjs apps/frontend/src/config/menuConfig.ts apps/backend/src/seeds/menu-config.json apps/backend/src/modules/menu-categories/utils/default-menu-category-layout.ts apps/backend/src/modules/menu-categories/utils/menu-code-validator.ts
git commit -m "chore: hide legacy OEE resource menu"
```

### Task 7: Verify the integrated change

**Files:**
- Verify every file changed in Tasks 1–6.

- [ ] **Step 1: Run focused backend tests**

```bash
pnpm --filter @eunsung/backend test -- --runInBand src/modules/master/prod-line-ddl.spec.ts src/modules/master/dto/prod-line.dto.spec.ts src/modules/master/services/prod-line.service.spec.ts src/modules/master/controllers/prod-line.controller.spec.ts
```

Expected: all tests pass.

- [ ] **Step 2: Run backend typecheck**

```bash
pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false
```

Expected: exit 0.

- [ ] **Step 3: Run frontend registry/structure tests and typecheck**

```bash
pnpm --filter @eunsung/frontend test
pnpm --filter @eunsung/frontend typecheck
```

Expected: menu artifacts regenerate without a diff, every structure test passes, and TypeScript exits 0.

- [ ] **Step 4: Confirm scope and patch integrity**

```bash
git diff --check <base-sha>..HEAD
git diff --name-only <base-sha>..HEAD
git grep -n OEE_MST_RESOURCE -- apps/frontend/src/config/menuConfig.ts apps/backend/src/seeds/menu-config.json apps/backend/src/modules/menu-categories/utils/default-menu-category-layout.ts apps/backend/src/modules/menu-categories/utils/menu-code-validator.ts
git diff <base-sha>..HEAD -- oracle_db_scripts/oee apps/backend/src/modules/oee apps/backend/src/entities/oee-resource.entity.ts 'apps/frontend/src/app/(authenticated)/oee/master/resource'
```

Expected: no whitespace errors, the menu grep has no matches, and OEE resource/runtime files have no diff.

- [ ] **Step 5: Verify Oracle, API, and rendered UI when available**

Re-query the Oracle catalog and confirm the three columns/two constraints. Check ports `3100` and `3003` without starting servers. If both are already running, use the authenticated browser session to verify: new registration defaults; `LINE` parent=self; `CELL` requires another line; saved values reload in the grid; code names display; and OEE line management is absent from navigation. If servers are stopped, report runtime verification as not performed and do not start them.

- [ ] **Step 6: Final commit only if verification generated tracked changes**

```bash
git status --short
```

If verification regenerated legitimate tracked artifacts, review and commit only those files. Otherwise do not create an empty commit.
