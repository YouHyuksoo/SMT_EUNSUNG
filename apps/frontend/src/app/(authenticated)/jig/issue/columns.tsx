import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, dateOnly, dateTime, num } from '../shared-format';

/** PB d_mcn_jig_issue_lst (IMCN_JIG_ISSUE) */
export interface JigIssueRow {
  issueDate: string | null; issueSequence: number | null;
  jigCode: string; jigLotNo: string | null;
  issueDeficit: string | null; issueDeficitName: string | null;
  issueQty: number | null;
  issueStatus: string | null; issueStatusName: string | null;
  issueAccount: string | null; issueAccountName: string | null;
  workstageCode: string | null; workstageName: string | null; machineCode: string | null;
  jigName: string | null; jigType: string | null; jigTypeName: string | null;
  enterBy: string | null; enterDate: string | null;
  lastModifyBy: string | null; lastModifyDate: string | null;
}

export const jigIssueColumns: ColumnDef<JigIssueRow>[] = [
  { accessorKey: 'issueDate', header: '출고일자', size: 120, cell: (c) => dateOnly(c.getValue()) },
  { accessorKey: 'issueSequence', header: '순번', size: 80, meta: { align: 'right' } },
  { accessorKey: 'jigCode', header: '지그코드', size: 130 },
  { accessorKey: 'jigLotNo', header: '지그LOT', size: 130 },
  { accessorKey: 'jigName', header: '지그명', size: 160 },
  { id: 'jigTypeName', header: '지그유형', size: 120, accessorFn: (r) => codeWithName(r.jigType, r.jigTypeName) },
  { id: 'issueDeficitName', header: '출고구분', size: 120, accessorFn: (r) => codeWithName(r.issueDeficit, r.issueDeficitName) },
  { accessorKey: 'issueQty', header: '출고수량', size: 100, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { id: 'issueStatusName', header: '출고상태', size: 110, accessorFn: (r) => codeWithName(r.issueStatus, r.issueStatusName) },
  { id: 'issueAccountName', header: '출고계정', size: 130, accessorFn: (r) => codeWithName(r.issueAccount, r.issueAccountName) },
  { id: 'workstageName', header: '공정', size: 120, accessorFn: (r) => codeWithName(r.workstageCode, r.workstageName) },
  { accessorKey: 'machineCode', header: '설비코드', size: 110 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];
