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
import { Modal } from '@/components/ui';
import { api } from '@/services/api';
import { useAuthStore } from '@/stores/authStore';
import {
  createRequestId,
  makeEndPayload,
  makeStartPayload,
  normalizeCommandResult,
  normalizeResource,
  normalizeStatus,
  readCollection,
  resourceIdentity,
  stableEndSignature,
  stableStartSignature,
  unwrap,
  type EndCommandFields,
  type OeeCommandResult,
  type OeeEndPayload,
  type OeeProcessCode,
  type OeeReason,
  type OeeResource,
  type OeeStartPayload,
  type OeeStatus,
  type OeeWorker,
  type StartCommandFields,
} from './_lib/oee-mobile';
import {
  commandKey,
  isRetryableOutcome,
  isTerminalSuccess,
  selectRetryableResources,
  type CommandOutcomeState,
  type CommandOutcomeView,
  type MultiEntryMode,
} from './_lib/multi-entry';

interface ResourceStatusRow {
  loading: boolean;
  status: OeeStatus | null;
  error: string | null;
}

interface PendingCommand {
  signature: string;
  requestId: string;
}

interface CommandToSubmit {
  mode: MultiEntryMode;
  resource: OeeResource;
  key: string;
  signature: string;
  requestId: string;
  payload: OeeStartPayload | OeeEndPayload;
}

interface CommandAttempt {
  command: CommandToSubmit;
  state: CommandOutcomeState;
  message: string;
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

function responseStatus(error: unknown): number | null {
  return axios.isAxiosError(error) ? error.response?.status ?? null : null;
}

function parseWorker(response: unknown): OeeWorker | null {
  const value = unwrap<unknown>(response);
  if (!isRecord(value) || typeof value.workerId !== 'string' || typeof value.workerName !== 'string') return null;
  return { workerId: value.workerId, workerName: value.workerName };
}

function isEligibleStatus(mode: MultiEntryMode, row: ResourceStatusRow | undefined): boolean {
  if (!row || row.loading || row.error || !row.status) return false;
  if (mode === 'START') return row.status.state === 'RUNNING';
  return row.status.state === 'DOWNTIME' && Boolean(row.status.openEvent?.eventId);
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
  if (mode === 'END' && row.status.state === 'DOWNTIME' && row.status.openEvent?.eventId) {
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

function getOutcomeIcon(state: CommandOutcomeState | undefined): LucideIcon {
  if (state === 'success') return CheckCircle2;
  if (state === 'replayed') return RefreshCw;
  if (state === 'conflict') return AlertTriangle;
  if (state === 'error') return CircleHelp;
  return CircleHelp;
}

export default function OeeMultiEntryPage() {
  const { t } = useTranslation();
  const user = useAuthStore((state) => state.user);
  const [online, setOnline] = useState(true);
  const [lastCommunicationAt, setLastCommunicationAt] = useState<number | null>(null);

  const [workerInput, setWorkerInput] = useState('');
  const [worker, setWorker] = useState<OeeWorker | null>(null);
  const [workerLoading, setWorkerLoading] = useState(false);
  const [workerError, setWorkerError] = useState<string | null>(null);

  const [selectedWorkplace, setSelectedWorkplace] = useState<OeeProcessCode | 'ALL' | null>(null);
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
  const [memo, setMemo] = useState('');
  const [reasonEditorOpen, setReasonEditorOpen] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [commandOutcomes, setCommandOutcomes] = useState<Record<string, CommandOutcomeView>>({});

  const contextGeneration = useRef(0);
  const statusGeneration = useRef(0);
  const reasonContextGeneration = useRef(0);
  const reasonsLoadedRef = useRef(false);
  const reasonsLoadingRef = useRef(false);
  const autoWorkerIdentityRef = useRef<string | null>(null);
  const pendingCommandsRef = useRef<Map<string, PendingCommand>>(new Map());
  const outcomesRef = useRef<Map<string, CommandOutcomeView>>(new Map());
  const firstReasonButtonRef = useRef<HTMLButtonElement>(null);

  const markCommunication = useCallback(() => {
    setLastCommunicationAt(Date.now());
  }, []);

  const clearCommandState = useCallback(() => {
    pendingCommandsRef.current.clear();
    outcomesRef.current.clear();
    setCommandOutcomes({});
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
    clearCommandState();
  }, [clearCommandState]);

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
            const response = await api.get('/oee/mobile/status', {
              params: {
                processCode: resource.processCode,
                resourceType: resource.resourceType,
                resourceCode: resource.resourceCode,
                parentLineCode: resource.parentLineCode ?? resource.resourceCode,
              },
              suppressErrorModal: true,
            });
            return { resource, status: normalizeStatus(response), error: null };
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
    const identity = loggedInUser.id.trim();
    if (!identity) return;
    if (autoWorkerIdentityRef.current === identity) return;

    autoWorkerIdentityRef.current = identity;
    const candidates = [loggedInUser.empNo ?? '', loggedInUser.id];
    void resolveAutoWorker(candidates);
  }, [resolveAutoWorker, user]);

  const contextLocked = submitting;

  const changeWorker = useCallback(() => {
    if (contextLocked) return;
    setWorker(null);
    setWorkerInput('');
    setWorkerError(null);
    clearContext();
  }, [clearContext, contextLocked]);

  const toggleAllProcesses = useCallback(() => {
    if (!worker || contextLocked) return;
    if (selectedWorkplace === 'ALL') return;
    setSelectedWorkplace('ALL');
    void loadContext(RESOURCE_PROCESS_CODES);
  }, [contextLocked, loadContext, selectedWorkplace, worker]);

  const toggleWorkplace = useCallback(
    (processCode: OeeProcessCode) => {
      if (!worker || contextLocked) return;
      if (selectedWorkplace === processCode) return;
      setSelectedWorkplace(processCode);
      setSelectedResourceIds((current) => {
        const next = new Set(current);
        for (const resource of resources) {
          if (resource.processCode !== processCode) next.delete(resourceIdentity(resource));
        }
        return next;
      });
      void loadContext([processCode]);
    },
    [contextLocked, loadContext, resources, selectedWorkplace, worker],
  );

  const selectedProcessList = useMemo(
    () => (selectedWorkplace === 'ALL' ? RESOURCE_PROCESS_CODES : selectedWorkplace ? [selectedWorkplace] : []),
    [selectedWorkplace],
  );

  const processMasterState = selectedWorkplace === 'ALL';

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
      setMemo('');
      setReasonEditorOpen(false);
      clearCommandState();
    },
    [clearCommandState, contextLocked],
  );

  const toggleResource = useCallback(
    (resource: OeeResource) => {
      if (contextLocked) return;
      const key = resourceIdentity(resource);
      if (!isEligibleStatus(mode, statusByResource[key])) return;
      setSelectedResourceIds((current) => {
        const next = new Set(current);
        if (next.has(key)) next.delete(key);
        else next.add(key);
        return next;
      });
    },
    [contextLocked, mode, statusByResource],
  );

  const retryReasons = useCallback(() => {
    if (selectedProcessList.length > 0 && !contextLocked) void loadReasons();
  }, [contextLocked, loadReasons, selectedProcessList]);

  const selectedResources = useMemo(
    () => resources.filter((resource) => selectedResourceIds.has(resourceIdentity(resource))),
    [resources, selectedResourceIds],
  );

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
  }, [contextLocked, visibleEligibleResources]);

  const selectedItems = useMemo(
    () => selectedResources.map((resource) => ({ resource, resourceKey: resourceIdentity(resource) })),
    [selectedResources],
  );

  const outcomesMap = useMemo(() => new Map(Object.entries(commandOutcomes)), [commandOutcomes]);

  const retryCandidates = useMemo(
    () => selectRetryableResources(selectedItems, outcomesMap),
    [outcomesMap, selectedItems],
  );

  const failedCount = useMemo(
    () => selectedResources.filter((resource) => isRetryableOutcome(commandOutcomes[resourceIdentity(resource)]?.state)).length,
    [commandOutcomes, selectedResources],
  );

  const completedCount = useMemo(
    () =>
      selectedResources.filter((resource) =>
        isTerminalSuccess(commandOutcomes[resourceIdentity(resource)]?.state),
      ).length,
    [commandOutcomes, selectedResources],
  );

  const statusLoading = resources.some((resource) => statusByResource[resourceIdentity(resource)]?.loading);
  const lastCommunicationLabel = lastCommunicationAt
    ? new Date(lastCommunicationAt).toLocaleTimeString(undefined, {
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
      })
    : t('oeeMultiEntry.notYet');

  const updateOutcome = useCallback((outcome: CommandOutcomeView) => {
    outcomesRef.current.set(outcome.resourceKey, outcome);
    setCommandOutcomes(Object.fromEntries(outcomesRef.current.entries()));
  }, []);

  const buildStartCommand = useCallback(
    (resource: OeeResource): CommandToSubmit | null => {
      const row = statusByResource[resourceIdentity(resource)];
      if (!worker || selectedProcessList.length === 0 || !reasonCode || !isEligibleStatus('START', row)) return null;

      const fields: StartCommandFields = {
        processCode: resource.processCode,
        resourceType: resource.resourceType,
        resourceCode: resource.resourceCode,
        parentLineCode: resource.parentLineCode ?? resource.resourceCode,
        workerId: worker.workerId,
        reasonCode,
        memo,
        requestId: '',
      };
      const signature = stableStartSignature(fields);
      const key = commandKey('START', resourceIdentity(resource), signature);
      const pending = pendingCommandsRef.current.get(key);
      const requestId = pending?.signature === signature ? pending.requestId : createRequestId();
      pendingCommandsRef.current.set(key, { signature, requestId });
      return {
        mode: 'START',
        resource,
        key,
        signature,
        requestId,
        payload: makeStartPayload({ ...fields, requestId }),
      };
    },
    [memo, reasonCode, selectedProcessList.length, statusByResource, worker],
  );

  const buildEndCommand = useCallback(
    (resource: OeeResource): CommandToSubmit | null => {
      const row = statusByResource[resourceIdentity(resource)];
      const activeEvent = row?.status?.openEvent;
      if (!worker || selectedProcessList.length === 0 || !activeEvent?.eventId || !isEligibleStatus('END', row)) return null;

      const fields: EndCommandFields = {
        eventId: activeEvent.eventId,
        processCode: resource.processCode,
        resourceType: resource.resourceType,
        resourceCode: resource.resourceCode,
        parentLineCode: resource.parentLineCode ?? resource.resourceCode,
        workerId: worker.workerId,
        requestId: '',
      };
      const signature = stableEndSignature(fields);
      const key = commandKey('END', resourceIdentity(resource), signature);
      const pending = pendingCommandsRef.current.get(key);
      const requestId = pending?.signature === signature ? pending.requestId : createRequestId();
      pendingCommandsRef.current.set(key, { signature, requestId });
      return {
        mode: 'END',
        resource,
        key,
        signature,
        requestId,
        payload: makeEndPayload({ ...fields, requestId }),
      };
    },
    [selectedProcessList.length, statusByResource, worker],
  );

  const refreshStatuses = useCallback(async () => {
    if (selectedProcessList.length > 0 && resources.length > 0) await loadStatuses(resources);
  }, [loadStatuses, resources, selectedProcessList.length]);

  const submitBatch = useCallback(async () => {
    if (submitting || !online) {
      if (!online) toast.error(t('oeeMultiEntry.offlineBlocked'));
      return;
    }
    if (!worker || selectedProcessList.length === 0 || selectedResources.length === 0) {
      toast.error(t('oeeMultiEntry.selectAtLeastOne'));
      return;
    }
    if (mode === 'START' && !reasonCode) {
      toast.error(t('oeeMultiEntry.reasonRequired'));
      return;
    }
    if (mode === 'START' && memo.length > 500) {
      toast.error(t('oeeMultiEntry.memoTooLong'));
      return;
    }

    const commands = retryCandidates
      .map((item) => (mode === 'START' ? buildStartCommand(item.resource) : buildEndCommand(item.resource)))
      .filter((command): command is CommandToSubmit => command !== null);

    if (commands.length !== retryCandidates.length) {
      toast.error(t('oeeMultiEntry.statusChanged'));
      await refreshStatuses();
      return;
    }

    setSubmitting(true);
    try {
      const commandResults = await Promise.allSettled(
        commands.map(async (command): Promise<CommandAttempt> => {
          try {
            const response =
              command.mode === 'START'
                ? await api.post('/oee/mobile/downtime/start', command.payload, {
                    suppressErrorModal: true,
                    skipSuccessToast: true,
                  }).finally(markCommunication)
                : await api.post('/oee/mobile/downtime/end', command.payload, {
                    suppressErrorModal: true,
                    skipSuccessToast: true,
                  }).finally(markCommunication);
            const result: OeeCommandResult = normalizeCommandResult(response);
            return {
              command,
              state: result.replayed ? 'replayed' : 'success',
              message: result.replayed ? t('oeeMultiEntry.replayed') : t('oeeMultiEntry.success'),
            };
          } catch (error: unknown) {
            const conflict = responseStatus(error) === 409;
            return {
              command,
              state: conflict ? 'conflict' : 'error',
              message: conflict
                ? t('oeeMultiEntry.conflict')
                : readApiMessage(error, t('oeeMultiEntry.error')),
            };
          }
        }),
      );

      let failed = 0;
      let completed = 0;
      for (const [index, settled] of commandResults.entries()) {
        const fallbackCommand = commands[index];
        if (!fallbackCommand) continue;
        const attempt: CommandAttempt =
          settled.status === 'fulfilled'
            ? settled.value
            : { command: fallbackCommand, state: 'error', message: t('oeeMultiEntry.error') };
        const resourceKey = resourceIdentity(attempt.command.resource);
        updateOutcome({
          resourceKey,
          resourceCode: attempt.command.resource.resourceCode,
          mode: attempt.command.mode,
          requestId: attempt.command.requestId,
          state: attempt.state,
          message: attempt.message,
        });
        if (isTerminalSuccess(attempt.state)) pendingCommandsRef.current.delete(attempt.command.key);
        if (isRetryableOutcome(attempt.state)) failed += 1;
        else completed += 1;
      }

      if (failed > 0) {
        toast.error(t('oeeMultiEntry.partialResult', { completed, failed }));
      } else {
        toast.success(t('oeeMultiEntry.batchSaved'));
      }
    } finally {
      await refreshStatuses();
      setSubmitting(false);
    }
  }, [
    buildEndCommand,
    buildStartCommand,
    markCommunication,
    memo.length,
    mode,
    online,
    reasonCode,
    refreshStatuses,
    retryCandidates,
    selectedProcessList.length,
    selectedResources.length,
    submitting,
    t,
    updateOutcome,
    worker,
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
  const selectedReason = reasons.find((reason) => reason.reasonCode === reasonCode);
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
  const canSubmitStart = mode === 'START' && selectedEligibleCount > 0 && Boolean(reasonCode) && !reasonsLoading;
  const canSubmitEnd = mode === 'END' && selectedEligibleCount > 0;
  const canSubmit = (canSubmitStart || canSubmitEnd) && online && !submitting && !contextLocked;

  return (
    <div className="oee-multi-entry-board flex h-full min-h-0 flex-col overflow-hidden bg-[#07111d] text-slate-100">
      <div className="mx-auto flex min-h-0 w-full max-w-[1680px] flex-1 flex-col gap-3 overflow-y-auto p-3 sm:p-4 lg:p-5">
        <header className="shrink-0 rounded-2xl border border-slate-700/80 bg-[#0d1a2a] p-3 shadow-[0_12px_32px_rgba(0,0,0,0.24)] sm:p-4">
          <div className="flex min-w-0 flex-col gap-3 xl:flex-row xl:items-center xl:justify-between">
            <div className="flex min-w-0 items-start gap-3 xl:flex-1">
              <div className="rounded-xl border border-cyan-400/30 bg-cyan-400/10 p-2.5 text-cyan-300">
                <PauseCircle className="h-8 w-8" aria-hidden="true" />
              </div>
              <div className="min-w-0">
                <p className="font-mono text-xs font-bold uppercase tracking-[0.24em] text-cyan-300">C / OPERATIONS BOARD</p>
                <h1 className="mt-1 text-xl font-black tracking-tight text-white sm:text-2xl">{t('oeeMultiEntry.title')}</h1>
                <p className="mt-1 max-w-3xl text-sm text-slate-300">{t('oeeMultiEntry.subtitle')}</p>
              </div>
            </div>

            <div
              data-testid="oee-multi-status-area"
              className={`grid min-w-0 grid-cols-1 gap-2 sm:grid-cols-2 ${worker ? 'xl:grid-cols-3' : 'xl:grid-cols-2'} xl:w-[min(44rem,100%)] xl:shrink-0`}
            >
              <div
                className={`flex min-h-[48px] items-center gap-3 rounded-xl border px-3 ${
                  online ? 'border-emerald-400/40 bg-emerald-400/10' : 'border-red-400/50 bg-red-400/10'
                }`}
                role="status"
                aria-label={t('oeeMultiEntry.deviceNetwork')}
              >
                {online ? <Wifi className="h-6 w-6 text-emerald-300" aria-hidden="true" /> : <WifiOff className="h-6 w-6 text-red-300" aria-hidden="true" />}
                <div>
                  <span className="block text-xs font-bold uppercase tracking-wider text-slate-400">{t('oeeMultiEntry.deviceNetwork')}</span>
                  <strong className={online ? 'text-emerald-200' : 'text-red-200'}>{online ? t('oeeMultiEntry.online') : t('oeeMultiEntry.offline')}</strong>
                </div>
              </div>
              <div
                className="flex min-h-[48px] items-center gap-3 rounded-xl border border-slate-700 bg-[#101f31] px-3"
                role="status"
                aria-label={t('oeeMultiEntry.recentMesCommunication')}
              >
                <Send className="h-6 w-6 text-amber-300" aria-hidden="true" />
                <div>
                  <span className="block text-xs font-bold uppercase tracking-wider text-slate-400">{t('oeeMultiEntry.recentMesCommunication')}</span>
                  <strong className="font-mono text-sm text-slate-100">{lastCommunicationLabel}</strong>
                </div>
              </div>
              {worker && (
                <div
                  data-testid="oee-multi-worker-summary"
                  className="worker-summary flex min-h-[48px] min-w-0 items-center justify-between gap-2 rounded-xl border border-emerald-400/30 bg-emerald-400/10 px-3"
                  role="status"
                  aria-label={`${t('oeeMultiEntry.workerId')}: ${worker.workerName} · ${worker.workerId}`}
                >
                  <div className="flex min-w-0 items-center gap-2">
                    <UserRound className="h-5 w-5 shrink-0 text-emerald-200" aria-hidden="true" />
                    <span className="min-w-0 truncate text-sm font-bold text-emerald-100">
                      {worker.workerName} <span className="font-mono font-semibold text-emerald-200/80">· {worker.workerId}</span>
                    </span>
                  </div>
                  <button
                    type="button"
                    onClick={changeWorker}
                    disabled={contextLocked}
                    className="inline-flex min-h-[44px] shrink-0 cursor-pointer items-center justify-center gap-2 rounded-lg border border-slate-600 px-3 text-sm font-bold text-slate-100 transition hover:border-cyan-300 hover:bg-cyan-300/10 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    {t('oeeMultiEntry.changeWorker')}
                  </button>
                </div>
              )}
            </div>
          </div>

          {!worker && (
            <form
              data-testid="oee-multi-worker-form"
              className="mt-3 flex flex-col gap-2 border-t border-slate-700 pt-3 sm:flex-row sm:items-end"
              onSubmit={(event) => {
                event.preventDefault();
                void confirmWorker();
              }}
            >
              <label className="flex min-w-0 flex-1 flex-col gap-1 text-sm font-semibold text-slate-300">
                {t('oeeMultiEntry.workerId')}
                <input
                  value={workerInput}
                  onChange={(event) => setWorkerInput(event.target.value)}
                  disabled={workerLoading || contextLocked}
                  placeholder={t('oeeMultiEntry.workerPlaceholder')}
                  autoComplete="off"
                  className="min-h-[64px] w-full rounded-xl border border-slate-600 bg-[#07111d] px-4 text-lg font-semibold text-white outline-none transition focus:border-cyan-300 focus:ring-2 focus:ring-cyan-300/30 disabled:cursor-not-allowed disabled:opacity-50"
                  aria-describedby={workerError ? 'oee-multi-worker-error' : undefined}
                />
              </label>
              <button
                type="submit"
                disabled={workerLoading || !workerInput.trim() || contextLocked}
                className="inline-flex min-h-[64px] cursor-pointer items-center justify-center gap-2 rounded-xl bg-cyan-400 px-5 text-base font-black text-slate-950 shadow-lg shadow-cyan-400/20 transition hover:bg-cyan-300 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-200 disabled:cursor-not-allowed disabled:opacity-50"
              >
                {workerLoading && <Loader2 className="h-5 w-5 animate-spin" aria-hidden="true" />}
                {t('oeeMultiEntry.workerConfirm')}
              </button>
            </form>
          )}
          {workerError && <p id="oee-multi-worker-error" className="mt-2 text-sm font-semibold text-red-300">{workerError}</p>}
        </header>

        <div className="grid min-h-0 min-w-0 shrink-0 grid-cols-1 gap-3 lg:flex-1 lg:grid-cols-[minmax(0,3fr)_minmax(0,2fr)]">
          <section className="flex min-h-[560px] min-w-0 flex-col overflow-hidden rounded-2xl border border-slate-700/80 bg-[#0d1a2a] p-3 shadow-[0_12px_32px_rgba(0,0,0,0.2)] sm:p-4" aria-labelledby="oee-multi-selection-title">
            <div className="flex shrink-0 flex-col gap-3 xl:flex-row xl:items-end xl:justify-between">
              <div>
                <p className="font-mono text-xs font-bold uppercase tracking-[0.24em] text-cyan-300">01 / SELECT</p>
                <h2 id="oee-multi-selection-title" className="mt-1 text-lg font-black text-white">{t('oeeMultiEntry.selectionTitle')}</h2>
              </div>
            </div>

            <div className="mt-2 grid shrink-0 grid-cols-1 gap-2 sm:grid-cols-3" role="group" aria-label={t('oeeMultiEntry.processSelection')}>
              <button
                data-testid="oee-multi-process-all"
                type="button"
                role="checkbox"
                onClick={toggleAllProcesses}
                disabled={!worker || contextLocked}
                aria-checked={processMasterState}
                className={`inline-flex min-h-[64px] cursor-pointer items-center gap-3 rounded-xl border px-4 text-left transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 ${
                  processMasterState !== false ? 'border-cyan-300 bg-cyan-400/15 text-white' : 'border-slate-600 bg-[#07111d] text-slate-300 hover:border-cyan-300/70'
                } disabled:cursor-not-allowed disabled:opacity-45`}
              >
                <span className="flex h-6 w-6 shrink-0 items-center justify-center rounded border border-cyan-200" aria-hidden="true">
                  {processMasterState ? <Check className="h-4 w-4" /> : null}
                </span>
                <span className="min-w-0">
                  <strong className="block truncate font-mono text-lg font-black">{t('oeeMultiEntry.allProcesses')}</strong>
                  <small className="mt-0.5 block truncate text-xs font-semibold opacity-75">{t('oeeMultiEntry.processGroupSmt')} + {t('oeeMultiEntry.processGroupAssy')}</small>
                </span>
              </button>
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
                                    disabled={availability.disabled || contextLocked}
                                    aria-disabled={availability.disabled || contextLocked}
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

          <section className="flex min-h-[560px] min-w-0 flex-col overflow-hidden rounded-2xl border border-slate-700/80 bg-[#0d1a2a] p-3 shadow-[0_12px_32px_rgba(0,0,0,0.2)] sm:p-4" aria-labelledby="oee-multi-command-title">
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

            <div className="mt-3 grid grid-cols-3 gap-2 rounded-xl border border-slate-700 bg-[#07111d] p-3 text-center">
              <div><span className="block text-xs font-bold uppercase tracking-wide text-slate-500">{t('oeeMultiEntry.selected')}</span><strong className="block text-2xl text-white">{selectedResources.length}</strong><small className="block text-[11px] text-slate-500">{t('oeeMultiEntry.visible')}: {visibleSelectedCount}</small></div>
              <div><span className="block text-xs font-bold uppercase tracking-wide text-slate-500">{t('oeeMultiEntry.ready')}</span><strong className="block text-2xl text-cyan-200">{selectedEligibleCount}</strong><small className="block text-[11px] text-slate-500">{t('oeeMultiEntry.visible')}: {visibleSelectedEligibleCount}</small></div>
              <div><span className="block text-xs font-bold uppercase tracking-wide text-slate-500">{t('oeeMultiEntry.failed')}</span><strong className="text-2xl text-red-200">{failedCount}</strong></div>
            </div>

            {mode === 'START' && selectedResources.length > 0 && (
              <fieldset disabled={contextLocked} className="mt-3 min-w-0 rounded-xl border border-emerald-400/30 bg-emerald-400/5 p-3">
                <legend className="px-1 text-sm font-black text-emerald-100">{t('oeeMultiEntry.commonStartFields')}</legend>
                <p className="mt-1 text-xs text-slate-400">{t('oeeMultiEntry.commonStartHint')}</p>
                {reasonCode ? (
                  <button
                    data-testid="oee-multi-reason-summary"
                    type="button"
                    onClick={openReasonEditor}
                    disabled={contextLocked}
                    aria-label={`${t('oeeMultiEntry.reason')}: ${selectedReason?.reasonName ?? reasonCode}, ${selectedReasonTypeLabel} · ${selectedReason?.reasonCode ?? reasonCode}; ${t('common.change')}; ${t('oeeMultiEntry.memo')}: ${memo.trim() || '—'}`}
                    className="mt-3 flex min-h-[48px] w-full min-w-0 cursor-pointer items-center justify-between gap-3 rounded-lg border border-slate-600 bg-[#07111d] px-3 py-2 text-left transition hover:border-cyan-300/70 hover:bg-cyan-300/10 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    <span className="min-w-0 flex-1">
                      <span className="block truncate text-sm font-bold text-emerald-100">{selectedReason?.reasonName ?? reasonCode}</span>
                      <span className="mt-0.5 block truncate text-xs text-slate-400">{selectedReasonTypeLabel} · {selectedReason?.reasonCode ?? reasonCode}</span>
                    </span>
                    <span className="shrink-0 text-xs font-bold text-slate-100">{t('common.change')}</span>
                  </button>
                ) : (
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
                )}
                <label className="mt-3 block text-sm font-bold text-slate-200">
                  {t('oeeMultiEntry.memo')} <span className="font-normal text-slate-400">({t('oeeMultiEntry.optional')})</span>
                  <textarea
                    value={memo}
                    onChange={(event) => {
                      setMemo(event.target.value);
                      clearCommandState();
                    }}
                    maxLength={500}
                    rows={2}
                    className="mt-1 min-h-[64px] w-full resize-none rounded-lg border border-slate-600 bg-[#07111d] px-3 py-2 text-base font-medium text-white outline-none focus:border-cyan-300 focus:ring-2 focus:ring-cyan-300/30 disabled:opacity-50"
                    placeholder={t('oeeMultiEntry.memoPlaceholder')}
                  />
                  <span className="mt-1 block text-right text-xs text-slate-400">{memo.length} / 500</span>
                </label>
              </fieldset>
            )}

            {mode === 'END' && selectedResources.length > 0 && (
              <div className="mt-3 rounded-xl border border-red-400/30 bg-red-400/5 p-3">
                <p className="text-sm font-black text-red-100">{t('oeeMultiEntry.endSelectionTitle')}</p>
                <p className="mt-1 text-xs text-slate-400">{t('oeeMultiEntry.endSelectionHint')}</p>
                <div className="mt-3 grid gap-2">
                  {selectedResources.map((resource) => {
                    const event = statusByResource[resourceIdentity(resource)]?.status?.openEvent;
                    return <div key={resourceIdentity(resource)} className="flex min-h-[64px] items-center justify-between gap-3 rounded-lg border border-slate-700 bg-[#07111d] px-3 text-sm"><span className="min-w-0 truncate font-mono font-bold text-white">{resource.resourceCode}</span><span className="shrink-0 text-right text-xs text-slate-400">{event?.eventId ? `EVENT #${event.eventId}` : t('oeeMultiEntry.statusUnknown')}</span></div>;
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

            {failedCount > 0 && (
              <div className="mt-3 flex shrink-0 flex-col gap-2">
                <button type="button" onClick={() => void submitBatch()} disabled={!online || submitting || contextLocked || retryCandidates.length === 0} className="inline-flex min-h-[64px] cursor-pointer items-center justify-center gap-2 rounded-xl border border-amber-300/70 bg-amber-300/10 px-5 text-base font-black text-amber-100 transition hover:bg-amber-300/20 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-amber-200 disabled:cursor-not-allowed disabled:opacity-45">
                  <RefreshCw className="h-5 w-5" aria-hidden="true" />{t('oeeMultiEntry.retryFailed', { count: failedCount })}
                </button>
              </div>
            )}

            {submitting && <div role="status" aria-live="polite" className="mt-3 flex min-h-[64px] items-center gap-3 rounded-xl border border-cyan-300/40 bg-cyan-300/10 px-4 text-sm font-bold text-cyan-100"><LockKeyhole className="h-5 w-5 shrink-0" aria-hidden="true" />{t('oeeMultiEntry.contextLocked')}</div>}

            <div className="mt-3 min-h-0 flex-1 overflow-y-auto rounded-xl border border-slate-700 bg-[#07111d] p-3" aria-live="polite">
              <div className="flex items-center justify-between gap-2">
                <div>
                  <h3 className="text-sm font-black uppercase tracking-wider text-slate-200">{t('oeeMultiEntry.resultsTitle')}</h3>
                  <p className="mt-1 text-xs text-slate-400">{completedCount > 0 && failedCount > 0 ? t('oeeMultiEntry.partialResult', { completed: completedCount, failed: failedCount }) : completedCount > 0 && failedCount === 0 ? t('oeeMultiEntry.allComplete', { completed: completedCount }) : t('oeeMultiEntry.awaitingResults')}</p>
                </div>
                    {selectedProcessList.length > 0 && <span className="font-mono text-xs font-bold text-cyan-300">{selectedProcessList.join(' + ')} · {mode}</span>}
              </div>
              <div className="mt-3 grid gap-2">
                {selectedResources.length === 0 && <p className="py-6 text-center text-sm text-slate-500">{t('oeeMultiEntry.noResults')}</p>}
                {selectedResources.map((resource) => {
                  const key = resourceIdentity(resource);
                  const outcome = commandOutcomes[key];
                  const OutcomeIcon = getOutcomeIcon(outcome?.state);
                  const stateLabel = outcome?.state ? t(`oeeMultiEntry.${outcome.state}`) : t('oeeMultiEntry.queued');
                  return (
                    <article key={key} className={`rounded-lg border p-3 ${outcome?.state === 'error' || outcome?.state === 'conflict' ? 'border-red-400/40 bg-red-400/5' : outcome ? 'border-emerald-400/30 bg-emerald-400/5' : 'border-slate-700 bg-[#0d1a2a]'}`} aria-label={`${resource.resourceCode}: ${stateLabel}`}>
                      <div className="flex items-start gap-3">
                        <OutcomeIcon className={`mt-0.5 h-6 w-6 shrink-0 ${outcome?.state === 'error' || outcome?.state === 'conflict' ? 'text-red-300' : outcome ? 'text-emerald-300' : 'text-slate-500'}`} aria-hidden="true" />
                        <div className="min-w-0 flex-1">
                          <div className="flex flex-wrap items-center justify-between gap-2">
                            <span className="font-mono font-black text-white">{resource.resourceCode}</span>
                            <span className="text-sm font-black text-slate-200">{stateLabel}</span>
                          </div>
                          <p className="mt-1 text-xs text-slate-400">{outcome?.message ?? t('oeeMultiEntry.notSubmitted')}</p>
                          {outcome && <p className="mt-1 truncate font-mono text-[11px] text-slate-500">{t('oeeMultiEntry.requestId')}: {outcome.requestId}</p>}
                        </div>
                      </div>
                    </article>
                  );
                })}
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
                              setReasonCode(reason.reasonCode);
                              clearCommandState();
                              setReasonEditorOpen(false);
                            }}
                            aria-pressed={reasonCode === reason.reasonCode}
                            aria-label={`${reasonTypeLabel}: ${reason.reasonName}, ${reason.reasonCode}`}
                            className={`flex min-h-[44px] min-w-0 cursor-pointer flex-col justify-center rounded-lg border px-2.5 py-1.5 text-left transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 ${reasonCode === reason.reasonCode ? 'border-cyan-300 bg-cyan-400/20 text-white' : 'border-slate-600 bg-[#07111d] text-slate-300 hover:border-cyan-300/70'}`}
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
