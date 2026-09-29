import type { ColumnDef } from '@tanstack/react-table';
import { comCodeCell } from '@/components/shared/codeCells';
import type { MagazineLabelHistoryRow, MagazineLabelViewMode } from './types';

const qty = (value: unknown) => value == null ? '' : Number(value).toLocaleString(undefined, { maximumFractionDigits: 3 });
const dateTime = (value: unknown) => value ? new Date(String(value)).toLocaleString('ko-KR', { hour12: false }).replace(/\.\s?$/, '') : '';

const historyColumns: ColumnDef<MagazineLabelHistoryRow>[] = [
  { accessorKey: 'magazineLabelType', header: '라벨유형', size: 110, cell: comCodeCell('MAGAZINE LABEL TYPE') },
  { accessorKey: 'runNo', header: 'RUN NO', size: 145 },
  { accessorKey: 'magazineLabelNo', header: '매거진 라벨번호', size: 180 },
  { accessorKey: 'enterDate', header: '발행일시', size: 165, cell: ctx => dateTime(ctx.getValue()) },
  { accessorKey: 'lineCode', header: '라인', size: 110, cell: ctx => ctx.row.original.lineName ?? ctx.getValue() ?? '' },
  { accessorKey: 'workstageCode', header: '공정', size: 120, cell: ctx => ctx.row.original.workstageName ?? ctx.getValue() ?? '' },
  { accessorKey: 'receiptDate', header: '수불일시', size: 165, cell: ctx => dateTime(ctx.getValue()) },
  { accessorKey: 'modelName', header: '모델명', size: 150 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 85 },
  { accessorKey: 'itemCode', header: '품목코드', size: 145 },
  { accessorKey: 'pcbItem', header: 'PCB 구분', size: 95 },
  { accessorKey: 'lotQty', header: '수량', size: 95, meta: { align: 'right' }, cell: ctx => qty(ctx.getValue()) },
  { accessorKey: 'badQty', header: '불량수량', size: 100, meta: { align: 'right' }, cell: ctx => qty(ctx.getValue()) },
  { accessorKey: 'transferMagazineLabelNo', header: '대체 매거진 라벨번호', size: 210 },
];

const summaryColumns = historyColumns.filter(column => !['magazineLabelNo', 'enterDate', 'modelSuffix', 'badQty', 'transferMagazineLabelNo'].includes(String((column as { accessorKey?: string }).accessorKey)));

export function magazineLabelColumns(mode: MagazineLabelViewMode, matrixColumnKeys: string[] = []): ColumnDef<MagazineLabelHistoryRow>[] {
  if (mode === 'history') return historyColumns;
  if (mode === 'summary') return summaryColumns;
  return [
    { accessorKey: 'lineCode', header: '라인', size: 110, cell: ctx => ctx.row.original.lineName ?? ctx.getValue() ?? '' },
    { accessorKey: 'runNo', header: 'RUN NO', size: 145 },
    { accessorKey: 'modelName', header: '모델명', size: 150 },
    { accessorKey: 'pcbItem', header: 'PCB 구분', size: 95 },
    ...matrixColumnKeys.map(key => ({ accessorKey: key, header: key, size: 125, meta: { align: 'right' as const }, cell: (ctx: { getValue(): unknown }) => qty(ctx.getValue()) })),
    { accessorKey: 'lotQty', header: '합계', size: 105, meta: { align: 'right' }, cell: ctx => qty(ctx.getValue()) },
  ];
}
