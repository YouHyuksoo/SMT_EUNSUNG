# Process Grid Height and Button Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Change the process/assigned-equipment vertical split from 60:40 to 56:44 and make the assigned-equipment button match the process-add button.

**Architecture:** Adjust only the page-level CSS Grid row ratio and the lower toolbar button classes. Reuse the existing `Button size="sm"` and `Plus` icon contract from `ProcessList`; do not change shared components, data flow, APIs, or translations.

**Tech Stack:** React 19, Next.js 16, TypeScript, Tailwind CSS 4, Node test runner

---

### Task 1: Define the new sizing contract with failing tests

**Files:**
- Modify: `apps/frontend/src/app/(authenticated)/master/process/process-upload.eunsung.structure.test.mjs`
- Modify: `apps/frontend/src/app/(authenticated)/master/process/process-equipment-toolbar-layout.eunsung.structure.test.mjs`

- [ ] **Step 1: Change the vertical-layout assertion**

Replace the old `3fr:2fr` expectation with:

```js
assert.match(page, /grid-rows-\[minmax\(0,14fr\)_minmax\(220px,11fr\)\]/);
assert.doesNotMatch(page, /grid-rows-\[minmax\(0,3fr\)_minmax\(220px,2fr\)\]/);
```

- [ ] **Step 2: Change the lower-button assertions to match `ProcessList`**

Require both source files to contain the same button and icon contracts:

```js
const buttonPattern = /<Button size="sm" onClick=\{onAdd\}>/;
const iconPattern = /<Plus className="w-4 h-4 mr-1" \/>/;
assert.match(list, buttonPattern);
assert.match(equipmentGrid, buttonPattern);
assert.match(list, iconPattern);
assert.match(equipmentGrid, iconPattern);
assert.doesNotMatch(equipmentGrid, /!h-7|!px-2|!text-xs/);
```

Update the focused toolbar test to require `<Button size="sm" onClick={onAdd}>` and remove its old `!h-7` expectation while retaining button-before-title and count assertions.

- [ ] **Step 3: Run process tests to verify RED**

Run:

```bash
pnpm --filter @eunsung/frontend exec node --test 'src/app/(authenticated)/master/process/*.structure.test.mjs'
```

Expected: FAIL because the page still uses `3fr:2fr` and the lower button still has compact overrides.

- [ ] **Step 4: Commit the failing tests**

```bash
git add 'apps/frontend/src/app/(authenticated)/master/process/process-upload.eunsung.structure.test.mjs' 'apps/frontend/src/app/(authenticated)/master/process/process-equipment-toolbar-layout.eunsung.structure.test.mjs'
git commit -m "test: specify process grid sizing"
```

### Task 2: Apply the 56:44 split and matching button size

**Files:**
- Modify: `apps/frontend/src/app/(authenticated)/master/process/page.tsx:375`
- Modify: `apps/frontend/src/app/(authenticated)/master/process/components/ProcessEquipGrid.tsx:146-149`

- [ ] **Step 1: Change the vertical split**

Replace:

```tsx
grid-rows-[minmax(0,3fr)_minmax(220px,2fr)]
```

with:

```tsx
grid-rows-[minmax(0,14fr)_minmax(220px,11fr)]
```

- [ ] **Step 2: Match the process-add button contract**

Replace the lower toolbar button and icon with:

```tsx
<Button size="sm" onClick={onAdd}>
  <Plus className="w-4 h-4 mr-1" />
  {t("master.process.assignEquipment", "설비 배치")}
</Button>
```

Keep the surrounding `toolbarLeft` block and button→title order unchanged.

- [ ] **Step 3: Run focused process tests to verify GREEN**

Run:

```bash
pnpm --filter @eunsung/frontend exec node --test 'src/app/(authenticated)/master/process/*.structure.test.mjs'
```

Expected: all process structure tests PASS.

- [ ] **Step 4: Run full frontend verification**

Run sequentially:

```bash
pnpm --filter @eunsung/frontend test
pnpm --filter @eunsung/frontend typecheck
```

Expected: all tests and typecheck PASS.

- [ ] **Step 5: Verify the rendered screen when available**

If the user-run development servers and authenticated browser are available, open 공정관리 and confirm the upper/lower visual split and matching button sizes. Do not start a server automatically.

- [ ] **Step 6: Commit the implementation**

```bash
git add 'apps/frontend/src/app/(authenticated)/master/process/page.tsx' 'apps/frontend/src/app/(authenticated)/master/process/components/ProcessEquipGrid.tsx'
git commit -m "fix: rebalance process management grids"
```
