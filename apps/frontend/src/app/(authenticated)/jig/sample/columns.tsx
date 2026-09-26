import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, dateOnly, dateTime, num } from '../shared-format';

/** PB d_mcn_sample_lst (IMCN_SAMPLE) */
export interface SampleMasterRow {
  sampleCode: string; sampleLotNo: string | null;
  sampleName: string | null; sampleSpec: string | null;
  sampleType: string | null; sampleTypeName: string | null;
  sampleStatus: string | null; sampleStatusName: string | null;
  sampleSection: string | null; sampleSectionName: string | null;
  sampleGrade: string | null;
  useStatus: string | null; useStatusName: string | null;
  sampleApplyDate: string | null; validMonths: number | null;
  remainDays: number | null; expireDate: string | null;
  lineCode: string | null; lineName: string | null;
  workstageCode: string | null; workstageName: string | null;
  modelName: string | null; sampleBarcode: string | null; locationAddress: string | null;
  managementCommnets: string | null; useNsnpYn: string | null;
  enterBy: string | null; enterDate: string | null;
  lastModifyBy: string | null; lastModifyDate: string | null;
}

/** PB d_mcn_sample_apply_model_lst */
export interface SampleApplyModelRow {
  sampleCode: string; sampleLotNo: string; itemCode: string;
  applySmtModelName: string | null; enterBy: string | null; enterDate: string | null;
}

export const sampleMasterColumns: ColumnDef<SampleMasterRow>[] = [
  { accessorKey: 'sampleCode', header: '샘플코드', size: 130 },
  { accessorKey: 'sampleLotNo', header: '샘플LOT', size: 130 },
  { accessorKey: 'sampleName', header: '샘플명', size: 170 },
  { accessorKey: 'sampleSpec', header: '규격', size: 150 },
  { id: 'sampleTypeName', header: '샘플유형', size: 140, accessorFn: (r) => codeWithName(r.sampleType, r.sampleTypeName) },
  { id: 'sampleStatusName', header: '샘플상태', size: 120, accessorFn: (r) => codeWithName(r.sampleStatus, r.sampleStatusName) },
  { id: 'sampleSectionName', header: '구역', size: 110, accessorFn: (r) => codeWithName(r.sampleSection, r.sampleSectionName) },
  { id: 'useStatusName', header: '사용상태', size: 120, accessorFn: (r) => codeWithName(r.useStatus, r.useStatusName) },
  { accessorKey: 'sampleApplyDate', header: '적용일자', size: 110, cell: (c) => dateOnly(c.getValue()) },
  { accessorKey: 'validMonths', header: '유효개월', size: 90, meta: { align: 'right' } },
  { accessorKey: 'expireDate', header: '만료일자', size: 110, cell: (c) => dateOnly(c.getValue()) },
  {
    accessorKey: 'remainDays',
    header: '잔여일',
    size: 90,
    meta: { align: 'right' },
    // PB 는 잔여일이 지난 샘플을 빨간색으로 칠한다. 색 규칙만 옮긴다.
    cell: (c) => {
      const value = Number(c.getValue() ?? 0);
      return <span className={value <= 0 ? 'font-semibold text-red-600' : ''}>{num(value)}</span>;
    },
  },
  { id: 'lineName', header: '라인', size: 110, accessorFn: (r) => codeWithName(r.lineCode, r.lineName) },
  { id: 'workstageName', header: '공정', size: 120, accessorFn: (r) => codeWithName(r.workstageCode, r.workstageName) },
  { accessorKey: 'modelName', header: '모델명', size: 150 },
  { accessorKey: 'sampleBarcode', header: '샘플바코드', size: 160 },
  { accessorKey: 'locationAddress', header: '보관위치', size: 130 },
  { accessorKey: 'managementCommnets', header: '관리설명', size: 180 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];

export const sampleApplyModelColumns: ColumnDef<SampleApplyModelRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'applySmtModelName', header: '적용 SMT 모델', size: 200 },
  { accessorKey: 'enterBy', header: '등록자', size: 100 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => dateTime(c.getValue()) },
];
