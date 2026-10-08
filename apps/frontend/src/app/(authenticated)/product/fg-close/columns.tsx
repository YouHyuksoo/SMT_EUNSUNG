/**
 * @file src/app/(authenticated)/product/fg-close/columns.tsx
 * @description 제품 월마감 표 컬럼 (수량만)
 */
import type { ColumnDef } from '@tanstack/react-table';
import type { FgCloseLine } from './fg-close';

const fmt = (v: unknown) => {
  const n = Number(v ?? 0);
  return n ? n.toLocaleString(undefined, { maximumFractionDigits: 4 }) : '';
};
const num = (key: keyof FgCloseLine, header: string, size = 110, bold = false): ColumnDef<FgCloseLine> => ({
  accessorKey: key,
  header,
  size,
  meta: { align: 'right', filterType: 'number' },
  cell: (c) => {
    const v = Number(c.getValue() ?? 0);
    return <span className={`${v < 0 ? 'text-red-500' : ''} ${bold ? 'font-semibold' : ''}`}>{fmt(v)}</span>;
  },
});

export const fgCloseColumns: ColumnDef<FgCloseLine>[] = [
  { accessorKey: 'modelName', header: '모델', size: 200 },
  { accessorKey: 'modelSuffix', header: '모델접미', size: 80, meta: { align: 'center' } },
  { accessorKey: 'itemCode', header: '품목코드', size: 130 },
  num('openingQty', '기초수량'),
  num('receiptQty', '입고수량'),
  num('issueQty', '출고수량'),
  num('adjustQty', '재고조정'),
  num('endingQty', '기말수량', 120, true),
];
