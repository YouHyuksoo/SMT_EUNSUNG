/**
 * @file src/app/(authenticated)/warehouse/barcode-issue-columns.tsx
 * @description 238 자재바코드출고관리 행 타입 + 그리드 컬럼.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, num } from '@/components/shared/grid-format';
import { formatDisplayDate } from '@/utils/date';

const right = { align: 'right' } as const;
const center = { align: 'center' } as const;
const ts = (value: unknown) => (value ? formatDisplayDate(value) : '');

/** 238 출고 한 줄. */
export interface BarcodeIssueRow {
  issueDate: string | null;
  issueSequence: number | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  issueQty: number | null;
  lotNo: string | null;
  barcode: string | null;
  supplierBarcode: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  feederLocationCode: string | null;
  issueDivision: string | null;
  modelName: string | null;
  inventoryType: string | null;
  mslPassedTime: number | null;
  locationCode: string | null;
  mfs: string | null;
  receiptSlipNo: string | null;
  supplierCode: string | null;
  lineType: string | null;
  issueStatus: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 238 출고 대기 바코드 한 줄. */
export interface IssueWaitingRow {
  itemBarcode: string;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemClass: string | null;
  mslLevel: string | null;
  moqQty: number | null;
  lotNo: string | null;
  currentQty: number | null;
  scanQty: number | null;
  receiptSlipNo: string | null;
  supplierCode: string | null;
  inventoryType: string | null;
  labelType: string | null;
  manufactureWeek: string | null;
  manufactureDate: string | null;
  receiptCompareDate: string | null;
  holdingYn: string | null;
  lineCode: string | null;
  workstageCode: string | null;
  /** 베이킹 중이면 꺼낼 수 없다. */
  bakingYn: string | null;
  scanDate: string | null;
}

/** 238 키팅 BOM 한 줄. */
export interface KittingBomRow {
  modelName: string | null;
  parentItemCode: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemClass: string | null;
  bomQty: number | null;
  lineCode: string | null;
  workstageCode: string | null;
  feederLocationCode: string | null;
  locationInfo: string | null;
  feederShaft: string | null;
  pcbItem: string | null;
  markingNo: string | null;
  bomVersion: string | null;
  replaceItems: string | null;
}

/** 238 FIFO 위반 후보 한 줄 — 이 릴을 먼저 써야 한다. */
export interface FifoCandidateRow {
  itemBarcode: string;
  lotNo: string | null;
  scanQty: number | null;
  manufactureWeek: string | null;
  manufactureDate: string | null;
  receiptCompareDate: string | null;
  inventoryType: string | null;
  labelType: string | null;
  inventoryQty: number | null;
  locationCode: string | null;
}

/** 238 검사 한 건. */
export interface ScanCheck {
  key: string;
  label: string;
  result: 'pass' | 'reject' | 'warn' | 'skip';
  detail?: string;
}

/** 238 스캔 판정 결과. */
export interface BarcodeIssueScanResult {
  barcode: string;
  itemCode: string | null;
  lotNo: string | null;
  issuable: boolean;
  reason: string | null;
  fifoCount?: number;
  checks: ScanCheck[];
  item: {
    itemName?: string | null;
    itemSpec?: string | null;
    itemClass?: string | null;
    mslLevel?: string | null;
    moqQty?: number | null;
  } | null;
  barcodeRow: {
    issueQty?: number | null;
    receiptSlipNo?: string | null;
    inventoryType?: string | null;
    manufactureWeek?: string | null;
    manufactureDate?: string | null;
    mslPassedTime?: number | null;
    mslMaxTime?: number | null;
  } | null;
}

export const barcodeIssueColumns: ColumnDef<BarcodeIssueRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 170 },
  { accessorKey: 'issueDate', header: '출고일', size: 110, meta: center },
  { accessorKey: 'issueSequence', header: '순번', size: 100, meta: right },
  { accessorKey: 'itemSpec', header: '규격', size: 150 },
  { accessorKey: 'issueQty', header: '출고수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  { accessorKey: 'barcode', header: '자재 바코드', size: 220 },
  {
    id: 'lineName',
    header: '라인',
    size: 150,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'workstageCode', header: '공정', size: 90, meta: center },
  { accessorKey: 'feederLocationCode', header: '피더 위치', size: 110 },
  { accessorKey: 'modelName', header: '모델명', size: 150 },
  {
    accessorKey: 'issueDivision',
    header: '출고구분',
    size: 90,
    meta: center,
    // 'K' = 키팅 출고 (PB rb_kitting)
    cell: (c) => (String(c.getValue() ?? '') === 'K' ? '키팅' : String(c.getValue() ?? '')),
  },
  { accessorKey: 'mslPassedTime', header: 'MSL 경과', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inventoryType', header: '재고유형', size: 100, meta: center },
  { accessorKey: 'receiptSlipNo', header: '전표번호', size: 150 },
  { accessorKey: 'supplierCode', header: '협력사', size: 110 },
  { accessorKey: 'enterBy', header: '처리자', size: 100 },
  { accessorKey: 'enterDate', header: '처리일시', size: 160, cell: (c) => ts(c.getValue()) },
];

export const issueWaitingColumns: ColumnDef<IssueWaitingRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 170 },
  { accessorKey: 'itemBarcode', header: '자재 바코드', size: 220 },
  { accessorKey: 'itemSpec', header: '규격', size: 150 },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  { accessorKey: 'currentQty', header: '수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'moqQty', header: 'MOQ', size: 90, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'mslLevel', header: 'MSL', size: 70, meta: center },
  { accessorKey: 'itemClass', header: '품목분류', size: 100, meta: center },
  { accessorKey: 'manufactureDate', header: '제조일', size: 110, meta: center },
  { accessorKey: 'manufactureWeek', header: '제조주차', size: 100, meta: center },
  { accessorKey: 'receiptCompareDate', header: '입고대조일', size: 120, meta: center },
  {
    accessorKey: 'bakingYn',
    header: '베이킹 중',
    size: 100,
    meta: center,
    // 베이킹 중이면 꺼낼 수 없다 — FIFO 순서도 이 릴을 건너뛴다.
    cell: (c) => (String(c.getValue() ?? '') === 'Y'
      ? <span className="font-semibold text-amber-500">예</span>
      : ''),
  },
  { accessorKey: 'inventoryType', header: '재고유형', size: 100, meta: center },
  { accessorKey: 'receiptSlipNo', header: '전표번호', size: 150 },
  { accessorKey: 'scanDate', header: '발행시각', size: 160, cell: (c) => ts(c.getValue()) },
];

export const kittingBomColumns: ColumnDef<KittingBomRow>[] = [
  { accessorKey: 'itemCode', header: '자재코드', size: 140 },
  { accessorKey: 'itemName', header: '자재명', size: 170 },
  { accessorKey: 'workstageCode', header: '공정', size: 90, meta: center },
  { accessorKey: 'feederLocationCode', header: '피더 위치', size: 110 },
  { accessorKey: 'feederShaft', header: '피더 축', size: 90, meta: center },
  { accessorKey: 'itemSpec', header: '규격', size: 150 },
  { accessorKey: 'bomQty', header: '소요량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'locationInfo', header: '회로 기호', size: 180 },
  {
    accessorKey: 'replaceItems',
    header: '대체품',
    size: 200,
    // 대체품으로 찍어도 통과한다.
    cell: (c) => (c.getValue()
      ? <span className="text-emerald-500">{String(c.getValue())}</span>
      : ''),
  },
  { accessorKey: 'lineCode', header: '라인', size: 80, meta: center },
  { accessorKey: 'markingNo', header: '마킹번호', size: 110 },
  { accessorKey: 'bomVersion', header: '판번', size: 80, meta: center },
];

export const fifoCandidateColumns: ColumnDef<FifoCandidateRow>[] = [
  { accessorKey: 'itemBarcode', header: '먼저 써야 할 바코드', size: 230 },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  { accessorKey: 'scanQty', header: '릴 수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inventoryQty', header: '재고수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'manufactureDate', header: '제조일', size: 110, meta: center },
  { accessorKey: 'manufactureWeek', header: '제조주차', size: 100, meta: center },
  { accessorKey: 'receiptCompareDate', header: '입고대조일', size: 120, meta: center },
  { accessorKey: 'locationCode', header: '창고', size: 80, meta: center },
];
