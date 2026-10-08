/**
 * @file src/modules/inventory-query/close-period.ts
 * @description 재고마감 기간 — 월별 마감 시작일~종료일을 미리 정해 두고 그 기간을 그 달 마감으로 본다
 *
 * 초보자 가이드:
 * 1. **마감 기간은 달력 월이 아니다.** 마감 기간은 `ISYS_INVENTORY_CLOSE_DATE` 에 월(YYYYMM)마다
 *    시작일·종료일로 미리 등록한다 (재고마감일자설정 화면). 예: 26일~다음 달 25일.
 *    종료일은 그날 끝까지 포함한다 — 구간은 `[시작일 0시, 종료일 다음 날 0시)` 이다.
 * 2. 등록된 기간이 없는 달은 달력 월(1일~말일)로 본다 (`F_GET_INVENTORY_CLOSE_DATE` 와 같다).
 * 3. 마감은 입출고 **날짜**로 그 기간 것만 모으므로, 기간이 끝난 뒤의 입출고는 다음 달 몫이고
 *    마감 중에도 생산을 멈출 필요가 없다. "그 달이 끝났다" 도 이 기간의 종료일로 판단한다.
 * 4. 실사 조정은 기간의 종료일 날짜로 들어간다 (`F_GET_INVENTORY_CLOSE_DATE(…, 'END')`) — 그래야 그 달 수불에 잡힌다.
 */
import { DataSource, QueryRunner } from 'typeorm';
import { namedBinds } from '../../common/utils/named-binds.util';

type Queryable = Pick<DataSource, 'query'> | Pick<QueryRunner, 'query'>;

/** YYYYMM ± n 개월 */
export const shiftMonth = (yyyymm: string, n: number) => {
  const d = new Date(Number(yyyymm.slice(0, 4)), Number(yyyymm.slice(4, 6)) - 1 + n, 1);
  return `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}`;
};

const calendarStart = (yyyymm: string) => `${yyyymm.slice(0, 4)}-${yyyymm.slice(4, 6)}-01`;

export interface ClosePeriod {
  yyyymm: string;
  /** 시작일 (YYYY-MM-DD, 그날 0시부터) */
  start: string;
  /** 종료일 (YYYY-MM-DD, 그날 끝까지 포함) */
  end: string;
  /** 종료일 다음 날 (YYYY-MM-DD) — 집계는 `< endExclusive` 로 한다 */
  endExclusive: string;
  /** 마감일자설정에 등록된 기간인가 (아니면 달력 월) */
  registered: boolean;
}

const pad = (n: number) => String(n).padStart(2, '0');
const ymd = (d: Date) => `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;

/** 그 달의 마감 기간. 등록이 없으면 달력 월. */
export async function getClosePeriod(q: Queryable, yyyymm: string, organizationId: number): Promise<ClosePeriod> {
  const rows = (await q.query(
    `SELECT TO_CHAR(TRUNC(START_DATE), 'YYYY-MM-DD') AS "s", TO_CHAR(TRUNC(END_DATE), 'YYYY-MM-DD') AS "e",
            TO_CHAR(TRUNC(END_DATE) + 1, 'YYYY-MM-DD') AS "x"
       FROM ISYS_INVENTORY_CLOSE_DATE
      WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
    namedBinds({ yyyymm, organizationId }),
  )) as { s: string; e: string; x: string }[];
  if (rows[0]?.s && rows[0]?.e) {
    return { yyyymm, start: rows[0].s, end: rows[0].e, endExclusive: rows[0].x, registered: true };
  }
  const nextFirst = calendarStart(shiftMonth(yyyymm, 1));
  const last = new Date(`${nextFirst}T00:00:00`);
  last.setDate(last.getDate() - 1);
  return { yyyymm, start: calendarStart(yyyymm), end: ymd(last), endExclusive: nextFirst, registered: false };
}

/** 기간이 끝났는가 (종료일 다음 날 0시 이후, 한국 시간) */
export const periodEnded = (p: ClosePeriod, now = new Date()) =>
  now >= new Date(`${p.endExclusive}T00:00:00+09:00`);

/**
 * 기간 조건 SQL 조각 — `col` 이 그 달 마감 기간 안인가.
 * `F_GET_INVENTORY_CLOSE_DATE` 가 등록이 없으면 달력 월을 준다. 종료는 날짜 부분만 보고 다음 날 0시 앞까지.
 */
export const periodBoundsSql = (col: string, yyyymm: string, org: string) =>
  `${col} >= F_GET_INVENTORY_CLOSE_DATE(${yyyymm}, 'START', ${org})
   AND ${col} < TRUNC(F_GET_INVENTORY_CLOSE_DATE(${yyyymm}, 'END', ${org})) + 1`;

/**
 * 실사를 시작할 수 있는 달인가 — 오늘이 속한 마감 기간과 그 직전 기간(월말 실사가 다음 기간 초에 끝나는 경우).
 * 오늘이 등록된 어느 기간에도 안 들어가면 달력 기준(이번 달·지난달)으로 본다.
 */
export async function isStocktakePeriodAllowed(
  q: Queryable,
  yyyymm: string,
  organizationId: number,
  fallback: (yyyymm: string) => boolean,
): Promise<boolean> {
  const cur = (await q.query(
    `SELECT MAX(CLOSE_YYYYMM) AS "ym" FROM ISYS_INVENTORY_CLOSE_DATE
      WHERE ORGANIZATION_ID = :organizationId AND TRUNC(SYSDATE) BETWEEN TRUNC(START_DATE) AND TRUNC(END_DATE)`,
    namedBinds({ organizationId }),
  )) as { ym: string | null }[];
  const current = cur[0]?.ym;
  if (!current) return fallback(yyyymm);
  return yyyymm === current || yyyymm === shiftMonth(current, -1);
}
