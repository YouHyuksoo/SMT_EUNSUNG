"use client";

/**
 * @file src/app/(authenticated)/dashboard/components/HeaderClock.tsx
 * @description 헤더 현재시각 — 1초 갱신을 이 컴포넌트 안에 가둔다.
 *
 * 초보자 가이드:
 * - 공용 useNow 는 setInterval 이라 숨겨진 탭(TabKeepAlive)에서도 1초마다 돈다.
 *   대시보드는 고정 탭이라 항상 마운트돼 있으므로 useActiveInterval 로 보이는 탭에서만 갱신한다.
 * - 시각이 바뀌어도 페이지 전체가 리렌더되지 않도록 상태를 이 컴포넌트에만 둔다.
 * - `useNowHour` 는 시(0~23) 단위만 필요한 형태 컴포넌트용이다 (30초마다 확인).
 */
import { useEffect, useState } from "react";
import { useActiveInterval } from "@/hooks/useTabActive";
import { formatClock } from "@/components/monitoring/BoardClock";

export function useNowHour(): number | null {
  const [hour, setHour] = useState<number | null>(null);
  useEffect(() => setHour(new Date().getHours()), []);
  useActiveInterval(() => setHour(new Date().getHours()), 30_000, { catchUp: true });
  return hour;
}

export default function HeaderClock() {
  const [now, setNow] = useState<Date | null>(null);
  // 첫 렌더는 SSR 하이드레이션 불일치를 피하려고 null — 첫 틱에서 채운다
  useActiveInterval(() => setNow(new Date()), 1000, { catchUp: true });
  const clock = now ? formatClock(now) : null;

  return (
    <div className="text-right tabular-nums leading-none">
      <div className="text-[11px] uppercase tracking-[0.18em] text-text-muted">{clock?.date ?? ""}</div>
      <div className="text-2xl font-extrabold text-text mt-1">
        {clock?.hm ?? "--:--"}<span className="text-text-muted">:{clock?.sec ?? "--"}</span>
      </div>
    </div>
  );
}
