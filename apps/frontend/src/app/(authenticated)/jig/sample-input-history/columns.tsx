import type { ColumnDef } from '@tanstack/react-table';
import type { SampleInputHistoryRow } from './types';

const dateTime = (value: unknown) => {
  if (!value) return '';
  const parsed = new Date(String(value));
  if (Number.isNaN(parsed.getTime())) return String(value);
  return parsed.toLocaleString('ko-KR', { hour12: false }).replace(/\.\s?$/, '');
};
const dateOnly = (value: unknown) => (value ? String(value).slice(0, 10) : '');
const codeWithName = (code: unknown, name: unknown) => {
  const text = name ? String(name) : '';
  return text ? `${text} (${String(code ?? '')})` : String(code ?? '');
};

export const sampleInputHistoryColumns: ColumnDef<SampleInputHistoryRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'inputDate', header: '장착일시', size: 150, cell: (ctx) => dateTime(ctx.getValue()) },
  { id: 'lineName', header: '라인', size: 120, accessorFn: (row) => codeWithName(row.lineCode, row.lineName) },
  { id: 'sampleTypeName', header: '샘플유형', size: 140, accessorFn: (row) => codeWithName(row.sampleType, row.sampleTypeName) },
  { accessorKey: 'sampleCode', header: '샘플코드', size: 130 },
  { accessorKey: 'sampleLotNo', header: '샘플LOT', size: 130 },
  { accessorKey: 'sampleSpec', header: '규격', size: 160 },
  { accessorKey: 'currentApplyDate', header: '장착시 적용일', size: 120, cell: (ctx) => dateOnly(ctx.getValue()) },
  { accessorKey: 'sampleApplyDate', header: '마스터 적용일', size: 120, cell: (ctx) => dateOnly(ctx.getValue()) },
  { accessorKey: 'runNo', header: 'RUN NO', size: 120 },
  { accessorKey: 'modelName', header: '모델명', size: 150 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (ctx) => dateTime(ctx.getValue()) },
  { accessorKey: 'lastModifyBy', header: '수정자', size: 90 },
  { accessorKey: 'lastModifyDate', header: '수정일시', size: 150, cell: (ctx) => dateTime(ctx.getValue()) },
];
