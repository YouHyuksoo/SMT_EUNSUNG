import type { ColumnDef } from '@tanstack/react-table';
import type { JigApplyModelRow, JigMasterRow } from './types';

const dateTime = (value: unknown) => {
  if (!value) return '';
  const parsed = new Date(String(value));
  if (Number.isNaN(parsed.getTime())) return String(value);
  return parsed.toLocaleString('ko-KR', { hour12: false }).replace(/\.\s?$/, '');
};
const dateOnly = (value: unknown) => (value ? String(value).slice(0, 10) : '');
const num = (value: unknown) => (value == null ? '' : Number(value).toLocaleString());

/** 코드컬럼은 뜻을 보여주고 코드는 괄호로 함께 둔다 (그리드에 원시 코드만 나가지 않도록) */
const codeWithName = (code: unknown, name: unknown) => {
  const text = name ? String(name) : '';
  return text ? `${text} (${String(code ?? '')})` : String(code ?? '');
};

export const jigMasterColumns: ColumnDef<JigMasterRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 130 },
  { accessorKey: 'jigCode', header: '지그코드', size: 130 },
  { accessorKey: 'jigLotNo', header: '지그LOT', size: 130 },
  { accessorKey: 'jigName', header: '지그명', size: 170 },
  { id: 'jigTypeName', header: '지그유형', size: 130, accessorFn: (r) => codeWithName(r.jigType, r.jigTypeName) },
  { id: 'jigStatusName', header: '지그상태', size: 120, accessorFn: (r) => codeWithName(r.jigStatus, r.jigStatusName) },
  { id: 'useStatusName', header: '사용상태', size: 120, accessorFn: (r) => codeWithName(r.useStatus, r.useStatusName) },
  { id: 'lineName', header: '라인', size: 110, accessorFn: (r) => codeWithName(r.lineCode, r.lineName) },
  { id: 'workstageName', header: '공정', size: 120, accessorFn: (r) => codeWithName(r.workstageCode, r.workstageName) },
  { accessorKey: 'machineCode', header: '설비코드', size: 110 },
  { accessorKey: 'jigModelName', header: '지그모델명', size: 150 },
  { accessorKey: 'jigSpec', header: '지그규격', size: 150 },
  { id: 'pcbItemName', header: 'T/B', size: 100, accessorFn: (r) => codeWithName(r.pcbItem, r.pcbItemName) },
  { accessorKey: 'solderType', header: '솔더타입', size: 90 },
  { accessorKey: 'hitValue', header: '사용횟수', size: 100, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'breakValue', header: '한계수명', size: 100, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'minTension', header: '최소장력', size: 90, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'maxTension', header: '최대장력', size: 90, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
  { accessorKey: 'tensionCheckYn', header: '장력측정', size: 90 },
  { accessorKey: 'useTpmYn', header: '자주보전', size: 90 },
  { id: 'acquisitionTypeName', header: '취득유형', size: 120, accessorFn: (r) => codeWithName(r.acquisitionType, r.acquisitionTypeName) },
  { accessorKey: 'acquisitionDate', header: '취득일자', size: 110, cell: (c) => dateOnly(c.getValue()) },
  { accessorKey: 'locationAddress', header: '자재위치', size: 130 },
  { accessorKey: 'customerCode', header: '고객코드', size: 110 },
  { accessorKey: 'supplierCode', header: '제작처', size: 110 },
  { accessorKey: 'managementCommnets', header: '관리설명', size: 180 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'lastModifyBy', header: '수정자', size: 90 },
  { accessorKey: 'lastModifyDate', header: '수정일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];

export const jigApplyModelColumns: ColumnDef<JigApplyModelRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'applySmtModelName', header: '적용 SMT 모델', size: 200 },
  { accessorKey: 'enterBy', header: '등록자', size: 100 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => dateTime(c.getValue()) },
];
