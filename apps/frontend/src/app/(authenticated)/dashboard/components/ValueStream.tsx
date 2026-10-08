"use client";

/**
 * @file src/app/(authenticated)/dashboard/components/ValueStream.tsx
 * @description 공정 흐름 리본 — 재고 → 자재(솔더·MSL) → SMD → 제품 → 품질 5단계를 좌→우 흐름선으로 잇고,
 *              단계마다 대표 숫자 1개 + 보조 지표 + 압력 게이지(12칸 LED)를 보여준다.
 *              단계 클릭 시 해당 업무 화면으로 이동한다.
 *
 * 초보자 가이드:
 * 1. "압력" = 그 단계에서 사람이 처리해야 할 예외 건수. 0 이면 게이지가 꺼진다.
 * 2. 단계별 숫자 정의는 stageViews.ts 에 있다 (FlowMap 과 같은 정의를 쓴다).
 * 3. 흐름선의 점선 애니메이션은 CSS 만 사용한다 (ds-flow keyframes 는 page.tsx 에 정의).
 */
import { useMemo } from "react";
import Link from "next/link";
import { useTranslation } from "react-i18next";
import type { AttentionItem, DashboardData } from "./types";
import { buildStageViews, isFlowing } from "./stageViews";

const GAUGE_SEGMENTS = 12;

function Gauge({ pressure }: { pressure: number }) {
  const lit = Math.min(GAUGE_SEGMENTS, pressure);
  const tone = pressure >= 6 ? "bg-error" : pressure > 0 ? "bg-warning" : "bg-success";
  return (
    <div className="flex gap-[3px] mt-3" aria-hidden>
      {Array.from({ length: GAUGE_SEGMENTS }, (_, i) => (
        <span
          key={i}
          className={`h-[5px] flex-1 rounded-[1px] transition-colors duration-500 ${i < lit ? tone : "bg-border"}`}
          style={i < lit ? { transitionDelay: `${i * 30}ms` } : undefined}
        />
      ))}
    </div>
  );
}

function FlowConnector({ active }: { active: boolean }) {
  return (
    <div className="w-8 xl:w-10 flex-shrink-0 self-center -mt-6" aria-hidden>
      <svg viewBox="0 0 40 12" className="w-full h-3 overflow-visible">
        <line x1="0" y1="6" x2="40" y2="6" className="stroke-border" strokeWidth="1" />
        {active && (
          <line x1="0" y1="6" x2="40" y2="6" className="stroke-primary ds-flow" strokeWidth="2" strokeDasharray="6 8" strokeLinecap="round" />
        )}
        <path d="M34 2 L40 6 L34 10" fill="none" className={active ? "stroke-primary" : "stroke-border"} strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
      </svg>
    </div>
  );
}

export default function ValueStream({ data, attention }: { data: DashboardData; attention: AttentionItem[] }) {
  const { t } = useTranslation();
  const stages = useMemo(() => buildStageViews(data, attention, t).filter((s) => s.line === "flow"), [data, attention, t]);
  const flowing = isFlowing(data);

  return (
    <div className="flex items-stretch">
      {stages.map((s, i) => (
        <div key={s.key} className="contents">
          {i > 0 && <FlowConnector active={flowing} />}
          <Link
            href={s.href}
            className="flex-1 min-w-0 group ds-rise"
            style={{ animationDelay: `${120 + i * 90}ms` }}
          >
            <div className="flex items-center gap-2">
              <span className="font-mono text-[11px] text-text-muted">{String(i + 1).padStart(2, "0")}</span>
              <span className="text-xs font-bold uppercase tracking-[0.16em] text-text group-hover:text-primary transition-colors">
                {t(`dashboard.stream.${s.key}`)}
              </span>
              {s.pressure > 0 && (
                <span className="ml-auto font-mono text-[11px] font-semibold text-warning border border-warning/60 rounded-sm px-1 leading-4">
                  +{s.pressure}
                </span>
              )}
            </div>
            <div className="flex items-baseline gap-1.5 mt-2">
              <span className={`text-3xl xl:text-4xl font-extrabold tabular-nums leading-none tracking-tight ${s.heroTone}`}>{s.hero}</span>
              {s.heroUnit && <span className="text-xs font-medium text-text-muted tabular-nums truncate">{s.heroUnit}</span>}
            </div>
            <div className="text-[11px] text-text-muted mt-0.5">{s.heroLabel}</div>
            <dl className="mt-3 space-y-1">
              {s.lines.map((l) => (
                <div key={l.label} className="flex items-baseline justify-between gap-2 text-xs">
                  <dt className="text-text-muted truncate">{l.label}</dt>
                  <dd className={`font-semibold tabular-nums whitespace-nowrap ${l.tone ?? "text-text"}`}>{l.value}</dd>
                </div>
              ))}
            </dl>
            <Gauge pressure={s.pressure} />
          </Link>
        </div>
      ))}
    </div>
  );
}
