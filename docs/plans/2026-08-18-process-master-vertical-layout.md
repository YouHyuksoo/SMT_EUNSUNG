# Process Master Vertical Layout Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 공정관리 메인 화면의 공정마스터와 배치된 설비 그리드를 상단 60%·하단 40%로 배치하고 기존 팝업 구성을 보존한다.

**Architecture:** 기존 `ProcessList`와 `ProcessEquipGrid`의 props와 데이터 흐름은 유지한다. 두 컴포넌트의 공통 래퍼만 12열 좌우 Grid에서 `3fr 2fr` 2행 Grid로 바꾸고, 구조 테스트와 사용자 도움말을 새 배치에 맞춘다.

**Tech Stack:** Next.js 16, React 19, TypeScript, Tailwind CSS 4, Node test runner

---

### Task 1: 공정관리 그리드를 60:40 상하 배치로 변경

**Files:**
- Modify: `apps/frontend/src/app/(authenticated)/master/process/process-upload.eunsung.structure.test.mjs`
- Modify: `apps/frontend/src/app/(authenticated)/master/process/page.tsx`
- Modify: `apps/frontend/public/help/user/ko/MST_PROCESS.md`

- [ ] **Step 1: 기존 팝업 구조의 특성 테스트를 먼저 추가한다**

레이아웃을 바꾸기 전에 같은 테스트 파일에 등록·수정 슬라이드 패널과 설비 배치 모달의 핵심 구성을 고정하는 테스트를 추가한다.

```js
test('preserves the process editor panel and equipment assignment modal composition', () => {
  assert.match(page, /\{isPanelOpen && \(/);
  assert.match(page, /w-\[520px\].*animate-slide-in-right/s);
  assert.match(page, /editingItem \? t\("master\.process\.editProcess"\) : t\("master\.process\.addProcess"\)/);
  assert.match(page, /<Modal\s+isOpen=\{assignModalOpen\}[\s\S]*?size="md"/);
  assert.match(page, /<Select[\s\S]*?options=\{assignOptions\}[\s\S]*?onChange=\{setAssignEquipCode\}/);
});
```

Run:

```bash
node --test 'apps/frontend/src/app/(authenticated)/master/process/process-upload.eunsung.structure.test.mjs'
```

Expected: 새 특성 테스트를 포함한 모든 테스트 PASS. 이 테스트는 이후 단계에서 수정하지 않는다.

- [ ] **Step 2: 상하 배치 구조 테스트를 작성한다**

`process-upload.eunsung.structure.test.mjs`에 다음 조건을 검증하는 테스트를 추가한다.

```js
test('process and assigned-equipment grids use a 60:40 vertical layout', () => {
  assert.match(page, /grid-rows-\[minmax\(0,3fr\)_minmax\(0,2fr\)\]/);
  assert.doesNotMatch(page, /grid-cols-12/);
  assert.doesNotMatch(page, /col-span-7/);
  assert.doesNotMatch(page, /col-span-5/);
});
```

기존 테스트의 등록·수정 패널과 설비 배치 모달 연결 검증은 삭제하거나 완화하지 않는다.

- [ ] **Step 3: 새 구조 테스트가 기대한 이유로 실패하는지 확인한다**

Run:

```bash
node --test 'apps/frontend/src/app/(authenticated)/master/process/process-upload.eunsung.structure.test.mjs'
```

Expected: 새 테스트가 `grid-rows-[minmax(0,3fr)_minmax(0,2fr)]` 부재로 FAIL하고 기존 테스트는 PASS한다.

- [ ] **Step 4: 최소 레이아웃 변경을 구현한다**

`page.tsx`의 두 그리드 래퍼를 다음 구조로 변경한다.

```tsx
<div className="flex-1 min-w-0 grid grid-rows-[minmax(0,3fr)_minmax(0,2fr)] gap-6">
  <div className="flex flex-col min-h-0">
    <ProcessList {...existingProps} />
  </div>
  <div className="flex flex-col min-h-0">
    <ProcessEquipGrid {...existingProps} />
  </div>
</div>
```

파일 상단 및 본문 주석의 `좌측/우측` 표현만 `상단/하단`으로 변경한다. 슬라이드 패널과 모든 모달 JSX는 수정하지 않는다.

- [ ] **Step 5: 사용자 도움말의 두 그리드 관계만 갱신한다**

`MST_PROCESS.md`에서 두 그리드의 관계를 설명하는 문장만 문맥에 맞게 고친다.

- 공정 목록과 그 선택 동작: `왼쪽` → `상단`
- 배치된 설비 목록과 버튼/행 동작: `오른쪽` → `하단`
- 구조 도식, 컬럼 제목, 작업 순서, 대표설비 FAQ에서 두 목록을 지칭하는 방향 표현도 같은 기준으로 갱신
- 빈 선택 안내 문구 인용은 실제 화면 번역문을 바꾸지 않으므로 그대로 유지
- `상단 우측 새로고침`, 슬라이드 패널이 오른쪽에서 열리는 설명처럼 두 그리드 배치와 무관한 방향 표현은 그대로 유지

- [ ] **Step 6: focused 구조 테스트가 통과하는지 확인한다**

Run:

```bash
node --test 'apps/frontend/src/app/(authenticated)/master/process/process-upload.eunsung.structure.test.mjs'
```

Expected: 모든 테스트 PASS.

- [ ] **Step 7: 프론트엔드 전체 구조 테스트와 타입 검사를 실행한다**

Run:

```bash
pnpm --filter @eunsung/frontend test
pnpm --filter @eunsung/frontend typecheck
```

Expected: 두 명령 모두 exit code 0. 기존 실패가 있으면 이번 변경과의 연관성을 분리해 보고한다.

- [ ] **Step 8: 실행 중인 dev 서버가 있으면 렌더 화면을 확인한다**

서버를 새로 기동하지 않는다. `http://localhost:3100`이 이미 응답할 때만 공정관리 화면에서 다음을 확인한다.

- 공정마스터가 위 60%, 배치된 설비가 아래 40%에 표시됨
- 각 그리드 내부 스크롤이 유지됨
- 공정 선택 시 하단 설비 목록이 갱신됨
- 등록 버튼으로 여는 기존 슬라이드 패널의 너비와 내부 필드 구성이 그대로임

- [ ] **Step 9: 변경 파일만 커밋한다**

```bash
git add 'apps/frontend/src/app/(authenticated)/master/process/process-upload.eunsung.structure.test.mjs' \
  'apps/frontend/src/app/(authenticated)/master/process/page.tsx' \
  apps/frontend/public/help/user/ko/MST_PROCESS.md
git commit -m "feat: stack process management grids vertically"
```
