/**
 * @file route.ts
 * @description 제품생산현황 API (메뉴 21).
 * 초보자 가이드: GET /api/display/21?lines=S01,S02 로 호출하면 선택 라인만 조회한다.
 * lines 파라미터가 없거나 '%'이면 전체 라인 조회.
 */
import { NextResponse } from 'next/server';
import { executeQuery } from '@/lib/db';
import { buildInFilter } from '@/lib/display-helpers';
import { sqlProductLineMonitoring } from '@/lib/queries/product-line-monitoring';

interface ProductionLineRow {
  LINE_NAME: string;
  LINE_CODE: string;
  LINE_STATUS: string;
  MODEL_NAME: string | null;
  PRODUCT_RUN_TYPE: string | null;
  RUN_DATE: string | null;
  ACTUAL_DATE: string | null;
  RUNNING_LOT_PLAN_QTY: number | null;
  RUNNING_LOT_ACTUAL_QTY: number | null;
  RUNNING_LOT_NG_QTY: number | null;
}

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const linesParam = searchParams.get('lines') ?? '%';
    const lineCodes = linesParam.split(',').map((s) => s.trim()).filter(Boolean);
    const { clause, binds } = buildInFilter(lineCodes, 'LINE_CODE', 'line');
    const lines = await executeQuery<ProductionLineRow>(sqlProductLineMonitoring(clause), binds);
    return NextResponse.json({ lines, timestamp: new Date().toISOString() });
  } catch (error) {
    console.error('[API /display/21] Error:', error);
    return NextResponse.json(
      { error: 'Database query failed', lines: [] },
      { status: 500 },
    );
  }
}
