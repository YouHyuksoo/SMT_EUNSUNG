'use client';

import { useCallback, useEffect, useMemo, useState } from 'react';
import { usePathname, useRouter, useSearchParams } from 'next/navigation';
import { Check, ClipboardList, Expand, Factory, GitBranch, Loader2, Minimize2, RefreshCw, Wifi, WifiOff } from 'lucide-react';
import { WorkResultForm, type WorkResultMachine, type WorkResultRun } from '@/components/shared';
import api from '@/services/api';
import { useAuthStore } from '@/stores/authStore';
import { normalizeResource, readCollection, type OeeProcessCode, type OeeResource } from '../multi-entry/_lib/oee-mobile';

interface WorkOrderRow extends WorkResultRun {
  resultQty: number;
  resultCount: number;
  wipCount: number;
}

const PROCESS_CODES: OeeProcessCode[] = ['SMT', 'ASSY'];

function currentKstDate(): string {
  const parts = new Intl.DateTimeFormat('en-US', {
    timeZone: 'Asia/Seoul', year: 'numeric', month: '2-digit', day: '2-digit',
  }).formatToParts(new Date());
  const value = (type: Intl.DateTimeFormatPartTypes) => parts.find((part) => part.type === type)?.value ?? '';
  return `${value('year')}-${value('month')}-${value('day')}`;
}

interface ResourceHierarchy {
  parentCode: string;
  parent: OeeResource | null;
  cells: OeeResource[];
}

function hasDistinctParent(resource: OeeResource): boolean {
  const parentCode = resource.parentLineCode?.trim();
  return Boolean(parentCode && parentCode !== resource.resourceCode);
}

function groupResourceHierarchy(resources: OeeResource[]): ResourceHierarchy[] {
  const parentResources = resources.filter((resource) => !hasDistinctParent(resource));
  const cellsByParent = new Map<string, OeeResource[]>();
  resources.filter(hasDistinctParent).forEach((resource) => {
    const parentCode = resource.parentLineCode!.trim();
    cellsByParent.set(parentCode, [...(cellsByParent.get(parentCode) ?? []), resource]);
  });

  const groups: ResourceHierarchy[] = parentResources.map((parent) => ({
    parentCode: parent.resourceCode,
    parent,
    cells: cellsByParent.get(parent.resourceCode) ?? [],
  }));
  const knownParents = new Set(parentResources.map((resource) => resource.resourceCode));
  cellsByParent.forEach((cells, parentCode) => {
    if (!knownParents.has(parentCode)) groups.push({ parentCode, parent: null, cells });
  });
  return groups;
}

function isComplete(row: WorkOrderRow): boolean {
  return row.resultCount > 0 && row.wipCount === 0;
}

export default function OeeResultEntryPage() {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const user = useAuthStore((state) => state.user);
  const [online, setOnline] = useState(() => typeof navigator === 'undefined' || navigator.onLine);
  const [resources, setResources] = useState<OeeResource[]>([]);
  const [resourcesLoading, setResourcesLoading] = useState(true);
  const [resourceError, setResourceError] = useState('');
  const [selectedResourceId, setSelectedResourceId] = useState<number | null>(null);
  const [orders, setOrders] = useState<WorkOrderRow[]>([]);
  const [ordersLoading, setOrdersLoading] = useState(false);
  const [orderError, setOrderError] = useState('');
  const [selectedRunNo, setSelectedRunNo] = useState<string | null>(null);
  const [machines, setMachines] = useState<WorkResultMachine[]>([]);
  const [formVersion, setFormVersion] = useState(0);
  const [workDate, setWorkDate] = useState(currentKstDate);
  const isFullView = searchParams.get('view') === 'full';

  const selectedResource = resources.find((resource) => resource.resourceId === selectedResourceId) ?? null;
  const selectedLineCode = selectedResource?.resourceCode ?? null;
  const selectedOrder = orders.find((order) => order.runNo === selectedRunNo) ?? null;

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
    const loaded = results.flatMap((result) => result.status === 'fulfilled'
      ? readCollection<OeeResource>(result.value, 'resources').map(normalizeResource)
      : []);
    const unique = Array.from(new Map(loaded.map((resource) => [resource.resourceId, resource])).values());
    setResources(unique);
    setResourcesLoading(false);
    if (!unique.length) {
      setResourceError('라인/셀을 불러오지 못했습니다. 네트워크 상태를 확인한 뒤 다시 시도하세요.');
    } else if (results.some((result) => result.status === 'rejected')) {
      setResourceError('일부 공정의 라인/셀을 불러오지 못했습니다.');
    }
  }, []);

  const loadOrders = useCallback(async (lineCode: string) => {
    if (!workDate) {
      setOrders([]);
      setSelectedRunNo(null);
      return;
    }
    setOrdersLoading(true);
    setOrderError('');
    try {
      const response = await api.get('/oee/work-result', {
        params: { fromDate: workDate, toDate: workDate, lineCode },
      });
      const nextOrders = readCollection<WorkOrderRow>(response, 'list').sort((a, b) => {
        const completionOrder = Number(isComplete(a)) - Number(isComplete(b));
        return completionOrder || a.runNo.localeCompare(b.runNo);
      });
      setOrders(nextOrders);
      setSelectedRunNo((current) => nextOrders.some((row) => row.runNo === current) ? current : null);
    } catch (error: unknown) {
      setOrders([]);
      setSelectedRunNo(null);
      setOrderError('작업지시를 불러오지 못했습니다. 다시 조회하세요.');
    } finally {
      setOrdersLoading(false);
    }
  }, [workDate]);

  useEffect(() => {
    void loadResources();
    api.get('/oee/work-result/machines')
      .then((response) => setMachines(readCollection<WorkResultMachine>(response, 'list')))
      .catch(() => setMachines([]));
  }, [loadResources]);

  useEffect(() => {
    setSelectedRunNo(null);
    setOrders([]);
    if (selectedLineCode) void loadOrders(selectedLineCode);
  }, [loadOrders, selectedLineCode]);

  const lineMachines = useMemo(() => {
    if (!selectedLineCode) return [];
    return machines.filter((machine) => machine.lineCode === selectedLineCode || machine.machineCode === selectedOrder?.machineCode);
  }, [machines, selectedLineCode, selectedOrder?.machineCode]);

  function switchView() {
    const next = new URLSearchParams(searchParams.toString());
    if (isFullView) next.delete('view');
    else next.set('view', 'full');
    const query = next.toString();
    router.replace(query ? `${pathname}?${query}` : pathname);
  }

  async function handleSaved() {
    if (!selectedLineCode) return;
    await loadOrders(selectedLineCode);
    setFormVersion((value) => value + 1);
  }

  return (
    <div className="flex h-full min-h-0 flex-col overflow-hidden bg-[#07111d] text-slate-100">
      <div className="mx-auto flex min-h-0 w-full max-w-[1720px] flex-1 flex-col gap-2 p-2 sm:gap-3 sm:p-3">
        <header className="flex shrink-0 items-center justify-between gap-3 rounded-2xl border border-slate-700/80 bg-[#0d1a2a] px-4 py-3 shadow-[0_12px_32px_rgba(0,0,0,0.24)]">
          <div className="flex min-w-0 items-center gap-3">
            <div className="rounded-xl border border-cyan-400/30 bg-cyan-400/10 p-2.5 text-cyan-300"><ClipboardList className="h-7 w-7" aria-hidden="true" /></div>
            <div className="min-w-0">
              <p className="font-mono text-[11px] font-bold uppercase tracking-[0.22em] text-cyan-300">PRODUCTION / RESULT ENTRY</p>
              <h1 className="truncate text-xl font-black tracking-tight text-white sm:text-2xl">OEE 실적 입력</h1>
            </div>
          </div>
          <div className="flex shrink-0 items-center gap-2">
            <div className={`hidden min-h-11 items-center gap-2 rounded-xl border px-3 sm:flex ${online ? 'border-emerald-400/35 bg-emerald-400/10 text-emerald-100' : 'border-red-400/40 bg-red-400/10 text-red-100'}`} role="status">
              {online ? <Wifi className="h-5 w-5" /> : <WifiOff className="h-5 w-5" />}<span className="text-sm font-bold">{online ? '온라인' : '오프라인'}</span>
            </div>
            <div className="hidden min-h-11 max-w-56 items-center rounded-xl border border-slate-700 bg-[#101f31] px-3 text-sm font-semibold text-slate-200 md:flex"><span className="truncate">{user?.name || user?.empNo || user?.id || '작업자 미확인'}</span></div>
            <button type="button" onClick={switchView} className="inline-flex min-h-11 cursor-pointer items-center gap-2 rounded-xl border border-slate-600 px-3 text-sm font-bold text-slate-100 transition hover:border-cyan-300 hover:bg-cyan-300/10 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300">
              {isFullView ? <Minimize2 className="h-5 w-5" /> : <Expand className="h-5 w-5" />}{isFullView ? '메뉴 보기' : '전체 화면'}
            </button>
          </div>
        </header>

        <main className={`grid min-h-0 flex-1 grid-cols-1 gap-2 sm:gap-3 ${isFullView ? 'lg:grid-cols-[minmax(220px,0.82fr)_minmax(260px,1fr)_minmax(420px,1.55fr)]' : 'xl:grid-cols-[minmax(220px,0.82fr)_minmax(260px,1fr)_minmax(420px,1.55fr)]'}`}>
          <section className="flex min-h-[220px] min-w-0 flex-col overflow-hidden rounded-2xl border border-slate-700/80 bg-[#0d1a2a] p-3" aria-labelledby="result-entry-step-1">
            <div className="flex shrink-0 items-start justify-between gap-2">
              <div><p className="font-mono text-xs font-black tracking-[0.2em] text-cyan-300">01 / LINE · CELL</p><h2 id="result-entry-step-1" className="mt-1 text-lg font-black text-white">라인/셀 선택</h2></div>
              <button type="button" onClick={() => void loadResources()} disabled={resourcesLoading} aria-label="라인/셀 다시 조회" className="inline-flex min-h-11 min-w-11 cursor-pointer items-center justify-center rounded-xl border border-slate-600 text-slate-200 transition hover:border-cyan-300 hover:text-cyan-200 disabled:opacity-50"><RefreshCw className={`h-5 w-5 ${resourcesLoading ? 'animate-spin' : ''}`} /></button>
            </div>
            <p className="mt-1 shrink-0 text-xs text-slate-400">작업지시를 조회할 생산 위치를 선택하세요.</p>
            <div className="mt-3 min-h-0 flex-1 overflow-y-auto overscroll-contain pr-1">
              {resourcesLoading && <div className="flex h-full min-h-24 items-center justify-center gap-2 text-sm text-slate-300"><Loader2 className="h-5 w-5 animate-spin text-cyan-300" />조회 중</div>}
              {!resourcesLoading && PROCESS_CODES.map((processCode) => {
                const processResources = resources.filter((resource) => resource.processCode === processCode);
                if (!processResources.length) return null;
                return (
                  <section key={processCode} className="mb-3 rounded-xl border border-slate-700 bg-[#101f31] p-2" data-workplace={processCode}>
                    <div className="mb-2 flex items-center justify-between gap-2 px-1">
                      <h3 className="font-mono text-sm font-black text-cyan-200">{processCode} 작업장</h3>
                      <span className="text-xs font-bold text-slate-400">{processResources.length}개</span>
                    </div>
                    {groupResourceHierarchy(processResources).map((group) => (
                      <div key={group.parentCode} className="mb-2 last:mb-0">
                        {group.parent ? (() => {
                          const selected = group.parent.resourceId === selectedResourceId;
                          return (
                            <button type="button" onClick={() => setSelectedResourceId(group.parent!.resourceId)} aria-pressed={selected} className={`flex min-h-16 w-full cursor-pointer items-center gap-3 rounded-xl border px-3 text-left transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 ${selected ? 'border-cyan-300 bg-cyan-400/15' : 'border-slate-700 bg-[#07111d] hover:border-cyan-300/70'}`}>
                              <Factory className={`h-5 w-5 shrink-0 ${selected ? 'text-cyan-200' : 'text-slate-500'}`} />
                              <span className="min-w-0 flex-1"><strong className="block truncate font-mono text-sm text-white">{group.parent.resourceCode}</strong><span className="block truncate text-xs text-slate-400">{group.parent.resourceName} · {group.parent.resourceType}</span></span>
                              <span className={`flex h-6 w-6 shrink-0 items-center justify-center rounded-md border ${selected ? 'border-cyan-200 bg-cyan-300/20 text-cyan-100' : 'border-slate-600 text-transparent'}`}><Check className="h-4 w-4" /></span>
                            </button>
                          );
                        })() : (
                          <div className="rounded-lg border border-dashed border-slate-600 px-3 py-2 text-xs font-bold text-slate-300">상위 라인 {group.parentCode}</div>
                        )}
                        {group.cells.length > 0 && (
                          <div className="ml-3 mt-1.5 space-y-1.5 border-l-2 border-cyan-400/25 pl-2">
                            {group.cells.map((cell) => {
                              const selected = cell.resourceId === selectedResourceId;
                              return (
                                <button key={cell.resourceId} type="button" onClick={() => setSelectedResourceId(cell.resourceId)} aria-pressed={selected} className={`flex min-h-16 w-full cursor-pointer items-center gap-3 rounded-xl border px-3 text-left transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan-300 ${selected ? 'border-amber-300 bg-amber-300/15' : 'border-slate-700 bg-[#07111d] hover:border-amber-300/70'}`}>
                                  <GitBranch className={`h-5 w-5 shrink-0 ${selected ? 'text-amber-200' : 'text-slate-500'}`} />
                                  <span className="min-w-0 flex-1"><strong className="block truncate font-mono text-sm text-white">{cell.resourceCode}</strong><span className="block truncate text-xs text-slate-400">{cell.resourceName} · CELL</span></span>
                                  <span className={`flex h-6 w-6 shrink-0 items-center justify-center rounded-md border ${selected ? 'border-amber-200 bg-amber-300/20 text-amber-100' : 'border-slate-600 text-transparent'}`}><Check className="h-4 w-4" /></span>
                                </button>
                              );
                            })}
                          </div>
                        )}
                      </div>
                    ))}
                  </section>
                );
              })}
              {!resourcesLoading && resourceError && <div className="rounded-xl border border-amber-300/40 bg-amber-300/10 p-3 text-sm font-semibold text-amber-100">{resourceError}</div>}
            </div>
          </section>

          <section className="flex min-h-[240px] min-w-0 flex-col overflow-hidden rounded-2xl border border-slate-700/80 bg-[#0d1a2a] p-3" aria-labelledby="result-entry-step-2">
            <div className="flex shrink-0 items-start justify-between gap-2">
              <div><p className="font-mono text-xs font-black tracking-[0.2em] text-amber-300">02 / WORK ORDER</p><h2 id="result-entry-step-2" className="mt-1 text-lg font-black text-white">작업지시 선택</h2></div>
              <input type="date" value={workDate} onChange={(event) => setWorkDate(event.target.value)} aria-label="작업지시 조회 날짜" required className="min-h-11 rounded-lg border border-slate-600 bg-[#101f31] px-2 font-mono text-sm font-bold text-slate-100 outline-none focus:border-amber-300 focus:ring-2 focus:ring-amber-300/30" />
            </div>
            <p className="mt-1 shrink-0 truncate text-xs text-slate-400">{selectedResource ? `${selectedResource.resourceName} · 미완료 우선` : '먼저 라인/셀을 선택하세요.'}</p>
            <div className="mt-3 min-h-0 flex-1 overflow-y-auto overscroll-contain pr-1">
              {ordersLoading && <div className="flex h-full min-h-24 items-center justify-center gap-2 text-sm text-slate-300"><Loader2 className="h-5 w-5 animate-spin text-amber-300" />조회 중</div>}
              {!ordersLoading && orders.map((order) => {
                const selected = order.runNo === selectedRunNo;
                const complete = isComplete(order);
                return <button key={order.runNo} type="button" onClick={() => setSelectedRunNo(order.runNo)} aria-pressed={selected} className={`mb-2 min-h-[76px] w-full cursor-pointer rounded-xl border p-3 text-left transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-amber-300 ${selected ? 'border-amber-300 bg-amber-300/12' : 'border-slate-700 bg-[#07111d] hover:border-amber-300/70'}`}>
                  <div className="flex items-center justify-between gap-2"><strong className="truncate font-mono text-sm text-white">{order.runNo}</strong><span className={`shrink-0 rounded-full px-2 py-0.5 text-[11px] font-black ${complete ? 'bg-blue-400/15 text-blue-200' : 'bg-amber-300/15 text-amber-100'}`}>{complete ? '완료' : '입력 가능'}</span></div>
                  <p className="mt-1 truncate text-xs font-semibold text-slate-200">{order.itemCode || '-'} · {order.itemName || order.modelName || '-'}</p>
                  <p className="mt-1 flex justify-between text-[11px] text-slate-400"><span>계획 {Number(order.planQty ?? 0).toLocaleString()}</span><span>누적 {Number(order.resultQty ?? 0).toLocaleString()}</span></p>
                </button>;
              })}
              {!ordersLoading && !selectedResource && <div className="flex h-full min-h-24 items-center justify-center text-center text-sm font-semibold text-slate-500">1단계에서 라인/셀을 선택하세요.</div>}
              {!ordersLoading && selectedResource && !orders.length && !orderError && <div className="flex h-full min-h-24 items-center justify-center text-center text-sm font-semibold text-slate-500">선택한 날짜의 작업지시가 없습니다.</div>}
              {!ordersLoading && orderError && <div className="rounded-xl border border-red-300/40 bg-red-300/10 p-3 text-sm font-semibold text-red-100">{orderError}<button type="button" onClick={() => selectedLineCode && void loadOrders(selectedLineCode)} className="mt-3 flex min-h-11 w-full items-center justify-center rounded-lg border border-red-200/50 font-bold">다시 조회</button></div>}
            </div>
          </section>

          <section className="flex min-h-[360px] min-w-0 flex-col overflow-hidden rounded-2xl border border-slate-700/80 bg-slate-50 text-slate-900 shadow-[0_12px_32px_rgba(0,0,0,0.2)]" aria-labelledby="result-entry-step-3">
            <div className="shrink-0 border-b border-slate-200 bg-white px-4 py-3">
              <p className="font-mono text-xs font-black tracking-[0.2em] text-emerald-700">03 / RESULT</p>
              <div className="mt-1 flex items-center justify-between gap-3"><h2 id="result-entry-step-3" className="text-lg font-black text-slate-950">작업지시 실적 입력</h2>{selectedOrder && <span className="truncate font-mono text-sm font-bold text-slate-600">{selectedOrder.runNo}</span>}</div>
            </div>
            <div className="min-h-0 flex-1 overflow-y-auto p-4">
              {selectedOrder ? <WorkResultForm key={`${selectedOrder.runNo}-${formVersion}`} run={selectedOrder} machines={lineMachines} defaultWorkerName={user?.name || user?.empNo || user?.id || ''} fieldMode onSaved={handleSaved} /> : (
                <div className="flex h-full min-h-56 flex-col items-center justify-center gap-3 rounded-xl border-2 border-dashed border-slate-300 bg-slate-100 px-6 text-center text-slate-500">
                  <ClipboardList className="h-10 w-10" /><p className="font-bold">2단계에서 작업지시를 선택하면 실적 입력 항목이 열립니다.</p><p className="text-sm">실적수량, 작업시간, 투입인원, 작업자, 처리구분을 PC 화면과 동일하게 저장합니다.</p>
                </div>
              )}
            </div>
          </section>
        </main>
      </div>
    </div>
  );
}
