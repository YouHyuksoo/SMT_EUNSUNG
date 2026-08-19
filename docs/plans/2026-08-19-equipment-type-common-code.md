# Equipment Type Common Code Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 설비가 없어도 설비마스터의 유형 필터와 등록·수정 콤보가 `MACHINE TYPE` 공통코드 9건을 표시하도록 한다.

**Architecture:** 공유 `useEquipTypeOptions`의 반환 계약은 유지하고 내부 데이터 원천만 `useComCodes`/`useComCodeOptions`로 전환한다. 화면에서는 `TEMP` 초기값과 빈 목록 예비 옵션을 제거해 공통코드만 선택 가능하게 한다.

**Tech Stack:** Next.js 16, React 19, TypeScript, TanStack Query, Node test

---

### Task 1: 공통코드 기반 설비유형 옵션

**Files:**
- Create: `apps/frontend/src/app/(authenticated)/master/equip/equip-type-options.eunsung.structure.test.mjs`
- Modify: `apps/frontend/src/hooks/useMasterOptions.ts`
- Modify: `apps/frontend/src/app/(authenticated)/master/equip/components/EquipMasterTab.tsx`

- [ ] **Step 1: 실패하는 구조 테스트 작성**

테스트는 다음 계약을 검사한다.

```js
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import test from "node:test";

const masterOptionsSource = readFileSync(
  new URL("../../../../hooks/useMasterOptions.ts", import.meta.url),
  "utf8",
);
const masterTabSource = readFileSync(
  new URL("./components/EquipMasterTab.tsx", import.meta.url),
  "utf8",
);

test("equipment type options come from MACHINE TYPE common codes", () => {
  assert.match(masterOptionsSource, /useComCodeOptions\("MACHINE TYPE", false, true\)/);
  assert.match(masterOptionsSource, /useComCodes\(\)/);
  assert.doesNotMatch(masterOptionsSource, /\/equipment\/equips\/metadata\/types/);
});

test("filter and form share common-code options without TEMP fallback", () => {
  assert.match(masterTabSource, /equipType: ""/);
  assert.doesNotMatch(masterTabSource, /TEMP/);
  assert.match(masterTabSource, /\.\.\.equipTypeOptions\.map/);
  assert.match(masterTabSource, /<Select\s+options=\{equipTypeOptions\}/);
  assert.doesNotMatch(masterTabSource, /options=\{equipTypeOptions\.length \?/);
});
```

- [ ] **Step 2: RED 확인**

Run:

```bash
node --test 'apps/frontend/src/app/(authenticated)/master/equip/equip-type-options.eunsung.structure.test.mjs'
```

Expected: 기존 메타데이터 API와 `TEMP` 기본값 때문에 FAIL.

- [ ] **Step 3: 최소 구현**

`useMasterOptions.ts`에서 기존 `EquipTypeItem`과 메타데이터 API 변환 코드를 제거하고 공통코드 훅을 사용한다.

```ts
import { useComCodeOptions, useComCodes } from "./useComCode";

export function useEquipTypeOptions() {
  const options = useComCodeOptions("MACHINE TYPE", false, true);
  const { isLoading } = useComCodes();
  return { options, isLoading };
}
```

`EquipMasterTab.tsx`에서는 신규 폼 유형을 빈 문자열로 시작하고 공통코드 옵션을 그대로 전달한다.

```tsx
equipType: "",
// ...
<Select options={equipTypeOptions} ... />
```

- [ ] **Step 4: GREEN 확인**

Run:

```bash
node --test 'apps/frontend/src/app/(authenticated)/master/equip/equip-type-options.eunsung.structure.test.mjs'
```

Expected: PASS.

- [ ] **Step 5: 전체 프론트 검증**

Run:

```bash
pnpm --filter @eunsung/frontend test
pnpm --filter @eunsung/frontend typecheck
```

Expected: 전체 구조 테스트와 TypeScript 검사 PASS.

- [ ] **Step 6: 실행 중인 화면 검증**

사용자가 실행한 개발 서버가 있으면 `/master/equip`에서 필터와 등록 패널을 열어 `M0100`부터 `M0170`까지 9건이 표시되고 `TEMP`가 없는지 확인한다. 서버가 없으면 임의로 기동하지 않고 제한을 보고한다.

- [ ] **Step 7: 구현 커밋**

```bash
git add \
  'apps/frontend/src/app/(authenticated)/master/equip/equip-type-options.eunsung.structure.test.mjs' \
  'apps/frontend/src/app/(authenticated)/master/equip/components/EquipMasterTab.tsx' \
  apps/frontend/src/hooks/useMasterOptions.ts
git commit -m "fix: load equipment types from common codes"
```
