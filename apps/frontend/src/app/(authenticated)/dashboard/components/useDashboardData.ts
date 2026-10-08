"use client";

/**
 * @file src/app/(authenticated)/dashboard/components/useDashboardData.ts
 * @description 대시보드 데이터 훅 — 5개 API 를 병렬 호출하고 60초마다 자동 갱신한다.
 *
 * 초보자 가이드:
 * 1. GET /dashboard/summary?date=오늘   : 설비·생산(SMD/제품)·솔더/MSL·불량 판정 수치
 * 2. GET /dashboard/insights?date=오늘  : 최근 7일 추이 + 라인별 계획/실적
 * 3. GET /monitoring/boards/production  : 오늘 생산 계획 행 + 시간대별 실적
 * 4. GET /monitoring/boards/quality     : 불량률/공정별/유형 TOP/수리/7일 추이
 * 5. GET /monitoring/boards/inventory   : 안전재고 미달/기한 LOT/보류 재고/금일 입출고
 * 6. 일부 API 가 실패해도 나머지는 표시한다 (allSettled). 실패 API 는 이전 값 유지.
 * 7. 자동 갱신은 setInterval 이 아니라 useActiveInterval 이다 — 탭이 숨겨지면(TabKeepAlive) 타이머가 멈추고,
 *    다시 보일 때 주기를 놓쳤으면 한 번 즉시 갱신한다 (저사양 현장 PC 부하 방지).
 */
import { useCallback, useEffect, useRef, useState } from "react";
import api from "@/services/api";
import { getTodayLocal } from "@/utils/date";
import { useActiveInterval } from "@/hooks/useTabActive";
import type { DashboardData, DashboardInsights, DashboardSummary, InventoryBoardData, ProductionBoardData, QualityBoardData } from "./types";

export const REFRESH_MS = 60_000;

async function fetchData<T>(url: string, params?: Record<string, string>): Promise<T> {
  const res = await api.get(url, { params });
  return res.data.data as T;
}

const EMPTY: DashboardData = { summary: null, insights: null, production: null, quality: null, inventory: null };

export function useDashboardData() {
  const [data, setData] = useState<DashboardData>(EMPTY);
  const [loading, setLoading] = useState(false);
  const [updatedAt, setUpdatedAt] = useState<Date | null>(null);
  const inFlight = useRef(false);

  const refresh = useCallback(async () => {
    if (inFlight.current) return;
    inFlight.current = true;
    setLoading(true);
    try {
      const today = getTodayLocal();
      const [summary, insights, production, quality, inventory] = await Promise.allSettled([
        fetchData<DashboardSummary>("/dashboard/summary", { date: today }),
        fetchData<DashboardInsights>("/dashboard/insights", { date: today }),
        fetchData<ProductionBoardData>("/monitoring/boards/production"),
        fetchData<QualityBoardData>("/monitoring/boards/quality"),
        fetchData<InventoryBoardData>("/monitoring/boards/inventory"),
      ]);
      setData((prev) => ({
        summary: summary.status === "fulfilled" ? summary.value : prev.summary,
        insights: insights.status === "fulfilled" ? insights.value : prev.insights,
        production: production.status === "fulfilled" ? production.value : prev.production,
        quality: quality.status === "fulfilled" ? quality.value : prev.quality,
        inventory: inventory.status === "fulfilled" ? inventory.value : prev.inventory,
      }));
      setUpdatedAt(new Date());
    } finally {
      setLoading(false);
      inFlight.current = false;
    }
  }, []);

  // 첫 조회 1회 + 이후 60초 주기(보이는 탭에서만)
  useEffect(() => {
    void refresh();
  }, [refresh]);
  useActiveInterval(() => { void refresh(); }, REFRESH_MS, { catchUp: true });

  return { data, loading, updatedAt, refresh };
}
