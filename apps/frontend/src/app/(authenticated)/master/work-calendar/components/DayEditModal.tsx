"use client";

/**
 * @file master/work-calendar/components/DayEditModal.tsx
 * @description 일자 편집 모달 — 근무유형/휴무사유/교대조별 작업시간/잔업/비작업 시간/비고
 *
 * 초보자 가이드:
 * 0. targetDates가 1건이면 단일 편집, 2건 이상이면 캘린더에서 체크한 일자들의 일괄 수정이다.
 *    일괄 수정은 입력한 값을 선택 일자 전부에 그대로 적용하므로 초기값을 채우지 않는다.
 * 1. 근무유형·휴무사유·교대조·비작업분류는 자유입력이 아니라 공통코드다
 *    (WORK DAY TYPE / DAY OFF TYPE / SHIFT CODE / BREAK TYPE).
 * 2. 휴무사유는 dayType='OFF'일 때만 노출된다.
 * 3. 교대조 시간은 그 일자에 저장된 값이 있으면 그것을, 없으면 교대시간 마스터
 *    (IP_SHIFT_TIME_MASTER)의 주간=A / 야간=B 값을 prefill한다. 저장하면 그 일자만의
 *    예외로 자식 테이블에 남는다.
 * 3-1. 비작업 시간도 같은 규칙이다. 저장값이 없으면 마스터의 주간·야간 비작업분을
 *    분류별로 **합산**해서 채운다(주간 휴게 30 + 야간 휴게 30 → 휴게 60). 일자 편집의
 *    비작업 시간은 교대조별이 아니라 일자 전체 단위이기 때문이다.
 * 4. 근무시간(분)은 더 이상 직접 입력하지 않는다 — Σ(교대조 구간) − Σ(비작업분)으로
 *    파생되며(@smt/shared calendarWorkMinutes), 화면에는 계산 결과만 보여준다.
 *    잔업(OT)은 근무시간에 포함하지 않는 별도 값이다.
 */
import { useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";
import { Modal, Button, Input } from "@/components/ui";
import { ComCodeSelect } from "@/components/shared";
import { useComCodeList } from "@/hooks/useComCode";
import { calendarWorkMinutes } from "@smt/shared";
import type { CalendarBreak, CalendarShift, ShiftTimeItem, WorkCalendarDay, WorkDayType } from "../types";

interface Props {
  isOpen: boolean;
  onClose: () => void;
  /** 편집 대상 일자. 1건이면 단일 편집, 2건 이상이면 일괄 수정 */
  targetDates: string[];
  /** 단일 편집일 때의 초기값. 일괄 수정이면 null */
  currentData: WorkCalendarDay | null;
  /** 교대조 시간 prefill 근거 (IP_SHIFT_TIME_MASTER) */
  shiftTimes: ShiftTimeItem[];
  onSave: (days: (Partial<WorkCalendarDay> & { workDate: string })[]) => void;
}

/** 교대시간 마스터에서 해당 일자에 유효한 행을 고른다. dateend가 없으면 무기한. */
function pickShiftMaster(rows: ShiftTimeItem[], isoDate: string): ShiftTimeItem | null {
  const applicable = rows
    .filter((r) => r.dateset.slice(0, 10) <= isoDate)
    .filter((r) => !r.dateend || isoDate <= r.dateend.slice(0, 10))
    .sort((a, b) => b.dateset.localeCompare(a.dateset));
  return applicable[0] ?? null;
}

/**
 * 교대시간 마스터를 교대조 코드에 매핑한다 — 첫 번째 코드(A=1교대)가 주간,
 * 두 번째 코드(B=2교대)가 야간이다. 마스터에 값이 없으면 빈 문자열로 둬서
 * 담당자가 직접 채우게 한다.
 */
function prefillFromMaster(shiftCodes: string[], master: ShiftTimeItem | null): CalendarShift[] {
  return shiftCodes.map((shiftCode, idx) => {
    const start = idx === 0 ? master?.dayTimeStart : master?.nightTimeStart;
    const end = idx === 0 ? master?.dayTimeEnd : master?.nightTimeEnd;
    return { shiftCode, startTime: start ?? "", endTime: end ?? "" };
  });
}

/**
 * 교대시간 마스터의 슬롯별 비작업분을 분류별로 합산한다.
 * 일자 편집은 비작업 시간을 일자 단위로 다루므로 주간·야간을 더해서 하나로 만든다.
 */
function sumMasterBreaks(master: ShiftTimeItem | null, breakTypes: string[]): Record<string, number> {
  const total: Record<string, number> = {};
  for (const type of breakTypes) total[type] = 0;
  for (const b of [...(master?.dayBreaks ?? []), ...(master?.nightBreaks ?? [])]) {
    if (b.breakType in total) total[b.breakType] += b.breakMinutes;
  }
  return total;
}

export default function DayEditModal({
  isOpen,
  onClose,
  targetDates,
  currentData,
  shiftTimes,
  onSave,
}: Props) {
  const { t } = useTranslation();

  const shiftCodeList = useComCodeList("SHIFT CODE");
  const breakTypeList = useComCodeList("BREAK TYPE");

  const [dayType, setDayType] = useState<WorkDayType>("WORK");
  const [offReason, setOffReason] = useState("");
  const [shifts, setShifts] = useState<CalendarShift[]>([]);
  const [otMinutes, setOtMinutes] = useState("0");
  const [breakMinutes, setBreakMinutes] = useState<Record<string, string>>({});
  const [comment, setComment] = useState("");

  // 일괄 수정은 대상이 여러 날이라 특정 일자의 마스터를 고를 수 없다 — 첫 일자를 기준으로 삼는다.
  const baseDate = targetDates[0] ?? "";

  useEffect(() => {
    if (!isOpen) return;
    setDayType((currentData?.dayType as WorkDayType) ?? "WORK");
    setOffReason(currentData?.offReason ?? "");
    setOtMinutes(String(currentData?.otMinutes ?? 0));
    setComment(currentData?.comment ?? "");

    const codes = shiftCodeList.map((c) => c.detailCode);
    const saved = currentData?.shifts ?? [];
    // 저장된 값이 있으면 그것이 이기고, 없는 교대조는 마스터 기본값으로 채운다.
    const prefilled = prefillFromMaster(codes, pickShiftMaster(shiftTimes, baseDate));
    setShifts(
      prefilled.map((p) => saved.find((s) => s.shiftCode === p.shiftCode) ?? p),
    );

    // 저장값이 있으면 그것이 이기고, 없으면 마스터의 주간+야간 합을 prefill한다.
    const savedBreaks = currentData?.breaks ?? [];
    const types = breakTypeList.map((b) => b.detailCode);
    const fromMaster = sumMasterBreaks(pickShiftMaster(shiftTimes, baseDate), types);
    const next: Record<string, string> = {};
    for (const type of types) {
      const found = savedBreaks.find((x) => x.breakType === type);
      next[type] = String(found?.breakMinutes ?? fromMaster[type] ?? 0);
    }
    setBreakMinutes(next);
  }, [isOpen, currentData, shiftCodeList, breakTypeList, shiftTimes, baseDate]);

  const breaks = useMemo<CalendarBreak[]>(
    () =>
      breakTypeList.map((b) => ({
        breakType: b.detailCode,
        breakMinutes: Number(breakMinutes[b.detailCode]) || 0,
      })),
    [breakTypeList, breakMinutes],
  );

  // 저장될 근무분과 같은 식이다 — 서버도 @smt/shared의 같은 함수로 다시 계산한다.
  const derivedWorkMinutes = useMemo(
    () => calendarWorkMinutes(dayType, shifts, breaks),
    [dayType, shifts, breaks],
  );

  if (targetDates.length === 0) return null;

  const isBulk = targetDates.length > 1;

  const setShiftField = (shiftCode: string, field: "startTime" | "endTime", value: string) => {
    setShifts((prev) =>
      prev.map((s) => (s.shiftCode === shiftCode ? { ...s, [field]: value } : s)),
    );
  };

  const handleSave = () => {
    const base: Partial<WorkCalendarDay> = {
      dayType,
      offReason: dayType === "OFF" ? (offReason || null) : null,
      otMinutes: Number(otMinutes) || 0,
      comment: comment || null,
      // 시각이 비어 있는 교대조는 보내지 않는다 — 그 교대조는 운영하지 않는다는 뜻이다.
      shifts: shifts.filter((s) => s.startTime && s.endTime),
      breaks,
    };
    onSave(targetDates.map((workDate) => ({ ...base, workDate })));
  };

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title={
        isBulk
          ? t("master.workCalendar.bulkEditTitle", { count: targetDates.length })
          : `${t("master.workCalendar.editDay")} — ${targetDates[0]}`
      }
      headerActions={
        <>
          <Button variant="secondary" size="sm" onClick={onClose}>{t("common.cancel")}</Button>
          <Button size="sm" onClick={handleSave}>{t("common.save")}</Button>
        </>
      }
    >
      <div className="space-y-4">
        {isBulk && (
          <p className="rounded border border-primary/40 bg-primary/5 px-3 py-2 text-xs text-primary">
            {t("master.workCalendar.bulkEditHint", { count: targetDates.length })}
          </p>
        )}

        <div>
          <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
            {t("master.workCalendar.dayType")}
          </label>
          <ComCodeSelect
            groupCode="WORK_DAY_TYPE"
            includeAll={false}
            value={dayType}
            onChange={(v) => setDayType(v as WorkDayType)}
            fullWidth
          />
        </div>

        {dayType === "OFF" && (
          <div>
            <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
              {t("master.workCalendar.offReason")}
            </label>
            <ComCodeSelect
              groupCode="DAY_OFF_TYPE"
              includeAll={false}
              value={offReason}
              onChange={setOffReason}
              fullWidth
            />
          </div>
        )}

        {/* 교대조별 작업시간 — 공통코드 'SHIFT CODE'의 코드 수만큼 행이 생긴다 */}
        <div>
          <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
            {t("master.workCalendar.shiftWorkTime")}
          </label>
          <div className="space-y-2 rounded border border-border dark:border-gray-700 p-2">
            {shifts.length === 0 ? (
              <p className="text-xs text-text-muted dark:text-gray-400">
                {t("master.workCalendar.noShiftCodes")}
              </p>
            ) : (
              shifts.map((s) => {
                const label = shiftCodeList.find((c) => c.detailCode === s.shiftCode)?.codeName;
                return (
                  <div key={s.shiftCode} className="flex items-center gap-2">
                    <span className="w-20 flex-shrink-0 text-xs text-text dark:text-gray-200">
                      {label ?? s.shiftCode}
                    </span>
                    <Input
                      type="time"
                      value={s.startTime}
                      onChange={(e) => setShiftField(s.shiftCode, "startTime", e.target.value)}
                      fullWidth
                    />
                    <span className="text-xs text-text-muted dark:text-gray-400">~</span>
                    <Input
                      type="time"
                      value={s.endTime}
                      onChange={(e) => setShiftField(s.shiftCode, "endTime", e.target.value)}
                      fullWidth
                    />
                  </div>
                );
              })
            )}
          </div>
        </div>

        <div>
          <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
            {t("master.workCalendar.otMinutes")}
          </label>
          <Input
            type="number"
            min={0}
            value={otMinutes}
            onChange={(e) => setOtMinutes(e.target.value)}
            fullWidth
          />
        </div>

        {/* 비작업 시간 — 공통코드 'BREAK TYPE'의 분류별 분 입력 */}
        <div>
          <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
            {t("master.workCalendar.breakTime")}
          </label>
          <div className="space-y-2 rounded border border-border dark:border-gray-700 p-2">
            {breakTypeList.length === 0 ? (
              <p className="text-xs text-text-muted dark:text-gray-400">
                {t("master.workCalendar.noBreakTypes")}
              </p>
            ) : (
              breakTypeList.map((b) => (
                <div key={b.detailCode} className="flex items-center gap-2">
                  <span className="w-20 flex-shrink-0 text-xs text-text dark:text-gray-200">
                    {b.codeName}
                  </span>
                  <Input
                    type="number"
                    min={0}
                    value={breakMinutes[b.detailCode] ?? "0"}
                    onChange={(e) =>
                      setBreakMinutes((prev) => ({ ...prev, [b.detailCode]: e.target.value }))
                    }
                    fullWidth
                  />
                </div>
              ))
            )}
          </div>
        </div>

        {/* 근무시간은 입력이 아니라 파생값이다 */}
        <div className="flex items-center justify-between rounded bg-surface dark:bg-slate-800 px-3 py-2">
          <span className="text-sm text-text-muted dark:text-gray-400">
            {t("master.workCalendar.derivedWorkMinutes")}
          </span>
          <b className="text-sm text-text dark:text-gray-100">
            {derivedWorkMinutes.toLocaleString()}
          </b>
        </div>

        <div>
          <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
            {t("master.workCalendar.remark")}
          </label>
          <Input value={comment} onChange={(e) => setComment(e.target.value)} fullWidth />
        </div>
      </div>
    </Modal>
  );
}
