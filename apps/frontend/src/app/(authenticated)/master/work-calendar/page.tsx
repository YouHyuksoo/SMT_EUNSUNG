"use client";

/**
 * @file master/work-calendar/page.tsx
 * @description 생산월력관리 — 전사 월력 + 라인 예외 + 2교대 시간 마스터
 *
 * 초보자 가이드:
 * 1. 좌측: 연도 + 라인 선택(전사 / 특정 라인). 라인을 고르면 라인 예외 월력을 편집한다.
 * 2. 우측: 월 그리드 — 날짜 클릭 시 DayEditModal. 확정된 일자는 잠긴다.
 * 3. 상단 버튼: 연간 생성 / 전사에서 복사(라인 모드) / 확정 / 확정취소.
 * 4. 교대시간 탭: IP_SHIFT_TIME_MASTER 유효기간 행 CRUD.
 */
import { useState, useEffect, useCallback, useMemo } from "react";
import { useTranslation } from "react-i18next";
import { Calendar, RefreshCw, CalendarPlus, Copy, Lock, Unlock } from "lucide-react";
import { Card, CardContent, Button, Input, ConfirmModal } from "@/components/ui";
import { LineSelect } from "@/components/shared";
import api from "@/services/api";
import CalendarGrid from "./components/CalendarGrid";
import DayEditModal from "./components/DayEditModal";
import ShiftTimeTab from "./components/ShiftTimeTab";
import type { WorkCalendarDay, ShiftTimeItem, WorkCalendarSummary } from "./types";

type TabType = "calendar" | "shift";
type TopAction = "generate" | "copy" | "confirm" | "unconfirm" | null;

export default function WorkCalendarPage() {
  const { t } = useTranslation();

  const [activeTab, setActiveTab] = useState<TabType>("calendar");
  const [lineCode, setLineCode] = useState("");
  const [currentMonth, setCurrentMonth] = useState(() => {
    const now = new Date();
    return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}`;
  });
  // 연도는 표시 중인 월(currentMonth)에서 파생한다 — 월 그리드가 연도 경계를 넘어가도
  // year가 화면에 보이는 월과 어긋날 수 없다(Bug 3: 일괄작업 대상연도 불일치 방지).
  const year = useMemo(() => currentMonth.split("-")[0], [currentMonth]);
  const handleYearChange = useCallback((v: string) => {
    const y = v.replace(/\D/g, "").slice(0, 4);
    if (!y) return; // 빈 연도로는 currentMonth를 만들 수 없다 — 그대로 무시한다.
    setCurrentMonth((prev) => `${y}-${prev.split("-")[1]}`);
  }, []);

  const [days, setDays] = useState<WorkCalendarDay[]>([]);
  const [summary, setSummary] = useState<WorkCalendarSummary | null>(null);
  const [shiftTimes, setShiftTimes] = useState<ShiftTimeItem[]>([]);
  const [loading, setLoading] = useState(false);

  const [editingDay, setEditingDay] = useState<{ date: string; data: WorkCalendarDay | null } | null>(null);
  const [topAction, setTopAction] = useState<TopAction>(null);
  const [genSatWork, setGenSatWork] = useState(false);
  const [genSunWork, setGenSunWork] = useState(false);

  const lineParam = useMemo(() => (lineCode ? `&lineCode=${lineCode}` : ""), [lineCode]);

  /* ── 조회 ── */
  const fetchDays = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get(`/master/work-calendar/days?month=${currentMonth}${lineParam}`);
      setDays(res.data?.data ?? []);
    } catch { setDays([]); } finally { setLoading(false); }
  }, [currentMonth, lineParam]);

  const fetchSummary = useCallback(async () => {
    try {
      const res = await api.get(`/master/work-calendar/summary?year=${year}${lineParam}`);
      setSummary(res.data?.data ?? null);
    } catch { setSummary(null); }
  }, [year, lineParam]);

  const fetchShiftTimes = useCallback(async () => {
    try { setShiftTimes((await api.get("/master/shift-times")).data?.data ?? []); }
    catch { /* interceptor */ }
  }, []);

  useEffect(() => { fetchDays(); }, [fetchDays]);
  useEffect(() => { fetchSummary(); }, [fetchSummary]);
  useEffect(() => { fetchShiftTimes(); }, [fetchShiftTimes]);

  /* ── 쓰기 ── */
  const refreshAll = useCallback(async () => {
    await Promise.all([fetchDays(), fetchSummary()]);
  }, [fetchDays, fetchSummary]);

  const handleDaySave = useCallback(async (day: Partial<WorkCalendarDay>) => {
    try {
      await api.put("/master/work-calendar/days/bulk", {
        lineCode: lineCode || undefined,
        days: [day],
      });
      setEditingDay(null);
      await refreshAll();
    } catch { /* interceptor */ }
  }, [lineCode, refreshAll]);

  const handleGenerate = useCallback(async () => {
    try {
      await api.post("/master/work-calendar/generate", {
        year,
        lineCode: lineCode || undefined,
        saturdayWork: genSatWork,
        sundayWork: genSunWork,
        applyHolidays: true,
      });
      await refreshAll();
    } catch { /* interceptor */ } finally { setTopAction(null); }
  }, [year, lineCode, genSatWork, genSunWork, refreshAll]);

  const handleCopyFromCompany = useCallback(async () => {
    if (!lineCode) return;
    try {
      await api.post("/master/work-calendar/copy-from-company", { year, lineCode });
      await refreshAll();
    } catch { /* interceptor */ } finally { setTopAction(null); }
  }, [year, lineCode, refreshAll]);

  const handleConfirm = useCallback(async (confirmed: boolean) => {
    try {
      await api.post(`/master/work-calendar/${confirmed ? "confirm" : "unconfirm"}`, {
        year,
        lineCode: lineCode || undefined,
      });
      await refreshAll();
    } catch { /* interceptor */ } finally { setTopAction(null); }
  }, [year, lineCode, refreshAll]);

  return (
    <div className="h-full flex flex-col overflow-hidden p-6 gap-4 animate-fade-in">
      {/* 헤더 */}
      <div className="flex justify-between items-center flex-shrink-0">
        <div>
          <h1 className="text-xl font-bold text-text dark:text-gray-100 flex items-center gap-2">
            <Calendar className="w-7 h-7 text-primary" />
            {t("master.workCalendar.title")}
          </h1>
          <p className="text-text-muted dark:text-gray-400 mt-1">{t("master.workCalendar.subtitle")}</p>
        </div>
        <div className="flex gap-2">
          <Button variant="secondary" size="sm" onClick={() => { refreshAll(); fetchShiftTimes(); }}>
            <RefreshCw className="w-4 h-4 mr-1" />{t("common.refresh")}
          </Button>
          {activeTab === "calendar" && (
            <>
              <Button variant="secondary" size="sm" onClick={() => setTopAction("generate")}>
                <CalendarPlus className="w-4 h-4 mr-1" />{t("master.workCalendar.generateYear")}
              </Button>
              {lineCode && (
                <Button variant="secondary" size="sm" onClick={() => setTopAction("copy")}>
                  <Copy className="w-4 h-4 mr-1" />{t("master.workCalendar.copyFromCompany")}
                </Button>
              )}
              <Button variant="secondary" size="sm" onClick={() => setTopAction("unconfirm")}>
                <Unlock className="w-4 h-4 mr-1" />{t("master.workCalendar.unconfirm")}
              </Button>
              <Button size="sm" onClick={() => setTopAction("confirm")}>
                <Lock className="w-4 h-4 mr-1" />{t("master.workCalendar.confirm")}
              </Button>
            </>
          )}
        </div>
      </div>

      {/* 탭 */}
      <div className="flex gap-1 flex-shrink-0">
        {(["calendar", "shift"] as const).map((tab) => (
          <button key={tab} onClick={() => setActiveTab(tab)}
            className={`px-4 py-2 text-sm font-medium rounded-t transition-colors
              ${activeTab === tab
                ? "bg-white dark:bg-slate-800 text-primary border-b-2 border-primary"
                : "text-text-muted dark:text-gray-400 hover:text-text dark:hover:text-gray-200"}`}>
            {tab === "calendar"
              ? t("master.workCalendar.calendarManagement")
              : t("master.workCalendar.shiftTimeTab")}
          </button>
        ))}
      </div>

      {activeTab === "calendar" ? (
        <div className="grid grid-cols-12 gap-4 min-h-0 flex-1">
          {/* 좌측: 연도 + 라인 + 요약 */}
          <div className="col-span-3 flex flex-col min-h-0 gap-3">
            <Card padding="none">
              <CardContent className="p-3 space-y-3">
                <div>
                  <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
                    {t("master.workCalendar.year")}
                  </label>
                  <Input value={year} onChange={(e) => handleYearChange(e.target.value)} maxLength={4} fullWidth />
                </div>
                <div>
                  <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
                    {t("master.workCalendar.line")}
                  </label>
                  <LineSelect value={lineCode} onChange={setLineCode} fullWidth />
                  <p className="mt-1 text-xs text-text-muted dark:text-gray-400">
                    {lineCode
                      ? t("master.workCalendar.lineModeHint")
                      : t("master.workCalendar.companyModeHint")}
                  </p>
                </div>
              </CardContent>
            </Card>

            {summary && (
              <Card padding="none">
                <CardContent className="p-3 space-y-1.5 text-sm">
                  <div className="flex justify-between">
                    <span className="text-text-muted dark:text-gray-400">{t("master.workCalendar.workDays")}</span>
                    <b className="text-blue-600 dark:text-blue-400">{summary.workDays}</b>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-text-muted dark:text-gray-400">{t("master.workCalendar.offDays")}</span>
                    <b className="text-red-500 dark:text-red-400">{summary.offDays}</b>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-text-muted dark:text-gray-400">{t("master.workCalendar.halfDays")}</span>
                    <b className="text-yellow-600 dark:text-yellow-400">{summary.halfDays}</b>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-text-muted dark:text-gray-400">{t("master.workCalendar.specialDays")}</span>
                    <b className="text-green-600 dark:text-green-400">{summary.specialDays}</b>
                  </div>
                  <div className="flex justify-between border-t border-border dark:border-gray-700 pt-1.5">
                    <span className="text-text-muted dark:text-gray-400">{t("master.workCalendar.totalMinutes")}</span>
                    <b className="text-text dark:text-gray-200">{summary.totalMinutes.toLocaleString()}</b>
                  </div>
                </CardContent>
              </Card>
            )}
          </div>

          {/* 우측: 월 그리드 */}
          <div className="col-span-9 flex flex-col min-h-0">
            <Card padding="none" className="flex-1 flex flex-col min-h-0">
              <CardContent className="flex-1 flex flex-col min-h-0 p-4 overflow-y-auto">
                {loading ? (
                  <div className="flex justify-center py-8">
                    <RefreshCw className="w-5 h-5 text-primary animate-spin" />
                  </div>
                ) : (
                  <CalendarGrid
                    month={currentMonth}
                    days={days}
                    onDayClick={(date, day) => setEditingDay({ date, data: day })}
                    onMonthChange={setCurrentMonth}
                  />
                )}
              </CardContent>
            </Card>
          </div>
        </div>
      ) : (
        <div className="flex-1 min-h-0 overflow-y-auto">
          <ShiftTimeTab shiftTimes={shiftTimes} onRefresh={fetchShiftTimes} />
        </div>
      )}

      <DayEditModal
        isOpen={editingDay !== null}
        onClose={() => setEditingDay(null)}
        selectedDate={editingDay?.date ?? null}
        currentData={editingDay?.data ?? null}
        onSave={handleDaySave}
      />

      <ConfirmModal
        isOpen={topAction === "generate"}
        onClose={() => setTopAction(null)}
        onConfirm={handleGenerate}
        title={t("master.workCalendar.generateYear")}
        message={
          <div>
            <p className="mb-3">
              {t("master.workCalendar.confirmMsg.generate", "{{year}}년 월력을 생성합니다. 기존 일자는 덮어써집니다. 주말과 양력 고정공휴일만 자동 휴무 처리되며, 설·추석·대체공휴일은 직접 수정해야 합니다.", { year })}
            </p>
            <div className="space-y-2">
              <label className="flex items-center gap-2 text-sm text-text dark:text-gray-200 cursor-pointer">
                <input type="checkbox" checked={genSatWork} onChange={(e) => setGenSatWork(e.target.checked)}
                  className="rounded border-border dark:border-gray-600" />
                {t("master.workCalendar.saturdayWork")}
              </label>
              <label className="flex items-center gap-2 text-sm text-text dark:text-gray-200 cursor-pointer">
                <input type="checkbox" checked={genSunWork} onChange={(e) => setGenSunWork(e.target.checked)}
                  className="rounded border-border dark:border-gray-600" />
                {t("master.workCalendar.sundayWork")}
              </label>
            </div>
          </div>
        }
      />

      <ConfirmModal
        isOpen={topAction === "copy"}
        onClose={() => setTopAction(null)}
        onConfirm={handleCopyFromCompany}
        title={t("master.workCalendar.copyFromCompany")}
        message={t("master.workCalendar.confirmMsg.copy", "전사 {{year}}년 월력을 이 라인으로 복사합니다. 이 라인의 기존 예외는 덮어써집니다.", { year })}
      />

      <ConfirmModal
        isOpen={topAction === "confirm"}
        onClose={() => setTopAction(null)}
        onConfirm={() => handleConfirm(true)}
        title={t("master.workCalendar.confirm")}
        message={t("master.workCalendar.confirmMsg.confirm", "{{year}}년 월력을 확정합니다. 확정 후에는 수정할 수 없습니다.", { year })}
      />

      <ConfirmModal
        isOpen={topAction === "unconfirm"}
        onClose={() => setTopAction(null)}
        onConfirm={() => handleConfirm(false)}
        title={t("master.workCalendar.unconfirm")}
        message={t("master.workCalendar.confirmMsg.unconfirm", "{{year}}년 월력의 확정을 취소하고 다시 수정할 수 있게 합니다.", { year })}
        variant="danger"
      />
    </div>
  );
}
