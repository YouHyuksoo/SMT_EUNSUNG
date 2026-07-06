'use client';

import { PieChart, Pie, Cell, ResponsiveContainer } from 'recharts';
import ChartCard from './ChartCard';
import type { FctSummaryRow } from '@/lib/queries/fct-chart';

const PIE_COLORS = ['#22c55e', '#f87171'];
const DEFECT_TARGET = 0.5;

function KpiItem({ label, value, unit }: {
  label: string; value: string; unit?: string;
}) {
  return (
    <div className="rounded-lg border border-white/5 bg-white/[0.03] px-3 py-2 text-center">
      <p className="text-xs font-medium tracking-wide text-zinc-300">{label}</p>
      <p className="mt-0.5 text-lg font-bold tabular-nums text-zinc-100">
        {value}
        {unit && <span className="ml-0.5 text-xs font-normal text-zinc-400">{unit}</span>}
      </p>
    </div>
  );
}

function CenterLabel({ defectRate }: { defectRate: number }) {
  const statusText = defectRate <= DEFECT_TARGET ? '안정' : '주의';
  const statusColor = defectRate <= DEFECT_TARGET ? '#4ade80' : '#f87171';
  return (
    <g>
      <text x="50%" y="44%" textAnchor="middle" fill={statusColor} fontSize={13} fontWeight={700}>
        {statusText}
      </text>
      <text x="50%" y="58%" textAnchor="middle" fill="#e4e4e7" fontSize={22} fontWeight={800}>
        {defectRate.toFixed(2)}%
      </text>
      <text x="50%" y="68%" textAnchor="middle" fill="#a1a1aa" fontSize={10}>
        불량율
      </text>
    </g>
  );
}

interface DefectRatePanelProps {
  summary: FctSummaryRow | null;
}

export default function DefectRatePanel({ summary }: DefectRatePanelProps) {
  const totalInspected = summary?.TOTAL_INSPECTED ?? 0;
  const totalGood = summary?.TOTAL_GOOD ?? 0;
  const totalDefects = summary?.TOTAL_DEFECTS ?? 0;
  const defectRate = summary?.DEFECT_RATE ?? 0;
  const fpyRate = summary?.FPY_RATE ?? 0;

  const pieData = [
    { name: 'Good', value: totalGood },
    { name: 'Defect', value: totalDefects },
  ];

  return (
    <ChartCard title="당일 검사 KPI" subtitle="검사수 / 양품 / 불량 / 불량율">
      {totalInspected === 0 ? (
        <div className="flex h-full items-center justify-center text-sm text-zinc-500">
          데이터 없음
        </div>
      ) : (
        <div className="flex h-full gap-3">
          <div className="flex w-1/2 items-center justify-center">
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie data={pieData} cx="50%" cy="50%" innerRadius="60%" outerRadius="82%" paddingAngle={3} dataKey="value" stroke="none" startAngle={90} endAngle={-270}>
                  {pieData.map((row, idx) => (
                    <Cell key={row.name} fill={PIE_COLORS[idx]} fillOpacity={0.85} />
                  ))}
                </Pie>
                <CenterLabel defectRate={defectRate} />
              </PieChart>
            </ResponsiveContainer>
          </div>
          <div className="grid w-1/2 grid-cols-2 content-center gap-2">
            <KpiItem label="검사수" value={totalInspected.toLocaleString()} />
            <KpiItem label="양품" value={totalGood.toLocaleString()} />
            <KpiItem label="불량" value={totalDefects.toLocaleString()} />
            <KpiItem label="FPY" value={fpyRate.toFixed(1)} unit="%" />
          </div>
        </div>
      )}
    </ChartCard>
  );
}
