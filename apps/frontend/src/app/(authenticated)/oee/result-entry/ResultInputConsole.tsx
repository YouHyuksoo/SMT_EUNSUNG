'use client';

import { useCallback, useEffect, useMemo, useState } from 'react';
import { Check, Delete, Eraser, Loader2, RefreshCw, Save, Search, UserRound } from 'lucide-react';
import toast from 'react-hot-toast';
import { Modal } from '@/components/ui';
import api from '@/services/api';
import { readCollection, unwrap } from '../multi-entry/_lib/oee-mobile';
import { isSensorPending } from '@/components/shared/sensorApply';

export interface ResultEntryRun {
  runNo: string;
  machineCode: string | null;
  workstageCode: string | null;
  runDate: string;
  lineCode: string | null;
  lineName?: string | null;
  shiftCode: string | null;
  itemCode: string | null;
  revision: string | null;
  modelName: string | null;
  itemName?: string | null;
  unit: string | null;
  itemClass: string | null;
  carModel: string | null;
  ct: number | null;
  planQty: number | null;
  resultQty?: number;
}

interface LatestResult {
  seqNo: string;
  resultQty: number;
  workTime: number;
  workerCount: number;
  workerName: string;
  resultStatus: 'WIP' | 'DONE' | string;
  sensorApplyYn?: string;
  sensorApplyMsg?: string | null;
  receiptDate?: string;
  updatedAt?: string;
}

interface SensorApplyResponse {
  sensorApplyYn?: string;
  sensorWarning?: string;
}

type NumericField = 'resultQty' | 'workTime' | 'workerCount';
type ResultStatus = 'WIP' | 'DONE';

interface ResultDraft {
  resultQty: number;
  workTime: number;
  workerCount: number;
  workerId: string;
  workerName: string;
  resultStatus: ResultStatus;
}

interface ResultInputConsoleProps {
  run: ResultEntryRun;
  isComplete: boolean;
  defaultWorkerId: string;
  defaultWorkerName: string;
  onSaved: () => void | Promise<void>;
  onDirtyChange: (dirty: boolean) => void;
}

const NUMERIC_FIELDS: Array<{ field: NumericField; label: string; unit: string | null }> = [
  { field: 'resultQty', label: '실적수량', unit: null },
  { field: 'workTime', label: '작업시간', unit: '분' },
  { field: 'workerCount', label: '투입인원', unit: '명' },
];

const KEYPAD_KEYS = ['7', '8', '9', '4', '5', '6', '1', '2', '3', '00', '0'];

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null;
}

function readApiMessage(error: unknown, fallback: string): string {
  if (isRecord(error)) {
    const response = error.response;
    if (isRecord(response) && isRecord(response.data) && typeof response.data.message === 'string') {
      return response.data.message;
    }
  }
  return error instanceof Error && error.message ? error.message : fallback;
}

function formatNumber(value: number | null | undefined): string {
  return Number(value ?? 0).toLocaleString();
}

function initialDraft(workerId: string, workerName: string): ResultDraft {
  return {
    resultQty: 0,
    workTime: 0,
    workerCount: 0,
    workerId,
    workerName,
    resultStatus: 'WIP',
  };
}

function latestResultFrom(response: unknown): LatestResult | null {
  const rows = readCollection<LatestResult>(response, 'list');
  return rows.length ? rows[rows.length - 1] : null;
}

export default function ResultInputConsole({
  run,
  isComplete,
  defaultWorkerId,
  defaultWorkerName,
  onSaved,
  onDirtyChange,
}: ResultInputConsoleProps) {
  const normalizedDefaultWorkerId = defaultWorkerId.trim();
  const [draft, setDraft] = useState<ResultDraft>(() => initialDraft(normalizedDefaultWorkerId, defaultWorkerName));
  const [activeNumericField, setActiveNumericField] = useState<NumericField>('resultQty');
  const [latest, setLatest] = useState<LatestResult | null>(null);
  const [latestLoading, setLatestLoading] = useState(true);
  const [latestError, setLatestError] = useState('');
  const [workerLoading, setWorkerLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [applyingSensor, setApplyingSensor] = useState(false);
  const [doneConfirmationOpen, setDoneConfirmationOpen] = useState(false);

  const loadLatest = useCallback(async () => {
    setLatestLoading(true);
    setLatestError('');
    try {
      const response = await api.get('/oee/work-result/results', {
        params: { runNo: run.runNo },
        suppressErrorModal: true,
      });
      setLatest(latestResultFrom(response));
    } catch {
      setLatest(null);
      setLatestError('최근 실적을 불러오지 못했습니다.');
    } finally {
      setLatestLoading(false);
    }
  }, [run.runNo]);

  useEffect(() => {
    void loadLatest();
  }, [loadLatest]);

  const isDirty = useMemo(
    () => draft.resultQty !== 0
      || draft.workTime !== 0
      || draft.workerCount !== 0
      || draft.resultStatus !== 'WIP'
      || draft.workerId !== normalizedDefaultWorkerId
      || draft.workerName !== defaultWorkerName,
    [defaultWorkerName, draft, normalizedDefaultWorkerId],
  );

  useEffect(() => {
    onDirtyChange(isDirty && !isComplete);
  }, [isComplete, isDirty, onDirtyChange]);

  const planQty = Number(run.planQty ?? 0);
  const cumulativeQty = Number(run.resultQty ?? 0);
  const remainingQty = Math.max(planQty - cumulativeQty, 0);
  const overrunQty = Math.max(cumulativeQty - planQty, 0);
  const activeNumericLabel = NUMERIC_FIELDS.find((entry) => entry.field === activeNumericField)?.label ?? '숫자';

  function resetDraft() {
    setDraft(initialDraft(normalizedDefaultWorkerId, defaultWorkerName));
    setActiveNumericField('resultQty');
  }

  function updateNumericField(field: NumericField, value: number) {
    setDraft((current) => ({ ...current, [field]: Math.max(0, Math.trunc(value)) }));
  }

  function appendKey(key: string) {
    const currentValue = String(draft[activeNumericField]);
    const currentDigits = currentValue === '0' ? '' : currentValue;
    const nextDigits = `${currentDigits}${key}`.slice(0, 9);
    updateNumericField(activeNumericField, Number(nextDigits || 0));
  }

  function backspace() {
    const currentDigits = String(draft[activeNumericField]);
    updateNumericField(activeNumericField, Number(currentDigits.slice(0, -1) || 0));
  }

  function clearActiveNumericField() {
    updateNumericField(activeNumericField, 0);
  }

  async function lookupWorker() {
    const workerId = draft.workerId.trim();
    if (!workerId) {
      setDraft((current) => ({ ...current, workerId: '', workerName: '' }));
      return;
    }

    setWorkerLoading(true);
    try {
      const response = await api.get(`/oee/mobile/workers/${encodeURIComponent(workerId)}`, {
        suppressErrorModal: true,
      });
      const worker = unwrap<unknown>(response);
      const resolvedWorkerId = isRecord(worker) ? worker.workerId : undefined;
      const resolvedWorkerName = isRecord(worker) ? worker.workerName : undefined;
      if (typeof resolvedWorkerId !== 'string' || typeof resolvedWorkerName !== 'string') {
        throw new Error('작업자 응답을 확인할 수 없습니다.');
      }
      setDraft((current) => ({ ...current, workerId: resolvedWorkerId, workerName: resolvedWorkerName }));
      toast.success(`${resolvedWorkerName || resolvedWorkerId} 작업자를 적용했습니다.`);
    } catch (error: unknown) {
      toast.error(readApiMessage(error, '작업자를 찾을 수 없습니다.'));
    } finally {
      setWorkerLoading(false);
    }
  }

  async function submitResult() {
    if (isComplete || saving) return;
    setSaving(true);
    try {
      const response = await api.post('/oee/work-result/results', {
        runNo: run.runNo,
        machineCode: run.machineCode || undefined,
        workstageCode: run.workstageCode ?? '',
        resultQty: draft.resultQty,
        workTime: draft.workTime,
        workerCount: draft.workerCount,
        workerName: draft.workerName,
        resultStatus: draft.resultStatus,
      }, {
        skipSuccessToast: true,
        suppressErrorModal: true,
      });
      const result = unwrap<SensorApplyResponse>(response);
      if (result?.sensorWarning) {
        toast.error(`실적은 저장됐지만 공정재고 반영에 실패했습니다. ${result.sensorWarning}`);
      } else {
        toast.success('실적이 저장되었습니다.');
      }
      setDoneConfirmationOpen(false);
      resetDraft();
      await loadLatest();
      await onSaved();
    } catch (error: unknown) {
      toast.error(readApiMessage(error, '실적 저장에 실패했습니다.'));
    } finally {
      setSaving(false);
    }
  }

  async function applyLatestSensor() {
    if (!latest || !isSensorPending(latest.resultStatus, latest.sensorApplyYn) || applyingSensor) return;
    setApplyingSensor(true);
    try {
      const response = await api.post('/oee/work-result/results/apply-sensor', {
        runNo: run.runNo,
        seqNo: latest.seqNo,
      }, {
        skipSuccessToast: true,
        suppressErrorModal: true,
      });
      const result = unwrap<SensorApplyResponse>(response);
      if (result?.sensorWarning) {
        toast.error(`공정재고 반영에 실패했습니다. ${result.sensorWarning}`);
      } else {
        toast.success('공정재고에 반영되었습니다.');
      }
      await loadLatest();
      await onSaved();
    } catch (error: unknown) {
      toast.error(readApiMessage(error, '공정재고 반영에 실패했습니다.'));
    } finally {
      setApplyingSensor(false);
    }
  }

  function handleSave() {
    if (isComplete || saving) return;
    if (draft.resultStatus === 'DONE') {
      setDoneConfirmationOpen(true);
      return;
    }
    void submitResult();
  }

  return (
    <section
      data-testid="oee-result-entry-input-console"
      className="relative flex min-h-0 min-w-0 flex-1 flex-col overflow-hidden bg-[#f4f7f8] text-slate-900"
      aria-labelledby="result-entry-console-title"
    >
      <header className="flex shrink-0 items-center justify-between gap-3 border-b border-slate-200 bg-white px-4 py-3 shadow-[0_4px_16px_rgba(15,23,42,0.08)]">
        <div className="min-w-0">
          <p className="font-mono text-[10px] font-black uppercase tracking-[0.2em] text-teal-700">02 / TOUCH CONSOLE</p>
          <h2 id="result-entry-console-title" className="mt-1 truncate text-lg font-black text-slate-950">실적 입력</h2>
          {run && (
            <p className="mt-0.5 truncate font-mono text-xs font-bold text-slate-500">
              {run.lineCode ?? '-'} · {run.runNo}{run.lineName ? ` · ${run.lineName}` : ''}
            </p>
          )}
        </div>
        <button
          type="button"
          data-testid="oee-result-entry-save"
          onClick={handleSave}
          disabled={isComplete || saving}
          className="inline-flex min-h-12 shrink-0 cursor-pointer items-center justify-center gap-2 rounded-xl bg-teal-600 px-4 text-sm font-black text-white shadow-lg shadow-teal-600/20 transition hover:bg-teal-700 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-teal-500 disabled:cursor-not-allowed disabled:bg-slate-300 disabled:text-slate-500 disabled:shadow-none"
        >
          {saving ? <Loader2 className="h-5 w-5 animate-spin" aria-hidden="true" /> : <Save className="h-5 w-5" aria-hidden="true" />}
          {isComplete ? '입력 완료' : '저장'}
        </button>
      </header>

      <div className={`min-h-0 flex-1 space-y-3 overflow-y-auto p-3 ${isComplete ? '' : 'pb-[322px]'}`}>
        <section data-testid="oee-result-entry-order-summary" className="rounded-2xl border border-slate-200 bg-white p-3 shadow-sm">
          <div className="mb-2 flex items-center justify-between gap-2">
            <h3 className="text-sm font-black text-slate-950">작업지시 요약</h3>
            {isComplete && <span className="rounded-full bg-blue-100 px-2.5 py-1 text-[11px] font-black text-blue-700">완료</span>}
          </div>
          <div className="grid grid-cols-2 gap-x-4 gap-y-2 text-xs">
            <div className="col-span-2 min-w-0">
              <span className="block text-[10px] font-bold uppercase tracking-wide text-slate-400">품목 / 품명</span>
              <strong className="mt-0.5 block truncate text-sm text-slate-900" title={`${run.itemCode ?? '-'} · ${run.itemName ?? run.modelName ?? '-'}`}>
                {run.itemCode ?? '-'} · {run.itemName ?? run.modelName ?? '-'}
              </strong>
            </div>
            <div><span className="block text-[10px] font-bold text-slate-400">교대</span><strong className="font-mono text-sm">{run.shiftCode ?? '-'}</strong></div>
            <div><span className="block text-[10px] font-bold text-slate-400">C/T</span><strong className="font-mono text-sm">{run.ct != null ? `${run.ct}s` : '-'}</strong></div>
            <div><span className="block text-[10px] font-bold text-slate-400">차종</span><strong className="block truncate text-sm" title={run.carModel ?? '-'}>{run.carModel ?? '-'}</strong></div>
            <div><span className="block text-[10px] font-bold text-slate-400">단위</span><strong className="font-mono text-sm">{run.unit ?? '-'}</strong></div>
          </div>
          <div className="mt-3 grid grid-cols-3 gap-2 border-t border-slate-100 pt-3">
            <div className="rounded-xl bg-slate-50 p-2"><span className="block text-[10px] font-bold text-slate-400">계획</span><strong className="font-mono text-base tabular-nums">{formatNumber(planQty)}</strong></div>
            <div className="rounded-xl bg-slate-50 p-2"><span className="block text-[10px] font-bold text-slate-400">누적</span><strong className="font-mono text-base tabular-nums">{formatNumber(cumulativeQty)}</strong></div>
            <div className="rounded-xl bg-amber-50 p-2"><span className="block text-[10px] font-bold text-amber-700">남은 수량</span><strong className="font-mono text-base tabular-nums text-amber-900">{formatNumber(remainingQty)}</strong></div>
          </div>
          <div data-testid="oee-result-entry-overrun" className={`mt-2 flex items-center justify-between rounded-lg px-2.5 py-1.5 text-xs font-bold ${overrunQty > 0 ? 'bg-red-50 text-red-700' : 'bg-slate-50 text-slate-500'}`}>
            <span>초과 수량</span>
            <span className="font-mono tabular-nums">{overrunQty > 0 ? `+${formatNumber(overrunQty)}` : '0'}</span>
          </div>
        </section>

        <section data-testid="oee-result-entry-latest" className="rounded-2xl border border-slate-200 bg-white p-3 shadow-sm">
          <div className="mb-2 flex items-center justify-between gap-2">
            <h3 className="text-sm font-black text-slate-950">최근 실적</h3>
            <span className="text-[10px] font-bold uppercase tracking-wide text-slate-400">읽기 전용</span>
          </div>
          {latestLoading && <div className="flex min-h-12 items-center justify-center gap-2 text-xs font-semibold text-slate-500"><Loader2 className="h-4 w-4 animate-spin text-teal-600" aria-hidden="true" />조회 중</div>}
          {!latestLoading && latestError && <p className="rounded-lg bg-amber-50 p-2 text-xs font-semibold text-amber-800" role="status">{latestError}</p>}
          {!latestLoading && !latestError && latest && (
            <>
              <div className="grid grid-cols-4 gap-2 text-center">
                <div><span className="block text-[10px] font-bold text-slate-400">수량</span><strong className="mt-0.5 block font-mono text-base tabular-nums">{formatNumber(latest.resultQty)}</strong></div>
                <div><span className="block text-[10px] font-bold text-slate-400">상태</span><strong className={`mt-0.5 block text-xs ${latest.resultStatus === 'DONE' ? (isSensorPending(latest.resultStatus, latest.sensorApplyYn) ? 'text-red-700' : 'text-blue-700') : 'text-amber-700'}`}>{latest.resultStatus === 'DONE' ? '완료' : '진행'}</strong></div>
                <div className="min-w-0"><span className="block text-[10px] font-bold text-slate-400">작업자</span><strong className="mt-0.5 block truncate text-xs" title={latest.workerName || '미지정'}>{latest.workerName || '미지정'}</strong></div>
                <div><span className="block text-[10px] font-bold text-slate-400">시간</span><strong className="mt-0.5 block truncate font-mono text-[10px]" title={latest.updatedAt ?? latest.receiptDate ?? '-'}>{latest.updatedAt ?? latest.receiptDate ?? '-'}</strong></div>
              </div>
              {isSensorPending(latest.resultStatus, latest.sensorApplyYn) && (
                <div data-testid="oee-result-entry-sensor-warning" className="mt-2 flex items-center justify-between gap-2 rounded-lg border border-red-200 bg-red-50 p-2 text-xs font-bold text-red-700" role="status">
                  <span className="min-w-0 flex-1 truncate" title={latest.sensorApplyMsg ?? '공정재고에 반영되지 않았습니다.'}>{latest.sensorApplyMsg ?? '공정재고에 반영되지 않았습니다.'}</span>
                  <button type="button" onClick={() => void applyLatestSensor()} disabled={applyingSensor} className="inline-flex min-h-11 shrink-0 cursor-pointer items-center justify-center gap-1.5 rounded-lg border border-red-300 bg-white px-3 text-xs font-black text-red-700 transition hover:bg-red-100 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-red-500 disabled:cursor-not-allowed disabled:opacity-50">
                    <RefreshCw className={`h-4 w-4 ${applyingSensor ? 'animate-spin' : ''}`} aria-hidden="true" />
                    실적반영
                  </button>
                </div>
              )}
            </>
          )}
          {!latestLoading && !latestError && !latest && <p className="py-2 text-center text-xs font-semibold text-slate-500">등록된 실적이 없습니다.</p>}
        </section>

        <section data-testid="oee-result-entry-numeric-input" className={`rounded-2xl border bg-white p-3 shadow-sm ${isComplete ? 'border-slate-200' : 'border-teal-200'}`}>
          <div className="mb-2 flex items-center justify-between gap-2">
            <h3 className="text-sm font-black text-slate-950">새 실적</h3>
            {isComplete && <span className="text-xs font-bold text-slate-500">완료된 작업지시는 입력할 수 없습니다.</span>}
          </div>
          <div className="grid grid-cols-3 gap-2">
            {NUMERIC_FIELDS.map(({ field, label, unit }) => {
              const active = activeNumericField === field;
              const displayUnit = field === 'resultQty' ? (run.unit ?? '-') : unit;
              return (
                <button
                  key={field}
                  type="button"
                  data-testid={`oee-result-entry-${field}-card`}
                  aria-label={`${label} ${draft[field].toLocaleString()} ${displayUnit}`}
                  aria-pressed={active}
                  disabled={isComplete}
                  onClick={() => setActiveNumericField(field)}
                  className={`min-h-[76px] cursor-pointer rounded-xl border-2 p-2 text-left transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-teal-500 disabled:cursor-not-allowed disabled:opacity-50 ${active && !isComplete ? 'border-teal-500 bg-teal-50 shadow-[0_0_0_3px_rgba(13,148,136,0.12)]' : 'border-slate-200 bg-slate-50 hover:border-teal-300'}`}
                >
                  <span className="block text-[10px] font-bold text-slate-500">{label}</span>
                  <strong className="mt-1 block text-right font-mono text-2xl font-black tabular-nums text-slate-950">{formatNumber(draft[field])}</strong>
                  <span className="block text-right text-[10px] font-bold text-slate-400">{displayUnit}</span>
                </button>
              );
            })}
          </div>

          {!isComplete && <div data-testid="oee-result-entry-keypad" data-active-field={activeNumericField} className="absolute bottom-3 left-3 right-3 z-10 rounded-xl border border-slate-200 bg-slate-100 p-2 shadow-[0_-8px_20px_rgba(15,23,42,0.12)]">
            <div className="mb-2 flex items-center justify-between gap-2 px-1">
              <span className="text-xs font-black text-slate-600">입력 중 · {activeNumericLabel}</span>
              <span className="font-mono text-sm font-black tabular-nums text-teal-700">{formatNumber(draft[activeNumericField])}</span>
            </div>
            <div className="grid grid-cols-3 gap-2">
              {KEYPAD_KEYS.map((key) => (
                  <button
                    key={key}
                    type="button"
                    data-testid={`oee-result-entry-key-${key}`}
                    disabled={isComplete}
                  onClick={() => appendKey(key)}
                  className="min-h-11 cursor-pointer rounded-lg border border-slate-200 bg-white font-mono text-lg font-black text-slate-800 shadow-sm transition hover:border-teal-400 hover:bg-teal-50 active:scale-[0.98] focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-teal-500 disabled:cursor-not-allowed"
                >
                  {key}
                </button>
              ))}
            </div>
            <div className="mt-2 grid grid-cols-2 gap-2">
              <button type="button" data-testid="oee-result-entry-keypad-clear" disabled={isComplete} onClick={clearActiveNumericField} className="inline-flex min-h-11 cursor-pointer items-center justify-center gap-1.5 rounded-lg border border-slate-200 bg-white text-xs font-black text-slate-600 transition hover:border-teal-400 hover:bg-teal-50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-teal-500 disabled:cursor-not-allowed"><Eraser className="h-4 w-4" aria-hidden="true" />지우기</button>
              <button type="button" data-testid="oee-result-entry-keypad-backspace" disabled={isComplete} onClick={backspace} className="inline-flex min-h-11 cursor-pointer items-center justify-center gap-1.5 rounded-lg border border-slate-200 bg-white text-xs font-black text-slate-600 transition hover:border-teal-400 hover:bg-teal-50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-teal-500 disabled:cursor-not-allowed"><Delete className="h-4 w-4" aria-hidden="true" />한 자리 삭제</button>
            </div>
          </div>}
        </section>

        <section data-testid="oee-result-entry-status-worker" className={`rounded-2xl border bg-white p-3 shadow-sm ${isComplete ? 'border-slate-200' : 'border-slate-200'}`}>
          <div className="mb-2 flex items-center justify-between gap-2">
            <h3 className="text-sm font-black text-slate-950">처리 상태 · 작업자</h3>
            {isComplete && <span className="inline-flex items-center gap-1 text-xs font-bold text-blue-700"><Check className="h-4 w-4" aria-hidden="true" />저장 잠김</span>}
          </div>
          <div role="group" aria-label="처리구분" className="grid grid-cols-2 gap-2">
            {(['WIP', 'DONE'] as const).map((status) => {
              const active = draft.resultStatus === status;
              return (
                <button
                  key={status}
                  type="button"
                  data-testid={`oee-result-entry-status-${status.toLowerCase()}`}
                  aria-pressed={active}
                  disabled={isComplete}
                  onClick={() => setDraft((current) => ({ ...current, resultStatus: status }))}
                  className={`min-h-14 cursor-pointer rounded-xl border-2 text-base font-black transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-teal-500 disabled:cursor-not-allowed disabled:opacity-50 ${active ? (status === 'DONE' ? 'border-blue-600 bg-blue-600 text-white' : 'border-amber-500 bg-amber-500 text-white') : 'border-slate-200 bg-slate-50 text-slate-500 hover:border-slate-300'}`}
                >
                  {status === 'WIP' ? '진행 (WIP)' : '완료 (DONE)'}
                </button>
              );
            })}
          </div>
          <div className="mt-3 rounded-xl border border-slate-200 bg-slate-50 p-2.5">
            <div className="flex items-center gap-2">
              <UserRound className="h-5 w-5 shrink-0 text-teal-700" aria-hidden="true" />
              <label htmlFor="oee-result-entry-worker-id" className="sr-only">작업자 ID</label>
              <input
                id="oee-result-entry-worker-id"
                data-testid="oee-result-entry-worker-id"
                value={draft.workerId}
                disabled={isComplete}
                onChange={(event) => {
                  const workerId = event.target.value;
                  setDraft((current) => ({ ...current, workerId, workerName: '' }));
                }}
                placeholder="작업자 ID (선택)"
                className="min-h-11 min-w-0 flex-1 rounded-lg border border-slate-200 bg-white px-2.5 text-sm font-semibold text-slate-900 outline-none placeholder:text-slate-400 focus:border-teal-500 focus:ring-2 focus:ring-teal-500/20 disabled:bg-slate-100"
              />
              <button type="button" data-testid="oee-result-entry-worker-lookup" disabled={isComplete || workerLoading || !draft.workerId.trim()} onClick={() => void lookupWorker()} className="inline-flex min-h-11 shrink-0 cursor-pointer items-center justify-center gap-1.5 rounded-lg bg-slate-800 px-3 text-xs font-black text-white transition hover:bg-slate-700 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-500 disabled:cursor-not-allowed disabled:opacity-45"><Search className="h-4 w-4" aria-hidden="true" />조회</button>
            </div>
            <div className="mt-2 flex items-center justify-between gap-2 text-xs">
              <span className="min-w-0 truncate font-semibold text-slate-600">{draft.workerName ? `확인된 작업자: ${draft.workerName}` : '작업자 없음 · 빈 값으로 저장 가능'}</span>
                  {draft.workerId || draft.workerName ? <button type="button" data-testid="oee-result-entry-worker-clear" disabled={isComplete} onClick={() => setDraft((current) => ({ ...current, workerId: '', workerName: '' }))} className="min-h-11 shrink-0 cursor-pointer rounded-lg px-2 font-bold text-slate-500 underline-offset-2 hover:bg-white hover:text-slate-800 hover:underline focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-teal-500 disabled:cursor-not-allowed">비우기</button> : null}
            </div>
          </div>
        </section>
      </div>

      <Modal
        isOpen={doneConfirmationOpen}
        onClose={() => { if (!saving) setDoneConfirmationOpen(false); }}
        closeOnOverlayClick={!saving}
        closeOnEsc={!saving}
        title="완료로 저장"
        subtitle="완료 실적은 저장 후 이 화면에서 새 입력을 할 수 없습니다."
        footer={(
          <div className="flex w-full justify-end gap-2">
            <button type="button" onClick={() => setDoneConfirmationOpen(false)} disabled={saving} className="min-h-11 cursor-pointer rounded-lg border border-border px-4 text-sm font-bold text-text transition hover:bg-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary disabled:cursor-not-allowed disabled:opacity-50">취소</button>
            <button type="button" onClick={() => void submitResult()} disabled={saving} className="inline-flex min-h-11 cursor-pointer items-center justify-center gap-2 rounded-lg bg-primary px-4 text-sm font-black text-white transition hover:bg-primary/90 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary disabled:cursor-not-allowed disabled:opacity-50">{saving && <Loader2 className="h-4 w-4 animate-spin" aria-hidden="true" />}완료 저장</button>
          </div>
        )}
      >
        <p className="text-sm leading-6 text-text">현재 입력값을 <strong>DONE(완료)</strong> 상태로 저장하시겠습니까?</p>
      </Modal>
    </section>
  );
}
