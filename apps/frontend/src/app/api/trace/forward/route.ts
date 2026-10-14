/**
 * @file src/app/api/trace/forward/route.ts
 * @description 정추적 API. webdisplay U1 정추적(api/u1/traceability)을 가져왔다.
 *
 * 초보자 가이드:
 * - GET ?mode=tables → 고정 마스터 + IQ 목록 + defaultTables (체크박스 초기값)
 * - GET ?barcode=PID → 마스터 + 타임라인. tables 생략=기본 부분집합, tables=all=전체.
 * - DB 실행은 lib/trace/db.ts (은성 MES 활성 프로필 메인 풀).
 * - HW_* / LOG_* / ROWNUM=1 금지. 같은 PID 의 Bot+Top RUN + PAIR 짝 시리얼을 모두 조회한다.
 */
import { NextRequest, NextResponse } from 'next/server';
import { resolveTraceProfile } from '@/lib/trace/db';
import { isU1TraceDefaultIqTable, listIqMachineTraceTables } from '@/lib/trace/trace-tables';
import { fetchU1Traceability, U1_TRACE_FIXED_TABLES } from '@/lib/trace/trace-sql';

export const dynamic = 'force-dynamic';

export async function GET(req: NextRequest) {
  let profile: string;
  try {
    profile = resolveTraceProfile();
  } catch (err) {
    return NextResponse.json({ error: (err as Error).message }, { status: 502 });
  }

  const mode = req.nextUrl.searchParams.get('mode') ?? '';

  if (mode === 'tables') {
    try {
      const iq = await listIqMachineTraceTables(profile);
      const iqNames = iq.map((t) => t.tableName);
      return NextResponse.json({
        tables: [...U1_TRACE_FIXED_TABLES, ...iqNames],
        defaultTables: [
          ...U1_TRACE_FIXED_TABLES,
          ...iqNames.filter((name) => isU1TraceDefaultIqTable(name)),
        ],
      });
    } catch (err) {
      return NextResponse.json({ error: (err as Error).message }, { status: 500 });
    }
  }

  const barcode = req.nextUrl.searchParams.get('barcode')?.trim() ?? '';
  if (!barcode) {
    return NextResponse.json({ error: 'barcode 파라미터가 필요합니다' }, { status: 400 });
  }

  const orgId = req.nextUrl.searchParams.get('orgId')?.trim() || null;
  const tablesParam = req.nextUrl.searchParams.get('tables') ?? '';
  const iqMode = tablesParam === 'all' ? 'all' : 'default';
  const selectedTables =
    tablesParam && tablesParam !== 'all'
      ? new Set(tablesParam.split(',').map((s) => s.trim()).filter(Boolean))
      : null;

  try {
    const data = await fetchU1Traceability(profile, { barcode, orgId, selectedTables, iqMode });
    return NextResponse.json(data);
  } catch (err) {
    console.error('정추적 API 오류:', err);
    return NextResponse.json(
      { error: `조회 실패: ${(err as Error).message}` },
      { status: 500 },
    );
  }
}
