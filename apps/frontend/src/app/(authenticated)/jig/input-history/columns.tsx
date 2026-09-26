import type { ColumnDef } from '@tanstack/react-table';
import type { JigInputHistoryRow } from './types';

const dateTime = (value: unknown) => {
  if (!value) return '';
  const parsed = new Date(String(value));
  if (Number.isNaN(parsed.getTime())) return String(value);
  return parsed.toLocaleString('ko-KR', { hour12: false }).replace(/\.\s?$/, '');
};
const qty = (value: unknown) => (value == null ? '' : Number(value).toLocaleString());

/** 코드컬럼(JIG_TYPE)은 뜻을 보여주고 코드는 괄호로 함께 둔다. */
const codeWithName = (code: unknown, name: unknown) => {
  const text = name ? String(name) : '';
  return text ? `${text} (${String(code ?? '')})` : String(code ?? '');
};

export const jigInputHistoryColumns: ColumnDef<JigInputHistoryRow>[] = [
  { accessorKey: 'inputDate', header: '투입일시', size: 150, cell: (ctx) => dateTime(ctx.getValue()) },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (row) => codeWithName(row.lineCode, row.lineName),
  },
  {
    id: 'jigTypeName',
    header: '지그유형',
    size: 130,
    accessorFn: (row) => codeWithName(row.jigType, row.jigTypeName),
  },
  { accessorKey: 'jigCode', header: '지그코드', size: 130 },
  { accessorKey: 'jigLotNo', header: '지그LOT', size: 130 },
  { accessorKey: 'jigSpec', header: '규격', size: 160 },
  { accessorKey: 'solderType', header: '솔더유형', size: 100 },
  { accessorKey: 'currentHitValue', header: '누적타수', size: 100, meta: { align: 'right' }, cell: (ctx) => qty(ctx.getValue()) },
  { accessorKey: 'runNo', header: 'RUN NO', size: 120 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'modelName', header: '모델명', size: 150 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (ctx) => dateTime(ctx.getValue()) },
  { accessorKey: 'lastModifyBy', header: '수정자', size: 90 },
  { accessorKey: 'lastModifyDate', header: '수정일시', size: 150, cell: (ctx) => dateTime(ctx.getValue()) },
];
