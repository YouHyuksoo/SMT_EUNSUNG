"use client";

/**
 * @file master/work-calendar/components/DayEditModal.tsx
 * @description 일자 편집 모달 — 근무유형/휴무사유/근무분/잔업분/비고
 *
 * 초보자 가이드:
 * 1. 근무유형·휴무사유는 자유입력이 아니라 공통코드(WORK_DAY_TYPE / DAY_OFF_TYPE)다.
 * 2. 휴무사유는 dayType='OFF'일 때만 노출된다.
 * 3. 근무분을 비워두면(빈 문자열) 저장 시 키 자체를 보내지 않아 서버가 @smt/shared의
 *    defaultWorkMinutes 규칙(교대시간 마스터 기준)으로 자동 파생한다. 값을 입력하면
 *    그 값이 명시적 override로 저장된다. 근무유형을 바꾸면 이전 값은 더 이상 유효하지
 *    않으므로 필드를 비워 자동계산으로 되돌린다.
 */
import { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { Modal, Button, Input } from "@/components/ui";
import { ComCodeSelect } from "@/components/shared";
import type { WorkCalendarDay, WorkDayType } from "../types";

interface Props {
  isOpen: boolean;
  onClose: () => void;
  selectedDate: string | null;
  currentData: WorkCalendarDay | null;
  onSave: (day: Partial<WorkCalendarDay> & { workDate: string }) => void;
}

export default function DayEditModal({ isOpen, onClose, selectedDate, currentData, onSave }: Props) {
  const { t } = useTranslation();

  const [dayType, setDayType] = useState<WorkDayType>("WORK");
  const [offReason, setOffReason] = useState("");
  const [workMinutes, setWorkMinutes] = useState("");
  const [otMinutes, setOtMinutes] = useState("0");
  const [comment, setComment] = useState("");

  useEffect(() => {
    if (!isOpen) return;
    setDayType((currentData?.dayType as WorkDayType) ?? "WORK");
    setOffReason(currentData?.offReason ?? "");
    // 기존 값이 없으면 비워 둔다 → 저장 시 키 생략 → 서버가 교대시간 마스터로 자동 파생.
    setWorkMinutes(currentData?.workMinutes != null ? String(currentData.workMinutes) : "");
    setOtMinutes(String(currentData?.otMinutes ?? 0));
    setComment(currentData?.comment ?? "");
  }, [isOpen, currentData]);

  if (!selectedDate) return null;

  // 근무유형이 바뀌면 이전 근무유형 기준 근무분은 더 이상 유효하지 않다.
  // 필드를 비워 자동계산(서버 파생)으로 되돌린다.
  const handleDayTypeChange = (v: string) => {
    setDayType(v as WorkDayType);
    setWorkMinutes("");
  };

  const handleSave = () => {
    const payload: Partial<WorkCalendarDay> & { workDate: string } = {
      workDate: selectedDate,
      dayType,
      offReason: dayType === "OFF" ? (offReason || null) : null,
      otMinutes: Number(otMinutes) || 0,
      comment: comment || null,
    };
    // 근무분을 비우면 키를 보내지 않아 서버가 교대시간 마스터에서 파생시킨다(Task 5 buildRow).
    if (workMinutes !== "") payload.workMinutes = Number(workMinutes) || 0;
    onSave(payload);
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title={`${t("master.workCalendar.editDay")} — ${selectedDate}`}>
      <div className="space-y-4">
        <div>
          <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
            {t("master.workCalendar.dayType")}
          </label>
          <ComCodeSelect
            groupCode="WORK_DAY_TYPE"
            includeAll={false}
            value={dayType}
            onChange={handleDayTypeChange}
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

        <div className="grid grid-cols-2 gap-3">
          <div>
            <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
              {t("master.workCalendar.workMinutes")}
            </label>
            <Input type="number" min={0} value={workMinutes}
              onChange={(e) => setWorkMinutes(e.target.value)}
              placeholder={t("master.workCalendar.workMinutesAutoPlaceholder")}
              fullWidth />
          </div>
          <div>
            <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
              {t("master.workCalendar.otMinutes")}
            </label>
            <Input type="number" min={0} value={otMinutes}
              onChange={(e) => setOtMinutes(e.target.value)} fullWidth />
          </div>
        </div>

        <div>
          <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
            {t("master.workCalendar.remark")}
          </label>
          <Input value={comment} onChange={(e) => setComment(e.target.value)} fullWidth />
        </div>

        <div className="flex justify-end gap-2 pt-2">
          <Button variant="secondary" onClick={onClose}>{t("common.cancel")}</Button>
          <Button onClick={handleSave}>{t("common.save")}</Button>
        </div>
      </div>
    </Modal>
  );
}
