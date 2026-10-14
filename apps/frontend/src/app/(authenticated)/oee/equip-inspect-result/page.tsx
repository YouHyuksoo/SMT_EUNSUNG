'use client';

/**
 * @file (authenticated)/oee/equip-inspect-result/page.tsx
 * @description 설비별 검사실적관리(현장 단말) — 검사설비 앞 PC 에서 작업지시별 판정(합격/불합격)·수량·불량원인을 기록한다.
 *              설비별 작업 실적관리(/oee/equip-work-result)와 같은 구조이고, 생산실적이 아니라 검사실적을 넣는다.
 *
 * 화면 구성:
 *   상단 띠  : 라인 · 공정 · 설비 · 검사자 · 설비 가동상태
 *   중앙     : 검사 현황 — 작업지시 정보 / 검사실적 이력 그리드(최근순, 취소) / 지표 띠
 *   중앙 우측: 검사실적 입력판 — 판정 · 수량 · 불량원인, [검사실적 저장] 한 번으로 확정
 *   우측 레일: 라인선택 · 작업지시 · 설비정지 · 관리자호출(준비 중)
 *
 * 초보자 가이드:
 * 1. 검사실적은 IQ_EQUIP_INSPECT_RESULT 에 따로 쌓는다. 생산실적·작업지시·센서 누적은 바꾸지 않는다.
 * 2. 설비는 검사공정(공정유형 Q) 설비만 고른다. 작업지시는 생산 화면과 같이 조립·가공 라인 작업지시에서 고른다.
 * 3. 라인·설비·작업지시·검사자는 단말기에 기억한다(_lib/inspect.ts, 생산 화면과 다른 키).
 *
 * API(글로벌 prefix /api → 백엔드 /api/v1)
 *   라인/설비·상태: GET /oee/equip-ops/lines, /oee/equip-ops/machines
 *   작업지시: GET /oee/work-result?fromDate&toDate&lineCode&excludeSmt=Y
 *   검사실적: GET /oee/inspect-result/results?runNo · POST /oee/inspect-result/results · POST /results/cancel
 *   불량원인: GET /oee/work-result/bad-reasons (WQC BAD REASON CODE) · 설비정지: components/shared/EquipDowntimePanel
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import { BellRing, ClipboardList, Factory, PauseCircle, PlayCircle } from 'lucide-react';
import toast from 'react-hot-toast';
import { Modal } from '@/components/ui';
import EquipDowntimePanel from '@/components/shared/EquipDowntimePanel';
import api from '@/services/api';
import type { OpsLine, OpsMachine } from '../equip-ops-status/types';
import RunPickerModal from '../equip-work-result/components/RunPickerModal';
import WorkerModal from '../equip-work-result/components/WorkerModal';
import { lineLabel } from '../equip-work-result/_lib/scope';
import { businessDate } from '../equip-work-result/_lib/kpi';
import type { RunRow } from '../equip-work-result/_lib/types';
import InspectScopeModal from './components/InspectScopeModal';
import InspectStatus from './components/InspectStatus';
import InspectEntryPad, { type BadReason } from './components/InspectEntryPad';
import {
  loadInspector, loadRunNo, loadScope, saveInspector, saveRunNo, saveScope,
  type InspectHistoryRow, type Inspector, type Scope,
} from './_lib/inspect';

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

export default function EquipInspectResultPage() {
  const [lines, setLines] = useState<OpsLine[]>([]);
  const [machines, setMachines] = useState<OpsMachine[]>([]);
  const [badReasons, setBadReasons] = useState<BadReason[]>([]);
  const [scope, setScope] = useState<Scope | null>(null);
  const [inspector, setInspector] = useState<Inspector | null>(null);
  const [run, setRun] = useState<RunRow | null>(null);
  const [history, setHistory] = useState<InspectHistoryRow[]>([]);
  const [booted, setBooted] = useState(false);

  const [scopeOpen, setScopeOpen] = useState(false);
  const [runOpen, setRunOpen] = useState(false);
  const [inspectorOpen, setInspectorOpen] = useState(false);
  const [inspectorNotice, setInspectorNotice] = useState<string | null>(null);
  const [stopOpen, setStopOpen] = useState(false);

  const loadMachines = useCallback(async () => {
    try {
      const res = await api.get('/oee/equip-ops/machines');
      setMachines(res.data?.data?.list ?? []);
    } catch { toast.error('설비 목록 조회에 실패했습니다'); }
  }, []);

  const loadLines = useCallback(async () => {
    try {
      const res = await api.get('/oee/equip-ops/lines');
      setLines(res.data?.data?.list ?? []);
    } catch { toast.error('라인 목록 조회에 실패했습니다'); }
  }, []);

  // 진입: 라인·설비·불량원인 목록을 읽고 기억한 선택을 되살린다. 없으면 라인선택 창을 연다.
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
      if (!saved) setScopeOpen(true);
      setBooted(true);
    })();
  }, [loadLines, loadMachines]);

  // 라인선택 창을 열 때 목록이 비어 있으면 다시 읽는다 — 진입 때 조회가 실패(서버 지연 등)하면 빈 창만 뜬다
  useEffect(() => {
    if (!scopeOpen) return;
    if (!lines.length) void loadLines();
    if (!machines.length) void loadMachines();
  }, [scopeOpen, lines.length, machines.length, loadLines, loadMachines]);

  const machine = useMemo(() => machines.find((m) => m.machineCode === scope?.machineCode) ?? null, [machines, scope]);
  const line = useMemo(() => lines.find((l) => l.lineCode === scope?.lineCode) ?? null, [lines, scope]);

  /** 작업지시 한 건을 다시 읽는다(작업지시 수량·생산 실적 갱신) */
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
      const res = await api.get('/oee/inspect-result/results', { params: { runNo } });
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

  function confirmScope(next: Scope) {
    const lineChanged = next.lineCode !== scope?.lineCode;
    setScope(next); saveScope(next); setScopeOpen(false);
    if (lineChanged) { setRun(null); setHistory([]); saveRunNo(null); setRunOpen(true); }
  }

  async function selectRun(r: RunRow) {
    setRun(r); saveRunNo(r.runNo); setRunOpen(false);
    await loadHistory(r.runNo);
  }

  function selectInspector(w: Inspector) {
    setInspector(w); setInspectorOpen(false); saveInspector(w);
  }

  /** 입력이 막힌 상태에서 누르면, 막힌 이유에 맞는 선택 창을 연다 */
  function guideBlocked() {
    if (!scope || !machine) { toast('라인·공정·설비를 먼저 선택하세요'); setScopeOpen(true); return; }
    if (!machine.workstageCode) { toast.error('설비에 공정이 지정되지 않아 검사실적을 저장할 수 없습니다'); return; }
    if (!run) { toast('작업지시를 먼저 선택하세요'); setRunOpen(true); return; }
    if (!inspector) { setInspectorNotice('검사실적을 넣으려면 검사자를 먼저 선택하세요.'); setInspectorOpen(true); }
  }

  const entryBlocked = !scope ? '라인·공정·설비를 먼저 선택하세요'
    : !machine ? '선택한 설비를 찾을 수 없습니다. 라인선택에서 다시 고르세요'
    : !machine.workstageCode ? '설비에 공정이 지정되지 않아 검사실적을 저장할 수 없습니다'
    : !run ? '작업지시를 먼저 선택하세요'
    : !inspector ? '검사자를 먼저 선택하세요'
    : null;

  async function saveInspect(v: { verdict: 'P' | 'R'; qty: number; badReasonCode: string | null }) {
    if (!run || !machine || !inspector) return false;
    try {
      await api.post('/oee/inspect-result/results', {
        runNo: run.runNo, machineCode: machine.machineCode, inspectResult: v.verdict, inspectQty: v.qty,
        badReasonCode: v.badReasonCode ?? undefined, inspectorName: inspector.name,
      }, { skipSuccessToast: true });
      toast.success(`${v.verdict === 'P' ? '합격' : '불합격'} ${v.qty.toLocaleString()} 저장`);
      await loadHistory(run.runNo);
      return true;
    } catch (e: unknown) {
      toast.error(errorMessage(e, '검사실적 저장에 실패했습니다'));
      return false;
    }
  }

  const cancelInspect = useCallback(async (h: InspectHistoryRow) => {
    if (!run) return;
    try {
      await api.post('/oee/inspect-result/results/cancel', { runNo: run.runNo, seqNo: h.seqNo }, { skipSuccessToast: true });
      toast.success(`검사실적 ${h.inspectQty.toLocaleString()} 취소`);
      await loadHistory(run.runNo);
    } catch (e: unknown) {
      toast.error(errorMessage(e, '검사실적 취소에 실패했습니다'));
    }
  }, [run, loadHistory]);

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
          <section className="flex-1 min-h-0 rounded-xl border border-dashed border-border bg-surface flex flex-col items-center justify-center gap-3 text-text-muted">
            <ClipboardList className="w-10 h-10" />
            <p className="text-sm">{scope ? '작업지시를 선택하면 검사 현황이 여기에 보입니다.' : '라인·공정·설비를 먼저 선택하세요.'}</p>
            <button type="button" onClick={() => (scope ? setRunOpen(true) : setScopeOpen(true))}
              className="h-11 px-5 rounded-lg bg-primary text-white font-semibold hover:bg-primary/90">
              {scope ? '작업지시 선택' : '라인 선택'}
            </button>
          </section>
        )}

        <InspectEntryPad disabledReason={entryBlocked} badReasons={badReasons}
          subtitle={[machine?.machineCode, run?.runNo].filter(Boolean).join(' · ')}
          onSave={saveInspect} onBlocked={guideBlocked} />

        <nav className="w-[140px] flex-shrink-0 flex flex-col gap-2.5" aria-label="작업">
          <RailButton icon={<Factory className="w-6 h-6" />} label="라인선택" onClick={() => setScopeOpen(true)} />
          <RailButton icon={<ClipboardList className="w-6 h-6" />} label="작업지시" onClick={() => setRunOpen(true)} disabled={!scope} />
          <RailButton icon={stopped ? <PlayCircle className="w-6 h-6" /> : <PauseCircle className="w-6 h-6" />}
            label={stopped ? '정지 해제' : '설비정지'} tone={stopped ? 'danger-on' : 'danger'}
            onClick={() => setStopOpen(true)} disabled={!machine} />
          <RailButton icon={<BellRing className="w-6 h-6" />} label="관리자호출" sub="준비 중" disabled />
        </nav>
      </div>

      <InspectScopeModal isOpen={scopeOpen} onClose={() => setScopeOpen(false)} lines={lines} machines={machines}
        value={scope} onConfirm={confirmScope} />
      <RunPickerModal isOpen={runOpen} onClose={() => setRunOpen(false)} lineCode={scope?.lineCode ?? ''}
        lineName={scope ? lineLabel(line, scope.lineCode) : ''} selectedRunNo={run?.runNo ?? null} onSelect={(r) => void selectRun(r)} />
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
