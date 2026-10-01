/**
 * @file src/app/(authenticated)/warehouse/receipt-manage-columns.tsx
 * @description 253 자재입고관리 · 254 자재기타입고관리 행 타입 + 그리드 컬럼.
 *
 * 이 화면에서 가장 헷갈리는 것은 **수량 부호**다. 기타입고는 음수면 차감이라
 * 같은 표에 더하는 건과 빼는 건이 섞여 있다. 그래서 수량과 구분을 붙여 보여준다.
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
/** 입고/차감 구분. PB 는 수량 부호로 이 값을 정한다. */
const deficitLabel = (value: unknown) => {
  const v = Number(value ?? 0);
  if (v === 1) return '입고';
  if (v === 2) return '차감';
  return String(value ?? '');
};

/** 253·254 입고 원장 한 줄. */
export interface ReceiptRow {
  receiptDate: string | null;
  receiptSequence: number | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  receiptQty: number | null;
  receiptDeficit: number | null;
  unitPrice: number | null;
  receiptAmt: number | null;
  currency: string | null;
  exchangeRate: number | null;
  invoiceNo: string | null;
  receiptLotNo: string | null;
  locationCode: string | null;
  materialMfs: string | null;
  mfs: string | null;
  /** 바코드로 만들어진 입고는 이 값이 있다 — 그런 행은 고칠 수 없다. */
  barcode: string | null;
  lineType: string | null;
  receiptType: string | null;
  receiptStatus: string | null;
  delivery: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  originSupplierCode: string | null;
  orderNo: string | null;
  orderType: string | null;
  incidentalExpenseCode: string | null;
  tariffRate: number | null;
  tariffAmt: number | null;
  confirmYn: string | null;
  interfaceYn: string | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 254 현재고 한 줄. 여기서 골라 기타입고를 만든다. */
export interface ReceiptInventoryRow {
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemType: string | null;
  itemUom: string | null;
  locationAddress: string | null;
  lineType: string | null;
  supplierCode: string | null;
  inventoryQty: number | null;
  inventoryPrice: number | null;
  inventoryAmt: number | null;
  inventoryStatus: string | null;
  inventoryHold: string | null;
  locationCode: string | null;
  materialMfs: string | null;
  comments: string | null;
}

/** 253 입고예정 한 줄. 이 현장에서는 항상 비어 있다. */
export interface ArrivalRow {
  arrivalDate: string | null;
  arrivalSeqNo: number | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  arrivalQty: number | null;
  arrivalStatus: string | null;
  arrivalType: string | null;
  unitPrice: number | null;
  arrivalAmt: number | null;
  receiptDate: string | null;
  receiptSequence: number | null;
  supplierCode: string | null;
  supplierName: string | null;
  invoiceNo: string | null;
  materialMfs: string | null;
  lineType: string | null;
  orderNo: string | null;
  inspectResult: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

export const receiptColumns: ColumnDef<ReceiptRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'receiptDate', header: '입고일', size: 110, meta: center },
  { accessorKey: 'receiptSequence', header: '입고순번', size: 110, meta: right },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  {
    accessorKey: 'receiptQty',
    header: '수량',
    size: 110,
    meta: right,
    // 차감(음수)이 눈에 띄어야 한다 — 같은 표에 더하는 건과 빼는 건이 섞여 있다.
    cell: (c) => {
      const v = Number(c.getValue() ?? 0);
      return <span className={v < 0 ? 'font-semibold text-red-500' : ''}>{num(v)}</span>;
    },
  },
  {
    accessorKey: 'receiptDeficit',
    header: '구분',
    size: 80,
    meta: center,
    cell: (c) => deficitLabel(c.getValue()),
  },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  { accessorKey: 'unitPrice', header: '단가', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'receiptAmt', header: '입고금액', size: 120, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'currency', header: '통화', size: 80, meta: center },
  { accessorKey: 'invoiceNo', header: '전표번호', size: 150 },
  { accessorKey: 'receiptLotNo', header: '입고 롯트번호', size: 130 },
  { accessorKey: 'locationCode', header: '창고', size: 80, meta: center },
  { accessorKey: 'materialMfs', header: '자재 롯트', size: 130 },
  { accessorKey: 'mfs', header: '협력사 롯트', size: 130 },
  {
    accessorKey: 'barcode',
    header: '바코드',
    size: 200,
    // 값이 있으면 바코드로 만들어진 입고다 — 이 화면에서 고칠 수 없다.
    cell: (c) => (c.getValue()
      ? <span className="text-text-muted">{String(c.getValue())}</span>
      : ''),
  },
  { accessorKey: 'receiptType', header: '입고유형', size: 90, meta: center },
  { accessorKey: 'lineType', header: '구매유형', size: 90, meta: center },
  {
    id: 'supplierName',
    header: '협력사',
    size: 170,
    accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName),
  },
  { accessorKey: 'receiptStatus', header: '상태', size: 80, meta: center },
  { accessorKey: 'confirmYn', header: '확정', size: 70, meta: center, cell: (c) => yesNo(c.getValue()) },
  { accessorKey: 'interfaceYn', header: '전송', size: 70, meta: center, cell: (c) => yesNo(c.getValue()) },
  { accessorKey: 'comments', header: '비고', size: 160 },
  { accessorKey: 'enterBy', header: '등록자', size: 100 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

export const receiptInventoryColumns: ColumnDef<ReceiptInventoryRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'inventoryQty', header: '재고수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  { accessorKey: 'inventoryPrice', header: '재고단가', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inventoryAmt', header: '재고금액', size: 120, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'locationCode', header: '창고', size: 80, meta: center },
  { accessorKey: 'locationAddress', header: '창고번지', size: 110 },
  { accessorKey: 'materialMfs', header: '자재 롯트', size: 130 },
  { accessorKey: 'lineType', header: '구매유형', size: 90, meta: center },
  { accessorKey: 'supplierCode', header: '협력사', size: 110 },
  { accessorKey: 'inventoryStatus', header: '재고상태', size: 100, meta: center },
  { accessorKey: 'inventoryHold', header: '보류', size: 80, meta: center },
  { accessorKey: 'comments', header: '비고', size: 150 },
];

export const arrivalColumns: ColumnDef<ArrivalRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'arrivalDate', header: '입고예정일', size: 120, meta: center },
  { accessorKey: 'arrivalSeqNo', header: '순번', size: 90, meta: right },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'arrivalQty', header: '예정수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'arrivalStatus', header: '상태', size: 90, meta: center },
  { accessorKey: 'arrivalType', header: '유형', size: 80, meta: center },
  { accessorKey: 'unitPrice', header: '단가', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'arrivalAmt', header: '금액', size: 120, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'receiptDate', header: '입고일', size: 110, meta: center },
  { accessorKey: 'receiptSequence', header: '입고순번', size: 110, meta: right },
  {
    id: 'supplierName',
    header: '협력사',
    size: 170,
    accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName),
  },
  { accessorKey: 'invoiceNo', header: '전표번호', size: 150 },
  { accessorKey: 'materialMfs', header: '자재 롯트', size: 130 },
  { accessorKey: 'inspectResult', header: '검사결과', size: 100, meta: center },
  { accessorKey: 'enterBy', header: '등록자', size: 100 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];
