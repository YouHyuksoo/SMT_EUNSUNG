"use client";

/**
 * @file master/work-calendar/components/CalendarGrid.tsx
 * @description 월별 달력 그리드 — 근무일/휴일/반일/특근을 색상으로 표시
 *
 * 초보자 가이드:
 * 1. month(YYYY-MM) 기준으로 달력 셀을 생성하고 days 데이터를 매핑.
 *    상단 년월은 month 피커라 원하는 년월로 바로 이동할 수 있고, 좌우 화살표는 그대로
 *    한 달씩 이동한다. 둘 다 onMonthChange 하나로 모인다.
 * 2. 날짜 클릭 시 onDayClick 호출 → 부모에서 DayEditModal 오픈. 확정(confirmYn=Y) 일자는 잠김.
 * 3. 셀 우측 상단 체크박스로 여러 날짜를 선택하면 상단 툴바에서 일괄 수정할 수 있다.
 *    툴바는 상시 표시하고, 선택이 없으면 일괄 수정만 비활성으로 둔다.
 *    선택을 비우려면 켜져 있는 그룹 체크박스를 다시 누른다(별도 해제 버튼은 두지 않는다).
 *    전체/평일/주말은 한 번에 하나만 켜지는 체크박스다. 켜면 그 그룹을 선택하고 다시 누르면
 *    선택을 비운다. 체크 상태는 별도 state가 아니라 현재 선택과 그룹을 비교해 파생시킨다 —
 *    그래야 개별 날짜 체크박스를 손대면 그룹 체크가 자동으로 풀린다.
 *    확정 일자는 수정 대상이 아니므로 체크박스를 노출하지 않고 일괄 선택에서도 뺀다.
 * 4. 하단 요약바에 근무일/휴일 수와 총 근무분 표시
 */
import { useMemo } from "react";
import { useTranslation } from "react-i18next";
import { ChevronLeft, ChevronRight, Lock, PauseCircle } from "lucide-react";
import { Button, Input } from "@/components/ui";
import { ComCodeBadge } from "@/components/ui";
import type { WorkCalendarDay } from "../types";

interface CalendarGridProps {
  month: string;
  days: WorkCalendarDay[];
  /** 체크된 일자(YYYY-MM-DD) 집합 */
  selectedDates: Set<string>;
  /** 일자별 계획 비가동 건수 (YYYY-MM-DD → 건수) */
  planCounts: Map<string, number>;
  /** ⏸뱃지 클릭 — 그날 계획 비가동 목록을 연다 */
  onPlanBadgeClick: (date: string) => void;
  onDayClick: (date: string, day: WorkCalendarDay | null) => void;
  onToggleSelect: (date: string) => void;
  /** 전체/평일/주말 일괄 선택 — 넘긴 목록으로 선택을 통째로 교체한다. */
  onSelectDates: (dates: string[]) => void;
  onBulkEdit: () => void;
  onMonthChange: (month: string) => void;
}

const TYPE_COLORS: Record<string, string> = {
  WORK: "bg-blue-50 dark:bg-blue-900/30 border-blue-200 dark:border-blue-700",
  OFF: "bg-red-50 dark:bg-red-900/30 border-red-200 dark:border-red-700",
  HALF: "bg-yellow-50 dark:bg-yellow-900/30 border-yellow-200 dark:border-yellow-700",
  SPECIAL: "bg-green-50 dark:bg-green-900/30 border-green-200 dark:border-green-700",
};

const WEEKDAYS = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

/** 일괄 선택 그룹. 한 번에 하나만 켜진다. */
const GROUP_KINDS = ["ALL", "WEEKDAY", "WEEKEND"] as const;
type GroupKind = (typeof GROUP_KINDS)[number];

const GROUP_LABEL_KEYS: Record<GroupKind, string> = {
  ALL: "master.workCalendar.selectAllDays",
  WEEKDAY: "master.workCalendar.selectWeekdays",
  WEEKEND: "master.workCalendar.selectWeekends",
};

export default function CalendarGrid({
  month,
  days,
  selectedDates,
  onDayClick,
  planCounts,
  onToggleSelect,
  onSelectDates,
  onPlanBadgeClick,
  onBulkEdit,
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

  /** 그 달의 모든 일자 — 확정 일자도 계획 비가동 대상이 될 수 있어 제외하지 않는다. */
  const selectableDays = useMemo(() => {
    const [y, m] = month.split("-").map(Number);
    const lastDate = new Date(y, m, 0).getDate();
    const result: { date: string; dow: number }[] = [];
    for (let d = 1; d <= lastDate; d++) {
      result.push({
        date: `${month}-${String(d).padStart(2, "0")}`,
        dow: new Date(y, m - 1, d).getDay(),
      });
    }
    return result;
  }, [month]);

  const groups = useMemo(
    () => ({
      ALL: selectableDays.map((d) => d.date),
      WEEKDAY: selectableDays.filter((d) => d.dow >= 1 && d.dow <= 5).map((d) => d.date),
      WEEKEND: selectableDays.filter((d) => d.dow === 0 || d.dow === 6).map((d) => d.date),
    }),
    [selectableDays],
  );

  /** 현재 선택이 어느 그룹과 정확히 일치하는지. 어디에도 안 맞으면 셋 다 해제 상태다. */
  const activeGroup = useMemo(
    () =>
      GROUP_KINDS.find(
        (kind) =>
          groups[kind].length > 0 &&
          groups[kind].length === selectedDates.size &&
          groups[kind].every((d) => selectedDates.has(d)),
      ) ?? null,
    [groups, selectedDates],
  );

  // 이미 켜진 그룹을 다시 누르면 선택을 비운다(토글).
  const toggleGroup = (kind: GroupKind) => {
    onSelectDates(activeGroup === kind ? [] : groups[kind]);
  };

  return (
    <div className="flex flex-col gap-3">
      {/* 월 네비게이션 — 화살표는 한 달씩, 가운데 피커는 임의의 년월로 이동 */}
      <div className="flex items-center justify-between">
        <Button variant="ghost" size="sm" onClick={() => changeMonth(-1)} aria-label={t("master.workCalendar.prevMonth")}>
          <ChevronLeft className="w-6 h-6" />
        </Button>
        <Input
          type="month"
          value={month}
          // 피커를 비우면(지우기) 조회 대상이 사라지므로 그때는 현재 월을 유지한다.
          onChange={(e) => { if (e.target.value) onMonthChange(e.target.value); }}
          aria-label={t("master.workCalendar.selectMonth")}
          className="!h-[34px] text-sm font-bold text-center"
        />
        <Button variant="ghost" size="sm" onClick={() => changeMonth(1)} aria-label={t("master.workCalendar.nextMonth")}>
          <ChevronRight className="w-6 h-6" />
        </Button>
      </div>

      {/* 선택 툴바 — 상시 표시. 선택이 없으면 일괄 수정만 비활성 */}
      <div className="flex min-h-[38px] items-center justify-between gap-2 rounded border border-primary/40 bg-primary/5 px-3 py-0.5">
        <span className="text-xs font-medium text-primary">
          {t("master.workCalendar.selectedCount", { count: selectedDates.size })}
        </span>
        <div className="flex items-center gap-1">
          {GROUP_KINDS.map((kind) => (
            <label
              key={kind}
              className="flex cursor-pointer items-center gap-1 pr-1.5 text-xs text-primary"
            >
              <input
                type="checkbox"
                checked={activeGroup === kind}
                onChange={() => toggleGroup(kind)}
                className="w-3.5 h-3.5 cursor-pointer rounded border-border dark:border-gray-600"
              />
              {t(GROUP_LABEL_KEYS[kind])}
            </label>
          ))}
          <Button size="sm" className="!h-7 !px-2.5 !text-xs" disabled={selectedDates.size === 0} onClick={onBulkEdit}>
            {t("master.workCalendar.bulkEdit")}
          </Button>
        </div>
      </div>

      {/* 요일 헤더 */}
      <div className="grid grid-cols-7 gap-1">
        {WEEKDAYS.map((wd) => (
          <div key={wd} className="text-center text-[15px] font-medium text-text-muted dark:text-gray-400 py-1">
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
          const selected = selectedDates.has(ds);
          const planCount = planCounts.get(ds) ?? 0;
          return (
            <div
              key={ds}
              className={`relative h-16 rounded border transition-colors
                ${color} ${selected ? "ring-2 ring-primary" : ""}`}
            >
              <button
                onClick={() => !locked && onDayClick(ds, info ?? null)}
                disabled={locked}
                className={`absolute inset-0 p-1 pr-5 pb-5 text-left flex flex-col rounded
                  ${locked ? "cursor-default opacity-80" : "hover:ring-1 hover:ring-primary cursor-pointer"}`}
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
              {/* 확정 일자에도 체크박스를 낸다 — 계획 비가동은 월력 확정과 별개 업무다 */}
              <input
                type="checkbox"
                checked={selected}
                onChange={() => onToggleSelect(ds)}
                aria-label={ds}
                className="absolute top-1 right-1 z-10 w-3.5 h-3.5 cursor-pointer rounded border-border dark:border-gray-600"
              />
              {/* 계획 비가동 뱃지 — 누르면 그날 목록. 셀 버튼보다 위에 둔다 */}
              {planCount > 0 && (
                <button
                  type="button"
                  onClick={() => onPlanBadgeClick(ds)}
                  title={t("master.workCalendar.planCountTitle", { count: planCount })}
                  className="absolute bottom-1 right-1 z-10 flex items-center gap-0.5 rounded bg-amber-500 px-1 py-0.5 text-[10px] font-medium text-white hover:bg-amber-600"
                >
                  <PauseCircle className="w-3 h-3" />
                  {planCount}
                </button>
              )}
            </div>
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
