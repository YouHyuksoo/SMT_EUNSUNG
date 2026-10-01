/**
 * @file src/app/(authenticated)/process-transaction/magazine-columns.tsx
 * @description 매거진 3화면 행 타입 + 그리드 컬럼 — 229 발행 · 230 분할 · 231 PID 매핑.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { num } from '@/components/shared/grid-format';
import { formatDisplayDate } from '@/utils/date';

const right = { align: 'right' } as const;
const center = { align: 'center' } as const;
const ts = (value: unknown) => (value ? formatDisplayDate(value) : '');

/** `MAGAZINE_LABEL_TYPE` 을 사람이 읽는 말로. 현장은 사실상 P 만 쓴다. */
export const LABEL_TYPE_NAME: Record<string, string> = {
  P: '정상',
  B: '불량',
  R: '수리',
  D: '폐기',
};

const labelTypeCell = (value: unknown) => {
  const code = String(value ?? '');
  const name = LABEL_TYPE_NAME[code] ?? code;
  const tone = code === 'P'
    ? 'text-text'
    : code === 'B'
      ? 'text-red-500'
      : code === 'D'
        ? 'text-text-muted line-through'
        : 'text-amber-500';
  return <span className={`font-medium ${tone}`}>{name}</span>;
};

// ───────────────────────────────── 229 발행

/** 발행 대상 모델 한 줄 — 사용자가 수량·장수를 고쳐 넣는다. */
export interface MagazinePlanRow {
  modelName: string;
  modelSuffix: string | null;
  itemCode: string | null;
  /** 런카드 지시수량. */
  lotQty: number;
  /** 이 런카드로 이미 발행된 수량. */
  magazineQty: number;
  /** 이번에 발행할 정상 수량 (지시 − 발행된). */
  okQty: number;
  /** 상자 하나에 담는 수량. */
  packingPcsQty: number;
  /** 발행할 라벨 장수. */
  printQty: number;
}

/** 발행된 라벨 한 줄. */
export interface MagazineIssuedRow {
  magazineLabelNo: string;
  magazineLabelType: string | null;
  runNo: string | null;
  itemCode: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  workstageName: string | null;
  pcbItem: string | null;
  lotQty: number | null;
  badQty: number | null;
  destroyQty: number | null;
  magazineSetNo: string | null;
  receiptSequence: number | null;
  receiptStatus: string | null;
  transferMagazineLabelNo: string | null;
  enterBy: string | null;
  receiptDate: string | null;
}

export const magazinePlanColumns: ColumnDef<MagazinePlanRow>[] = [
  { accessorKey: 'modelName', header: '모델', size: 160 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  { accessorKey: 'itemCode', header: '품목코드', size: 130 },
  {
    accessorKey: 'lotQty',
    header: '지시수량',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'magazineQty',
    header: '이미 발행',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'okQty',
    header: '발행 가능',
    size: 100,
    meta: right,
    cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
  },
  {
    accessorKey: 'packingPcsQty',
    header: '장입수량',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
];

export const magazineIssuedColumns: ColumnDef<MagazineIssuedRow>[] = [
  { accessorKey: 'magazineLabelNo', header: '매거진라벨', size: 130 },
  {
    accessorKey: 'magazineLabelType',
    header: '구분',
    size: 70,
    meta: center,
    cell: (c) => labelTypeCell(c.getValue()),
  },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  {
    accessorKey: 'lotQty',
    header: '수량',
    size: 90,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'pcbItem', header: 'PCB', size: 70, meta: center },
  { accessorKey: 'lineName', header: '라인', size: 110 },
  { accessorKey: 'workstageName', header: '공정', size: 120 },
  { accessorKey: 'magazineSetNo', header: '세트번호', size: 130 },
  { accessorKey: 'enterBy', header: '작성자', size: 100 },
  {
    accessorKey: 'receiptDate',
    header: '발행일시',
    size: 160,
    cell: (c) => ts(c.getValue()),
  },
];

// ───────────────────────────────── 230 분할

export interface MagazineSplitRow {
  magazineLabelNo: string;
  magazineLabelType: string | null;
  parentMagazineLabelNo: string | null;
  transferMagazineLabelNo: string | null;
  magazineSetNo: string | null;
  runNo: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  itemCode: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  pcbItem: string | null;
  lotQty: number | null;
  enterBy: string | null;
  receiptDate: string | null;
}

export const magazineSplitColumns: ColumnDef<MagazineSplitRow>[] = [
  { accessorKey: 'magazineLabelNo', header: '새 라벨', size: 130 },
  {
    accessorKey: 'magazineLabelType',
    header: '구분',
    size: 70,
    meta: center,
    cell: (c) => labelTypeCell(c.getValue()),
  },
  {
    accessorKey: 'lotQty',
    header: '수량',
    size: 90,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'parentMagazineLabelNo', header: '원본 라벨', size: 130 },
  { accessorKey: 'magazineSetNo', header: '세트번호', size: 130 },
  { accessorKey: 'runNo', header: '런카드', size: 130 },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'lineName', header: '라인', size: 110 },
  { accessorKey: 'pcbItem', header: 'PCB', size: 70, meta: center },
  { accessorKey: 'enterBy', header: '작성자', size: 100 },
  {
    accessorKey: 'receiptDate',
    header: '분할일시',
    size: 160,
    cell: (c) => ts(c.getValue()),
  },
];

// ───────────────────────────────── 231 PID 매핑

export interface MagazinePidRow {
  serialNo: string;
  runNo: string | null;
  magazineNo: string | null;
  itemCode: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  lineCode: string | null;
  workstageCode: string | null;
  barcodeStatus: string | null;
  qcScanYn: string | null;
  lotQty: number | null;
  enterBy: string | null;
  runDate: string | null;
  enterDate: string | null;
}

export const magazinePidColumns: ColumnDef<MagazinePidRow>[] = [
  { accessorKey: 'serialNo', header: 'PID', size: 200 },
  {
    accessorKey: 'barcodeStatus',
    header: '상태',
    size: 80,
    meta: center,
    cell: (c) => (String(c.getValue() ?? '') === 'R'
      ? <span className="font-medium text-amber-500">수리</span>
      : <span>정상</span>),
  },
  {
    accessorKey: 'qcScanYn',
    header: '검사읽음',
    size: 90,
    meta: center,
    cell: (c) => (String(c.getValue() ?? 'N') === 'Y'
      ? <span className="font-medium text-blue-500">읽음</span>
      : <span className="text-text-muted">-</span>),
  },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  { accessorKey: 'runNo', header: '런카드', size: 130 },
  { accessorKey: 'lineCode', header: '라인', size: 80, meta: center },
  { accessorKey: 'workstageCode', header: '공정', size: 90, meta: center },
  { accessorKey: 'enterBy', header: '작성자', size: 100 },
  {
    accessorKey: 'enterDate',
    header: '등록일시',
    size: 160,
    cell: (c) => ts(c.getValue()),
  },
];
