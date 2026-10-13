/**
 * @file (authenticated)/oee/equip-ops-status/components/downtime-columns.tsx
 * @description 비가동 처리 화면의 DataGrid 컬럼 — 설비 운영 현황(비가동 처리 탭)과 현장 화면이 같이 쓴다.
 *
 * 초보자 가이드:
 * 1. recentColumns: 이전 30일 비가동 이력 (설비 · 시작 · 종료 · 소요)
 * 2. targetMachineColumns: 비가동 대상 설비 (원인설비 체크 · 상태 · 설비코드 · 설비명 · 유형)
 *    원인설비 체크 상태는 화면이 들고 있으므로 함수 인자로 받는다.
 */
import type { ColumnDef } from '@tanstack/react-table';
import type { OpsMachine, RecentRow } from '../types';

/** 이전 30일 비가동 이력 */
export const recentColumns: ColumnDef<RecentRow>[] = [
  {
    accessorKey: 'machineCode',
    header: '설비',
    meta: { align: 'center' },
    cell: ({ row }) => (
      <span className="font-mono">
        {row.original.machineCode}
        {row.original.causeYn === 'Y' && (
          <span className="ml-1 px-1 py-0.5 rounded bg-amber-500/15 text-amber-600 text-[10px] font-sans" title="라인 정지의 원인설비">원인</span>
        )}
      </span>
    ),
  },
  { accessorKey: 'startTime', header: '시작', meta: { align: 'center' }, cell: ({ row }) => <span className="font-mono">{row.original.startTime ?? '-'}</span> },
  {
    // 종료가 없으면 진행중 — 필터·내보내기에도 같은 글자가 나가도록 값으로 만든다
    id: 'endTime',
    header: '종료',
    accessorFn: (d) => d.endTime ?? '진행중',
    meta: { align: 'center' },
    cell: ({ row }) => <span className="font-mono">{row.original.endTime ?? <span className="text-red-500 font-sans">진행중</span>}</span>,
  },
  {
    accessorKey: 'durationMin',
    header: '소요(분)',
    meta: { align: 'right', filterType: 'number' },
    cell: ({ row }) => <span className="font-mono tabular-nums">{row.original.durationMin.toLocaleString()}분</span>,
  },
];

interface TargetColumnOptions {
  causeCodes: Set<string>;
  /** 하나라도 비가동이면 종료 처리 — 이때는 원인설비를 고르지 않는다 */
  willEnd: boolean;
  onToggleCause: (machineCode: string) => void;
}

/** 비가동 대상 설비 — 원인설비 체크박스는 비가동 시작에서만 고를 수 있다 */
export function targetMachineColumns({ causeCodes, willEnd, onToggleCause }: TargetColumnOptions): ColumnDef<OpsMachine>[] {
  return [
    {
      id: 'cause',
      header: '원인',
      size: 52,
      enableSorting: false,
      enableResizing: false,
      meta: { align: 'center', filterType: 'none' },
      cell: ({ row }) => {
        const m = row.original;
        const down = m.openDtSeq != null;
        return (
          <input
            type="checkbox"
            checked={causeCodes.has(m.machineCode)}
            onChange={() => onToggleCause(m.machineCode)}
            onClick={(e) => e.stopPropagation()}
            disabled={willEnd || down}
            title={willEnd ? '종료 처리에는 원인설비를 지정하지 않습니다' : down ? '이미 비가동 중인 설비입니다' : '이 설비를 라인 정지의 원인으로 표시'}
            aria-label={`${m.machineCode} 원인설비`}
            className="w-4 h-4 cursor-pointer rounded border-border accent-primary disabled:cursor-not-allowed disabled:opacity-40"
          />
        );
      },
    },
    // 상태는 원인 바로 뒤에 둔다 — 좁은 현장 화면에서도 가로 스크롤 없이 보이게
    {
      id: 'status',
      header: '상태',
      accessorFn: (m) => (m.openDtSeq != null ? '비가동' : '가동'),
      meta: { align: 'center', filterType: 'select' },
      cell: ({ row }) => (row.original.openDtSeq != null
        ? <span className="px-1.5 py-0.5 rounded bg-red-500 text-white">비가동</span>
        : <span className="px-1.5 py-0.5 rounded bg-emerald-500 text-white">가동</span>),
    },
    { accessorKey: 'machineCode', header: '설비코드', cell: ({ row }) => <span className="font-mono">{row.original.machineCode}</span> },
    { id: 'machineName', header: '설비명', accessorFn: (m) => m.machineName ?? '-' },
    { id: 'machineType', header: '유형', accessorFn: (m) => m.machineTypeName ?? m.machineType ?? '-', meta: { align: 'center' } },
  ];
}
