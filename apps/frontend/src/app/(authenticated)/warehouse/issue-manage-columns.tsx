/**
 * @file src/app/(authenticated)/warehouse/issue-manage-columns.tsx
 * @description 257 자재기타출고 · 258 자재출고취소 행 타입 + 그리드 컬럼.
 *
 * 입고와 마찬가지로 **수량 부호가 뜻을 정한다** (3 출고 · 4 반납).
 * 취소된 건은 상태 'C' 로 남으므로 눈에 띄게 보여준다.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, num } from '@/components/shared/grid-format';

const right = { align: 'right' } as const;
const center = { align: 'center' } as const;
const ts = (value: unknown) => (value ? String(value) : '');
/** 출고/반납 구분. PB 는 수량 부호로 이 값을 정한다. */
const deficitLabel = (value: unknown) => {
  const v = String(value ?? '');
  if (v === '3') return '출고';
  if (v === '4') return '반납';
  return v;
};

/** 257·258 출고 원장 한 줄. */
export interface IssueRow {
  issueDate: string | null;
  issueSequence: number | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  issueQty: number | null;
  issueDeficit: string | null;
  issuePrice: number | null;
  issueAmt: number | null;
  issueStatus: string | null;
  issueType: string | null;
  issueAccount: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  machineCode: string | null;
  locationCode: string | null;
  materialMfs: string | null;
  mfs: string | null;
  barcode: string | null;
  invoiceNo: string | null;
  workOrderNo: string | null;
  parentItemCode: string | null;
  modelName: string | null;
  lineType: string | null;
  itemType: string | null;
  inventoryType: string | null;
  supplierCode: string | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 257 현재고 한 줄. 여기서 골라 출고한다. */
export interface IssueInventoryRow {
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemType: string | null;
  itemUom: string | null;
  locationAddress: string | null;
  /** 포장 단위. 화면이 실제 출고 수량을 미리 계산할 때 쓴다. */
  issuePackingQty: number | null;
  lineType: string | null;
  inventoryQty: number | null;
  inventoryPrice: number | null;
  inventoryAmt: number | null;
  inventoryStatus: string | null;
  inventoryHold: string | null;
  locationCode: string | null;
  materialMfs: string | null;
  comments: string | null;
}

export const issueColumns: ColumnDef<IssueRow>[] = [
  { accessorKey: 'issueDate', header: '출고일', size: 110, meta: center },
  { accessorKey: 'issueSequence', header: '출고순번', size: 110, meta: right },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  {
    accessorKey: 'issueQty',
    header: '수량',
    size: 110,
    meta: right,
    cell: (c) => {
      const v = Number(c.getValue() ?? 0);
      return <span className={v < 0 ? 'font-semibold text-red-500' : ''}>{num(v)}</span>;
    },
  },
  {
    accessorKey: 'issueDeficit',
    header: '구분',
    size: 80,
    meta: center,
    cell: (c) => deficitLabel(c.getValue()),
  },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  {
    accessorKey: 'issueStatus',
    header: '상태',
    size: 90,
    meta: center,
    // 취소된 건은 원장에 그대로 남는다 — 지운 것이 아니다.
    cell: (c) => (String(c.getValue() ?? '') === 'C'
      ? <span className="font-semibold text-amber-500">취소</span>
      : '정상'),
  },
  { accessorKey: 'issuePrice', header: '출고단가', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'issueAmt', header: '출고금액', size: 120, meta: right, cell: (c) => num(c.getValue()) },
  {
    id: 'lineName',
    header: '라인',
    size: 150,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'workstageCode', header: '공정', size: 90, meta: center },
  { accessorKey: 'machineCode', header: '설비', size: 90, meta: center },
  { accessorKey: 'locationCode', header: '창고', size: 80, meta: center },
  { accessorKey: 'materialMfs', header: '자재 롯트', size: 130 },
  { accessorKey: 'mfs', header: '협력사 롯트', size: 130 },
  { accessorKey: 'barcode', header: '바코드', size: 200 },
  { accessorKey: 'invoiceNo', header: '전표번호', size: 140 },
  { accessorKey: 'workOrderNo', header: '작업지시', size: 120 },
  { accessorKey: 'modelName', header: '모델명', size: 140 },
  { accessorKey: 'issueType', header: '출고유형', size: 90, meta: center },
  { accessorKey: 'issueAccount', header: '출고계정', size: 100, meta: center },
  { accessorKey: 'comments', header: '비고', size: 150 },
  { accessorKey: 'enterBy', header: '등록자', size: 100 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

export const issueInventoryColumns: ColumnDef<IssueInventoryRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'inventoryQty', header: '재고수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  {
    accessorKey: 'issuePackingQty',
    header: '포장 단위',
    size: 100,
    meta: right,
    // 0 이면 올림 없이 요청한 수량 그대로 나간다.
    cell: (c) => (Number(c.getValue() ?? 0) > 0 ? num(c.getValue()) : '—'),
  },
  { accessorKey: 'inventoryPrice', header: '재고단가', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'locationCode', header: '창고', size: 80, meta: center },
  { accessorKey: 'locationAddress', header: '창고번지', size: 110 },
  { accessorKey: 'materialMfs', header: '자재 롯트', size: 130 },
  { accessorKey: 'lineType', header: '구매유형', size: 90, meta: center },
  { accessorKey: 'inventoryStatus', header: '재고상태', size: 100, meta: center },
  { accessorKey: 'inventoryHold', header: '보류', size: 80, meta: center },
];
