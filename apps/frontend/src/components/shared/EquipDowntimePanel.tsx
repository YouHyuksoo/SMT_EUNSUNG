'use client';

/**
 * @file src/components/shared/EquipDowntimePanel.tsx
 * @description 설비비가동 시작/종료 공용 패널 — 설비 기준으로 이력·진행중을 다룬다 (ADR 0002)
 *
 * 컨테이너에 의존하지 않는다. 슬라이드 패널·모달·인라인 어디에 넣어도 동작하도록
 * 바깥 껍데기(헤더/닫기 버튼)는 호출하는 쪽이 만든다.
 *
 * API: /oee/work-result/downtimes(GET machineCode · POST/PUT) · /downtime-reasons
 *
 * 사용 예:
 *   <EquipDowntimePanel machine={{ machineCode, machineName, workstageCode }} runNo={runNo} onChanged={reload} />
 *   <EquipDowntimePanel machine={null} selectableMachines={machines} onChanged={reload} />
 */

import { useCallback, useEffect, useMemo, useState } from 'react';
import type { ColumnDef } from '@tanstack/react-table';
import { useActiveInterval } from '@/hooks/useTabActive';
import { Search } from 'lucide-react';
import toast from 'react-hot-toast';
import { Input, Modal } from '@/components/ui';
import DataGrid from '@/components/data-grid/DataGrid';
import api from '@/services/api';
import DowntimeReasonGrid from './DowntimeReasonGrid';

export interface DowntimeMachine {
  machineCode: string;
  machineName: string | null;
  workstageCode: string | null;
}
interface Code { code: string; name: string; }
interface DowntimeRow {
  dtSeq: number; runNo: string | null; machineCode: string; workstageCode: string | null;
  reasonCode: string | null; reasonName: string | null;
  startTime: string | null; startAt: string | null; endTime: string | null;
  memo: string | null; worker: string | null;
}

// 이력 표 공용 컬럼 — 사유 · 시작 · 종료 · 상태
const reasonColumn: ColumnDef<DowntimeRow> = { id: 'reason', header: '사유', accessorFn: (d) => d.reasonName ?? d.reasonCode ?? '-' };
const timeColumns: ColumnDef<DowntimeRow>[] = [
  { accessorKey: 'startTime', header: '시작', cell: ({ row }) => <span className="font-mono">{row.original.startTime ?? '-'}</span> },
  {
    // 종료가 없으면 진행중 — 필터·내보내기에도 같은 글자가 나가도록 값으로 만든다
    id: 'endTime',
    header: '종료',
    accessorFn: (d) => d.endTime ?? '진행중',
    cell: ({ row }) => <span className="font-mono">{row.original.endTime ?? <span className="text-red-500 font-sans">진행중</span>}</span>,
  },
  {
    id: 'status',
    header: '상태',
    accessorFn: (d) => (d.endTime ? '완료' : '진행중'),
    meta: { align: 'center', filterType: 'select' },
    cell: ({ row }) => (row.original.endTime
      ? <span className="px-2 py-0.5 rounded bg-blue-500 text-white text-xs">완료</span>
      : <span className="px-2 py-0.5 rounded bg-amber-500 text-white text-xs">진행중</span>),
  },
];
/** 최신 1건 */
const latestColumns: ColumnDef<DowntimeRow>[] = [reasonColumn, ...timeColumns];
/** 전체 이력 팝업 — 순번 · 작업지시가 더 붙는다 */
const historyColumns: ColumnDef<DowntimeRow>[] = [
  { accessorKey: 'dtSeq', header: '순번', meta: { align: 'center' }, cell: ({ row }) => <span className="font-mono">{row.original.dtSeq}</span> },
  {
    id: 'runNo',
    header: '작업지시',
    accessorFn: (d) => d.runNo ?? '없음',
    cell: ({ row }) => <span className="font-mono">{row.original.runNo ?? <span className="text-text-muted font-sans">없음</span>}</span>,
  },
  reasonColumn,
  ...timeColumns,
];

/** 'YYYY-MM-DD HH:MM:SS' 를 로컬 시각으로 파싱 (브라우저별 문자열 파싱 차이 회피) */
export function parseLocalTime(s: string): number | null {
  const m = s.match(/^(\d{4})-(\d{2})-(\d{2})[ T](\d{2}):(\d{2})(?::(\d{2}))?$/);
  if (!m) return null;
  return new Date(+m[1], +m[2] - 1, +m[3], +m[4], +m[5], +(m[6] ?? '0')).getTime();
}

/** 비가동 시작시각부터의 경과시간을 1초마다 HH:MM:SS로 갱신 (진행중일 때만 마운트).
 *  startAt은 DB 시각이므로 브라우저 시계와의 차이(skewMs)를 더해 맞춘다. */
export function ElapsedTime({ startAt, skewMs }: { startAt: string | null; skewMs: number }) {
  const [now, setNow] = useState(() => Date.now());
  useActiveInterval(() => setNow(Date.now()), 1000, { catchUp: true });
  const started = startAt ? parseLocalTime(startAt) : null;
  if (started == null) return <>--:--:--</>;
  const sec = Math.max(0, Math.floor((now + skewMs - started) / 1000));
  const p = (n: number) => String(n).padStart(2, '0');
  return <>{p(Math.floor(sec / 3600))}:{p(Math.floor((sec % 3600) / 60))}:{p(sec % 60)}</>;
}

/** 설비 검색 콤보 (native input + 필터 리스트) */
function MachineCombo({ machines, value, onSelect }: { machines: DowntimeMachine[]; value: string; onSelect: (m: DowntimeMachine) => void }) {
  const [q, setQ] = useState('');
  const [open, setOpen] = useState(false);
  const list = useMemo(() => {
    const s = q.trim().toLowerCase();
    return (s ? machines.filter((m) => `${m.machineCode} ${m.machineName ?? ''}`.toLowerCase().includes(s)) : machines).slice(0, 100);
  }, [machines, q]);
  const sel = machines.find((m) => m.machineCode === value);
  return (
    <div className="relative">
      <button type="button" onClick={() => setOpen((o) => !o)}
        className="w-full border border-border rounded p-2 bg-background text-text text-left text-sm flex justify-between items-center">
        <span className={sel ? '' : 'text-text-muted'}>{sel ? `${sel.machineCode} · ${sel.machineName ?? ''}` : '설비선택'}</span>
        <Search className="w-4 h-4 text-text-muted" />
      </button>
      {open && (
        <div className="absolute z-20 mt-1 w-full bg-background border border-border rounded shadow-lg max-h-64 overflow-auto">
          <div className="p-1 sticky top-0 bg-background border-b border-border">
            <Input placeholder="설비코드/명 검색" value={q} onChange={(e) => setQ(e.target.value)} leftIcon={<Search className="w-4 h-4" />} fullWidth />
          </div>
          {list.map((m) => (
            <button key={m.machineCode} type="button" onClick={() => { onSelect(m); setOpen(false); setQ(''); }}
              className="w-full text-left px-3 py-1.5 text-sm hover:bg-surface border-b border-border last:border-0">
              <span className="font-mono">{m.machineCode}</span> · {m.machineName ?? ''}
              <span className="text-text-muted text-xs"> ({m.workstageCode})</span>
            </button>
          ))}
          {!list.length && <div className="p-3 text-center text-text-muted text-xs">설비 없음</div>}
        </div>
      )}
    </div>
  );
}

/** 비가동 이력 상세 팝업 (전체 이력, 최신이 위) */
function DowntimeHistoryModal({ isOpen, onClose, downtimes, machineCode }: { isOpen: boolean; onClose: () => void; downtimes: DowntimeRow[]; machineCode: string }) {
  const rows = useMemo(() => [...downtimes].reverse(), [downtimes]);
  return (
    <Modal isOpen={isOpen} onClose={onClose} title="비가동 이력 상세" size="2xl">
      <DataGrid
        data={rows}
        columns={historyColumns}
        pageSize={100}
        maxHeight="60vh"
        enableFullscreen={false}
        enableExport
        exportFileName={`비가동이력_${machineCode}`}
        getRowId={(d) => String(d.dtSeq)}
        emptyMessage="비가동 이력이 없습니다"
      />
    </Modal>
  );
}

/** 비가동 이력 — 최신 1건 카드 + 이력보기 팝업. 패널 밖(입력판 아래 등)에 따로 둘 때 쓴다.
 *  refreshKey 가 바뀌면 다시 조회한다(예: 설비의 진행중 비가동 순번). */
export function EquipDowntimeHistory({ machineCode, refreshKey }: { machineCode: string; refreshKey?: unknown }) {
  const [downtimes, setDowntimes] = useState<DowntimeRow[]>([]);
  const [historyOpen, setHistoryOpen] = useState(false);

  useEffect(() => {
    let alive = true;
    (async () => {
      if (!machineCode) { setDowntimes([]); return; }
      try {
        const res = await api.get('/oee/work-result/downtimes', { params: { machineCode } });
        if (alive) setDowntimes(res.data?.data?.list ?? []);
      } catch { if (alive) setDowntimes([]); }
    })();
    return () => { alive = false; };
  }, [machineCode, refreshKey]);

  const latest = downtimes.length ? downtimes[downtimes.length - 1] : null;

  return (
    <section className="flex-shrink-0 rounded-xl border border-border bg-surface p-3.5 space-y-2" aria-label="비가동 이력">
      <div className="flex items-center justify-between">
        <h2 className="text-sm font-bold text-text">비가동 이력 <span className="font-normal text-text-muted text-xs">(최신)</span></h2>
        <button type="button" onClick={() => setHistoryOpen(true)} disabled={downtimes.length <= 1}
          className="text-xs border border-primary text-primary rounded px-2 py-1 hover:bg-background disabled:border-border disabled:text-text-muted disabled:hover:bg-transparent disabled:cursor-not-allowed">
          이력보기{downtimes.length > 1 ? ` (${downtimes.length})` : ''}
        </button>
      </div>
      {latest ? (
        <div className="rounded-lg border border-border bg-background px-2.5 py-2 text-xs space-y-1">
          <div className="flex items-center justify-between gap-2">
            <span className="font-semibold text-text truncate">{latest.reasonName ?? latest.reasonCode ?? '-'}</span>
            {latest.endTime
              ? <span className="flex-shrink-0 px-2 py-0.5 rounded bg-blue-500 text-white">완료</span>
              : <span className="flex-shrink-0 px-2 py-0.5 rounded bg-amber-500 text-white">진행중</span>}
          </div>
          <div className="text-text-muted">시작 <span className="font-mono text-text">{latest.startTime ?? '-'}</span></div>
          <div className="text-text-muted">종료 {latest.endTime
            ? <span className="font-mono text-text">{latest.endTime}</span>
            : <span className="text-red-500">진행중</span>}</div>
        </div>
      ) : (
        <p className="py-2 text-center text-xs text-text-muted">{machineCode ? '비가동 이력이 없습니다' : '설비를 먼저 선택하세요'}</p>
      )}
      <DowntimeHistoryModal isOpen={historyOpen} onClose={() => setHistoryOpen(false)} downtimes={downtimes} machineCode={machineCode} />
    </section>
  );
}

interface Props {
  /** 대상 설비. null이면 selectableMachines에서 직접 고른다 */
  machine: DowntimeMachine | null;
  /** machine이 null일 때 고를 수 있는 설비 목록 */
  selectableMachines?: DowntimeMachine[];
  /** 비가동이 발생한 작업지시 (선택 — 없으면 RUN_NO NULL로 저장) */
  runNo?: string | null;
  /** 시작/종료 후 바깥 목록을 갱신하고 싶을 때 */
  onChanged?: () => void | Promise<void>;
  /** 이력 표를 패널 밖(EquipDowntimeHistory)에 따로 둘 때 true */
  hideHistory?: boolean;
}

export default function EquipDowntimePanel({ machine, selectableMachines = [], runNo, onChanged, hideHistory = false }: Props) {
  // machine prop이 있으면 그걸 쓰고, 없으면 콤보로 고른 설비를 쓴다
  const [picked, setPicked] = useState<DowntimeMachine | null>(null);
  const target = machine ?? picked;
  const machineCode = target?.machineCode ?? '';

  const [downtimes, setDowntimes] = useState<DowntimeRow[]>([]);
  const [dtReasons, setDtReasons] = useState<Code[]>([]);
  const [form, setForm] = useState<{ reasonCode: string; memo: string; worker: string }>({ reasonCode: '', memo: '', worker: '' });
  // DB 시각 − 브라우저 시각 (경과 타이머 보정용)
  const [clockSkew, setClockSkew] = useState(0);
  const [historyOpen, setHistoryOpen] = useState(false);

  // downtimes는 설비 기준으로 조회되므로 종료여부만 보면 된다 (ADR 0002)
  const openEvent = useMemo(() => downtimes.find((d) => !d.endTime) ?? null, [downtimes]);
  const latest = downtimes.length ? downtimes[downtimes.length - 1] : null;

  // 종료 상태에서 변경 가능한 비가동 사유 (진행중 이벤트의 현재 사유로 초기화)
  const [endReasonCode, setEndReasonCode] = useState('');
  useEffect(() => { setEndReasonCode(openEvent?.reasonCode ?? ''); }, [openEvent]);

  // 비가동 이력 조회 + DB 현재시각으로 브라우저 시계 오차 보정
  const load = useCallback(async (code: string) => {
    if (!code) { setDowntimes([]); setDtReasons([]); return; }
    try {
      const res = await api.get('/oee/work-result/downtimes', { params: { machineCode: code } });
      setDowntimes(res.data?.data?.list ?? []);
      const serverNow: string | undefined = res.data?.data?.serverNow;
      const t = serverNow ? parseLocalTime(serverNow) : null;
      setClockSkew(t == null ? 0 : t - Date.now());
    } catch { setDowntimes([]); }
    try {
      const res = await api.get('/oee/work-result/downtime-reasons', { params: { machineCode: code } });
      setDtReasons(res.data?.data?.list ?? []);
    } catch { setDtReasons([]); }
  }, []);

  useEffect(() => { load(machineCode); }, [load, machineCode]);

  async function afterChange() {
    await load(machineCode);
    await onChanged?.();
  }

  async function start() {
    if (!machineCode) return toast.error('설비를 선택하세요');
    // 최초 비가동 시작은 사유 없이도 가능(종료 시 필수 선택)
    try {
      // 비가동 입력은 모든 화면이 같은 API 하나로 한다(설비 1대도 일괄 처리로)
      const res = await api.post('/oee/work-result/downtimes/bulk', {
        action: 'START', machineCodes: [machineCode], runNo: runNo || undefined,
        reasonCode: form.reasonCode || undefined, memo: form.memo || undefined, worker: form.worker || undefined,
      });
      if (!res.data?.data?.affected) toast('이미 비가동 중인 설비입니다', { icon: 'ℹ️' });
      else toast.success('비가동 시작 등록');
      setForm({ reasonCode: '', memo: '', worker: '' });
      await afterChange();
    } catch (e: unknown) {
      const msg = e && typeof e === 'object' && 'response' in e ? (e as { response?: { data?: { message?: string } } }).response?.data?.message : undefined;
      toast.error(msg || '비가동 시작 실패');
    }
  }

  async function end() {
    if (!openEvent) return;
    if (!endReasonCode) return toast.error('비가동 사유를 선택하세요');
    try {
      const res = await api.post('/oee/work-result/downtimes/bulk', {
        action: 'END', machineCodes: [openEvent.machineCode], reasonCode: endReasonCode,
      });
      if (!res.data?.data?.affected) toast('이미 종료된 비가동입니다', { icon: 'ℹ️' });
      else toast.success('비가동 종료');
      await afterChange();
    } catch (e: unknown) {
      const msg = e && typeof e === 'object' && 'response' in e ? (e as { response?: { data?: { message?: string } } }).response?.data?.message : undefined;
      toast.error(msg || '비가동 종료 실패');
    }
  }

  // 최신 1건 표 (전체 이력 팝업은 최신이 위로 오게 뒤집는다)
  const latestRows = useMemo(() => (latest ? [latest] : []), [latest]);

  return (
    <div className="space-y-4">
      {/* 설비: 지정돼 있으면 고정, 아니면 직접 선택 */}
      <div>
        <span className="text-sm font-semibold text-text">설비 {machine ? '' : '(설비 선택)'} <span className="text-red-500">*</span></span>
        {machine ? (
          <div className="mt-1 border border-border rounded p-2 bg-surface text-sm">
            <span className="font-mono">{machine.machineCode}</span> · {machine.machineName ?? ''}
            <span className="text-text-muted text-xs"> ({machine.workstageCode})</span>
          </div>
        ) : (
          <div className="mt-1">
            <MachineCombo machines={selectableMachines} value={machineCode} onSelect={setPicked} />
          </div>
        )}
      </div>

      {/* 비가동 이력 — 최신 1건만, 과거 이력은 이력보기 팝업 */}
      {!hideHistory && <div>
        <div className="flex items-center justify-between">
          <span className="text-sm font-semibold text-text">비가동 이력 <span className="font-normal text-text-muted text-xs">(최신)</span></span>
          <button type="button" onClick={() => setHistoryOpen(true)} disabled={downtimes.length <= 1}
            className="text-xs border border-primary text-primary rounded px-2 py-1 hover:bg-surface disabled:border-border disabled:text-text-muted disabled:hover:bg-transparent disabled:cursor-not-allowed">
            이력보기{downtimes.length > 1 ? ` (${downtimes.length})` : ''}
          </button>
        </div>
        <div className="mt-1">
          <DataGrid
            data={latestRows}
            columns={latestColumns}
            showFooter={false}
            enableColumnFilter={false}
            enableFullscreen={false}
            enableColumnReordering={false}
            enableColumnPinning={false}
            getRowId={(d) => String(d.dtSeq)}
            emptyMessage={machineCode ? '비가동 이력이 없습니다' : '설비를 먼저 선택하세요'}
          />
        </div>
      </div>}

      {/* 비가동 시작/종료 버튼 */}
      {openEvent ? (
        <button onClick={end} className="w-full py-5 rounded bg-emerald-500 text-white text-sm font-semibold hover:bg-emerald-600">
          비가동 종료 (<span className="font-mono tabular-nums"><ElapsedTime startAt={openEvent.startAt} skewMs={clockSkew} /></span> 경과)
        </button>
      ) : (
        <button onClick={start} disabled={!machineCode}
          className="w-full py-5 rounded bg-rose-500 text-white text-sm font-semibold hover:bg-rose-600 disabled:bg-surface disabled:text-text-muted disabled:cursor-not-allowed">
          {machineCode ? '비가동 시작 (현재시각)' : '설비를 선택하세요'}
        </button>
      )}

      {/* 비가동 사유(박스 버튼 2열) / 상세 입력 */}
      {openEvent ? (
        <div className="border-t border-border pt-3 space-y-2">
          <span className="text-sm font-semibold text-red-600">비가동 진행중 — 종료</span>
          <div className="border border-red-300 rounded p-2 bg-red-500/5 text-sm space-y-0.5">
            <div className="text-text-muted">시작 <span className="font-mono text-text">{openEvent.startTime ?? '-'}</span></div>
            {openEvent.memo && <div className="text-text-muted">메모 <span className="text-text">{openEvent.memo}</span></div>}
          </div>
          <div className="flex flex-col gap-1.5">
            <span className="text-sm text-text-muted">비가동 사유 <span className="text-red-500">*</span> (변경 가능)</span>
            <DowntimeReasonGrid reasons={dtReasons} value={endReasonCode} onChange={setEndReasonCode} />
          </div>
          <p className="text-[11px] text-text-muted">현재 이 설비는 비가동 중입니다. 종료 시각은 현재시각으로 기록됩니다.</p>
        </div>
      ) : (
        <div className="border-t border-border pt-3 space-y-2">
          <span className="text-sm font-semibold text-text">비가동 시작 등록</span>
          <div className="flex flex-col gap-1.5">
            <span className="text-sm text-text-muted">비가동 사유 <span className="text-red-500">*</span></span>
            <DowntimeReasonGrid reasons={dtReasons} value={form.reasonCode} onChange={(code) => setForm({ ...form, reasonCode: code })} />
          </div>
          <label className="text-sm text-text-muted flex flex-col gap-1">메모
            <textarea rows={2} value={form.memo} onChange={(e) => setForm({ ...form, memo: e.target.value })} className="border border-border rounded p-2 bg-background text-text resize-none" />
          </label>
          <label className="text-sm text-text-muted flex flex-col gap-1">작업자
            <input value={form.worker} onChange={(e) => setForm({ ...form, worker: e.target.value })} className="border border-border rounded p-2 bg-background text-text" />
          </label>
          <p className="text-[11px] text-text-muted">시작 시각은 현재시각으로 기록됩니다.</p>
        </div>
      )}

      {/* 비가동 이력 상세 (전체 이력) */}
      <DowntimeHistoryModal isOpen={historyOpen} onClose={() => setHistoryOpen(false)} downtimes={downtimes} machineCode={machineCode} />
    </div>
  );
}
