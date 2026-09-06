# Move OEE Master Menus Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Move the standard-time and two equipment-downtime master menus from OEE management to the approved location and order under master data.

**Architecture:** Treat `apps/frontend/src/config/menuConfig.ts` as the only editable menu source. Preserve each leaf's code, label key, and route while moving the three objects between category child arrays, then regenerate all backend menu-registration artifacts with the existing generator.

**Tech Stack:** TypeScript configuration, Node structure tests, pnpm menu generator, Next.js page registry.

---

## File map

- Create `apps/frontend/src/config/oee-master-menu-category.eunsung.structure.test.mjs`: enforce category, order, and preserved leaf contracts.
- Modify `apps/frontend/src/config/menuConfig.ts`: move the three existing leaf objects.
- Regenerate `apps/backend/src/seeds/menu-config.json`: synchronize category membership.
- Regenerate `apps/backend/src/modules/menu-categories/utils/default-menu-category-layout.ts`: synchronize default layout.
- Regenerate `apps/backend/src/modules/menu-categories/utils/menu-code-validator.ts`: regenerate without changing the preserved valid codes.

### Task 1: Specify the category and ordering contract

**Files:**
- Create: `apps/frontend/src/config/oee-master-menu-category.eunsung.structure.test.mjs`
- Modify later: `apps/frontend/src/config/menuConfig.ts`

- [ ] **Step 1: Record the implementation baseline**

```bash
git rev-parse HEAD
```

Record the exact output as `<base-sha>` in the execution notes. Final scope and whitespace checks use `<base-sha>..HEAD` so committed task changes remain visible.

- [ ] **Step 2: Write the failing structure test**

Read `menuConfig.ts` and parse its exported array with the same data-only algorithm as `scripts/gen-menu-registration.mjs`: find `export const menuConfig`, locate the `=` and following `[`, scan characters while tracking bracket depth until the matching `]`, remove `icon: <identifier>`, and evaluate the remaining literal with `new Function`. Select categories from the resulting array by exact `code`; do not use a regular expression to infer nested category boundaries.

Assert the exact objects remain in `MASTER.children` and are absent from `OEE.children`:

```js
const movedLeaves = [
  { code: 'OEE_MST_STD_TIME', labelKey: 'menu.oee.standardTime', path: '/oee/master/standard-time' },
  { code: 'OEE_MST_IDLE_REASON', labelKey: 'menu.oee.idleReason', path: '/oee/master/idle-reason' },
  { code: 'OEE_MST_EQUIP_REASON', labelKey: 'menu.oee.equipReason', path: '/oee/master/equip-reason-map' },
];
for (const leaf of movedLeaves) {
  assert.deepEqual(master.children.find((item) => item.code === leaf.code), leaf);
  assert.equal(oee.children.some((item) => item.code === leaf.code), false);
}
const codes = master.children.map((item) => item.code);
const start = codes.indexOf('EQUIP_MASTER');
assert.deepEqual(codes.slice(start, start + 5), [
  'EQUIP_MASTER',
  'OEE_MST_STD_TIME',
  'OEE_MST_IDLE_REASON',
  'OEE_MST_EQUIP_REASON',
  'MST_PROCESS',
]);
```

- [ ] **Step 3: Run the focused test and verify RED**

```bash
pnpm --filter @eunsung/frontend exec node --test src/config/oee-master-menu-category.eunsung.structure.test.mjs
```

Expected: FAIL because all three leaves are still in the OEE category.

- [ ] **Step 4: Commit the failing test**

```bash
git add apps/frontend/src/config/oee-master-menu-category.eunsung.structure.test.mjs
git commit -m "test: specify OEE master menu placement"
```

### Task 2: Move the menu leaves and regenerate registrations

**Files:**
- Modify: `apps/frontend/src/config/menuConfig.ts`
- Regenerate: `apps/backend/src/seeds/menu-config.json`
- Regenerate: `apps/backend/src/modules/menu-categories/utils/default-menu-category-layout.ts`
- Regenerate: `apps/backend/src/modules/menu-categories/utils/menu-code-validator.ts`

- [ ] **Step 1: Move the existing objects without changing their contracts**

Cut the three leaf objects from the `OEE.children` array and insert them in `MASTER.children` immediately after `EQUIP_MASTER` and before `MST_PROCESS`, in this order: standard time, downtime reason code, equipment-reason mapping. Do not copy or rename them.

- [ ] **Step 2: Regenerate backend menu artifacts**

```bash
pnpm --filter @eunsung/frontend gen:menu
```

Expected: the generated `MASTER` child list contains the three codes in the approved order; `OEE` no longer contains them; the known-code validator still contains each code exactly once.

- [ ] **Step 3: Run the focused test and verify GREEN**

Run the Task 1 focused command. Expected: PASS.

- [ ] **Step 4: Commit the menu move**

```bash
git add apps/frontend/src/config/menuConfig.ts apps/backend/src/seeds/menu-config.json apps/backend/src/modules/menu-categories/utils/default-menu-category-layout.ts apps/backend/src/modules/menu-categories/utils/menu-code-validator.ts
git commit -m "feat: move OEE master menus to master data"
```

### Task 3: Verify integration and scope

**Files:**
- Verify all files changed in Tasks 1–2.

- [ ] **Step 1: Run the complete frontend structure suite**

```bash
pnpm --filter @eunsung/frontend test
```

Expected: all structure tests pass and the page/menu registration reports success.

- [ ] **Step 2: Run frontend typecheck**

```bash
pnpm --filter @eunsung/frontend typecheck
```

Expected: exit 0.

- [ ] **Step 3: Confirm generated artifacts and limited scope**

```bash
git diff --check <base-sha>..HEAD
git status --short
git diff --name-only <base-sha>..HEAD
```

Expected: only the new structure test, menu source, three generated backend artifacts, and the already approved spec/plan commits differ from the recorded baseline. No page, API, locale, or Oracle file changes are present.

- [ ] **Step 4: Verify the rendered navigation when available**

Check ports 3100 and 3003 without starting servers. If the merged code is already served, confirm the three labels appear under 기준정보 in the approved order, disappear from OEE 관리, and navigate to the unchanged URLs. Otherwise report that runtime verification was not performed.
