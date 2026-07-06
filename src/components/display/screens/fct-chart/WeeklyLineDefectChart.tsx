'use client';

import {
  BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, Cell,
} from 'recharts';
import ChartCard from './ChartCard';
import type { FctLineCompareRow } from '@/lib/queries/fct-chart';

const RANK_COLORS = ['#f87171', '#fb923c', '#facc15', '#4ade80', '#22d3ee', '#38bdf8', '#818cf8', '#a78bfa'];

function CustomTooltip({ active, payload }: {
  active?: boolean;
  payload?: Array<{ payload: FctLineCompareRow }>;
}) {
  if (!active || !payload?.[0]) return null;
  const d = payload[0].payload;
  return (
    <div className="rounded-lg border border-white/10 bg-zinc-900/95 px-3 py-2 text-xs shadow-xl backdrop-blur">
      <p className="font-semibold text-zinc-100">{d.LINE_NAME}</p>
      <p className="text-zinc-400">불량수: <span className="font-mono text-zinc-200">{d.NG_CNT.toLocaleString()}</span></p>
      <p className="text-zinc-400">검사수: <span className="font-mono text-zinc-200">{d.TOTAL_CNT.toLocaleString()}</span></p>
      <p className="text-zinc-400">불량율: <span className="font-mono text-zinc-200">{d.NG_RATE}%</span></p>
    </div>
  );
}

function RenderLabel({ x, y, width, height, value }: {
  x?: number; y?: number; width?: number; height?: number; value?: number;
}) {
  if (x == null || y == null || width == null || height == null) return null;
  return (
    <text x={x + width + 6} y={y + height / 2} fill="#a1a1aa" fontSize={10} dominantBaseline="central">
      {value}
    </text>
  );
}

interface WeeklyLineDefectChartProps {
  data: FctLineCompareRow[];
}

export default function WeeklyLineDefectChart({ data }: WeeklyLineDefectChartProps) {
  return (
    <ChartCard title="주간 라인별 불량 TOP" subtitle="최근 7일 NG 건수 기준">
      {data.length === 0 ? (
        <div className="flex h-full items-center justify-center text-sm text-zinc-500">
          데이터 없음
        </div>
      ) : (
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={data} layout="vertical" margin={{ top: 4, right: 34, left: 0, bottom: 0 }}>
            <XAxis type="number" tick={{ fill: '#a1a1aa', fontSize: 10 }} axisLine={false} tickLine={false} />
            <YAxis type="category" dataKey="LINE_NAME" width={72} tick={{ fill: '#d4d4d8', fontSize: 10 }} axisLine={false} tickLine={false} />
            <Tooltip content={<CustomTooltip />} cursor={{ fill: 'rgba(255,255,255,0.04)' }} />
            <Bar dataKey="NG_CNT" radius={[0, 4, 4, 0]} barSize={16} label={<RenderLabel />}>
              {data.map((row, idx) => (
                <Cell key={row.LINE_CODE} fill={RANK_COLORS[idx] ?? '#64748b'} fillOpacity={0.8} />
              ))}
            </Bar>
          </BarChart>
        </ResponsiveContainer>
      )}
    </ChartCard>
  );
}
