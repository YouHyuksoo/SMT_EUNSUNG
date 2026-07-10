'use client';

/**
 * @file (authenticated)/oee/dashboard/drilldown/page.tsx
 * @description 리소스 드릴다운(대시보드 45). 공정 선택 → 리소스별 OEE 막대(Recharts).
 * 당일=실시간, 과거=스냅샷(미마감 409 안내). 종합화면에서 processCode/date 를 쿼리로 전달받는다.
 */
import { Suspense, useState } from 'react';
import { useSearchParams } from 'next/navigation';
import useSWR from 'swr';
import Link from 'next/link';
import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Cell,
} from 'recharts';
import { oeeFetch, todayStr, pct, type OeeResult } from '../_lib/fetcher';

const PROCESSES = ['SMT', 'PERF', 'COAT', 'ROUTER', 'ASSY', 'PACK'];

interface DrilldownRow {
  RESOURCE_ID: number;
  RESOURCE_NAME: string;
  AVAILABILITY: number;
  PERFORMANCE: number;
  QUALITY: number;
  OEE: number;
  UPH: number;
  PLAN_ACHIEVE: number;
  RUN_MIN: number;
  DOWNTIME_MIN: number;
  OUTPUT_QTY: number;
}
interface DrilldownResp {
  workDate: string;
  live: boolean;
  processCode: string;
  rows: DrilldownRow[];
}

const isDark = () =>
  typeof document !== 'undefined' && document.documentElement.classList.contains('dark');

function barColor(oee: number): string {
  if (oee >= 0.85) return '#10b981';
  if (oee >= 0.6) return '#f59e0b';
  return '#f43f5e';
}

function DrilldownTooltip({ active, payload }: {
  active?: boolean;
  payload?: Array<{ payload: DrilldownRow }>;
}) {
  if (!active || !payload?.[0]) return null;
  const d = payload[0].payload;
  return (
    <div className="rounded-lg border border-border bg-surface px-3 py-2 text-xs shadow-lg">
      <p className="mb-1 font-semibold text-text">{d.RESOURCE_NAME}</p>
      <div className="grid grid-cols-2 gap-x-3 gap-y-0.5 text-text-muted">
        <span>OEE</span><span className="text-right text-text">{pct(d.OEE)}</span>
        <span>가동</span><span className="text-right">{pct(d.AVAILABILITY)}</span>
        <span>성능</span><span className="text-right">{pct(d.PERFORMANCE)}</span>
        <span>양품</span><span className="text-right">{pct(d.QUALITY)}</span>
        <span>UPH</span><span className="text-right">{d.UPH?.toFixed(0) ?? '-'}</span>
        <span>계획달성</span><span className="text-right">{pct(d.PLAN_ACHIEVE)}</span>
        <span>가동/비가동(분)</span><span className="text-right">{d.RUN_MIN}/{d.DOWNTIME_MIN}</span>
      </div>
    </div>
  );
}

function DrilldownContent() {
  const params = useSearchParams();
  const [processCode, setProcessCode] = useState(params.get('processCode') || 'SMT');
  const [date, setDate] = useState(params.get('date') || todayStr());

  const { data, isLoading } = useSWR<OeeResult<DrilldownResp>>(
    `/oee/dashboard/drilldown?processCode=${processCode}&date=${date}`,
    (url: string) => oeeFetch<DrilldownResp>(url),
    { refreshInterval: 30000 },
  );

  const resp = data?.data ?? null;
  const notBuilt = data?.notBuilt ?? false;
  const dark = isDark();
  const gridColor = dark ? '#334155' : '#e2e8f0';
  const textColor = dark ? '#94a3b8' : '#64748b';
  // OEE(0~1) → 백분율 수치로 차트 표시
  const chartData = (resp?.rows ?? []).map((r) => ({ ...r, OEE_PCT: Number((r.OEE * 100).toFixed(1)) }));

  return (
    <div className="p-6 space-y-4">
      <div className="flex flex-wrap items-center gap-3">
        <Link href="/oee/dashboard" className="text-sm text-primary hover:underline">
          ← 공정별 종합
        </Link>
        <h1 className="text-xl font-bold text-text">리소스 OEE 드릴다운</h1>
        <label className="text-sm text-text-muted flex items-center gap-2">
          공정
          <select
            value={processCode}
            onChange={(e) => setProcessCode(e.target.value)}
            className="border border-border rounded p-2 bg-background text-text"
          >
            {PROCESSES.map((p) => <option key={p}>{p}</option>)}
          </select>
        </label>
        <label className="text-sm text-text-muted flex items-center gap-2">
          일자
          <input
            type="date"
            value={date}
            max={todayStr()}
            onChange={(e) => setDate(e.target.value)}
            className="border border-border rounded p-2 bg-background text-text"
          />
        </label>
        {resp && (
          <span
            className={`text-xs px-2 py-1 rounded-full ${
              resp.live ? 'bg-emerald-500/15 text-emerald-500' : 'bg-slate-500/15 text-text-muted'
            }`}
          >
            {resp.live ? '실시간' : '마감 스냅샷'}
          </span>
        )}
      </div>

      {notBuilt ? (
        <div className="rounded-lg border border-amber-500/30 bg-amber-500/10 p-8 text-center text-amber-500">
          <div className="text-lg font-semibold">집계 미생성 (마감 필요)</div>
          <div className="mt-1 text-sm text-text-muted">
            선택한 과거 일자의 OEE 마감 스냅샷이 없습니다.
          </div>
        </div>
      ) : chartData.length === 0 ? (
        <div className="rounded-lg border border-border p-8 text-center text-text-muted">
          {isLoading ? '불러오는 중…' : `${processCode} 공정의 리소스 데이터가 없습니다`}
        </div>
      ) : (
        <div className="rounded-xl border border-border bg-surface p-4">
          <div className="mb-2 text-sm text-text-muted">{processCode} 리소스별 OEE (%)</div>
          <ResponsiveContainer width="100%" height={Math.max(240, chartData.length * 56)}>
            <BarChart data={chartData} layout="vertical" margin={{ top: 8, right: 24, left: 8, bottom: 8 }}>
              <CartesianGrid strokeDasharray="3 3" stroke={gridColor} horizontal={false} />
              <XAxis type="number" domain={[0, 100]} tick={{ fontSize: 11, fill: textColor }} unit="%" />
              <YAxis
                type="category"
                dataKey="RESOURCE_NAME"
                width={120}
                tick={{ fontSize: 11, fill: textColor }}
              />
              <Tooltip content={<DrilldownTooltip />} cursor={{ fill: 'rgba(148,163,184,0.08)' }} />
              <Bar dataKey="OEE_PCT" radius={[0, 4, 4, 0]} barSize={28}>
                {chartData.map((r) => (
                  <Cell key={r.RESOURCE_ID} fill={barColor(r.OEE)} />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </div>
      )}
    </div>
  );
}

export default function OeeDrilldownPage() {
  return (
    <Suspense fallback={<div className="p-6 text-text-muted">불러오는 중…</div>}>
      <DrilldownContent />
    </Suspense>
  );
}
