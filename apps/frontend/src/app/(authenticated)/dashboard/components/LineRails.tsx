"use client";

/**
 * @file src/app/(authenticated)/dashboard/components/LineRails.tsx
 * @description 라인별 계획 대비 실적 레일 — 라인 1개 = 한 줄. 20칸 중 달성률만큼 채운다.
 *              (HANES 의 점검 레일 자리 — 은성은 점검 데이터가 없어 GET /dashboard/insights 의 lines 로 대체)
 *
 * 초보자 가이드:
 * - 데이터: insights.lines [{lineCode, lineName, productionType 'SMD'|'MI', planQty, actualQty}] (오늘 기준)
 * - 계획이 0 인 라인은 달성률을 만들지 않고 빈 레일 + "계획 없음" 으로 보여준다 (근거 없는 0% 방지).
 * - 달성 100% 이상이면 success, 그 외는 primary. 줄을 누르면 생산현황 대시보드로 이동한다.
 */
import Link from "next/link";
import { useTranslation } from "react-i18next";
import type { InsightsLine } from "./types";
import { achieveRate } from "./stageViews";

const RAIL_CELLS = 20;

function Rail({ line, delay }: { line: InsightsLine; delay: number }) {
  const { t } = useTranslation();
  const rate = achieveRate(line.actualQty, line.planQty);
  const lit = rate === null ? 0 : Math.round((Math.min(100, rate) / 100) * RAIL_CELLS);
  const tone = rate !== null && rate >= 100 ? "bg-success" : "bg-primary";
  const type = line.productionType === "SMD" ? "SMD" : t("dashboard.chart.product");

  return (
    <Link href="/tracking/line-dashboard" className="grid grid-cols-[minmax(96px,160px)_1fr_auto] items-center gap-4 py-1.5 group ds-rise" style={{ animationDelay: `${delay}ms` }}>
      <span className="flex items-baseline gap-2 min-w-0">
        <span className="text-xs font-semibold text-text group-hover:text-primary transition-colors truncate">{line.lineName || line.lineCode}</span>
        <span className="font-mono text-[10px] text-text-muted flex-shrink-0">{type}</span>
      </span>
      <div className="flex gap-[2px] h-2.5" aria-hidden>
        {Array.from({ length: RAIL_CELLS }, (_, i) => (
          <span key={i} className={`flex-1 rounded-[1px] ${i < lit ? tone : "bg-border"}`} />
        ))}
      </div>
      <span className="font-mono text-[11px] tabular-nums text-text-muted whitespace-nowrap">
        <b className="text-text">{line.actualQty.toLocaleString()}</b> / {line.planQty.toLocaleString()}
        <span className="ml-2 inline-block w-14 text-right">{rate === null ? t("dashboard.lineRails.noPlan") : `${rate.toFixed(1)}%`}</span>
      </span>
    </Link>
  );
}

export default function LineRails({ lines }: { lines: InsightsLine[] | null }) {
  const { t } = useTranslation();
  const rows = lines ?? [];
  return (
    <div>
      <div className="flex items-center gap-3">
        <span className="text-[11px] font-semibold uppercase tracking-[0.18em] text-text-muted whitespace-nowrap">{t("dashboard.lineRails.title")}</span>
        <span className="h-px flex-1 bg-border" />
        <span className="text-[10px] text-text-muted flex items-center gap-2">
          <span className="flex items-center gap-1"><i className="inline-block w-2 h-2 bg-primary" />{t("dashboard.chart.actual")}</span>
          <span className="flex items-center gap-1"><i className="inline-block w-2 h-2 bg-success" />{t("dashboard.lineRails.done")}</span>
          <span className="flex items-center gap-1"><i className="inline-block w-2 h-2 bg-border" />{t("dashboard.lineRails.remaining")}</span>
        </span>
      </div>
      {rows.length === 0 ? (
        <div className="py-3 text-[11px] text-text-muted">{t("dashboard.lineRails.noTarget")}</div>
      ) : (
        <div className="mt-1 divide-y divide-border/60">
          {rows.map((l, i) => (
            <Rail key={`${l.productionType}-${l.lineCode}`} line={l} delay={400 + Math.min(i, 8) * 60} />
          ))}
        </div>
      )}
    </div>
  );
}
