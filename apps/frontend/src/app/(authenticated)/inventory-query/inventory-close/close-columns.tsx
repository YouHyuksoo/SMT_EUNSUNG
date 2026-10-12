/**
 * @file src/app/(authenticated)/inventory-query/inventory-close/close-columns.tsx
 * @description 271 원자재 월마감 표 컬럼
 */
import type { ColumnDef } from '@tanstack/react-table';

export interface CloseLine {
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  lineType: string;
  locationCode: string;
  openingQty: number;
  openingPrice: number;
  openingAmt: number;
  receiptQty: number;
  receiptAmt: number;
  massQty: number;
  badQty: number;
  freeQty: number;
  saleQty: number;
  extraQty: number;
  adjustQty: number;
  adjustAmt: number;
  issueQty: number;
  issueAmt: number;
  avgPrice: number;
  endingQty: number;
  endingAmt: number;
  tablePriced?: number;
  unpriced?: number;
}

const fmt = (v: unknown, digits = 0) => {
  const n = Number(v ?? 0);
  return n ? n.toLocaleString(undefined, { maximumFractionDigits: digits }) : '';
};
const num = (key: keyof CloseLine, header: string, size = 100, digits = 0): ColumnDef<CloseLine> => ({
  accessorKey: key,
  header,
  size,
  meta: { align: 'right', filterType: 'number' },
  cell: (c) => {
    const v = Number(c.getValue() ?? 0);
    return <span className={v < 0 ? 'text-red-500' : ''}>{fmt(v, digits)}</span>;
  },
});

/**
 * 조정 칸 — 원장·마감표는 부족을 출고(+)로 쌓지만, 화면은 실사 화면과 같게 "실사 − 장부"(부족 −, 남음 +)로 보여준다.
 * accessorFn 으로 뒤집으므로 필터·엑셀 내보내기도 같은 부호를 쓴다.
 */
const adjust = (key: 'adjustQty' | 'adjustAmt', header: string, size: number, digits = 0): ColumnDef<CloseLine> => ({
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

export const closeColumns: ColumnDef<CloseLine>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 130 },
  { accessorKey: 'itemName', header: '품목명', size: 170 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'lineType', header: '거래유형', size: 70 },
  { accessorKey: 'locationCode', header: '창고', size: 60 },
  num('openingQty', '기초수량', 100, 4),
  num('openingPrice', '기초단가', 80, 4),
  num('openingAmt', '기초금액', 110),
  num('receiptQty', '입고수량', 100, 4),
  num('receiptAmt', '입고금액', 110),
  num('massQty', '양산출고', 100, 4),
  num('badQty', '불량출고', 90, 4),
  num('freeQty', '무상출고', 90, 4),
  num('saleQty', '유상출고', 90, 4),
  num('extraQty', '기타출고', 90, 4),
  adjust('adjustQty', '재고조정(실사−장부)', 110, 4),
  adjust('adjustAmt', '조정금액(실사−장부)', 120),
  num('issueAmt', '출고금액', 110),
  {
    accessorKey: 'avgPrice', header: '월평균단가', size: 90, meta: { align: 'right' },
    cell: (c) => <span className="font-semibold">{fmt(c.getValue(), 4)}</span>,
  },
  num('endingQty', '기말수량', 100, 4),
  {
    accessorKey: 'endingAmt', header: '기말금액', size: 120, meta: { align: 'right' },
    cell: (c) => <span className="font-semibold">{fmt(c.getValue())}</span>,
  },
  {
    accessorKey: 'unpriced', header: '단가 미등록 입고', size: 110, meta: { align: 'right' },
    cell: (c) => {
      const v = Number(c.getValue() ?? 0);
      return v ? <span className="text-amber-500">{v.toLocaleString()}건</span> : '';
    },
  },
];
