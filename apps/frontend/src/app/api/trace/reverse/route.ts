/**
 * @file src/app/api/trace/reverse/route.ts
 * @description 역추적 API — 자재바코드(SCAN_PARTNAME)로 사용된 PCB 조회. webdisplay U1 역추적을 가져왔다.
 *
 * 초보자 가이드:
 * - DB 실행은 lib/trace/db.ts (은성 MES 활성 프로필 메인 풀).
 * - HW_* / LOG_* / ROWNUM=1 금지. 같은 릴이 두 라인에 있으면 두 RUN 의 시리얼을 모두 반환.
 * - summary JSON 키는 멕시코 TraceResultPanel 과 동일 (reelMaster/reelChanges 는 항상 []).
 * - boards: CHECKHIST RUN → IP_PRODUCT_2D_BARCODE 전 시리얼 (Bot+Top).
 */
import { NextRequest, NextResponse } from 'next/server';
import { executeQueryByProfile } from '@/lib/trace/db';
import { resolveTraceProfile } from '@/lib/trace/db';
import { buildInBinds } from '@/lib/trace/trace-sql';
import { listPairedSerials } from '@/lib/trace/trace-tables';
import { toDbWallClock } from '@/lib/trace/oracle-date';

export const dynamic = 'force-dynamic';

const IN_CHUNK = 400;

function isMissingColumn(err: unknown): boolean {
  return /ORA-00904/i.test((err as Error)?.message ?? '');
}

function sanitize(rows: Record<string, unknown>[]): Record<string, unknown>[] {
  return rows.map((row) => {
    const safe: Record<string, unknown> = {};
    for (const [k, v] of Object.entries(row)) {
      if (v instanceof Date) safe[k] = toDbWallClock(v);
      else if (typeof v === 'bigint') safe[k] = Number(v);
      else if (typeof v === 'string') safe[k] = v.trim();
      else safe[k] = v;
    }
    return safe;
  });
}

export async function GET(req: NextRequest) {
  let profile: string;
  try {
    profile = resolveTraceProfile();
  } catch (err) {
    return NextResponse.json({ error: (err as Error).message }, { status: 502 });
  }

  const sp = req.nextUrl.searchParams;
  const reelCd = (sp.get('reelCd') ?? '').trim();
  const mode = (sp.get('mode') ?? 'summary').trim().toLowerCase();

  if (!reelCd) {
    return NextResponse.json({ error: 'reelCd 파라미터가 필요합니다' }, { status: 400 });
  }

  try {
    if (mode === 'detail') {
      return await handleDetail(profile, reelCd, (sp.get('boardSN') ?? '').trim());
    }
    return await handleSummary(profile, reelCd);
  } catch (err) {
    console.error('역추적 API 오류:', err);
    return NextResponse.json(
      { error: `조회 실패: ${(err as Error).message}` },
      { status: 500 },
    );
  }
}

function parseLotFromReel(reelCd: string): string {
  const parts = reelCd.split('-');
  return parts.length >= 2 ? parts.slice(1, -1).join('-') : reelCd;
}

async function handleSummary(profile: string, reelCd: string) {
  const receiptRows = await queryReceipt(profile, reelCd);
  const lotNo =
    receiptRows.map((r) => String(r.LOT_NO ?? '').trim()).find(Boolean) || parseLotFromReel(reelCd);

  const [issueRows, checkRuns] = await Promise.all([
    queryIssues(profile, lotNo),
    queryCheckhistRuns(profile, reelCd),
  ]);

  let runNos = [...new Set(checkRuns.map((r) => String(r.RUN_NO ?? '').trim()).filter(Boolean))];
  if (runNos.length === 0) {
    runNos = await queryIssueRuns(profile, lotNo);
  }

  const boardRows = await queryBoardsByRuns(profile, runNos);

  return NextResponse.json({
    reelCd,
    lotNo,
    receipt: sanitize(receiptRows),
    issues: sanitize(issueRows),
    reelMaster: [],
    reelChanges: [],
    boards: sanitize(boardRows),
    total: boardRows.length,
  });
}

/** 해당 보드의 모든 RUN (Bot+Top) + 릴 CHECKHIST. HW_VW_LTS 아님. */
async function handleDetail(profile: string, reelCd: string, boardSN: string) {
  if (!boardSN) {
    return NextResponse.json({ error: 'boardSN 파라미터가 필요합니다' }, { status: 400 });
  }

  const runNos = await queryRunsForBoard(profile, boardSN);
  if (runNos.length === 0) {
    return NextResponse.json({ reelCd, boardSN, details: [], total: 0 });
  }

  const details = await queryCheckhistDetail(profile, reelCd, boardSN, runNos);
  return NextResponse.json({
    reelCd,
    boardSN,
    details: sanitize(details),
    total: details.length,
  });
}

async function queryReceipt(profile: string, reelCd: string): Promise<Record<string, unknown>[]> {
  const full = `
    SELECT ITEM_BARCODE, ITEM_CODE, LOT_NO, SCAN_DATE, SCAN_QTY,
           SUPPLIER_CODE, RECEIPT_SLIP_NO, BARCODE_STATUS, MANUFACTURE_DATE,
           MANUFACTURE_WEEK, VENDOR_LOTNO, INSPECT_RESULT
      FROM IM_ITEM_RECEIPT_BARCODE
     WHERE ITEM_BARCODE = :reelCd`;
  const core = `
    SELECT ITEM_BARCODE, ITEM_CODE, LOT_NO, SCAN_DATE, SCAN_QTY, SUPPLIER_CODE
      FROM IM_ITEM_RECEIPT_BARCODE
     WHERE ITEM_BARCODE = :reelCd`;
  try {
    return await executeQueryByProfile<Record<string, unknown>>(profile, full, { reelCd });
  } catch (err) {
    if (!isMissingColumn(err)) throw err;
    return executeQueryByProfile<Record<string, unknown>>(profile, core, { reelCd });
  }
}

async function queryIssues(profile: string, lotNo: string): Promise<Record<string, unknown>[]> {
  if (!lotNo) return [];
  const byMfs = `
    SELECT ISSUE_DATE, ITEM_CODE, MATERIAL_MFS, LINE_CODE, WORKSTAGE_CODE,
           ISSUE_QTY, ISSUE_STATUS, MODEL_NAME, ISSUE_TYPE, ENTER_DATE, ENTER_BY
      FROM IM_ITEM_ISSUE
     WHERE MATERIAL_MFS = :lotNo
       AND ISSUE_DEFICIT = '3'
       AND LOT_DIVIDE_SEQUENCE IS NULL
     ORDER BY ISSUE_DATE DESC`;
  const byMfsCol = `
    SELECT ISSUE_DATE, ITEM_CODE, MFS AS MATERIAL_MFS, LINE_CODE, WORKSTAGE_CODE,
           ISSUE_QTY, ISSUE_STATUS, MODEL_NAME, ISSUE_TYPE, ENTER_DATE, ENTER_BY
      FROM IM_ITEM_ISSUE
     WHERE MFS = :lotNo
       AND ISSUE_DEFICIT = '3'
       AND LOT_DIVIDE_SEQUENCE IS NULL
     ORDER BY ISSUE_DATE DESC`;
  try {
    return await executeQueryByProfile<Record<string, unknown>>(profile, byMfs, { lotNo });
  } catch (err) {
    if (!isMissingColumn(err)) throw err;
    try {
      return await executeQueryByProfile<Record<string, unknown>>(profile, byMfsCol, { lotNo });
    } catch (err2) {
      if (!isMissingColumn(err2)) throw err2;
      return [];
    }
  }
}

async function queryCheckhistRuns(
  profile: string,
  reelCd: string,
): Promise<{ RUN_NO: string | null }[]> {
  return executeQueryByProfile<{ RUN_NO: string | null }>(
    profile,
    `SELECT DISTINCT RUN_NO, LINE_CODE
       FROM IB_SMT_CHECKHIST
      WHERE SCAN_PARTNAME = :reelCd
        AND RUN_NO IS NOT NULL`,
    { reelCd },
  );
}

async function queryIssueRuns(profile: string, lotNo: string): Promise<string[]> {
  if (!lotNo) return [];
  const byMfs = `
    SELECT DISTINCT RUN_NO
      FROM IM_ITEM_ISSUE
     WHERE MATERIAL_MFS = :lotNo
       AND RUN_NO IS NOT NULL
       AND ISSUE_DEFICIT = '3'
       AND LOT_DIVIDE_SEQUENCE IS NULL`;
  const byMfsCol = `
    SELECT DISTINCT RUN_NO
      FROM IM_ITEM_ISSUE
     WHERE MFS = :lotNo
       AND RUN_NO IS NOT NULL
       AND ISSUE_DEFICIT = '3'
       AND LOT_DIVIDE_SEQUENCE IS NULL`;
  try {
    const rows = await executeQueryByProfile<{ RUN_NO: string | null }>(profile, byMfs, { lotNo });
    return rows.map((r) => String(r.RUN_NO ?? '').trim()).filter(Boolean);
  } catch (err) {
    if (!isMissingColumn(err)) throw err;
    try {
      const rows = await executeQueryByProfile<{ RUN_NO: string | null }>(profile, byMfsCol, { lotNo });
      return rows.map((r) => String(r.RUN_NO ?? '').trim()).filter(Boolean);
    } catch (err2) {
      if (!isMissingColumn(err2)) throw err2;
      return [];
    }
  }
}

async function queryBoardsByRuns(
  profile: string,
  runNos: string[],
): Promise<Record<string, unknown>[]> {
  const unique = [...new Set(runNos.map((v) => String(v ?? '').trim()).filter(Boolean))];
  if (unique.length === 0) return [];

  const all: Record<string, unknown>[] = [];
  for (let i = 0; i < unique.length; i += IN_CHUNK) {
    const chunk = unique.slice(i, i + IN_CHUNK);
    const { placeholders, binds } = buildInBinds(chunk, 'run');
    const grouped = `
      SELECT SERIAL_NO              AS "BoardSN",
             LINE_CODE              AS "LineNm",
             RUN_NO                 AS "JobOrderNo",
             MIN(ITEM_CODE)         AS "PartNo",
             MIN(MACHINE_CODE)      AS "EqpNm",
             MIN(ENTER_DATE)        AS "StartDt",
             MAX(ENTER_DATE)        AS "EndDt",
             COUNT(*)               AS "StepCount"
        FROM IP_PRODUCT_2D_BARCODE
       WHERE RUN_NO IN (${placeholders})
         AND SERIAL_NO IS NOT NULL
       GROUP BY SERIAL_NO, LINE_CODE, RUN_NO
       ORDER BY MIN(ENTER_DATE) DESC NULLS LAST`;
    const plain = `
      SELECT SERIAL_NO AS "BoardSN",
             LINE_CODE AS "LineNm",
             RUN_NO    AS "JobOrderNo",
             NULL      AS "PartNo",
             NULL      AS "EqpNm",
             NULL      AS "StartDt",
             NULL      AS "EndDt",
             1         AS "StepCount"
        FROM IP_PRODUCT_2D_BARCODE
       WHERE RUN_NO IN (${placeholders})
         AND SERIAL_NO IS NOT NULL`;
    try {
      all.push(...(await executeQueryByProfile<Record<string, unknown>>(profile, grouped, binds)));
    } catch (err) {
      if (!isMissingColumn(err)) throw err;
      all.push(...(await executeQueryByProfile<Record<string, unknown>>(profile, plain, binds)));
    }
  }
  return all;
}

async function queryRunsForBoard(profile: string, boardSN: string): Promise<string[]> {
  const { serials } = await listPairedSerials(profile, boardSN);
  const serialIn = buildInBinds(serials.length > 0 ? serials : [boardSN], 's');
  if (serialIn.values.length === 0) return [];
  const sql = `
    SELECT DISTINCT RUN_NO
      FROM IP_PRODUCT_2D_BARCODE
     WHERE SERIAL_NO IN (${serialIn.placeholders})
       AND RUN_NO IS NOT NULL`;
  const rows = await executeQueryByProfile<{ RUN_NO: string | null }>(profile, sql, serialIn.binds);
  return [...new Set(rows.map((r) => String(r.RUN_NO ?? '').trim()).filter(Boolean))];
}

async function queryCheckhistDetail(
  profile: string,
  reelCd: string,
  boardSN: string,
  runNos: string[],
): Promise<Record<string, unknown>[]> {
  const { placeholders, binds } = buildInBinds(runNos, 'run');
  const allBinds = { ...binds, reelCd, boardSN };

  const full = `
    SELECT c.LINE_CODE,
           c.RUN_NO,
           c.SCAN_PARTNAME,
           c.CHECK_DATE,
           c.PCB_ITEM,
           c.LOCATION_CODE,
           c.ITEM_CODE,
           c.CHECK_SEQUENCE,
           c.VALID_DATE,
           c.MACHINE,
           :boardSN                    AS "BoardSN",
           c.SCAN_PARTNAME             AS "ReelCd",
           NVL(c.ITEM_CODE, c.PCB_ITEM) AS "PartNo",
           c.LOCATION_CODE             AS "SlotNo",
           c.LOCATION_CODE             AS "ReferenceID",
           c.CHECK_DATE                AS "StartDt",
           c.VALID_DATE                AS "EndDt",
           c.LINE_CODE                 AS "LineNm",
           c.RUN_NO                    AS "JobOrderNo",
           c.CHECK_SEQUENCE            AS "StepNo",
           NULL                        AS "ArrayIndex",
           NULL                        AS "BlockIndex",
           c.MACHINE                   AS "EqpNm"
      FROM IB_SMT_CHECKHIST c
     WHERE c.SCAN_PARTNAME = :reelCd
       AND c.RUN_NO IN (${placeholders})
     ORDER BY c.CHECK_DATE, c.CHECK_SEQUENCE`;

  const core = `
    SELECT c.LINE_CODE,
           c.RUN_NO,
           c.SCAN_PARTNAME,
           c.CHECK_DATE,
           c.LOCATION_CODE,
           :boardSN            AS "BoardSN",
           c.SCAN_PARTNAME     AS "ReelCd",
           c.LOCATION_CODE     AS "SlotNo",
           c.LOCATION_CODE     AS "ReferenceID",
           c.CHECK_DATE        AS "StartDt",
           c.LINE_CODE         AS "LineNm",
           c.RUN_NO            AS "JobOrderNo"
      FROM IB_SMT_CHECKHIST c
     WHERE c.SCAN_PARTNAME = :reelCd
       AND c.RUN_NO IN (${placeholders})
     ORDER BY c.CHECK_DATE`;

  try {
    return await executeQueryByProfile<Record<string, unknown>>(profile, full, allBinds);
  } catch (err) {
    if (!isMissingColumn(err)) throw err;
    return executeQueryByProfile<Record<string, unknown>>(profile, core, allBinds);
  }
}
