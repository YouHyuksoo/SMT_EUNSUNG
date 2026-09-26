import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, dateOnly, dateTime, num } from '../shared-format';

/** PB d_mcn_jig_pm_plan_lst (IMCN_JIG_PM_MASTER) */
export interface JigPmRow {
  lineCode: string | null; lineName: string | null;
  jigCode: string; jigLotNo: string | null; jigName: string | null;
  pmType: string | null; pmTypeName: string | null;
  pmDivision: string | null; pmDivisionName: string | null;
  planDate: string | null; pmDate: string | null;
  breakValue: number | null; hitValue: number | null;
  confirmYn: string | null; confirmYnName: string | null;
  confirmBy: string | null; charger: string | null; comments: string | null;
  enterBy: string | null; enterDate: string | null;
  lastModifyBy: string | null; lastModifyDate: string | null;
}

export const jigPmColumns: ColumnDef<JigPmRow>[] = [
  { accessorKey: 'planDate', header: '계획일자', size: 120, cell: (c) => dateOnly(c.getValue()) },
  { accessorKey: 'pmDate', header: '보전일자', size: 120, cell: (c) => dateOnly(c.getValue()) },
  { id: 'lineName', header: '라인', size: 110, accessorFn: (r) => codeWithName(r.lineCode, r.lineName) },
  { accessorKey: 'jigCode', header: '지그코드', size: 130 },
  { accessorKey: 'jigLotNo', header: '지그LOT', size: 130 },
  { accessorKey: 'jigName', header: '지그명', size: 160 },
  { id: 'pmTypeName', header: 'PM 유형', size: 200, accessorFn: (r) => codeWithName(r.pmType, r.pmTypeName) },
  { id: 'pmDivisionName', header: 'PM 주기', size: 140, accessorFn: (r) => codeWithName(r.pmDivision, r.pmDivisionName) },
  { accessorKey: 'hitValue', header: '사용횟수', size: 100, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'breakValue', header: '한계수명', size: 100, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { id: 'confirmYnName', header: '승인', size: 100, accessorFn: (r) => codeWithName(r.confirmYn, r.confirmYnName) },
  { accessorKey: 'confirmBy', header: '승인자', size: 90 },
  { accessorKey: 'charger', header: '담당자', size: 90 },
  { accessorKey: 'comments', header: '설명', size: 200 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];
