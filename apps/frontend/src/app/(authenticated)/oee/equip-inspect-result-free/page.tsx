'use client';

/**
 * @file (authenticated)/oee/equip-inspect-result-free/page.tsx
 * @description 검사실적(계획 없음) — 검사설비에서 작업지시(계획)를 고르지 않고 모델만 골라 검사실적을 넣는다.
 *              화면 틀은 설비별 검사실적관리(/oee/equip-inspect-result)를 그대로 쓰고, 생산실적(계획 없음)과 같은 방식으로 동작한다.
 *
 * 초보자 가이드:
 * 1. 라인·공정·설비·검사자·모델은 단말기(localStorage)에 기억한다. 설비는 검사공정(공정유형 Q) 설비만 고른다.
 * 2. 첫 검사실적을 저장하면 서버가 오늘 업무일의 작업지시(런카드)를 만들고, 계획수량은 검사수량 합계로 맞춘다.
 *    같은 라인·공정·모델의 다음 검사실적은 그 지시에 쌓인다. 실적을 취소하면 계획수량도 줄어든다.
 * 3. 제품생산계획에서 내려온 지시는 이 화면이 만들지도 고치지도 않는다.
 *
 * API(글로벌 prefix /api → 백엔드 /api/v1)
 *   모델: GET /oee/work-result-free/models (생산실적(계획 없음)과 같은 목록) · 오늘 지시: GET /oee/inspect-result-free/runs?lineCode&workstageCode
 *   검사실적: POST /oee/inspect-result-free/results · POST /oee/inspect-result-free/results/cancel
 *   이력: GET /oee/inspect-result/results?runNo · 불량원인: GET /oee/work-result/bad-reasons · 설비정지: components/shared/EquipDowntimePanel
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import { BellRing, ClipboardList, Factory, Layers, PauseCircle, PlayCircle } from 'lucide-react';
import toast from 'react-hot-toast';
import { Modal } from '@/components/ui';
import EquipDowntimePanel, { EquipDowntimeHistory } from '@/components/shared/EquipDowntimePanel';
import api from '@/services/api';
import type { OpsLine, OpsMachine } from '../equip-ops-status/types';
import WorkerModal from '../equip-work-result/components/WorkerModal';
import { lineLabel } from '../equip-work-result/_lib/scope';
import { businessDate } from '../equip-work-result/_lib/kpi';
import type { RunRow } from '../equip-work-result/_lib/types';
import InspectScopeModal from '../equip-inspect-result/components/InspectScopeModal';
import InspectStatus from '../equip-inspect-result/components/InspectStatus';
import InspectEntryPad, { type BadReason } from '../equip-inspect-result/components/InspectEntryPad';
import {
  loadInspector, loadScope, saveInspector, saveScope,
  type InspectHistoryRow, type Inspector, type Scope,
} from '../equip-inspect-result/_lib/inspect';
import ModelPickerModal from '../equip-work-result-free/components/ModelPickerModal';
import type { FreeRunRow, ModelRow } from '../equip-work-result-free/_lib/types';

const MODEL_KEY = 'oee:equip-inspect-result-free:model';

function loadModel(): ModelRow | null {
  try {
    const raw = localStorage.getItem(MODEL_KEY);
    const m = raw ? (JSON.parse(raw) as ModelRow) : null;
    return m?.modelName && m.itemCode ? m : null;
  } catch { return null; }
}
function saveModel(m: ModelRow) {
  try { localStorage.setItem(MODEL_KEY, JSON.stringify(m)); } catch { /* 저장 실패 무시 */ }
}

function errorMessage(e: unknown, fallback: string) {
  return (e && typeof e === 'object' && 'response' in e
    ? (e as { response?: { data?: { message?: string } } }).response?.data?.message
    : undefined) || fallback;
}

/** 우측 레일 버튼 */
function RailButton({ icon, label, onClick, disabled, tone, sub }: {
  icon: React.ReactNode; label: string; onClick?: () => void; disabled?: boolean; tone?: 'danger' | 'danger-on'; sub?: string;
}) {
  const cls = tone === 'danger-on'
    ? 'bg-red-600 border-red-600 text-white'
    : tone === 'danger' ? 'bg-surface border-slate-400 dark:border-slate-500 shadow-sm text-red-600 hover:border-red-500' : 'bg-surface border-slate-400 dark:border-slate-500 shadow-sm text-text hover:border-primary';
  return (
    <button type="button" onClick={onClick} disabled={disabled}
      className={`flex-1 min-h-[76px] rounded-xl border flex flex-col items-center justify-center gap-1.5 text-[15px] font-semibold transition-colors disabled:opacity-40 disabled:cursor-not-allowed ${cls}`}>
      {icon}{label}{sub && <span className="text-[11px] font-medium opacity-80">{sub}</span>}
    </button>
  );
}

export default function EquipInspectResultFreePage() {
  const [lines, setLines] = useState<OpsLine[]>([]);
  const [machines, setMachines] = useState<OpsMachine[]>([]);
  const [badReasons, setBadReasons] = useState<BadReason[]>([]);
  const [scope, setScope] = useState<Scope | null>(null);
  const [inspector, setInspector] = useState<Inspector | null>(null);
  const [model, setModel] = useState<ModelRow | null>(null);
  const [freeRuns, setFreeRuns] = useState<FreeRunRow[]>([]);
  const [history, setHistory] = useState<InspectHistoryRow[]>([]);
  const [now, setNow] = useState(() => new Date());
  const [booted, setBooted] = useState(false);

  const [scopeOpen, setScopeOpen] = useState(false);
  const [modelOpen, setModelOpen] = useState(false);
  const [inspectorOpen, setInspectorOpen] = useState(false);
  const [inspectorNotice, setInspectorNotice] = useState<string | null>(null);
  const [stopOpen, setStopOpen] = useState(false);

  useEffect(() => {
    const t = setInterval(() => setNow(new Date()), 60_000);
    return () => clearInterval(t);
  }, []);

  const loadMachines = useCallback(async () => {
    try {
      const res = await api.get('/oee/equip-ops/machines', { params: { downtimeTarget: 'Y' } });
      setMachines(res.data?.data?.list ?? []);
    } catch { toast.error('설비 목록 조회에 실패했습니다'); }
  }, []);

  const loadLines = useCallback(async () => {
    try {
      const res = await api.get('/oee/equip-ops/lines');
      setLines(res.data?.data?.list ?? []);
    } catch { toast.error('라인 목록 조회에 실패했습니다'); }
  }, []);

  useEffect(() => {
    void (async () => {
      await loadLines();
      try {
        const res = await api.get('/oee/work-result/bad-reasons');
        // OK 는 양품 표시 코드라 불합격 원인에서 뺀다
        setBadReasons(((res.data?.data?.list ?? []) as BadReason[]).filter((r) => r.code !== 'OK'));
      } catch { toast.error('불량원인 목록 조회에 실패했습니다'); }
      await loadMachines();
      const saved = loadScope();
      setScope(saved);
      setInspector(loadInspector());
      setModel(loadModel());
      if (!saved) setScopeOpen(true);
      setBooted(true);
    })();
  }, [loadLines, loadMachines]);

  useEffect(() => {
    if (!scopeOpen) return;
    if (!lines.length) void loadLines();
    if (!machines.length) void loadMachines();
  }, [scopeOpen, lines.length, machines.length, loadLines, loadMachines]);

  const machine = useMemo(() => machines.find((m) => m.machineCode === scope?.machineCode) ?? null, [machines, scope]);
  const line = useMemo(() => lines.find((l) => l.lineCode === scope?.lineCode) ?? null, [lines, scope]);
  const workstageCode = machine?.workstageCode ?? scope?.workstageCode ?? '';

  /** 오늘 만들어진 지시(라인·공정 기준)를 다시 읽는다 */
  const loadRuns = useCallback(async () => {
    if (!scope?.lineCode || !workstageCode) { setFreeRuns([]); return [] as FreeRunRow[]; }
    try {
      const res = await api.get('/oee/inspect-result-free/runs', { params: { lineCode: scope.lineCode, workstageCode } });
      const list = (res.data?.data?.list ?? []) as FreeRunRow[];
      setFreeRuns(list);
      return list;
    } catch { return [] as FreeRunRow[]; }
  }, [scope?.lineCode, workstageCode]);

  const currentRun = useMemo(
    () => (model ? freeRuns.find((r) => r.modelName === model.modelName && r.itemCode === model.itemCode) ?? null : null),
    [freeRuns, model],
  );

  /** InspectStatus 가 쓰는 작업지시 형태로 맞춘다 — 계획 연결·CT 는 없다 */
  const run: RunRow | null = useMemo(() => {
    if (!currentRun || !model) return null;
    return {
      runNo: currentRun.runNo, workOrderNo: null,
      machineCode: machine?.machineCode ?? null, machineName: machine?.machineName ?? null,
      workstageCode: workstageCode || null, workstageName: machine?.workstageName ?? null, workstageGroup: null,
      runDate: businessDate(now), lineCode: scope?.lineCode ?? null, shiftCode: 'A',
      itemCode: model.itemCode, revision: model.revision, modelName: model.modelName, itemName: null,
      unit: null, itemClass: null, carModel: null, ct: null,
      planQty: currentRun.planQty, resultQty: currentRun.resultQty, defectQty: 0, openDowntime: 0,
      resultCount: history.filter((h) => h.resultStatus !== 'CANCEL').length, wipCount: 0,
    };
  }, [currentRun, model, machine, workstageCode, scope?.lineCode, now, history]);

  const loadHistory = useCallback(async (runNo: string) => {
    try {
      const res = await api.get('/oee/inspect-result/results', { params: { runNo } });
      setHistory(res.data?.data?.list ?? []);
    } catch { setHistory([]); }
  }, []);

  // 범위가 정해지면 오늘 지시를 읽는다
  useEffect(() => { if (booted) void loadRuns(); }, [booted, loadRuns]);
  // 고른 모델의 오늘 지시가 있으면 이력을 읽는다
  useEffect(() => {
    if (currentRun?.runNo) void loadHistory(currentRun.runNo);
    else setHistory([]);
  }, [currentRun?.runNo, loadHistory]);

  const refresh = useCallback(async () => {
    const list = await loadRuns();
    const found = model ? list.find((r) => r.modelName === model.modelName && r.itemCode === model.itemCode) : null;
    if (found) await loadHistory(found.runNo);
  }, [loadRuns, loadHistory, model]);

  function confirmScope(next: Scope) {
    const changed = next.lineCode !== scope?.lineCode || next.workstageCode !== scope?.workstageCode;
    setScope(next); saveScope(next); setScopeOpen(false);
    if (changed && !model) setModelOpen(true);
  }

  function selectModel(m: ModelRow) {
    setModel(m); saveModel(m); setModelOpen(false);
  }

  function selectInspector(w: Inspector) {
    setInspector(w); setInspectorOpen(false); saveInspector(w);
  }

  /** 입력이 막힌 상태에서 누르면, 막힌 이유에 맞는 선택 창을 연다 */
  function guideBlocked() {
    if (!scope || !machine) { toast('라인·공정·설비를 먼저 선택하세요'); setScopeOpen(true); return; }
    if (!machine.workstageCode) { toast.error('설비에 공정이 지정되지 않아 검사실적을 저장할 수 없습니다'); return; }
    if (!model) { toast('모델을 먼저 선택하세요'); setModelOpen(true); return; }
    if (!inspector) { setInspectorNotice('검사실적을 넣으려면 검사자를 먼저 선택하세요.'); setInspectorOpen(true); }
  }

  const entryBlocked = !scope ? '라인·공정·설비를 먼저 선택하세요'
    : !machine ? '선택한 설비를 찾을 수 없습니다. 라인선택에서 다시 고르세요'
    : !machine.workstageCode ? '설비에 공정이 지정되지 않아 검사실적을 저장할 수 없습니다'
    : !model ? '모델을 먼저 선택하세요'
    : !inspector ? '검사자를 먼저 선택하세요'
    : null;

  async function saveInspect(v: { verdict: 'P' | 'R'; qty: number; badReasonCode: string | null }) {
    if (!scope || !machine || !model || !inspector) return false;
    try {
      await api.post('/oee/inspect-result-free/results', {
        lineCode: scope.lineCode, machineCode: machine.machineCode,
        modelName: model.modelName, itemCode: model.itemCode,
        inspectResult: v.verdict, inspectQty: v.qty,
        badReasonCode: v.badReasonCode ?? undefined, inspectorName: inspector.name,
      }, { skipSuccessToast: true });
      toast.success(`${v.verdict === 'P' ? '합격' : '불합격'} ${v.qty.toLocaleString()} 저장`);
      await refresh();
      return true;
    } catch (e: unknown) {
      toast.error(errorMessage(e, '검사실적 저장에 실패했습니다'));
      return false;
    }
  }

  const cancelInspect = useCallback(async (h: InspectHistoryRow) => {
    if (!currentRun) return;
    try {
      await api.post('/oee/inspect-result-free/results/cancel', { runNo: currentRun.runNo, seqNo: h.seqNo }, { skipSuccessToast: true });
      toast.success(`검사실적 ${h.inspectQty.toLocaleString()} 취소`);
      await refresh();
    } catch (e: unknown) {
      toast.error(errorMessage(e, '검사실적 취소에 실패했습니다'));
    }
  }, [currentRun, refresh]);

  const stopped = !!machine?.openDtSeq;

  return (
    <div className="h-full flex flex-col overflow-hidden p-4 gap-3 animate-fade-in">
      {/* 상단 띠 */}
      <div className="flex-shrink-0 flex flex-wrap items-center gap-x-5 gap-y-2 rounded-xl border-2 border-slate-400 dark:border-slate-500 bg-surface shadow-md px-4 py-2.5">
        <ScopeItem label="라인" value={scope ? lineLabel(line, scope.lineCode) : '-'} />
        <Divider />
        <ScopeItem label="공정" value={machine?.workstageName ?? machine?.workstageCode ?? '-'} />
        <Divider />
        <ScopeItem label="설비" value={machine?.machineName ?? scope?.machineCode ?? '-'} sub={machine?.machineCode} />
        <Divider />
        <button type="button" onClick={() => setModelOpen(true)} disabled={!scope}
          className="flex items-center gap-3 rounded-lg border border-border bg-background px-3 py-1 hover:border-primary disabled:opacity-40">
          <span className="text-left">
            <span className="block text-[11px] text-text-muted">모델</span>
            <span className={`block max-w-[16rem] truncate text-base font-bold ${model ? 'text-text' : 'text-red-600'}`}>{model?.modelName ?? '선택 필요'}</span>
          </span>
          <span className="text-xs font-semibold text-primary">변경</span>
        </button>
        <button type="button" onClick={() => { setInspectorNotice(null); setInspectorOpen(true); }}
          className="flex items-center gap-3 rounded-lg border border-border bg-background px-3 py-1 hover:border-primary">
          <span className="text-left">
            <span className="block text-[11px] text-text-muted">검사자</span>
            <span className={`block text-base font-bold ${inspector ? 'text-text' : 'text-red-600'}`}>{inspector?.name ?? '선택 필요'}</span>
          </span>
          <span className="text-xs font-semibold text-primary">변경</span>
        </button>
        {machine && (
          <span className={`ml-auto inline-flex items-center gap-2 rounded-full px-3 py-1.5 text-sm font-bold ${
            stopped ? 'bg-red-500/15 text-red-600 dark:text-red-400' : 'bg-emerald-500/15 text-emerald-600 dark:text-emerald-400'
          }`}>
            <span className={`w-2.5 h-2.5 rounded-full bg-current ${stopped ? 'motion-safe:animate-pulse' : ''}`} />
            {stopped ? `정지 중${machine.openReasonCode ? ` · ${machine.openReasonCode}` : ''}` : '가동중'}
          </span>
        )}
      </div>

      {/* 본문: 검사 현황 · 검사실적 입력 · 레일 */}
      <div className="flex-1 min-h-0 flex gap-3">
        {run ? (
          <InspectStatus run={run} history={history} onCancel={cancelInspect} />
        ) : (
          <section className="flex-1 min-h-0 rounded-xl border border-dashed border-slate-400 dark:border-slate-500 bg-surface flex flex-col items-center justify-center gap-3 text-text-muted">
            <ClipboardList className="w-10 h-10" />
            <p className="text-sm">
              {!scope ? '라인·공정·설비를 먼저 선택하세요.'
                : !model ? '모델을 선택하세요.'
                : '오늘 이 모델의 검사실적이 아직 없습니다. 첫 검사실적을 저장하면 계획이 만들어집니다.'}
            </p>
            {(!scope || !model) && (
              <button type="button" onClick={() => (scope ? setModelOpen(true) : setScopeOpen(true))}
                className="h-11 px-5 rounded-lg bg-primary text-white font-semibold hover:bg-primary/90">
                {scope ? '모델 선택' : '라인 선택'}
              </button>
            )}
          </section>
        )}

        {/* 입력판 + 그 아래 비가동 이력 */}
        <div className="w-[300px] flex-shrink-0 min-h-0 flex flex-col gap-3 overflow-y-auto">
          <InspectEntryPad disabledReason={entryBlocked} badReasons={badReasons}
            subtitle={[machine?.machineCode, model?.modelName].filter(Boolean).join(' · ')}
            onSave={saveInspect} onBlocked={guideBlocked} />
          <EquipDowntimeHistory machineCode={machine?.machineCode ?? ''} refreshKey={machine?.openDtSeq ?? null} />
        </div>

        <nav className="w-[140px] flex-shrink-0 flex flex-col gap-2.5" aria-label="작업">
          <RailButton icon={<Factory className="w-6 h-6" />} label="라인선택" onClick={() => setScopeOpen(true)} />
          <RailButton icon={<Layers className="w-6 h-6" />} label="모델선택" onClick={() => setModelOpen(true)} disabled={!scope} />
          <RailButton icon={stopped ? <PlayCircle className="w-6 h-6" /> : <PauseCircle className="w-6 h-6" />}
            label={stopped ? '정지 해제' : '설비정지'} tone={stopped ? 'danger-on' : 'danger'}
            onClick={() => setStopOpen(true)} disabled={!machine} />
          <RailButton icon={<BellRing className="w-6 h-6" />} label="관리자호출" sub="준비 중" disabled />
        </nav>
      </div>

      <InspectScopeModal isOpen={scopeOpen} onClose={() => setScopeOpen(false)} lines={lines} machines={machines}
        value={scope} onConfirm={confirmScope} />
      <ModelPickerModal isOpen={modelOpen} onClose={() => setModelOpen(false)} selected={model} onSelect={selectModel} />
      <WorkerModal isOpen={inspectorOpen} onClose={() => setInspectorOpen(false)} value={inspector} onSelect={selectInspector} notice={inspectorNotice} />

      <Modal isOpen={stopOpen && !!machine} onClose={() => setStopOpen(false)} size="2xl" bodyMaxHeightClass="max-h-[85vh]"
        title={<span>{stopped ? '설비 정지 해제' : '설비 정지'} <span className="ml-2 font-mono text-base text-text-muted">{machine?.machineCode}</span></span>}
        headerActions={
          <button type="button" onClick={() => setStopOpen(false)}
            className="h-9 px-4 rounded-lg border border-border text-sm font-medium text-text hover:bg-surface">닫기</button>
        }>
        {machine && (
          <EquipDowntimePanel
            key={machine.machineCode}
            machine={{ machineCode: machine.machineCode, machineName: machine.machineName ?? '', workstageCode: machine.workstageCode ?? '' }}
            runNo={currentRun?.runNo ?? null}
            hideHistory
            onChanged={async () => { await loadMachines(); setStopOpen(false); }}
          />
        )}
      </Modal>
    </div>
  );
}

/** 상단 띠 항목 — 넘치면 말줄임, 전체는 툴팁 */
function ScopeItem({ label, value, sub }: { label: string; value: string; sub?: string | null }) {
  return (
    <div className="w-44 flex-shrink-0 min-w-0" title={sub ? `${value} · ${sub}` : value}>
      <div className="text-[11px] text-text-muted">{label}</div>
      <div className="text-base font-bold text-text truncate">
        {value}{sub && <span className="ml-1.5 font-mono text-xs font-normal text-text-muted">{sub}</span>}
      </div>
    </div>
  );
}

function Divider() {
  return <span className="w-px self-stretch bg-border" aria-hidden />;
}
