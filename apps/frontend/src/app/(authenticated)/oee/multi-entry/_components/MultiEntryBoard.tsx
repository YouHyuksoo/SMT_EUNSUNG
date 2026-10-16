'use client';

/**
 * @file oee/multi-entry/_components/MultiEntryBoard.tsx
 * @description OEE 비가동 입력 본체 — SMT·ASSY 페이지가 작업장을 고정해서 쓴다.
 *
 * 비가동의 주체는 설비다(ADR 0002). 라인은 설비를 묶어 보여 주는 단위일 뿐이다.
 * - 좌: 가동 설비, 우: 비가동 설비. 카드는 라인별로 묶는다.
 * - 가동 설비를 누르면 비가동 시작, 비가동 설비를 누르면 비가동 종료 대상이 된다.
 * - 누르면 바로 처리하고 그 자리에서 다시 읽는다. 비가동 카드는 경과 시간이 1초마다 올라가고,
 *   종료하면 그 시간이 설비의 오늘 누적 비가동에 더해진다(누적 = 오늘 종료분 + 진행중 경과).
 * - 처리는 설비정지 모달·설비 운영 현황과 같은 API(POST /oee/work-result/downtimes/bulk)로 한다.
 *   이미 처리된 설비는 서버가 건너뛰므로 같은 요청을 다시 보내도 중복으로 들어가지 않는다.
 *
 * API: GET /oee/work-result/downtime-board?processCode= · GET /oee/work-result/downtime-reasons
 *      POST /oee/work-result/downtimes/bulk · GET /oee/mobile/workers/:id
 */
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import axios from 'axios';
import {
  Ban,
  Check,
  Expand,
  Loader2,
  Minimize2,
  Minus,
  PauseCircle,
  PlayCircle,
  RefreshCw,
  Send,
  UserRound,
  Wifi,
  WifiOff,
} from 'lucide-react';
import { useTranslation } from 'react-i18next';
import toast from 'react-hot-toast';
import { usePathname, useRouter, useSearchParams } from 'next/navigation';
import DowntimeReasonModal from '@/components/shared/DowntimeReasonModal';
import { parseLocalTime } from '@/components/shared/EquipDowntimePanel';
import type { DowntimeReasonOption } from '@/components/shared/DowntimeReasonGrid';
import { useActiveInterval } from '@/hooks/useTabActive';
import { resolveOeeViewMode, type OeeViewMode } from '@/lib/oee-view-mode';
import { api } from '@/services/api';
import { useAuthStore } from '@/stores/authStore';
import { unwrap, type OeeProcessCode, type OeeWorker } from '../_lib/oee-mobile';

type Mode = 'START' | 'END';

interface BoardMachine {
  machineCode: string;
  machineName: string | null;
  workstageCode: string | null;
  workstageName: string | null;
  open: { dtSeq: number; reasonCode: string | null; reasonName: string | null; startAt: string | null } | null;
  /** 오늘(달력일) 종료된 비가동 누적 초 */
  closedSecToday: number;
}
interface BoardLine {
  lineCode: string;
  lineName: string;
  machines: BoardMachine[];
}
interface BulkResult {
  affected: number;
  skipped: number;
  targets: number;
  skippedMachines: string[];
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null;
}

function readApiMessage(error: unknown, fallback: string): string {
  if (axios.isAxiosError(error)) {
    const body = error.response?.data;
    if (isRecord(body) && typeof body.message === 'string') return body.message;
  }
  if (error instanceof Error && error.message) return error.message;
  return fallback;
}

function parseWorker(response: unknown): OeeWorker | null {
  const value = unwrap<unknown>(response);
  if (!isRecord(value) || typeof value.workerId !== 'string' || typeof value.workerName !== 'string') return null;
  return { workerId: value.workerId, workerName: value.workerName };
}

/** 'YYYY-MM-DD HH:MM:SS' 에서 HH:MM 만 */
function clockOf(value: string | null | undefined): string {
  return value?.match(/\d{2}:\d{2}/)?.[0] ?? '';
}

function hms(totalSec: number): string {
  const sec = Math.max(0, Math.floor(totalSec));
  const p = (n: number) => String(n).padStart(2, '0');
  return `${p(Math.floor(sec / 3600))}:${p(Math.floor((sec % 3600) / 60))}:${p(sec % 60)}`;
}

/** 카드 아래 시간 줄 — 비가동이면 경과(1초마다), 그리고 오늘 누적(종료분 + 진행중 오늘 몫) */
function DowntimeTimes({ machine, skewMs, todayStart }: { machine: BoardMachine; skewMs: number; todayStart: number | null }) {
  const { t } = useTranslation();
  const startedAt = machine.open?.startAt ? parseLocalTime(machine.open.startAt) : null;
  const [now, setNow] = useState(() => Date.now());
  useActiveInterval(() => {
    if (startedAt != null) setNow(Date.now());
  }, 1000, { catchUp: true });
  const dbNow = now + skewMs;
  const elapsedSec = startedAt == null ? 0 : (dbNow - startedAt) / 1000;
  const openTodaySec = startedAt == null ? 0 : (dbNow - Math.max(startedAt, todayStart ?? startedAt)) / 1000;
  const totalSec = machine.closedSecToday + openTodaySec;
  if (startedAt == null && totalSec <= 0) return null;
  return (
    <div className="mt-1 flex items-center justify-between gap-2 font-mono text-xs">
      {startedAt != null ? <span className="font-bold text-error">{t('oeeMultiEntry.elapsed')} {hms(elapsedSec)}</span> : <span />}
      <span className="text-text-muted">{t('oeeMultiEntry.todayTotal')} {hms(totalSec)}</span>
    </div>
  );
}

export default function MultiEntryBoard({ processCode }: { processCode: OeeProcessCode }) {
  const { t } = useTranslation();
  const pathname = usePathname();
  const router = useRouter();
  const searchParams = useSearchParams();
  const viewMode = resolveOeeViewMode(searchParams.get('view'));
  const user = useAuthStore((state) => state.user);

  const [online, setOnline] = useState(true);
  const [lastCommunicationAt, setLastCommunicationAt] = useState<number | null>(null);

  const [workerInput, setWorkerInput] = useState('');
  const [worker, setWorker] = useState<OeeWorker | null>(null);
  const [workerLoading, setWorkerLoading] = useState(false);
  const [workerError, setWorkerError] = useState<string | null>(null);
  const autoWorkerIdentityRef = useRef<string | null>(null);

  const [lines, setLines] = useState<BoardLine[] | null>(null);
  const [boardError, setBoardError] = useState<string | null>(null);
  // DB 시각 − 브라우저 시각, 오늘 0시(DB 기준) — 경과·누적 시간을 DB 시계로 센다
  const [clock, setClock] = useState<{ skewMs: number; todayStart: number | null }>({ skewMs: 0, todayStart: null });
  const boardGeneration = useRef(0);

  const [mode, setMode] = useState<Mode>('START');
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [reasonCode, setReasonCode] = useState('');
  const [memo, setMemo] = useState('');
  const [submitting, setSubmitting] = useState(false);

  const [reasonOpen, setReasonOpen] = useState(false);
  const [reasons, setReasons] = useState<DowntimeReasonOption[]>([]);
  const [reasonsLoading, setReasonsLoading] = useState(false);
  const [reasonsError, setReasonsError] = useState<string | null>(null);
  const firstReasonButtonRef = useRef<HTMLButtonElement>(null);

  const markCommunication = useCallback(() => setLastCommunicationAt(Date.now()), []);

  useEffect(() => {
    const updateOnline = () => setOnline(navigator.onLine);
    updateOnline();
    window.addEventListener('online', updateOnline);
    window.addEventListener('offline', updateOnline);
    return () => {
      window.removeEventListener('online', updateOnline);
      window.removeEventListener('offline', updateOnline);
    };
  }, []);

  const switchView = useCallback(
    (nextMode: OeeViewMode) => {
      if (!pathname || submitting || nextMode === viewMode) return;
      const params = new URLSearchParams(searchParams.toString());
      params.set('view', nextMode);
      router.replace(`${pathname}?${params.toString()}`, { scroll: false });
    },
    [pathname, router, searchParams, submitting, viewMode],
  );

  /* ── 작업자 ── */
  const lookupWorker = useCallback(
    async (workerId: string): Promise<OeeWorker> => {
      try {
        const response = await api.get(`/oee/mobile/workers/${encodeURIComponent(workerId)}`, { suppressErrorModal: true });
        const next = parseWorker(response);
        if (!next) throw new Error(t('oeeMultiEntry.workerResponseError'));
        return next;
      } finally {
        markCommunication();
      }
    },
    [markCommunication, t],
  );

  const confirmWorker = useCallback(async () => {
    const id = workerInput.trim();
    if (!id) {
      setWorkerError(t('oeeMultiEntry.workerRequired'));
      return;
    }
    setWorkerLoading(true);
    setWorkerError(null);
    try {
      const next = await lookupWorker(id);
      setWorker(next);
      setWorkerInput(next.workerId);
      toast.success(t('oeeMultiEntry.workerConfirmed'));
    } catch (error: unknown) {
      const message = readApiMessage(error, t('oeeMultiEntry.workerNotFound'));
      setWorkerError(message);
      toast.error(message);
    } finally {
      setWorkerLoading(false);
    }
  }, [lookupWorker, t, workerInput]);

  // 로그인 사용자(사번 → 아이디 순)로 작업자를 자동 확인한다
  useEffect(() => {
    const identity = typeof user?.id === 'string' ? user.id.trim() : '';
    if (!identity || autoWorkerIdentityRef.current === identity) return;
    autoWorkerIdentityRef.current = identity;
    const candidates = [...new Set([user?.empNo ?? '', identity].map((c) => c.trim()).filter(Boolean))];
    void (async () => {
      setWorkerLoading(true);
      try {
        for (const candidate of candidates) {
          try {
            const next = await lookupWorker(candidate);
            setWorker(next);
            setWorkerInput(next.workerId);
            return;
          } catch {
            // 다음 후보로
          }
        }
      } finally {
        setWorkerLoading(false);
      }
    })();
  }, [lookupWorker, user]);

  const changeWorker = useCallback(() => {
    if (submitting) return;
    setWorker(null);
    setWorkerInput('');
    setWorkerError(null);
  }, [submitting]);

  /* ── 보드(라인별 설비 상태) ── */
  const loadBoard = useCallback(async () => {
    const generation = ++boardGeneration.current;
    try {
      const response = await api.get('/oee/work-result/downtime-board', {
        params: { processCode },
        suppressErrorModal: true,
      });
      if (generation !== boardGeneration.current) return;
      const value = unwrap<{ lines?: BoardLine[]; serverNow?: string | null }>(response);
      setLines(Array.isArray(value?.lines) ? value.lines : []);
      const serverNow = value?.serverNow ? parseLocalTime(value.serverNow) : null;
      const todayStart = value?.serverNow ? parseLocalTime(`${value.serverNow.slice(0, 10)} 00:00:00`) : null;
      setClock({ skewMs: serverNow == null ? 0 : serverNow - Date.now(), todayStart });
      setBoardError(null);
    } catch (error: unknown) {
      if (generation !== boardGeneration.current) return;
      const message = readApiMessage(error, t('oeeMultiEntry.statusLoadError'));
      setBoardError(message);
      // 이미 보이는 화면이 있으면 그대로 두고 토스트로만 알린다
      toast.error(message, { id: 'oee-multi-entry-board' });
    } finally {
      markCommunication();
    }
  }, [markCommunication, processCode, t]);

  useEffect(() => {
    void loadBoard();
  }, [loadBoard]);

  const machineByCode = useMemo(() => {
    const map = new Map<string, { line: BoardLine; machine: BoardMachine }>();
    for (const line of lines ?? []) for (const machine of line.machines) map.set(machine.machineCode, { line, machine });
    return map;
  }, [lines]);

  // 상태가 바뀌어 지금 모드와 맞지 않게 된 선택은 정리한다(다른 화면에서 처리된 경우)
  const selectedMachines = useMemo(
    () => [...selected].map((code) => machineByCode.get(code)?.machine).filter((m): m is BoardMachine => Boolean(m)),
    [machineByCode, selected],
  );
  const eligible = useCallback((machine: BoardMachine, forMode: Mode) => (forMode === 'START' ? !machine.open : Boolean(machine.open)), []);
  const selectedEligible = selectedMachines.filter((m) => eligible(m, mode));

  const clearSelection = useCallback(() => {
    setSelected(new Set());
    setReasonCode('');
    setMemo('');
  }, []);

  const toggleMachine = useCallback(
    (machine: BoardMachine) => {
      if (submitting) return;
      const cardMode: Mode = machine.open ? 'END' : 'START';
      if (cardMode !== mode) {
        setMode(cardMode);
        setReasonCode('');
        setMemo('');
        setSelected(new Set([machine.machineCode]));
        return;
      }
      setSelected((current) => {
        const next = new Set(current);
        if (next.has(machine.machineCode)) next.delete(machine.machineCode);
        else next.add(machine.machineCode);
        return next;
      });
    },
    [mode, submitting],
  );

  /** 묶음 선택 — 다른 영역이면 그쪽으로 넘어가며 전부, 같은 영역이면 전체/해제 */
  const toggleGroup = useCallback(
    (groupMode: Mode, machines: BoardMachine[]) => {
      if (submitting || machines.length === 0) return;
      const codes = machines.map((m) => m.machineCode);
      if (groupMode !== mode) {
        setMode(groupMode);
        setReasonCode('');
        setMemo('');
        setSelected(new Set(codes));
        return;
      }
      setSelected((current) => {
        const next = new Set(current);
        const all = codes.every((code) => next.has(code));
        for (const code of codes) {
          if (all) next.delete(code);
          else next.add(code);
        }
        return next;
      });
    },
    [mode, submitting],
  );

  /* ── 사유 ── */
  const openReasonModal = useCallback(async () => {
    setReasonOpen(true);
    setReasonsLoading(true);
    setReasonsError(null);
    try {
      // 설비 1대면 그 설비에 연계된 사유(설비정지 모달과 같다), 여러 대면 전체 사유
      const params = selectedEligible.length === 1 ? { machineCode: selectedEligible[0].machineCode } : {};
      const response = await api.get('/oee/work-result/downtime-reasons', { params, suppressErrorModal: true });
      const value = unwrap<{ list?: DowntimeReasonOption[] }>(response);
      setReasons(Array.isArray(value?.list) ? value.list : []);
    } catch (error: unknown) {
      setReasonsError(readApiMessage(error, t('oeeMultiEntry.reasonLoadError')));
    } finally {
      setReasonsLoading(false);
      markCommunication();
    }
  }, [markCommunication, selectedEligible, t]);

  // 종료: 새 사유를 고르지 않으면 시작 때 사유를 그대로 둔다. 시작 사유가 없는 설비가 있으면 필수.
  const endReasonMissing = mode === 'END' && !reasonCode && selectedEligible.some((m) => !m.open?.reasonCode);
  const endReasonNames = [...new Set(selectedEligible.map((m) => m.open?.reasonName ?? m.open?.reasonCode).filter(Boolean))];
  const reasonLabel = reasonCode
    ? reasons.find((r) => r.code === reasonCode)?.name ?? reasonCode
    : mode === 'START'
      ? `${t('oeeMultiEntry.reasonSelect')} (${t('oeeMultiEntry.optional')})`
      : endReasonMissing
        ? `${t('oeeMultiEntry.reasonSelect')} (${t('oeeMultiEntry.required')})`
        : endReasonNames.length === 1
          ? String(endReasonNames[0])
          : t('oeeMultiEntry.endReasonMixed');

  /* ── 제출 ── */
  const canSubmit =
    online && !submitting && Boolean(worker) && selectedEligible.length > 0 && selectedEligible.length === selectedMachines.length && !endReasonMissing;

  const submit = useCallback(async () => {
    if (!canSubmit || !worker) return;
    const machineCodes = selectedEligible.map((m) => m.machineCode);
    setSubmitting(true);
    try {
      const response = await api.post(
        '/oee/work-result/downtimes/bulk',
        {
          action: mode,
          machineCodes,
          ...(mode === 'START' ? { memo: memo.trim() || undefined } : {}),
          reasonCode: reasonCode || undefined,
          worker: worker.workerId,
        },
        { suppressErrorModal: true, skipSuccessToast: true },
      );
      const result = unwrap<BulkResult>(response);
      toast.success(t('oeeMultiEntry.processedMachines', { count: result?.affected ?? machineCodes.length }));
      if (result?.skipped) toast(t('oeeMultiEntry.skippedMachines', { count: result.skipped }), { icon: 'ℹ️' });
      clearSelection();
    } catch (error: unknown) {
      toast.error(readApiMessage(error, t('oeeMultiEntry.error')));
    } finally {
      markCommunication();
      setSubmitting(false);
      void loadBoard();
    }
  }, [canSubmit, clearSelection, loadBoard, markCommunication, memo, mode, reasonCode, selectedEligible, t, worker]);

  /* ── 화면 ── */
  const lastCommunicationLabel = lastCommunicationAt
    ? new Date(lastCommunicationAt).toLocaleTimeString(undefined, { hour: '2-digit', minute: '2-digit', second: '2-digit' })
    : t('oeeMultiEntry.notYet');

  const zones = useMemo(() => {
    const build = (zoneMode: Mode) =>
      (lines ?? [])
        .map((line) => ({ line, machines: line.machines.filter((m) => (zoneMode === 'START' ? !m.open : Boolean(m.open))) }))
        .filter((group) => group.machines.length > 0);
    return { START: build('START'), END: build('END') };
  }, [lines]);
  const unassignedLines = (lines ?? []).filter((line) => line.machines.length === 0);

  return (
    <div className="oee-multi-entry-board flex h-full min-h-0 flex-col overflow-hidden bg-background text-text">
      <div className="mx-auto flex min-h-0 w-full max-w-[1680px] flex-1 flex-col gap-2 overflow-hidden p-2">
        <header className="oee-multi-entry-header shrink-0 rounded-2xl border border-border bg-card p-3 sm:p-4">
          <div className="oee-multi-entry-header-row flex min-w-0 flex-col gap-3 lg:grid lg:grid-cols-[minmax(10.5rem,1fr)_minmax(6.75rem,0.68fr)_minmax(8rem,0.82fr)_minmax(11rem,1.05fr)_max-content] lg:items-stretch lg:gap-1">
            <div className="flex min-w-0 items-center gap-2">
              <div className="oee-header-optional-icon shrink-0 rounded-xl border border-primary/30 bg-primary/10 p-2 text-primary">
                <PauseCircle className="h-8 w-8" aria-hidden="true" />
              </div>
              <div className="min-w-0">
                <h1 className="truncate text-xl font-black tracking-tight text-text sm:text-2xl lg:text-lg xl:text-xl">
                  {t('oeeMultiEntry.title')} <span className="font-mono text-primary">{processCode}</span>
                </h1>
                <p className="oee-header-optional-copy mt-0.5 truncate text-xs text-text-muted">{t('oeeMultiEntry.subtitle')}</p>
              </div>
            </div>

            <div data-testid="oee-multi-status-area" className="grid min-w-0 grid-cols-1 gap-2 sm:grid-cols-2 lg:contents">
              <div
                className={`flex min-h-[48px] min-w-0 items-center gap-2 rounded-xl border px-2 ${online ? 'border-success/40 bg-success/10' : 'border-error/40 bg-error/10'}`}
                role="status"
                aria-label={t('oeeMultiEntry.deviceNetwork')}
              >
                {online ? <Wifi className="oee-header-optional-icon h-5 w-5 shrink-0 text-success" aria-hidden="true" /> : <WifiOff className="oee-header-optional-icon h-5 w-5 shrink-0 text-error" aria-hidden="true" />}
                <div className="min-w-0">
                  <span className="block truncate text-[11px] font-bold uppercase tracking-wide text-text-muted">{t('oeeMultiEntry.deviceNetwork')}</span>
                  <strong className={`block truncate text-sm ${online ? 'text-success' : 'text-error'}`}>{online ? t('oeeMultiEntry.online') : t('oeeMultiEntry.offline')}</strong>
                </div>
              </div>
              <div className="flex min-h-[48px] min-w-0 items-center gap-2 rounded-xl border border-border bg-surface px-2" role="status" aria-label={t('oeeMultiEntry.recentMesCommunication')}>
                <Send className="oee-header-optional-icon h-5 w-5 shrink-0 text-warning" aria-hidden="true" />
                <div className="min-w-0">
                  <span className="block truncate text-[11px] font-bold uppercase tracking-wide text-text-muted">{t('oeeMultiEntry.recentMesCommunication')}</span>
                  <strong className="block truncate font-mono text-xs text-text">{lastCommunicationLabel}</strong>
                </div>
              </div>
              {worker ? (
                <div
                  data-testid="oee-multi-worker-summary"
                  className="worker-summary flex min-h-[48px] min-w-0 items-center justify-between gap-1 rounded-xl border border-success/40 bg-success/10 px-2"
                  role="status"
                  aria-label={`${t('oeeMultiEntry.workerId')}: ${worker.workerName} · ${worker.workerId}`}
                >
                  <div className="flex min-w-0 items-center gap-1.5">
                    <UserRound className="oee-header-optional-icon h-5 w-5 shrink-0 text-success" aria-hidden="true" />
                    <span className="min-w-0 truncate text-xs font-bold text-success xl:text-sm">
                      {worker.workerName} <span className="font-mono font-semibold">· {worker.workerId}</span>
                    </span>
                  </div>
                  <button
                    type="button"
                    onClick={changeWorker}
                    disabled={submitting}
                    className="inline-flex min-h-[44px] min-w-[44px] shrink-0 cursor-pointer flex-col items-center justify-center rounded-lg border border-border px-1.5 text-[11px] font-bold leading-tight text-text transition hover:border-primary hover:bg-primary/10 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    <span>{t('oeeMultiEntry.changeWorkerLine1')}</span>
                    <span>{t('oeeMultiEntry.changeWorkerLine2')}</span>
                  </button>
                </div>
              ) : (
                <form
                  data-testid="oee-multi-worker-form"
                  className="grid min-h-[48px] min-w-0 grid-cols-[minmax(0,1fr)_auto] items-end gap-1 rounded-xl border border-border bg-surface p-1 sm:col-span-2 lg:col-span-1"
                  onSubmit={(event) => {
                    event.preventDefault();
                    void confirmWorker();
                  }}
                >
                  <label className="flex min-w-0 flex-col text-[10px] font-semibold leading-tight text-text-muted">
                    <span className="truncate">{t('oeeMultiEntry.workerId')}</span>
                    <input
                      value={workerInput}
                      onChange={(event) => setWorkerInput(event.target.value)}
                      disabled={workerLoading}
                      placeholder={t('oeeMultiEntry.workerPlaceholder')}
                      autoComplete="off"
                      className="mt-0.5 min-h-[44px] min-w-0 rounded-lg border border-border bg-background px-2 text-sm font-semibold text-text outline-none transition focus:border-primary focus:ring-2 focus:ring-primary/30 disabled:opacity-50"
                    />
                  </label>
                  <button
                    type="submit"
                    disabled={workerLoading || !workerInput.trim()}
                    aria-label={t('oeeMultiEntry.workerConfirm')}
                    className="inline-flex min-h-[44px] min-w-[44px] cursor-pointer items-center justify-center rounded-lg bg-primary px-2 text-xs font-black text-white transition hover:bg-primary/90 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    {workerLoading ? <Loader2 className="h-4 w-4 animate-spin" aria-hidden="true" /> : t('common.confirm')}
                  </button>
                </form>
              )}
            </div>

            <button
              data-testid="oee-multi-view-switch"
              type="button"
              onClick={() => switchView(viewMode === 'normal' ? 'full' : 'normal')}
              disabled={submitting}
              className="inline-flex min-h-11 shrink-0 cursor-pointer items-center justify-center gap-2 rounded-xl border border-border px-3 text-sm font-bold text-text transition hover:border-primary hover:bg-primary/10 disabled:cursor-not-allowed disabled:opacity-45"
            >
              {viewMode === 'normal' ? <Expand className="h-5 w-5 shrink-0" aria-hidden="true" /> : <Minimize2 className="h-5 w-5 shrink-0" aria-hidden="true" />}
              <span className="whitespace-nowrap">{viewMode === 'normal' ? t('oeeMultiEntry.viewFull') : t('oeeMultiEntry.viewNormal')}</span>
            </button>
          </div>
          {workerError && <p className="mt-2 text-sm font-semibold text-error">{workerError}</p>}
        </header>

        {/* 처리 줄 — 선택한 설비 · 사유 · 메모 · 실행 */}
        <section data-testid="oee-multi-command-bar" className="flex min-h-[64px] shrink-0 items-center gap-2 rounded-2xl border border-border bg-card px-3 py-2">
          {selectedMachines.length === 0 ? (
            <p className="min-w-0 flex-1 truncate text-sm font-semibold text-text-muted">{t('oeeMultiEntry.tapHint')}</p>
          ) : (
            <>
              <span className={`inline-flex min-h-[44px] shrink-0 items-center gap-2 rounded-lg px-3 text-sm font-black ${mode === 'START' ? 'bg-error/10 text-error' : 'bg-success/10 text-success'}`}>
                {mode === 'START' ? t('oeeMultiEntry.startAction') : t('oeeMultiEntry.endAction')}
                <span className="font-mono text-base">{selectedMachines.length}</span>
              </span>
              <button
                data-testid="oee-multi-reason-trigger"
                type="button"
                onClick={() => void openReasonModal()}
                disabled={submitting}
                className={`inline-flex min-h-[44px] min-w-0 max-w-[18rem] shrink cursor-pointer items-center gap-2 rounded-lg border bg-background px-3 text-left text-sm transition hover:border-primary disabled:cursor-not-allowed disabled:opacity-50 ${endReasonMissing ? 'border-error ring-2 ring-error/40' : 'border-border'}`}
              >
                <span className="shrink-0 text-xs font-bold text-text-muted">{t('oeeMultiEntry.reason')}</span>
                <span className="min-w-0 truncate font-bold text-text">{reasonLabel}</span>
              </button>
              {mode === 'START' ? (
                <input
                  value={memo}
                  onChange={(event) => setMemo(event.target.value)}
                  disabled={submitting}
                  maxLength={500}
                  placeholder={`${t('oeeMultiEntry.memo')} (${t('oeeMultiEntry.optional')})`}
                  aria-label={t('oeeMultiEntry.memo')}
                  className="min-h-[44px] min-w-0 flex-1 rounded-lg border border-border bg-background px-3 text-sm text-text outline-none placeholder:text-text-muted focus:border-primary focus:ring-2 focus:ring-primary/30 disabled:opacity-50"
                />
              ) : (
                <span className="flex-1" />
              )}
              <button
                type="button"
                onClick={clearSelection}
                disabled={submitting}
                className="inline-flex min-h-[44px] shrink-0 cursor-pointer items-center rounded-lg border border-border px-3 text-xs font-bold text-text transition hover:border-primary disabled:cursor-not-allowed disabled:opacity-50"
              >
                {t('oeeMultiEntry.clearSelection')}
              </button>
            </>
          )}
          <button
            data-testid="oee-multi-primary-action"
            type="button"
            onClick={() => void submit()}
            disabled={!canSubmit}
            title={!worker ? t('oeeMultiEntry.workerFirst') : !online ? t('oeeMultiEntry.offlineBlocked') : undefined}
            className={`inline-flex min-h-[48px] shrink-0 cursor-pointer items-center justify-center gap-2 rounded-xl px-5 text-base font-black text-white transition disabled:cursor-not-allowed disabled:bg-surface disabled:text-text-muted ${mode === 'START' ? 'bg-error hover:bg-error/90' : 'bg-success hover:bg-success/90'}`}
          >
            {submitting ? <Loader2 className="h-5 w-5 animate-spin" aria-hidden="true" /> : mode === 'START' ? <PauseCircle className="h-5 w-5" aria-hidden="true" /> : <PlayCircle className="h-5 w-5" aria-hidden="true" />}
            {mode === 'START' ? t('oeeMultiEntry.startAction') : t('oeeMultiEntry.endAction')}
          </button>
        </section>

        {/* 본문 — 좌: 가동 · 우: 비가동. 처음 불러올 때만 가운데 스피너 */}
        {lines === null ? (
          <div className="flex flex-1 flex-col items-center justify-center gap-3 rounded-2xl border border-border bg-card text-text-muted" role="status">
            {boardError ? (
              <>
                <p className="text-sm font-semibold">{t('oeeMultiEntry.statusLoadError')}</p>
                <button
                  type="button"
                  onClick={() => void loadBoard()}
                  className="inline-flex h-10 items-center gap-1.5 rounded-lg border border-border px-4 text-sm font-semibold text-text hover:bg-surface"
                >
                  <RefreshCw className="h-4 w-4" aria-hidden="true" />{t('oeeMultiEntry.retry')}
                </button>
              </>
            ) : (
              <>
                <Loader2 className="h-10 w-10 animate-spin text-primary" aria-hidden="true" />
                <p className="text-sm font-semibold">{t('oeeMultiEntry.statusLoading')}</p>
              </>
            )}
          </div>
        ) : (
          <div className="grid min-h-0 flex-1 grid-cols-2 gap-2">
            {(['START', 'END'] as const).map((zoneMode) => {
              const running = zoneMode === 'START';
              const groups = zones[zoneMode];
              const zoneMachines = groups.flatMap((g) => g.machines);
              const selectedInZone = mode === zoneMode ? zoneMachines.filter((m) => selected.has(m.machineCode)).length : 0;
              const allSelected = zoneMachines.length > 0 && selectedInZone === zoneMachines.length;
              return (
                <section
                  key={zoneMode}
                  data-testid={running ? 'oee-multi-zone-running' : 'oee-multi-zone-downtime'}
                  className={`flex min-h-0 min-w-0 flex-col overflow-hidden rounded-2xl border bg-card ${running ? 'border-success/40' : 'border-error/40'}`}
                >
                  <div className={`flex shrink-0 items-center gap-2 px-3 py-2 ${running ? 'bg-success/10' : 'bg-error/10'}`}>
                    {running ? <PlayCircle className="h-5 w-5 text-success" aria-hidden="true" /> : <PauseCircle className="h-5 w-5 text-error" aria-hidden="true" />}
                    <h2 className={`text-lg font-black ${running ? 'text-success' : 'text-error'}`}>{running ? t('oeeMultiEntry.running') : t('oeeMultiEntry.downtime')}</h2>
                    <span className="font-mono text-lg font-black text-text">{zoneMachines.length}</span>
                    <button
                      type="button"
                      role="checkbox"
                      aria-checked={allSelected ? true : selectedInZone > 0 ? 'mixed' : false}
                      onClick={() => toggleGroup(zoneMode, zoneMachines)}
                      disabled={submitting || zoneMachines.length === 0}
                      className="ml-auto inline-flex min-h-[40px] items-center gap-1.5 rounded-lg border border-border px-2.5 text-xs font-bold text-text transition hover:border-primary disabled:cursor-not-allowed disabled:opacity-40"
                    >
                      <span className="flex h-5 w-5 items-center justify-center rounded border border-border" aria-hidden="true">
                        {allSelected ? <Check className="h-4 w-4" /> : selectedInZone > 0 ? <Minus className="h-4 w-4" /> : null}
                      </span>
                      {t('oeeMultiEntry.selectAll')}
                    </button>
                  </div>
                  <div className="min-h-0 flex-1 space-y-3 overflow-y-auto overscroll-contain p-2">
                    {groups.length === 0 && (
                      <div className="flex min-h-[96px] items-center justify-center gap-2 text-sm text-text-muted">
                        <Ban className="h-5 w-5" aria-hidden="true" />
                        {running ? t('oeeMultiEntry.noRunningResources') : t('oeeMultiEntry.noDowntimeResources')}
                      </div>
                    )}
                    {groups.map(({ line, machines }) => {
                      const lineSelected = mode === zoneMode ? machines.filter((m) => selected.has(m.machineCode)).length : 0;
                      return (
                        <div key={line.lineCode}>
                          <button
                            type="button"
                            onClick={() => toggleGroup(zoneMode, machines)}
                            disabled={submitting}
                            className="mb-1 flex w-full items-center gap-2 rounded px-1 text-left text-sm font-bold text-text hover:text-primary disabled:opacity-50"
                            title={t('oeeMultiEntry.lineAll')}
                          >
                            <span className="font-mono text-text-muted">{line.lineCode}</span>
                            {line.lineName}
                            <span className="text-xs font-normal text-text-muted">
                              {lineSelected > 0 ? `${lineSelected}/` : ''}{machines.length}
                            </span>
                          </button>
                          <div className="grid grid-cols-1 gap-2 xl:grid-cols-2 2xl:grid-cols-3">
                            {machines.map((machine) => {
                              const isSelected = selected.has(machine.machineCode);
                              return (
                                <button
                                  key={machine.machineCode}
                                  data-testid="oee-multi-machine-card"
                                  type="button"
                                  onClick={() => toggleMachine(machine)}
                                  disabled={submitting}
                                  aria-pressed={isSelected}
                                  className={`min-h-[60px] min-w-0 cursor-pointer rounded-lg border p-2 text-left transition disabled:cursor-not-allowed disabled:opacity-50 ${
                                    isSelected
                                      ? running ? 'border-error bg-error/10 ring-2 ring-error/40' : 'border-success bg-success/10 ring-2 ring-success/40'
                                      : 'border-border bg-background hover:border-primary/70'
                                  }`}
                                >
                                  <div className="flex min-w-0 items-center gap-2">
                                    <span className="min-w-0 flex-1 truncate text-sm font-bold text-text">{machine.machineName ?? machine.machineCode}</span>
                                    <span className={`flex h-5 w-5 shrink-0 items-center justify-center rounded border ${isSelected ? 'border-current bg-current/10' : 'border-border text-transparent'}`} aria-hidden="true">
                                      {isSelected ? <Check className="h-4 w-4" /> : null}
                                    </span>
                                  </div>
                                  <div className="mt-1 flex min-w-0 items-center justify-between gap-2 text-xs">
                                    <span className="min-w-0 truncate font-mono text-text-muted">
                                      {machine.machineCode}{machine.workstageName ? ` · ${machine.workstageName}` : ''}
                                    </span>
                                    {machine.open && (
                                      <span className="min-w-0 shrink-0 truncate text-error">
                                        {machine.open.reasonName ?? machine.open.reasonCode ?? t('oeeMultiEntry.noReason')}
                                        {machine.open.startAt ? <span className="ml-1 font-mono text-text-muted">{clockOf(machine.open.startAt)}~</span> : null}
                                      </span>
                                    )}
                                  </div>
                                  <DowntimeTimes machine={machine} skewMs={clock.skewMs} todayStart={clock.todayStart} />
                                </button>
                              );
                            })}
                          </div>
                        </div>
                      );
                    })}
                    {running && unassignedLines.length > 0 && (
                      <p className="px-1 pt-1 text-xs text-text-muted">
                        {t('oeeMultiEntry.unassignedLines')}: {unassignedLines.map((line) => line.lineName).join(', ')}
                      </p>
                    )}
                  </div>
                </section>
              );
            })}
          </div>
        )}
      </div>

      <DowntimeReasonModal
        isOpen={reasonOpen}
        onClose={() => setReasonOpen(false)}
        title={t('oeeMultiEntry.reasonSelect')}
        reasons={reasons}
        value={reasonCode}
        onChange={setReasonCode}
        required={endReasonMissing}
        loading={reasonsLoading}
        error={reasonsError}
        onRetry={() => void openReasonModal()}
        emptyText={t('oeeMultiEntry.noReasons')}
        firstButtonRef={firstReasonButtonRef}
      />
    </div>
  );
}
