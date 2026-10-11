/**
 * @file src/app/(authenticated)/process-transaction/wip-close/columns.tsx
 * @description 공정재고 월마감 표 컬럼
 */
import type { ColumnDef } from '@tanstack/react-table';
import type { WipCloseLine } from './wip-close';

const fmt = (v: unknown, digits = 0) => {
  const n = Number(v ?? 0);
  return n ? n.toLocaleString(undefined, { maximumFractionDigits: digits }) : '';
};
const num = (key: keyof WipCloseLine, header: string, size = 100, digits = 0, bold = false): ColumnDef<WipCloseLine> => ({
  accessorKey: key,
  header,
  size,
  meta: { align: 'right', filterType: 'number' },
  cell: (c) => {
    const v = Number(c.getValue() ?? 0);
    return <span className={`${v < 0 ? 'text-red-500' : ''} ${bold ? 'font-semibold' : ''}`}>{fmt(v, digits)}</span>;
  },
});

/**
 * 조정 칸 — 공정출고는 부족을 출고(+)로 쌓지만, 화면은 실사 화면과 같게 "실사 − 장부"(부족 −, 남음 +)로 보여준다.
 * accessorFn 으로 뒤집으므로 필터·엑셀 내보내기도 같은 부호를 쓴다.
 */
const adjust = (key: 'adjustQty' | 'adjustAmt', header: string, size: number, digits = 0): ColumnDef<WipCloseLine> => ({
  id: key,
  accessorFn: (r) => -Number(r[key] ?? 0),
  header,
  size,
  meta: { align: 'right', filterType: 'number' },
  cell: (c) => {
    const v = Number(c.getValue() ?? 0);
    return <span className={v < 0 ? 'text-red-500' : ''}>{fmt(v, digits)}</span>;
  },
});

export const wipCloseColumns: ColumnDef<WipCloseLine>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 130 },
  { accessorKey: 'itemName', header: '품목명', size: 170 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'itemUom', header: '단위', size: 60, meta: { align: 'center' } },
  num('openingQty', '기초수량', 100, 4),
  num('openingAmt', '기초금액', 110),
  num('receiptQty', '입고수량', 100, 4),
  num('receiptAmt', '입고금액', 110),
  num('issueQty', '출고수량', 100, 4),
  num('issueAmt', '출고금액', 110),
  adjust('adjustQty', '재고조정(실사−장부)', 110, 4),
  adjust('adjustAmt', '조정금액(실사−장부)', 120),
  num('avgPrice', '단가', 90, 4),
  num('endingQty', '기말수량', 100, 4, true),
  num('endingAmt', '기말금액', 120, 0, true),
];
