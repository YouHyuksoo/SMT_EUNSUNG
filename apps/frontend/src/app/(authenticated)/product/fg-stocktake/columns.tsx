/**
 * @file src/app/(authenticated)/product/fg-stocktake/columns.tsx
 * @description 제품 실사표 컬럼
 */
import type { ColumnDef } from '@tanstack/react-table';
import type { FgCheckRow } from './fg-stocktake';

const right = { align: 'right' as const, filterType: 'number' as const };
const fmt = (v: unknown) => Number(v ?? 0).toLocaleString(undefined, { maximumFractionDigits: 4 });
const signed = (v: unknown) => {
  const n = Number(v ?? 0);
  if (!n) return fmt(0);
  return <span className={`font-semibold ${n > 0 ? 'text-emerald-500' : 'text-red-500'}`}>{n > 0 ? '+' : ''}{fmt(n)}</span>;
};

export const fgCheckColumns: ColumnDef<FgCheckRow>[] = [
  { accessorKey: 'barcode', header: '박스 바코드', size: 260 },
  { accessorKey: 'locationCode', header: '로케이션', size: 80, meta: { align: 'center' } },
  { accessorKey: 'modelName', header: '모델', size: 180 },
  { accessorKey: 'modelSuffix', header: '모델접미', size: 80, meta: { align: 'center' } },
  { accessorKey: 'itemCode', header: '품목코드', size: 120 },
  { accessorKey: 'bookQty', header: '장부수량', size: 100, meta: right, cell: (c) => fmt(c.getValue()) },
  { accessorKey: 'checkQty', header: '실사수량', size: 100, meta: right, cell: (c) => fmt(c.getValue()) },
  { accessorKey: 'differenceQty', header: '차이', size: 100, meta: right, cell: (c) => signed(c.getValue()) },
  {
    accessorKey: 'adjustedQty', header: '조정됨', size: 100, meta: right,
    cell: (c) => (c.getValue() == null ? '' : signed(c.getValue())),
  },
  {
    accessorKey: 'scannedYn', header: '센 여부', size: 70, meta: { align: 'center' },
    cell: (c) => (c.getValue() === 'Y' ? '센 박스' : <span className="text-text-muted">안 셈</span>),
  },
  { accessorKey: 'comments', header: '비고', size: 140 },
];
