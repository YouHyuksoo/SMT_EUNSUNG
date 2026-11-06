import type { ColumnDef } from '@tanstack/react-table';
import { comCodeCell } from '@/components/shared/codeCells';
import type { WorkstageByWsRow, WorkstageInventoryRow, WorkstageMoveRow, WorkstageProductRow } from './types';

const quantity = (value: unknown) => value == null ? '' : Number(value).toLocaleString(undefined, { maximumFractionDigits: 6 });
const dateTime = (value: unknown) => {
  if (!value) return '';
  const date = new Date(String(value));
  return Number.isNaN(date.getTime()) ? String(value) : date.toLocaleString('ko-KR', { hour12: false }).replace(/\.\s?$/, '');
};

export const workstageInventoryColumns: ColumnDef<WorkstageInventoryRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemDivision', header: '품목구분', size: 90, cell: comCodeCell('ITEM DIVISION') },
  { accessorKey: 'itemClass', header: '품목분류', size: 120, cell: comCodeCell('ITEM CLASS') },
  { accessorKey: 'itemName', header: '품목명', size: 220 },
  { accessorKey: 'itemSpec', header: '규격', size: 220 },
  { accessorKey: 'itemUom', header: '단위', size: 80, cell: comCodeCell('ITEM UOM') },
  { accessorKey: 'supplierCode', header: '공급상코드', size: 110 },
  { accessorKey: 'supplierName', header: '공급상명', size: 180 },
  { accessorKey: 'modelName', header: '모델명', size: 180 },
  { accessorKey: 'locationAddress', header: '자재위치', size: 100 },
  { accessorKey: 'inventoryQty', header: '공정재고수량', size: 130, meta: { align: 'right' }, cell: context => quantity(context.getValue()) },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: context => dateTime(context.getValue()) },
  { accessorKey: 'enterBy', header: '등록자', size: 110 },
  { accessorKey: 'lastModifyDate', header: '최종수정일시', size: 160, cell: context => dateTime(context.getValue()) },
  { accessorKey: 'lastModifyBy', header: '최종수정자', size: 110 },
  { accessorKey: 'organizationId', header: '조직 ID', size: 90, meta: { align: 'right' } },
];

const wsLabel = (code: string | null, name: string | null) => (name ? `${name} (${code})` : code ?? '');

export const workstageByWsColumns: ColumnDef<WorkstageByWsRow>[] = [
  { id: 'workstage', header: '공정', size: 150, accessorFn: row => wsLabel(row.workstageCode, row.workstageName) },
  { accessorKey: 'itemCode', header: '품목코드', size: 160 },
  { accessorKey: 'itemName', header: '품목명', size: 240 },
  { accessorKey: 'itemDivision', header: '품목구분', size: 90, cell: comCodeCell('ITEM DIVISION') },
  { accessorKey: 'inventoryQty', header: '공정재고수량', size: 130, meta: { align: 'right' }, cell: context => quantity(context.getValue()) },
  { accessorKey: 'lastModifyDate', header: '최종변경', size: 140 },
  { accessorKey: 'lastModifyBy', header: '최종변경 구분', size: 120 },
];

export const workstageMoveColumns: ColumnDef<WorkstageMoveRow>[] = [
  { accessorKey: 'moveDate', header: '이동시각', size: 160 },
  { accessorKey: 'magazineLabelNo', header: '매거진 라벨', size: 130 },
  { id: 'from', header: '출발 공정', size: 140, accessorFn: row => wsLabel(row.fromWorkstageCode, row.fromWorkstageName) },
  { id: 'to', header: '도착 공정', size: 140, accessorFn: row => wsLabel(row.toWorkstageCode, row.toWorkstageName) },
  { accessorKey: 'itemCode', header: '반제품', size: 160 },
  { accessorKey: 'itemName', header: '품목명', size: 220 },
  { accessorKey: 'moveQty', header: '수량', size: 100, meta: { align: 'right' }, cell: context => quantity(context.getValue()) },
  { accessorKey: 'runNo', header: '런카드', size: 130 },
  { accessorKey: 'lineCode', header: '라인', size: 70 },
  { accessorKey: 'enterBy', header: '스캔', size: 90 },
];

export const workstageProductColumns: ColumnDef<WorkstageProductRow>[] = [
  { accessorKey: 'modelName', header: '모델명', size: 240 },
  { accessorKey: 'itemCode', header: '품목코드', size: 170 },
  { accessorKey: 'itemName', header: '품목명', size: 220 },
  { accessorKey: 'itemDivision', header: '품목구분', size: 90, cell: comCodeCell('ITEM DIVISION') },
  { accessorKey: 'boxCount', header: '박스수', size: 90, meta: { align: 'right' }, cell: context => quantity(context.getValue()) },
  { accessorKey: 'packQty', header: '포장수량', size: 110, meta: { align: 'right' }, cell: context => quantity(context.getValue()) },
  { accessorKey: 'firstPackDate', header: '최초포장일', size: 110 },
  { accessorKey: 'lastPackDate', header: '최종포장일', size: 110 },
];
