'use client';

import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import axios from 'axios';
import {
  AlertTriangle,
  CheckCircle2,
  Circle,
  Cloud,
  CloudOff,
  History,
  Loader2,
  Play,
  RefreshCw,
  Square,
  UserRound,
} from 'lucide-react';
import { useTranslation } from 'react-i18next';
import toast from 'react-hot-toast';
import { ConfirmModal } from '@/components/ui';
import { api } from '@/services/api';
import {
  ASSY_PARENT_LINE_CODE,
  NO_ASSEMBLY_CELL_MASTER,
  createRequestId,
  formatServerTimestamp,
  makeEndPayload,
  makeStartPayload,
  normalizeCommandResult,
  normalizeResource,
  normalizeStatus,
  readCollection,
  stableEndSignature,
  stableStartSignature,
  unwrap,
  type EndCommandFields,
  type OeeCommandResult,
  type OeeDowntimeEvent,
  type OeeProcessCode,
  type OeeReason,
  type OeeResource,
  type OeeStatus,
  type OeeWorker,
  type StartCommandFields,
} from './_lib/oee-entry';

interface StartDraft {
  reasonCode: string;
  memo: string;
}

interface PendingCommand {
  signature: string;
  requestId: string;
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null;
}

function readApiMessage(error: unknown, fallback: string): string {
  if (axios.isAxiosError(error)) {
    const body = error.response?.data;
    if (isRecord(body) && typeof body.message === 'string') return body.message;
    if (typeof body === 'string' && body.trim()) return body;
    if (!error.response) return '네트워크 연결을 확인하세요.';
    return fallback;
  }
  if (error instanceof Error && error.message) return error.message;
  return fallback;
}

function responseStatus(error: unknown): number | null {
  return axios.isAxiosError(error) ? error.response?.status ?? null : null;
}

function isRetryableCommandFailure(error: unknown): boolean {
  if (!axios.isAxiosError(error)) return false;
  if (!error.response) return true;
  return error.code === 'ECONNABORTED' || error.code === 'ETIMEDOUT' || error.response.status >= 500;
}

function parseWorker(response: unknown): OeeWorker | null {
  const value = unwrap<unknown>(response);
  if (!isRecord(value) || typeof value.workerId !== 'string' || typeof value.workerName !== 'string') return null;
  return { workerId: value.workerId, workerName: value.workerName };
}

function StateBadge({
  state,
  statusLabel,
  runningLabel,
  downtimeLabel,
}: {
  state: 'RUNNING' | 'DOWNTIME';
  statusLabel: string;
  runningLabel: string;
  downtimeLabel: string;
}) {
  const isRunning = state === 'RUNNING';
  const Icon = isRunning ? CheckCircle2 : Square;
  return (
    <div
      className={`flex items-center gap-3 rounded-xl border px-4 py-3 ${
        isRunning ? 'border-emerald-300 bg-emerald-500/10 text-emerald-700' : 'border-red-300 bg-red-500/10 text-red-700'
      }`}
      role="status"
      aria-label={isRunning ? runningLabel : downtimeLabel}
    >
      <Icon className="h-8 w-8 shrink-0" aria-hidden="true" />
      <div>
        <p className="text-xs font-semibold uppercase tracking-wide opacity-80">{statusLabel}</p>
        <p className="text-2xl font-black">{isRunning ? runningLabel : downtimeLabel}</p>
      </div>
    </div>
  );
}

export default function OeeEntryPage() {
  const { t } = useTranslation();
  const [online, setOnline] = useState(true);

  const [workerInput, setWorkerInput] = useState('');
  const [worker, setWorker] = useState<OeeWorker | null>(null);
  const [workerLoading, setWorkerLoading] = useState(false);
  const [workerError, setWorkerError] = useState<string | null>(null);

  const [processCode, setProcessCode] = useState<OeeProcessCode | null>(null);
  const [resources, setResources] = useState<OeeResource[]>([]);
  const [resourcesLoading, setResourcesLoading] = useState(false);
  const [resourcesError, setResourcesError] = useState<string | null>(null);
  const [reasons, setReasons] = useState<OeeReason[]>([]);
  const [reasonsLoading, setReasonsLoading] = useState(false);
  const [reasonsError, setReasonsError] = useState<string | null>(null);
  const [selectedResource, setSelectedResource] = useState<OeeResource | null>(null);

  const [status, setStatus] = useState<OeeStatus | null>(null);
  const [statusLoading, setStatusLoading] = useState(false);
  const [statusError, setStatusError] = useState<string | null>(null);

  const [startDraft, setStartDraft] = useState<StartDraft | null>(null);
  const [startSubmitting, setStartSubmitting] = useState(false);
  const [endConfirmOpen, setEndConfirmOpen] = useState(false);
  const [endSubmitting, setEndSubmitting] = useState(false);

  const contextGeneration = useRef(0);
  const statusGeneration = useRef(0);
  const pendingStartRef = useRef<PendingCommand | null>(null);
  const pendingEndRef = useRef<PendingCommand | null>(null);

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

  const contextLocked = Boolean(
    startDraft ||
      startSubmitting ||
      endSubmitting ||
      status?.state === 'DOWNTIME',
  );

  const clearContext = useCallback(() => {
    contextGeneration.current += 1;
    statusGeneration.current += 1;
    setResourcesLoading(false);
    setReasonsLoading(false);
    setStatusLoading(false);
    setSelectedResource(null);
    setStatus(null);
    setStatusError(null);
    setResources([]);
    setResourcesError(null);
    setReasons([]);
    setReasonsError(null);
  }, []);

  const confirmWorker = useCallback(async () => {
    const workerId = workerInput.trim();
    if (!workerId) {
      setWorkerError(t('oeeEntry.workerRequired'));
      return;
    }

    setWorkerLoading(true);
    setWorkerError(null);
    try {
      const response = await api.get(`/oee/mobile/workers/${encodeURIComponent(workerId)}`, {
        suppressErrorModal: true,
      });
      const nextWorker = parseWorker(response);
      if (!nextWorker) throw new Error(t('oeeEntry.workerResponseError'));

      setWorker(nextWorker);
      setWorkerInput(nextWorker.workerId);
      setProcessCode(null);
      clearContext();
      toast.success(t('oeeEntry.workerConfirmed'));
    } catch (error: unknown) {
      const message = readApiMessage(error, t('oeeEntry.workerNotFound'));
      setWorkerError(message);
      toast.error(message);
    } finally {
      setWorkerLoading(false);
    }
  }, [clearContext, t, workerInput]);

  const changeWorker = useCallback(() => {
    if (contextLocked) return;
    setWorker(null);
    setWorkerError(null);
    setProcessCode(null);
    setWorkerInput('');
    clearContext();
  }, [clearContext, contextLocked]);

  const loadContext = useCallback(async (nextProcess: OeeProcessCode) => {
    const generation = ++contextGeneration.current;
    setResourcesLoading(true);
    setResourcesError(null);
    setReasonsLoading(true);
    setReasonsError(null);
    setResources([]);
    setReasons([]);

    const [resourceResult, reasonResult] = await Promise.allSettled([
      api.get('/oee/mobile/resources', {
        params: { processCode: nextProcess },
        suppressErrorModal: true,
      }),
      api.get('/oee/mobile/reasons', { suppressErrorModal: true }),
    ]);

    if (generation !== contextGeneration.current) return;

    if (resourceResult.status === 'fulfilled') {
      const expectedResourceType = nextProcess === 'SMT' ? 'LINE' : 'CELL';
      const rows = readCollection<OeeResource>(resourceResult.value, 'resources')
        .filter((resource) => resource.processCode === nextProcess && resource.resourceType === expectedResourceType)
        .map(normalizeResource);
      setResources(rows);
      if (rows.length === 0) {
        setResourcesError(nextProcess === 'ASSY' ? NO_ASSEMBLY_CELL_MASTER : t('oeeEntry.noResourceMaster'));
      }
    } else {
      const message = readApiMessage(resourceResult.reason, t('oeeEntry.resourceLoadError'));
      setResourcesError(
        nextProcess === 'ASSY' && message.includes(NO_ASSEMBLY_CELL_MASTER) ? NO_ASSEMBLY_CELL_MASTER : message,
      );
    }
    setResourcesLoading(false);

    if (reasonResult.status === 'fulfilled') {
      const rows = readCollection<OeeReason>(reasonResult.value, 'reasons');
      setReasons(rows);
      if (rows.length === 0) setReasonsError(t('oeeEntry.noReasonMaster'));
    } else {
      setReasonsError(readApiMessage(reasonResult.reason, t('oeeEntry.reasonLoadError')));
    }
    setReasonsLoading(false);
  }, [t]);

  const selectProcess = useCallback(
    (nextProcess: OeeProcessCode) => {
      if (!worker || contextLocked) return;
      setProcessCode(nextProcess);
      setSelectedResource(null);
      setStatus(null);
      setStatusError(null);
      statusGeneration.current += 1;
      setStatusLoading(false);
      pendingStartRef.current = null;
      pendingEndRef.current = null;
      void loadContext(nextProcess);
    },
    [contextLocked, loadContext, worker],
  );

  const loadStatus = useCallback(
    async (targetResource: OeeResource | null = selectedResource, targetProcess: OeeProcessCode | null = processCode) => {
      if (!targetResource || !targetProcess) return null;

      const generation = ++statusGeneration.current;
      const parentLineCode = targetResource.parentLineCode ?? targetResource.resourceCode;
      setStatusLoading(true);
      setStatusError(null);
      try {
        const response = await api.get('/oee/mobile/status', {
          params: {
            processCode: targetProcess,
            resourceType: targetResource.resourceType,
            resourceCode: targetResource.resourceCode,
            parentLineCode,
          },
          suppressErrorModal: true,
        });
        const nextStatus = normalizeStatus(response);
        if (generation !== statusGeneration.current) return null;
        setStatus(nextStatus);
        setStatusError(null);
        return nextStatus;
      } catch (error: unknown) {
        if (generation !== statusGeneration.current) return null;
        const message = readApiMessage(error, t('oeeEntry.statusLoadError'));
        setStatusError(message);
        toast.error(message);
        return null;
      } finally {
        if (generation === statusGeneration.current) setStatusLoading(false);
      }
    },
    [processCode, selectedResource, t],
  );

  const selectResource = useCallback(
    (resource: OeeResource) => {
      if (!worker || !processCode || contextLocked) return;
      const normalized = normalizeResource(resource);
      setSelectedResource(normalized);
      setStatus(null);
      setStatusError(null);
      pendingStartRef.current = null;
      pendingEndRef.current = null;
      void loadStatus(normalized, processCode);
    },
    [contextLocked, loadStatus, processCode, worker],
  );

  const retryContext = useCallback(() => {
    if (processCode) void loadContext(processCode);
  }, [loadContext, processCode]);

  const retryStatus = useCallback(() => {
    void loadStatus();
  }, [loadStatus]);

  const beginStartDraft = useCallback(() => {
    if (!worker || !selectedResource || !status || status.state !== 'RUNNING' || statusLoading || statusError) return;
    pendingStartRef.current = null;
    setStartDraft({ reasonCode: '', memo: '' });
  }, [selectedResource, status, statusError, statusLoading, worker]);

  const cancelStartDraft = useCallback(() => {
    if (startSubmitting) return;
    pendingStartRef.current = null;
    setStartDraft(null);
  }, [startSubmitting]);

  const updateDraftReason = useCallback((reasonCode: string) => {
    pendingStartRef.current = null;
    setStartDraft((draft) => (draft ? { ...draft, reasonCode } : draft));
  }, []);

  const updateDraftMemo = useCallback((memo: string) => {
    pendingStartRef.current = null;
    setStartDraft((draft) => (draft ? { ...draft, memo } : draft));
  }, []);

  const startCommandFields = useMemo<StartCommandFields | null>(() => {
    if (!worker || !selectedResource || !processCode || !startDraft) return null;
    return {
      processCode,
      resourceType: selectedResource.resourceType,
      resourceCode: selectedResource.resourceCode,
      parentLineCode: selectedResource.parentLineCode ?? selectedResource.resourceCode,
      workerId: worker.workerId,
      reasonCode: startDraft.reasonCode,
      memo: startDraft.memo,
      requestId: '',
    };
  }, [processCode, selectedResource, startDraft, worker]);

  const applyStartResult = useCallback((result: OeeCommandResult) => {
    setStatus((current) => {
      if (!current) return current;
      const event = result.event ?? current.openEvent;
      const events = event
        ? [...current.events.filter((row) => row.eventId !== event.eventId), event].sort((left, right) => left.eventId - right.eventId)
        : current.events;
      return { ...current, state: 'DOWNTIME', openEvent: event, events };
    });
    setStatusError(null);
  }, []);

  const submitStart = useCallback(async () => {
    if (!startDraft || !startCommandFields || !online) return;
    if (!startDraft.reasonCode) {
      toast.error(t('oeeEntry.reasonRequired'));
      return;
    }
    if (startDraft.memo.length > 500) {
      toast.error(t('oeeEntry.memoTooLong'));
      return;
    }
    if (!status || status.state !== 'RUNNING' || statusLoading || statusError) {
      toast.error(t('oeeEntry.statusUnknown'));
      return;
    }

    const signature = stableStartSignature({
      processCode: startCommandFields.processCode,
      resourceType: startCommandFields.resourceType,
      resourceCode: startCommandFields.resourceCode,
      parentLineCode: startCommandFields.parentLineCode,
      workerId: startCommandFields.workerId,
      reasonCode: startCommandFields.reasonCode,
      memo: startCommandFields.memo,
    });
    const pending = pendingStartRef.current;

    setStartSubmitting(true);
    try {
      const requestId = pending?.signature === signature ? pending.requestId : createRequestId();
      pendingStartRef.current = { signature, requestId };
      const payload = makeStartPayload({ ...startCommandFields, requestId });
      const response = await api.post('/oee/mobile/downtime/start', payload, {
        suppressErrorModal: true,
        skipSuccessToast: true,
      });
      const result = normalizeCommandResult(response);
      pendingStartRef.current = null;
      setStartDraft(null);
      applyStartResult(result);
      toast.success(result.replayed ? t('oeeEntry.startReplayed') : t('oeeEntry.startSaved'));
      const refreshed = await loadStatus();
      if (!refreshed) toast.error(t('oeeEntry.refreshAfterSaveError'));
    } catch (error: unknown) {
      if (responseStatus(error) === 409) {
        toast.error(t('oeeEntry.conflictRefreshing'));
        const refreshed = await loadStatus();
        if (refreshed?.state === 'DOWNTIME') {
          pendingStartRef.current = null;
          setStartDraft(null);
        }
      } else if (isRetryableCommandFailure(error)) {
        toast.error(t('oeeEntry.commandRetryable'));
      } else {
        toast.error(readApiMessage(error, t('oeeEntry.startError')));
      }
    } finally {
      setStartSubmitting(false);
    }
  }, [applyStartResult, loadStatus, online, startCommandFields, startDraft, status, statusError, statusLoading, t]);

  const activeEvent = status?.openEvent ?? null;
  const endCommandFields = useMemo<EndCommandFields | null>(() => {
    if (!activeEvent || !worker || !selectedResource || !processCode) return null;
    return {
      eventId: activeEvent.eventId,
      processCode,
      resourceType: selectedResource.resourceType,
      resourceCode: selectedResource.resourceCode,
      parentLineCode: selectedResource.parentLineCode ?? selectedResource.resourceCode,
      workerId: worker.workerId,
      requestId: '',
    };
  }, [activeEvent, processCode, selectedResource, worker]);

  const applyEndResult = useCallback(
    (result: OeeCommandResult) => {
      setStatus((current) => {
        if (!current) return current;
        const event = result.event;
        const events = event
          ? current.events.map((row) => (row.eventId === event.eventId ? event : row))
          : current.events;
        return { ...current, state: 'RUNNING', openEvent: null, events };
      });
      setStatusError(null);
    },
    [],
  );

  const submitEnd = useCallback(async () => {
    if (!endCommandFields || !online) return;
    if (!status || status.state !== 'DOWNTIME' || statusLoading || statusError) {
      toast.error(t('oeeEntry.statusUnknown'));
      return;
    }
    const signature = stableEndSignature(endCommandFields);
    const pending = pendingEndRef.current;

    setEndSubmitting(true);
    try {
      const requestId = pending?.signature === signature ? pending.requestId : createRequestId();
      pendingEndRef.current = { signature, requestId };
      const payload = makeEndPayload({ ...endCommandFields, requestId });
      const response = await api.post('/oee/mobile/downtime/end', payload, {
        suppressErrorModal: true,
        skipSuccessToast: true,
      });
      const result = normalizeCommandResult(response);
      pendingEndRef.current = null;
      setEndConfirmOpen(false);
      applyEndResult(result);
      toast.success(result.replayed ? t('oeeEntry.endReplayed') : t('oeeEntry.endSaved'));
      const refreshed = await loadStatus();
      if (!refreshed) toast.error(t('oeeEntry.refreshAfterSaveError'));
    } catch (error: unknown) {
      if (responseStatus(error) === 409) {
        toast.error(t('oeeEntry.conflictRefreshing'));
        const refreshed = await loadStatus();
        if (refreshed?.state === 'RUNNING') {
          pendingEndRef.current = null;
          setEndConfirmOpen(false);
        }
      } else if (isRetryableCommandFailure(error)) {
        toast.error(t('oeeEntry.commandRetryable'));
      } else {
        toast.error(readApiMessage(error, t('oeeEntry.endError')));
      }
    } finally {
      setEndSubmitting(false);
    }
  }, [applyEndResult, endCommandFields, loadStatus, online, status, statusError, statusLoading, t]);

  const statusKnown = Boolean(status && !statusLoading && !statusError);
  const transitionBlocked = useCallback(() => {
    if (statusError) return true;
    return !online || !statusKnown;
  }, [online, statusError, statusKnown]);

  const canStart = Boolean(
    startDraft &&
      startDraft.reasonCode &&
      !reasonsLoading &&
      reasons.length > 0 &&
      !reasonsError &&
      !startSubmitting &&
      !transitionBlocked(),
  );
  const canEnd = Boolean(status?.state === 'DOWNTIME' && activeEvent?.eventId && !endSubmitting && !transitionBlocked());

  const reasonName = useCallback(
    (reasonCode: string | null | undefined) => {
      if (!reasonCode) return '—';
      return reasons.find((reason) => reason.reasonCode === reasonCode)?.reasonName ?? reasonCode;
    },
    [reasons],
  );

  const historyRows = status?.events ?? [];
  const resourceErrorLabel = resourcesError === NO_ASSEMBLY_CELL_MASTER
    ? NO_ASSEMBLY_CELL_MASTER
    : resourcesError;

  return (
    <div className="oee-entry-page flex h-full min-h-0 flex-col overflow-hidden bg-background text-text">
      <div className="mx-auto flex min-h-0 w-full max-w-[1600px] flex-1 flex-col gap-3 overflow-y-auto p-3 sm:p-4 lg:p-5">
        <header className="shrink-0 rounded-2xl border border-border bg-card p-3 shadow-sm sm:p-4">
          <div className="flex flex-col gap-3 xl:flex-row xl:items-center xl:justify-between">
            <div className="flex items-start gap-3">
              <div className="rounded-xl bg-primary/10 p-2.5 text-primary">
                <History className="h-7 w-7" aria-hidden="true" />
              </div>
              <div>
                <h1 className="text-xl font-black tracking-tight text-text sm:text-2xl">{t('oeeEntry.title')}</h1>
                <p className="mt-0.5 text-sm text-text-muted">{t('oeeEntry.subtitle')}</p>
              </div>
            </div>

            <div className="flex flex-wrap items-center gap-2 text-sm">
              <span className={`inline-flex min-h-[64px] items-center gap-2 rounded-xl border px-4 font-semibold ${online ? 'border-emerald-300 bg-emerald-500/10 text-emerald-700' : 'border-red-300 bg-red-500/10 text-red-700'}`}>
                {online ? <Cloud className="h-5 w-5" aria-hidden="true" /> : <CloudOff className="h-5 w-5" aria-hidden="true" />}
                {online ? t('oeeEntry.online') : t('oeeEntry.offline')}
              </span>
              <span className="inline-flex min-h-[64px] items-center gap-2 rounded-xl border border-border bg-surface px-4 font-semibold text-text">
                <UserRound className="h-5 w-5 text-primary" aria-hidden="true" />
                {worker ? `${worker.workerName} (${worker.workerId})` : t('oeeEntry.workerRequired')}
              </span>
            </div>
          </div>

          <form
            className="mt-3 flex flex-col gap-2 border-t border-border pt-3 sm:flex-row sm:items-end"
            onSubmit={(event) => {
              event.preventDefault();
              void confirmWorker();
            }}
          >
            <label className="flex min-w-0 flex-1 flex-col gap-1 text-sm font-semibold text-text-muted">
              {t('oeeEntry.workerId')}
              <input
                value={workerInput}
                onChange={(event) => setWorkerInput(event.target.value)}
                disabled={Boolean(worker) || workerLoading || contextLocked}
                placeholder={t('oeeEntry.workerPlaceholder')}
                autoComplete="off"
                className="min-h-[64px] w-full rounded-xl border border-border bg-background px-4 text-lg font-semibold text-text outline-none transition focus:border-primary focus:ring-2 focus:ring-primary/30 disabled:cursor-not-allowed disabled:opacity-60"
                aria-describedby={workerError ? 'oee-worker-error' : undefined}
              />
            </label>
            {worker ? (
              <button
                type="button"
                onClick={changeWorker}
                disabled={contextLocked}
                className="min-h-[64px] rounded-xl border border-border px-5 text-base font-bold text-text transition hover:bg-surface disabled:cursor-not-allowed disabled:opacity-50"
              >
                {t('oeeEntry.changeWorker')}
              </button>
            ) : (
              <button
                type="submit"
                disabled={workerLoading || !workerInput.trim()}
                className="inline-flex min-h-[64px] items-center justify-center gap-2 rounded-xl bg-primary px-6 text-base font-bold text-white shadow-lg shadow-primary/20 transition hover:bg-primary-hover disabled:cursor-not-allowed disabled:opacity-50"
              >
                {workerLoading && <Loader2 className="h-5 w-5 animate-spin" aria-hidden="true" />}
                {t('oeeEntry.workerConfirm')}
              </button>
            )}
          </form>
          {workerError && <p id="oee-worker-error" className="mt-2 text-sm font-semibold text-error">{workerError}</p>}
        </header>

        <div className="grid min-h-0 shrink-0 grid-cols-1 gap-3 min-[1024px]:flex-1 min-[1024px]:grid-cols-2">
          <section className="flex min-h-[360px] min-w-0 flex-col overflow-hidden rounded-2xl border border-border bg-card p-3 shadow-sm sm:p-4" aria-labelledby="oee-process-title">
            <div className="flex shrink-0 items-center justify-between gap-2">
              <div>
                <p className="text-xs font-bold uppercase tracking-wider text-primary">01</p>
                <h2 id="oee-process-title" className="text-lg font-black text-text">{t('oeeEntry.processAndResource')}</h2>
              </div>
              {processCode && <span className="rounded-lg bg-primary/10 px-3 py-1.5 font-mono text-sm font-bold text-primary">{processCode}</span>}
            </div>

            <div className="mt-3 grid shrink-0 grid-cols-2 gap-2">
              {(['SMT', 'ASSY'] as const).map((nextProcess) => (
                <button
                  key={nextProcess}
                  type="button"
                  onClick={() => selectProcess(nextProcess)}
                  disabled={!worker || contextLocked}
                  aria-pressed={processCode === nextProcess}
                  className={`min-h-[64px] rounded-xl border px-4 text-lg font-black transition ${
                    processCode === nextProcess
                      ? 'border-primary bg-primary text-white shadow-lg shadow-primary/20'
                      : 'border-border bg-background text-text hover:border-primary/60 hover:bg-primary/5'
                  } disabled:cursor-not-allowed disabled:opacity-50`}
                >
                  {nextProcess === 'SMT' ? t('oeeEntry.processSmt') : t('oeeEntry.processAssy')}
                  <span className="mt-0.5 block text-xs font-semibold opacity-80">{nextProcess}</span>
                </button>
              ))}
            </div>

            <div className="mt-3 flex min-h-0 flex-1 flex-col overflow-hidden rounded-xl border border-border bg-background p-3">
              <div className="flex shrink-0 items-center justify-between gap-2">
                <h3 className="text-base font-bold text-text">{t('oeeEntry.resource')}</h3>
                {resourcesLoading && <Loader2 className="h-5 w-5 animate-spin text-primary" aria-label={t('common.loading')} />}
              </div>

              {!worker && (
                <div className="flex flex-1 flex-col items-center justify-center gap-2 py-8 text-center text-text-muted">
                  <UserRound className="h-9 w-9" aria-hidden="true" />
                  <p className="font-semibold">{t('oeeEntry.workerFirst')}</p>
                </div>
              )}
              {worker && !processCode && (
                <div className="flex flex-1 flex-col items-center justify-center gap-2 py-8 text-center text-text-muted">
                  <Circle className="h-9 w-9" aria-hidden="true" />
                  <p className="font-semibold">{t('oeeEntry.processFirst')}</p>
                </div>
              )}
              {processCode && resourcesLoading && (
                <div className="flex flex-1 flex-col items-center justify-center gap-2 py-8 text-text-muted">
                  <Loader2 className="h-8 w-8 animate-spin text-primary" aria-hidden="true" />
                  <p>{t('oeeEntry.resourcesLoading')}</p>
                </div>
              )}
              {processCode && !resourcesLoading && resourcesError && (
                <div className="flex flex-1 flex-col items-center justify-center gap-2 py-8 text-center">
                  <AlertTriangle className="h-9 w-9 text-warning" aria-hidden="true" />
                  <p className="font-bold text-error">{resourceErrorLabel}</p>
                  {resourcesError === NO_ASSEMBLY_CELL_MASTER && <p className="max-w-sm text-sm text-text-muted">{t('oeeEntry.noAssemblyCellMaster')}</p>}
                      {processCode && (
                        <button type="button" onClick={retryContext} className="mt-2 inline-flex min-h-[64px] items-center gap-2 rounded-xl border border-primary px-5 font-bold text-primary hover:bg-primary/5">
                      <RefreshCw className="h-5 w-5" aria-hidden="true" />
                      {t('oeeEntry.retry')}
                    </button>
                  )}
                </div>
              )}
              {processCode && !resourcesLoading && !resourcesError && resources.length === 0 && (
                <div className="flex flex-1 flex-col items-center justify-center gap-2 py-8 text-center text-text-muted">
                  <Circle className="h-9 w-9" aria-hidden="true" />
                  <p className="font-semibold">{t('oeeEntry.noResourceMaster')}</p>
                </div>
              )}
              {processCode && !resourcesLoading && !resourcesError && resources.length > 0 && (
                <div className="mt-2 min-h-0 flex-1 overflow-y-auto pr-1">
                  <div className="grid grid-cols-2 gap-2 xl:grid-cols-3">
                    {resources.map((resource) => {
                      const selected = selectedResource?.resourceCode === resource.resourceCode;
                      return (
                        <button
                          key={`${resource.resourceType}-${resource.resourceCode}`}
                          type="button"
                          onClick={() => selectResource(resource)}
                          disabled={contextLocked}
                          aria-pressed={selected}
                          className={`min-h-[64px] rounded-xl border p-3 text-left transition ${
                            selected ? 'border-primary bg-primary/10 ring-2 ring-primary/30' : 'border-border bg-card hover:border-primary/60'
                          } disabled:cursor-not-allowed disabled:opacity-50`}
                        >
                          <span className="block font-mono text-lg font-black text-text">{resource.resourceCode}</span>
                          <span className="mt-0.5 block truncate text-sm font-semibold text-text">{resource.resourceName}</span>
                          <span className="mt-1 block text-xs text-text-muted">
                            {resource.resourceType}{resource.processCode === 'ASSY' ? ` · ${ASSY_PARENT_LINE_CODE}` : ''}
                          </span>
                        </button>
                      );
                    })}
                  </div>
                </div>
              )}
            </div>
          </section>

          <section className="flex min-h-[360px] min-w-0 flex-col overflow-y-auto rounded-2xl border border-border bg-card p-3 shadow-sm sm:p-4" aria-labelledby="oee-state-title">
            <div className="flex shrink-0 items-center justify-between gap-2">
              <div>
                <p className="text-xs font-bold uppercase tracking-wider text-primary">02</p>
                <h2 id="oee-state-title" className="text-lg font-black text-text">{t('oeeEntry.currentStatus')}</h2>
              </div>
              {statusLoading && <span className="inline-flex items-center gap-2 text-sm font-semibold text-primary"><Loader2 className="h-5 w-5 animate-spin" aria-hidden="true" />{t('oeeEntry.statusLoading')}</span>}
            </div>

            <div className="mt-3 grid grid-cols-2 gap-2 rounded-xl border border-border bg-background p-3 text-sm">
              <div><span className="block text-xs font-semibold text-text-muted">{t('oeeEntry.workDate')}</span><strong>{status?.workDate ?? '—'}</strong></div>
              <div><span className="block text-xs font-semibold text-text-muted">{t('oeeEntry.workSegment')}</span><strong>{status?.workSegment ?? '—'}</strong></div>
              <div className="col-span-2"><span className="block text-xs font-semibold text-text-muted">{t('oeeEntry.selectedResource')}</span><strong>{selectedResource ? `${selectedResource.resourceCode} · ${selectedResource.resourceName}` : '—'}</strong></div>
            </div>

            {!selectedResource && (
              <div className="mt-3 flex flex-1 flex-col items-center justify-center gap-2 rounded-xl border border-dashed border-border p-6 text-center text-text-muted">
                <Circle className="h-9 w-9" aria-hidden="true" />
                <p className="font-semibold">{t('oeeEntry.resourceFirst')}</p>
              </div>
            )}
            {selectedResource && statusLoading && (
              <div className="mt-3 flex flex-1 flex-col items-center justify-center gap-2 rounded-xl border border-border p-6 text-text-muted">
                <Loader2 className="h-9 w-9 animate-spin text-primary" aria-hidden="true" />
                <p className="font-semibold">{t('oeeEntry.statusLoading')}</p>
              </div>
            )}
            {selectedResource && !statusLoading && statusError && (
              <div className="mt-3 flex flex-1 flex-col items-center justify-center gap-3 rounded-xl border border-red-300 bg-red-500/5 p-6 text-center">
                <AlertTriangle className="h-9 w-9 text-error" aria-hidden="true" />
                    <p className="font-semibold text-error">{t('oeeEntry.statusUnknown')}</p>
                    <p className="text-sm text-text-muted">{statusError}</p>
                    {status?.state === 'DOWNTIME' && status.openEvent && (
                      <p className="text-sm font-semibold text-warning">{t('oeeEntry.lastKnownEvent')} #{status.openEvent.eventId}</p>
                    )}
                    <button type="button" onClick={retryStatus} className="inline-flex min-h-[64px] items-center gap-2 rounded-xl border border-primary px-5 font-bold text-primary hover:bg-primary/5">
                  <RefreshCw className="h-5 w-5" aria-hidden="true" />
                  {t('oeeEntry.retry')}
                </button>
              </div>
            )}
            {selectedResource && !statusLoading && !statusError && status && (
              <div className="mt-3 flex flex-col gap-3">
                    <StateBadge
                      state={status.state}
                      statusLabel={t('oeeEntry.status')}
                      runningLabel={t('oeeEntry.running')}
                      downtimeLabel={t('oeeEntry.downtime')}
                    />

                {status.state === 'DOWNTIME' && activeEvent && (
                  <div className="rounded-xl border border-red-300 bg-red-500/5 p-3 text-sm">
                    <div className="grid grid-cols-2 gap-2">
                      <div><span className="block text-xs font-semibold text-text-muted">{t('oeeEntry.reason')}</span><strong>{reasonName(activeEvent.reasonCode)}</strong></div>
                      <div><span className="block text-xs font-semibold text-text-muted">{t('oeeEntry.startedAt')}</span><strong>{formatServerTimestamp(activeEvent.startTime)}</strong></div>
                      <div><span className="block text-xs font-semibold text-text-muted">{t('oeeEntry.workerId')}</span><strong>{activeEvent.workerId ?? worker?.workerId ?? '—'}</strong></div>
                      <div><span className="block text-xs font-semibold text-text-muted">EVENT_ID</span><strong>{activeEvent.eventId}</strong></div>
                    </div>
                  </div>
                )}

                {status.state === 'RUNNING' && !startDraft && (
                  <button
                    type="button"
                    onClick={beginStartDraft}
                    disabled={transitionBlocked() || !online}
                    className="inline-flex min-h-[72px] items-center justify-center gap-3 rounded-xl bg-primary px-5 text-xl font-black text-white shadow-lg shadow-primary/20 transition hover:bg-primary-hover disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    <Play className="h-7 w-7" fill="currentColor" aria-hidden="true" />
                    {t('oeeEntry.startDowntime')}
                  </button>
                )}

                {status.state === 'DOWNTIME' && activeEvent && (
                  <button
                    type="button"
                    onClick={() => setEndConfirmOpen(true)}
                    disabled={!canEnd}
                    className="inline-flex min-h-[72px] items-center justify-center gap-3 rounded-xl bg-error px-5 text-xl font-black text-white shadow-lg shadow-error/20 transition hover:opacity-90 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    <Square className="h-7 w-7" fill="currentColor" aria-hidden="true" />
                    {t('oeeEntry.endDowntime')}
                  </button>
                )}

                {status.state === 'RUNNING' && startDraft && (
                  <div className="rounded-xl border border-warning/50 bg-warning/10 p-3">
                    <div className="flex items-start justify-between gap-3">
                      <div>
                        <p className="text-xs font-bold uppercase tracking-wider text-warning">DRAFT</p>
                        <h3 className="text-lg font-black text-text">{t('oeeEntry.startDraft')}</h3>
                      </div>
                      <span className="text-xs font-semibold text-text-muted">{t('oeeEntry.serverTimeNotice')}</span>
                    </div>

                    <fieldset className="mt-3" disabled={startSubmitting}>
                      <legend className="mb-2 text-sm font-bold text-text">{t('oeeEntry.reason')} <span className="text-error">*</span></legend>
                      {reasonsLoading && <p className="flex items-center gap-2 text-sm text-text-muted"><Loader2 className="h-4 w-4 animate-spin" aria-hidden="true" />{t('oeeEntry.reasonsLoading')}</p>}
                      {reasonsError && (
                        <div className="rounded-lg border border-red-300 bg-red-500/5 p-3 text-sm text-error">
                          <p>{reasonsError}</p>
                          <button type="button" onClick={retryContext} className="mt-2 inline-flex min-h-[64px] items-center gap-2 rounded-lg border border-primary px-4 font-bold text-primary"><RefreshCw className="h-4 w-4" aria-hidden="true" />{t('oeeEntry.retry')}</button>
                        </div>
                      )}
                      {!reasonsLoading && !reasonsError && reasons.length === 0 && <p className="text-sm text-error">{t('oeeEntry.noReasonMaster')}</p>}
                      {!reasonsLoading && !reasonsError && reasons.length > 0 && (
                        <div className="grid max-h-40 grid-cols-1 gap-2 overflow-y-auto sm:grid-cols-2">
                          {reasons.map((reason) => {
                            const selected = startDraft.reasonCode === reason.reasonCode;
                            return (
                              <button
                                key={reason.reasonCode}
                                type="button"
                                onClick={() => updateDraftReason(reason.reasonCode)}
                                aria-pressed={selected}
                                className={`min-h-[64px] rounded-lg border px-3 text-left text-sm font-bold transition ${selected ? 'border-primary bg-primary text-white' : 'border-border bg-background text-text hover:border-primary/60'}`}
                              >
                                {reason.reasonName}
                              </button>
                            );
                          })}
                        </div>
                      )}
                    </fieldset>

                    <label className="mt-3 block text-sm font-bold text-text">
                      {t('oeeEntry.memo')} <span className="font-normal text-text-muted">({t('oeeEntry.optional')})</span>
                      <textarea
                        value={startDraft.memo}
                        onChange={(event) => updateDraftMemo(event.target.value)}
                        maxLength={500}
                        rows={2}
                        disabled={startSubmitting}
                        className="mt-1 min-h-[64px] w-full resize-none rounded-lg border border-border bg-background px-3 py-2 text-base font-medium text-text outline-none focus:border-primary focus:ring-2 focus:ring-primary/30 disabled:opacity-60"
                        placeholder={t('oeeEntry.memoPlaceholder')}
                      />
                      <span className={`mt-1 block text-right text-xs ${startDraft.memo.length > 500 ? 'text-error' : 'text-text-muted'}`}>{startDraft.memo.length} / 500</span>
                    </label>

                    <div className="mt-3 flex flex-col gap-2 sm:flex-row">
                      <button type="button" onClick={() => void submitStart()} disabled={!canStart} className="inline-flex min-h-[72px] flex-1 items-center justify-center gap-2 rounded-xl bg-primary px-5 text-lg font-black text-white shadow-lg shadow-primary/20 disabled:cursor-not-allowed disabled:opacity-50">
                        {startSubmitting && <Loader2 className="h-5 w-5 animate-spin" aria-hidden="true" />}
                        {t('oeeEntry.saveStart')}
                      </button>
                      <button type="button" onClick={cancelStartDraft} disabled={startSubmitting} className="min-h-[64px] rounded-xl border border-border px-5 text-base font-bold text-text hover:bg-background disabled:cursor-not-allowed disabled:opacity-50">
                        {t('common.cancel')}
                      </button>
                    </div>
                  </div>
                )}
              </div>
            )}
          </section>
        </div>

        <section className="flex min-h-[180px] shrink-0 flex-col overflow-hidden rounded-2xl border border-border bg-card p-3 shadow-sm sm:p-4" aria-labelledby="oee-history-title">
          <div className="flex shrink-0 items-center justify-between gap-2">
            <div>
              <p className="text-xs font-bold uppercase tracking-wider text-primary">03</p>
              <h2 id="oee-history-title" className="text-lg font-black text-text">{t('oeeEntry.history')}</h2>
            </div>
            {status?.workDate && <span className="text-sm font-semibold text-text-muted">{status.workDate} · {status.workSegment}</span>}
          </div>
          <div className="mt-2 min-h-0 flex-1 overflow-y-auto rounded-xl border border-border bg-background">
            {!selectedResource && <p className="p-5 text-center text-sm font-semibold text-text-muted">{t('oeeEntry.resourceFirst')}</p>}
            {selectedResource && statusLoading && <p className="flex items-center justify-center gap-2 p-5 text-sm text-text-muted"><Loader2 className="h-5 w-5 animate-spin" aria-hidden="true" />{t('oeeEntry.statusLoading')}</p>}
            {selectedResource && !statusLoading && statusError && <div className="flex items-center justify-center gap-3 p-5 text-sm text-error"><AlertTriangle className="h-5 w-5" aria-hidden="true" />{t('oeeEntry.historyUnavailable')}<button type="button" onClick={retryStatus} className="inline-flex min-h-[64px] items-center gap-2 rounded-lg border border-primary px-4 font-bold text-primary"><RefreshCw className="h-4 w-4" aria-hidden="true" />{t('oeeEntry.retry')}</button></div>}
            {selectedResource && !statusLoading && !statusError && status && historyRows.length === 0 && <p className="p-5 text-center text-sm font-semibold text-text-muted">{t('oeeEntry.emptyHistory')}</p>}
            {selectedResource && !statusLoading && !statusError && historyRows.length > 0 && (
              <div className="divide-y divide-border">
                {historyRows.map((event: OeeDowntimeEvent) => {
                  const active = event.eventId === activeEvent?.eventId && !event.endTime;
                  return (
                    <div key={event.eventId} className={`grid grid-cols-[auto_1fr_auto] items-center gap-3 p-3 text-sm ${active ? 'bg-red-500/5' : ''}`}>
                      <div className={active ? 'text-error' : 'text-emerald-600'}><Square className="h-5 w-5" fill="currentColor" aria-hidden="true" /></div>
                      <div className="min-w-0">
                        <div className="flex flex-wrap items-center gap-x-3 gap-y-1 font-semibold text-text">
                          <span>{formatServerTimestamp(event.startTime)} → {event.endTime ? formatServerTimestamp(event.endTime) : t('oeeEntry.inProgress')}</span>
                          <span className={active ? 'text-error' : 'text-text-muted'}>{active ? t('oeeEntry.downtime') : t('oeeEntry.completed')}</span>
                        </div>
                        <p className="truncate text-text-muted">{reasonName(event.reasonCode)} · {event.workerId ?? '—'} · {selectedResource.resourceCode}</p>
                      </div>
                      <span className="font-mono text-xs text-text-muted">#{event.eventId}</span>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        </section>
      </div>

      <ConfirmModal
        isOpen={endConfirmOpen}
        onClose={() => {
          if (!endSubmitting) setEndConfirmOpen(false);
        }}
        onConfirm={() => void submitEnd()}
        title={t('oeeEntry.endConfirmTitle')}
        message={t('oeeEntry.endConfirmMessage', {
          resource: selectedResource?.resourceName ?? selectedResource?.resourceCode ?? '—',
          startedAt: formatServerTimestamp(activeEvent?.startTime),
        })}
        confirmText={t('oeeEntry.endDowntime')}
        cancelText={t('common.cancel')}
        variant="danger"
        isLoading={endSubmitting}
      />
    </div>
  );
}
