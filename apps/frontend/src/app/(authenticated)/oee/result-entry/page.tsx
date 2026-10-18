'use client';

import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { Check, ClipboardList, Expand, Factory, GitBranch, Loader2, Minimize2, RefreshCw, Wifi, WifiOff, X } from 'lucide-react';
import { usePathname, useRouter, useSearchParams } from 'next/navigation';
import { Modal } from '@/components/ui';
import api from '@/services/api';
import { useAuthStore } from '@/stores/authStore';
import { normalizeResource, readCollection, unwrap, type OeeProcessCode, type OeeResource } from '../multi-entry/_lib/oee-mobile';
import ResultInputConsole, { type ResultEntryRun } from './ResultInputConsole';

interface WorkOrderRow extends ResultEntryRun {
  lineName: string | null;
  resultQty: number;
  resultCount: number;
  wipCount: number;
}

interface StoredLineSelection {
  processCode: OeeProcessCode;
  lineCodes: string[];
}

interface LineSelectionModalProps {
  isOpen: boolean;
  initialProcessCode: OeeProcessCode;
  initialLineCodes: string[];
  resources: OeeResource[];
  resourcesLoading: boolean;
  resourceError: string;
  onClose: () => void;
  onApply: (processCode: OeeProcessCode, lineCodes: string[]) => void;
}

// SMT 실적은 AOI 로 자동 집계된다 — 이 화면은 조립 공정 지시만 받는다
const PROCESS_CODES: OeeProcessCode[] = ['ASSY'];
const LINE_SELECTION_STORAGE_PREFIX = 'oee-result-entry-line-selection';

function currentKstDate(): string {
  const parts = new Intl.DateTimeFormat('en-US', {
    timeZone: 'Asia/Seoul',
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).formatToParts(new Date());
  const value = (type: Intl.DateTimeFormatPartTypes) => parts.find((part) => part.type === type)?.value ?? '';
  return `${value('year')}-${value('month')}-${value('day')}`;
}

function isProcessCode(value: unknown): value is OeeProcessCode {
  return value === 'ASSY';
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null;
}

function selectionStorageKey(organizationId: string, userId: string): string {
  return `${LINE_SELECTION_STORAGE_PREFIX}:${encodeURIComponent(organizationId)}:${encodeURIComponent(userId)}`;
}

function readStoredSelection(storageKey: string): StoredLineSelection | null {
  try {
    const raw = localStorage.getItem(storageKey);
    if (!raw) return null;
    const parsed: unknown = JSON.parse(raw);
    if (!isRecord(parsed) || !isProcessCode(parsed.processCode) || !Array.isArray(parsed.lineCodes)) return null;
    const lineCodes = [...new Set(parsed.lineCodes.filter((lineCode): lineCode is string => typeof lineCode === 'string' && lineCode.trim().length > 0))];
    return { processCode: parsed.processCode, lineCodes };
  } catch {
    return null;
  }
}

function writeStoredSelection(storageKey: string | null, selection: StoredLineSelection): void {
  if (!storageKey) return;
  try {
    localStorage.setItem(storageKey, JSON.stringify(selection));
  } catch {
    // Browser storage can be unavailable in private browsing or restricted kiosk mode.
  }
}

function resourceSort(left: OeeResource, right: OeeResource): number {
  return (left.sortOrder ?? Number.MAX_SAFE_INTEGER) - (right.sortOrder ?? Number.MAX_SAFE_INTEGER)
    || left.lineCode.localeCompare(right.lineCode);
}

function isComplete(row: WorkOrderRow): boolean {
  return Number(row.resultCount ?? 0) > 0 && Number(row.wipCount ?? 0) === 0;
}

function workOrderKey(row: Pick<WorkOrderRow, 'lineCode' | 'runNo'>): string {
  return `${row.lineCode ?? ''}:${row.runNo}`;
}

function LineSelectionModal({
  isOpen,
  initialProcessCode,
  initialLineCodes,
  resources,
  resourcesLoading,
  resourceError,
  onClose,
  onApply,
}: LineSelectionModalProps) {
  const [draftProcessCode, setDraftProcessCode] = useState<OeeProcessCode>(initialProcessCode);
  const [draftLineCodes, setDraftLineCodes] = useState<string[]>(initialLineCodes);

  useEffect(() => {
    if (!isOpen) return;
    setDraftProcessCode(initialProcessCode);
    setDraftLineCodes([...initialLineCodes]);
  }, [initialLineCodes, initialProcessCode, isOpen]);

  const processResources = useMemo(
    () => resources.filter((resource) => resource.processCode === draftProcessCode).sort(resourceSort),
    [draftProcessCode, resources],
  );
  const draftLineCodeSet = useMemo(() => new Set(draftLineCodes), [draftLineCodes]);
  const allLinesSelected = processResources.length > 0 && processResources.every((resource) => draftLineCodeSet.has(resource.lineCode));

  function switchProcess(processCode: OeeProcessCode) {
    if (processCode === draftProcessCode) return;
    // Process is intentionally singular. A process change starts a fresh staged selection.
    setDraftProcessCode(processCode);
    setDraftLineCodes([]);
  }

  function toggleLine(lineCode: string) {
    setDraftLineCodes((current) => current.includes(lineCode)
      ? current.filter((code) => code !== lineCode)
      : [...current, lineCode]);
  }

  function selectAllLines() {
    setDraftLineCodes(processResources.map((resource) => resource.lineCode));
  }

  function deselectAllLines() {
    setDraftLineCodes([]);
  }

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title="라인 선택"
      subtitle="한 공정에서 여러 라인을 선택할 수 있습니다. 적용 전까지 현재 조회 조건은 유지됩니다."
      size="2xl"
      bodyMaxHeightClass="max-h-[58vh]"
      footer={(
        <div className="flex w-full items-center justify-between gap-3">
          <span className="text-sm font-semibold text-text-muted">
            {draftLineCodes.length}개 선택 · 최소 1개 필요
          </span>
          <div className="flex items-center gap-2">
            <button
              type="button"
              onClick={onClose}
              className="inline-flex min-h-11 cursor-pointer items-center justify-center rounded-lg border border-border px-4 text-sm font-bold text-text transition hover:bg-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary"
            >
              취소
            </button>
            <button
              type="button"
              data-testid="oee-result-entry-line-apply"
              onClick={() => onApply(draftProcessCode, draftLineCodes)}
              disabled={draftLineCodes.length === 0}
              className="inline-flex min-h-11 cursor-pointer items-center justify-center gap-2 rounded-lg bg-primary px-5 text-sm font-black text-white transition hover:bg-primary/90 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary disabled:cursor-not-allowed disabled:opacity-45"
            >
              <Check className="h-4 w-4" aria-hidden="true" />
              적용
            </button>
          </div>
        </div>
      )}
    >
      <div data-testid="oee-result-entry-line-modal" className="space-y-4">
        <div role="tablist" aria-label="공정 선택" className="grid grid-cols-2 gap-2">
          {PROCESS_CODES.map((processCode) => {
            const active = draftProcessCode === processCode;
            return (
              <button
                key={processCode}
                type="button"
                role="tab"
                aria-selected={active}
                data-testid={`oee-result-entry-process-${processCode.toLowerCase()}`}
                onClick={() => switchProcess(processCode)}
                className={`inline-flex min-h-16 cursor-pointer items-center gap-3 rounded-xl border px-4 text-left transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary ${active ? 'border-primary bg-primary/10 text-text ring-2 ring-primary/20' : 'border-border bg-background text-text-muted hover:border-primary/60 hover:bg-surface'}`}
              >
                <span className={`flex h-7 w-7 shrink-0 items-center justify-center rounded-lg border font-mono text-xs font-black ${active ? 'border-primary bg-primary text-white' : 'border-border text-text-muted'}`}>
                  {active ? <Check className="h-4 w-4" aria-hidden="true" /> : processCode === 'SMT' ? 'S' : 'A'}
                </span>
                <span className="min-w-0">
                  <strong className="block font-mono text-lg font-black">{processCode}</strong>
                  <small className="mt-0.5 block truncate text-xs font-semibold text-text-muted">
                    {processCode === 'SMT' ? '표면실장 공정' : '조립 공정'}
                  </small>
                </span>
              </button>
            );
          })}
        </div>

        <div className="flex flex-wrap items-center justify-between gap-2 rounded-xl border border-border bg-background p-3">
          <div>
            <h3 className="text-sm font-black text-text">{draftProcessCode} 라인</h3>
            <p className="mt-0.5 text-xs text-text-muted">조회할 라인을 선택하세요. 선택은 적용 버튼을 눌러 확정합니다.</p>
          </div>
          <div className="flex items-center gap-2">
            <button
              type="button"
              data-testid="oee-result-entry-select-all"
              onClick={selectAllLines}
              disabled={processResources.length === 0}
              className="inline-flex min-h-11 cursor-pointer items-center justify-center rounded-lg border border-primary/60 px-3 text-xs font-black text-primary transition hover:bg-primary/10 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary disabled:cursor-not-allowed disabled:opacity-45"
            >
              전체 선택{allLinesSelected ? '됨' : ''}
            </button>
            <button
              type="button"
              data-testid="oee-result-entry-deselect-all"
              onClick={deselectAllLines}
              disabled={draftLineCodes.length === 0}
              className="inline-flex min-h-11 cursor-pointer items-center justify-center rounded-lg border border-border px-3 text-xs font-black text-text-muted transition hover:bg-surface focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary disabled:cursor-not-allowed disabled:opacity-45"
            >
              전체 해제
            </button>
          </div>
        </div>

        {resourcesLoading && (
          <div className="flex min-h-32 items-center justify-center gap-2 rounded-xl border border-dashed border-border text-sm font-semibold text-text-muted">
            <Loader2 className="h-5 w-5 animate-spin text-primary" aria-hidden="true" />
            라인 목록 조회 중
          </div>
        )}
        {!resourcesLoading && resourceError && (
          <div className="rounded-xl border border-amber-400/50 bg-amber-50 p-3 text-sm font-semibold text-amber-800" role="status">
            {resourceError}
          </div>
        )}
        {!resourcesLoading && !processResources.length && !resourceError && (
          <div className="flex min-h-32 items-center justify-center rounded-xl border border-dashed border-border text-sm font-semibold text-text-muted">
            선택한 공정의 라인이 없습니다.
          </div>
        )}
        {!resourcesLoading && processResources.length > 0 && (
          <div className="grid grid-cols-2 gap-2 md:grid-cols-3" data-testid="oee-result-entry-line-cards">
            {processResources.map((resource) => {
              const selected = draftLineCodeSet.has(resource.lineCode);
              return (
                <button
                  key={`${resource.processCode}-${resource.lineCode}`}
                  type="button"
                  data-testid="oee-result-entry-line-card"
                  aria-pressed={selected}
                  aria-label={`${resource.lineCode}, ${resource.lineName}, ${resource.resourceType}`}
                  onClick={() => toggleLine(resource.lineCode)}
                  className={`min-h-[72px] min-w-0 cursor-pointer rounded-lg border p-3 text-left transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary ${selected ? 'border-primary bg-primary/10 ring-2 ring-primary/20' : 'border-border bg-background hover:border-primary/60 hover:bg-surface'}`}
                >
                  <div className="flex min-w-0 items-center gap-2">
                    {resource.resourceType === 'CELL'
                      ? <GitBranch className={`h-4 w-4 shrink-0 ${selected ? 'text-primary' : 'text-text-muted'}`} aria-hidden="true" />
                      : <Factory className={`h-4 w-4 shrink-0 ${selected ? 'text-primary' : 'text-text-muted'}`} aria-hidden="true" />}
                    <span className="min-w-0 flex-1">
                      <strong className="block truncate font-mono text-sm font-black text-text">{resource.lineCode}</strong>
                      <span className="mt-0.5 block truncate text-xs font-semibold text-text-muted">{resource.lineName}</span>
                    </span>
                    <span className={`flex h-5 w-5 shrink-0 items-center justify-center rounded border ${selected ? 'border-primary bg-primary text-white' : 'border-border text-transparent'}`} aria-hidden="true">
                      <Check className="h-3.5 w-3.5" />
                    </span>
                  </div>
                  <span className="mt-2 block font-mono text-[10px] font-bold uppercase tracking-wide text-text-muted">{resource.resourceType}</span>
                </button>
              );
            })}
          </div>
        )}
      </div>
    </Modal>
  );
}

export default function OeeResultEntryPage() {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const user = useAuthStore((state) => state.user);
  const selectedPlant = useAuthStore((state) => state.selectedPlant);
  const [online, setOnline] = useState(() => typeof navigator === 'undefined' || navigator.onLine);
  const [resources, setResources] = useState<OeeResource[]>([]);
  const [resourcesLoading, setResourcesLoading] = useState(true);
  const [resourceError, setResourceError] = useState('');
  const [appliedProcessCode, setAppliedProcessCode] = useState<OeeProcessCode>('ASSY');
  const [appliedLineCodes, setAppliedLineCodes] = useState<string[]>([]);
  const [lineModalOpen, setLineModalOpen] = useState(false);
  const [selectionHydratedFor, setSelectionHydratedFor] = useState<string | null>(null);
  const [orders, setOrders] = useState<WorkOrderRow[]>([]);
  const [ordersLoading, setOrdersLoading] = useState(false);
  const [orderError, setOrderError] = useState('');
  const [hasQueried, setHasQueried] = useState(false);
  const [selectedRunKey, setSelectedRunKey] = useState<string | null>(null);
  const [ordersTruncated, setOrdersTruncated] = useState(false);
  const [draftDirty, setDraftDirty] = useState(false);
  const [pendingDiscardAction, setPendingDiscardAction] = useState<(() => void) | null>(null);
  const [workDate, setWorkDate] = useState(currentKstDate);
  const isFullView = searchParams.get('view') === 'full';
  const queryGeneration = useRef(0);

  const organizationId = (user?.plant || selectedPlant || '').trim();
  const lineSelectionStorageKey = useMemo(
    () => user?.id?.trim() && organizationId ? selectionStorageKey(organizationId, user.id.trim()) : null,
    [organizationId, user?.id],
  );
  const selectionScope = lineSelectionStorageKey ?? 'anonymous';

  const clearOrderResults = useCallback(() => {
    queryGeneration.current += 1;
    setOrders([]);
    setSelectedRunKey(null);
    setOrdersLoading(false);
    setOrderError('');
    setHasQueried(false);
    setOrdersTruncated(false);
    setDraftDirty(false);
  }, []);

  const requestDiscard = useCallback((action: () => void) => {
    if (!draftDirty) {
      action();
      return;
    }
    setPendingDiscardAction(() => action);
  }, [draftDirty]);

  useEffect(() => {
    const updateOnline = () => setOnline(navigator.onLine);
    window.addEventListener('online', updateOnline);
    window.addEventListener('offline', updateOnline);
    return () => {
      window.removeEventListener('online', updateOnline);
      window.removeEventListener('offline', updateOnline);
    };
  }, []);

  const loadResources = useCallback(async () => {
    setResourcesLoading(true);
    setResourceError('');
    const results = await Promise.allSettled(
      PROCESS_CODES.map((processCode) => api.get('/oee/mobile/resources', { params: { processCode } })),
    );
    const loaded = results.flatMap((result, index) => {
      if (result.status !== 'fulfilled') return [];
      const processCode = PROCESS_CODES[index];
      return readCollection<OeeResource>(result.value, 'resources')
        .filter((resource) => resource.processCode === processCode && (resource.resourceType === 'LINE' || resource.resourceType === 'CELL'))
        .map(normalizeResource);
    });
    const unique = Array.from(new Map(loaded.map((resource) => [`${resource.processCode}:${resource.lineCode}`, resource])).values());
    setResources(unique);
    setResourcesLoading(false);
    if (!unique.length) {
      setResourceError('라인/셀을 불러오지 못했습니다. 네트워크 상태를 확인한 뒤 다시 시도하세요.');
    } else if (results.some((result) => result.status === 'rejected')) {
      setResourceError('일부 공정의 라인/셀을 불러오지 못했습니다.');
    }
  }, []);

  useEffect(() => {
    void loadResources();
  }, [loadResources]);

  useEffect(() => {
    if (resourcesLoading || selectionHydratedFor === selectionScope) return;

    const stored = lineSelectionStorageKey ? readStoredSelection(lineSelectionStorageKey) : null;
    const restoredProcessCode = stored?.processCode ?? 'ASSY';
    const availableLineCodes = new Set(
      resources.filter((resource) => resource.processCode === restoredProcessCode).map((resource) => resource.lineCode),
    );
    const canPrune = resources.length > 0 || !resourceError;
    const restoredLineCodes = canPrune
      ? [...new Set((stored?.lineCodes ?? []).filter((lineCode) => availableLineCodes.has(lineCode)))]
      : stored?.lineCodes ?? [];

    setAppliedProcessCode(restoredProcessCode);
    setAppliedLineCodes(restoredLineCodes);
    if (stored && lineSelectionStorageKey && (stored.lineCodes.length !== restoredLineCodes.length || stored.processCode !== restoredProcessCode)) {
      writeStoredSelection(lineSelectionStorageKey, { processCode: restoredProcessCode, lineCodes: restoredLineCodes });
    }
    setSelectionHydratedFor(selectionScope);
    clearOrderResults();
  }, [clearOrderResults, lineSelectionStorageKey, resourceError, resources, resourcesLoading, selectionHydratedFor, selectionScope]);

  const appliedResourceByCode = useMemo(() => {
    const map = new Map<string, OeeResource>();
    resources
      .filter((resource) => resource.processCode === appliedProcessCode)
      .forEach((resource) => map.set(resource.lineCode, resource));
    return map;
  }, [appliedProcessCode, resources]);

  const appliedLineResources = useMemo(
    () => appliedLineCodes.map((lineCode) => appliedResourceByCode.get(lineCode) ?? null),
    [appliedLineCodes, appliedResourceByCode],
  );

  const commitLineSelection = useCallback((processCode: OeeProcessCode, nextLineCodes: string[]) => {
    const availableLineCodes = new Set(
      resources.filter((resource) => resource.processCode === processCode).map((resource) => resource.lineCode),
    );
    const validLineCodes = [...new Set(nextLineCodes.filter((lineCode) => availableLineCodes.has(lineCode)))];
    if (validLineCodes.length === 0) return;

    setAppliedProcessCode(processCode);
    setAppliedLineCodes(validLineCodes);
    writeStoredSelection(lineSelectionStorageKey, { processCode, lineCodes: validLineCodes });
    clearOrderResults();
    setLineModalOpen(false);
  }, [clearOrderResults, lineSelectionStorageKey, resources]);

  const applyLineSelection = useCallback((processCode: OeeProcessCode, nextLineCodes: string[]) => {
    const commit = () => commitLineSelection(processCode, nextLineCodes);
    if (draftDirty) setLineModalOpen(false);
    requestDiscard(commit);
  }, [commitLineSelection, draftDirty, requestDiscard]);

  const removeAppliedLine = useCallback((lineCode: string) => {
    setAppliedLineCodes((current) => {
      const next = current.filter((code) => code !== lineCode);
      writeStoredSelection(lineSelectionStorageKey, { processCode: appliedProcessCode, lineCodes: next });
      return next;
    });
    clearOrderResults();
  }, [appliedProcessCode, clearOrderResults, lineSelectionStorageKey]);

  const handleRemoveAppliedLine = useCallback((lineCode: string) => {
    requestDiscard(() => removeAppliedLine(lineCode));
  }, [removeAppliedLine, requestDiscard]);

  const handleDateChange = useCallback((nextDate: string) => {
    if (nextDate === workDate) return;
    requestDiscard(() => {
      setWorkDate(nextDate);
      clearOrderResults();
    });
  }, [clearOrderResults, requestDiscard, workDate]);

  const loadOrders = useCallback(async (preserveSelection = false) => {
    const requestLineCodes = [...appliedLineCodes];
    if (!workDate || requestLineCodes.length === 0) {
      clearOrderResults();
      return;
    }

    const generation = queryGeneration.current + 1;
    queryGeneration.current = generation;
    if (!preserveSelection) {
      setOrders([]);
      setSelectedRunKey(null);
    }
    setOrdersLoading(true);
    setOrderError('');
    setHasQueried(true);
    setOrdersTruncated(false);

    try {
      const response = await api.get('/oee/work-result', {
        params: { lineCodes: requestLineCodes.join(','), fromDate: workDate, toDate: workDate },
      });
      if (generation !== queryGeneration.current) return;

      const responseValue = unwrap<unknown>(response);
      const responseTruncated = isRecord(responseValue) && responseValue.truncated === true;

      const lineNameByCode = new Map(
        resources
          .filter((resource) => resource.processCode === appliedProcessCode)
          .map((resource) => [resource.lineCode, resource.lineName]),
      );
      const nextOrders = readCollection<WorkOrderRow>(response, 'list')
        .map((order) => ({
          ...order,
          lineName: order.lineName ?? lineNameByCode.get(order.lineCode ?? '') ?? null,
        }))
        .sort((left, right) => {
          const completionOrder = Number(isComplete(left)) - Number(isComplete(right));
          return completionOrder
            || (left.lineCode ?? '').localeCompare(right.lineCode ?? '')
            || left.runNo.localeCompare(right.runNo);
        });
      setOrders(nextOrders);
      setOrdersTruncated(responseTruncated);
      const initialOrder = nextOrders.find((order) => !isComplete(order)) ?? nextOrders[0];
      setSelectedRunKey((current) => {
        if (preserveSelection && nextOrders.some((order) => workOrderKey(order) === current)) return current;
        return initialOrder ? workOrderKey(initialOrder) : null;
      });
      setDraftDirty(false);
    } catch {
      if (generation !== queryGeneration.current) return;
      setOrders([]);
      setSelectedRunKey(null);
      setOrdersTruncated(false);
      setOrderError('작업지시를 불러오지 못했습니다. 조회 버튼으로 다시 시도하세요.');
    } finally {
      if (generation === queryGeneration.current) setOrdersLoading(false);
    }
  }, [appliedLineCodes, appliedProcessCode, clearOrderResults, resources, workDate]);

  const selectedOrder = useMemo(
    () => orders.find((order) => workOrderKey(order) === selectedRunKey) ?? null,
    [orders, selectedRunKey],
  );
  const handleSaved = useCallback(async () => {
    await loadOrders(true);
  }, [loadOrders]);

  const selectOrder = useCallback((nextRunKey: string) => {
    if (nextRunKey === selectedRunKey) return;
    requestDiscard(() => {
      setSelectedRunKey(nextRunKey);
      setDraftDirty(false);
    });
  }, [requestDiscard, selectedRunKey]);

  const queryOrders = useCallback(() => {
    requestDiscard(() => { void loadOrders(false); });
  }, [loadOrders, requestDiscard]);

  const confirmDiscard = useCallback(() => {
    const action = pendingDiscardAction;
    setPendingDiscardAction(null);
    setDraftDirty(false);
    action?.();
  }, [pendingDiscardAction]);

  function switchView() {
    const next = new URLSearchParams(searchParams.toString());
    if (isFullView) next.delete('view');
    else next.set('view', 'full');
    const query = next.toString();
    router.replace(query ? `${pathname}?${query}` : pathname, { scroll: false });
  }

  return (
    <div data-target="1280x800" className="oee-result-entry-canvas flex h-full min-h-0 min-w-0 w-full flex-col overflow-hidden bg-[#07111d] text-slate-100">
      <div className="mx-auto flex min-h-0 w-full flex-1 flex-col gap-3 overflow-hidden p-3">
        <header className="flex shrink-0 items-center justify-between gap-3 rounded-2xl border border-slate-700/80 bg-[#0d1a2a] px-4 py-3 shadow-[0_12px_32px_rgba(0,0,0,0.24)]">
          <div className="flex min-w-0 items-center gap-3">
            <div className="rounded-xl border border-cyan-400/30 bg-cyan-400/10 p-2.5 text-cyan-300">
              <ClipboardList className="h-7 w-7" aria-hidden="true" />
            </div>
            <div className="min-w-0">
              <p className="font-mono text-[11px] font-bold uppercase tracking-[0.22em] text-cyan-300">PRODUCTION / RESULT ENTRY</p>
              <h1 className="truncate text-xl font-black tracking-tight text-white">OEE 실적 입력</h1>
            </div>
          </div>
          <div className="flex shrink-0 items-center gap-2">
            <div className={`hidden min-h-11 items-center gap-2 rounded-xl border px-3 sm:flex ${online ? 'border-emerald-400/35 bg-emerald-400/10 text-emerald-100' : 'border-red-400/40 bg-red-400/10 text-red-100'}`} role="status">
              {online ? <Wifi className="h-5 w-5" aria-hidden="true" /> : <WifiOff className="h-5 w-5" aria-hidden="true" />}
              <span className="text-sm font-bold">{online ? '온라인' : '오프라인'}</span>
            </div>
            <div className="hidden min-h-11 max-w-56 items-center rounded-xl border border-slate-700 bg-[#101f31] px-3 text-sm font-semibold text-slate-200 md:flex">
              <span className="truncate">{user?.name || user?.empNo || user?.id || '작업자 미확인'}</span>
            </div>
            <button
              type="button"
              onClick={switchView}
              className="inline-flex min-h-11 cursor-pointer items-center gap-2 rounded-xl border border-slate-600 px-3 text-sm font-bold text-slate-100 transition hover:border-cyan-300 hover:bg-cyan-300/10 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300"
            >
              {isFullView ? <Minimize2 className="h-5 w-5" aria-hidden="true" /> : <Expand className="h-5 w-5" aria-hidden="true" />}
              {isFullView ? '메뉴 보기' : '전체 화면'}
            </button>
          </div>
        </header>

        <main className="grid min-h-0 flex-1 grid-cols-[minmax(0,3fr)_minmax(0,2fr)] gap-3" data-testid="oee-result-entry-grid" data-layout="60-40">
          <section className="flex min-h-0 min-w-0 flex-col gap-3 overflow-hidden" data-testid="oee-result-entry-left-workspace" aria-label="작업지시 조회 영역">
            <section data-testid="oee-result-entry-query-bar" className="shrink-0 rounded-2xl border border-slate-700/80 bg-[#0d1a2a] p-3 shadow-[0_12px_32px_rgba(0,0,0,0.2)]" aria-labelledby="result-entry-query-title">
              <div data-testid="oee-result-entry-query-row-1" className="flex min-w-0 items-end gap-3">
                <div className="min-w-0 flex-1">
                  <p className="font-mono text-xs font-black tracking-[0.2em] text-cyan-300">QUERY</p>
                  <h2 id="result-entry-query-title" className="mt-1 whitespace-nowrap text-lg font-black text-white">조회조건</h2>
                </div>
                <label className="flex min-w-36 flex-col gap-1 text-[11px] font-bold text-slate-400">
                  작업일
                  <input
                    type="date"
                    value={workDate}
                    onChange={(event) => handleDateChange(event.target.value)}
                    aria-label="작업일"
                    required
                    style={{ colorScheme: 'dark' }}
                    className="min-h-11 rounded-xl border border-slate-600 bg-[#07111d] px-2 font-mono text-sm font-bold text-slate-100 outline-none focus:border-cyan-300 focus:ring-2 focus:ring-cyan-300/30"
                  />
                </label>
                <button
                  type="button"
                  data-testid="oee-result-entry-query"
                  onClick={queryOrders}
                  disabled={ordersLoading || resourcesLoading || !workDate || appliedLineCodes.length === 0}
                  className="inline-flex min-h-11 cursor-pointer items-center justify-center gap-2 rounded-xl bg-cyan-400 px-5 text-sm font-black text-slate-950 shadow-lg shadow-cyan-400/15 transition hover:bg-cyan-300 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-200 disabled:cursor-not-allowed disabled:opacity-45"
                >
                  <RefreshCw className={`h-4 w-4 ${ordersLoading ? 'animate-spin' : ''}`} aria-hidden="true" />
                  조회
                </button>
              </div>
              <div data-testid="oee-result-entry-query-row-2" className="mt-2 flex min-w-0 items-center gap-2">
                <div className="min-w-0 flex-1">
                  <span className="mb-1 block text-[11px] font-bold text-slate-400">선택 라인</span>
                  <div className="flex min-h-11 min-w-0 flex-wrap items-center gap-1.5 rounded-xl border border-slate-600 bg-[#07111d] px-2 py-1.5">
                    {appliedLineResources.map((resource, index) => {
                      const lineCode = appliedLineCodes[index];
                      return (
                        <button
                          key={lineCode}
                          type="button"
                          data-testid="oee-result-entry-line-chip"
                          onClick={() => handleRemoveAppliedLine(lineCode)}
                          aria-label={`${resource?.lineName ?? lineCode} 라인 제거`}
                          className="inline-flex min-h-11 max-w-52 cursor-pointer items-center gap-1.5 rounded-lg border border-cyan-300/50 bg-cyan-400/10 px-2.5 text-left text-xs font-bold text-cyan-100 transition hover:border-cyan-200 hover:bg-cyan-400/20 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300"
                        >
                          <span className="truncate font-mono">{lineCode}</span>
                          <span className="truncate text-cyan-100/75">{resource?.lineName ?? '라인'}</span>
                          <X className="h-3.5 w-3.5 shrink-0" aria-hidden="true" />
                        </button>
                      );
                    })}
                    {!appliedLineCodes.length && <span className="px-1 text-sm font-semibold text-slate-500">라인을 선택하세요</span>}
                  </div>
                </div>
                <button
                  type="button"
                  data-testid="oee-result-entry-line-selector"
                  onClick={() => setLineModalOpen(true)}
                  aria-haspopup="dialog"
                  aria-expanded={lineModalOpen}
                  className="mt-5 inline-flex min-h-11 shrink-0 cursor-pointer items-center justify-center gap-2 rounded-xl border border-cyan-300/60 px-4 text-sm font-black text-cyan-100 transition hover:bg-cyan-300/10 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300"
                >
                  <GitBranch className="h-4 w-4" aria-hidden="true" />
                  라인 선택
                </button>
              </div>
              <div className="mt-2 flex items-center justify-between gap-3 text-xs text-slate-400">
                <span>{appliedLineCodes.length ? `${appliedProcessCode} · ${appliedLineCodes.length}개 라인` : '라인을 선택한 뒤 조회하세요.'}</span>
                {resourceError && <span className="truncate text-amber-200">{resourceError}</span>}
              </div>
            </section>

            <section className="flex min-h-0 min-w-0 flex-1 flex-col overflow-hidden rounded-2xl border border-slate-700/80 bg-[#0d1a2a] p-3 shadow-[0_12px_32px_rgba(0,0,0,0.2)]" aria-labelledby="result-entry-orders-title">
            <div className="flex shrink-0 items-start justify-between gap-2">
              <div>
                <p className="font-mono text-xs font-black tracking-[0.2em] text-amber-300">01 / WORK ORDER</p>
                <h2 id="result-entry-orders-title" data-testid="oee-result-entry-orders-title" className="mt-1 text-lg font-black text-white">작업지시 목록</h2>
              </div>
              <span className="rounded-full border border-slate-600 px-2.5 py-1 font-mono text-xs font-bold text-slate-300">{orders.length}건</span>
            </div>
            <p className="mt-1 shrink-0 text-xs text-slate-400">미완료 작업지시를 먼저, 라인코드와 작업지시번호 순으로 표시합니다.</p>

            <div className="mt-3 min-h-0 flex-1 overflow-y-auto overscroll-contain pr-1">
              {!ordersLoading && ordersTruncated && (
                <div data-testid="oee-result-entry-truncated-notice" className="mb-2 rounded-xl border border-amber-300/50 bg-amber-300/10 px-3 py-2 text-xs font-bold leading-5 text-amber-100" role="status">
                  조회 결과가 100건으로 제한되었습니다. 라인 또는 작업일 조건을 좁혀 다시 조회하세요.
                </div>
              )}
              {ordersLoading && <div className="flex h-full min-h-24 items-center justify-center gap-2 text-sm text-slate-300"><Loader2 className="h-5 w-5 animate-spin text-amber-300" aria-hidden="true" />조회 중</div>}
              {!ordersLoading && orders.map((order) => {
                const selected = workOrderKey(order) === selectedRunKey;
                const complete = isComplete(order);
                return (
                  <button
                    key={workOrderKey(order)}
                    type="button"
                    onClick={() => selectOrder(workOrderKey(order))}
                    aria-pressed={selected}
                    className={`mb-2 min-h-[92px] w-full cursor-pointer rounded-xl border p-3 text-left transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-amber-300 ${selected ? 'border-amber-300 bg-amber-300/12 ring-2 ring-amber-300/20' : 'border-slate-700 bg-[#07111d] hover:border-amber-300/70'}`}
                  >
                    <div className="flex items-center justify-between gap-2">
                      <strong className="truncate font-mono text-sm text-white">{order.runNo}</strong>
                      <span className={`shrink-0 rounded-full px-2 py-0.5 text-[11px] font-black ${complete ? 'bg-blue-400/15 text-blue-200' : 'bg-amber-300/15 text-amber-100'}`}>{complete ? '완료' : '입력 가능'}</span>
                    </div>
                    <div className="mt-1 flex min-w-0 items-center gap-2 text-xs">
                      <span className="shrink-0 rounded bg-cyan-400/10 px-1.5 py-0.5 font-mono font-black text-cyan-200">{order.lineCode ?? '-'}</span>
                      <span className="min-w-0 truncate font-semibold text-cyan-100">{order.lineName ?? '-'}</span>
                    </div>
                    <p className="mt-1 truncate text-xs font-semibold text-slate-200">{order.itemCode || '-'} · {order.itemName || order.modelName || '-'}</p>
                    <p className="mt-1 flex justify-between text-[11px] text-slate-400"><span>계획 {Number(order.planQty ?? 0).toLocaleString()}</span><span>누적 {Number(order.resultQty ?? 0).toLocaleString()}</span></p>
                  </button>
                );
              })}
              {!ordersLoading && !appliedLineCodes.length && <div className="flex h-full min-h-24 items-center justify-center text-center text-sm font-semibold text-slate-500">라인 선택 버튼에서 라인을 선택하세요.</div>}
              {!ordersLoading && appliedLineCodes.length > 0 && !hasQueried && <div className="flex h-full min-h-24 items-center justify-center text-center text-sm font-semibold text-slate-500">조건을 확인한 뒤 조회 버튼을 누르세요.</div>}
              {!ordersLoading && appliedLineCodes.length > 0 && hasQueried && !orders.length && !orderError && <div className="flex h-full min-h-24 items-center justify-center text-center text-sm font-semibold text-slate-500">선택한 조건의 작업지시가 없습니다.</div>}
              {!ordersLoading && orderError && <div className="rounded-xl border border-red-300/40 bg-red-300/10 p-3 text-sm font-semibold text-red-100">{orderError}<button type="button" onClick={queryOrders} className="mt-3 flex min-h-11 w-full cursor-pointer items-center justify-center rounded-lg border border-red-200/50 font-bold hover:bg-red-200/10 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-red-200">다시 조회</button></div>}
            </div>
            </section>
          </section>

          {selectedOrder ? (
            <ResultInputConsole
              key={workOrderKey(selectedOrder)}
              run={selectedOrder}
              isComplete={isComplete(selectedOrder)}
              defaultWorkerId={user?.empNo || user?.id || ''}
              defaultWorkerName={user?.name || user?.empNo || user?.id || ''}
              onSaved={handleSaved}
              onDirtyChange={setDraftDirty}
            />
          ) : (
            <section className="flex min-h-0 min-w-0 flex-col overflow-hidden rounded-2xl border border-slate-700/80 bg-[#f4f7f8] text-slate-900 shadow-[0_12px_32px_rgba(0,0,0,0.2)]" aria-labelledby="result-entry-console-empty-title">
              <div className="flex min-h-0 flex-1 flex-col items-center justify-center gap-3 px-6 text-center text-slate-500">
                <ClipboardList className="h-10 w-10 text-teal-700" aria-hidden="true" />
                <h2 id="result-entry-console-empty-title" className="font-black text-slate-800">작업지시를 선택하세요</h2>
                <p className="text-sm">왼쪽 목록에서 작업지시를 선택하면 터치 입력 콘솔이 열립니다.</p>
              </div>
            </section>
          )}
        </main>
      </div>

      <Modal
        isOpen={pendingDiscardAction !== null}
        onClose={() => setPendingDiscardAction(null)}
        title="입력값을 버릴까요?"
        subtitle="저장하지 않은 값이 있습니다. 이 작업을 계속하면 현재 입력값이 사라집니다."
        footer={(
          <div className="flex w-full justify-end gap-2">
            <button type="button" onClick={() => setPendingDiscardAction(null)} className="min-h-11 cursor-pointer rounded-lg border border-border px-4 text-sm font-bold text-text transition hover:bg-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">계속 입력</button>
            <button type="button" onClick={confirmDiscard} className="min-h-11 cursor-pointer rounded-lg bg-primary px-4 text-sm font-black text-white transition hover:bg-primary/90 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">입력값 버리기</button>
          </div>
        )}
      >
        <p className="text-sm leading-6 text-text">현재 입력한 실적수량, 작업시간, 투입인원, 작업자 또는 처리구분을 저장하지 않고 이동하시겠습니까?</p>
      </Modal>

      <LineSelectionModal
        isOpen={lineModalOpen}
        initialProcessCode={appliedProcessCode}
        initialLineCodes={appliedLineCodes}
        resources={resources}
        resourcesLoading={resourcesLoading}
        resourceError={resourceError}
        onClose={() => setLineModalOpen(false)}
        onApply={applyLineSelection}
      />
    </div>
  );
}
