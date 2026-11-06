/**
 * @file src/app/api/trace/forward/barcodes/route.ts
 * @description 정추적 바코드 목록 API. webdisplay U1 바코드 목록(api/u1/traceability/barcodes)을 가져왔다.
 *
 * 초보자 가이드:
 * - 구버전: GET ?runNo=XXXX
 * - GET ?mode=runNo|magazine|box&value=XXX  (IP_PRODUCT_2D_BARCODE 인덱스 컬럼만. 팔레트·캐리어는 인덱스가 없어 막는다)
 * - GET ?mode=repair&dateFrom=&dateTo=&itemCode=
 * - GET ?mode=spi|aoi&dateFrom=&dateTo=  → IQ_MACHINE_INSPECT_DATA_* INSPECT_DATE (PID).
 * - 같은 SERIAL 이 두 라인이면 목록에 한 번. meta.lines + 행.lines 에 LINE_CODE.
 * - PCB_ITEM 은 VN 2D 에 없을 수 있다. 없으면 null (또는 단일 라인의 LINE_CODE).
 */
import { NextRequest, NextResponse } from 'next/server';
import { executeQueryByProfile } from '@/lib/trace/db';
import { resolveTraceProfile } from '@/lib/trace/db';
import { loadLineNameMap, toLineName } from '@/lib/trace/line-names';


export const dynamic = 'force-dynamic';

interface RawBarcodeRow {
  SERIAL_NO: string | null;
  PCB_ITEM?: string | null;
  LINE_CODE?: string | null;
}

interface BarcodeItem {
  SERIAL_NO: string;
  PCB_ITEM: string | null;
  lines: string[];
}

type SingleMode = 'barcode' | 'runNo' | 'magazine' | 'box';

const SINGLE_MODE_COLUMN: Record<SingleMode, string> = {
  barcode: 'SERIAL_NO',
  runNo: 'RUN_NO',
  magazine: 'MAGAZINE_NO',
  box: 'BOX_NO',
};

const YMD = /^\d{4}-\d{2}-\d{2}$/;
const BARCODE_LIMIT = 1000;

const SPI_TABLE = 'IQ_MACHINE_INSPECT_DATA_SPI';
const AOI_TABLE = 'IQ_MACHINE_INSPECT_DATA_AOI';

function isMissingColumn(err: unknown): boolean {
  return /ORA-00904/i.test((err as Error)?.message ?? '');
}

function collapseRows(rows: RawBarcodeRow[]): { barcodes: BarcodeItem[]; lines: string[] } {
  const bySerial = new Map<string, { pcb: Set<string>; lines: string[] }>();
  for (const row of rows) {
    const serial = String(row.SERIAL_NO ?? '').trim();
    if (!serial) continue;
    let cur = bySerial.get(serial);
    if (!cur) {
      cur = { pcb: new Set(), lines: [] };
      bySerial.set(serial, cur);
    }
    const line = row.LINE_CODE == null ? '' : String(row.LINE_CODE).trim();
    if (line && !cur.lines.includes(line)) cur.lines.push(line);
    const pcb = row.PCB_ITEM == null ? '' : String(row.PCB_ITEM).trim();
    if (pcb) cur.pcb.add(pcb);
  }

  const barcodes: BarcodeItem[] = [...bySerial.entries()].map(([SERIAL_NO, cur]) => {
    let pcbItem: string | null = null;
    if (cur.pcb.size === 1) pcbItem = [...cur.pcb][0];
    else if (cur.pcb.size === 0 && cur.lines.length === 1) pcbItem = cur.lines[0];
    return { SERIAL_NO, PCB_ITEM: pcbItem, lines: cur.lines };
  });

  const lines = [...new Set(barcodes.flatMap((b) => b.lines))].sort();
  barcodes.sort((a, b) => a.SERIAL_NO.localeCompare(b.SERIAL_NO));
  return { barcodes, lines };
}

async function jsonList(profile: string, rows: RawBarcodeRow[]) {
  const { barcodes, lines } = collapseRows(rows);
  const names = await loadLineNameMap(profile);
  const sliced = barcodes.slice(0, BARCODE_LIMIT).map((b) => ({
    ...b,
    PCB_ITEM:
      b.PCB_ITEM && b.lines.includes(b.PCB_ITEM)
        ? toLineName(names, b.PCB_ITEM) || b.PCB_ITEM
        : b.PCB_ITEM,
    lines: b.lines.map((line) => toLineName(names, line) || line),
  }));
  return NextResponse.json({
    barcodes: sliced,
    total: sliced.length,
    lines: lines.map((line) => toLineName(names, line) || line),
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
  const mode = sp.get('mode');
  const legacyRunNo = sp.get('runNo')?.trim() ?? '';

  try {
    if (!mode && legacyRunNo) {
      return jsonList(profile, await querySingle(profile, 'RUN_NO', legacyRunNo));
    }

    if (mode && mode in SINGLE_MODE_COLUMN) {
      const value = sp.get('value')?.trim() ?? '';
      if (!value) {
        return NextResponse.json({ error: 'value 파라미터가 필요합니다' }, { status: 400 });
      }
      return jsonList(profile, await querySingle(profile, SINGLE_MODE_COLUMN[mode as SingleMode], value));
    }

    if (mode === 'repair') {
      const dateFrom = sp.get('dateFrom')?.trim() ?? '';
      const dateTo = sp.get('dateTo')?.trim() ?? '';
      const itemCode = sp.get('itemCode')?.trim() ?? '';
      if (!dateFrom || !dateTo || !itemCode) {
        return NextResponse.json(
          { error: 'dateFrom, dateTo, itemCode 파라미터가 모두 필요합니다' },
          { status: 400 },
        );
      }
      if (!YMD.test(dateFrom) || !YMD.test(dateTo)) {
        return NextResponse.json({ error: '날짜는 YYYY-MM-DD 형식이어야 합니다' }, { status: 400 });
      }
      return jsonList(profile, await queryRepair(profile, dateFrom, dateTo, itemCode));
    }

    if (mode === 'spi' || mode === 'aoi') {
      const dateFrom = sp.get('dateFrom')?.trim() ?? '';
      const dateTo = sp.get('dateTo')?.trim() ?? '';
      if (!dateFrom || !dateTo) {
        return NextResponse.json(
          { error: 'dateFrom, dateTo 파라미터가 필요합니다' },
          { status: 400 },
        );
      }
      if (!YMD.test(dateFrom) || !YMD.test(dateTo)) {
        return NextResponse.json({ error: '날짜는 YYYY-MM-DD 형식이어야 합니다' }, { status: 400 });
      }
      return jsonList(profile, await queryInspect(profile, mode, dateFrom, dateTo));
    }

    return NextResponse.json(
      { error: 'mode 또는 runNo 파라미터가 필요합니다' },
      { status: 400 },
    );
  } catch (err) {
    console.error('정추적 바코드 목록 조회 실패:', err);
    return NextResponse.json(
      { error: `조회 실패: ${(err as Error).message}` },
      { status: 500 },
    );
  }
}

async function querySingle(profile: string, column: string, value: string): Promise<RawBarcodeRow[]> {
  const withPcb = `SELECT SERIAL_NO, LINE_CODE, PCB_ITEM
                     FROM IP_PRODUCT_2D_BARCODE
                    WHERE ${column} = :val`;
  const noPcb = `SELECT SERIAL_NO, LINE_CODE, NULL AS PCB_ITEM
                   FROM IP_PRODUCT_2D_BARCODE
                  WHERE ${column} = :val`;
  const min = `SELECT SERIAL_NO, NULL AS PCB_ITEM
                 FROM IP_PRODUCT_2D_BARCODE
                WHERE ${column} = :val`;
  try {
    return await executeQueryByProfile<RawBarcodeRow>(profile, withPcb, { val: value });
  } catch (err) {
    if (!isMissingColumn(err)) throw err;
    try {
      return await executeQueryByProfile<RawBarcodeRow>(profile, noPcb, { val: value });
    } catch (err2) {
      if (!isMissingColumn(err2)) throw err2;
      return executeQueryByProfile<RawBarcodeRow>(profile, min, { val: value });
    }
  }
}

async function queryRepair(
  profile: string,
  dateFrom: string,
  dateTo: string,
  itemCode: string,
): Promise<RawBarcodeRow[]> {
  const withLine = `SELECT DISTINCT SERIAL_NO, LINE_CODE, NULL AS PCB_ITEM
                      FROM IP_PRODUCT_WORK_QC
                     WHERE QC_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
                       AND QC_DATE <  TO_DATE(:dateTo,   'YYYY-MM-DD') + 1
                       AND ITEM_CODE = :itemCode
                       AND SERIAL_NO IS NOT NULL`;
  const noLine = `SELECT DISTINCT SERIAL_NO, NULL AS PCB_ITEM
                    FROM IP_PRODUCT_WORK_QC
                   WHERE QC_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
                     AND QC_DATE <  TO_DATE(:dateTo,   'YYYY-MM-DD') + 1
                     AND ITEM_CODE = :itemCode
                     AND SERIAL_NO IS NOT NULL`;
  const binds = { dateFrom, dateTo, itemCode };
  try {
    return await executeQueryByProfile<RawBarcodeRow>(profile, withLine, binds);
  } catch (err) {
    if (!isMissingColumn(err)) throw err;
    return executeQueryByProfile<RawBarcodeRow>(profile, noLine, binds);
  }
}

async function queryInspect(
  profile: string,
  mode: 'spi' | 'aoi',
  dateFrom: string,
  dateTo: string,
): Promise<RawBarcodeRow[]> {
  const table = mode === 'spi' ? SPI_TABLE : AOI_TABLE;
  /* 은성 SPI/AOI 에는 ACTUAL_DATE 가 없다. INSPECT_DATE 는 VARCHAR2 'YYYY/MM/DD HH24:MI:SS' 이고
     (INSPECT_DATE, PID) 인덱스가 있어서 컬럼에 함수를 걸지 않고 문자열 범위로 비교한다. */
  const datePred = `INSPECT_DATE >= :fromStr
       AND INSPECT_DATE <  :toStr`;
  const withLine = `SELECT PID AS SERIAL_NO, LINE_CODE, NULL AS PCB_ITEM
                      FROM ${table}
                     WHERE PID IS NOT NULL
                       AND ${datePred}
                     GROUP BY PID, LINE_CODE
                     FETCH FIRST ${BARCODE_LIMIT * 2} ROWS ONLY`;
  const noLine = `SELECT DISTINCT PID AS SERIAL_NO, NULL AS PCB_ITEM
                    FROM ${table}
                   WHERE PID IS NOT NULL
                     AND ${datePred}
                   FETCH FIRST ${BARCODE_LIMIT} ROWS ONLY`;
  const binds = { fromStr: inspectDateStr(dateFrom, 0), toStr: inspectDateStr(dateTo, 1) };
  try {
    return await executeQueryByProfile<RawBarcodeRow>(profile, withLine, binds);
  } catch (err) {
    if (!isMissingColumn(err)) throw err;
    return executeQueryByProfile<RawBarcodeRow>(profile, noLine, binds);
  }
}

/** 'YYYY-MM-DD' + addDays → INSPECT_DATE 비교용 'YYYY/MM/DD 00:00:00' */
function inspectDateStr(ymd: string, addDays: number): string {
  const d = new Date(`${ymd}T00:00:00Z`);
  d.setUTCDate(d.getUTCDate() + addDays);
  return `${d.toISOString().slice(0, 10).replace(/-/g, '/')} 00:00:00`;
}
