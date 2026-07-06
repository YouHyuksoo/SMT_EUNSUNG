# FCT Inspection Monitoring Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the selected production quality control dashboard for FCT inspection analysis on `/display/42`.

**Architecture:** Add a focused query module for FCT aggregation, a Next.js API route for `/api/display/42`, and a display screen component tree matching the existing SPI/AOI chart pattern. Reuse the existing display shell and menu card registration.

**Tech Stack:** Next.js App Router, TypeScript, Oracle `oracledb`, SWR, Recharts, Tailwind CSS.

---

### Task 1: FCT SQL and API

**Files:**
- Create: `src/lib/queries/fct-chart.ts`
- Create: `src/app/api/display/42/route.ts`
- Modify: `src/lib/queries/sql-registry.ts`

- [ ] Add SQL builders for today-by-model, 7-day trend, today summary, and weekly top models.
- [ ] Join `IQ_MACHINE_INSPECT_DATA_FCT` to `IP_PRODUCT_2D_BARCODE` on `SERIAL_NO = PID`.
- [ ] Treat `GOOD`, `OK`, `PASS`, `P`, `Y`, `TRUE`, `1` as pass values.
- [ ] Use parsed `INSPECT_DATE`, falling back to `ENTER_DATE`.
- [ ] Register the screen SQL for SQL viewer.

### Task 2: FCT Display Components

**Files:**
- Create: `src/components/display/screens/fct-chart/FctChartStatus.tsx`
- Create: `src/components/display/screens/fct-chart/ChartCard.tsx`
- Create: `src/components/display/screens/fct-chart/DefectByModelChart.tsx`
- Create: `src/components/display/screens/fct-chart/FpyTrendChart.tsx`
- Create: `src/components/display/screens/fct-chart/DefectRatePanel.tsx`
- Create: `src/components/display/screens/fct-chart/TopDefectModelChart.tsx`
- Modify: `src/app/(display)/display/[screenId]/page.tsx`

- [ ] Render the selected 2x2 dashboard.
- [ ] Poll using existing display timing and SWR helper.
- [ ] Keep Korean chart labels focused for the BJ monitoring clone.
- [ ] Route screen `42` to the FCT component.

### Task 3: Verification

**Files:**
- No source files expected.

- [ ] Run `npx tsc --noEmit`.
- [ ] Start or reuse the local Next server.
- [ ] Call `/api/display/42` and confirm JSON shape.
- [ ] Open `/display/42` in the browser if the server is available.
