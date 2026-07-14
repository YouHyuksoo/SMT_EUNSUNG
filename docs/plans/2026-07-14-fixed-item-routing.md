# Fixed Item Routing Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 현재 BOM이 있는 W/F 품목마다 고정 라우팅 하나를 관리하고, 공정별 라벨발행 Y/N과 BOM 자재 배정을 저장·조회한다.

**Architecture:** 기존 `IP_ROUTING_GROUPS / IP_ROUTING_PROCESSES / IP_ROUTING_MATERIALS`와 `master/routing-groups` API를 유지한다. 그룹은 `routingCode=itemCode` 및 조직·품목 단일성을 서버와 Oracle에서 강제하고, 전용 후보 API가 W/F·BOM 상태를 서버 검색/페이지 방식으로 제공한다. 라벨은 공정의 `LABEL_ISSUE_YN`만 저장하며 실제 채번·인쇄는 구현하지 않는다.

**Tech Stack:** Oracle, NestJS 11, TypeORM, class-validator, Jest, Next.js/React 19, TypeScript, node:test, pnpm/turborepo

---

## 실행 전 조건

- 기준 설계: `docs/specs/2026-07-14-fixed-item-routing-design.md`
- 기준 커밋: `2cf48a4`
- 구현은 현재 작업 중인 근무달력 파일과 분리된 worktree/브랜치에서 수행한다.
- 사용자가 실행하지 않은 dev 서버를 임의로 기동하지 않는다.
- DB 작업은 `@oracle-db`로 실제 스키마와 사전 건수를 다시 확인한 뒤 수행한다.
- 각 코드 작업은 `@tdd`의 red → green → refactor 순서를 따른다.
- 품질검사·품질조건·자주검사·회로 연결과 실제 라벨 채번·인쇄는 구현하지 않는다.

## 파일 책임 지도

| 책임 | 파일 |
|---|---|
| 신규/기존 Oracle 구조 | `apps/backend/src/migrations/2026-07-12_ip_routing_tables.sql`, 신규 `apps/backend/src/migrations/2026-07-14_fixed_item_routing.sql` |
| DDL 구조 회귀 | `apps/backend/src/migrations/ip-routing-tables.structure.test.mjs` |
| 라우팅 엔티티 | `apps/backend/src/entities/routing-group.entity.ts`, `routing-process.entity.ts` |
| 엔티티 구조 회귀 | `apps/backend/src/entities/ip-routing-entities.structure.test.mjs` |
| API 입력 계약 | `apps/backend/src/modules/master/dto/routing-group.dto.ts` |
| 업무 규칙·후보 조회 | `apps/backend/src/modules/master/services/routing-group.service.ts` |
| 서비스 단위 테스트 | `apps/backend/src/modules/master/services/routing-group.service.spec.ts` |
| API 경로·Guard | `apps/backend/src/modules/master/controllers/routing-group.controller.ts`, `routing-group.controller.spec.ts` |
| 프론트 계약 | `apps/frontend/src/app/(authenticated)/master/routing/types.ts` |
| 품목 후보 선택 | 신규 `components/RoutingCandidateItemSelect.tsx` |
| 그룹·공정 편집 | `components/RoutingGroupManager.tsx`, `RoutingFieldHelp.tsx` |
| 프론트 구조 회귀 | `ip-routing.eunsung.structure.test.mjs` 및 신규/기존 라우팅 구조 테스트 |
| 구현 후 DB 문서 | `docs/database/ip-routing.md` |

### Task 1: Oracle 최종 구조를 테스트로 고정

**Files:**
- Modify: `apps/backend/src/migrations/ip-routing-tables.structure.test.mjs`
- Modify: `apps/backend/src/migrations/2026-07-12_ip_routing_tables.sql`
- Create: `apps/backend/src/migrations/2026-07-14_fixed_item_routing.sql`

- [ ] **Step 1: 새 구조를 요구하는 실패 테스트 작성**

기존 구조 테스트에 다음 계약을 추가한다.

```js
assert.match(sql, /LABEL_ISSUE_YN VARCHAR2\(1\) DEFAULT 'N' NOT NULL/);
assert.match(sql, /CONSTRAINT CK_IP_RP_LABEL_ISSUE CHECK \(LABEL_ISSUE_YN IN \('Y', 'N'\)\)/);
assert.match(compact, /CONSTRAINT UK_IP_RG_ITEM UNIQUE \(ORGANIZATION_ID, ITEM_CODE\)/);
assert.doesNotMatch(sql, /UK_IP_RG_ACTIVE_ITEM/);

assert.match(upgradeSql, /ALTER TABLE IP_ROUTING_PROCESSES ADD \(LABEL_ISSUE_YN/);
assert.match(upgradeSql, /DROP INDEX UK_IP_RG_ACTIVE_ITEM/);
assert.match(upgradeSql, /ADD CONSTRAINT UK_IP_RG_ITEM UNIQUE/);
```

증분 DDL 검증은 사전 중복 조회, 기존 객체 정의 검증, 재실행 안전성, 예상과 다른 객체에서의 중단도 요구한다.

- [ ] **Step 2: 구조 테스트가 실패하는지 확인**

Run:

```powershell
node --test apps/backend/src/migrations/ip-routing-tables.structure.test.mjs
```

Expected: `LABEL_ISSUE_YN` 또는 `UK_IP_RG_ITEM` 계약 누락으로 FAIL.

- [ ] **Step 3: 신규 설치 기준선 DDL 수정**

`2026-07-12_ip_routing_tables.sql`의 `IP_ROUTING_PROCESSES` 생성부에 컬럼과 check를 추가하고 공정 컬럼 수 검증을 15개로 갱신한다. 활성 행 함수 기반 인덱스 생성·정확 검증은 제거하고 다음 제약을 생성·검증한다.

```sql
CONSTRAINT UK_IP_RG_ITEM UNIQUE (ORGANIZATION_ID, ITEM_CODE)
```

`LABEL_ISSUE_YN`의 자료형, nullable, 기본값, check도 `assert_column`, `assert_default`, `assert_check`로 정확히 검증한다.

- [ ] **Step 4: 기존 Oracle용 증분 DDL 작성**

`2026-07-14_fixed_item_routing.sql`은 다음 순서로 동작한다.

1. `IP_ROUTING_GROUPS`와 `IP_ROUTING_PROCESSES` 존재 및 예상 기준 구조 확인
2. `ORGANIZATION_ID + ITEM_CODE` 중복이 있으면 식별 가능한 오류로 중단
3. `LABEL_ISSUE_YN`이 없으면 기본값 `N`으로 추가, 있으면 정확 정의 검증
4. `CK_IP_RP_LABEL_ISSUE` 생성 또는 정확 정의 검증
5. `UK_IP_RG_ACTIVE_ITEM`이 정확한 기존 인덱스일 때만 제거
6. `UK_IP_RG_ITEM` 생성 또는 정확 정의 검증
7. COMMIT 없이 DDL 결과 검증

임의 drop/alter는 하지 않고 예상과 다른 동명 객체면 중단한다.

- [ ] **Step 5: 구조 테스트 통과 확인**

Run:

```powershell
node --test apps/backend/src/migrations/ip-routing-tables.structure.test.mjs
```

Expected: 전체 PASS.

- [ ] **Step 6: DDL 변경 커밋**

```powershell
git add apps/backend/src/migrations/2026-07-12_ip_routing_tables.sql apps/backend/src/migrations/2026-07-14_fixed_item_routing.sql apps/backend/src/migrations/ip-routing-tables.structure.test.mjs
git commit -m "feat: migrate routing to fixed item model"
```

### Task 2: 공정별 라벨발행 Y/N 백엔드 계약 추가

**Files:**
- Modify: `apps/backend/src/entities/routing-process.entity.ts`
- Modify: `apps/backend/src/entities/ip-routing-entities.structure.test.mjs`
- Modify: `apps/backend/src/modules/master/dto/routing-group.dto.ts`
- Modify: `apps/backend/src/modules/master/controllers/routing-group.controller.spec.ts`
- Modify: `apps/backend/src/modules/master/services/routing-group.service.ts`
- Modify: `apps/backend/src/modules/master/services/routing-group.service.spec.ts`

- [ ] **Step 1: 엔티티·DTO·서비스 실패 테스트 작성**

다음을 검증한다.

```ts
expect(validatedProperties(CreateRoutingProcessDto)).toContain('labelIssueYn');
expect(await errors(CreateRoutingProcessDto, {
  seq: 10, workstageCode: 'SMT', labelIssueYn: 'Y',
})).toHaveLength(0);
expect(await errors(CreateRoutingProcessDto, {
  seq: 10, workstageCode: 'SMT', labelIssueYn: 'YES',
})).not.toHaveLength(0);
```

서비스 테스트는 서로 다른 두 공정 모두 `labelIssueYn: 'Y'`로 생성 가능하고 생성/수정 저장값이 유지되는지 확인한다. 엔티티 구조 테스트는 `LABEL_ISSUE_YN`을 필수로 요구하고 `ISSUE_LABEL_TYPE`은 계속 금지한다.

- [ ] **Step 2: 대상 테스트가 실패하는지 확인**

Run:

```powershell
node --test apps/backend/src/entities/ip-routing-entities.structure.test.mjs
pnpm --filter @eunsung/backend test -- routing-group.controller.spec.ts routing-group.service.spec.ts --runInBand
```

Expected: 새 필드 계약 누락으로 FAIL.

- [ ] **Step 3: 최소 엔티티·DTO 구현**

`routing-process.entity.ts`:

```ts
@Column({
  name: 'LABEL_ISSUE_YN',
  type: 'varchar2',
  length: 1,
  default: 'N',
  nullable: false,
})
labelIssueYn!: 'Y' | 'N';
```

`CreateRoutingProcessDto`와 `UpdateRoutingProcessDto`에 `@IsIn(YN_VALUES)` 기반 `labelIssueYn`을 추가한다. `issueLabelType` 또는 라벨 종류 enum은 만들지 않는다.

- [ ] **Step 4: 생성·수정 매핑 구현**

생성 시 기본값을 명시하고 수정 시 DTO의 값을 그대로 반영한다.

```ts
labelIssueYn: dto.labelIssueYn ?? 'N',
```

여러 공정의 `Y`를 제한하는 조회나 유니크 검사는 추가하지 않는다.

- [ ] **Step 5: 대상 테스트 통과 확인**

Task 2 Step 2 명령을 다시 실행한다.

Expected: 전체 PASS.

- [ ] **Step 6: 라벨 계약 커밋**

```powershell
git add apps/backend/src/entities/routing-process.entity.ts apps/backend/src/entities/ip-routing-entities.structure.test.mjs apps/backend/src/modules/master/dto/routing-group.dto.ts apps/backend/src/modules/master/controllers/routing-group.controller.spec.ts apps/backend/src/modules/master/services/routing-group.service.ts apps/backend/src/modules/master/services/routing-group.service.spec.ts
git commit -m "feat: add routing process label issue flag"
```

### Task 3: 품목별 고정 라우팅과 후보 API 구현

**Files:**
- Modify: `apps/backend/src/modules/master/dto/routing-group.dto.ts`
- Modify: `apps/backend/src/entities/routing-group.entity.ts`
- Modify: `apps/backend/src/entities/ip-routing-entities.structure.test.mjs`
- Modify: `apps/backend/src/modules/master/controllers/routing-group.controller.ts`
- Modify: `apps/backend/src/modules/master/controllers/routing-group.controller.spec.ts`
- Modify: `apps/backend/src/modules/master/services/routing-group.service.ts`
- Modify: `apps/backend/src/modules/master/services/routing-group.service.spec.ts`

- [ ] **Step 1: 고정 라우팅 실패 테스트 작성**

서비스 테스트에 다음 시나리오를 추가한다.

- `routingCode !== itemCode` 생성은 `ConflictException`
- W/F가 아닌 품목은 `UnprocessableEntityException`
- 현재 BOM이 없는 W/F는 `UnprocessableEntityException`
- 비활성 라우팅이 이미 있어도 동일 품목 추가는 `ConflictException`
- W/F + 현재 BOM + `routingCode=itemCode`는 생성 성공
- `ORA-00001`은 동일 품목 충돌 메시지의 HTTP 409로 변환
- `RoutingGroup` 엔티티는 `ORGANIZATION_ID + ITEM_CODE` 유니크 인덱스 메타데이터를 가진다.

- [ ] **Step 2: 후보 API 계약 실패 테스트 작성**

`RoutingCandidateItemQueryDto`는 `PaginationQueryDto`를 상속하고 선택적 `search`를 가진다. 컨트롤러 경로 목록에 `GET candidate-items`를 추가하고 `candidateItems` 메서드가 `findOne`보다 먼저 선언되었는지 검증한다.

서비스 테스트는 다음 응답을 요구한다.

```ts
{
  data: [{
    itemCode: 'W100',
    itemName: '반제품',
    itemDivision: 'W',
    bomRegisteredYn: 'Y',
    selectableYn: 'Y',
  }],
  total: 2,
  page: 1,
  limit: 50,
}
```

100건을 넘는 페이지, 검색어, BOM 미등록 `selectableYn='N'`, 기존 라우팅 `selectableYn='N'`을 검증한다. count 쿼리의 bind 객체를 mock에서 변형한 뒤 data 쿼리 bind가 오염되지 않는 회귀 테스트를 둔다.

- [ ] **Step 3: 실패 확인**

Run:

```powershell
pnpm --filter @eunsung/backend test -- routing-group.controller.spec.ts routing-group.service.spec.ts --runInBand
```

Expected: 고정 코드/후보 API 미구현으로 FAIL.

- [ ] **Step 4: 후보 DTO·정적 컨트롤러 경로 구현**

`@Get('candidate-items')`를 `@Get(':code')`보다 앞에 둔다.

```ts
@Get('candidate-items')
async findCandidateItems(
  @Query() query: RoutingCandidateItemQueryDto,
  @OrganizationId() organizationId: number,
) {
  const result = await this.svc.findCandidateItems(query, organizationId);
  return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
}
```

- [ ] **Step 5: 서버 검색·페이지 후보 조회 구현**

`ID_ITEM`을 기준으로 `ITEM_DIVISION IN ('W','F')`를 적용하고, 현재 날짜의 `ID_ENG_BOM` 존재 여부와 `IP_ROUTING_GROUPS` 등록 여부를 `EXISTS`로 계산한다. 검색은 품목코드/품목명에 적용하고 `OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`를 사용한다.

현재 BOM 조건은 기존 자재 조회와 동일하게 `DATESET <= TRUNC(SYSDATE)` 및
`DATEEND >= TRUNC(SYSDATE)`를 사용한다. 검색 조건은 항상
`(:search IS NULL OR ITEM_CODE LIKE :search OR ITEM_NAME LIKE :search)` 형태로 두어
검색어가 없어도 count/data SQL의 bind 계약이 일정하게 유지되게 한다.

Oracle 드라이버 bind 변형 회귀를 막기 위해 두 호출에 새 객체를 전달한다.

```ts
const countBinds = { organizationId, search: searchPattern };
const dataBinds = {
  organizationId,
  search: searchPattern,
  offset: (page - 1) * limit,
  limit,
};
const countRows = await this.itemRepo.query(countSql, countBinds as never);
const data = await this.itemRepo.query(dataSql, dataBinds as never);
```

- [ ] **Step 6: 그룹 생성 규칙 구현**

`ensureItem`을 W/F 확인과 현재 BOM 확인을 포함하는 `ensureRoutingItem`으로 좁힌다. `ensureSingleActive`는 활성 여부와 무관한 `ensureSingleRoute`로 변경한다.

```ts
if (dto.routingCode !== dto.itemCode) {
  throw new ConflictException('라우팅 코드는 품목코드와 같아야 합니다.');
}
```

`routingName`, `description`, `useYn`은 기존 계약을 유지한다. 그룹 수정에서 활성 버전 전환 검사는 제거한다.
`routing-group.entity.ts`에는 다음 인덱스 메타데이터를 추가한다.

```ts
@Index('UK_IP_RG_ITEM', ['organizationId', 'itemCode'], { unique: true })
```

- [ ] **Step 7: 대상 테스트 통과 확인**

Task 3 Step 3 명령을 다시 실행한다.

Expected: 전체 PASS.

- [ ] **Step 8: 고정 라우팅 API 커밋**

```powershell
git add apps/backend/src/entities/routing-group.entity.ts apps/backend/src/entities/ip-routing-entities.structure.test.mjs apps/backend/src/modules/master/dto/routing-group.dto.ts apps/backend/src/modules/master/controllers/routing-group.controller.ts apps/backend/src/modules/master/controllers/routing-group.controller.spec.ts apps/backend/src/modules/master/services/routing-group.service.ts apps/backend/src/modules/master/services/routing-group.service.spec.ts
git commit -m "feat: enforce fixed routing per bom item"
```

### Task 4: 라우팅 전용 품목 후보 선택기 구현

**Files:**
- Modify: `apps/frontend/src/app/(authenticated)/master/routing/types.ts`
- Create: `apps/frontend/src/app/(authenticated)/master/routing/components/RoutingCandidateItemSelect.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/master/routing/components/RoutingGroupManager.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/master/routing/ip-routing.eunsung.structure.test.mjs`
- Test: 신규 `apps/frontend/src/app/(authenticated)/master/routing/routing-fixed-item.eunsung.structure.test.mjs`

- [ ] **Step 1: 프론트 구조 실패 테스트 작성**

다음을 요구한다.

```js
assert.match(candidate, /\/master\/routing-groups\/candidate-items/);
assert.match(candidate, /bomRegisteredYn/);
assert.match(candidate, /selectableYn/);
assert.match(candidate, /page/);
assert.match(manager, /routingCode:item\.itemCode/);
assert.doesNotMatch(manager, /<PartSelect/);
```

기존 `ip-routing.eunsung.structure.test.mjs`의 금지 목록은 유지한다.

- [ ] **Step 2: 구조 테스트 실패 확인**

Run:

```powershell
pnpm --filter @eunsung/frontend test
```

Expected: 후보 선택기/고정 코드 계약 누락으로 FAIL.

- [ ] **Step 3: 후보 타입과 전용 선택기 구현**

`types.ts`:

```ts
export interface RoutingCandidateItem {
  itemCode: string;
  itemName: string | null;
  itemDivision: 'W' | 'F';
  bomRegisteredYn: 'Y' | 'N';
  selectableYn: 'Y' | 'N';
}
```

`RoutingCandidateItemSelect.tsx`는 검색어, 현재 페이지, 로딩, 선택값만 소유한다. 검색/페이지 변경마다 전용 API를 호출하고 이전 요청을 `AbortController`로 취소한다. BOM 미등록 또는 이미 등록된 품목은 사유 badge와 disabled 상태로 표시한다.

- [ ] **Step 4: 그룹 등록 폼 연결**

`PartSelect`를 제거하고 후보 선택 결과로 세 필드를 한 번에 설정한다.

```ts
onSelect={(item) => setGroupForm((form) => ({
  ...form,
  itemCode: item.itemCode,
  routingCode: item.itemCode,
  routingName: item.itemName ?? item.itemCode,
}))}
```

라우팅 코드 입력은 신규·수정 모두 읽기 전용으로 만들고, 저장 직전에도 `routingCode === itemCode`를 확인한다.

- [ ] **Step 5: 프론트 테스트 통과 확인**

Run:

```powershell
pnpm --filter @eunsung/frontend test
pnpm --filter @eunsung/frontend typecheck
```

Expected: 전체 PASS.

- [ ] **Step 6: 후보 선택 UI 커밋**

```powershell
git add -- "apps/frontend/src/app/(authenticated)/master/routing/types.ts" "apps/frontend/src/app/(authenticated)/master/routing/components/RoutingCandidateItemSelect.tsx" "apps/frontend/src/app/(authenticated)/master/routing/components/RoutingGroupManager.tsx" "apps/frontend/src/app/(authenticated)/master/routing/ip-routing.eunsung.structure.test.mjs" "apps/frontend/src/app/(authenticated)/master/routing/routing-fixed-item.eunsung.structure.test.mjs"
git commit -m "feat: add fixed routing item selector"
```

### Task 5: 공정 라벨발행 여부 UI 구현

**Files:**
- Modify: `apps/frontend/src/app/(authenticated)/master/routing/types.ts`
- Modify: `apps/frontend/src/app/(authenticated)/master/routing/components/RoutingGroupManager.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/master/routing/components/RoutingFieldHelp.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/master/routing/ip-routing.eunsung.structure.test.mjs`

- [ ] **Step 1: 실패 구조 테스트 작성**

`labelIssueYn`을 타입, 초기값 `N`, 편집값 복원, API body, 공정 목록 표시, 공정 폼 체크박스에서 모두 요구한다. `issueLabelType`, `BUNDLE`, `SG`, `FG`는 계속 금지한다.

- [ ] **Step 2: 실패 확인**

Run: `pnpm --filter @eunsung/frontend test`

Expected: `labelIssueYn` 누락으로 FAIL.

- [ ] **Step 3: 타입·폼·API body 구현**

`RoutingProcessItem`에 `labelIssueYn:'Y'|'N'`을 추가하고 공정 폼 기본값은 `N`으로 둔다.

```tsx
<label>
  <input
    type="checkbox"
    checked={processForm.labelIssueYn === 'Y'}
    onChange={(event) => setProcessForm((form) => ({
      ...form,
      labelIssueYn: event.target.checked ? 'Y' : 'N',
    }))}
  />
  라벨발행
</label>
```

공정 목록에는 `Y`인 행만 알아볼 수 있는 짧은 badge를 표시한다. 여러 행의 `Y`를 막는 UI 검증은 두지 않는다.

- [ ] **Step 4: 필드 도움말 추가**

`RoutingFieldHelp.tsx`에 `IP_ROUTING_PROCESSES.LABEL_ISSUE_YN`과 “실제 인쇄가 아닌 후속 발행 대상 여부”라는 경계를 기록한다.

- [ ] **Step 5: 테스트·typecheck 통과 확인**

Run:

```powershell
pnpm --filter @eunsung/frontend test
pnpm --filter @eunsung/frontend typecheck
```

Expected: 전체 PASS.

- [ ] **Step 6: 라벨 UI 커밋**

```powershell
git add -- "apps/frontend/src/app/(authenticated)/master/routing/types.ts" "apps/frontend/src/app/(authenticated)/master/routing/components/RoutingGroupManager.tsx" "apps/frontend/src/app/(authenticated)/master/routing/components/RoutingFieldHelp.tsx" "apps/frontend/src/app/(authenticated)/master/routing/ip-routing.eunsung.structure.test.mjs"
git commit -m "feat: manage label issue flag by routing process"
```

### Task 6: Oracle 증분 DDL 적용 및 실제 CRUD 검증

**Files:**
- Read/execute: `apps/backend/src/migrations/2026-07-14_fixed_item_routing.sql`
- Modify after evidence: `docs/database/ip-routing.md`

- [ ] **Step 1: 실제 스키마·데이터 사전 확인**

`@oracle-db`로 다음을 조회해 결과를 기록한다.

- 신규 세 테이블 건수
- `IP_ROUTING_PROCESSES` 컬럼·기본값·nullable
- `IP_ROUTING_GROUPS` 인덱스·제약
- `ORGANIZATION_ID + ITEM_CODE` 중복 건수
- 레거시 라우팅 두 테이블 건수

예상과 다르거나 신규 테이블에 데이터/중복이 있으면 DDL을 실행하지 않고 보고한다.

- [ ] **Step 2: 증분 DDL 실제 적용**

검증된 커넥터로 `2026-07-14_fixed_item_routing.sql`을 실행한다. SQL 파일 작성만으로 완료 처리하지 않는다.

- [ ] **Step 3: DDL 재실행 안전성 확인**

동일 스크립트를 다시 실행해 성공하고 구조가 변하지 않는지 확인한다.

- [ ] **Step 4: 구조 사후 확인**

`LABEL_ISSUE_YN`, 기본값 `N`, NOT NULL, check, `UK_IP_RG_ITEM`을 확인하고 `UK_IP_RG_ACTIVE_ITEM`이 제거되었는지 확인한다. 레거시 및 신규 테이블 사전 건수와 비교한다.

- [ ] **Step 5: 식별 가능한 테스트 CRUD 수행**

현재 BOM이 있는 테스트 W/F 품목 하나를 선정해 다음을 검증한다.

1. `routingCode=itemCode` 그룹 생성
2. 서로 다른 공정 두 개에 `LABEL_ISSUE_YN='Y'` 저장
3. BOM 자재를 서로 다른 공정에 배정
4. 동일 품목 두 번째 그룹과 다른 코드 생성 차단
5. BOM 비소속 자재 차단
6. 재조회 값 일치

- [ ] **Step 6: 검증 데이터 정리**

자재 → 공정 → 그룹 순으로 삭제하고 신규/레거시 테이블 건수가 사전 값으로 돌아왔는지 확인한다.

### Task 7: 전체 검증, 화면 확인, 문서 동기화

**Files:**
- Modify: `docs/database/ip-routing.md`
- Create only if blocked: `docs/reports/2026-07-14-fixed-item-routing.md`

- [ ] **Step 1: 백엔드 전체 대상 검증**

Run:

```powershell
node --test apps/backend/src/migrations/ip-routing-tables.structure.test.mjs apps/backend/src/entities/ip-routing-entities.structure.test.mjs
pnpm --filter @eunsung/backend test -- routing-group.controller.spec.ts routing-group.service.spec.ts --runInBand
pnpm --filter @eunsung/backend test
pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false
```

Expected: 실패 0.

- [ ] **Step 2: 프론트 전체 대상 검증**

Run:

```powershell
pnpm --filter @eunsung/frontend test
pnpm --filter @eunsung/frontend typecheck
```

Expected: 실패 0.

- [ ] **Step 3: 서버 상태 확인**

3003/3100이 이미 실행 중인지 확인한다. 실행 중이 아니면 서버를 시작하거나 다른 포트를 사용하지 않고 Step 6의 미완료 기록으로 이동한다.

- [ ] **Step 4: 인증 API 흐름 확인**

기존 로그인 세션으로 다음을 확인한다.

- 후보 API 검색·2페이지 이상·BOM 상태
- 그룹 생성 시 코드 자동 고정
- 공정 두 개의 라벨발행 Y 저장·재조회
- BOM 자재 배정·불일치 표시
- 품질·자주검사·회로·라벨종류 요청 부재

- [ ] **Step 5: 렌더된 화면 확인**

`@chrome:control-chrome`로 기존 사용자 Chrome 세션에 붙어 라우팅 화면을 확인한다. 후보 검색/페이지, disabled 사유, 공정 badge, 새로고침 후 값 유지, 여러 공정 Y를 확인한다.

- [ ] **Step 6: 문서와 미완료 상태 처리**

DB/API/UI 검증이 모두 끝나면 `docs/database/ip-routing.md`의 “구현 전” 문구를 실제 상태와 증거에 맞게 갱신하고 `verifiedCommit`을 구현 커밋으로 스탬프한다.
`sources`에는 7/14 증분 DDL과 후보 API·라벨 필드 구현 파일이 포함되어야 한다.

서버 미기동 등으로 API/UI 검증을 못 하면 완료로 주장하지 않고 `docs/reports/2026-07-14-fixed-item-routing.md`에 완료 항목, 미검증 항목, 재개 명령을 기록한다.

- [ ] **Step 7: 문서 커밋**

```powershell
git add docs/database/ip-routing.md
if (Test-Path "docs/reports/2026-07-14-fixed-item-routing.md") { git add -- "docs/reports/2026-07-14-fixed-item-routing.md" }
git commit -m "docs: record fixed routing verification"
```

## 최종 완료 조건

- Oracle 기준선/증분 DDL과 구조 테스트가 새 모델에 일치한다.
- W/F + 현재 BOM 품목만 `routingCode=itemCode` 고정 라우팅을 하나 가질 수 있다.
- 후보 API는 서버 검색·페이지·BOM/선택 상태를 제공하고 100건 제한이 없다.
- 여러 공정의 `labelIssueYn='Y'`가 저장·재조회된다.
- 라벨 종류, 품질, 자주검사, 회로 기능이 들어오지 않는다.
- BOM 자재 중복·불일치 규칙이 유지된다.
- Oracle 실제 CRUD 정리 후 건수가 원복된다.
- 백엔드 테스트/typecheck와 프론트 테스트/typecheck가 통과한다.
- 실행 중인 서버가 있으면 인증 API와 렌더 화면까지 확인한다. 없으면 미완료 보고서가 존재한다.
- 최종 완료 주장 전 `@verification-before-completion`으로 최신 검증 출력을 다시 확인한다.
