/**
 * @file src/app/api/trace/reverse/candidates/route.ts
 * @description 역추적 위자드 — 릴 후보 리스트. webdisplay U1 역추적 후보 API 를 가져왔다.
 *
 * 초보자 가이드:
 * - issue: 멕시코와 동일 IM_ITEM_ISSUE ⋈ IM_ITEM_RECEIPT_BARCODE
 * - run: IB_SMT_CHECKHIST.SCAN_PARTNAME, 없으면 ISSUE.RUN_NO (컬럼 있을 때)
 * - lot / barcode: RECEIPT.ITEM_BARCODE·LOT_NO 또는 CHECKHIST.SCAN_PARTNAME
 * - feeder / refid: 한화 HW_* 없음 → 400
 */
import { NextRequest, NextResponse } from 'next/server';
import { executeQueryByProfile } from '@/lib/trace/db';
import { resolveTraceProfile } from '@/lib/trace/db';

export const dynamic = 'force-dynamic';

const CANDIDATE_LIMIT = 500;
const HANWHA_UNAVAILABLE =
  '한화/피더 역추적은 U1에서 사용할 수 없습니다 (IB_SMT_CHECKHIST 경로만 지원)';

function isMissingColumn(err: unknown): boolean {
  return /ORA-00904/i.test((err as Error)?.message ?? '');
}

export async function GET(req: NextRequest) {
  let profile: string;
  try {
    profile = resolveTraceProfile();
  } catch (err) {
    return NextResponse.json({ error: (err as Error).message }, { status: 502 });
  }

  const sp = req.nextUrl.searchParams;
  const mode = (sp.get('mode') ?? '').trim().toLowerCase();

  try {
    if (mode === 'issue') return await handleIssue(profile, sp);
    if (mode === 'run') return await handleRun(profile, sp);
    if (mode === 'lot') return await handleLot(profile, sp);
    if (mode === 'barcode') return await handleBarcode(profile, sp);
    if (mode === 'feeder' || mode === 'refid') {
      return NextResponse.json({ error: HANWHA_UNAVAILABLE }, { status: 400 });
    }
    return NextResponse.json(
      { error: 'mode 파라미터가 필요합니다 (issue | run | lot | barcode)' },
      { status: 400 },
    );
  } catch (err) {
    console.error('역추적 후보 API 오류:', err);
    return NextResponse.json(
      { error: `조회 실패: ${(err as Error).message}` },
      { status: 500 },
    );
  }
}

function jsonCandidates(mode: string, rows: Record<string, unknown>[]) {
  return NextResponse.json({ mode, candidates: rows, total: rows.length });
}

async function handleIssue(profile: string, sp: URLSearchParams) {
  const dateFrom = sp.get('dateFrom') ?? '';
  const dateTo = sp.get('dateTo') ?? '';
  const itemCode = sp.get('itemCode') ?? '';
  if (!dateFrom || !dateTo || !itemCode) {
    return NextResponse.json({ error: 'dateFrom, dateTo, itemCode 모두 필요합니다' }, { status: 400 });
  }

  const sql = `
    SELECT DISTINCT
           rb.ITEM_BARCODE                                  AS "reelCd",
           iss.ITEM_CODE                                    AS "itemCode",
           NVL(iss.MODEL_NAME, '-')                         AS "modelName",
           TO_CHAR(iss.ISSUE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "issueDate",
           iss.ISSUE_QTY                                    AS "issueQty",
           iss.MATERIAL_MFS                                 AS "lotNo"
      FROM IM_ITEM_ISSUE iss
      JOIN IM_ITEM_RECEIPT_BARCODE rb
        ON rb.LOT_NO = iss.MATERIAL_MFS AND rb.ITEM_CODE = iss.ITEM_CODE
     WHERE iss.ISSUE_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
       AND iss.ISSUE_DATE <  TO_DATE(:dateTo,   'YYYY-MM-DD') + 1
       AND iss.ITEM_CODE = :itemCode
       AND iss.ISSUE_DEFICIT = '3'
       AND iss.LOT_DIVIDE_SEQUENCE IS NULL
     ORDER BY "issueDate" DESC
     FETCH FIRST ${CANDIDATE_LIMIT} ROWS ONLY`;

  const rows = await executeQueryByProfile<Record<string, unknown>>(profile, sql, {
    dateFrom,
    dateTo,
    itemCode,
  });
  return jsonCandidates('issue', rows);
}

/** CHECKHIST SCAN_PARTNAME 우선. 없으면 ISSUE.RUN_NO (컬럼 없으면 빈 목록). */
async function handleRun(profile: string, sp: URLSearchParams) {
  const runNo = (sp.get('runNo') ?? '').trim();
  if (!runNo) {
    return NextResponse.json({ error: 'runNo 파라미터가 필요합니다' }, { status: 400 });
  }

  const checkSql = `
    SELECT DISTINCT
           c.SCAN_PARTNAME                                  AS "reelCd",
           c.ITEM_CODE                                      AS "itemCode",
           NVL(c.SMT_MODEL_NAME, '-')                       AS "modelName",
           TO_CHAR(c.CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "issueDate",
           c.SCAN_QTY                                       AS "issueQty",
           c.LOT_NO                                         AS "lotNo"
      FROM IB_SMT_CHECKHIST c
     WHERE c.RUN_NO = :runNo
       AND c.SCAN_PARTNAME IS NOT NULL
     ORDER BY "issueDate" DESC
     FETCH FIRST ${CANDIDATE_LIMIT} ROWS ONLY`;
  const checkSqlCore = `
    SELECT DISTINCT
           c.SCAN_PARTNAME                                  AS "reelCd",
           c.ITEM_CODE                                      AS "itemCode",
           '-'                                              AS "modelName",
           TO_CHAR(c.CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "issueDate",
           c.SCAN_QTY                                       AS "issueQty"
      FROM IB_SMT_CHECKHIST c
     WHERE c.RUN_NO = :runNo
       AND c.SCAN_PARTNAME IS NOT NULL
     ORDER BY "issueDate" DESC
     FETCH FIRST ${CANDIDATE_LIMIT} ROWS ONLY`;

  let checkRows: Record<string, unknown>[];
  try {
    checkRows = await executeQueryByProfile<Record<string, unknown>>(profile, checkSql, { runNo });
  } catch (err) {
    if (!isMissingColumn(err)) throw err;
    checkRows = await executeQueryByProfile<Record<string, unknown>>(profile, checkSqlCore, { runNo });
  }
  if (checkRows.length > 0) return jsonCandidates('run', checkRows);

  const issueSql = `
    SELECT DISTINCT
           rb.ITEM_BARCODE                                  AS "reelCd",
           iss.ITEM_CODE                                    AS "itemCode",
           NVL(iss.MODEL_NAME, '-')                         AS "modelName",
           TO_CHAR(iss.ISSUE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "issueDate",
           iss.ISSUE_QTY                                    AS "issueQty"
      FROM IM_ITEM_ISSUE iss
      JOIN IM_ITEM_RECEIPT_BARCODE rb
        ON rb.LOT_NO = iss.MATERIAL_MFS AND rb.ITEM_CODE = iss.ITEM_CODE
     WHERE iss.RUN_NO = :runNo
       AND iss.ISSUE_DEFICIT = '3'
       AND iss.LOT_DIVIDE_SEQUENCE IS NULL
     ORDER BY "issueDate" DESC
     FETCH FIRST ${CANDIDATE_LIMIT} ROWS ONLY`;

  try {
    const issueRows = await executeQueryByProfile<Record<string, unknown>>(profile, issueSql, { runNo });
    return jsonCandidates('run', issueRows);
  } catch (err) {
    if (!isMissingColumn(err)) throw err;
    return jsonCandidates('run', []);
  }
}

async function handleLot(profile: string, sp: URLSearchParams) {
  const lotNo = firstParam(sp, ['lotNo', 'value', 'lot']);
  if (!lotNo) {
    return NextResponse.json({ error: 'lotNo 파라미터가 필요합니다' }, { status: 400 });
  }

  const sql = `
    SELECT * FROM (
      SELECT DISTINCT
             rb.ITEM_BARCODE                                  AS "reelCd",
             rb.ITEM_CODE                                     AS "itemCode",
             NVL(rb.LOT_NO, :lotNo)                           AS "lotNo",
             TO_CHAR(rb.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "issueDate",
             rb.SCAN_QTY                                      AS "issueQty"
        FROM IM_ITEM_RECEIPT_BARCODE rb
       WHERE rb.LOT_NO = :lotNo
         AND rb.ITEM_BARCODE IS NOT NULL
      UNION
      SELECT DISTINCT
             c.SCAN_PARTNAME                                  AS "reelCd",
             c.ITEM_CODE                                      AS "itemCode",
             NVL(c.LOT_NO, :lotNo)                            AS "lotNo",
             TO_CHAR(c.CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "issueDate",
             c.SCAN_QTY                                       AS "issueQty"
        FROM IB_SMT_CHECKHIST c
       WHERE c.LOT_NO = :lotNo
         AND c.SCAN_PARTNAME IS NOT NULL
    )
     ORDER BY "issueDate" DESC NULLS LAST
     FETCH FIRST ${CANDIDATE_LIMIT} ROWS ONLY`;

  try {
    const rows = await executeQueryByProfile<Record<string, unknown>>(profile, sql, { lotNo });
    return jsonCandidates('lot', rows);
  } catch (err) {
    if (!isMissingColumn(err)) throw err;
    const receiptOnly = `
      SELECT DISTINCT
             rb.ITEM_BARCODE                                  AS "reelCd",
             rb.ITEM_CODE                                     AS "itemCode",
             rb.LOT_NO                                        AS "lotNo",
             TO_CHAR(rb.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "issueDate",
             rb.SCAN_QTY                                      AS "issueQty"
        FROM IM_ITEM_RECEIPT_BARCODE rb
       WHERE rb.LOT_NO = :lotNo
         AND rb.ITEM_BARCODE IS NOT NULL
       ORDER BY "issueDate" DESC
       FETCH FIRST ${CANDIDATE_LIMIT} ROWS ONLY`;
    const rows = await executeQueryByProfile<Record<string, unknown>>(profile, receiptOnly, { lotNo });
    return jsonCandidates('lot', rows);
  }
}

async function handleBarcode(profile: string, sp: URLSearchParams) {
  const barcode = firstParam(sp, ['barcode', 'value', 'reelCd', 'itemBarcode']);
  if (!barcode) {
    return NextResponse.json({ error: 'barcode 파라미터가 필요합니다' }, { status: 400 });
  }

  const sql = `
    SELECT * FROM (
      SELECT DISTINCT
             rb.ITEM_BARCODE                                  AS "reelCd",
             rb.ITEM_CODE                                     AS "itemCode",
             rb.LOT_NO                                        AS "lotNo",
             TO_CHAR(rb.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "issueDate",
             rb.SCAN_QTY                                      AS "issueQty"
        FROM IM_ITEM_RECEIPT_BARCODE rb
       WHERE rb.ITEM_BARCODE = :barcode
      UNION
      SELECT DISTINCT
             c.SCAN_PARTNAME                                  AS "reelCd",
             c.ITEM_CODE                                      AS "itemCode",
             c.LOT_NO                                         AS "lotNo",
             TO_CHAR(c.CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "issueDate",
             c.SCAN_QTY                                       AS "issueQty"
        FROM IB_SMT_CHECKHIST c
       WHERE c.SCAN_PARTNAME = :barcode
    )
     ORDER BY "issueDate" DESC NULLS LAST
     FETCH FIRST ${CANDIDATE_LIMIT} ROWS ONLY`;

  try {
    const rows = await executeQueryByProfile<Record<string, unknown>>(profile, sql, { barcode });
    return jsonCandidates('barcode', rows);
  } catch (err) {
    if (!isMissingColumn(err)) throw err;
    const receiptOnly = `
      SELECT DISTINCT
             rb.ITEM_BARCODE                                  AS "reelCd",
             rb.ITEM_CODE                                     AS "itemCode",
             rb.LOT_NO                                        AS "lotNo",
             TO_CHAR(rb.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "issueDate",
             rb.SCAN_QTY                                      AS "issueQty"
        FROM IM_ITEM_RECEIPT_BARCODE rb
       WHERE rb.ITEM_BARCODE = :barcode
       ORDER BY "issueDate" DESC
       FETCH FIRST ${CANDIDATE_LIMIT} ROWS ONLY`;
    const rows = await executeQueryByProfile<Record<string, unknown>>(profile, receiptOnly, { barcode });
    return jsonCandidates('barcode', rows);
  }
}

function firstParam(sp: URLSearchParams, keys: string[]): string {
  for (const key of keys) {
    const v = (sp.get(key) ?? '').trim();
    if (v) return v;
  }
  return '';
}
