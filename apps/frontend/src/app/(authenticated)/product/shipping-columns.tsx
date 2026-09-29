/**
 * @file src/app/(authenticated)/product/shipping-columns.tsx
 * @description 출하현황 행 타입 + 그리드 컬럼 — 299 포장 · 311 패킹이력 ·
 *   302·304 입고 · 307·308 출하.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { num } from '@/components/shared/grid-format';

const right = { align: 'right' } as const;
const center = { align: 'center' } as const;
const ts = (value: unknown) => (value ? String(value) : '');

/** Y/N 플래그를 눈에 띄게. 단계가 어디까지 갔는지 한눈에 본다. */
const flagCell = (label: string) => (value: unknown) => (
  String(value ?? 'N') === 'Y'
    ? <span className="font-medium text-emerald-500">{label}</span>
    : <span className="text-text-muted">-</span>
);

/** 입·출고 수량 — 취소분은 음수로 오므로 색으로 구분한다. */
const signedQty = (value: unknown) => {
  const v = Number(value ?? 0);
  return (
    <span className={v < 0 ? 'font-semibold text-red-500' : ''}>{num(v)}</span>
  );
};

// ───────────────────────────────── 299 포장

export interface PackRow {
  packBarcode: string;
  packType: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  partNo: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  packingPcsQty: number | null;
  packQty: number | null;
  completeFlag: string | null;
  printFlag: string | null;
  receiptFlag: string | null;
  shipFlag: string | null;
  reprint: number | null;
  receiptNo: string | null;
  shipNo: string | null;
  customerCode: string | null;
  runNo: string | null;
  enterBy: string | null;
  packDate: string | null;
  receiptDate: string | null;
  shipDate: string | null;
  enterDate: string | null;
}

export interface PackSerialRow {
  serialNo: string;
  packBarcode: string | null;
  masterBarcode: string | null;
  runNo: string | null;
  lineCode: string | null;
  workstageCode: string | null;
  finalInspectFlag: string | null;
  barcodeQty: number | null;
  enterBy: string | null;
  scanDate: string | null;
  finalInspectDate: string | null;
}

export const packColumns: ColumnDef<PackRow>[] = [
  { accessorKey: 'packBarcode', header: '박스 바코드', size: 220 },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  {
    accessorKey: 'packQty',
    header: '담긴 수량',
    size: 100,
    meta: right,
    cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
  },
  {
    accessorKey: 'packingPcsQty',
    header: '박스 정량',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'completeFlag',
    header: '포장완료',
    size: 90,
    meta: center,
    cell: (c) => flagCell('완료')(c.getValue()),
  },
  {
    accessorKey: 'receiptFlag',
    header: '입고',
    size: 80,
    meta: center,
    cell: (c) => flagCell('입고')(c.getValue()),
  },
  {
    accessorKey: 'shipFlag',
    header: '출하',
    size: 80,
    meta: center,
    cell: (c) => flagCell('출하')(c.getValue()),
  },
  { accessorKey: 'lineName', header: '라인', size: 110 },
  { accessorKey: 'runNo', header: '런카드', size: 130 },
  {
    accessorKey: 'reprint',
    header: '재출력',
    size: 80,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'enterBy', header: '작성자', size: 100 },
  { accessorKey: 'packDate', header: '포장일', size: 110, cell: (c) => ts(c.getValue()) },
];

export const packSerialColumns: ColumnDef<PackSerialRow>[] = [
  { accessorKey: 'serialNo', header: 'PID', size: 200 },
  { accessorKey: 'runNo', header: '런카드', size: 130 },
  { accessorKey: 'lineCode', header: '라인', size: 80, meta: center },
  { accessorKey: 'workstageCode', header: '공정', size: 90, meta: center },
  {
    accessorKey: 'finalInspectFlag',
    header: '최종검사',
    size: 90,
    meta: center,
    cell: (c) => (String(c.getValue() ?? '') === 'OK'
      ? <span className="font-medium text-emerald-500">OK</span>
      : <span className="text-text-muted">{ts(c.getValue()) || '-'}</span>),
  },
  { accessorKey: 'enterBy', header: '작성자', size: 100 },
  { accessorKey: 'scanDate', header: '담은일시', size: 160, cell: (c) => ts(c.getValue()) },
];

// ───────────────────────────────── 311 패킹이력

export interface PackHistoryRow extends PackSerialRow {
  modelName: string | null;
  modelSuffix: string | null;
  partNo: string | null;
  completeFlag: string | null;
  receiptFlag: string | null;
  shipFlag: string | null;
  shipNo: string | null;
  packDate: string | null;
  shipDate: string | null;
  lineName: string | null;
}

export const packHistoryColumns: ColumnDef<PackHistoryRow>[] = [
  { accessorKey: 'serialNo', header: 'PID', size: 200 },
  { accessorKey: 'packBarcode', header: '박스 바코드', size: 220 },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'runNo', header: '런카드', size: 130 },
  { accessorKey: 'lineName', header: '라인', size: 110 },
  {
    accessorKey: 'completeFlag',
    header: '포장완료',
    size: 90,
    meta: center,
    cell: (c) => flagCell('완료')(c.getValue()),
  },
  {
    accessorKey: 'receiptFlag',
    header: '입고',
    size: 80,
    meta: center,
    cell: (c) => flagCell('입고')(c.getValue()),
  },
  {
    accessorKey: 'shipFlag',
    header: '출하',
    size: 80,
    meta: center,
    cell: (c) => flagCell('출하')(c.getValue()),
  },
  { accessorKey: 'shipNo', header: '출하번호', size: 130 },
  { accessorKey: 'packDate', header: '포장일', size: 110, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'scanDate', header: '담은일시', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'shipDate', header: '출하일시', size: 160, cell: (c) => ts(c.getValue()) },
];

// ───────────────────────────────── 302·304 입고

export interface FgReceiptRow {
  receiptDate: string | null;
  receiptSequence: number | null;
  barcode: string;
  packType: string | null;
  txnDeficit: string | null;
  qty: number | null;
  modelName: string | null;
  modelSuffix: string | null;
  itemCode: string | null;
  itemType: string | null;
  mfs: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  machineCode: string | null;
  locationCode: string | null;
  shiftCode: string | null;
  workTimeZone: string | null;
  enterBy: string | null;
  actualDate: string | null;
}

/** `TXN_DEFICIT` 1 입고 / 2 입고취소 · 3 출고 / 4 출고취소. */
export const TXN_NAME: Record<string, string> = {
  '1': '입고',
  '2': '입고취소',
  '3': '출고',
  '4': '출고취소',
};

const txnCell = (value: unknown) => {
  const code = String(value ?? '');
  const name = TXN_NAME[code] ?? code;
  const cancel = code === '2' || code === '4';
  return (
    <span className={cancel ? 'font-medium text-red-500' : 'font-medium'}>{name}</span>
  );
};

export const fgReceiptColumns: ColumnDef<FgReceiptRow>[] = [
  { accessorKey: 'barcode', header: '바코드', size: 220 },
  {
    accessorKey: 'txnDeficit',
    header: '구분',
    size: 90,
    meta: center,
    cell: (c) => txnCell(c.getValue()),
  },
  {
    accessorKey: 'qty',
    header: '수량',
    size: 90,
    meta: right,
    cell: (c) => signedQty(c.getValue()),
  },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  { accessorKey: 'itemCode', header: '품목코드', size: 130 },
  { accessorKey: 'locationCode', header: '창고', size: 80, meta: center },
  { accessorKey: 'lineName', header: '라인', size: 110 },
  { accessorKey: 'shiftCode', header: '근무조', size: 80, meta: center },
  { accessorKey: 'enterBy', header: '작성자', size: 100 },
  { accessorKey: 'receiptDate', header: '입고일시', size: 160, cell: (c) => ts(c.getValue()) },
];

// ───────────────────────────────── 307·308 출하

export interface FgIssueRow {
  issueDate: string | null;
  issueSequence: number | null;
  barcode: string;
  packType: string | null;
  txnDeficit: string | null;
  issueType: string | null;
  qty: number | null;
  modelName: string | null;
  modelSuffix: string | null;
  itemCode: string | null;
  customerCode: string | null;
  customerName: string | null;
  salesUnitPrice: number | null;
  currency: string | null;
  locationCode: string | null;
  palletNo: string | null;
  shipNo: string | null;
  shiftCode: string | null;
  enterBy: string | null;
  actualDate: string | null;
}

export interface FgIssueSummaryRow {
  customerCode: string;
  customerName: string | null;
  issueCount: number | null;
  qty: number | null;
}

export interface FgIssuableRow {
  barcode: string;
  packType: string | null;
  locationCode: string | null;
  qty: number | null;
  modelName: string | null;
  modelSuffix: string | null;
  itemCode: string | null;
  itemType: string | null;
  palletNo: string | null;
  palletFlag: string | null;
  receiptNo: string | null;
  enterBy: string | null;
  inventoryDate: string | null;
}

export const fgIssueColumns: ColumnDef<FgIssueRow>[] = [
  { accessorKey: 'barcode', header: '바코드', size: 220 },
  {
    accessorKey: 'txnDeficit',
    header: '구분',
    size: 90,
    meta: center,
    cell: (c) => txnCell(c.getValue()),
  },
  {
    accessorKey: 'qty',
    header: '수량',
    size: 90,
    meta: right,
    cell: (c) => signedQty(c.getValue()),
  },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'customerCode', header: '고객코드', size: 110 },
  { accessorKey: 'customerName', header: '고객명', size: 150 },
  { accessorKey: 'shipNo', header: '출하번호', size: 130 },
  { accessorKey: 'locationCode', header: '창고', size: 80, meta: center },
  { accessorKey: 'enterBy', header: '작성자', size: 100 },
  { accessorKey: 'issueDate', header: '출하일시', size: 160, cell: (c) => ts(c.getValue()) },
];

export const fgIssueSummaryColumns: ColumnDef<FgIssueSummaryRow>[] = [
  { accessorKey: 'customerCode', header: '고객코드', size: 130 },
  { accessorKey: 'customerName', header: '고객명', size: 200 },
  {
    accessorKey: 'issueCount',
    header: '건수',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'qty',
    header: '수량',
    size: 120,
    meta: right,
    cell: (c) => signedQty(c.getValue()),
  },
];

export const fgIssuableColumns: ColumnDef<FgIssuableRow>[] = [
  { accessorKey: 'barcode', header: '바코드', size: 220 },
  {
    accessorKey: 'qty',
    header: '수량',
    size: 90,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  { accessorKey: 'itemCode', header: '품목코드', size: 130 },
  { accessorKey: 'locationCode', header: '창고', size: 80, meta: center },
  { accessorKey: 'receiptNo', header: '입고번호', size: 130 },
  {
    accessorKey: 'inventoryDate',
    header: '재고일시',
    size: 160,
    cell: (c) => ts(c.getValue()),
  },
];
