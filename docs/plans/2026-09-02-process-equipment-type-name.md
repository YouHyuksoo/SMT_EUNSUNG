# Process Equipment Type Name Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 공정관리 배치 설비 그리드에서 설비유형 코드 대신 `MACHINE TYPE` 공통코드명을 표시한다.

**Architecture:** 기존 `ComCodeBadge` 렌더링을 유지하고 잘못된 코드 그룹만 교정한다. 별도 데이터 조회나 백엔드 변경 없이 공통코드 캐시와 기존 폴백 동작을 재사용한다.

**Tech Stack:** Next.js, React, TypeScript, Node test runner

---

### Task 1: 배치 설비 유형 코드명 표시

**Files:**
- Create: `apps/frontend/src/app/(authenticated)/master/process/process-equipment-type-name.eunsung.structure.test.mjs`
- Modify: `apps/frontend/src/app/(authenticated)/master/process/components/ProcessEquipGrid.tsx`의 `equipType` 컬럼

- [ ] **Step 1: 실패하는 구조 테스트 작성**

  테스트에서 `ProcessEquipGrid.tsx`를 읽고 설비유형 셀이 `groupCode="MACHINE TYPE"`을 사용하며 `groupCode="EQUIP_TYPE"`을 사용하지 않는다고 단언한다.

- [ ] **Step 2: RED 확인**

  Run: `pnpm --filter @eunsung/frontend exec node --test 'src/app/(authenticated)/master/process/process-equipment-type-name.eunsung.structure.test.mjs'`

  Expected: `MACHINE TYPE` 단언이 실패한다.

- [ ] **Step 3: 최소 구현**

  `ProcessEquipGrid.tsx`의 설비유형 `ComCodeBadge`에서 `groupCode="EQUIP_TYPE"`을 `groupCode="MACHINE TYPE"`으로 변경한다.

- [ ] **Step 4: GREEN 확인**

  Run: `pnpm --filter @eunsung/frontend exec node --test 'src/app/(authenticated)/master/process/process-equipment-type-name.eunsung.structure.test.mjs'`

  Expected: PASS.

- [ ] **Step 5: 전체 구조 테스트 검증**

  Run: `pnpm --filter @eunsung/frontend test`

  Expected: 신규 테스트가 기본 glob으로 수집되고 전체 구조 테스트가 성공한다.

- [ ] **Step 6: 프론트엔드 타입 검증**

  Run: `pnpm --filter @eunsung/frontend typecheck`

  Expected: 페이지·메뉴 등록 검증과 TypeScript 검사가 성공한다.

- [ ] **Step 7: 변경 검토**

  Run: `git diff --check && git diff -- 'apps/frontend/src/app/(authenticated)/master/process/components/ProcessEquipGrid.tsx' 'apps/frontend/src/app/(authenticated)/master/process/process-equipment-type-name.eunsung.structure.test.mjs'`

  Expected: 공백 오류가 없고 변경이 코드그룹 교정과 회귀 테스트에 한정된다.
