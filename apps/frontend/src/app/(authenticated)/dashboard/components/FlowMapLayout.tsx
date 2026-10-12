"use client";

/**
 * @file src/app/(authenticated)/dashboard/components/FlowMapLayout.tsx
 * @description 형태 3 "노선도" — 지하철 노선도처럼 공장을 읽는다.
 *
 *   공정 라인(위)  : 재고 ─ 자재(솔더·MSL) ─ SMD ─ 제품 ─ 품질. 역마다 대표 숫자, 압력(조치 건수)만큼 링이 켜진다.
 *   설비 라인(아래): 사용중 ─ 비가동 ─ 미사용. SMD 역에서 환승(세로 연결)한다.
 *   역을 누르면 아래 왼쪽에 그 역의 지표, 오른쪽에 그 역의 조치 항목만(드릴다운 포함) 보인다.
 *   아무 역도 안 고르면 전체 조치 큐와 모든 역의 지표가 보인다. 다시 누르면 해제.
 *
 * 좌표는 viewBox(1000×288) 기준이라 화면 폭에 맞춰 통째로 늘어난다(글자도 함께).
 * 역 숫자 정의는 stageViews.ts (공정 흐름 리본과 같은 정의).
 */
import { useMemo, useState } from "react";
import Link from "next/link";
import { useTranslation } from "react-i18next";
import type { DashboardLayoutProps } from "./layouts";
import { EQUIP_STAGES, FLOW_STAGES, isFlowStation, pressureTone, stationOf, type Station } from "./attentionStage";
import { buildStageViews, isFlowing, type StageView } from "./stageViews";
import { Skyline } from "./RhythmStrip";
import AttentionQueue from "./AttentionQueue";

const FLOW_Y = 78;
const EQUIP_Y = 200;
const FLOW_X: Record<string, number> = { stock: 100, material: 300, smd: 500, product: 700, quality: 900 };
const EQUIP_X: Record<string, number> = { inUse: 300, down: 500, notUsed: 700 };

type Tone = "success" | "warning" | "error";
const STROKE: Record<Tone, string> = { success: "stroke-success", warning: "stroke-warning", error: "stroke-error" };
const FILL: Record<Tone, string> = { success: "fill-success", warning: "fill-warning", error: "fill-error" };
const TEXT: Record<Tone, string> = { success: "text-success", warning: "text-warning", error: "text-error" };

const STATION_ORDER: readonly Station[] = [...FLOW_STAGES, ...EQUIP_STAGES];

function heroText(s: StageView) {
  return s.heroUnit ? `${s.hero} ${s.heroUnit}` : s.hero;
}

/** 역 하나의 지표 목록 (대표 숫자 + 보조 지표) */
function StationMetrics({ view, name }: { view: StageView; name?: string }) {
  return (
    <div className="min-w-0">
      {name && <div className="text-[11px] font-semibold uppercase tracking-[0.16em] text-text-muted mb-1">{name}</div>}
      <dl className="space-y-1">
        <div className="flex items-baseline justify-between gap-2 text-xs">
          <dt className="text-text-muted truncate">{view.heroLabel}</dt>
          <dd className={`font-bold tabular-nums whitespace-nowrap ${view.heroTone}`}>{heroText(view)}</dd>
        </div>
        {view.lines.map((l) => (
          <div key={l.label} className="flex items-baseline justify-between gap-2 text-xs">
            <dt className="text-text-muted truncate">{l.label}</dt>
            <dd className={`font-semibold tabular-nums whitespace-nowrap ${l.tone ?? "text-text"}`}>{l.value}</dd>
          </div>
        ))}
      </dl>
    </div>
  );
}

export default function FlowMapLayout({ data, attention, attentionCount, nowHour }: DashboardLayoutProps) {
  const { t } = useTranslation();
  const [selected, setSelected] = useState<Station | null>(null);
  const running = isFlowing(data);

  const views = useMemo(() => buildStageViews(data, attention, t), [data, attention, t]);
  const byKey = useMemo(() => new Map(views.map((v) => [v.key, v])), [views]);

  const stationName = (id: Station) => (isFlowStation(id) ? t(`dashboard.stream.${id}`) : t(`dashboard.equip${id.charAt(0).toUpperCase()}${id.slice(1)}`));
  const toggle = (id: Station) => setSelected((prev) => (prev === id ? null : id));

  const visible = useMemo(() => (selected ? attention.filter((a) => stationOf(a) === selected) : attention), [attention, selected]);
  const visibleCount = selected ? visible.reduce((n, a) => n + a.count, 0) : attentionCount;
  const current = selected ? byKey.get(selected) ?? null : null;

  return (
    <div className="flex-1 min-h-0 flex flex-col gap-4">
      {/* 노선도 */}
      <div className="flex-shrink-0">
        <div className="flex items-center gap-3 mb-1">
          <span className="text-[11px] font-semibold uppercase tracking-[0.18em] text-text-muted whitespace-nowrap">{t("dashboard.layout.map")}</span>
          <span className="h-px flex-1 bg-border" />
          <span className="text-[10px] text-text-muted">{t("dashboard.map.hint")}</span>
        </div>
        <svg viewBox="0 -18 1000 288" className="w-full h-[240px] xl:h-[280px] overflow-visible select-none" role="group" aria-label={t("dashboard.layout.map")}>
          {/* 라인 */}
          <line x1={FLOW_X.stock} y1={FLOW_Y} x2={FLOW_X.quality} y2={FLOW_Y} className="stroke-border" strokeWidth="10" strokeLinecap="round" />
          {running && <line x1={FLOW_X.stock} y1={FLOW_Y} x2={FLOW_X.quality} y2={FLOW_Y} className="stroke-primary ds-flow" strokeWidth="3" strokeDasharray="10 18" strokeLinecap="round" />}
          <line x1={EQUIP_X.inUse} y1={EQUIP_Y} x2={EQUIP_X.notUsed} y2={EQUIP_Y} className="stroke-border" strokeWidth="10" strokeLinecap="round" />
          <line x1={FLOW_X.smd} y1={FLOW_Y} x2={EQUIP_X.down} y2={EQUIP_Y} className="stroke-border" strokeWidth="6" strokeDasharray="2 8" strokeLinecap="round" />
          <text x={FLOW_X.stock - 60} y={FLOW_Y + 4} className="fill-text-muted" fontSize="11" fontWeight="600" textAnchor="end" letterSpacing="2">{t("dashboard.map.flowLine")}</text>
          <text x={EQUIP_X.inUse - 60} y={EQUIP_Y + 4} className="fill-text-muted" fontSize="11" fontWeight="600" textAnchor="end" letterSpacing="2">{t("dashboard.map.equipLine")}</text>

          {/* 역 */}
          {STATION_ORDER.map((id, i) => {
            const s = byKey.get(id);
            if (!s) return null;
            const flow = s.line === "flow";
            const x = flow ? FLOW_X[id] : EQUIP_X[id];
            const y = flow ? FLOW_Y : EQUIP_Y;
            const tone = pressureTone(s.pressure);
            const isSel = id === selected;
            const dir = flow ? -1 : 1;
            const shift = flow ? 0 : 2;
            return (
              <g
                key={id}
                role="button"
                tabIndex={0}
                aria-pressed={isSel}
                aria-label={stationName(id)}
                className="cursor-pointer ds-rise focus:outline-none"
                style={{ animationDelay: `${i * 60}ms` }}
                onClick={() => toggle(id)}
                onKeyDown={(e) => { if (e.key === "Enter" || e.key === " ") { e.preventDefault(); toggle(id); } }}
              >
                {/* 압력 링 — 조치가 있을 때만 켜지고, 선택되면 primary 로 */}
                {(s.pressure > 0 || isSel) && (
                  <circle
                    cx={x} cy={y} r={28} fill="none"
                    className={isSel ? "stroke-primary" : `${STROKE[tone]} ${tone === "error" ? "ds-blink" : ""}`}
                    strokeWidth={isSel ? 3 : 2}
                    strokeDasharray={isSel ? undefined : "4 4"}
                  />
                )}
                <circle cx={x} cy={y} r={16} className={`fill-background ${isSel ? "stroke-primary" : STROKE[tone]}`} strokeWidth="5" />
                {s.pressure > 0 && (
                  <text x={x} y={y + 4} textAnchor="middle" fontSize="12" fontWeight="800" className={isSel ? "fill-primary" : FILL[tone]}>{s.pressure}</text>
                )}
                {/* 역명 */}
                <text x={x} y={y + dir * 40} textAnchor="middle" fontSize="15" fontWeight="800" letterSpacing="1" className={isSel ? "fill-primary" : "fill-text"}>{stationName(id)}</text>
                {/* 대표 숫자 */}
                <text x={x} y={y + dir * 60 + shift} textAnchor="middle" fontSize="13" fontWeight="700" className="fill-text" style={{ fontVariantNumeric: "tabular-nums" }}>{heroText(s)}</text>
                <text x={x} y={y + dir * 76 + shift} textAnchor="middle" fontSize="10" className="fill-text-muted">{s.heroLabel}</text>
              </g>
            );
          })}
        </svg>
      </div>

      {/* 아래: 역 정보 + 그 역의 조치 */}
      <div className="flex-1 min-h-0 flex gap-6">
        <div className="flex-1 min-w-0 min-h-0 flex flex-col gap-4">
          <div className="flex items-baseline gap-3 border-b border-border pb-2 flex-shrink-0">
            <span className="text-[11px] font-semibold uppercase tracking-[0.18em] text-text-muted">{t("dashboard.map.station")}</span>
            <span className={`text-2xl font-extrabold tracking-tight ${current ? "text-primary" : "text-text"}`}>{selected ? stationName(selected) : t("dashboard.map.all")}</span>
            {current && (
              <span className={`ml-auto font-mono text-sm font-bold tabular-nums ${TEXT[pressureTone(current.pressure)]}`}>
                {t("dashboard.map.pressure")} {current.pressure}
              </span>
            )}
            {current && (
              <Link href={current.href} className="font-mono text-xs font-semibold text-primary hover:underline">
                {t("dashboard.attention.open")}
              </Link>
            )}
          </div>

          {/* 지표: 선택한 역의 숫자, 안 골랐으면 모든 역의 숫자 */}
          <div className="flex-1 min-h-0 overflow-y-auto">
            {current ? (
              <div className="max-w-sm"><StationMetrics view={current} /></div>
            ) : (
              <div className="grid grid-cols-[repeat(auto-fill,minmax(200px,1fr))] gap-x-8 gap-y-4">
                {STATION_ORDER.map((id) => {
                  const v = byKey.get(id);
                  return v ? <StationMetrics key={id} view={v} name={stationName(id)} /> : null;
                })}
              </div>
            )}
          </div>

          <div className="flex-shrink-0 h-[110px] flex">
            <Skyline data={data} nowHour={nowHour} />
          </div>
        </div>
        <aside className="w-[320px] xl:w-[380px] flex-shrink-0 min-h-0 border-l border-border pl-6">
          <AttentionQueue items={visible} total={visibleCount} />
        </aside>
      </div>
    </div>
  );
}
