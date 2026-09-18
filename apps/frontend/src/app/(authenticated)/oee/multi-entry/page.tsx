'use client';

import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import axios from 'axios';
import {
  AlertTriangle,
  Ban,
  Check,
  CheckCircle2,
  CircleHelp,
  LockKeyhole,
  Loader2,
  Minus,
  PauseCircle,
  PlayCircle,
  RefreshCw,
  Send,
  Square,
  UserRound,
  Wifi,
  WifiOff,
  type LucideIcon,
} from 'lucide-react';
import { useTranslation } from 'react-i18next';
import toast from 'react-hot-toast';
import { usePathname, useRouter, useSearchParams } from 'next/navigation';
import { Modal } from '@/components/ui';
import { resolveOeeViewMode, type OeeViewMode } from '@/lib/oee-view-mode';
import { api } from '@/services/api';
import { useAuthStore } from '@/stores/authStore';
import {
  normalizeResource,
  readCollection,
  resourceIdentity,
  unwrap,
  type OeeProcessCode,
  type OeeReason,
  type OeeResource,
  type OeeWorker,
} from './_lib/oee-mobile';
import {
  clearPendingSubmission,
  canConfirmPendingSubmission,
  createEndReasonOverride,
  getActiveEndReasonCode,
  getPendingSubmissionStorageKey,
  makeEndBatchPayload,
  makeStartBatchPayload,
  normalizeBatchResponse,
  normalizeMultiEntryStatus,
  parseOrganizationId,
  PendingSubmissionStorageError,
  readPendingSubmission,
  summarizeEndReasons,
  utf8ByteLength,
  validateBatchEvents,
  writePendingSubmission,
  type BatchOutcomeState,
  type EndReasonOverride,
  type MultiEntryEndItem,
  type MultiEntryEvent,
  type MultiEntryEndReasonTarget,
  type MultiEntryStatus,
  type PendingMultiEntrySubmission,
  type PendingStatusSnapshot,
  type MultiEntryMode,
} from './_lib/multi-entry';

interface ResourceStatusRow {
  loading: boolean;
  status: MultiEntryStatus | null;
  error: string | null;
}

interface BatchOutcomeView {
  mode: MultiEntryMode;
  processCode: OeeProcessCode;
  lineCodes: string[];
  targetItemCount: number;
  state: BatchOutcomeState;
  message: string;
  events: MultiEntryEvent[] | null;
}

interface AvailabilityLabels {
  loading: string;
  unknown: string;
  startOnly: string;
  endOnly: string;
  inapplicable: string;
  running: string;
  downtime: string;
}

interface ResourceAvailability {
  disabled: boolean;
  label: string;
  icon: LucideIcon;
  tone: string;
  disabledReason?: string;
}

const RESOURCE_PROCESS_CODES: OeeProcessCode[] = ['SMT', 'ASSY'];

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null;
}

function readApiMessage(error: unknown, fallback: string): string {
  if (axios.isAxiosError(error)) {
    const body = error.response?.data;
    if (isRecord(body) && typeof body.message === 'string') return body.message;
    if (typeof body === 'string' && body.trim()) return body;
    if (!error.response) return fallback;
    return fallback;
  }
  if (error instanceof Error && error.message) return error.message;
  return fallback;
}

function readPendingStorageErrorMessage(error: unknown, fallback: string): string {
  if (error instanceof PendingSubmissionStorageError) return `${fallback} (${error.code})`;
  return fallback;
}

function responseStatus(error: unknown): number | null {
  return axios.isAxiosError(error) ? error.response?.status ?? null : null;
}

function responseHttpStatus(response: unknown): number | null {
  if (!isRecord(response) || typeof response.status !== 'number') return null;
  return response.status;
}

function parseWorker(response: unknown): OeeWorker | null {
  const value = unwrap<unknown>(response);
  if (!isRecord(value) || typeof value.workerId !== 'string' || typeof value.workerName !== 'string') return null;
  return { workerId: value.workerId, workerName: value.workerName };
}

function isEligibleStatus(mode: MultiEntryMode, row: ResourceStatusRow | undefined): boolean {
  if (!row || row.loading || row.error || !row.status) return false;
  if (mode === 'START') return row.status.state === 'RUNNING';
  return row.status.state === 'DOWNTIME' && row.status.openEvents.length > 0;
}

function getResourceAvailability(
  mode: MultiEntryMode,
  row: ResourceStatusRow | undefined,
  labels: AvailabilityLabels,
): ResourceAvailability {
  if (!row || row.loading) {
    return { disabled: true, label: labels.loading, icon: Loader2, tone: 'text-cyan-300' };
  }
  if (row.error || !row.status) {
    return { disabled: true, label: labels.unknown, icon: AlertTriangle, tone: 'text-amber-300' };
  }

  if (mode === 'START' && row.status.state === 'RUNNING') {
    return { disabled: false, label: labels.running, icon: PlayCircle, tone: 'text-emerald-300' };
  }
  if (mode === 'END' && row.status.state === 'DOWNTIME' && row.status.openEvents.length > 0) {
    return { disabled: false, label: labels.downtime, icon: PauseCircle, tone: 'text-red-300' };
  }

  const actualState = row.status.state === 'RUNNING' ? labels.running : labels.downtime;
  const actualIcon = row.status.state === 'RUNNING' ? PlayCircle : PauseCircle;
  const actualTone = row.status.state === 'RUNNING' ? 'text-emerald-300' : 'text-red-300';

  return {
    disabled: true,
    label: actualState,
    icon: actualIcon,
    tone: actualTone,
    disabledReason: `${labels.inapplicable} · ${mode === 'START' ? labels.startOnly : labels.endOnly}`,
  };
}

function getOutcomeIcon(state: BatchOutcomeState | undefined): LucideIcon {
  if (state === 'success') return CheckCircle2;
  if (state === 'definitiveFailure') return AlertTriangle;
  if (state === 'needsConfirmation') return CircleHelp;
  return CircleHelp;
}

export default function OeeMultiEntryPage() {
  const { t } = useTranslation();
  const pathname = usePathname();
  const router = useRouter();
  const searchParams = useSearchParams();
  const viewMode = resolveOeeViewMode(searchParams.get('view'));
  const isCompactFullView = viewMode === 'full';
  const user = useAuthStore((state) => state.user);
  const [online, setOnline] = useState(true);
  const [lastCommunicationAt, setLastCommunicationAt] = useState<number | null>(null);

  const [workerInput, setWorkerInput] = useState('');
  const [worker, setWorker] = useState<OeeWorker | null>(null);
  const [workerLoading, setWorkerLoading] = useState(false);
  const [workerError, setWorkerError] = useState<string | null>(null);

  const [selectedWorkplace, setSelectedWorkplace] = useState<OeeProcessCode | null>(null);
  const [resources, setResources] = useState<OeeResource[]>([]);
  const [resourceLoadingByProcess, setResourceLoadingByProcess] = useState<Partial<Record<OeeProcessCode, boolean>>>({});
  const [resourceProcessErrors, setResourceProcessErrors] = useState<Partial<Record<OeeProcessCode, string>>>({});
  const [reasons, setReasons] = useState<OeeReason[]>([]);
  const [reasonsLoading, setReasonsLoading] = useState(false);
  const [reasonsError, setReasonsError] = useState<string | null>(null);
  const [statusByResource, setStatusByResource] = useState<Record<string, ResourceStatusRow>>({});
  const [selectedResourceIds, setSelectedResourceIds] = useState<Set<string>>(new Set());

  const [mode, setMode] = useState<MultiEntryMode>('START');
  const [reasonCode, setReasonCode] = useState('');
  const [endReasonOverride, setEndReasonOverride] = useState<EndReasonOverride | null>(null);
  const [memo, setMemo] = useState('');
  const [reasonEditorOpen, setReasonEditorOpen] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [batchOutcome, setBatchOutcome] = useState<BatchOutcomeView | null>(null);
  const [pendingSubmission, setPendingSubmission] = useState<PendingMultiEntrySubmission | null>(null);
  const [pendingStorageError, setPendingStorageError] = useState<string | null>(null);
  const [hydratedPendingStorageKey, setHydratedPendingStorageKey] = useState<string | undefined>(undefined);
  const [pendingStatusLoading, setPendingStatusLoading] = useState(false);
  const [pendingStatusByLine, setPendingStatusByLine] = useState<Record<string, PendingStatusSnapshot>>({});
  const [pendingStatusSnapshotGeneration, setPendingStatusSnapshotGeneration] = useState<number | null>(null);

  const contextGeneration = useRef(0);
  const statusGeneration = useRef(0);
  const reasonContextGeneration = useRef(0);
  const reasonsLoadedRef = useRef(false);
  const reasonsLoadingRef = useRef(false);
  const autoWorkerIdentityRef = useRef<string | null>(null);
  const submissionLockRef = useRef(false);
  const pendingSubmissionRef = useRef<PendingMultiEntrySubmission | null>(null);
  const pendingStorageKeyRef = useRef<string | null>(null);
  const pendingStatusRequestRef = useRef(false);
  const pendingQueryGenerationRef = useRef(0);
  const firstReasonButtonRef = useRef<HTMLButtonElement>(null);

  // The authenticated backend exposes ORGANIZATION_ID as AuthUser.plant; it is only
  // used to scope the browser-side uncertain-submission lock, never sent by the page.
  const organizationId = parseOrganizationId(user?.plant);
  const userId = typeof user?.id === 'string' ? user.id.trim() : '';
  const pendingStorageKey = useMemo(
    () => getPendingSubmissionStorageKey(user?.plant, user?.id),
    [user?.id, user?.plant],
  );
  const pendingLockReady = !user || hydratedPendingStorageKey === (pendingStorageKey ?? '');
  const contextLocked = submitting || Boolean(pendingSubmission) || Boolean(pendingStorageError) || (Boolean(user) && !pendingLockReady);

  const switchView = useCallback(
    (nextMode: OeeViewMode) => {
      if (!pathname || contextLocked || nextMode === viewMode) return;
      const params = new URLSearchParams(searchParams.toString());
      params.set('view', nextMode);
      router.replace(`${pathname}?${params.toString()}`, { scroll: false });
    },
    [contextLocked, pathname, router, searchParams, viewMode],
  );

  const markCommunication = useCallback(() => {
    setLastCommunicationAt(Date.now());
  }, []);

  const clearBatchOutcome = useCallback(() => {
    setBatchOutcome(null);
  }, []);

  const clearContext = useCallback(() => {
    contextGeneration.current += 1;
    statusGeneration.current += 1;
    reasonContextGeneration.current += 1;
    reasonsLoadedRef.current = false;
    reasonsLoadingRef.current = false;
    setResources([]);
    setReasons([]);
    setStatusByResource({});
    setSelectedResourceIds(new Set());
    setSelectedWorkplace(null);
    setResourceLoadingByProcess({});
    setReasonsLoading(false);
    setResourceProcessErrors({});
    setReasonsError(null);
    setReasonEditorOpen(false);
    setEndReasonOverride(null);
    if (!pendingSubmissionRef.current) {
      clearBatchOutcome();
      setPendingStatusByLine({});
    }
  }, [clearBatchOutcome]);

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

  const loadStatuses = useCallback(
    async (targetResources: OeeResource[]) => {
      const generation = ++statusGeneration.current;
      const loadingRows: Record<string, ResourceStatusRow> = {};
      for (const resource of targetResources) {
        loadingRows[resourceIdentity(resource)] = { loading: true, status: null, error: null };
      }
      setStatusByResource((current) => ({ ...current, ...loadingRows }));

      const results = await Promise.allSettled(
        targetResources.map(async (resource) => {
          try {
            const response = await api.get('/oee/multi-entry/status', {
              params: {
                processCode: resource.processCode,
                lineCode: resource.resourceCode,
              },
              suppressErrorModal: true,
            });
            return { resource, status: normalizeMultiEntryStatus(response), error: null };
          } catch (error: unknown) {
            return {
              resource,
              status: null,
              error: readApiMessage(error, t('oeeMultiEntry.statusLoadError')),
            };
          } finally {
            markCommunication();
          }
        }),
      );

      if (generation !== statusGeneration.current) return;

      const nextRows: Record<string, ResourceStatusRow> = {};
      results.forEach((result, index) => {
        const resource = targetResources[index];
        if (!resource) return;
        const key = resourceIdentity(resource);
        if (result.status === 'fulfilled') {
          nextRows[key] = {
            loading: false,
            status: result.value.status,
            error: result.value.error,
          };
        } else {
          nextRows[key] = {
            loading: false,
            status: null,
            error: readApiMessage(result.reason, t('oeeMultiEntry.statusLoadError')),
          };
        }
      });
      setStatusByResource((current) => ({ ...current, ...nextRows }));
    },
    [markCommunication, t],
  );

  const loadReasons = useCallback(async () => {
    if (reasonsLoadedRef.current || reasonsLoadingRef.current) return;

    reasonsLoadingRef.current = true;
    const generation = reasonContextGeneration.current;
    setReasonsLoading(true);
    setReasonsError(null);

    try {
      const response = await api.get('/oee/mobile/reasons', { suppressErrorModal: true }).finally(markCommunication);
      if (generation !== reasonContextGeneration.current) return;

      const loadedReasons = readCollection<OeeReason>(response, 'reasons');
      setReasons(loadedReasons);
      setReasonsError(loadedReasons.length === 0 ? t('oeeMultiEntry.noReasons') : null);
      reasonsLoadedRef.current = true;
    } catch (error: unknown) {
      if (generation !== reasonContextGeneration.current) return;
      reasonsLoadedRef.current = false;
      setReasonsError(readApiMessage(error, t('oeeMultiEntry.reasonLoadError')));
    } finally {
      if (generation === reasonContextGeneration.current) {
        reasonsLoadingRef.current = false;
        setReasonsLoading(false);
      }
    }
  }, [markCommunication, t]);

  const loadContext = useCallback(
    async (nextProcesses: OeeProcessCode[], processesToLoad: OeeProcessCode[] = nextProcesses) => {
      const generation = ++contextGeneration.current;
      const selectedProcessSet = new Set(nextProcesses);
      const requestedProcesses = RESOURCE_PROCESS_CODES.filter(
        (processCode) => selectedProcessSet.has(processCode) && processesToLoad.includes(processCode),
      );
      statusGeneration.current += 1;

      setResources((current) => current.filter((resource) => selectedProcessSet.has(resource.processCode)));
      setResourceLoadingByProcess(() =>
        Object.fromEntries(
          RESOURCE_PROCESS_CODES.filter((processCode) => selectedProcessSet.has(processCode)).map((processCode) => [
            processCode,
            requestedProcesses.includes(processCode),
          ]),
        ),
      );
      setResourceProcessErrors((current) => {
        const next: Partial<Record<OeeProcessCode, string>> = {};
        for (const processCode of RESOURCE_PROCESS_CODES) {
          if (selectedProcessSet.has(processCode) && !requestedProcesses.includes(processCode) && current[processCode]) {
            next[processCode] = current[processCode];
          }
        }
        return next;
      });

      if (requestedProcesses.length === 0) {
        setResources([]);
        setStatusByResource({});
        return;
      }

      void loadReasons();

      const resourceResults = await Promise.allSettled(
        requestedProcesses.map(async (requestedProcess) => {
          const response = await api
            .get('/oee/mobile/resources', {
              params: { processCode: requestedProcess },
              suppressErrorModal: true,
            })
            .finally(markCommunication);
          const loadedResources = readCollection<OeeResource>(response, 'resources')
            .filter(
              (resource) =>
                resource.processCode === requestedProcess &&
                (resource.resourceType === 'LINE' || resource.resourceType === 'CELL'),
            )
            .map(normalizeResource);
          return { processCode: requestedProcess, resources: loadedResources };
        }),
      );

      if (generation !== contextGeneration.current) return;

      let loadedResources: OeeResource[] = [];
      const successfulProcesses = new Set<OeeProcessCode>();
      const processErrors: Partial<Record<OeeProcessCode, string>> = {};
      resourceResults.forEach((result, index) => {
        const requestedProcess = requestedProcesses[index];
        if (!requestedProcess) return;
        if (result.status === 'fulfilled') {
          successfulProcesses.add(requestedProcess);
          loadedResources = [...loadedResources, ...result.value.resources];
        } else {
          processErrors[requestedProcess] = readApiMessage(result.reason, t('oeeMultiEntry.resourceLoadError'));
        }
      });

      setResources((current) => [
        ...current.filter(
          (resource) => selectedProcessSet.has(resource.processCode) && !successfulProcesses.has(resource.processCode),
        ),
        ...loadedResources,
      ]);
      setResourceProcessErrors((current) => {
        const next: Partial<Record<OeeProcessCode, string>> = {};
        for (const processCode of RESOURCE_PROCESS_CODES) {
          if (selectedProcessSet.has(processCode) && !requestedProcesses.includes(processCode) && current[processCode]) {
            next[processCode] = current[processCode];
          }
        }
        Object.assign(next, processErrors);
        return next;
      });
      setResourceLoadingByProcess((current) => {
        const next = { ...current };
        for (const processCode of requestedProcesses) next[processCode] = false;
        return next;
      });

      if (loadedResources.length > 0) void loadStatuses(loadedResources);
    },
    [loadReasons, loadStatuses, markCommunication, t],
  );

  useEffect(() => {
    pendingStorageKeyRef.current = pendingStorageKey;
    pendingQueryGenerationRef.current += 1;
    pendingStatusRequestRef.current = false;
    let cancelled = false;
    queueMicrotask(() => {
      if (cancelled) return;
      pendingSubmissionRef.current = null;
      submissionLockRef.current = false;
      setPendingStatusLoading(false);
      setPendingStatusSnapshotGeneration(null);
      setPendingSubmission(null);
      setPendingStatusByLine({});
      setPendingStorageError(null);

      if (!user || organizationId === null || !userId || !pendingStorageKey) {
        if (user) setPendingStorageError(t('oeeMultiEntry.pendingStorageUnavailable'));
        setBatchOutcome(null);
        setHydratedPendingStorageKey(pendingStorageKey ?? '');
        return;
      }

      let stored: PendingMultiEntrySubmission | null;
      try {
        stored = readPendingSubmission(pendingStorageKey);
      } catch (error: unknown) {
        pendingSubmissionRef.current = null;
        submissionLockRef.current = false;
        setPendingStorageError(
          readPendingStorageErrorMessage(error, t('oeeMultiEntry.pendingStorageUnavailable')),
        );
        setBatchOutcome(null);
        setHydratedPendingStorageKey(pendingStorageKey);
        return;
      }

      pendingSubmissionRef.current = stored;
      submissionLockRef.current = Boolean(stored);
      setPendingSubmission(stored);
      setPendingStatusByLine({});
      if (stored) {
        setBatchOutcome({
          mode: stored.mode,
          processCode: stored.processCode,
          lineCodes: stored.lineCodes,
          targetItemCount: stored.items?.length ?? stored.lineCodes.length,
          state: 'needsConfirmation',
          message: t('oeeMultiEntry.uncertainSubmission'),
          events: null,
        });
      } else {
        setBatchOutcome(null);
      }
      setHydratedPendingStorageKey(pendingStorageKey);
    });
    return () => {
      cancelled = true;
    };
  }, [organizationId, pendingStorageKey, t, user, userId]);

  useEffect(() => {
    if (!pendingSubmission || !worker || selectedWorkplace === pendingSubmission.processCode) return;
    let cancelled = false;
    queueMicrotask(() => {
      if (cancelled) return;
      setSelectedWorkplace(pendingSubmission.processCode);
      void loadContext([pendingSubmission.processCode]);
    });
    return () => {
      cancelled = true;
    };
  }, [loadContext, pendingSubmission, selectedWorkplace, worker]);

  const requeryPendingStatus = useCallback(async () => {
    const pending = pendingSubmissionRef.current;
    const queryStorageKey = pendingStorageKeyRef.current;
    if (
      !pending ||
      !queryStorageKey ||
      queryStorageKey !== pendingStorageKey ||
      organizationId === null ||
      !userId ||
      pendingStatusRequestRef.current
    ) return;

    const queryGeneration = pendingQueryGenerationRef.current + 1;
    pendingQueryGenerationRef.current = queryGeneration;

    pendingStatusRequestRef.current = true;
    setPendingStatusLoading(true);
    setPendingStatusSnapshotGeneration(null);
    setPendingStatusByLine({});
    try {
      const results = await Promise.allSettled(
        pending.lineCodes.map(async (lineCode) => {
          try {
            const response = await api.get('/oee/multi-entry/status', {
              params: { processCode: pending.processCode, lineCode },
              suppressErrorModal: true,
            });
            return { lineCode, status: normalizeMultiEntryStatus(response), error: null };
          } catch (error: unknown) {
            return {
              lineCode,
              status: null,
              error: readApiMessage(error, t('oeeMultiEntry.statusLoadError')),
            };
          } finally {
            if (
              pendingSubmissionRef.current === pending &&
              pendingStorageKeyRef.current === queryStorageKey &&
              pendingQueryGenerationRef.current === queryGeneration
            ) {
              markCommunication();
            }
          }
        }),
      );
      if (
        pendingSubmissionRef.current !== pending ||
        pendingStorageKeyRef.current !== queryStorageKey ||
        pendingQueryGenerationRef.current !== queryGeneration
      ) return;

      const next: Record<string, PendingStatusSnapshot> = {};
      results.forEach((result, index) => {
        const lineCode = pending.lineCodes[index];
        if (!lineCode) return;
        next[lineCode] = result.status === 'fulfilled'
          ? { status: result.value.status, error: result.value.error }
          : { status: null, error: readApiMessage(result.reason, t('oeeMultiEntry.statusLoadError')) };
      });
      setPendingStatusSnapshotGeneration(queryGeneration);
      setPendingStatusByLine(next);
      setBatchOutcome((current) =>
        current
          ? { ...current, message: `${current.message} ${t('oeeMultiEntry.statusRequeryComplete')}` }
          : current,
      );
    } finally {
      if (pendingQueryGenerationRef.current === queryGeneration) {
        pendingStatusRequestRef.current = false;
        setPendingStatusLoading(false);
      }
    }
  }, [markCommunication, organizationId, pendingStorageKey, t, userId]);

  useEffect(() => {
    if (batchOutcome?.state === 'needsConfirmation' && pendingSubmission && online) {
      void requeryPendingStatus();
    }
  }, [batchOutcome?.state, online, pendingSubmission, requeryPendingStatus]);

  const applyWorker = useCallback(
    (nextWorker: OeeWorker) => {
      setWorker(nextWorker);
      setWorkerInput(nextWorker.workerId);
      clearContext();
    },
    [clearContext],
  );

  const lookupWorker = useCallback(
    async (workerId: string): Promise<OeeWorker> => {
      try {
        const response = await api.get(`/oee/mobile/workers/${encodeURIComponent(workerId)}`, {
          suppressErrorModal: true,
        });
        const nextWorker = parseWorker(response);
        if (!nextWorker) throw new Error(t('oeeMultiEntry.workerResponseError'));
        return nextWorker;
      } finally {
        markCommunication();
      }
    },
    [markCommunication, t],
  );

  const confirmWorker = useCallback(async () => {
    const normalizedWorkerId = workerInput.trim();
    if (!normalizedWorkerId) {
      setWorkerError(t('oeeMultiEntry.workerRequired'));
      return;
    }

    setWorkerLoading(true);
    setWorkerError(null);
    try {
      const nextWorker = await lookupWorker(normalizedWorkerId);
      applyWorker(nextWorker);
      toast.success(t('oeeMultiEntry.workerConfirmed'));
    } catch (error: unknown) {
      const message = readApiMessage(error, t('oeeMultiEntry.workerNotFound'));
      setWorkerError(message);
      toast.error(message);
    } finally {
      setWorkerLoading(false);
    }
  }, [applyWorker, lookupWorker, t, workerInput]);

  const resolveAutoWorker = useCallback(
    async (candidateWorkerIds: string[]) => {
      const candidates = [...new Set(candidateWorkerIds.map((candidate) => candidate.trim()).filter(Boolean))];
      if (candidates.length === 0) return;

      setWorkerLoading(true);
      setWorkerError(null);
      let lastError: unknown = null;
      try {
        for (const workerId of candidates) {
          try {
            const nextWorker = await lookupWorker(workerId);
            applyWorker(nextWorker);
            return;
          } catch (error: unknown) {
            lastError = error;
          }
        }
        setWorkerError(readApiMessage(lastError, t('oeeMultiEntry.workerNotFound')));
      } finally {
        setWorkerLoading(false);
      }
    },
    [applyWorker, lookupWorker, t],
  );

  useEffect(() => {
    const loggedInUser = user;
    if (!loggedInUser) {
      autoWorkerIdentityRef.current = null;
      return;
    }
    const identity = typeof loggedInUser.id === 'string' ? loggedInUser.id.trim() : '';
    if (!identity) return;
    if (autoWorkerIdentityRef.current === identity) return;

    autoWorkerIdentityRef.current = identity;
    const candidates = [loggedInUser.empNo ?? '', loggedInUser.id];
    void resolveAutoWorker(candidates);
  }, [resolveAutoWorker, user]);

  const changeWorker = useCallback(() => {
    if (contextLocked) return;
    setWorker(null);
    setWorkerInput('');
    setWorkerError(null);
    clearContext();
  }, [clearContext, contextLocked]);

  const toggleWorkplace = useCallback(
    (processCode: OeeProcessCode) => {
      if (!worker || contextLocked) return;
      if (selectedWorkplace === processCode) return;
      setSelectedWorkplace(processCode);
      setEndReasonOverride(null);
      setSelectedResourceIds((current) => {
        const next = new Set(current);
        for (const resource of resources) {
          if (resource.processCode !== processCode) next.delete(resourceIdentity(resource));
        }
        return next;
      });
      clearBatchOutcome();
      void loadContext([processCode]);
    },
    [clearBatchOutcome, contextLocked, loadContext, resources, selectedWorkplace, worker],
  );

  const selectedProcessList = useMemo(
    () => (selectedWorkplace ? [selectedWorkplace] : []),
    [selectedWorkplace],
  );

  const retryProcess = useCallback(
    (processCode: OeeProcessCode) => {
      if (!worker || contextLocked || !selectedProcessList.includes(processCode)) return;
      void loadContext(selectedProcessList, [processCode]);
    },
    [contextLocked, loadContext, selectedProcessList, worker],
  );

  const selectMode = useCallback(
    (nextMode: MultiEntryMode) => {
      if (contextLocked) return;
      setMode(nextMode);
      setSelectedResourceIds(new Set());
      setReasonCode('');
      setEndReasonOverride(null);
      setMemo('');
      setReasonEditorOpen(false);
      clearBatchOutcome();
    },
    [clearBatchOutcome, contextLocked],
  );

  const toggleResource = useCallback(
    (resource: OeeResource) => {
      if (contextLocked) return;
      const key = resourceIdentity(resource);
      setEndReasonOverride(null);
      setSelectedResourceIds((current) => {
        const next = new Set(current);
        if (next.has(key)) next.delete(key);
        else if (isEligibleStatus(mode, statusByResource[key])) next.add(key);
        return next;
      });
      clearBatchOutcome();
    },
    [clearBatchOutcome, contextLocked, mode, statusByResource],
  );

  const retryReasons = useCallback(() => {
    if (selectedProcessList.length > 0 && !contextLocked) void loadReasons();
  }, [contextLocked, loadReasons, selectedProcessList]);

  const selectedResources = useMemo(
    () => resources.filter((resource) => selectedResourceIds.has(resourceIdentity(resource))),
    [resources, selectedResourceIds],
  );

  const selectedEndReasonTargets = useMemo<MultiEntryEndReasonTarget[]>(
    () => selectedResources.flatMap((resource) => {
      const openEvents = statusByResource[resourceIdentity(resource)]?.status?.openEvents ?? [];
      return openEvents.map((event) => ({
        lineCode: event.lineCode,
        dtSeq: event.dtSeq,
        reasonCode: event.reasonCode,
      }));
    }),
    [selectedResources, statusByResource],
  );
  const endReasonSummary = useMemo(
    () => summarizeEndReasons(selectedEndReasonTargets),
    [selectedEndReasonTargets],
  );
  const endReasonSnapshotKey = endReasonSummary.snapshotKey;
  const endReasonOverrideCode = getActiveEndReasonCode(endReasonOverride, endReasonSnapshotKey);
  const endReasonNeedsSelection = endReasonSummary.state === 'someMissing' || endReasonSummary.state === 'allMissing';
  const endDisplayedReasonCode = endReasonOverrideCode
    ?? (endReasonSummary.state === 'same' ? endReasonSummary.reasonCodes[0] ?? null : null);

  const visibleResources = useMemo(
    () => resources.filter((resource) => selectedProcessList.includes(resource.processCode)),
    [resources, selectedProcessList],
  );

  const visibleEligibleResources = useMemo(
    () =>
      visibleResources.filter((resource) =>
        isEligibleStatus(mode, statusByResource[resourceIdentity(resource)]),
      ),
    [mode, statusByResource, visibleResources],
  );

  const visibleSelectedCount = visibleResources.filter((resource) =>
    selectedResourceIds.has(resourceIdentity(resource)),
  ).length;
  const visibleSelectedEligibleCount = visibleEligibleResources.filter((resource) =>
    selectedResourceIds.has(resourceIdentity(resource)),
  ).length;
  const allVisibleEligibleSelected =
    visibleEligibleResources.length > 0 && visibleSelectedEligibleCount === visibleEligibleResources.length;
  const someVisibleEligibleSelected = visibleSelectedEligibleCount > 0 && !allVisibleEligibleSelected;
  const visibleSelectionState: boolean | 'mixed' = allVisibleEligibleSelected
    ? true
    : someVisibleEligibleSelected
      ? 'mixed'
      : false;

  const toggleVisibleEligible = useCallback(() => {
    if (contextLocked || visibleEligibleResources.length === 0) return;
    setEndReasonOverride(null);
    setSelectedResourceIds((current) => {
      const clearVisible = visibleEligibleResources.every((resource) =>
        current.has(resourceIdentity(resource)),
      );
      const next = new Set(current);
      for (const resource of visibleEligibleResources) {
        const key = resourceIdentity(resource);
        if (clearVisible) next.delete(key);
        else next.add(key);
      }
      return next;
    });
    clearBatchOutcome();
  }, [clearBatchOutcome, contextLocked, visibleEligibleResources]);

  const statusLoading = resources.some((resource) => statusByResource[resourceIdentity(resource)]?.loading);
  const lastCommunicationLabel = lastCommunicationAt
    ? new Date(lastCommunicationAt).toLocaleTimeString(undefined, {
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
      })
    : t('oeeMultiEntry.notYet');

  const refreshStatuses = useCallback(async () => {
    if (selectedProcessList.length > 0 && resources.length > 0) await loadStatuses(resources);
  }, [loadStatuses, resources, selectedProcessList.length]);

  const canConfirmPending =
    canConfirmPendingSubmission({
      pending: pendingSubmission,
      statusByLine: pendingStatusByLine,
      statusLoading: pendingStatusLoading,
      online,
      submitting,
    }) &&
    pendingStatusSnapshotGeneration !== null &&
    organizationId !== null &&
    Boolean(userId) &&
    pendingStorageKey !== null &&
    hydratedPendingStorageKey === pendingStorageKey &&
    !pendingStorageError;

  const submitBatch = useCallback(async () => {
    // This ref guard is synchronous so two clicks cannot pass before React rerenders.
    if (submissionLockRef.current || pendingSubmissionRef.current || submitting || !pendingLockReady || pendingStorageError) {
      return;
    }
    const submissionStorageKey = pendingStorageKeyRef.current;
    if (organizationId === null || !userId || !pendingStorageKey || submissionStorageKey !== pendingStorageKey) {
      const message = t('oeeMultiEntry.pendingStorageUnavailable');
      setPendingStorageError(message);
      toast.error(message);
      return;
    }
    if (!online) {
      toast.error(t('oeeMultiEntry.offlineBlocked'));
      return;
    }
    const processCode = selectedProcessList[0];
    if (!worker || !processCode || selectedResources.length === 0) {
      toast.error(t('oeeMultiEntry.selectAtLeastOne'));
      return;
    }
    const normalizedStartReasonCode = reasonCode.trim();
    if (mode === 'END' && endReasonNeedsSelection && !endReasonOverrideCode) {
      toast.error(t('oeeMultiEntry.reasonRequired'));
      return;
    }
    if (mode === 'START' && utf8ByteLength(memo) > 500) {
      toast.error(t('oeeMultiEntry.memoTooLong'));
      return;
    }

    const lineCodes = selectedResources.map((resource) => resource.resourceCode);
    if (new Set(lineCodes).size !== lineCodes.length) {
      toast.error(t('oeeMultiEntry.duplicateLineSelection'));
      return;
    }

    let endItems: MultiEntryEndItem[] | undefined;
    if (mode === 'END') {
      endItems = [];
      for (const resource of selectedResources) {
        const openEvents = statusByResource[resourceIdentity(resource)]?.status?.openEvents ?? [];
        if (openEvents.length === 0 || !isEligibleStatus('END', statusByResource[resourceIdentity(resource)])) {
          toast.error(t('oeeMultiEntry.statusChanged'));
          await refreshStatuses();
          return;
        }
        endItems.push(...openEvents.map((event) => ({ lineCode: resource.resourceCode, dtSeq: event.dtSeq })));
      }
      if (new Set(endItems.map((item) => item.dtSeq)).size !== endItems.length) {
        toast.error(t('oeeMultiEntry.statusChanged'));
        await refreshStatuses();
        return;
      }
    }

    const pending: PendingMultiEntrySubmission = {
      mode,
      processCode,
      lineCodes,
      ...(endItems ? { items: endItems } : {}),
      createdAt: Date.now(),
    };
    const payload = mode === 'START'
      ? makeStartBatchPayload({
          processCode,
          lineCodes,
          workerId: worker.workerId,
          reasonCode: normalizedStartReasonCode || undefined,
          memo: memo.trim() || undefined,
        })
      : makeEndBatchPayload({
          processCode,
          items: endItems ?? [],
          ...(endReasonOverrideCode ? { reasonCode: endReasonOverrideCode } : {}),
        });

    try {
      writePendingSubmission(submissionStorageKey, pending);
    } catch (error: unknown) {
      const message = readPendingStorageErrorMessage(error, t('oeeMultiEntry.pendingStorageUnavailable'));
      pendingSubmissionRef.current = null;
      submissionLockRef.current = false;
      setPendingSubmission(null);
      setPendingStatusByLine({});
      setPendingStorageError(message);
      setBatchOutcome(null);
      setSubmitting(false);
      toast.error(message);
      return;
    }

    setPendingStorageError(null);
    pendingQueryGenerationRef.current += 1;
    setPendingStatusSnapshotGeneration(null);
    submissionLockRef.current = true;
    pendingSubmissionRef.current = pending;
    setPendingSubmission(pending);
    setPendingStatusByLine({});
    setBatchOutcome(null);
    setSubmitting(true);
    let response: unknown = null;
    let refreshAfterResponse = false;
    try {
      response = await api.post(
        `/oee/multi-entry/${mode === 'START' ? 'start' : 'end'}`,
        payload,
        { suppressErrorModal: true, skipSuccessToast: true },
      ).finally(markCommunication);
      const normalized = normalizeBatchResponse(response);
      validateBatchEvents(
        normalized.events,
        mode === 'START'
          ? { mode: 'START', organizationId, lineCodes }
          : {
              mode: 'END',
              organizationId,
              items: endItems ?? [],
              ...(endReasonOverrideCode ? { reasonCode: endReasonOverrideCode } : {}),
            },
      );
      setBatchOutcome({
        mode,
        processCode,
        lineCodes,
        targetItemCount: endItems?.length ?? lineCodes.length,
        state: 'success',
        message: t('oeeMultiEntry.batchSaved'),
        events: normalized.events,
      });
      clearPendingSubmission(submissionStorageKey);
      pendingSubmissionRef.current = null;
      submissionLockRef.current = false;
      setPendingSubmission(null);
      toast.success(t('oeeMultiEntry.batchSaved'));
      refreshAfterResponse = true;
    } catch (error: unknown) {
      const status = responseStatus(error) ?? responseHttpStatus(response);
      if (error instanceof PendingSubmissionStorageError) {
        setPendingStorageError(readPendingStorageErrorMessage(error, t('oeeMultiEntry.pendingStorageUnavailable')));
      }
      const definitiveFailure = status !== null && status >= 400 && status < 500 && status !== 408;
      const uncertain = !definitiveFailure;
      if (uncertain) {
        // A changed GET state cannot attribute this POST, so the lock remains persisted.
        setBatchOutcome({
          mode,
          processCode,
          lineCodes,
          targetItemCount: endItems?.length ?? lineCodes.length,
          state: 'needsConfirmation',
          message: t('oeeMultiEntry.uncertainSubmission'),
          events: null,
        });
        toast.error(t('oeeMultiEntry.needsConfirmation'));
      } else {
        setBatchOutcome({
          mode,
          processCode,
          lineCodes,
          targetItemCount: endItems?.length ?? lineCodes.length,
          state: 'definitiveFailure',
          message: readApiMessage(error, t('oeeMultiEntry.error')),
          events: null,
        });
        const message = readApiMessage(error, t('oeeMultiEntry.error'));
        try {
          clearPendingSubmission(submissionStorageKey);
          pendingSubmissionRef.current = null;
          submissionLockRef.current = false;
          setPendingSubmission(null);
        } catch (clearError: unknown) {
          setPendingStorageError(
            readPendingStorageErrorMessage(clearError, t('oeeMultiEntry.pendingStorageUnavailable')),
          );
          toast.error(readPendingStorageErrorMessage(clearError, t('oeeMultiEntry.pendingStorageUnavailable')));
        }
        toast.error(message);
        refreshAfterResponse = true;
      }
    } finally {
      if (refreshAfterResponse) await refreshStatuses();
      setSubmitting(false);
    }
  }, [
    endReasonNeedsSelection,
    endReasonOverrideCode,
    markCommunication,
    memo,
    mode,
    online,
    pendingLockReady,
    reasonCode,
    refreshStatuses,
    selectedProcessList,
    selectedResources,
    organizationId,
    pendingStorageError,
    pendingStorageKey,
    statusByResource,
    submitting,
    t,
    userId,
    worker,
  ]);

  const confirmPendingSubmission = useCallback(() => {
    const pending = pendingSubmissionRef.current;
    const storageKey = pendingStorageKeyRef.current;
    const queryGeneration = pendingQueryGenerationRef.current;
    const isCurrentPending =
      pending !== null &&
      pendingSubmissionRef.current === pending &&
      storageKey !== null &&
      pendingStorageKeyRef.current === storageKey &&
      pendingQueryGenerationRef.current === queryGeneration;

    if (
      !canConfirmPending ||
      !isCurrentPending ||
      storageKey === null ||
      storageKey !== pendingStorageKey ||
      organizationId === null ||
      !userId ||
      pendingStatusSnapshotGeneration !== queryGeneration
    ) return;
    if (!pending || !storageKey) return;

    try {
      clearPendingSubmission(storageKey);
    } catch (error: unknown) {
      const message = readPendingStorageErrorMessage(error, t('oeeMultiEntry.pendingStorageUnavailable'));
      setPendingStorageError(message);
      toast.error(message);
      return;
    }

    const stillCurrentPending =
      pendingSubmissionRef.current === pending &&
      pendingStorageKeyRef.current === storageKey &&
      pendingQueryGenerationRef.current === queryGeneration;
    if (!stillCurrentPending) {
      setPendingStorageError(t('oeeMultiEntry.pendingStorageUnavailable'));
      return;
    }

    const latestPendingStatuses = pendingStatusByLine;
    statusGeneration.current += 1;
    pendingQueryGenerationRef.current = queryGeneration + 1;
    pendingStatusRequestRef.current = false;
    pendingSubmissionRef.current = null;
    submissionLockRef.current = false;
    setStatusByResource((current) => {
      const next = { ...current };
      for (const resource of resources) {
        if (resource.processCode !== pending.processCode || !pending.lineCodes.includes(resource.resourceCode)) continue;
        const snapshot = latestPendingStatuses[resource.resourceCode];
        if (!snapshot?.status || snapshot.error) continue;
        next[resourceIdentity(resource)] = { loading: false, status: snapshot.status, error: null };
      }
      return next;
    });
    setPendingSubmission(null);
    setPendingStatusByLine({});
    setPendingStatusSnapshotGeneration(null);
    setPendingStatusLoading(false);
    setSelectedResourceIds(new Set());
    setEndReasonOverride(null);
    setReasonCode('');
    setMemo('');
    setBatchOutcome(null);
    toast.success(t('oeeMultiEntry.pendingConfirmationComplete'));
  }, [
    canConfirmPending,
    organizationId,
    pendingStatusByLine,
    pendingStatusSnapshotGeneration,
    pendingStorageKey,
    resources,
    t,
    userId,
  ]);

  const resourceLabels: AvailabilityLabels = {
    loading: t('oeeMultiEntry.statusLoading'),
    unknown: t('oeeMultiEntry.statusUnknown'),
    startOnly: t('oeeMultiEntry.startOnly'),
    endOnly: t('oeeMultiEntry.endOnly'),
    inapplicable: t('oeeMultiEntry.inapplicable'),
    running: t('oeeMultiEntry.running'),
    downtime: t('oeeMultiEntry.downtime'),
  };
  const selectedReasonCode = mode === 'START' ? reasonCode : endDisplayedReasonCode;
  const selectedReason = reasons.find((reason) => reason.reasonCode === selectedReasonCode);
  const pickerReasonCode = mode === 'START' ? reasonCode : endReasonOverrideCode;
  const selectedReasonTypeLabel = selectedReason
    ? selectedReason.reasonType === 'PLAN'
      ? t('oeeMultiEntry.reasonTypePlan')
      : t('oeeMultiEntry.reasonTypeUnplan')
    : '';
  const reasonGroups = useMemo(
    () =>
      (['PLAN', 'UNPLAN'] as const).map((reasonType) => ({
        reasonType,
        reasons: reasons
          .filter((reason) => reason.reasonType === reasonType)
          .sort(
            (left, right) =>
              left.displayOrder - right.displayOrder || left.reasonCode.localeCompare(right.reasonCode),
          ),
      })),
    [reasons],
  );
  const reasonCardCapacity = useMemo(() => {
    const largestReasonGroup = Math.max(6, ...reasonGroups.map(({ reasons: groupedReasons }) => groupedReasons.length));
    return largestReasonGroup % 2 === 0 ? largestReasonGroup : largestReasonGroup + 1;
  }, [reasonGroups]);
  const firstReasonCode = reasonGroups.find(({ reasons: groupedReasons }) => groupedReasons.length > 0)?.reasons[0]?.reasonCode;

  useEffect(() => {
    if (!reasonEditorOpen || reasonsLoading || !firstReasonButtonRef.current) return;
    firstReasonButtonRef.current.focus();
  }, [reasonEditorOpen, reasonsLoading]);

  const openReasonEditor = useCallback(() => {
    if (contextLocked) return;
    setReasonEditorOpen(true);
    void loadReasons();
  }, [contextLocked, loadReasons]);

  const selectedEligibleCount = selectedResources.filter((resource) =>
    isEligibleStatus(mode, statusByResource[resourceIdentity(resource)]),
  ).length;
  const selectedOpenEventCount = selectedEndReasonTargets.length;
  const allSelectedEligible = selectedResources.length > 0 && selectedEligibleCount === selectedResources.length;
  const canSubmitStart = mode === 'START' && allSelectedEligible && !reasonsLoading;
  const canSubmitEnd = mode === 'END' && allSelectedEligible && (!endReasonNeedsSelection || Boolean(endReasonOverrideCode));
  const canSubmit = (canSubmitStart || canSubmitEnd) && online && !submitting && !contextLocked;
  const endReasonStatusLabel = endReasonSummary.state === 'same'
    ? t('oeeMultiEntry.endReasonSame')
    : endReasonSummary.state === 'mixed'
      ? t('oeeMultiEntry.endReasonMixed')
      : endReasonSummary.state === 'someMissing'
        ? t('oeeMultiEntry.endReasonSomeMissing')
        : t('oeeMultiEntry.endReasonAllMissing');

  return (
    <div className="oee-multi-entry-board flex h-full min-h-0 flex-col overflow-hidden bg-[#07111d] text-slate-100">
      <div className={`mx-auto flex min-h-0 w-full max-w-[1680px] flex-1 flex-col ${isCompactFullView ? 'gap-2 overflow-hidden p-2' : 'gap-3 overflow-y-auto p-3 sm:p-4 lg:p-5'}`}>
        <header className="oee-multi-entry-header shrink-0 rounded-2xl border border-slate-700/80 bg-[#0d1a2a] p-3 shadow-[0_12px_32px_rgba(0,0,0,0.24)] sm:p-4">
          <div className="oee-multi-entry-header-row flex min-w-0 flex-col gap-3 lg:grid lg:grid-cols-[minmax(10.5rem,1fr)_minmax(6.75rem,0.68fr)_minmax(8rem,0.82fr)_minmax(11rem,1.05fr)_3.5rem] lg:items-stretch lg:gap-1">
            <div className="flex min-w-0 items-center gap-2">
              <div className="oee-header-optional-icon shrink-0 rounded-xl border border-cyan-400/30 bg-cyan-400/10 p-2 text-cyan-300">
                <PauseCircle className="h-8 w-8" aria-hidden="true" />
              </div>
              <div className="min-w-0">
                <p className="font-mono text-xs font-bold uppercase tracking-[0.24em] text-cyan-300 lg:hidden">C / OPERATIONS BOARD</p>
                <h1 className="truncate text-xl font-black tracking-tight text-white sm:text-2xl lg:text-lg xl:text-xl">{t('oeeMultiEntry.title')}</h1>
                <p className="oee-header-optional-copy mt-0.5 truncate text-xs text-slate-300">{t('oeeMultiEntry.subtitle')}</p>
              </div>
            </div>

            <div
              data-testid="oee-multi-status-area"
              className="grid min-w-0 grid-cols-1 gap-2 sm:grid-cols-2 lg:contents"
            >
              <div
                className={`flex min-h-[48px] min-w-0 items-center gap-2 rounded-xl border px-2 ${
                  online ? 'border-emerald-400/40 bg-emerald-400/10' : 'border-red-400/50 bg-red-400/10'
                }`}
                role="status"
                aria-label={t('oeeMultiEntry.deviceNetwork')}
              >
                {online ? <Wifi className="oee-header-optional-icon h-5 w-5 shrink-0 text-emerald-300" aria-hidden="true" /> : <WifiOff className="oee-header-optional-icon h-5 w-5 shrink-0 text-red-300" aria-hidden="true" />}
                <div className="min-w-0">
                  <span className="block truncate text-[11px] font-bold uppercase tracking-wide text-slate-400">{t('oeeMultiEntry.deviceNetwork')}</span>
                  <strong className={`block truncate text-sm ${online ? 'text-emerald-200' : 'text-red-200'}`}>{online ? t('oeeMultiEntry.online') : t('oeeMultiEntry.offline')}</strong>
                </div>
              </div>
              <div
                className="flex min-h-[48px] min-w-0 items-center gap-2 rounded-xl border border-slate-700 bg-[#101f31] px-2"
                role="status"
                aria-label={t('oeeMultiEntry.recentMesCommunication')}
              >
                <Send className="oee-header-optional-icon h-5 w-5 shrink-0 text-amber-300" aria-hidden="true" />
                <div className="min-w-0">
                  <span className="block truncate text-[11px] font-bold uppercase tracking-wide text-slate-400">{t('oeeMultiEntry.recentMesCommunication')}</span>
                  <strong className="block truncate font-mono text-xs text-slate-100">{lastCommunicationLabel}</strong>
                </div>
              </div>
              {worker && (
                <div
                  data-testid="oee-multi-worker-summary"
                  className="worker-summary flex min-h-[48px] min-w-0 items-center justify-between gap-1 rounded-xl border border-emerald-400/30 bg-emerald-400/10 px-2"
                  role="status"
                  aria-label={`${t('oeeMultiEntry.workerId')}: ${worker.workerName} · ${worker.workerId}`}
                >
                  <div className="flex min-w-0 items-center gap-1.5">
                    <UserRound className="oee-header-optional-icon h-5 w-5 shrink-0 text-emerald-200" aria-hidden="true" />
                    <span className="min-w-0 truncate text-xs font-bold text-emerald-100 xl:text-sm">
                      {worker.workerName} <span className="font-mono font-semibold text-emerald-200/80">· {worker.workerId}</span>
                    </span>
                  </div>
                  <button
                    type="button"
                    onClick={changeWorker}
                    disabled={contextLocked}
                    className="inline-flex min-h-[44px] min-w-[44px] shrink-0 cursor-pointer flex-col items-center justify-center rounded-lg border border-slate-600 px-1.5 text-[11px] font-bold leading-tight text-slate-100 transition hover:border-cyan-300 hover:bg-cyan-300/10 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    <span>{t('oeeMultiEntry.changeWorkerLine1')}</span>
                    <span>{t('oeeMultiEntry.changeWorkerLine2')}</span>
                  </button>
                </div>
              )}
              {!worker && (
                <form
                  data-testid="oee-multi-worker-form"
                  className="grid min-h-[48px] min-w-0 grid-cols-[minmax(0,1fr)_auto] items-end gap-1 rounded-xl border border-slate-700 bg-[#101f31] p-1 sm:col-span-2 lg:col-span-1"
                  onSubmit={(event) => {
                    event.preventDefault();
                    void confirmWorker();
                  }}
                >
                  <label className="flex min-w-0 flex-col text-[10px] font-semibold leading-tight text-slate-300">
                    <span className="truncate">{t('oeeMultiEntry.workerId')}</span>
                    <input
                      value={workerInput}
                      onChange={(event) => setWorkerInput(event.target.value)}
                      disabled={workerLoading || contextLocked}
                      placeholder={t('oeeMultiEntry.workerPlaceholder')}
                      autoComplete="off"
                      className="mt-0.5 min-h-[44px] min-w-0 rounded-lg border border-slate-600 bg-[#07111d] px-2 text-sm font-semibold text-white outline-none transition focus:border-cyan-300 focus:ring-2 focus:ring-cyan-300/30 disabled:cursor-not-allowed disabled:opacity-50"
                      aria-describedby={workerError ? 'oee-multi-worker-error' : undefined}
                    />
                  </label>
                  <button
                    type="submit"
                    disabled={workerLoading || !workerInput.trim() || contextLocked}
                    aria-label={t('oeeMultiEntry.workerConfirm')}
                    className="inline-flex min-h-[44px] min-w-[44px] cursor-pointer items-center justify-center rounded-lg bg-cyan-400 px-2 text-xs font-black text-slate-950 shadow-lg shadow-cyan-400/20 transition hover:bg-cyan-300 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-200 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    {workerLoading ? <Loader2 className="h-4 w-4 animate-spin" aria-hidden="true" /> : t('common.confirm')}
                  </button>
                </form>
              )}
            </div>

            <div
              data-testid="oee-multi-view-switch"
              className="flex min-h-[48px] min-w-[48px] shrink-0 items-stretch rounded-xl border border-slate-700 bg-[#101f31] p-1"
              role="group"
              aria-label={t('oeeMultiEntry.viewMode')}
            >
              <span className="sr-only">{t('oeeMultiEntry.viewMode')}</span>
              <button
                type="button"
                onClick={() => switchView(viewMode === 'normal' ? 'full' : 'normal')}
                disabled={submitting || contextLocked}
                aria-label={viewMode === 'normal' ? t('oeeMultiEntry.viewFull') : t('oeeMultiEntry.viewNormal')}
                className="flex min-h-[44px] min-w-[44px] flex-1 cursor-pointer flex-col items-center justify-center rounded-lg px-1 text-[11px] font-black leading-tight text-slate-100 transition hover:bg-cyan-300/10 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 disabled:cursor-not-allowed disabled:opacity-45"
              >
                {viewMode === 'normal' ? (
                  <>
                    <span>{t('oeeMultiEntry.viewFullLine1')}</span>
                    <span>{t('oeeMultiEntry.viewFullLine2')}</span>
                  </>
                ) : t('oeeMultiEntry.viewNormal')}
              </button>
            </div>
          </div>

          {workerError && <p id="oee-multi-worker-error" className="mt-2 text-sm font-semibold text-red-300">{workerError}</p>}
        </header>

        <div className={`grid min-h-0 min-w-0 ${isCompactFullView ? 'flex-1 grid-cols-[minmax(0,3fr)_minmax(0,2fr)] gap-2' : 'shrink-0 grid-cols-1 gap-3 lg:flex-1 lg:grid-cols-[minmax(0,3fr)_minmax(0,2fr)]'}`}>
          <section className={`flex ${isCompactFullView ? 'min-h-0' : 'min-h-[560px]'} min-w-0 flex-col overflow-hidden rounded-2xl border border-slate-700/80 bg-[#0d1a2a] p-3 shadow-[0_12px_32px_rgba(0,0,0,0.2)] sm:p-4`} aria-labelledby="oee-multi-selection-title">
            <div className="flex shrink-0 flex-col gap-3 xl:flex-row xl:items-end xl:justify-between">
              <div>
                <p className="font-mono text-xs font-bold uppercase tracking-[0.24em] text-cyan-300">01 / SELECT</p>
                <h2 id="oee-multi-selection-title" className="mt-1 text-lg font-black text-white">{t('oeeMultiEntry.selectionTitle')}</h2>
              </div>
            </div>

            <div className="mt-2 grid shrink-0 grid-cols-1 gap-2 sm:grid-cols-2" role="group" aria-label={t('oeeMultiEntry.processSelection')}>
              {RESOURCE_PROCESS_CODES.map((processCode) => {
                const selected = selectedWorkplace === processCode;
                return (
                  <button
                    key={processCode}
                    data-testid={`oee-multi-process-${processCode.toLowerCase()}`}
                    type="button"
                    onClick={() => toggleWorkplace(processCode)}
                    disabled={!worker || contextLocked}
                    aria-pressed={selected}
                    className={`inline-flex min-h-[64px] cursor-pointer items-center gap-3 rounded-xl border px-4 text-left transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 ${
                      selected ? 'border-cyan-300 bg-cyan-400/15 text-white' : 'border-slate-600 bg-[#07111d] text-slate-300 hover:border-cyan-300/70'
                    } disabled:cursor-not-allowed disabled:opacity-45`}
                  >
                    <span className="flex h-6 w-6 shrink-0 items-center justify-center rounded border border-cyan-200" aria-hidden="true">
                      {selected ? <Check className="h-4 w-4" /> : null}
                    </span>
                    <span className="min-w-0">
                      <strong className="block font-mono text-lg font-black">{processCode}</strong>
                      <small className="mt-0.5 block truncate text-xs font-semibold opacity-75">
                        {processCode === 'SMT' ? t('oeeMultiEntry.processGroupSmt') : t('oeeMultiEntry.processGroupAssy')}
                      </small>
                    </span>
                  </button>
                );
              })}
            </div>

            <div className="mt-3 flex min-h-0 flex-1 flex-col overflow-hidden rounded-xl border border-slate-700 bg-[#07111d] p-3">
              {selectedProcessList.length > 0 && (
                <div data-testid="oee-multi-resource-header" className="flex min-w-0 flex-wrap items-center gap-2 sm:flex-nowrap">
                  <div className="min-w-0 flex-1 basis-full sm:basis-auto">
                    <h3 className="truncate text-base font-black text-white">{t('oeeMultiEntry.resourceList')}</h3>
                    <p className="mt-0.5 text-xs text-slate-400">{t('oeeMultiEntry.selectionHint')}</p>
                    {visibleResources.length > 0 && (
                      <p className="mt-1 text-xs font-semibold text-cyan-200">
                        {t('oeeMultiEntry.visible')}: {visibleResources.length} · {t('oeeMultiEntry.selected')}: {visibleSelectedCount}
                      </p>
                    )}
                    {statusLoading && (
                      <span className="mt-1 inline-flex items-center gap-1.5 text-xs font-semibold text-cyan-200">
                        <Loader2 className="h-4 w-4 animate-spin" aria-hidden="true" />
                        {t('oeeMultiEntry.statusLoading')}
                      </span>
                    )}
                  </div>
                  <div role="group" aria-label={t('oeeMultiEntry.mode')} className="inline-flex min-h-[44px] shrink-0 overflow-hidden rounded-lg border border-slate-600 bg-[#101f31]">
                    <button
                      type="button"
                      onClick={() => selectMode('START')}
                      disabled={!worker || contextLocked}
                      aria-pressed={mode === 'START'}
                      className={`inline-flex min-h-[44px] min-w-[4.25rem] cursor-pointer flex-col items-center justify-center px-2 transition focus-visible:z-10 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 ${
                        mode === 'START' ? 'bg-emerald-400/20 text-emerald-100' : 'text-slate-300 hover:bg-emerald-300/10'
                      } disabled:cursor-not-allowed disabled:opacity-45`}
                    >
                      <strong className="text-xs font-black leading-none">{t('oeeMultiEntry.startMode')}</strong>
                      <small className="mt-1 whitespace-nowrap text-[10px] font-semibold leading-none opacity-80">{t('oeeMultiEntry.startRule')}</small>
                    </button>
                    <button
                      type="button"
                      onClick={() => selectMode('END')}
                      disabled={!worker || contextLocked}
                      aria-pressed={mode === 'END'}
                      className={`inline-flex min-h-[44px] min-w-[4.25rem] cursor-pointer flex-col items-center justify-center border-l border-slate-600 px-2 transition focus-visible:z-10 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 ${
                        mode === 'END' ? 'bg-red-400/20 text-red-100' : 'text-slate-300 hover:bg-red-300/10'
                      } disabled:cursor-not-allowed disabled:opacity-45`}
                    >
                      <strong className="text-xs font-black leading-none">{t('oeeMultiEntry.endMode')}</strong>
                      <small className="mt-1 whitespace-nowrap text-[10px] font-semibold leading-none opacity-80">{t('oeeMultiEntry.endRule')}</small>
                    </button>
                  </div>
                  {visibleResources.length > 0 && (
                    <button
                      data-testid="oee-multi-select-all"
                      type="button"
                      role="checkbox"
                      aria-checked={visibleSelectionState}
                      aria-label={`${t('oeeMultiEntry.selectAllEligible')} (${visibleSelectedEligibleCount}/${visibleEligibleResources.length})`}
                      onClick={toggleVisibleEligible}
                      disabled={contextLocked || visibleEligibleResources.length === 0}
                      className="inline-flex min-h-[44px] shrink-0 cursor-pointer items-center gap-1.5 rounded-lg border border-cyan-300/60 px-2 text-left text-xs font-bold text-cyan-100 transition hover:bg-cyan-300/10 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 disabled:cursor-not-allowed disabled:opacity-45"
                    >
                      <span className="flex h-5 w-5 items-center justify-center rounded border border-cyan-200" aria-hidden="true">
                        {visibleSelectionState === true ? <Check className="h-4 w-4" /> : visibleSelectionState === 'mixed' ? <Minus className="h-4 w-4" /> : null}
                      </span>
                      <span className="whitespace-nowrap">{t('oeeMultiEntry.selectAll')}</span>
                      <span className="whitespace-nowrap font-mono">{visibleSelectedEligibleCount}/{visibleEligibleResources.length}</span>
                    </button>
                  )}
                </div>
              )}

              {!worker && (
                <div className="flex flex-1 flex-col items-center justify-center gap-2 py-10 text-center text-slate-400">
                  <UserRound className="h-10 w-10" aria-hidden="true" />
                  <p className="font-semibold">{t('oeeMultiEntry.workerFirst')}</p>
                </div>
              )}
              {worker && selectedProcessList.length === 0 && (
                <div className="flex flex-1 flex-col items-center justify-center gap-2 py-10 text-center text-slate-400">
                  <PlayCircle className="h-10 w-10" aria-hidden="true" />
                  <p className="font-semibold">{t('oeeMultiEntry.selectProcess')}</p>
                </div>
              )}
              {worker && selectedProcessList.length > 0 && (
                <div data-testid="oee-multi-resource-groups" className="mt-3 min-h-0 flex-1 overflow-y-auto overflow-x-hidden overscroll-contain pr-1">
                  <div className={`grid min-w-0 gap-3 ${selectedProcessList.length > 1 ? 'grid-cols-1 xl:grid-cols-2' : 'grid-cols-1'}`}>
                    {selectedProcessList.map((processCode) => {
                      const processResources = resources.filter((resource) => resource.processCode === processCode);
                      const processLoading = Boolean(resourceLoadingByProcess[processCode]);
                      const processError = resourceProcessErrors[processCode];
                      return (
                        <section key={processCode} data-process-code={processCode} className="min-w-0 rounded-xl border border-slate-700/80 bg-[#101f31] p-2.5">
                          <div className="flex min-w-0 items-center justify-between gap-2">
                            <div className="min-w-0">
                              <h4 className="truncate text-sm font-black text-white">
                                {processCode === 'SMT' ? t('oeeMultiEntry.processGroupSmt') : t('oeeMultiEntry.processGroupAssy')}
                              </h4>
                              <p className="mt-0.5 font-mono text-[11px] font-bold text-slate-400">{processResources.length}</p>
                            </div>
                            {processLoading && <Loader2 className="h-4 w-4 shrink-0 animate-spin text-cyan-300" aria-hidden="true" />}
                          </div>

                          {processError && (
                            <div className="mt-2 flex min-w-0 items-center justify-between gap-2 rounded-lg border border-amber-300/40 bg-amber-300/10 px-2.5 py-2 text-xs text-amber-100" role="status">
                              <div className="min-w-0">
                                <p className="truncate font-semibold">{t('oeeMultiEntry.partialResourceLoadError', { processes: processCode })}</p>
                                <p className="mt-0.5 truncate text-[11px] text-amber-200/80">{processError}</p>
                              </div>
                              <button
                                type="button"
                                onClick={() => retryProcess(processCode)}
                                disabled={contextLocked}
                                aria-label={`${t('oeeMultiEntry.retry')} ${processCode}`}
                                className="inline-flex min-h-[64px] shrink-0 cursor-pointer items-center gap-1.5 rounded-lg border border-cyan-300 px-2.5 font-bold text-cyan-200 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 disabled:cursor-not-allowed disabled:opacity-50"
                              >
                                <RefreshCw className="h-4 w-4" aria-hidden="true" />{t('oeeMultiEntry.retry')}
                              </button>
                            </div>
                          )}

                          {processLoading && (
                            <div className="mt-2 flex min-h-[72px] items-center justify-center gap-2 rounded-lg border border-dashed border-slate-700 px-2 text-center text-xs text-slate-400">
                              <Loader2 className="h-5 w-5 animate-spin text-cyan-300" aria-hidden="true" />
                              <span>{t('oeeMultiEntry.resourcesLoading')}</span>
                            </div>
                          )}
                          {!processLoading && !processError && processResources.length === 0 && (
                            <div className="mt-2 flex min-h-[72px] items-center justify-center gap-2 rounded-lg border border-dashed border-slate-700 px-2 text-center text-xs text-slate-400">
                              <Ban className="h-5 w-5" aria-hidden="true" />
                              <span>{t('oeeMultiEntry.noResources')}</span>
                            </div>
                          )}
                          {!processLoading && processResources.length > 0 && (
                            <div className={`mt-2 grid min-w-0 gap-2 ${selectedProcessList.length === 1 ? 'grid-cols-1 sm:grid-cols-2 2xl:grid-cols-3' : 'grid-cols-1 sm:grid-cols-2'}`}>
                              {processResources.map((resource) => {
                                const key = resourceIdentity(resource);
                                const selected = selectedResourceIds.has(key);
                                const availability = getResourceAvailability(mode, statusByResource[key], resourceLabels);
                                const StateIcon = availability.icon;
                                return (
                                  <button
                                    key={key}
                                    data-testid="oee-multi-resource-card"
                                    type="button"
                                    onClick={() => toggleResource(resource)}
                                    disabled={contextLocked || (availability.disabled && !selected)}
                                    aria-disabled={contextLocked || (availability.disabled && !selected)}
                                    aria-pressed={selected}
                                    aria-label={`${resource.resourceCode}, ${resource.resourceName}, ${resource.resourceType}, ${availability.label}${availability.disabledReason ? `, ${availability.disabledReason}` : ''}`}
                                    title={availability.disabledReason}
                                    className={`min-h-[56px] min-w-0 cursor-pointer rounded-lg border p-2 text-left transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 focus-visible:ring-offset-2 focus-visible:ring-offset-[#07111d] ${
                                      selected ? 'border-cyan-300 bg-cyan-400/15 ring-2 ring-cyan-300/30' : 'border-slate-700 bg-[#0d1a2a] hover:border-cyan-300/70 hover:bg-cyan-300/5'
                                    } disabled:cursor-not-allowed disabled:opacity-70`}
                                  >
                                    <div data-testid="oee-multi-resource-card-identity" className="flex min-w-0 items-center gap-2">
                                      <span className="shrink-0 truncate font-mono text-sm font-black text-white">{resource.resourceCode}</span>
                                      <span className="min-w-0 flex-1 truncate text-xs font-semibold text-slate-300">{resource.resourceName}</span>
                                      <span className={`flex h-5 w-5 shrink-0 items-center justify-center rounded border ${selected ? 'border-cyan-200 bg-cyan-300/20 text-cyan-100' : 'border-slate-600 text-transparent'}`} aria-hidden="true">
                                        {selected ? <Check className="h-4 w-4" /> : null}
                                      </span>
                                    </div>
                                    <div data-testid="oee-multi-resource-card-status" className="mt-1 flex min-w-0 items-center justify-between gap-2 text-xs font-bold text-slate-300">
                                      <span className="min-w-0 truncate text-[11px] font-bold text-cyan-200">
                                        {resource.resourceType}
                                      </span>
                                      <span className="flex min-w-0 items-center gap-1.5">
                                        <StateIcon className={`h-4 w-4 shrink-0 ${availability.tone}`} aria-hidden="true" />
                                        <span className="min-w-0 truncate">{availability.label}</span>
                                      </span>
                                    </div>
                                  </button>
                                );
                              })}
                            </div>
                          )}
                        </section>
                      );
                    })}
                  </div>
                </div>
              )}
            </div>
          </section>

          <section className={`flex ${isCompactFullView ? 'min-h-0' : 'min-h-[560px]'} min-w-0 flex-col overflow-hidden rounded-2xl border border-slate-700/80 bg-[#0d1a2a] p-3 shadow-[0_12px_32px_rgba(0,0,0,0.2)] sm:p-4`} aria-labelledby="oee-multi-command-title">
            <div className="flex shrink-0 items-start justify-between gap-3">
              <div>
                <p className="font-mono text-xs font-bold uppercase tracking-[0.24em] text-amber-300">02 / COMMAND</p>
                <h2 id="oee-multi-command-title" className="mt-1 text-lg font-black text-white">{t('oeeMultiEntry.commandTitle')}</h2>
              </div>
              {mode === 'START' ? (
                <button
                  data-testid="oee-multi-primary-action"
                  type="button"
                  onClick={() => void submitBatch()}
                  disabled={!canSubmit}
                  className="inline-flex min-h-[64px] shrink-0 cursor-pointer items-center justify-center gap-2 rounded-xl bg-emerald-400 px-5 text-base font-black text-slate-950 shadow-lg shadow-emerald-400/20 transition hover:bg-emerald-300 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-200 disabled:cursor-not-allowed disabled:opacity-45"
                >
                  {submitting && <Loader2 className="h-5 w-5 animate-spin" aria-hidden="true" />}
                  <PlayCircle className="h-5 w-5" aria-hidden="true" />
                  {t('oeeMultiEntry.startBatch')}
                </button>
              ) : (
                <button
                  data-testid="oee-multi-primary-action"
                  type="button"
                  onClick={() => void submitBatch()}
                  disabled={!canSubmit}
                  className="inline-flex min-h-[64px] shrink-0 cursor-pointer items-center justify-center gap-2 rounded-xl bg-red-400 px-5 text-base font-black text-slate-950 shadow-lg shadow-red-400/20 transition hover:bg-red-300 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-red-200 disabled:cursor-not-allowed disabled:opacity-45"
                >
                  {submitting && <Loader2 className="h-5 w-5 animate-spin" aria-hidden="true" />}
                  <Square className="h-5 w-5" fill="currentColor" aria-hidden="true" />
                  {t('oeeMultiEntry.endBatch')}
                </button>
              )}
            </div>

            {pendingStorageError && (
              <div data-testid="oee-multi-storage-error" role="alert" aria-live="assertive" className="mt-3 shrink-0 rounded-xl border border-red-300/50 bg-red-400/10 p-3 text-red-100">
                <div className="flex items-start gap-3">
                  <LockKeyhole className="mt-0.5 h-5 w-5 shrink-0 text-red-200" aria-hidden="true" />
                  <div className="min-w-0">
                    <p className="font-bold">{pendingStorageError}</p>
                  </div>
                </div>
              </div>
            )}

            {pendingSubmission && (
              <div data-testid="oee-multi-pending-lock" role="status" aria-live="polite" className="mt-3 shrink-0 rounded-xl border border-amber-300/50 bg-amber-300/10 p-3 text-amber-100">
                <div className="flex flex-col gap-2">
                  <div className="flex items-start gap-3">
                    <LockKeyhole className="mt-0.5 h-5 w-5 shrink-0" aria-hidden="true" />
                    <div className="min-w-0">
                      <p className="font-bold">{t('oeeMultiEntry.pendingSubmissionLock')}</p>
                      <p className="mt-1 text-xs text-amber-100/80">{t('oeeMultiEntry.noAutomaticUnlock')}</p>
                    </div>
                  </div>
                  <div className="flex shrink-0 flex-wrap justify-end gap-2">
                    <button
                      data-testid="oee-multi-status-requery"
                      type="button"
                      onClick={() => void requeryPendingStatus()}
                      disabled={pendingStatusLoading || !online}
                      className="inline-flex min-h-[44px] shrink-0 cursor-pointer items-center gap-2 rounded-lg border border-amber-200 px-3 text-xs font-black text-amber-50 transition hover:bg-amber-200/15 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-amber-200 disabled:cursor-not-allowed disabled:opacity-50"
                    >
                      {pendingStatusLoading && <Loader2 className="h-4 w-4 animate-spin" aria-hidden="true" />}
                      <RefreshCw className="h-4 w-4" aria-hidden="true" />
                      {t('oeeMultiEntry.statusRequery')}
                    </button>
                    <button
                      data-testid="oee-multi-confirm-pending"
                      type="button"
                      onClick={confirmPendingSubmission}
                      disabled={!canConfirmPending}
                      className="inline-flex min-h-[44px] shrink-0 cursor-pointer items-center gap-2 rounded-lg border border-emerald-200 px-3 text-xs font-black text-emerald-50 transition hover:bg-emerald-200/15 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-emerald-200 disabled:cursor-not-allowed disabled:opacity-50"
                    >
                      <CheckCircle2 className="h-4 w-4" aria-hidden="true" />
                      {t('oeeMultiEntry.confirmPendingSubmission')}
                    </button>
                  </div>
                </div>
                <div className="mt-2 grid gap-1 pl-8">
                  {Object.entries(pendingStatusByLine).map(([lineCode, result]) => (
                    <div key={lineCode} className="flex min-w-0 items-center justify-between gap-2 text-xs text-amber-100/80">
                      <span className="font-mono font-bold">{lineCode}</span>
                      <span className="truncate text-right">{result.error ?? (result.status?.state === 'DOWNTIME' ? t('oeeMultiEntry.downtime') : result.status ? t('oeeMultiEntry.running') : t('oeeMultiEntry.statusUnknown'))}</span>
                    </div>
                  ))}
                </div>
              </div>
            )}

            <div className="mt-3 grid grid-cols-3 gap-2 rounded-xl border border-slate-700 bg-[#07111d] p-3 text-center">
              <div><span className="block text-xs font-bold uppercase tracking-wide text-slate-500">{t('oeeMultiEntry.selectedLineCount')}</span><strong className="block text-2xl text-white">{selectedResources.length}</strong><small className="block text-[11px] text-slate-500">{t('oeeMultiEntry.visible')}: {visibleSelectedCount}{mode === 'END' ? ` · ${t('oeeMultiEntry.openEventCount', { count: selectedOpenEventCount })}` : ''}</small></div>
              <div><span className="block text-xs font-bold uppercase tracking-wide text-slate-500">{t('oeeMultiEntry.readyLineCount')}</span><strong className="block text-2xl text-cyan-200">{selectedEligibleCount}</strong><small className="block text-[11px] text-slate-500">{t('oeeMultiEntry.visible')}: {visibleSelectedEligibleCount}</small></div>
              <div><span className="block text-xs font-bold uppercase tracking-wide text-slate-500">{t('oeeMultiEntry.resultRowCount')}</span><strong className="block text-2xl text-cyan-200">{batchOutcome?.events?.length ?? 0}</strong><small className="block text-[11px] text-slate-500">{batchOutcome ? t('oeeMultiEntry.responseReceived') : t('oeeMultiEntry.awaitingResults')}</small></div>
            </div>

            {selectedResources.length > 0 && (
              <fieldset disabled={contextLocked} className={`mt-3 min-w-0 rounded-xl p-3 ${mode === 'START' ? 'border border-emerald-400/30 bg-emerald-400/5' : 'border border-red-400/30 bg-red-400/5'}`}>
                <legend className={`px-1 text-sm font-black ${mode === 'START' ? 'text-emerald-100' : 'text-red-100'}`}>
                  {mode === 'START' ? t('oeeMultiEntry.commonStartFields') : t('oeeMultiEntry.endReasonFields')}
                </legend>
                <p className="mt-1 text-xs text-slate-400">{mode === 'START' ? t('oeeMultiEntry.commonStartHint') : t('oeeMultiEntry.endReasonHint')}</p>
                <p className="mt-3 text-sm font-bold text-slate-200">
                  {t('oeeMultiEntry.reason')}
                  {mode === 'START' || (endReasonNeedsSelection && !endReasonOverrideCode)
                    ? <span className="font-normal text-slate-400">({mode === 'START' ? t('oeeMultiEntry.optional') : t('oeeMultiEntry.required')})</span>
                    : null}
                </p>
                {mode === 'START' && reasonCode ? (
                  <button
                    data-testid="oee-multi-reason-summary"
                    type="button"
                    onClick={openReasonEditor}
                    disabled={contextLocked}
                    aria-label={`${t('oeeMultiEntry.reason')}: ${selectedReason?.reasonName ?? reasonCode}, ${selectedReasonTypeLabel} · ${selectedReason?.reasonCode ?? reasonCode}; ${t('oeeMultiEntry.optional')}; ${t('common.change')}`}
                    className="mt-3 flex min-h-[48px] w-full min-w-0 cursor-pointer items-center justify-between gap-3 rounded-lg border border-slate-600 bg-[#07111d] px-3 py-2 text-left transition hover:border-cyan-300/70 hover:bg-cyan-300/10 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    <span className="min-w-0 flex-1">
                      <span className="block truncate text-sm font-bold text-emerald-100">{selectedReason?.reasonName ?? reasonCode}</span>
                      <span className="mt-0.5 block truncate text-xs text-slate-400">{selectedReasonTypeLabel} · {selectedReason?.reasonCode ?? reasonCode}</span>
                    </span>
                    <span className="shrink-0 text-xs font-bold text-slate-100">{t('common.change')}</span>
                  </button>
                ) : mode === 'START' ? (
                  <button
                    data-testid="oee-multi-reason-trigger"
                    type="button"
                    onClick={openReasonEditor}
                    disabled={contextLocked}
                    aria-haspopup="dialog"
                    aria-expanded={reasonEditorOpen}
                    className="mt-3 inline-flex min-h-[48px] w-full cursor-pointer items-center justify-between rounded-lg border border-dashed border-cyan-300/60 bg-[#07111d] px-3 text-left text-sm font-bold text-cyan-100 transition hover:border-cyan-200 hover:bg-cyan-300/10 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    <span>{t('oeeMultiEntry.reasonSelect')}</span>
                    <span aria-hidden="true" className="text-lg leading-none">+</span>
                  </button>
                ) : (
                  <div
                    data-testid="oee-multi-end-reason-summary"
                    aria-label={endReasonStatusLabel}
                    className="mt-3 flex min-h-[48px] w-full min-w-0 items-center justify-between gap-3 rounded-lg border border-slate-600 bg-[#07111d] px-3 py-2 text-left"
                  >
                    <div className="min-w-0 flex-1">
                      {endDisplayedReasonCode ? (
                        <>
                          <span className="block truncate text-sm font-bold text-emerald-100">
                            {selectedReason?.reasonName ?? t('oeeMultiEntry.reasonMetadataUnavailable')}
                          </span>
                          <span className="mt-0.5 block truncate text-xs text-slate-400">
                            {selectedReason ? `${selectedReasonTypeLabel} · ${endDisplayedReasonCode}` : endDisplayedReasonCode}
                          </span>
                        </>
                      ) : (
                        <span className="block truncate text-sm font-bold text-red-100">{endReasonStatusLabel}</span>
                      )}
                      {endReasonNeedsSelection && !endReasonOverrideCode && (
                        <span className="mt-0.5 block text-xs font-normal text-red-200">({t('oeeMultiEntry.required')})</span>
                      )}
                    </div>
                    <button
                      data-testid="oee-multi-end-reason-change"
                      type="button"
                      onClick={openReasonEditor}
                      disabled={contextLocked}
                      aria-haspopup="dialog"
                      aria-expanded={reasonEditorOpen}
                      className="inline-flex min-h-[44px] shrink-0 cursor-pointer items-center justify-center rounded-lg border border-slate-600 px-3 text-xs font-bold text-slate-100 transition hover:border-cyan-300 hover:bg-cyan-300/10 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 disabled:cursor-not-allowed disabled:opacity-50"
                    >
                      {endReasonSummary.state === 'allMissing' && !endReasonOverrideCode
                        ? t('oeeMultiEntry.reasonSelect')
                        : t('oeeMultiEntry.changeReason')}
                    </button>
                  </div>
                )}
                 {mode === 'START' && (
                   <label className="mt-3 block text-sm font-bold text-slate-200">
                     {t('oeeMultiEntry.memo')} <span className="font-normal text-slate-400">({t('oeeMultiEntry.optional')})</span>
                     <textarea
                       value={memo}
                       onChange={(event) => {
                         setMemo(event.target.value);
                         clearBatchOutcome();
                       }}
                       maxLength={500}
                       rows={2}
                       className="mt-1 min-h-[64px] w-full resize-none rounded-lg border border-slate-600 bg-[#07111d] px-3 py-2 text-base font-medium text-white outline-none focus:border-cyan-300 focus:ring-2 focus:ring-cyan-300/30 disabled:opacity-50"
                       placeholder={t('oeeMultiEntry.memoPlaceholder')}
                     />
                      <span className="mt-1 block text-right text-xs text-slate-400">{utf8ByteLength(memo)} / 500 B</span>
                   </label>
                 )}
              </fieldset>
            )}

            {mode === 'END' && selectedResources.length > 0 && (
              <div className="mt-3 rounded-xl border border-red-400/30 bg-red-400/5 p-3">
                <p className="text-sm font-black text-red-100">{t('oeeMultiEntry.endSelectionTitle')}</p>
                <p className="mt-1 text-xs text-slate-400">{t('oeeMultiEntry.endSelectionHint')} · {t('oeeMultiEntry.openEventCount', { count: selectedOpenEventCount })}</p>
                <div className="mt-3 grid gap-2">
                  {selectedResources.map((resource) => {
                    const openEvents = statusByResource[resourceIdentity(resource)]?.status?.openEvents ?? [];
                    return (
                      <div key={resourceIdentity(resource)} className="rounded-lg border border-slate-700 bg-[#07111d] px-3 py-2 text-sm">
                        <div className="flex min-h-[32px] items-center justify-between gap-3">
                          <span className="min-w-0 truncate font-mono font-bold text-white">{resource.resourceCode}</span>
                          <span className="shrink-0 text-right text-xs text-slate-400">{t('oeeMultiEntry.openEventCount', { count: openEvents.length })}</span>
                        </div>
                        <div className="mt-1 grid gap-1 pl-2">
                          {openEvents.map((event) => (
                            <span key={`${event.lineCode}-${event.dtSeq}`} className="font-mono text-xs text-slate-400">DT #{event.dtSeq}</span>
                          ))}
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            )}

            {selectedResources.length === 0 && (
              <div className="mt-3 flex min-h-[180px] flex-col items-center justify-center gap-2 rounded-xl border border-dashed border-slate-700 bg-[#07111d] p-5 text-center text-slate-400">
                <CircleHelp className="h-9 w-9" aria-hidden="true" />
                <p className="font-semibold">{t('oeeMultiEntry.selectAtLeastOne')}</p>
              </div>
            )}

            {submitting && <div role="status" aria-live="polite" className="mt-3 flex min-h-[64px] items-center gap-3 rounded-xl border border-cyan-300/40 bg-cyan-300/10 px-4 text-sm font-bold text-cyan-100"><LockKeyhole className="h-5 w-5 shrink-0" aria-hidden="true" />{t('oeeMultiEntry.contextLocked')}</div>}

            <div className="mt-3 min-h-0 flex-1 overflow-y-auto rounded-xl border border-slate-700 bg-[#07111d] p-3" aria-live="polite">
              <div className="flex items-center justify-between gap-2">
                <div>
                  <h3 className="text-sm font-black uppercase tracking-wider text-slate-200">{t('oeeMultiEntry.resultsTitle')}</h3>
                  <p className="mt-1 text-xs text-slate-400">{batchOutcome ? t(`oeeMultiEntry.${batchOutcome.state}`) : t('oeeMultiEntry.awaitingResults')}</p>
                </div>
                {selectedProcessList.length > 0 && <span className="font-mono text-xs font-bold text-cyan-300">{selectedProcessList[0]} · {mode}</span>}
              </div>
              <div className="mt-3 grid gap-2">
                {batchOutcome ? (
                  (() => {
                    const OutcomeIcon = getOutcomeIcon(batchOutcome.state);
                    const isFailure = batchOutcome.state !== 'success';
                    return (
                      <article
                        data-testid="oee-multi-batch-result"
                        className={`rounded-lg border p-3 ${isFailure ? 'border-amber-300/40 bg-amber-300/5' : 'border-emerald-400/30 bg-emerald-400/5'}`}
                        aria-label={t(`oeeMultiEntry.${batchOutcome.state}`)}
                      >
                        <div className="flex items-start gap-3">
                          <OutcomeIcon className={`mt-0.5 h-6 w-6 shrink-0 ${isFailure ? 'text-amber-200' : 'text-emerald-300'}`} aria-hidden="true" />
                          <div className="min-w-0 flex-1">
                            <div className="flex flex-wrap items-center justify-between gap-2">
                              <span className="font-mono font-black text-white">{batchOutcome.processCode}</span>
                              <span className="text-sm font-black text-slate-200">{t(`oeeMultiEntry.${batchOutcome.state}`)}</span>
                            </div>
                            <p className="mt-1 text-xs text-slate-400">{batchOutcome.message}</p>
                            <p className="mt-1 text-xs text-slate-500">{t('oeeMultiEntry.batchTargetCount', { count: batchOutcome.lineCodes.length, itemCount: batchOutcome.targetItemCount })}</p>
                            {batchOutcome.events && (
                              <div className="mt-2 grid gap-1">
                                {batchOutcome.events.map((event) => (
                                  <div key={`${event.lineCode}-${event.dtSeq}`} className="flex items-center justify-between gap-2 rounded-md border border-slate-700 bg-[#07111d] px-2 py-1.5 text-xs">
                                    <span className="font-mono font-bold text-slate-200">{event.lineCode}</span>
                                    <span className="font-mono text-slate-400">DT #{event.dtSeq}</span>
                                  </div>
                                ))}
                              </div>
                            )}
                          </div>
                        </div>
                      </article>
                    );
                  })()
                ) : selectedResources.length === 0 ? (
                  <p className="py-6 text-center text-sm text-slate-500">{t('oeeMultiEntry.noResults')}</p>
                ) : (
                  <p className="py-6 text-center text-sm text-slate-500">{t('oeeMultiEntry.notSubmitted')}</p>
                )}
              </div>
            </div>
          </section>
        </div>
      </div>

      <Modal
        isOpen={reasonEditorOpen}
        onClose={() => setReasonEditorOpen(false)}
        title={t('oeeMultiEntry.reasonSelect')}
        size="xl"
        initialFocusRef={firstReasonButtonRef}
      >
        <div data-testid="oee-multi-reason-picker" className="max-h-[70vh] min-w-0 overflow-y-auto">
          {reasonsLoading && (
            <p className="flex min-h-[44px] items-center gap-2 text-sm text-slate-400">
              <Loader2 className="h-5 w-5 animate-spin" aria-hidden="true" />
              {t('oeeMultiEntry.reasonsLoading')}
            </p>
          )}
          {reasonsError && (
            <div className="rounded-lg border border-red-400/40 bg-red-400/10 p-3 text-sm text-red-200">
              <p>{reasonsError}</p>
              <button
                type="button"
                onClick={retryReasons}
                disabled={contextLocked}
                className="mt-2 inline-flex min-h-[64px] cursor-pointer items-center gap-2 rounded-lg border border-cyan-300 px-4 font-bold text-cyan-200 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 disabled:cursor-not-allowed disabled:opacity-50"
              >
                <RefreshCw className="h-4 w-4" aria-hidden="true" />
                {t('oeeMultiEntry.retry')}
              </button>
            </div>
          )}
          {!reasonsLoading && !reasonsError && reasons.length === 0 && (
            <p className="text-sm text-red-200">{t('oeeMultiEntry.noReasons')}</p>
          )}
          {!reasonsLoading && !reasonsError && reasons.length > 0 && (
            <div className="grid min-w-0 grid-cols-1 gap-3 md:grid-cols-2">
              {reasonGroups.map(({ reasonType, reasons: groupedReasons }) => {
                const reasonTypeLabel = reasonType === 'PLAN'
                  ? t('oeeMultiEntry.reasonTypePlan')
                  : t('oeeMultiEntry.reasonTypeUnplan');
                return (
                  <section
                    key={reasonType}
                    data-testid="oee-multi-reason-group"
                    data-reason-type={reasonType}
                    className="min-w-0 rounded-lg border border-slate-700/80 bg-[#101f31] p-2"
                    aria-labelledby={`oee-multi-reason-group-${reasonType}`}
                  >
                    <div className="flex min-w-0 items-center justify-between gap-2">
                      <h3 id={`oee-multi-reason-group-${reasonType}`} className="truncate text-xs font-black uppercase tracking-wide text-slate-200">
                        {reasonTypeLabel}
                      </h3>
                      <span className="shrink-0 rounded-full bg-slate-700 px-2 py-0.5 font-mono text-[11px] font-bold text-cyan-200">
                        {groupedReasons.length}
                      </span>
                    </div>
                    <div className="mt-2 grid min-w-0 grid-cols-2 gap-2">
                      {Array.from({ length: reasonCardCapacity }, (_, index) => {
                        const reason = groupedReasons[index];
                        if (!reason) {
                          return (
                            <div
                              key={`${reasonType}-placeholder-${index}`}
                              data-testid="oee-multi-reason-placeholder"
                              aria-hidden="true"
                              aria-disabled="true"
                              className="pointer-events-none min-h-[44px] min-w-0 rounded-lg border border-slate-700/50 bg-[#07111d]/50 px-2.5 py-1.5 opacity-50"
                            />
                          );
                        }

                        return (
                          <button
                            key={reason.reasonCode}
                            ref={reason.reasonCode === firstReasonCode ? firstReasonButtonRef : undefined}
                            data-testid="oee-multi-reason-card"
                            type="button"
                            onClick={() => {
                              if (mode === 'START') {
                                setReasonCode(reason.reasonCode);
                              } else {
                                const override = createEndReasonOverride(reason.reasonCode, endReasonSummary.snapshotKey);
                                if (override) setEndReasonOverride(override);
                              }
                              clearBatchOutcome();
                              setReasonEditorOpen(false);
                            }}
                            aria-pressed={pickerReasonCode === reason.reasonCode}
                            aria-label={`${reasonTypeLabel}: ${reason.reasonName}, ${reason.reasonCode}`}
                            className={`flex min-h-[44px] min-w-0 cursor-pointer flex-col justify-center rounded-lg border px-2.5 py-1.5 text-left transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 ${pickerReasonCode === reason.reasonCode ? 'border-cyan-300 bg-cyan-400/20 text-white' : 'border-slate-600 bg-[#07111d] text-slate-300 hover:border-cyan-300/70'}`}
                          >
                            <span className="block min-w-0 truncate text-xs font-bold">{reason.reasonName}</span>
                            <span className="mt-0.5 block min-w-0 truncate font-mono text-[11px] text-slate-400">{reasonTypeLabel} · {reason.reasonCode}</span>
                          </button>
                        );
                      })}
                    </div>
                  </section>
                );
              })}
            </div>
          )}
        </div>
      </Modal>

    </div>
  );
}
