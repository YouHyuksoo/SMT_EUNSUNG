'use client';

/**
 * @file (authenticated)/oee/field-ops/page.tsx
 * @description 현장 작업자용 '설비 운영 및 실적관리' — 비가동 처리와 작업실적 등록만 담은 단일 화면.
 *
 * 설비 운영 현황의 비가동 처리 탭을 바탕으로 만들되 현장에 맞게 덜어냈다.
 *   - 자동갱신·상단 조회 없음 (처리 후에만 다시 읽는다)
 *   - 탭 없음
 *   - 상단에 작업자 선택 추가 → 비가동 WORKER(사번) / 실적 WORKER_NAME(이름)으로 흐른다
 *   - 이전 30일 이력은 [이력보기] 팝업으로 옮기고, 그 자리를 작업실적 관리가 쓴다
 *
 * 설계 근거: docs/plans/2026-09-09-field-ops-app.md
 */
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { Barcode, Factory, HardHat, Wrench } from 'lucide-react';
import toast from 'react-hot-toast';
import { Input, Select } from '@/components/ui';
import { useWorkerOptions } from '@/hooks/useMasterOptions';
import api from '@/services/api';
import DailyMetrics from '../equip-ops-status/components/DailyMetrics';
import { EMPTY_SUMMARY, type DailySummary, type OpsLine, type OpsMachine, type RecentRow } from '../equip-ops-status/types';
import DowntimePanel from './components/DowntimePanel';
import WorkOrderPanel from './components/WorkOrderPanel';
import DowntimeHistoryModal from './components/DowntimeHistoryModal';

type ScopeMode = 'LINE' | 'MACHINE';

/** 라인 모드에서 고르는 묶음 — SMT 는 라인, 후공정(ASSY) 설비는 라인이 없어(LINE_CODE='*') 공정으로 묶는다 */
interface ScopeGroup {
  key: string;
  kind: 'LINE' | 'WORKSTAGE';
  code: string;
  name: string;
  division: string | null;
  /** 비가동 대상 설비 수 */
  count: number;
}

export default function FieldOpsPage() {
  const [mode, setMode] = useState<ScopeMode>('MACHINE');
  const [groupKey, setGroupKey] = useState('');
  const [machineCode, setMachineCode] = useState('');
  const [scan, setScan] = useState('');
  const scanRef = useRef<HTMLInputElement>(null);
  const [workerCode, setWorkerCode] = useState('');
  const [historyOpen, setHistoryOpen] = useState(false);

  const [machines, setMachines] = useState<OpsMachine[]>([]);
  const [lines, setLines] = useState<OpsLine[]>([]);
  const [summary, setSummary] = useState<DailySummary>(EMPTY_SUMMARY);
  const [recent, setRecent] = useState<{ list: RecentRow[]; totalCount: number; totalMinutes: number }>({ list: [], totalCount: 0, totalMinutes: 0 });

  const { workers } = useWorkerOptions();
  // 비가동에는 사번을, 실적에는 이름을 남긴다 (컬럼 의미에 맞춘다)
  const workerName = workers.find((w) => (w.workerCode ?? w.id) === workerCode)?.workerName ?? '';

  const loadMachines = useCallback(async () => {
    try {
      const res = await api.get('/oee/equip-ops/machines', { params: { downtimeTarget: 'Y' } }); // 비가동 대상 설비만(ES- 코드)
      setMachines(res.data?.data?.list ?? []);
    } catch { toast.error('설비 목록 조회에 실패했습니다'); }
  }, []);

  useEffect(() => { void loadMachines(); }, [loadMachines]);
  useEffect(() => {
    api.get('/oee/equip-ops/lines').then((r) => setLines(r.data?.data?.list ?? [])).catch(() => {});
  }, []);

  // 비가동 대상 설비가 있는 라인 + 후공정 공정만 고를 수 있다
  const groups = useMemo<ScopeGroup[]>(() => {
    const lineGroups: ScopeGroup[] = lines
      .map((l) => ({
        key: `L:${l.lineCode}`, kind: 'LINE' as const, code: l.lineCode, name: l.lineName ?? '', division: l.lineDivision,
        count: machines.filter((m) => m.lineCode === l.lineCode).length,
      }))
      .filter((g) => g.count > 0);
    const stages = new Map<string, ScopeGroup>();
    for (const m of machines) {
      if (m.workstageGroup !== 'PBA' || !m.workstageCode) continue;
      const g = stages.get(m.workstageCode)
        ?? { key: `W:${m.workstageCode}`, kind: 'WORKSTAGE' as const, code: m.workstageCode, name: m.workstageName ?? '', division: '후공정', count: 0 };
      g.count += 1;
      stages.set(m.workstageCode, g);
    }
    return [...lineGroups, ...[...stages.values()].sort((a, b) => a.code.localeCompare(b.code))];
  }, [lines, machines]);

  const selectedGroup = groups.find((g) => g.key === groupKey) ?? null;
  const selectedMachine = machines.find((m) => m.machineCode === machineCode) ?? null;
  // 설비 목록을 다시 읽어도 조회가 반복되지 않도록 아래 메모는 값으로만 의존한다
  const groupKind = selectedGroup?.kind;
  const groupCode = selectedGroup?.code;
  const machineGroup = selectedMachine?.workstageGroup ?? null;
  const machineStage = selectedMachine?.workstageCode ?? null;
  const machineLine = selectedMachine?.lineCode ?? null;

  const targets = useMemo(() => {
    if (mode === 'LINE') {
      if (!groupKind || !groupCode) return [];
      return machines.filter((m) => (groupKind === 'LINE' ? m.lineCode === groupCode : m.workstageCode === groupCode));
    }
    return selectedMachine ? [selectedMachine] : [];
  }, [mode, groupKind, groupCode, machines, selectedMachine]);

  /** 비가동 지표·이력 범위 — 설비 모드는 그 설비만 */
  const scopeParams = useMemo(() => {
    if (mode === 'LINE') {
      if (!groupKind || !groupCode) return null;
      return groupKind === 'LINE' ? { lineCode: groupCode } : { workstageCode: groupCode };
    }
    return machineCode ? { machineCode } : null;
  }, [mode, groupKind, groupCode, machineCode]);

  /** 작업지시 범위 — 작업지시에는 설비코드가 거의 없어서 설비 모드도 설비가 속한 공정(후공정)이나 라인(SMT)으로 찾는다 */
  const workScope = useMemo(() => {
    if (mode === 'LINE') {
      if (!groupKind || !groupCode) return null;
      return groupKind === 'LINE' ? { lineCode: groupCode } : { workstageCode: groupCode, excludeSmt: 'Y' as const };
    }
    if (!machineCode) return null;
    if (machineGroup === 'PBA' && machineStage) return { workstageCode: machineStage, excludeSmt: 'Y' as const };
    if (machineLine && machineLine !== '*') return { lineCode: machineLine };
    return { machineCode };
  }, [mode, groupKind, groupCode, machineCode, machineGroup, machineStage, machineLine]);

  const scopeLabel = mode === 'LINE'
    ? (selectedGroup ? `${selectedGroup.code} · ${selectedGroup.name}` : null)
    : (selectedMachine ? `${selectedMachine.machineCode} · ${selectedMachine.machineName ?? ''}` : null);

  const loadScope = useCallback(async () => {
    if (!scopeParams) {
      setSummary(EMPTY_SUMMARY);
      setRecent({ list: [], totalCount: 0, totalMinutes: 0 });
      return;
    }
    try {
      const [s, m] = await Promise.all([
        api.get('/oee/equip-ops/summary', { params: scopeParams }),
        api.get('/oee/equip-ops/recent', { params: scopeParams }),
      ]);
      setSummary(s.data?.data ?? EMPTY_SUMMARY);
      setRecent(m.data?.data ?? { list: [], totalCount: 0, totalMinutes: 0 });
    } catch { /* 조회 실패는 빈 화면으로 둔다 */ }
  }, [scopeParams]);

  useEffect(() => { void loadScope(); }, [loadScope]);

  const afterChange = useCallback(async () => {
    await loadMachines();
    await loadScope();
  }, [loadMachines, loadScope]);

  const selectMode = (m: ScopeMode) => { setMode(m); setGroupKey(''); setMachineCode(''); };

  /** 바코드/수기 입력 → 선택 모드에 맞는 코드로 대상 확정 */
  function resolveScan(raw: string) {
    const code = raw.trim().toUpperCase();
    if (!code) return;
    if (mode === 'LINE') {
      const group = groups.find((g) => g.code.toUpperCase() === code);
      if (!group) { toast.error(`라인·공정 코드 '${raw.trim()}'를 찾을 수 없습니다`); return; }
      setGroupKey(group.key); setScan('');
      toast.success(`${group.code} · ${group.name} 선택`);
      return;
    }
    const machine = machines.find((m) => m.machineCode.toUpperCase() === code);
    if (!machine) { toast.error(`설비코드 '${raw.trim()}'를 찾을 수 없습니다`); return; }
    setMachineCode(machine.machineCode); setScan('');
    toast.success(`${machine.machineCode} · ${machine.machineName ?? ''} 선택`);
  }

  return (
    <div className="h-full flex flex-col overflow-hidden p-6 gap-3 animate-fade-in">
      <div className="flex-shrink-0">
        <h1 className="text-xl font-bold text-text flex items-center gap-2">
          <HardHat className="w-6 h-6 text-primary" /> 설비 운영 및 실적관리(현장)
        </h1>
        <p className="text-sm text-text-muted mt-1">현장 작업자용 · 라인/설비 비가동 처리와 작업실적 등록</p>
      </div>

      {/* 상단 — 라인/설비 선택 + 바코드 + 작업자 */}
      <div className="flex items-end gap-3 flex-nowrap flex-shrink-0 border border-border rounded-lg p-3">
        <div className="flex gap-2 flex-shrink-0">
          {([['LINE', '라인·공정', Factory], ['MACHINE', '설비', Wrench]] as const).map(([key, label, Icon]) => (
            <button key={key} type="button" onClick={() => selectMode(key)}
              className={`w-[86.4px] h-[61.2px] rounded-lg border flex flex-col items-center justify-center gap-1 text-sm font-semibold transition-colors ${
                mode === key ? 'bg-primary text-white border-primary' : 'border-border bg-background text-text hover:border-primary/60'
              }`}>
              <Icon className="w-5 h-5" />{label}
            </button>
          ))}
        </div>

        {mode === 'LINE' ? (
          <label className="text-xs text-text-muted flex flex-col gap-1 flex-1 min-w-0 max-w-64">라인·공정 선택 (코드 · 이름 · 구분)
            <Select
              options={[{ value: '', label: '라인 또는 공정을 선택하세요' },
                ...groups.map((g) => ({ value: g.key, label: `${g.code} · ${g.name} · ${g.division ?? '-'} (${g.count}대)` }))]}
              value={groupKey} onChange={setGroupKey} fullWidth />
          </label>
        ) : (
          <label className="text-xs text-text-muted flex flex-col gap-1 flex-1 min-w-0 max-w-64">설비 선택 (설비코드 · 설비명 · 유형)
            <Select
              options={[{ value: '', label: '설비를 선택하세요' },
                ...machines.map((m) => ({ value: m.machineCode, label: `${m.machineCode} · ${m.machineName ?? ''} · ${m.machineTypeName ?? m.machineType ?? '-'}` }))]}
              value={machineCode} onChange={setMachineCode} fullWidth />
          </label>
        )}

        <label className="text-xs text-text-muted flex flex-col gap-1 flex-1 min-w-0 max-w-52 truncate">바코드 ({mode === 'LINE' ? '라인·공정 코드' : '설비코드'} 스캔)
          <div className="w-full">
            <Input ref={scanRef} placeholder="스캔 후 Enter" value={scan}
              onChange={(e) => setScan(e.target.value)}
              onKeyDown={(e) => { if (e.key === 'Enter') { e.preventDefault(); resolveScan(scan); } }}
              leftIcon={<Barcode className="w-4 h-4" />} fullWidth />
          </div>
        </label>

        <label className="text-xs text-text-muted flex flex-col gap-1 flex-1 min-w-0 max-w-64 truncate">작업자 (사번 · 이름 · 부서)
          <Select
            options={[{ value: '', label: '작업자를 선택하세요' },
              ...workers.map((w) => {
                const code = w.workerCode ?? w.id ?? '';
                return { value: code, label: [code, w.workerName, w.dept].filter(Boolean).join(' · ') };
              })]}
            value={workerCode} onChange={setWorkerCode} fullWidth />
        </label>
      </div>

      {/* 본문 3분할 */}
      <div className="flex-1 min-h-0 grid grid-rows-[minmax(0,1fr)] grid-cols-[minmax(0,0.9fr)_minmax(0,1.5fr)_minmax(0,1.2fr)] gap-3 overflow-hidden">
        <DailyMetrics summary={summary} scopeLabel={scopeLabel} />
        <DowntimePanel targets={targets} mode={mode} workerCode={workerCode}
          onHistoryClick={() => setHistoryOpen(true)} onChanged={afterChange} />
        <WorkOrderPanel scope={workScope} workerName={workerName} />
      </div>

      <DowntimeHistoryModal isOpen={historyOpen} onClose={() => setHistoryOpen(false)}
        scopeLabel={scopeLabel} recent={recent} />
    </div>
  );
}
