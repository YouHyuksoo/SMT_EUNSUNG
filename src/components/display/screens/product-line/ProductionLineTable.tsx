/**
 * @file ProductionLineTable.tsx
 * @description 제품생산현황 라인별 테이블. LINE_NAME/MODEL_NAME/계획/실적/달성률/NG/상태 표시.
 * 초보자 가이드: rows 배열을 받아 테이블 렌더링. 달성률은 부모에서 계산되어 전달된다.
 */
'use client';

import { getLineRateColor } from '@/components/display/shared/status-styles';
import { fmtNum } from '@/lib/display-helpers';
import type { ProductionLineRowWithRate } from './types';

interface ProductionLineTableProps {
  rows: ProductionLineRowWithRate[];
}

function fmtDate(value: string | null): string {
  if (!value) return '-';
  return value.slice(0, 10);
}

export default function ProductionLineTable({ rows }: ProductionLineTableProps) {
  if (rows.length === 0) {
    return (
      <div className="flex h-full items-center justify-center text-3xl font-bold text-zinc-500">
        데이터 없음
      </div>
    );
  }

  return (
    <div className="h-full overflow-hidden">
      <table className="h-full w-full table-fixed border-collapse text-[clamp(1.25rem,1.45vw,1.875rem)]">
        <thead className="sticky top-0 z-10 bg-zinc-900">
          <tr className="border-b border-zinc-700 text-[clamp(1rem,1.12vw,1.5rem)] text-zinc-400">
            <th className="w-[11%] whitespace-nowrap px-3 py-2 text-left">라인</th>
            <th className="w-[14%] whitespace-nowrap px-3 py-2 text-left">계획일자</th>
            <th className="w-[37%] whitespace-nowrap px-3 py-2 text-left">모델</th>
            <th className="w-[12%] whitespace-nowrap px-3 py-2 text-right">계획</th>
            <th className="w-[12%] whitespace-nowrap px-3 py-2 text-right">실적</th>
            <th className="w-[14%] whitespace-nowrap px-3 py-2 text-right">달성률</th>
          </tr>
        </thead>
        <tbody className="[&_tr:last-child]:border-b-0">
          {rows.map((row) => {
            const rateStyle = getLineRateColor(row.achieveRate);
            return (
              <tr
                key={row.LINE_CODE}
                className="border-b border-zinc-800"
              >
                <td className="truncate whitespace-nowrap px-3 py-2 font-bold text-zinc-100">{row.LINE_NAME}</td>
                <td className="whitespace-nowrap px-3 py-2 font-bold text-zinc-300">{fmtDate(row.RUN_DATE)}</td>
                <td className="min-w-0 truncate whitespace-nowrap px-3 py-2 font-bold text-zinc-200" title={row.MODEL_NAME ?? '-'}>
                  {row.MODEL_NAME ?? '-'}
                </td>
                <td className="whitespace-nowrap px-3 py-2 text-right font-bold text-zinc-200">{fmtNum(row.RUNNING_LOT_PLAN_QTY)}</td>
                <td className="whitespace-nowrap px-3 py-2 text-right font-bold text-zinc-100">{fmtNum(row.RUNNING_LOT_ACTUAL_QTY)}</td>
                <td className={`whitespace-nowrap px-3 py-2 text-right font-bold ${rateStyle.text}`}>
                  {row.achieveRate.toFixed(1)}%
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
