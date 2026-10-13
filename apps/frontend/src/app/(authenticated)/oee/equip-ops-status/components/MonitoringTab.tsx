'use client';

/**
 * @file (authenticated)/oee/equip-ops-status/components/MonitoringTab.tsx
 * @description 설비 운영 현황 - 모니터링 탭. 설비마스터 전체의 현재 가동상태 목록 + 행별 비가동 관리
 *
 * 비가동 처리는 공용 컴포넌트 EquipDowntimePanel을 우측 슬라이드 패널에 담아 쓴다.
 */

import { useMemo, useState } from 'react';
import type { ColumnDef } from '@tanstack/react-table';
import { Search, PauseCircle, Wrench } from 'lucide-react';
import { Card, CardContent, Input, Select } from '@/components/ui';
import DataGrid from '@/components/data-grid/DataGrid';
import EquipDowntimePanel, { type DowntimeMachine } from '@/components/shared/EquipDowntimePanel';
import { useEquipTypeOptions, useProcessOptions } from '@/hooks/useMasterOptions';
import type { OpsMachine } from '../types';

interface Props {
  machines: OpsMachine[];
  loading: boolean;
  /** 비가동 처리 후 목록을 다시 읽는다 */
  onChanged: () => void | Promise<void>;
}

type StatusFilter = '' | 'DOWN' | 'OK';

export default function MonitoringTab({ machines, loading, onChanged }: Props) {
  const [machineType, setMachineType] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');
  const [status, setStatus] = useState<StatusFilter>('');
  const [keyword, setKeyword] = useState('');
  const [panelMachine, setPanelMachine] = useState<OpsMachine | null>(null);

  const { options: typeOptions } = useEquipTypeOptions();
  const { options: processOptions } = useProcessOptions();

  // 목록은 한 번에 다 받아오므로 필터는 클라이언트에서 건다 (120대 규모)
  const rows = useMemo(() => {
    const kw = keyword.trim().toUpperCase();
    return machines.filter((m) => {
      if (machineType && m.machineType !== machineType) return false;
      if (workstageCode && m.workstageCode !== workstageCode) return false;
      if (status === 'DOWN' && m.openDtSeq == null) return false;
      if (status === 'OK' && m.openDtSeq != null) return false;
      if (kw && !`${m.machineCode} ${m.machineName ?? ''}`.toUpperCase().includes(kw)) return false;
      return true;
    });
  }, [machines, machineType, workstageCode, status, keyword]);

  const downCount = useMemo(() => machines.filter((m) => m.openDtSeq != null).length, [machines]);

  const columns = useMemo<ColumnDef<OpsMachine>[]>(() => [
    { accessorKey: 'machineCode', header: '설비코드', cell: ({ row }) => <span className="font-mono">{row.original.machineCode}</span> },
    { id: 'machineName', header: '설비명', accessorFn: (m) => m.machineName ?? '-' },
    { id: 'machineType', header: '유형', accessorFn: (m) => m.machineTypeName ?? m.machineType ?? '-', meta: { align: 'center' as const } },
    { id: 'workstage', header: '적용공정', accessorFn: (m) => (m.workstageCode ? `${m.workstageCode} · ${m.workstageName ?? ''}` : '-') },
    { id: 'modelName', header: '모델', accessorFn: (m) => m.modelName ?? '-', cell: ({ getValue }) => <span className="text-text-muted">{String(getValue())}</span> },
    {
      id: 'status',
      header: '상태',
      size: 96,
      accessorFn: (m) => (m.openDtSeq != null ? '비가동' : '정상'),
      meta: { align: 'center' as const, filterType: 'select' as const },
      cell: ({ row }) => {
        const down = row.original.openDtSeq != null;
        return (
          <span className={`px-2 py-0.5 rounded text-xs font-medium ${down ? 'bg-red-500 text-white' : 'bg-emerald-500 text-white'}`}>
            {down ? '비가동' : '정상'}
          </span>
        );
      },
    },
    {
      id: 'actions',
      header: '비가동 처리',
      size: 128,
      enableSorting: false,
      meta: { align: 'center' as const, filterType: 'none' as const },
      cell: ({ row }) => (
        <button onClick={(e) => { e.stopPropagation(); setPanelMachine(row.original); }}
          className="text-xs border border-primary text-primary rounded px-2 py-1 hover:bg-surface inline-flex items-center gap-1">
          <Wrench className="w-3 h-3" />비가동 관리
        </button>
      ),
    },
  ], []);

  // 패널이 열린 설비의 최신 상태 (목록 갱신 후에도 패널이 따라가도록)
  const panelTarget: DowntimeMachine | null = panelMachine
    ? { machineCode: panelMachine.machineCode, machineName: panelMachine.machineName, workstageCode: panelMachine.workstageCode }
    : null;

  return (
    <div className="h-full flex gap-4 overflow-hidden">
      <div className="flex-1 min-w-0 flex flex-col gap-3 overflow-hidden">
        {/* 조회조건 */}
        <div className="flex items-end gap-2 flex-wrap flex-shrink-0">
          <label className="text-xs text-text-muted flex flex-col gap-1 w-44">설비유형
            <Select options={[{ value: '', label: '전체' }, ...typeOptions]} value={machineType} onChange={setMachineType} fullWidth />
          </label>
          <label className="text-xs text-text-muted flex flex-col gap-1 w-48">적용공정
            <Select options={[{ value: '', label: '전체' }, ...processOptions]} value={workstageCode} onChange={setWorkstageCode} fullWidth />
          </label>
          <label className="text-xs text-text-muted flex flex-col gap-1 w-36">상태
            <Select
              options={[{ value: '', label: '전체' }, { value: 'DOWN', label: '비가동만' }, { value: 'OK', label: '정상만' }]}
              value={status} onChange={(v) => setStatus(v as StatusFilter)} fullWidth />
          </label>
          <label className="text-xs text-text-muted flex flex-col gap-1">통합검색
            <div className="w-56"><Input placeholder="설비코드·설비명" value={keyword} onChange={(e) => setKeyword(e.target.value)} leftIcon={<Search className="w-4 h-4" />} fullWidth /></div>
          </label>
          <div className="ml-auto text-sm text-text-muted pb-2">
            전체 <span className="font-semibold text-text">{machines.length}</span>대 ·
            비가동 <span className={`font-semibold ${downCount ? 'text-red-500' : 'text-text'}`}>{downCount}</span>대 ·
            표시 <span className="font-semibold text-text">{rows.length}</span>대
          </div>
        </div>

        {/* 목록 */}
        <Card className="flex-1 min-h-0 overflow-hidden" padding="none">
          <CardContent className="h-full p-4">
            <DataGrid
              data={rows}
              columns={columns}
              isLoading={loading}
              pageSize={200}
              enableExport
              exportFileName="설비운영현황"
              getRowId={(m) => m.machineCode}
              selectedRowId={panelMachine?.machineCode}
              emptyMessage="조회 결과가 없습니다"
            />
          </CardContent>
        </Card>
      </div>

      {/* 우측 슬라이드 패널 — 공용 비가동 컴포넌트 */}
      {panelTarget && (
        <div className="w-[560px] flex-shrink-0 border-l border-border bg-background flex flex-col h-full overflow-hidden shadow-2xl animate-slide-in-right">
          <div className="px-5 py-3 border-b border-border flex items-center justify-between flex-shrink-0">
            <h2 className="text-sm font-bold text-text flex items-center gap-2">
              <PauseCircle className="w-4 h-4 text-rose-600" />설비비가동
              <span className="ml-1 font-mono text-text-muted text-xs">{panelTarget.machineCode}</span>
            </h2>
            <button onClick={() => setPanelMachine(null)} className="px-3 py-2 rounded border border-border text-text-muted text-sm">닫기</button>
          </div>
          <div className="flex-1 min-h-0 overflow-y-auto px-5 py-4">
            <EquipDowntimePanel key={panelTarget.machineCode} machine={panelTarget} onChanged={onChanged} />
          </div>
        </div>
      )}
    </div>
  );
}
