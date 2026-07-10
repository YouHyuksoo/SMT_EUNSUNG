'use client';

import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip,
  ResponsiveContainer, Cell, LabelList,
} from 'recharts';
import ChartCard from './ChartCard';
import type { FctLineCompareRow } from '@/lib/queries/fct-chart';

function getBarColor(ngRate: number): string {
  if (ngRate >= 5) return '#ef4444';
  if (ngRate >= 3) return '#f97316';
  if (ngRate >= 1) return '#eab308';
  return '#22d3ee';
}

function CustomTooltip({ active, payload, label }: {
  active?: boolean;
  payload?: Array<{ payload: FctLineCompareRow }>;
  label?: string;
}) {
  if (!active || !payload?.[0]) return null;
  const d = payload[0].payload;
  return (
    <div className="rounded-lg border border-white/10 bg-zinc-900/95 px-3 py-2 text-xs shadow-xl backdrop-blur">
      <p className="mb-1 font-semibold text-zinc-100">{d.LINE_NAME ?? label}</p>
      <p className="text-zinc-400">검사수: <span className="font-mono text-zinc-200">{d.TOTAL_CNT.toLocaleString()}</span></p>
      <p className="text-zinc-400">불량수: <span className="font-mono text-red-400">{d.NG_CNT.toLocaleString()}</span></p>
      <p className="text-zinc-400">불량율: <span className="font-mono text-zinc-200">{d.NG_RATE}%</span></p>
    </div>
  );
}

interface TodayLineDefectChartProps {
  data: FctLineCompareRow[];
}

export default function TodayLineDefectChart({ data }: TodayLineDefectChartProps) {
  return (
    <ChartCard title="당일 라인별 불량율" subtitle="라인 품질 비교">
      {data.length === 0 ? (
        <div className="flex h-full items-center justify-center text-sm text-zinc-500">
          데이터 없음
        </div>
      ) : (
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={data} margin={{ top: 16, right: 10, left: -8, bottom: 0 }}>
            <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.06)" />
            <XAxis dataKey="LINE_NAME" tick={{ fill: '#a1a1aa', fontSize: 11 }} axisLine={{ stroke: 'rgba(255,255,255,0.1)' }} tickLine={false} />
            <YAxis tick={{ fill: '#a1a1aa', fontSize: 11 }} axisLine={false} tickLine={false} />
            <Tooltip content={<CustomTooltip />} cursor={{ fill: 'rgba(255,255,255,0.04)' }} />
            <Bar dataKey="NG_RATE" radius={[4, 4, 0, 0]} barSize={26}>
              {data.map((row) => (
                <Cell key={row.LINE_CODE} fill={getBarColor(row.NG_RATE)} fillOpacity={0.85} />
              ))}
              <LabelList dataKey="NG_RATE" position="top" fill="#a1a1aa" fontSize={10} formatter={(v) => (typeof v === 'number' ? `${v}%` : '')} />
            </Bar>
          </BarChart>
        </ResponsiveContainer>
      )}
    </ChartCard>
  );
}
