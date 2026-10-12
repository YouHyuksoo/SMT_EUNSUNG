import type { ColumnDef } from '@tanstack/react-table';
import { comCodeCell } from '@/components/shared/codeCells';
import type { RawBomRow } from './types';

/** 단위수량은 PB 와 같이 소수 8자리까지 보인다 */
const qty = (value: unknown) => value == null ? '' : Number(value).toLocaleString(undefined, { maximumFractionDigits: 8 });
const num = (value: unknown) => value == null ? '' : Number(value).toLocaleString(undefined, { maximumFractionDigits: 4 });

/**
 * 원단위BOM 그리드 — PB d_des_raw_bom_lst 컬럼 순서.
 * 코드 컬럼은 공통코드 뜻을 보인다(PB DDDW vd_basecode). 날짜는 서버가 'YYYY-MM-DD' 문자열로 준다.
 */
export const rawBomColumns: ColumnDef<RawBomRow>[] = [
  { accessorKey: 'itemName', header: '품명', size: 180 },
  {
    id: 'rowNo', header: '순번', size: 60, enableSorting: false,
    meta: { filterType: 'none' as const, align: 'right' as const },
    cell: ({ row }) => row.index + 1,
  },
  { accessorKey: 'setItemYn', header: '세트품목(모)', size: 90, meta: { align: 'center' as const } },
  { accessorKey: 'assyExplosionYn', header: '반제품전개', size: 90, cell: comCodeCell('ASSY EXPLOSION YN') },
  { accessorKey: 'parentItemCode', header: '모품목코드', size: 160 },
  { accessorKey: 'childItemCode', header: '자품목코드', size: 150 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'itemDivision', header: '품목구분', size: 90, cell: comCodeCell('ITEM DIVISION') },
  { accessorKey: 'drawingNo', header: '도면번호', size: 120 },
  { accessorKey: 'parentItemName', header: '모품명', size: 180 },
  { accessorKey: 'parentItemSpec', header: '모규격', size: 160 },
  { accessorKey: 'itemUom', header: '단위', size: 70, cell: comCodeCell('ITEM UOM') },
  { accessorKey: 'itemType', header: '품목유형', size: 90, cell: comCodeCell('ITEM TYPE') },
  { accessorKey: 'lineType', header: '구입유형', size: 100, cell: comCodeCell('LINE TYPE') },
  { accessorKey: 'itemUnitQty', header: '단위수량', size: 110, meta: { align: 'right' as const }, cell: ctx => qty(ctx.getValue()) },
  { accessorKey: 'itemUnitQtyExt', header: '단위수량(기타)', size: 110, meta: { align: 'right' as const }, cell: ctx => qty(ctx.getValue()) },
  { accessorKey: 'locationInfo', header: '로케이션정보', size: 180 },
  {
    accessorKey: 'workstageCode', header: '공정', size: 110,
    // 공정 기준정보에 없는 코드('*' 등)는 코드를 그대로 보인다(PB DDDW 와 같다).
    cell: ctx => ctx.row.original.workstageName ?? ctx.getValue() ?? '',
  },
  { accessorKey: 'sortSequence', header: '정렬순번', size: 80, meta: { align: 'right' as const } },
  { accessorKey: 'dateset', header: '시작일자', size: 100 },
  { accessorKey: 'dateend', header: '종료일자', size: 100 },
  { accessorKey: 'bomWorkNo', header: 'BOM작업번호', size: 100, meta: { align: 'right' as const } },
  { accessorKey: 'abcGrade', header: '등급', size: 60, meta: { align: 'center' as const } },
  { accessorKey: 'manufactureLeadtime', header: '제조리드타임', size: 100, meta: { align: 'right' as const }, cell: ctx => num(ctx.getValue()) },
  { accessorKey: 'workBadRate', header: '작업불량율', size: 90, meta: { align: 'right' as const }, cell: ctx => num(ctx.getValue()) },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일자', size: 150 },
  { accessorKey: 'lastModifyBy', header: '최종수정자', size: 90 },
  { accessorKey: 'lastModifyDate', header: '최종수정일자', size: 150 },
];
