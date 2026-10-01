/**
 * @file src/app/(authenticated)/warehouse/solder-label-columns.tsx
 * @description 243 솔더라벨 발행 행 타입 + 그리드 컬럼.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, num } from '@/components/shared/grid-format';
import { formatDisplayDate } from '@/utils/date';

const right = { align: 'right' } as const;
const center = { align: 'center' } as const;
const ts = (value: unknown) => (value ? formatDisplayDate(value) : '');
const solderTypeLabel = (value: unknown) => {
  const v = String(value ?? '');
  if (v === 'F') return '무연(F)';
  if (v === 'P') return '유연(P)';
  return v;
};

/** 243 솔더 전표 한 줄. */
export interface SolderSlipRow {
  receiptSlipNo: string;
  receiptDate: string | null;
  receiptSequence: number | null;
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  solderType: string | null;
  reelQty: number | null;
  receiptUnitQty: number | null;
  receiptSumQty: number | null;
  receiptBarcode: string | null;
  receiptType: string | null;
  receiptStatus: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  fromSupplierCode: string | null;
  ecoItemYn: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 243 발행된 라벨 한 줄. */
export interface SolderLabelRow {
  itemBarcode: string;
  lotNo: string | null;
  originLotNo: string | null;
  scanQty: number | null;
  scanDate: string | null;
  validDate: string | null;
  itemCode: string | null;
  receiptSlipNo: string | null;
  receiptType: string | null;
  barcodeStatus: string | null;
  receiptCompareYn: string | null;
  holdingYn: string | null;
  labelType: string | null;
  supplierCode: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 243 발행 전 확인 결과. */
export interface SolderIssueContext {
  item: {
    itemCode?: string | null;
    itemName?: string | null;
    itemSpec?: string | null;
    itemClass?: string | null;
    solderType?: string | null;
  } | null;
  /** 바코드 앞 1자 (무연 F 는 S 로 바뀐다). 비면 발행할 수 없다. */
  solderTypeCode: string;
  factory: string;
  /** 그날 이미 찍힌 마지막 일련번호. */
  lastSequence: number;
  /** 오늘 YYMMDD. */
  dateYymmdd: string;
}

/** 243 발행 결과. */
export interface SolderIssueResult {
  slipNo: string;
  itemCode: string;
  solderTypeCode: string;
  factory: string;
  dateYymmdd: string;
  datePrefix: string;
  issued: number;
  totalQty: number;
  slipRows: number;
  barcodeRows: number;
  firstBarcode: string | null;
  lastBarcode: string | null;
}

export const solderSlipColumns: ColumnDef<SolderSlipRow>[] = [
  { accessorKey: 'receiptSlipNo', header: '전표번호', size: 150 },
  { accessorKey: 'receiptDate', header: '전표일', size: 110, meta: center },
  { accessorKey: 'itemCode', header: '품목코드', size: 130 },
  { accessorKey: 'itemName', header: '품목명', size: 170 },
  { accessorKey: 'itemSpec', header: '규격', size: 150 },
  {
    accessorKey: 'solderType',
    header: '솔더 종류',
    size: 110,
    meta: center,
    cell: (c) => solderTypeLabel(c.getValue()),
  },
  { accessorKey: 'reelQty', header: '라벨 장수', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'receiptUnitQty', header: '한 통 수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'receiptSumQty',
    header: '총수량',
    size: 110,
    meta: right,
    cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
  },
  {
    id: 'supplierName',
    header: '협력사',
    size: 170,
    accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName),
  },
  { accessorKey: 'receiptBarcode', header: '협력사 바코드', size: 180 },
  { accessorKey: 'receiptType', header: '입고유형', size: 90, meta: center },
  { accessorKey: 'receiptStatus', header: '상태', size: 80, meta: center },
  { accessorKey: 'enterBy', header: '발행자', size: 100 },
  { accessorKey: 'enterDate', header: '발행일시', size: 160, cell: (c) => ts(c.getValue()) },
];

export const solderLabelColumns: ColumnDef<SolderLabelRow>[] = [
  { accessorKey: 'itemBarcode', header: '라벨 바코드', size: 150 },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  { accessorKey: 'scanQty', header: '수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'validDate', header: '유효기한', size: 110, meta: center },
  {
    accessorKey: 'receiptCompareYn',
    header: '입고대조',
    size: 100,
    meta: center,
    // 대조 전 라벨은 아직 재고가 아니다 (입고는 237 대조 때 생긴다).
    cell: (c) => (String(c.getValue() ?? '') === 'Y'
      ? <span className="text-text-muted">완료</span>
      : <span className="font-semibold text-amber-500">대기</span>),
  },
  { accessorKey: 'barcodeStatus', header: '바코드상태', size: 100, meta: center },
  { accessorKey: 'holdingYn', header: '보류', size: 80, meta: center },
  { accessorKey: 'labelType', header: '라벨유형', size: 90, meta: center },
  { accessorKey: 'originLotNo', header: '원본 롯트', size: 130 },
  { accessorKey: 'supplierCode', header: '협력사', size: 110 },
  { accessorKey: 'scanDate', header: '발행시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'enterBy', header: '발행자', size: 100 },
];
