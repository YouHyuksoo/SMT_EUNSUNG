'use client';

/**
 * @file (authenticated)/oee/equip-ops-status/components/DailyMetrics.tsx
 * @description 설비 운영 현황 - 당일 지표(좌측). 가동율 파이 + 3대 지표 막대 + 비가동 시간/정지 회수
 *
 * 비가동 시간(분)과 정지 회수만 실측이다. 가동율·시간가동율·성능가동율·양품율은
 * 산식이 확정되지 않아 MOCK_METRICS 더미값을 쓴다 — 확정되면 이 상수만 교체하면 된다.
 * (docs/plans/2026-08-27-equip-ops-status.md 결정 #5·#6)
 */

import { PieChart, Pie, Cell, ResponsiveContainer } from 'recharts';
import { Card, CardContent } from '@/components/ui';

/** 산식 확정 전까지 쓰는 더미값 — 확정 시 이 블록만 실측 계산으로 교체한다 */
const MOCK_METRICS = {
  oeeRate: 78.4,       // 가동율(파이)
  timeRate: 86.2,      // 시간 가동율
  performanceRate: 91.5, // 성능 가동율
  qualityRate: 99.3,   // 양품율
};

interface Props {
  /** 실측 — 당일 비가동 누적 분 */
  downMinutes: number;
  /** 실측 — 당일 정지 회수 */
  stopCount: number;
  /** 선택된 대상 표시용 (없으면 안내) */
  scopeLabel: string | null;
}

/** 100% 기준 가로 막대 한 줄 — 단순 비율이라 차트 라이브러리를 쓰지 않는다 */
function RateBar({ label, value, color }: { label: string; value: number; color: string }) {
  return (
    <div className="space-y-1">
      <div className="flex items-baseline justify-between">
        <span className="text-xs text-text-muted">{label}</span>
        <span className="text-sm font-semibold text-text font-mono tabular-nums">{value.toFixed(1)}%</span>
      </div>
      <div className="h-2.5 w-full rounded-full bg-surface overflow-hidden">
        <div className={`h-full rounded-full ${color}`} style={{ width: `${Math.min(100, Math.max(0, value))}%` }} />
      </div>
    </div>
  );
}

export default function DailyMetrics({ downMinutes, stopCount, scopeLabel }: Props) {
  const rate = MOCK_METRICS.oeeRate;
  const pieData = [{ name: '가동', value: rate }, { name: '비가동', value: 100 - rate }];

  return (
    <Card className="h-full overflow-hidden" padding="none">
      <CardContent className="h-full p-4 overflow-y-auto space-y-4">
        <div className="flex items-baseline justify-between">
          <span className="text-sm font-semibold text-text">당일 지표</span>
          <span className="text-[11px] text-text-muted truncate max-w-[60%]">{scopeLabel ?? '대상 미선택'}</span>
        </div>

        {/* 가동율 도넛 */}
        <div className="relative h-40">
          <ResponsiveContainer width="100%" height="100%">
            <PieChart>
              <Pie data={pieData} dataKey="value" innerRadius="66%" outerRadius="92%" startAngle={90} endAngle={-270} stroke="none">
                <Cell fill="var(--color-primary, #3b82f6)" />
                <Cell fill="var(--color-surface, #e5e7eb)" />
              </Pie>
            </PieChart>
          </ResponsiveContainer>
          <div className="absolute inset-0 flex flex-col items-center justify-center pointer-events-none">
            <span className="text-2xl font-bold text-text font-mono tabular-nums">{rate.toFixed(1)}%</span>
            <span className="text-[11px] text-text-muted">가동율</span>
          </div>
        </div>

        {/* 3대 지표 */}
        <div className="space-y-3 border-t border-border pt-3">
          <RateBar label="시간 가동율" value={MOCK_METRICS.timeRate} color="bg-sky-500" />
          <RateBar label="성능 가동율" value={MOCK_METRICS.performanceRate} color="bg-violet-500" />
          <RateBar label="양품율" value={MOCK_METRICS.qualityRate} color="bg-emerald-500" />
          <p className="text-[11px] text-text-muted">가동율과 위 3개 지표는 산식 확정 전 예시값입니다.</p>
        </div>

        {/* 실측 2종 */}
        <div className="grid grid-cols-2 gap-2 border-t border-border pt-3">
          <div className="rounded border border-border p-3 text-center">
            <div className="text-[11px] text-text-muted">당일 비가동</div>
            <div className="text-xl font-bold text-red-500 font-mono tabular-nums">{downMinutes.toLocaleString()}</div>
            <div className="text-[11px] text-text-muted">분</div>
          </div>
          <div className="rounded border border-border p-3 text-center">
            <div className="text-[11px] text-text-muted">당일 정지</div>
            <div className="text-xl font-bold text-text font-mono tabular-nums">{stopCount.toLocaleString()}</div>
            <div className="text-[11px] text-text-muted">회</div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
