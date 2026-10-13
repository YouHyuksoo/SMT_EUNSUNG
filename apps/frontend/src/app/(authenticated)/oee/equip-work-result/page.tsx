'use client';

/**
 * @file (authenticated)/oee/equip-work-result/page.tsx
 * @description 설비별 작업 실적관리(현장 단말) — 설비 앞 PC 에서 실적·불량·설비정지를 최소 터치로 기록한다.
 *
 * 화면 구성:
 *   상단 띠  : 라인 · 공정 · 설비 · 작업자 · 설비 가동상태
 *   중앙     : 생산 현황 — 작업지시 정보 / 실적 이력 그리드(최근순, 취소) / 지표 띠
 *   중앙 우측: 실적 입력판 — 숫자패드 상시, [실적 저장] 한 번으로 확정
 *   우측 레일: 라인선택 · 작업지시 · 불량등록 · 설비정지 · 관리자호출(준비 중)
 *
 * 초보자 가이드:
 * 1. 라인·공정·설비·작업자·작업지시는 단말기(localStorage)에 기억했다가 진입 때 자동 선택한다(_lib/scope.ts).
 * 2. 실적은 항상 확정(DONE)으로 저장한다 → 서버가 센서 누적 프로시저로 생산현황에 바로 반영한다.
 *    잘못 넣은 실적은 이력 그리드에서 취소한다(POST /oee/work-result/results/cancel, 오늘 업무일만).
 * 3. 설비는 고른 설비로 고정한다. 실적의 공정은 설비의 공정이다.
 *
 * API(글로벌 prefix /api → 백엔드 /api/v1)
 *   라인/설비·상태: GET /oee/equip-ops/lines, /oee/equip-ops/machines
 *   작업지시: GET /oee/work-result?fromDate&toDate&lineCode&excludeSmt=Y
 *   실적: GET /oee/work-result/results?runNo · POST /oee/work-result/results · POST /results/cancel
 *   불량: GET/POST /oee/work-result/defect · 설비정지: components/shared/EquipDowntimePanel
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import { AlertTriangle, BellRing, ClipboardList, Factory, PauseCircle, PlayCircle } from 'lucide-react';
import toast from 'react-hot-toast';
import { Modal } from '@/components/ui';
import EquipDowntimePanel from '@/components/shared/EquipDowntimePanel';
import api from '@/services/api';
import { useActiveInterval } from '@/hooks/useTabActive';
import type { OpsLine, OpsMachine } from '../equip-ops-status/types';
import ScopeModal from './components/ScopeModal';
import RunPickerModal from './components/RunPickerModal';
import DefectModal from './components/DefectModal';
import WorkerModal, { type Worker } from './components/WorkerModal';
import ProductionStatus from './components/ProductionStatus';
import EntryPad from './components/EntryPad';
import { lineLabel, loadRunNo, loadScope, saveRunNo, saveScope, type Scope } from './_lib/scope';
import { businessDate } from './_lib/kpi';
import type { ResultHistoryRow, RunRow } from './_lib/types';

const WORKER_KEY = 'oee:equip-work-result:worker';

function loadWorker(): Worker | null {
  try {
    const raw = localStorage.getItem(WORKER_KEY);
    const w = raw ? (JSON.parse(raw) as Worker) : null;
    return w?.code ? w : null;
  } catch { return null; }
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

export default function EquipWorkResultPage() {
  const [lines, setLines] = useState<OpsLine[]>([]);
  const [machines, setMachines] = useState<OpsMachine[]>([]);
  const [scope, setScope] = useState<Scope | null>(null);
  const [worker, setWorker] = useState<Worker | null>(null);
  const [run, setRun] = useState<RunRow | null>(null);
  const [history, setHistory] = useState<ResultHistoryRow[]>([]);
  const [now, setNow] = useState(() => new Date());
  const [booted, setBooted] = useState(false);

  const [scopeOpen, setScopeOpen] = useState(false);
  const [runOpen, setRunOpen] = useState(false);
  const [defectOpen, setDefectOpen] = useState(false);
  const [workerOpen, setWorkerOpen] = useState(false);
  const [workerNotice, setWorkerNotice] = useState<string | null>(null);
  const [stopOpen, setStopOpen] = useState(false);

  // 지표(목표)는 시간에 따라 변한다 — 1분마다 다시 계산. 숨겨진 탭에서는 멈추고 돌아오면 바로 한 번 돈다.
  useActiveInterval(() => setNow(new Date()), 60_000, { catchUp: true });

  const loadMachines = useCallback(async () => {
    try {
      const res = await api.get('/oee/equip-ops/machines');
      setMachines(res.data?.data?.list ?? []);
    } catch { toast.error('설비 목록 조회에 실패했습니다'); }
  }, []);

  // 진입: 라인·설비 목록을 읽고 기억한 선택을 되살린다. 없으면 라인선택 창을 연다.
  useEffect(() => {
    void (async () => {
      try {
        const res = await api.get('/oee/equip-ops/lines');
        setLines(res.data?.data?.list ?? []);
      } catch { /* 빈 목록 */ }
      await loadMachines();
      const saved = loadScope();
      setScope(saved);
      setWorker(loadWorker());
      if (!saved) setScopeOpen(true);
      setBooted(true);
    })();
  }, [loadMachines]);

  const machine = useMemo(() => machines.find((m) => m.machineCode === scope?.machineCode) ?? null, [machines, scope]);
  const line = useMemo(() => lines.find((l) => l.lineCode === scope?.lineCode) ?? null, [lines, scope]);

  /** 작업지시 한 건을 다시 읽는다(실적 합계·불량 갱신) */
  const reloadRun = useCallback(async (runNo: string, lineCode: string | null, runDate: string) => {
    try {
      const res = await api.get('/oee/work-result', { params: { fromDate: runDate, toDate: runDate, lineCode: lineCode ?? undefined, excludeSmt: 'Y' } });
      const found = (res.data?.data?.list as RunRow[] | undefined)?.find((r) => r.runNo === runNo) ?? null;
      setRun(found);
      return found;
    } catch { return null; }
  }, []);

  const loadHistory = useCallback(async (runNo: string) => {
    try {
      const res = await api.get('/oee/work-result/results', { params: { runNo } });
      setHistory(res.data?.data?.list ?? []);
    } catch { setHistory([]); }
  }, []);

  // 범위가 정해지면 오늘 고른 작업지시를 되살린다
  useEffect(() => {
    if (!booted || !scope) return;
    const runNo = loadRunNo();
    if (!runNo) { setRun(null); setHistory([]); return; }
    void (async () => {
      const found = await reloadRun(runNo, scope.lineCode, businessDate(new Date()));
      if (found) await loadHistory(found.runNo);
      else { saveRunNo(null); setHistory([]); }
    })();
  }, [booted, scope, reloadRun, loadHistory]);

  const refresh = useCallback(async () => {
    if (!run || !scope) return;
    await Promise.all([reloadRun(run.runNo, run.lineCode, run.runDate), loadHistory(run.runNo)]);
  }, [run, scope, reloadRun, loadHistory]);

  function confirmScope(next: Scope) {
    const lineChanged = next.lineCode !== scope?.lineCode;
    setScope(next); saveScope(next); setScopeOpen(false);
    if (lineChanged) { setRun(null); setHistory([]); saveRunNo(null); setRunOpen(true); }
  }

  async function selectRun(r: RunRow) {
    setRun(r); saveRunNo(r.runNo); setRunOpen(false);
    await loadHistory(r.runNo);
  }

  function selectWorker(w: Worker) {
    setWorker(w); setWorkerOpen(false);
    try { localStorage.setItem(WORKER_KEY, JSON.stringify(w)); } catch { /* 무시 */ }
  }

  /** 실적 입력이 막힌 상태에서 누르면, 막힌 이유에 맞는 선택 창을 연다 */
  function guideBlocked() {
    if (!scope || !machine) { toast('라인·공정·설비를 먼저 선택하세요'); setScopeOpen(true); return; }
    if (!machine.workstageCode) { toast.error('설비에 공정이 지정되지 않아 실적을 저장할 수 없습니다'); return; }
    if (!run) { toast('작업지시를 먼저 선택하세요'); setRunOpen(true); return; }
    if (!worker) { setWorkerNotice('실적을 넣으려면 작업자를 먼저 선택하세요.'); setWorkerOpen(true); }
  }

  const entryBlocked = !scope ? '라인·공정·설비를 먼저 선택하세요'
    : !machine ? '선택한 설비를 찾을 수 없습니다. 라인선택에서 다시 고르세요'
    : !machine.workstageCode ? '설비에 공정이 지정되지 않아 실적을 저장할 수 없습니다'
    : !run ? '작업지시를 먼저 선택하세요'
    : !worker ? '작업자를 먼저 선택하세요'
    : null;

  async function saveResult(v: { qty: number; time: number; crew: number }) {
    if (!run || !machine || !worker) return false;
    try {
      const res = await api.post('/oee/work-result/results', {
        runNo: run.runNo, machineCode: machine.machineCode, workstageCode: machine.workstageCode,
        resultQty: v.qty, workTime: v.time, workerCount: v.crew, workerName: worker.name, resultStatus: 'DONE',
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
    if (!run) return;
    try {
      const res = await api.post('/oee/work-result/results/cancel', { runNo: run.runNo, seqNo: h.seqNo }, { skipSuccessToast: true });
      const warning = res.data?.data?.sensorWarning as string | undefined;
      if (warning) toast.error(`취소했지만 생산현황 차감에 실패했습니다 — ${warning}`);
      else toast.success(`실적 ${h.resultQty.toLocaleString()} 취소`);
      await refresh();
    } catch (e: unknown) {
      toast.error(errorMessage(e, '실적 취소에 실패했습니다'));
    }
  }, [run, refresh]);

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
            <p className="text-sm">{scope ? '작업지시를 선택하면 생산 현황이 여기에 보입니다.' : '라인·공정·설비를 먼저 선택하세요.'}</p>
            <button type="button" onClick={() => (scope ? setRunOpen(true) : setScopeOpen(true))}
              className="h-11 px-5 rounded-lg bg-primary text-white font-semibold hover:bg-primary/90">
              {scope ? '작업지시 선택' : '라인 선택'}
            </button>
          </section>
        )}

        <EntryPad disabledReason={entryBlocked}
          subtitle={[machine?.machineCode, run?.runNo].filter(Boolean).join(' · ')}
          onSave={saveResult} onBlocked={guideBlocked} />

        <nav className="w-[140px] flex-shrink-0 flex flex-col gap-2.5" aria-label="작업">
          <RailButton icon={<Factory className="w-6 h-6" />} label="라인선택" onClick={() => setScopeOpen(true)} />
          <RailButton icon={<ClipboardList className="w-6 h-6" />} label="작업지시" onClick={() => setRunOpen(true)} disabled={!scope} />
          <RailButton icon={<AlertTriangle className="w-6 h-6" />} label="불량등록" onClick={() => setDefectOpen(true)} disabled={!run} />
          <RailButton icon={stopped ? <PlayCircle className="w-6 h-6" /> : <PauseCircle className="w-6 h-6" />}
            label={stopped ? '정지 해제' : '설비정지'} tone={stopped ? 'danger-on' : 'danger'}
            onClick={() => setStopOpen(true)} disabled={!machine} />
          <RailButton icon={<BellRing className="w-6 h-6" />} label="관리자호출" sub="준비 중" disabled />
        </nav>
      </div>

      <ScopeModal isOpen={scopeOpen} onClose={() => setScopeOpen(false)} lines={lines} machines={machines}
        value={scope} onConfirm={confirmScope} />
      <RunPickerModal isOpen={runOpen} onClose={() => setRunOpen(false)} lineCode={scope?.lineCode ?? ''}
        workstageCode={scope?.workstageCode ?? ''} lineName={scope ? lineLabel(line, scope.lineCode) : ''} selectedRunNo={run?.runNo ?? null} onSelect={(r) => void selectRun(r)} />
      <DefectModal run={defectOpen ? run : null} onClose={() => setDefectOpen(false)}
        onSaved={async () => { setDefectOpen(false); await refresh(); }} />
      <WorkerModal isOpen={workerOpen} onClose={() => setWorkerOpen(false)} value={worker} onSelect={selectWorker} notice={workerNotice} />

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
            runNo={run?.runNo ?? null}
            onChanged={async () => { await loadMachines(); setStopOpen(false); }}
          />
        )}
      </Modal>
    </div>
  );
}

/** 상단 띠 항목 — 라인·공정·설비가 같은 폭을 쓴다(넘치면 말줄임, 전체는 툴팁) */
function ScopeItem({ label, value, sub }: { label: string; value: string; sub?: string | null }) {
  return (
    <div className="w-52 flex-shrink-0 min-w-0" title={sub ? `${value} · ${sub}` : value}>
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
