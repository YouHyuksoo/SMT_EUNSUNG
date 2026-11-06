/**
 * @file src/lib/trace/trace-tables.ts
 * @description 정추적·역추적의 IQ 테이블 맵 + 다라인 RUN 헬퍼.
 *              webdisplay 베트남 U1 추적(lib/u1/trace-tables.ts)을 은성 DB 에 맞춰 가져왔다.
 *
 * 초보자 가이드:
 * - 같은 PID(SERIAL_NO)가 Bot/Top 라인에 각각 있다. RUN 은 2D ∪ IQ
 *   (SPI/MAOI/AOI). ROWNUM=1 로 하나 고르면 반대면 자재·이력이 빠진다.
 * - 은성 DB 에는 PAIR 테이블이 없어 짝 시리얼은 +A/+B 접미사로만 찾는다.
 * - 설비 로그는 LOG_* / HW_* 가 아니라 IQ_MACHINE_* (PID 또는 BARCODE 컬럼).
 *   IQ 는 AOI / SPI / 마킹 / 리플로우. 리플로우는 PID 없음(SPI·AOI 시각).
 * - 릴 자재 시간창은 라인별 최초 SPI/AOI. 전역 MIN(inspect_date) 금지.
 *   (은성 DB 에는 IQ_MACHINE_INSPECT_DATA_MAOI 가 없다.)
 * - inspect_date 는 DATE 가 아니라 VARCHAR2 'yyyy/mm/dd hh24:mi:ss' (PB DW).
 */
import { executeQueryByProfile } from '@/lib/trace/db';

/** PID / BARCODE 중 하나라도 있으면 정추적 설비 테이블 후보. */
const IQ_KEY_COLUMNS = ['PID', 'BARCODE'] as const;

const SAFE_IDENT = /^[A-Z][A-Z0-9_]*$/;
const SERIAL_BIND_RE = /^[A-Za-z][A-Za-z0-9_]*$/;
/** ALL_TAB_COLUMNS 결과는 프로세스 동안 재사용. 테이블 추가는 드물다. */
const IQ_TABLE_CACHE_TTL_MS = 10 * 60 * 1000;
const iqTableCache = new Map<string, { at: number; value: U1IqTraceTable[] }>();

/** PB DW 와 동일한 inspect_date 포맷 (VARCHAR2). */
export const LINE_INSPECT_DATE_FMT = 'yyyy/mm/dd hh24:mi:ss';

/** 자재 시간창 앵커로 쓰는 검사 테이블. 전역 MIN 없이 LINE_CODE 로 묶는다. */
export const LINE_INSPECT_ANCHOR_TABLES = [
  'IQ_MACHINE_INSPECT_DATA_SPI',
  'IQ_MACHINE_INSPECT_DATA_AOI',
] as const;

export interface U1IqTraceTable {
  tableName: string;
  keyColumns: Array<(typeof IQ_KEY_COLUMNS)[number]>;
}

export interface U1TraceRun {
  runNo: string;
  lineCode: string;
}

/** IP_PRODUCT_2D_BARCODE_PAIR 한 행. SERIAL_NO=TOP, PAIR_SERIAL_NO=BOTTOM. */
export interface U1BarcodePairRow {
  serialNo: string;
  pairSerialNo: string;
  enterDate: string | null;
  raw: Record<string, unknown>;
}

/** 조회 PID + PAIR 로 묶인 시리얼 집합. queried 가 항상 serials[0]. */
export interface U1PairedSerials {
  queried: string;
  serials: string[];
  pairs: U1BarcodePairRow[];
}

function upperName(name: string): string {
  return (name || '').toUpperCase();
}

/** 체크된 IQ만. AOI / SPI / 마킹 / 리플로우. */
export const U1_TRACE_IQ_ALLOWLIST = [
  'IQ_MACHINE_INSPECT_DATA_AOI',
  'IQ_MACHINE_INSPECT_DATA_SPI',
  'IQ_MACHINE_INSPECT_DATA_MK',
  'IQ_MACHINE_INSPECT_DATA_REFLOW',
] as const;

/**
 * U1 정추적에 쓸 IQ_MACHINE_* 테이블인지.
 * 허용 목록에 있는 IQ 만 true.
 */
export function isU1TraceIqTable(name: string): boolean {
  const n = upperName(name);
  return (U1_TRACE_IQ_ALLOWLIST as readonly string[]).includes(n);
}

/** 남은 IQ 는 전부 기본 체크. */
export function isU1TraceDefaultIqTable(name: string): boolean {
  return isU1TraceIqTable(name);
}

/**
 * ALL_TAB_COLUMNS 에서 IQ_MACHINE_% + PID/BARCODE 테이블을 모은 뒤 제외 규칙을 적용.
 * 테이블명은 메타데이터 결과만 사용한다 (바인드 불가 식별자).
 */
export async function listIqMachineTraceTables(
  profile: string,
): Promise<U1IqTraceTable[]> {
  const cacheKey = `${profile}:${U1_TRACE_IQ_ALLOWLIST.join(',')}`;
  const cached = iqTableCache.get(cacheKey);
  if (cached && Date.now() - cached.at < IQ_TABLE_CACHE_TTL_MS) {
    return cached.value.filter((t) => isU1TraceIqTable(t.tableName));
  }

  const placeholders = IQ_KEY_COLUMNS.map((_, i) => `:col${i}`).join(', ');
  const binds = Object.fromEntries(IQ_KEY_COLUMNS.map((c, i) => [`col${i}`, c]));

  const rows = await executeQueryByProfile<{ TABLE_NAME: string; COLUMN_NAME: string }>(
    profile,
    `SELECT C.TABLE_NAME, C.COLUMN_NAME
       FROM USER_TAB_COLUMNS C
      WHERE C.TABLE_NAME LIKE 'IQ_MACHINE\\_%' ESCAPE '\\'
        AND C.COLUMN_NAME IN (${placeholders})`,
    binds,
  );

  const byTable = new Map<string, Set<string>>();
  for (const row of rows) {
    const table = upperName(row.TABLE_NAME);
    const col = upperName(row.COLUMN_NAME);
    if (!SAFE_IDENT.test(table) || !IQ_KEY_COLUMNS.includes(col as (typeof IQ_KEY_COLUMNS)[number])) {
      continue;
    }
    let cols = byTable.get(table);
    if (!cols) {
      cols = new Set<string>();
      byTable.set(table, cols);
    }
    cols.add(col);
  }

  const value = [...byTable.entries()]
    .filter(([table]) => isU1TraceIqTable(table))
    .map(([table, cols]) => ({
      tableName: table,
      keyColumns: IQ_KEY_COLUMNS.filter((c) => cols.has(c)),
    }));
  /* REFLOW 는 PID/BARCODE 없음. PB 는 SPI/AOI 시각으로 조회. 목록에만 강제 추가. */
  if (
    isU1TraceIqTable('IQ_MACHINE_INSPECT_DATA_REFLOW') &&
    !value.some((t) => t.tableName === 'IQ_MACHINE_INSPECT_DATA_REFLOW')
  ) {
    value.push({ tableName: 'IQ_MACHINE_INSPECT_DATA_REFLOW', keyColumns: [] });
  }
  value.sort((a, b) => a.tableName.localeCompare(b.tableName));
  iqTableCache.set(cacheKey, { at: Date.now(), value });
  return value;
}

function mapRunRows(rows: { RUN_NO: unknown; LINE_CODE: unknown }[]): U1TraceRun[] {
  return rows.map((row) => ({
    runNo: row.RUN_NO == null ? '' : String(row.RUN_NO).trim(),
    lineCode: row.LINE_CODE == null ? '' : String(row.LINE_CODE).trim(),
  }));
}

/** 빈 RUN 은 LINE 이 유일한 식별일 때만 남긴다. 둘 다 빈 행은 버린다. */
function normalizeRuns(rows: U1TraceRun[]): U1TraceRun[] {
  const seen = new Set<string>();
  const unique: U1TraceRun[] = [];
  for (const row of rows) {
    if (!row.runNo && !row.lineCode) continue;
    const key = `${row.runNo}\0${row.lineCode}`;
    if (seen.has(key)) continue;
    seen.add(key);
    unique.push(row);
  }

  const withRun = unique.filter((row) => row.runNo);
  const kept = withRun.length > 0 ? withRun : unique.filter((row) => row.lineCode);
  return kept.sort((a, b) => a.lineCode.localeCompare(b.lineCode) || a.runNo.localeCompare(b.runNo));
}

/** 바인드 이름 배열 → `= :s0` 또는 `IN (:s0, :s1)`. */
function serialPred(column: string, bindNames: string[]): string {
  const names = bindNames.filter((n) => SERIAL_BIND_RE.test(n));
  const safe = names.length > 0 ? names : ['serial'];
  if (safe.length === 1) return `${column} = :${safe[0]}`;
  return `${column} IN (${safe.map((n) => `:${n}`).join(', ')})`;
}

/** 시리얼 목록 → :s0, :s1 … 바인드. */
export function buildSerialBinds(serials: string[]): {
  names: string[];
  binds: Record<string, string>;
  values: string[];
} {
  const values = [...new Set(serials.map((s) => String(s ?? '').trim()).filter(Boolean))];
  const binds: Record<string, string> = {};
  const names = values.map((v, i) => {
    const name = `s${i}`;
    binds[name] = v;
    return name;
  });
  return { names, binds, values };
}

function sql2dRuns(bindNames: string[], orgClause: string): string {
  return `SELECT RUN_NO, LINE_CODE
            FROM IP_PRODUCT_2D_BARCODE
           WHERE ${serialPred('SERIAL_NO', bindNames)}
             ${orgClause}`;
}

function sqlIqRuns(bindNames: string[]): string {
  const pred = serialPred('PID', bindNames);
  return LINE_INSPECT_ANCHOR_TABLES.map(
    (table) => `SELECT RUN_NO, LINE_CODE FROM ${table} WHERE ${pred}`,
  ).join('\n    UNION\n    ');
}

function sqlRunsForPidUnion(bindNames: string[], orgClause: string): string {
  return `SELECT DISTINCT RUN_NO, LINE_CODE
            FROM (
              ${sql2dRuns(bindNames, orgClause)}
              UNION
              ${sqlIqRuns(bindNames)}
            )
           ORDER BY LINE_CODE, RUN_NO`;
}

async function queryRunRows(
  profile: string,
  sql: string,
  binds: Record<string, string>,
): Promise<U1TraceRun[]> {
  const rows = await executeQueryByProfile<{ RUN_NO: unknown; LINE_CODE: unknown }>(
    profile,
    sql,
    binds,
  );
  return mapRunRows(rows);
}

async function queryIqRunsFallback(
  profile: string,
  bindNames: string[],
  binds: Record<string, string>,
): Promise<U1TraceRun[]> {
  try {
    return await queryRunRows(
      profile,
      `SELECT DISTINCT RUN_NO, LINE_CODE
         FROM (
           ${sqlIqRuns(bindNames)}
         )
        ORDER BY LINE_CODE, RUN_NO`,
      binds,
    );
  } catch (err) {
    console.error('[U1추적] IQ RUN UNION 실패, 테이블별 조회:', (err as Error).message);
    const pred = serialPred('PID', bindNames);
    const parts = await Promise.all(
      LINE_INSPECT_ANCHOR_TABLES.map((table) =>
        queryRunRows(
          profile,
          `SELECT DISTINCT RUN_NO, LINE_CODE
             FROM ${table}
            WHERE ${pred}`,
          binds,
        ).catch((tableErr) => {
          console.error(`[U1추적] ${table} RUN 스킵:`, (tableErr as Error).message);
          return [] as U1TraceRun[];
        }),
      ),
    );
    return parts.flat();
  }
}

/**
 * 해당 SERIAL(들) 의 전 라인 RUN (Bot+Top + PAIR 짝).
 * IP_PRODUCT_2D_BARCODE ∪ IQ SPI/MAOI/AOI. ROWNUM=1 금지.
 * 없으면 빈 배열 — 호출부가 자재 쿼리를 스킵한다.
 */
export async function listRunsForPid(
  profile: string,
  serial: string | string[],
  orgId?: string | number | null,
): Promise<U1TraceRun[]> {
  const { names, binds } = buildSerialBinds(Array.isArray(serial) ? serial : [serial]);
  if (names.length === 0) return [];

  let orgClause = '';
  if (orgId != null && String(orgId).trim() !== '') {
    binds.orgId = String(orgId).trim();
    orgClause = ' AND ORGANIZATION_ID = :orgId';
  }

  try {
    return normalizeRuns(await queryRunRows(profile, sqlRunsForPidUnion(names, orgClause), binds));
  } catch (err) {
    console.error('[U1추적] RUN UNION 실패, 2D/IQ 분리 조회:', (err as Error).message);
    const [from2d, fromIq] = await Promise.all([
      queryRunRows(
        profile,
        `${sql2dRuns(names, orgClause)}
         ORDER BY LINE_CODE, RUN_NO`,
        binds,
      ).catch((twoDErr) => {
        console.error('[U1추적] 2D RUN 실패:', (twoDErr as Error).message);
        return [] as U1TraceRun[];
      }),
      queryIqRunsFallback(profile, names, binds),
    ]);
    return normalizeRuns([...from2d, ...fromIq]);
  }
}

/** `...+A` ↔ `...+B` TOP/BOTTOM 접미사 짝. */
export function flipAbPairSuffix(serial: string): string | null {
  const s = (serial ?? '').trim();
  if (/\+A$/i.test(s)) return `${s.slice(0, -2)}+B`;
  if (/\+B$/i.test(s)) return `${s.slice(0, -2)}+A`;
  return null;
}

/**
 * 조회 시리얼 + TOP/BOTTOM 짝 시리얼.
 * 은성 DB 에는 IP_PRODUCT_2D_BARCODE_PAIR 테이블과 2D 바코드 PAIR_SERIAL_NO 컬럼이 없어
 * 접미사 +A/+B 짝만 조회 집합에 넣는다.
 */
export async function listPairedSerials(
  _profile: string,
  serial: string,
): Promise<U1PairedSerials> {
  const queried = (serial ?? '').trim();
  if (!queried) return { queried, serials: [], pairs: [] };
  const mate = flipAbPairSuffix(queried);
  return { queried, serials: mate ? [queried, mate] : [queried], pairs: [] };
}

/**
 * 라인별 최초 SPI/MAOI/AOI 시각 서브쿼리.
 * 반환 컬럼: LINE_CODE, INSPECT_DATE(DATE). 호출부가 LINE_CODE 로 조인한다.
 *
 * inspect_date 는 VARCHAR2 이므로 TO_DATE 후 LINE_CODE 별 MIN.
 * 형식 이상값은 REGEXP_LIKE 로 제외해 ORA-01861 을 막는다.
 */
export function lineInspectAnchorSql(serialBinds: string | readonly string[] = 'serial'): string {
  const requested = typeof serialBinds === 'string' ? [serialBinds] : [...serialBinds];
  const names = requested.filter((n) => SERIAL_BIND_RE.test(n));
  const pidPred = serialPred('pid', names.length > 0 ? names : ['serial']);
  const datePred = `REGEXP_LIKE(inspect_date, '^[0-9]{4}/[0-9]{2}/[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$')`;
  const unions = LINE_INSPECT_ANCHOR_TABLES.map(
    (table) =>
      `SELECT line_code, inspect_date
         FROM ${table}
        WHERE ${pidPred}
          AND ${datePred}`,
  ).join('\n    UNION ALL\n    ');

  return `SELECT x.line_code AS line_code,
       MIN(TO_DATE(x.inspect_date, '${LINE_INSPECT_DATE_FMT}')) AS inspect_date
  FROM (
    ${unions}
  ) x
 GROUP BY x.line_code`;
}
