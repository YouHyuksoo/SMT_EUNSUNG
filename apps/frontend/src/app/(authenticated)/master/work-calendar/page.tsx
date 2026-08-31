"use client";

/**
 * @file master/work-calendar/page.tsx
 * @description 생산월력관리 — 전사 월력 + 라인 예외 + 2교대 시간 마스터
 *
 * 초보자 가이드:
 * 1. 좌측: 연도 + 라인 선택(전사 / 특정 라인). 라인을 고르면 라인 예외 월력을 편집한다.
 * 2. 우측: 월 그리드 — 날짜 클릭 시 DayEditModal. 확정된 일자는 잠긴다.
 *    셀 체크박스로 여러 날짜를 고르면 같은 모달로 일괄 수정한다(PUT days/bulk 한 번).
 * 3. 상단 버튼: 연간 생성 / 전사에서 복사(라인 모드) / 확정 / 확정취소.
 * 4. 교대시간 탭: IP_SHIFT_TIME_MASTER 유효기간 행 CRUD.
 */
import { useState, useEffect, useCallback, useMemo, useRef } from "react";
import { useTranslation } from "react-i18next";
import { Calendar, RefreshCw, CalendarPlus, Lock, Unlock } from "lucide-react";
import { Card, CardContent, Button, ConfirmModal } from "@/components/ui";
import api from "@/services/api";
import CalendarGrid from "./components/CalendarGrid";
import DayEditModal from "./components/DayEditModal";
import PlanDowntimeListModal from "./components/PlanDowntimeListModal";
import PlanDowntimePanel from "./components/PlanDowntimePanel";
import ShiftTimeTab from "./components/ShiftTimeTab";
import type { WorkCalendarDay, PlanDowntime, ShiftTimeItem } from "./types";

type TabType = "calendar" | "shift";
type TopAction = "generate" | "confirm" | "unconfirm" | null;

export default function WorkCalendarPage() {
  const { t } = useTranslation();

  const [activeTab, setActiveTab] = useState<TabType>("calendar");
  const [currentMonth, setCurrentMonth] = useState(() => {
    const now = new Date();
    return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}`;
  });
  // 캘린더 셀 체크박스로 고른 일자(YYYY-MM-DD). 월/라인이 바뀌면 비운다.
  const [selectedDates, setSelectedDates] = useState<Set<string>>(new Set());
  // 연도는 표시 중인 월(currentMonth)에서 파생한다 — 월 그리드가 연도 경계를 넘어가도
  // year가 화면에 보이는 월과 어긋날 수 없다(Bug 3: 일괄작업 대상연도 불일치 방지).
  const year = useMemo(() => currentMonth.split("-")[0], [currentMonth]);

  const [days, setDays] = useState<WorkCalendarDay[]>([]);
  const [shiftTimes, setShiftTimes] = useState<ShiftTimeItem[]>([]);
  const [loading, setLoading] = useState(false);

  // 표시 중인 달의 계획 비가동. 캘린더 뱃지와 일자별 목록 모달이 함께 쓴다.
  const [planDowntimes, setPlanDowntimes] = useState<PlanDowntime[]>([]);
  const [planModalDate, setPlanModalDate] = useState<string | null>(null);

  // 편집 대상 일자. 1건이면 단일 편집(data=기존 값), 여러 건이면 체크박스 일괄 수정(data=null).
  const [editTargets, setEditTargets] = useState<{ dates: string[]; data: WorkCalendarDay | null } | null>(null);
  const [topAction, setTopAction] = useState<TopAction>(null);
  const [genSatWork, setGenSatWork] = useState(false);
  const [genSunWork, setGenSunWork] = useState(false);

  const changeMonth = useCallback((m: string) => {
    setCurrentMonth(m);
    setSelectedDates(new Set());
  }, []);


  /* ── 조회 ──
   * 각 로더는 자체 AbortController + 단조증가 requestGeneration을 갖는다.
   * 이전 요청을 abort하고, 응답이 와도 최신 generation이 아니면 state를 덮어쓰지 않는다.
   * (routing/components/RoutingGroupManager.tsx, RoutingMaterialEditor.tsx와 동일한 패턴)
   */
  const daysRequestGeneration = useRef(0);
  const daysRequestController = useRef<AbortController | null>(null);
  const shiftRequestGeneration = useRef(0);
  const shiftRequestController = useRef<AbortController | null>(null);

  const fetchDays = useCallback(async () => {
    daysRequestController.current?.abort();
    const controller = new AbortController();
    daysRequestController.current = controller;
    const generation = ++daysRequestGeneration.current;
    setLoading(true);
    try {
      const res = await api.get(`/master/work-calendar/days?month=${currentMonth}`, { signal: controller.signal });
      if (generation !== daysRequestGeneration.current) return;
      setDays(res.data?.data ?? []);
    } catch {
      if (!controller.signal.aborted && generation === daysRequestGeneration.current) setDays([]);
    } finally {
      if (generation === daysRequestGeneration.current) setLoading(false);
    }
  }, [currentMonth]);

  const fetchShiftTimes = useCallback(async () => {
    shiftRequestController.current?.abort();
    const controller = new AbortController();
    shiftRequestController.current = controller;
    const generation = ++shiftRequestGeneration.current;
    try {
      const res = await api.get("/master/shift-times", { signal: controller.signal });
      if (generation !== shiftRequestGeneration.current) return;
      setShiftTimes(res.data?.data ?? []);
    } catch { /* interceptor */ }
  }, []);

  const toggleSelect = useCallback((date: string) => {
    setSelectedDates((prev) => {
      const next = new Set(prev);
      if (next.has(date)) next.delete(date); else next.add(date);
      return next;
    });
  }, []);

  const fetchPlanDowntimes = useCallback(async () => {
    const [y, m] = currentMonth.split("-").map(Number);
    const last = String(new Date(y, m, 0).getDate()).padStart(2, "0");
    try {
      const res = await api.get("/oee/work-result/downtimes/plan", {
        params: { from: `${currentMonth}-01`, to: `${currentMonth}-${last}` },
      });
      setPlanDowntimes(res.data?.data?.list ?? []);
    } catch { setPlanDowntimes([]); }
  }, [currentMonth]);

  useEffect(() => { void fetchPlanDowntimes(); }, [fetchPlanDowntimes]);

  /** 일자 → 계획 비가동 건수 (캘린더 뱃지) */
  const planCounts = useMemo(() => {
    const m = new Map<string, number>();
    for (const p of planDowntimes) m.set(p.planDate, (m.get(p.planDate) ?? 0) + 1);
    return m;
  }, [planDowntimes]);

  /** 등록 패널에 넘길 체크된 일자 (정렬된 배열) */
  const selectedDateList = useMemo(() => [...selectedDates].sort(), [selectedDates]);

  /**
   * 계획 비가동 등록 성공 후 — 뱃지를 다시 읽고 캘린더 선택을 비운다.
   * 선택을 남겨두면 같은 날짜에 실수로 다시 등록(= 기존 계획 덮어쓰기)하기 쉽다.
   */
  const handlePlanRegistered = useCallback(async () => {
    setSelectedDates(new Set());
    await fetchPlanDowntimes();
  }, [fetchPlanDowntimes]);

  useEffect(() => { void fetchDays(); return () => daysRequestController.current?.abort(); }, [fetchDays]);
  useEffect(() => { void fetchShiftTimes(); return () => shiftRequestController.current?.abort(); }, [fetchShiftTimes]);

  /* ── 쓰기 ── */
  const refreshAll = useCallback(async () => {
    await fetchDays();
  }, [fetchDays]);

  const handleDaySave = useCallback(async (days: Partial<WorkCalendarDay>[]) => {
    try {
      await api.put("/master/work-calendar/days/bulk", {
        days,
      });
      setEditTargets(null);
      setSelectedDates(new Set());
      await refreshAll();
    } catch { /* interceptor */ }
  }, [refreshAll]);

  const handleGenerate = useCallback(async () => {
    try {
      await api.post("/master/work-calendar/generate", {
        year,
        saturdayWork: genSatWork,
        sundayWork: genSunWork,
        applyHolidays: true,
      });
      await refreshAll();
    } catch { /* interceptor */ } finally { setTopAction(null); }
  }, [year, genSatWork, genSunWork, refreshAll]);

  const handleConfirm = useCallback(async (confirmed: boolean) => {
    try {
      await api.post(`/master/work-calendar/${confirmed ? "confirm" : "unconfirm"}`, {
        year,
      });
      await refreshAll();
    } catch { /* interceptor */ } finally { setTopAction(null); }
  }, [year, refreshAll]);

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
          {/* 좌측: 설비 계획 비가동 등록 (설비/라인 · 사유 · 시간) */}
          <div className="col-span-4 flex flex-col min-h-0 overflow-y-auto">
            <PlanDowntimePanel
              selectedDates={selectedDateList}
              onRegistered={handlePlanRegistered}
            />
          </div>

          {/* 우측: 월 그리드 */}
          <div className="col-span-8 flex flex-col min-h-0">
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
                    selectedDates={selectedDates}
                    planCounts={planCounts}
                    onPlanBadgeClick={setPlanModalDate}
                    onDayClick={(date, day) => setEditTargets({ dates: [date], data: day })}
                    onToggleSelect={toggleSelect}
                    onSelectDates={(dates) => setSelectedDates(new Set(dates))}
                    onBulkEdit={() => setEditTargets({ dates: [...selectedDates].sort(), data: null })}
                    onMonthChange={changeMonth}
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
        isOpen={editTargets !== null}
        onClose={() => setEditTargets(null)}
        targetDates={editTargets?.dates ?? []}
        currentData={editTargets?.data ?? null}
        shiftTimes={shiftTimes}
        onSave={handleDaySave}
      />

      <PlanDowntimeListModal
        isOpen={planModalDate !== null}
        onClose={() => setPlanModalDate(null)}
        date={planModalDate}
        rows={planDowntimes.filter((p) => p.planDate === planModalDate)}
        onChanged={fetchPlanDowntimes}
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
