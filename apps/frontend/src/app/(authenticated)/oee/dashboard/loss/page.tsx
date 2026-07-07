'use client';

/**
 * @file (authenticated)/oee/dashboard/loss/page.tsx
 * @description 로스 파레토(대시보드 46). 비가동 사유별 시간 내림차순 막대 + 누적% 선(Recharts).
 * 원장(OEE_OPERATION_LOG)을 당일/과거 공통 집계하므로 스냅샷 분기·409가 없다.
 */
import { useMemo, useState } from 'react';
import useSWR from 'swr';
import Link from 'next/link';
import {
  ComposedChart, Bar, Line, XAxis, YAxis, CartesianGrid, Tooltip,
  ResponsiveContainer, Cell, Legend,
} from 'recharts';
import { oeeFetch, todayStr, type OeeResult } from '../_lib/fetcher';

interface LossRow {
  REASON_CODE: string;
  REASON_NAME: string;
  LOSS_BUCKET: string | null;
  DOWN_MIN: number;
}
interface LossResp {
  workDate: string;
  rows: LossRow[];
}

const isDark = () =>
  typeof document !== 'undefined' && document.documentElement.classList.contains('dark');

/** 로스 버킷별 색상 (OEE 3대 요소 + 부가) */
const BUCKET_COLOR: Record<string, string> = {
  AVAILABILITY: '#6366f1',
  PERFORMANCE: '#f59e0b',
  QUALITY: '#f43f5e',
  MATERIAL: '#14b8a6',
  SETUP: '#8b5cf6',
};
const bucketColor = (b: string | null) => (b && BUCKET_COLOR[b]) || '#64748b';

export default function OeeLossPage() {
  const [date, setDate] = useState(todayStr());
  const { data, isLoading } = useSWR<OeeResult<LossResp>>(
    `/oee/dashboard/loss?date=${date}`,
    (url: string) => oeeFetch<LossResp>(url),
    { refreshInterval: 30000 },
  );

  const rows = data?.data?.rows ?? [];
  const dark = isDark();
  const gridColor = dark ? '#334155' : '#e2e8f0';
  const textColor = dark ? '#94a3b8' : '#64748b';

  // 누적 비율(파레토) 계산
  const chartData = useMemo(() => {
    const total = rows.reduce((s, r) => s + r.DOWN_MIN, 0);
    let cum = 0;
    return rows.map((r) => {
      cum += r.DOWN_MIN;
      return {
        ...r,
        CUM_PCT: total > 0 ? Number(((cum / total) * 100).toFixed(1)) : 0,
      };
    });
  }, [rows]);

  return (
    <div className="p-6 space-y-4">
      <div className="flex flex-wrap items-center gap-3">
        <Link href="/oee/dashboard" className="text-sm text-primary hover:underline">
          ← 공정별 종합
        </Link>
        <h1 className="text-xl font-bold text-text">OEE 로스 파레토</h1>
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
      </div>

      {chartData.length === 0 ? (
        <div className="rounded-lg border border-border p-8 text-center text-text-muted">
          {isLoading ? '불러오는 중…' : '해당 일자의 비가동(로스) 기록이 없습니다'}
        </div>
      ) : (
        <div className="rounded-xl border border-border bg-surface p-4">
          <div className="mb-2 text-sm text-text-muted">사유별 비가동 시간(분) · 누적%</div>
          <ResponsiveContainer width="100%" height={360}>
            <ComposedChart data={chartData} margin={{ top: 16, right: 16, left: 0, bottom: 8 }}>
              <CartesianGrid strokeDasharray="3 3" stroke={gridColor} vertical={false} />
              <XAxis
                dataKey="REASON_NAME"
                tick={{ fontSize: 11, fill: textColor }}
                interval={0}
                angle={-20}
                textAnchor="end"
                height={56}
              />
              <YAxis yAxisId="left" tick={{ fontSize: 11, fill: textColor }} allowDecimals={false} />
              <YAxis
                yAxisId="right"
                orientation="right"
                domain={[0, 100]}
                unit="%"
                tick={{ fontSize: 11, fill: textColor }}
              />
              <Tooltip
                contentStyle={{
                  fontSize: 12,
                  background: dark ? '#1e293b' : '#fff',
                  border: `1px solid ${gridColor}`,
                  borderRadius: 8,
                  color: dark ? '#e2e8f0' : '#1e293b',
                }}
                formatter={(value: unknown, name: unknown) =>
                  name === '누적%' ? [`${value as number}%`, '누적%'] : [`${value as number}분`, '비가동']
                }
              />
              <Legend wrapperStyle={{ fontSize: 12 }} />
              <Bar yAxisId="left" dataKey="DOWN_MIN" name="비가동(분)" radius={[3, 3, 0, 0]} barSize={36}>
                {chartData.map((r) => (
                  <Cell key={r.REASON_CODE} fill={bucketColor(r.LOSS_BUCKET)} />
                ))}
              </Bar>
              <Line
                yAxisId="right"
                type="monotone"
                dataKey="CUM_PCT"
                name="누적%"
                stroke={dark ? '#e2e8f0' : '#1e293b'}
                strokeWidth={2}
                dot={{ r: 3 }}
              />
            </ComposedChart>
          </ResponsiveContainer>
        </div>
      )}
    </div>
  );
}
