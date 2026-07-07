'use client';

import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip,
  ResponsiveContainer, Cell, LabelList,
} from 'recharts';
import ChartCard from './ChartCard';
import type { FctModelRow } from '@/lib/queries/fct-chart';

function getBarColor(ngRate: number): string {
  if (ngRate >= 5) return '#ef4444';
  if (ngRate >= 3) return '#f97316';
  if (ngRate >= 1) return '#eab308';
  return '#22d3ee';
}

function shortModelName(value: string): string {
  return value.length > 12 ? `${value.slice(0, 11)}...` : value;
}

function CustomTooltip({ active, payload, label }: {
  active?: boolean;
  payload?: Array<{ payload: FctModelRow }>;
  label?: string;
}) {
  if (!active || !payload?.[0]) return null;
  const d = payload[0].payload;
  return (
    <div className="rounded-lg border border-white/10 bg-zinc-900/95 px-3 py-2 text-xs shadow-xl backdrop-blur">
      <p className="mb-1 font-semibold text-zinc-100">{d.MODEL_NAME ?? label}</p>
      <div className="flex items-center gap-2">
        <span className="text-zinc-400">검사수</span>
        <span className="ml-auto font-mono text-zinc-200">{d.TOTAL_CNT.toLocaleString()}</span>
      </div>
      <div className="flex items-center gap-2">
        <span className="text-zinc-400">불량수</span>
        <span className="ml-auto font-mono text-red-400">{d.NG_CNT.toLocaleString()}</span>
      </div>
      <div className="flex items-center gap-2">
        <span className="text-zinc-400">불량율</span>
        <span className="ml-auto font-mono text-zinc-200">{d.NG_RATE}%</span>
      </div>
    </div>
  );
}

interface DefectByModelChartProps {
  data: FctModelRow[];
}

export default function DefectByModelChart({ data }: DefectByModelChartProps) {
  return (
    <ChartCard title="당일 모델별 불량율" subtitle="불량율 높은 모델 우선">
      {data.length === 0 ? (
        <div className="flex h-full items-center justify-center text-sm text-zinc-500">
          데이터 없음
        </div>
      ) : (
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={data} margin={{ top: 16, right: 12, left: -8, bottom: 0 }}>
            <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.06)" />
            <XAxis
              dataKey="MODEL_NAME"
              tick={{ fill: '#a1a1aa', fontSize: 11 }}
              axisLine={{ stroke: 'rgba(255,255,255,0.1)' }}
              tickLine={false}
              tickFormatter={shortModelName}
            />
            <YAxis
              tick={{ fill: '#a1a1aa', fontSize: 11 }}
              axisLine={false}
              tickLine={false}
            />
            <Tooltip content={<CustomTooltip />} cursor={{ fill: 'rgba(255,255,255,0.04)' }} />
            <Bar dataKey="NG_RATE" radius={[4, 4, 0, 0]} barSize={32}>
              {data.map((row) => (
                <Cell key={row.MODEL_NAME} fill={getBarColor(row.NG_RATE)} fillOpacity={0.85} />
              ))}
              <LabelList dataKey="NG_RATE" position="top" fill="#a1a1aa" fontSize={11} formatter={(v) => (typeof v === 'number' ? `${v}%` : '')} />
            </Bar>
          </BarChart>
        </ResponsiveContainer>
      )}
    </ChartCard>
  );
}
