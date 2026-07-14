# 생산월력관리 IP_ 모델 재구축 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 생산월력관리(`MST_WORK_CALENDAR`, `/master/work-calendar`)를 실DB에 존재하지 않는 HANES 모델(`WORK_CALENDARS`)에서 은성 Oracle에 실재하는 IP_ 월력 모델로 재구축해, 화면이 실제로 동작하게 만든다.

**Architecture:** `IP_PRODUCT_COMPANY_CALENDAR`(전사) + `IP_PRODUCT_LINE_CALENDAR`(라인 예외) + `IP_SHIFT_TIME_MASTER`(2교대 시간)를 정본으로 삼는다. 세 테이블 모두 0건이므로 부족한 컬럼(`DAY_TYPE`·`WORK_MINUTES`·`OT_MINUTES`·`CONFIRM_YN` 등)을 ALTER로 보강한다. `HOLIDAY_YN`은 기존 PL/SQL `F_GET_DELIVERY_DATE`가 읽으므로 삭제하지 않고 `DAY_TYPE`의 미러로 유지하며 CHECK 제약으로 정합을 강제한다. 근무분 계산 규칙은 `packages/shared`에 한 번 정의해 프론트·백엔드가 함께 호출한다.

**Tech Stack:** Oracle(oracle-db connector), NestJS 11 + TypeORM, Next.js 16 App Router + React 19, `@smt/shared`(vitest), jest(backend), node:test(frontend 구조테스트).

**설계 근거:** `docs/specs/2026-07-14-work-calendar-ip-model-design.md`

## Global Constraints

- 패키지 매니저는 `pnpm`만 사용한다. `npm`/`yarn` 금지.
- dev/백엔드 서버는 사용자가 직접 기동한다. 에이전트가 임의로 서버를 띄우지 않는다.
- tenant는 `@OrganizationId()` 데코레이터(은성 규약). `@Company()`/`@Plant()`를 쓰지 않는다.
- 응답은 `ResponseUtil.success(...)` / `ResponseUtil.paged(...)`.
- 프론트 API 호출은 `import api from "@/services/api"` (axios 인스턴스). 에러는 `catch { /* interceptor */ }`로 전역 인터셉터에 위임한다.
- 코드성 값(근무유형·휴무사유)은 자유입력 금지 — `ComCodeSelect` / `ComCodeBadge` + 공통코드 그룹(`WORK_DAY_TYPE`, `DAY_OFF_TYPE`).
- `alert()`/`confirm()`/`prompt()` 금지 — `ConfirmModal`/토스트 사용.
- `catch (error: unknown)` 유지, `as any` 금지.
- DAY_TYPE 값 집합은 정확히 `'WORK' | 'OFF' | 'HALF' | 'SPECIAL'`.
- 근무분 기본값: `OFF`→0, `WORK`→주간순+야간순, `HALF`→주간순÷2, `SPECIAL`→주간순.
- 양력 고정공휴일만 자동 반영: 1/1, 3/1, 5/5, 6/6, 8/15, 10/3, 10/9, 12/25.
- `packages/shared`는 tracked `dist`를 소비한다. src 변경 후 반드시 `pnpm --filter @smt/shared build`.
- 소스는 UTF-8(BOM 없음). PowerShell `Set-Content`로 한글 파일 쓰지 않는다.

## File Structure

**신규 생성**

| 경로 | 책임 |
|---|---|
| `apps/backend/src/migrations/2026-07-14_ip_work_calendar_columns.sql` | IP_ 3개 테이블 ALTER (멱등) |
| `packages/shared/src/work-calendar/types.ts` | `WorkDayType`, `ShiftTimeSpan`, `ShiftTimeMasterLike` |
| `packages/shared/src/work-calendar/work-calendar-rules.ts` | 근무분 계산·휴일 판정·HOLIDAY_YN 파생 |
| `packages/shared/src/work-calendar/work-calendar-rules.test.ts` | 위 규칙 vitest |
| `packages/shared/src/work-calendar/index.ts` | 배럴 |
| `apps/backend/src/entities/product-company-calendar.entity.ts` | `IP_PRODUCT_COMPANY_CALENDAR` |
| `apps/backend/src/entities/product-line-calendar.entity.ts` | `IP_PRODUCT_LINE_CALENDAR` |
| `apps/backend/src/entities/shift-time-master.entity.ts` | `IP_SHIFT_TIME_MASTER` |
| `apps/backend/src/modules/master/controllers/shift-time.controller.ts` | `master/shift-times` |
| `apps/backend/src/modules/master/services/shift-time.service.ts` | 교대시간 CRUD + 유효기간 해석 |
| `apps/backend/src/modules/master/services/shift-time.service.spec.ts` | jest |
| `apps/frontend/src/app/(authenticated)/master/work-calendar/types.ts` | 화면 타입 |
| `apps/frontend/src/app/(authenticated)/master/work-calendar/components/ShiftTimeTab.tsx` | 교대시간 탭 |
| `apps/frontend/src/app/(authenticated)/master/work-calendar/work-calendar.eunsung.structure.test.mjs` | 구조테스트 |

**재작성**

| 경로 | 변경 |
|---|---|
| `apps/backend/src/modules/master/dto/work-calendar.dto.ts` | IP_ 모델 DTO로 전면 교체 |
| `apps/backend/src/modules/master/services/work-calendar.service.ts` | 전면 교체 |
| `apps/backend/src/modules/master/services/work-calendar.service.spec.ts` | 전면 교체 |
| `apps/backend/src/modules/master/controllers/work-calendar.controller.ts` | 전면 교체 |
| `apps/backend/src/modules/master/master-work-calendar.module.ts` | 엔티티/컨트롤러/프로바이더 교체 |
| `apps/frontend/.../work-calendar/page.tsx` | 전면 교체 |
| `apps/frontend/.../work-calendar/components/CalendarGrid.tsx` | 타입/요약 조정 |
| `apps/frontend/.../work-calendar/components/DayEditModal.tsx` | 전면 교체 |
| `apps/frontend/.../work-calendar/components/WorkCalendarFieldHelp.tsx` | DB 컬럼 매핑 교체 |
| `apps/frontend/src/locales/{ko,en,vi,zh}.json` | `master.workCalendar` 키 교체 |

**삭제**

- `apps/backend/src/entities/work-calendar.entity.ts`, `work-calendar-day.entity.ts`, `shift-pattern.entity.ts` (+ `entities/index.ts` re-export, `database.module.ts` 배열)
- `apps/backend/src/modules/master/controllers/shift-pattern.controller.ts`, `services/shift-pattern.service.ts` (모듈 미배선 고아)
- `apps/frontend/.../work-calendar/components/CalendarFormPanel.tsx`, `AddCalendarModal.tsx`, `ShiftPatternTab.tsx`

---

## Task 0: 선행 확인 (DB 접속 · 라인 마스터)

설계 시점에 ESDBext 접속이 타임아웃돼 확인하지 못한 항목이다. **이 태스크가 통과해야 Task 1로 간다.**

> **실행 결과 (2026-07-14, 통과):**
> - **DB 사이트는 `ESDBext`(61.105.35.54)를 쓴다** (사용자 지시). 내부 사이트 `ESDB`(192.168.175.100)는 같은 스키마지만, 사내망이 끊기면 두 사이트 모두 `ORA-12170`으로 실패한다. 접속이 끊기면 **대체 호스트로 우회하지 말고 실패를 그대로 보고한다.**
> - **PL/SQL 마이그레이션 파일은 선행 주석 없이 `DECLARE`/`BEGIN`으로 시작해야 한다.** `oracle_connector.py`의 `execute_file`은 파일이 `DECLARE`/`BEGIN`으로 시작할 때만 끝의 `;`를 보존하고, 아니면 `END;`의 세미콜론을 잘라내 `PLS-00103`이 난다. 주석은 `DECLARE` 다음 줄에 넣는다.
> - IP_ 월력 3개 테이블 모두 0건 확인 → ALTER 안전.
> - `WORK_CALENDARS`는 실DB에 존재하지 않음 확인(HANES 모델이 실재하지 않는다는 전제 재확인).
> - `IP_PRODUCT_LINE`에 라인 **56건** → 라인 예외 월력 구현·검증 가능.
> - `ISYS_BASECODE` 실구조 확인 → Task 6 시드 SQL을 실제 컬럼(`CODE_TYPE`/`CODE_NAME`/`CODE_MEAN_KOR`/`CODE_GROUP`)에 맞게 수정 완료.

**Files:** 없음 (조사 전용)

- [ ] **Step 1: DB 접속 확인**

```bash
python "C:/Users/hsyou/.claude/skills/oracle-db/scripts/oracle_connector.py" --site ESDBext --query "SELECT 1 AS OK FROM DUAL"
```

Expected: `{"success": true, ... "row_count": 1}`. 타임아웃(ORA-12170)이면 중단하고 사용자에게 보고한다.

- [ ] **Step 2: IP_ 월력 3개 테이블이 여전히 0건인지 확인 (ALTER 안전성 전제)**

```bash
python "C:/Users/hsyou/.claude/skills/oracle-db/scripts/oracle_connector.py" --site ESDBext --query "SELECT 'COMPANY' T, COUNT(*) C FROM IP_PRODUCT_COMPANY_CALENDAR UNION ALL SELECT 'LINE', COUNT(*) FROM IP_PRODUCT_LINE_CALENDAR UNION ALL SELECT 'SHIFT', COUNT(*) FROM IP_SHIFT_TIME_MASTER"
```

Expected: 세 행 모두 `C = 0`. 0이 아니면 중단하고 보고한다(데이터가 생겼다면 ALTER 전략 재검토 필요).

- [ ] **Step 3: 라인 마스터 실데이터 확인**

```bash
python "C:/Users/hsyou/.claude/skills/oracle-db/scripts/oracle_connector.py" --site ESDBext --query "SELECT LINE_CODE, LINE_NAME, LINE_DIVISION, ACTIVE_YN FROM IP_PRODUCT_LINE ORDER BY LINE_CODE"
```

Expected: 라인 목록 반환. **0건이면 라인별 예외 월력을 테스트할 수 없으므로 사용자에게 알리고 전사 월력만 먼저 구현할지 확인한다.**

- [ ] **Step 4: `F_GET_DELIVERY_DATE`가 실제로 `HOLIDAY_YN`을 읽는지 원문 확인**

```bash
python "C:/Users/hsyou/.claude/skills/oracle-db/scripts/oracle_connector.py" --site ESDBext --procedure-source F_GET_DELIVERY_DATE
```

Expected: 소스에 `IP_PRODUCT_COMPANY_CALENDAR`와 `HOLIDAY_YN`이 등장. 이 사실이 `HOLIDAY_YN` 보존 결정의 근거다. 함수를 **실행하지는 않는다**(oracle-db 스킬 규칙).

- [ ] **Step 5: 확인 결과를 기록**

`docs/sql/` 규정에 따라 `F_GET_DELIVERY_DATE` 원문을 `docs/sql/F_GET_DELIVERY_DATE.sql`로 저장한다(화면 개발 근거가 된 PL/SQL 스냅샷).

---

## Task 1: DB 마이그레이션 — IP_ 테이블 컬럼 보강

**Files:**
- Create: `apps/backend/src/migrations/2026-07-14_ip_work_calendar_columns.sql`

**Interfaces:**
- Produces: 아래 컬럼들. 이후 모든 태스크가 이 스키마를 전제한다.
  - `IP_PRODUCT_COMPANY_CALENDAR` / `IP_PRODUCT_LINE_CALENDAR`: `DAY_TYPE VARCHAR2(20) NOT NULL DEFAULT 'WORK'`, `OFF_REASON VARCHAR2(20)`, `WORK_MINUTES NUMBER(5) NOT NULL DEFAULT 0`, `OT_MINUTES NUMBER(5) NOT NULL DEFAULT 0`, `CONFIRM_YN VARCHAR2(1) NOT NULL DEFAULT 'N'`
  - `IP_SHIFT_TIME_MASTER`: PK `(ORGANIZATION_ID, DATESET)`, `DAY_BREAK_MINUTES NUMBER(4) NOT NULL DEFAULT 0`, `NIGHT_BREAK_MINUTES NUMBER(4) NOT NULL DEFAULT 0`

- [ ] **Step 1: 마이그레이션 SQL 작성**

`apps/backend/src/migrations/2026-07-14_ip_work_calendar_columns.sql`:

```sql
-- 생산월력 IP_ 모델 보강 (멱등)
-- 설계: docs/specs/2026-07-14-work-calendar-ip-model-design.md
-- 대상: IP_PRODUCT_COMPANY_CALENDAR, IP_PRODUCT_LINE_CALENDAR, IP_SHIFT_TIME_MASTER
-- HOLIDAY_YN은 F_GET_DELIVERY_DATE가 읽으므로 삭제하지 않고 DAY_TYPE의 미러로 유지한다.

DECLARE
  PROCEDURE add_column(p_table VARCHAR2, p_column VARCHAR2, p_ddl VARCHAR2) IS
    l_cnt NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_cnt FROM USER_TAB_COLUMNS
     WHERE TABLE_NAME = UPPER(p_table) AND COLUMN_NAME = UPPER(p_column);
    IF l_cnt = 0 THEN
      EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table || ' ADD (' || p_ddl || ')';
    END IF;
  END;

  PROCEDURE add_constraint(p_table VARCHAR2, p_name VARCHAR2, p_ddl VARCHAR2) IS
    l_cnt NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_cnt FROM USER_CONSTRAINTS
     WHERE TABLE_NAME = UPPER(p_table) AND CONSTRAINT_NAME = UPPER(p_name);
    IF l_cnt = 0 THEN
      EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table || ' ADD CONSTRAINT ' || p_name || ' ' || p_ddl;
    END IF;
  END;

  PROCEDURE force_not_null(p_table VARCHAR2, p_column VARCHAR2) IS
    l_nullable VARCHAR2(1);
  BEGIN
    SELECT NULLABLE INTO l_nullable FROM USER_TAB_COLUMNS
     WHERE TABLE_NAME = UPPER(p_table) AND COLUMN_NAME = UPPER(p_column);
    IF l_nullable = 'Y' THEN
      EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table || ' MODIFY (' || p_column || ' NOT NULL)';
    END IF;
  END;
BEGIN
  -- ① 전사 월력
  add_column('IP_PRODUCT_COMPANY_CALENDAR', 'DAY_TYPE',     'DAY_TYPE VARCHAR2(20) DEFAULT ''WORK'' NOT NULL');
  add_column('IP_PRODUCT_COMPANY_CALENDAR', 'OFF_REASON',   'OFF_REASON VARCHAR2(20)');
  add_column('IP_PRODUCT_COMPANY_CALENDAR', 'WORK_MINUTES', 'WORK_MINUTES NUMBER(5) DEFAULT 0 NOT NULL');
  add_column('IP_PRODUCT_COMPANY_CALENDAR', 'OT_MINUTES',   'OT_MINUTES NUMBER(5) DEFAULT 0 NOT NULL');
  add_column('IP_PRODUCT_COMPANY_CALENDAR', 'CONFIRM_YN',   'CONFIRM_YN VARCHAR2(1) DEFAULT ''N'' NOT NULL');
  add_constraint('IP_PRODUCT_COMPANY_CALENDAR', 'CK_IPCC_DAY_TYPE',
    'CHECK (DAY_TYPE IN (''WORK'',''OFF'',''HALF'',''SPECIAL''))');
  add_constraint('IP_PRODUCT_COMPANY_CALENDAR', 'CK_IPCC_HOLIDAY_SYNC',
    'CHECK ((DAY_TYPE = ''OFF'' AND HOLIDAY_YN = ''Y'') OR (DAY_TYPE <> ''OFF'' AND HOLIDAY_YN = ''N''))');
  add_constraint('IP_PRODUCT_COMPANY_CALENDAR', 'CK_IPCC_CONFIRM_YN',
    'CHECK (CONFIRM_YN IN (''Y'',''N''))');

  -- ② 라인 예외 월력
  add_column('IP_PRODUCT_LINE_CALENDAR', 'DAY_TYPE',     'DAY_TYPE VARCHAR2(20) DEFAULT ''WORK'' NOT NULL');
  add_column('IP_PRODUCT_LINE_CALENDAR', 'OFF_REASON',   'OFF_REASON VARCHAR2(20)');
  add_column('IP_PRODUCT_LINE_CALENDAR', 'WORK_MINUTES', 'WORK_MINUTES NUMBER(5) DEFAULT 0 NOT NULL');
  add_column('IP_PRODUCT_LINE_CALENDAR', 'OT_MINUTES',   'OT_MINUTES NUMBER(5) DEFAULT 0 NOT NULL');
  add_column('IP_PRODUCT_LINE_CALENDAR', 'CONFIRM_YN',   'CONFIRM_YN VARCHAR2(1) DEFAULT ''N'' NOT NULL');
  add_constraint('IP_PRODUCT_LINE_CALENDAR', 'CK_IPLC_DAY_TYPE',
    'CHECK (DAY_TYPE IN (''WORK'',''OFF'',''HALF'',''SPECIAL''))');
  add_constraint('IP_PRODUCT_LINE_CALENDAR', 'CK_IPLC_HOLIDAY_SYNC',
    'CHECK ((DAY_TYPE = ''OFF'' AND HOLIDAY_YN = ''Y'') OR (DAY_TYPE <> ''OFF'' AND HOLIDAY_YN = ''N''))');
  add_constraint('IP_PRODUCT_LINE_CALENDAR', 'CK_IPLC_CONFIRM_YN',
    'CHECK (CONFIRM_YN IN (''Y'',''N''))');

  -- ③ 교대시간 마스터 — PK가 없어 먼저 정상화
  force_not_null('IP_SHIFT_TIME_MASTER', 'ORGANIZATION_ID');
  force_not_null('IP_SHIFT_TIME_MASTER', 'DATESET');
  add_column('IP_SHIFT_TIME_MASTER', 'DAY_BREAK_MINUTES',   'DAY_BREAK_MINUTES NUMBER(4) DEFAULT 0 NOT NULL');
  add_column('IP_SHIFT_TIME_MASTER', 'NIGHT_BREAK_MINUTES', 'NIGHT_BREAK_MINUTES NUMBER(4) DEFAULT 0 NOT NULL');
  add_constraint('IP_SHIFT_TIME_MASTER', 'PK_IP_SHIFT_TIME_MASTER',
    'PRIMARY KEY (ORGANIZATION_ID, DATESET)');
END;
/
```

- [ ] **Step 2: 적용 전 상태 기록**

```bash
python "C:/Users/hsyou/.claude/skills/oracle-db/scripts/oracle_connector.py" --site ESDBext --query "SELECT table_name, column_name FROM user_tab_columns WHERE table_name IN ('IP_PRODUCT_COMPANY_CALENDAR','IP_PRODUCT_LINE_CALENDAR','IP_SHIFT_TIME_MASTER') AND column_name IN ('DAY_TYPE','OFF_REASON','WORK_MINUTES','OT_MINUTES','CONFIRM_YN','DAY_BREAK_MINUTES','NIGHT_BREAK_MINUTES')"
```

Expected: 0건 (아직 없음).

- [ ] **Step 3: 마이그레이션 실행**

```bash
python "C:/Users/hsyou/.claude/skills/oracle-db/scripts/oracle_connector.py" --site ESDBext --execute-file "apps/backend/src/migrations/2026-07-14_ip_work_calendar_columns.sql"
```

Expected: `"success": true`, `blocks_executed: 1`.

- [ ] **Step 4: 적용 후 검증 — 컬럼 7개 + 제약 7개**

```bash
python "C:/Users/hsyou/.claude/skills/oracle-db/scripts/oracle_connector.py" --site ESDBext --query "SELECT table_name, column_name, nullable, data_default FROM user_tab_columns WHERE table_name IN ('IP_PRODUCT_COMPANY_CALENDAR','IP_PRODUCT_LINE_CALENDAR','IP_SHIFT_TIME_MASTER') AND column_name IN ('DAY_TYPE','OFF_REASON','WORK_MINUTES','OT_MINUTES','CONFIRM_YN','DAY_BREAK_MINUTES','NIGHT_BREAK_MINUTES') ORDER BY table_name, column_name"
```

Expected: 12건 (COMPANY 5 + LINE 5 + SHIFT 2).

```bash
python "C:/Users/hsyou/.claude/skills/oracle-db/scripts/oracle_connector.py" --site ESDBext --query "SELECT table_name, constraint_name, constraint_type FROM user_constraints WHERE constraint_name IN ('CK_IPCC_DAY_TYPE','CK_IPCC_HOLIDAY_SYNC','CK_IPCC_CONFIRM_YN','CK_IPLC_DAY_TYPE','CK_IPLC_HOLIDAY_SYNC','CK_IPLC_CONFIRM_YN','PK_IP_SHIFT_TIME_MASTER') ORDER BY table_name, constraint_name"
```

Expected: 7건. `PK_IP_SHIFT_TIME_MASTER`의 `constraint_type = 'P'`.

- [ ] **Step 5: 멱등성 확인 — 같은 파일 재실행**

Step 3 명령을 다시 실행한다. Expected: `"success": true` (에러 없음, 아무것도 바뀌지 않음).

- [ ] **Step 6: 커밋**

```bash
git add apps/backend/src/migrations/2026-07-14_ip_work_calendar_columns.sql docs/sql/F_GET_DELIVERY_DATE.sql
git commit -m "feat(work-calendar): IP_ 월력 테이블에 DAY_TYPE/근무분/확정 컬럼 보강"
```

---

## Task 2: `@smt/shared` — 근무분 계산 규칙 (TDD)

프론트(미리보기)와 백엔드(저장값 계산)가 같은 함수를 호출한다. 같은 조건을 두 계층에 복붙하지 않는다.

**Files:**
- Create: `packages/shared/src/work-calendar/types.ts`
- Create: `packages/shared/src/work-calendar/work-calendar-rules.ts`
- Create: `packages/shared/src/work-calendar/work-calendar-rules.test.ts`
- Create: `packages/shared/src/work-calendar/index.ts`
- Modify: `packages/shared/src/index.ts`
- Modify: `packages/shared/package.json` (exports에 `./work-calendar` 추가)

**Interfaces:**
- Produces:
  - `type WorkDayType = 'WORK' | 'OFF' | 'HALF' | 'SPECIAL'`
  - `interface ShiftTimeSpan { start: string; end: string; breakMinutes: number }`
  - `interface ShiftTimeMasterLike { dayTimeStart: string | null; dayTimeEnd: string | null; dayBreakMinutes: number; nightTimeStart: string | null; nightTimeEnd: string | null; nightBreakMinutes: number }`
  - `shiftNetMinutes(span: ShiftTimeSpan): number`
  - `defaultWorkMinutes(dayType: WorkDayType, shift: ShiftTimeMasterLike | null): number`
  - `holidayYnOf(dayType: WorkDayType): 'Y' | 'N'`
  - `isFixedHoliday(isoDate: string): boolean`
  - `FIXED_HOLIDAYS: readonly [number, number][]`

- [ ] **Step 1: 실패하는 테스트 작성**

`packages/shared/src/work-calendar/work-calendar-rules.test.ts`:

```ts
import { describe, it, expect } from 'vitest';
import {
  shiftNetMinutes,
  defaultWorkMinutes,
  holidayYnOf,
  isFixedHoliday,
} from './work-calendar-rules';
import type { ShiftTimeMasterLike } from './types';

const SHIFT: ShiftTimeMasterLike = {
  dayTimeStart: '08:00',
  dayTimeEnd: '20:00',
  dayBreakMinutes: 60,
  nightTimeStart: '20:00',
  nightTimeEnd: '08:00',
  nightBreakMinutes: 60,
};

describe('shiftNetMinutes = 교대 구간 - 휴식', () => {
  it('08:00~20:00, 휴식 60분이면 660분', () =>
    expect(shiftNetMinutes({ start: '08:00', end: '20:00', breakMinutes: 60 })).toBe(660));

  it('자정을 넘기는 야간 20:00~08:00, 휴식 60분이면 660분', () =>
    expect(shiftNetMinutes({ start: '20:00', end: '08:00', breakMinutes: 60 })).toBe(660));

  it('HH:MM:SS 형식도 받는다', () =>
    expect(shiftNetMinutes({ start: '08:00:00', end: '17:00:00', breakMinutes: 60 })).toBe(480));

  it('휴식이 구간보다 크면 0으로 잘린다', () =>
    expect(shiftNetMinutes({ start: '08:00', end: '09:00', breakMinutes: 120 })).toBe(0));

  it('시작=종료면 0 (24시간이 아니라 0으로 본다)', () =>
    expect(shiftNetMinutes({ start: '08:00', end: '08:00', breakMinutes: 0 })).toBe(0));
});

describe('defaultWorkMinutes', () => {
  it('OFF는 0', () => expect(defaultWorkMinutes('OFF', SHIFT)).toBe(0));
  it('WORK는 주간순 + 야간순 = 1320', () => expect(defaultWorkMinutes('WORK', SHIFT)).toBe(1320));
  it('HALF는 주간순의 절반 = 330', () => expect(defaultWorkMinutes('HALF', SHIFT)).toBe(330));
  it('SPECIAL은 주간순 = 660', () => expect(defaultWorkMinutes('SPECIAL', SHIFT)).toBe(660));
  it('교대시간 마스터가 없으면 0', () => expect(defaultWorkMinutes('WORK', null)).toBe(0));

  it('야간 미운영(시간 미설정)이면 WORK는 주간순만', () =>
    expect(
      defaultWorkMinutes('WORK', { ...SHIFT, nightTimeStart: null, nightTimeEnd: null }),
    ).toBe(660));

  it('HALF는 홀수분이면 내림한다', () =>
    expect(
      defaultWorkMinutes('HALF', { ...SHIFT, dayTimeEnd: '17:01', dayBreakMinutes: 0 }),
    ).toBe(270)); // 08:00~17:01 = 541분 → 절반 270.5 → 270
});

describe('holidayYnOf — HOLIDAY_YN은 DAY_TYPE의 미러', () => {
  it('OFF만 Y', () => expect(holidayYnOf('OFF')).toBe('Y'));
  it('WORK는 N', () => expect(holidayYnOf('WORK')).toBe('N'));
  it('HALF는 N', () => expect(holidayYnOf('HALF')).toBe('N'));
  it('SPECIAL은 N (휴일 특근이지만 근무일이다)', () => expect(holidayYnOf('SPECIAL')).toBe('N'));
});

describe('isFixedHoliday — 양력 고정공휴일만', () => {
  it('1월 1일', () => expect(isFixedHoliday('2026-01-01')).toBe(true));
  it('3월 1일', () => expect(isFixedHoliday('2026-03-01')).toBe(true));
  it('12월 25일', () => expect(isFixedHoliday('2026-12-25')).toBe(true));
  it('평일은 false', () => expect(isFixedHoliday('2026-07-14')).toBe(false));
  it('설날(음력)은 자동 반영하지 않는다', () => expect(isFixedHoliday('2026-02-17')).toBe(false));
});
```

- [ ] **Step 2: 테스트 실패 확인**

```bash
pnpm --filter @smt/shared test
```

Expected: FAIL — `Failed to resolve import "./work-calendar-rules"`.

- [ ] **Step 3: 타입 작성**

`packages/shared/src/work-calendar/types.ts`:

```ts
/**
 * @file packages/shared/src/work-calendar/types.ts
 * @description 생산월력 공유 타입 (IP_ 월력 모델)
 */

/** 근무유형 — 공통코드 WORK_DAY_TYPE */
export type WorkDayType = 'WORK' | 'OFF' | 'HALF' | 'SPECIAL';

/** 단일 교대 구간 */
export interface ShiftTimeSpan {
  /** 'HH:MM' 또는 'HH:MM:SS' */
  start: string;
  /** 'HH:MM' 또는 'HH:MM:SS'. start보다 이르면 자정을 넘긴 것으로 본다. */
  end: string;
  breakMinutes: number;
}

/** IP_SHIFT_TIME_MASTER 한 행이 제공하는 2교대 시간 */
export interface ShiftTimeMasterLike {
  dayTimeStart: string | null;
  dayTimeEnd: string | null;
  dayBreakMinutes: number;
  nightTimeStart: string | null;
  nightTimeEnd: string | null;
  nightBreakMinutes: number;
}
```

- [ ] **Step 4: 규칙 구현**

`packages/shared/src/work-calendar/work-calendar-rules.ts`:

```ts
/**
 * @file packages/shared/src/work-calendar/work-calendar-rules.ts
 * @description 생산월력 도메인 규칙 — 프론트(미리보기)와 백엔드(저장값)가 함께 호출한다.
 *
 * 초보자 가이드:
 * 1. HOLIDAY_YN은 DAY_TYPE의 미러다. 기존 PL/SQL F_GET_DELIVERY_DATE가 HOLIDAY_YN을 읽으므로
 *    DB CHECK 제약으로 정합이 강제되며, 애플리케이션은 holidayYnOf()로만 파생시킨다.
 * 2. 야간 교대는 자정을 넘긴다(20:00~08:00). end < start면 +24h로 계산한다.
 * 3. 공휴일 자동 반영은 양력 고정공휴일만이다. 설·추석·대체공휴일은 담당자가 수정한다.
 */
import type { ShiftTimeMasterLike, ShiftTimeSpan, WorkDayType } from './types';

/** 양력 고정공휴일 [월, 일] */
export const FIXED_HOLIDAYS: readonly [number, number][] = [
  [1, 1],
  [3, 1],
  [5, 5],
  [6, 6],
  [8, 15],
  [10, 3],
  [10, 9],
  [12, 25],
];

const MINUTES_PER_DAY = 24 * 60;

/** 'HH:MM' / 'HH:MM:SS' → 자정 기준 분. 형식이 깨지면 null. */
function toMinutes(hhmm: string | null): number | null {
  if (!hhmm) return null;
  const m = /^(\d{1,2}):(\d{2})(?::\d{2})?$/.exec(hhmm.trim());
  if (!m) return null;
  const hours = Number(m[1]);
  const minutes = Number(m[2]);
  if (hours > 23 || minutes > 59) return null;
  return hours * 60 + minutes;
}

/** 교대 구간의 순근무분 = (종료 - 시작) - 휴식. 자정 넘김 처리. 음수는 0. */
export function shiftNetMinutes(span: ShiftTimeSpan): number {
  const start = toMinutes(span.start);
  const end = toMinutes(span.end);
  if (start === null || end === null) return 0;
  const raw = end > start ? end - start : end < start ? end + MINUTES_PER_DAY - start : 0;
  return Math.max(0, raw - span.breakMinutes);
}

function dayNetMinutes(shift: ShiftTimeMasterLike | null): number {
  if (!shift?.dayTimeStart || !shift.dayTimeEnd) return 0;
  return shiftNetMinutes({
    start: shift.dayTimeStart,
    end: shift.dayTimeEnd,
    breakMinutes: shift.dayBreakMinutes,
  });
}

function nightNetMinutes(shift: ShiftTimeMasterLike | null): number {
  if (!shift?.nightTimeStart || !shift.nightTimeEnd) return 0;
  return shiftNetMinutes({
    start: shift.nightTimeStart,
    end: shift.nightTimeEnd,
    breakMinutes: shift.nightBreakMinutes,
  });
}

/**
 * 근무유형별 기본 근무분.
 * OFF=0 / WORK=주간+야간 / HALF=주간÷2(내림) / SPECIAL=주간(휴일 특근은 주간 1교대)
 * 사용자가 일자편집에서 override할 수 있으며, 저장되는 값은 최종값이다.
 */
export function defaultWorkMinutes(
  dayType: WorkDayType,
  shift: ShiftTimeMasterLike | null,
): number {
  if (dayType === 'OFF') return 0;
  const day = dayNetMinutes(shift);
  if (dayType === 'HALF') return Math.floor(day / 2);
  if (dayType === 'SPECIAL') return day;
  return day + nightNetMinutes(shift);
}

/** HOLIDAY_YN은 DAY_TYPE에서 파생한다. 직접 입력받지 않는다. */
export function holidayYnOf(dayType: WorkDayType): 'Y' | 'N' {
  return dayType === 'OFF' ? 'Y' : 'N';
}

/** 'YYYY-MM-DD'가 양력 고정공휴일인지. 음력·대체공휴일은 포함하지 않는다. */
export function isFixedHoliday(isoDate: string): boolean {
  const m = /^\d{4}-(\d{2})-(\d{2})$/.exec(isoDate);
  if (!m) return false;
  const month = Number(m[1]);
  const day = Number(m[2]);
  return FIXED_HOLIDAYS.some(([hm, hd]) => hm === month && hd === day);
}
```

- [ ] **Step 5: 배럴 + 진입점 연결**

`packages/shared/src/work-calendar/index.ts`:

```ts
/**
 * @file packages/shared/src/work-calendar/index.ts
 * @description 생산월력 공유 도메인 진입점.
 */
export * from './types';
export * from './work-calendar-rules';
```

`packages/shared/src/index.ts` — `export * from './oee';` 아래에 추가:

```ts
// 생산월력 도메인(근무분 계산·휴일 판정) 내보내기
export * from './work-calendar';
```

`packages/shared/package.json` — `exports`의 `"./oee"` 블록 아래에 추가:

```json
    "./work-calendar": {
      "types": "./dist/work-calendar/index.d.ts",
      "default": "./dist/work-calendar/index.js"
    }
```

- [ ] **Step 6: 테스트 통과 확인**

```bash
pnpm --filter @smt/shared test
```

Expected: PASS — work-calendar-rules 22 tests.

- [ ] **Step 7: dist 재빌드 (필수)**

`@smt/shared`는 tracked `dist`를 소비한다. 빌드하지 않으면 백엔드·프론트가 새 함수를 못 본다.

```bash
pnpm --filter @smt/shared build
```

Expected: 종료코드 0, `packages/shared/dist/work-calendar/` 생성.

- [ ] **Step 8: 커밋**

```bash
git add packages/shared/src/work-calendar packages/shared/src/index.ts packages/shared/package.json packages/shared/dist
git commit -m "feat(shared): 생산월력 근무분 계산·휴일 판정 규칙 추가"
```

---

## Task 3: 백엔드 엔티티 — IP_ 매핑 3개 + 구 엔티티 제거

**Files:**
- Create: `apps/backend/src/entities/product-company-calendar.entity.ts`
- Create: `apps/backend/src/entities/product-line-calendar.entity.ts`
- Create: `apps/backend/src/entities/shift-time-master.entity.ts`
- Delete: `apps/backend/src/entities/work-calendar.entity.ts`, `work-calendar-day.entity.ts`, `shift-pattern.entity.ts`
- Modify: `apps/backend/src/entities/index.ts` (re-export 교체)
- Modify: `apps/backend/src/database/database.module.ts` (엔티티 배열 교체)

**Interfaces:**
- Consumes: Task 1의 컬럼.
- Produces: `ProductCompanyCalendar`, `ProductLineCalendar`, `ShiftTimeMaster` 클래스. Task 4·5가 `@InjectRepository`로 주입받는다.

- [ ] **Step 1: 전사 월력 엔티티**

`apps/backend/src/entities/product-company-calendar.entity.ts`:

```ts
/**
 * @file entities/product-company-calendar.entity.ts
 * @description 전사 생산월력 — 은성 레거시 테이블 IP_PRODUCT_COMPANY_CALENDAR에 매핑한다.
 *
 * 초보자 가이드:
 * 1. PK는 PLAN_DATE + ORGANIZATION_ID 복합키다.
 * 2. HOLIDAY_YN은 DAY_TYPE의 미러다. PL/SQL F_GET_DELIVERY_DATE가 읽으므로 삭제하지 않는다.
 *    저장 시 @smt/shared의 holidayYnOf(dayType)로 파생시킨다 (DB CHECK 제약이 정합을 강제).
 * 3. CONFIRM_YN='Y'인 일자는 모든 쓰기 경로에서 차단된다.
 */
import { Entity, PrimaryColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity({ name: 'IP_PRODUCT_COMPANY_CALENDAR' })
export class ProductCompanyCalendar {
  @PrimaryColumn({ name: 'PLAN_DATE', type: 'date' })
  planDate: Date;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  /** 휴일유무: DAY_TYPE의 미러 (OFF='Y', 그 외='N') */
  @Column({ type: 'varchar2', name: 'HOLIDAY_YN', length: 1 })
  holidayYn: string;

  /** 근무유형: WORK/OFF/HALF/SPECIAL — 공통코드 WORK_DAY_TYPE */
  @Column({ type: 'varchar2', name: 'DAY_TYPE', length: 20, default: 'WORK' })
  dayType: string;

  /** 휴무사유 — 공통코드 DAY_OFF_TYPE (DAY_TYPE='OFF'일 때만) */
  @Column({ type: 'varchar2', name: 'OFF_REASON', length: 20, nullable: true })
  offReason: string | null;

  @Column({ type: 'number', name: 'WORK_MINUTES', default: 0 })
  workMinutes: number;

  @Column({ type: 'number', name: 'OT_MINUTES', default: 0 })
  otMinutes: number;

  @Column({ type: 'varchar2', name: 'CONFIRM_YN', length: 1, default: 'N' })
  confirmYn: string;

  @Column({ type: 'varchar2', name: 'CALENDAR_COMMENT', length: 500, nullable: true })
  calendarComment: string | null;

  @Column({ type: 'varchar2', name: 'ENTER_BY', length: 20, nullable: true })
  enterBy: string | null;

  @Column({ type: 'varchar2', name: 'LAST_MODIFY_BY', length: 20, nullable: true })
  lastModifyBy: string | null;

  @CreateDateColumn({ name: 'ENTER_DATE', type: 'date' })
  enterDate: Date;

  @UpdateDateColumn({ name: 'LAST_MODIFY_DATE', type: 'date' })
  lastModifyDate: Date;
}
```

- [ ] **Step 2: 라인 예외 월력 엔티티**

`apps/backend/src/entities/product-line-calendar.entity.ts`: 위와 동일하되 `@Entity({ name: 'IP_PRODUCT_LINE_CALENDAR' })`, 그리고 세 번째 PK 컬럼을 추가한다.

```ts
  @PrimaryColumn({ name: 'LINE_CODE', length: 20 })
  lineCode: string;
```

나머지 컬럼(`holidayYn`·`dayType`·`offReason`·`workMinutes`·`otMinutes`·`confirmYn`·`calendarComment`·감사 4종)은 Step 1과 **완전히 동일한 선언**을 복사한다. 파일 주석의 `@description`은 "라인별 예외 생산월력 — IP_PRODUCT_LINE_CALENDAR에 매핑. 해당 (일자, 라인) 행이 있으면 전사 월력을 덮어쓴다."로 한다.

- [ ] **Step 3: 교대시간 마스터 엔티티**

`apps/backend/src/entities/shift-time-master.entity.ts`:

```ts
/**
 * @file entities/shift-time-master.entity.ts
 * @description 2교대 시간 마스터 — 은성 레거시 테이블 IP_SHIFT_TIME_MASTER에 매핑한다.
 *
 * 초보자 가이드:
 * 1. 유효기간형이다. DATESET ~ DATEEND 구간이 적용되며 DATEEND=null이면 무기한이다.
 * 2. 원본 테이블에는 PK가 없었다. 2026-07-14 마이그레이션이 (ORGANIZATION_ID, DATESET) PK를 부여했다.
 * 3. 야간 교대는 자정을 넘긴다(예: 20:00~08:00). 근무분 계산은 @smt/shared가 담당한다.
 */
import { Entity, PrimaryColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity({ name: 'IP_SHIFT_TIME_MASTER' })
export class ShiftTimeMaster {
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  /** 적용 시작일 */
  @PrimaryColumn({ name: 'DATESET', type: 'date' })
  dateset: Date;

  /** 적용 종료일 (null = 무기한) */
  @Column({ type: 'date', name: 'DATEEND', nullable: true })
  dateend: Date | null;

  @Column({ type: 'varchar2', name: 'DAY_TIME_START', length: 8, nullable: true })
  dayTimeStart: string | null;

  @Column({ type: 'varchar2', name: 'DAY_TIME_END', length: 8, nullable: true })
  dayTimeEnd: string | null;

  @Column({ type: 'number', name: 'DAY_BREAK_MINUTES', default: 0 })
  dayBreakMinutes: number;

  @Column({ type: 'varchar2', name: 'NIGHT_TIME_START', length: 8, nullable: true })
  nightTimeStart: string | null;

  @Column({ type: 'varchar2', name: 'NIGHT_TIME_END', length: 8, nullable: true })
  nightTimeEnd: string | null;

  @Column({ type: 'number', name: 'NIGHT_BREAK_MINUTES', default: 0 })
  nightBreakMinutes: number;

  @Column({ type: 'varchar2', name: 'ENTER_BY', length: 20, nullable: true })
  enterBy: string | null;

  @Column({ type: 'varchar2', name: 'LAST_MODIFY_BY', length: 20, nullable: true })
  lastModifyBy: string | null;

  @CreateDateColumn({ name: 'ENTER_DATE', type: 'date' })
  enterDate: Date;

  @UpdateDateColumn({ name: 'LAST_MODIFY_DATE', type: 'date' })
  lastModifyDate: Date;
}
```

- [ ] **Step 4: 구 엔티티 삭제 + 배럴/모듈 갱신**

```bash
rm apps/backend/src/entities/work-calendar.entity.ts \
   apps/backend/src/entities/work-calendar-day.entity.ts \
   apps/backend/src/entities/shift-pattern.entity.ts
```

`apps/backend/src/entities/index.ts`에서 세 파일의 `export *` 줄을 지우고, 새 엔티티 3개의 export를 추가한다:

```ts
export * from './product-company-calendar.entity';
export * from './product-line-calendar.entity';
export * from './shift-time-master.entity';
```

`apps/backend/src/database/database.module.ts`에서 `WorkCalendar`, `WorkCalendarDay`, `ShiftPattern` import와 엔티티 배열 항목을 지우고 `ProductCompanyCalendar`, `ProductLineCalendar`, `ShiftTimeMaster`로 교체한다.

- [ ] **Step 5: 타입체크**

```bash
pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false
```

Expected: 이 시점에는 **실패한다** — `work-calendar.service.ts` / `shift-pattern.service.ts`가 삭제된 엔티티를 import하기 때문이다. 에러가 그 파일들에만 국한되는지 확인한다(Task 4·5에서 해소). 다른 파일에서 에러가 나면 배럴/모듈 갱신이 빠진 것이다.

- [ ] **Step 6: 커밋**

```bash
git add apps/backend/src/entities apps/backend/src/database/database.module.ts
git commit -m "feat(work-calendar): IP_ 월력 엔티티 3종 추가, HANES 월력 엔티티 제거"
```

---

## Task 4: 백엔드 교대시간 서비스 (TDD)

월력 서비스가 근무분 계산에 이 서비스를 쓰므로 먼저 만든다.

**Files:**
- Create: `apps/backend/src/modules/master/services/shift-time.service.ts`
- Create: `apps/backend/src/modules/master/services/shift-time.service.spec.ts`
- Modify: `apps/backend/src/modules/master/dto/work-calendar.dto.ts` (교대시간 DTO 추가 — 파일 전체 교체는 Task 5)
- Delete: `apps/backend/src/modules/master/services/shift-pattern.service.ts`

**Interfaces:**
- Consumes: `ShiftTimeMaster` (Task 3), `defaultWorkMinutes` (Task 2)
- Produces:
  - `ShiftTimeService.findAll(organizationId): Promise<ShiftTimeMaster[]>` — `dateset DESC`
  - `ShiftTimeService.resolveForDate(isoDate: string, organizationId: number): Promise<ShiftTimeMaster | null>` — 해당 일자에 유효한 행
  - `ShiftTimeService.create(dto: CreateShiftTimeDto, organizationId: number): Promise<ShiftTimeMaster>`
  - `ShiftTimeService.update(dateset: string, dto: UpdateShiftTimeDto, organizationId: number): Promise<ShiftTimeMaster>`
  - `ShiftTimeService.remove(dateset: string, organizationId: number): Promise<void>`

- [ ] **Step 1: DTO 추가**

`apps/backend/src/modules/master/dto/work-calendar.dto.ts` 하단에 추가한다(기존 내용은 Task 5에서 교체하므로 지금은 append):

```ts
export class CreateShiftTimeDto {
  @ApiProperty({ description: '적용 시작일 (YYYY-MM-DD)', example: '2026-01-01' })
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/, { message: 'dateset은 YYYY-MM-DD 형식이어야 합니다.' })
  dateset: string;

  @ApiPropertyOptional({ description: '적용 종료일 (YYYY-MM-DD). 미지정이면 무기한' })
  @IsOptional()
  @Matches(/^\d{4}-\d{2}-\d{2}$/, { message: 'dateend는 YYYY-MM-DD 형식이어야 합니다.' })
  dateend?: string;

  @ApiPropertyOptional({ description: '주간 시작 (HH:MM)', example: '08:00' })
  @IsOptional()
  @Matches(/^\d{2}:\d{2}$/, { message: 'dayTimeStart는 HH:MM 형식이어야 합니다.' })
  dayTimeStart?: string;

  @ApiPropertyOptional({ description: '주간 종료 (HH:MM)', example: '20:00' })
  @IsOptional()
  @Matches(/^\d{2}:\d{2}$/, { message: 'dayTimeEnd는 HH:MM 형식이어야 합니다.' })
  dayTimeEnd?: string;

  @ApiPropertyOptional({ description: '주간 휴식(분)', default: 0 })
  @IsOptional()
  @IsInt()
  @Min(0)
  dayBreakMinutes?: number;

  @ApiPropertyOptional({ description: '야간 시작 (HH:MM)', example: '20:00' })
  @IsOptional()
  @Matches(/^\d{2}:\d{2}$/, { message: 'nightTimeStart는 HH:MM 형식이어야 합니다.' })
  nightTimeStart?: string;

  @ApiPropertyOptional({ description: '야간 종료 (HH:MM)', example: '08:00' })
  @IsOptional()
  @Matches(/^\d{2}:\d{2}$/, { message: 'nightTimeEnd는 HH:MM 형식이어야 합니다.' })
  nightTimeEnd?: string;

  @ApiPropertyOptional({ description: '야간 휴식(분)', default: 0 })
  @IsOptional()
  @IsInt()
  @Min(0)
  nightBreakMinutes?: number;
}

export class UpdateShiftTimeDto extends PartialType(OmitType(CreateShiftTimeDto, ['dateset'] as const)) {}
```

import 구문에 `Matches`, `IsInt`, `Min`, `IsOptional`, `IsString`(class-validator), `ApiProperty`, `ApiPropertyOptional`, `PartialType`, `OmitType`(`@nestjs/swagger`)이 포함돼야 한다.

- [ ] **Step 2: 실패하는 테스트 작성**

`apps/backend/src/modules/master/services/shift-time.service.spec.ts`:

```ts
import { Test } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { ConflictException, NotFoundException } from '@nestjs/common';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { Repository } from 'typeorm';
import { ShiftTimeMaster } from '../../../entities/shift-time-master.entity';
import { ShiftTimeService } from './shift-time.service';

describe('ShiftTimeService', () => {
  let target: ShiftTimeService;
  let repo: DeepMocked<Repository<ShiftTimeMaster>>;

  const row = (dateset: string, dateend: string | null): ShiftTimeMaster =>
    ({
      organizationId: 1,
      dateset: new Date(`${dateset}T00:00:00`),
      dateend: dateend ? new Date(`${dateend}T00:00:00`) : null,
      dayTimeStart: '08:00',
      dayTimeEnd: '20:00',
      dayBreakMinutes: 60,
      nightTimeStart: '20:00',
      nightTimeEnd: '08:00',
      nightBreakMinutes: 60,
    }) as ShiftTimeMaster;

  beforeEach(async () => {
    repo = createMock<Repository<ShiftTimeMaster>>();
    const moduleRef = await Test.createTestingModule({
      providers: [
        ShiftTimeService,
        { provide: getRepositoryToken(ShiftTimeMaster), useValue: repo },
      ],
    }).compile();
    target = moduleRef.get(ShiftTimeService);
  });

  describe('resolveForDate', () => {
    it('유효기간에 들어가는 행을 고른다', async () => {
      repo.find.mockResolvedValue([row('2026-01-01', '2026-06-30'), row('2026-07-01', null)]);
      const found = await target.resolveForDate('2026-07-14', 1);
      expect(found?.dateset).toEqual(new Date('2026-07-01T00:00:00'));
    });

    it('DATEEND가 null이면 무기한으로 본다', async () => {
      repo.find.mockResolvedValue([row('2026-07-01', null)]);
      expect(await target.resolveForDate('2030-01-01', 1)).not.toBeNull();
    });

    it('어떤 구간에도 안 들어가면 null', async () => {
      repo.find.mockResolvedValue([row('2026-01-01', '2026-06-30')]);
      expect(await target.resolveForDate('2026-07-14', 1)).toBeNull();
    });
  });

  describe('create', () => {
    it('유효기간이 겹치면 409', async () => {
      repo.find.mockResolvedValue([row('2026-01-01', null)]);
      await expect(
        target.create({ dateset: '2026-07-01', dayTimeStart: '08:00', dayTimeEnd: '20:00' }, 1),
      ).rejects.toBeInstanceOf(ConflictException);
    });

    it('겹치지 않으면 저장한다', async () => {
      repo.find.mockResolvedValue([row('2026-01-01', '2026-06-30')]);
      repo.create.mockImplementation((v) => v as ShiftTimeMaster);
      repo.save.mockImplementation(async (v) => v as ShiftTimeMaster);
      const saved = await target.create(
        { dateset: '2026-07-01', dayTimeStart: '08:00', dayTimeEnd: '20:00' },
        1,
      );
      expect(saved.organizationId).toBe(1);
      expect(repo.save).toHaveBeenCalledTimes(1);
    });
  });

  describe('remove', () => {
    it('없는 행이면 404', async () => {
      repo.findOne.mockResolvedValue(null);
      await expect(target.remove('2026-07-01', 1)).rejects.toBeInstanceOf(NotFoundException);
    });
  });
});
```

- [ ] **Step 3: 테스트 실패 확인**

```bash
pnpm --filter @eunsung/backend exec jest src/modules/master/services/shift-time.service.spec.ts
```

Expected: FAIL — `Cannot find module './shift-time.service'`.

- [ ] **Step 4: 서비스 구현**

`apps/backend/src/modules/master/services/shift-time.service.ts`:

```ts
/**
 * @file src/modules/master/services/shift-time.service.ts
 * @description 2교대 시간 마스터(IP_SHIFT_TIME_MASTER) 서비스
 *
 * 초보자 가이드:
 * 1. 유효기간형이다. DATESET ~ DATEEND(null=무기한) 구간이 겹치면 안 된다.
 *    Oracle 제약으로 표현할 수 없어 서비스에서 검증한다.
 * 2. resolveForDate()가 특정 일자에 적용될 교대시간을 돌려주며, 월력 서비스가 근무분 계산에 쓴다.
 */
import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ShiftTimeMaster } from '../../../entities/shift-time-master.entity';
import { CreateShiftTimeDto, UpdateShiftTimeDto } from '../dto/work-calendar.dto';

/** 'YYYY-MM-DD' → 로컬 자정 Date (Oracle DATE 비교용) */
function parseYmd(isoDate: string): Date {
  const [y, m, d] = isoDate.split('-').map(Number);
  return new Date(y, m - 1, d);
}

@Injectable()
export class ShiftTimeService {
  constructor(
    @InjectRepository(ShiftTimeMaster)
    private readonly repo: Repository<ShiftTimeMaster>,
  ) {}

  async findAll(organizationId: number): Promise<ShiftTimeMaster[]> {
    return this.repo.find({
      where: { organizationId },
      order: { dateset: 'DESC' },
    });
  }

  /** 해당 일자에 유효한 교대시간 1건. 없으면 null. */
  async resolveForDate(isoDate: string, organizationId: number): Promise<ShiftTimeMaster | null> {
    const target = parseYmd(isoDate).getTime();
    const rows = await this.repo.find({ where: { organizationId } });
    const hit = rows.find((r) => {
      const from = new Date(r.dateset).getTime();
      const to = r.dateend ? new Date(r.dateend).getTime() : Number.POSITIVE_INFINITY;
      return target >= from && target <= to;
    });
    return hit ?? null;
  }

  async create(dto: CreateShiftTimeDto, organizationId: number): Promise<ShiftTimeMaster> {
    await this.ensureNoOverlap(dto.dateset, dto.dateend ?? null, organizationId, null);
    const entity = this.repo.create({
      organizationId,
      dateset: parseYmd(dto.dateset),
      dateend: dto.dateend ? parseYmd(dto.dateend) : null,
      dayTimeStart: dto.dayTimeStart ?? null,
      dayTimeEnd: dto.dayTimeEnd ?? null,
      dayBreakMinutes: dto.dayBreakMinutes ?? 0,
      nightTimeStart: dto.nightTimeStart ?? null,
      nightTimeEnd: dto.nightTimeEnd ?? null,
      nightBreakMinutes: dto.nightBreakMinutes ?? 0,
    });
    return this.repo.save(entity);
  }

  async update(
    dateset: string,
    dto: UpdateShiftTimeDto,
    organizationId: number,
  ): Promise<ShiftTimeMaster> {
    const found = await this.findOneOrThrow(dateset, organizationId);
    const nextEnd = dto.dateend !== undefined ? (dto.dateend ? parseYmd(dto.dateend) : null) : found.dateend;
    await this.ensureNoOverlap(
      dateset,
      nextEnd ? this.toIso(nextEnd) : null,
      organizationId,
      dateset,
    );
    found.dateend = nextEnd;
    if (dto.dayTimeStart !== undefined) found.dayTimeStart = dto.dayTimeStart ?? null;
    if (dto.dayTimeEnd !== undefined) found.dayTimeEnd = dto.dayTimeEnd ?? null;
    if (dto.dayBreakMinutes !== undefined) found.dayBreakMinutes = dto.dayBreakMinutes;
    if (dto.nightTimeStart !== undefined) found.nightTimeStart = dto.nightTimeStart ?? null;
    if (dto.nightTimeEnd !== undefined) found.nightTimeEnd = dto.nightTimeEnd ?? null;
    if (dto.nightBreakMinutes !== undefined) found.nightBreakMinutes = dto.nightBreakMinutes;
    return this.repo.save(found);
  }

  async remove(dateset: string, organizationId: number): Promise<void> {
    const found = await this.findOneOrThrow(dateset, organizationId);
    await this.repo.remove(found);
  }

  private async findOneOrThrow(dateset: string, organizationId: number): Promise<ShiftTimeMaster> {
    const found = await this.repo.findOne({
      where: { organizationId, dateset: parseYmd(dateset) },
    });
    if (!found) throw new NotFoundException(`교대시간을 찾을 수 없습니다: ${dateset}`);
    return found;
  }

  private toIso(d: Date): string {
    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    return `${y}-${m}-${day}`;
  }

  /** 유효기간 겹침 검증. excludeDateset은 수정 시 자기 자신을 제외하기 위한 값. */
  private async ensureNoOverlap(
    dateset: string,
    dateend: string | null,
    organizationId: number,
    excludeDateset: string | null,
  ): Promise<void> {
    const from = parseYmd(dateset).getTime();
    const to = dateend ? parseYmd(dateend).getTime() : Number.POSITIVE_INFINITY;
    if (to < from) {
      throw new ConflictException('종료일이 시작일보다 이릅니다.');
    }
    const rows = await this.repo.find({ where: { organizationId } });
    const clash = rows.find((r) => {
      const rFromDate = new Date(r.dateset);
      if (excludeDateset && this.toIso(rFromDate) === excludeDateset) return false;
      const rFrom = rFromDate.getTime();
      const rTo = r.dateend ? new Date(r.dateend).getTime() : Number.POSITIVE_INFINITY;
      return from <= rTo && rFrom <= to;
    });
    if (clash) {
      throw new ConflictException(
        `적용기간이 겹치는 교대시간이 있습니다: ${this.toIso(new Date(clash.dateset))}`,
      );
    }
  }
}
```

- [ ] **Step 5: 테스트 통과 확인**

```bash
pnpm --filter @eunsung/backend exec jest src/modules/master/services/shift-time.service.spec.ts
```

Expected: PASS — 6 tests.

- [ ] **Step 6: 고아 shift-pattern 서비스 삭제**

```bash
rm apps/backend/src/modules/master/services/shift-pattern.service.ts
```

- [ ] **Step 7: 커밋**

```bash
git add apps/backend/src/modules/master/services/shift-time.service.ts \
        apps/backend/src/modules/master/services/shift-time.service.spec.ts \
        apps/backend/src/modules/master/dto/work-calendar.dto.ts
git rm --cached apps/backend/src/modules/master/services/shift-pattern.service.ts 2>/dev/null || true
git add -A apps/backend/src/modules/master/services
git commit -m "feat(work-calendar): 교대시간 마스터 서비스 추가 (유효기간 겹침 검증)"
```

---

## Task 5: 백엔드 월력 서비스 + DTO + 컨트롤러 + 모듈 배선 (TDD)

**Files:**
- Modify (전면 교체): `apps/backend/src/modules/master/dto/work-calendar.dto.ts`
- Modify (전면 교체): `apps/backend/src/modules/master/services/work-calendar.service.ts`
- Modify (전면 교체): `apps/backend/src/modules/master/services/work-calendar.service.spec.ts`
- Modify (전면 교체): `apps/backend/src/modules/master/controllers/work-calendar.controller.ts`
- Create: `apps/backend/src/modules/master/controllers/shift-time.controller.ts`
- Modify: `apps/backend/src/modules/master/master-work-calendar.module.ts`
- Delete: `apps/backend/src/modules/master/controllers/shift-pattern.controller.ts`

**Interfaces:**
- Consumes: `ProductCompanyCalendar`·`ProductLineCalendar` (Task 3), `ShiftTimeService.resolveForDate` (Task 4), `defaultWorkMinutes`·`holidayYnOf`·`isFixedHoliday` (Task 2)
- Produces (컨트롤러 경로 — 프론트가 이 경로를 호출한다):
  - `GET  /master/work-calendar/days?year&month&lineCode`
  - `PUT  /master/work-calendar/days/bulk`
  - `POST /master/work-calendar/generate`
  - `POST /master/work-calendar/copy-from-company`
  - `POST /master/work-calendar/confirm` · `/unconfirm`
  - `GET  /master/work-calendar/summary?year&lineCode`
  - `GET|POST /master/shift-times`, `PUT|DELETE /master/shift-times/:dateset`
- Produces (응답 DTO — 프론트 타입의 원천):
  ```ts
  interface WorkCalendarDayView {
    workDate: string;        // YYYY-MM-DD
    dayType: WorkDayType;
    offReason: string | null;
    workMinutes: number;
    otMinutes: number;
    comment: string | null;
    confirmYn: 'Y' | 'N';
    source: 'COMPANY' | 'LINE'; // 라인 예외 행이 이겼는지
  }
  ```

- [ ] **Step 1: DTO 전면 교체**

`apps/backend/src/modules/master/dto/work-calendar.dto.ts`. Task 4에서 추가한 `CreateShiftTimeDto`/`UpdateShiftTimeDto`는 **그대로 유지**하고, 그 위의 HANES DTO(`CreateWorkCalendarDto`, `UpdateWorkCalendarDto`, `WorkCalendarQueryDto`, `WorkCalendarDayItemDto`, `BulkUpdateDaysDto`, `GenerateCalendarDto`, `CreateShiftPatternDto`, `UpdateShiftPatternDto`)를 아래로 교체한다.

```ts
/**
 * @file src/modules/master/dto/work-calendar.dto.ts
 * @description 생산월력(IP_ 모델) DTO
 *
 * 초보자 가이드:
 * 1. lineCode가 없으면 전사 월력(IP_PRODUCT_COMPANY_CALENDAR), 있으면 라인 예외(IP_PRODUCT_LINE_CALENDAR).
 * 2. HOLIDAY_YN은 클라이언트가 보내지 않는다 — dayType에서 서버가 파생시킨다.
 */
import { ApiProperty, ApiPropertyOptional, OmitType, PartialType } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsArray,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Matches,
  Max,
  MaxLength,
  Min,
  ValidateNested,
  IsBoolean,
} from 'class-validator';

export const WORK_DAY_TYPES = ['WORK', 'OFF', 'HALF', 'SPECIAL'] as const;

export class WorkCalendarDaysQueryDto {
  @ApiProperty({ description: '조회 월 (YYYY-MM)', example: '2026-07' })
  @Matches(/^\d{4}-\d{2}$/, { message: 'month는 YYYY-MM 형식이어야 합니다.' })
  month: string;

  @ApiPropertyOptional({ description: '라인코드. 미지정이면 전사 월력' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  lineCode?: string;
}

export class WorkCalendarDayItemDto {
  @ApiProperty({ description: '일자 (YYYY-MM-DD)', example: '2026-07-14' })
  @Matches(/^\d{4}-\d{2}-\d{2}$/, { message: 'workDate는 YYYY-MM-DD 형식이어야 합니다.' })
  workDate: string;

  @ApiProperty({ description: '근무유형', enum: WORK_DAY_TYPES })
  @IsIn(WORK_DAY_TYPES as unknown as string[])
  dayType: string;

  @ApiPropertyOptional({ description: '휴무사유 (dayType=OFF일 때만 유효)' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  offReason?: string | null;

  @ApiPropertyOptional({ description: '근무분. 미지정이면 교대시간 마스터에서 파생' })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(2880)
  workMinutes?: number;

  @ApiPropertyOptional({ description: '잔업분', default: 0 })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(1440)
  otMinutes?: number;

  @ApiPropertyOptional({ description: '비고' })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  comment?: string | null;
}

export class BulkUpdateDaysDto {
  @ApiPropertyOptional({ description: '라인코드. 미지정이면 전사 월력' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  lineCode?: string;

  @ApiProperty({ type: [WorkCalendarDayItemDto] })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => WorkCalendarDayItemDto)
  days: WorkCalendarDayItemDto[];
}

export class GenerateCalendarDto {
  @ApiProperty({ description: '대상 연도 (YYYY)', example: '2026' })
  @Matches(/^\d{4}$/, { message: 'year는 YYYY 형식이어야 합니다.' })
  year: string;

  @ApiPropertyOptional({ description: '라인코드. 미지정이면 전사 월력' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  lineCode?: string;

  @ApiPropertyOptional({ description: '토요일 근무 여부', default: false })
  @IsOptional()
  @IsBoolean()
  saturdayWork?: boolean;

  @ApiPropertyOptional({ description: '일요일 근무 여부', default: false })
  @IsOptional()
  @IsBoolean()
  sundayWork?: boolean;

  @ApiPropertyOptional({ description: '양력 고정공휴일 자동 반영', default: true })
  @IsOptional()
  @IsBoolean()
  applyHolidays?: boolean;
}

export class CopyFromCompanyDto {
  @ApiProperty({ description: '대상 연도 (YYYY)', example: '2026' })
  @Matches(/^\d{4}$/, { message: 'year는 YYYY 형식이어야 합니다.' })
  year: string;

  @ApiProperty({ description: '복사 대상 라인코드' })
  @IsString()
  @MaxLength(20)
  lineCode: string;
}

export class ConfirmDaysDto {
  @ApiProperty({ description: '대상 연도 (YYYY)', example: '2026' })
  @Matches(/^\d{4}$/, { message: 'year는 YYYY 형식이어야 합니다.' })
  year: string;

  @ApiPropertyOptional({ description: '대상 월 (1~12). 미지정이면 연 전체' })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(12)
  month?: number;

  @ApiPropertyOptional({ description: '라인코드. 미지정이면 전사 월력' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  lineCode?: string;
}

export class SummaryQueryDto {
  @ApiProperty({ description: '대상 연도 (YYYY)', example: '2026' })
  @Matches(/^\d{4}$/, { message: 'year는 YYYY 형식이어야 합니다.' })
  year: string;

  @ApiPropertyOptional({ description: '라인코드. 미지정이면 전사 월력' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  lineCode?: string;
}
```

(파일 하단의 `CreateShiftTimeDto` / `UpdateShiftTimeDto`는 Task 4에서 추가한 그대로 둔다.)

- [ ] **Step 2: 실패하는 서비스 테스트 작성**

`apps/backend/src/modules/master/services/work-calendar.service.spec.ts` 전면 교체:

```ts
import { Test } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { ConflictException } from '@nestjs/common';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { Repository } from 'typeorm';
import { ProductCompanyCalendar } from '../../../entities/product-company-calendar.entity';
import { ProductLineCalendar } from '../../../entities/product-line-calendar.entity';
import { ShiftTimeMaster } from '../../../entities/shift-time-master.entity';
import { ShiftTimeService } from './shift-time.service';
import { WorkCalendarService } from './work-calendar.service';

const SHIFT = {
  organizationId: 1,
  dateset: new Date('2026-01-01T00:00:00'),
  dateend: null,
  dayTimeStart: '08:00',
  dayTimeEnd: '20:00',
  dayBreakMinutes: 60,
  nightTimeStart: '20:00',
  nightTimeEnd: '08:00',
  nightBreakMinutes: 60,
} as ShiftTimeMaster;

describe('WorkCalendarService', () => {
  let target: WorkCalendarService;
  let companyRepo: DeepMocked<Repository<ProductCompanyCalendar>>;
  let lineRepo: DeepMocked<Repository<ProductLineCalendar>>;
  let shiftTime: DeepMocked<ShiftTimeService>;

  beforeEach(async () => {
    companyRepo = createMock<Repository<ProductCompanyCalendar>>();
    lineRepo = createMock<Repository<ProductLineCalendar>>();
    shiftTime = createMock<ShiftTimeService>();
    shiftTime.resolveForDate.mockResolvedValue(SHIFT);

    const moduleRef = await Test.createTestingModule({
      providers: [
        WorkCalendarService,
        { provide: getRepositoryToken(ProductCompanyCalendar), useValue: companyRepo },
        { provide: getRepositoryToken(ProductLineCalendar), useValue: lineRepo },
        { provide: ShiftTimeService, useValue: shiftTime },
      ],
    }).compile();
    target = moduleRef.get(WorkCalendarService);
  });

  const companyRow = (date: string, dayType: string, confirmYn = 'N') =>
    ({
      planDate: new Date(`${date}T00:00:00`),
      organizationId: 1,
      dayType,
      holidayYn: dayType === 'OFF' ? 'Y' : 'N',
      offReason: dayType === 'OFF' ? 'WEEKEND' : null,
      workMinutes: dayType === 'OFF' ? 0 : 1320,
      otMinutes: 0,
      confirmYn,
      calendarComment: null,
    }) as ProductCompanyCalendar;

  describe('findDays — 전사 + 라인 예외 병합', () => {
    it('라인 예외 행이 전사 행을 덮어쓴다', async () => {
      companyRepo.find.mockResolvedValue([companyRow('2026-07-14', 'WORK')]);
      lineRepo.find.mockResolvedValue([
        {
          planDate: new Date('2026-07-14T00:00:00'),
          organizationId: 1,
          lineCode: 'L1',
          dayType: 'OFF',
          holidayYn: 'Y',
          offReason: 'LINE_STOP',
          workMinutes: 0,
          otMinutes: 0,
          confirmYn: 'N',
          calendarComment: null,
        } as ProductLineCalendar,
      ]);

      const days = await target.findDays({ month: '2026-07', lineCode: 'L1' }, 1);
      const day = days.find((d) => d.workDate === '2026-07-14');
      expect(day?.dayType).toBe('OFF');
      expect(day?.source).toBe('LINE');
    });

    it('라인 예외가 없으면 전사 행이 그대로 보이고 source=COMPANY', async () => {
      companyRepo.find.mockResolvedValue([companyRow('2026-07-14', 'WORK')]);
      lineRepo.find.mockResolvedValue([]);

      const days = await target.findDays({ month: '2026-07', lineCode: 'L1' }, 1);
      const day = days.find((d) => d.workDate === '2026-07-14');
      expect(day?.dayType).toBe('WORK');
      expect(day?.source).toBe('COMPANY');
    });

    it('lineCode가 없으면 라인 테이블을 조회하지 않는다', async () => {
      companyRepo.find.mockResolvedValue([companyRow('2026-07-14', 'WORK')]);
      await target.findDays({ month: '2026-07' }, 1);
      expect(lineRepo.find).not.toHaveBeenCalled();
    });
  });

  describe('generateYear', () => {
    it('토/일 미근무면 OFF/WEEKEND로 생성한다', async () => {
      companyRepo.find.mockResolvedValue([]);
      companyRepo.save.mockImplementation(async (v) => v as ProductCompanyCalendar);

      await target.generateYear({ year: '2026', saturdayWork: false, sundayWork: false }, 1);

      const saved = companyRepo.save.mock.calls[0][0] as ProductCompanyCalendar[];
      // 2026-01-03은 토요일
      const sat = saved.find((d) => d.planDate.getTime() === new Date('2026-01-03T00:00:00').getTime());
      expect(sat?.dayType).toBe('OFF');
      expect(sat?.offReason).toBe('WEEKEND');
      expect(sat?.workMinutes).toBe(0);
      expect(sat?.holidayYn).toBe('Y');
    });

    it('양력 고정공휴일은 OFF/HOLIDAY로 생성한다', async () => {
      companyRepo.find.mockResolvedValue([]);
      companyRepo.save.mockImplementation(async (v) => v as ProductCompanyCalendar);

      await target.generateYear({ year: '2026', saturdayWork: true, sundayWork: true }, 1);

      const saved = companyRepo.save.mock.calls[0][0] as ProductCompanyCalendar[];
      const day = saved.find((d) => d.planDate.getTime() === new Date('2026-03-01T00:00:00').getTime());
      expect(day?.dayType).toBe('OFF');
      expect(day?.offReason).toBe('HOLIDAY');
    });

    it('평일은 WORK이고 근무분은 교대시간에서 파생된다 (주간660+야간660=1320)', async () => {
      companyRepo.find.mockResolvedValue([]);
      companyRepo.save.mockImplementation(async (v) => v as ProductCompanyCalendar);

      await target.generateYear({ year: '2026', applyHolidays: false }, 1);

      const saved = companyRepo.save.mock.calls[0][0] as ProductCompanyCalendar[];
      // 2026-07-14는 화요일
      const day = saved.find((d) => d.planDate.getTime() === new Date('2026-07-14T00:00:00').getTime());
      expect(day?.dayType).toBe('WORK');
      expect(day?.workMinutes).toBe(1320);
      expect(day?.holidayYn).toBe('N');
    });

    it('확정된 일자가 하나라도 있으면 409로 거부한다', async () => {
      companyRepo.find.mockResolvedValue([companyRow('2026-07-14', 'WORK', 'Y')]);
      await expect(target.generateYear({ year: '2026' }, 1)).rejects.toBeInstanceOf(ConflictException);
      expect(companyRepo.save).not.toHaveBeenCalled();
    });
  });

  describe('bulkUpdateDays', () => {
    it('확정된 일자를 수정하려 하면 409', async () => {
      companyRepo.find.mockResolvedValue([companyRow('2026-07-14', 'WORK', 'Y')]);
      await expect(
        target.bulkUpdateDays({ days: [{ workDate: '2026-07-14', dayType: 'OFF' }] }, 1),
      ).rejects.toBeInstanceOf(ConflictException);
    });

    it('workMinutes 미지정이면 dayType에서 파생시킨다', async () => {
      companyRepo.find.mockResolvedValue([]);
      companyRepo.save.mockImplementation(async (v) => v as ProductCompanyCalendar);

      await target.bulkUpdateDays({ days: [{ workDate: '2026-07-14', dayType: 'HALF' }] }, 1);

      const saved = companyRepo.save.mock.calls[0][0] as ProductCompanyCalendar[];
      expect(saved[0].workMinutes).toBe(330); // 주간 660 ÷ 2
    });

    it('workMinutes를 명시하면 그 값을 그대로 저장한다 (override)', async () => {
      companyRepo.find.mockResolvedValue([]);
      companyRepo.save.mockImplementation(async (v) => v as ProductCompanyCalendar);

      await target.bulkUpdateDays(
        { days: [{ workDate: '2026-07-14', dayType: 'WORK', workMinutes: 480 }] },
        1,
      );

      const saved = companyRepo.save.mock.calls[0][0] as ProductCompanyCalendar[];
      expect(saved[0].workMinutes).toBe(480);
    });

    it('OFF가 아니면 offReason을 null로 강제한다', async () => {
      companyRepo.find.mockResolvedValue([]);
      companyRepo.save.mockImplementation(async (v) => v as ProductCompanyCalendar);

      await target.bulkUpdateDays(
        { days: [{ workDate: '2026-07-14', dayType: 'WORK', offReason: 'WEEKEND' }] },
        1,
      );

      const saved = companyRepo.save.mock.calls[0][0] as ProductCompanyCalendar[];
      expect(saved[0].offReason).toBeNull();
      expect(saved[0].holidayYn).toBe('N');
    });
  });
});
```

- [ ] **Step 3: 테스트 실패 확인**

```bash
pnpm --filter @eunsung/backend exec jest src/modules/master/services/work-calendar.service.spec.ts
```

Expected: FAIL — 컴파일 에러(`WorkCalendarService`에 `findDays`가 없음).

- [ ] **Step 4: 서비스 전면 교체**

`apps/backend/src/modules/master/services/work-calendar.service.ts`:

```ts
/**
 * @file src/modules/master/services/work-calendar.service.ts
 * @description 생산월력(IP_ 모델) 서비스 — 전사 월력 + 라인 예외
 *
 * 초보자 가이드:
 * 1. lineCode가 없으면 IP_PRODUCT_COMPANY_CALENDAR, 있으면 IP_PRODUCT_LINE_CALENDAR를 쓴다.
 * 2. 조회는 병합이다: 라인 예외 행이 있으면 그것이 이기고(source=LINE), 없으면 전사 행(source=COMPANY).
 * 3. HOLIDAY_YN은 절대 클라이언트 값을 믿지 않는다 — holidayYnOf(dayType)로 파생시킨다.
 *    DB CHECK 제약(CK_*_HOLIDAY_SYNC)이 이 불변식을 다시 한 번 강제한다.
 * 4. CONFIRM_YN='Y'인 일자가 범위에 하나라도 있으면 쓰기(저장/생성/복사)를 거부한다.
 */
import { ConflictException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Between, Repository } from 'typeorm';
import {
  defaultWorkMinutes,
  holidayYnOf,
  isFixedHoliday,
  type ShiftTimeMasterLike,
  type WorkDayType,
} from '@smt/shared';
import { ProductCompanyCalendar } from '../../../entities/product-company-calendar.entity';
import { ProductLineCalendar } from '../../../entities/product-line-calendar.entity';
import { ShiftTimeService } from './shift-time.service';
import {
  BulkUpdateDaysDto,
  ConfirmDaysDto,
  CopyFromCompanyDto,
  GenerateCalendarDto,
  SummaryQueryDto,
  WorkCalendarDaysQueryDto,
} from '../dto/work-calendar.dto';

export interface WorkCalendarDayView {
  workDate: string;
  dayType: WorkDayType;
  offReason: string | null;
  workMinutes: number;
  otMinutes: number;
  comment: string | null;
  confirmYn: 'Y' | 'N';
  source: 'COMPANY' | 'LINE';
}

export interface WorkCalendarSummary {
  workDays: number;
  offDays: number;
  halfDays: number;
  specialDays: number;
  totalMinutes: number;
}

function parseYmd(isoDate: string): Date {
  const [y, m, d] = isoDate.split('-').map(Number);
  return new Date(y, m - 1, d);
}

function toIso(d: Date): string {
  const date = new Date(d);
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${y}-${m}-${day}`;
}

/** 'YYYY-MM' → [해당 월 1일, 말일] */
function monthRange(month: string): [Date, Date] {
  const [y, m] = month.split('-').map(Number);
  return [new Date(y, m - 1, 1), new Date(y, m, 0)];
}

function yearRange(year: string): [Date, Date] {
  const y = Number(year);
  return [new Date(y, 0, 1), new Date(y, 11, 31)];
}

@Injectable()
export class WorkCalendarService {
  constructor(
    @InjectRepository(ProductCompanyCalendar)
    private readonly companyRepo: Repository<ProductCompanyCalendar>,
    @InjectRepository(ProductLineCalendar)
    private readonly lineRepo: Repository<ProductLineCalendar>,
    private readonly shiftTime: ShiftTimeService,
  ) {}

  /* ── 조회 ── */

  async findDays(
    query: WorkCalendarDaysQueryDto,
    organizationId: number,
  ): Promise<WorkCalendarDayView[]> {
    const [from, to] = monthRange(query.month);

    const companyRows = await this.companyRepo.find({
      where: { organizationId, planDate: Between(from, to) },
    });

    const lineRows = query.lineCode
      ? await this.lineRepo.find({
          where: { organizationId, lineCode: query.lineCode, planDate: Between(from, to) },
        })
      : [];

    const merged = new Map<string, WorkCalendarDayView>();
    for (const row of companyRows) {
      merged.set(toIso(row.planDate), this.toView(row, 'COMPANY'));
    }
    for (const row of lineRows) {
      merged.set(toIso(row.planDate), this.toView(row, 'LINE'));
    }
    return [...merged.values()].sort((a, b) => a.workDate.localeCompare(b.workDate));
  }

  async getSummary(
    query: SummaryQueryDto,
    organizationId: number,
  ): Promise<WorkCalendarSummary> {
    const [from, to] = yearRange(query.year);
    const companyRows = await this.companyRepo.find({
      where: { organizationId, planDate: Between(from, to) },
    });
    const lineRows = query.lineCode
      ? await this.lineRepo.find({
          where: { organizationId, lineCode: query.lineCode, planDate: Between(from, to) },
        })
      : [];

    const merged = new Map<string, WorkCalendarDayView>();
    for (const row of companyRows) merged.set(toIso(row.planDate), this.toView(row, 'COMPANY'));
    for (const row of lineRows) merged.set(toIso(row.planDate), this.toView(row, 'LINE'));

    const summary: WorkCalendarSummary = {
      workDays: 0,
      offDays: 0,
      halfDays: 0,
      specialDays: 0,
      totalMinutes: 0,
    };
    for (const day of merged.values()) {
      if (day.dayType === 'WORK') summary.workDays += 1;
      else if (day.dayType === 'OFF') summary.offDays += 1;
      else if (day.dayType === 'HALF') summary.halfDays += 1;
      else summary.specialDays += 1;
      summary.totalMinutes += day.workMinutes + day.otMinutes;
    }
    return summary;
  }

  /* ── 쓰기 ── */

  async bulkUpdateDays(dto: BulkUpdateDaysDto, organizationId: number): Promise<number> {
    if (dto.days.length === 0) return 0;

    const dates = dto.days.map((d) => d.workDate).sort();
    await this.ensureNotConfirmed(
      parseYmd(dates[0]),
      parseYmd(dates[dates.length - 1]),
      dto.lineCode,
      organizationId,
    );

    const rows = [];
    for (const day of dto.days) {
      rows.push(await this.buildRow(day, dto.lineCode, organizationId));
    }
    await this.repoFor(dto.lineCode).save(rows as never[]);
    return rows.length;
  }

  async generateYear(dto: GenerateCalendarDto, organizationId: number): Promise<number> {
    const [from, to] = yearRange(dto.year);
    await this.ensureNotConfirmed(from, to, dto.lineCode, organizationId);

    const applyHolidays = dto.applyHolidays ?? true;
    const rows = [];

    for (const cursor = new Date(from); cursor <= to; cursor.setDate(cursor.getDate() + 1)) {
      const isoDate = toIso(cursor);
      const dow = cursor.getDay(); // 0=일, 6=토

      let dayType: WorkDayType = 'WORK';
      let offReason: string | null = null;

      const weekendOff =
        (dow === 6 && !(dto.saturdayWork ?? false)) || (dow === 0 && !(dto.sundayWork ?? false));

      if (weekendOff) {
        dayType = 'OFF';
        offReason = 'WEEKEND';
      } else if (applyHolidays && isFixedHoliday(isoDate)) {
        dayType = 'OFF';
        offReason = 'HOLIDAY';
      }

      rows.push(
        await this.buildRow(
          { workDate: isoDate, dayType, offReason, otMinutes: 0, comment: null },
          dto.lineCode,
          organizationId,
        ),
      );
    }

    await this.repoFor(dto.lineCode).save(rows as never[]);
    return rows.length;
  }

  /** 라인 월력을 전사 월력에서 복제한다 (해당 연도 전체 덮어쓰기). */
  async copyFromCompany(dto: CopyFromCompanyDto, organizationId: number): Promise<number> {
    const [from, to] = yearRange(dto.year);
    await this.ensureNotConfirmed(from, to, dto.lineCode, organizationId);

    const companyRows = await this.companyRepo.find({
      where: { organizationId, planDate: Between(from, to) },
    });
    if (companyRows.length === 0) {
      throw new ConflictException(`복사할 전사 월력이 없습니다: ${dto.year}년`);
    }

    const rows = companyRows.map((src) =>
      this.lineRepo.create({
        planDate: new Date(src.planDate),
        organizationId,
        lineCode: dto.lineCode,
        dayType: src.dayType,
        holidayYn: src.holidayYn,
        offReason: src.offReason,
        workMinutes: src.workMinutes,
        otMinutes: src.otMinutes,
        confirmYn: 'N',
        calendarComment: src.calendarComment,
      }),
    );
    await this.lineRepo.save(rows);
    return rows.length;
  }

  async confirm(dto: ConfirmDaysDto, organizationId: number): Promise<number> {
    return this.setConfirm(dto, 'Y', organizationId);
  }

  async unconfirm(dto: ConfirmDaysDto, organizationId: number): Promise<number> {
    return this.setConfirm(dto, 'N', organizationId);
  }

  /* ── 내부 ── */

  private repoFor(lineCode?: string) {
    return lineCode ? this.lineRepo : this.companyRepo;
  }

  private toView(
    row: ProductCompanyCalendar | ProductLineCalendar,
    source: 'COMPANY' | 'LINE',
  ): WorkCalendarDayView {
    return {
      workDate: toIso(row.planDate),
      dayType: row.dayType as WorkDayType,
      offReason: row.offReason,
      workMinutes: row.workMinutes,
      otMinutes: row.otMinutes,
      comment: row.calendarComment,
      confirmYn: row.confirmYn === 'Y' ? 'Y' : 'N',
      source,
    };
  }

  /** 일자 1건을 엔티티로 만든다. HOLIDAY_YN과 근무분은 여기서만 파생된다. */
  private async buildRow(
    day: {
      workDate: string;
      dayType: string;
      offReason?: string | null;
      workMinutes?: number;
      otMinutes?: number;
      comment?: string | null;
    },
    lineCode: string | undefined,
    organizationId: number,
  ) {
    const dayType = day.dayType as WorkDayType;
    const shift = (await this.shiftTime.resolveForDate(
      day.workDate,
      organizationId,
    )) as ShiftTimeMasterLike | null;

    const base = {
      planDate: parseYmd(day.workDate),
      organizationId,
      dayType,
      holidayYn: holidayYnOf(dayType),
      offReason: dayType === 'OFF' ? (day.offReason ?? null) : null,
      workMinutes: day.workMinutes ?? defaultWorkMinutes(dayType, shift),
      otMinutes: day.otMinutes ?? 0,
      confirmYn: 'N',
      calendarComment: day.comment ?? null,
    };

    return lineCode
      ? this.lineRepo.create({ ...base, lineCode })
      : this.companyRepo.create(base);
  }

  /** 범위 안에 확정(CONFIRM_YN='Y') 일자가 하나라도 있으면 거부한다. */
  private async ensureNotConfirmed(
    from: Date,
    to: Date,
    lineCode: string | undefined,
    organizationId: number,
  ): Promise<void> {
    const rows = lineCode
      ? await this.lineRepo.find({
          where: { organizationId, lineCode, planDate: Between(from, to) },
        })
      : await this.companyRepo.find({
          where: { organizationId, planDate: Between(from, to) },
        });

    const locked = rows.find((r) => r.confirmYn === 'Y');
    if (locked) {
      throw new ConflictException(
        `확정된 월력은 수정할 수 없습니다. 확정 취소 후 진행하세요: ${toIso(locked.planDate)}`,
      );
    }
  }

  private async setConfirm(
    dto: ConfirmDaysDto,
    confirmYn: 'Y' | 'N',
    organizationId: number,
  ): Promise<number> {
    const [from, to] = dto.month
      ? monthRange(`${dto.year}-${String(dto.month).padStart(2, '0')}`)
      : yearRange(dto.year);

    const repo = this.repoFor(dto.lineCode);
    const rows = dto.lineCode
      ? await this.lineRepo.find({
          where: { organizationId, lineCode: dto.lineCode, planDate: Between(from, to) },
        })
      : await this.companyRepo.find({
          where: { organizationId, planDate: Between(from, to) },
        });

    for (const row of rows) row.confirmYn = confirmYn;
    await repo.save(rows as never[]);
    return rows.length;
  }
}
```

- [ ] **Step 5: 서비스 테스트 통과 확인**

```bash
pnpm --filter @eunsung/backend exec jest src/modules/master/services/work-calendar.service.spec.ts
```

Expected: PASS — 11 tests.

- [ ] **Step 6: 컨트롤러 2개 작성**

`apps/backend/src/modules/master/controllers/work-calendar.controller.ts` 전면 교체:

```ts
/**
 * @file src/modules/master/controllers/work-calendar.controller.ts
 * @description 생산월력(IP_ 모델) API 컨트롤러
 *
 * 초보자 가이드:
 * 1. lineCode 미지정 = 전사 월력, 지정 = 라인 예외 월력.
 * 2. 조회(GET /days)는 전사+라인 병합 결과를 돌려준다.
 */
import { Body, Controller, Get, HttpCode, HttpStatus, Post, Put, Query } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { WorkCalendarService } from '../services/work-calendar.service';
import {
  BulkUpdateDaysDto,
  ConfirmDaysDto,
  CopyFromCompanyDto,
  GenerateCalendarDto,
  SummaryQueryDto,
  WorkCalendarDaysQueryDto,
} from '../dto/work-calendar.dto';

@ApiTags('기준정보 - 생산월력')
@Controller('master/work-calendar')
export class WorkCalendarController {
  constructor(private readonly svc: WorkCalendarService) {}

  @Get('days')
  @ApiOperation({ summary: '월별 일자 조회 (전사 + 라인 예외 병합)' })
  async findDays(@Query() q: WorkCalendarDaysQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.findDays(q, organizationId));
  }

  @Put('days/bulk')
  @ApiOperation({ summary: '일자 일괄 저장' })
  async bulkUpdateDays(@Body() dto: BulkUpdateDaysDto, @OrganizationId() organizationId: number) {
    const count = await this.svc.bulkUpdateDays(dto, organizationId);
    return ResponseUtil.success({ count }, '월력이 저장되었습니다.');
  }

  @Post('generate')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: '연간 생성 (주말·양력 고정공휴일 자동 반영)' })
  async generate(@Body() dto: GenerateCalendarDto, @OrganizationId() organizationId: number) {
    const count = await this.svc.generateYear(dto, organizationId);
    return ResponseUtil.success({ count }, '연간 월력이 생성되었습니다.');
  }

  @Post('copy-from-company')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: '라인 월력을 전사 월력에서 복제' })
  async copyFromCompany(
    @Body() dto: CopyFromCompanyDto,
    @OrganizationId() organizationId: number,
  ) {
    const count = await this.svc.copyFromCompany(dto, organizationId);
    return ResponseUtil.success({ count }, '전사 월력을 복사했습니다.');
  }

  @Post('confirm')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: '월력 확정' })
  async confirm(@Body() dto: ConfirmDaysDto, @OrganizationId() organizationId: number) {
    const count = await this.svc.confirm(dto, organizationId);
    return ResponseUtil.success({ count }, '월력이 확정되었습니다.');
  }

  @Post('unconfirm')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: '월력 확정 취소' })
  async unconfirm(@Body() dto: ConfirmDaysDto, @OrganizationId() organizationId: number) {
    const count = await this.svc.unconfirm(dto, organizationId);
    return ResponseUtil.success({ count }, '확정이 취소되었습니다.');
  }

  @Get('summary')
  @ApiOperation({ summary: '연간 요약 (가동일수·비가동일수·총가용시간)' })
  async getSummary(@Query() q: SummaryQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.getSummary(q, organizationId));
  }
}
```

`apps/backend/src/modules/master/controllers/shift-time.controller.ts`:

```ts
/**
 * @file src/modules/master/controllers/shift-time.controller.ts
 * @description 2교대 시간 마스터(IP_SHIFT_TIME_MASTER) API 컨트롤러
 */
import { Body, Controller, Delete, Get, HttpCode, HttpStatus, Param, Post, Put } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { ShiftTimeService } from '../services/shift-time.service';
import { CreateShiftTimeDto, UpdateShiftTimeDto } from '../dto/work-calendar.dto';

@ApiTags('기준정보 - 교대시간')
@Controller('master/shift-times')
export class ShiftTimeController {
  constructor(private readonly svc: ShiftTimeService) {}

  @Get()
  @ApiOperation({ summary: '교대시간 목록 (적용 시작일 내림차순)' })
  async findAll(@OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.findAll(organizationId));
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: '교대시간 등록' })
  async create(@Body() dto: CreateShiftTimeDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.create(dto, organizationId), '교대시간이 등록되었습니다.');
  }

  @Put(':dateset')
  @ApiOperation({ summary: '교대시간 수정' })
  async update(
    @Param('dateset') dateset: string,
    @Body() dto: UpdateShiftTimeDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(
      await this.svc.update(dateset, dto, organizationId),
      '교대시간이 수정되었습니다.',
    );
  }

  @Delete(':dateset')
  @ApiOperation({ summary: '교대시간 삭제' })
  async remove(@Param('dateset') dateset: string, @OrganizationId() organizationId: number) {
    await this.svc.remove(dateset, organizationId);
    return ResponseUtil.success(null, '교대시간이 삭제되었습니다.');
  }
}
```

- [ ] **Step 7: 모듈 배선 + 고아 컨트롤러 삭제**

`apps/backend/src/modules/master/master-work-calendar.module.ts` 전면 교체:

```ts
/**
 * @file src/modules/master/master-work-calendar.module.ts
 * @description 은성전장 생산월력(IP_ 모델) + 교대시간 API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductCompanyCalendar } from '../../entities/product-company-calendar.entity';
import { ProductLineCalendar } from '../../entities/product-line-calendar.entity';
import { ShiftTimeMaster } from '../../entities/shift-time-master.entity';
import { WorkCalendarController } from './controllers/work-calendar.controller';
import { ShiftTimeController } from './controllers/shift-time.controller';
import { WorkCalendarService } from './services/work-calendar.service';
import { ShiftTimeService } from './services/shift-time.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([ProductCompanyCalendar, ProductLineCalendar, ShiftTimeMaster]),
  ],
  controllers: [WorkCalendarController, ShiftTimeController],
  providers: [WorkCalendarService, ShiftTimeService],
  exports: [WorkCalendarService, ShiftTimeService],
})
export class MasterWorkCalendarModule {}
```

```bash
rm apps/backend/src/modules/master/controllers/shift-pattern.controller.ts
```

- [ ] **Step 8: 백엔드 타입체크 + 전체 월력 테스트**

```bash
pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false
```

Expected: 통과 (Task 3 Step 5에서 났던 에러가 모두 해소).

```bash
pnpm --filter @eunsung/backend exec jest src/modules/master
```

Expected: PASS.

- [ ] **Step 9: 커밋**

```bash
git add -A apps/backend/src/modules/master
git commit -m "feat(work-calendar): IP_ 모델 월력 서비스·컨트롤러 재작성, 교대시간 컨트롤러 배선"
```

---

## Task 6: 공통코드 시드 — `WORK_DAY_TYPE`, `DAY_OFF_TYPE`

화면이 `ComCodeSelect`/`ComCodeBadge`로 이 그룹을 읽는다. 시드가 없으면 드롭다운이 빈다.

**Files:**
- Create: `apps/backend/src/migrations/2026-07-14_work_calendar_com_codes.sql`

**실DB 확인 완료 (Task 0):** `ISYS_BASECODE`의 실제 구조는 `CODE_TYPE`(그룹, VARCHAR2(30) NOT NULL) + `CODE_NAME`(코드값, NOT NULL) + `ORGANIZATION_ID`(NOT NULL)가 키이고, 한글명은 `CODE_MEAN_KOR`, 영문명은 `CODE_MEAN_ENG`, 분류는 `CODE_GROUP`(기존 행은 `'SYSTEM'`)이다. **`CODE`·`USE_YN`·`SORT_SEQUENCE` 컬럼은 존재하지 않는다.** 기존 행 예: `('HOLIDAY YN','Y','휴일')`, `('SHIFT CODE','A','1교대')`.

- [ ] **Step 1: 시드 SQL 작성**

`apps/backend/src/migrations/2026-07-14_work_calendar_com_codes.sql`:

```sql
-- 생산월력 공통코드 시드 (멱등)
-- WORK DAY TYPE: 근무유형, DAY OFF TYPE: 휴무사유
-- 은성 공통코드 조회는 groupCode의 언더스코어를 공백으로 정규화해 CODE_TYPE과 매칭한다.
-- (구조테스트 'common code lookup normalizes column names and CODE_TYPE spacing' 참조)
-- 따라서 프론트의 groupCode "WORK_DAY_TYPE" → CODE_TYPE 'WORK DAY TYPE'.
MERGE INTO ISYS_BASECODE t
USING (
  SELECT 'WORK DAY TYPE' AS CODE_TYPE, 'WORK'    AS CODE_NAME, '근무'     AS CODE_MEAN_KOR, 'WORK'           AS CODE_MEAN_ENG, 1 AS ORGANIZATION_ID FROM DUAL UNION ALL
  SELECT 'WORK DAY TYPE', 'OFF',            '휴무',     'DAY OFF',        1 FROM DUAL UNION ALL
  SELECT 'WORK DAY TYPE', 'HALF',           '반일',     'HALF DAY',       1 FROM DUAL UNION ALL
  SELECT 'WORK DAY TYPE', 'SPECIAL',        '특근',     'SPECIAL WORK',   1 FROM DUAL UNION ALL
  SELECT 'DAY OFF TYPE',  'WEEKEND',        '주말',     'WEEKEND',        1 FROM DUAL UNION ALL
  SELECT 'DAY OFF TYPE',  'HOLIDAY',        '공휴일',   'PUBLIC HOLIDAY', 1 FROM DUAL UNION ALL
  SELECT 'DAY OFF TYPE',  'PLANT_SHUTDOWN', '공장휴무', 'PLANT SHUTDOWN', 1 FROM DUAL UNION ALL
  SELECT 'DAY OFF TYPE',  'LINE_STOP',      '라인정지', 'LINE STOP',      1 FROM DUAL
) s
ON (t.CODE_TYPE = s.CODE_TYPE AND t.CODE_NAME = s.CODE_NAME AND t.ORGANIZATION_ID = s.ORGANIZATION_ID)
WHEN NOT MATCHED THEN
  INSERT (CODE_TYPE, CODE_NAME, ORGANIZATION_ID, CODE_MEAN_KOR, CODE_MEAN_ENG, CODE_GROUP, ENTER_BY, ENTER_DATE)
  VALUES (s.CODE_TYPE, s.CODE_NAME, s.ORGANIZATION_ID, s.CODE_MEAN_KOR, s.CODE_MEAN_ENG, 'SYSTEM', 'SYSTEM', SYSDATE);
/
```

- [ ] **Step 2: 적용 + 검증**

```bash
python "C:/Users/hsyou/.claude/skills/oracle-db/scripts/oracle_connector.py" --site ESDBext --execute-file "apps/backend/src/migrations/2026-07-14_work_calendar_com_codes.sql"
python "C:/Users/hsyou/.claude/skills/oracle-db/scripts/oracle_connector.py" --site ESDBext --query "SELECT CODE_TYPE, CODE_NAME, CODE_MEAN_KOR FROM ISYS_BASECODE WHERE CODE_TYPE IN ('WORK DAY TYPE','DAY OFF TYPE') ORDER BY CODE_TYPE, CODE_NAME"
```

Expected: 8건 반환.

- [ ] **Step 3: 멱등성 확인** — Step 2의 `--execute-file`을 다시 실행. Expected: `success: true`, 여전히 8건(중복 삽입 없음).

- [ ] **Step 4: 커밋**

```bash
git add apps/backend/src/migrations/2026-07-14_work_calendar_com_codes.sql
git commit -m "feat(work-calendar): 근무유형/휴무사유 공통코드 시드"
```

---

## Task 7: 프론트 — 타입 + 페이지 재작성

**Files:**
- Create: `apps/frontend/src/app/(authenticated)/master/work-calendar/types.ts`
- Modify (전면 교체): `.../work-calendar/page.tsx`
- Modify: `.../work-calendar/components/CalendarGrid.tsx`
- Delete: `.../work-calendar/components/CalendarFormPanel.tsx`, `AddCalendarModal.tsx`, `ShiftPatternTab.tsx`

**Interfaces:**
- Consumes: Task 5의 API 경로와 `WorkCalendarDayView`.
- Produces: `WorkCalendarDay`, `ShiftTimeItem` 타입 (Task 8의 모달·탭이 import).

- [ ] **Step 1: 화면 타입**

`apps/frontend/src/app/(authenticated)/master/work-calendar/types.ts`:

```ts
/**
 * @file master/work-calendar/types.ts
 * @description 생산월력 화면 타입 (백엔드 IP_ 모델 응답과 1:1)
 */
import type { WorkDayType } from "@smt/shared";

export type { WorkDayType };

/** GET /master/work-calendar/days 응답 1건 */
export interface WorkCalendarDay {
  workDate: string;
  dayType: WorkDayType;
  offReason: string | null;
  workMinutes: number;
  otMinutes: number;
  comment: string | null;
  confirmYn: "Y" | "N";
  /** 라인 예외 행이 이겼는지 */
  source: "COMPANY" | "LINE";
}

/** GET /master/shift-times 응답 1건 */
export interface ShiftTimeItem {
  dateset: string;
  dateend: string | null;
  dayTimeStart: string | null;
  dayTimeEnd: string | null;
  dayBreakMinutes: number;
  nightTimeStart: string | null;
  nightTimeEnd: string | null;
  nightBreakMinutes: number;
}

/** 연간 요약 */
export interface WorkCalendarSummary {
  workDays: number;
  offDays: number;
  halfDays: number;
  specialDays: number;
  totalMinutes: number;
}
```

- [ ] **Step 2: `CalendarGrid` 타입/요약 조정**

`.../components/CalendarGrid.tsx`에서 파일 상단의 `WorkCalendarDay`·`ShiftPatternItem` **인터페이스 선언 2개를 삭제**하고 `types.ts`에서 import 한다.

```ts
import type { WorkCalendarDay } from "../types";
```

`CalendarGridProps`를 아래로 교체한다(`calendarId` 제거, 라인 예외 표시용 필드 없음 — 셀에서 `source`를 쓴다).

```ts
interface CalendarGridProps {
  month: string;
  days: WorkCalendarDay[];
  onDayClick: (date: string, day: WorkCalendarDay | null) => void;
  onMonthChange: (month: string) => void;
}
```

요약 계산에서 `d.workMinutes + d.otMinutes` 합산은 그대로 두고, 셀 렌더에서 `isConfirmed` prop 대신 **일자별 `info?.confirmYn === "Y"`** 로 잠금을 판정한다.

```tsx
const locked = info?.confirmYn === "Y";
return (
  <button
    key={ds}
    onClick={() => !locked && onDayClick(ds, info ?? null)}
    disabled={locked}
    className={`h-16 rounded border p-1 text-left flex flex-col transition-colors
      ${color} ${locked ? "cursor-default opacity-80" : "hover:ring-1 hover:ring-primary cursor-pointer"}`}
  >
    <span className="text-xs font-medium text-text dark:text-gray-200">{day}</span>
    {info && (
      <div className="mt-auto flex items-center gap-1">
        <ComCodeBadge groupCode="WORK_DAY_TYPE" code={info.dayType} />
        {info.source === "LINE" && (
          <span className="text-[9px] px-1 rounded bg-purple-100 dark:bg-purple-900/40 text-purple-700 dark:text-purple-300">
            예외
          </span>
        )}
        {locked && <Lock className="w-3 h-3 text-green-500" />}
      </div>
    )}
  </button>
);
```

- [ ] **Step 3: 구 컴포넌트 삭제**

```bash
rm "apps/frontend/src/app/(authenticated)/master/work-calendar/components/CalendarFormPanel.tsx" \
   "apps/frontend/src/app/(authenticated)/master/work-calendar/components/AddCalendarModal.tsx" \
   "apps/frontend/src/app/(authenticated)/master/work-calendar/components/ShiftPatternTab.tsx"
```

- [ ] **Step 4: `page.tsx` 전면 교체**

```tsx
"use client";

/**
 * @file master/work-calendar/page.tsx
 * @description 생산월력관리 — 전사 월력 + 라인 예외 + 2교대 시간 마스터
 *
 * 초보자 가이드:
 * 1. 좌측: 연도 + 라인 선택(전사 / 특정 라인). 라인을 고르면 라인 예외 월력을 편집한다.
 * 2. 우측: 월 그리드 — 날짜 클릭 시 DayEditModal. 확정된 일자는 잠긴다.
 * 3. 상단 버튼: 연간 생성 / 전사에서 복사(라인 모드) / 확정 / 확정취소.
 * 4. 교대시간 탭: IP_SHIFT_TIME_MASTER 유효기간 행 CRUD.
 */
import { useState, useEffect, useCallback, useMemo } from "react";
import { useTranslation } from "react-i18next";
import { Calendar, RefreshCw, CalendarPlus, Copy, Lock, Unlock } from "lucide-react";
import { Card, CardContent, Button, Input, ConfirmModal } from "@/components/ui";
import { LineSelect } from "@/components/shared";
import api from "@/services/api";
import CalendarGrid from "./components/CalendarGrid";
import DayEditModal from "./components/DayEditModal";
import ShiftTimeTab from "./components/ShiftTimeTab";
import type { WorkCalendarDay, ShiftTimeItem, WorkCalendarSummary } from "./types";

type TabType = "calendar" | "shift";
type TopAction = "generate" | "copy" | "confirm" | "unconfirm" | null;

export default function WorkCalendarPage() {
  const { t } = useTranslation();

  const [activeTab, setActiveTab] = useState<TabType>("calendar");
  const [year, setYear] = useState(() => String(new Date().getFullYear()));
  const [lineCode, setLineCode] = useState("");
  const [currentMonth, setCurrentMonth] = useState(() => {
    const now = new Date();
    return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}`;
  });

  const [days, setDays] = useState<WorkCalendarDay[]>([]);
  const [summary, setSummary] = useState<WorkCalendarSummary | null>(null);
  const [shiftTimes, setShiftTimes] = useState<ShiftTimeItem[]>([]);
  const [loading, setLoading] = useState(false);

  const [editingDay, setEditingDay] = useState<{ date: string; data: WorkCalendarDay | null } | null>(null);
  const [topAction, setTopAction] = useState<TopAction>(null);
  const [genSatWork, setGenSatWork] = useState(false);
  const [genSunWork, setGenSunWork] = useState(false);

  const lineParam = useMemo(() => (lineCode ? `&lineCode=${lineCode}` : ""), [lineCode]);

  /* ── 조회 ── */
  const fetchDays = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get(`/master/work-calendar/days?month=${currentMonth}${lineParam}`);
      setDays(res.data?.data ?? []);
    } catch { setDays([]); } finally { setLoading(false); }
  }, [currentMonth, lineParam]);

  const fetchSummary = useCallback(async () => {
    try {
      const res = await api.get(`/master/work-calendar/summary?year=${year}${lineParam}`);
      setSummary(res.data?.data ?? null);
    } catch { setSummary(null); }
  }, [year, lineParam]);

  const fetchShiftTimes = useCallback(async () => {
    try { setShiftTimes((await api.get("/master/shift-times")).data?.data ?? []); }
    catch { /* interceptor */ }
  }, []);

  useEffect(() => { fetchDays(); }, [fetchDays]);
  useEffect(() => { fetchSummary(); }, [fetchSummary]);
  useEffect(() => { fetchShiftTimes(); }, [fetchShiftTimes]);

  /* 연도 변경 시 표시 월도 그 연도로 옮긴다 */
  useEffect(() => {
    setCurrentMonth((prev) => `${year}-${prev.split("-")[1]}`);
  }, [year]);

  /* ── 쓰기 ── */
  const refreshAll = useCallback(async () => {
    await Promise.all([fetchDays(), fetchSummary()]);
  }, [fetchDays, fetchSummary]);

  const handleDaySave = useCallback(async (day: Partial<WorkCalendarDay>) => {
    try {
      await api.put("/master/work-calendar/days/bulk", {
        lineCode: lineCode || undefined,
        days: [day],
      });
      setEditingDay(null);
      await refreshAll();
    } catch { /* interceptor */ }
  }, [lineCode, refreshAll]);

  const handleGenerate = useCallback(async () => {
    try {
      await api.post("/master/work-calendar/generate", {
        year,
        lineCode: lineCode || undefined,
        saturdayWork: genSatWork,
        sundayWork: genSunWork,
        applyHolidays: true,
      });
      await refreshAll();
    } catch { /* interceptor */ } finally { setTopAction(null); }
  }, [year, lineCode, genSatWork, genSunWork, refreshAll]);

  const handleCopyFromCompany = useCallback(async () => {
    if (!lineCode) return;
    try {
      await api.post("/master/work-calendar/copy-from-company", { year, lineCode });
      await refreshAll();
    } catch { /* interceptor */ } finally { setTopAction(null); }
  }, [year, lineCode, refreshAll]);

  const handleConfirm = useCallback(async (confirmed: boolean) => {
    try {
      await api.post(`/master/work-calendar/${confirmed ? "confirm" : "unconfirm"}`, {
        year,
        lineCode: lineCode || undefined,
      });
      await refreshAll();
    } catch { /* interceptor */ } finally { setTopAction(null); }
  }, [year, lineCode, refreshAll]);

  return (
    <div className="h-full flex flex-col overflow-hidden p-6 gap-4 animate-fade-in">
      {/* 헤더 */}
      <div className="flex justify-between items-center flex-shrink-0">
        <div>
          <h1 className="text-xl font-bold text-text dark:text-gray-100 flex items-center gap-2">
            <Calendar className="w-7 h-7 text-primary" />
            {t("master.workCalendar.title")}
          </h1>
          <p className="text-text-muted dark:text-gray-400 mt-1">{t("master.workCalendar.subtitle")}</p>
        </div>
        <div className="flex gap-2">
          <Button variant="secondary" size="sm" onClick={() => { refreshAll(); fetchShiftTimes(); }}>
            <RefreshCw className="w-4 h-4 mr-1" />{t("common.refresh")}
          </Button>
          {activeTab === "calendar" && (
            <>
              <Button variant="secondary" size="sm" onClick={() => setTopAction("generate")}>
                <CalendarPlus className="w-4 h-4 mr-1" />{t("master.workCalendar.generateYear")}
              </Button>
              {lineCode && (
                <Button variant="secondary" size="sm" onClick={() => setTopAction("copy")}>
                  <Copy className="w-4 h-4 mr-1" />{t("master.workCalendar.copyFromCompany")}
                </Button>
              )}
              <Button variant="secondary" size="sm" onClick={() => setTopAction("unconfirm")}>
                <Unlock className="w-4 h-4 mr-1" />{t("master.workCalendar.unconfirm")}
              </Button>
              <Button size="sm" onClick={() => setTopAction("confirm")}>
                <Lock className="w-4 h-4 mr-1" />{t("master.workCalendar.confirm")}
              </Button>
            </>
          )}
        </div>
      </div>

      {/* 탭 */}
      <div className="flex gap-1 flex-shrink-0">
        {(["calendar", "shift"] as const).map((tab) => (
          <button key={tab} onClick={() => setActiveTab(tab)}
            className={`px-4 py-2 text-sm font-medium rounded-t transition-colors
              ${activeTab === tab
                ? "bg-white dark:bg-slate-800 text-primary border-b-2 border-primary"
                : "text-text-muted dark:text-gray-400 hover:text-text dark:hover:text-gray-200"}`}>
            {tab === "calendar"
              ? t("master.workCalendar.calendarManagement")
              : t("master.workCalendar.shiftTimeTab")}
          </button>
        ))}
      </div>

      {activeTab === "calendar" ? (
        <div className="grid grid-cols-12 gap-4 min-h-0 flex-1">
          {/* 좌측: 연도 + 라인 + 요약 */}
          <div className="col-span-3 flex flex-col min-h-0 gap-3">
            <Card padding="none">
              <CardContent className="p-3 space-y-3">
                <div>
                  <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
                    {t("master.workCalendar.year")}
                  </label>
                  <Input value={year} onChange={(e) => setYear(e.target.value)} maxLength={4} fullWidth />
                </div>
                <div>
                  <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
                    {t("master.workCalendar.line")}
                  </label>
                  <LineSelect value={lineCode} onChange={setLineCode} fullWidth />
                  <p className="mt-1 text-xs text-text-muted dark:text-gray-400">
                    {lineCode
                      ? t("master.workCalendar.lineModeHint")
                      : t("master.workCalendar.companyModeHint")}
                  </p>
                </div>
              </CardContent>
            </Card>

            {summary && (
              <Card padding="none">
                <CardContent className="p-3 space-y-1.5 text-sm">
                  <div className="flex justify-between">
                    <span className="text-text-muted dark:text-gray-400">{t("master.workCalendar.workDays")}</span>
                    <b className="text-blue-600 dark:text-blue-400">{summary.workDays}</b>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-text-muted dark:text-gray-400">{t("master.workCalendar.offDays")}</span>
                    <b className="text-red-500 dark:text-red-400">{summary.offDays}</b>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-text-muted dark:text-gray-400">{t("master.workCalendar.halfDays")}</span>
                    <b className="text-yellow-600 dark:text-yellow-400">{summary.halfDays}</b>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-text-muted dark:text-gray-400">{t("master.workCalendar.specialDays")}</span>
                    <b className="text-green-600 dark:text-green-400">{summary.specialDays}</b>
                  </div>
                  <div className="flex justify-between border-t border-border dark:border-gray-700 pt-1.5">
                    <span className="text-text-muted dark:text-gray-400">{t("master.workCalendar.totalMinutes")}</span>
                    <b className="text-text dark:text-gray-200">{summary.totalMinutes.toLocaleString()}</b>
                  </div>
                </CardContent>
              </Card>
            )}
          </div>

          {/* 우측: 월 그리드 */}
          <div className="col-span-9 flex flex-col min-h-0">
            <Card padding="none" className="flex-1 flex flex-col min-h-0">
              <CardContent className="flex-1 flex flex-col min-h-0 p-4 overflow-y-auto">
                {loading ? (
                  <div className="flex justify-center py-8">
                    <RefreshCw className="w-5 h-5 text-primary animate-spin" />
                  </div>
                ) : (
                  <CalendarGrid
                    month={currentMonth}
                    days={days}
                    onDayClick={(date, day) => setEditingDay({ date, data: day })}
                    onMonthChange={setCurrentMonth}
                  />
                )}
              </CardContent>
            </Card>
          </div>
        </div>
      ) : (
        <div className="flex-1 min-h-0 overflow-y-auto">
          <ShiftTimeTab shiftTimes={shiftTimes} onRefresh={fetchShiftTimes} />
        </div>
      )}

      <DayEditModal
        isOpen={editingDay !== null}
        onClose={() => setEditingDay(null)}
        selectedDate={editingDay?.date ?? null}
        currentData={editingDay?.data ?? null}
        onSave={handleDaySave}
      />

      <ConfirmModal
        isOpen={topAction === "generate"}
        onClose={() => setTopAction(null)}
        onConfirm={handleGenerate}
        title={t("master.workCalendar.generateYear")}
        message={
          <div>
            <p className="mb-3">{t("master.workCalendar.confirmMsg.generate")}</p>
            <div className="space-y-2">
              <label className="flex items-center gap-2 text-sm text-text dark:text-gray-200 cursor-pointer">
                <input type="checkbox" checked={genSatWork} onChange={(e) => setGenSatWork(e.target.checked)}
                  className="rounded border-border dark:border-gray-600" />
                {t("master.workCalendar.saturdayWork")}
              </label>
              <label className="flex items-center gap-2 text-sm text-text dark:text-gray-200 cursor-pointer">
                <input type="checkbox" checked={genSunWork} onChange={(e) => setGenSunWork(e.target.checked)}
                  className="rounded border-border dark:border-gray-600" />
                {t("master.workCalendar.sundayWork")}
              </label>
            </div>
          </div>
        }
      />

      <ConfirmModal
        isOpen={topAction === "copy"}
        onClose={() => setTopAction(null)}
        onConfirm={handleCopyFromCompany}
        title={t("master.workCalendar.copyFromCompany")}
        message={t("master.workCalendar.confirmMsg.copy")}
      />

      <ConfirmModal
        isOpen={topAction === "confirm"}
        onClose={() => setTopAction(null)}
        onConfirm={() => handleConfirm(true)}
        title={t("master.workCalendar.confirm")}
        message={t("master.workCalendar.confirmMsg.confirm")}
      />

      <ConfirmModal
        isOpen={topAction === "unconfirm"}
        onClose={() => setTopAction(null)}
        onConfirm={() => handleConfirm(false)}
        title={t("master.workCalendar.unconfirm")}
        message={t("master.workCalendar.confirmMsg.unconfirm")}
        variant="danger"
      />
    </div>
  );
}
```

- [ ] **Step 5: 커밋** (이 시점엔 `DayEditModal`/`ShiftTimeTab`이 아직 구버전이라 typecheck가 깨진다 — Task 8과 함께 검증한다)

```bash
git add "apps/frontend/src/app/(authenticated)/master/work-calendar"
git commit -m "feat(work-calendar): 프론트 페이지를 IP_ 모델(전사+라인 예외)로 재작성"
```

---

## Task 8: 프론트 — `DayEditModal` 교체 + `ShiftTimeTab` 신규

**Files:**
- Modify (전면 교체): `.../work-calendar/components/DayEditModal.tsx`
- Create: `.../work-calendar/components/ShiftTimeTab.tsx`
- Modify: `.../work-calendar/components/WorkCalendarFieldHelp.tsx`

**Interfaces:**
- Consumes: `WorkCalendarDay`, `ShiftTimeItem` (Task 7 `types.ts`), `defaultWorkMinutes` (`@smt/shared`)
- Produces: 없음 (말단 컴포넌트)

- [ ] **Step 1: `DayEditModal` 전면 교체**

```tsx
"use client";

/**
 * @file master/work-calendar/components/DayEditModal.tsx
 * @description 일자 편집 모달 — 근무유형/휴무사유/근무분/잔업분/비고
 *
 * 초보자 가이드:
 * 1. 근무유형·휴무사유는 자유입력이 아니라 공통코드(WORK_DAY_TYPE / DAY_OFF_TYPE)다.
 * 2. 휴무사유는 dayType='OFF'일 때만 노출된다.
 * 3. 근무분은 근무유형이 바뀔 때 @smt/shared의 규칙으로 자동 채워지고, 사용자가 덮어쓸 수 있다.
 */
import { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { Modal, Button, Input } from "@/components/ui";
import { ComCodeSelect } from "@/components/shared";
import type { WorkCalendarDay, WorkDayType } from "../types";

interface Props {
  isOpen: boolean;
  onClose: () => void;
  selectedDate: string | null;
  currentData: WorkCalendarDay | null;
  onSave: (day: Partial<WorkCalendarDay> & { workDate: string }) => void;
}

export default function DayEditModal({ isOpen, onClose, selectedDate, currentData, onSave }: Props) {
  const { t } = useTranslation();

  const [dayType, setDayType] = useState<WorkDayType>("WORK");
  const [offReason, setOffReason] = useState("");
  const [workMinutes, setWorkMinutes] = useState("0");
  const [otMinutes, setOtMinutes] = useState("0");
  const [comment, setComment] = useState("");

  useEffect(() => {
    if (!isOpen) return;
    setDayType((currentData?.dayType as WorkDayType) ?? "WORK");
    setOffReason(currentData?.offReason ?? "");
    setWorkMinutes(String(currentData?.workMinutes ?? 0));
    setOtMinutes(String(currentData?.otMinutes ?? 0));
    setComment(currentData?.comment ?? "");
  }, [isOpen, currentData]);

  if (!selectedDate) return null;

  const handleSave = () => {
    const payload: Partial<WorkCalendarDay> & { workDate: string } = {
      workDate: selectedDate,
      dayType,
      offReason: dayType === "OFF" ? (offReason || null) : null,
      otMinutes: Number(otMinutes) || 0,
      comment: comment || null,
    };
    // 근무분을 비우면 키를 보내지 않아 서버가 교대시간 마스터에서 파생시킨다(Task 5 buildRow).
    if (workMinutes !== "") payload.workMinutes = Number(workMinutes) || 0;
    onSave(payload);
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title={`${t("master.workCalendar.editDay")} — ${selectedDate}`}>
      <div className="space-y-4">
        <div>
          <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
            {t("master.workCalendar.dayType")}
          </label>
          <ComCodeSelect
            groupCode="WORK_DAY_TYPE"
            includeAll={false}
            value={dayType}
            onChange={(v) => setDayType(v as WorkDayType)}
            fullWidth
          />
        </div>

        {dayType === "OFF" && (
          <div>
            <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
              {t("master.workCalendar.offReason")}
            </label>
            <ComCodeSelect
              groupCode="DAY_OFF_TYPE"
              includeAll={false}
              value={offReason}
              onChange={setOffReason}
              fullWidth
            />
          </div>
        )}

        <div className="grid grid-cols-2 gap-3">
          <div>
            <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
              {t("master.workCalendar.workMinutes")}
            </label>
            <Input type="number" min={0} value={workMinutes}
              onChange={(e) => setWorkMinutes(e.target.value)} fullWidth />
          </div>
          <div>
            <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
              {t("master.workCalendar.otMinutes")}
            </label>
            <Input type="number" min={0} value={otMinutes}
              onChange={(e) => setOtMinutes(e.target.value)} fullWidth />
          </div>
        </div>

        <div>
          <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
            {t("master.workCalendar.remark")}
          </label>
          <Input value={comment} onChange={(e) => setComment(e.target.value)} fullWidth />
        </div>

        <div className="flex justify-end gap-2 pt-2">
          <Button variant="secondary" onClick={onClose}>{t("common.cancel")}</Button>
          <Button onClick={handleSave}>{t("common.save")}</Button>
        </div>
      </div>
    </Modal>
  );
}
```

> **근무분 파생 규약:** 모달은 근무분 입력이 비어 있으면(`""`) `workMinutes` 키를 **아예 보내지 않는다.** 그러면 서버(`buildRow`, Task 5)가 교대시간 마스터에서 파생시킨다. 값을 넣으면 그 값이 override로 저장된다. 이 때문에 `workMinutes` 상태의 초기값은 `"0"`이 아니라 기존 값이며, 사용자가 지우면 자동 파생으로 돌아간다.

- [ ] **Step 2: `ShiftTimeTab` 신규**

`.../work-calendar/components/ShiftTimeTab.tsx`:

```tsx
"use client";

/**
 * @file master/work-calendar/components/ShiftTimeTab.tsx
 * @description 2교대 시간 마스터 탭 — 유효기간(DATESET~DATEEND) 행 CRUD
 *
 * 초보자 가이드:
 * 1. 유효기간이 겹치면 서버가 409로 거부한다.
 * 2. 야간은 자정을 넘길 수 있다(20:00~08:00). 순근무분은 @smt/shared가 계산한다.
 */
import { useCallback, useState } from "react";
import { useTranslation } from "react-i18next";
import { Plus, Pencil, Trash2 } from "lucide-react";
import { Card, CardContent, Button, Input, Modal, ConfirmModal } from "@/components/ui";
import { shiftNetMinutes } from "@smt/shared";
import api from "@/services/api";
import type { ShiftTimeItem } from "../types";

interface Props {
  shiftTimes: ShiftTimeItem[];
  onRefresh: () => void;
}

const EMPTY: ShiftTimeItem = {
  dateset: "",
  dateend: null,
  dayTimeStart: "08:00",
  dayTimeEnd: "20:00",
  dayBreakMinutes: 60,
  nightTimeStart: "20:00",
  nightTimeEnd: "08:00",
  nightBreakMinutes: 60,
};

function netOf(start: string | null, end: string | null, breakMinutes: number): number {
  if (!start || !end) return 0;
  return shiftNetMinutes({ start, end, breakMinutes });
}

export default function ShiftTimeTab({ shiftTimes, onRefresh }: Props) {
  const { t } = useTranslation();
  const [form, setForm] = useState<ShiftTimeItem | null>(null);
  const [isEdit, setIsEdit] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState<string | null>(null);

  const handleSave = useCallback(async () => {
    if (!form) return;
    try {
      if (isEdit) {
        await api.put(`/master/shift-times/${form.dateset}`, {
          dateend: form.dateend,
          dayTimeStart: form.dayTimeStart,
          dayTimeEnd: form.dayTimeEnd,
          dayBreakMinutes: form.dayBreakMinutes,
          nightTimeStart: form.nightTimeStart,
          nightTimeEnd: form.nightTimeEnd,
          nightBreakMinutes: form.nightBreakMinutes,
        });
      } else {
        await api.post("/master/shift-times", form);
      }
      setForm(null);
      onRefresh();
    } catch { /* interceptor */ }
  }, [form, isEdit, onRefresh]);

  const handleDelete = useCallback(async () => {
    if (!deleteTarget) return;
    try {
      await api.delete(`/master/shift-times/${deleteTarget}`);
      setDeleteTarget(null);
      onRefresh();
    } catch { /* interceptor */ }
  }, [deleteTarget, onRefresh]);

  return (
    <Card padding="none">
      <CardContent className="p-4">
        <div className="flex justify-between items-center mb-3">
          <h2 className="text-sm font-bold text-text dark:text-gray-100">
            {t("master.workCalendar.shiftTimes")}
          </h2>
          <Button size="sm" onClick={() => { setForm({ ...EMPTY }); setIsEdit(false); }}>
            <Plus className="w-4 h-4 mr-1" />{t("common.add")}
          </Button>
        </div>

        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-border dark:border-gray-700 text-text-muted dark:text-gray-400">
              <th className="py-2 text-left">{t("master.workCalendar.dateset")}</th>
              <th className="py-2 text-left">{t("master.workCalendar.dateend")}</th>
              <th className="py-2 text-left">{t("master.workCalendar.dayShift")}</th>
              <th className="py-2 text-right">{t("master.workCalendar.dayNet")}</th>
              <th className="py-2 text-left">{t("master.workCalendar.nightShift")}</th>
              <th className="py-2 text-right">{t("master.workCalendar.nightNet")}</th>
              <th className="py-2 text-right">{t("common.actions")}</th>
            </tr>
          </thead>
          <tbody>
            {shiftTimes.length === 0 ? (
              <tr><td colSpan={7} className="py-8 text-center text-text-muted dark:text-gray-400">
                {t("common.noData")}
              </td></tr>
            ) : shiftTimes.map((s) => (
              <tr key={s.dateset} className="border-b border-border dark:border-gray-700">
                <td className="py-2">{s.dateset}</td>
                <td className="py-2">{s.dateend ?? "—"}</td>
                <td className="py-2">{s.dayTimeStart} ~ {s.dayTimeEnd} (휴식 {s.dayBreakMinutes}분)</td>
                <td className="py-2 text-right">{netOf(s.dayTimeStart, s.dayTimeEnd, s.dayBreakMinutes)}</td>
                <td className="py-2">
                  {s.nightTimeStart ? `${s.nightTimeStart} ~ ${s.nightTimeEnd} (휴식 ${s.nightBreakMinutes}분)` : "—"}
                </td>
                <td className="py-2 text-right">{netOf(s.nightTimeStart, s.nightTimeEnd, s.nightBreakMinutes)}</td>
                <td className="py-2 text-right">
                  <button onClick={() => { setForm({ ...s }); setIsEdit(true); }}
                    className="p-1 rounded hover:bg-primary/10 text-primary">
                    <Pencil className="w-3.5 h-3.5" />
                  </button>
                  <button onClick={() => setDeleteTarget(s.dateset)}
                    className="p-1 rounded hover:bg-red-100 dark:hover:bg-red-900/30 text-red-500">
                    <Trash2 className="w-3.5 h-3.5" />
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </CardContent>

      <Modal isOpen={form !== null} onClose={() => setForm(null)}
        title={isEdit ? t("master.workCalendar.editShiftTime") : t("master.workCalendar.addShiftTime")}>
        {form && (
          <div className="space-y-3">
            <div className="grid grid-cols-2 gap-3">
              <div>
                <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
                  {t("master.workCalendar.dateset")}
                </label>
                <Input type="date" value={form.dateset} disabled={isEdit}
                  onChange={(e) => setForm({ ...form, dateset: e.target.value })} fullWidth />
              </div>
              <div>
                <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
                  {t("master.workCalendar.dateend")}
                </label>
                <Input type="date" value={form.dateend ?? ""}
                  onChange={(e) => setForm({ ...form, dateend: e.target.value || null })} fullWidth />
              </div>
            </div>

            <div className="grid grid-cols-3 gap-3">
              <Input type="time" value={form.dayTimeStart ?? ""}
                onChange={(e) => setForm({ ...form, dayTimeStart: e.target.value || null })} fullWidth />
              <Input type="time" value={form.dayTimeEnd ?? ""}
                onChange={(e) => setForm({ ...form, dayTimeEnd: e.target.value || null })} fullWidth />
              <Input type="number" min={0} value={String(form.dayBreakMinutes)}
                onChange={(e) => setForm({ ...form, dayBreakMinutes: Number(e.target.value) || 0 })} fullWidth />
            </div>

            <div className="grid grid-cols-3 gap-3">
              <Input type="time" value={form.nightTimeStart ?? ""}
                onChange={(e) => setForm({ ...form, nightTimeStart: e.target.value || null })} fullWidth />
              <Input type="time" value={form.nightTimeEnd ?? ""}
                onChange={(e) => setForm({ ...form, nightTimeEnd: e.target.value || null })} fullWidth />
              <Input type="number" min={0} value={String(form.nightBreakMinutes)}
                onChange={(e) => setForm({ ...form, nightBreakMinutes: Number(e.target.value) || 0 })} fullWidth />
            </div>

            <div className="flex justify-end gap-2 pt-2">
              <Button variant="secondary" onClick={() => setForm(null)}>{t("common.cancel")}</Button>
              <Button onClick={handleSave} disabled={!form.dateset}>{t("common.save")}</Button>
            </div>
          </div>
        )}
      </Modal>

      <ConfirmModal isOpen={deleteTarget !== null} onClose={() => setDeleteTarget(null)}
        onConfirm={handleDelete} title={t("common.delete")}
        message={t("master.workCalendar.deleteShiftTimeMsg")} variant="danger" />
    </Card>
  );
}
```

- [ ] **Step 3: `WorkCalendarFieldHelp` DB 매핑 교체**

기존 `WORK_CALENDAR_FIELD_HELP` 맵의 항목을 IP_ 컬럼으로 교체한다.

```ts
export const WORK_CALENDAR_FIELD_HELP = {
  // 전사 월력 (IP_PRODUCT_COMPANY_CALENDAR) / 라인 예외 (IP_PRODUCT_LINE_CALENDAR)
  dayType: { db: "IP_PRODUCT_COMPANY_CALENDAR.DAY_TYPE", description: "근무/휴무/반일/특근 구분입니다. 휴무(OFF)로 지정하면 HOLIDAY_YN이 'Y'로 함께 설정됩니다." },
  offReason: { db: "IP_PRODUCT_COMPANY_CALENDAR.OFF_REASON", description: "휴무 사유입니다. 근무유형이 휴무일 때만 입력합니다." },
  workMinutes: { db: "IP_PRODUCT_COMPANY_CALENDAR.WORK_MINUTES", description: "그날의 순근무분입니다. 비워두면 교대시간 마스터에서 자동 계산됩니다." },
  otMinutes: { db: "IP_PRODUCT_COMPANY_CALENDAR.OT_MINUTES", description: "그날의 잔업분입니다." },
  confirmYn: { db: "IP_PRODUCT_COMPANY_CALENDAR.CONFIRM_YN", description: "확정 여부입니다. 확정된 일자는 수정·생성·복사가 차단됩니다." },
  comment: { db: "IP_PRODUCT_COMPANY_CALENDAR.CALENDAR_COMMENT", description: "월력 비고입니다." },
  lineCode: { db: "IP_PRODUCT_LINE_CALENDAR.LINE_CODE", description: "라인 예외 월력의 대상 라인입니다. 해당 (일자, 라인) 행이 있으면 전사 월력을 덮어씁니다." },

  // 교대시간 (IP_SHIFT_TIME_MASTER)
  dateset: { db: "IP_SHIFT_TIME_MASTER.DATESET", description: "교대시간 적용 시작일입니다. 등록 후에는 변경할 수 없습니다." },
  dateend: { db: "IP_SHIFT_TIME_MASTER.DATEEND", description: "교대시간 적용 종료일입니다. 비우면 무기한입니다." },
  dayTimeStart: { db: "IP_SHIFT_TIME_MASTER.DAY_TIME_START", description: "주간 교대 시작 시각입니다." },
  dayTimeEnd: { db: "IP_SHIFT_TIME_MASTER.DAY_TIME_END", description: "주간 교대 종료 시각입니다." },
  dayBreakMinutes: { db: "IP_SHIFT_TIME_MASTER.DAY_BREAK_MINUTES", description: "주간 교대의 휴식시간(분)입니다. 순근무분 계산에서 차감됩니다." },
  nightTimeStart: { db: "IP_SHIFT_TIME_MASTER.NIGHT_TIME_START", description: "야간 교대 시작 시각입니다. 자정을 넘길 수 있습니다." },
  nightTimeEnd: { db: "IP_SHIFT_TIME_MASTER.NIGHT_TIME_END", description: "야간 교대 종료 시각입니다." },
  nightBreakMinutes: { db: "IP_SHIFT_TIME_MASTER.NIGHT_BREAK_MINUTES", description: "야간 교대의 휴식시간(분)입니다." },
} as const;
```

- [ ] **Step 4: 프론트 타입체크**

```bash
pnpm --filter @eunsung/frontend exec tsc --noEmit --pretty false
```

Expected: 통과. 실패하면 대개 (a) `@smt/shared` dist 미빌드(Task 2 Step 7 재실행), (b) `.next/` 캐시의 stale 생성 타입 — `rm -rf apps/frontend/.next` 후 재시도.

- [ ] **Step 5: 커밋**

```bash
git add "apps/frontend/src/app/(authenticated)/master/work-calendar"
git commit -m "feat(work-calendar): 일자편집 모달 재작성, 교대시간 탭 추가"
```

---

## Task 9: 로케일 + 구조테스트

**Files:**
- Modify: `apps/frontend/src/locales/{ko,en,vi,zh}.json`
- Create: `.../master/work-calendar/work-calendar.eunsung.structure.test.mjs`

- [ ] **Step 1: `master.workCalendar` 키 교체 (ko)**

제거할 키(HANES 모델 잔재): `calendarId`, `calendarYear`, `processCd`, `allProcesses`, `defaultShiftCount`, `defaultShifts`, `status`, `shiftCount`, `shifts`, `shiftPattern`, `shiftPatternTab`, `shiftPatterns`, `shiftCode`, `shiftName`, `startTime`, `endTime`, `breakMinutes`, `breakMin`, `workMin`, `addCalendar`, `deleteCalendarMsg`, `selectCalendar`, `sourceCalendar`, `addShift`, `editShift`, `deleteShiftMsg`, `copyFrom`, `calendarManagement`(유지), `confirmMsg.copy`(문구 교체).

추가/유지할 키 (ko 기준):

```json
    "workCalendar": {
      "title": "생산월력관리",
      "subtitle": "전사 근무일과 라인별 예외, 2교대 근무시간을 관리합니다.",
      "calendarManagement": "월력",
      "shiftTimeTab": "교대시간",
      "year": "연도",
      "line": "라인",
      "companyModeHint": "전사 월력을 편집합니다.",
      "lineModeHint": "이 라인의 예외만 편집합니다. 예외가 없는 날은 전사 월력을 따릅니다.",
      "generateYear": "연간 생성",
      "copyFromCompany": "전사에서 복사",
      "confirm": "확정",
      "unconfirm": "확정취소",
      "editDay": "일자 편집",
      "dayType": "근무유형",
      "offReason": "휴무사유",
      "workMinutes": "근무시간(분)",
      "otMinutes": "잔업시간(분)",
      "remark": "비고",
      "workDays": "가동일수",
      "offDays": "비가동일수",
      "halfDays": "반일",
      "specialDays": "특근",
      "totalMinutes": "총가용시간(분)",
      "saturdayWork": "토요일 근무",
      "sundayWork": "일요일 근무",
      "shiftTimes": "교대시간 목록",
      "dateset": "적용 시작일",
      "dateend": "적용 종료일",
      "dayShift": "주간",
      "nightShift": "야간",
      "dayNet": "주간 순근무(분)",
      "nightNet": "야간 순근무(분)",
      "addShiftTime": "교대시간 등록",
      "editShiftTime": "교대시간 수정",
      "deleteShiftTimeMsg": "이 교대시간을 삭제하시겠습니까?",
      "confirmMsg": {
        "generate": "해당 연도의 월력을 생성합니다. 기존 일자는 덮어써집니다. 주말과 양력 고정공휴일만 자동 휴무 처리되며, 설·추석·대체공휴일은 직접 수정해야 합니다.",
        "copy": "전사 월력을 이 라인으로 복사합니다. 이 라인의 기존 예외는 덮어써집니다.",
        "confirm": "해당 연도의 월력을 확정합니다. 확정 후에는 수정할 수 없습니다.",
        "unconfirm": "확정을 취소하고 다시 수정할 수 있게 합니다."
      }
    },
```

en/vi/zh도 같은 키 집합으로 각 언어에 맞게 번역해 교체한다. **en/vi/zh 파일에 한국어를 남기지 않는다.**

- [ ] **Step 2: 구조테스트 작성**

`.../master/work-calendar/work-calendar.eunsung.structure.test.mjs`:

```js
import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

const root = new URL('../../../../../', import.meta.url);
const read = (p) => fs.readFileSync(new URL(p, root), 'utf8');

test('work calendar page is fully registered', () => {
  for (const [p, r] of [
    ['src/config/menuConfig.ts', /MST_WORK_CALENDAR/],
    ['../backend/src/seeds/menu-config.json', /MST_WORK_CALENDAR/],
    ['../backend/src/modules/menu-categories/utils/menu-code-validator.ts', /MST_WORK_CALENDAR/],
    ['../backend/src/modules/menu-categories/utils/default-menu-category-layout.ts', /MST_WORK_CALENDAR/],
  ]) {
    assert.match(read(p), r);
  }
});

test('work calendar uses the IP_ calendar model, not the HANES model', () => {
  const backend = [
    '../backend/src/entities/product-company-calendar.entity.ts',
    '../backend/src/entities/product-line-calendar.entity.ts',
    '../backend/src/entities/shift-time-master.entity.ts',
  ].map(read).join('\n');

  assert.match(backend, /IP_PRODUCT_COMPANY_CALENDAR/);
  assert.match(backend, /IP_PRODUCT_LINE_CALENDAR/);
  assert.match(backend, /IP_SHIFT_TIME_MASTER/);

  // HOLIDAY_YN은 F_GET_DELIVERY_DATE가 읽으므로 유지돼야 한다.
  assert.match(backend, /HOLIDAY_YN/);

  // HANES 모델이 되살아나면 안 된다.
  for (const forbidden of ['WORK_CALENDARS', 'WORK_CALENDAR_DAYS', 'SHIFT_PATTERNS']) {
    assert.ok(!backend.includes(forbidden), `${forbidden}가 다시 등장했습니다`);
  }
});

test('work calendar frontend calls only the approved API paths', () => {
  const front = [
    'src/app/(authenticated)/master/work-calendar/page.tsx',
    'src/app/(authenticated)/master/work-calendar/components/ShiftTimeTab.tsx',
    'src/app/(authenticated)/master/work-calendar/components/DayEditModal.tsx',
    'src/app/(authenticated)/master/work-calendar/types.ts',
  ].map(read).join('\n');

  assert.match(front, /\/master\/work-calendar\/days/);
  assert.match(front, /\/master\/work-calendar\/generate/);
  assert.match(front, /\/master\/work-calendar\/copy-from-company/);
  assert.match(front, /\/master\/shift-times/);

  // 구 API/모델 잔재 금지
  assert.ok(!front.includes('/master/work-calendars'), '구 복수형 API 경로가 남아 있습니다');
  assert.ok(!front.includes('/master/shift-patterns'), '구 교대패턴 API가 남아 있습니다');
  assert.ok(!front.includes('calendarId'), 'HANES 캘린더 헤더 개념이 남아 있습니다');

  // 코드성 값은 공통코드로
  assert.match(front, /WORK_DAY_TYPE/);
  assert.match(front, /DAY_OFF_TYPE/);
});

test('day type / holiday_yn 불변식이 shared에 한 번만 정의된다', () => {
  const rules = read('../../packages/shared/src/work-calendar/work-calendar-rules.ts');
  assert.match(rules, /export function holidayYnOf/);
  assert.match(rules, /export function defaultWorkMinutes/);

  const service = read('../backend/src/modules/master/services/work-calendar.service.ts');
  assert.match(service, /holidayYnOf/);
  assert.match(service, /defaultWorkMinutes/);
  // 서비스가 자체 계산식을 다시 갖고 있으면 안 된다.
  assert.ok(!/dayType === 'OFF' \? 'Y' : 'N'/.test(service), 'HOLIDAY_YN 파생이 서비스에 복붙돼 있습니다');
});
```

- [ ] **Step 3: 구조테스트 실행**

```bash
node --test "apps/frontend/src/app/(authenticated)/master/work-calendar/work-calendar.eunsung.structure.test.mjs"
```

Expected: 4 tests PASS. (CWD는 repo 루트여야 한다 — 경로가 루트 기준.)

- [ ] **Step 4: 프론트 전체 테스트 + 타입체크**

```bash
pnpm --filter @eunsung/frontend test
pnpm --filter @eunsung/frontend exec tsc --noEmit --pretty false
```

Expected: 모두 PASS. `Page registration OK`가 출력돼야 한다.

- [ ] **Step 5: 커밋**

```bash
git add apps/frontend/src/locales "apps/frontend/src/app/(authenticated)/master/work-calendar"
git commit -m "feat(work-calendar): 로케일 키를 IP_ 모델로 교체, 구조테스트 추가"
```

---

## Task 10: 도움말 문서 재작성 + 실화면 검증

**Files:**
- Modify: `apps/frontend/public/help/user/ko/MST_WORK_CALENDAR.md`
- Modify: `apps/frontend/public/help/operator/ko/MST_WORK_CALENDAR.md`

- [ ] **Step 1: 사용자 도움말 재작성**

기존 문서는 HANES 모델(캘린더 ID·교대패턴·공정별 월력) 기준이라 전부 틀렸다. 아래 구조로 다시 쓴다.

- 화면 목적: 전사 근무일과 라인별 예외, 2교대 근무시간 관리
- 화면 구성: 월력 탭(연도·라인 선택 → 월 그리드 → 일자 편집) / 교대시간 탭
- 컬럼·필드 표: 근무유형(WORK/OFF/HALF/SPECIAL), 휴무사유, 근무시간(분), 잔업시간(분), 비고 / 적용 시작일·종료일, 주간·야간 시작·종료·휴식
- 사용 순서: ① 교대시간 등록 → ② 연간 생성 → ③ 공휴일·특근 수동 보정 → ④ 라인 예외 지정 → ⑤ 확정
- 입력 규칙: 확정된 일자는 수정 불가 / 연간 생성과 복사는 덮어쓰기 / 근무시간을 비우면 교대시간에서 자동 계산 / 휴무사유는 휴무일 때만 / 양력 고정공휴일만 자동 반영(설·추석·대체공휴일은 수동)
- FAQ: 라인 예외를 지우면? 전사 월력을 따른다 / 근무시간이 0으로 나온다? 교대시간 마스터 미등록

- [ ] **Step 2: 운영자 도움말 재작성**

- 데이터 구조: `IP_PRODUCT_COMPANY_CALENDAR`(PK: PLAN_DATE + ORGANIZATION_ID) / `IP_PRODUCT_LINE_CALENDAR`(+ LINE_CODE) / `IP_SHIFT_TIME_MASTER`(PK: ORGANIZATION_ID + DATESET)
- **`HOLIDAY_YN` 주의**: `DAY_TYPE`의 미러이며 PL/SQL `F_GET_DELIVERY_DATE`(납기일 계산)가 읽는다. 직접 수정하지 말 것. DB CHECK 제약 `CK_IPCC_HOLIDAY_SYNC` / `CK_IPLC_HOLIDAY_SYNC`가 정합을 강제한다.
- API 목록, 병합 규칙(라인 우선), 근무분 파생식, 확정 잠금
- 공통코드 선행: `WORK DAY TYPE`, `DAY OFF TYPE`
- 트러블슈팅: 409 확정 잠금 / 409 교대시간 기간 겹침 / 근무분 0(교대시간 미등록) / 라인 목록 빔(`IP_PRODUCT_LINE` 미등록)

- [ ] **Step 3: 실화면 검증 (claude-in-chrome)**

사용자가 dev 서버를 띄운 상태에서 `http://localhost:3100/master/work-calendar`를 연다. 확인 항목:

1. 교대시간 탭에서 `2026-01-01 ~ (무기한)`, 주간 `08:00~20:00` 휴식 60, 야간 `20:00~08:00` 휴식 60을 등록 → 목록에 주간/야간 순근무 `660` 표시.
2. 월력 탭에서 연도 `2026`, 라인 "전사" → **연간 생성** → 토/일이 빨간 OFF, 3/1·5/5 등이 OFF로 표시.
3. 평일 셀 클릭 → 근무유형 `특근`으로 변경 후 저장 → 셀이 초록으로 바뀌고 좌측 요약의 특근 수가 증가.
4. 라인을 하나 선택 → 특정 일자를 OFF로 저장 → 셀에 "예외" 뱃지.
5. **확정** → 셀에 잠금 아이콘, 클릭해도 모달이 열리지 않음. 다시 연간 생성 시도 → 409 토스트.

- [ ] **Step 4: 커밋**

```bash
git add apps/frontend/public/help
git commit -m "docs(work-calendar): 도움말을 IP_ 월력 모델 기준으로 재작성"
```

---

## Self-Review 결과

**스펙 커버리지**

| 스펙 항목 | 태스크 |
|---|---|
| §4.1 COMPANY/LINE 컬럼 보강 + CHECK | Task 1 |
| §4.2 SHIFT_TIME PK + 휴식분 | Task 1 |
| §4.3 공통코드 시드 | Task 6 |
| §5 shared 규칙 (근무분·HOLIDAY_YN·고정공휴일) | Task 2 |
| §5 월력 병합 (라인 우선) | Task 5 (findDays) |
| §5 연간 생성 (주말·공휴일·덮어쓰기) | Task 5 (generateYear) |
| §5 확정 잠금 | Task 5 (ensureNotConfirmed) |
| §6 API 7종 + 교대시간 4종 | Task 5 |
| §6 모듈 배선 (shift 컨트롤러 누락 재발 방지) | Task 5 Step 7 |
| §7 프론트 (연도·라인, 그리드, 모달, 교대탭) | Task 7·8 |
| §8 테스트 3계층 | Task 2·4·5·9 |
| §9 라인 마스터 실데이터 확인 | Task 0 |
| 폐기: HANES 엔티티·서비스·컨트롤러·컴포넌트 | Task 3·4·5·7 |

**미커버(의도적, 스펙 §9의 후속)**: `OEE_PLAN_TIME` 파생, en/vi/zh 도움말.

**타입 일관성**: `WorkDayType`(Task 2) → 엔티티 `dayType: string` + 서비스 캐스팅(Task 3·5) → `WorkCalendarDayView`(Task 5) → 프론트 `WorkCalendarDay`(Task 7) → 모달/그리드(Task 7·8)에서 동일 필드명(`workDate`·`dayType`·`offReason`·`workMinutes`·`otMinutes`·`comment`·`confirmYn`·`source`)을 쓴다. `ShiftTimeMasterLike`(Task 2)의 필드명은 엔티티 `ShiftTimeMaster`(Task 3)와 프론트 `ShiftTimeItem`(Task 7)에서 동일하다.
