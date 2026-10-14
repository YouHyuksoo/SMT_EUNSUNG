/**
 * @file src/lib/trace/trace-sql.ts
 * @description 정추적 SQL + 섹션 조회. webdisplay 베트남 U1 추적(lib/u1/trace-sql.ts)을
 *              은성 DB 에 맞춰 가져왔다 (PAIR 테이블·MAOI 없음, 리플로우 라인코드 = SMT 라인코드).
 *
 * 초보자 가이드:
 * - 같은 PID 가 Bot/Top 두 LINE/RUN 을 가진다. RUN 은 집합(IN)으로만 쓴다. ROWNUM=1 금지.
 * - TOP/BOTTOM 시리얼이 다르면 IP_PRODUCT_2D_BARCODE_PAIR 로 짝 PID 까지 같이 조회한다.
 * - 설비 로그는 IQ_MACHINE_* (PID/BARCODE). HW_* / LOG_* 는 여기 없다.
 * - 릴 자재 시간창은 라인별 SPI/MAOI/AOI (lineInspectAnchorSql). 전역 MIN 금지.
 * - 위성 테이블 컬럼이 사이트마다 다를 수 있다. 섹션 단위 try/catch 후 스킵.
 * - 값은 바인드만. 테이블/컬럼 식별자는 상수 또는 ALL_TAB_COLUMNS 결과만.
 */
import { executeQueryByProfile } from '@/lib/trace/db';
import {
  lineInspectAnchorSql,
  listIqMachineTraceTables,
  listPairedSerials,
  listRunsForPid,
  isU1TraceIqTable,
  isU1TraceDefaultIqTable,
  type U1IqTraceTable,
  type U1TraceRun,
} from '@/lib/trace/trace-tables';
import { applyLineNames, loadLineNameMap, toLineName } from '@/lib/trace/line-names';
import type { TimelineEvent, TimelineEventType, TraceabilityResponse } from '@/types/trace/traceability';
import { toDbWallClock } from '@/lib/trace/oracle-date';

/** mode=tables 고정 마스터. 이 순서 유지. 뒤에 IQ 테이블명이 붙는다. */
export const U1_TRACE_FIXED_TABLES = [
  'IP_PRODUCT_2D_BARCODE',
  'IP_PRODUCT_WORK_QC',
  'IMCN_JIG_INPUT_HIST',
  'IM_ITEM_SOLDER_INPUT_HIST',
  'IB_SMT_CHECKHIST',
  'IP_PRODUCT_PCB_SCAN_MASTER',
] as const;

const SAFE_IDENT = /^[A-Z][A-Z0-9_]*$/;

/** 보조 풀 poolMax=5. IQ 병렬을 이 이하로 묶어 NJS-040 을 막는다. */
const QUERY_CONCURRENCY = 4;

const SERIAL_KEY_CANDIDATES = [
  'SERIAL_NO',
  'PID',
  'BARCODE',
  'MASTER_BARCODE',
] as const;

const TS_PREFERRED = [
  'INSPECT_DATE',
  'START_TIME',
  'END_TIME',
  'RUN_DATE',
  'ACTUAL_DATE',
  'CHECK_DATE',
  'INPUT_DATE',
  'SCAN_DATE',
  'QC_DATE',
  'REPAIR_DATE',
  'IO_DATE',
  'FEEDING_DATE',
  'FINAL_INSPECT_DATE',
] as const;

const TS_EXCLUDE = /^(ENTER|LAST_MODIFY|CREATE|UPDATE|REG)_?(DATE|DT)$/i;

export interface U1TraceQueryOptions {
  barcode: string;
  orgId?: string | number | null;
  /** 지정 시 그 테이블만. 없으면 iqMode 기본값. */
  selectedTables?: Set<string> | null;
  /** selectedTables 가 없을 때 IQ 범위. default=헤더+U1, all=목록 전체. */
  iqMode?: 'default' | 'all';
}

/** 멕시코 UI 호환 + 다라인 부가 필드. */
export interface U1TraceabilityResponse extends TraceabilityResponse {
  masters?: Record<string, unknown>[];
  runs?: U1TraceRun[];
  /** 조회 PID + PAIR 짝 시리얼. [0] 이 조회값. */
  pairedSerials?: string[];
}

function assertIdent(name: string): string {
  const n = (name || '').toUpperCase();
  if (!SAFE_IDENT.test(n)) {
    throw new Error(`허용되지 않은 식별자: ${name}`);
  }
  return n;
}

const COL_CACHE_TTL_MS = 10 * 60 * 1000;
const columnCache = new Map<string, { at: number; value: Set<string> }>();

function isSelected(
  selected: Set<string> | null | undefined,
  table: string,
  iqMode: 'default' | 'all',
  isIq: boolean,
): boolean {
  if (selected) return selected.has(table);
  if (!isIq || iqMode === 'all') return true;
  return isU1TraceDefaultIqTable(table);
}

function isMissingColumn(err: unknown): boolean {
  return /ORA-00904/i.test((err as Error)?.message ?? '');
}

/** BigInt / Date / LOB 을 JSON 직렬화 가능하게. 멕시코 route sanitizeRow 와 동일. */
export function sanitizeRow(row: Record<string, unknown>): Record<string, unknown> {
  const safe: Record<string, unknown> = {};
  for (const [key, val] of Object.entries(row)) {
    if (val == null) {
      safe[key] = val;
    } else if (typeof val === 'bigint') {
      safe[key] = Number.isSafeInteger(Number(val)) ? Number(val) : String(val);
    } else if (val instanceof Date) {
      safe[key] = toDbWallClock(val);
    } else if (Buffer.isBuffer(val)) {
      safe[key] = val.toString('base64');
    } else if (typeof val === 'object' && (val as { constructor?: { name?: string } }).constructor?.name === 'Lob') {
      safe[key] = '[LOB]';
    } else {
      try {
        JSON.stringify(val);
        safe[key] = val;
      } catch {
        safe[key] = String(val);
      }
    }
  }
  return safe;
}

export function pickTimestamp(row: Record<string, unknown>, extraPreferred: string[] = []): string {
  const keys = Object.keys(row);
  const preferred = [...extraPreferred, ...TS_PREFERRED];
  const tsCol =
    preferred.find((c) => keys.includes(c) && row[c] != null) ??
    keys.find((c) => !TS_EXCLUDE.test(c) && /DATE|TIME/i.test(c) && row[c] != null) ??
    null;
  if (!tsCol || row[tsCol] == null) return '';
  const raw = row[tsCol];
  if (raw instanceof Date) return toDbWallClock(raw);
  return String(raw);
}

function toEvent(
  source: string,
  type: TimelineEventType,
  row: Record<string, unknown>,
  extraPreferred: string[] = [],
): TimelineEvent {
  const data = sanitizeRow(row);
  return { source, type, timestamp: pickTimestamp(row, extraPreferred), data };
}

/** 빈 값 제거 후 :prefix0, :prefix1 … */
export function buildInBinds(
  values: string[],
  prefix: string,
): { placeholders: string; binds: Record<string, string>; values: string[] } {
  const unique = [...new Set(values.map((v) => String(v ?? '').trim()).filter(Boolean))];
  const binds: Record<string, string> = {};
  const names = unique.map((v, i) => {
    const name = `${prefix}${i}`;
    binds[name] = v;
    return `:${name}`;
  });
  return { placeholders: names.join(', '), binds, values: unique };
}

async function mapLimited<T, R>(items: T[], fn: (item: T) => Promise<R>): Promise<R[]> {
  if (items.length === 0) return [];
  const results: R[] = new Array(items.length);
  let cursor = 0;
  const worker = async () => {
    while (cursor < items.length) {
      const i = cursor;
      cursor += 1;
      results[i] = await fn(items[i]);
    }
  };
  const n = Math.min(QUERY_CONCURRENCY, items.length);
  await Promise.all(Array.from({ length: n }, () => worker()));
  return results;
}

async function safeSection<T>(label: string, fn: () => Promise<T>, fallback: T): Promise<T> {
  try {
    return await fn();
  } catch (err) {
    console.error(`[U1추적] ${label} 스킵:`, (err as Error).message);
    return fallback;
  }
}

export function sqlMasterBySerial(hasOrg: boolean): string {
  return `SELECT *
            FROM IP_PRODUCT_2D_BARCODE
           WHERE SERIAL_NO = :barcode
             ${hasOrg ? 'AND ORGANIZATION_ID = :orgId' : ''}
           ORDER BY LINE_CODE, RUN_NO`;
}

export function sqlMasterBySerials(placeholders: string, hasOrg: boolean): string {
  return `SELECT *
            FROM IP_PRODUCT_2D_BARCODE
           WHERE SERIAL_NO IN (${placeholders})
             ${hasOrg ? 'AND ORGANIZATION_ID = :orgId' : ''}
           ORDER BY LINE_CODE, RUN_NO`;
}

export function sqlRunCards(placeholders: string): string {
  return `SELECT * FROM IP_PRODUCT_RUN_CARD WHERE RUN_NO IN (${placeholders})`;
}

export function sqlModelMasters(placeholders: string): string {
  return `SELECT * FROM IP_PRODUCT_MODEL_MASTER WHERE MODEL_NAME IN (${placeholders})`;
}

export function sqlIqByKeys(
  tableName: string,
  keyColumns: string[],
  serialPlaceholders = ':barcode',
): string {
  const table = assertIdent(tableName);
  const keys = keyColumns.map(assertIdent);
  const where = keys.map((c) => `${c} IN (${serialPlaceholders})`).join(' OR ');
  return `SELECT * FROM ${table} WHERE ${where}`;
}

export function sqlReelMaterial(
  runPlaceholders: string,
  serialBind: string | readonly string[] = 'serial',
): string {
  const anchor = lineInspectAnchorSql(serialBind);
  return `
    SELECT c.LINE_CODE,
           c.RUN_NO,
           c.LOCATION_CODE,
           c.PCB_ITEM,
           DECODE(c.CHECK_TYPE, '1', 'CCS', '2', 'REEL', c.CHECK_TYPE) AS CHECK_TYPE,
           c.SCAN_PARTNAME,
           c.ITEM_CODE,
           c.SCAN_QTY,
           c.VENDOR_NAME,
           c.CHECK_DATE,
           c.VALID_DATE,
           c.CHECK_STATUS,
           b.SUPPLIER_BARCODE,
           b.SUPPLIER_LOT_NO,
           b.LOT_NO AS RECEIPT_LOT_NO,
           i.MSL_LEVEL,
           i.MSL_MAX_TIME,
           z.INSPECT_DATE AS LINE_INSPECT_DATE
      FROM IB_SMT_CHECKHIST c
      JOIN IM_ITEM_RECEIPT_BARCODE b ON c.SCAN_PARTNAME = b.ITEM_BARCODE
      LEFT JOIN ID_ITEM i ON c.ITEM_CODE = i.ITEM_CODE
      JOIN (
        ${anchor}
      ) z ON c.LINE_CODE = z.LINE_CODE
     WHERE c.RUN_NO IN (${runPlaceholders})
       AND c.CHECK_TYPE IN ('1', '2')
       AND c.CHECK_STATUS = 'P'
       AND c.CHECK_DATE <= z.INSPECT_DATE
       AND NVL(c.VALID_DATE, SYSDATE) > z.INSPECT_DATE`;
}

export function sqlReelMaterialNoItem(
  runPlaceholders: string,
  serialBind: string | readonly string[] = 'serial',
): string {
  const anchor = lineInspectAnchorSql(serialBind);
  return `
    SELECT c.LINE_CODE,
           c.RUN_NO,
           c.LOCATION_CODE,
           c.PCB_ITEM,
           DECODE(c.CHECK_TYPE, '1', 'CCS', '2', 'REEL', c.CHECK_TYPE) AS CHECK_TYPE,
           c.SCAN_PARTNAME,
           c.ITEM_CODE,
           c.SCAN_QTY,
           c.VENDOR_NAME,
           c.CHECK_DATE,
           c.VALID_DATE,
           c.CHECK_STATUS,
           b.SUPPLIER_BARCODE,
           b.SUPPLIER_LOT_NO,
           b.LOT_NO AS RECEIPT_LOT_NO,
           z.INSPECT_DATE AS LINE_INSPECT_DATE
      FROM IB_SMT_CHECKHIST c
      JOIN IM_ITEM_RECEIPT_BARCODE b ON c.SCAN_PARTNAME = b.ITEM_BARCODE
      JOIN (
        ${anchor}
      ) z ON c.LINE_CODE = z.LINE_CODE
     WHERE c.RUN_NO IN (${runPlaceholders})
       AND c.CHECK_TYPE IN ('1', '2')
       AND c.CHECK_STATUS = 'P'
       AND c.CHECK_DATE <= z.INSPECT_DATE
       AND NVL(c.VALID_DATE, SYSDATE) > z.INSPECT_DATE`;
}

/** 입고 부가 컬럼이 없을 때. SCAN_PARTNAME=ITEM_BARCODE 조인만 유지. */
export function sqlReelMaterialCore(
  runPlaceholders: string,
  serialBind: string | readonly string[] = 'serial',
): string {
  const anchor = lineInspectAnchorSql(serialBind);
  return `
    SELECT c.*,
           z.INSPECT_DATE AS LINE_INSPECT_DATE
      FROM IB_SMT_CHECKHIST c
      JOIN IM_ITEM_RECEIPT_BARCODE b ON c.SCAN_PARTNAME = b.ITEM_BARCODE
      JOIN (
        ${anchor}
      ) z ON c.LINE_CODE = z.LINE_CODE
     WHERE c.RUN_NO IN (${runPlaceholders})
       AND c.CHECK_TYPE IN ('1', '2')
       AND c.CHECK_STATUS = 'P'
       AND c.CHECK_DATE <= z.INSPECT_DATE
       AND NVL(c.VALID_DATE, SYSDATE) > z.INSPECT_DATE`;
}

export function sqlSolder(runPlaceholders: string): string {
  return `
    SELECT h.LINE_CODE,
           h.RUN_NO,
           h.INPUT_DATE,
           h.SOLDER_LOT_NO,
           h.ORGANIZATION_ID,
           m.ITEM_CODE AS SOLDER_ITEM_CODE,
           m.RECEIPT_DATE,
           m.ISSUE_DATE,
           m.OPEN_DATE,
           m.VALID_DATE AS SOLDER_VALID_DATE
      FROM IM_ITEM_SOLDER_INPUT_HIST h
      LEFT JOIN IM_ITEM_SOLDER_MASTER m ON h.SOLDER_LOT_NO = m.SOLDER_LOT_NO
     WHERE h.RUN_NO IN (${runPlaceholders})`;
}

export function sqlSolderHistOnly(runPlaceholders: string): string {
  return `SELECT * FROM IM_ITEM_SOLDER_INPUT_HIST WHERE RUN_NO IN (${runPlaceholders})`;
}

export function sqlPcbScan(serialPlaceholders: string): string {
  return `
    SELECT s.RUN_NO,
           s.LINE_CODE,
           s.MACHINE_CODE,
           s.SCAN_DATE,
           s.SCAN_BY,
           s.PCB_BARCODE,
           s.ORGANIZATION_ID,
           b.ITEM_BARCODE,
           b.SUPPLIER_BARCODE,
           b.SUPPLIER_LOT_NO,
           b.LOT_NO AS RECEIPT_LOT_NO,
           b.ITEM_CODE AS RECEIPT_ITEM_CODE
      FROM IP_PRODUCT_PCB_SCAN_MASTER s
      LEFT JOIN IM_ITEM_RECEIPT_BARCODE b ON s.PCB_BARCODE = b.ITEM_BARCODE
     WHERE s.PCB_BARCODE IN (${serialPlaceholders})`;
}

export function sqlPcbScanOnly(serialPlaceholders: string): string {
  return `SELECT * FROM IP_PRODUCT_PCB_SCAN_MASTER WHERE PCB_BARCODE IN (${serialPlaceholders})`;
}

const REFLOW_TABLE = 'IQ_MACHINE_INSPECT_DATA_REFLOW';

/**
 * 이 PID 가 마지막으로 검사된 라인의 리플로우 측정 1건.
 * 앵커 테이블은 AOI, 없으면 SPI. 마지막 검사 10분 전 이후 가장 이른 측정값.
 * 은성 DB 의 리플로우 LINE_CODE 는 SMT 라인코드와 같아서 앵커 행의 line_code 로 바로 찾는다
 * (U1 은 F_GET_LINE_NAME_GROUP(17) 로 변환했지만 은성 DB 에는 그 함수가 없다).
 */
export function sqlReflowNestedDw(anchorTable: 'IQ_MACHINE_INSPECT_DATA_AOI' | 'IQ_MACHINE_INSPECT_DATA_SPI'): string {
  const table = assertIdent(anchorTable);
  return `
    SELECT measure_date,
           top1, bottom1, top2, bottom2, top3, bottom3,
           top4, bottom4, top5, bottom5, top6, bottom6,
           top7, bottom7, top8, bottom8, top9, bottom9,
           top10, bottom10, top11, bottom11, top12, bottom12,
           top13, bottom13,
           belt_speed,
           oxygen_concentration,
           file_name,
           F_GET_LINE_NAME(line_code, 1) AS line_code,
           job_file
      FROM (
    SELECT *
      FROM ${REFLOW_TABLE}
     WHERE line_code IN (
             SELECT line_code
               FROM ${table}
              WHERE pid = :serial
                AND inspect_date >= (
                      SELECT MAX(inspect_date)
                        FROM ${table}
                       WHERE pid = :serial
                    )
           )
       AND measure_date >= (
             SELECT TO_CHAR(
                      TO_DATE(MAX(inspect_date), 'YYYY/MM/DD HH24:MI:SS') - (10 / (24 * 60)),
                      'YYYY/MM/DD HH24:MI:SS')
               FROM ${table}
              WHERE pid = :serial
           )
     ORDER BY measure_date
    )
     WHERE ROWNUM = 1`;
}

async function listColumns(profile: string, tableName: string): Promise<Set<string>> {
  const table = assertIdent(tableName);
  const cacheKey = `${profile}:${table}`;
  const hit = columnCache.get(cacheKey);
  if (hit && Date.now() - hit.at < COL_CACHE_TTL_MS) return hit.value;

  const rows = await executeQueryByProfile<{ COLUMN_NAME: string }>(
    profile,
    `SELECT COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME = :tname`,
    { tname: table },
  );
  const value = new Set(
    rows.map((r) => String(r.COLUMN_NAME || '').toUpperCase()).filter((c) => SAFE_IDENT.test(c)),
  );
  columnCache.set(cacheKey, { at: Date.now(), value });
  return value;
}

async function queryIqTable(
  profile: string,
  table: U1IqTraceTable,
  serials: string[],
): Promise<TimelineEvent[]> {
  if (!isU1TraceIqTable(table.tableName) || table.keyColumns.length === 0) return [];
  const serialIn = buildInBinds(serials, 's');
  if (serialIn.values.length === 0) return [];
  const sql = sqlIqByKeys(table.tableName, table.keyColumns, serialIn.placeholders);
  const rows = await executeQueryByProfile<Record<string, unknown>>(profile, sql, serialIn.binds);
  return rows.map((row) => toEvent(table.tableName, 'log', row, ['INSPECT_DATE']));
}

async function queryBySerialOrRun(
  profile: string,
  tableName: string,
  serials: string[],
  runNos: string[],
  eventType: TimelineEventType,
  extraPreferred: string[],
  /** 지정하면 이 컬럼만 시리얼 키로 쓴다 (인덱스 없는 키 컬럼을 OR 로 풀스캔하지 않게) */
  serialKeys?: readonly string[],
): Promise<TimelineEvent[]> {
  const cols = await listColumns(profile, tableName);
  const serialCols = (serialKeys ?? SERIAL_KEY_CANDIDATES).filter((c) => cols.has(c));
  const hasRun = cols.has('RUN_NO');
  const runIn = hasRun ? buildInBinds(runNos, 'run') : { placeholders: '', binds: {}, values: [] };
  const serialIn = buildInBinds(serials, 's');

  let where = '';
  const binds: Record<string, string> = {};
  if (serialCols.length > 0 && serialIn.values.length > 0) {
    /* SERIAL/PID/BARCODE 가 있으면 이 PID 들만. RUN 까지 AND 하면 QC RUN 이 비어 있는 행이 빠진다. */
    where = serialCols.map((c) => `${c} IN (${serialIn.placeholders})`).join(' OR ');
    Object.assign(binds, serialIn.binds);
  } else if (runIn.values.length > 0) {
    where = `RUN_NO IN (${runIn.placeholders})`;
    Object.assign(binds, runIn.binds);
  } else {
    return [];
  }

  const sql = `SELECT * FROM ${assertIdent(tableName)} WHERE ${where}`;
  const rows = await executeQueryByProfile<Record<string, unknown>>(profile, sql, binds);
  return rows.map((row) => toEvent(tableName, eventType, row, extraPreferred));
}

async function queryReelMaterial(
  profile: string,
  serials: string[],
  runNos: string[],
): Promise<TimelineEvent[]> {
  if (runNos.length === 0) return [];
  const runIn = buildInBinds(runNos, 'run');
  const serialIn = buildInBinds(serials, 's');
  const allBinds = { ...runIn.binds, ...serialIn.binds };
  const serialBinds = serialIn.values.map((_, i) => `s${i}`);

  const trySql = async (sql: string) => {
    const rows = await executeQueryByProfile<Record<string, unknown>>(profile, sql, allBinds);
    return rows.map((row) => toEvent('IB_SMT_CHECKHIST', 'log', row, ['CHECK_DATE', 'FEEDING_DATE']));
  };

  try {
    return await trySql(sqlReelMaterial(runIn.placeholders, serialBinds));
  } catch (err) {
    if (!isMissingColumn(err)) throw err;
    try {
      return await trySql(sqlReelMaterialNoItem(runIn.placeholders, serialBinds));
    } catch (err2) {
      if (!isMissingColumn(err2)) throw err2;
      return trySql(sqlReelMaterialCore(runIn.placeholders, serialBinds));
    }
  }
}

async function querySolder(profile: string, runNos: string[]): Promise<TimelineEvent[]> {
  if (runNos.length === 0) return [];
  const { placeholders, binds } = buildInBinds(runNos, 'run');
  try {
    const rows = await executeQueryByProfile<Record<string, unknown>>(
      profile,
      sqlSolder(placeholders),
      binds,
    );
    return rows.map((row) => toEvent('IM_ITEM_SOLDER_INPUT_HIST', 'log', row, ['INPUT_DATE']));
  } catch (err) {
    if (!isMissingColumn(err)) throw err;
    const rows = await executeQueryByProfile<Record<string, unknown>>(
      profile,
      sqlSolderHistOnly(placeholders),
      binds,
    );
    return rows.map((row) => toEvent('IM_ITEM_SOLDER_INPUT_HIST', 'log', row, ['INPUT_DATE']));
  }
}

async function queryReflow(profile: string, serials: string[]): Promise<TimelineEvent[]> {
  const unique = [...new Set(serials.map((s) => String(s ?? '').trim()).filter(Boolean))];
  if (unique.length === 0) return [];
  const aoiSql = sqlReflowNestedDw('IQ_MACHINE_INSPECT_DATA_AOI');
  const spiSql = sqlReflowNestedDw('IQ_MACHINE_INSPECT_DATA_SPI');
  const parts = await Promise.all(
    unique.map(async (serial) => {
      try {
        const aoi = await executeQueryByProfile<Record<string, unknown>>(profile, aoiSql, { serial });
        if (aoi.length > 0) return aoi;
      } catch (err) {
        console.error('[U1추적] REFLOW AOI 앵커 실패:', (err as Error).message);
      }
      try {
        return await executeQueryByProfile<Record<string, unknown>>(profile, spiSql, { serial });
      } catch (err) {
        console.error('[U1추적] REFLOW SPI 앵커 실패:', (err as Error).message);
        return [] as Record<string, unknown>[];
      }
    }),
  );
  return parts.flat().map((row) => toEvent(REFLOW_TABLE, 'log', row, ['MEASURE_DATE']));
}

function pcbScanDedupeKey(row: Record<string, unknown>): string {
  return [
    String(row.RUN_NO ?? '').trim(),
    String(row.LINE_CODE ?? '').trim(),
    String(row.PCB_BARCODE ?? '').trim(),
  ].join('\0');
}

function pcbScanTime(row: Record<string, unknown>): string {
  const raw = row.SCAN_DATE;
  if (raw instanceof Date) return toDbWallClock(raw);
  return raw == null ? '' : String(raw);
}

/** WEBAPI 가 같은 RUN/라인/바코드를 1초 간격으로 두 번 넣은 행을 접는다. */
function dedupePcbScanRows(rows: Record<string, unknown>[]): Record<string, unknown>[] {
  const best = new Map<string, Record<string, unknown>>();
  for (const row of rows) {
    const key = pcbScanDedupeKey(row);
    const prev = best.get(key);
    if (!prev || pcbScanTime(row) < pcbScanTime(prev)) best.set(key, row);
  }
  return [...best.values()];
}

async function queryPcbScan(profile: string, serials: string[]): Promise<TimelineEvent[]> {
  const { placeholders, binds, values } = buildInBinds(serials, 's');
  if (values.length === 0) return [];
  try {
    const rows = await executeQueryByProfile<Record<string, unknown>>(
      profile,
      sqlPcbScan(placeholders),
      binds,
    );
    return dedupePcbScanRows(rows).map((row) =>
      toEvent('IP_PRODUCT_PCB_SCAN_MASTER', 'log', row, ['SCAN_DATE']),
    );
  } catch (err) {
    if (!isMissingColumn(err)) throw err;
    const rows = await executeQueryByProfile<Record<string, unknown>>(
      profile,
      sqlPcbScanOnly(placeholders),
      binds,
    );
    return dedupePcbScanRows(rows).map((row) =>
      toEvent('IP_PRODUCT_PCB_SCAN_MASTER', 'log', row, ['SCAN_DATE']),
    );
  }
}

function sortTimeline(events: TimelineEvent[]): TimelineEvent[] {
  return [...events].sort((a, b) => {
    if (!a.timestamp && !b.timestamp) return 0;
    if (!a.timestamp) return 1;
    if (!b.timestamp) return -1;
    return a.timestamp.localeCompare(b.timestamp);
  });
}

/**
 * 한 PID 의 전 라인 정추적. PAIR 짝 시리얼 이력도 합친다.
 * master 는 조회 PID 행(UI 호환), masters/runs/pairedSerials 에 전 행.
 */
export async function fetchU1Traceability(
  profile: string,
  opts: U1TraceQueryOptions,
): Promise<U1TraceabilityResponse> {
  const barcode = (opts.barcode ?? '').trim();
  const orgId = opts.orgId == null || String(opts.orgId).trim() === '' ? null : String(opts.orgId).trim();
  const selected = opts.selectedTables ?? null;
  const iqMode = opts.iqMode ?? 'default';
  const pick = (table: string, isIq = false) => isSelected(selected, table, iqMode, isIq);
  const t0 = Date.now();

  const pairInfo = await listPairedSerials(profile, barcode);
  const serials = pairInfo.serials.length > 0 ? pairInfo.serials : [barcode];
  const serialIn = buildInBinds(serials, 's');
  const masterBinds: Record<string, string> = { ...serialIn.binds };
  if (orgId) masterBinds.orgId = orgId;

  const [masterRows, runs] = await Promise.all([
    serialIn.values.length > 0
      ? executeQueryByProfile<Record<string, unknown>>(
          profile,
          sqlMasterBySerials(serialIn.placeholders, Boolean(orgId)),
          masterBinds,
        )
      : Promise.resolve([] as Record<string, unknown>[]),
    listRunsForPid(profile, serials, orgId),
  ]);

  const masters = masterRows.map((r) => sanitizeRow(r));
  const pairOthers = serials.filter((s) => s !== barcode);
  const masterRow =
    masters.find((r) => String(r['SERIAL_NO'] ?? '').trim() === barcode) ?? masters[0] ?? null;
  const master = masterRow
    ? pairOthers.length > 0
      ? { ...masterRow, PAIR_SERIAL_NO: pairOthers.join(', ') }
      : masterRow
    : null;
  const runNos = [...new Set(runs.map((r) => r.runNo).filter(Boolean))];
  const modelNames = [
    ...new Set(
      masters
        .map((r) => (r['MODEL_NAME'] == null ? '' : String(r['MODEL_NAME']).trim()))
        .filter(Boolean),
    ),
  ];

  const runIn = buildInBinds(runNos, 'run');
  const modelIn = buildInBinds(modelNames, 'model');

  const [runCardRows, modelMasterRows, iqTables] = await Promise.all([
    runIn.values.length > 0
      ? executeQueryByProfile<Record<string, unknown>>(profile, sqlRunCards(runIn.placeholders), runIn.binds)
          .catch((err) => {
            console.error('[U1추적] RUN_CARD 실패:', (err as Error).message);
            return [] as Record<string, unknown>[];
          })
      : Promise.resolve([] as Record<string, unknown>[]),
    modelIn.values.length > 0
      ? executeQueryByProfile<Record<string, unknown>>(profile, sqlModelMasters(modelIn.placeholders), modelIn.binds)
          .catch((err) => {
            console.error('[U1추적] MODEL_MASTER 실패:', (err as Error).message);
            return [] as Record<string, unknown>[];
          })
      : Promise.resolve([] as Record<string, unknown>[]),
    listIqMachineTraceTables(profile).catch((err) => {
      console.error('[U1추적] IQ 테이블 목록 실패:', (err as Error).message);
      return [] as U1IqTraceTable[];
    }),
  ]);

  const runCards = runCardRows.map((r) => sanitizeRow(r));
  const modelMasters = modelMasterRows.map((r) => sanitizeRow(r));
  const runCard = runCards[0] ?? null;
  const modelMaster = modelMasters[0] ?? null;

  const iqTargets = iqTables.filter(
    (t) => isU1TraceIqTable(t.tableName) && pick(t.tableName, true),
  );

  type Job = { label: string; run: () => Promise<TimelineEvent[]> };
  const jobs: Job[] = [];

  if (pick('IP_PRODUCT_2D_BARCODE')) {
    jobs.push({
      label: 'IP_PRODUCT_2D_BARCODE',
      run: async () => masterRows.map((row) => toEvent('IP_PRODUCT_2D_BARCODE', 'log', row, ['RUN_DATE'])),
    });
  }

  if (pick('IP_PRODUCT_2D_BARCODE_PAIR') && pairInfo.pairs.length > 0) {
    jobs.push({
      label: 'IP_PRODUCT_2D_BARCODE_PAIR',
      run: async () =>
        pairInfo.pairs.map((p) =>
          toEvent(
            'IP_PRODUCT_2D_BARCODE_PAIR',
            'log',
            { ...sanitizeRow(p.raw), SERIAL_NO: p.serialNo, PAIR_SERIAL_NO: p.pairSerialNo },
            ['ENTER_DATE'],
          ),
        ),
    });
  }

  if (runCards.length > 1) {
    jobs.push({
      label: 'IP_PRODUCT_RUN_CARD',
      run: async () =>
        runCardRows.slice(1).map((row) => toEvent('IP_PRODUCT_RUN_CARD', 'log', row, ['RUN_DATE'])),
    });
  }

  for (const table of iqTargets) {
    if (table.tableName === REFLOW_TABLE || table.keyColumns.length === 0) continue;
    jobs.push({
      label: table.tableName,
      run: () => queryIqTable(profile, table, serials),
    });
  }

  if (pick(REFLOW_TABLE, true)) {
    jobs.push({
      label: REFLOW_TABLE,
      run: () => queryReflow(profile, serials),
    });
  }

  if (pick('IB_SMT_CHECKHIST')) {
    jobs.push({
      label: 'IB_SMT_CHECKHIST',
      run: () => queryReelMaterial(profile, serials, runNos),
    });
  }
  if (pick('IM_ITEM_SOLDER_INPUT_HIST')) {
    jobs.push({
      label: 'IM_ITEM_SOLDER_INPUT_HIST',
      run: () => querySolder(profile, runNos),
    });
  }
  if (pick('IP_PRODUCT_PCB_SCAN_MASTER')) {
    jobs.push({
      label: 'IP_PRODUCT_PCB_SCAN_MASTER',
      run: () => queryPcbScan(profile, serials),
    });
  }
  if (pick('IP_PRODUCT_WORK_QC')) {
    jobs.push({
      label: 'IP_PRODUCT_WORK_QC',
      run: () =>
        queryBySerialOrRun(profile, 'IP_PRODUCT_WORK_QC', serials, runNos, 'repair', ['QC_DATE', 'REPAIR_DATE']),
    });
  }
  if (pick('IP_PRODUCT_WORKSTAGE_IO')) {
    jobs.push({
      label: 'IP_PRODUCT_WORKSTAGE_IO',
      run: () =>
        queryBySerialOrRun(profile, 'IP_PRODUCT_WORKSTAGE_IO', serials, runNos, 'stage_move', ['IO_DATE']),
    });
  }
  if (pick('IMCN_JIG_INPUT_HIST')) {
    jobs.push({
      label: 'IMCN_JIG_INPUT_HIST',
      run: () =>
        queryBySerialOrRun(profile, 'IMCN_JIG_INPUT_HIST', serials, runNos, 'log', ['INPUT_DATE']),
    });
  }
  if (pick('IP_PRODUCT_PACK_SERIAL')) {
    jobs.push({
      label: 'IP_PRODUCT_PACK_SERIAL',
      run: () =>
        queryBySerialOrRun(
          profile,
          'IP_PRODUCT_PACK_SERIAL',
          serials,
          runNos,
          'log',
          ['SCAN_DATE', 'FINAL_INSPECT_DATE'],
          /* 은성 DB: BARCODE 는 PK, MASTER_BARCODE 는 인덱스 없음(950만행 풀스캔 7초+) */
          ['BARCODE'],
        ),
    });
  }

  const sections = await mapLimited(jobs, (job) => safeSection(job.label, job.run, [] as TimelineEvent[]));
  const timeline = sortTimeline(sections.flat());

  const queriedTables = [
    ...(pick('IP_PRODUCT_2D_BARCODE') ? ['IP_PRODUCT_2D_BARCODE'] : []),
    ...iqTargets.map((t) => t.tableName),
    ...(pick(REFLOW_TABLE, true) && !iqTargets.some((t) => t.tableName === REFLOW_TABLE)
      ? [REFLOW_TABLE]
      : []),
    ...U1_TRACE_FIXED_TABLES.filter((t) => t !== 'IP_PRODUCT_2D_BARCODE' && pick(t)),
  ];

  const lineNames = await loadLineNameMap(profile);
  const namedMaster = applyLineNames(master, lineNames);
  const namedRunCard = applyLineNames(runCard, lineNames);
  const namedMasters = masters.map((row) => applyLineNames(row, lineNames) ?? row);
  const namedRuns = runs.map((r) => ({ ...r, lineCode: toLineName(lineNames, r.lineCode) || r.lineCode }));
  const namedTimeline = timeline.map((ev) => ({
    ...ev,
    data: applyLineNames(ev.data, lineNames) ?? ev.data,
  }));

  console.log(
    `[U1추적] ${barcode} pair=${serials.length} runs=${runNos.length} iq=${iqTargets.length} events=${namedTimeline.length} ${Date.now() - t0}ms`,
  );

  return {
    master: namedMaster,
    runCard: namedRunCard,
    modelMaster,
    timeline: namedTimeline,
    queriedTables,
    masters: namedMasters,
    runs: namedRuns,
    pairedSerials: serials,
  };
}
