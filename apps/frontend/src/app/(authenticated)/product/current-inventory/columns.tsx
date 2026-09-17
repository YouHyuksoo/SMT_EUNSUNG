import type { ColumnDef } from '@tanstack/react-table';
import type { ProductInventoryRow } from './types';

const qty = (value: unknown) => value == null ? '' : Number(value).toLocaleString();
const dateTime = (value: unknown) => {
  if (!value) return '';
  const d = new Date(String(value));
  if (Number.isNaN(d.getTime())) return String(value);
  return d.toLocaleString('ko-KR', { hour12: false }).replace(/\.\s?$/, '');
};

export const productInventoryColumns: ColumnDef<ProductInventoryRow>[] = [
  { accessorKey: 'inventoryDate', header: '재고일자', size: 150, cell: ctx => dateTime(ctx.getValue()) },
  { accessorKey: 'productLocationCode', header: '제품로케이션', size: 120 },
  { accessorKey: 'modelName', header: '모델명', size: 190 },
  { accessorKey: 'modelSuffix', header: '모델Suffix', size: 110 },
  { accessorKey: 'invDay', header: '재고일수', size: 90, meta: { align: 'right' }, cell: ctx => ctx.getValue() == null ? '' : Number(ctx.getValue()).toFixed(2) },
  { accessorKey: 'qty', header: '수량', size: 100, meta: { align: 'right' }, cell: ctx => qty(ctx.getValue()) },
  { accessorKey: 'barcode', header: '바코드', size: 190 },
  { accessorKey: 'packType', header: '포장유형', size: 100 },
  { accessorKey: 'palletNo', header: '팔레트번호', size: 150 },
  { accessorKey: 'palletDate', header: '팔레트일자', size: 150, cell: ctx => dateTime(ctx.getValue()) },
];
