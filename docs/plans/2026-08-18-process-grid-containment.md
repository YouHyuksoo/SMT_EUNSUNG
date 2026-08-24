# Process Grid Containment Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 공정관리 두 카드의 우측 테두리와 내부 양방향 스크롤을 보장하고, 하단 헤더 간격·그리드 inset·설비배치 버튼 노출을 보정한다.

**Architecture:** 공용 `Card`와 `DataGrid`는 유지하고 `ProcessList`·`ProcessEquipGrid`의 너비/overflow/flex 경계만 명시한다. 기존 구조 테스트에 화면 로컬 계약을 추가해 회귀를 막는다.

**Tech Stack:** Next.js 16, React 19, TypeScript, Tailwind CSS 4, Node test runner

---

### Task 1: 두 카드의 경계·스크롤·하단 헤더 보정

**Files:**
- Modify: `apps/frontend/src/app/(authenticated)/master/process/process-upload.eunsung.structure.test.mjs`
- Modify: `apps/frontend/src/app/(authenticated)/master/process/components/ProcessList.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/master/process/components/ProcessEquipGrid.tsx`

- [ ] **Step 1: 기존 패딩 테스트를 새 카드 경계 계약으로 갱신하고 회귀 테스트를 추가한다**

기존 `uses compact process-card padding and an inline assigned-equipment count` 테스트의 상단 Card/CardContent exact-class 기대값을 새 경계 클래스까지 포함하도록 먼저 갱신한다. 같은 파일이 읽는 `list`와 `equipmentGrid` 문자열을 사용해 나머지 계약도 추가한다.

```js
test('contains both grids and keeps the equipment action visible', () => {
  assert.match(list, /<Card padding="none" className="flex-1 flex flex-col min-w-0 min-h-0 w-full max-w-full overflow-hidden">/);
  assert.match(list, /<CardContent className="flex-1 min-w-0 min-h-0 overflow-hidden px-4 py-3">/);

  assert.match(equipmentGrid, /<Card padding="none" className="flex-1 flex flex-col min-w-0 min-h-0 w-full max-w-full overflow-hidden">/);
  assert.match(equipmentGrid, /<Card className="flex-1 flex items-center justify-center min-w-0 min-h-0 w-full max-w-full overflow-hidden">/);
  assert.match(equipmentGrid, /className="px-4 pt-3 pb-1 border-b border-border flex-shrink-0"/);
  assert.match(equipmentGrid, /className="flex items-center justify-between gap-3"/);
  assert.match(equipmentGrid, /className="flex-1 min-w-0"/);
  assert.match(equipmentGrid, /<Button size="sm" className="flex-shrink-0" onClick=\{onAdd\}>/);
  assert.match(equipmentGrid, /<CardContent className="flex-1 min-w-0 min-h-0 overflow-hidden px-4 py-3">/);
});
```

기존 인라인 건수 검증은 유지하며 상단 Card/CardContent exact-class 두 assertion만 새 최종 문자열로 갱신한다. 60:40 배치, 등록 패널·설비 배치 모달 등 다른 테스트는 변경하지 않는다.

- [ ] **Step 2: 테스트가 기대한 이유로 실패하는지 확인한다**

Run:

```bash
node --test 'apps/frontend/src/app/(authenticated)/master/process/process-upload.eunsung.structure.test.mjs'
```

Expected: 갱신된 상단 exact-class assertion과 새 테스트가 카드 너비 경계, 하단 패딩, 미선택 카드 경계 또는 버튼 수축 방지 클래스 부재로 FAIL한다. 기존 동작 테스트는 PASS한다.

- [ ] **Step 3: 상단 카드와 그리드 경계를 보정한다**

`ProcessList.tsx`의 래퍼를 다음과 같이 변경한다.

```tsx
<Card padding="none" className="flex-1 flex flex-col min-w-0 min-h-0 w-full max-w-full overflow-hidden">
  <CardContent className="flex-1 min-w-0 min-h-0 overflow-hidden px-4 py-3">
```

DataGrid props는 변경하지 않는다.

- [ ] **Step 4: 하단 카드·헤더·버튼·그리드 경계를 보정한다**

`ProcessEquipGrid.tsx`의 선택된 공정 렌더 경로를 다음 기준으로 변경한다.

```tsx
<Card padding="none" className="flex-1 flex flex-col min-w-0 min-h-0 w-full max-w-full overflow-hidden">
  <div className="px-4 pt-3 pb-1 border-b border-border flex-shrink-0">
    <div className="flex items-center justify-between gap-3">
      <div className="flex-1 min-w-0">
        {/* 기존 한 줄 제목과 건수 */}
      </div>
      <Button size="sm" className="flex-shrink-0" onClick={onAdd}>
        {/* 기존 아이콘과 라벨 */}
      </Button>
    </div>
  </div>
  <CardContent className="flex-1 min-w-0 min-h-0 overflow-hidden px-4 py-3">
```

제목 텍스트, `equipments.length`, 버튼 핸들러와 DataGrid props는 유지한다.

- [ ] **Step 5: 공정 미선택 카드도 우측 경계를 보존한다**

같은 컴포넌트의 미선택 분기 Card를 다음 exact class로 변경한다.

```tsx
<Card className="flex-1 flex items-center justify-center min-w-0 min-h-0 w-full max-w-full overflow-hidden">
```

안내 문구와 아이콘은 변경하지 않는다.

- [ ] **Step 6: focused 테스트를 GREEN으로 확인한다**

Run:

```bash
node --test 'apps/frontend/src/app/(authenticated)/master/process/process-upload.eunsung.structure.test.mjs'
```

Expected: 모든 focused 테스트 PASS.

- [ ] **Step 7: 전체 프론트 검증을 실행한다**

Run:

```bash
pnpm --filter @eunsung/frontend test
pnpm --filter @eunsung/frontend typecheck
```

Expected: 두 명령 모두 exit code 0.

- [ ] **Step 8: 실행 중인 dev 서버가 있으면 렌더 화면을 확인한다**

서버를 새로 기동하지 않는다. localhost:3100이 이미 응답할 때만 공정관리 화면에서 다음을 확인한다.

- 두 카드의 우측 외곽선이 좌측과 대칭으로 표시됨
- 넓고 긴 데이터에서 가로·세로 스크롤이 카드 내부에 나타남
- 하단 구분선이 제목에 가까워짐
- 상·하단 그리드 inset이 동일함
- 설비배치 버튼이 카드 우측에 보이고 클릭 시 기존 모달이 열림

- [ ] **Step 9: 변경 파일만 커밋한다**

```bash
git add 'apps/frontend/src/app/(authenticated)/master/process/process-upload.eunsung.structure.test.mjs' \
  'apps/frontend/src/app/(authenticated)/master/process/components/ProcessList.tsx' \
  'apps/frontend/src/app/(authenticated)/master/process/components/ProcessEquipGrid.tsx'
git commit -m "fix: contain process management grids"
```
