import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, dateTime, num } from '../shared-format';

/** PB d_mcn_jig_squeze_check_mlst (IMCN_JIG_SQUEZE_CHECK) */
export interface SqueezeCheckRow {
  jigCode: string; jigLotNo: string | null; jigCheckSequence: number | null;
  jigCheckDate: string | null; jigCheckStatus: string | null; jigCheckStatusName: string | null;
  lineCode: string | null; lineName: string | null;
  cleanYn: string | null; pinHoleYn: string | null; airPressValue: number | null;
  breakValue: number | null; hitValue: number | null; usedBy: string | null;
  confirmYn: string | null; confirmYnName: string | null; confirmDate: string | null;
  comments: string | null; jigName: string | null; jigSpec: string | null;
  enterBy: string | null; enterDate: string | null;
  lastModifyBy: string | null; lastModifyDate: string | null;
}

export const squeezeCheckColumns: ColumnDef<SqueezeCheckRow>[] = [
  { accessorKey: 'jigCheckDate', header: '검사일자', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'jigCode', header: '지그코드', size: 130 },
  { accessorKey: 'jigLotNo', header: '지그LOT', size: 130 },
  { accessorKey: 'jigName', header: '지그명', size: 160 },
  { accessorKey: 'jigCheckSequence', header: '항번', size: 70, meta: { align: 'right' } },
  { id: 'jigCheckStatusName', header: '체크상태', size: 120, accessorFn: (r) => codeWithName(r.jigCheckStatus, r.jigCheckStatusName) },
  { id: 'lineName', header: '라인', size: 110, accessorFn: (r) => codeWithName(r.lineCode, r.lineName) },
  { accessorKey: 'cleanYn', header: '세척', size: 70 },
  { accessorKey: 'pinHoleYn', header: '핀홀', size: 70 },
  { accessorKey: 'airPressValue', header: '공기압력', size: 100, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'hitValue', header: '사용횟수', size: 100, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'breakValue', header: '한계수명', size: 100, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'usedBy', header: '사용자', size: 90 },
  { id: 'confirmYnName', header: '승인', size: 100, accessorFn: (r) => codeWithName(r.confirmYn, r.confirmYnName) },
  { accessorKey: 'confirmDate', header: '승인일자', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'comments', header: '설명', size: 180 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];
