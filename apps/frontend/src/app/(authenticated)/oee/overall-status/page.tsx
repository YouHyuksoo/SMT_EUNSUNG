"use client";

/**
 * @file oee/overall-status/page.tsx
 * @description OEE 종합 현황 — 관제센터형 (DESIGN A) 목업
 *
 * 초보자 가이드:
 * 1. 아직 목업이다. 수치는 _lib/mock.ts 상수이고 헤더에 목업 배지를 상시 노출한다.
 *    실제 설비코드에 가짜 수치가 붙으므로 표식이 없으면 실적으로 오해된다.
 * 2. 원안(docs/presentations/2026-07-10-inventory-oee-visual-review.html · DESIGN A)은
 *    고정 다크 팔레트지만, 여기서는 레이아웃만 가져오고 색은 프로젝트 테마 토큰을 쓴다.
 * 3. 상단 KPI 띠는 공장 종합 고정값이다 — 라인을 바꿔도 변하지 않는다.
 * 4. 라인 타일은 단일 선택이고 진입 시 첫 라인이 잡힌다. 상시 표출 화면이라 빈 상태를 두지 않는다.
 * 5. 시계만 1초마다 돈다. 탭을 벗어나면(document.hidden) 멈춘다.
 * 6. 배경은 계층으로 구분한다 — 라인은 card, 설비는 surface. 상태(가동/주의)는 테두리로만
 *    표현해 배경 구분이 상태색에 먹히지 않게 한다.
 * 7. 비가동은 예외다. 배경까지 빨강으로 덮어써서 라인·설비를 같은 모양으로 만든다.
 *    라인은 자기 상태가 아니라 소속 설비 중 정지가 하나라도 있으면 비가동으로 본다.
 */
import { useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";
import { Activity, AlertTriangle, FlaskConical } from "lucide-react";
import {
  MOCK_ALERT,
  MOCK_FACTORY_KPIS,
  MOCK_LINES,
  MOCK_MACHINES,
  type OeeMachine,
  type OeeRates,
  type TileStatus,
} from "./_lib/mock";

/** 계층별 기본 배경 — 라인과 설비를 한눈에 구분한다 */
const LINE_BG = "bg-card dark:bg-slate-800";
const MACHINE_BG = "bg-surface dark:bg-slate-900";

/** 가동/주의는 테두리로만. 배경은 계층 색을 유지한다. */
const BORDER_TONE: Record<Exclude<TileStatus, "STOP">, string> = {
  RUN: "border-emerald-500/50",
  WARN: "border-amber-500/60",
};

/** 비가동 — 라인·설비가 똑같이 쓰는 빨강. 배경까지 덮어쓴다. */
const STOP_TONE = "border-rose-500/60 bg-rose-500/10 dark:bg-rose-500/15";

function tileTone(status: TileStatus, layer: "LINE" | "MACHINE"): string {
  if (status === "STOP") return STOP_TONE;
  return `${BORDER_TONE[status]} ${layer === "LINE" ? LINE_BG : MACHINE_BG}`;
}

const BADGE_TONE: Record<TileStatus, string> = {
  RUN: "bg-emerald-500/15 text-emerald-600 dark:text-emerald-400",
  WARN: "bg-amber-500/15 text-amber-600 dark:text-amber-400",
  STOP: "bg-rose-500/15 text-rose-600 dark:text-rose-400",
};

const KPI_TONE = {
  normal: "text-primary",
  warn: "text-amber-600 dark:text-amber-400",
  bad: "text-rose-600 dark:text-rose-400",
} as const;

/** 정지 타일만 점멸. 모션 최소화 설정을 존중한다. */
const BLINK = "motion-safe:animate-pulse";

/** 라인의 표시 상태 — 소속 설비에 정지가 있으면 비가동이 이긴다 */
function lineStatusOf(lineCode: string, own: TileStatus): TileStatus {
  const hasStop = (MOCK_MACHINES[lineCode] ?? []).some((m) => m.status === "STOP");
  return hasStop ? "STOP" : own;
}

function pct(n: number) {
  return `${n.toFixed(1)}%`;
}

/** 가동율·성능율·양품율 3줄 — 라인/설비 타일이 함께 쓴다 */
function RateRows({ rates, compact }: { rates: OeeRates; compact?: boolean }) {
  const { t } = useTranslation();
  const rows: [string, number][] = [
    [t("oee.overallStatus.availability"), rates.availability],
    [t("oee.overallStatus.performance"), rates.performance],
    [t("oee.overallStatus.quality"), rates.quality],
  ];
  return (
    <div className={compact ? "flex gap-2 text-[11px]" : "mt-2 space-y-0.5"}>
      {rows.map(([label, v]) => (
        <div key={label} className={compact ? "" : "flex justify-between text-xs"}>
          <span className="text-text-muted dark:text-gray-400">{label}</span>{" "}
          <span className="font-mono font-semibold text-text dark:text-gray-100">{pct(v)}</span>
        </div>
      ))}
    </div>
  );
}

function MachineTile({ machine }: { machine: OeeMachine }) {
  const { t } = useTranslation();
  return (
    <div
      className={`rounded border p-3 ${tileTone(machine.status, "MACHINE")} ${machine.status === "STOP" ? BLINK : ""}`}
    >
      <div className="flex items-center justify-between gap-2">
        <span className="font-mono text-xs font-semibold text-text dark:text-gray-100 truncate">
          {machine.machineCode}
        </span>
        <span className={`flex-shrink-0 rounded-full px-2 py-0.5 text-[10px] ${BADGE_TONE[machine.status]}`}>
          {t(`oee.overallStatus.status.${machine.status}`)}
        </span>
      </div>
      <p className="mt-0.5 truncate text-[11px] text-text-muted dark:text-gray-400">{machine.machineName}</p>
      <RateRows rates={machine} />
      <p className="mt-2 truncate text-[10px] text-text-muted dark:text-gray-400">{machine.note}</p>
    </div>
  );
}

export default function OeeOverallStatusPage() {
  const { t } = useTranslation();
  const [selectedLine, setSelectedLine] = useState(MOCK_LINES[0]?.lineCode ?? "");
  const [now, setNow] = useState<Date | null>(null);

  // 시계는 1초마다. 탭을 벗어나면 멈춰 keep-alive 상태에서 계속 돌지 않게 한다.
  useEffect(() => {
    const tick = () => setNow(document.hidden ? null : new Date());
    tick();
    const id = setInterval(tick, 1000);
    document.addEventListener("visibilitychange", tick);
    return () => {
      clearInterval(id);
      document.removeEventListener("visibilitychange", tick);
    };
  }, []);

  const machines = useMemo(() => MOCK_MACHINES[selectedLine] ?? [], [selectedLine]);
  const selected = MOCK_LINES.find((l) => l.lineCode === selectedLine) ?? null;

  return (
    <div className="h-full overflow-y-auto p-6 animate-fade-in">
      {/* 헤더 — 목업 배지를 상시 노출한다 */}
      <div className="mb-4 flex flex-wrap items-center justify-between gap-3">
        <div className="flex items-center gap-2">
          <Activity className="h-6 w-6 text-primary" />
          <h1 className="font-mono text-sm font-bold tracking-[0.2em] text-primary">
            {t("oee.overallStatus.headline")}
          </h1>
          <span className="flex items-center gap-1 rounded border border-amber-500/60 bg-amber-500/10 px-2 py-0.5 text-[11px] font-medium text-amber-600 dark:text-amber-400">
            <FlaskConical className="h-3 w-3" />
            {t("oee.overallStatus.mockBadge")}
          </span>
        </div>
        <span className="font-mono text-xs text-text-muted dark:text-gray-400">
          {now ? now.toLocaleString() : "--"} · {t("oee.overallStatus.dayShift")}
        </span>
      </div>

      {/* 공장 종합 KPI — 라인 선택과 무관하게 고정 */}
      <div className="mb-4 grid gap-2 [grid-template-columns:repeat(auto-fit,minmax(140px,1fr))]">
        {MOCK_FACTORY_KPIS.map((k) => (
          <div
            key={k.labelKey}
            className="rounded border border-border dark:border-gray-700 bg-surface dark:bg-slate-800 p-3 text-center"
          >
            <b className={`block font-mono text-3xl font-extrabold ${KPI_TONE[k.tone]}`}>
              {k.value}
              {k.unit && <small className="text-base">{k.unit}</small>}
            </b>
            <span className="text-[11px] text-text-muted dark:text-gray-400">{t(k.labelKey)}</span>
          </div>
        ))}
      </div>

      {/* 라인 타일 — 단일 선택 */}
      <h2 className="mb-2 text-xs font-semibold text-text-muted dark:text-gray-400">
        {t("oee.overallStatus.lineSection")}
      </h2>
      <div className="mb-5 grid gap-2 [grid-template-columns:repeat(auto-fit,minmax(170px,1fr))]">
        {MOCK_LINES.map((line) => {
          const active = line.lineCode === selectedLine;
          // 소속 설비에 정지가 하나라도 있으면 라인도 비가동으로 본다.
          const status = lineStatusOf(line.lineCode, line.status);
          return (
            <button
              key={line.lineCode}
              type="button"
              onClick={() => setSelectedLine(line.lineCode)}
              aria-pressed={active}
              className={`rounded border p-3 text-left transition-colors ${tileTone(status, "LINE")}
                ${status === "STOP" ? BLINK : ""}
                ${active ? "ring-2 ring-primary" : "hover:ring-1 hover:ring-primary/60"}`}
            >
              <div className="flex items-center justify-between gap-2">
                <span className="font-mono text-xs font-semibold text-text dark:text-gray-100 truncate">
                  {line.lineName}
                </span>
                <span className={`flex-shrink-0 rounded-full px-2 py-0.5 text-[10px] ${BADGE_TONE[status]}`}>
                  {t(status === "STOP" ? "oee.overallStatus.status.LINE_STOP" : `oee.overallStatus.status.${status}`)}
                </span>
              </div>
              <b className="mt-1 block font-mono text-2xl text-text dark:text-gray-100">{pct(line.oee)}</b>
              <RateRows rates={line} compact />
              <p className="mt-1.5 truncate text-[10px] text-text-muted dark:text-gray-400">{line.note}</p>
            </button>
          );
        })}
      </div>

      {/* 선택 라인의 설비 */}
      <h2 className="mb-2 text-xs font-semibold text-text-muted dark:text-gray-400">
        {t("oee.overallStatus.machineSection", { line: selected?.lineName ?? "" })}
      </h2>
      {machines.length === 0 ? (
        <p className="rounded border border-border dark:border-gray-700 p-6 text-center text-sm text-text-muted dark:text-gray-400">
          {t("oee.overallStatus.noMachines")}
        </p>
      ) : (
        <div className="grid gap-2 [grid-template-columns:repeat(auto-fit,minmax(170px,1fr))]">
          {machines.map((m) => (
            <MachineTile key={m.machineCode} machine={m} />
          ))}
        </div>
      )}

      {/* 경보 */}
      <div className="mt-5 flex items-center gap-2 overflow-hidden rounded border border-rose-500/50 bg-rose-500/5 px-4 py-2">
        <AlertTriangle className="h-4 w-4 flex-shrink-0 text-rose-500" />
        <span className="truncate font-mono text-xs text-rose-600 dark:text-rose-400">{MOCK_ALERT}</span>
      </div>
    </div>
  );
}
