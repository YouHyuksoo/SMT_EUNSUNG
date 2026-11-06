'use client';

/**
 * @file (authenticated)/oee/equip-ops-status/components/DailyMetrics.tsx
 * @description 설비 운영 현황 - 당일 지표(좌측). 종합 가동율 파이 + 3대 지표 막대 + 비가동 시간/정지 회수
 *
 * 값은 모두 GET /oee/equip-ops/summary 가 업무일 기준으로 계산한다 (산식은 equip-ops.service.ts summary).
 * 계산할 수 없는 지표는 '-' 와 사유를 보여준다. 종합은 3개 지표가 모두 있을 때만 나온다.
 */

import { PieChart, Pie, Cell, ResponsiveContainer } from 'recharts';
import { Card, CardContent } from '@/components/ui';
import type { DailySummary } from '../types';

interface Props {
  summary: DailySummary;
  /** 선택된 대상 표시용 (없으면 안내) */
  scopeLabel: string | null;
}

const pct = (v: number) => v * 100;

/** 100% 기준 가로 막대 한 줄 — 단순 비율이라 차트 라이브러리를 쓰지 않는다 */
function RateBar({ label, value, reason, detail, color }: {
  label: string; value: number | null; reason: string | null; detail?: string; color: string;
}) {
  return (
    <div className="space-y-1">
      <div className="flex items-baseline justify-between gap-2">
        <span className="text-xs text-text-muted">{label}</span>
        <span className="text-sm font-semibold text-text font-mono tabular-nums">
          {value == null ? '-' : `${pct(value).toFixed(1)}%`}
        </span>
      </div>
      <div className="h-2.5 w-full rounded-full bg-surface overflow-hidden">
        {value != null && (
          <div className={`h-full rounded-full ${color}`} style={{ width: `${Math.min(100, Math.max(0, pct(value)))}%` }} />
        )}
      </div>
      {(value == null ? reason : detail) && (
        <div className="text-[11px] text-text-muted">{value == null ? reason : detail}</div>
      )}
    </div>
  );
}

export default function DailyMetrics({ summary, scopeLabel }: Props) {
  const s = summary;
  const rate = s.oeeRate;
  const pieData = rate == null
    ? [{ name: '비가동', value: 100 }]
    : [{ name: '가동', value: pct(rate) }, { name: '비가동', value: Math.max(0, 100 - pct(rate)) }];
  const oeeReason = [s.timeRate, s.performanceRate, s.qualityRate].some((v) => v == null)
    ? '3개 지표가 모두 있어야 계산' : null;

  return (
    <Card className="h-full overflow-hidden" padding="none">
      <CardContent className="h-full p-4 overflow-y-auto space-y-4">
        <div className="flex items-baseline justify-between">
          <span className="text-sm font-semibold text-text">당일 지표</span>
          <span className="text-[11px] text-text-muted truncate max-w-[60%]">{scopeLabel ?? '대상 미선택'}</span>
        </div>

        {/* 종합 가동율 도넛 */}
        <div className="relative h-40">
          <ResponsiveContainer width="100%" height="100%">
            <PieChart>
              <Pie data={pieData} dataKey="value" innerRadius="66%" outerRadius="92%" startAngle={90} endAngle={-270} stroke="none">
                {rate != null && <Cell fill="var(--color-primary, #3b82f6)" />}
                <Cell fill="var(--color-surface, #e5e7eb)" />
              </Pie>
            </PieChart>
          </ResponsiveContainer>
          <div className="absolute inset-0 flex flex-col items-center justify-center pointer-events-none">
            <span className="text-2xl font-bold text-text font-mono tabular-nums">{rate == null ? '-' : `${pct(rate).toFixed(1)}%`}</span>
            <span className="text-[11px] text-text-muted">가동율</span>
            {scopeLabel && oeeReason && <span className="text-[10px] text-text-muted">{oeeReason}</span>}
          </div>
        </div>

        {/* 3대 지표 */}
        <div className="space-y-3 border-t border-border pt-3">
          <RateBar label="시간 가동율" value={s.timeRate} reason={scopeLabel ? s.reasons.timeRate : null}
            detail={`부하 ${s.loadMinutes.toLocaleString()}분 중 비가동 ${s.lossMinutes.toLocaleString()}분 (계획 ${s.planMinutes}분 × ${s.machineCount}대)`}
            color="bg-sky-500" />
          <RateBar label="성능 가동율" value={s.performanceRate} reason={scopeLabel ? s.reasons.performanceRate : null}
            color="bg-violet-500" />
          <RateBar label="양품율" value={s.qualityRate} reason={scopeLabel ? s.reasons.qualityRate : null}
            detail={`양품 ${s.goodQty.toLocaleString()} · 불량 ${s.defectQty.toLocaleString()} (라인 기준)`}
            color="bg-emerald-500" />
        </div>

        {/* 실측 2종 */}
        <div className="grid grid-cols-2 gap-2 border-t border-border pt-3">
          <div className="rounded border border-border px-3 py-2 text-center">
            <div className="text-[11px] text-text-muted">당일 비가동</div>
            <div className="text-xl font-bold text-red-500 font-mono tabular-nums">{s.downMinutes.toLocaleString()}</div>
            <div className="text-[11px] text-text-muted">분</div>
          </div>
          <div className="rounded border border-border px-3 py-2 text-center">
            <div className="text-[11px] text-text-muted">당일 정지</div>
            <div className="text-xl font-bold text-text font-mono tabular-nums">{s.stopCount.toLocaleString()}</div>
            <div className="text-[11px] text-text-muted">회</div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
