# 생산지시·생산실적·출하지시 분리 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 생산지시(런카드)를 공정 단위로 발행하고, 지시 대비 실적을 실적 테이블(IP_PRODUCT_WORK_RESULT)로 집계하며, 출하지시(IP_PRODUCT_DELIVERY_PLAN)를 등록하고 출고 박스와 잇는다.

**Architecture:** 새 테이블·컬럼 없이 기존 테이블만 쓴다. 후공정 지시 실적 SQL 조각을 `planning/order-result.sql.ts` 한 곳에 두고 생산 보드·대시보드가 같이 쓴다. 출하지시는 product 모듈에 서비스 하나를 더하고, 출고 서비스가 같은 트랜잭션에서 그 서비스를 불러 박스를 지시에 잇는다.

**Tech Stack:** NestJS 11 + TypeORM raw SQL(Oracle), Jest / Next.js 16 + React 19 + TanStack, node --test 구조 테스트, pnpm.

**Spec:** `docs/specs/2026-10-14-production-order-and-shipping-order-design.md`

## Global Constraints

- 패키지 매니저는 pnpm 만 쓴다. dev/백엔드 서버는 띄우지 않는다(사용자가 띄운다).
- DB 스키마 변경 없음. 새 테이블·컬럼·인덱스·트리거를 만들지 않는다.
- 후공정 지시 실적 = `IP_PRODUCT_WORK_RESULT.RESULT_STATUS = 'DONE'` 의 RESULT_QTY 합 (CANCEL 제외), 런카드 LOT_NO 가 IP_PRODUCT_MI_PLAN.MFS 인 것.
- SMT 지시 실적은 센서 실적(IP_ASSEMBLY_ACTUAL_TIME_V) 그대로. SMT 런카드의 WORK_RESULT 는 더하지 않는다.
- 작업일 시작은 08:30 (`F_GET_WORK_ACTUAL_DATE(dt, 'A')`, ICOM_WORKTIME_RANGES SMTWORKTIME 'A').
- 생산 보드 제품 행 = RUN_DATE 가 당일 작업일인 후공정 런카드만 (이월 없음).
- 출하지시번호(MFS) = `DLV` + YYMMDD(납기일) + 3자리 순번. LINE_CODE = `'*'`.
- 화면 문구는 사실 서술형 한국어. PB 언급 금지. `alert/confirm/prompt` 금지(모달·토스트 사용).
- 코드값 입력(고객·모델·공정)은 선택 컴포넌트로 받는다.
- `catch (error: unknown)` 유지, `as any` 금지.
- Oracle 오류(ORA-*/NJS-*) 원문을 지우지 않는다.
- 발주계획 화면(purchase/order-plan)은 건드리지 않는다.
- 제품생산계획·반제품생산계획 화면, 포장 흐름, 공정 통과 이력은 건드리지 않는다.

## Review Focus

1. **공정 미지정 기존 런카드에 첫 실적을 넣을 때** — 그 공정으로 런카드가 고정되고, 이후 다른 공정 실적은 거부돼야 한다 (Task 4 테스트).
2. **같은 계획의 두 번째 공정 런카드에서 PID 생성** — 같은 LOT_NO 의 다른 런카드에 PID 가 이미 있으면 거부해야 한다. 제품 하나에 PID 가 두 벌 생기면 추적이 깨진다 (Task 2 테스트).
3. **출하지시로 나간 박스의 출고 취소** — 박스의 SHIP_NO 로 지시를 찾아 ACTUAL_QTY 를 되돌리고 상태를 다시 계산해야 한다 (Task 7 테스트).
4. **출하지시 초과·모델 불일치·완료 지시에 스캔** — 거부되고 프로시저 결과도 롤백돼야 한다. 동시 스캔은 지시 행 `FOR UPDATE` 로 직렬화한다 (Task 7 테스트).
5. **작업일 경계** — 08:00 에 넣은 실적은 전날 작업일로, 08:40 실적은 당일로 잡혀야 한다 (Task 5·6 테스트).

---

## File Structure

| 파일 | 책임 |
|---|---|
| Create `apps/backend/src/modules/planning/order-result.sql.ts` | 후공정 지시 실적 SQL 조각 (단일 출처) |
| Create `apps/backend/src/modules/planning/order-result.sql.spec.ts` | 조각 테스트 |
| Modify `apps/backend/src/modules/run-card/lot-card.dto.ts`, `lot-card.service.ts`, `lot-card.service.spec.ts` | 공정 지정 발행·공정별 남은 수량·PID 중복 방지 |
| Modify `apps/frontend/src/components/shared/processOptions.mjs`, `ProcessSelect.tsx` | 제조공정 판별 공용 함수와 `manufacturingOnly` 옵션 |
| Modify `apps/frontend/src/app/(authenticated)/production/run-card/components/PlanPickerModal.tsx` | 후공정 계획이면 공정 선택 |
| Modify `apps/frontend/src/app/(authenticated)/oee/equip-work-result/components/ScopeModal.tsx` | 공용 제조공정 판별 함수 사용 |
| Modify `apps/backend/src/modules/work-result/work-result.controller.ts`, `work-result.service.ts`, `work-result.service.spec.ts` | 작업지시 공정 필터, 공정 고정 규칙 |
| Modify `apps/frontend/src/app/(authenticated)/oee/equip-work-result/components/RunPickerModal.tsx`, `page.tsx`, `_lib/types.ts` | 공정 필터 전달, 공정 미지정 표시 |
| Modify `apps/backend/src/modules/monitoring/services/production-board.service.ts`, `.spec.ts` | 제품 행 = 당일 후공정 런카드 + 실적 |
| Modify `apps/backend/src/modules/dashboard/dashboard.service.ts`, `dashboard-insights.sql.ts`, `dashboard.service.spec.ts` | 제품 실적 원천 교체 |
| Create `apps/backend/src/modules/product/dto/shipping-order.dto.ts`, `services/shipping-order.service.ts`, `services/shipping-order.service.spec.ts`, `controllers/shipping-order.controller.ts` | 출하지시 CRUD·출고 연결 |
| Modify `apps/backend/src/modules/product/product-inventory.module.ts` | 등록 |
| Modify `apps/backend/src/modules/product/dto/product-fg.dto.ts`, `services/product-fg.service.ts` | 출고 시 출하지시 연결 |
| Create `apps/frontend/src/app/(authenticated)/product/shipping-order/page.tsx`, `components/ShippingOrderFormModal.tsx`, `components/ShippingOrderPickerModal.tsx` | 출하지시 화면, 출고용 지시 선택 |
| Modify `apps/frontend/src/app/(authenticated)/product/components/FgScanPanel.tsx`, `product/fg-issue/page.tsx` | 출고 화면에서 지시 선택 |
| Modify `apps/frontend/src/config/menuConfig.ts`, `src/locales/{ko,en,vi,zh}.json`, `apps/backend/src/modules/menu-categories/utils/menu-code-validator.ts`, `default-menu-category-layout.ts`, `apps/backend/src/seeds/menu-config.json` | 메뉴 등록 |

---

### Task 1: 후공정 지시 실적 SQL 조각

**Files:**
- Create: `apps/backend/src/modules/planning/order-result.sql.ts`
- Test: `apps/backend/src/modules/planning/order-result.sql.spec.ts`

**Interfaces:**
- Produces:
  - `MI_ORDER_EXISTS(alias: string): string` — 런카드 별칭을 받아 "그 런카드가 제품생산계획 지시인가" EXISTS 조건을 돌려준다.
  - `MI_ORDER_RESULTS_SQL: string` — 열: `RUN_NO, ORGANIZATION_ID, LINE_CODE, MODEL_NAME, RESULT_QTY, ENTER_DATE`. 확정(DONE) 실적만, 후공정 지시만. 날짜 조건은 쓰는 쪽이 `WHERE` 로 붙인다.

- [ ] **Step 1: 실패하는 테스트 작성**

```ts
// apps/backend/src/modules/planning/order-result.sql.spec.ts
import { MI_ORDER_EXISTS, MI_ORDER_RESULTS_SQL } from './order-result.sql';

describe('order-result.sql', () => {
  it('MI_ORDER_EXISTS ties the run card to an MI plan by LOT_NO = MFS', () => {
    const sql = MI_ORDER_EXISTS('r');
    expect(sql).toContain('FROM IP_PRODUCT_MI_PLAN');
    expect(sql).toContain('.MFS = r.LOT_NO');
    expect(sql).toContain('.ORGANIZATION_ID = r.ORGANIZATION_ID');
  });

  it('MI_ORDER_RESULTS_SQL counts only confirmed results (no WIP, no CANCEL)', () => {
    expect(MI_ORDER_RESULTS_SQL).toContain("wr.RESULT_STATUS = 'DONE'");
    expect(MI_ORDER_RESULTS_SQL).not.toContain('CANCEL');
    expect(MI_ORDER_RESULTS_SQL).toContain('JOIN IP_PRODUCT_RUN_CARD r');
    expect(MI_ORDER_RESULTS_SQL).toContain(MI_ORDER_EXISTS('r'));
  });

  it('does not read process-pass history', () => {
    expect(MI_ORDER_RESULTS_SQL).not.toMatch(/WORKSTAGE_IO|ACTUAL_TIME_V/);
  });
});
```

- [ ] **Step 2: 실패 확인**

Run: `pnpm --filter @eunsung/backend exec jest src/modules/planning/order-result.sql.spec.ts`
Expected: FAIL — `Cannot find module './order-result.sql'`

- [ ] **Step 3: 구현**

```ts
// apps/backend/src/modules/planning/order-result.sql.ts
/**
 * @file src/modules/planning/order-result.sql.ts
 * @description 후공정 생산지시(런카드) 대비 실적 SQL 조각 — 생산 보드·대시보드가 같이 쓴다
 *
 * 초보자 가이드:
 * 1. 생산지시 = IP_PRODUCT_RUN_CARD. 런카드 LOT_NO 는 원천 계획의 MFS 다.
 *    LOT_NO 가 제품생산계획(IP_PRODUCT_MI_PLAN) MFS 이면 후공정 지시, 반제품생산계획 MFS 이면 SMT 지시다.
 * 2. 후공정 지시 실적 = IP_PRODUCT_WORK_RESULT 의 확정(DONE) 실적 합. 진행(WIP)·취소(CANCEL)는 세지 않는다.
 * 3. SMT 지시 실적은 센서 실적 뷰(IP_ASSEMBLY_ACTUAL_TIME_V)를 그대로 쓴다. SMT 라인에서 넣은 실적은
 *    센서 누적 프로시저로 이미 센서에 들어가 있어 여기서 더하면 두 번 센다.
 * 4. 공정 통과 이력(IP_PRODUCT_WORKSTAGE_IO)은 실적이 아니다 (설계 docs/specs/2026-10-14-production-order-and-shipping-order-design.md).
 */

/** 런카드(alias)가 제품생산계획에서 내려간 후공정 지시인가 */
export const MI_ORDER_EXISTS = (alias: string): string =>
  `EXISTS (SELECT 1 FROM IP_PRODUCT_MI_PLAN mip
            WHERE mip.MFS = ${alias}.LOT_NO
              AND mip.ORGANIZATION_ID = ${alias}.ORGANIZATION_ID)`;

/** 후공정 지시의 확정 실적 행. 날짜 조건은 쓰는 쪽이 wr.ENTER_DATE 로 붙인다. */
export const MI_ORDER_RESULTS_SQL = `
  SELECT wr.RUN_NO, wr.ORGANIZATION_ID, r.LINE_CODE, r.MODEL_NAME, wr.RESULT_QTY, wr.ENTER_DATE
    FROM IP_PRODUCT_WORK_RESULT wr
    JOIN IP_PRODUCT_RUN_CARD r ON r.RUN_NO = wr.RUN_NO AND r.ORGANIZATION_ID = wr.ORGANIZATION_ID
   WHERE wr.RESULT_STATUS = 'DONE'
     AND ${MI_ORDER_EXISTS('r')}`;
```

- [ ] **Step 4: 통과 확인**

Run: `pnpm --filter @eunsung/backend exec jest src/modules/planning/order-result.sql.spec.ts`
Expected: PASS (3 tests)

- [ ] **Step 5: 실DB 문법 확인 (읽기 전용)**

oracle-db 스킬로 실행: `SELECT COUNT(*), SUM(RESULT_QTY) FROM (<MI_ORDER_RESULTS_SQL 본문>) WHERE ENTER_DATE >= DATE '2026-10-01'`
Expected: 오류 없이 한 줄 (테스트 시드 TST3401 실적이 있으면 CANCEL 이 아닌 DONE 만 합산).

- [ ] **Step 6: Commit**

```bash
git add apps/backend/src/modules/planning/order-result.sql.ts apps/backend/src/modules/planning/order-result.sql.spec.ts
git commit -m "feat(planning): 후공정 생산지시 실적 SQL 조각을 한 곳에 둔다"
```

---

### Task 2: 런카드를 공정 단위로 발행 (백엔드)

**Files:**
- Modify: `apps/backend/src/modules/run-card/lot-card.dto.ts`
- Modify: `apps/backend/src/modules/run-card/lot-card.service.ts` (PLAN_SELECT.MI 52-53행, findPlans 107-132행, createFromPlan 148-232행, createPids 363행~)
- Test: `apps/backend/src/modules/run-card/lot-card.service.spec.ts`

**Interfaces:**
- Produces:
  - `LotCardPlanQueryDto.workstageCode?: string` — 후공정 계획 목록에서 그 공정 기준 남은 수량을 계산한다.
  - `LotCardFromPlanDto.workstageCode?: string` — planType 'MI' 이면 필수. 런카드 `WORKSTAGE_CODE` 로 들어간다.
  - 후공정 남은 수량 = 계획수량 − 같은 LOT_NO·같은 WORKSTAGE_CODE 런카드 LOT_SIZE 합.

- [ ] **Step 1: 실패하는 테스트 작성** (`lot-card.service.spec.ts` 끝에 추가)

```ts
describe('LotCardService per-process run cards', () => {
  function serviceWith(query: jest.Mock) {
    const transaction = jest.fn(async (callback: (m: { query: jest.Mock }) => unknown) => callback({ query }));
    return new LotCardService({ transaction, query, manager: { query } } as never);
  }
  const miPlan = {
    planType: 'MI', mfs: 'MI20261014001', planDate: '2026-10-14', planSequence: 1, lineCode: '34',
    modelName: 'M', itemCode: 'I', itemName: null, parentItemCode: null, workOrderNo: 'WO1', pcbItem: null,
    masterModelName: 'M', mfsGroupNo: 'MI20261014001', shiftCode: 'A', productionType: 'P', customerCode: null,
    planStatus: 'W', planQty: 100, lotQty: 100, remainQty: 100,
  };

  it('refuses an MI run card without a process', async () => {
    const query = jest.fn();
    await expect(serviceWith(query).createFromPlan(
      { planType: 'MI', planDate: '2026-10-14', planSequence: 1, mfs: miPlan.mfs, productRunType: 'P' }, 1, 'U',
    )).rejects.toBeInstanceOf(BadRequestException);
    expect(query).not.toHaveBeenCalled();
  });

  it('computes MI remaining quantity per process and stores WORKSTAGE_CODE', async () => {
    const query = jest.fn(async (sql: string) => {
      if (sql.includes('FROM IP_PRODUCT_MI_PLAN')) return [miPlan];
      if (sql.includes('FROM IP_PRODUCT_MODEL_MASTER')) return [{ cnt: 1, carrierSize: 2 }];
      if (sql.includes('F_GET_NEW_RUN_NO')) return [{ runNo: 'R9' }];
      if (sql.includes('SELECT COUNT(*) AS "cnt" FROM IP_PRODUCT_RUN_CARD WHERE RUN_NO')) return [{ cnt: 0 }];
      return [];
    });
    await serviceWith(query).createFromPlan(
      { planType: 'MI', planDate: '2026-10-14', planSequence: 1, mfs: miPlan.mfs, productRunType: 'P', workstageCode: 'W091' }, 1, 'U',
    );
    const planSql = String(query.mock.calls.find(([s]) => String(s).includes('FROM IP_PRODUCT_MI_PLAN'))![0]);
    expect(planSql).toContain('WORKSTAGE_CODE = :workstageCode');
    const insert = query.mock.calls.find(([s]) => String(s).includes('INSERT INTO IP_PRODUCT_RUN_CARD ('))!;
    expect(String(insert[0])).toContain('WORKSTAGE_CODE');
    expect(insert[1]).toMatchObject({ workstageCode: 'W091' });
  });

  it('refuses PIDs when another run card of the same plan already has PIDs', async () => {
    const run = [{ runNo: 'R2', modelName: 'M', runDate: '2026-10-14', lotSize: 10, itemCode: 'I', parentItemCode: null, lineCode: '34', carrierSize: 2, lotNo: 'MI20261014001' }];
    const query = jest.fn()
      .mockResolvedValueOnce(run)           // runCard
      .mockResolvedValueOnce([{ cnt: 0 }])  // 이 런카드 PID 없음
      .mockResolvedValueOnce([{ runNo: 'R1' }]); // 같은 LOT_NO 다른 런카드에 PID 있음
    await expect(serviceWith(query).createPids('R2', {}, 1, 'U')).rejects.toBeInstanceOf(ConflictException);
  });
});
```

- [ ] **Step 2: 실패 확인**

Run: `pnpm --filter @eunsung/backend exec jest src/modules/run-card/lot-card.service.spec.ts`
Expected: FAIL — 새 3개 실패 (공정 검사·WORKSTAGE_CODE 바인드·형제 PID 검사 없음)

- [ ] **Step 3: DTO 수정** (`lot-card.dto.ts`)

```ts
export class LotCardPlanQueryDto {
  @IsString() @MaxLength(10) lineCode!: string;
  @IsOptional() @IsString() modelName?: string;
  @Matches(YMD) dateFrom!: string;
  @Matches(YMD) dateTo!: string;
  /** 후공정 계획에서 이 공정 기준 남은 수량을 본다 (공정마다 지시를 따로 내린다) */
  @IsOptional() @IsString() @MaxLength(10) workstageCode?: string;
}

export class LotCardFromPlanDto {
  @IsIn(['SMD', 'MI']) planType!: 'SMD' | 'MI';
  @Matches(YMD) planDate!: string;
  @Type(() => Number) @IsInt() planSequence!: number;
  @IsString() @MaxLength(30) mfs!: string;
  @IsString() @MaxLength(1) productRunType!: string;
  @IsOptional() @IsString() @MaxLength(20) modelClass?: string;
  @IsOptional() @IsString() @MaxLength(20) pcbWeek?: string;
  /** 후공정(MI) 지시의 공정 — 제조공정만. SMD 는 비운다 */
  @IsOptional() @IsString() @MaxLength(10) workstageCode?: string;
}
```

- [ ] **Step 4: 서비스 수정** (`lot-card.service.ts`)

PLAN_SELECT.MI 의 `lotQty`·`remainQty` 를 공정 기준으로 바꾼다 (`:workstageCode` 가 NULL 이면 공정 구분 없이 전체 — 목록에서 공정을 아직 안 고른 경우):

```ts
           p.PLAN_QTY AS "planQty",
           (SELECT SUM(rc.LOT_SIZE) FROM IP_PRODUCT_RUN_CARD rc
             WHERE rc.LOT_NO = p.MFS AND rc.ORGANIZATION_ID = p.ORGANIZATION_ID
               AND (:workstageCode IS NULL OR rc.WORKSTAGE_CODE = :workstageCode)) AS "lotQty",
           p.PLAN_QTY - NVL((SELECT SUM(rc.LOT_SIZE) FROM IP_PRODUCT_RUN_CARD rc
             WHERE rc.LOT_NO = p.MFS AND rc.ORGANIZATION_ID = p.ORGANIZATION_ID
               AND (:workstageCode IS NULL OR rc.WORKSTAGE_CODE = :workstageCode)), 0) AS "remainQty"
```

findPlans: MI 일 때 바인드에 `workstageCode: query.workstageCode?.trim() || null` 를 넣는다 (SMD 는 넣지 않는다 — SMD SQL 에 `:workstageCode` 가 없다).

createFromPlan 맨 앞:

```ts
    if (!dto.productRunType?.trim()) throw new BadRequestException('제조유형을 선택하세요.');
    const workstageCode = dto.workstageCode?.trim() || null;
    if (dto.planType === 'MI' && !workstageCode) throw new BadRequestException('공정을 선택하세요. 후공정 지시는 공정마다 따로 내립니다.');
```

계획 재조회 바인드에 MI 면 `workstageCode` 추가. RUN_CARD INSERT 컬럼 목록 끝에 `WORKSTAGE_CODE`, 값에 `:workstageCode`, 바인드에 `workstageCode` (SMD 면 null).

createPids: 이 런카드 PID 존재 검사 직후, 재생성 분기 전에:

```ts
      const sibling = await m.query(
        `SELECT MIN(b.RUN_NO) AS "runNo" FROM IP_PRODUCT_2D_BARCODE b
          WHERE b.LOT_NO = :lotNo AND b.RUN_NO <> :runNo AND b.ORGANIZATION_ID = :organizationId`,
        namedBinds({ lotNo: card.lotNo, runNo, organizationId }),
      ) as Array<{ runNo: string | null }>;
      if (sibling[0]?.runNo) {
        throw new ConflictException(`같은 계획의 다른 공정 지시(${sibling[0].runNo})에 PID 가 이미 있습니다. PID 는 계획당 한 번만 만듭니다.`);
      }
```

(PID_INSERT 가 `LOT_NO = r.LOT_NO` 를 넣으므로 LOT_NO 로 형제 PID 를 찾을 수 있다.) 기존 "asks before regenerating" 테스트의 mock 순서가 바뀌면(형제 검사 쿼리가 추가됨) 그 테스트에 `.mockResolvedValueOnce([{ runNo: null }])` 를 알맞은 자리에 넣는다.

- [ ] **Step 5: 통과 확인**

Run: `pnpm --filter @eunsung/backend exec jest src/modules/run-card`
Expected: PASS (기존 + 새 3개)

- [ ] **Step 6: Commit**

```bash
git add apps/backend/src/modules/run-card/lot-card.dto.ts apps/backend/src/modules/run-card/lot-card.service.ts apps/backend/src/modules/run-card/lot-card.service.spec.ts
git commit -m "feat(run-card): 후공정 런카드를 공정마다 발행하고 같은 계획의 PID 중복 생성을 막는다"
```

---

### Task 3: 런카드 발행 화면 공정 선택 + 제조공정 판별 공용화 (프론트)

**Files:**
- Modify: `apps/frontend/src/components/shared/processOptions.mjs`
- Modify: `apps/frontend/src/components/shared/ProcessSelect.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/production/run-card/components/PlanPickerModal.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/oee/equip-work-result/components/ScopeModal.tsx`
- Test: `apps/frontend/src/components/shared/processOptions.test.mjs` (새로 만든다; 기존에 있으면 추가)

**Interfaces:**
- Consumes: Task 2 의 `workstageCode` (plans 조회·from-plan 본문)
- Produces: `isManufacturingProcess(p: { codeGroup?: string; processType?: string }): boolean` — SMT 그룹·검사(Q) 유형이면 false. `ProcessSelect` 의 `manufacturingOnly?: boolean`.

- [ ] **Step 1: 실패하는 테스트 작성**

```js
// apps/frontend/src/components/shared/processOptions.test.mjs
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { isManufacturingProcess } from './processOptions.mjs';

test('제조공정만 통과: SMT 그룹·검사 유형 제외', () => {
  assert.equal(isManufacturingProcess({ codeGroup: 'PBA', processType: 'I' }), true);
  assert.equal(isManufacturingProcess({ codeGroup: 'SMT', processType: 'I' }), false);
  assert.equal(isManufacturingProcess({ codeGroup: 'PBA', processType: 'Q' }), false);
  assert.equal(isManufacturingProcess({}), true);
});
```

- [ ] **Step 2: 실패 확인**

Run: `pnpm --filter @eunsung/frontend exec node --test src/components/shared/processOptions.test.mjs`
Expected: FAIL — `isManufacturingProcess` 가 export 되지 않음

- [ ] **Step 3: 구현**

`processOptions.mjs` 에 추가:

```js
/**
 * 실적·지시 대상 제조공정인가 — SMT 공정(공정그룹 SMT)과 검사공정(공정유형 Q)은 뺀다.
 * @param {{ codeGroup?: string, processType?: string }} process
 */
export function isManufacturingProcess(process) {
  return process.codeGroup !== 'SMT' && process.processType !== 'Q';
}
```

`ProcessSelect.tsx`: props 에 `manufacturingOnly?: boolean` 추가, `displayOptions` 계산 전에 `const source = manufacturingOnly ? rawData.filter(isManufacturingProcess) : rawData;` 로 거르고 `options` 대신 `buildProcessOptions(source, processTypeMap, showProcessType)` 를 쓴다.

`ScopeModal.tsx`: `excludedStages` 계산의 `codeGroup==='SMT' || processType==='Q'` 를 `!isManufacturingProcess(p)` 로 바꾼다 (import `@/components/shared/processOptions.mjs`).

`PlanPickerModal.tsx`:
- `const [workstageCode, setWorkstageCode] = useState('');`
- 조회 영역에 후공정 계획일 때만(선택된 라인의 계획 유형이 MI — 목록 첫 행 `planType` 또는 라인 구분으로 판단) `<ProcessSelect manufacturingOnly labelPrefix="공정" value={workstageCode} onChange={(v) => setWorkstageCode(String(v))} className="w-56" />` 표시.
- `/production/lot-card/plans` 조회 params 에 `workstageCode: workstageCode || undefined`.
- 생성 전 검사: `if (picked.planType === 'MI' && !workstageCode) { toast.error('공정을 고르세요. 후공정 지시는 공정마다 따로 내립니다.'); return; }`
- from-plan 본문에 `workstageCode: picked.planType === 'MI' ? workstageCode : undefined`.
- 공정이 바뀌면 목록을 다시 조회한다 (남은 수량이 공정 기준이라서).

- [ ] **Step 4: 통과 확인**

Run: `pnpm --filter @eunsung/frontend exec node --test src/components/shared/processOptions.test.mjs`
Expected: PASS
Run: `pnpm --filter @eunsung/frontend exec tsc --noEmit --pretty false`
Expected: 오류 없음

- [ ] **Step 5: 화면 확인 (aside-browser)**

`http://localhost:4010/production/run-card` → 계획 선택에서 조립 H라인(34) 선택 → 공정 칸이 보이고 SMT·검사 공정이 목록에 없는지, 공정 없이 생성하면 토스트가 뜨는지 확인. (dev 서버가 떠 있지 않으면 이 단계는 건너뛰었다고 보고한다.)

- [ ] **Step 6: Commit**

```bash
git add apps/frontend/src/components/shared/processOptions.mjs apps/frontend/src/components/shared/processOptions.test.mjs apps/frontend/src/components/shared/ProcessSelect.tsx "apps/frontend/src/app/(authenticated)/production/run-card/components/PlanPickerModal.tsx" "apps/frontend/src/app/(authenticated)/oee/equip-work-result/components/ScopeModal.tsx"
git commit -m "feat(run-card): 후공정 런카드 발행 시 제조공정을 고른다"
```

---

### Task 4: 설비별 작업실적 — 공정별 지시와 공정 고정 규칙

**Files:**
- Modify: `apps/backend/src/modules/work-result/work-result.controller.ts` (list, 61-80행)
- Modify: `apps/backend/src/modules/work-result/work-result.service.ts` (list 71-148행, upsertResult 205-281행)
- Test: `apps/backend/src/modules/work-result/work-result.service.spec.ts`
- Modify: `apps/frontend/src/app/(authenticated)/oee/equip-work-result/components/RunPickerModal.tsx`, `page.tsx`, `_lib/types.ts`

**Interfaces:**
- Produces:
  - `GET /oee/work-result?...&workstageCode=W091` — 그 공정 런카드 + 공정 미지정(NULL) 런카드만.
  - 실적 저장 규칙: 런카드 WORKSTAGE_CODE 가 있고 실적 공정과 다르면 400 `'이 작업지시는 <공정> 지시입니다. 다른 공정 실적은 그 공정 지시로 넣으세요.'`. 비어 있으면 첫 실적 공정으로 채운다(전환 기간). 설비(MACHINE_CODE) write-back 은 지금처럼 한다.

- [ ] **Step 1: 실패하는 테스트 작성** (`work-result.service.spec.ts` 의 기존 mock 방식을 따른다 — `repo.manager.transaction` 이 `mgr.query` 를 부르고, SQL 문자열로 응답을 고른다)

```ts
  describe('process-bound run cards', () => {
    it('list filters by process but keeps unassigned run cards', async () => {
      await service.list('2026-10-14', '2026-10-14', '34', undefined, 1, undefined, true, undefined, 'W091');
      const [sql, params] = queryMock.mock.calls.at(-1)!;
      expect(String(sql)).toMatch(/\(r\.WORKSTAGE_CODE = :\d+ OR r\.WORKSTAGE_CODE IS NULL\)/);
      expect(params).toContain('W091');
    });

    it('rejects a result for a different process than the run card', async () => {
      mgrQuery.mockImplementation(async (sql: string) => {
        if (sql.includes('SELECT LINE_CODE AS "lineCode"')) return [{ lineCode: '34', workstageCode: 'W091' }];
        return [];
      });
      await expect(service.upsertResult(
        { runNo: 'R1', workstageCode: 'W120', machineCode: 'M1', resultQty: 5, resultStatus: 'DONE' } as never, 1, 'U',
      )).rejects.toThrow('W091');
    });

    it('locks an unassigned run card to the first result process', async () => {
      mgrQuery.mockImplementation(async (sql: string) => {
        if (sql.includes('SELECT LINE_CODE AS "lineCode"')) return [{ lineCode: '34', workstageCode: null }];
        if (sql.includes('LPAD')) return [{ seq: '01' }];
        return [];
      });
      await service.upsertResult(
        { runNo: 'R1', workstageCode: 'W091', machineCode: 'M1', resultQty: 5, resultStatus: 'WIP' } as never, 1, 'U',
      );
      const write = mgrQuery.mock.calls.find(([s]) => String(s).startsWith('UPDATE IP_PRODUCT_RUN_CARD'))!;
      expect(String(write[0])).toContain('WORKSTAGE_CODE=NVL(WORKSTAGE_CODE,');
    });
  });
```

(`queryMock`/`mgrQuery`/`service` 이름은 기존 spec 의 변수명에 맞춘다.)

- [ ] **Step 2: 실패 확인**

Run: `pnpm --filter @eunsung/backend exec jest src/modules/work-result`
Expected: FAIL — 새 3개

- [ ] **Step 3: 구현**

service.list 시그니처 끝에 `workstageCode?: string` 추가, `machineCode` 처리 뒤에:

```ts
    // 후공정 지시는 공정마다 따로 내린다. 공정이 비어 있는 예전 런카드는 전환 기간 동안 함께 보여준다.
    if (workstageCode) {
      params.push(workstageCode);
      where += ` AND (r.WORKSTAGE_CODE = :${params.length} OR r.WORKSTAGE_CODE IS NULL)`;
    }
```

controller.list 에 `@Query('workstageCode') workstageCode?: string` 를 받아 넘긴다.

upsertResult: 런카드 조회를 `SELECT LINE_CODE AS "lineCode", WORKSTAGE_CODE AS "workstageCode" FROM IP_PRODUCT_RUN_CARD WHERE RUN_NO=:1 AND ORGANIZATION_ID=:2 FOR UPDATE` 로 바꾸고, 바로 뒤:

```ts
      const fixed = runCard[0]?.workstageCode ?? null;
      if (fixed && dto.workstageCode && fixed !== dto.workstageCode) {
        throw new BadRequestException(`이 작업지시는 ${fixed} 공정 지시입니다. 다른 공정 실적은 그 공정 지시로 넣으세요.`);
      }
```

write-back 을 공정은 비어 있을 때만 채우게 바꾼다:

```ts
      await mgr.query(
        `UPDATE IP_PRODUCT_RUN_CARD SET MACHINE_CODE=:1, WORKSTAGE_CODE=NVL(WORKSTAGE_CODE, :2) WHERE RUN_NO=:3 AND ORGANIZATION_ID=:4`,
        [machineCode, dto.workstageCode, dto.runNo, organization],
      );
```

프론트:
- `RunPickerModal.tsx` 조회 params 에 `workstageCode: scope.workstageCode`.
- 카드에 `run.workstageCode` 가 비어 있으면 작은 회색 배지 `공정 미지정` 표시.
- `_lib/types.ts` 의 `RunRow` 에 `workstageCode: string | null` 가 이미 있는지 확인하고 없으면 추가.

- [ ] **Step 4: 통과 확인**

Run: `pnpm --filter @eunsung/backend exec jest src/modules/work-result`
Expected: PASS
Run: `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false` 와 `pnpm --filter @eunsung/frontend exec tsc --noEmit --pretty false`
Expected: 오류 없음

- [ ] **Step 5: Commit**

```bash
git add apps/backend/src/modules/work-result "apps/frontend/src/app/(authenticated)/oee/equip-work-result"
git commit -m "feat(work-result): 작업지시를 공정으로 거르고 런카드 공정과 다른 실적을 막는다"
```

---

### Task 5: 생산 보드 제품 행 = 당일 후공정 런카드

**Files:**
- Modify: `apps/backend/src/modules/monitoring/services/production-board.service.ts` (MI_PLAN_SQL 196-219행, getBoard 247-304행, 머리 주석 14-18행)
- Test: `apps/backend/src/modules/monitoring/services/production-board.service.spec.ts`

**Interfaces:**
- Consumes: Task 1 `MI_ORDER_EXISTS`, `MI_ORDER_RESULTS_SQL`
- Produces: `MI_ORDER_SQL` (MI_PLAN_SQL 대체, 같은 PlanRow 열), `MI_RESULT_MINUTE_SQL` (열 `hhmm`, `qty`).

- [ ] **Step 1: 실패하는 테스트 작성**

spec 의 `answer()` 를 바꾼다:

```ts
    if (sql.includes('FROM IP_PRODUCT_RUN_CARD r') && sql.includes('"planSequence"')) return miRows;
    if (sql.includes('FROM IP_PRODUCT_WORK_RESULT wr') && sql.includes('"hhmm"')) return [{ hhmm: '0840', qty: '7' }, { hhmm: '0800', qty: '3' }];
```

`FROM IP_PRODUCT_MI_PLAN` / `FROM IP_PRODUCT_ACTUAL_TIME_V v` 분기는 지운다. 테스트 추가:

```ts
  it('MI rows come from run cards issued on the work day, not from plans', async () => {
    await target.getBoard();
    const sqls = mockDataSource.query.mock.calls.map(([s]) => String(s));
    const mi = sqls.find((s) => s.includes('FROM IP_PRODUCT_RUN_CARD r'))!;
    expect(mi).toContain('r.RUN_DATE >= wd.day AND r.RUN_DATE < wd.day + 1');
    expect(sqls.some((s) => s.includes('IP_PRODUCT_ACTUAL_TIME_V'))).toBe(false);
  });

  it('result minutes are slotted by the work-time ranges (08:40 → A, 08:00 → J)', async () => {
    const board = await target.getBoard();
    // SMD 슬롯 [10,20,0,0,0,0,5,0,0,0] + 실적 A=7, J=3
    expect(board.hourly[0].goodQty).toBe(10 + 7);
    expect(board.hourly[9].goodQty).toBe(0 + 3);
  });
```

기존 테스트 중 MI 슬롯 합 `[1,2,3,...]` 을 기대하던 단언은 새 값으로 고친다.

- [ ] **Step 2: 실패 확인**

Run: `pnpm --filter @eunsung/backend exec jest src/modules/monitoring/services/production-board.service.spec.ts`
Expected: FAIL

- [ ] **Step 3: 구현**

```ts
import { MI_ORDER_EXISTS, MI_ORDER_RESULTS_SQL } from '../../planning/order-result.sql';

/** 제품 행 = 당일 작업일에 발행된 후공정 생산지시(런카드). 실적은 그 런카드의 확정 실적 합 */
export const MI_ORDER_SQL = `
  WITH wd AS (SELECT ${WORK_DAY} AS day FROM DUAL)
  SELECT r.RUN_NO AS "planSequence",
         (SELECT MAX(p.WORK_ORDER_NO) FROM IP_PRODUCT_MI_PLAN p
           WHERE p.MFS = r.LOT_NO AND p.ORGANIZATION_ID = r.ORGANIZATION_ID) AS "workOrderNo",
         5 AS "priority", r.LINE_CODE AS "lineCode", r.ITEM_CODE AS "itemCode",
         NVL(i.ITEM_NAME, r.MODEL_NAME) AS "itemName", r.MODEL_NAME AS "modelName",
         r.LOT_SIZE AS "planQty",
         NVL((SELECT SUM(wr.RESULT_QTY) FROM IP_PRODUCT_WORK_RESULT wr
               WHERE wr.RUN_NO = r.RUN_NO AND wr.ORGANIZATION_ID = r.ORGANIZATION_ID
                 AND wr.RESULT_STATUS = 'DONE'), 0) AS "goodQty",
         0 AS "defectQty",
         (SELECT MAX(wr.ENTER_DATE) FROM IP_PRODUCT_WORK_RESULT wr
           WHERE wr.RUN_NO = r.RUN_NO AND wr.ORGANIZATION_ID = r.ORGANIZATION_ID
             AND wr.RESULT_STATUS = 'DONE') AS "lastResultAt"
    FROM IP_PRODUCT_RUN_CARD r
    CROSS JOIN wd
    LEFT JOIN ID_ITEM i ON i.ITEM_CODE = r.ITEM_CODE AND i.ORGANIZATION_ID = ${ORG}
   WHERE r.ORGANIZATION_ID = ${ORG}
     AND r.RUN_DATE >= wd.day AND r.RUN_DATE < wd.day + 1
     AND ${MI_ORDER_EXISTS('r')}
   ORDER BY r.LINE_CODE, r.RUN_NO`;

/** 작업일 창(08:30~다음날 08:30) 후공정 확정 실적을 분 단위로 — 칸 배정은 JS(slotIndexOf) */
export const MI_RESULT_MINUTE_SQL = `
  SELECT TO_CHAR(x.ENTER_DATE, 'HH24MI') AS "hhmm", SUM(x.RESULT_QTY) AS "qty"
    FROM (${MI_ORDER_RESULTS_SQL}) x
   WHERE x.ORGANIZATION_ID = ${ORG}
     AND x.ENTER_DATE >= ${WORK_DAY} + ${WORK_START_FRACTION}
     AND x.ENTER_DATE < ${WORK_DAY} + 1 + ${WORK_START_FRACTION}
   GROUP BY TO_CHAR(x.ENTER_DATE, 'HH24MI')`;
```

(쉼표 조인과 ANSI LEFT JOIN 을 섞으면 Oracle 이 ON 절의 `r` 을 못 찾으므로 `CROSS JOIN wd` 로 쓴다.)

getBoard:
- 1묶음 `MI_PLAN_SQL` → `MI_ORDER_SQL` (바인드 `dayBind`).
- 2묶음의 `SLOT_SUM_SQL('IP_PRODUCT_ACTUAL_TIME_V', 'ACTUAL_DATE')` → `MI_RESULT_MINUTE_SQL` (바인드 `dayStartBind`), 결과를 QC 처럼 `slotIndexOf` 로 칸에 더해 `miSum` 을 만든다:

```ts
    const miSum = SLOT_KEYS.map(() => 0);
    for (const r of miMinutes) {
      const idx = slotIndexOf(String(r.hhmm), slots);
      if (idx >= 0) miSum[idx] += n(r.qty);
    }
```

(`slots` 계산을 `miSum` 보다 먼저 옮긴다.) 머리 주석 3번의 "제품: IP_PRODUCT_ACTUAL_TIME_V" 줄을 "제품: 당일 발행 후공정 런카드 + IP_PRODUCT_WORK_RESULT 확정 실적" 으로 고친다. 지시 행 `planSequence` 에 RUN_NO 가 들어가므로 `orderNo` 는 `workOrderNo` 가 없으면 `MI-<RUN_NO>` 가 된다 (buildOrders 그대로).

- [ ] **Step 4: 통과 확인**

Run: `pnpm --filter @eunsung/backend exec jest src/modules/monitoring`
Expected: PASS

- [ ] **Step 5: 실DB 문법 확인 (읽기 전용)**

`MI_ORDER_SQL`·`MI_RESULT_MINUTE_SQL` 의 `:day`=오늘 작업일, `:startFrac`=0.3541666 를 넣어 oracle-db 스킬로 실행. Expected: 오류 없음, TST34% 시드 런카드가 RUN_DATE 당일이면 행이 나온다.

- [ ] **Step 6: Commit**

```bash
git add apps/backend/src/modules/monitoring/services/production-board.service.ts apps/backend/src/modules/monitoring/services/production-board.service.spec.ts
git commit -m "feat(monitoring): 생산 보드 제품 행을 당일 생산지시와 실적 테이블로 집계한다"
```

---

### Task 6: 대시보드 제품 실적 원천 교체

**Files:**
- Modify: `apps/backend/src/modules/dashboard/dashboard.service.ts` (production 요약 109-114행)
- Modify: `apps/backend/src/modules/dashboard/dashboard-insights.sql.ts` (movements 의 MI 실적 41-44행, 머리 주석 8행)
- Test: `apps/backend/src/modules/dashboard/dashboard.service.spec.ts`

**Interfaces:**
- Consumes: Task 1 `MI_ORDER_RESULTS_SQL`

- [ ] **Step 1: 실패하는 테스트 작성**

```ts
  it('product actual comes from confirmed work results, not process-pass history', async () => {
    await service.getSummary('2026-10-14');
    const sqls = queryMock.mock.calls.map(([s]) => String(s));
    expect(sqls.some((s) => s.includes('IP_PRODUCT_ACTUAL_TIME_V'))).toBe(false);
    const prod = sqls.find((s) => s.includes('"miActual"'))!;
    expect(prod).toContain("wr.RESULT_STATUS = 'DONE'");
    expect(prod).toContain("F_GET_WORK_ACTUAL_DATE(x.ENTER_DATE, 'A')");
  });

  it('insights product actual uses the business date of the result entry', () => {
    expect(DASHBOARD_INSIGHTS_SQL).not.toContain('IP_PRODUCT_ACTUAL_TIME_V');
    expect(DASHBOARD_INSIGHTS_SQL).toContain("F_GET_WORK_ACTUAL_DATE(x.ENTER_DATE, 'A')");
  });
```

(`service`/`queryMock`/메서드 이름은 기존 spec 에 맞춘다.)

- [ ] **Step 2: 실패 확인**

Run: `pnpm --filter @eunsung/backend exec jest src/modules/dashboard`
Expected: FAIL

- [ ] **Step 3: 구현**

dashboard.service.ts:

```ts
                (SELECT NVL(SUM(x.RESULT_QTY), 0) FROM (${MI_ORDER_RESULTS_SQL}) x
                  WHERE x.ORGANIZATION_ID = ${ORG}
                    AND x.ENTER_DATE >= ${day} - 1 AND x.ENTER_DATE < ${day} + 2
                    AND F_GET_WORK_ACTUAL_DATE(x.ENTER_DATE, 'A') = ${day}) AS "miActual"
```

(앞의 날짜 범위 조건은 함수 호출 행 수를 사흘로 줄이기 위한 것이다.)

dashboard-insights.sql.ts movements 의 MI 실적 블록:

```ts
    UNION ALL
    SELECT F_GET_WORK_ACTUAL_DATE(x.ENTER_DATE, 'A'), x.LINE_CODE, 'MI', 0, SUM(x.RESULT_QTY)
      FROM (${MI_ORDER_RESULTS_SQL}) x CROSS JOIN bounds b
     WHERE x.ORGANIZATION_ID = 1
       AND x.ENTER_DATE >= b.selected_day - 7 AND x.ENTER_DATE < b.selected_day + 2
       AND F_GET_WORK_ACTUAL_DATE(x.ENTER_DATE, 'A') >= b.selected_day - 6
       AND F_GET_WORK_ACTUAL_DATE(x.ENTER_DATE, 'A') < b.selected_day + 1
     GROUP BY F_GET_WORK_ACTUAL_DATE(x.ENTER_DATE, 'A'), x.LINE_CODE
```

머리 주석 3번을 "실적: IP_ASSEMBLY_ACTUAL_TIME_V(SMD) 시간대 합 / 제품은 후공정 생산지시 확정 실적(IP_PRODUCT_WORK_RESULT)을 입력 시각의 작업일로" 로 고친다.

- [ ] **Step 4: 통과 확인**

Run: `pnpm --filter @eunsung/backend exec jest src/modules/dashboard`
Expected: PASS

- [ ] **Step 5: 실DB 문법 확인 (읽기 전용)** — 두 SQL 을 `:day`=오늘로 oracle-db 스킬로 실행, 오류 없음 확인. 실행 시간이 2초를 넘으면 숫자를 기록하고 보고한다.

- [ ] **Step 6: Commit**

```bash
git add apps/backend/src/modules/dashboard
git commit -m "feat(dashboard): 제품 실적을 후공정 생산지시 실적으로 집계한다"
```

---

### Task 7: 출하지시 백엔드 (등록·출고 연결)

**Files:**
- Create: `apps/backend/src/modules/product/dto/shipping-order.dto.ts`
- Create: `apps/backend/src/modules/product/services/shipping-order.service.ts`
- Create: `apps/backend/src/modules/product/services/shipping-order.service.spec.ts`
- Create: `apps/backend/src/modules/product/controllers/shipping-order.controller.ts`
- Modify: `apps/backend/src/modules/product/product-inventory.module.ts`
- Modify: `apps/backend/src/modules/product/dto/product-fg.dto.ts` (FgIssueDto)
- Modify: `apps/backend/src/modules/product/services/product-fg.service.ts` (issue 371-387행, runProc 414-446행)

**Interfaces:**
- Produces:
  - `GET /product/shipping-orders?dateFrom&dateTo&customerCode&modelName&openOnly` → `ShippingOrderRow[]` `{ shipOrderNo, planDate, planSequence, customerCode, customerName, modelName, modelSuffix, itemCode, planQty, actualQty, remainQty, planStatus, comments }`
  - `POST /product/shipping-orders` (등록), `PUT /product/shipping-orders/:shipOrderNo` (수정), `DELETE /product/shipping-orders/:shipOrderNo` (실적 0 일 때만)
  - `ShippingOrderService.linkIssuedBox(qr, shipOrderNo, barcode, organizationId, userId): Promise<void>`
  - `ShippingOrderService.unlinkCancelledBox(qr, shipOrderNo, barcode, organizationId, userId): Promise<void>`
  - `ShippingOrderService.shipOrderOfBox(qr, barcode, organizationId): Promise<string | null>` — 박스 SHIP_NO 가 `DLV` 로 시작하면 그 번호
  - `FgIssueDto.shipOrderNo?: string`
  - 상태: ACTUAL_QTY 0 → 'W'(대기), 0 < 실적 < 지시 → 'P', 실적 = 지시 → 'C'(완료)

- [ ] **Step 1: 실패하는 테스트 작성**

```ts
// apps/backend/src/modules/product/services/shipping-order.service.spec.ts
import { BadRequestException, ConflictException } from '@nestjs/common';
import { ShippingOrderService, nextStatus, shipOrderNo } from './shipping-order.service';

const qr = (answers: Array<[RegExp, unknown]>) => {
  const query = jest.fn(async (sql: string) => {
    const hit = answers.find(([re]) => re.test(sql));
    return hit ? hit[1] : [];
  });
  return { query };
};

describe('ShippingOrderService', () => {
  const service = new ShippingOrderService({} as never, {} as never);

  it('numbers orders DLV + YYMMDD + 3 digits', () => {
    expect(shipOrderNo('2026-10-20', 7)).toBe('DLV261020007');
  });

  it('derives status from quantities', () => {
    expect(nextStatus(100, 0)).toBe('W');
    expect(nextStatus(100, 40)).toBe('P');
    expect(nextStatus(100, 100)).toBe('C');
  });

  const order = [{ modelName: 'M1', planQty: 100, actualQty: 90, planStatus: 'P' }];

  it('links a shipped box: SHIP_NO on issue row and pack, adds ACTUAL_QTY', async () => {
    const r = qr([[/FOR UPDATE/, order], [/FROM IP_PRODUCT_PACK_MASTER/, [{ modelName: 'M1', qty: 10 }]]]);
    await service.linkIssuedBox(r as never, 'DLV261020001', 'BOX1', 1, 'U');
    const sqls = r.query.mock.calls.map(([s]) => String(s));
    expect(sqls.some((s) => s.startsWith('UPDATE IP_PRODUCT_FG_ISSUE') && s.includes('SHIP_NO'))).toBe(true);
    expect(sqls.some((s) => s.startsWith('UPDATE IP_PRODUCT_PACK_MASTER') && s.includes('SHIP_NO'))).toBe(true);
    const upd = r.query.mock.calls.find(([s]) => String(s).startsWith('UPDATE IP_PRODUCT_DELIVERY_PLAN'))!;
    expect(upd[1]).toMatchObject({ actualQty: 100, planStatus: 'C' });
  });

  it('rejects a box of another model', async () => {
    const r = qr([[/FOR UPDATE/, order], [/FROM IP_PRODUCT_PACK_MASTER/, [{ modelName: 'M2', qty: 10 }]]]);
    await expect(service.linkIssuedBox(r as never, 'DLV261020001', 'BOX1', 1, 'U')).rejects.toBeInstanceOf(BadRequestException);
  });

  it('rejects going over the order quantity', async () => {
    const r = qr([[/FOR UPDATE/, order], [/FROM IP_PRODUCT_PACK_MASTER/, [{ modelName: 'M1', qty: 20 }]]]);
    await expect(service.linkIssuedBox(r as never, 'DLV261020001', 'BOX1', 1, 'U')).rejects.toBeInstanceOf(ConflictException);
  });

  it('rejects a completed order', async () => {
    const r = qr([[/FOR UPDATE/, [{ ...order[0], actualQty: 100, planStatus: 'C' }]]]);
    await expect(service.linkIssuedBox(r as never, 'DLV261020001', 'BOX1', 1, 'U')).rejects.toBeInstanceOf(ConflictException);
  });

  it('unlinks a cancelled box: subtracts ACTUAL_QTY and recomputes status', async () => {
    const r = qr([[/FOR UPDATE/, [{ modelName: 'M1', planQty: 100, actualQty: 100, planStatus: 'C' }]], [/FROM IP_PRODUCT_PACK_MASTER/, [{ modelName: 'M1', qty: 10 }]]]);
    await service.unlinkCancelledBox(r as never, 'DLV261020001', 'BOX1', 1, 'U');
    const upd = r.query.mock.calls.find(([s]) => String(s).startsWith('UPDATE IP_PRODUCT_DELIVERY_PLAN'))!;
    expect(upd[1]).toMatchObject({ actualQty: 90, planStatus: 'P' });
  });

  it('finds the order of a box only for DLV ship numbers', async () => {
    const r1 = qr([[/SHIP_NO/, [{ shipNo: 'DLV261020001' }]]]);
    await expect(service.shipOrderOfBox(r1 as never, 'BOX1', 1)).resolves.toBe('DLV261020001');
    const r2 = qr([[/SHIP_NO/, [{ shipNo: '20261013172415I868000000' }]]]);
    await expect(service.shipOrderOfBox(r2 as never, 'BOX1', 1)).resolves.toBeNull();
  });
});
```

- [ ] **Step 2: 실패 확인**

Run: `pnpm --filter @eunsung/backend exec jest src/modules/product/services/shipping-order.service.spec.ts`
Expected: FAIL — 모듈 없음

- [ ] **Step 3: DTO 작성** (`shipping-order.dto.ts`)

```ts
// 출하지시 (IP_PRODUCT_DELIVERY_PLAN) 입력 DTO
import { Type } from 'class-transformer';
import { IsBoolean, IsInt, IsOptional, IsString, Matches, MaxLength, Min } from 'class-validator';

const YMD = /^\d{4}-\d{2}-\d{2}$/;

export class ShippingOrderQueryDto {
  @Matches(YMD) dateFrom!: string;
  @Matches(YMD) dateTo!: string;
  @IsOptional() @IsString() customerCode?: string;
  @IsOptional() @IsString() modelName?: string;
  /** 완료(C) 지시를 뺀다 — 출고 화면의 지시 선택이 쓴다 */
  @IsOptional() @Type(() => Boolean) @IsBoolean() openOnly?: boolean;
}

export class ShippingOrderUpsertDto {
  /** 납기일 */
  @Matches(YMD) planDate!: string;
  @IsString() @MaxLength(30) customerCode!: string;
  @IsString() @MaxLength(100) modelName!: string;
  @Type(() => Number) @IsInt() @Min(1) planQty!: number;
  @IsOptional() @IsString() @MaxLength(2000) comments?: string;
}
```

- [ ] **Step 4: 서비스 작성** (`shipping-order.service.ts`)

```ts
/**
 * @file src/modules/product/services/shipping-order.service.ts
 * @description 출하지시 — IP_PRODUCT_DELIVERY_PLAN 등록과 출고 박스 연결
 *
 * 초보자 가이드:
 * 1. 출하지시는 고객 납품 계획(고객·모델·수량·납기)이다. 생산지시(런카드)와 따로 내려간다.
 * 2. 출하지시번호 = MFS = 'DLV' + 납기일 YYMMDD + 3자리 순번. 테이블에 PK 가 없어 서버가 중복을 막는다.
 * 3. 출하에는 라인이 없지만 LINE_CODE 가 NOT NULL 이라 '*' 를 넣는다. MODEL_SUFFIX·ITEM_CODE 는 모델마스터에서 채운다.
 * 4. 출고(P_PRODUCT_FG_ISSUE) 직후 같은 트랜잭션에서 박스를 잇는다:
 *    IP_PRODUCT_FG_ISSUE·IP_PRODUCT_PACK_MASTER 의 SHIP_NO 를 지시번호로 바꾸고 ACTUAL_QTY 를 더한다.
 *    SHIP_NO 는 프로시저가 시각으로 만드는 값이고 다른 곳에서 쓰지 않는다.
 * 5. 출고 취소는 박스의 SHIP_NO 로 지시를 찾아 ACTUAL_QTY 를 되돌린다.
 * 6. 상태: 실적 0 = W(대기) / 일부 = P / 지시수량 도달 = C(완료). 공통코드 PLAN STATUS 값이다.
 */
import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../../shared/transaction.service';
import { namedBinds } from '../../../common/utils/named-binds.util';
import { ShippingOrderQueryDto, ShippingOrderUpsertDto } from '../dto/shipping-order.dto';

type Q = { query: (sql: string, params?: unknown) => Promise<unknown> };
type Row = Record<string, unknown>;

export const SHIP_ORDER_PREFIX = 'DLV';

export function shipOrderNo(planDate: string, seq: number): string {
  return `${SHIP_ORDER_PREFIX}${planDate.slice(2, 4)}${planDate.slice(5, 7)}${planDate.slice(8, 10)}${String(seq).padStart(3, '0')}`;
}

export function nextStatus(planQty: number, actualQty: number): 'W' | 'P' | 'C' {
  if (actualQty <= 0) return 'W';
  return actualQty >= planQty ? 'C' : 'P';
}

@Injectable()
export class ShippingOrderService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  async list(query: ShippingOrderQueryDto, organizationId: number) {
    return this.dataSource.query(
      `SELECT d.MFS AS "shipOrderNo", TO_CHAR(d.PLAN_DATE, 'YYYY-MM-DD') AS "planDate", d.PLAN_SEQUENCE AS "planSequence",
              d.CUSTOMER_CODE AS "customerCode", cu.CUSTOMER_NAME AS "customerName",
              d.MODEL_NAME AS "modelName", d.MODEL_SUFFIX AS "modelSuffix", d.ITEM_CODE AS "itemCode",
              d.PLAN_QTY AS "planQty", NVL(d.ACTUAL_QTY, 0) AS "actualQty",
              d.PLAN_QTY - NVL(d.ACTUAL_QTY, 0) AS "remainQty",
              NVL(d.PLAN_STATUS, 'W') AS "planStatus", d.COMMENTS AS "comments"
         FROM IP_PRODUCT_DELIVERY_PLAN d
         LEFT JOIN ICOM_CUSTOMER cu ON cu.CUSTOMER_CODE = d.CUSTOMER_CODE AND cu.ORGANIZATION_ID = d.ORGANIZATION_ID
        WHERE d.ORGANIZATION_ID = :organizationId
          AND d.MFS LIKE '${SHIP_ORDER_PREFIX}%'
          AND d.PLAN_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD') AND d.PLAN_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(d.CUSTOMER_CODE, '*') LIKE :customerCode
          AND d.MODEL_NAME LIKE :modelName
          ${query.openOnly ? "AND NVL(d.PLAN_STATUS, 'W') <> 'C'" : ''}
        ORDER BY d.PLAN_DATE, d.PLAN_SEQUENCE`,
      namedBinds({
        organizationId, dateFrom: query.dateFrom, dateTo: query.dateTo,
        customerCode: query.customerCode?.trim() || '%',
        modelName: query.modelName?.trim() ? `%${query.modelName.trim()}%` : '%',
      }),
    ) as Promise<Row[]>;
  }

  async create(dto: ShippingOrderUpsertDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const model = await this.model(qr, dto.modelName, organizationId);
      // 같은 납기일 순번은 표를 잠그지 않고 MAX+1 로 잡고, 번호 중복이면 다시 잡는다
      for (let attempt = 0; attempt < 3; attempt += 1) {
        const seqRows = await qr.query(
          `SELECT NVL(MAX(PLAN_SEQUENCE), 0) + 1 AS "seq" FROM IP_PRODUCT_DELIVERY_PLAN
            WHERE PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD') AND ORGANIZATION_ID = :organizationId`,
          namedBinds({ planDate: dto.planDate, organizationId }),
        ) as Array<{ seq: number }>;
        const seq = Number(seqRows[0]?.seq ?? 1);
        const no = shipOrderNo(dto.planDate, seq);
        const dup = await qr.query(
          `SELECT COUNT(*) AS "cnt" FROM IP_PRODUCT_DELIVERY_PLAN WHERE MFS = :no AND ORGANIZATION_ID = :organizationId`,
          namedBinds({ no, organizationId }),
        ) as Array<{ cnt: number }>;
        if (Number(dup[0]?.cnt ?? 0) > 0) continue;
        await qr.query(
          `INSERT INTO IP_PRODUCT_DELIVERY_PLAN
             (PLAN_DATE, PLAN_SEQUENCE, LINE_CODE, MFS, MODEL_NAME, MODEL_SUFFIX, ITEM_CODE, PLAN_QTY, ACTUAL_QTY,
              CUSTOMER_CODE, PLAN_STATUS, COMMENTS, ORGANIZATION_ID, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
           VALUES (TO_DATE(:planDate, 'YYYY-MM-DD'), :seq, '*', :no, :modelName, :modelSuffix, :itemCode, :planQty, 0,
                   :customerCode, 'W', :comments, :organizationId, SYSDATE, :userId, SYSDATE, :userId)`,
          namedBinds({
            planDate: dto.planDate, seq, no, modelName: dto.modelName, modelSuffix: model.modelSuffix,
            itemCode: model.itemCode, planQty: dto.planQty, customerCode: dto.customerCode,
            comments: dto.comments?.trim() || null, organizationId, userId,
          }),
        );
        return { shipOrderNo: no };
      }
      throw new ConflictException('출하지시번호를 만들지 못했습니다. 다시 시도하세요.');
    });
  }

  async update(no: string, dto: ShippingOrderUpsertDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const cur = await this.lock(qr, no, organizationId);
      if (cur.actualQty > 0 && cur.modelName !== dto.modelName) {
        throw new ConflictException('출고된 박스가 있어 모델을 바꿀 수 없습니다.');
      }
      if (dto.planQty < cur.actualQty) {
        throw new BadRequestException(`지시수량은 이미 출고한 수량(${cur.actualQty})보다 작을 수 없습니다.`);
      }
      const model = await this.model(qr, dto.modelName, organizationId);
      await qr.query(
        `UPDATE IP_PRODUCT_DELIVERY_PLAN
            SET PLAN_DATE = TO_DATE(:planDate, 'YYYY-MM-DD'), CUSTOMER_CODE = :customerCode, MODEL_NAME = :modelName,
                MODEL_SUFFIX = :modelSuffix, ITEM_CODE = :itemCode, PLAN_QTY = :planQty, PLAN_STATUS = :planStatus,
                COMMENTS = :comments, LAST_MODIFY_DATE = SYSDATE, LAST_MODIFY_BY = :userId
          WHERE MFS = :no AND ORGANIZATION_ID = :organizationId`,
        namedBinds({
          planDate: dto.planDate, customerCode: dto.customerCode, modelName: dto.modelName,
          modelSuffix: model.modelSuffix, itemCode: model.itemCode, planQty: dto.planQty,
          planStatus: nextStatus(dto.planQty, cur.actualQty), comments: dto.comments?.trim() || null,
          userId, no, organizationId,
        }),
      );
      return { shipOrderNo: no };
    });
  }

  async remove(no: string, organizationId: number) {
    return this.tx.run(async (qr) => {
      const cur = await this.lock(qr, no, organizationId);
      if (cur.actualQty > 0) throw new ConflictException('출고된 박스가 있는 출하지시는 지울 수 없습니다.');
      await qr.query(
        `DELETE FROM IP_PRODUCT_DELIVERY_PLAN WHERE MFS = :no AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ no, organizationId }),
      );
      return { shipOrderNo: no };
    });
  }

  /** 박스 출고 직후(같은 트랜잭션) — 박스를 지시에 잇는다 */
  async linkIssuedBox(qr: Q, no: string, barcode: string, organizationId: number, userId: string) {
    const order = await this.lock(qr, no, organizationId);
    if (order.planStatus === 'C') throw new ConflictException(`출하지시 ${no} 는 이미 완료됐습니다.`);
    const box = await this.box(qr, barcode, organizationId);
    if (box.modelName !== order.modelName) {
      throw new BadRequestException(`박스 모델(${box.modelName})이 출하지시 모델(${order.modelName})과 다릅니다.`);
    }
    const actualQty = order.actualQty + box.qty;
    if (actualQty > order.planQty) {
      throw new ConflictException(`출하지시 수량을 넘습니다 (지시 ${order.planQty}, 출고 ${order.actualQty} + 박스 ${box.qty}).`);
    }
    await this.setShipNo(qr, barcode, no, organizationId, userId);
    await this.saveActual(qr, no, order.planQty, actualQty, organizationId, userId);
  }

  /** 박스 출고 취소 직후(같은 트랜잭션) — 지시 실적을 되돌린다 */
  async unlinkCancelledBox(qr: Q, no: string, barcode: string, organizationId: number, userId: string) {
    const order = await this.lock(qr, no, organizationId);
    const box = await this.box(qr, barcode, organizationId);
    await this.saveActual(qr, no, order.planQty, Math.max(0, order.actualQty - box.qty), organizationId, userId);
  }

  /** 박스가 출하지시로 나갔으면 그 지시번호 */
  async shipOrderOfBox(qr: Q, barcode: string, organizationId: number): Promise<string | null> {
    const rows = await qr.query(
      `SELECT SHIP_NO AS "shipNo" FROM IP_PRODUCT_PACK_MASTER WHERE PACK_BARCODE = :barcode AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ barcode, organizationId }),
    ) as Array<{ shipNo: string | null }>;
    const shipNo = rows[0]?.shipNo ?? null;
    return shipNo?.startsWith(SHIP_ORDER_PREFIX) ? shipNo : null;
  }

  private async lock(qr: Q, no: string, organizationId: number) {
    const rows = await qr.query(
      `SELECT MODEL_NAME AS "modelName", PLAN_QTY AS "planQty", NVL(ACTUAL_QTY, 0) AS "actualQty",
              NVL(PLAN_STATUS, 'W') AS "planStatus"
         FROM IP_PRODUCT_DELIVERY_PLAN WHERE MFS = :no AND ORGANIZATION_ID = :organizationId FOR UPDATE`,
      namedBinds({ no, organizationId }),
    ) as Array<{ modelName: string; planQty: number; actualQty: number; planStatus: string }>;
    if (!rows[0]) throw new NotFoundException(`출하지시 ${no} 가 없습니다.`);
    return { ...rows[0], planQty: Number(rows[0].planQty), actualQty: Number(rows[0].actualQty) };
  }

  private async box(qr: Q, barcode: string, organizationId: number) {
    const rows = await qr.query(
      `SELECT MODEL_NAME AS "modelName", PACK_QTY AS "qty" FROM IP_PRODUCT_PACK_MASTER
        WHERE PACK_BARCODE = :barcode AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ barcode, organizationId }),
    ) as Array<{ modelName: string; qty: number }>;
    if (!rows[0]) throw new BadRequestException(`포장 박스 ${barcode} 를 찾을 수 없습니다.`);
    return { modelName: rows[0].modelName, qty: Number(rows[0].qty ?? 0) };
  }

  private async model(qr: Q, modelName: string, organizationId: number) {
    const rows = await qr.query(
      `SELECT MODEL_SUFFIX AS "modelSuffix", ITEM_CODE AS "itemCode" FROM IP_PRODUCT_MODEL_MASTER
        WHERE MODEL_NAME = :modelName AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ modelName, organizationId }),
    ) as Array<{ modelSuffix: string | null; itemCode: string | null }>;
    if (!rows[0]) throw new BadRequestException(`모델마스터에 ${modelName} 이 없습니다.`);
    return { modelSuffix: rows[0].modelSuffix ?? '*', itemCode: rows[0].itemCode };
  }

  private async setShipNo(qr: Q, barcode: string, no: string, organizationId: number, userId: string) {
    // 방금 프로시저가 넣은 출고 행 = 그 바코드의 가장 늦은 출고 행
    await qr.query(
      `UPDATE IP_PRODUCT_FG_ISSUE SET SHIP_NO = :no, LAST_MODIFY_DATE = SYSDATE, LAST_MODIFY_BY = :userId
        WHERE ROWID = (SELECT MAX(ROWID) KEEP (DENSE_RANK LAST ORDER BY ISSUE_DATE, ISSUE_SEQUENCE)
                         FROM IP_PRODUCT_FG_ISSUE WHERE BARCODE = :barcode AND ORGANIZATION_ID = :organizationId)`,
      namedBinds({ no, userId, barcode, organizationId }),
    );
    await qr.query(
      `UPDATE IP_PRODUCT_PACK_MASTER SET SHIP_NO = :no, LAST_MODIFY_DATE = SYSDATE, LAST_MODIFY_BY = :userId
        WHERE PACK_BARCODE = :barcode AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ no, userId, barcode, organizationId }),
    );
  }

  private async saveActual(qr: Q, no: string, planQty: number, actualQty: number, organizationId: number, userId: string) {
    await qr.query(
      `UPDATE IP_PRODUCT_DELIVERY_PLAN SET ACTUAL_QTY = :actualQty, PLAN_STATUS = :planStatus,
              LAST_MODIFY_DATE = SYSDATE, LAST_MODIFY_BY = :userId
        WHERE MFS = :no AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ actualQty, planStatus: nextStatus(planQty, actualQty), userId, no, organizationId }),
    );
  }
}
```

테스트의 `upd[1]` 은 `namedBinds` 결과다. `namedBinds` 가 객체를 그대로 돌려주지 않으면(배열 등) 테스트 단언을 그 형태에 맞춘다 — `apps/backend/src/common/utils/named-binds.util.ts` 를 먼저 읽는다. `TransactionService.run` 의 콜백 인자(qr)가 `query(sql, params)` 를 가진다는 것은 product-fg.service.ts 414-446행과 같다.

- [ ] **Step 5: 컨트롤러·모듈 등록**

```ts
// apps/backend/src/modules/product/controllers/shipping-order.controller.ts
import { Body, Controller, Delete, Get, Param, Post, Put, Query, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { OrganizationId } from '../../../common/decorators/organization-id.decorator';
import { CurrentUserId } from '../../../common/decorators/current-user-id.decorator';
import { ShippingOrderQueryDto, ShippingOrderUpsertDto } from '../dto/shipping-order.dto';
import { ShippingOrderService } from '../services/shipping-order.service';

@UseGuards(JwtAuthGuard)
@Controller('product/shipping-orders')
export class ShippingOrderController {
  constructor(private readonly service: ShippingOrderService) {}

  @Get()
  list(@Query() query: ShippingOrderQueryDto, @OrganizationId() organizationId: number) {
    return this.service.list(query, organizationId);
  }

  @Post()
  create(@Body() dto: ShippingOrderUpsertDto, @OrganizationId() organizationId: number, @CurrentUserId() userId: string) {
    return this.service.create(dto, organizationId, userId);
  }

  @Put(':shipOrderNo')
  update(@Param('shipOrderNo') no: string, @Body() dto: ShippingOrderUpsertDto,
    @OrganizationId() organizationId: number, @CurrentUserId() userId: string) {
    return this.service.update(no, dto, organizationId, userId);
  }

  @Delete(':shipOrderNo')
  remove(@Param('shipOrderNo') no: string, @OrganizationId() organizationId: number) {
    return this.service.remove(no, organizationId);
  }
}
```

데코레이터 import 경로·이름(`OrganizationId`, 사용자 id 데코레이터)은 `product-shipping.controllers.ts` 가 쓰는 것과 똑같이 맞춘다. `product-inventory.module.ts` 의 controllers 에 `ShippingOrderController`, providers 에 `ShippingOrderService` 추가.

- [ ] **Step 6: 출고 연결** (`product-fg.dto.ts`, `product-fg.service.ts`)

FgIssueDto 에 추가:

```ts
  /** 출하지시번호 — 있으면 출고한 박스를 그 지시에 잇는다 (출고 취소는 박스 기록으로 찾는다) */
  @IsOptional() @IsString() @MaxLength(30) shipOrderNo?: string;
```

ProductFgService 생성자에 `private readonly shippingOrders: ShippingOrderService` 주입. `runProc` 에 선택 인자 `after?: (qr) => Promise<void>` 와 `before?: (qr) => Promise<void>` 를 더해 프로시저 호출 전후, 같은 `this.tx.run` 안에서 부른다. issue:

```ts
  async issue(dto: FgIssueDto, organizationId: number, userId = 'ADMIN') {
    const txn = dto.cancel ? FG_TXN.issueCancel : FG_TXN.issue;
    const barcode = dto.barcode.trim();
    let cancelledOrder: string | null = null;
    return this.runProc(
      'P_PRODUCT_FG_ISSUE(:barcode, :barType, :customerCode, :location, :txn, :commitFlag, v_out, v_msg)',
      { barcode, barType: dto.barType ?? 'I', customerCode: dto.customerCode, location: dto.locationCode, txn, commitFlag: NO_PROC_COMMIT },
      dto.cancel ? '출하취소' : '출하',
      { barcode, txn, organizationId, shipOrderNo: dto.shipOrderNo ?? null },
      {
        // 취소는 프로시저가 박스 기록을 바꾸기 전에 어느 지시로 나갔는지 읽어 둔다
        before: dto.cancel ? async (qr) => { cancelledOrder = await this.shippingOrders.shipOrderOfBox(qr, barcode, organizationId); } : undefined,
        after: async (qr) => {
          if (dto.cancel) {
            if (cancelledOrder) await this.shippingOrders.unlinkCancelledBox(qr, cancelledOrder, barcode, organizationId, userId);
          } else if (dto.shipOrderNo?.trim()) {
            await this.shippingOrders.linkIssuedBox(qr, dto.shipOrderNo.trim(), barcode, organizationId, userId);
          }
        },
      },
    );
  }
```

컨트롤러 `@Post('issue')` 가 사용자 id 를 넘기도록 고친다(같은 파일의 다른 쓰기 엔드포인트가 쓰는 데코레이터를 따른다). `after` 에서 예외가 나면 `tx.run` 이 롤백하므로 프로시저 출고도 취소된다 — 이것을 product-fg 테스트로 고정한다:

```ts
  it('rolls back the issue when the box cannot be linked to the order', async () => {
    // tx.run 모킹: 콜백 예외를 그대로 던지고 commit 을 부르지 않는지 확인
  });
```

(product-fg.service 에 spec 이 없으면 `product-fg.issue.spec.ts` 를 새로 만들고, `tx.run` 을 `jest.fn(async (cb) => cb(qr))` 로, `shippingOrders.linkIssuedBox` 를 reject 로 모킹해 `issue()` 가 reject 되는지만 단언한다.)

- [ ] **Step 7: 통과 확인**

Run: `pnpm --filter @eunsung/backend exec jest src/modules/product`
Expected: PASS
Run: `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`
Expected: 오류 없음

- [ ] **Step 8: Commit**

```bash
git add apps/backend/src/modules/product
git commit -m "feat(product): 출하지시(IP_PRODUCT_DELIVERY_PLAN) 등록과 출고 박스 연결을 추가한다"
```

---

### Task 8: 출하지시 화면·메뉴·출고 화면 지시 선택 (프론트)

**Files:**
- Create: `apps/frontend/src/app/(authenticated)/product/shipping-order/page.tsx`
- Create: `apps/frontend/src/app/(authenticated)/product/shipping-order/components/ShippingOrderFormModal.tsx`
- Create: `apps/frontend/src/app/(authenticated)/product/components/ShippingOrderPickerModal.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/product/components/FgScanPanel.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/product/fg-issue/page.tsx`
- Modify: `apps/frontend/src/config/menuConfig.ts` (292행 PRD_FG_ISSUE 바로 위)
- Modify: `apps/frontend/src/locales/ko.json`, `en.json`, `vi.json`, `zh.json` (`productMgmt.fgIssue` 근처)
- Modify: `apps/backend/src/modules/menu-categories/utils/menu-code-validator.ts`, `default-menu-category-layout.ts`, `apps/backend/src/seeds/menu-config.json`

**Interfaces:**
- Consumes: Task 7 API, `FgIssueDto.shipOrderNo`
- Produces: 메뉴 코드 `PRD_SHIPPING_ORDER`, 경로 `/product/shipping-order`, pbWindow `w_pln_product_delivery_master`. `FgScanPanel` 의 `extraBody?: Record<string, unknown>`, `headerSlot?: React.ReactNode`.

- [ ] **Step 1: 메뉴 등록**

menuConfig.ts PRD_FG_ISSUE 위에:

```ts
      { code: "PRD_SHIPPING_ORDER", labelKey: "menu.productMgmt.shippingOrder", path: "/product/shipping-order", pbLinkStatus: "powerbuilder", pbWindow: "w_pln_product_delivery_master" },
```

locales: ko `"productMgmt.shippingOrder": "출하지시"`, en `"Shipping Order"`, vi `"Lệnh xuất hàng"`, zh `"出货指示"`.
validator·default layout·seed json 에 `PRD_FG_ISSUE` 가 들어간 자리 바로 앞에 같은 형식으로 `PRD_SHIPPING_ORDER` 추가 (세 파일 모두 `git grep -n PRD_FG_ISSUE` 로 위치 확인).

- [ ] **Step 2: 구조 테스트·생성기 실행**

Run: `pnpm --filter @eunsung/frontend test`
Expected: PASS. pageRegistry.generated.ts 등 생성 파일이 바뀌면 함께 커밋 대상에 넣는다. 실패하면 메시지가 가리키는 등록 누락(도움말 manifest 등)을 채운다.

- [ ] **Step 3: 출하지시 화면**

`page.tsx` — 기존 목록 화면 패턴(예: `product/fg-issue-query/page.tsx`)을 따른다:
- 조회 조건: 납기일 `DateRangeFilter`(기본 오늘~+14일), 고객 `PopupSearchField popupId="customer-search"`, 모델 `ModelSearchField`, [조회].
- 헤더 오른쪽 [출하지시 등록] 버튼 → `ShippingOrderFormModal`.
- `DataGrid` 열: 출하지시번호, 납기일, 고객, 모델, 지시수량, 출고수량, 잔량, 상태(`ComCodeBadge` groupCode `PLAN STATUS`), 비고. 행 더블클릭 → 수정 모달.
- 삭제는 모달 안 [삭제] 버튼 + 프로젝트 확인 모달(ConfirmModal 류 — `components/ui` 에서 기존 확인 모달을 찾아 쓴다). 출고수량 > 0 이면 버튼 비활성.

`ShippingOrderFormModal.tsx` — 납기일(date input), 고객(PopupSearchField 필수), 모델(ModelSearchField 필수), 수량(number, 1 이상), 비고. 저장: 신규 `POST /product/shipping-orders`, 수정 `PUT /product/shipping-orders/:no`. 오류는 `toast.error(서버 message)`.

- [ ] **Step 4: 출고 화면 지시 선택**

`FgScanPanel.tsx`: props 에 `extraBody?: Record<string, unknown>`, `headerSlot?: React.ReactNode` 추가. post 본문에 `...(extraBody ?? {})` 를 펼치고, `headerSlot` 은 처리 버튼 줄 앞에 그린다.

`ShippingOrderPickerModal.tsx`: `GET /product/shipping-orders?openOnly=true&dateFrom=오늘-7&dateTo=오늘+30` 목록을 카드 격자로 보여주고 고르면 `onPick(row)`.

`fg-issue/page.tsx`:
- `const [shipOrder, setShipOrder] = useState<ShippingOrderRow | null>(null);`
- `headerSlot` 에 [출하지시 선택] 버튼 + 고른 지시 요약(번호·고객·모델·잔량) + [해제].
- `extraBody={shipOrder ? { shipOrderNo: shipOrder.shipOrderNo, customerCode: shipOrder.customerCode } : undefined}` — 지시를 고르면 고객은 지시 고객으로 보낸다.
- 처리 후 `onDone` 에서 지시 목록을 다시 읽어 잔량을 갱신하고, 잔량 0 이면 선택을 해제하고 `toast.success('출하지시가 완료됐습니다.')`.

- [ ] **Step 5: 확인**

Run: `pnpm --filter @eunsung/frontend exec tsc --noEmit --pretty false` 와 `pnpm --filter @eunsung/frontend lint`
Expected: 오류 없음

- [ ] **Step 6: 메뉴 DB 반영**

oracle-db 로 `MENU_CATEGORY_ITEMS` 에 PRD_FG_ISSUE 행의 카테고리·정렬을 읽어 같은 카테고리에 PRD_SHIPPING_ORDER 를 넣는다(pre/post SELECT 기록). 이미 있으면 건너뛴다.

- [ ] **Step 7: Commit**

```bash
git add "apps/frontend/src/app/(authenticated)/product" apps/frontend/src/config/menuConfig.ts apps/frontend/src/locales apps/frontend/src/components/layout/pageRegistry.generated.ts apps/backend/src/modules/menu-categories/utils apps/backend/src/seeds/menu-config.json
git commit -m "feat(product): 출하지시 화면을 추가하고 출고 화면에서 출하지시를 고른다"
```

---

### Task 9: 실DB 통합 확인과 정리

**Files:** 코드 변경 없음. 필요 시 `docs/reports/2026-10-14-production-order-and-shipping-order-unfinished.md`

- [ ] **Step 1: 백엔드·프론트 전체 검사**

Run: `pnpm --filter @eunsung/backend test` · `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false` · `pnpm --filter @eunsung/frontend test` · `pnpm --filter @eunsung/frontend exec tsc --noEmit --pretty false`
Expected: 전부 통과. 실패는 원문 그대로 보고한다.

- [ ] **Step 2: 지시 대비 실적 대조 (dev 서버가 떠 있을 때)**

1. 조립 H라인(34) 계획으로 코팅(W091) 런카드를 발행한다(테스트 시드 TSTMI34% 계획).
2. 설비별 작업실적에서 그 런카드에 실적 5 를 넣는다.
3. `GET /monitoring/production-board`(실제 경로는 controller 확인)의 그 런카드 goodQty 가 5, 대시보드 `miActual` 이 5 만큼 늘었는지 확인한다.
4. 다른 공정(W120)으로 같은 런카드에 실적을 넣으면 400 이 나는지 확인한다.

- [ ] **Step 3: 출고 연결 확인**

1. 테스트 출하지시(고객·모델 = 출고 가능 박스 하나와 같게, 수량 = 그 박스 수량)를 등록한다.
2. 그 박스를 지시를 골라 출고 → IP_PRODUCT_FG_ISSUE·PACK_MASTER SHIP_NO 와 지시 ACTUAL_QTY·상태 C 확인 (SELECT 기록).
3. 같은 박스 출고 취소 → ACTUAL_QTY 0·상태 W 확인.
4. 테스트 출하지시를 삭제한다. 출고/취소 이력 2행은 남는다(재고 원장) — 보고에 적는다.

- [ ] **Step 4: 미완료 기록**

검증하지 못한 항목이나 남은 정리(테스트 시드 TST34%·WOTEST34%·TSTMI34%)가 있으면 `docs/reports/2026-10-14-production-order-and-shipping-order-unfinished.md` 에 남긴다.
