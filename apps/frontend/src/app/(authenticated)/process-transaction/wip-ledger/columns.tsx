/**
 * @file src/app/(authenticated)/process-transaction/wip-ledger/columns.tsx
 * @description 공정입출고내역 컬럼 — 품목별 합계 · 건별 내역
 */
import type { ColumnDef } from '@tanstack/react-table';

export type WipLedgerKind = 'R' | 'I' | 'A';

export const KIND_LABEL: Record<WipLedgerKind, string> = { R: '입고', I: '생산투입', A: '실사조정' };

export interface WipLedgerSummaryRow {
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  receiptQty: number;
  issueQty: number;
  adjustQty: number;
  netQty: number;
  count: number;
  currentQty: number;
}

export interface WipLedgerDetailRow {
  kind: WipLedgerKind;
  txnDate: string;
  seq: number;
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  deficit: string | null;
  qty: number;
  stockEffect: number;
  productCode: string | null;
  productName: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

const fmtQty = (v: unknown) => Number(v ?? 0).toLocaleString();
const signedCell = (v: unknown) => {
  const n = Number(v ?? 0);
  const cls = n > 0 ? 'text-emerald-600' : n < 0 ? 'text-red-500' : 'text-text-muted';
  return <span className={`block text-right ${cls}`}>{n > 0 ? '+' : ''}{n.toLocaleString()}</span>;
};
const qtyCell = (v: unknown) => <span className="block text-right">{fmtQty(v)}</span>;
const dateOnly = (v: unknown) => (v ? String(v).slice(0, 10) : '');
const dateTime = (v: unknown) => (v ? String(v).replace('T', ' ').slice(0, 19) : '');

export const summaryColumns: ColumnDef<WipLedgerSummaryRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'itemUom', header: '단위', size: 60 },
  { accessorKey: 'receiptQty', header: '입고', size: 110, cell: (c) => qtyCell(c.getValue()) },
  { accessorKey: 'issueQty', header: '생산투입', size: 110, cell: (c) => qtyCell(c.getValue()) },
  { accessorKey: 'adjustQty', header: '실사조정', size: 100, cell: (c) => qtyCell(c.getValue()) },
  { accessorKey: 'netQty', header: '순증감', size: 110, cell: (c) => signedCell(c.getValue()) },
  { accessorKey: 'currentQty', header: '지금 공정재고', size: 120, cell: (c) => qtyCell(c.getValue()) },
  { accessorKey: 'count', header: '건수', size: 80, cell: (c) => qtyCell(c.getValue()) },
];

export const detailColumns: ColumnDef<WipLedgerDetailRow>[] = [
  { accessorKey: 'txnDate', header: '일자', size: 100, cell: (c) => dateOnly(c.getValue()) },
  {
    accessorKey: 'kind', header: '구분', size: 90,
    cell: (c) => KIND_LABEL[c.getValue() as WipLedgerKind] ?? String(c.getValue() ?? ''),
  },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 150 },
  { accessorKey: 'qty', header: '수량', size: 100, cell: (c) => qtyCell(c.getValue()) },
  { accessorKey: 'stockEffect', header: '공정재고 증감', size: 120, cell: (c) => signedCell(c.getValue()) },
  { accessorKey: 'productCode', header: '투입 제품', size: 150 },
  { accessorKey: 'productName', header: '투입 제품명', size: 220 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록시각', size: 150, cell: (c) => dateTime(c.getValue()) },
];
