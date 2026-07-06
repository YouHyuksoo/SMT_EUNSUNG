# display/21 제품생산현황 재구성 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** display/21을 IRPT_PRODUCT_LINE_MONITORING 기반 테이블 + 달성률 바 차트 화면으로 완전 재구성한다.

**Architecture:** API Route에서 IRPT_PRODUCT_LINE_MONITORING 전체 조회 → 클라이언트에서 달성률 계산 → 좌측 테이블 + 우측 CSS 수평 바 차트 렌더링. `useDisplayTiming()` 훅으로 갱신 주기 연동.

**Tech Stack:** Next.js 15 App Router, TypeScript, Tailwind CSS 4, SWR, next-intl

---

## File Map

### 삭제 대상
- `src/components/display/screens/assy-production/AssyProductionStatus.tsx`
- `src/components/display/screens/assy-production/AssyProductionGrid.tsx`
- `src/lib/queries/assy-production-status.ts`

### 수정 대상
- `src/app/api/display/21/route.ts` — IRPT_PRODUCT_LINE_MONITORING 기반으로 전면 교체
- `src/app/(display)/display/[screenId]/page.tsx` — import 교체 (AssyProductionStatus → ProductionLineStatus)
- `src/lib/queries/sql-registry.ts` — screen '21' 쿼리 정보 업데이트
- `src/components/display/shared/status-styles.ts` — 라인 달성률 색상 함수 추가

### 신규 생성
- `src/lib/queries/product-line-monitoring.ts` — SQL 쿼리
- `src/components/display/screens/product-line/ProductionLineStatus.tsx` — 메인 컴포넌트
- `src/components/display/screens/product-line/ProductionLineTable.tsx` — 테이블
- `src/components/display/screens/product-line/ProductionLineChart.tsx` — CSS 바 차트

---

## Task 1: 기존 파일 삭제

**Files:**
- Delete: `src/components/display/screens/assy-production/AssyProductionStatus.tsx`
- Delete: `src/components/display/screens/assy-production/AssyProductionGrid.tsx`
- Delete: `src/lib/queries/assy-production-status.ts`

- [ ] **Step 1: 기존 Assy 컴포넌트 및 쿼리 파일 삭제**

```bash
rm src/components/display/screens/assy-production/AssyProductionStatus.tsx
rm src/components/display/screens/assy-production/AssyProductionGrid.tsx
rmdir src/components/display/screens/assy-production
rm src/lib/queries/assy-production-status.ts
```

- [ ] **Step 2: sql-registry.ts에서 assy-production-status import 제거 및 screen '21' 쿼리 임시 교체**

`src/lib/queries/sql-registry.ts` 상단 import 라인 중 아래 줄 제거:
```typescript
import { sqlAssyProductionList } from './assy-production-status';
```

그리고 SCREEN_SQL_BUILDERS 내 '21' 항목을 임시 placeholder로 교체 (Task 3에서 최종 교체):
```typescript
'21': () => ({
  screenId: '21',
  title: 'Product Line Monitoring',
  queries: [],
}),
```

- [ ] **Step 3: page.tsx에서 AssyProductionStatus 제거**

`src/app/(display)/display/[screenId]/page.tsx`에서 아래 import 제거:
```typescript
import AssyProductionStatus from '@/components/display/screens/assy-production/AssyProductionStatus';
```

그리고 아래 블록 제거:
```typescript
if (screenId === '21') {
  return <AssyProductionStatus screenId={screenId} />;
}
```

- [ ] **Step 4: 빌드 에러 없는지 확인**

```bash
npm run build 2>&1 | tail -30
```

Expected: assy-production 관련 에러 없음 (display/21은 일시적으로 DisplayPlaceholder 렌더링)

---

## Task 2: SQL 쿼리 파일 작성

**Files:**
- Create: `src/lib/queries/product-line-monitoring.ts`

- [ ] **Step 1: 쿼리 파일 생성**

```typescript
/**
 * @file product-line-monitoring.ts
 * @description 제품생산현황(메뉴 21) SQL 쿼리.
 * 초보자 가이드: IRPT_PRODUCT_LINE_MONITORING 뷰에서 라인별 생산 모니터링 데이터를 조회한다.
 * RUNNING_LOT_INPUT_QTY는 BJVNSMT_E에서 항상 null이므로 제외.
 */

export const SQL_PRODUCT_LINE_MONITORING = `
SELECT
  LINE_NAME,
  LINE_CODE,
  LINE_STATUS,
  MODEL_NAME,
  PRODUCT_RUN_TYPE,
  RUN_DATE,
  ACTUAL_DATE,
  RUNNING_LOT_PLAN_QTY,
  RUNNING_LOT_ACTUAL_QTY,
  RUNNING_LOT_NG_QTY
FROM IRPT_PRODUCT_LINE_MONITORING
ORDER BY LINE_CODE
`;
```

- [ ] **Step 2: 커밋**

```bash
git add src/lib/queries/product-line-monitoring.ts
git commit -m "feat: add product-line-monitoring SQL query for display/21"
```

---

## Task 3: API Route 교체

**Files:**
- Modify: `src/app/api/display/21/route.ts`
- Modify: `src/lib/queries/sql-registry.ts`

- [ ] **Step 1: route.ts 전면 교체**

`src/app/api/display/21/route.ts` 내용을 아래로 교체:

```typescript
/**
 * @file route.ts
 * @description 제품생산현황 API (메뉴 21).
 * 초보자 가이드: GET /api/display/21 → IRPT_PRODUCT_LINE_MONITORING 전체 라인 조회.
 * 파라미터 없음 — 전체 라인을 항상 반환한다.
 */
import { NextResponse } from 'next/server';
import { executeQuery } from '@/lib/db';
import { SQL_PRODUCT_LINE_MONITORING } from '@/lib/queries/product-line-monitoring';

export async function GET() {
  try {
    const lines = await executeQuery<ProductionLineRow>(SQL_PRODUCT_LINE_MONITORING, {});
    return NextResponse.json({ lines, timestamp: new Date().toISOString() });
  } catch (error) {
    console.error('[API /display/21] Error:', error);
    return NextResponse.json(
      { error: 'Database query failed', lines: [] },
      { status: 500 },
    );
  }
}

interface ProductionLineRow {
  LINE_NAME: string;
  LINE_CODE: string;
  LINE_STATUS: string;
  MODEL_NAME: string | null;
  PRODUCT_RUN_TYPE: string | null;
  RUN_DATE: string | null;
  ACTUAL_DATE: string | null;
  RUNNING_LOT_PLAN_QTY: number | null;
  RUNNING_LOT_ACTUAL_QTY: number | null;
  RUNNING_LOT_NG_QTY: number | null;
}
```

- [ ] **Step 2: sql-registry.ts의 '21' 항목 최종 교체**

`src/lib/queries/sql-registry.ts` 상단에 import 추가:
```typescript
import { SQL_PRODUCT_LINE_MONITORING } from './product-line-monitoring';
```

SCREEN_SQL_BUILDERS의 '21' 항목 교체:
```typescript
'21': () => ({
  screenId: '21',
  title: '제품생산현황 (Line Monitoring)',
  queries: [
    { label: 'Line Monitoring', sql: SQL_PRODUCT_LINE_MONITORING },
  ],
}),
```

- [ ] **Step 3: API 동작 확인**

개발 서버가 실행 중인 상태에서:
```bash
curl "http://localhost:3000/api/display/21"
```

Expected: `{ "lines": [...], "timestamp": "..." }` — lines 배열에 LINE_NAME, LINE_CODE 등 포함

- [ ] **Step 4: 커밋**

```bash
git add src/app/api/display/21/route.ts src/lib/queries/sql-registry.ts
git commit -m "feat: rewrite display/21 API to use IRPT_PRODUCT_LINE_MONITORING"
```

---

## Task 4: 달성률 색상 함수 추가

**Files:**
- Modify: `src/components/display/shared/status-styles.ts`

- [ ] **Step 1: 라인 달성률 색상 함수 추가**

`src/components/display/shared/status-styles.ts` 하단에 아래 추가:

```typescript
/* ─────────────── 라인 달성률 색상 ─────────────── */

/** 라인 달성률 임계값: >= 70 양호, >= 30 주의, < 30 위험 */
const LINE_RATE_GOOD = 70;
const LINE_RATE_WARNING = 30;

/** 달성률에 따른 바/텍스트 색상 — 테이블 셀 및 차트 바 공용 */
export function getLineRateColor(rate: number): { bar: string; text: string } {
  if (rate >= LINE_RATE_GOOD) return { bar: 'bg-emerald-500', text: 'text-emerald-400' };
  if (rate >= LINE_RATE_WARNING) return { bar: 'bg-amber-500', text: 'text-amber-400' };
  return { bar: 'bg-red-500', text: 'text-red-400' };
}

/** LINE_STATUS 뱃지 스타일 */
export function getLineStatusStyle(status: string): { bg: string; text: string; label: string } {
  switch (status) {
    case 'R': return { bg: 'bg-emerald-500/20', text: 'text-emerald-400', label: '가동중' };
    case 'N': return { bg: 'bg-zinc-700/50', text: 'text-zinc-400', label: '미가동' };
    default:  return { bg: 'bg-amber-500/20', text: 'text-amber-400', label: '대기' };
  }
}
```

- [ ] **Step 2: 커밋**

```bash
git add src/components/display/shared/status-styles.ts
git commit -m "feat: add line rate color and status style helpers"
```

---

## Task 5: 타입 정의 파일 작성

**Files:**
- Create: `src/components/display/screens/product-line/types.ts`

- [ ] **Step 1: 타입 파일 생성**

```typescript
/**
 * @file types.ts
 * @description 제품생산현황(메뉴 21) 타입 정의.
 * 초보자 가이드: API 응답 행 타입과 달성률 계산 결과 타입을 정의한다.
 */

/** API /api/display/21 응답 행 타입 */
export interface ProductionLineRow {
  LINE_NAME: string;
  LINE_CODE: string;
  LINE_STATUS: string;
  MODEL_NAME: string | null;
  PRODUCT_RUN_TYPE: string | null;
  RUN_DATE: string | null;
  ACTUAL_DATE: string | null;
  RUNNING_LOT_PLAN_QTY: number | null;
  RUNNING_LOT_ACTUAL_QTY: number | null;
  RUNNING_LOT_NG_QTY: number | null;
}

/** 달성률이 계산된 행 타입 */
export interface ProductionLineRowWithRate extends ProductionLineRow {
  /** 달성률 0~100+ (PLAN=0이면 0) */
  achieveRate: number;
}

/** API /api/display/21 전체 응답 타입 */
export interface ProductionLineApiResponse {
  lines: ProductionLineRow[];
  timestamp: string;
  error?: string;
}
```

- [ ] **Step 2: 커밋**

```bash
git add src/components/display/screens/product-line/types.ts
git commit -m "feat: add ProductionLine types for display/21"
```

---

## Task 6: ProductionLineTable 컴포넌트

**Files:**
- Create: `src/components/display/screens/product-line/ProductionLineTable.tsx`

- [ ] **Step 1: 테이블 컴포넌트 작성**

```typescript
/**
 * @file ProductionLineTable.tsx
 * @description 제품생산현황 라인별 테이블. LINE_NAME/MODEL_NAME/계획/실적/달성률/NG/상태 표시.
 * 초보자 가이드: rows 배열을 받아 테이블 렌더링. 달성률은 부모에서 계산되어 전달된다.
 */
'use client';

import { getLineRateColor, getLineStatusStyle } from '@/components/display/shared/status-styles';
import { fmtNum } from '@/lib/display-helpers';
import type { ProductionLineRowWithRate } from './types';

interface ProductionLineTableProps {
  rows: ProductionLineRowWithRate[];
}

export default function ProductionLineTable({ rows }: ProductionLineTableProps) {
  if (rows.length === 0) {
    return (
      <div className="flex h-full items-center justify-center text-zinc-500">
        데이터 없음
      </div>
    );
  }

  return (
    <div className="h-full overflow-auto">
      <table className="w-full border-collapse text-sm">
        <thead className="sticky top-0 z-10 bg-zinc-900">
          <tr className="border-b border-zinc-700 text-zinc-400">
            <th className="px-3 py-2 text-left">라인</th>
            <th className="px-3 py-2 text-left">모델</th>
            <th className="px-3 py-2 text-right">계획</th>
            <th className="px-3 py-2 text-right">실적</th>
            <th className="px-3 py-2 text-right">달성률</th>
            <th className="px-3 py-2 text-right">NG</th>
            <th className="px-3 py-2 text-center">상태</th>
          </tr>
        </thead>
        <tbody>
          {rows.map((row) => {
            const rateStyle = getLineRateColor(row.achieveRate);
            const statusStyle = getLineStatusStyle(row.LINE_STATUS);
            return (
              <tr
                key={row.LINE_CODE}
                className="border-b border-zinc-800 hover:bg-zinc-800/40"
              >
                <td className="px-3 py-2 font-medium text-zinc-200">{row.LINE_NAME}</td>
                <td className="px-3 py-2 text-zinc-300">{row.MODEL_NAME ?? '-'}</td>
                <td className="px-3 py-2 text-right text-zinc-300">{fmtNum(row.RUNNING_LOT_PLAN_QTY)}</td>
                <td className="px-3 py-2 text-right text-zinc-300">{fmtNum(row.RUNNING_LOT_ACTUAL_QTY)}</td>
                <td className={`px-3 py-2 text-right font-bold ${rateStyle.text}`}>
                  {row.achieveRate.toFixed(1)}%
                </td>
                <td className="px-3 py-2 text-right text-zinc-400">{fmtNum(row.RUNNING_LOT_NG_QTY)}</td>
                <td className="px-3 py-2 text-center">
                  <span className={`rounded-full px-2 py-0.5 text-xs font-medium ${statusStyle.bg} ${statusStyle.text}`}>
                    {statusStyle.label}
                  </span>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
```

- [ ] **Step 2: 커밋**

```bash
git add src/components/display/screens/product-line/ProductionLineTable.tsx
git commit -m "feat: add ProductionLineTable component for display/21"
```

---

## Task 7: ProductionLineChart 컴포넌트

**Files:**
- Create: `src/components/display/screens/product-line/ProductionLineChart.tsx`

- [ ] **Step 1: 차트 컴포넌트 작성**

```typescript
/**
 * @file ProductionLineChart.tsx
 * @description 라인별 달성률 수평 바 차트. 외부 라이브러리 없이 CSS로 구현.
 * 초보자 가이드: rows 배열에서 라인명과 달성률(%)을 받아 수평 바로 시각화한다.
 * 바 색상은 달성률 구간(< 30 빨강 / < 70 노랑 / >= 70 초록)에 따라 결정된다.
 */
'use client';

import { getLineRateColor } from '@/components/display/shared/status-styles';
import type { ProductionLineRowWithRate } from './types';

interface ProductionLineChartProps {
  rows: ProductionLineRowWithRate[];
}

export default function ProductionLineChart({ rows }: ProductionLineChartProps) {
  if (rows.length === 0) {
    return (
      <div className="flex h-full items-center justify-center text-zinc-500">
        차트 데이터 없음
      </div>
    );
  }

  return (
    <div className="flex h-full flex-col gap-2 overflow-auto px-3 py-2">
      <p className="mb-1 text-xs font-semibold uppercase tracking-wider text-zinc-500">
        라인별 달성률
      </p>
      {rows.map((row) => {
        const rateStyle = getLineRateColor(row.achieveRate);
        const barWidth = Math.min(row.achieveRate, 100);
        return (
          <div key={row.LINE_CODE} className="flex flex-col gap-0.5">
            <div className="flex items-center justify-between text-xs">
              <span className="font-medium text-zinc-300">{row.LINE_NAME}</span>
              <span className={`font-bold ${rateStyle.text}`}>
                {row.achieveRate.toFixed(1)}%
              </span>
            </div>
            <div className="h-4 w-full overflow-hidden rounded-full bg-zinc-800">
              <div
                className={`h-full rounded-full transition-all duration-500 ${rateStyle.bar}`}
                style={{ width: `${barWidth}%` }}
              />
            </div>
          </div>
        );
      })}
    </div>
  );
}
```

- [ ] **Step 2: 커밋**

```bash
git add src/components/display/screens/product-line/ProductionLineChart.tsx
git commit -m "feat: add ProductionLineChart CSS bar chart for display/21"
```

---

## Task 8: ProductionLineStatus 메인 컴포넌트

**Files:**
- Create: `src/components/display/screens/product-line/ProductionLineStatus.tsx`

- [ ] **Step 1: 메인 컴포넌트 작성**

```typescript
/**
 * @file ProductionLineStatus.tsx
 * @description 제품생산현황 메인 화면 (메뉴 21). SWR polling + 테이블/차트 레이아웃.
 * 초보자 가이드: API에서 라인별 생산 데이터를 가져와 좌측 테이블 + 우측 달성률 차트에 표시.
 * DisplayLayout이 100vh 프레임을 제공하고, 좌우 패널이 꽉 찬 높이를 차지한다.
 */
'use client';

import useSWR from 'swr';
import DisplayLayout from '../../DisplayLayout';
import ProductionLineTable from './ProductionLineTable';
import ProductionLineChart from './ProductionLineChart';
import useDisplayTiming from '@/hooks/useDisplayTiming';
import { useSyncFooterStatus } from '@/components/providers/FooterProvider';
import { fetcher } from '@/lib/fetcher';
import type { ProductionLineApiResponse, ProductionLineRowWithRate } from './types';
import { useState } from 'react';
import { useTranslations } from 'next-intl';

interface ProductionLineStatusProps {
  screenId: string;
}

/** PLAN_QTY 기반 달성률 계산 (0으로 나누기 방지) */
function calcAchieveRate(actual: number | null, plan: number | null): number {
  if (!plan || plan === 0) return 0;
  return Math.round(((actual ?? 0) / plan) * 1000) / 10; // 소수점 1자리
}

export default function ProductionLineStatus({ screenId }: ProductionLineStatusProps) {
  const t = useTranslations('display');
  const timing = useDisplayTiming();
  const [lastUpdated, setLastUpdated] = useState<Date | null>(null);

  const { data, error, isLoading } = useSWR<ProductionLineApiResponse>(
    '/api/display/21',
    fetcher,
    {
      refreshInterval: timing.refreshSeconds * 1000,
      onSuccess: () => setLastUpdated(new Date()),
    },
  );

  useSyncFooterStatus({ loading: isLoading, lastUpdated });

  const rows: ProductionLineRowWithRate[] = (data?.lines ?? []).map((row) => ({
    ...row,
    achieveRate: calcAchieveRate(row.RUNNING_LOT_ACTUAL_QTY, row.RUNNING_LOT_PLAN_QTY),
  }));

  if (isLoading) {
    return (
      <DisplayLayout screenId={screenId}>
        <div className="flex h-full items-center justify-center text-zinc-400">
          {t('loading')}
        </div>
      </DisplayLayout>
    );
  }

  if (error || data?.error) {
    return (
      <DisplayLayout screenId={screenId}>
        <div className="flex h-full items-center justify-center text-red-400">
          {t('loadError')}
        </div>
      </DisplayLayout>
    );
  }

  return (
    <DisplayLayout screenId={screenId}>
      <div className="flex h-full gap-2 overflow-hidden p-2">
        {/* 좌측: 테이블 60% */}
        <div className="min-h-0 w-3/5 overflow-hidden rounded-lg border border-zinc-800 bg-zinc-900/50">
          <ProductionLineTable rows={rows} />
        </div>
        {/* 우측: 달성률 바 차트 40% */}
        <div className="min-h-0 w-2/5 overflow-hidden rounded-lg border border-zinc-800 bg-zinc-900/50">
          <ProductionLineChart rows={rows} />
        </div>
      </div>
    </DisplayLayout>
  );
}
```

- [ ] **Step 2: 커밋**

```bash
git add src/components/display/screens/product-line/ProductionLineStatus.tsx
git commit -m "feat: add ProductionLineStatus main component for display/21"
```

---

## Task 9: page.tsx 연결

**Files:**
- Modify: `src/app/(display)/display/[screenId]/page.tsx`

- [ ] **Step 1: import 추가 및 라우트 연결**

`src/app/(display)/display/[screenId]/page.tsx` 상단 import 블록에 추가:
```typescript
import ProductionLineStatus from '@/components/display/screens/product-line/ProductionLineStatus';
```

그리고 `if (screenId === '24')` 블록 **앞에** (또는 기존 '21' 블록이 있던 위치에) 추가:
```typescript
if (screenId === '21') {
  return <ProductionLineStatus screenId={screenId} />;
}
```

- [ ] **Step 2: 빌드 확인**

```bash
npm run build 2>&1 | tail -20
```

Expected: 에러 없음

- [ ] **Step 3: 커밋**

```bash
git add src/app/(display)/display/[screenId]/page.tsx
git commit -m "feat: wire display/21 to ProductionLineStatus"
```

---

## Task 10: 최종 동작 확인

- [ ] **Step 1: 개발 서버 실행 (이미 실행 중이면 생략)**

```bash
npm run dev
```

- [ ] **Step 2: 브라우저에서 display/21 확인**

`http://localhost:3000/display/21` 열기

확인 항목:
- 좌측 테이블에 LINE_NAME, MODEL_NAME, 계획, 실적, 달성률%, NG, 상태뱃지 표시
- 우측 차트에 라인별 수평 바 + 달성률% 표시
- 달성률 0% 라인(계획=0)에서 빨간 바
- LINE_STATUS=N 라인에 '미가동' 회색 뱃지
- 설정 모달에서 갱신 주기 변경 시 SWR 반영

- [ ] **Step 3: 린트 확인**

```bash
npm run lint 2>&1 | tail -20
```

Expected: 에러 없음

- [ ] **Step 4: 최종 커밋**

```bash
git add -A
git commit -m "feat: complete display/21 rebuild with IRPT_PRODUCT_LINE_MONITORING"
```
