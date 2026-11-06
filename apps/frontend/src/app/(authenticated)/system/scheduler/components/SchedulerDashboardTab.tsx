"use client";

/**
 * @file system/scheduler/components/SchedulerDashboardTab.tsx
 * @description 스케줄러 대시보드 탭 - 통계카드 + 차트 + 최근 실패 테이블
 *
 * 초보자 가이드:
 * 1. **StatCard 4개**: 오늘 실행, 성공, 실패, 성공률
 * 2. **7일 추이 LineChart**: 성공/실패 일별 트렌드 (recharts)
 * 3. **작업별 BarChart**: 작업별 성공/실패 스택 바 차트
 * 4. **최근 실패**: 5건 그리드 (DataGrid)
 * 5. API: GET /scheduler/logs/summary
 */
import { useState, useEffect, useCallback, useMemo } from "react";
import { useTranslation } from "react-i18next";
import { Activity, CheckCircle, XCircle, TrendingUp, RefreshCw } from "lucide-react";
import {
  LineChart, Line, BarChart, Bar, XAxis, YAxis, CartesianGrid,
  Tooltip, Legend, ResponsiveContainer,
} from "recharts";
import type { ColumnDef } from "@tanstack/react-table";
import { Card, CardContent, Button, StatCard } from "@/components/ui";
import DataGrid from "@/components/data-grid/DataGrid";
import api from "@/services/api";

/** 대시보드 요약 데이터 */
interface DashboardSummary {
  todayTotal: number;
  todaySuccess: number;
  todayFail: number;
  successRate: number;
  trend: { date: string; success: number; fail: number }[];
  jobStats: { jobCode: string; jobName: string; success: number; fail: number }[];
  recentFails: RecentFail[];
}

/** 최근 실패 1건 */
interface RecentFail {
  jobCode: string; startTime: string; errorMsg: string | null;
}

const EMPTY: DashboardSummary = {
  todayTotal: 0, todaySuccess: 0, todayFail: 0, successRate: 0,
  trend: [], jobStats: [], recentFails: [],
};

/** ISO 일시를 "YYYY-MM-DD HH:mm:ss" 로 */
const fmtDt = (v: string | null) => v ? v.replace("T", " ").slice(0, 19) : "-";

export default function SchedulerDashboardTab() {
  const { t } = useTranslation();
  const [data, setData] = useState<DashboardSummary>(EMPTY);
  const [loading, setLoading] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get("/scheduler/logs/summary");
      setData(res.data?.data ?? res.data ?? EMPTY);
    } catch {
      setData(EMPTY);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { search(); }, [search]);

  /** 최근 실패 그리드 컬럼 — 에러상세는 400px 에서 자르고 전체는 툴팁으로 본다 */
  const failColumns = useMemo<ColumnDef<RecentFail>[]>(() => [
    { accessorKey: "jobCode", header: t("system.scheduler.jobCode", "작업코드"), size: 140,
      cell: ({ getValue }) => <span className="text-primary font-medium">{String(getValue() ?? "")}</span> },
    { id: "startTime", header: t("system.scheduler.startTime", "시작시각"), size: 160,
      accessorFn: (row) => fmtDt(row.startTime) },
    { id: "errorMsg", header: t("system.scheduler.errorMsg", "에러상세"), size: 400,
      accessorFn: (row) => row.errorMsg ?? "-",
      cell: ({ getValue }) => (
        <span className="block max-w-[400px] truncate text-red-600 dark:text-red-400" title={String(getValue())}>
          {String(getValue())}
        </span>
      ) },
  ], [t]);

  return (
    <div className="flex flex-col h-full gap-4 overflow-y-auto min-h-0">
      {/* 새로고침 */}
      <div className="flex justify-end flex-shrink-0">
        <Button size="sm" variant="secondary" onClick={search}>
          <RefreshCw className={`w-4 h-4 mr-1 ${loading ? "animate-spin" : ""}`} />
          {t("common.refresh")}
        </Button>
      </div>

      {/* 통계 카드 4개 */}
      <div className="grid grid-cols-4 gap-4 flex-shrink-0">
        <StatCard label={t("system.scheduler.todayTotal", "오늘 실행")} value={data.todayTotal}
          icon={Activity} color="blue" />
        <StatCard label={t("system.scheduler.todaySuccess", "성공")} value={data.todaySuccess}
          icon={CheckCircle} color="green" />
        <StatCard label={t("system.scheduler.todayFail", "실패")} value={data.todayFail}
          icon={XCircle} color="red" />
        <StatCard label={t("system.scheduler.successRate", "성공률")}
          value={`${data.successRate.toFixed(1)}%`}
          icon={TrendingUp} color="purple" />
      </div>

      {/* 차트 영역 */}
      <div className="grid grid-cols-2 gap-4 flex-shrink-0">
        {/* 7일 추이 LineChart */}
        <Card>
          <CardContent>
            <h3 className="text-sm font-semibold text-text mb-3">{t("system.scheduler.trendChart", "7일간 실행 추이")}</h3>
            <ResponsiveContainer width="100%" height={250}>
              <LineChart data={data.trend}>
                <CartesianGrid strokeDasharray="3 3" className="opacity-30" />
                <XAxis dataKey="date" tick={{ fontSize: 11 }} />
                <YAxis tick={{ fontSize: 11 }} allowDecimals={false} />
                <Tooltip contentStyle={{ fontSize: 12 }} />
                <Legend wrapperStyle={{ fontSize: 12 }} />
                <Line type="monotone" dataKey="success" name={t("system.scheduler.todaySuccess", "성공")}
                  stroke="#22c55e" strokeWidth={2} dot={{ r: 3 }} />
                <Line type="monotone" dataKey="fail" name={t("system.scheduler.todayFail", "실패")}
                  stroke="#ef4444" strokeWidth={2} dot={{ r: 3 }} />
              </LineChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        {/* 작업별 BarChart */}
        <Card>
          <CardContent>
            <h3 className="text-sm font-semibold text-text mb-3">{t("system.scheduler.ratioChart", "작업별 성공/실패")}</h3>
            <ResponsiveContainer width="100%" height={250}>
              <BarChart data={data.jobStats}>
                <CartesianGrid strokeDasharray="3 3" className="opacity-30" />
                <XAxis dataKey="jobCode" tick={{ fontSize: 10 }} />
                <YAxis tick={{ fontSize: 11 }} allowDecimals={false} />
                <Tooltip contentStyle={{ fontSize: 12 }} />
                <Legend wrapperStyle={{ fontSize: 12 }} />
                <Bar dataKey="success" name={t("system.scheduler.todaySuccess", "성공")}
                  stackId="a" fill="#22c55e" />
                <Bar dataKey="fail" name={t("system.scheduler.todayFail", "실패")}
                  stackId="a" fill="#ef4444" />
              </BarChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
      </div>

      {/* 최근 실패 테이블 */}
      <Card className="flex-shrink-0">
        <CardContent>
          <h3 className="text-sm font-semibold text-text mb-3">{t("system.scheduler.recentFails", "최근 실패")}</h3>
          <DataGrid data={data.recentFails.slice(0, 5)} columns={failColumns} enableColumnFilter={false}
            enableFullscreen={false} showFooter={false} emptyMessage={t("common.noData", "데이터 없음")} />
        </CardContent>
      </Card>
    </div>
  );
}
