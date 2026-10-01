/**
 * @file src/app/(authenticated)/warehouse/divide-baking-columns.tsx
 * @description 240 자재분할관리 · 261 베이킹이력관리 행 타입 + 그리드 컬럼.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { num } from '@/components/shared/grid-format';
import { formatDisplayDate } from '@/utils/date';

const right = { align: 'right' } as const;
const center = { align: 'center' } as const;
const ts = (value: unknown) => (value ? formatDisplayDate(value) : '');

/** 챔버 종류 이름. 세 화면(240·261·262~264)이 같은 값을 쓴다. */
export const CHAMBER_LABEL: Record<string, string> = {
  B: '베이킹실',
  V: '진공포장',
  D: '제습함',
};

/** 240 분할된 바코드 한 줄. */
export interface DividedRow {
  itemBarcode: string;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  lotNo: string | null;
  originLotNo: string | null;
  originItemBarcode: string | null;
  scanQty: number | null;
  newScanQty: number | null;
  lotDivideSequence: number | null;
  lotDivideDate: string | null;
  divideReason: string | null;
  receiptSlipNo: string | null;
  supplierCode: string | null;
  inventoryType: string | null;
  labelType: string | null;
  issueCompareYn: string | null;
  holdingYn: string | null;
  lineCode: string | null;
  feedingModel: string | null;
  mslPassedTime: number | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 240 나눌 릴을 풀어 본 결과. */
export interface DivideLookup {
  barcode: string;
  itemCode: string | null;
  lotNo: string | null;
  dividable: boolean;
  reason: string | null;
  barcodeRow: {
    itemName?: string | null;
    itemSpec?: string | null;
    currentQty?: number | null;
    scanQty?: number | null;
    newScanQty?: number | null;
    receiptSlipNo?: string | null;
    holdingYn?: string | null;
    reelDestroyYn?: string | null;
    inventoryType?: string | null;
    mslPassedTime?: number | null;
  } | null;
}

/** 240 분할 결과. */
export interface DivideResult {
  barcode: string;
  itemCode: string;
  lotNo: string;
  originQty: number;
  divideSequence: number;
  pieceCount: number;
  totalQty: number;
  created: { lotNo: string; itemBarcode: string; qty: number }[];
  originalPiece: number;
  originalBarcode: string;
}

/** 261 챔버 입출고 이력 한 줄. */
export interface BakingHistoryRow {
  chamberType: string | null;
  chamberCode: string | null;
  chamberLocation: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  mslLevel: string | null;
  itemBarcode: string | null;
  lotNo: string | null;
  lotQty: number | null;
  inputScanDate: string | null;
  outputScanDate: string | null;
  stayHours: number | null;
  inChamberYn: string | null;
  scanBy: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 261 찍은 바코드를 풀어 본 결과. */
export interface BakingLookup {
  barcode: string;
  itemCode: string | null;
  lotNo: string | null;
  chamberType: string;
  openCount: number;
  canInput: boolean;
  canOutput: boolean;
  inputReason: string | null;
  outputReason: string | null;
  barcodeRow: {
    itemName?: string | null;
    itemSpec?: string | null;
    mslLevel?: string | null;
    lotQty?: number | null;
    mslPassedTime?: number | null;
    mslRemainTime?: number | null;
    mslOpenDate?: string | null;
  } | null;
}

export const dividedColumns: ColumnDef<DividedRow>[] = [
  { accessorKey: 'lotDivideDate', header: '분할시각', size: 160, cell: (c) => ts(c.getValue()) },
  {
    accessorKey: 'lotDivideSequence',
    header: '분할 묶음',
    size: 110,
    meta: right,
    // 같은 값끼리 한 번의 분할이다.
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'itemBarcode', header: '자재 바코드', size: 220 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 170 },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  { accessorKey: 'originLotNo', header: '원본 롯트', size: 130 },
  { accessorKey: 'scanQty', header: '수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'divideReason', header: '분할사유', size: 150 },
  { accessorKey: 'originItemBarcode', header: '원본 바코드', size: 220 },
  { accessorKey: 'receiptSlipNo', header: '전표번호', size: 150 },
  { accessorKey: 'supplierCode', header: '협력사', size: 110 },
  { accessorKey: 'issueCompareYn', header: '출고됨', size: 90, meta: center },
  { accessorKey: 'holdingYn', header: '보류', size: 80, meta: center },
  { accessorKey: 'inventoryType', header: '재고유형', size: 100, meta: center },
  { accessorKey: 'mslPassedTime', header: 'MSL 경과', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'enterBy', header: '처리자', size: 100 },
];

export const bakingHistoryColumns: ColumnDef<BakingHistoryRow>[] = [
  {
    accessorKey: 'chamberType',
    header: '챔버 종류',
    size: 110,
    meta: center,
    cell: (c) => CHAMBER_LABEL[String(c.getValue() ?? '')] ?? String(c.getValue() ?? ''),
  },
  { accessorKey: 'chamberCode', header: '챔버 번호', size: 110, meta: center },
  { accessorKey: 'chamberLocation', header: '자리', size: 90, meta: center },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 170 },
  { accessorKey: 'itemSpec', header: '규격', size: 150 },
  { accessorKey: 'mslLevel', header: 'MSL', size: 70, meta: center },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  { accessorKey: 'lotQty', header: '수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inputScanDate', header: '넣은 시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'outputScanDate', header: '꺼낸 시각', size: 160, cell: (c) => ts(c.getValue()) },
  {
    accessorKey: 'stayHours',
    header: '머문 시간(h)',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'inChamberYn',
    header: '안에 있음',
    size: 100,
    meta: center,
    // 아직 꺼내지 않은 것 — 262·263·264 화면이 보는 것과 같은 상태다.
    cell: (c) => (String(c.getValue() ?? '') === 'Y'
      ? <span className="font-semibold text-amber-500">예</span>
      : ''),
  },
  { accessorKey: 'itemBarcode', header: '자재 바코드', size: 220 },
  { accessorKey: 'scanBy', header: '처리자', size: 100 },
];
