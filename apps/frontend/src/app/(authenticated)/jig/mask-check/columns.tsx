import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, dateTime, num } from '@/components/shared/grid-format';

/** PB d_mcn_jig_mask_check_lst (IMCN_JIG_MASK_CHECK) */
export interface MaskCheckRow {
  jigCode: string; jigLotNo: string | null; jigCheckSequence: number | null;
  jigCheckDate: string | null; jigCheckStatus: string | null; jigCheckStatusName: string | null;
  jigCheckType: string | null;
  lineCode: string | null; lineName: string | null; cleanYn: string | null;
  tensionCheck1: number | null; tensionCheck2: number | null; tensionCheck3: number | null;
  tensionCheck4: number | null; tensionCheck5: number | null; maxTension: number | null;
  tensionCheck1Ext: number | null; tensionCheck2Ext: number | null; tensionCheck3Ext: number | null;
  tensionCheck4Ext: number | null; tensionCheck5Ext: number | null; tensionCheck6Ext: number | null;
  usedQty: number | null; actualValue: number | null;
  breakValue: number | null; hitValue: number | null;
  usedBy: string | null; returnBy: string | null;
  confirmYn: string | null; confirmYnName: string | null; confirmDate: string | null;
  comments: string | null; jigName: string | null; jigSpec: string | null;
  jigMinTension: number | null; jigMaxTension: number | null;
  enterBy: string | null; enterDate: string | null;
  lastModifyBy: string | null; lastModifyDate: string | null;
}

export const maskCheckColumns: ColumnDef<MaskCheckRow>[] = [
  { accessorKey: 'jigCheckDate', header: '검사일자', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'jigCode', header: '지그코드', size: 130 },
  { accessorKey: 'jigLotNo', header: '지그LOT', size: 130 },
  { accessorKey: 'jigName', header: '지그명', size: 160 },
  { accessorKey: 'jigCheckSequence', header: '항번', size: 70, meta: { align: 'right' } },
  { id: 'jigCheckStatusName', header: '체크상태', size: 120, accessorFn: (r) => codeWithName(r.jigCheckStatus, r.jigCheckStatusName) },
  { id: 'lineName', header: '라인', size: 110, accessorFn: (r) => codeWithName(r.lineCode, r.lineName) },
  { accessorKey: 'cleanYn', header: '세척', size: 70 },
  { accessorKey: 'tensionCheck1', header: '장력1', size: 80, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'tensionCheck2', header: '장력2', size: 80, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'tensionCheck3', header: '장력3', size: 80, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'tensionCheck4', header: '장력4', size: 80, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'tensionCheck5', header: '장력5', size: 80, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'maxTension', header: '최대장력', size: 100, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'jigMinTension', header: '기준 최소', size: 100, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'jigMaxTension', header: '기준 최대', size: 100, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'hitValue', header: '사용횟수', size: 100, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'breakValue', header: '한계수명', size: 100, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'usedBy', header: '사용자', size: 90 },
  { accessorKey: 'returnBy', header: '반납자', size: 90 },
  { id: 'confirmYnName', header: '승인', size: 100, accessorFn: (r) => codeWithName(r.confirmYn, r.confirmYnName) },
  { accessorKey: 'confirmDate', header: '승인일자', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'comments', header: '설명', size: 180 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];
