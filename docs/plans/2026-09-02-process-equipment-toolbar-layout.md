# Process Equipment Toolbar Layout Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Move the assigned-equipment action and title/count into the DataGrid toolbar, ordered button then title, at the same height as the fullscreen control.

**Architecture:** Reuse DataGrid's existing `toolbarLeft` extension point so the custom controls share the built-in single-row toolbar with export and fullscreen controls. Remove the redundant card header only from `ProcessEquipGrid`; do not change the shared DataGrid, APIs, state, or translations.

**Tech Stack:** React 19, Next.js 16, TypeScript, Tailwind CSS 4, Node test runner

---

### Task 1: Lock the toolbar composition with a failing structure test

**Files:**
- Create: `apps/frontend/src/app/(authenticated)/master/process/process-equipment-toolbar-layout.eunsung.structure.test.mjs`
- Test: `apps/frontend/src/app/(authenticated)/master/process/process-equipment-toolbar-layout.eunsung.structure.test.mjs`

- [ ] **Step 1: Write the failing test**

Create a source structure test that reads `components/ProcessEquipGrid.tsx`, extracts the explicitly marked toolbar block, and asserts:

```js
const toolbar = grid.match(/\/\* assigned-equipment-toolbar:start \*\/[\s\S]*?\/\* assigned-equipment-toolbar:end \*\//)?.[0] ?? "";
assert.ok(toolbar, "assigned equipment toolbar block must exist");
assert.match(toolbar, /toolbarLeft=\{/);
assert.match(toolbar, /<Button[^>]*className="!h-7 flex-shrink-0 !px-2 !text-xs"[^>]*onClick=\{onAdd\}/);
assert.ok(toolbar.indexOf("assignEquipment") < toolbar.indexOf("assignedEquipments"));
assert.match(toolbar, /\{equipments\.length\}\{t\("common\.count"/);
assert.doesNotMatch(grid, /className="px-4 pt-3 pb-1 border-b border-border flex-shrink-0"/);
```

These assertions delimit the exact `toolbarLeft` block, fix the button → title/count order, require the compact important height override, and prevent the old standalone card header from returning.

- [ ] **Step 2: Run the test to verify RED**

Run:

```bash
pnpm --filter @eunsung/frontend exec node --test 'src/app/(authenticated)/master/process/process-equipment-toolbar-layout.eunsung.structure.test.mjs'
```

Expected: FAIL because `ProcessEquipGrid` has no `toolbarLeft` and still renders the standalone header.

- [ ] **Step 3: Commit the failing test**

```bash
git add 'apps/frontend/src/app/(authenticated)/master/process/process-equipment-toolbar-layout.eunsung.structure.test.mjs'
git commit -m "test: specify process equipment toolbar layout"
```

### Task 2: Move the action and title into the DataGrid toolbar

**Files:**
- Modify: `apps/frontend/src/app/(authenticated)/master/process/components/ProcessEquipGrid.tsx:132-160`
- Test: `apps/frontend/src/app/(authenticated)/master/process/process-equipment-toolbar-layout.eunsung.structure.test.mjs`

- [ ] **Step 1: Remove the standalone card header**

Delete the wrapper beginning with:

```tsx
<div className="px-4 pt-3 pb-1 border-b border-border flex-shrink-0">
```

Keep the card and `CardContent` sizing behavior unchanged.

- [ ] **Step 2: Add the ordered DataGrid `toolbarLeft` content**

Pass the following element to `DataGrid`:

```tsx
toolbarLeft={
  /* assigned-equipment-toolbar:start */
  <div className="flex min-w-0 items-center gap-2">
    <Button size="sm" className="!h-7 flex-shrink-0 !px-2 !text-xs" onClick={onAdd}>
      <Plus className="mr-1 h-3.5 w-3.5" />
      {t("master.process.assignEquipment", "설비 배치")}
    </Button>
    <h3 className="flex min-w-0 items-center gap-2 text-sm font-semibold text-text">
      <Monitor className="h-4 w-4 flex-shrink-0 text-primary" />
      <span className="whitespace-nowrap">{t("master.process.assignedEquipments")}</span>
      <span className="truncate font-normal text-text-muted">
        - {processCode} ({processName}) · {equipments.length}{t("common.count", { defaultValue: "건" })}
      </span>
    </h3>
  </div>
  /* assigned-equipment-toolbar:end */
}
```

This keeps the assign button first, the title/count second, and the built-in export/fullscreen actions on the right side of the same toolbar.

- [ ] **Step 3: Run the focused test to verify GREEN**

Run:

```bash
pnpm --filter @eunsung/frontend exec node --test 'src/app/(authenticated)/master/process/process-equipment-toolbar-layout.eunsung.structure.test.mjs'
```

Expected: PASS.

- [ ] **Step 4: Run existing process structure tests**

Run:

```bash
pnpm --filter @eunsung/frontend exec node --test 'src/app/(authenticated)/master/process/*.structure.test.mjs'
```

Expected: all process structure tests PASS. If the existing compact-header assertion describes the intentionally removed header, update only that assertion to require the new `toolbarLeft` composition.

- [ ] **Step 5: Run frontend verification**

Run:

```bash
pnpm --filter @eunsung/frontend test
pnpm --filter @eunsung/frontend typecheck
```

Expected: all tests and typecheck PASS.

- [ ] **Step 6: Verify the rendered layout when available**

If the user-run development servers and authenticated browser session are available, open 공정관리, select a process, and confirm that the assign button and title/count appear on the DataGrid toolbar's left side at the same vertical position as the fullscreen button, with both buttons at `h-7`. If unavailable, report that limitation without starting a server.

- [ ] **Step 7: Commit the implementation**

```bash
git add 'apps/frontend/src/app/(authenticated)/master/process/components/ProcessEquipGrid.tsx' 'apps/frontend/src/app/(authenticated)/master/process/process-equipment-toolbar-layout.eunsung.structure.test.mjs'
git commit -m "fix: align process equipment toolbar controls"
```
