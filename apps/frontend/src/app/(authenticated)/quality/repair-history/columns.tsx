import type { ColumnDef } from '@tanstack/react-table';
import { codeMasterCell, comCodeCell } from '@/components/shared/codeCells';
import type { RepairHistoryRow } from './types';

const qty = (value: unknown) => value == null ? '' : Number(value).toLocaleString(undefined, { maximumFractionDigits: 3 });
const hours = (value: unknown) => value == null ? '' : `${Number(value).toLocaleString(undefined, { maximumFractionDigits: 1 })}h`;
const dateTime = (value: unknown) => {
  if (!value) return '';
  const parsed = new Date(String(value));
  if (Number.isNaN(parsed.getTime())) return String(value);
  return parsed.toLocaleString('ko-KR', { hour12: false }).replace(/\.\s?$/, '');
};

export const repairHistoryColumns: ColumnDef<RepairHistoryRow>[] = [
  { accessorKey: 'qcSequence', header: 'QC순번', size: 100, meta: { align: 'right' } },
  { accessorKey: 'receiptDeficit', header: '불량구분', size: 100, cell: comCodeCell('RECEIPT DEFICIT') },
  { accessorKey: 'qcInspectHandling', header: '검사처리', size: 100, cell: comCodeCell('QC INSPECT HANDLING') },
  { accessorKey: 'qcResult', header: 'QC결과', size: 90, cell: comCodeCell('QC RESULT') },
  { accessorKey: 'serialNo', header: 'PCB 시리얼', size: 170 },
  { accessorKey: 'modelName', header: '모델명', size: 150 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'lineCode', header: '라인', size: 100 },
  { accessorKey: 'workstageCode', header: '공정', size: 110 },
  { accessorKey: 'badReasonCode', header: '불량사유', size: 110, cell: codeMasterCell('WQC BAD REASON CODE') },
  { accessorKey: 'badCauseBy', header: '불량귀책', size: 100 },
  { accessorKey: 'badQty', header: '불량수량', size: 100, meta: { align: 'right' }, cell: ctx => qty(ctx.getValue()) },
  { accessorKey: 'defectQty', header: '결함수량', size: 100, meta: { align: 'right' }, cell: ctx => qty(ctx.getValue()) },
  { accessorKey: 'qcDate', header: 'QC일시', size: 150, cell: ctx => dateTime(ctx.getValue()) },
  { accessorKey: 'tatTime', header: 'TAT', size: 90, meta: { align: 'right' }, cell: ctx => hours(ctx.getValue()) },
  { accessorKey: 'repairResultCode', header: '수리결과', size: 100, cell: comCodeCell('REPAIR RESULT CODE') },
  { accessorKey: 'repairMethod', header: '수리방법', size: 140 },
  { accessorKey: 'repairBy', header: '수리자', size: 100 },
  { accessorKey: 'repairDate', header: '수리일시', size: 150, cell: ctx => dateTime(ctx.getValue()) },
  { accessorKey: 'repairLineCode', header: '수리라인', size: 100 },
  { accessorKey: 'repairWorkstageCode', header: '수리공정', size: 110 },
  { accessorKey: 'lcrMeasure', header: 'LCR 측정', size: 110 },
  { accessorKey: 'charger', header: '담당자', size: 100 },
  { accessorKey: 'machineCode', header: '설비', size: 110 },
  { accessorKey: 'shiftCode', header: '근무조', size: 80 },
  { accessorKey: 'locationCode', header: '로케이션', size: 110 },
  { accessorKey: 'comments', header: '비고', size: 180 },
  { accessorKey: 'enterBy', header: '등록자', size: 100 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: ctx => dateTime(ctx.getValue()) },
];
