"use client";

/**
 * @file src/app/(authenticated)/dashboard/components/PulseLine.tsx
 * @description "오늘의 한 줄" — 공장 상태를 문장처럼 읽는 대형 숫자 5개.
 *              SMD 달성률 · 제품 달성률 · 설비 가동 · 진성 불량 · 조치 필요.
 *              카드/박스 없이 baseline 정렬 + 괘선 구분만 쓴다.
 */
import { useTranslation } from "react-i18next";
import type { DashboardData } from "./types";
import { DASH, achieveRate, rateText } from "./stageViews";

interface Props {
  data: DashboardData;
  attentionCount: number;
}

interface Segment {
  label: string;
  value: string;
  unit?: string;
  sub?: string;
  tone: string;
}

export default function PulseLine({ data, attentionCount }: Props) {
  const { t } = useTranslation();
  const { summary } = data;
  const prod = summary?.production;
  const equip = summary?.equip;
  const defect = summary?.defect;

  const smdRate = prod ? achieveRate(prod.smdActual, prod.smdPlan) : null;
  const miRate = prod ? achieveRate(prod.miActual, prod.miPlan) : null;

  const segments: Segment[] = [
    {
      label: t("dashboard.pulse.smdAchieve"),
      value: rateText(smdRate),
      unit: smdRate === null ? undefined : "%",
      sub: prod ? `${prod.smdActual.toLocaleString()} / ${prod.smdPlan.toLocaleString()}` : undefined,
      tone: "text-primary",
    },
    {
      label: t("dashboard.pulse.productAchieve"),
      value: rateText(miRate),
      unit: miRate === null ? undefined : "%",
      sub: prod ? `${prod.miActual.toLocaleString()} / ${prod.miPlan.toLocaleString()}` : undefined,
      tone: "text-primary",
    },
    {
      label: t("dashboard.pulse.equipRun"),
      value: equip ? String(equip.inUse) : DASH,
      unit: equip ? t("dashboard.pulse.equipOfTotal", { total: equip.total }) : undefined,
      sub: equip ? `${t("dashboard.equipDown")} ${equip.down}` : undefined,
      tone: equip && equip.down > 0 ? "text-warning" : "text-text",
    },
    {
      label: t("dashboard.pulse.genuine"),
      value: defect ? String(defect.genuine) : DASH,
      unit: defect ? t("dashboard.pulse.countUnit") : undefined,
      sub: defect ? `${t("dashboard.defectPending")} ${defect.pending} · ${t("dashboard.defectUnrepaired")} ${defect.unrepaired}` : undefined,
      tone: defect && defect.genuine > 0 ? "text-error" : "text-text",
    },
    {
      label: t("dashboard.pulse.attention"),
      value: String(attentionCount),
      unit: t("dashboard.pulse.countUnit"),
      tone: attentionCount === 0 ? "text-success" : "text-warning",
    },
  ];

  return (
    <div className="flex items-end divide-x divide-border border-y border-border py-3">
      {segments.map((s, i) => (
        <div key={s.label} className="flex-1 min-w-0 px-5 first:pl-1 last:pr-1 ds-rise" style={{ animationDelay: `${i * 70}ms` }}>
          <div className="text-[11px] font-semibold uppercase tracking-[0.18em] text-text-muted truncate">{s.label}</div>
          <div className="flex items-baseline gap-1.5 mt-1">
            <span className={`text-4xl xl:text-5xl font-extrabold tabular-nums leading-none tracking-tight ${s.tone}`}>{s.value}</span>
            {s.unit && <span className="text-sm font-medium text-text-muted tabular-nums">{s.unit}</span>}
          </div>
          <div className="text-[11px] text-text-muted tabular-nums mt-1 h-4 truncate">{s.sub ?? ""}</div>
        </div>
      ))}
    </div>
  );
}
