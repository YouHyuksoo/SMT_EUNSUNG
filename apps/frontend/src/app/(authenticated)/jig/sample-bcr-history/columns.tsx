import type { ColumnDef } from '@tanstack/react-table';
import type { SampleBcrHistoryRow } from './types';

const dateTime = (value: unknown) => {
  if (!value) return '';
  const parsed = new Date(String(value));
  if (Number.isNaN(parsed.getTime())) return String(value);
  return parsed.toLocaleString('ko-KR', { hour12: false }).replace(/\.\s?$/, '');
};
const codeWithName = (code: unknown, name: unknown) => {
  const text = name ? String(name) : '';
  return text ? `${text} (${String(code ?? '')})` : String(code ?? '');
};

export const sampleBcrHistoryColumns: ColumnDef<SampleBcrHistoryRow>[] = [
  { accessorKey: 'inputDate', header: '투입일시', size: 150, cell: (ctx) => dateTime(ctx.getValue()) },
  { id: 'lineName', header: '라인', size: 120, accessorFn: (row) => codeWithName(row.lineCode, row.lineName) },
  { id: 'workstageName', header: '공정', size: 130, accessorFn: (row) => codeWithName(row.workstageCode, row.workstageName) },
  { accessorKey: 'runNo', header: 'RUN NO', size: 120 },
  { accessorKey: 'modelName', header: '모델명', size: 150 },
  { id: 'sampleTypeName', header: '샘플유형', size: 140, accessorFn: (row) => codeWithName(row.sampleType, row.sampleTypeName) },
  { accessorKey: 'sampleSection', header: '구분', size: 80 },
  { accessorKey: 'sampleLotNo', header: '샘플LOT', size: 130 },
  { accessorKey: 'sampleBarcode', header: '샘플바코드', size: 170 },
  {
    accessorKey: 'inspectResult',
    header: '판정',
    size: 80,
    cell: (ctx) => {
      const value = String(ctx.getValue() ?? '');
      // PB 는 NG 행을 빨간색으로 칠한다. 조건부 색상만 옮기고 사운드는 옮기지 않는다.
      const ng = value.toUpperCase() === 'NG';
      return <span className={ng ? 'font-semibold text-red-600' : ''}>{value}</span>;
    },
  },
];
