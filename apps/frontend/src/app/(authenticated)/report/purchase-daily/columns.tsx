/**
 * @file src/app/(authenticated)/report/purchase-daily/columns.tsx
 * @description 구매팀 일보 그리드 컬럼 — 요약은 백만 원, 상세는 원·수량 단위. 거래처는 장부 기초의 거래처 묶음이다.
 */
import type { ColumnDef, HeaderContext } from '@tanstack/react-table';

export interface PurchaseDailySummaryRow {
  bookGroup: string;
  itemCount: number;
  baseAmt: number;
  inAmt: number;
  outAmt: number;
  endAmt: number;
}

export interface PurchaseDailyDetailRow {
  bookGroup: string;
  itemClass: string | null;
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  unitPrice: number;
  baseQty: number;
  inQty: number;
  outQty: number;
  endQty: number;
  baseAmt: number;
  inAmt: number;
  outAmt: number;
  endAmt: number;
}

const right = { align: 'right' } as const;
const won = (v: unknown) => (v == null ? '' : Math.round(Number(v)).toLocaleString());
/** 백만 원 단위, 소수 첫째 자리까지. */
const million = (v: unknown) =>
  v == null
    ? ''
    : (Number(v) / 1_000_000).toLocaleString(undefined, { minimumFractionDigits: 1, maximumFractionDigits: 1 });
const qty = (v: unknown) => (v == null ? '' : Number(v).toLocaleString());
const price = (v: unknown) =>
  v == null ? '' : Number(v).toLocaleString(undefined, { maximumFractionDigits: 4 });

const sumOf =
  <T,>(id: string, format: (v: number) => string) =>
  ({ table }: HeaderContext<T, unknown>) =>
    format(table.getFilteredRowModel().rows.reduce((s, r) => s + Number(r.getValue(id) ?? 0), 0));

const bold = (text: string) => <span className="font-semibold">{text}</span>;

export const purchaseDailySummaryColumns: ColumnDef<PurchaseDailySummaryRow>[] = [
  { accessorKey: 'bookGroup', header: '거래처', size: 200, footer: '합계' },
  { accessorKey: 'itemCount', header: '품목수', size: 90, meta: right, cell: (c) => qty(c.getValue()), footer: sumOf<PurchaseDailySummaryRow>('itemCount', qty) },
  { accessorKey: 'baseAmt', header: '기초재고', size: 120, meta: right, cell: (c) => million(c.getValue()), footer: sumOf<PurchaseDailySummaryRow>('baseAmt', million) },
  { accessorKey: 'inAmt', header: '입고누계', size: 120, meta: right, cell: (c) => million(c.getValue()), footer: sumOf<PurchaseDailySummaryRow>('inAmt', million) },
  { accessorKey: 'outAmt', header: '출고누계', size: 120, meta: right, cell: (c) => million(c.getValue()), footer: sumOf<PurchaseDailySummaryRow>('outAmt', million) },
  { accessorKey: 'endAmt', header: '현재고', size: 120, meta: right, cell: (c) => bold(million(c.getValue())), footer: sumOf<PurchaseDailySummaryRow>('endAmt', million) },
];

export const purchaseDailyDetailColumns: ColumnDef<PurchaseDailyDetailRow>[] = [
  { accessorKey: 'bookGroup', header: '거래처', size: 150, footer: '합계' },
  { accessorKey: 'itemClass', header: '구분', size: 80 },
  { accessorKey: 'itemCode', header: '품번', size: 150 },
  { accessorKey: 'itemName', header: '품명', size: 220 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'unitPrice', header: '단가', size: 100, meta: right, cell: (c) => price(c.getValue()) },
  { accessorKey: 'baseQty', header: '기초수량', size: 110, meta: right, cell: (c) => qty(c.getValue()), footer: sumOf<PurchaseDailyDetailRow>('baseQty', qty) },
  { accessorKey: 'inQty', header: '입고수량', size: 110, meta: right, cell: (c) => qty(c.getValue()), footer: sumOf<PurchaseDailyDetailRow>('inQty', qty) },
  { accessorKey: 'outQty', header: '출고수량', size: 110, meta: right, cell: (c) => qty(c.getValue()), footer: sumOf<PurchaseDailyDetailRow>('outQty', qty) },
  { accessorKey: 'endQty', header: '현재수량', size: 110, meta: right, cell: (c) => bold(qty(c.getValue())), footer: sumOf<PurchaseDailyDetailRow>('endQty', qty) },
  { accessorKey: 'baseAmt', header: '기초금액', size: 130, meta: right, cell: (c) => won(c.getValue()), footer: sumOf<PurchaseDailyDetailRow>('baseAmt', won) },
  { accessorKey: 'inAmt', header: '입고금액', size: 130, meta: right, cell: (c) => won(c.getValue()), footer: sumOf<PurchaseDailyDetailRow>('inAmt', won) },
  { accessorKey: 'outAmt', header: '출고금액', size: 130, meta: right, cell: (c) => won(c.getValue()), footer: sumOf<PurchaseDailyDetailRow>('outAmt', won) },
  { accessorKey: 'endAmt', header: '현재금액', size: 130, meta: right, cell: (c) => bold(won(c.getValue())), footer: sumOf<PurchaseDailyDetailRow>('endAmt', won) },
];
