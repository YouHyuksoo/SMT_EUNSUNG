/**
 * @file src/app/(authenticated)/design/design-columns.tsx
 * @description 설계(M_DESIGN) 행 타입 + 그리드 컬럼 — 149 적용모델관리.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { num } from '@/components/shared/grid-format';

const right = { align: 'right' } as const;
const ts = (value: unknown) => (value ? String(value) : '');

/** 149 상위 품목 한 줄 (이 자재를 쓰는 품목). */
export interface ApplyItemRow {
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  itemType: string | null;
  itemClass: string | null;
  lineType: string | null;
  barcode: string | null;
  abcGrade: string | null;
  rawMaterial: string | null;
  safetyInventory: number | null;
  workBadRate: number | null;
  manufactureLeadtime: number | null;
  hsCode: string | null;
  svcCode: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 149 제품모델 한 줄. */
export interface ApplyModelRow {
  modelName: string;
  modelSuffix: string | null;
  modelType: string | null;
  modelDivision: string | null;
  partNo: string | null;
  itemCode: string | null;
  customerCode: string | null;
  customerName: string | null;
  customerModelName: string | null;
  ecNo: string | null;
  revision: string | null;
  packingPcsQty: number | null;
  arrayType: string | null;
  barcodeType: string | null;
  dateSet: string | null;
  dateEnd: string | null;
}

export const applyItemColumns: ColumnDef<ApplyItemRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 200 },
  { accessorKey: 'itemSpec', header: '규격', size: 180 },
  { accessorKey: 'itemType', header: '품목유형', size: 100 },
  { accessorKey: 'itemClass', header: '품목분류', size: 110 },
  { accessorKey: 'lineType', header: '라인유형', size: 100 },
  { accessorKey: 'itemUom', header: '단위', size: 80 },
  {
    accessorKey: 'safetyInventory',
    header: '안전재고',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'manufactureLeadtime',
    header: '제조 L/T',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'abcGrade', header: 'ABC', size: 70 },
  { accessorKey: 'hsCode', header: 'HS 코드', size: 110 },
  { accessorKey: 'enterDate', header: '등록일', size: 110, cell: (c) => ts(c.getValue()) },
];

export const applyModelColumns: ColumnDef<ApplyModelRow>[] = [
  { accessorKey: 'modelName', header: '모델', size: 170 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  { accessorKey: 'modelType', header: '모델유형', size: 100 },
  { accessorKey: 'partNo', header: 'Part No', size: 140 },
  { accessorKey: 'customerCode', header: '고객코드', size: 110 },
  { accessorKey: 'customerModelName', header: '고객모델명', size: 170 },
  { accessorKey: 'ecNo', header: 'EC No', size: 110 },
  { accessorKey: 'revision', header: '리비전', size: 90 },
  {
    accessorKey: 'packingPcsQty',
    header: '포장정량',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'dateSet', header: '적용시작', size: 110, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'dateEnd', header: '적용종료', size: 110, cell: (c) => ts(c.getValue()) },
];
