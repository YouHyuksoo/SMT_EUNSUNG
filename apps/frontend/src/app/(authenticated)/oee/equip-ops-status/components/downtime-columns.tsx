/**
 * @file (authenticated)/oee/equip-ops-status/components/downtime-columns.tsx
 * @description 비가동 처리 화면의 DataGrid 컬럼 — 설비 운영 현황(비가동 처리 탭)과 현장 화면이 같이 쓴다.
 *
 * 초보자 가이드:
 * 1. recentColumns: 이전 30일 비가동 이력 (설비 · 시작 · 종료 · 소요)
 * 2. targetMachineColumns: 비가동 대상 설비 (상태 · 설비코드 · 설비명 · 유형)
 */
import type { ColumnDef } from '@tanstack/react-table';
import type { OpsMachine, RecentRow } from '../types';

/** 이전 30일 비가동 이력 */
export const recentColumns: ColumnDef<RecentRow>[] = [
  {
    accessorKey: 'machineCode',
    header: '설비',
    meta: { align: 'center' },
    cell: ({ row }) => <span className="font-mono">{row.original.machineCode}</span>,
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

/** 비가동 대상 설비 — 상태를 맨 앞에 둔다(좁은 현장 화면에서도 가로 스크롤 없이 보이게) */
export const targetMachineColumns: ColumnDef<OpsMachine>[] = [
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
