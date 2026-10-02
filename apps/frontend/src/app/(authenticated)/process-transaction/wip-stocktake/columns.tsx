/**
 * @file src/app/(authenticated)/process-transaction/wip-stocktake/columns.tsx
 * @description 공정 실사표 · 입력 기록 컬럼
 */
import type { ColumnDef } from '@tanstack/react-table';
import type { WipCheckRow, WipEntryRow } from './wip-stocktake';

const right = { align: 'right' as const, filterType: 'number' as const };
const fmt = (v: unknown) => Number(v ?? 0).toLocaleString(undefined, { maximumFractionDigits: 4 });
const signed = (v: unknown) => {
  const n = Number(v ?? 0);
  if (!n) return fmt(0);
  return <span className={`font-semibold ${n > 0 ? 'text-emerald-500' : 'text-red-500'}`}>{n > 0 ? '+' : ''}{fmt(n)}</span>;
};

export const wipCheckColumns: ColumnDef<WipCheckRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 130 },
  { accessorKey: 'itemName', header: '품목명', size: 170 },
  { accessorKey: 'itemSpec', header: '규격', size: 180 },
  { accessorKey: 'lineType', header: '거래유형', size: 70, meta: { align: 'center' } },
  { accessorKey: 'bookQty', header: '장부수량', size: 120, meta: right, cell: (c) => fmt(c.getValue()) },
  { accessorKey: 'checkQty', header: '실사수량', size: 110, meta: right, cell: (c) => fmt(c.getValue()) },
  { accessorKey: 'differenceQty', header: '차이', size: 120, meta: right, cell: (c) => signed(c.getValue()) },
  {
    accessorKey: 'adjustedQty', header: '조정됨', size: 120, meta: right,
    cell: (c) => (c.getValue() == null ? '' : signed(c.getValue())),
  },
  { accessorKey: 'entries', header: '입력', size: 60, meta: right, cell: (c) => (Number(c.getValue()) ? fmt(c.getValue()) : '') },
  { accessorKey: 'itemUom', header: '단위', size: 60, meta: { align: 'center' } },
  { accessorKey: 'comments', header: '비고', size: 140 },
];

export const wipEntryColumns: ColumnDef<WipEntryRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 130 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130, cell: (c) => (c.getValue() as string | null) ?? '품목 입력' },
  { accessorKey: 'lineCode', header: '라인', size: 80, meta: { align: 'center' } },
  { accessorKey: 'qty', header: '수량', size: 110, meta: right, cell: (c) => fmt(c.getValue()) },
];
