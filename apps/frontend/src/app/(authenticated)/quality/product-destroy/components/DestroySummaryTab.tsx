"use client";

/**
 * @file src/app/(authenticated)/quality/product-destroy/components/DestroySummaryTab.tsx
 * @description 공정폐기 월 요약 — 팀별 불량유형·주야·원인별 수량/폐기금액 (요청서 26.10.22 3번 시트 양식)
 *
 * 초보자 가이드:
 * 1. 월과 팀을 고르고 조회하면 /quality/product-destroy/summary 를 부른다.
 * 2. 불량유형 표는 0건 유형까지 코드 순으로 다 나온다. 점유율은 폐기금액 기준이다.
 * 3. 폐기금액은 등록 시점 단가 × 수량이다 (구매단가, 없으면 BOM 자재원가 합).
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import {
  Bar, BarChart, CartesianGrid, Cell, LabelList, Legend, Pie, PieChart, ResponsiveContainer, Tooltip, XAxis, YAxis,
} from 'recharts';
import { Button, Card, Input } from '@/components/ui';
import Spinner from '@/components/ui/Spinner';
import api from '@/services/api';
import type { DestroySummary, DestroyTeam, SummaryBucket } from '../types';

const won = (value: number) => Math.round(value).toLocaleString();
const share = (part: number, total: number) => (total > 0 ? `${((part / total) * 100).toFixed(1)}%` : '0.0%');
const thisMonth = () => {
  const now = new Date();
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;
};

const tooltipStyle = {
  background: 'var(--card)', border: '1px solid var(--border)', borderRadius: 8, fontSize: 12, color: 'var(--text)',
};
const axisTick = { fontSize: 11, fill: 'var(--text-muted)' };
const SHIFT_COLORS = ['var(--info)', 'var(--warning)'];
const CAUSE_COLORS = ['var(--error)', 'var(--warning)', 'var(--success)'];

function BucketTable({ rows }: { rows: SummaryBucket[] }) {
  const qty = rows.reduce((sum, r) => sum + r.qty, 0);
  const amount = rows.reduce((sum, r) => sum + r.amount, 0);
  return (
    <table className="w-full text-sm">
      <tbody>
        {rows.map(r => (
          <tr key={r.key} className="border-b border-border">
            <td className="py-1 text-text">{r.name}</td>
            <td className="py-1 text-right tabular-nums">{r.qty.toLocaleString()}</td>
            <td className="py-1 text-right tabular-nums">{won(r.amount)}</td>
            <td className="py-1 text-right tabular-nums text-text-muted">{share(r.amount, amount)}</td>
          </tr>
        ))}
        <tr className="font-semibold">
          <td className="py-1">합계</td>
          <td className="py-1 text-right tabular-nums">{qty.toLocaleString()}</td>
          <td className="py-1 text-right tabular-nums">{won(amount)}</td>
          <td className="py-1 text-right tabular-nums">{amount > 0 ? '100%' : '0.0%'}</td>
        </tr>
      </tbody>
    </table>
  );
}

function BucketPie({ title, rows, colors }: { title: string; rows: SummaryBucket[]; colors: string[] }) {
  const total = rows.reduce((sum, r) => sum + r.amount, 0);
  return (
    <Card className="flex min-w-0 flex-1 flex-col" padding="sm">
      <div className="mb-1 text-sm font-semibold text-text">{title}</div>
      <BucketTable rows={rows} />
      <div className="mt-2 h-44">
        {total > 0 ? (
          <ResponsiveContainer width="100%" height="100%">
            <PieChart>
              <Pie data={rows} dataKey="amount" nameKey="name" outerRadius={64} isAnimationActive={false}
                label={({ percent }: { percent?: number }) => `${((percent ?? 0) * 100).toFixed(1)}%`}>
                {rows.map((r, i) => <Cell key={r.key} fill={colors[i % colors.length]} />)}
              </Pie>
              <Tooltip contentStyle={tooltipStyle} formatter={(v) => `${won(Number(v))}원`} />
              <Legend wrapperStyle={{ fontSize: 11 }} />
            </PieChart>
          </ResponsiveContainer>
        ) : (
          <div className="flex h-full items-center justify-center text-sm text-text-muted">폐기금액이 없습니다.</div>
        )}
      </div>
    </Card>
  );
}

export default function DestroySummaryTab() {
  const [month, setMonth] = useState(thisMonth);
  const [team, setTeam] = useState<DestroyTeam>('1');
  const [data, setData] = useState<DestroySummary | null>(null);
  const [loading, setLoading] = useState(false);

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/quality/product-destroy/summary', { params: { month, team } });
      setData(response.data?.data ?? null);
    } catch {
      setData(null);
      toast.error('폐기 요약 조회에 실패했습니다');
    } finally {
      setLoading(false);
    }
  }, [month, team]);

  useEffect(() => { void load(); }, [load]);

  const totals = useMemo(() => ({
    qty: data?.byType.reduce((sum, r) => sum + r.qty, 0) ?? 0,
    amount: data?.byType.reduce((sum, r) => sum + r.amount, 0) ?? 0,
  }), [data]);

  return (
    <>
      <Card className="shrink-0" padding="sm">
        <div className="flex flex-wrap items-center gap-2">
          <Input type="month" aria-label="조회월" value={month} onChange={e => setMonth(e.target.value)} className="w-40" />
          <div className="flex overflow-hidden rounded-md border border-border" role="group" aria-label="팀">
            {(['1', '2'] as const).map(value => (
              <button key={value} type="button" onClick={() => setTeam(value)}
                className={`px-3 py-1.5 text-sm ${team === value ? 'bg-primary text-primary-foreground' : 'bg-background text-text hover:bg-surface'}`}>
                {value === '1' ? '생산1팀 (SMT)' : '생산2팀 (조립)'}
              </button>
            ))}
          </div>
          <Button size="sm" onClick={() => void load()} disabled={loading || !month}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <span className="text-sm text-text-muted">
            {month} 공정불량 · 수량 {totals.qty.toLocaleString()} · 폐기금액 {won(totals.amount)}원
          </span>
        </div>
      </Card>

      {loading && !data ? (
        <div className="flex flex-1 items-center justify-center"><Spinner /></div>
      ) : data && (
        <div className="flex min-h-0 flex-1 flex-col gap-3 overflow-y-auto">
          <div className="flex shrink-0 flex-col gap-3 xl:flex-row">
            <Card className="shrink-0 xl:w-[420px]" padding="sm">
              <div className="mb-1 text-sm font-semibold text-text">불량유형별 현황 (단위: 원)</div>
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b border-border text-text-muted">
                    <th className="py-1 text-left font-medium">불량유형</th>
                    <th className="py-1 text-right font-medium">불량수량</th>
                    <th className="py-1 text-right font-medium">폐기금액</th>
                    <th className="py-1 text-right font-medium">점유율</th>
                  </tr>
                </thead>
                <tbody>
                  {data.byType.map(r => (
                    <tr key={r.code} className={`border-b border-border ${r.qty === 0 ? 'text-text-muted' : 'text-text'}`}>
                      <td className="py-1">{r.name}</td>
                      <td className="py-1 text-right tabular-nums">{r.qty.toLocaleString()}</td>
                      <td className="py-1 text-right tabular-nums">{won(r.amount)}</td>
                      <td className="py-1 text-right tabular-nums">{share(r.amount, totals.amount)}</td>
                    </tr>
                  ))}
                  <tr className="font-semibold">
                    <td className="py-1">합계</td>
                    <td className="py-1 text-right tabular-nums">{totals.qty.toLocaleString()}</td>
                    <td className="py-1 text-right tabular-nums">{won(totals.amount)}</td>
                    <td className="py-1 text-right tabular-nums">{totals.amount > 0 ? '100%' : '0.0%'}</td>
                  </tr>
                </tbody>
              </table>
            </Card>
            <Card className="min-h-[360px] min-w-0 flex-1" padding="sm">
              <div className="mb-1 text-sm font-semibold text-text">불량유형별 폐기금액</div>
              <div className="h-[calc(100%-1.5rem)] min-h-[320px]">
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={data.byType} margin={{ top: 20, right: 8, left: 8, bottom: 40 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke="var(--border)" vertical={false} />
                    <XAxis dataKey="name" tick={axisTick} interval={0} angle={-35} textAnchor="end" height={70} />
                    <YAxis tick={axisTick} tickFormatter={(v: number) => v.toLocaleString()} width={70} />
                    <Tooltip contentStyle={tooltipStyle} formatter={(v) => `${won(Number(v))}원`} />
                    <Bar dataKey="amount" name="폐기금액" fill="var(--info)" barSize={18} isAnimationActive={false}>
                      <LabelList dataKey="amount" position="top" fontSize={10} fill="var(--text-muted)" formatter={(v) => won(Number(v))} />
                    </Bar>
                  </BarChart>
                </ResponsiveContainer>
              </div>
            </Card>
          </div>
          <div className="flex shrink-0 flex-col gap-3 md:flex-row">
            <BucketPie title="주간 / 야간" rows={data.byShift} colors={SHIFT_COLORS} />
            <BucketPie title="원인 (설비이상 / 원자재 / HUMAN)" rows={data.byCause} colors={CAUSE_COLORS} />
          </div>
        </div>
      )}
    </>
  );
}
