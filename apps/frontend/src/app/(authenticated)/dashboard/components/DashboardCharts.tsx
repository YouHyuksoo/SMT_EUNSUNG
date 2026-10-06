"use client";

/**
 * @file src/app/(authenticated)/dashboard/components/DashboardCharts.tsx
 * @description 대시보드 시각화 카드 모음 (도넛/게이지/누적막대/추이/라인별 막대)
 *
 * 초보자 가이드:
 * 1. 색은 globals.css 의 CSS 변수(--success, --error, --warning, --info)만 쓴다 (라이트/다크 자동 대응)
 * 2. 데이터는 page.tsx 가 /dashboard/summary, /dashboard/insights 로 받아 props 로 넘긴다
 * 3. insights(7일 추이·라인별)가 없으면 해당 카드는 "데이터 없음" 으로 표시한다
 * 4. 차트 높이는 부모(고정 높이 div)가 정한다 — ResponsiveContainer 는 높이 0 이면 그려지지 않는다
 */
import { useState, type ReactNode } from "react";
import { useTranslation } from "react-i18next";
import {
  PieChart, Pie, Cell, LabelList, RadialBarChart, RadialBar, PolarAngleAxis,
  BarChart, Bar, ComposedChart, Line, XAxis, YAxis, CartesianGrid,
  Tooltip, Legend, ResponsiveContainer,
} from "recharts";
import { Button } from "@/components/ui";

/* ── Types ── */
export interface InsightsTrend {
  date: string;
  smdPlan: number;
  smdActual: number;
  miPlan: number;
  miActual: number;
}

export interface InsightsLine {
  lineCode: string;
  lineName?: string | null;
  productionType: string;
  planQty: number;
  actualQty: number;
}

export interface DashboardInsights {
  date: string;
  trend: InsightsTrend[];
  lines: InsightsLine[];
}

/* ── 공통 ── */
const C = {
  success: "var(--success)",
  error: "var(--error)",
  warning: "var(--warning)",
  info: "var(--info)",
  primary: "var(--primary)",
  muted: "var(--muted-foreground)",
  grid: "var(--border)",
};

const tooltipStyle = {
  background: "var(--card)",
  border: "1px solid var(--border)",
  borderRadius: 8,
  fontSize: 12,
  color: "var(--card-foreground)",
};

const axisTick = { fontSize: 11, fill: C.muted };

export function pct(actual: number, plan: number): number {
  return plan > 0 ? Math.round((actual / plan) * 1000) / 10 : 0;
}

function ChartCard({ title, sub, action, children, className = "" }: {
  title: string; sub?: string; action?: ReactNode; children: ReactNode; className?: string;
}) {
  return (
    <div className={`rounded-2xl border border-border bg-card p-3 flex flex-col min-w-0 ${className}`}>
      <div className="flex items-start justify-between gap-2 mb-2">
        <div className="min-w-0">
          <div className="text-xs font-semibold text-text">{title}</div>
          {sub && <div className="text-[10px] text-text-muted mt-0.5">{sub}</div>}
        </div>
        {action}
      </div>
      {children}
    </div>
  );
}

function NoData() {
  const { t } = useTranslation();
  return (
    <div className="flex h-full items-center justify-center text-xs text-text-muted">
      {t("dashboard.chart.noData")}
    </div>
  );
}

function LegendRow({ color, label, value }: { color: string; label: string; value: string }) {
  return (
    <div className="flex items-center gap-2 text-[11px]">
      <span className="inline-block h-2.5 w-2.5 rounded-sm flex-shrink-0" style={{ background: color }} />
      <span className="text-text-muted truncate">{label}</span>
      <span className="ml-auto font-semibold text-text tabular-nums">{value}</span>
    </div>
  );
}

/* ── 도넛 (설비 / 불량 공용) ── */
interface Slice { name: string; value: number; color: string }

function DonutCard({ title, sub, slices, centerValue, centerLabel, footer }: {
  title: string; sub?: string; slices: Slice[]; centerValue: string; centerLabel: string; footer?: ReactNode;
}) {
  const total = slices.reduce((s, x) => s + x.value, 0);
  const data = total > 0 ? slices.filter((s) => s.value > 0) : [{ name: "-", value: 1, color: C.grid }];
  return (
    <ChartCard title={title} sub={sub}>
      <div className="flex flex-col items-center gap-3">
        <div className="relative h-[160px] w-[160px] flex-shrink-0">
          <ResponsiveContainer width="100%" height="100%">
            <PieChart>
              <Pie data={data} dataKey="value" nameKey="name" innerRadius={52} outerRadius={76}
                paddingAngle={data.length > 1 ? 2 : 0} stroke="none" isAnimationActive={false}>
                {data.map((s) => <Cell key={s.name} fill={s.color} />)}
              </Pie>
              {total > 0 && <Tooltip contentStyle={tooltipStyle} />}
            </PieChart>
          </ResponsiveContainer>
          <div className="pointer-events-none absolute inset-0 flex flex-col items-center justify-center">
            <div className="text-lg font-bold text-text leading-tight tabular-nums">{centerValue}</div>
            <div className="text-[10px] text-text-muted">{centerLabel}</div>
          </div>
        </div>
        <div className="w-full min-w-0 flex flex-col gap-1.5">
          {slices.map((s) => (
            <LegendRow key={s.name} color={s.color} label={s.name}
              value={`${s.value.toLocaleString()} (${pct(s.value, total)}%)`} />
          ))}
          {footer}
        </div>
      </div>
    </ChartCard>
  );
}

/* ── 설비 가동률 도넛 ── */
export function EquipDonutCard({ equip }: { equip: { inUse: number; down: number; notUsed: number; total: number } }) {
  const { t } = useTranslation();
  return (
    <DonutCard
      title={t("dashboard.chart.equipTitle")}
      sub={t("dashboard.chart.equipSub")}
      slices={[
        { name: t("dashboard.equipInUse"), value: equip.inUse, color: C.success },
        { name: t("dashboard.equipDown"), value: equip.down, color: C.error },
        { name: t("dashboard.equipNotUsed"), value: equip.notUsed, color: C.muted },
      ]}
      centerValue={`${pct(equip.inUse, equip.total)}%`}
      centerLabel={t("dashboard.chart.inUseRate")}
    />
  );
}

/* ── 불량 판정 구성 도넛 ── */
export function DefectDonutCard({ defect }: {
  defect: { pending: number; genuine: number; pseudo: number; unrepaired: number };
}) {
  const { t } = useTranslation();
  const total = defect.pending + defect.genuine + defect.pseudo;
  return (
    <DonutCard
      title={t("dashboard.chart.defectTitle")}
      sub={t("dashboard.chart.defectSub")}
      slices={[
        { name: t("dashboard.defectGenuine"), value: defect.genuine, color: C.error },
        { name: t("dashboard.defectPseudo"), value: defect.pseudo, color: C.info },
        { name: t("dashboard.defectPending"), value: defect.pending, color: C.warning },
      ]}
      centerValue={total.toLocaleString()}
      centerLabel={t("dashboard.chart.total")}
      footer={
        <div className="mt-1 border-t border-border pt-1.5">
          <LegendRow color={C.error} label={t("dashboard.defectUnrepaired")}
            value={`${defect.unrepaired.toLocaleString()} (${pct(defect.unrepaired, defect.genuine)}%)`} />
        </div>
      }
    />
  );
}

/* ── 생산 달성률 게이지 (SMD / 제품 이중 링) ── */
export function ProductionGaugeCard({ production }: {
  production: { smdPlan: number; smdActual: number; miPlan: number; miActual: number };
}) {
  const { t } = useTranslation();
  const smd = pct(production.smdActual, production.smdPlan);
  const mi = pct(production.miActual, production.miPlan);
  const data = [
    { name: "SMD", value: Math.min(smd, 100), fill: C.info },
    { name: t("dashboard.chart.product"), value: Math.min(mi, 100), fill: C.success },
  ];
  return (
    <ChartCard title={t("dashboard.chart.gaugeTitle")} sub={t("dashboard.chart.gaugeSub")}>
      <div className="flex flex-col items-center gap-3">
        <div className="h-[160px] w-[160px] flex-shrink-0">
          <ResponsiveContainer width="100%" height="100%">
            <RadialBarChart data={data} innerRadius={32} outerRadius={72} startAngle={90} endAngle={-270} barSize={16}>
              <PolarAngleAxis type="number" domain={[0, 100]} tick={false} />
              <RadialBar dataKey="value" background={{ fill: C.grid }} cornerRadius={8} isAnimationActive={false} />
            </RadialBarChart>
          </ResponsiveContainer>
        </div>
        <div className="w-full min-w-0 grid grid-cols-2 gap-4">
          {[
            { label: "SMD", color: C.info, rate: smd, a: production.smdActual, p: production.smdPlan },
            { label: t("dashboard.chart.product"), color: C.success, rate: mi, a: production.miActual, p: production.miPlan },
          ].map((r) => (
            <div key={r.label}>
              <div className="flex items-center gap-2">
                <span className="inline-block h-2.5 w-2.5 rounded-sm" style={{ background: r.color }} />
                <span className="text-[11px] text-text-muted">{r.label}</span>
                <span className="ml-auto text-lg font-bold text-text tabular-nums">{r.rate}%</span>
              </div>
              <div className="text-[10px] text-text-muted tabular-nums text-right">
                {r.a.toLocaleString()} / {r.p.toLocaleString()}
              </div>
            </div>
          ))}
        </div>
      </div>
    </ChartCard>
  );
}

/* ── 솔더·MSL 정상/NG 누적 막대 ── */
export function MaterialBarCard({ material }: {
  material: { solderInUse: number; solderNg: number; mslLots: number; mslNg: number };
}) {
  const { t } = useTranslation();
  const data = [
    { name: t("dashboard.chart.solder"), ok: Math.max(material.solderInUse - material.solderNg, 0), ng: material.solderNg },
    { name: "MSL", ok: Math.max(material.mslLots - material.mslNg, 0), ng: material.mslNg },
  ];
  const empty = material.solderInUse + material.mslLots === 0;
  return (
    <ChartCard title={t("dashboard.chart.materialTitle")} sub={t("dashboard.chart.materialSub")}>
      <div className="h-[250px]">
        {empty ? <NoData /> : (
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={data} layout="vertical" margin={{ top: 8, right: 16, left: 8, bottom: 0 }}>
              <CartesianGrid horizontal={false} stroke={C.grid} strokeDasharray="3 3" />
              <XAxis type="number" allowDecimals={false} tick={axisTick} axisLine={false} tickLine={false} />
              <YAxis type="category" dataKey="name" tick={axisTick} axisLine={false} tickLine={false} width={44} />
              <Tooltip contentStyle={tooltipStyle} cursor={{ fill: "transparent" }} />
              <Legend iconType="square" wrapperStyle={{ fontSize: 11 }} />
              <Bar dataKey="ok" name={t("dashboard.chart.normal")} stackId="m" fill={C.success} barSize={22} isAnimationActive={false}>
                <LabelList dataKey="ok" position="insideRight" fill="var(--primary-foreground)" fontSize={11} />
              </Bar>
              <Bar dataKey="ng" name="NG" stackId="m" fill={C.error} barSize={22} isAnimationActive={false} />
            </BarChart>
          </ResponsiveContainer>
        )}
      </div>
    </ChartCard>
  );
}

/* ── 최근 7일 생산 추이 (실적 막대 + 계획 선) ── */
export function ProductionTrendCard({ trend }: { trend: InsightsTrend[] | null }) {
  const { t } = useTranslation();
  const [type, setType] = useState<"smd" | "mi">("smd");
  const data = (trend ?? []).map((r) => ({
    label: r.date.slice(5),
    plan: type === "smd" ? r.smdPlan : r.miPlan,
    actual: type === "smd" ? r.smdActual : r.miActual,
  }));
  const hasData = data.some((d) => d.plan > 0 || d.actual > 0);
  const toggle = (
    <div className="flex gap-1 flex-shrink-0">
      <Button size="sm" variant={type === "smd" ? "primary" : "outline"} onClick={() => setType("smd")}>SMD</Button>
      <Button size="sm" variant={type === "mi" ? "primary" : "outline"} onClick={() => setType("mi")}>
        {t("dashboard.chart.product")}
      </Button>
    </div>
  );
  return (
    <ChartCard title={t("dashboard.chart.trendTitle")} sub={t("dashboard.chart.trendSub")} action={toggle} className="lg:col-span-2">
      <div className="h-[240px]">
        {!hasData ? <NoData /> : (
          <ResponsiveContainer width="100%" height="100%">
            <ComposedChart data={data} margin={{ top: 8, right: 12, left: -4, bottom: 0 }}>
              <CartesianGrid vertical={false} stroke={C.grid} strokeDasharray="3 3" />
              <XAxis dataKey="label" tick={axisTick} axisLine={false} tickLine={false} />
              <YAxis tick={axisTick} axisLine={false} tickLine={false} tickFormatter={(v: number) => v.toLocaleString()} />
              <Tooltip contentStyle={tooltipStyle} cursor={{ fill: "transparent" }}
                formatter={(v) => (typeof v === "number" ? v.toLocaleString() : v)} />
              <Legend iconType="square" wrapperStyle={{ fontSize: 11 }} />
              <Bar dataKey="actual" name={t("dashboard.chart.actual")} fill={C.info} radius={[4, 4, 0, 0]} barSize={28} isAnimationActive={false} />
              <Line dataKey="plan" name={t("dashboard.chart.plan")} stroke={C.warning} strokeWidth={2}
                strokeDasharray="5 3" dot={{ r: 3, fill: C.warning, strokeWidth: 0 }} isAnimationActive={false} />
            </ComposedChart>
          </ResponsiveContainer>
        )}
      </div>
    </ChartCard>
  );
}

/* ── 라인별 계획 대비 실적 (가로 막대) ── */
export function LineAchievementCard({ lines }: { lines: InsightsLine[] | null }) {
  const { t } = useTranslation();
  const rows = (lines ?? []).map((l) => ({
    name: l.lineName || l.lineCode,
    plan: l.planQty,
    actual: l.actualQty,
    rate: pct(l.actualQty, l.planQty),
  }));
  const hasData = rows.some((r) => r.plan > 0 || r.actual > 0);
  const height = Math.max(240, rows.length * 44 + 40);
  return (
    <ChartCard title={t("dashboard.chart.lineTitle")} sub={t("dashboard.chart.lineSub")} className="lg:col-span-2">
      <div className="h-[240px] overflow-y-auto">
        {!hasData ? <NoData /> : (
          <div style={{ height }}>
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={rows} layout="vertical" margin={{ top: 4, right: 16, left: 8, bottom: 0 }}>
                <CartesianGrid horizontal={false} stroke={C.grid} strokeDasharray="3 3" />
                <XAxis type="number" tick={axisTick} axisLine={false} tickLine={false} tickFormatter={(v: number) => v.toLocaleString()} />
                <YAxis type="category" dataKey="name" tick={axisTick} axisLine={false} tickLine={false} width={96} />
                <Tooltip contentStyle={tooltipStyle} cursor={{ fill: "transparent" }}
                  formatter={(v) => (typeof v === "number" ? v.toLocaleString() : v)} />
                <Legend iconType="square" wrapperStyle={{ fontSize: 11 }} />
                <Bar dataKey="plan" name={t("dashboard.chart.plan")} fill={C.warning} barSize={12} radius={[0, 4, 4, 0]} isAnimationActive={false} />
                <Bar dataKey="actual" name={t("dashboard.chart.actual")} fill={C.info} barSize={12} radius={[0, 4, 4, 0]} isAnimationActive={false} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        )}
      </div>
    </ChartCard>
  );
}
