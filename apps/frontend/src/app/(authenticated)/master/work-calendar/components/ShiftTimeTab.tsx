"use client";

/**
 * @file master/work-calendar/components/ShiftTimeTab.tsx
 * @description 2교대 시간 마스터 탭 — 유효기간(DATESET~DATEEND) 행 CRUD
 *
 * 초보자 가이드:
 * 1. 유효기간이 겹치면 서버가 409로 거부한다.
 * 2. 야간은 자정을 넘길 수 있다(20:00~08:00). 순근무분은 @smt/shared가 계산한다.
 */
import { useCallback, useState } from "react";
import { useTranslation } from "react-i18next";
import { Plus, Pencil, Trash2 } from "lucide-react";
import { Card, CardContent, Button, Input, Modal, ConfirmModal } from "@/components/ui";
import { shiftNetMinutes } from "@smt/shared";
import api from "@/services/api";
import type { ShiftTimeItem } from "../types";

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
};

function netOf(start: string | null, end: string | null, breakMinutes: number): number {
  if (!start || !end) return 0;
  return shiftNetMinutes({ start, end, breakMinutes });
}

export default function ShiftTimeTab({ shiftTimes, onRefresh }: Props) {
  const { t } = useTranslation();
  const [form, setForm] = useState<ShiftTimeItem | null>(null);
  const [isEdit, setIsEdit] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState<string | null>(null);

  const handleSave = useCallback(async () => {
    if (!form) return;
    try {
      if (isEdit) {
        await api.put(`/master/shift-times/${form.dateset}`, {
          dateend: form.dateend,
          dayTimeStart: form.dayTimeStart,
          dayTimeEnd: form.dayTimeEnd,
          dayBreakMinutes: form.dayBreakMinutes,
          nightTimeStart: form.nightTimeStart,
          nightTimeEnd: form.nightTimeEnd,
          nightBreakMinutes: form.nightBreakMinutes,
        });
      } else {
        await api.post("/master/shift-times", form);
      }
      setForm(null);
      onRefresh();
    } catch { /* interceptor */ }
  }, [form, isEdit, onRefresh]);

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
          <Button size="sm" onClick={() => { setForm({ ...EMPTY }); setIsEdit(false); }}>
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
                  <button onClick={() => { setForm({ ...s }); setIsEdit(true); }}
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

            <div className="grid grid-cols-3 gap-3">
              <Input type="time" value={form.dayTimeStart ?? ""}
                onChange={(e) => setForm({ ...form, dayTimeStart: e.target.value || null })} fullWidth />
              <Input type="time" value={form.dayTimeEnd ?? ""}
                onChange={(e) => setForm({ ...form, dayTimeEnd: e.target.value || null })} fullWidth />
              <Input type="number" min={0} value={String(form.dayBreakMinutes)}
                onChange={(e) => setForm({ ...form, dayBreakMinutes: Number(e.target.value) || 0 })} fullWidth />
            </div>

            <div className="grid grid-cols-3 gap-3">
              <Input type="time" value={form.nightTimeStart ?? ""}
                onChange={(e) => setForm({ ...form, nightTimeStart: e.target.value || null })} fullWidth />
              <Input type="time" value={form.nightTimeEnd ?? ""}
                onChange={(e) => setForm({ ...form, nightTimeEnd: e.target.value || null })} fullWidth />
              <Input type="number" min={0} value={String(form.nightBreakMinutes)}
                onChange={(e) => setForm({ ...form, nightBreakMinutes: Number(e.target.value) || 0 })} fullWidth />
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
