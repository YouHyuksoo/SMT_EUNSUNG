import type { ColumnDef } from '@tanstack/react-table';
import type { WorkstagePassMode, WorkstagePassRow } from './types';

const dt = (value: unknown) => value ? new Date(String(value)).toLocaleString('ko-KR', { hour12: false }).replace(/\.\s?$/, '') : '';
const qty = (value: unknown) => value == null ? '' : Number(value).toLocaleString();
const detail: ColumnDef<WorkstagePassRow>[] = [
  { accessorKey: 'ioDate', header: '통과일시', size: 165, cell: c => dt(c.getValue()) },
  { accessorKey: 'serialNo', header: 'PID/매거진', size: 190 }, { accessorKey: 'runNo', header: 'RUN NO', size: 140 },
  { accessorKey: 'lineCode', header: '라인', size: 100 }, { accessorKey: 'workstageCode', header: '공정', size: 110 },
  { accessorKey: 'modelName', header: '모델명', size: 150 }, { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  { accessorKey: 'itemCode', header: '품목코드', size: 145 }, { accessorKey: 'ioDeficit', header: '수불', size: 70 },
  { accessorKey: 'ioQty', header: '수량', size: 90, meta: { align: 'right' }, cell: c => qty(c.getValue()) },
  { accessorKey: 'outDate', header: '출고일시', size: 165, cell: c => dt(c.getValue()) }, { accessorKey: 'lotNo', header: 'LOT NO', size: 130 },
];
export const workstagePassColumns = (mode: WorkstagePassMode): ColumnDef<WorkstagePassRow>[] =>
  mode === 'inventory' ? [
    { accessorKey: 'actualDate', header: '기준일', size: 130, cell: c => dt(c.getValue()) },
    { accessorKey: 'workstageCode', header: '공정', size: 130 }, { accessorKey: 'modelName', header: '모델명', size: 180 },
    { accessorKey: 'ioQty', header: '재공수량', size: 110, meta: { align: 'right' }, cell: c => qty(c.getValue()) },
  ] : mode === 'workstageSummary' ? [
    { accessorKey: 'workstageCode', header: '공정', size: 130 }, { accessorKey: 'modelName', header: '모델명', size: 180 },
    { accessorKey: 'ioDeficit', header: '수불', size: 80 }, { accessorKey: 'ioQty', header: '수량', size: 110, meta: { align: 'right' }, cell: c => qty(c.getValue()) },
  ] : detail;
