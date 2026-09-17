import type { ColumnDef } from '@tanstack/react-table';
import type { CurrentInventoryRow } from './types';

const qty = (value: unknown) => value == null ? '' : Number(value).toLocaleString(undefined, { maximumFractionDigits: 6 });
const money = (value: unknown) => value == null ? '' : Number(value).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
const dateTime = (value: unknown) => {
  if (!value) return '';
  const d = new Date(String(value));
  if (Number.isNaN(d.getTime())) return String(value);
  return d.toLocaleString('ko-KR', { hour12: false }).replace(/\.\s?$/, '');
};

export const currentInventoryColumns: ColumnDef<CurrentInventoryRow>[] = [
  { accessorKey: 'locationCode', header: '로케이션', size: 110 },
  { accessorKey: 'locationAddress', header: '로케이션 주소', size: 140 },
  { accessorKey: 'materialMfs', header: '자재 MFS', size: 150 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 180 },
  { accessorKey: 'lineType', header: '라인유형', size: 90 },
  { accessorKey: 'inventoryStatus', header: '재고상태', size: 90 },
  { accessorKey: 'inventoryHold', header: '보류', size: 70 },
  { accessorKey: 'inventoryQty', header: '현재고수량', size: 110, meta: { align: 'right' }, cell: ctx => qty(ctx.getValue()) },
  { accessorKey: 'inventoryPrice', header: '재고단가', size: 110, meta: { align: 'right' }, cell: ctx => money(ctx.getValue()) },
  { accessorKey: 'inventoryAmt', header: '재고금액', size: 130, meta: { align: 'right' }, cell: ctx => money(ctx.getValue()) },
  { accessorKey: 'itemUom', header: '단위', size: 70 },
  { accessorKey: 'itemDivision', header: '품목구분', size: 90 },
  { accessorKey: 'manufactureWeek', header: '제조주차', size: 90 },
  { accessorKey: 'lastReceiptDate', header: '최근입고일', size: 150, cell: ctx => dateTime(ctx.getValue()) },
  { accessorKey: 'bakingDate', header: '베이킹일', size: 150, cell: ctx => dateTime(ctx.getValue()) },
  { accessorKey: 'comments', header: '비고', size: 180 },
];
