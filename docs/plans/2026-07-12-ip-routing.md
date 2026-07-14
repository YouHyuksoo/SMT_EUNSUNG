# IP Routing Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 은성전장 Oracle에 `IP_ROUTING_*` 3개 테이블을 생성하고, 현재 BOM을 후보로 공정별 투입자재를 한 번만 배정하는 라우팅 관리 기능을 기존 화면에 연결한다.

**Architecture:** `ID_ITEM`, `IP_PRODUCT_WORKSTAGE`, `ICOM_SUPPLIER`, 현재 유효 `ID_ENG_BOM`을 기준정보로 사용하고 신규 라우팅 테이블은 그룹·공정·자재 배정만 소유한다. 기존 `/master/routing-groups` 계약을 정리해 사용하며 품질조건·자주검사 경로는 제거한다. DB 제약과 NestJS 서비스 검증을 함께 두고, Oracle → 인증 API → 프론트 프록시 → 렌더 화면 순서로 완료를 확인한다.

**Tech Stack:** Oracle, TypeORM, NestJS 11, Jest, Next.js 16, React 19, TypeScript, node:test, pnpm

**Design:** `docs/specs/2026-07-12-ip-routing-design.md`

---

## File map

- Create `apps/backend/src/migrations/2026-07-12_ip_routing_tables.sql`: 재실행 시 기존 객체 정의를 검증하고 신규 3개 테이블·제약·인덱스를 생성하는 Oracle DDL.
- Create `apps/backend/src/migrations/ip-routing-tables.structure.test.mjs`: DDL의 테이블명, FK, check, 함수 기반 유니크 인덱스, 비파괴 규칙 고정.
- Modify `apps/backend/src/entities/routing-group.entity.ts`: `IP_ROUTING_GROUPS` 전체 컬럼 매핑.
- Modify `apps/backend/src/entities/routing-process.entity.ts`: `IP_ROUTING_PROCESSES`와 은성 공정 컬럼 매핑.
- Modify `apps/backend/src/entities/routing-material.entity.ts`: `IP_ROUTING_MATERIALS` 매핑 및 불필요한 circuit/use 컬럼 제거.
- Create `apps/backend/src/entities/ip-routing-entities.structure.test.mjs`: 엔티티 테이블·컬럼 계약 고정.
- Modify `apps/backend/src/modules/master/dto/routing-group.dto.ts`: 은성 라우팅 DTO, 명시적 자재 변경 및 순번 변경 계약.
- Modify `apps/backend/src/modules/master/services/routing-group.service.ts`: 활성 라우팅, 외주, BOM 후보, 자재 소유권, stale 보존, 삭제·재순번 트랜잭션 규칙.
- Modify `apps/backend/src/modules/master/services/routing-group.service.spec.ts`: 서비스 업무 규칙 회귀 테스트.
- Modify `apps/backend/src/modules/master/controllers/routing-group.controller.ts`: 승인된 API 경로와 오류 흐름만 노출.
- Create `apps/backend/src/modules/master/controllers/routing-group.controller.spec.ts`: `JwtAuthGuard` 및 조직 컨텍스트 메타데이터 검증.
- Modify `apps/backend/src/modules/master/master-routing-group.module.ts`: 품질조건/자주검사 저장소 제거.
- Modify `apps/backend/src/database/database.module.ts`: 신규 라우팅 엔티티만 등록하고 제거 대상 의존성 정리.
- Modify `apps/frontend/src/app/(authenticated)/master/routing/types.ts`: BOM 후보·배정·불일치 타입.
- Modify `apps/frontend/src/app/(authenticated)/master/routing/page.tsx`: 라우팅·자재 중심 화면 조립.
- Modify `apps/frontend/src/app/(authenticated)/master/routing/components/RoutingGroupManager.tsx`: 은성 마스터 선택, 공정 저장·삭제·순서 계약.
- Modify `apps/frontend/src/app/(authenticated)/master/routing/components/RoutingMaterialEditor.tsx`: BOM 후보 체크, 타 공정 disabled, stale 경고와 명시 삭제.
- Modify `apps/frontend/src/app/(authenticated)/master/routing/components/RoutingFieldHelp.tsx`: 실제 용어와 동작 설명.
- Delete `apps/frontend/src/app/(authenticated)/master/routing/components/QualityConditionEditor.tsx`: 범위 제외 UI.
- Delete `apps/frontend/src/app/(authenticated)/master/routing/components/SelfInspectConfigEditor.tsx`: 범위 제외 UI.
- Create `apps/frontend/src/app/(authenticated)/master/routing/ip-routing.structure.test.mjs`: 화면/API/제외 기능 구조 계약.
- Modify `apps/frontend/public/help/user/ko/MST_ROUTING.md`: 사용자 도움말.
- Modify `apps/frontend/public/help/operator/ko/MST_ROUTING.md`: 운영자 도움말.
- Modify `CONTEXT.md`: 최종 구현에서 확인된 라우팅 도메인 용어와 테이블 역할 반영.

## Worktree safety baseline

이 저장소에는 사용자 소유의 기존 변경과 이미 스테이징된 항목이 있으므로 구현 시작 전에 `git status --short`와 각 대상 파일의 `git diff -- <exact-path>`를 기록한다. 대상 파일에 기존 변경이 있으면 해당 변경의 의도를 보존하면서 라우팅 변경만 수술적으로 추가한다. 사용자 index를 reset/unstage하지 않는다. 매 커밋은 대상 파일을 stage한 뒤 `git diff --cached --name-status`와 `git diff --cached --check`로 전체 index를 확인하고, 반드시 `git commit --only -- <exact target paths>`를 사용해 지정 경로만 커밋한다. `CONTEXT.md`처럼 이미 사용자 변경이 있는 파일은 구현 내용은 보존하되 중간 커밋에서 제외하고 최종 상태에 별도 보고한다.

### Task 1: Freeze the Oracle schema contract

**Files:**
- Create: `apps/backend/src/migrations/ip-routing-tables.structure.test.mjs`
- Create: `apps/backend/src/migrations/2026-07-12_ip_routing_tables.sql`

- [ ] **Step 1: Write the failing DDL structure test**

검사 항목을 명시한다: 세 `CREATE TABLE`, 마스터 PK 순서에 맞는 FK, 공정 FK의 `DEFERRABLE INITIALLY IMMEDIATE`, `ALLOC_QTY > 0`, 시간 범위, Y/N·열거형 check, 활성 라우팅 CASE 유니크 인덱스, 라우팅 자재 단일공정 unique, `DROP/CASCADE/DML` 부재.

- [ ] **Step 2: Run the test and confirm RED**

Run: `node --test apps/backend/src/migrations/ip-routing-tables.structure.test.mjs`

Expected: FAIL because `2026-07-12_ip_routing_tables.sql` does not exist.

- [ ] **Step 3: Write the minimum idempotent Oracle DDL**

각 객체는 `USER_TABLES`, `USER_TAB_COLUMNS`, `USER_CONSTRAINTS`, `USER_INDEXES`로 정의 일치를 검사한다. 없는 객체만 생성하고, 같은 이름의 불일치 객체는 `RAISE_APPLICATION_ERROR`로 중단한다. SQL에는 데이터 INSERT/UPDATE/DELETE와 기존 객체 ALTER/DROP을 넣지 않는다.

- [ ] **Step 4: Run the structure test and confirm GREEN**

Run: `node --test apps/backend/src/migrations/ip-routing-tables.structure.test.mjs`

Expected: PASS.

- [ ] **Step 5: Commit only the DDL contract**

```bash
git add apps/backend/src/migrations/2026-07-12_ip_routing_tables.sql apps/backend/src/migrations/ip-routing-tables.structure.test.mjs
git diff --cached --name-status
git diff --cached --check
git commit --only -m "feat(db): define IP routing tables" -- apps/backend/src/migrations/2026-07-12_ip_routing_tables.sql apps/backend/src/migrations/ip-routing-tables.structure.test.mjs
```

### Task 2: Precheck and apply the live Oracle DDL

**Files:**
- Use: `apps/backend/src/migrations/2026-07-12_ip_routing_tables.sql`
- Record evidence in final verification output; do not create seed data.

- [ ] **Step 1: Use the `oracle-db` skill and `ESDBext` connector to query live keys**

확인 대상: `SYS_CONTEXT('USERENV','CURRENT_SCHEMA')='INFINITY21_JSMES'`, 신규 객체 부재/정의, `ID_ITEM(ITEM_CODE, ORGANIZATION_ID)`, `IP_PRODUCT_WORKSTAGE(WORKSTAGE_CODE, ORGANIZATION_ID)`, `ICOM_SUPPLIER(SUPPLIER_CODE, ORGANIZATION_ID)`의 컬럼 datatype/length/precision/scale, 참조 PK/UK의 status와 컬럼 순서, 레거시 두 테이블의 정의와 DDL 전 건수.

- [ ] **Step 2: Stop on any incompatible live definition**

Expected: 마스터 키가 설계와 일치한다. 다르면 DDL을 실행하지 말고 설계 변경 승인을 요청한다.

- [ ] **Step 3: Execute the SQL file through the connector**

SQL 파일을 PL/SQL 블록 단위(`/` 구분)로 실행할 수 있는 connector의 파일 실행 경로를 사용한다. Expected: all three tables, constraints, and indexes created without ORA/NJS errors. Preserve any error verbatim.

- [ ] **Step 4: Verify post-DDL metadata and initial counts**

Query `USER_TABLES`, `USER_TAB_COLUMNS`, `USER_CONSTRAINTS`, `USER_CONS_COLUMNS`, `USER_INDEXES`, `USER_IND_COLUMNS`, `USER_IND_EXPRESSIONS`. 모든 컬럼의 datatype/length/precision/scale/default/nullability, 모든 PK/FK/check의 status·deferrable·delete rule, 함수 기반 인덱스 표현식과 자재 unique 컬럼 순서를 기대값과 대조한다. Expected: each new table count is `0`, and legacy definitions/counts match Step 1.

- [ ] **Step 5: Re-run DDL to prove safe repeat behavior**

Expected: succeeds only after confirming every existing definition matches; no object or data changes.

Oracle DDL은 auto-commit이므로 이후 애플리케이션 작업이 막혀도 신규 빈 테이블은 단계적 배포 상태로 남는 것을 수용한다. DROP이나 자동 롤백은 하지 않으며, 막힌 원인·DB 객체 상태·후속 책임을 필수 미완료 보고서에 기록한다.

### Task 3: Map TypeORM entities to the live schema

**Files:**
- Modify: `apps/backend/src/entities/routing-group.entity.ts`
- Modify: `apps/backend/src/entities/routing-process.entity.ts`
- Modify: `apps/backend/src/entities/routing-material.entity.ts`
- Create: `apps/backend/src/entities/ip-routing-entities.structure.test.mjs`
- Modify: `apps/backend/src/database/database.module.ts`
- Modify: `apps/backend/src/modules/master/master-routing-group.module.ts`

- [ ] **Step 1: Write a failing entity contract test**

Assert `@Entity({ name: 'IP_ROUTING_*' })`, `PROCESS_SEQ`, `WORKSTAGE_CODE`, `SUBCON_SUPPLIER_CODE`, `STANDARD_TIME`, and absence of `PROCESS_NAME`, QC, circuit, SG/FG label and self-inspection fields.

- [ ] **Step 2: Run and confirm RED**

Run: `node --test apps/backend/src/entities/ip-routing-entities.structure.test.mjs`

Expected: FAIL on current `ROUTING_*`, `SEQ`, `PROCESS_CODE`, and legacy columns.

- [ ] **Step 3: Implement exact entity mappings**

Use the types, lengths, nullability and defaults from the approved design. Keep TypeScript property names intention-revealing (`processSeq`, `workstageCode`, `subconSupplierCode`, `standardTime`).

- [ ] **Step 4: Remove excluded repositories from module wiring**

Keep unrelated entities intact; remove `ProcessQualityCondition` and self-inspection dependencies only from the routing-group module path.

- [ ] **Step 5: Run entity test and backend typecheck**

Run: `node --test apps/backend/src/entities/ip-routing-entities.structure.test.mjs`

Run: `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`

Expected: both PASS.

- [ ] **Step 6: Commit entity mapping**

정확한 6개 파일을 stage한 뒤 cached name/status와 check를 확인한다.

```bash
git add apps/backend/src/entities/routing-group.entity.ts apps/backend/src/entities/routing-process.entity.ts apps/backend/src/entities/routing-material.entity.ts apps/backend/src/entities/ip-routing-entities.structure.test.mjs apps/backend/src/database/database.module.ts apps/backend/src/modules/master/master-routing-group.module.ts
git diff --cached --name-status
git diff --cached --check
git commit --only -m "feat(master): map IP routing entities" -- apps/backend/src/entities/routing-group.entity.ts apps/backend/src/entities/routing-process.entity.ts apps/backend/src/entities/routing-material.entity.ts apps/backend/src/entities/ip-routing-entities.structure.test.mjs apps/backend/src/database/database.module.ts apps/backend/src/modules/master/master-routing-group.module.ts
```

### Task 4: Define DTO and controller contracts

**Files:**
- Modify: `apps/backend/src/modules/master/dto/routing-group.dto.ts`
- Modify: `apps/backend/src/modules/master/controllers/routing-group.controller.ts`
- Create: `apps/backend/src/modules/master/controllers/routing-group.controller.spec.ts`

- [ ] **Step 1: Write failing controller/DTO tests**

Test `JwtAuthGuard` metadata, organization only from `@OrganizationId()`, no conditions endpoints, no legacy `GET by-item/:itemCode`, materials path without `/bulk`, explicit `{ upserts, deletes }`, process-order DTO, positive quantities, approved enum values. The UI will use the approved group list/detail endpoints instead of `by-item`.

- [ ] **Step 2: Run focused tests and confirm RED**

Run: `pnpm --filter @eunsung/backend test -- routing-group.controller.spec.ts --runInBand`

Expected: FAIL on missing guard and old condition/bulk contracts.

- [ ] **Step 3: Implement minimal DTOs and controller routes**

Do not accept `organizationId` in body/query DTOs. Keep routing code immutable on update. Map validation failures to 422 and preserve 409 service exceptions.

- [ ] **Step 4: Run focused tests and confirm GREEN**

Run: `pnpm --filter @eunsung/backend test -- routing-group.controller.spec.ts --runInBand`

Expected: PASS.

- [ ] **Step 5: Commit API contract**

정확한 DTO/controller/spec 세 파일만 stage하고 cached diff를 확인한다.

```bash
git add apps/backend/src/modules/master/dto/routing-group.dto.ts apps/backend/src/modules/master/controllers/routing-group.controller.ts apps/backend/src/modules/master/controllers/routing-group.controller.spec.ts
git diff --cached --name-status
git diff --cached --check
git commit --only -m "feat(master): define IP routing API contract" -- apps/backend/src/modules/master/dto/routing-group.dto.ts apps/backend/src/modules/master/controllers/routing-group.controller.ts apps/backend/src/modules/master/controllers/routing-group.controller.spec.ts
```

### Task 5: Implement group and process business rules

**Files:**
- Modify: `apps/backend/src/modules/master/services/routing-group.service.ts`
- Modify: `apps/backend/src/modules/master/services/routing-group.service.spec.ts`

- [ ] **Step 1: Preserve valid coverage and add failing 은성 rules**

현재 테스트 중 그룹/공정 CRUD와 트랜잭션의 여전히 유효한 검증은 유지한다. 품질조건 등 폐기된 복사 계약 assertion만 제거하거나 교체한다. Cover: one active group per item, ORA-00001 → 409, item/workstage/supplier organization checks, `SUBCON` supplier required, `INTERNAL` clears supplier, child-bearing deletes return 409, process sequence cannot change through ordinary update.

- [ ] **Step 2: Run focused tests and confirm RED**

Run: `pnpm --filter @eunsung/backend test -- routing-group.service.spec.ts --runInBand`

Expected: FAIL on current cascade deletes and copied master rules.

- [ ] **Step 3: Implement minimal group/process logic**

Use query-runner transactions for multi-row operations. Create a fresh named-bind object for every raw query call. Derive process name from `IP_PRODUCT_WORKSTAGE`; never persist it.

- [ ] **Step 4: Add and implement process-order tests**

Test valid swap, temp-sequence collision prevention, FK preservation, invalid duplicate targets, and rollback after a mid-transaction failure. Defer only the named materials-process FK inside this transaction.

- [ ] **Step 5: Run focused tests and typecheck**

Run: `pnpm --filter @eunsung/backend test -- routing-group.service.spec.ts --runInBand`

Run: `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`

Expected: PASS.

- [ ] **Step 6: Commit group/process behavior**

서비스와 spec 두 파일의 cached diff만 확인해 커밋한다.

```bash
git add apps/backend/src/modules/master/services/routing-group.service.ts apps/backend/src/modules/master/services/routing-group.service.spec.ts
git diff --cached --name-status
git diff --cached --check
git commit --only -m "feat(master): enforce routing group and process rules" -- apps/backend/src/modules/master/services/routing-group.service.ts apps/backend/src/modules/master/services/routing-group.service.spec.ts
```

### Task 6: Implement BOM candidate and material assignment rules

**Files:**
- Modify: `apps/backend/src/modules/master/services/routing-group.service.ts`
- Modify: `apps/backend/src/modules/master/services/routing-group.service.spec.ts`

- [ ] **Step 1: Write failing BOM candidate tests**

Test `DATESET <= TRUNC(SYSDATE) AND DATEEND >= TRUNC(SYSDATE)`, `ITEM_UNIT_QTY` as `bomQty`, overlapping current rows → 422, assigned process metadata, and stale saved rows returned with `bomMatchYn='N'`.

- [ ] **Step 2: Write failing material mutation tests**

Test positive quantity, BOM membership, explicit upsert/delete, omitted row preservation, same-routing unique assignment, other-process mutation/deletion → 409 with `assignedProcessSeq`, stale explicit deletion, and full rollback.

- [ ] **Step 3: Run focused tests and confirm RED**

Run: `pnpm --filter @eunsung/backend test -- routing-group.service.spec.ts --runInBand`

- [ ] **Step 4: Implement candidate merge and transactional mutations**

Return `{ childItemCode, bomQty, allocQty, bomMatchYn, mismatchReason, assignedProcessSeq, selectableYn, issueMethod }`. Validate every requested row before performing mutations and never auto-delete stale or omitted rows.

- [ ] **Step 5: Run backend tests and typecheck**

Run: `pnpm --filter @eunsung/backend test -- routing-group.service.spec.ts --runInBand`

Run: `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`

Expected: PASS.

- [ ] **Step 6: Commit BOM/material behavior**

서비스와 spec 두 파일의 cached diff만 확인해 커밋한다.

```bash
git add apps/backend/src/modules/master/services/routing-group.service.ts apps/backend/src/modules/master/services/routing-group.service.spec.ts
git diff --cached --name-status
git diff --cached --check
git commit --only -m "feat(master): assign BOM materials to routing processes" -- apps/backend/src/modules/master/services/routing-group.service.ts apps/backend/src/modules/master/services/routing-group.service.spec.ts
```

### Task 7: Simplify and connect the routing UI

**Files:**
- Modify: `apps/frontend/src/app/(authenticated)/master/routing/types.ts`
- Modify: `apps/frontend/src/app/(authenticated)/master/routing/page.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/master/routing/components/RoutingGroupManager.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/master/routing/components/RoutingMaterialEditor.tsx`
- Delete: `apps/frontend/src/app/(authenticated)/master/routing/components/QualityConditionEditor.tsx`
- Delete: `apps/frontend/src/app/(authenticated)/master/routing/components/SelfInspectConfigEditor.tsx`
- Create: `apps/frontend/src/app/(authenticated)/master/routing/ip-routing.structure.test.mjs`

- [ ] **Step 1: Write a failing frontend structure test**

Assert excluded imports/components and `/conditions`, `/self-inspect`, `/materials/bulk` calls are absent; new material fields and explicit `upserts/deletes` are present; page remains a thin assembler.

- [ ] **Step 2: Run and confirm RED**

Run: `node --test "apps/frontend/src/app/(authenticated)/master/routing/ip-routing.structure.test.mjs"`

- [ ] **Step 3: Update types and page composition**

Remove quality/self types and tabs. Retain selected group/process state and material editor only.

- [ ] **Step 4: Adapt group/process forms**

Use existing shared item, process and supplier selectors. Show execution type, job-order flag, nonnegative times and use flag. Remove SG/FG label controls and the `by-item` request, then compose selection from the approved group list and group detail endpoints. Display 409/422 messages through project toast/modal components.

- [ ] **Step 5: Implement BOM candidate grid behavior**

Show BOM match status, current assigned process, selection availability, BOM quantity, allocation quantity and issue method. Disable other-process rows. Show stale rows with warning styling and a separate explicit delete action.

- [ ] **Step 6: Run focused and workspace checks**

Run: `node --test "apps/frontend/src/app/(authenticated)/master/routing/ip-routing.structure.test.mjs"`

Run: `pnpm --filter @eunsung/frontend test`

Run: `pnpm --filter @eunsung/frontend typecheck`

Expected: PASS.

- [ ] **Step 7: Commit UI change**

```bash
git add "apps/frontend/src/app/(authenticated)/master/routing/types.ts" "apps/frontend/src/app/(authenticated)/master/routing/page.tsx" "apps/frontend/src/app/(authenticated)/master/routing/components/RoutingGroupManager.tsx" "apps/frontend/src/app/(authenticated)/master/routing/components/RoutingMaterialEditor.tsx" "apps/frontend/src/app/(authenticated)/master/routing/components/QualityConditionEditor.tsx" "apps/frontend/src/app/(authenticated)/master/routing/components/SelfInspectConfigEditor.tsx" "apps/frontend/src/app/(authenticated)/master/routing/ip-routing.structure.test.mjs"
git diff --cached --name-status
git diff --cached --check
git commit --only -m "feat(master): manage IP routing from current BOM" -- "apps/frontend/src/app/(authenticated)/master/routing/types.ts" "apps/frontend/src/app/(authenticated)/master/routing/page.tsx" "apps/frontend/src/app/(authenticated)/master/routing/components/RoutingGroupManager.tsx" "apps/frontend/src/app/(authenticated)/master/routing/components/RoutingMaterialEditor.tsx" "apps/frontend/src/app/(authenticated)/master/routing/components/QualityConditionEditor.tsx" "apps/frontend/src/app/(authenticated)/master/routing/components/SelfInspectConfigEditor.tsx" "apps/frontend/src/app/(authenticated)/master/routing/ip-routing.structure.test.mjs"
```

### Task 8: Update routing help and domain documentation

**Files:**
- Modify: `apps/frontend/src/app/(authenticated)/master/routing/components/RoutingFieldHelp.tsx`
- Modify: `apps/frontend/public/help/user/ko/MST_ROUTING.md`
- Modify: `apps/frontend/public/help/operator/ko/MST_ROUTING.md`
- Modify: `CONTEXT.md`

- [ ] **Step 1: Update terminology and operational guidance**

Document 라우팅 그룹, 공정, 공정별 투입자재, 현재 BOM 후보, 타 공정 중복 금지, stale 명시 삭제, 내작/외주 공급처 규칙. Do not mention excluded quality/self-inspection features.

- [ ] **Step 2: Run help/registry checks through frontend test**

Run: `pnpm --filter @eunsung/frontend test`

Expected: PASS with help manifest and page registration checks.

- [ ] **Step 3: Commit documentation**

```bash
git add "apps/frontend/src/app/(authenticated)/master/routing/components/RoutingFieldHelp.tsx" "apps/frontend/public/help/user/ko/MST_ROUTING.md" "apps/frontend/public/help/operator/ko/MST_ROUTING.md"
git diff --cached --name-status
git diff --cached --check
git commit --only -m "docs: explain IP routing management" -- "apps/frontend/src/app/(authenticated)/master/routing/components/RoutingFieldHelp.tsx" "apps/frontend/public/help/user/ko/MST_ROUTING.md" "apps/frontend/public/help/operator/ko/MST_ROUTING.md"
```

`CONTEXT.md` 라우팅 갱신은 기존 사용자 변경과 함께 작업 트리에 보존하고 이 커밋에는 포함하지 않는다.

### Task 9: Verify the complete application and live data flow

**Files:**
- Create only if blocked: `docs/reports/2026-07-12-ip-routing-unfinished.md`

- [ ] **Step 1: Run backend verification**

Run: `pnpm --filter @eunsung/backend test`

Run: `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`

Expected: PASS.

- [ ] **Step 2: Run frontend verification**

Run: `pnpm --filter @eunsung/frontend test`

Run: `pnpm --filter @eunsung/frontend typecheck`

Expected: PASS. Do not run `pnpm build` while dev servers are running.

- [ ] **Step 3: Reconfirm live Oracle structure and pre-runtime counts**

Use `oracle-db` connector. Expected: exact three-table definition, enabled constraints, initial `0/0/0`, and unchanged legacy counts recorded earlier.

- [ ] **Step 4: Verify authenticated backend API on port 3003**

With the user's existing server and session, create a uniquely named test routing for a real upper item that has a current BOM; immediately persist the unique routing key in the verification log; add two processes; assign one BOM child; prove a second-process assignment returns 409; verify 404/422 responses; reorder processes and confirm the material FK follows the new sequence. Do not modify production BOM data. Stale preservation/deletion is mandatory in service tests and mocked UI behavior; at runtime only read-verify it when a pre-existing stale assignment is discovered.

From the first successful create onward, perform cleanup in a `finally` path. If any later API, proxy or UI assertion fails, cleanup still deletes test material → processes → group. If normal cleanup fails, issue a recovery cleanup using the persisted unique key and record the exact remaining rows.

- [ ] **Step 5: Verify the frontend proxy API on port 3100**

Send an authenticated request through the frontend proxy for the created routing and record status plus representative response fields. Expected: it matches backend data and preserves `bomMatchYn`, `assignedProcessSeq`, `selectableYn`, quantities and issue method.

- [ ] **Step 6: Verify the rendered page on port 3100**

Use the existing authenticated Chrome session. Confirm group/process creation, all BOM children visible, assigned row disabled in another process, quantities and issue method visible, excluded tabs absent, and errors actionable. Do not start another server or use another port.

- [ ] **Step 7: Clean test routing data**

Delete test material, processes, then group through the authenticated API. Query Oracle to confirm no test-key rows remain and legacy counts are unchanged.

- [ ] **Step 8: Handle unavailable runtime honestly**

If 3003/3100 or authenticated access is unavailable, do not mark complete. Create `docs/reports/2026-07-12-ip-routing-unfinished.md` under manifest rules with exact unverified steps, current DB/code state, DDL auto-commit staged-deployment state, remaining test keys, and recovery owner/action.

- [ ] **Step 9: Inspect scoped diff and commit remaining intended files only**

Run: `git status --short`

Run: `git diff --check`

Do not stage or commit unrelated pre-existing worktree changes.
