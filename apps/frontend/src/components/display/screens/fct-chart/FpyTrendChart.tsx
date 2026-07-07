'use client';

import {
  AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip,
  ResponsiveContainer, ReferenceLine,
} from 'recharts';
import ChartCard from './ChartCard';
import type { FctFpyRow } from '@/lib/queries/fct-chart';

const FPY_TARGET = 98.0;

function CustomTooltip({ active, payload, label }: {
  active?: boolean;
  payload?: Array<{ name: string; value: number }>;
  label?: string;
}) {
  if (!active || !payload) return null;
  return (
    <div className="rounded-lg border border-white/10 bg-zinc-900/95 px-3 py-2 text-xs shadow-xl backdrop-blur">
      <p className="mb-1 font-semibold text-zinc-100">{label}</p>
      {payload.map((p) => (
        <div key={p.name} className="flex items-center gap-2">
          <span className="text-zinc-400">{p.name === 'FPY' ? 'FPY' : '목표'}</span>
          <span className="ml-auto font-mono text-zinc-200">
            {p.value != null ? `${p.value.toFixed(1)}%` : '-'}
          </span>
        </div>
      ))}
    </div>
  );
}

function CustomDot({ cx, cy, payload }: {
  cx?: number; cy?: number; payload?: FctFpyRow;
}) {
  if (cx == null || cy == null || !payload || payload.FPY == null) return null;
  const achieved = payload.FPY >= FPY_TARGET;
  return (
    <circle
      cx={cx} cy={cy} r={4}
      fill={achieved ? '#4ade80' : '#facc15'}
      stroke={achieved ? '#22c55e' : '#eab308'}
      strokeWidth={2}
    />
  );
}

interface FpyTrendChartProps {
  data: FctFpyRow[];
}

export default function FpyTrendChart({ data }: FpyTrendChartProps) {
  const validFpy = data.map((d) => d.FPY).filter((v): v is number => v != null);
  const minFpy = validFpy.length > 0 ? Math.floor(Math.min(...validFpy) - 2) : 90;
  const yMin = Math.max(minFpy, 0);

  return (
    <ChartCard title="최근 7일 FPY 추이" subtitle="기능검사 직행율">
      {data.length === 0 ? (
        <div className="flex h-full items-center justify-center text-sm text-zinc-500">
          데이터 없음
        </div>
      ) : (
        <ResponsiveContainer width="100%" height="100%">
          <AreaChart data={data} margin={{ top: 8, right: 12, left: -8, bottom: 0 }}>
            <defs>
              <linearGradient id="fctFpyGradient" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor="#22d3ee" stopOpacity={0.3} />
                <stop offset="100%" stopColor="#22d3ee" stopOpacity={0.02} />
              </linearGradient>
            </defs>
            <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.06)" />
            <XAxis dataKey="WORK_DATE" tick={{ fill: '#a1a1aa', fontSize: 12 }} axisLine={{ stroke: 'rgba(255,255,255,0.1)' }} tickLine={false} />
            <YAxis domain={[yMin, 100]} tick={{ fill: '#a1a1aa', fontSize: 11 }} axisLine={false} tickLine={false} tickFormatter={(v: number) => `${v}%`} />
            <Tooltip content={<CustomTooltip />} />
            <ReferenceLine y={FPY_TARGET} stroke="#f87171" strokeDasharray="6 3" strokeWidth={1.5} label={{ value: `목표 ${FPY_TARGET}%`, position: 'right', fill: '#f87171', fontSize: 10 }} />
            <Area type="monotone" dataKey="FPY" stroke="#22d3ee" strokeWidth={2.5} fill="url(#fctFpyGradient)" dot={<CustomDot />} activeDot={{ r: 6, stroke: '#22d3ee', strokeWidth: 2, fill: '#0e7490' }} connectNulls />
          </AreaChart>
        </ResponsiveContainer>
      )}
    </ChartCard>
  );
}
