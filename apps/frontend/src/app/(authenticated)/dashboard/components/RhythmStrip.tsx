"use client";

/**
 * @file src/app/(authenticated)/dashboard/components/RhythmStrip.tsx
 * @description 오늘의 리듬 — 시간대별(0~23시) 실적 스카이라인 + 최근 7일 계획 대비 달성률 스파크라인.
 *              현재 시각 열은 밑줄 마커로 표시한다. 차트 라이브러리 없이 div/SVG 로 그린다.
 *
 * 초보자 가이드:
 * - Skyline  : GET /monitoring/boards/production 의 hourly (양품/불량). 은성은 24시간 가동일 수 있어 0~23시 전부 그린다.
 * - TrendSpark: GET /dashboard/insights 의 trend 7일 — SMD/제품 달성률(실적/계획). 계획 0 인 날은 선을 끊는다(0% 로 그리지 않음).
 */
import { useMemo } from "react";
import { useTranslation } from "react-i18next";
import type { DashboardData } from "./types";
import { achieveRate } from "./stageViews";

const HOURS = Array.from({ length: 24 }, (_, i) => i);

export function Skyline({ data, nowHour }: { data: DashboardData; nowHour: number | null }) {
  const { t } = useTranslation();
  const hourly = data.production?.hourly;

  const cols = useMemo(() => {
    const map = new Map((hourly ?? []).map((h) => [Number(h.hour), h]));
    const max = Math.max(1, ...HOURS.map((h) => (map.get(h)?.goodQty ?? 0) + (map.get(h)?.defectQty ?? 0)));
    return HOURS.map((h) => {
      const p = map.get(h);
      const good = p?.goodQty ?? 0;
      const defect = p?.defectQty ?? 0;
      return { hour: h, good, defect, goodPct: (good / max) * 100, defectPct: (defect / max) * 100 };
    });
  }, [hourly]);

  const hasAny = cols.some((c) => c.good + c.defect > 0);

  return (
    <div className="flex-1 min-w-0 flex flex-col">
      <div className="flex items-baseline justify-between">
        <span className="text-[11px] font-semibold uppercase tracking-[0.18em] text-text-muted">{t("dashboard.rhythm.hourly")}</span>
        <span className="text-[11px] text-text-muted flex items-center gap-3">
          <span className="flex items-center gap-1"><i className="inline-block w-2 h-2 bg-primary" />{t("dashboard.rhythm.good")}</span>
          <span className="flex items-center gap-1"><i className="inline-block w-2 h-2 bg-error" />{t("dashboard.rhythm.defect")}</span>
        </span>
      </div>
      <div className="relative flex-1 min-h-[72px] mt-2 flex items-end gap-[3px] border-b border-border">
        {!hasAny && (
          <span className="absolute inset-0 flex items-center justify-center text-xs text-text-muted">{t("dashboard.rhythm.noHourly")}</span>
        )}
        {cols.map((c, i) => (
          <div key={c.hour} className="flex-1 h-full flex flex-col justify-end ds-grow" style={{ animationDelay: `${300 + i * 20}ms` }} title={`${c.hour}:00  ${c.good.toLocaleString()} / ${c.defect.toLocaleString()}`}>
            <div className="bg-error" style={{ height: `${c.defectPct}%` }} />
            <div className={`${c.hour === nowHour ? "bg-primary" : "bg-primary/60"}`} style={{ height: `${c.goodPct}%` }} />
          </div>
        ))}
      </div>
      <div className="flex gap-[3px] mt-1">
        {cols.map((c) => (
          <div key={c.hour} className={`flex-1 text-center font-mono text-[10px] leading-none ${c.hour === nowHour ? "text-primary font-bold" : "text-text-muted"}`}>
            {c.hour % 3 === 0 ? String(c.hour).padStart(2, "0") : ""}
            {c.hour === nowHour && <div className="h-[2px] bg-primary mt-1 mx-auto w-full" />}
          </div>
        ))}
      </div>
    </div>
  );
}

const W = 160;
const H = 56;

interface Series {
  key: "smd" | "product";
  stroke: string;
  fill: string;
  /** 7일 달성률(%) — 계획 없는 날은 null */
  rates: Array<number | null>;
}

export function TrendSpark({ data }: { data: DashboardData }) {
  const { t } = useTranslation();
  const trend = data.insights?.trend;

  const geo = useMemo(() => {
    if (!trend || trend.length === 0) return null;
    const series: Series[] = [
      { key: "smd", stroke: "stroke-primary", fill: "fill-primary", rates: trend.map((p) => achieveRate(p.smdActual, p.smdPlan)) },
      { key: "product", stroke: "stroke-info", fill: "fill-info", rates: trend.map((p) => achieveRate(p.miActual, p.miPlan)) },
    ];
    const all = series.flatMap((s) => s.rates).filter((r): r is number => r !== null);
    if (all.length === 0) return null;
    const max = Math.max(100, ...all);
    const step = trend.length > 1 ? W / (trend.length - 1) : 0;
    const y = (r: number) => H - (r / max) * (H - 6) - 3;
    return series.map((s) => {
      const pts = s.rates.map((r, i) => (r === null ? null : { x: i * step, y: y(r), rate: r }));
      // 계획 없는 날(null)에서 선을 끊는다
      let d = "";
      let pen = false;
      for (const p of pts) {
        if (!p) { pen = false; continue; }
        d += `${pen ? "L" : "M"}${p.x.toFixed(1)},${p.y.toFixed(1)} `;
        pen = true;
      }
      const lastIdx = pts.map((p, i) => (p ? i : -1)).filter((i) => i >= 0).pop();
      return { ...s, pts, d: d.trim(), last: lastIdx === undefined ? undefined : pts[lastIdx] };
    });
  }, [trend]);

  return (
    <div className="w-[240px] xl:w-[280px] flex-shrink-0 flex flex-col border-l border-border pl-5">
      <span className="text-[11px] font-semibold uppercase tracking-[0.18em] text-text-muted">{t("dashboard.rhythm.trendAchieve7")}</span>
      <div className="flex items-end gap-4 mt-2 flex-1">
        <div className="flex-1 min-w-0">
          {geo ? (
            <svg viewBox={`0 0 ${W} ${H}`} className="w-full h-14 overflow-visible" preserveAspectRatio="none">
              {geo.map((s) => (
                <g key={s.key}>
                  {s.d && <path d={s.d} fill="none" className={s.stroke} strokeWidth="1.5" strokeLinejoin="round" strokeLinecap="round" />}
                  {s.pts.map((p, i) => (p ? <circle key={i} cx={p.x} cy={p.y} r="1.6" className={s.fill} /> : null))}
                  {s.last && <circle cx={s.last.x} cy={s.last.y} r="3.5" className={`${s.fill} ds-blink`} />}
                </g>
              ))}
            </svg>
          ) : (
            <div className="h-14 flex items-center text-xs text-text-muted">{t("dashboard.rhythm.noTrend")}</div>
          )}
        </div>
        <div className="text-right space-y-1">
          {(geo ?? []).map((s) => (
            <div key={s.key} className="flex items-baseline justify-end gap-1.5">
              <span className="text-[10px] text-text-muted">{s.key === "smd" ? "SMD" : t("dashboard.chart.product")}</span>
              <span className={`text-lg font-extrabold tabular-nums leading-none ${s.key === "smd" ? "text-primary" : "text-info"}`}>
                {s.last ? s.last.rate.toFixed(1) : "—"}<span className="text-xs text-text-muted ml-0.5">%</span>
              </span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

export default function RhythmStrip({ data, nowHour }: { data: DashboardData; nowHour: number | null }) {
  return (
    <div className="flex-1 min-h-0 flex gap-5">
      <Skyline data={data} nowHour={nowHour} />
      <TrendSpark data={data} />
    </div>
  );
}
