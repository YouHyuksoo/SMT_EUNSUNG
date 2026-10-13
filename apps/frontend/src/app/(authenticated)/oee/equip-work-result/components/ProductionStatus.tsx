'use client';

/**
 * @file oee/equip-work-result/components/ProductionStatus.tsx
 * @description 중앙 생산 현황 — 위: 작업지시 정보(모델·작업지시번호·수량), 가운데: 실적 이력 그리드(최근순),
 *              아래: 지표 띠(계획·실적·목표·달성율·계획달성율·UPH).
 *
 * 초보자 가이드:
 * 1. 이력의 [취소]는 두 번 눌러야 취소된다(첫 번째는 확인). 취소된 실적은 행이 남고 합계에서 빠진다.
 * 2. 취소는 오늘 업무일 실적만 가능하다 — 서버가 다시 확인한다.
 * 3. 지표 계산은 _lib/kpi.ts 에 있다. 계산할 수 없는 값은 '-' 로 보인다.
 */
import { useMemo, useState } from 'react';
import type { ColumnDef } from '@tanstack/react-table';
import DataGrid from '@/components/data-grid/DataGrid';
import { isSensorPending } from '@/components/shared/sensorApply';
import { computeKpis, businessDate } from '../_lib/kpi';
import { runState, RUN_STATE_CLASS, RUN_STATE_LABEL, type ResultHistoryRow, type RunRow } from '../_lib/types';

interface Props {
  run: RunRow;
  history: ResultHistoryRow[];
  now: Date;
  onCancel: (row: ResultHistoryRow) => Promise<void>;
}

const fmt = (n: number | null, digits = 0) =>
  n == null ? '-' : n.toLocaleString(undefined, { minimumFractionDigits: digits, maximumFractionDigits: digits });

function Fact({ label, value }: { label: string; value: string }) {
  return (
    <div className="min-w-0">
      <div className="text-xs text-text-muted">{label}</div>
      <div className="text-base font-semibold text-text truncate" title={value}>{value}</div>
    </div>
  );
}

function Kpi({ label, value, hint, bar, tone }: { label: string; value: string; hint: string; bar?: number | null; tone?: 'good' | 'warn' }) {
  const color = tone === 'good' ? 'text-emerald-600 dark:text-emerald-400' : tone === 'warn' ? 'text-amber-600 dark:text-amber-400' : 'text-text';
  return (
    <div className="min-w-0 px-4 py-3 border-r border-border last:border-r-0">
      <div className="text-xs text-text-muted">{label}</div>
      <div className={`font-mono text-3xl font-semibold leading-tight tabular-nums ${color}`}>{value}</div>
      <div className="text-[11px] text-text-muted truncate">{hint}</div>
      {bar != null && (
        <div className="mt-1.5 h-1.5 rounded-full bg-border overflow-hidden">
          <div className={`h-full ${tone === 'good' ? 'bg-emerald-500' : tone === 'warn' ? 'bg-amber-500' : 'bg-primary'}`} style={{ width: `${Math.min(100, Math.max(0, bar))}%` }} />
        </div>
      )}
    </div>
  );
}

export default function ProductionStatus({ run, history, now, onCancel }: Props) {
  const [asking, setAsking] = useState<string | null>(null);
  const [busy, setBusy] = useState<string | null>(null);
  const kpis = computeKpis(run, history, now);
  const st = runState(run);
  const today = businessDate(now);

  // 최근 등록 순
  const rows = useMemo(
    () => [...history].sort((a, b) => (b.enteredAt ?? '').localeCompare(a.enteredAt ?? '') || b.seqNo.localeCompare(a.seqNo)),
    [history],
  );

  const columns = useMemo<ColumnDef<ResultHistoryRow>[]>(() => [
    { id: 'enteredAt', header: '등록시각', size: 150, accessorFn: (h) => h.enteredAt ?? '',
      cell: ({ row }) => <span className="font-mono">{row.original.enteredAt?.slice(5) ?? '-'}</span> },
    { accessorKey: 'resultQty', header: '수량', size: 90, meta: { align: 'right' },
      cell: ({ row }) => (
        <span className={`font-mono font-semibold ${row.original.resultStatus === 'CANCEL' ? 'line-through text-text-muted' : ''}`}>
          {row.original.resultQty.toLocaleString()}
        </span>
      ) },
    { accessorKey: 'workTime', header: '작업시간(분)', size: 100, meta: { align: 'right' },
      cell: ({ getValue }) => <span className="font-mono">{Number(getValue() ?? 0).toLocaleString()}</span> },
    { accessorKey: 'workerCount', header: '인원', size: 60, meta: { align: 'right' },
      cell: ({ getValue }) => <span className="font-mono">{Number(getValue() ?? 0)}</span> },
    { accessorKey: 'workerName', header: '작업자', size: 110 },
    { id: 'state', header: '상태', size: 110, meta: { align: 'center' },
      accessorFn: (h) => (h.resultStatus === 'CANCEL' ? '취소됨' : isSensorPending(h.resultStatus, h.sensorApplyYn) ? '미반영' : '확정'),
      cell: ({ row }) => {
        const h = row.original;
        if (h.resultStatus === 'CANCEL') return <span className="text-text-muted">취소됨</span>;
        if (isSensorPending(h.resultStatus, h.sensorApplyYn))
          return <span className="text-red-600 font-semibold" title={h.sensorApplyMsg ?? '생산현황에 반영되지 않았습니다'}>미반영</span>;
        return <span className="text-blue-600 dark:text-blue-400">확정</span>;
      } },
    { id: 'cancel', header: '', size: 110, meta: { align: 'center', filterType: 'none' as const },
      cell: ({ row }) => {
        const h = row.original;
        const cancellable = h.resultStatus !== 'CANCEL' && !!h.enteredAt && businessDateOf(h.enteredAt) === today;
        if (!cancellable) return null;
        const ask = asking === h.seqNo;
        return (
          <button type="button" disabled={busy === h.seqNo}
            onClick={async (e) => {
              e.stopPropagation();
              if (!ask) { setAsking(h.seqNo); return; }
              setBusy(h.seqNo);
              try { await onCancel(h); } finally { setBusy(null); setAsking(null); }
            }}
            onBlur={() => ask && setAsking(null)}
            className={`h-8 px-3 rounded-md text-xs font-semibold border transition-colors disabled:opacity-50 ${
              ask ? 'bg-red-600 border-red-600 text-white' : 'border-border text-text-muted hover:border-red-500 hover:text-red-600'
            }`}>
            {ask ? '취소할까요?' : '취소'}
          </button>
        );
      } },
  ], [asking, busy, onCancel, today]);

  return (
    <section className="flex-1 min-h-0 flex flex-col rounded-xl border border-border bg-surface overflow-hidden" aria-label="생산 현황">
      {/* 작업지시 정보 */}
      <div className="grid grid-cols-[minmax(0,1.3fr)_minmax(0,1fr)] gap-6 px-6 py-4 border-b border-border">
        <div className="min-w-0">
          <div className="flex items-center gap-2 text-xs text-text-muted">
            <span className="font-mono font-semibold text-text">{run.workOrderNo ?? run.runNo}</span>
            {run.workOrderNo && <span className="font-mono">롯트 {run.runNo}</span>}
            <span className={`px-2 py-0.5 rounded-full font-semibold ${RUN_STATE_CLASS[st]}`}>{RUN_STATE_LABEL[st]}</span>
            <span>계획일 {run.runDate}</span>
          </div>
          <div className="mt-1 text-3xl font-bold text-text leading-tight break-words">{run.modelName ?? run.itemName ?? '-'}</div>
          <div className="text-sm text-text-muted font-mono">{run.itemCode ?? '-'} | Rev {run.revision ?? '-'}{run.carModel ? ` · 차종 ${run.carModel}` : ''}</div>
        </div>
        <div className="grid grid-cols-3 gap-x-4 gap-y-2 content-start">
          <Fact label="작업지시 수량" value={`${fmt(run.planQty ?? 0)} ${run.unit ?? ''}`.trim()} />
          <Fact label="C/T" value={run.ct != null ? `${run.ct} s` : '-'} />
          <Fact label="교대" value={run.shiftCode ?? '-'} />
          <Fact label="실적" value={fmt(run.resultQty)} />
          <Fact label="불량" value={fmt(run.defectQty)} />
          <Fact label="잔량" value={fmt(Math.max(0, Number(run.planQty ?? 0) - run.resultQty))} />
        </div>
      </div>

      {/* 실적 이력 — 최근순 */}
      <div className="flex-1 min-h-0 flex flex-col px-6 py-3 gap-2">
        <div className="text-sm font-semibold text-text-muted">실적 이력</div>
        <div className="flex-1 min-h-0">
          <DataGrid
            data={rows}
            columns={columns}
            getRowId={(h) => h.seqNo}
            pageSize={1000}
            enableColumnFilter={false}
            enableColumnReordering={false}
            enableFullscreen={false}
            showFooter={false}
            emptyMessage="등록된 실적이 없습니다. 오른쪽 숫자패드로 입력하세요."
          />
        </div>
      </div>

      {/* 지표 띠 */}
      <div className="grid grid-cols-6 border-t border-border bg-background/60">
        <Kpi label="계획" value={fmt(kpis.plan)} hint="작업지시 수량" />
        <Kpi label="실적" value={fmt(kpis.result)} hint="취소 제외 실적 합계" />
        <Kpi label="목표" value={fmt(kpis.target)} hint={run.runDate === today ? '08:30부터 경과 ÷ C/T' : '지난 계획일은 계획수량'} />
        <Kpi label="달성율" value={kpis.achieveRate == null ? '-' : `${fmt(kpis.achieveRate, 1)}%`} hint="실적 ÷ 목표"
          bar={kpis.achieveRate} tone={kpis.achieveRate == null ? undefined : kpis.achieveRate >= 100 ? 'good' : 'warn'} />
        <Kpi label="계획달성율" value={kpis.planRate == null ? '-' : `${fmt(kpis.planRate, 1)}%`} hint="실적 ÷ 계획" bar={kpis.planRate} />
        <Kpi label="UPH" value={fmt(kpis.uph)} hint="실적 ÷ 작업시간" />
      </div>
    </section>
  );
}

/** 'YYYY-MM-DD HH24:MI:SS' 등록시각 → 업무일(08:30 기준) */
function businessDateOf(enteredAt: string): string {
  const d = new Date(enteredAt.replace(' ', 'T'));
  return Number.isNaN(d.getTime()) ? '' : businessDate(d);
}
