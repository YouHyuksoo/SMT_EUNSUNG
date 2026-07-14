"use client";

/**
 * @file master/work-calendar/components/CalendarGrid.tsx
 * @description 월별 달력 그리드 — 근무일/휴일/반일/특근을 색상으로 표시
 *
 * 초보자 가이드:
 * 1. month(YYYY-MM) 기준으로 달력 셀을 생성하고 days 데이터를 매핑
 * 2. 날짜 클릭 시 onDayClick 호출 → 부모에서 DayEditModal 오픈. 확정(confirmYn=Y) 일자는 잠김.
 * 3. 하단 요약바에 근무일/휴일 수와 총 근무분 표시
 */
import { useMemo } from "react";
import { useTranslation } from "react-i18next";
import { ChevronLeft, ChevronRight, Lock } from "lucide-react";
import { Button } from "@/components/ui";
import { ComCodeBadge } from "@/components/ui";
import type { WorkCalendarDay } from "../types";

interface CalendarGridProps {
  month: string;
  days: WorkCalendarDay[];
  onDayClick: (date: string, day: WorkCalendarDay | null) => void;
  onMonthChange: (month: string) => void;
}

const TYPE_COLORS: Record<string, string> = {
  WORK: "bg-blue-50 dark:bg-blue-900/30 border-blue-200 dark:border-blue-700",
  OFF: "bg-red-50 dark:bg-red-900/30 border-red-200 dark:border-red-700",
  HALF: "bg-yellow-50 dark:bg-yellow-900/30 border-yellow-200 dark:border-yellow-700",
  SPECIAL: "bg-green-50 dark:bg-green-900/30 border-green-200 dark:border-green-700",
};

const WEEKDAYS = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

export default function CalendarGrid({
  month,
  days,
  onDayClick,
  onMonthChange,
}: CalendarGridProps) {
  const { t } = useTranslation();

  const dateMap = useMemo(() => {
    const m = new Map<string, WorkCalendarDay>();
    days.forEach((d) => m.set(d.workDate, d));
    return m;
  }, [days]);

  const calendarCells = useMemo(() => {
    const [y, m] = month.split("-").map(Number);
    const firstDay = new Date(y, m - 1, 1).getDay();
    const lastDate = new Date(y, m, 0).getDate();
    const cells: (number | null)[] = Array(firstDay).fill(null);
    for (let d = 1; d <= lastDate; d++) cells.push(d);
    while (cells.length % 7 !== 0) cells.push(null);
    return cells;
  }, [month]);

  const summary = useMemo(() => {
    let work = 0, off = 0, totalMin = 0;
    days.forEach((d) => {
      if (d.dayType === "WORK" || d.dayType === "HALF" || d.dayType === "SPECIAL") work++;
      else off++;
      totalMin += d.workMinutes + d.otMinutes;
    });
    return { work, off, totalMin };
  }, [days]);

  const changeMonth = (delta: number) => {
    const [y, m] = month.split("-").map(Number);
    const d = new Date(y, m - 1 + delta, 1);
    onMonthChange(`${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}`);
  };

  const toDateStr = (day: number) => `${month}-${String(day).padStart(2, "0")}`;

  return (
    <div className="flex flex-col gap-3">
      {/* 월 네비게이션 */}
      <div className="flex items-center justify-between">
        <Button variant="ghost" size="sm" onClick={() => changeMonth(-1)}>
          <ChevronLeft className="w-4 h-4" />
        </Button>
        <span className="text-sm font-bold text-text dark:text-gray-100">
          {month}
        </span>
        <Button variant="ghost" size="sm" onClick={() => changeMonth(1)}>
          <ChevronRight className="w-4 h-4" />
        </Button>
      </div>

      {/* 요일 헤더 */}
      <div className="grid grid-cols-7 gap-1">
        {WEEKDAYS.map((wd) => (
          <div key={wd} className="text-center text-[10px] font-medium text-text-muted dark:text-gray-400 py-1">
            {wd}
          </div>
        ))}
      </div>

      {/* 날짜 셀 */}
      <div className="grid grid-cols-7 gap-1">
        {calendarCells.map((day, idx) => {
          if (day === null) return <div key={`e-${idx}`} className="h-16" />;
          const ds = toDateStr(day);
          const info = dateMap.get(ds);
          const color = info ? TYPE_COLORS[info.dayType] ?? "" : "border-border dark:border-gray-700";
          const locked = info?.confirmYn === "Y";
          return (
            <button
              key={ds}
              onClick={() => !locked && onDayClick(ds, info ?? null)}
              disabled={locked}
              className={`h-16 rounded border p-1 text-left flex flex-col transition-colors
                ${color} ${locked ? "cursor-default opacity-80" : "hover:ring-1 hover:ring-primary cursor-pointer"}`}
            >
              <span className="text-xs font-medium text-text dark:text-gray-200">{day}</span>
              {info && (
                <div className="mt-auto flex items-center gap-1">
                  <ComCodeBadge groupCode="WORK_DAY_TYPE" code={info.dayType} />
                  {info.source === "LINE" && (
                    <span className="text-[9px] px-1 rounded bg-purple-100 dark:bg-purple-900/40 text-purple-700 dark:text-purple-300">
                      예외
                    </span>
                  )}
                  {locked && <Lock className="w-3 h-3 text-green-500" />}
                </div>
              )}
            </button>
          );
        })}
      </div>

      {/* 요약바 */}
      <div className="flex items-center justify-center gap-6 text-xs text-text-muted dark:text-gray-400 bg-surface dark:bg-slate-800 rounded p-2">
        <span>{t("master.workCalendar.workDays")}: <b className="text-blue-600 dark:text-blue-400">{summary.work}</b></span>
        <span>{t("master.workCalendar.offDays")}: <b className="text-red-500 dark:text-red-400">{summary.off}</b></span>
        <span>{t("master.workCalendar.totalMinutes")}: <b className="text-text dark:text-gray-200">{summary.totalMin.toLocaleString()}</b></span>
      </div>
    </div>
  );
}
