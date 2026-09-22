import type { ColumnDef } from '@tanstack/react-table';
import { comCodeCell } from '@/components/shared/codeCells';
import { receiptKey, type ReceiptCancelMode, type ReceiptCancelRow } from './types';

const qty = (value: unknown) => value == null ? '' : Number(value).toLocaleString(undefined, { maximumFractionDigits: 6 });
const money = (value: unknown) => value == null ? '' : Number(value).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
const date = (value: unknown) => {
  if (!value) return '';
  const parsed = new Date(String(value));
  if (Number.isNaN(parsed.getTime())) return String(value);
  return parsed.toLocaleDateString('ko-KR').replace(/\.$/, '');
};
const dateTime = (value: unknown) => {
  if (!value) return '';
  const parsed = new Date(String(value));
  if (Number.isNaN(parsed.getTime())) return String(value);
  return parsed.toLocaleString('ko-KR', { hour12: false }).replace(/\.\s?$/, '');
};

interface CheckOptions {
  selected: Set<string>;
  toggle: (row: ReceiptCancelRow) => void;
}

/**
 * PB DataWindow 의 check_yn 컴퓨트 컬럼에 대응하는 선택 체크박스.
 * 이력 모드(rb_hst)에는 취소 기능이 없어 이 컬럼을 붙이지 않는다.
 */
function checkColumn({ selected, toggle }: CheckOptions): ColumnDef<ReceiptCancelRow> {
  return {
    id: 'check',
    header: '선택',
    size: 56,
    enableSorting: false,
    meta: { filterType: 'none' as const, align: 'center' as const },
    cell: ({ row }) => (
      <input
        type="checkbox"
        aria-label={`입고순번 ${row.original.receiptSequence} 선택`}
        className="h-4 w-4 accent-primary"
        checked={selected.has(receiptKey(row.original))}
        onChange={() => toggle(row.original)}
        onClick={(event) => event.stopPropagation()}
      />
    ),
  };
}

const baseColumns: ColumnDef<ReceiptCancelRow>[] = [
  { accessorKey: 'receiptDate', header: '입고일', size: 110, cell: ctx => date(ctx.getValue()) },
  { accessorKey: 'receiptSequence', header: '입고순번', size: 110, meta: { align: 'right' } },
  { accessorKey: 'receiptStatus', header: '입고상태', size: 90, cell: comCodeCell('RECEIPT STATUS') },
  { accessorKey: 'receiptType', header: '입고유형', size: 90, cell: comCodeCell('RECEIPT TYPE') },
  { accessorKey: 'locationCode', header: '로케이션', size: 110 },
  { accessorKey: 'lineType', header: '라인유형', size: 90, cell: comCodeCell('LINE TYPE') },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'materialMfs', header: '자재 MFS', size: 150 },
  { accessorKey: 'supplierCode', header: '공급업체코드', size: 120 },
  { accessorKey: 'supplierName', header: '공급업체명', size: 160 },
  { accessorKey: 'invoiceNo', header: 'Invoice No', size: 130 },
  { accessorKey: 'receiptQty', header: '입고수량', size: 110, meta: { align: 'right' }, cell: ctx => qty(ctx.getValue()) },
  { accessorKey: 'unitPrice', header: '단가', size: 110, meta: { align: 'right' }, cell: ctx => money(ctx.getValue()) },
  { accessorKey: 'receiptAmt', header: '입고금액', size: 130, meta: { align: 'right' }, cell: ctx => money(ctx.getValue()) },
  { accessorKey: 'currency', header: '통화', size: 70, cell: comCodeCell('CURRENCY') },
  { accessorKey: 'receiptLotNo', header: '입고 LOT', size: 130 },
  { accessorKey: 'orderNo', header: '발주번호', size: 130 },
  { accessorKey: 'interfaceYn', header: 'I/F', size: 60 },
  { accessorKey: 'comments', header: '비고', size: 160 },
  { accessorKey: 'enterBy', header: '등록자', size: 100 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: ctx => dateTime(ctx.getValue()) },
];

const barcodeColumns: ColumnDef<ReceiptCancelRow>[] = [
  { accessorKey: 'itemBarcode', header: '자재바코드', size: 160 },
  { accessorKey: 'scanQty', header: '스캔수량', size: 100, meta: { align: 'right' }, cell: ctx => qty(ctx.getValue()) },
];

export function buildReceiptCancelColumns(mode: ReceiptCancelMode, check: CheckOptions): ColumnDef<ReceiptCancelRow>[] {
  if (mode === 'HISTORY') return baseColumns;
  return [checkColumn(check), ...baseColumns, ...barcodeColumns];
}
