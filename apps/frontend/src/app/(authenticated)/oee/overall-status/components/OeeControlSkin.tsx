"use client";

/**
 * @file oee/overall-status/components/OeeControlSkin.tsx
 * @description OEE 종합 현황 스킨 "관제" — 모니터링 보드(설비가동 노선도·생산 관제탑)와 같은
 *              다크 전광판 팔레트·헤더·하단 띠 구조. 현장 TV 시청거리 기준으로 글자를 키웠다.
 *
 * 초보자 가이드:
 * 1. 좌: 공장 종합 OEE 초대형 숫자 + 가동/성능/양품·직행율·무작업 진행 중.
 * 2. 우: 라인 행 — 라인 OEE, 3율 막대, 소속 설비 노드. 라인이 많으면 rollingSec 마다 페이지 순환.
 *    TV 화면이라 클릭 선택을 두지 않고 라인마다 설비를 함께 펼친다.
 * 3. 하단: 경보 띠(흐르는 문구) + 갱신시각·페이지.
 * 4. 상태색: 가동=초록, 주의=호박, 정지=빨강(점멸). 라인은 소속 설비에 정지가 하나라도 있으면 정지로 본다.
 * 5. 목업 표식은 헤더에 상시 노출한다 — 실제 라인·설비 코드에 가짜 수치가 붙기 때문이다.
 */
import { useTranslation } from "react-i18next";
import { useRotation } from "@/components/monitoring";
import { formatClock } from "@/components/monitoring/BoardClock";
import type { FactoryKpi, OeeLine, OeeMachine, OeeRates, TileStatus } from "../_lib/mock";

const LINES_PER_PAGE = 4;
const SEGMENTS = 20;

/** 다크 보드 공통 팔레트 (LineMapSkin·ControlTowerSkin 과 같은 값) */
const C = {
  text: "#e6edf7",
  strong: "#f1f6ff",
  muted: "#6b7d99",
  dim: "#3d5170",
  rule: "#16233a",
  track: "#101b2e",
  accent: "#22d3ee",
};

const STATUS_COLOR: Record<TileStatus, string> = {
  RUN: "#34d399",
  WARN: "#fbbf24",
  STOP: "#ef4444",
};

const KPI_COLOR: Record<FactoryKpi["tone"], string> = {
  normal: C.strong,
  warn: STATUS_COLOR.WARN,
  bad: STATUS_COLOR.STOP,
};

export interface OeeBoardLine extends OeeLine {
  /** 소속 설비 반영 후 표시 상태 */
  displayStatus: TileStatus;
  machines: OeeMachine[];
}

export interface OeeSkinProps {
  factoryKpis: FactoryKpi[];
  lines: OeeBoardLine[];
  alert: string;
  rollingSec: number;
  paused: boolean;
  updatedAt: string;
  /** 현재 시각 — 페이지가 탭 활성 상태를 보고 넘긴다(숨김이면 null) */
  now: Date | null;
}

function machineOee(m: OeeRates) {
  return (m.availability * m.performance * m.quality) / 10000;
}

/** 3율 막대 한 줄 — 라벨 · 막대 · 값 */
function RateBar({ label, value, color }: { label: string; value: number; color: string }) {
  return (
    <div className="flex items-center gap-3">
      <span className="w-14 shrink-0 text-sm 2xl:text-base text-[#6b7d99]">{label}</span>
      <div className="flex-1 h-3 bg-[#101b2e]">
        <div className="h-full" style={{ width: `${Math.min(100, value)}%`, background: color, opacity: 0.85 }} />
      </div>
      <span className="oee-num w-16 shrink-0 text-right text-xl 2xl:text-2xl font-bold text-[#f1f6ff]">{value.toFixed(1)}</span>
    </div>
  );
}

function MachineNode({ m, dense }: { m: OeeMachine; dense: boolean }) {
  const color = STATUS_COLOR[m.status];
  const stop = m.status === "STOP";
  return (
    <div className="min-w-0 flex flex-col items-center text-center overflow-hidden">
      <span
        className={`w-5 h-5 rounded-full ${stop ? "oee-blink" : ""}`}
        style={{ background: color, boxShadow: `0 0 10px ${color}` }}
      />
      <span className={`oee-num mt-1.5 w-full font-bold text-[#f1f6ff] truncate ${dense ? "text-sm 2xl:text-lg" : "text-base 2xl:text-xl"}`} title={`${m.machineCode} ${m.machineName}`}>
        {m.machineCode}
      </span>
      <span className="oee-num w-full truncate text-2xl 2xl:text-3xl font-bold leading-none" style={{ color: stop ? color : C.strong }}>
        {stop ? "—" : machineOee(m).toFixed(1)}
      </span>
      <span className="mt-1 w-full text-sm font-semibold truncate" style={{ color }} title={m.note}>{m.note}</span>
    </div>
  );
}

export default function OeeControlSkin({ factoryKpis, lines, alert, rollingSec, paused, updatedAt, now }: OeeSkinProps) {
  const { t } = useTranslation();
  const clock = now ? formatClock(now) : null;

  const { pageItems, page, pageCount } = useRotation(lines, LINES_PER_PAGE, rollingSec, paused);

  // 첫 KPI 가 공장 종합 OEE, 이어서 가동/성능/양품, 나머지는 보조 지표다
  const [factory, ...rest] = factoryKpis;
  const factoryValue = Number(factory?.value ?? 0);
  const [rateInt, rateDec] = (factory?.value ?? "0.0").split(".");
  const litSegs = Math.round((Math.min(100, factoryValue) / 100) * SEGMENTS);
  const worst: TileStatus = lines.some((l) => l.displayStatus === "STOP")
    ? "STOP"
    : lines.some((l) => l.displayStatus === "WARN") ? "WARN" : "RUN";

  const rateLabels = {
    availability: t("oee.overallStatus.availability"),
    performance: t("oee.overallStatus.performance"),
    quality: t("oee.overallStatus.quality"),
  };
  const statusLabel = (l: OeeBoardLine) =>
    t(l.displayStatus === "STOP" && l.status !== "STOP"
      ? "oee.overallStatus.status.LINE_STOP"
      : `oee.overallStatus.status.${l.displayStatus}`);

  return (
    <div className="w-full h-full flex flex-col overflow-hidden text-[#e6edf7]"
      style={{ background: "radial-gradient(1200px 700px at 25% -10%, #0e1a2b 0%, #070b12 55%)" }}>
      <style>{`
        @keyframes oee-pulse { 0%,100% { opacity: 1; } 50% { opacity: 0.25; } }
        @keyframes oee-ticker { 0% { transform: translateX(0); } 100% { transform: translateX(-50%); } }
        .oee-num { font-family: 'Rajdhani', var(--font-sans), sans-serif; font-variant-numeric: tabular-nums; }
        .oee-blink { animation: oee-pulse 1s ease-in-out infinite; }
        .oee-ticker { animation: oee-ticker 30s linear infinite; }
        @media (prefers-reduced-motion: reduce) { .oee-blink, .oee-ticker, .oee-live { animation: none !important; } }
      `}</style>

      {/* 헤더 — 보드 공통: 상태 점 + 제목 + 영문 표식 / 우측 날짜·시계 */}
      <div className="flex items-center justify-between px-10 pt-5 pb-4 border-b border-[#16233a] flex-shrink-0">
        <div className="flex items-center gap-4 min-w-0">
          <span className="oee-live w-3.5 h-3.5 rounded-full shrink-0"
            style={{ background: STATUS_COLOR[worst], boxShadow: `0 0 14px ${STATUS_COLOR[worst]}`, animation: "oee-pulse 1.6s ease-in-out infinite" }} />
          <span className="text-3xl font-black tracking-[0.22em] text-[#f1f6ff] truncate">{t("menu.oee.overallStatus")}</span>
          <span className="oee-num text-xl font-semibold tracking-[0.3em] text-[#22d3ee] shrink-0">LIVE OEE</span>
          <span className="shrink-0 rounded border-2 border-[#fbbf24] px-3 py-0.5 text-lg font-bold text-[#fbbf24]">
            {t("oee.overallStatus.mockBadge")}
          </span>
        </div>
        <div className="flex items-baseline gap-5 shrink-0">
          <span className="text-lg tracking-[0.2em] text-[#6b7d99]">{clock?.date ?? ""}</span>
          <span className="oee-num text-5xl font-bold text-[#f1f6ff]" style={{ textShadow: "0 0 24px rgba(34,211,238,0.35)" }}>
            {clock?.hm ?? "--:--"}<span className="text-[#3d5170]">:{clock?.sec ?? "--"}</span>
          </span>
        </div>
      </div>

      {/* 본문 */}
      <div className="flex-1 flex min-h-0">
        {/* 좌: 공장 종합 */}
        <div className="w-[28%] shrink-0 flex flex-col justify-center px-8 2xl:px-10 border-r border-[#16233a]">
          <div className="text-xl font-bold tracking-[0.28em] text-[#6b7d99]">{factory ? t(factory.labelKey) : ""}</div>
          <div className="flex items-baseline">
            <span className="oee-num font-bold text-[#22d3ee] leading-[0.9] text-[9rem] 2xl:text-[14rem]"
              style={{ textShadow: "0 0 60px rgba(34,211,238,0.45)" }}>{rateInt}</span>
            <span className="oee-num text-5xl 2xl:text-6xl font-semibold text-[#22d3ee]">{rateDec ? `.${rateDec}` : ""}%</span>
          </div>
          <div className="flex gap-1 mt-4">
            {Array.from({ length: SEGMENTS }, (_, i) => (
              <div key={i} className="flex-1 h-4"
                style={i < litSegs ? { background: C.accent, boxShadow: "0 0 8px rgba(34,211,238,0.5)" } : { background: C.track }} />
            ))}
          </div>
          <div className="grid grid-cols-2 gap-x-6 gap-y-5 mt-8">
            {rest.map((k) => (
              <div key={k.labelKey} className="min-w-0">
                <div className="text-base tracking-[0.15em] text-[#6b7d99] truncate">{t(k.labelKey)}</div>
                <div className="oee-num text-4xl 2xl:text-6xl font-bold leading-none mt-1 truncate" style={{ color: KPI_COLOR[k.tone] }}>
                  {k.value}<span className="text-2xl 2xl:text-3xl text-[#6b7d99]">{k.unit}</span>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* 우: 라인 행 */}
        <div className="flex-1 min-w-0 flex flex-col px-8 2xl:px-10 py-2">
          {pageItems.map((line) => {
            const color = STATUS_COLOR[line.displayStatus];
            const stop = line.displayStatus === "STOP";
            return (
              <div key={line.lineCode} className="flex-1 min-h-0 flex items-center gap-6 2xl:gap-8 border-b border-[#16233a] last:border-b-0">
                {/* 라인 라벨 + OEE */}
                <div className="w-48 2xl:w-60 shrink-0 min-w-0">
                  <div className="flex items-center gap-2.5">
                    <span className={`w-3.5 h-3.5 rounded-full ${stop ? "oee-blink" : ""}`} style={{ background: color, boxShadow: `0 0 10px ${color}` }} />
                    <span className="text-3xl font-black text-[#f1f6ff] truncate">{line.lineName}</span>
                  </div>
                  <div className="text-lg font-semibold mt-1" style={{ color }}>{statusLabel(line)}</div>
                  <div className="oee-num text-5xl 2xl:text-6xl font-bold leading-none mt-1" style={{ color: stop ? color : C.strong }}>
                    {line.oee.toFixed(1)}<span className="text-2xl text-[#6b7d99]">%</span>
                  </div>
                </div>

                {/* 3율 막대 */}
                <div className="flex-1 min-w-[220px] max-w-[440px] space-y-2.5">
                  <RateBar label={rateLabels.availability} value={line.availability} color={color} />
                  <RateBar label={rateLabels.performance} value={line.performance} color={color} />
                  <RateBar label={rateLabels.quality} value={line.quality} color={color} />
                </div>

                {/* 소속 설비 */}
                <div className="flex-[1.3] min-w-0 grid grid-flow-col auto-cols-[minmax(0,1fr)] gap-3 overflow-hidden">
                  {line.machines.length === 0 ? (
                    <span className="text-xl text-[#3d5170]">{t("oee.overallStatus.noMachines")}</span>
                  ) : (
                    line.machines.map((m) => <MachineNode key={m.machineCode} m={m} dense={line.machines.length > 3} />)
                  )}
                </div>
              </div>
            );
          })}
          {/* 마지막 페이지가 덜 차도 행 높이를 유지한다 */}
          {Array.from({ length: Math.max(0, LINES_PER_PAGE - pageItems.length) }, (_, i) => (
            <div key={`pad-${i}`} className="flex-1 min-h-0" />
          ))}
        </div>
      </div>

      {/* 하단 경보 띠 */}
      <div className="h-[76px] border-t border-[#16233a] flex items-center overflow-hidden bg-[#060910] flex-shrink-0">
        <div className="flex-shrink-0 px-6 h-full flex items-center bg-[#1a0b10] border-r border-[#3b1219]">
          <span className="text-lg font-black tracking-[0.25em] text-[#ef4444]">ALERT</span>
        </div>
        <div className="flex-1 overflow-hidden">
          {alert && (
            <div className="oee-ticker flex gap-24 w-max pl-10">
              <span className="text-2xl font-semibold whitespace-nowrap text-[#fca5a5]">{alert}</span>
              <span className="text-2xl font-semibold whitespace-nowrap text-[#fca5a5]">{alert}</span>
            </div>
          )}
        </div>
        <div className="flex-shrink-0 px-6 font-mono text-sm text-[#3d5170]">
          {t("monitoring.board.updatedAt")} {updatedAt}{pageCount > 1 ? ` · ${page + 1}/${pageCount}` : ""}
        </div>
      </div>
    </div>
  );
}
