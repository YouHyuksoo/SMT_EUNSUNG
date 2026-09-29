import type { ColumnDef } from '@tanstack/react-table';
import { comCodeCell } from '@/components/shared/codeCells';
import type { BomExpandRow, ReplaceRow } from './types';

const qty = (value: unknown) => value == null ? '' : Number(value).toLocaleString(undefined, { maximumFractionDigits: 6 });
const date = (value: unknown) => {
  if (!value) return '';
  const parsed = new Date(String(value));
  if (Number.isNaN(parsed.getTime())) return String(value);
  return parsed.toLocaleDateString('ko-KR').replace(/\.$/, '');
};

/** 관리 모드 — BOM 전개 그리드. bomLevel(LPAD '.') 로 계층 들여쓰기를 표현한다. */
export const bomExpandColumns: ColumnDef<BomExpandRow>[] = [
  {
    accessorKey: 'childItemCode', header: '구성품목', size: 220,
    cell: ({ row }) => {
      const level = String(row.original.bomLevel ?? '');
      const indent = level.length > 1 ? level.slice(0, -1) : '';
      return <span className="font-mono">{indent}{row.original.childItemCode}</span>;
    },
  },
  { accessorKey: 'childItemName', header: '품목명', size: 180 },
  { accessorKey: 'childItemSpec', header: '규격', size: 160 },
  { accessorKey: 'childItemUom', header: '단위', size: 70 },
  { accessorKey: 'childItemType', header: '품목유형', size: 90, cell: comCodeCell('CHILD ITEM TYPE') },
  { accessorKey: 'itemUnitQty', header: '단위수량', size: 100, meta: { align: 'right' }, cell: ctx => qty(ctx.getValue()) },
  { accessorKey: 'workstageCode', header: '공정', size: 110, cell: ctx => ctx.row.original.workstageName ?? ctx.getValue() ?? '' },
  { accessorKey: 'locationInfo', header: 'BOM 위치', size: 120 },
  { accessorKey: 'parentItemCode', header: '상위품목', size: 150 },
  { accessorKey: 'assyExplosionYn', header: '전개', size: 60, cell: comCodeCell('ASSY EXPLOSION YN') },
];

/** 목록 모드 — 등록된 대체품 그리드 */
export function replaceColumns(
  onEdit: (row: ReplaceRow) => void,
  onDelete: (row: ReplaceRow) => void,
): ColumnDef<ReplaceRow>[] {
  return [
    {
      id: 'actions', header: '작업', size: 80, enableSorting: false,
      meta: { filterType: 'none' as const, align: 'center' as const },
      cell: ({ row }) => (
        <div className="flex justify-center gap-1">
          <button onClick={(e) => { e.stopPropagation(); onEdit(row.original); }} className="rounded p-1 text-primary hover:bg-surface" title="수정">✎</button>
          <button onClick={(e) => { e.stopPropagation(); onDelete(row.original); }} className="rounded p-1 text-red-500 hover:bg-surface" title="삭제">🗑</button>
        </div>
      ),
    },
    { accessorKey: 'parentItemCode', header: '상위품목(SET)', size: 160 },
    { accessorKey: 'childItemCode', header: '구성품목', size: 160 },
    { accessorKey: 'replaceItemCode', header: '대체품목', size: 160 },
    { accessorKey: 'replaceItemName', header: '대체품목명', size: 180 },
    { accessorKey: 'replaceItemSpec', header: '규격', size: 160 },
    { accessorKey: 'replaceSequence', header: '순번', size: 70, meta: { align: 'right' } },
    { accessorKey: 'itemUnitQty', header: '단위수량', size: 100, meta: { align: 'right' }, cell: ctx => qty(ctx.getValue()) },
    { accessorKey: 'workstageCode', header: '공정', size: 110, cell: ctx => ctx.row.original.workstageName ?? ctx.getValue() ?? '' },
    { accessorKey: 'bomLocationCode', header: 'BOM 위치', size: 120 },
    { accessorKey: 'dateset', header: '적용시작', size: 110, cell: ctx => date(ctx.getValue()) },
    { accessorKey: 'dateend', header: '적용종료', size: 110, cell: ctx => date(ctx.getValue()) },
    { accessorKey: 'enterBy', header: '등록자', size: 100 },
  ];
}
