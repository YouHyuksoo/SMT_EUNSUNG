import { NextResponse } from 'next/server';
import { executeQuery } from '@/lib/db';
import { buildInFilter } from '@/lib/display-helpers';
import {
  sqlFctByModel,
  sqlFctFpyTrend,
  sqlFctSummary,
  sqlFctTodayLineCompare,
  sqlFctTopModels,
  sqlFctWeeklyLineCompare,
} from '@/lib/queries/fct-chart';
import type {
  FctFpyRow,
  FctLineCompareRow,
  FctModelRow,
  FctSummaryRow,
  FctTopModelRow,
} from '@/lib/queries/fct-chart';

const BARCODE_CHUNK_SIZE = 700;

interface BarcodeRow {
  SERIAL_NO: string;
  MODEL_NAME: string | null;
  LINE_CODE: string | null;
}

async function fetchBarcodeMap(pids: string[]): Promise<Map<string, { modelName: string | null; lineCode: string | null }>> {
  const uniquePids = Array.from(new Set(pids.filter(Boolean))).slice(0, 10000);
  const map = new Map<string, { modelName: string | null; lineCode: string | null }>();

  for (let start = 0; start < uniquePids.length; start += BARCODE_CHUNK_SIZE) {
    const chunk = uniquePids.slice(start, start + BARCODE_CHUNK_SIZE);
    const binds = Object.fromEntries(chunk.map((pid, idx) => [`pid${idx}`, pid]));
    const placeholders = chunk.map((_, idx) => `:pid${idx}`).join(', ');
    const rows = await executeQuery<BarcodeRow>(
      `
SELECT
  SERIAL_NO,
  MAX(MODEL_NAME) AS MODEL_NAME,
  MAX(LINE_CODE) AS LINE_CODE
FROM IP_PRODUCT_2D_BARCODE
WHERE SERIAL_NO IN (${placeholders})
GROUP BY SERIAL_NO
`,
      binds,
    );

    for (const row of rows) {
      map.set(row.SERIAL_NO, { modelName: row.MODEL_NAME, lineCode: row.LINE_CODE });
    }
  }

  return map;
}

function applyBarcodeModelNames<T extends { MODEL_NAME: string; SAMPLE_PID?: string }>(
  rows: T[],
  barcodeMap: Map<string, { modelName: string | null; lineCode: string | null }>,
): T[] {
  return rows.map((row) => {
    const barcodeModel = row.SAMPLE_PID ? barcodeMap.get(row.SAMPLE_PID)?.modelName?.trim() : null;
    return {
      ...row,
      MODEL_NAME: barcodeModel || row.MODEL_NAME,
    };
  });
}

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const linesParam = searchParams.get('lines') ?? '%';
  const lineCodes = linesParam.split(',').map((s) => s.trim()).filter(Boolean);
  const { clause, binds } = buildInFilter(lineCodes, 'f.LINE_CODE', 'line');

  try {
    const [byModelRows, fpyTrend, summaryRows, topModelRows, todayLines, weeklyLines] = await Promise.all([
      executeQuery<FctModelRow>(sqlFctByModel(clause), binds),
      executeQuery<FctFpyRow>(sqlFctFpyTrend(clause), binds),
      executeQuery<FctSummaryRow>(sqlFctSummary(clause), binds),
      executeQuery<FctTopModelRow>(sqlFctTopModels(clause), binds),
      executeQuery<FctLineCompareRow>(sqlFctTodayLineCompare(clause), binds),
      executeQuery<FctLineCompareRow>(sqlFctWeeklyLineCompare(clause), binds),
    ]);

    const samplePids = [
      ...byModelRows.map((row) => row.SAMPLE_PID),
      ...topModelRows.map((row) => row.SAMPLE_PID),
    ].filter((pid): pid is string => Boolean(pid));
    const barcodeMap = await fetchBarcodeMap(samplePids);

    return NextResponse.json({
      byModel: applyBarcodeModelNames(byModelRows, barcodeMap),
      fpyTrend,
      summary: summaryRows[0] ?? {
        TOTAL_INSPECTED: 0,
        TOTAL_GOOD: 0,
        TOTAL_DEFECTS: 0,
        DEFECT_RATE: 0,
        FPY_RATE: 0,
      },
      topModels: applyBarcodeModelNames(topModelRows, barcodeMap),
      todayLines,
      weeklyLines,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error('[API /display/42] Error:', error);
    return NextResponse.json(
      { error: 'Database query failed', byModel: [], fpyTrend: [], summary: null, topModels: [], todayLines: [], weeklyLines: [] },
      { status: 500 },
    );
  }
}
