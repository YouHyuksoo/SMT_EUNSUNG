import type { ColumnDef } from '@tanstack/react-table';
import type { WorkstageInventoryRow } from './types';

const quantity = (value: unknown) => value == null ? '' : Number(value).toLocaleString(undefined, { maximumFractionDigits: 6 });
const dateTime = (value: unknown) => {
  if (!value) return '';
  const date = new Date(String(value));
  return Number.isNaN(date.getTime()) ? String(value) : date.toLocaleString('ko-KR', { hour12: false }).replace(/\.\s?$/, '');
};

export const workstageInventoryColumns: ColumnDef<WorkstageInventoryRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 220 },
  { accessorKey: 'itemSpec', header: '규격', size: 220 },
  { accessorKey: 'itemUom', header: '단위', size: 80 },
  { accessorKey: 'inventoryQty', header: '공정재고수량', size: 130, meta: { align: 'right' }, cell: context => quantity(context.getValue()) },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: context => dateTime(context.getValue()) },
  { accessorKey: 'enterBy', header: '등록자', size: 110 },
  { accessorKey: 'lastModifyDate', header: '최종수정일시', size: 160, cell: context => dateTime(context.getValue()) },
  { accessorKey: 'lastModifyBy', header: '최종수정자', size: 110 },
  { accessorKey: 'organizationId', header: '조직 ID', size: 90, meta: { align: 'right' } },
];
