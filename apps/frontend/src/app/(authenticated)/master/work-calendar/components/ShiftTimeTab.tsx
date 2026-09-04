"use client";

/**
 * @file master/work-calendar/components/ShiftTimeTab.tsx
 * @description 2교대 시간 마스터 탭 — 유효기간(DATESET~DATEEND) 행 CRUD
 *
 * 초보자 가이드:
 * 1. 유효기간이 겹치면 서버가 409로 거부한다.
 * 2. 야간은 자정을 넘길 수 있다(20:00~08:00). 순근무분은 @smt/shared가 계산한다.
 * 3. 비작업 시간은 슬롯(주간/야간) x 공통코드 'BREAK TYPE'별로 입력한다. 마스터의
 *    DAY_BREAK_MINUTES / NIGHT_BREAK_MINUTES는 그 합으로 서버가 갱신하는 롤업이라
 *    화면에서 직접 입력하지 않는다.
 * 4. 등록 모달의 두 시간 행에 교대조명을 붙인다. 공통코드 'SHIFT CODE'의 첫 코드(A=1교대)가
 *    주간(DAY_TIME_*), 두 번째(B=2교대)가 야간(NIGHT_TIME_*)에 대응한다 — DayEditModal의
 *    prefillFromMaster()와 같은 매핑이다. 코드가 없으면 주간/야간 라벨만 쓴다.
 */
import { useCallback, useState } from "react";
import { useTranslation } from "react-i18next";
import { Plus, Pencil, Trash2 } from "lucide-react";
import { Card, CardContent, Button, Input, Modal, ConfirmModal } from "@/components/ui";
import { useComCodeList } from "@/hooks/useComCode";
import { shiftNetMinutes } from "@smt/shared";
import api from "@/services/api";
import type { ShiftTimeBreakItem, ShiftTimeItem } from "../types";

interface Props {
  shiftTimes: ShiftTimeItem[];
  onRefresh: () => void;
}

const EMPTY: ShiftTimeItem = {
  dateset: "",
  dateend: null,
  dayTimeStart: "08:00",
  dayTimeEnd: "20:00",
  dayBreakMinutes: 60,
  nightTimeStart: "20:00",
  nightTimeEnd: "08:00",
  nightBreakMinutes: 60,
  dayBreaks: [],
  nightBreaks: [],
};

/** 분류별 분 맵 ↔ 배열 변환. 화면은 맵으로 다루고 API는 배열로 주고받는다. */
function toMinutesMap(breaks: ShiftTimeBreakItem[], types: string[]): Record<string, string> {
  const map: Record<string, string> = {};
  for (const type of types) {
    map[type] = String(breaks.find((b) => b.breakType === type)?.breakMinutes ?? 0);
  }
  return map;
}

function toBreakList(map: Record<string, string>, types: string[]): ShiftTimeBreakItem[] {
  return types.map((breakType) => ({
    breakType,
    breakMinutes: Number(map[breakType]) || 0,
  }));
}

function netOf(start: string | null, end: string | null, breakMinutes: number): number {
  if (!start || !end) return 0;
  return shiftNetMinutes({ start, end, breakMinutes });
}

export default function ShiftTimeTab({ shiftTimes, onRefresh }: Props) {
  const { t } = useTranslation();
  const shiftCodeList = useComCodeList("SHIFT CODE");
  const breakTypeList = useComCodeList("BREAK TYPE");
  const breakTypes = breakTypeList.map((b) => b.detailCode);

  /** '1교대 (주간)' 형태. 교대조 코드가 없으면 '주간'만 남긴다. */
  const shiftLabel = (index: number, fallbackKey: string) => {
    const base = t(fallbackKey);
    const name = shiftCodeList[index]?.codeName;
    return name ? `${name} (${base})` : base;
  };
  const [form, setForm] = useState<ShiftTimeItem | null>(null);
  // 슬롯별 비작업 분. 입력 중 빈 문자열을 허용해야 해서 숫자가 아니라 문자열로 들고 있다.
  const [dayBreakMap, setDayBreakMap] = useState<Record<string, string>>({});
  const [nightBreakMap, setNightBreakMap] = useState<Record<string, string>>({});
  const [isEdit, setIsEdit] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState<string | null>(null);

  const openForm = useCallback(
    (item: ShiftTimeItem, edit: boolean) => {
      setForm({ ...item });
      setIsEdit(edit);
      setDayBreakMap(toMinutesMap(item.dayBreaks ?? [], breakTypes));
      setNightBreakMap(toMinutesMap(item.nightBreaks ?? [], breakTypes));
    },
    [breakTypes],
  );

  const handleSave = useCallback(async () => {
    if (!form) return;
    try {
      // 휴식분 총합(dayBreakMinutes/nightBreakMinutes)은 보내지 않는다 — 서버가 목록 합으로 롤업한다.
      const payload = {
        dateend: form.dateend,
        dayTimeStart: form.dayTimeStart,
        dayTimeEnd: form.dayTimeEnd,
        nightTimeStart: form.nightTimeStart,
        nightTimeEnd: form.nightTimeEnd,
        dayBreaks: toBreakList(dayBreakMap, breakTypes),
        nightBreaks: toBreakList(nightBreakMap, breakTypes),
      };
      if (isEdit) {
        await api.put(`/master/shift-times/${form.dateset}`, payload);
      } else {
        await api.post("/master/shift-times", { ...payload, dateset: form.dateset });
      }
      setForm(null);
      onRefresh();
    } catch { /* interceptor */ }
  }, [form, isEdit, onRefresh, dayBreakMap, nightBreakMap, breakTypes]);

  const handleDelete = useCallback(async () => {
    if (!deleteTarget) return;
    try {
      await api.delete(`/master/shift-times/${deleteTarget}`);
      setDeleteTarget(null);
      onRefresh();
    } catch { /* interceptor */ }
  }, [deleteTarget, onRefresh]);

  return (
    <Card padding="none">
      <CardContent className="p-4">
        <div className="flex justify-between items-center mb-3">
          <h2 className="text-sm font-bold text-text dark:text-gray-100">
            {t("master.workCalendar.shiftTimes")}
          </h2>
          <Button size="sm" onClick={() => openForm(EMPTY, false)}>
            <Plus className="w-4 h-4 mr-1" />{t("common.add")}
          </Button>
        </div>

        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-border dark:border-gray-700 text-text-muted dark:text-gray-400">
              <th className="px-3 py-2 text-left">{t("master.workCalendar.dateset")}</th>
              <th className="px-3 py-2 text-left">{t("master.workCalendar.dateend")}</th>
              <th className="px-3 py-2 text-left">{t("master.workCalendar.dayShift")}</th>
              <th className="px-3 py-2 text-right">{t("master.workCalendar.dayNet")}</th>
              <th className="px-3 py-2 text-left">{t("master.workCalendar.nightShift")}</th>
              <th className="px-3 py-2 text-right">{t("master.workCalendar.nightNet")}</th>
              <th className="px-3 py-2 text-right">{t("common.actions")}</th>
            </tr>
          </thead>
          <tbody>
            {shiftTimes.length === 0 ? (
              <tr><td colSpan={7} className="py-8 text-center text-text-muted dark:text-gray-400">
                {t("common.noData")}
              </td></tr>
            ) : shiftTimes.map((s) => (
              <tr key={s.dateset} className="border-b border-border dark:border-gray-700">
                <td className="px-3 py-2">{s.dateset}</td>
                <td className="px-3 py-2">{s.dateend ?? "—"}</td>
                <td className="px-3 py-2">{s.dayTimeStart} ~ {s.dayTimeEnd} (휴식 {s.dayBreakMinutes}분)</td>
                <td className="px-3 py-2 text-right">{netOf(s.dayTimeStart, s.dayTimeEnd, s.dayBreakMinutes)}</td>
                <td className="px-3 py-2">
                  {s.nightTimeStart ? `${s.nightTimeStart} ~ ${s.nightTimeEnd} (휴식 ${s.nightBreakMinutes}분)` : "—"}
                </td>
                <td className="px-3 py-2 text-right">{netOf(s.nightTimeStart, s.nightTimeEnd, s.nightBreakMinutes)}</td>
                <td className="px-3 py-2 text-right">
                  <button onClick={() => openForm(s, true)}
                    className="p-1 rounded hover:bg-primary/10 text-primary">
                    <Pencil className="w-3.5 h-3.5" />
                  </button>
                  <button onClick={() => setDeleteTarget(s.dateset)}
                    className="p-1 rounded hover:bg-red-100 dark:hover:bg-red-900/30 text-red-500">
                    <Trash2 className="w-3.5 h-3.5" />
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </CardContent>

      <Modal isOpen={form !== null} onClose={() => setForm(null)}
        title={isEdit ? t("master.workCalendar.editShiftTime") : t("master.workCalendar.addShiftTime")}>
        {form && (
          <div className="space-y-3">
            <div className="grid grid-cols-2 gap-3">
              <div>
                <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
                  {t("master.workCalendar.dateset")}
                </label>
                <Input type="date" value={form.dateset} disabled={isEdit}
                  onChange={(e) => setForm({ ...form, dateset: e.target.value })} fullWidth />
              </div>
              <div>
                <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
                  {t("master.workCalendar.dateend")}
                </label>
                <Input type="date" value={form.dateend ?? ""}
                  onChange={(e) => setForm({ ...form, dateend: e.target.value || null })} fullWidth />
              </div>
            </div>

            <div>
              <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
                {shiftLabel(0, "master.workCalendar.dayShift")}
              </label>
              <div className="grid grid-cols-2 gap-3">
                <Input type="time" value={form.dayTimeStart ?? ""}
                  onChange={(e) => setForm({ ...form, dayTimeStart: e.target.value || null })} fullWidth />
                <Input type="time" value={form.dayTimeEnd ?? ""}
                  onChange={(e) => setForm({ ...form, dayTimeEnd: e.target.value || null })} fullWidth />
              </div>
              {/* 비작업 시간 — 공통코드 'BREAK TYPE' 분류별 분. 합은 서버가 롤업한다. */}
              <div className="mt-2 space-y-2 rounded border border-border dark:border-gray-700 p-2">
                <p className="text-xs text-text-muted dark:text-gray-400">
                  {t("master.workCalendar.breakTime")}
                </p>
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
                      <Input type="number" min={0} value={dayBreakMap[b.detailCode] ?? "0"}
                        onChange={(e) => setDayBreakMap((prev) => ({ ...prev, [b.detailCode]: e.target.value }))}
                        fullWidth />
                    </div>
                  ))
                )}
              </div>
            </div>

            <div>
              <label className="mb-1.5 block text-sm font-medium text-text dark:text-gray-200">
                {shiftLabel(1, "master.workCalendar.nightShift")}
              </label>
              <div className="grid grid-cols-2 gap-3">
                <Input type="time" value={form.nightTimeStart ?? ""}
                  onChange={(e) => setForm({ ...form, nightTimeStart: e.target.value || null })} fullWidth />
                <Input type="time" value={form.nightTimeEnd ?? ""}
                  onChange={(e) => setForm({ ...form, nightTimeEnd: e.target.value || null })} fullWidth />
              </div>
              {/* 비작업 시간 — 공통코드 'BREAK TYPE' 분류별 분. 합은 서버가 롤업한다. */}
              <div className="mt-2 space-y-2 rounded border border-border dark:border-gray-700 p-2">
                <p className="text-xs text-text-muted dark:text-gray-400">
                  {t("master.workCalendar.breakTime")}
                </p>
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
                      <Input type="number" min={0} value={nightBreakMap[b.detailCode] ?? "0"}
                        onChange={(e) => setNightBreakMap((prev) => ({ ...prev, [b.detailCode]: e.target.value }))}
                        fullWidth />
                    </div>
                  ))
                )}
              </div>
            </div>

            <div className="flex justify-end gap-2 pt-2">
              <Button variant="secondary" onClick={() => setForm(null)}>{t("common.cancel")}</Button>
              <Button onClick={handleSave} disabled={!form.dateset}>{t("common.save")}</Button>
            </div>
          </div>
        )}
      </Modal>

      <ConfirmModal isOpen={deleteTarget !== null} onClose={() => setDeleteTarget(null)}
        onConfirm={handleDelete} title={t("common.delete")}
        message={t("master.workCalendar.deleteShiftTimeMsg")} variant="danger" />
    </Card>
  );
}
