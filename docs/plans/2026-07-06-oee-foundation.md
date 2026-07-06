# OEE 관리기능 — 플랜 1: 데이터·계산 기반 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** OEE 관리기능의 데이터 스키마(신규 테이블 5종)와 재사용 가능한 계산·검증 로직 모듈을 구축한다 — 입력·대시보드 플랜의 공통 기반.

**Architecture:** 접근 B(독립 OEE 도메인). Oracle에 OEE 전용 테이블 5종을 생성하고, 가동율·성능율·양품율·OEE 계산식과 입력 검증식을 `src/lib/oee/`에 순수 함수로 단일 정의한다. 프론트/API가 이 모듈을 공유 참조한다(계산식 중복 금지).

**Tech Stack:** Next.js 16, TypeScript 5, Oracle `oracledb` 6, vitest(신규 도입).

**근거 스펙:** `docs/specs/2026-07-06-oee-management-design.md`

## Global Constraints

- Oracle 접근은 `src/lib/db.ts` 헬퍼만 사용 (`executeQuery`/`executeDml`/신규 `executeTransaction`).
- `config/database.json`은 git 미추적 — 커밋 금지.
- Oracle 오류(`ORA-*`/`NJS-*`)는 원문 보존.
- 소스는 UTF-8, PowerShell `Set-Content` 금지(한글). 편집은 Edit/Write 도구 사용.
- 계산식·검증식은 `src/lib/oee/`에 **한 번만** 정의 — 다른 레이어는 복제하지 말고 import.
- 신규 테이블 컬럼은 모두 `organization_id` 포함(다중사업장 정책, 스펙 11장 확인 대상).
- DDL/PLSQL 원본은 `oracle_db_scripts/oee/`에 저장, 개발 근거 SQL 스냅샷은 `docs/sql/`(문서 규정).

## File Structure

| 파일 | 책임 |
|---|---|
| `oracle_db_scripts/oee/01_tables.sql` | OEE 테이블 5종 DDL + 시퀀스/제약 |
| `oracle_db_scripts/oee/02_seed_reason.sql` | 비가동사유 6대 로스 시드 데이터 |
| `src/lib/db.ts` | `executeTransaction` 헬퍼 추가 (근무조 원자적 저장용) |
| `src/lib/oee/types.ts` | OEE 도메인 공용 타입 |
| `src/lib/oee/oee-calc.ts` | 가동율/성능율/양품율/OEE 순수 계산 함수 |
| `src/lib/oee/oee-validation.ts` | 가동일지 구간 검증 순수 함수 |
| `src/lib/oee/oee-calc.test.ts` | 계산 함수 유닛테스트 |
| `src/lib/oee/oee-validation.test.ts` | 검증 함수 유닛테스트 |
| `vitest.config.ts` | vitest 설정 |
| `package.json` | vitest devDependency + `test` 스크립트 |

---

## Task 0: 도구 셋업 — vitest + 트랜잭션 헬퍼

**Files:**
- Modify: `package.json` (devDependency + scripts)
- Create: `vitest.config.ts`
- Modify: `src/lib/db.ts` (append `executeTransaction`)
- Create: `src/lib/oee/__smoke__.test.ts` (러너 동작 확인용, 마지막에 삭제)

**Interfaces:**
- Produces: `executeTransaction(statements: Array<{ sql: string; binds?: oracledb.BindParameters }>): Promise<void>` — 여러 DML을 단일 커넥션/커밋으로 실행, 실패 시 롤백.

- [ ] **Step 1: vitest 설치**

Run: `npm install -D vitest@^2`
Expected: `package.json` devDependencies에 `vitest` 추가, 설치 성공.

- [ ] **Step 2: `package.json`에 test 스크립트 추가**

`scripts` 블록에 아래 줄 추가:
```json
"test": "vitest run",
"test:watch": "vitest"
```

- [ ] **Step 3: `vitest.config.ts` 생성**

```ts
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    include: ['src/**/*.test.ts'],
    environment: 'node',
  },
});
```

- [ ] **Step 4: 스모크 테스트로 러너 확인**

Create `src/lib/oee/__smoke__.test.ts`:
```ts
import { describe, it, expect } from 'vitest';

describe('smoke', () => {
  it('runs', () => {
    expect(1 + 1).toBe(2);
  });
});
```

Run: `npm test`
Expected: PASS 1 test.

- [ ] **Step 5: `executeTransaction` 헬퍼 추가**

`src/lib/db.ts`의 `executeDml` 함수 바로 뒤에 추가:
```ts
/**
 * 여러 DML을 단일 커넥션·단일 커밋으로 실행한다.
 * 하나라도 실패하면 전체 롤백 (근무조 단위 원자적 저장용).
 */
export async function executeTransaction(
  statements: Array<{ sql: string; binds?: oracledb.BindParameters }>,
): Promise<void> {
  const pool = await getPool();
  const conn = await pool.getConnection();
  try {
    for (const { sql, binds } of statements) {
      await conn.execute(sql, binds ?? {}, { autoCommit: false });
    }
    await conn.commit();
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    await conn.close();
  }
}
```

- [ ] **Step 6: 타입 체크**

Run: `npx tsc --noEmit --pretty false`
Expected: 에러 없음 (기존 대비 신규 에러 0).

- [ ] **Step 7: 스모크 테스트 삭제 후 커밋**

```bash
rm src/lib/oee/__smoke__.test.ts
git add package.json package-lock.json vitest.config.ts src/lib/db.ts
git commit -m "chore(oee): add vitest and executeTransaction helper"
```

---

## Task 1: OEE 도메인 테이블 DDL (5종) + 시드

**Files:**
- Create: `oracle_db_scripts/oee/01_tables.sql`
- Create: `oracle_db_scripts/oee/02_seed_reason.sql`
- Create: `docs/sql/oee_tables_snapshot.sql` (근거 스냅샷 = 01_tables.sql 사본)

**Interfaces:**
- Produces (테이블/컬럼, 이후 모든 플랜이 참조):
  - `OEE_RESOURCE(resource_id, organization_id, process_code, resource_type, ref_code, resource_name, ideal_ct, use_yn, sort_order)`
  - `OEE_DOWNTIME_REASON(reason_code, organization_id, process_code, reason_name, loss_bucket, oee_factor, use_yn, sort_order)`
  - `OEE_OPERATION_LOG(log_id, organization_id, resource_id, process_code, work_date, shift, start_time, end_time, duration_min, status, reason_code, run_no, remark, created_by, created_date)`
  - `OEE_PLAN_TIME(plan_time_id, resource_id, organization_id, work_date, shift, planned_minutes, planned_stop_minutes, net_load_minutes, override_yn)`
  - `OEE_DAILY_SUMMARY(summary_id, resource_id, process_code, organization_id, work_date, shift, net_load_min, run_min, downtime_min, availability, ideal_ct, output_qty, performance, good_qty, total_qty, quality, oee)`

- [ ] **Step 1: `01_tables.sql` 작성**

```sql
-- OEE 도메인 테이블 (접근 B: 독립 도메인)
-- 실행 계정: 은성 MES 스키마 소유자. 재실행 안전을 위해 DROP은 수동 판단.

CREATE TABLE OEE_RESOURCE (
  RESOURCE_ID      NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  ORGANIZATION_ID  NUMBER        NOT NULL,
  PROCESS_CODE     VARCHAR2(20)  NOT NULL,   -- SMT/PERF/COAT/ROUTER/ASSY/PACK
  RESOURCE_TYPE    VARCHAR2(20)  NOT NULL,   -- MACHINE/LINE/WORKGROUP
  REF_CODE         VARCHAR2(50),             -- IMCN_MACHINE.MACHINE_CODE 또는 라인코드
  RESOURCE_NAME    VARCHAR2(100) NOT NULL,
  IDEAL_CT         NUMBER,                   -- 이론 CT(초), NULL이면 모델 ST 사용
  USE_YN           CHAR(1)       DEFAULT 'Y' NOT NULL,
  SORT_ORDER       NUMBER        DEFAULT 0   NOT NULL
);

CREATE TABLE OEE_DOWNTIME_REASON (
  REASON_CODE      VARCHAR2(20)  PRIMARY KEY,
  ORGANIZATION_ID  NUMBER        NOT NULL,
  PROCESS_CODE     VARCHAR2(20)  DEFAULT '*' NOT NULL,  -- '*'=공통
  REASON_NAME      VARCHAR2(100) NOT NULL,
  LOSS_BUCKET      VARCHAR2(30)  NOT NULL,   -- AVAIL_DOWN/SETUP/MATERIAL/PERF_MINOR_STOP/PERF_SPEED
  OEE_FACTOR       VARCHAR2(20)  NOT NULL,   -- AVAILABILITY/PERFORMANCE
  USE_YN           CHAR(1)       DEFAULT 'Y' NOT NULL,
  SORT_ORDER       NUMBER        DEFAULT 0   NOT NULL
);

CREATE TABLE OEE_OPERATION_LOG (
  LOG_ID           NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  ORGANIZATION_ID  NUMBER        NOT NULL,
  RESOURCE_ID      NUMBER        NOT NULL REFERENCES OEE_RESOURCE(RESOURCE_ID),
  PROCESS_CODE     VARCHAR2(20)  NOT NULL,
  WORK_DATE        DATE          NOT NULL,
  SHIFT            VARCHAR2(10)  NOT NULL,   -- DAY/NIGHT
  START_TIME       DATE          NOT NULL,
  END_TIME         DATE          NOT NULL,
  DURATION_MIN     NUMBER        NOT NULL,
  STATUS           VARCHAR2(10)  NOT NULL,   -- RUN/DOWN
  REASON_CODE      VARCHAR2(20)  REFERENCES OEE_DOWNTIME_REASON(REASON_CODE),
  RUN_NO           VARCHAR2(50),
  REMARK           VARCHAR2(500),
  CREATED_BY       VARCHAR2(50)  NOT NULL,   -- 작업자 사번
  CREATED_DATE     DATE          DEFAULT SYSDATE NOT NULL
);
CREATE INDEX IX_OEE_OPLOG_RES_DATE ON OEE_OPERATION_LOG(RESOURCE_ID, WORK_DATE, SHIFT);

CREATE TABLE OEE_PLAN_TIME (
  PLAN_TIME_ID        NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  RESOURCE_ID         NUMBER        NOT NULL REFERENCES OEE_RESOURCE(RESOURCE_ID),
  ORGANIZATION_ID     NUMBER        NOT NULL,
  WORK_DATE           DATE          NOT NULL,
  SHIFT               VARCHAR2(10)  NOT NULL,
  PLANNED_MINUTES     NUMBER        NOT NULL,
  PLANNED_STOP_MINUTES NUMBER       DEFAULT 0 NOT NULL,
  NET_LOAD_MINUTES    NUMBER        NOT NULL,
  OVERRIDE_YN         CHAR(1)       DEFAULT 'N' NOT NULL,
  CONSTRAINT UQ_OEE_PLANTIME UNIQUE (RESOURCE_ID, WORK_DATE, SHIFT)
);

CREATE TABLE OEE_DAILY_SUMMARY (
  SUMMARY_ID       NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  RESOURCE_ID      NUMBER        NOT NULL REFERENCES OEE_RESOURCE(RESOURCE_ID),
  PROCESS_CODE     VARCHAR2(20)  NOT NULL,
  ORGANIZATION_ID  NUMBER        NOT NULL,
  WORK_DATE        DATE          NOT NULL,
  SHIFT            VARCHAR2(10)  NOT NULL,
  NET_LOAD_MIN     NUMBER        DEFAULT 0 NOT NULL,
  RUN_MIN          NUMBER        DEFAULT 0 NOT NULL,
  DOWNTIME_MIN     NUMBER        DEFAULT 0 NOT NULL,
  AVAILABILITY     NUMBER        DEFAULT 0 NOT NULL,
  IDEAL_CT         NUMBER,
  OUTPUT_QTY       NUMBER        DEFAULT 0 NOT NULL,
  PERFORMANCE      NUMBER        DEFAULT 0 NOT NULL,
  GOOD_QTY         NUMBER        DEFAULT 0 NOT NULL,
  TOTAL_QTY        NUMBER        DEFAULT 0 NOT NULL,
  QUALITY          NUMBER        DEFAULT 0 NOT NULL,
  OEE              NUMBER        DEFAULT 0 NOT NULL,
  CONSTRAINT UQ_OEE_SUMMARY UNIQUE (RESOURCE_ID, WORK_DATE, SHIFT)
);
```

- [ ] **Step 2: `02_seed_reason.sql` 작성 (6대 로스 최소 시드)**

```sql
-- ORGANIZATION_ID는 대상 사업장 값으로 치환 (예: 1). 착수 전 확인 항목.
INSERT INTO OEE_DOWNTIME_REASON (REASON_CODE, ORGANIZATION_ID, PROCESS_CODE, REASON_NAME, LOSS_BUCKET, OEE_FACTOR, SORT_ORDER) VALUES ('MAT_WAIT', 1, '*', '자재 대기',       'MATERIAL',        'AVAILABILITY', 10);
INSERT INTO OEE_DOWNTIME_REASON (REASON_CODE, ORGANIZATION_ID, PROCESS_CODE, REASON_NAME, LOSS_BUCKET, OEE_FACTOR, SORT_ORDER) VALUES ('SETUP',    1, '*', '셋업/단품교체',   'SETUP',           'AVAILABILITY', 20);
INSERT INTO OEE_DOWNTIME_REASON (REASON_CODE, ORGANIZATION_ID, PROCESS_CODE, REASON_NAME, LOSS_BUCKET, OEE_FACTOR, SORT_ORDER) VALUES ('BREAKDOWN',1, '*', '설비 고장정지',   'AVAIL_DOWN',      'AVAILABILITY', 30);
INSERT INTO OEE_DOWNTIME_REASON (REASON_CODE, ORGANIZATION_ID, PROCESS_CODE, REASON_NAME, LOSS_BUCKET, OEE_FACTOR, SORT_ORDER) VALUES ('NO_OPER',  1, '*', '작업자 부재',     'AVAIL_DOWN',      'AVAILABILITY', 40);
INSERT INTO OEE_DOWNTIME_REASON (REASON_CODE, ORGANIZATION_ID, PROCESS_CODE, REASON_NAME, LOSS_BUCKET, OEE_FACTOR, SORT_ORDER) VALUES ('MINOR_STOP',1,'*', '미세정지',        'PERF_MINOR_STOP', 'PERFORMANCE',  50);
INSERT INTO OEE_DOWNTIME_REASON (REASON_CODE, ORGANIZATION_ID, PROCESS_CODE, REASON_NAME, LOSS_BUCKET, OEE_FACTOR, SORT_ORDER) VALUES ('SPEED_LOSS',1,'*', '속도저하',        'PERF_SPEED',      'PERFORMANCE',  60);
COMMIT;
```

- [ ] **Step 3: DDL 배포**

`oracle-db` 스킬로 `01_tables.sql` → `02_seed_reason.sql` 순서로 배포한다. (스킬이 없으면 은성 MES 스키마 소유자 계정으로 sqlplus/SQL Developer 실행.)
Expected: 5개 CREATE TABLE 성공, 6행 INSERT 성공.

- [ ] **Step 4: 배포 검증**

`oracle-db` 스킬 또는 read-only 쿼리로 실행:
```sql
SELECT table_name FROM user_tables WHERE table_name LIKE 'OEE_%' ORDER BY table_name;
SELECT COUNT(*) FROM OEE_DOWNTIME_REASON;
```
Expected: 5개 테이블(OEE_DAILY_SUMMARY, OEE_DOWNTIME_REASON, OEE_OPERATION_LOG, OEE_PLAN_TIME, OEE_RESOURCE), REASON 6행.

- [ ] **Step 5: 근거 스냅샷 복사 후 커밋**

`docs/sql/oee_tables_snapshot.sql`에 `01_tables.sql` 내용을 그대로 복사(문서 규정: 개발 근거 SQL 스냅샷).
```bash
git add oracle_db_scripts/oee/01_tables.sql oracle_db_scripts/oee/02_seed_reason.sql docs/sql/oee_tables_snapshot.sql
git commit -m "feat(oee): add OEE domain tables DDL and downtime reason seed"
```

---

## Task 2: 계산 모듈 `oee-calc.ts` (TDD)

**Files:**
- Create: `src/lib/oee/oee-calc.ts`
- Test: `src/lib/oee/oee-calc.test.ts`

**Interfaces:**
- Produces:
  - `availability(runMinutes: number, netLoadMinutes: number): number`
  - `performance(idealCtSec: number, totalQty: number, runMinutes: number): number`
  - `quality(goodQty: number, totalQty: number): number`
  - `oee(availabilityRate: number, performanceRate: number, qualityRate: number): number`
  - 규칙: 분모가 0 이하이면 0 반환(0으로 나누기 방지). 비율은 clamp하지 않음(1 초과 = 이상징후 노출).

- [ ] **Step 1: 실패하는 테스트 작성**

`src/lib/oee/oee-calc.test.ts`:
```ts
import { describe, it, expect } from 'vitest';
import { availability, performance, quality, oee } from './oee-calc';

describe('availability = 실제가동 / 계획가동', () => {
  it('완전 가동이면 1', () => expect(availability(480, 480)).toBe(1));
  it('절반 가동이면 0.5', () => expect(availability(240, 480)).toBe(0.5));
  it('계획가동 0이면 0 (0으로 나누기 방지)', () => expect(availability(100, 0)).toBe(0));
});

describe('performance = (이론CT초 x 총생산) / 가동초', () => {
  it('이론CT 6초, 100개, 10분 가동이면 1', () => expect(performance(6, 100, 10)).toBe(1));
  it('가동 0분이면 0', () => expect(performance(6, 100, 0)).toBe(0));
});

describe('quality = 양품 / 총생산', () => {
  it('95/100 = 0.95', () => expect(quality(95, 100)).toBe(0.95));
  it('총생산 0이면 0', () => expect(quality(0, 0)).toBe(0));
});

describe('oee = 가동 x 성능 x 양품', () => {
  it('세 비율의 곱', () => expect(oee(0.5, 0.5, 0.5)).toBe(0.125));
});
```

- [ ] **Step 2: 실패 확인**

Run: `npx vitest run src/lib/oee/oee-calc.test.ts`
Expected: FAIL — `Cannot find module './oee-calc'`.

- [ ] **Step 3: 최소 구현**

`src/lib/oee/oee-calc.ts`:
```ts
/**
 * OEE 계산 순수 함수. 프론트/API/집계가 이 정의를 공유한다 (계산식 단일 출처).
 * 분모가 0 이하이면 0을 반환한다. 비율은 clamp하지 않는다(1 초과 = 이상 노출).
 */

/** 가동율 = 실제 가동시간 / 계획 가동시간(순부하시간) */
export function availability(runMinutes: number, netLoadMinutes: number): number {
  if (netLoadMinutes <= 0) return 0;
  return runMinutes / netLoadMinutes;
}

/** 성능율 = (이론CT초 x 총생산수량) / (가동분 x 60) */
export function performance(idealCtSec: number, totalQty: number, runMinutes: number): number {
  const runSeconds = runMinutes * 60;
  if (runSeconds <= 0) return 0;
  return (idealCtSec * totalQty) / runSeconds;
}

/** 양품율 = 양품수량 / 총생산수량 */
export function quality(goodQty: number, totalQty: number): number {
  if (totalQty <= 0) return 0;
  return goodQty / totalQty;
}

/** OEE = 가동율 x 성능율 x 양품율 */
export function oee(availabilityRate: number, performanceRate: number, qualityRate: number): number {
  return availabilityRate * performanceRate * qualityRate;
}
```

- [ ] **Step 4: 통과 확인**

Run: `npx vitest run src/lib/oee/oee-calc.test.ts`
Expected: PASS (10 assertions).

- [ ] **Step 5: 커밋**

```bash
git add src/lib/oee/oee-calc.ts src/lib/oee/oee-calc.test.ts
git commit -m "feat(oee): add availability/performance/quality/oee calc functions"
```

---

## Task 3: 검증 모듈 `oee-validation.ts` (TDD)

**Files:**
- Create: `src/lib/oee/types.ts`
- Create: `src/lib/oee/oee-validation.ts`
- Test: `src/lib/oee/oee-validation.test.ts`

**Interfaces:**
- Consumes: 없음(순수 로직).
- Produces:
  - `types.ts`: `interface LogInterval { startMin: number; endMin: number; status: 'RUN' | 'DOWN'; reasonCode: string | null; }`
  - `types.ts`: `interface OeeValidationError { code: 'REVERSED' | 'OVERLAP' | 'EXCEEDS_LOAD' | 'REASON_REQUIRED'; index: number; message: string; }`
  - `validateIntervals(intervals: LogInterval[], netLoadMinutes: number): OeeValidationError[]`
  - 규칙: `startMin`/`endMin`은 근무조 기준 경과분. 검사 = ①역전(end<=start) ②겹침 ③합>계획가동 ④DOWN인데 사유없음. 위반 없으면 빈 배열.

- [ ] **Step 1: 실패하는 테스트 작성**

`src/lib/oee/oee-validation.test.ts`:
```ts
import { describe, it, expect } from 'vitest';
import { validateIntervals } from './oee-validation';
import type { LogInterval } from './types';

const run = (s: number, e: number): LogInterval => ({ startMin: s, endMin: e, status: 'RUN', reasonCode: null });
const down = (s: number, e: number, r: string | null): LogInterval => ({ startMin: s, endMin: e, status: 'DOWN', reasonCode: r });

describe('validateIntervals', () => {
  it('정상 구간이면 오류 없음', () => {
    expect(validateIntervals([run(0, 60), down(60, 90, 'SETUP')], 480)).toEqual([]);
  });
  it('역전 구간 검출', () => {
    const errs = validateIntervals([run(60, 60)], 480);
    expect(errs.map((e) => e.code)).toContain('REVERSED');
  });
  it('겹침 검출', () => {
    const errs = validateIntervals([run(0, 60), run(30, 90)], 480);
    expect(errs.map((e) => e.code)).toContain('OVERLAP');
  });
  it('계획가동 초과 검출', () => {
    const errs = validateIntervals([run(0, 300), run(300, 600)], 480);
    expect(errs.map((e) => e.code)).toContain('EXCEEDS_LOAD');
  });
  it('비가동인데 사유 없으면 검출', () => {
    const errs = validateIntervals([down(0, 30, null)], 480);
    expect(errs.map((e) => e.code)).toContain('REASON_REQUIRED');
  });
});
```

- [ ] **Step 2: 실패 확인**

Run: `npx vitest run src/lib/oee/oee-validation.test.ts`
Expected: FAIL — 모듈 없음.

- [ ] **Step 3: 타입 + 구현 작성**

`src/lib/oee/types.ts`:
```ts
/** OEE 도메인 공용 타입 */

export interface LogInterval {
  startMin: number;         // 근무조 시작 기준 경과분
  endMin: number;
  status: 'RUN' | 'DOWN';
  reasonCode: string | null; // DOWN일 때 필수
}

export interface OeeValidationError {
  code: 'REVERSED' | 'OVERLAP' | 'EXCEEDS_LOAD' | 'REASON_REQUIRED';
  index: number;            // 해당 구간 index, 전체 위반이면 -1
  message: string;
}
```

`src/lib/oee/oee-validation.ts`:
```ts
import type { LogInterval, OeeValidationError } from './types';

/**
 * 가동일지 구간을 검증한다. 프론트 입력검증과 write API가 공유한다(검증식 단일 출처).
 * 위반이 없으면 빈 배열을 반환한다.
 */
export function validateIntervals(
  intervals: LogInterval[],
  netLoadMinutes: number,
): OeeValidationError[] {
  const errors: OeeValidationError[] = [];

  intervals.forEach((iv, i) => {
    if (iv.endMin <= iv.startMin) {
      errors.push({ code: 'REVERSED', index: i, message: `구간 ${i + 1}: 종료가 시작보다 같거나 빠릅니다` });
    }
    if (iv.status === 'DOWN' && !iv.reasonCode) {
      errors.push({ code: 'REASON_REQUIRED', index: i, message: `구간 ${i + 1}: 비가동은 사유가 필수입니다` });
    }
  });

  const ordered = intervals
    .map((iv, i) => ({ iv, i }))
    .sort((a, b) => a.iv.startMin - b.iv.startMin);
  for (let k = 1; k < ordered.length; k++) {
    if (ordered[k].iv.startMin < ordered[k - 1].iv.endMin) {
      errors.push({ code: 'OVERLAP', index: ordered[k].i, message: `구간 ${ordered[k].i + 1}: 이전 구간과 겹칩니다` });
    }
  }

  const total = intervals.reduce((sum, iv) => sum + Math.max(0, iv.endMin - iv.startMin), 0);
  if (netLoadMinutes > 0 && total > netLoadMinutes) {
    errors.push({ code: 'EXCEEDS_LOAD', index: -1, message: `구간 합(${total}분)이 계획가동시간(${netLoadMinutes}분)을 초과합니다` });
  }

  return errors;
}
```

- [ ] **Step 4: 통과 확인**

Run: `npx vitest run src/lib/oee/oee-validation.test.ts`
Expected: PASS (5 tests).

- [ ] **Step 5: 전체 테스트 + 타입 체크**

Run: `npm test && npx tsc --noEmit --pretty false`
Expected: 전체 PASS, 타입 에러 없음.

- [ ] **Step 6: 커밋**

```bash
git add src/lib/oee/types.ts src/lib/oee/oee-validation.ts src/lib/oee/oee-validation.test.ts
git commit -m "feat(oee): add operation log interval validation"
```

---

## Self-Review (작성자 점검 결과)

**Spec coverage (플랜 1 범위):**
- 스펙 §3 테이블 5종 → Task 1 ✅
- 스펙 §4.1 계산식 → Task 2 ✅
- 스펙 §5.3 검증 규칙(겹침/합/DOWN사유/역전) → Task 3 ✅
- 스펙 §7.3 계산·검증 단일 출처(`src/lib/oee/`) → Task 2/3 ✅
- 스펙 §9 유닛테스트 + 트랜잭션 헬퍼 → Task 0/2/3 ✅
- **플랜 1 비범위(후속)**: §4.2 V_OEE_LIVE·집계 프로시저, §5 입력화면·write API, §6 대시보드, §4.1 계획가동시간 파생 뷰(외부 캘린더 컬럼 검증 후).

**Placeholder scan:** DDL/코드/테스트 모두 실제 내용 포함, "TBD"류 없음. `ORGANIZATION_ID=1`은 시드의 치환 대상임을 주석으로 명시.

**Type consistency:** `LogInterval`(types.ts)를 Task 3 테스트·구현이 동일 시그니처로 사용. calc 함수 시그니처는 Interfaces 블록과 구현 일치.

---

## 후속 플랜 (별도 문서로 작성 예정)

각 플랜은 자체로 동작·검증 가능한 단위다. 플랜 1 검증 완료 후 착수한다.

**플랜 2 — OEE 입력 (`docs/plans/2026-07-06-oee-input.md`)**
- 쿼리 빌더 `src/lib/queries/oee/{resource,reason,operation-log}.ts`
- 마스터 API + 화면 (`/oee/master/resource`, `/oee/master/reason`)
- 가동일지 write API (근무조 replace = DELETE+INSERT를 `executeTransaction`으로 원자화)
- 입력화면 `/oee/entry` (단말 프로파일 localStorage, 작업자 사번, 타임라인, `validateIntervals` 프론트 재사용)

**플랜 3 — 집계·대시보드 (`docs/plans/2026-07-06-oee-dashboard.md`)**
- 선행 검증: `IP_PRODUCT_COMPANY_CALENDAR`/`ICOM_WORKTIME_RANGES` 공정별 컬럼·RANGE_TYPE 확인 (스펙 §11)
- 계획가동시간 파생 뷰 `V_OEE_PLAN_TIME` + `OEE_PLAN_TIME` override
- `V_OEE_LIVE`(실시간) + `P_OEE_BUILD_SUMMARY`(마감 스냅샷, 폴백 없음)
- 대시보드 screenId 44(종합)/45(드릴다운)/46(로스 파레토) + `screens.ts`/`cards.json`/`sql-registry.ts` 등록
- 정합성 검증: 동일 입력에 대해 `V_OEE_LIVE` == 마감 후 `OEE_DAILY_SUMMARY`
