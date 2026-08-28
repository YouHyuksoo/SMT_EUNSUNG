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
import { availability, performance, quality, oee } from '@smt/shared/oee';
import { oeeFetch, todayStr, pct, type OeeResult } from '../_lib/fetcher';

const PROCESSES = ['SMT', 'PERF', 'COAT', 'ROUTER', 'ASSY', 'PACK'];

interface DrilldownRow {
  RESOURCE_ID: number;
  RESOURCE_CODE: string;
  RESOURCE_TYPE: string;
  RESOURCE_NAME: string;
  SHIFT: string;
  NET_LOAD_MIN: number | null;
  IDEAL_CT: number | null;
  PLAN_QTY: number | null;
  GOOD_QTY: number | null;
  TOTAL_QTY: number | null;
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

type MetricKey = 'availability' | 'performance' | 'quality' | 'oee';

interface CalculationCheck {
  key: MetricKey;
  label: string;
  formula: string;
  calculated: number | null;
  stored: number | null;
  missing: string[];
  warnings: string[];
}

const hasNumber = (value: number | null | undefined): value is number =>
  typeof value === 'number' && Number.isFinite(value);

function checksFor(row: DrilldownRow): CalculationCheck[] {
  const availabilityMissing = [
    !hasNumber(row.RUN_MIN) && '가동시간',
    !hasNumber(row.NET_LOAD_MIN) && '순부하시간',
  ].filter(Boolean) as string[];
  const performanceMissing = [
    !hasNumber(row.IDEAL_CT) && '이론 CT',
    !hasNumber(row.TOTAL_QTY) && '총생산수량',
    !hasNumber(row.RUN_MIN) && '가동시간',
  ].filter(Boolean) as string[];
  const qualityMissing = [
    !hasNumber(row.GOOD_QTY) && '양품수량',
    !hasNumber(row.TOTAL_QTY) && '총생산수량',
  ].filter(Boolean) as string[];

  const availabilityValue = hasNumber(row.RUN_MIN) && hasNumber(row.NET_LOAD_MIN)
    ? availability(row.RUN_MIN, row.NET_LOAD_MIN)
    : null;
  const performanceValue = hasNumber(row.IDEAL_CT) && hasNumber(row.TOTAL_QTY) && hasNumber(row.RUN_MIN)
    ? performance(row.IDEAL_CT, row.TOTAL_QTY, row.RUN_MIN)
    : null;
  const qualityValue = hasNumber(row.GOOD_QTY) && hasNumber(row.TOTAL_QTY)
    ? quality(row.GOOD_QTY, row.TOTAL_QTY)
    : null;
  const oeeMissing = [...new Set([
    ...availabilityMissing,
    ...performanceMissing,
    ...qualityMissing,
  ])];

  return [
    {
      key: 'availability', label: '가동율', formula: '가동시간 ÷ 순부하시간',
      calculated: availabilityValue, stored: row.AVAILABILITY,
      missing: availabilityMissing,
      warnings: hasNumber(row.NET_LOAD_MIN) && row.NET_LOAD_MIN <= 0 ? ['순부하시간이 0 이하'] : [],
    },
    {
      key: 'performance', label: '성능율', formula: '(이론 CT × 총생산수량) ÷ 가동초',
      calculated: performanceValue, stored: row.PERFORMANCE,
      missing: performanceMissing,
      warnings: hasNumber(row.RUN_MIN) && row.RUN_MIN <= 0 ? ['가동시간이 0 이하'] : [],
    },
    {
      key: 'quality', label: '양품율', formula: '양품수량 ÷ 총생산수량',
      calculated: qualityValue, stored: row.QUALITY,
      missing: qualityMissing,
      warnings: hasNumber(row.TOTAL_QTY) && row.TOTAL_QTY <= 0 ? ['총생산수량이 0 이하'] : [],
    },
    {
      key: 'oee', label: 'OEE', formula: '가동율 × 성능율 × 양품율',
      calculated: oeeMissing.length === 0 ? oee(availabilityValue!, performanceValue!, qualityValue!) : null,
      stored: row.OEE, missing: oeeMissing, warnings: [],
    },
  ];
}

function numberValue(value: number | null | undefined, unit = ''): string {
  return hasNumber(value) ? `${value.toLocaleString(undefined, { maximumFractionDigits: 2 })}${unit}` : '누락';
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
      <p className="mb-1 font-semibold text-text">{d.RESOURCE_CODE} · {d.RESOURCE_NAME}</p>
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

  const { data, error, isLoading, mutate } = useSWR<OeeResult<DrilldownResp>>(
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

      {error ? (
        <div className="rounded-lg border border-rose-500/30 bg-rose-500/10 p-8 text-center">
          <div className="text-lg font-semibold text-rose-500">OEE 원장 조회 실패</div>
          <div className="mt-1 text-sm text-text-muted">
            계산 기초값을 불러오지 못했습니다. OEE 뷰와 원천 테이블 상태를 확인하세요.
          </div>
          <button
            type="button"
            onClick={() => void mutate()}
            className="mt-4 min-h-11 rounded-md border border-rose-500/40 px-4 py-2 text-sm font-semibold text-rose-500 hover:bg-rose-500/10 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-rose-500"
          >
            다시 조회
          </button>
        </div>
      ) : notBuilt ? (
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
                  <Cell key={`${r.RESOURCE_ID}-${r.SHIFT}`} fill={barColor(r.OEE)} />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </div>
      )}

      {resp && resp.rows.length > 0 && (
        <section className="space-y-3" aria-labelledby="calculation-verification-title">
          <div className="flex flex-wrap items-end justify-between gap-2">
            <div>
              <h2 id="calculation-verification-title" className="text-lg font-bold text-text">OEE 계산 기초값 검증</h2>
              <p className="text-sm text-text-muted">누락 값은 계산식별로 표시하고, 0 이하 분모는 별도 확인 대상으로 구분합니다.</p>
            </div>
            <span className="text-xs text-text-muted">
              원천: {resp.live ? 'V_OEE_LIVE' : 'OEE_DAILY_SUMMARY'}
            </span>
          </div>

          {resp.rows.map((row) => {
            const checks = checksFor(row);
            const hasIssue = checks.some((check) => check.missing.length > 0 || check.warnings.length > 0);
            return (
              <article key={`${row.RESOURCE_ID}-${row.SHIFT}`} className="overflow-hidden rounded-xl border border-border bg-surface">
                <header className="flex flex-wrap items-center justify-between gap-2 border-b border-border px-4 py-3">
                  <div>
                    <h3 className="font-semibold text-text">{row.RESOURCE_CODE} · {row.RESOURCE_NAME}</h3>
                    <p className="text-xs text-text-muted">{row.RESOURCE_TYPE} · 리소스 #{row.RESOURCE_ID} · 업무구간 {row.SHIFT || '누락'}</p>
                  </div>
                  <span className={`rounded-full px-2.5 py-1 text-xs font-semibold ${
                    hasIssue ? 'bg-amber-500/15 text-amber-600 dark:text-amber-400' : 'bg-emerald-500/15 text-emerald-600 dark:text-emerald-400'
                  }`}>
                    {hasIssue ? '기초값 확인 필요' : '계산 가능'}
                  </span>
                </header>

                <div className="grid grid-cols-2 gap-px bg-border sm:grid-cols-3 lg:grid-cols-8">
                  {[
                    ['순부하시간', numberValue(row.NET_LOAD_MIN, '분')],
                    ['가동시간', numberValue(row.RUN_MIN, '분')],
                    ['비가동시간', numberValue(row.DOWNTIME_MIN, '분')],
                    ['이론 CT', numberValue(row.IDEAL_CT, '초')],
                    ['계획수량', numberValue(row.PLAN_QTY)],
                    ['생산수량', numberValue(row.OUTPUT_QTY)],
                    ['양품수량', numberValue(row.GOOD_QTY)],
                    ['총생산수량', numberValue(row.TOTAL_QTY)],
                  ].map(([label, value]) => (
                    <div key={label} className="bg-surface px-3 py-3">
                      <div className="text-[11px] text-text-muted">{label}</div>
                      <div className={`mt-1 font-mono text-sm font-semibold ${value === '누락' ? 'text-rose-500' : 'text-text'}`}>{value}</div>
                    </div>
                  ))}
                </div>

                <div className="overflow-x-auto">
                  <table className="min-w-[760px] w-full text-sm">
                    <thead className="bg-background text-left text-xs text-text-muted">
                      <tr>
                        <th className="px-4 py-2 font-medium">지표</th>
                        <th className="px-4 py-2 font-medium">계산식</th>
                        <th className="px-4 py-2 text-right font-medium">재계산</th>
                        <th className="px-4 py-2 text-right font-medium">원장값</th>
                        <th className="px-4 py-2 font-medium">계산 상태</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-border">
                      {checks.map((check) => (
                        <tr key={check.key}>
                          <td className="px-4 py-2 font-semibold text-text">{check.label}</td>
                          <td className="px-4 py-2 font-mono text-xs text-text-muted">{check.formula}</td>
                          <td className="px-4 py-2 text-right font-mono text-text">{check.calculated == null ? '-' : pct(check.calculated)}</td>
                          <td className="px-4 py-2 text-right font-mono text-text">{pct(check.stored)}</td>
                          <td className="px-4 py-2">
                            {check.missing.length > 0 ? (
                              <span className="font-semibold text-rose-500">계산 불가 · 누락: {check.missing.join(', ')}</span>
                            ) : check.warnings.length > 0 ? (
                              <span className="font-semibold text-amber-600 dark:text-amber-400">계산값 0 · {check.warnings.join(', ')}</span>
                            ) : (
                              <span className="font-semibold text-emerald-600 dark:text-emerald-400">계산 가능</span>
                            )}
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </article>
            );
          })}
        </section>
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
