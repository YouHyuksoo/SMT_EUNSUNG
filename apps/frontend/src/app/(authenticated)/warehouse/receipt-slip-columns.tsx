/**
 * @file src/app/(authenticated)/warehouse/receipt-slip-columns.tsx
 * @description 235 자재입고전표관리 그리드 컬럼 + 행 타입.
 *
 * 이 화면의 핵심은 **전표 수량과 발행 수량이 맞는가**다. 어긋나면 입고 원장이
 * 전표와 달라지므로, 수량 열이 눈에 들어와야 한다.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, num } from '@/components/shared/grid-format';
import { formatDisplayDate } from '@/utils/date';

const right = { align: 'right' } as const;
const center = { align: 'center' } as const;
const ts = (value: unknown) => (value ? formatDisplayDate(value) : '');
const yesNo = (value: unknown) => {
  const v = String(value ?? '');
  if (v === 'Y') return '예';
  if (v === 'N') return '아니오';
  return v;
};

/** 235 입고전표 한 줄. */
export interface ReceiptSlipRow {
  receiptSlipNo: string;
  receiptDate: string | null;
  receiptSequence: number | null;
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  receiptBarcode: string | null;
  /** 전표에 적힌 릴 장수 */
  reelQty: number | null;
  /** 전표에 적힌 한 장 수량 */
  receiptUnitQty: number | null;
  /** 전표 총수량. 발행 수량 합이 이 값과 같아야 한다. */
  receiptSumQty: number | null;
  receiptType: string | null;
  receiptStatus: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  enterBy: string | null;
  enterDate: string | null;
  /** 목록에서는 세지 않는다 (느려서 뺐다). 전표를 고르면 바코드 목록에서 알 수 있다. */
  issuedCount: number | null;
}

/** 235 발행된 바코드 한 줄. */
export interface ReceiptSlipBarcodeRow {
  itemBarcode: string;
  lotNo: string | null;
  originItemBarcode: string | null;
  scanQty: number | null;
  scanDate: string | null;
  itemCode: string | null;
  receiptSlipNo: string | null;
  receiptType: string | null;
  barcodeStatus: string | null;
  receiptCompareYn: string | null;
  holdingYn: string | null;
  lotDivideYn: string | null;
  inventoryType: string | null;
  supplierCode: string | null;
  supplierBarcode: string | null;
  supplierLotNo: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 235 발행 결과. */
export interface ReceiptSlipIssueResult {
  slipNo: string;
  itemCode: string;
  issued: number;
  totalQty: number;
  barcodeRows: number;
  receiptRows: number;
  firstBarcode: string | null;
  lastBarcode: string | null;
}

export const receiptSlipColumns: ColumnDef<ReceiptSlipRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 190 },
  { accessorKey: 'receiptSlipNo', header: '전표번호', size: 160 },
  { accessorKey: 'receiptDate', header: '전표일시', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'itemSpec', header: '규격', size: 170 },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  {
    id: 'supplierName',
    header: '협력사',
    size: 170,
    accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName),
  },
  { accessorKey: 'reelQty', header: '릴 장수', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'receiptUnitQty', header: '한 장 수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'receiptSumQty',
    header: '전표 총수량',
    size: 120,
    meta: right,
    // 발행 수량 합이 이 값과 같아야 한다 — 서버가 다르면 거절한다.
    cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
  },
  { accessorKey: 'receiptBarcode', header: '전표 바코드', size: 170 },
  { accessorKey: 'receiptType', header: '입고유형', size: 100, meta: center },
  { accessorKey: 'receiptStatus', header: '상태', size: 90, meta: center },
  { accessorKey: 'enterBy', header: '등록자', size: 100 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

export const receiptSlipBarcodeColumns: ColumnDef<ReceiptSlipBarcodeRow>[] = [
  { accessorKey: 'itemBarcode', header: '자재 바코드', size: 230 },
  { accessorKey: 'lotNo', header: '롯트번호', size: 160 },
  { accessorKey: 'scanQty', header: '수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'scanDate', header: '발행시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'barcodeStatus', header: '바코드상태', size: 110, meta: center },
  {
    accessorKey: 'receiptCompareYn',
    header: '입고대조',
    size: 100,
    meta: center,
    cell: (c) => yesNo(c.getValue()),
  },
  { accessorKey: 'holdingYn', header: '보류', size: 80, meta: center, cell: (c) => yesNo(c.getValue()) },
  { accessorKey: 'lotDivideYn', header: '롯트분할', size: 90, meta: center, cell: (c) => yesNo(c.getValue()) },
  { accessorKey: 'inventoryType', header: '재고유형', size: 100, meta: center },
  { accessorKey: 'supplierBarcode', header: '협력사 바코드', size: 180 },
  { accessorKey: 'supplierLotNo', header: '협력사 롯트', size: 150 },
  { accessorKey: 'supplierCode', header: '협력사', size: 110 },
  { accessorKey: 'receiptType', header: '입고유형', size: 100, meta: center },
  { accessorKey: 'originItemBarcode', header: '원본 바코드', size: 200 },
  { accessorKey: 'enterBy', header: '발행자', size: 100 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];
