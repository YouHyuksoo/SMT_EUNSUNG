import type { ColumnDef } from '@tanstack/react-table';
import { comCodeCell, processNameCell } from '@/components/shared/codeCells';
import type { ProductDestroyRow } from './types';

/** SHIFT_CODE — 공정폐기에서는 A=주간, B=야간 으로 쓴다 */
export const SHIFT_LABELS: Record<string, string> = { A: '주간', B: '야간' };

const qty = (value: unknown) => value == null ? '' : Number(value).toLocaleString(undefined, { maximumFractionDigits: 3 });
const won = (value: unknown) => value == null ? '' : Number(value).toLocaleString(undefined, { maximumFractionDigits: 1 });
const dateTime = (value: unknown) => {
  if (!value) return '';
  const parsed = new Date(String(value));
  if (Number.isNaN(parsed.getTime())) return String(value);
  return parsed.toLocaleString('ko-KR', { hour12: false }).replace(/\.\s?$/, '');
};

/** 폐기이력 그리드 — 공정폐기 원장 */
export const destroyHistoryColumns: ColumnDef<ProductDestroyRow>[] = [
  { accessorKey: 'destroyStatus', header: '상태', size: 95, cell: comCodeCell('DESTROY STATUS') },
  { accessorKey: 'destroyDate', header: '폐기일시', size: 150, cell: ctx => dateTime(ctx.getValue()) },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'serialNo', header: 'PCB 시리얼', size: 170 },
  { accessorKey: 'modelName', header: '모델명', size: 150 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  { accessorKey: 'destroyQty', header: '수량', size: 80, meta: { align: 'right' }, cell: ctx => qty(ctx.getValue()) },
  { accessorKey: 'lineCode', header: '라인', size: 100 },
  { accessorKey: 'workstageCode', header: '공정', size: 120, cell: processNameCell() },
  { accessorKey: 'destroyTeam', header: '팀', size: 90, cell: comCodeCell('DESTROY TEAM') },
  { accessorKey: 'badReasonName', header: '불량유형', size: 110, cell: ctx => ctx.getValue() ?? ctx.row.original.badReasonCode ?? '' },
  { accessorKey: 'destroyProductType', header: '제품구분', size: 90, cell: comCodeCell('DESTROY PRODUCT TYPE') },
  { accessorKey: 'destroyBadCategory', header: '불량구분1', size: 100, cell: comCodeCell('DESTROY BAD CATEGORY') },
  { accessorKey: 'badCauseBy', header: '원인', size: 95, cell: comCodeCell('BAD CAUSE BY') },
  { accessorKey: 'occurProcessName', header: '발생공정', size: 100 },
  { accessorKey: 'detectProcessName', header: '검출공정', size: 100 },
  { accessorKey: 'departmentName', header: '부서', size: 100, cell: ctx => ctx.getValue() ?? ctx.row.original.departmentCode ?? '' },
  { accessorKey: 'unitPrice', header: '단가', size: 100, meta: { align: 'right' }, cell: ctx => won(ctx.getValue()) },
  { accessorKey: 'destroyAmount', header: '폐기금액', size: 110, meta: { align: 'right' }, cell: ctx => won(ctx.getValue()) },
  { accessorKey: 'shiftCode', header: '주/야', size: 80, cell: ctx => SHIFT_LABELS[String(ctx.getValue() ?? '')] ?? ctx.getValue() ?? '' },
  { accessorKey: 'workerName', header: '작업자', size: 100 },
  { accessorKey: 'returnDate', header: '반품일시', size: 150, cell: ctx => dateTime(ctx.getValue()) },
  { accessorKey: 'cancelDate', header: '취소일시', size: 150, cell: ctx => dateTime(ctx.getValue()) },
  { accessorKey: 'cancelBy', header: '취소자', size: 100 },
  { accessorKey: 'cancelReason', header: '취소사유', size: 180 },
  { accessorKey: 'comments', header: '비고', size: 160 },
  { accessorKey: 'enterBy', header: '등록자', size: 100 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: ctx => dateTime(ctx.getValue()) },
];

/** 시리얼 단건 현황 그리드 (dw_1 폐기보관 / dw_2 반품) — 화면 하단 2분할용 축약 컬럼 */
export const serialColumns: ColumnDef<ProductDestroyRow>[] = [
  { accessorKey: 'destroySeq', header: '폐기번호', size: 90, meta: { align: 'right' } },
  { accessorKey: 'serialNo', header: '시리얼', size: 160 },
  { accessorKey: 'modelName', header: '모델명', size: 140 },
  { accessorKey: 'lineCode', header: '라인', size: 90 },
  { accessorKey: 'workstageCode', header: '공정', size: 120, cell: processNameCell() },
  { accessorKey: 'badReasonName', header: '불량유형', size: 100, cell: ctx => ctx.getValue() ?? ctx.row.original.badReasonCode ?? '' },
  { accessorKey: 'destroyQty', header: '수량', size: 70, meta: { align: 'right' }, cell: ctx => qty(ctx.getValue()) },
  { accessorKey: 'departmentName', header: '부서', size: 95, cell: ctx => ctx.getValue() ?? ctx.row.original.departmentCode ?? '' },
  { accessorKey: 'destroyStatus', header: '상태', size: 95, cell: comCodeCell('DESTROY STATUS') },
  { accessorKey: 'destroyDate', header: '폐기일시', size: 145, cell: ctx => dateTime(ctx.getValue()) },
  { accessorKey: 'returnDate', header: '반품일시', size: 145, cell: ctx => dateTime(ctx.getValue()) },
  { accessorKey: 'workerName', header: '작업자', size: 95 },
];
