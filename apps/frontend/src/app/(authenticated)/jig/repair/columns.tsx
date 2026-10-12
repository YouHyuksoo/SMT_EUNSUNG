import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, dateOnly, dateTime, num } from '@/components/shared/grid-format';

/** PB d_mcn_jig_repair_lst (IMCN_JIG_REPAIR) */
export interface JigRepairRow {
  jigCode: string; jigLotNo: string | null; repairSequence: number | null;
  repairStatus: string | null; repairStatusName: string | null;
  repairReasonCode: string | null; repairReasonName: string | null;
  repairRequestDate: string | null; repairDate: string | null; repairTime: number | null;
  repairBy: string | null;
  repairVendorCode: string | null; repairVendorName: string | null;
  repairAmt: number | null; currency: string | null;
  comments: string | null; repairComments: string | null;
  jigName: string | null; jigType: string | null; jigTypeName: string | null;
  enterBy: string | null; enterDate: string | null;
  lastModifyBy: string | null; lastModifyDate: string | null;
}

export const jigRepairColumns: ColumnDef<JigRepairRow>[] = [
  { accessorKey: 'repairRequestDate', header: '수리신청일', size: 120, cell: (c) => dateOnly(c.getValue()) },
  { accessorKey: 'jigCode', header: '지그코드', size: 130 },
  { accessorKey: 'jigLotNo', header: '지그LOT', size: 130 },
  { accessorKey: 'jigName', header: '지그명', size: 160 },
  { id: 'jigTypeName', header: '지그유형', size: 120, accessorFn: (r) => codeWithName(r.jigType, r.jigTypeName) },
  { accessorKey: 'repairSequence', header: '수리차수', size: 90, meta: { align: 'right' } },
  { id: 'repairStatusName', header: '수리상태', size: 130, accessorFn: (r) => codeWithName(r.repairStatus, r.repairStatusName) },
  { id: 'repairReasonName', header: '수리원인', size: 130, accessorFn: (r) => codeWithName(r.repairReasonCode, r.repairReasonName) },
  { id: 'repairVendorName', header: '수리처', size: 130, accessorFn: (r) => codeWithName(r.repairVendorCode, r.repairVendorName) },
  { accessorKey: 'repairDate', header: '수리일자', size: 120, cell: (c) => dateOnly(c.getValue()) },
  { accessorKey: 'repairTime', header: '수리시간', size: 90, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'repairBy', header: '수리자', size: 90 },
  { accessorKey: 'repairAmt', header: '수리금액', size: 110, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'currency', header: '통화', size: 70 },
  { accessorKey: 'comments', header: '신청내용', size: 200 },
  { accessorKey: 'repairComments', header: '수리내용', size: 200 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];
