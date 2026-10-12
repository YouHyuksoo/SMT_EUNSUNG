/**
 * @file src/app/(authenticated)/dashboard/components/stageViews.ts
 * @description 단계(역) 뷰모델 — 공정 흐름 리본(ValueStream)과 노선도(FlowMapLayout)가 같이 쓰는 순수 함수.
 *
 * 초보자 가이드:
 * 1. 공정 라인 5단계: 재고 → 자재(솔더·MSL) → SMD → 제품 → 품질. 설비 라인 3단계: 사용중/비가동/미사용.
 * 2. 숫자는 전부 API 에서 온 값이다. 아직 못 받은 값(null)은 "—" 로 보여 0 과 구분한다.
 * 3. "압력" = 그 단계에서 사람이 처리해야 할 예외 건수 (buildAttention 결과를 단계별로 합산).
 * 4. 단계별 이동 경로(href)는 menuConfig.ts 에 실제 있는 화면이다.
 */
import type { AttentionItem, DashboardData } from "./types";
import { EQUIP_STAGES, FLOW_STAGES, pressureByStation, type Station } from "./attentionStage";

type Translate = (key: string, options?: Record<string, unknown>) => string;

export interface StageMetric {
  label: string;
  value: string;
  /** 의미 토큰 클래스 (text-error 등). 없으면 기본 */
  tone?: string;
}

export interface StageView {
  key: Station;
  line: "flow" | "equip";
  href: string;
  hero: string;
  heroUnit?: string;
  heroTone: string;
  /** 대표 숫자 아래 설명 (i18n 적용 후) */
  heroLabel: string;
  lines: StageMetric[];
  pressure: number;
}

export const DASH = "—";

const num = (v: number | null | undefined) => (v === null || v === undefined ? DASH : v.toLocaleString());
const warn = (v: number | null | undefined, tone: string) => (v !== null && v !== undefined && v > 0 ? tone : undefined);

/** 달성률(%) — 계획이 0 이면 null (0% 와 "계획 없음" 을 구분) */
export function achieveRate(actual: number, plan: number): number | null {
  return plan > 0 ? (actual / plan) * 100 : null;
}

export const rateText = (rate: number | null) => (rate === null ? DASH : rate.toFixed(1));

/** 흐름선 애니메이션 켤지 — 오늘 SMD/제품 실적이 하나라도 있거나 진행 중 계획이 있을 때 */
export function isFlowing(data: DashboardData): boolean {
  const p = data.summary?.production;
  return (p ? p.smdActual + p.miActual > 0 : false) || (data.production?.kpi.runningCount ?? 0) > 0;
}

export function buildStageViews(data: DashboardData, attention: AttentionItem[], t: Translate): StageView[] {
  const { summary, inventory } = data;
  const pressure = pressureByStation(attention);
  const p = (id: Station) => pressure[id] ?? 0;

  const mat = summary?.material;
  const prod = summary?.production;
  const defect = summary?.defect;
  const equip = summary?.equip;
  const inv = inventory?.kpi;

  const smdRate = prod ? achieveRate(prod.smdActual, prod.smdPlan) : null;
  const miRate = prod ? achieveRate(prod.miActual, prod.miPlan) : null;

  const flow: StageView[] = [
    {
      key: "stock", line: "flow", href: "/monitoring/inventory-board",
      hero: num(inv?.inCount), heroUnit: t("dashboard.stream.countUnit"), heroTone: "text-text",
      heroLabel: t("dashboard.stream.stockHero"),
      lines: [
        { label: t("dashboard.stream.out"), value: num(inv?.outCount) },
        { label: t("dashboard.stream.expired"), value: num(inv?.expiredCount), tone: warn(inv?.expiredCount, "text-error") },
        { label: t("dashboard.stream.nearExpiry"), value: num(inv?.nearExpiryCount), tone: warn(inv?.nearExpiryCount, "text-warning") },
        { label: t("dashboard.stream.shortage"), value: num(inv?.shortageCount), tone: warn(inv?.shortageCount, "text-warning") },
        { label: t("dashboard.stream.hold"), value: num(inv?.holdCount), tone: warn(inv?.holdCount, "text-error") },
      ],
      pressure: p("stock"),
    },
    {
      key: "material", line: "flow", href: "/warehouse/solder",
      hero: num(mat?.solderInUse), heroTone: "text-text",
      heroLabel: t("dashboard.solderInUse"),
      lines: [
        { label: t("dashboard.mslLots"), value: num(mat?.mslLots) },
        { label: t("dashboard.solderNg"), value: num(mat?.solderNg), tone: warn(mat?.solderNg, "text-error") },
        { label: t("dashboard.mslNg"), value: num(mat?.mslNg), tone: warn(mat?.mslNg, "text-error") },
      ],
      pressure: p("material"),
    },
    {
      key: "smd", line: "flow", href: "/production/smd-actual",
      hero: num(prod?.smdActual), heroUnit: `/ ${num(prod?.smdPlan)}`, heroTone: "text-primary",
      heroLabel: t("dashboard.stream.smdHero"),
      lines: [
        { label: t("dashboard.stream.achieve"), value: smdRate === null ? DASH : `${smdRate.toFixed(1)}%` },
        { label: t("dashboard.stream.remaining"), value: prod ? Math.max(prod.smdPlan - prod.smdActual, 0).toLocaleString() : DASH },
      ],
      pressure: p("smd"),
    },
    {
      key: "product", line: "flow", href: "/production/pcb-result",
      hero: num(prod?.miActual), heroUnit: `/ ${num(prod?.miPlan)}`, heroTone: "text-primary",
      heroLabel: t("dashboard.stream.productHero"),
      lines: [
        { label: t("dashboard.stream.achieve"), value: miRate === null ? DASH : `${miRate.toFixed(1)}%` },
        { label: t("dashboard.stream.remaining"), value: prod ? Math.max(prod.miPlan - prod.miActual, 0).toLocaleString() : DASH },
      ],
      pressure: p("product"),
    },
    {
      key: "quality", line: "flow", href: "/quality/repair-query",
      hero: num(defect?.genuine), heroTone: (defect?.genuine ?? 0) > 0 ? "text-error" : "text-text",
      heroLabel: t("dashboard.stream.qualityHero"),
      lines: [
        { label: t("dashboard.defectPseudo"), value: num(defect?.pseudo) },
        { label: t("dashboard.defectPending"), value: num(defect?.pending), tone: warn(defect?.pending, "text-error") },
        { label: t("dashboard.defectUnrepaired"), value: num(defect?.unrepaired), tone: warn(defect?.unrepaired, "text-error") },
      ],
      pressure: p("quality"),
    },
  ];

  const equipLabel: Record<(typeof EQUIP_STAGES)[number], string> = {
    inUse: t("dashboard.equipInUse"),
    down: t("dashboard.equipDown"),
    notUsed: t("dashboard.equipNotUsed"),
  };
  const equipValue: Record<(typeof EQUIP_STAGES)[number], number | undefined> = {
    inUse: equip?.inUse, down: equip?.down, notUsed: equip?.notUsed,
  };
  const equipViews: StageView[] = EQUIP_STAGES.map((id) => ({
    key: id, line: "equip", href: "/oee/equip-ops-status",
    hero: num(equipValue[id]), heroUnit: `/ ${num(equip?.total)}`,
    heroTone: id === "down" && (equip?.down ?? 0) > 0 ? "text-error" : "text-text",
    heroLabel: equipLabel[id],
    lines: [],
    pressure: p(id),
  }));

  // FLOW_STAGES 순서를 보장한다(정의 순서가 곧 노선 순서)
  const ordered = FLOW_STAGES.map((id) => flow.find((s) => s.key === id)).filter((s): s is StageView => !!s);
  return [...ordered, ...equipViews];
}
