/**
 * @file ProductionLineChart.tsx
 * @description 라인별 달성률 수평 바 차트. 외부 라이브러리 없이 CSS로 구현.
 * 초보자 가이드: rows 배열에서 라인명과 달성률(%)을 받아 수평 바로 시각화한다.
 * 바 색상은 달성률 구간(< 30 빨강 / < 70 노랑 / >= 70 초록)에 따라 결정된다.
 */
'use client';

import { getLineRateColor } from '@/components/display/shared/status-styles';
import type { ProductionLineRowWithRate } from './types';

interface ProductionLineChartProps {
  rows: ProductionLineRowWithRate[];
}

export default function ProductionLineChart({ rows }: ProductionLineChartProps) {
  if (rows.length === 0) {
    return (
      <div className="flex h-full items-center justify-center text-3xl font-bold text-zinc-500">
        차트 데이터 없음
      </div>
    );
  }

  return (
    <div className="flex h-full flex-col gap-4 overflow-auto px-5 py-4">
      {rows.map((row) => {
        const rateStyle = getLineRateColor(row.achieveRate);
        const barWidth = Math.min(row.achieveRate, 100);
        return (
          <div key={row.LINE_CODE} className="flex flex-col gap-2 border-b border-zinc-800 pb-3">
            <div className="flex items-center justify-between gap-4">
              <span className="truncate text-3xl font-black text-zinc-100">{row.LINE_NAME}</span>
              <span className={`shrink-0 text-4xl font-black ${rateStyle.text}`}>
                {row.achieveRate.toFixed(1)}%
              </span>
            </div>
            <div className="h-2 w-full overflow-hidden rounded-full border border-zinc-700">
              <div
                className={`h-full rounded-full transition-all duration-500 ${rateStyle.bar}`}
                style={{ width: `${barWidth}%` }}
              />
            </div>
          </div>
        );
      })}
    </div>
  );
}
