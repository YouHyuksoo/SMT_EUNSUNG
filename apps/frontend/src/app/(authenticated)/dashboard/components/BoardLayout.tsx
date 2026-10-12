"use client";

/**
 * @file src/app/(authenticated)/dashboard/components/BoardLayout.tsx
 * @description 형태 2 "전광판" — 공항 출발 전광판처럼 읽는 대시보드.
 *
 *   좌측  : 초대형 숫자 6개를 세로로 쌓는다(SMD 달성률·제품 달성률·설비 가동·솔더/MSL NG·불량 판정대기·조치필요).
 *   중앙  : 오늘 생산 계획 전광판 — 진행중이 맨 위, 한 줄 = 계획 행 하나, 진행 레일 20칸.
 *           계획 행(보드 API)이 비어 있으면 라인별 계획/실적(insights.lines)으로 같은 형식을 그린다.
 *           ROWS_PER_PAGE 를 넘으면 ROLL_MS 마다 다음 페이지로 자동 순환한다(보이는 탭에서만).
 *   하단  : 시간대별 실적 스카이라인.  우측 : 조치 필요 큐(드릴다운 그대로).
 */
import { useMemo, useState } from "react";
import { useTranslation } from "react-i18next";
import { useActiveInterval } from "@/hooks/useTabActive";
import type { DashboardLayoutProps } from "./layouts";
import type { DashboardData } from "./types";
import { DASH, achieveRate, rateText } from "./stageViews";
import { Skyline } from "./RhythmStrip";
import AttentionQueue from "./AttentionQueue";

const ROWS_PER_PAGE = 10;
const ROLL_MS = 8_000;
const RAIL_CELLS = 20;

/** 전광판 정렬 — 지금 움직이는 것부터 */
const STATUS_ORDER: Record<string, number> = { RUNNING: 0, HOLD: 1, WAITING: 2, DONE: 3, CANCELED: 4 };
const STATUS_TONE: Record<string, string> = {
  RUNNING: "text-primary",
  HOLD: "text-warning",
  WAITING: "text-text-muted",
  DONE: "text-success",
  CANCELED: "text-text-muted",
};
const RAIL_TONE: Record<string, string> = { RUNNING: "bg-primary", HOLD: "bg-warning", DONE: "bg-success" };

interface DepartureRow {
  id: string;
  name: string;
  where: string;
  goodQty: number;
  planQty: number;
  rate: number;
  status: string;
}

/**
 * 전광판 행 만들기.
 * - 보드 API 의 오늘 계획 행이 있으면 그대로 쓴다.
 * - 없으면 insights.lines 로 만든다. 상태는 숫자에서만 유도한다:
 *   실적 ≥ 계획 > 0 → DONE, 0 < 실적 < 계획 → RUNNING, 실적 0 → WAITING (계획 0 인 라인은 제외).
 */
function buildRows(data: DashboardData, productLabel: string): { rows: DepartureRow[]; source: "orders" | "lines" } {
  const orders = data.production?.orders ?? [];
  if (orders.length > 0) {
    return {
      source: "orders",
      rows: orders.map((o) => ({
        id: o.orderNo,
        name: o.itemName ?? o.itemCode,
        where: [o.processCode, o.equipCode].filter(Boolean).join(" · ") || DASH,
        goodQty: o.goodQty,
        planQty: o.planQty,
        rate: o.achieveRate,
        status: o.status,
      })),
    };
  }
  const lines = (data.insights?.lines ?? []).filter((l) => l.planQty > 0);
  return {
    source: "lines",
    rows: lines.map((l) => {
      const rate = achieveRate(l.actualQty, l.planQty) ?? 0;
      const status = l.actualQty >= l.planQty ? "DONE" : l.actualQty > 0 ? "RUNNING" : "WAITING";
      return {
        id: l.lineCode,
        name: l.lineName || l.lineCode,
        where: l.productionType === "SMD" ? "SMD" : productLabel,
        goodQty: l.actualQty,
        planQty: l.planQty,
        rate,
        status,
      };
    }),
  };
}

function Hero({ label, value, unit, sub, tone, delay }: { label: string; value: string; unit?: string; sub?: string[]; tone: string; delay: number }) {
  return (
    <div className="py-3 border-b border-border ds-rise" style={{ animationDelay: `${delay}ms` }}>
      <div className="text-[11px] font-semibold uppercase tracking-[0.2em] text-text-muted">{label}</div>
      <div className="flex items-baseline gap-2 mt-1">
        <span className={`text-5xl 2xl:text-6xl font-extrabold tabular-nums leading-none tracking-tight ${tone}`}>{value}</span>
        {unit && <span className="text-sm text-text-muted tabular-nums">{unit}</span>}
      </div>
      {sub && sub.length > 0 && (
        <div className="mt-1 text-[11px] text-text-muted tabular-nums space-y-0.5">
          {sub.map((s) => <div key={s} className="truncate">{s}</div>)}
        </div>
      )}
    </div>
  );
}

function Rail({ rate, status }: { rate: number; status: string }) {
  const lit = Math.round((Math.min(100, Math.max(0, rate)) / 100) * RAIL_CELLS);
  const tone = RAIL_TONE[status] ?? "bg-text-muted";
  return (
    <div className="flex gap-[2px]" aria-hidden>
      {Array.from({ length: RAIL_CELLS }, (_, i) => (
        <span key={i} className={`h-2 flex-1 rounded-[1px] ${i < lit ? tone : "bg-border"}`} />
      ))}
    </div>
  );
}

function Departures({ data }: { data: DashboardData }) {
  const { t } = useTranslation();
  const { rows: allRows, source } = useMemo(() => buildRows(data, t("dashboard.chart.product")), [data, t]);
  const sorted = useMemo(
    () => [...allRows].sort((a, b) => (STATUS_ORDER[a.status] ?? 9) - (STATUS_ORDER[b.status] ?? 9)),
    [allRows],
  );
  const pageCount = Math.max(1, Math.ceil(sorted.length / ROWS_PER_PAGE));
  const [page, setPage] = useState(0);
  const safePage = Math.min(page, pageCount - 1);

  // 보이는 탭에서만 순환 — 숨겨진 탭은 타이머를 걸지 않는다
  useActiveInterval(() => setPage((p) => (p + 1) % pageCount), pageCount > 1 ? ROLL_MS : null);

  const rows = sorted.slice(safePage * ROWS_PER_PAGE, safePage * ROWS_PER_PAGE + ROWS_PER_PAGE);
  const cols = "grid grid-cols-[28px_minmax(70px,0.9fr)_minmax(90px,1.4fr)_minmax(60px,0.7fr)_minmax(90px,110px)_minmax(80px,1fr)_60px] gap-x-3 items-center";

  return (
    <div className="flex-1 min-h-0 flex flex-col">
      <div className="flex items-center gap-3">
        <span className="text-[11px] font-semibold uppercase tracking-[0.18em] text-text-muted whitespace-nowrap">
          {t(source === "orders" ? "dashboard.board.orders" : "dashboard.board.lines")}
        </span>
        <span className="h-px flex-1 bg-border" />
        <span className="font-mono text-[11px] text-text-muted tabular-nums">{t("dashboard.board.page", { page: safePage + 1, count: pageCount })}</span>
      </div>

      <div className={`${cols} mt-2 pb-1 border-b border-border text-[10px] font-semibold uppercase tracking-[0.16em] text-text-muted`}>
        <span>#</span>
        <span>{t("dashboard.board.code")}</span>
        <span>{t("dashboard.board.name")}</span>
        <span>{t("dashboard.board.where")}</span>
        <span className="text-right">{t("dashboard.board.qty")}</span>
        <span>{t("dashboard.board.progress")}</span>
        <span className="text-right">{t("dashboard.board.status")}</span>
      </div>

      {rows.length === 0 ? (
        <div className="flex-1 flex items-center justify-center text-sm text-text-muted">{t("dashboard.board.noRows")}</div>
      ) : (
        <ol key={safePage} className="flex-1 min-h-0 overflow-hidden divide-y divide-border/60">
          {rows.map((o, i) => (
            <li key={`${o.id}-${i}`} className={`${cols} py-2 font-mono text-sm ds-rise`} style={{ animationDelay: `${i * 40}ms` }}>
              <span className="text-[11px] text-text-muted tabular-nums">{String(safePage * ROWS_PER_PAGE + i + 1).padStart(2, "0")}</span>
              <span className={`font-bold tracking-wide truncate ${o.status === "RUNNING" ? "text-text" : "text-text-muted"}`}>{o.id}</span>
              <span className="font-sans text-text truncate">{o.name}</span>
              <span className="text-[11px] text-text-muted truncate">{o.where}</span>
              <span className="text-right tabular-nums whitespace-nowrap">
                <b className="text-text">{o.goodQty.toLocaleString()}</b><span className="text-text-muted"> / {o.planQty.toLocaleString()}</span>
              </span>
              <Rail rate={o.rate} status={o.status} />
              <span className={`text-right text-xs font-bold uppercase tracking-wider whitespace-nowrap ${STATUS_TONE[o.status] ?? "text-text-muted"} ${o.status === "RUNNING" ? "ds-blink" : ""}`}>
                {t(`dashboard.board.state.${o.status}`, { defaultValue: o.status })}
              </span>
            </li>
          ))}
        </ol>
      )}
    </div>
  );
}

export default function BoardLayout({ data, attention, attentionCount, nowHour }: DashboardLayoutProps) {
  const { t } = useTranslation();
  const { summary } = data;
  const prod = summary?.production;
  const equip = summary?.equip;
  const mat = summary?.material;
  const defect = summary?.defect;

  const smdRate = prod ? achieveRate(prod.smdActual, prod.smdPlan) : null;
  const miRate = prod ? achieveRate(prod.miActual, prod.miPlan) : null;
  const matNg = mat ? mat.solderNg + mat.mslNg : null;
  const qty = (a: number, p: number) => `${a.toLocaleString()} / ${p.toLocaleString()}`;

  return (
    <div className="flex-1 min-h-0 grid grid-cols-[minmax(220px,0.8fr)_minmax(0,2.6fr)_minmax(280px,1fr)] gap-6 font-mono">
      {/* 좌측: 초대형 숫자 */}
      <div className="min-h-0 overflow-y-auto border-r border-border pr-6 flex flex-col justify-start">
        <Hero
          label={t("dashboard.pulse.smdAchieve")}
          value={rateText(smdRate)}
          unit={smdRate === null ? undefined : "%"}
          sub={prod ? [qty(prod.smdActual, prod.smdPlan)] : undefined}
          tone="text-primary"
          delay={0}
        />
        <Hero
          label={t("dashboard.pulse.productAchieve")}
          value={rateText(miRate)}
          unit={miRate === null ? undefined : "%"}
          sub={prod ? [qty(prod.miActual, prod.miPlan)] : undefined}
          tone="text-primary"
          delay={60}
        />
        <Hero
          label={t("dashboard.board.equipRun")}
          value={equip ? String(equip.inUse) : DASH}
          unit={equip ? `/ ${equip.total}` : undefined}
          sub={equip ? [`${t("dashboard.equipDown")} ${equip.down} · ${t("dashboard.equipNotUsed")} ${equip.notUsed}`] : undefined}
          tone={(equip?.down ?? 0) > 0 ? "text-warning" : "text-text"}
          delay={120}
        />
        <Hero
          label={t("dashboard.board.materialNg")}
          value={matNg === null ? DASH : String(matNg)}
          unit={matNg === null ? undefined : t("dashboard.pulse.countUnit")}
          sub={mat ? [
            `${t("dashboard.solderNg")} ${mat.solderNg} · ${t("dashboard.mslNg")} ${mat.mslNg}`,
            `${t("dashboard.solderInUse")} ${mat.solderInUse} · ${t("dashboard.mslLots")} ${mat.mslLots}`,
          ] : undefined}
          tone={(matNg ?? 0) > 0 ? "text-error" : "text-text"}
          delay={180}
        />
        <Hero
          label={t("dashboard.board.defectJudge")}
          value={defect ? String(defect.pending) : DASH}
          unit={defect ? t("dashboard.pulse.countUnit") : undefined}
          sub={defect ? [`${t("dashboard.defectGenuine")} ${defect.genuine} · ${t("dashboard.defectPseudo")} ${defect.pseudo} · ${t("dashboard.defectUnrepaired")} ${defect.unrepaired}`] : undefined}
          tone={(defect?.pending ?? 0) > 0 ? "text-warning" : "text-text"}
          delay={240}
        />
        <Hero
          label={t("dashboard.pulse.attention")}
          value={String(attentionCount)}
          unit={t("dashboard.pulse.countUnit")}
          tone={attentionCount === 0 ? "text-success" : "text-warning"}
          delay={300}
        />
      </div>

      {/* 중앙: 생산 계획 전광판 + 스카이라인 */}
      <div className="min-w-0 min-h-0 flex flex-col gap-5">
        <Departures data={data} />
        <div className="flex-shrink-0 h-[150px] flex font-sans">
          <Skyline data={data} nowHour={nowHour} />
        </div>
      </div>

      {/* 우측: 조치 큐 */}
      <aside className="min-w-0 min-h-0 border-l border-border pl-6 font-sans">
        <AttentionQueue items={attention} total={attentionCount} />
      </aside>
    </div>
  );
}
