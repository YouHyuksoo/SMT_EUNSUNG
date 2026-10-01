/**
 * @file src/app/(authenticated)/warehouse/reprint-msl-columns.tsx
 * @description 241 자재바코드재발행 · 260 MSL 이상품목 · 239 IMD 라인 자재투입
 *              행 타입 + 그리드 컬럼.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, num } from '@/components/shared/grid-format';
import { formatDisplayDate } from '@/utils/date';

const right = { align: 'right' } as const;
const center = { align: 'center' } as const;
const ts = (value: unknown) => (value ? formatDisplayDate(value) : '');

/** 경과율 셀. 100% 를 넘으면 허용시간을 이미 지났다는 뜻이다. */
const rateCell = (value: unknown) => {
  const v = Number(value ?? 0);
  return (
    <span className={v >= 100 ? 'font-semibold text-red-500' : v >= 80 ? 'text-amber-500' : ''}>
      {num(v)}
    </span>
  );
};

/** 241 재발행 대상 한 줄. */
export interface ReprintRow {
  itemBarcode: string;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  lotNo: string | null;
  scanQty: number | null;
  newScanQty: number | null;
  lastScanQty: number | null;
  receiptSlipNo: string | null;
  supplierCode: string | null;
  supplierBarcode: string | null;
  receiptCompareYn: string | null;
  issueCompareYn: string | null;
  issueReturnYn: string | null;
  holdingYn: string | null;
  labelType: string | null;
  receiptType: string | null;
  inventoryType: string | null;
  lineCode: string | null;
  mslPassedTime: number | null;
  scanDate: string | null;
  issueReturnDate: string | null;
  enterBy: string | null;
}

/** 260 MSL 초과(재고) 한 줄. */
export interface MslInventoryRow {
  itemCode: string | null;
  itemName: string | null;
  partNo: string | null;
  lotNo: string | null;
  supplierCode: string | null;
  itemBarcode: string | null;
  scanQty: number | null;
  inventoryQty: number | null;
  mslLevel: string | null;
  mslMaxTime: number | null;
  prePassedTime: number | null;
  passedTime: number | null;
  passedRate: number | null;
  remainHour: number | null;
  bakingDate: string | null;
  locationRack: string | null;
  bakingEndDate: string | null;
}

/** 260 MSL 초과(투입) 한 줄. */
export interface MslIssuedRow {
  lotNo: string | null;
  itemBarcode: string | null;
  supplierCode: string | null;
  itemCode: string | null;
  itemName: string | null;
  partNo: string | null;
  newScanQty: number | null;
  scanQty: number | null;
  issueCompareDate: string | null;
  feedingDate: string | null;
  feedingModel: string | null;
  mslOpenDate: string | null;
  mslLevel: string | null;
  mslMaxTime: number | null;
  passedTime: number | null;
  remainTime: number | null;
  passedRate: number | null;
  prePassedTime: number | null;
  curPassedTime: number | null;
  lineName: string | null;
  workstageName: string | null;
  firstLineInputDate: string | null;
}

/** 260 MSL 현황 뷰 한 줄. */
export interface MslViewRow {
  lineCode: string | null;
  pcbItem: string | null;
  ccsYn: string | null;
  modelName: string | null;
  locationCode: string | null;
  itemBarcode: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  partNo: string | null;
  lotNo: string | null;
  scanQty: number | null;
  newScanQty: number | null;
  issueCompareYn: string | null;
  issueCompareDate: string | null;
  changeDate: string | null;
  mslLevel: string | null;
  mslMaxTime: number | null;
  passedHour: number | null;
  remainHour: number | null;
  prePassedTime: number | null;
  passedRate: number | null;
  bakingStartDate: string | null;
  bakingEndDate: string | null;
}

/** 260 처리이력 한 줄. */
export interface MslHistoryRow {
  scanDate: string | null;
  scanBy: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  mslLevel: string | null;
  itemBarcode: string | null;
  lotNo: string | null;
  lotQty: number | null;
  mslActionCode: string | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 239 수동 투입 이력 한 줄. */
export interface ManualInputRow {
  inputDate: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  workstageName: string | null;
  runNo: string | null;
  modelName: string | null;
  materialLot: string | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

export const reprintColumns: ColumnDef<ReprintRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 170 },
  { accessorKey: 'itemBarcode', header: '자재 바코드', size: 220 },
  { accessorKey: 'itemSpec', header: '규격', size: 150 },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  { accessorKey: 'scanQty', header: '수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'lastScanQty', header: '이전 수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'receiptSlipNo', header: '전표번호', size: 150 },
  { accessorKey: 'supplierBarcode', header: '협력사 바코드', size: 180 },
  { accessorKey: 'receiptCompareYn', header: '입고대조', size: 90, meta: center },
  { accessorKey: 'issueCompareYn', header: '출고대조', size: 90, meta: center },
  { accessorKey: 'issueReturnYn', header: '반품', size: 80, meta: center },
  { accessorKey: 'holdingYn', header: '보류', size: 80, meta: center },
  { accessorKey: 'labelType', header: '라벨유형', size: 90, meta: center },
  { accessorKey: 'lineCode', header: '라인', size: 80, meta: center },
  { accessorKey: 'scanDate', header: '발행시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'enterBy', header: '발행자', size: 100 },
];

export const mslInventoryColumns: ColumnDef<MslInventoryRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 170 },
  { accessorKey: 'partNo', header: '품번', size: 140 },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  { accessorKey: 'itemBarcode', header: '자재 바코드', size: 220 },
  { accessorKey: 'scanQty', header: '릴 수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inventoryQty', header: '재고수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'mslLevel', header: 'MSL', size: 70, meta: center },
  { accessorKey: 'mslMaxTime', header: '허용시간', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'passedTime', header: '경과시간', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'passedRate', header: '경과율(%)', size: 110, meta: right, cell: (c) => rateCell(c.getValue()) },
  { accessorKey: 'remainHour', header: '남은시간', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'prePassedTime', header: '이전 경과', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'bakingDate', header: '베이킹일', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'bakingEndDate', header: '베이킹 종료', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'locationRack', header: '창고 랙', size: 110 },
  { accessorKey: 'supplierCode', header: '협력사', size: 110 },
];

export const mslIssuedColumns: ColumnDef<MslIssuedRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 170 },
  { accessorKey: 'partNo', header: '품번', size: 140 },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  { accessorKey: 'itemBarcode', header: '자재 바코드', size: 220 },
  { accessorKey: 'scanQty', header: '릴 수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'mslLevel', header: 'MSL', size: 70, meta: center },
  { accessorKey: 'mslMaxTime', header: '허용시간', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'passedTime', header: '경과시간', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'passedRate', header: '경과율(%)', size: 110, meta: right, cell: (c) => rateCell(c.getValue()) },
  { accessorKey: 'remainTime', header: '남은시간', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'curPassedTime', header: '개봉 후(h)', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'mslOpenDate', header: '개봉시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'lineName', header: '라인', size: 150 },
  { accessorKey: 'workstageName', header: '공정', size: 130 },
  { accessorKey: 'feedingModel', header: '투입 모델', size: 150 },
  { accessorKey: 'issueCompareDate', header: '출고시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'firstLineInputDate', header: '최초 라인투입', size: 160, cell: (c) => ts(c.getValue()) },
];

export const mslViewColumns: ColumnDef<MslViewRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 170 },
  { accessorKey: 'lineCode', header: '라인', size: 80, meta: center },
  { accessorKey: 'modelName', header: '모델명', size: 160 },
  { accessorKey: 'locationCode', header: '피더 위치', size: 110 },
  { accessorKey: 'partNo', header: '품번', size: 140 },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  { accessorKey: 'itemBarcode', header: '자재 바코드', size: 220 },
  { accessorKey: 'scanQty', header: '수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'mslLevel', header: 'MSL', size: 70, meta: center },
  { accessorKey: 'mslMaxTime', header: '허용시간', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'passedHour', header: '경과시간', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'passedRate', header: '경과율(%)', size: 110, meta: right, cell: (c) => rateCell(c.getValue()) },
  { accessorKey: 'remainHour', header: '남은시간', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'issueCompareYn', header: '출고됨', size: 90, meta: center },
  { accessorKey: 'pcbItem', header: 'PCB', size: 80, meta: center },
  { accessorKey: 'ccsYn', header: 'CCS', size: 80, meta: center },
  { accessorKey: 'bakingStartDate', header: '베이킹 시작', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'bakingEndDate', header: '베이킹 종료', size: 160, cell: (c) => ts(c.getValue()) },
];

export const mslHistoryColumns: ColumnDef<MslHistoryRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 170 },
  { accessorKey: 'scanDate', header: '처리시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'scanBy', header: '처리자', size: 100 },
  { accessorKey: 'mslLevel', header: 'MSL', size: 70, meta: center },
  { accessorKey: 'itemBarcode', header: '자재 바코드', size: 220 },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  { accessorKey: 'lotQty', header: '수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'mslActionCode', header: '처리코드', size: 110, meta: center },
  { accessorKey: 'comments', header: '비고', size: 220 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

export const manualInputColumns: ColumnDef<ManualInputRow>[] = [
  { accessorKey: 'inputDate', header: '투입일시', size: 160, cell: (c) => ts(c.getValue()) },
  {
    id: 'lineName',
    header: '라인',
    size: 150,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  {
    id: 'workstageName',
    header: '공정',
    size: 140,
    accessorFn: (r) => codeWithName(r.workstageCode, r.workstageName),
  },
  { accessorKey: 'runNo', header: '런번호', size: 140 },
  { accessorKey: 'modelName', header: '모델명', size: 160 },
  { accessorKey: 'materialLot', header: '자재 롯트', size: 140 },
  { accessorKey: 'comments', header: '비고', size: 220 },
  { accessorKey: 'enterBy', header: '등록자', size: 100 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];
