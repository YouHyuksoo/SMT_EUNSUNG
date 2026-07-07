'use client';

/**
 * @file (authenticated)/oee/dashboard/page.tsx
 * @description 공정별 OEE 종합(대시보드 44). 당일=실시간(V_OEE_LIVE), 과거=마감 스냅샷.
 * 과거 미마감 시 백엔드 409 → "집계 미생성" 안내. 원자재준비율/고객불량은 보조 위젯.
 */
import { useState } from 'react';
import useSWR from 'swr';
import Link from 'next/link';
import { oeeFetch, todayStr, pct, type OeeResult } from './_lib/fetcher';

interface OverviewRow {
  PROCESS_CODE: string;
  AVAILABILITY: number;
  PERFORMANCE: number;
  QUALITY: number;
  OEE: number;
  PLAN_ACHIEVE: number;
  OUTPUT_QTY: number;
  UPH: number;
  PICKUP_RATE: number | null;
}
interface MaterialRow {
  PROCESS_CODE: string;
  PLAN_QTY: number;
  READY_QTY: number;
  READINESS_RATE: number;
}
interface OverviewResp {
  workDate: string;
  live: boolean;
  rows: OverviewRow[];
  material: MaterialRow[];
  customerReturnQty: number;
}

/** OEE 등급 색상 (막대/수치 강조) */
function oeeColor(oee: number): string {
  if (oee >= 0.85) return 'text-emerald-500';
  if (oee >= 0.6) return 'text-amber-500';
  return 'text-rose-500';
}

export default function OeeOverviewPage() {
  const [date, setDate] = useState(todayStr());
  const { data, isLoading } = useSWR<OeeResult<OverviewResp>>(
    `/oee/dashboard/overview?date=${date}`,
    (url: string) => oeeFetch<OverviewResp>(url),
    { refreshInterval: 30000 },
  );

  const resp = data?.data ?? null;
  const notBuilt = data?.notBuilt ?? false;

  return (
    <div className="p-6 space-y-4">
      <div className="flex flex-wrap items-center gap-3">
        <h1 className="text-xl font-bold text-text">공정별 OEE 종합</h1>
        <label className="text-sm text-text-muted flex items-center gap-2">
          일자
          <input
            type="date"
            value={date}
            max={todayStr()}
            onChange={(e) => setDate(e.target.value)}
            className="border border-border rounded p-2 bg-background text-text"
          />
        </label>
        {resp && (
          <span
            className={`text-xs px-2 py-1 rounded-full ${
              resp.live ? 'bg-emerald-500/15 text-emerald-500' : 'bg-slate-500/15 text-text-muted'
            }`}
          >
            {resp.live ? '실시간' : '마감 스냅샷'}
          </span>
        )}
        <div className="ml-auto flex gap-3 text-sm">
          <Link href="/oee/dashboard/drilldown" className="text-primary hover:underline">
            리소스 드릴다운 →
          </Link>
          <Link href="/oee/dashboard/loss" className="text-primary hover:underline">
            로스 파레토 →
          </Link>
        </div>
      </div>

      {notBuilt ? (
        <div className="rounded-lg border border-amber-500/30 bg-amber-500/10 p-8 text-center text-amber-500">
          <div className="text-lg font-semibold">집계 미생성 (마감 필요)</div>
          <div className="mt-1 text-sm text-text-muted">
            선택한 과거 일자의 OEE 마감 스냅샷이 없습니다. 마감 배치(P_OEE_BUILD_SUMMARY) 실행 후 조회하세요.
          </div>
        </div>
      ) : (
        <>
          {/* 보조 위젯: 원자재 준비율 / 고객불량 반입 */}
          <div className="flex flex-wrap gap-4 text-sm">
            <div className="rounded-lg border border-border bg-surface px-4 py-2 text-text-muted">
              <span className="mr-2 font-semibold text-text">원자재 준비율</span>
              {resp?.material.length
                ? resp.material.map((m) => `${m.PROCESS_CODE} ${pct(m.READINESS_RATE)}`).join(' · ')
                : '-'}
            </div>
            <div className="rounded-lg border border-border bg-surface px-4 py-2 text-text-muted">
              <span className="mr-2 font-semibold text-text">고객불량 반입</span>
              {resp?.customerReturnQty ?? 0}
            </div>
          </div>

          {/* 공정별 OEE 카드 */}
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
            {resp?.rows.map((r) => (
              <div key={r.PROCESS_CODE} className="rounded-xl border border-border bg-surface p-5">
                <div className="text-sm font-semibold text-text-muted">{r.PROCESS_CODE}</div>
                <div className={`my-2 text-5xl font-bold ${oeeColor(r.OEE)}`}>{pct(r.OEE)}</div>
                <div className="flex justify-between text-sm text-text">
                  <span>가동 {pct(r.AVAILABILITY)}</span>
                  <span>성능 {pct(r.PERFORMANCE)}</span>
                  <span>양품 {pct(r.QUALITY)}</span>
                </div>
                <div className="mt-2 flex justify-between border-t border-border pt-2 text-xs text-text-muted">
                  <span>UPH {r.UPH?.toFixed(0) ?? '-'}</span>
                  <span>계획달성 {pct(r.PLAN_ACHIEVE)}</span>
                  <span>생산 {r.OUTPUT_QTY?.toLocaleString() ?? 0}</span>
                  {r.PROCESS_CODE === 'SMT' && r.PICKUP_RATE != null && (
                    <span>픽업 {r.PICKUP_RATE.toFixed(1)}%</span>
                  )}
                </div>
                <Link
                  href={`/oee/dashboard/drilldown?processCode=${r.PROCESS_CODE}&date=${date}`}
                  className="mt-3 inline-block text-xs text-primary hover:underline"
                >
                  리소스별 보기 →
                </Link>
              </div>
            ))}
            {resp && resp.rows.length === 0 && (
              <div className="col-span-full rounded-lg border border-border p-8 text-center text-text-muted">
                {isLoading ? '불러오는 중…' : '해당 일자의 OEE 데이터가 없습니다'}
              </div>
            )}
          </div>
        </>
      )}
    </div>
  );
}
