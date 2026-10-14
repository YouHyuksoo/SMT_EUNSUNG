'use client';

/**
 * @file oee/equip-inspect-result/components/InspectStatus.tsx
 * @description 중앙 검사 현황 — 위: 작업지시 정보, 가운데: 검사실적 이력 그리드(최근순), 아래: 지표 띠
 *              (검사수·합격·불합격·합격률·검사율). 설비별 작업 실적관리 ProductionStatus 와 같은 배치다.
 *
 * 초보자 가이드:
 * 1. 이력의 [취소]는 두 번 눌러야 취소된다(첫 번째는 확인). 취소된 건은 행이 남고 합계에서 빠진다.
 * 2. 취소는 오늘 업무일 건만 가능하다 — 서버가 다시 확인한다.
 * 3. 검사율 = 검사수 ÷ 작업지시 수량. 작업지시 수량이 없으면 '-'.
 */
import { useMemo, useState } from 'react';
import type { ColumnDef } from '@tanstack/react-table';
import DataGrid from '@/components/data-grid/DataGrid';
import type { RunRow } from '../../equip-work-result/_lib/types';
import { computeInspectKpis, VERDICT_LABEL, type InspectHistoryRow } from '../_lib/inspect';

interface Props {
  run: RunRow;
  history: InspectHistoryRow[];
  onCancel: (row: InspectHistoryRow) => Promise<void>;
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

function Kpi({ label, value, hint, bar, tone }: { label: string; value: string; hint: string; bar?: number | null; tone?: 'good' | 'bad' }) {
  const color = tone === 'good' ? 'text-emerald-600 dark:text-emerald-400' : tone === 'bad' ? 'text-red-600 dark:text-red-400' : 'text-text';
  return (
    <div className="min-w-0 px-4 py-3 border-r border-border last:border-r-0">
      <div className="text-xs text-text-muted">{label}</div>
      <div className={`font-mono text-3xl font-semibold leading-tight tabular-nums ${color}`}>{value}</div>
      <div className="text-[11px] text-text-muted truncate">{hint}</div>
      {bar != null && (
        <div className="mt-1.5 h-1.5 rounded-full bg-border overflow-hidden">
          <div className="h-full bg-primary" style={{ width: `${Math.min(100, Math.max(0, bar))}%` }} />
        </div>
      )}
    </div>
  );
}

export default function InspectStatus({ run, history, onCancel }: Props) {
  const [asking, setAsking] = useState<number | null>(null);
  const [busy, setBusy] = useState<number | null>(null);
  const kpis = computeInspectKpis(history);
  const plan = Number(run.planQty ?? 0);
  const coverage = plan > 0 ? (kpis.inspected / plan) * 100 : null;

  // 최근 등록 순
  const rows = useMemo(() => [...history].sort((a, b) => b.seqNo - a.seqNo), [history]);

  const columns = useMemo<ColumnDef<InspectHistoryRow>[]>(() => [
    { id: 'enteredAt', header: '등록시각', size: 140, accessorFn: (h) => h.enteredAt ?? '',
      cell: ({ row }) => <span className="font-mono">{row.original.enteredAt?.slice(5) ?? '-'}</span> },
    { id: 'verdict', header: '판정', size: 80, meta: { align: 'center' }, accessorFn: (h) => VERDICT_LABEL[h.inspectResult],
      cell: ({ row }) => {
        const h = row.original;
        return (
          <span className={`px-2 py-0.5 rounded-full text-xs font-bold ${
            h.inspectResult === 'P' ? 'bg-emerald-500/15 text-emerald-600 dark:text-emerald-400' : 'bg-red-500/15 text-red-600 dark:text-red-400'
          } ${h.resultStatus === 'CANCEL' ? 'opacity-50' : ''}`}>{VERDICT_LABEL[h.inspectResult]}</span>
        );
      } },
    { accessorKey: 'inspectQty', header: '수량', size: 80, meta: { align: 'right' },
      cell: ({ row }) => (
        <span className={`font-mono font-semibold ${row.original.resultStatus === 'CANCEL' ? 'line-through text-text-muted' : ''}`}>
          {row.original.inspectQty.toLocaleString()}
        </span>
      ) },
    { id: 'badReason', header: '불량원인', size: 130, accessorFn: (h) => h.badReasonName ?? h.badReasonCode ?? '',
      cell: ({ row }) => row.original.badReasonCode
        ? <span title={row.original.badReasonCode}>{row.original.badReasonName ?? row.original.badReasonCode}</span>
        : <span className="text-text-muted">-</span> },
    { id: 'machine', header: '검사설비', size: 140, accessorFn: (h) => h.machineName ?? h.machineCode ?? '',
      cell: ({ row }) => <span title={row.original.machineCode ?? ''}>{row.original.machineName ?? row.original.machineCode ?? '-'}</span> },
    { accessorKey: 'inspectorName', header: '검사자', size: 100 },
    { id: 'state', header: '상태', size: 80, meta: { align: 'center' },
      accessorFn: (h) => (h.resultStatus === 'CANCEL' ? '취소됨' : '확정'),
      cell: ({ row }) => row.original.resultStatus === 'CANCEL'
        ? <span className="text-text-muted">취소됨</span>
        : <span className="text-blue-600 dark:text-blue-400">확정</span> },
    { id: 'cancel', header: '', size: 110, meta: { align: 'center', filterType: 'none' as const },
      cell: ({ row }) => {
        const h = row.original;
        if (h.resultStatus === 'CANCEL' || h.today !== 'Y') return null;
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
  ], [asking, busy, onCancel]);

  return (
    <section className="flex-1 min-h-0 flex flex-col rounded-xl border border-border bg-surface overflow-hidden" aria-label="검사 현황">
      {/* 작업지시 정보 */}
      <div className="grid grid-cols-[minmax(0,1.3fr)_minmax(0,1fr)] gap-6 px-6 py-4 border-b border-border">
        <div className="min-w-0">
          <div className="flex items-center gap-2 text-xs text-text-muted">
            <span className="font-mono font-semibold text-text">{run.workOrderNo ?? run.runNo}</span>
            {run.workOrderNo && <span className="font-mono">롯트 {run.runNo}</span>}
            <span>계획일 {run.runDate}</span>
          </div>
          <div className="mt-1 text-3xl font-bold text-text leading-tight break-words">{run.modelName ?? run.itemName ?? '-'}</div>
          <div className="text-sm text-text-muted font-mono">{run.itemCode ?? '-'} | Rev {run.revision ?? '-'}{run.carModel ? ` · 차종 ${run.carModel}` : ''}</div>
        </div>
        <div className="grid grid-cols-3 gap-x-4 gap-y-2 content-start">
          <Fact label="작업지시 수량" value={`${fmt(plan)} ${run.unit ?? ''}`.trim()} />
          <Fact label="생산 실적" value={fmt(run.resultQty)} />
          <Fact label="교대" value={run.shiftCode ?? '-'} />
          <Fact label="검사수" value={fmt(kpis.inspected)} />
          <Fact label="합격" value={fmt(kpis.pass)} />
          <Fact label="불합격" value={fmt(kpis.fail)} />
        </div>
      </div>

      {/* 검사실적 이력 — 최근순 */}
      <div className="flex-1 min-h-0 flex flex-col px-6 py-3 gap-2">
        <div className="text-sm font-semibold text-text-muted">검사실적 이력</div>
        <div className="flex-1 min-h-0">
          <DataGrid
            data={rows}
            columns={columns}
            getRowId={(h) => String(h.seqNo)}
            pageSize={1000}
            enableColumnFilter={false}
            enableColumnReordering={false}
            enableFullscreen={false}
            showFooter={false}
            emptyMessage="등록된 검사실적이 없습니다. 오른쪽에서 판정과 수량을 입력하세요."
          />
        </div>
      </div>

      {/* 지표 띠 */}
      <div className="grid grid-cols-5 border-t border-border bg-background/60">
        <Kpi label="검사수" value={fmt(kpis.inspected)} hint="취소 제외 합격+불합격" />
        <Kpi label="합격" value={fmt(kpis.pass)} hint="판정 합격 수량" tone="good" />
        <Kpi label="불합격" value={fmt(kpis.fail)} hint="판정 불합격 수량" tone={kpis.fail > 0 ? 'bad' : undefined} />
        <Kpi label="합격률" value={kpis.passRate == null ? '-' : `${fmt(kpis.passRate, 1)}%`} hint="합격 ÷ 검사수"
          bar={kpis.passRate} tone={kpis.passRate == null ? undefined : kpis.passRate >= 100 ? 'good' : 'bad'} />
        <Kpi label="검사율" value={coverage == null ? '-' : `${fmt(coverage, 1)}%`} hint="검사수 ÷ 작업지시 수량" bar={coverage} />
      </div>
    </section>
  );
}
