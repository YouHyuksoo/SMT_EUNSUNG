/**
 * @file src/app/(authenticated)/warehouse/warehouse-columns.tsx
 * @description 자재창고 그리드 컬럼 — 1단계.
 *
 * 표시 규칙은 다른 대분류와 같다. 여기만의 규칙 하나:
 * **경과시간이 기준을 넘으면 눈에 들어와야 한다.** 챔버에 넣어 둔 자재는
 * 정해진 시간을 넘기면 다시 베이킹해야 하므로, 그 초과가 이 화면의 존재 이유다.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, num } from '@/components/shared/grid-format';
import type {
  ChamberStockDetailRow,
  ChamberStockSummaryRow,
  RecycleCheckRow,
} from './warehouse-types';
import { formatDisplayDate } from '@/utils/date';

const right = { align: 'right' } as const;
const center = { align: 'center' } as const;

const ts = (value: unknown) => (value ? formatDisplayDate(value) : '');
/** 시간은 소수 한 자리까지 (0.1시간 = 6분 단위면 현장 판단에 충분하다). */
const hours = (value: unknown) =>
  value == null ? '' : `${Number(value).toLocaleString(undefined, { maximumFractionDigits: 1 })}h`;

/**
 * 경과시간이 기준을 넘었는지 칠한다.
 *
 * 기준은 품목의 베이킹시간이고, 없으면 수명을 쓴다. 둘 다 없으면 칠하지 않는다 —
 * 기준을 모르는데 빨갛게 칠하면 거짓 경보가 된다.
 */
const lapseCell = (lapse: unknown, bakingTime: unknown, lifeCycle: unknown) => {
  const value = lapse == null ? null : Number(lapse);
  if (value == null) return '';
  const limit = Number(bakingTime ?? 0) > 0
    ? Number(bakingTime)
    : (Number(lifeCycle ?? 0) > 0 ? Number(lifeCycle) : 0);
  if (limit <= 0) return hours(value);
  if (value >= limit) {
    return <span className="font-semibold text-red-500">{hours(value)}</span>;
  }
  // 기준의 80% 를 넘으면 곧 넘는다는 뜻이다.
  if (value >= limit * 0.8) return <span className="text-amber-500">{hours(value)}</span>;
  return hours(value);
};

// ───────────────────────────────── 262·263·264 챔버 재고

export const chamberStockSummaryColumns: ColumnDef<ChamberStockSummaryRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 190 },
  {
    id: 'chamberName',
    header: '챔버',
    size: 170,
    accessorFn: (r) => codeWithName(r.chamberCode, r.chamberName),
  },
  { accessorKey: 'itemSpec', header: '규격', size: 170 },
  { accessorKey: 'supplierCode', header: '협력사', size: 110 },
  {
    accessorKey: 'countNum',
    header: '건수',
    size: 90,
    meta: right,
    cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
  },
  { accessorKey: 'lotQty', header: '수량 합계', size: 120, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'maxLapseHours',
    header: '최장 경과',
    size: 120,
    meta: right,
    // 이 묶음에서 가장 오래 들어 있는 것. 기준 초과면 빨강.
    cell: (c) => {
      const r = c.row.original as ChamberStockSummaryRow;
      return lapseCell(c.getValue(), r.bakingTime, r.lifeCycle);
    },
  },
  { accessorKey: 'bakingTime', header: '기준 베이킹', size: 120, meta: right, cell: (c) => hours(c.getValue()) },
  { accessorKey: 'lifeCycle', header: '수명', size: 100, meta: right, cell: (c) => hours(c.getValue()) },
  { accessorKey: 'mslLevel', header: 'MSL', size: 80, meta: center },
  { accessorKey: 'minScanDate', header: '가장 이른 입고', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'maxScanDate', header: '가장 늦은 입고', size: 160, cell: (c) => ts(c.getValue()) },
];

export const chamberStockDetailColumns: ColumnDef<ChamberStockDetailRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemBarcode', header: '자재 바코드', size: 200 },
  { accessorKey: 'lotNo', header: '자재 롯트', size: 150 },
  { accessorKey: 'lotQty', header: '수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inputScanDate', header: '입고 스캔', size: 160, cell: (c) => ts(c.getValue()) },
  {
    accessorKey: 'inputLapseTime',
    header: '경과시간',
    size: 110,
    meta: right,
    cell: (c) => {
      const r = c.row.original as ChamberStockDetailRow;
      return lapseCell(c.getValue(), r.bakingTime, r.lifeCycle);
    },
  },
  { accessorKey: 'bakingTime', header: '기준 베이킹', size: 120, meta: right, cell: (c) => hours(c.getValue()) },
  { accessorKey: 'lifeCycle', header: '수명', size: 100, meta: right, cell: (c) => hours(c.getValue()) },
  { accessorKey: 'mslLevel', header: 'MSL', size: 80, meta: center },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'itemClass', header: '품목분류', size: 110 },
  { accessorKey: 'height', header: '높이', size: 90, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'chamberLocation', header: '챔버 위치', size: 120 },
  {
    accessorKey: 'stdTempValue',
    header: '기준 온도',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'minTempValue', header: '하한 온도', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'maxTempValue', header: '상한 온도', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'supplierCode', header: '협력사', size: 110 },
  { accessorKey: 'scanBy', header: '스캔자', size: 100 },
  { accessorKey: 'enterBy', header: '등록자', size: 100 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

// ───────────────────────────────── 266 SMT 공릴체크

/** 판정 코드. 'P' 통과 · 'E' 오류 (실측 419 / 158). */
const CHECK_STATUS_LABEL: Record<string, string> = { P: '통과', E: '오류' };

export const recycleCheckColumns: ColumnDef<RecycleCheckRow>[] = [
  { accessorKey: 'checkDate', header: '체크시각', size: 170, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'checkSequence', header: '순번', size: 80, meta: right },
  {
    accessorKey: 'checkStatus',
    header: '판정',
    size: 90,
    meta: center,
    cell: (c) => {
      const v = String(c.getValue() ?? '');
      const label = CHECK_STATUS_LABEL[v] ?? v;
      return v === 'E'
        ? <span className="font-semibold text-red-500">{label}</span>
        : label;
    },
  },
  // 오류 사유. 통과 건은 비어 있는 것이 정상이다.
  { accessorKey: 'checkMsg', header: '사유', size: 280 },
  { accessorKey: 'scanPartName', header: '스캔 바코드', size: 220 },
  {
    id: 'lineName',
    header: '라인',
    size: 140,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'locationCode', header: '위치', size: 110 },
  { accessorKey: 'feedingDate', header: '투입시각', size: 170, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'checkBy', header: '체크자', size: 100 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];
