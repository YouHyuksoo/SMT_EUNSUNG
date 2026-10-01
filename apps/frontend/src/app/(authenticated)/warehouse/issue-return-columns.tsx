/**
 * @file src/app/(authenticated)/warehouse/issue-return-columns.tsx
 * @description 250 출고바코드반품 행 타입 + 그리드 컬럼.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, num } from '@/components/shared/grid-format';
import { formatDisplayDate } from '@/utils/date';

const right = { align: 'right' } as const;
const center = { align: 'center' } as const;
const ts = (value: unknown) => (value ? formatDisplayDate(value) : '');

/** 250 반품 한 줄 (출고 원장의 마이너스 출고). */
export interface IssueReturnRow {
  issueDate: string | null;
  issueSequence: number | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  issueQty: number | null;
  lotNo: string | null;
  barcode: string | null;
  lineCode: string | null;
  lineName: string | null;
  receiptSlipNo: string | null;
  supplierCode: string | null;
  locationCode: string | null;
  issueAccount: string | null;
  issueDivision: string | null;
  feederShaft: string | null;
  inventoryType: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 250 로스 한 줄. */
export interface IssueLossRow {
  issueDate: string | null;
  issueSequence: number | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  lotNo: string | null;
  modelName: string | null;
  lineCode: string | null;
  lineName: string | null;
  lossQty: number | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 250 바코드를 풀어 본 결과. */
export interface IssueReturnLookup {
  itemCode: string | null;
  lotNo: string | null;
  lastIssueLineCode: string | null;
  returnable: boolean;
  reason: string | null;
  barcodeRow: {
    receiptSlipNo?: string | null;
    issueCompareYn?: string | null;
    issueReturnYn?: string | null;
    labelType?: string | null;
    currentQty?: number | null;
    itemBarcode?: string | null;
    itemName?: string | null;
    itemSpec?: string | null;
    feederShaft?: string | null;
    issueDivision?: string | null;
    feederLocationCode?: string | null;
  } | null;
}

/** 250 반품 결과. */
export interface IssueReturnResult {
  barcode: string;
  itemCode: string;
  lotNo: string;
  returnQty: number;
  actualQty: number;
  lossQty: number;
  newBarcode: string;
  previousQty: number;
  lineCode: string;
}

export const issueReturnColumns: ColumnDef<IssueReturnRow>[] = [
  { accessorKey: 'issueDate', header: '반품일', size: 110, meta: center },
  { accessorKey: 'issueSequence', header: '순번', size: 100, meta: right },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  {
    accessorKey: 'issueQty',
    header: '반품 수량',
    size: 110,
    meta: right,
    // 반품은 출고 원장에 마이너스로 들어간다 — 음수가 정상이다.
    cell: (c) => <span className="font-semibold">{num(Math.abs(Number(c.getValue() ?? 0)))}</span>,
  },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  { accessorKey: 'barcode', header: '반품 전 바코드', size: 220 },
  {
    id: 'lineName',
    header: '라인',
    size: 150,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'receiptSlipNo', header: '전표번호', size: 150 },
  { accessorKey: 'supplierCode', header: '협력사', size: 110 },
  { accessorKey: 'issueDivision', header: '출고구분', size: 100, meta: center },
  { accessorKey: 'feederShaft', header: '피더', size: 90, meta: center },
  { accessorKey: 'inventoryType', header: '재고유형', size: 100, meta: center },
  { accessorKey: 'enterBy', header: '처리자', size: 100 },
  { accessorKey: 'enterDate', header: '처리일시', size: 160, cell: (c) => ts(c.getValue()) },
];

export const issueLossColumns: ColumnDef<IssueLossRow>[] = [
  { accessorKey: 'issueDate', header: '발생일시', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  {
    accessorKey: 'lossQty',
    header: '로스 수량',
    size: 110,
    meta: right,
    cell: (c) => {
      const v = Number(c.getValue() ?? 0);
      return <span className={v > 0 ? 'font-semibold text-red-500' : ''}>{num(v)}</span>;
    },
  },
  {
    id: 'lineName',
    header: '라인',
    size: 150,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'modelName', header: '모델명', size: 140 },
  { accessorKey: 'enterBy', header: '처리자', size: 100 },
  { accessorKey: 'enterDate', header: '처리일시', size: 160, cell: (c) => ts(c.getValue()) },
];
