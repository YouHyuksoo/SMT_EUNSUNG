# Process Grid Density Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 공정관리 상단 카드의 여백을 좌우 16px·위아래 12px로 줄이고 하단 설비 건수를 제목의 공정 정보 뒤에 한 줄로 표시한다.

**Architecture:** 공용 `Card`와 `DataGrid`는 변경하지 않고 `ProcessList`와 `ProcessEquipGrid`의 로컬 JSX 클래스만 조정한다. 기존 구조 테스트에 두 표현을 고정하는 회귀 검증을 추가한다.

**Tech Stack:** Next.js 16, React 19, TypeScript, Tailwind CSS 4, Node test runner

---

### Task 1: 공정관리 두 그리드의 헤더 밀도 조정

**Files:**
- Modify: `apps/frontend/src/app/(authenticated)/master/process/process-upload.eunsung.structure.test.mjs`
- Modify: `apps/frontend/src/app/(authenticated)/master/process/components/ProcessList.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/master/process/components/ProcessEquipGrid.tsx`

- [ ] **Step 1: 레이아웃 표현 테스트를 먼저 추가한다**

기존 구조 테스트에서 두 컴포넌트 소스를 읽고 다음 조건을 검증한다.

```js
const processList = readFileSync(new URL('./components/ProcessList.tsx', import.meta.url), 'utf8');
const equipmentGrid = readFileSync(new URL('./components/ProcessEquipGrid.tsx', import.meta.url), 'utf8');

test('uses compact process-card padding and an inline assigned-equipment count', () => {
  assert.match(processList, /<Card padding="none" className="flex-1 flex flex-col min-h-0">/);
  assert.match(processList, /<CardContent className="flex-1 min-h-0 overflow-hidden px-4 py-3">/);
  assert.match(
    equipmentGrid,
    /<h3[^>]*>[\s\S]*?assignedEquipments[\s\S]*?<span className="text-text-muted font-normal">\s*- \{processCode\} \(\{processName\}\) · \{equipments\.length\}\{t\("common\.count"[\s\S]*?<\/span>\s*<\/h3>/,
  );
  assert.doesNotMatch(
    equipmentGrid,
    /<p[^>]*>(?:(?!<\/p>)[\s\S])*\{equipments\.length\}(?:(?!<\/p>)[\s\S])*<\/p>/,
  );
});
```

기존 60:40 배치, 등록 패널, 설비 배치 모달 관련 테스트는 변경하지 않는다.

- [ ] **Step 2: 새 테스트가 기대한 이유로 실패하는지 확인한다**

Run:

```bash
node --test 'apps/frontend/src/app/(authenticated)/master/process/process-upload.eunsung.structure.test.mjs'
```

Expected: 새 테스트만 `ProcessList`의 `padding="none"` 부재 또는 하단 인라인 건수 부재로 FAIL한다.

- [ ] **Step 3: 상단 카드 패딩을 최소 변경한다**

`ProcessList.tsx`를 다음 형태로 바꾼다.

```tsx
<Card padding="none" className="flex-1 flex flex-col min-h-0">
  <CardContent className="flex-1 min-h-0 overflow-hidden px-4 py-3">
```

DataGrid props와 버튼은 그대로 둔다.

- [ ] **Step 4: 하단 건수를 제목 줄에 통합한다**

`ProcessEquipGrid.tsx`에서 제목을 다음 순서로 렌더링한다.

```tsx
<span className="text-text-muted font-normal">
  - {processCode} ({processName}) · {equipments.length}{t("common.count", { defaultValue: "건" })}
</span>
```

기존 제목 아래의 건수 `<p>`만 제거한다. 헤더 패딩, 설비 배치 버튼 및 DataGrid는 변경하지 않는다.

- [ ] **Step 5: focused 테스트가 통과하는지 확인한다**

Run:

```bash
node --test 'apps/frontend/src/app/(authenticated)/master/process/process-upload.eunsung.structure.test.mjs'
```

Expected: 모든 focused 테스트 PASS.

- [ ] **Step 6: 프론트엔드 전체 검증을 실행한다**

Run:

```bash
pnpm --filter @eunsung/frontend test
pnpm --filter @eunsung/frontend typecheck
```

Expected: 두 명령 모두 exit code 0.

- [ ] **Step 7: 실행 중인 dev 서버가 있으면 렌더 화면을 확인한다**

서버를 새로 기동하지 않는다. localhost:3100이 이미 응답할 때만 공정관리 화면에서 다음을 확인한다.

- 상단 카드 여백이 좌우 16px·위아래 12px임
- `배치된 설비 - 공정코드 (공정명) · N건`이 한 줄에 표시됨
- 등록 패널, 설비 배치 버튼, 상하 60:40 배치가 유지됨

- [ ] **Step 8: 변경 파일만 커밋한다**

```bash
git add 'apps/frontend/src/app/(authenticated)/master/process/process-upload.eunsung.structure.test.mjs' \
  'apps/frontend/src/app/(authenticated)/master/process/components/ProcessList.tsx' \
  'apps/frontend/src/app/(authenticated)/master/process/components/ProcessEquipGrid.tsx'
git commit -m "style: tighten process grid spacing"
```
