import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, dateTime, num } from '../../jig/shared-format';

/** PB d_mcn_jig_feeder_adjust_lst (IMCN_JIG_FEEDER_ADJUST) */
export interface FeederAdjustRow {
  adjustDate: string | null;
  adjustSequence: number | null;
  jigCode: string;
  jigLotNo: string | null;
  jigName: string | null;
  jigSpec: string | null;
  jigType: string | null;
  jigTypeName: string | null;
  lineCode: string | null;
  lineName: string | null;
  useStatus: string | null;
  hitValue: number | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

export const feederAdjustColumns: ColumnDef<FeederAdjustRow>[] = [
  { accessorKey: 'adjustDate', header: '교정일시', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'adjustSequence', header: '교정항번', size: 90, meta: { align: 'right' } },
  { accessorKey: 'jigCode', header: '피더코드', size: 130 },
  { accessorKey: 'jigLotNo', header: '피더LOT', size: 130 },
  { accessorKey: 'jigName', header: '피더명', size: 160 },
  { accessorKey: 'jigSpec', header: '규격', size: 150 },
  { id: 'jigTypeName', header: '지그유형', size: 120, accessorFn: (r) => codeWithName(r.jigType, r.jigTypeName) },
  { id: 'lineName', header: '라인', size: 110, accessorFn: (r) => codeWithName(r.lineCode, r.lineName) },
  { accessorKey: 'hitValue', header: '사용횟수', size: 100, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'comments', header: '설명', size: 200 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];
