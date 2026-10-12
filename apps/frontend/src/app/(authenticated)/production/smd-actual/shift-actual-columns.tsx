/**
 * @file src/app/(authenticated)/production/smd-actual/shift-actual-columns.tsx
 * @description 반제품생산실적관리 — 계획별 주야 실적 탭의 행 타입과 그리드 컬럼.
 *
 * 초보자 가이드:
 * 1. **한 줄 = 반제품생산계획 한 건.** 자동 실적은 조회 시점의 라인 센서 실적을
 *    계획일·라인·모델·서픽스·PCB 면으로 맞춰 더한 값이다.
 * 2. **주간 08:30~20:30, 야간 20:30~다음날 08:30.** 야간은 계획일 저녁부터 다음날 아침까지다.
 * 3. **실적 = 수기가 있으면 수기, 없으면 자동.** 잔량 계산은 서버가 한다 —
 *    주간 잔량 = 계획 − 주간 실적, 야간 잔량 = 계획 − 주간 실적 − 야간 실적.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, dateOnly, num } from '@/components/shared/grid-format';

export interface SmdShiftActualRow {
  planDate: string;
  planSequence: number;
  lineCode: string | null;
  lineName: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  pcbItem: string | null;
  pcbItemName: string | null;
  itemCode: string | null;
  workOrderNo: string | null;
  planStatus: string | null;
  planStatusName: string | null;
  confirmYn: string | null;
  planQty: number | null;
  dayAutoQty: number;
  nightAutoQty: number;
  dayManualQty: number | null;
  nightManualQty: number | null;
  dayManualBy: string | null;
  dayManualDate: string | null;
  nightManualBy: string | null;
  nightManualDate: string | null;
  lastReceiptDate: string | null;
  /** 같은 계획일·라인·모델·서픽스·PCB 면 계획 수. 2 이상이면 자동 실적이 계획마다 똑같이 붙는다. */
  samePlanCount: number;
  dayActualQty: number;
  nightActualQty: number;
  dayRemainQty: number;
  nightRemainQty: number;
}

const right = { align: 'right' } as const;

/** 잔량 — 초과 생산(음수)은 빨갛게 둔다. */
const remain = (value: unknown) => {
  if (value == null) return '';
  const n = Number(value);
  return <span className={n < 0 ? 'text-red-500' : undefined}>{num(n)}</span>;
};

/** 수기 값 — 없으면 비워 두고, 있으면 굵게 보여 자동 대신 쓰인다는 것을 드러낸다. */
const manual = (value: unknown) =>
  value == null ? '' : <span className="font-semibold text-primary">{num(value)}</span>;

/** 자동 값 — 같은 근무조에 수기가 있으면 흐리게 둔다(실적에 쓰이지 않음). */
const auto = (value: unknown, overridden: boolean) => (
  <span className={overridden ? 'text-text-muted line-through' : undefined}>{num(value)}</span>
);

export const smdShiftActualColumns: ColumnDef<SmdShiftActualRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'planDate', header: '계획일', size: 110, cell: (c) => dateOnly(c.getValue()) },
  { accessorKey: 'planSequence', header: '순번', size: 80, meta: right },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'modelName', header: '모델명', size: 200 },
  {
    id: 'pcbItemName',
    header: 'PCB면',
    size: 90,
    accessorFn: (r) => codeWithName(r.pcbItem, r.pcbItemName),
  },
  { accessorKey: 'planQty', header: '계획수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'dayAutoQty',
    header: '주간실적(자동)',
    size: 120,
    meta: right,
    cell: (c) => auto(c.getValue(), c.row.original.dayManualQty != null),
  },
  {
    accessorKey: 'dayManualQty',
    header: '주간실적(수기)',
    size: 120,
    meta: right,
    cell: (c) => manual(c.getValue()),
  },
  {
    accessorKey: 'nightAutoQty',
    header: '야간실적(자동)',
    size: 120,
    meta: right,
    cell: (c) => auto(c.getValue(), c.row.original.nightManualQty != null),
  },
  {
    accessorKey: 'nightManualQty',
    header: '야간실적(수기)',
    size: 120,
    meta: right,
    cell: (c) => manual(c.getValue()),
  },
  { accessorKey: 'dayRemainQty', header: '주간 잔량', size: 110, meta: right, cell: (c) => remain(c.getValue()) },
  { accessorKey: 'nightRemainQty', header: '야간 잔량', size: 110, meta: right, cell: (c) => remain(c.getValue()) },
  {
    accessorKey: 'samePlanCount',
    header: '같은 모델 계획',
    size: 120,
    meta: right,
    cell: (c) => {
      const n = Number(c.getValue() ?? 1);
      return n > 1 ? <span className="text-amber-600">{n}건 (자동 실적 공유)</span> : '';
    },
  },
  { accessorKey: 'lastReceiptDate', header: '최종 센서 집계', size: 140 },
  {
    id: 'dayManualInfo',
    header: '주간 수기 입력',
    size: 170,
    accessorFn: (r) => (r.dayManualBy ? `${r.dayManualBy} ${r.dayManualDate ?? ''}` : ''),
  },
  {
    id: 'nightManualInfo',
    header: '야간 수기 입력',
    size: 170,
    accessorFn: (r) => (r.nightManualBy ? `${r.nightManualBy} ${r.nightManualDate ?? ''}` : ''),
  },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 80 },
  { accessorKey: 'workOrderNo', header: '작업지시번호', size: 140 },
  {
    id: 'planStatusName',
    header: '계획상태',
    size: 110,
    accessorFn: (r) => codeWithName(r.planStatus, r.planStatusName),
  },
  { accessorKey: 'confirmYn', header: '확정', size: 70 },
];
