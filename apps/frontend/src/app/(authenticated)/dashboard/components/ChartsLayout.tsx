"use client";

/**
 * @file src/app/(authenticated)/dashboard/components/ChartsLayout.tsx
 * @description 형태 4 "차트" — 익숙한 차트로 하루를 읽는다(recharts). 왼쪽은 스크롤, 오른쪽은 조치 필요 큐.
 *
 *   A행(수치 요약, 기존 대시보드 차트): 설비 가동률 도넛 | 생산 달성률 게이지 | 솔더·MSL 정상/NG | 불량 판정 도넛
 *   B행(기존): 최근 7일 생산 추이 | 라인별 계획 대비 실적
 *   C행(보드 API): 시간대별 실적(누적 막대) | 최근 7일 불량률(선)
 *   D행(보드 API): 공정별 불량률 | 상위 불량 유형 | 재고 조치 항목
 *
 * 초보자 가이드:
 * - A·B행은 DashboardCharts.tsx 의 카드를 그대로 쓴다(summary/insights 로 항상 값이 나온다).
 * - C·D행은 모니터링 보드 API(production/quality/inventory)가 채워지면 나온다. 비어 있으면 "데이터 없음".
 * - 색은 전부 CSS 변수(var(--primary) …)로 넘겨 스킨 A/B/C/D 를 그대로 따른다. hex 금지.
 */
import { useMemo, type ReactNode } from "react";
import { useTranslation } from "react-i18next";
import {
  Bar, BarChart, CartesianGrid, Cell, Line, LineChart, ResponsiveContainer, Tooltip, XAxis, YAxis,
} from "recharts";
import type { DashboardLayoutProps } from "./layouts";
import AttentionQueue from "./AttentionQueue";
import {
  DefectDonutCard, EquipDonutCard, LineAchievementCard, MaterialBarCard, ProductionGaugeCard, ProductionTrendCard,
} from "./DashboardCharts";
import type { DashboardSummary } from "./types";

const HOURS = Array.from({ length: 24 }, (_, i) => i);

const TOKEN = {
  primary: "var(--primary)",
  success: "var(--success)",
  warning: "var(--warning)",
  error: "var(--error)",
  info: "var(--info)",
  muted: "var(--text-muted)",
  border: "var(--border)",
} as const;

const TICK = { fontSize: 11, fill: TOKEN.muted };
const TOOLTIP_STYLE = { fontSize: 12, background: "var(--card)", border: "1px solid var(--border)", borderRadius: 4, color: "var(--text)" };
const TOOLTIP_LABEL = { color: "var(--text-muted)" };

const EMPTY_SUMMARY: DashboardSummary = {
  equip: { inUse: 0, down: 0, notUsed: 0, total: 0 },
  production: { smdPlan: 0, smdActual: 0, miPlan: 0, miActual: 0 },
  material: { solderInUse: 0, solderNg: 0, mslLots: 0, mslNg: 0 },
  defect: { pending: 0, genuine: 0, pseudo: 0, unrepaired: 0 },
};

/** 패널 — 카드 박스 대신 제목 + 괘선. 데이터가 없으면 차트 대신 안내 문구 */
function Panel({ title, legend, empty, className, children }: { title: string; legend?: ReactNode; empty: boolean; className: string; children: ReactNode }) {
  const { t } = useTranslation();
  return (
    <section className={`min-w-0 flex flex-col ${className}`}>
      <div className="flex items-center gap-3 flex-shrink-0">
        <span className="text-[11px] font-semibold uppercase tracking-[0.18em] text-text-muted whitespace-nowrap">{title}</span>
        <span className="h-px flex-1 bg-border" />
        {legend && <span className="text-[10px] text-text-muted flex items-center gap-3">{legend}</span>}
      </div>
      <div className="h-[220px] mt-2">
        {empty ? (
          <div className="h-full flex items-center justify-center text-xs text-text-muted">{t("dashboard.charts.noData")}</div>
        ) : (
          children
        )}
      </div>
    </section>
  );
}

function Swatch({ color, label }: { color: string; label: string }) {
  return (
    <span className="flex items-center gap-1">
      <i className="inline-block w-2 h-2" style={{ background: color }} />
      {label}
    </span>
  );
}

export default function ChartsLayout({ data, attention, attentionCount, nowHour }: DashboardLayoutProps) {
  const { t } = useTranslation();
  const { summary, insights, production, quality, inventory } = data;
  const s = summary ?? EMPTY_SUMMARY;

  const hourly = useMemo(() => {
    const map = new Map((production?.hourly ?? []).map((h) => [Number(h.hour), h]));
    return HOURS.map((hour) => ({
      hour: String(hour).padStart(2, "0"),
      good: map.get(hour)?.goodQty ?? 0,
      defect: map.get(hour)?.defectQty ?? 0,
      isNow: hour === nowHour,
    }));
  }, [production, nowHour]);
  const hourlyEmpty = hourly.every((h) => h.good + h.defect === 0);

  const trend = useMemo(() => (quality?.dailyTrend ?? []).map((p) => ({ date: p.date.slice(5), rate: p.defectRate, qty: p.defectQty })), [quality]);

  const byProcess = useMemo(
    () => [...(quality?.byProcess ?? [])].sort((a, b) => b.defectRate - a.defectRate).slice(0, 8).map((p) => ({ name: p.processCode, rate: p.defectRate, qty: p.defectQty })),
    [quality],
  );
  const topDefects = useMemo(() => (quality?.topDefects ?? []).slice(0, 6).map((d) => ({ name: d.defectName || d.defectCode, qty: d.qty })), [quality]);

  const inv = inventory
    ? [
        { name: t("dashboard.stream.shortage"), value: inventory.kpi.shortageCount, color: TOKEN.warning },
        { name: t("dashboard.stream.expired"), value: inventory.kpi.expiredCount, color: TOKEN.error },
        { name: t("dashboard.stream.nearExpiry"), value: inventory.kpi.nearExpiryCount, color: TOKEN.warning },
        { name: t("dashboard.stream.hold"), value: inventory.kpi.holdCount, color: TOKEN.error },
      ]
    : [];

  const pct = (v: number) => `${v.toFixed(1)}%`;

  return (
    <div className="flex-1 min-h-0 flex gap-6">
      <div className="flex-1 min-w-0 min-h-0 overflow-y-auto pr-1">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-12 gap-x-6 gap-y-5">
          {/* A: 수치 요약 (기존 차트 4개) */}
          <div className="min-w-0 lg:col-span-3"><EquipDonutCard equip={s.equip} /></div>
          <div className="min-w-0 lg:col-span-3"><ProductionGaugeCard production={s.production} /></div>
          <div className="min-w-0 lg:col-span-3"><MaterialBarCard material={s.material} /></div>
          <div className="min-w-0 lg:col-span-3"><DefectDonutCard defect={s.defect} /></div>

          {/* B: 7일 추이 / 라인별 (기존 차트 2개) */}
          <div className="min-w-0 sm:col-span-2 lg:col-span-6 flex flex-col"><ProductionTrendCard trend={insights?.trend ?? null} /></div>
          <div className="min-w-0 sm:col-span-2 lg:col-span-6 flex flex-col"><LineAchievementCard lines={insights?.lines ?? null} /></div>

          {/* C-1 시간대별 실적 */}
          <Panel
            title={t("dashboard.charts.hourly")}
            empty={hourlyEmpty}
            className="sm:col-span-2 lg:col-span-6"
            legend={<><Swatch color={TOKEN.primary} label={t("dashboard.rhythm.good")} /><Swatch color={TOKEN.error} label={t("dashboard.rhythm.defect")} /></>}
          >
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={hourly} margin={{ top: 4, right: 4, left: -18, bottom: 0 }} barCategoryGap="25%">
                <CartesianGrid vertical={false} stroke={TOKEN.border} />
                <XAxis dataKey="hour" tick={TICK} axisLine={{ stroke: TOKEN.border }} tickLine={false} interval={2} />
                <YAxis tick={TICK} axisLine={false} tickLine={false} allowDecimals={false} />
                <Tooltip contentStyle={TOOLTIP_STYLE} labelStyle={TOOLTIP_LABEL} cursor={{ fill: TOKEN.border, opacity: 0.3 }} />
                <Bar dataKey="good" name={t("dashboard.rhythm.good")} stackId="h" fill={TOKEN.primary} isAnimationActive={false}>
                  {hourly.map((h, i) => <Cell key={i} fillOpacity={h.isNow ? 1 : 0.6} />)}
                </Bar>
                <Bar dataKey="defect" name={t("dashboard.rhythm.defect")} stackId="h" fill={TOKEN.error} isAnimationActive={false} />
              </BarChart>
            </ResponsiveContainer>
          </Panel>

          {/* C-2 7일 불량률 */}
          <Panel title={t("dashboard.rhythm.trend7")} empty={trend.length === 0} className="sm:col-span-2 lg:col-span-6">
            <ResponsiveContainer width="100%" height="100%">
              <LineChart data={trend} margin={{ top: 8, right: 12, left: 0, bottom: 0 }}>
                <CartesianGrid vertical={false} stroke={TOKEN.border} />
                <XAxis dataKey="date" tick={TICK} axisLine={{ stroke: TOKEN.border }} tickLine={false} />
                <YAxis tick={TICK} axisLine={false} tickLine={false} tickFormatter={pct} width={60} />
                <Tooltip contentStyle={TOOLTIP_STYLE} labelStyle={TOOLTIP_LABEL} formatter={(v) => pct(Number(v))} />
                <Line type="monotone" dataKey="rate" name={t("dashboard.charts.rate")} stroke={TOKEN.error} strokeWidth={2} dot={{ r: 3, fill: TOKEN.error, strokeWidth: 0 }} activeDot={{ r: 5 }} isAnimationActive={false} />
              </LineChart>
            </ResponsiveContainer>
          </Panel>

          {/* D-1 공정별 불량률 */}
          <Panel title={t("dashboard.charts.byProcess")} empty={byProcess.length === 0} className="sm:col-span-2 lg:col-span-4">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={byProcess} layout="vertical" margin={{ top: 0, right: 24, left: 0, bottom: 0 }} barCategoryGap="30%">
                <CartesianGrid horizontal={false} stroke={TOKEN.border} />
                <XAxis type="number" tick={TICK} axisLine={false} tickLine={false} tickFormatter={pct} />
                <YAxis type="category" dataKey="name" tick={TICK} axisLine={false} tickLine={false} width={72} />
                <Tooltip contentStyle={TOOLTIP_STYLE} labelStyle={TOOLTIP_LABEL} formatter={(v) => pct(Number(v))} />
                <Bar dataKey="rate" name={t("dashboard.charts.rate")} isAnimationActive={false}>
                  {byProcess.map((p, i) => <Cell key={i} fill={p.rate >= 3 ? TOKEN.error : TOKEN.primary} />)}
                </Bar>
              </BarChart>
            </ResponsiveContainer>
          </Panel>

          {/* D-2 상위 불량 유형 */}
          <Panel title={t("dashboard.charts.topDefects")} empty={topDefects.length === 0} className="sm:col-span-2 lg:col-span-4">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={topDefects} layout="vertical" margin={{ top: 0, right: 24, left: 0, bottom: 0 }} barCategoryGap="30%">
                <CartesianGrid horizontal={false} stroke={TOKEN.border} />
                <XAxis type="number" tick={TICK} axisLine={false} tickLine={false} allowDecimals={false} />
                <YAxis type="category" dataKey="name" tick={TICK} axisLine={false} tickLine={false} width={96} />
                <Tooltip contentStyle={TOOLTIP_STYLE} labelStyle={TOOLTIP_LABEL} />
                <Bar dataKey="qty" name={t("dashboard.charts.qty")} fill={TOKEN.error} isAnimationActive={false} />
              </BarChart>
            </ResponsiveContainer>
          </Panel>

          {/* D-3 재고 조치 항목 */}
          <Panel title={t("dashboard.charts.inventory")} empty={inv.length === 0} className="sm:col-span-2 lg:col-span-4">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={inv} layout="vertical" margin={{ top: 0, right: 24, left: 0, bottom: 0 }} barCategoryGap="30%">
                <CartesianGrid horizontal={false} stroke={TOKEN.border} />
                <XAxis type="number" tick={TICK} axisLine={false} tickLine={false} allowDecimals={false} />
                <YAxis type="category" dataKey="name" tick={TICK} axisLine={false} tickLine={false} width={96} />
                <Tooltip contentStyle={TOOLTIP_STYLE} labelStyle={TOOLTIP_LABEL} />
                <Bar dataKey="value" name={t("dashboard.charts.qty")} isAnimationActive={false}>
                  {inv.map((row, i) => <Cell key={i} fill={row.value > 0 ? row.color : TOKEN.border} />)}
                </Bar>
              </BarChart>
            </ResponsiveContainer>
          </Panel>
        </div>
      </div>

      <aside className="w-[320px] xl:w-[380px] flex-shrink-0 min-h-0 border-l border-border pl-6">
        <AttentionQueue items={attention} total={attentionCount} />
      </aside>
    </div>
  );
}
