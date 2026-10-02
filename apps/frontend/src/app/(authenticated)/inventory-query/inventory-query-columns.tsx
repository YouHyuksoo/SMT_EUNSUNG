/**
 * @file src/app/(authenticated)/inventory-query/inventory-query-columns.tsx
 * @description 재고(M_INVENTORY) 4화면 행 타입 + 그리드 컬럼 — 269·271·272·274.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { num } from '@/components/shared/grid-format';
import { formatDisplayDate } from '@/utils/date';

const right = { align: 'right' } as const;
const center = { align: 'center' } as const;
const ts = (value: unknown) => (value ? formatDisplayDate(value) : '');

/** 재고가 있는 자리. 창고인지 라인인지. */
const DIV_LABEL: Record<string, string> = {
  WAREHOUSE: '자재창고',
  WORKSTAGE: '공정(라인)',
};

/** 차이 셀 — 0 이 아니면 눈에 띄어야 한다. */
const diffCell = (value: unknown) => {
  const v = Number(value ?? 0);
  if (v === 0) return num(0);
  return (
    <span className={v > 0 ? 'font-semibold text-emerald-500' : 'font-semibold text-red-500'}>
      {v > 0 ? `+${num(v)}` : num(v)}
    </span>
  );
};

/** 269 품목별 총재고 한 줄. */
export interface TotalInventoryRow {
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  itemType: string | null;
  itemClass: string | null;
  itemDivision: string | null;
  setItemYn: string | null;
  safetyInventory: number | null;
  buyPrice: number | null;
  inventoryQty: number | null;
  workstageQty: number | null;
  assemblyQty: number | null;
  productQty: number | null;
  totalQty: number | null;
}

/** 269 자리별 상세 한 줄. */
export interface InventoryByLocationRow {
  div: string | null;
  locationName: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  inventoryQty: number | null;
}

/** 269 롯트별 상세 한 줄. */
export interface InventoryByLotRow {
  div: string | null;
  locationName: string | null;
  locationCode: string | null;
  lotNo: string | null;
  inventoryQty: number | null;
}

/** 272 실사 한 줄. */
export interface InventoryCheckRow {
  closeYyyymm: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  lineType: string | null;
  lotNo: string | null;
  locationCode: string | null;
  inventoryHold: string | null;
  bookQty: number | null;
  checkQty: number | null;
  differenceQty: number | null;
  inventoryPrice: number | null;
  inventoryAmt: number | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 272 조정 이력 한 줄. */
export interface AdjustHistoryRow {
  issueDate: string | null;
  issueSequence: number | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  lotNo: string | null;
  locationCode: string | null;
  issueDeficit: string | null;
  issueQty: number | null;
  issuePrice: number | null;
  issueAmt: number | null;
  lineType: string | null;
  inventoryType: string | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 274 바코드 실사 한 줄. */
export interface BarcodeCheckRow {
  checkYyyymm: string | null;
  checkType: string | null;
  lineCode: string | null;
  itemBarcode: string | null;
  originItemBarcode: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  lotNo: string | null;
  barcodeQty: number | null;
  inventoryQty: number | null;
  differenceQty: number | null;
  labelType: string | null;
  locationCode: string | null;
  locationAddress: string | null;
  unitPrice: number | null;
  inventoryAmt: number | null;
  invoiceNo: string | null;
  customerCode: string | null;
  receiptLabelType: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 274 바코드 실사 요약 한 줄. */
export interface BarcodeCheckSummaryRow {
  checkYyyymm: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  barcodeCount: number | null;
  barcodeQty: number | null;
  inventoryQty: number | null;
  differenceQty: number | null;
  inventoryAmt: number | null;
}

export const totalInventoryColumns: ColumnDef<TotalInventoryRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  { accessorKey: 'itemClass', header: '품목분류', size: 100, meta: center },
  { accessorKey: 'itemDivision', header: '품목구분', size: 100, meta: center },
  {
    accessorKey: 'totalQty',
    header: '총재고',
    size: 120,
    meta: right,
    // 네 군데를 합친 값. 이 화면의 핵심이라 굵게 둔다.
    cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
  },
  { accessorKey: 'inventoryQty', header: '자재창고', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'workstageQty', header: '공정(라인)', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'assemblyQty', header: '조립품', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'productQty', header: '완제품', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'safetyInventory',
    header: '안전재고',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'setItemYn', header: '세트품', size: 80, meta: center },
  { accessorKey: 'buyPrice', header: '구매단가', size: 110, meta: right, cell: (c) => num(c.getValue()) },
];

export const inventoryByLocationColumns: ColumnDef<InventoryByLocationRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  {
    accessorKey: 'div',
    header: '구분',
    size: 110,
    meta: center,
    cell: (c) => DIV_LABEL[String(c.getValue() ?? '')] ?? String(c.getValue() ?? ''),
  },
  { accessorKey: 'locationName', header: '자리', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'inventoryQty', header: '수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
];

export const inventoryByLotColumns: ColumnDef<InventoryByLotRow>[] = [
  {
    accessorKey: 'div',
    header: '구분',
    size: 110,
    meta: center,
    cell: (c) => DIV_LABEL[String(c.getValue() ?? '')] ?? String(c.getValue() ?? ''),
  },
  { accessorKey: 'locationName', header: '자리', size: 180 },
  { accessorKey: 'locationCode', header: '코드', size: 100, meta: center },
  { accessorKey: 'lotNo', header: '롯트번호', size: 150 },
  { accessorKey: 'inventoryQty', header: '수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
];

export const inventoryCheckColumns: ColumnDef<InventoryCheckRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'closeYyyymm', header: '마감월', size: 100, meta: center },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  { accessorKey: 'locationCode', header: '창고', size: 80, meta: center },
  { accessorKey: 'bookQty', header: '장부수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'checkQty', header: '실사수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'differenceQty',
    header: '차이',
    size: 110,
    meta: right,
    cell: (c) => diffCell(c.getValue()),
  },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  { accessorKey: 'inventoryPrice', header: '재고단가', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inventoryHold', header: '보류', size: 80, meta: center },
  { accessorKey: 'comments', header: '비고', size: 180 },
  { accessorKey: 'enterBy', header: '등록자', size: 100 },
];

export const adjustHistoryColumns: ColumnDef<AdjustHistoryRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'issueDate', header: '조정일', size: 110, meta: center },
  { accessorKey: 'issueSequence', header: '순번', size: 100, meta: right },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  {
    accessorKey: 'issueQty',
    header: '조정수량',
    size: 110,
    meta: right,
    cell: (c) => diffCell(c.getValue()),
  },
  {
    accessorKey: 'issueDeficit',
    header: '구분',
    size: 100,
    meta: center,
    // 3 = 실제가 더 많음 · 4 = 실제가 적음
    cell: (c) => (String(c.getValue() ?? '') === '3' ? '실제 많음' : '실제 적음'),
  },
  { accessorKey: 'issuePrice', header: '단가', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'issueAmt', header: '금액', size: 120, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'locationCode', header: '창고', size: 80, meta: center },
  { accessorKey: 'comments', header: '비고', size: 180 },
  { accessorKey: 'enterBy', header: '처리자', size: 100 },
  { accessorKey: 'enterDate', header: '처리일시', size: 160, cell: (c) => ts(c.getValue()) },
];

export const barcodeCheckColumns: ColumnDef<BarcodeCheckRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'checkYyyymm', header: '실사월', size: 100, meta: center },
  { accessorKey: 'itemBarcode', header: '자재 바코드', size: 220 },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  { accessorKey: 'barcodeQty', header: '찍은 수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inventoryQty', header: '장부수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'differenceQty',
    header: '차이',
    size: 110,
    meta: right,
    cell: (c) => diffCell(c.getValue()),
  },
  { accessorKey: 'lineCode', header: '라인', size: 80, meta: center },
  { accessorKey: 'locationCode', header: '창고', size: 80, meta: center },
  { accessorKey: 'locationAddress', header: '창고번지', size: 110 },
  { accessorKey: 'labelType', header: '라벨유형', size: 90, meta: center },
  { accessorKey: 'unitPrice', header: '단가', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inventoryAmt', header: '금액', size: 120, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'enterBy', header: '처리자', size: 100 },
  { accessorKey: 'enterDate', header: '처리일시', size: 160, cell: (c) => ts(c.getValue()) },
];

export const barcodeCheckSummaryColumns: ColumnDef<BarcodeCheckSummaryRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'checkYyyymm', header: '실사월', size: 100, meta: center },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'barcodeCount', header: '바코드 수', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'barcodeQty', header: '찍은 수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inventoryQty', header: '장부수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'differenceQty',
    header: '차이',
    size: 110,
    meta: right,
    cell: (c) => diffCell(c.getValue()),
  },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  { accessorKey: 'inventoryAmt', header: '금액', size: 120, meta: right, cell: (c) => num(c.getValue()) },
];
