"use client";

/**
 * @file src/app/(authenticated)/dashboard/page.tsx
 * @description 대시보드 페이지 — 현황 카드 4개 + 요약 차트 4개 + 7일 추이/라인별 차트
 *
 * 초보자 가이드:
 * 1. API: GET /dashboard/summary?date=YYYY-MM-DD — 카드별 출처는 백엔드 dashboard.service.ts 머리말 참고
 * 2. 설비·솔더·MSL 은 조회 시점 현재 상태, 생산·불량은 date 하루 기준이다
 * 2-1. GET /dashboard/insights?date=YYYY-MM-DD — 7일 추이(trend)·라인별 계획/실적(lines), 차트는 components/DashboardCharts.tsx
 * 3. 설비 일상/정기점검·PM 카드는 은성 DB에 데이터가 없어 두지 않는다
 */
import { useState, useEffect, useCallback } from "react";
import { useTranslation } from "react-i18next";
import toast from "react-hot-toast";
import {
  Cpu, ClipboardList, PackageSearch, Bug,
  LayoutDashboard, RefreshCw,
} from "lucide-react";
import { Button } from "@/components/ui";
import api from "@/services/api";
import {
  EquipDonutCard, ProductionGaugeCard, MaterialBarCard, DefectDonutCard,
  ProductionTrendCard, LineAchievementCard, type DashboardInsights,
} from "./components/DashboardCharts";

/* ── Status Card ── */
interface StatusCardProps {
  title: string;
  icon: React.ComponentType<{ className?: string }>;
  color: string;
  gradient: string;
  items: { label: string; value: number; accent?: string }[];
}

function StatusCard({ title, icon: Icon, color, gradient, items }: StatusCardProps) {
  return (
    <div className={`p-[1.5px] rounded-2xl ${gradient}`}>
      <div className="bg-card rounded-2xl p-3 h-full">
        <div className="flex items-center gap-2 mb-3">
          <Icon className={`w-4 h-4 ${color}`} />
          <span className="text-xs font-semibold text-text">{title}</span>
        </div>
        <div className="grid grid-cols-2 gap-2">
          {items.map((item) => (
            <div key={item.label} className="text-center p-1.5 rounded-md bg-surface dark:bg-slate-800/50">
              <div className={`text-lg font-bold leading-tight ${item.accent || "text-text"}`}>
                {item.value.toLocaleString()}
              </div>
              <div className="text-[10px] text-text-muted mt-0.5">{item.label}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

/* ── Types ── */
interface DashboardSummary {
  equip: { inUse: number; down: number; notUsed: number; total: number };
  production: { smdPlan: number; smdActual: number; miPlan: number; miActual: number };
  material: { solderInUse: number; solderNg: number; mslLots: number; mslNg: number };
  defect: { pending: number; genuine: number; pseudo: number; unrepaired: number };
}

const emptySummary: DashboardSummary = {
  equip: { inUse: 0, down: 0, notUsed: 0, total: 0 },
  production: { smdPlan: 0, smdActual: 0, miPlan: 0, miActual: 0 },
  material: { solderInUse: 0, solderNg: 0, mslLots: 0, mslNg: 0 },
  defect: { pending: 0, genuine: 0, pseudo: 0, unrepaired: 0 },
};

function formatDate(d: Date) {
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}-${String(d.getDate()).padStart(2, "0")}`;
}

export default function DashboardPage() {
  const { t } = useTranslation();
  const [summary, setSummary] = useState<DashboardSummary>(emptySummary);
  const [insights, setInsights] = useState<DashboardInsights | null>(null);
  const [loading, setLoading] = useState(false);

  const today = formatDate(new Date());

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get("/dashboard/summary", { params: { date: today } });
      setSummary(res.data.data);
      // 추이/라인별 차트용. 실패해도 카드와 요약 차트는 그대로 보여준다
      api.get("/dashboard/insights", { params: { date: today } })
        .then((r) => setInsights(r.data.data))
        .catch((e: unknown) => { console.error(e); setInsights(null); });
    } catch (error: unknown) {
      console.error(error);
      toast.error(t("dashboard.loadFailed"));
    } finally {
      setLoading(false);
    }
  }, [today, t]);

  useEffect(() => { search(); }, [search]);

  const { equip, production, material, defect } = summary;

  return (
    <div className="h-full flex flex-col overflow-hidden p-6 gap-4 animate-fade-in">
      {/* Header */}
      <div className="flex justify-between items-center flex-shrink-0">
        <div>
          <h1 className="text-xl font-bold text-text flex items-center gap-2">
            <LayoutDashboard className="w-7 h-7 text-primary" />{t("dashboard.title")}
          </h1>
          <p className="text-text-muted mt-1">{t("dashboard.subtitle")}</p>
        </div>
        <Button variant="secondary" size="sm" onClick={search}>
          <RefreshCw className={`w-4 h-4 mr-1 ${loading ? "animate-spin" : ""}`} /> {t("common.refresh")}
        </Button>
      </div>

      <div className="flex-1 min-h-0 overflow-y-auto flex flex-col gap-4 pr-1">
      {/* Status Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 flex-shrink-0">
        <StatusCard
          title={t("dashboard.equipStatus")}
          icon={Cpu} color="text-indigo-500"
          gradient="bg-gradient-to-br from-indigo-400 via-purple-400 to-blue-500"
          items={[
            { label: t("dashboard.equipInUse"), value: equip.inUse, accent: "text-success" },
            { label: t("dashboard.equipDown"), value: equip.down, accent: equip.down > 0 ? "text-error" : "text-text" },
            { label: t("dashboard.equipNotUsed"), value: equip.notUsed },
            { label: t("dashboard.equipTotal"), value: equip.total },
          ]}
        />
        <StatusCard
          title={t("dashboard.prodStatus")}
          icon={ClipboardList} color="text-sky-500"
          gradient="bg-gradient-to-br from-sky-400 to-cyan-500"
          items={[
            { label: t("dashboard.smdPlan"), value: production.smdPlan },
            { label: t("dashboard.smdActual"), value: production.smdActual, accent: "text-info" },
            { label: t("dashboard.miPlan"), value: production.miPlan },
            { label: t("dashboard.miActual"), value: production.miActual, accent: "text-info" },
          ]}
        />
        <StatusCard
          title={t("dashboard.matStatus")}
          icon={PackageSearch} color="text-amber-500"
          gradient="bg-gradient-to-br from-amber-400 to-orange-500"
          items={[
            { label: t("dashboard.solderInUse"), value: material.solderInUse },
            { label: t("dashboard.solderNg"), value: material.solderNg, accent: material.solderNg > 0 ? "text-error" : "text-text" },
            { label: t("dashboard.mslLots"), value: material.mslLots },
            { label: t("dashboard.mslNg"), value: material.mslNg, accent: material.mslNg > 0 ? "text-error" : "text-text" },
          ]}
        />
        <StatusCard
          title={t("dashboard.defectStatus")}
          icon={Bug} color="text-rose-500"
          gradient="bg-gradient-to-br from-rose-400 to-red-500"
          items={[
            { label: t("dashboard.defectPending"), value: defect.pending, accent: defect.pending > 0 ? "text-warning" : "text-text" },
            { label: t("dashboard.defectGenuine"), value: defect.genuine },
            { label: t("dashboard.defectPseudo"), value: defect.pseudo },
            { label: t("dashboard.defectUnrepaired"), value: defect.unrepaired, accent: defect.unrepaired > 0 ? "text-error" : "text-text" },
          ]}
        />
      </div>

      {/* Charts: 요약 시각화 */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 flex-shrink-0">
        <EquipDonutCard equip={equip} />
        <ProductionGaugeCard production={production} />
        <MaterialBarCard material={material} />
        <DefectDonutCard defect={defect} />
      </div>

      {/* Charts: 7일 추이 / 라인별 */}
      <div className="grid grid-cols-1 lg:grid-cols-4 gap-4 flex-shrink-0">
        <ProductionTrendCard trend={insights?.trend ?? null} />
        <LineAchievementCard lines={insights?.lines ?? null} />
      </div>
      </div>
    </div>
  );
}
