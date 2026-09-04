# Optional Machine Work Result Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Allow OEE work results to be saved without selecting equipment while preserving the work order process code.

**Architecture:** Keep the existing work-result screen and API shape, but make only `machineCode` optional end-to-end. Normalize an absent or blank equipment code to Oracle `NULL` in the service while continuing to require and persist `workstageCode`.

**Tech Stack:** Next.js 16, React 19, TypeScript, NestJS 11, class-validator, TypeORM/Oracle, Node structure tests, Jest.

---

### Task 1: Specify the optional-equipment frontend contract behavior

**Files:**
- Create: `apps/frontend/src/app/(authenticated)/oee/equip-work-result/equip-work-result-optional-machine.eunsung.structure.test.mjs`
- Modify later: `apps/frontend/src/app/(authenticated)/oee/equip-work-result/page.tsx`

- [ ] **Step 1: Write the failing structure test**

Add a Node structure test that reads `page.tsx` and asserts all of the following:

```js
assert.doesNotMatch(source, /if \(!form\.machineCode\) return toast\.error\('설비를 선택하세요'\)/);
assert.doesNotMatch(source, /설비선택 <span className="text-red-500">\*<\/span>/);
assert.match(source, /machineCode: form\.machineCode \|\| undefined/);
assert.match(source, /workstageCode: form\.workstageCode/);
```

- [ ] **Step 2: Run the focused frontend test and verify RED**

Run:

```bash
pnpm --filter @eunsung/frontend exec node --test 'src/app/(authenticated)/oee/equip-work-result/equip-work-result-optional-machine.eunsung.structure.test.mjs'
```

Expected: FAIL because the existing page still blocks blank equipment, shows the required marker, and sends the raw empty string.

- [ ] **Step 3: Commit the failing frontend test**

```bash
git add 'apps/frontend/src/app/(authenticated)/oee/equip-work-result/equip-work-result-optional-machine.eunsung.structure.test.mjs'
git commit -m "test: specify optional equipment work results"
```

### Task 2: Specify the optional-equipment backend contract

**Files:**
- Modify: `apps/backend/src/modules/work-result/work-result.service.spec.ts`
- Create: `apps/backend/src/modules/work-result/work-result.dto.spec.ts`
- Modify later: `apps/backend/src/modules/work-result/work-result.dto.ts`
- Modify later: `apps/backend/src/modules/work-result/work-result.service.ts`

- [ ] **Step 1: Write a failing DTO validation test**

Instantiate `WorkResultUpsertDto` with `runNo`, `workstageCode`, `resultQty`, and `resultStatus`, leaving out `machineCode`. Use `validateSync` and assert that no validation error targets `machineCode`. Keep a second assertion that an omitted `workstageCode` still fails.

- [ ] **Step 2: Write failing service bind tests for create and update**

Extend the existing transaction mock test to call `upsertResult` without `machineCode`. Locate the `INSERT INTO IP_PRODUCT_SENSOR_ACTUAL` and `UPDATE IP_PRODUCT_RUN_CARD` calls and assert:

```ts
expect(insertCall?.[1]?.[3]).toBeNull();
expect(insertCall?.[1]?.[4]).toBe('WS-1');
expect(runCardCall?.[1]?.[0]).toBeNull();
expect(runCardCall?.[1]?.[1]).toBe('WS-1');
```

The bind indexes reflect the existing SQL parameter order.

Add a second test with `seqNo` present and whitespace-only `machineCode: '   '`. Make the transaction query mock return `[{ st: 'N' }]` for the current-status SELECT, then locate `UPDATE IP_PRODUCT_SENSOR_ACTUAL` and its following run-card write-back. Assert:

```ts
expect(sensorUpdateCall?.[1]?.[0]).toBeNull();
expect(sensorUpdateCall?.[1]?.[1]).toBe('WS-1');
expect(runCardCall?.[1]?.[0]).toBeNull();
expect(runCardCall?.[1]?.[1]).toBe('WS-1');
```

Together the two tests prove omitted values on INSERT and blank/whitespace values on UPDATE use the same normalization while preserving the process code.

- [ ] **Step 3: Run focused backend tests and verify RED**

Run:

```bash
pnpm --filter @eunsung/backend test -- --runInBand src/modules/work-result/work-result.dto.spec.ts src/modules/work-result/work-result.service.spec.ts
```

Expected: FAIL because DTO validation requires `machineCode` and the service does not explicitly normalize it to `null`.

- [ ] **Step 4: Commit the failing backend tests**

```bash
git add apps/backend/src/modules/work-result/work-result.dto.spec.ts apps/backend/src/modules/work-result/work-result.service.spec.ts
git commit -m "test: require nullable equipment binds for work results"
```

### Task 3: Implement the optional-equipment contract

**Files:**
- Modify: `apps/frontend/src/app/(authenticated)/oee/equip-work-result/page.tsx`
- Modify: `apps/backend/src/modules/work-result/work-result.dto.ts`
- Modify: `apps/backend/src/modules/work-result/work-result.service.ts`

- [ ] **Step 1: Remove the frontend required behavior**

Delete the blank-equipment early return and the required `*` beside `설비선택`. Construct the payload with:

```ts
machineCode: form.machineCode || undefined,
workstageCode: form.workstageCode,
```

Do not change other field validation or completed-result locking.

- [ ] **Step 2: Make only the DTO equipment code optional**

Change the field to:

```ts
@IsOptional() @IsString() machineCode?: string;
```

Keep `workstageCode` required.

- [ ] **Step 3: Normalize the equipment code once in the service**

At the start of the transaction callback define:

```ts
const machineCode = dto.machineCode?.trim() || null;
```

Use `machineCode` in both sensor-actual insert/update binds and the run-card write-back bind. Continue using `dto.workstageCode` unchanged.

- [ ] **Step 4: Run focused tests and verify GREEN**

Run both Task 1 and Task 2 focused commands. Expected: all pass.

- [ ] **Step 5: Commit the implementation**

```bash
git add 'apps/frontend/src/app/(authenticated)/oee/equip-work-result/page.tsx' apps/backend/src/modules/work-result/work-result.dto.ts apps/backend/src/modules/work-result/work-result.service.ts
git commit -m "fix: allow work results without equipment"
```

### Task 4: Verify the integrated change

**Files:**
- Verify all files changed in Tasks 1–3.

- [ ] **Step 1: Run the full frontend structure suite**

```bash
pnpm --filter @eunsung/frontend test
```

Expected: all tests pass.

- [ ] **Step 2: Run frontend typecheck**

```bash
pnpm --filter @eunsung/frontend typecheck
```

Expected: exit 0.

- [ ] **Step 3: Run work-result backend tests**

```bash
pnpm --filter @eunsung/backend test -- --runInBand src/modules/work-result/work-result.dto.spec.ts src/modules/work-result/work-result.service.spec.ts src/modules/work-result/work-result.controller.spec.ts
```

Expected: all tests pass.

- [ ] **Step 4: Run backend typecheck**

```bash
pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false
```

Expected: exit 0.

- [ ] **Step 5: Check patch integrity and runtime availability**

```bash
git diff --check
lsof -nP -iTCP:3100 -sTCP:LISTEN
lsof -nP -iTCP:3003 -sTCP:LISTEN
```

If both servers are already running, verify an authenticated blank-equipment save through the rendered screen and API. If stopped, report that runtime/Oracle verification was not performed; do not start servers.
