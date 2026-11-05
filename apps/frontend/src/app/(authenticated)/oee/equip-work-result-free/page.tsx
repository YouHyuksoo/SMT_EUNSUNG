'use client';

/**
 * @file (authenticated)/oee/equip-work-result-free/page.tsx
 * @description 생산실적(계획 없음) — 2층 조립 후공정용. 작업지시(계획)를 고르지 않고 모델만 골라 실적을 넣는다.
 *
 * 초보자 가이드:
 * 1. 라인·공정·설비·작업자·모델은 단말기(localStorage)에 기억한다. 화면 틀은 기존 설비별 작업 실적관리(/oee/equip-work-result)를 그대로 쓴다.
 * 2. 첫 실적을 저장하면 서버가 오늘 업무일의 작업지시(런카드)를 만들고, 계획수량은 실적 합계로 맞춘다.
 *    같은 라인·공정·모델의 다음 실적은 그 지시에 쌓인다. 실적을 취소하면 계획수량도 줄어든다.
 * 3. 제품생산계획에서 내려온 지시는 이 화면이 만들지도 고치지도 않는다.
 *
 * API(글로벌 prefix /api → 백엔드 /api/v1)
 *   타임구간: GET /oee/work-result-free/time-zones (작업시간 관리 WORKTIME A~J) — 실적 저장 때 함께 보낸다
 *   모델: GET /oee/work-result-free/models · 오늘 지시: GET /oee/work-result-free/runs?lineCode&workstageCode
 *   실적: POST /oee/work-result-free/results · POST /oee/work-result-free/results/cancel
 *   이력: GET /oee/work-result/results?runNo · 불량: DefectModal · 설비정지: components/shared/EquipDowntimePanel
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import { AlertTriangle, BellRing, ClipboardList, Factory, Layers, PauseCircle, PlayCircle } from 'lucide-react';
import toast from 'react-hot-toast';
import { Modal } from '@/components/ui';
import EquipDowntimePanel from '@/components/shared/EquipDowntimePanel';
import api from '@/services/api';
import { useActiveInterval } from '@/hooks/useTabActive';
import type { OpsLine, OpsMachine } from '../equip-ops-status/types';
import ScopeModal from '../equip-work-result/components/ScopeModal';
import DefectModal from '../equip-work-result/components/DefectModal';
import WorkerModal, { type Worker } from '../equip-work-result/components/WorkerModal';
import ProductionStatus from '../equip-work-result/components/ProductionStatus';
import EntryPad from '../equip-work-result/components/EntryPad';
import { lineLabel, type Scope } from '../equip-work-result/_lib/scope';
import { businessDate } from '../equip-work-result/_lib/kpi';
import type { ResultHistoryRow, RunRow } from '../equip-work-result/_lib/types';
import ModelPickerModal from './components/ModelPickerModal';
import TimeZonePicker from './components/TimeZonePicker';
import type { FreeRunRow, ModelRow, TimeZoneRow } from './_lib/types';

const SCOPE_KEY = 'oee:equip-work-result-free:scope';
const WORKER_KEY = 'oee:equip-work-result-free:worker';
const MODEL_KEY = 'oee:equip-work-result-free:model';

function readJson<T>(key: string): T | null {
  try {
    const raw = localStorage.getItem(key);
    return raw ? (JSON.parse(raw) as T) : null;
  } catch { return null; }
}
function writeJson(key: string, value: unknown) {
  try { localStorage.setItem(key, JSON.stringify(value)); } catch { /* 저장 실패 무시 */ }
}

function loadScope(): Scope | null {
  const s = readJson<Partial<Scope>>(SCOPE_KEY);
  return s?.lineCode && s.machineCode ? { lineCode: s.lineCode, workstageCode: s.workstageCode ?? '', machineCode: s.machineCode } : null;
}
function loadWorker(): Worker | null {
  const w = readJson<Worker>(WORKER_KEY);
  return w?.code ? w : null;
}
function loadModel(): ModelRow | null {
  const m = readJson<ModelRow>(MODEL_KEY);
  return m?.modelName && m.itemCode ? m : null;
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
    : tone === 'danger' ? 'bg-surface border-border text-red-600 hover:border-red-500' : 'bg-surface border-border text-text hover:border-primary';
  return (
    <button type="button" onClick={onClick} disabled={disabled}
      className={`flex-1 min-h-[76px] rounded-xl border flex flex-col items-center justify-center gap-1.5 text-[15px] font-semibold transition-colors disabled:opacity-40 disabled:cursor-not-allowed ${cls}`}>
      {icon}{label}{sub && <span className="text-[11px] font-medium opacity-80">{sub}</span>}
    </button>
  );
}

export default function EquipWorkResultFreePage() {
  const [lines, setLines] = useState<OpsLine[]>([]);
  const [machines, setMachines] = useState<OpsMachine[]>([]);
  const [scope, setScope] = useState<Scope | null>(null);
  const [worker, setWorker] = useState<Worker | null>(null);
  const [model, setModel] = useState<ModelRow | null>(null);
  const [freeRuns, setFreeRuns] = useState<FreeRunRow[]>([]);
  const [history, setHistory] = useState<ResultHistoryRow[]>([]);
  const [zones, setZones] = useState<TimeZoneRow[]>([]);
  const [currentZone, setCurrentZone] = useState<string | null>(null);
  const [timeZone, setTimeZone] = useState<string | null>(null);
  const [now, setNow] = useState(() => new Date());
  const [booted, setBooted] = useState(false);

  const [scopeOpen, setScopeOpen] = useState(false);
  const [modelOpen, setModelOpen] = useState(false);
  const [defectOpen, setDefectOpen] = useState(false);
  const [workerOpen, setWorkerOpen] = useState(false);
  const [workerNotice, setWorkerNotice] = useState<string | null>(null);
  const [stopOpen, setStopOpen] = useState(false);

  useActiveInterval(() => setNow(new Date()), 60_000, { catchUp: true });

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

  // 타임구간(작업시간 관리) — 처음에는 지금 시각이 속한 구간을 고른다
  const loadZones = useCallback(async () => {
    try {
      const res = await api.get('/oee/work-result-free/time-zones');
      const d = res.data?.data as { list?: TimeZoneRow[]; current?: string | null } | undefined;
      setZones(d?.list ?? []);
      setCurrentZone(d?.current ?? null);
      setTimeZone((prev) => prev ?? d?.current ?? null);
    } catch { toast.error('타임구간 조회에 실패했습니다'); }
  }, []);

  useEffect(() => {
    void (async () => {
      await loadZones();
      await loadLines();
      await loadMachines();
      const saved = loadScope();
      setScope(saved);
      setWorker(loadWorker());
      setModel(loadModel());
      if (!saved) setScopeOpen(true);
      setBooted(true);
    })();
  }, [loadZones, loadLines, loadMachines]);

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
      const res = await api.get('/oee/work-result-free/runs', { params: { lineCode: scope.lineCode, workstageCode } });
      const list = (res.data?.data?.list ?? []) as FreeRunRow[];
      setFreeRuns(list);
      return list;
    } catch { return [] as FreeRunRow[]; }
  }, [scope?.lineCode, workstageCode]);

  const currentRun = useMemo(
    () => (model ? freeRuns.find((r) => r.modelName === model.modelName && r.itemCode === model.itemCode) ?? null : null),
    [freeRuns, model],
  );

  /** ProductionStatus 가 쓰는 작업지시 형태로 맞춘다 — 계획 연결·CT 는 없다 */
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
      const res = await api.get('/oee/work-result/results', { params: { runNo } });
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
    setScope(next); writeJson(SCOPE_KEY, next); setScopeOpen(false);
    if (changed && !model) setModelOpen(true);
  }

  function selectModel(m: ModelRow) {
    setModel(m); writeJson(MODEL_KEY, m); setModelOpen(false);
  }

  function selectWorker(w: Worker) {
    setWorker(w); setWorkerOpen(false); writeJson(WORKER_KEY, w);
  }

  function guideBlocked() {
    if (!scope || !machine) { toast('라인·공정·설비를 먼저 선택하세요'); setScopeOpen(true); return; }
    if (!machine.workstageCode) { toast.error('설비에 공정이 지정되지 않아 실적을 저장할 수 없습니다'); return; }
    if (!model) { toast('모델을 먼저 선택하세요'); setModelOpen(true); return; }
    if (!worker) { setWorkerNotice('실적을 넣으려면 작업자를 먼저 선택하세요.'); setWorkerOpen(true); return; }
    if (!timeZone) { toast('타임구간을 선택하세요'); void loadZones(); }
  }

  const entryBlocked = !scope ? '라인·공정·설비를 먼저 선택하세요'
    : !machine ? '선택한 설비를 찾을 수 없습니다. 라인선택에서 다시 고르세요'
    : !machine.workstageCode ? '설비에 공정이 지정되지 않아 실적을 저장할 수 없습니다'
    : !model ? '모델을 먼저 선택하세요'
    : !worker ? '작업자를 먼저 선택하세요'
    : !timeZone ? '타임구간을 선택하세요'
    : null;

  async function saveResult(v: { qty: number; time: number; crew: number }) {
    if (!scope || !machine || !model || !worker || !timeZone) return false;
    try {
      const res = await api.post('/oee/work-result-free/results', {
        lineCode: scope.lineCode, workstageCode: machine.workstageCode, machineCode: machine.machineCode,
        modelName: model.modelName, itemCode: model.itemCode, timeZone,
        resultQty: v.qty, workTime: v.time, workerCount: v.crew, workerName: worker.name,
      }, { skipSuccessToast: true });
      const warning = res.data?.data?.sensorWarning as string | undefined;
      if (warning) toast.error(`실적은 저장됐지만 생산현황 반영에 실패했습니다 — ${warning}`);
      else toast.success(`실적 ${v.qty.toLocaleString()} 저장`);
      await refresh();
      return true;
    } catch (e: unknown) {
      toast.error(errorMessage(e, '실적 저장에 실패했습니다'));
      return false;
    }
  }

  const cancelResult = useCallback(async (h: ResultHistoryRow) => {
    if (!currentRun) return;
    try {
      const res = await api.post('/oee/work-result-free/results/cancel', { runNo: currentRun.runNo, seqNo: h.seqNo }, { skipSuccessToast: true });
      const warning = res.data?.data?.sensorWarning as string | undefined;
      if (warning) toast.error(`취소했지만 생산현황 차감에 실패했습니다 — ${warning}`);
      else toast.success(`실적 ${h.resultQty.toLocaleString()} 취소`);
      await refresh();
    } catch (e: unknown) {
      toast.error(errorMessage(e, '실적 취소에 실패했습니다'));
    }
  }, [currentRun, refresh]);

  const stopped = !!machine?.openDtSeq;

  return (
    <div className="h-full flex flex-col overflow-hidden p-4 gap-3 animate-fade-in">
      {/* 상단 띠 */}
      <div className="flex-shrink-0 flex flex-wrap items-center gap-x-5 gap-y-2 rounded-xl border border-border bg-surface px-4 py-2.5">
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
        <button type="button" onClick={() => { setWorkerNotice(null); setWorkerOpen(true); }}
          className="flex items-center gap-3 rounded-lg border border-border bg-background px-3 py-1 hover:border-primary">
          <span className="text-left">
            <span className="block text-[11px] text-text-muted">작업자</span>
            <span className={`block text-base font-bold ${worker ? 'text-text' : 'text-red-600'}`}>{worker?.name ?? '선택 필요'}</span>
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

      {/* 본문: 생산 현황 · 실적 입력 · 레일 */}
      <div className="flex-1 min-h-0 flex gap-3">
        {run ? (
          <ProductionStatus run={run} history={history} now={now} onCancel={cancelResult} />
        ) : (
          <section className="flex-1 min-h-0 rounded-xl border border-dashed border-border bg-surface flex flex-col items-center justify-center gap-3 text-text-muted">
            <ClipboardList className="w-10 h-10" />
            <p className="text-sm">
              {!scope ? '라인·공정·설비를 먼저 선택하세요.'
                : !model ? '모델을 선택하세요.'
                : '오늘 이 모델의 실적이 아직 없습니다. 첫 실적을 저장하면 계획이 만들어집니다.'}
            </p>
            {(!scope || !model) && (
              <button type="button" onClick={() => (scope ? setModelOpen(true) : setScopeOpen(true))}
                className="h-11 px-5 rounded-lg bg-primary text-white font-semibold hover:bg-primary/90">
                {scope ? '모델 선택' : '라인 선택'}
              </button>
            )}
          </section>
        )}

        <EntryPad disabledReason={entryBlocked}
          subtitle={[machine?.machineCode, model?.modelName].filter(Boolean).join(' · ')}
          onSave={saveResult} onBlocked={guideBlocked}
          extra={<TimeZonePicker zones={zones} value={timeZone} current={currentZone} onChange={setTimeZone} />} />

        <nav className="w-[140px] flex-shrink-0 flex flex-col gap-2.5" aria-label="작업">
          <RailButton icon={<Factory className="w-6 h-6" />} label="라인선택" onClick={() => setScopeOpen(true)} />
          <RailButton icon={<Layers className="w-6 h-6" />} label="모델선택" onClick={() => setModelOpen(true)} disabled={!scope} />
          <RailButton icon={<AlertTriangle className="w-6 h-6" />} label="불량등록" onClick={() => setDefectOpen(true)} disabled={!run} />
          <RailButton icon={stopped ? <PlayCircle className="w-6 h-6" /> : <PauseCircle className="w-6 h-6" />}
            label={stopped ? '정지 해제' : '설비정지'} tone={stopped ? 'danger-on' : 'danger'}
            onClick={() => setStopOpen(true)} disabled={!machine} />
          <RailButton icon={<BellRing className="w-6 h-6" />} label="관리자호출" sub="준비 중" disabled />
        </nav>
      </div>

      <ScopeModal isOpen={scopeOpen} onClose={() => setScopeOpen(false)} lines={lines} machines={machines}
        value={scope} onConfirm={confirmScope} />
      <ModelPickerModal isOpen={modelOpen} onClose={() => setModelOpen(false)} selected={model} onSelect={selectModel} />
      <DefectModal run={defectOpen ? run : null} onClose={() => setDefectOpen(false)}
        onSaved={async () => { setDefectOpen(false); await refresh(); }} />
      <WorkerModal compact isOpen={workerOpen} onClose={() => setWorkerOpen(false)} value={worker} onSelect={selectWorker} notice={workerNotice} />

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
