/**
 * @file src/app/(authenticated)/jig/jig-extra-columns.tsx
 * @description 지그 추가 2화면 행 타입 + 그리드 컬럼 — 187 수리신청 · 195 세척검사.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { num } from '@/components/shared/grid-format';
import { formatDisplayDate } from '@/utils/date';

const right = { align: 'right' } as const;
const center = { align: 'center' } as const;
const ts = (value: unknown) => (value ? formatDisplayDate(value) : '');

const yesNo = (yes: string, no: string) => (value: unknown) => (
  String(value ?? 'N') === 'Y'
    ? <span className="font-medium text-emerald-500">{yes}</span>
    : <span className="font-medium text-red-500">{no}</span>
);

// ───────────────────────────────── 187 수리신청

export interface JigRepairRequestRow {
  jigCode: string;
  jigName: string | null;
  jigType: string | null;
  jigLotNo: string | null;
  repairSequence: number;
  repairStatus: string | null;
  repairReasonCode: string | null;
  repairVendorCode: string | null;
  repairBy: string | null;
  repairTime: number | null;
  repairAmt: number | null;
  currency: string | null;
  comments: string | null;
  repairComments: string | null;
  enterBy: string | null;
  repairRequestDate: string | null;
  repairDate: string | null;
  enterDate: string | null;
}

export interface RepairableJigRow {
  jigCode: string;
  jigName: string | null;
  jigType: string | null;
  jigModelName: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  useStatus: string | null;
  capacity: number | null;
  useRate: number | null;
  customerCode: string | null;
  locationComment: string | null;
  acquisitionDate: string | null;
  openRequestCount: number | null;
}

export const jigRepairRequestColumns: ColumnDef<JigRepairRequestRow>[] = [
  { accessorKey: 'jigCode', header: '지그코드', size: 140 },
  { accessorKey: 'jigName', header: '지그명', size: 170 },
  { accessorKey: 'jigLotNo', header: '지그 롯트', size: 140 },
  {
    accessorKey: 'repairSequence',
    header: '신청번호',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'repairReasonCode', header: '수리사유', size: 120 },
  {
    accessorKey: 'repairDate',
    header: '수리완료',
    size: 110,
    meta: center,
    cell: (c) => (c.getValue()
      ? <span className="text-text-muted">{ts(c.getValue())}</span>
      : <span className="font-medium text-amber-500">대기</span>),
  },
  { accessorKey: 'repairVendorCode', header: '수리업체', size: 120 },
  { accessorKey: 'repairBy', header: '수리자', size: 100 },
  {
    accessorKey: 'repairAmt',
    header: '수리비',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'comments', header: '신청내용', size: 220 },
  { accessorKey: 'enterBy', header: '신청자', size: 100 },
  {
    accessorKey: 'repairRequestDate',
    header: '신청일',
    size: 110,
    cell: (c) => ts(c.getValue()),
  },
];

export const repairableJigColumns: ColumnDef<RepairableJigRow>[] = [
  { accessorKey: 'jigCode', header: '지그코드', size: 140 },
  { accessorKey: 'jigName', header: '지그명', size: 170 },
  { accessorKey: 'jigType', header: '유형', size: 80, meta: center },
  { accessorKey: 'jigModelName', header: '지그모델', size: 140 },
  { accessorKey: 'lineName', header: '라인', size: 110 },
  { accessorKey: 'useStatus', header: '상태', size: 80, meta: center },
  {
    accessorKey: 'openRequestCount',
    header: '미완료 신청',
    size: 110,
    meta: right,
    cell: (c) => {
      const v = Number(c.getValue() ?? 0);
      return v > 0
        ? <span className="font-semibold text-amber-500">{num(v)}</span>
        : <span className="text-text-muted">-</span>;
    },
  },
  { accessorKey: 'locationComment', header: '보관위치', size: 160 },
];

// ───────────────────────────────── 195 세척검사

export interface JigCleanCheckRow {
  jigCode: string;
  jigName: string | null;
  jigLotNo: string | null;
  jigCheckSequence: number | null;
  jigCheckStatus: string | null;
  lineCode: string | null;
  lineName: string | null;
  breakValue: number | null;
  hitValue: number | null;
  airPressValue: number | null;
  cleanYn: string | null;
  pinHoleYn: string | null;
  confirmYn: string | null;
  comments: string | null;
  usedBy: string | null;
  enterBy: string | null;
  jigCheckDate: string | null;
}

export const jigCleanCheckColumns: ColumnDef<JigCleanCheckRow>[] = [
  { accessorKey: 'jigLotNo', header: '지그 롯트', size: 150 },
  { accessorKey: 'jigCode', header: '지그코드', size: 130 },
  { accessorKey: 'jigName', header: '지그명', size: 150 },
  {
    accessorKey: 'jigCheckStatus',
    header: '판정',
    size: 80,
    meta: center,
    cell: (c) => (String(c.getValue() ?? '') === 'P'
      ? <span className="font-semibold text-emerald-500">합격</span>
      : <span className="font-semibold text-red-500">불합격</span>),
  },
  {
    accessorKey: 'cleanYn',
    header: '세척',
    size: 80,
    meta: center,
    cell: (c) => yesNo('OK', 'NG')(c.getValue()),
  },
  {
    accessorKey: 'pinHoleYn',
    header: '외관',
    size: 80,
    meta: center,
    cell: (c) => yesNo('OK', 'NG')(c.getValue()),
  },
  {
    accessorKey: 'airPressValue',
    header: '공기압',
    size: 90,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'breakValue',
    header: 'Break',
    size: 90,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'hitValue',
    header: 'Hit',
    size: 90,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'lineName', header: '라인', size: 110 },
  { accessorKey: 'comments', header: '비고', size: 200 },
  { accessorKey: 'enterBy', header: '검사자', size: 100 },
  {
    accessorKey: 'jigCheckDate',
    header: '검사일시',
    size: 160,
    cell: (c) => ts(c.getValue()),
  },
];
