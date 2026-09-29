import type { ColumnDef } from '@tanstack/react-table';
import { codeMasterCell, comCodeCell } from '@/components/shared/codeCells';
import type { ProductDestroyRow } from './types';

const qty = (value: unknown) => value == null ? '' : Number(value).toLocaleString(undefined, { maximumFractionDigits: 3 });
const dateTime = (value: unknown) => {
  if (!value) return '';
  const parsed = new Date(String(value));
  if (Number.isNaN(parsed.getTime())) return String(value);
  return parsed.toLocaleString('ko-KR', { hour12: false }).replace(/\.\s?$/, '');
};

/** 폐기이력 그리드 (rb_history) */
export const destroyHistoryColumns: ColumnDef<ProductDestroyRow>[] = [
  { accessorKey: 'qcSequence', header: 'QC순번', size: 100, meta: { align: 'right' } },
  { accessorKey: 'serialNo', header: 'PCB 시리얼', size: 170 },
  { accessorKey: 'modelName', header: '모델명', size: 150 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'lineCode', header: '라인', size: 100 },
  { accessorKey: 'workstageCode', header: '공정', size: 110 },
  { accessorKey: 'badReasonCode', header: '불량사유', size: 110, cell: codeMasterCell('WQC BAD REASON CODE') },
  { accessorKey: 'receiptDeficit', header: '불량구분', size: 100, cell: comCodeCell('RECEIPT DEFICIT') },
  { accessorKey: 'qcInspectHandling', header: '검사처리', size: 100, cell: comCodeCell('QC INSPECT HANDLING') },
  { accessorKey: 'badQty', header: '불량수량', size: 100, meta: { align: 'right' }, cell: ctx => qty(ctx.getValue()) },
  { accessorKey: 'qcDate', header: '폐기일시', size: 150, cell: ctx => dateTime(ctx.getValue()) },
  { accessorKey: 'repairDate', header: '반품일시', size: 150, cell: ctx => dateTime(ctx.getValue()) },
  { accessorKey: 'shiftCode', header: '근무조', size: 80 },
  { accessorKey: 'charger', header: '담당자', size: 100 },
  { accessorKey: 'locationCode', header: '로케이션', size: 110 },
  { accessorKey: 'comments', header: '비고', size: 160 },
  { accessorKey: 'enterBy', header: '등록자', size: 100 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: ctx => dateTime(ctx.getValue()) },
];

/** 시리얼 단건 현황 그리드 (dw_1 폐기 / dw_2 반품) — 화면 하단 2분할용 축약 컬럼 */
export const serialColumns: ColumnDef<ProductDestroyRow>[] = [
  { accessorKey: 'qcSequence', header: 'QC순번', size: 90, meta: { align: 'right' } },
  { accessorKey: 'serialNo', header: '시리얼', size: 160 },
  { accessorKey: 'modelName', header: '모델명', size: 140 },
  { accessorKey: 'lineCode', header: '라인', size: 90 },
  { accessorKey: 'workstageCode', header: '공정', size: 100 },
  { accessorKey: 'badReasonCode', header: '불량사유', size: 100, cell: codeMasterCell('WQC BAD REASON CODE') },
  { accessorKey: 'qcInspectHandling', header: '검사처리', size: 95, cell: comCodeCell('QC INSPECT HANDLING') },
  { accessorKey: 'qcDate', header: '폐기일시', size: 145, cell: ctx => dateTime(ctx.getValue()) },
  { accessorKey: 'repairDate', header: '반품일시', size: 145, cell: ctx => dateTime(ctx.getValue()) },
  { accessorKey: 'charger', header: '담당자', size: 95 },
];
