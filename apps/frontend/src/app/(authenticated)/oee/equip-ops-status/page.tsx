'use client';

/**
 * @file (authenticated)/oee/equip-ops-status/page.tsx
 * @description 설비 운영 현황 — 모니터링 탭 + 비가동 처리 탭. 설비마스터 기준 실시간 가동상태와 비가동 처리
 *
 * API(글로벌 prefix /api → 백엔드 /api/v1)
 *   설비/라인 GET /oee/equip-ops/machines · /lines
 *   지표/이력 GET /oee/equip-ops/summary · /monthly
 *   비가동    POST /oee/work-result/downtimes(단건) · /downtimes/bulk(일괄)
 *
 * 설계 근거: docs/plans/2026-08-27-equip-ops-status.md, docs/adr/0002-equip-downtime-machine-scoped.md
 */

import { useCallback, useEffect, useState } from 'react';
import { Activity, MonitorDot, PauseCircle, RefreshCw } from 'lucide-react';
import toast from 'react-hot-toast';
import { Select } from '@/components/ui';
import api from '@/services/api';
import MonitoringTab from './components/MonitoringTab';
import DowntimeTab from './components/DowntimeTab';
import { REFRESH_INTERVALS, type OpsLine, type OpsMachine, type RefreshInterval } from './types';

type TabValue = 'monitor' | 'downtime';

export default function EquipOpsStatusPage() {
  const [activeTab, setActiveTab] = useState<TabValue>('monitor');
  const [machines, setMachines] = useState<OpsMachine[]>([]);
  const [lines, setLines] = useState<OpsLine[]>([]);
  const [loading, setLoading] = useState(false);
  // 자동갱신 주기(초). 0이면 끄기 — 두 탭이 함께 쓴다
  const [refreshSec, setRefreshSec] = useState<RefreshInterval>(30);

  const loadMachines = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get('/oee/equip-ops/machines');
      setMachines(res.data?.data?.list ?? []);
    } catch { toast.error('설비 목록 조회에 실패했습니다'); }
    finally { setLoading(false); }
  }, []);

  useEffect(() => { loadMachines(); }, [loadMachines]);

  useEffect(() => {
    api.get('/oee/equip-ops/lines').then((r) => setLines(r.data?.data?.list ?? [])).catch(() => {});
  }, []);

  // 자동갱신 — 주기가 0이면 타이머를 걸지 않는다
  useEffect(() => {
    if (!refreshSec) return;
    const id = setInterval(() => { loadMachines(); }, refreshSec * 1000);
    return () => clearInterval(id);
  }, [refreshSec, loadMachines]);

  const tabs: { key: TabValue; label: string; icon: React.ReactNode }[] = [
    { key: 'monitor', label: '모니터링', icon: <MonitorDot className="w-4 h-4" /> },
    { key: 'downtime', label: '비가동 처리', icon: <PauseCircle className="w-4 h-4" /> },
  ];

  return (
    <div className="h-full flex flex-col overflow-hidden p-6 gap-4 animate-fade-in">
      {/* 헤더 */}
      <div className="flex items-start justify-between flex-shrink-0 gap-4">
        <div>
          <h1 className="text-xl font-bold text-text flex items-center gap-2">
            <Activity className="w-6 h-6 text-primary" /> 설비 운영 현황
          </h1>
          <p className="text-sm text-text-muted mt-1">설비마스터 기준 현재 가동상태 · 라인/설비 단위 비가동 처리</p>
        </div>
        <div className="flex items-end gap-2">
          <label className="text-xs text-text-muted flex flex-col gap-1 w-36">자동갱신
            <Select
              options={REFRESH_INTERVALS.map((s) => ({ value: String(s), label: s ? `${s}초` : '끄기' }))}
              value={String(refreshSec)}
              onChange={(v) => setRefreshSec(Number(v) as RefreshInterval)}
              fullWidth />
          </label>
          <button onClick={loadMachines} className="border border-border rounded px-3 h-10 text-text-muted hover:bg-surface flex items-center gap-1">
            <RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />조회
          </button>
        </div>
      </div>

      {/* 탭 네비게이션 */}
      <div className="border-b border-border flex-shrink-0">
        <div className="flex gap-1">
          {tabs.map((tab) => (
            <button
              key={tab.key}
              onClick={() => setActiveTab(tab.key)}
              className={`flex items-center gap-2 px-4 py-2.5 text-sm font-medium border-b-2 transition-colors ${
                activeTab === tab.key
                  ? 'border-primary text-primary'
                  : 'border-transparent text-text-muted hover:text-text hover:border-border'
              }`}
            >
              {tab.icon}
              {tab.label}
            </button>
          ))}
        </div>
      </div>

      {/* 탭 컨텐츠 */}
      <div className="flex-1 min-h-0 overflow-hidden">
        {activeTab === 'monitor' && <MonitoringTab machines={machines} loading={loading} onChanged={loadMachines} />}
        {activeTab === 'downtime' && <DowntimeTab machines={machines} lines={lines} refreshSec={refreshSec} onChanged={loadMachines} />}
      </div>
    </div>
  );
}
