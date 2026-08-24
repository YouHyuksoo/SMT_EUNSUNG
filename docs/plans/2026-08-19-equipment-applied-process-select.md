# Equipment Applied Process Select Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 설비마스터의 라인 필터·폼을 공정마스터 기반 적용공정 선택으로 바꾸고 `공정코드 | 공정명 | 공정유형 한글명`을 표시한다.

**Architecture:** `useProcessOptions`는 공정마스터 API를 단일 원천으로 사용하고 기존 반환 계약을 유지한다. 공용 `ProcessSelect`에는 선택적 유형 표시 기능을 추가하며, 설비마스터만 이를 켜서 조회·저장 필드를 `processCode`로 전환한다.

**Tech Stack:** Next.js 16, React 19, TypeScript, TanStack Query, Node test

---

### Task 1: 공정마스터 기반 공정 선택지

**Files:**
- Create: `apps/frontend/src/components/shared/processOptions.mjs`
- Create: `apps/frontend/src/components/shared/process-select.eunsung.structure.test.mjs`
- Modify: `apps/frontend/src/hooks/useMasterOptions.ts`
- Modify: `apps/frontend/src/components/shared/ProcessSelect.tsx`

- [ ] **Step 1: 실패하는 동작·구조 테스트 작성**

Node 20에서 실행 가능한 `.mjs` 헬퍼를 대상으로 다음 동작을 먼저 요구한다.

```js
const processes = [
  { processCode: "P10", processName: "조립", processType: "I" },
  { processCode: "P20", processName: "검사", processType: "T" },
];
const typeNames = { I: { codeName: "일반" }, T: { codeName: "검사" } };

assert.deepEqual(buildProcessOptions(processes, typeNames, true), [
  { value: "P10", label: "P10 | 조립 | 일반" },
  { value: "P20", label: "P20 | 검사 | 검사" },
]);
assert.deepEqual(buildProcessOptions(processes, typeNames, false), [
  { value: "P10", label: "P10 - 조립" },
  { value: "P20", label: "P20 - 검사" },
]);
```

구조 단언은 다음을 포함한다.

- `useProcessOptions`가 `/master/processes?limit=5000`을 호출한다.
- 기존 `/equipment/equips/metadata/processes`가 제거된다.
- `ProcessItem`에 `processType`이 존재한다.
- `ProcessSelect`가 `showProcessType`과 `WORKSTAGE TYPE` 공통코드 맵을 사용한다.

- [ ] **Step 2: RED 확인**

Run:

```bash
node --test apps/frontend/src/components/shared/process-select.eunsung.structure.test.mjs
```

Expected: 헬퍼 부재 또는 기존 메타데이터 API 의존 때문에 FAIL.

- [ ] **Step 3: 최소 구현**

`processOptions.mjs`에 JSDoc 타입이 있는 순수 `buildProcessOptions(processes, typeNames, showProcessType)`를 구현한다. 유형명이 없으면 원시 `processType`을 사용한다.

`useMasterOptions.ts`는 `ResponseUtil.paged` 응답을 `useApiQuery`가 한 번 벗긴 실제 계약에 맞춰 다음처럼 변경한다.

```ts
interface ProcessItem {
  processCode: string;
  processName: string;
  processType: string;
}

const { data, isLoading } = useApiQuery<ProcessItem[]>(
  ["processes", "options"],
  "/master/processes?limit=5000",
  ...,
);
const rawData = Array.isArray(data?.data) ? data.data : [];
```

`ProcessSelect.tsx`는 `showProcessType?: boolean`을 명시적으로 구조분해해 하위 `Select`의 `...props`로 전달되지 않게 한다. `useComCodeMap("WORKSTAGE TYPE")`, `rawData`, 순수 헬퍼로 옵션을 만들며 기본값 `false`에서는 기존 `코드 - 명칭` 표시를 유지한다. 테스트는 `useProcessOptions`의 `options`, `isLoading`, `rawData` 반환과 `labelPrefix` 사용 시 `공정: 전체` 계약도 보존하는지 단언한다.

- [ ] **Step 4: GREEN 확인**

Run targeted Node test. Expected: PASS.

- [ ] **Step 5: Task 1 커밋**

```bash
git add apps/frontend/src/components/shared/processOptions.mjs \
  apps/frontend/src/components/shared/process-select.eunsung.structure.test.mjs \
  apps/frontend/src/components/shared/ProcessSelect.tsx \
  apps/frontend/src/hooks/useMasterOptions.ts
git commit -m "fix: load process options from process master"
```

### Task 2: 설비마스터 적용공정 연결

**Files:**
- Create: `apps/frontend/src/app/(authenticated)/master/equip/equip-applied-process.eunsung.structure.test.mjs`
- Modify: `apps/frontend/src/app/(authenticated)/master/equip/components/EquipMasterTab.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/master/equip/components/EquipFieldHelp.tsx`
- Modify: `apps/frontend/src/locales/ko.json`
- Modify: `apps/frontend/src/locales/en.json`
- Modify: `apps/frontend/src/locales/zh.json`
- Modify: `apps/frontend/src/locales/vi.json`

- [ ] **Step 1: 실패하는 설비 계약 테스트 작성**

다음을 구조적으로 검사한다.

- `ProcessSelect`를 상단 필터와 폼에서 모두 사용하고 두 곳 모두 `showProcessType`을 전달한다.
- `processFilter`, API params `processCode`, 폼 `processCode`, 편집 복원 `equip.processCode`, 저장 body `processCode`가 연결된다.
- 필터·폼·조회 params·저장 body의 대상 코드 조각에 `LineSelect`, `lineFilter`, `FieldLineSelect`, `lineCode`가 남지 않는다. 파일 전체의 `lineCode`는 SERIAL 표시 등 별도 합법적 경로가 있으므로 금지하지 않는다.
- 폼 도움말이 `IMCN_MACHINE.WORKSTAGE_CODE`를 가리킨다.
- 그리드 헤더, 필터 접두어, 폼 라벨과 4개 locale의 `master.equip.process`가 `적용공정` 의미로 변경된다.

- [ ] **Step 2: RED 확인**

Run:

```bash
node --test 'apps/frontend/src/app/(authenticated)/master/equip/equip-applied-process.eunsung.structure.test.mjs'
```

Expected: 기존 라인 상태·컴포넌트·payload 때문에 FAIL.

- [ ] **Step 3: 최소 구현**

- `EquipMasterTab`의 필터와 폼 상태를 `processCode`로 변경한다.
- 두 `ProcessSelect`에 `showProcessType`을 전달한다.
- 필터는 `labelPrefix={t("master.equip.process", "적용공정")}`를 사용한다.
- 조회와 저장은 `processCode`만 전송한다.
- `EquipFieldHelp`에 `processCode: IMCN_MACHINE.WORKSTAGE_CODE` 도움말과 `FieldProcessSelect` 래퍼를 정의한다.
- 설비 그리드·폼 라벨과 실제 로딩되는 4개 locale(`ko`, `en`, `zh`, `vi`)의 설비 `process` 값을 적용공정 의미로 변경한다.

- [ ] **Step 4: GREEN 확인**

Run targeted test. Expected: PASS.

- [ ] **Step 5: 전체 검증**

```bash
pnpm --filter @eunsung/frontend test
pnpm --filter @eunsung/frontend typecheck
git diff --check
```

Expected: 전체 구조·동작 테스트와 TypeScript 검사 PASS.

- [ ] **Step 6: 화면 검증**

사용자가 실행한 서버가 있으면 `/master/equip`에서 상단 필터와 등록 패널이 `코드 | 공정명 | 유형 한글명`을 표시하고 저장 요청이 `processCode`를 보내는지 확인한다. 서버가 없으면 임의 기동하지 않고 제한을 보고한다.

- [ ] **Step 7: Task 2 커밋**

```bash
git add 'apps/frontend/src/app/(authenticated)/master/equip' \
  apps/frontend/src/locales/{ko,en,zh,vi}.json
git commit -m "fix: use applied process in equipment master"
```
