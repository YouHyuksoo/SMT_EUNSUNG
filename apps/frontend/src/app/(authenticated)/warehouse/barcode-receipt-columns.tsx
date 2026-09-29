/**
 * @file src/app/(authenticated)/warehouse/barcode-receipt-columns.tsx
 * @description 237 자재바코드입고관리 행 타입 + 그리드 컬럼.
 *
 * 이 화면의 핵심은 **대조 여부**다. 대조되지 않은 바코드는 입고되지 않은 물건이라
 * 재고에 없다. 그래서 대조 열이 눈에 들어와야 한다.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, num } from '@/components/shared/grid-format';

const right = { align: 'right' } as const;
const center = { align: 'center' } as const;
const ts = (value: unknown) => (value ? String(value) : '');
const yesNo = (value: unknown) => {
  const v = String(value ?? '');
  if (v === 'Y') return '예';
  if (v === 'N') return '아니오';
  return v;
};

/** 237 바코드 한 줄 (대조대기 · 바코드이력 공용). */
export interface BarcodeRow {
  itemBarcode: string;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  lotNo: string | null;
  scanQty: number | null;
  scanDate: string | null;
  receiptSlipNo: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  supplierBarcode: string | null;
  supplierItemCode: string | null;
  receiptCompareYn: string | null;
  receiptCompareDate: string | null;
  receiptCompareBy: string | null;
  barcodeStatus: string | null;
  receiptType: string | null;
  fromSupplierCode: string | null;
  lotDivideYn: string | null;
  originItemBarcode: string | null;
  labelType: string | null;
  locationAddress: string | null;
  mslLevel: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 237 입고 원장 한 줄. */
export interface BarcodeReceiptRow {
  receiptSequence: number | null;
  receiptDate: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  receiptQty: number | null;
  unitPrice: number | null;
  receiptAmt: number | null;
  invoiceNo: string | null;
  barcode: string | null;
  materialMfs: string | null;
  mfs: string | null;
  originMfs: string | null;
  receiptLotNo: string | null;
  locationCode: string | null;
  lineType: string | null;
  receiptType: string | null;
  receiptStatus: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  originSupplierCode: string | null;
  fromSupplierCode: string | null;
  confirmYn: string | null;
  interfaceYn: string | null;
  currency: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 237 발행됐지만 입고되지 않은 바코드 한 줄. */
export interface NoReceiptBarcodeRow {
  itemBarcode: string;
  scanDate: string | null;
  lotNo: string | null;
  scanQty: number | null;
  supplierBarcode: string | null;
}

/** 237 바코드를 풀어 본 결과 (쓰기 전에 화면이 보여준다). */
export interface BarcodeScanLookup {
  itemCode: string | null;
  lotNo: string | null;
  scanQty: number | null;
  supplierItemCode: string | null;
  itemMatches: boolean | null;
  itemExists: boolean;
  needsSupplierLot: boolean;
  item: {
    itemName?: string | null;
    itemSpec?: string | null;
    itemClass?: string | null;
    ecoCheckYn?: string | null;
    ecoCheckComments?: string | null;
    receiptLotCheckYn?: string | null;
    keyitemYn?: string | null;
    vendorCode1?: string | null;
    vendorCode2?: string | null;
    vendorCode3?: string | null;
  } | null;
  barcodeRow: {
    receiptSlipNo?: string | null;
    receiptCompareYn?: string | null;
    barcodeStatus?: string | null;
    labelType?: string | null;
    manufactureWeek?: string | null;
    pcbCoatingDate?: string | null;
    ledgerQty?: number | null;
  } | null;
}

/** 237 대조 결과. */
export interface BarcodeCompareResult {
  barcode: string;
  supplierBarcode: string;
  itemCode: string;
  lotNo: string;
  receiptQty: number;
  slipNo: string;
  locationCode: string;
  comparedRows: number;
  receiptRows: number;
}

export const barcodeColumns: ColumnDef<BarcodeRow>[] = [
  { accessorKey: 'itemBarcode', header: '자재 바코드', size: 230 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 170 },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  { accessorKey: 'scanQty', header: '수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'receiptCompareYn',
    header: '입고대조',
    size: 100,
    meta: center,
    // 대조 안 된 바코드는 입고되지 않은 물건이다 — 굵게 보여 준다.
    cell: (c) => {
      const v = String(c.getValue() ?? '');
      return v === 'Y'
        ? <span className="text-text-muted">완료</span>
        : <span className="font-semibold text-amber-500">대기</span>;
    },
  },
  { accessorKey: 'receiptCompareDate', header: '대조시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'receiptCompareBy', header: '대조자', size: 100 },
  { accessorKey: 'receiptSlipNo', header: '전표번호', size: 150 },
  { accessorKey: 'supplierBarcode', header: '협력사 바코드', size: 190 },
  { accessorKey: 'supplierItemCode', header: '협력사 품목', size: 150 },
  {
    id: 'supplierName',
    header: '협력사',
    size: 170,
    accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName),
  },
  { accessorKey: 'barcodeStatus', header: '바코드상태', size: 100, meta: center },
  { accessorKey: 'lotDivideYn', header: '롯트분할', size: 90, meta: center, cell: (c) => yesNo(c.getValue()) },
  { accessorKey: 'labelType', header: '라벨유형', size: 90, meta: center },
  { accessorKey: 'locationAddress', header: '창고번지', size: 110 },
  { accessorKey: 'mslLevel', header: 'MSL', size: 80, meta: center },
  { accessorKey: 'originItemBarcode', header: '원본 바코드', size: 200 },
  { accessorKey: 'scanDate', header: '발행시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'enterBy', header: '발행자', size: 100 },
];

export const barcodeReceiptColumns: ColumnDef<BarcodeReceiptRow>[] = [
  { accessorKey: 'receiptDate', header: '입고일', size: 110, meta: center },
  { accessorKey: 'receiptSequence', header: '입고순번', size: 110, meta: right },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 170 },
  { accessorKey: 'receiptQty', header: '입고수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'unitPrice',
    header: '단가',
    size: 100,
    meta: right,
    // 이 경로의 단가는 **0 이 정상이다** (PB 가 단가 조회를 주석 처리했다).
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'receiptAmt', header: '입고금액', size: 120, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'invoiceNo', header: '전표번호', size: 150 },
  { accessorKey: 'barcode', header: '자재 바코드', size: 220 },
  { accessorKey: 'materialMfs', header: '자재 롯트', size: 130 },
  { accessorKey: 'mfs', header: '협력사 롯트', size: 140 },
  { accessorKey: 'originMfs', header: '협력사 바코드', size: 190 },
  { accessorKey: 'receiptLotNo', header: '입고 롯트번호', size: 130 },
  { accessorKey: 'locationCode', header: '창고', size: 80, meta: center },
  { accessorKey: 'lineType', header: '구매유형', size: 90, meta: center },
  { accessorKey: 'receiptType', header: '입고유형', size: 90, meta: center },
  { accessorKey: 'receiptStatus', header: '상태', size: 80, meta: center },
  {
    id: 'supplierName',
    header: '협력사',
    size: 170,
    accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName),
  },
  { accessorKey: 'originSupplierCode', header: '원 협력사', size: 110 },
  { accessorKey: 'confirmYn', header: '확정', size: 70, meta: center, cell: (c) => yesNo(c.getValue()) },
  { accessorKey: 'interfaceYn', header: '전송', size: 70, meta: center, cell: (c) => yesNo(c.getValue()) },
  { accessorKey: 'enterBy', header: '등록자', size: 100 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

export const noReceiptBarcodeColumns: ColumnDef<NoReceiptBarcodeRow>[] = [
  { accessorKey: 'itemBarcode', header: '자재 바코드', size: 240 },
  { accessorKey: 'lotNo', header: '롯트번호', size: 140 },
  { accessorKey: 'scanQty', header: '수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'supplierBarcode', header: '협력사 바코드 (스캔이력)', size: 230 },
  { accessorKey: 'scanDate', header: '발행시각', size: 170, cell: (c) => ts(c.getValue()) },
];
