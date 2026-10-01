import type { ColumnDef } from '@tanstack/react-table';
import { comCodeCell } from '@/components/shared/codeCells';
import type { MfsDetailRow, MfsFeederRow, MfsModelRow, MfsSummaryRow } from './types';
import { formatDisplayDate } from '@/utils/date';

const qty = (value: unknown) => value == null ? '' : Number(value).toLocaleString(undefined, { maximumFractionDigits: 6 });
const date = (value: unknown) => formatDisplayDate(value);

/** (1) 제품모델 목록 */
export const modelColumns: ColumnDef<MfsModelRow>[] = [
  { accessorKey: 'modelName', header: '모델명', size: 180 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'smtModelName', header: 'SMT 모델명', size: 160 },
  { accessorKey: 'masterModelName', header: '마스터 모델명', size: 150 },
  { accessorKey: 'customerName', header: '고객사', size: 120 },
  { accessorKey: 'modelDivision', header: '모델구분', size: 90, cell: comCodeCell('MODEL DIVISION') },
  { accessorKey: 'modelType', header: '모델유형', size: 90 },
  { accessorKey: 'partNo', header: '고객 품번', size: 130 },
  { accessorKey: 'revision', header: '리비전', size: 70 },
  { accessorKey: 'modelSpec', header: '모델사양', size: 140 },
];

/** (2) 피더 레이아웃 */
export const feederColumns: ColumnDef<MfsFeederRow>[] = [
  { accessorKey: 'lineCode', header: '라인', size: 110, cell: ctx => ctx.row.original.lineName ?? ctx.getValue() ?? '' },
  { accessorKey: 'pcbItem', header: 'PCB 면', size: 70 },
  { accessorKey: 'revision', header: '리비전(MFS)', size: 100 },
  { accessorKey: 'feederShaft', header: '피더 샤프트', size: 90 },
  { accessorKey: 'feederShaftStatus', header: '샤프트 상태', size: 90 },
  { accessorKey: 'partCount', header: '부품 행수', size: 80, meta: { align: 'right' } },
  { accessorKey: 'parentItemCode', header: 'SMT 모델명', size: 170 },
];

/** (3) MFS 목록 */
export const mfsColumns: ColumnDef<MfsSummaryRow>[] = [
  { accessorKey: 'mfs', header: 'MFS', size: 110 },
  {
    id: 'status', header: '승인', size: 90,
    accessorFn: row => row.confirmedCount === 0 ? '미승인' : row.confirmedCount === row.rowCount ? '승인' : '일부 승인',
  },
  { accessorKey: 'rowCount', header: '행수', size: 70, meta: { align: 'right' } },
  { accessorKey: 'usedCount', header: '사용 행수', size: 80, meta: { align: 'right' } },
  { accessorKey: 'planDate', header: '생성일', size: 100, cell: ctx => date(ctx.getValue()) },
  { accessorKey: 'confirmDate', header: '승인일', size: 100, cell: ctx => date(ctx.getValue()) },
  { accessorKey: 'confirmBy', header: '승인자', size: 90 },
  { accessorKey: 'lastModifyBy', header: '최종 수정자', size: 90 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'comments', header: '비고', size: 160 },
];

/** (4) MFS 상세. BOM_LEVEL 만큼 들여써서 계층을 표시한다. */
export const detailColumns: ColumnDef<MfsDetailRow>[] = [
  {
    accessorKey: 'childItemCode', header: '구성품목', size: 220,
    cell: ({ row }) => {
      const level = Math.max(0, Number(row.original.bomLevel ?? 1) - 1);
      return <span className="font-mono">{'.'.repeat(level)}{row.original.childItemCode}</span>;
    },
  },
  { accessorKey: 'bomLevel', header: '레벨', size: 60, meta: { align: 'right' } },
  { accessorKey: 'childItemName', header: '품목명', size: 180 },
  { accessorKey: 'childItemSpec', header: '규격', size: 150 },
  { accessorKey: 'childItemUom', header: '단위', size: 60 },
  { accessorKey: 'itemType', header: '품목유형', size: 90, cell: comCodeCell('ITEM TYPE') },
  { accessorKey: 'lineType', header: '라인유형', size: 90, cell: comCodeCell('LINE TYPE') },
  { accessorKey: 'modelUnitQty', header: '모델 소요량', size: 90, meta: { align: 'right' }, cell: ctx => qty(ctx.getValue()) },
  { accessorKey: 'itemUnitQty', header: '단위수량', size: 90, meta: { align: 'right' }, cell: ctx => qty(ctx.getValue()) },
  { accessorKey: 'pcbItem', header: 'PCB 면', size: 70 },
  { accessorKey: 'usedYn', header: '사용', size: 70, cell: comCodeCell('USE YN') },
  { accessorKey: 'confirmYn', header: '승인', size: 70, cell: comCodeCell('CONFIRM YN') },
  { accessorKey: 'parentItemCode', header: '상위품목', size: 150 },
  { accessorKey: 'dateset', header: '적용시작', size: 100, cell: ctx => date(ctx.getValue()) },
  { accessorKey: 'dateend', header: '적용종료', size: 100, cell: ctx => date(ctx.getValue()) },
  { accessorKey: 'lastModifyBy', header: '최종 수정자', size: 90 },
];
