"use client";

/**
 * @file master/work-calendar/components/PlanDowntimeListModal.tsx
 * @description 일자별 계획 비가동 목록 — 캘린더 ⏸뱃지를 누르면 열린다. 건별 삭제만 한다.
 *
 * 초보자 가이드:
 * 1. 수정 기능은 없다. 같은 일자·설비에 다시 등록하면 서버가 기존 계획(PLAN)을 덮어쓴다.
 * 2. 여기서 지우는 것은 IP_EQUIP_DOWNTIME_RESULT 행이다 — 설비 운영 현황·설비작업실적이
 *    보는 것과 같은 데이터다.
 */
import { useState } from "react";
import { useTranslation } from "react-i18next";
import { Trash2 } from "lucide-react";
import toast from "react-hot-toast";
import { Modal } from "@/components/ui";
import api from "@/services/api";
import type { PlanDowntime } from "../types";

interface Props {
  isOpen: boolean;
  onClose: () => void;
  /** 대상 일자 'YYYY-MM-DD' */
  date: string | null;
  rows: PlanDowntime[];
  /** 삭제 후 부모가 목록·뱃지를 다시 읽도록 */
  onChanged: () => void;
}

export default function PlanDowntimeListModal({ isOpen, onClose, date, rows, onChanged }: Props) {
  const { t } = useTranslation();
  const [busySeq, setBusySeq] = useState<number | null>(null);

  const remove = async (dtSeq: number) => {
    setBusySeq(dtSeq);
    try {
      await api.delete(`/oee/work-result/downtimes/${dtSeq}`);
      toast.success(t("master.workCalendar.planDeleted"));
      onChanged();
    } catch { /* interceptor */ } finally { setBusySeq(null); }
  };

  if (!date) return null;

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title={`${t("master.workCalendar.planDowntimeList")} — ${date}`}
    >
      {rows.length === 0 ? (
        <p className="py-6 text-center text-sm text-text-muted dark:text-gray-400">
          {t("master.workCalendar.noPlanDowntime")}
        </p>
      ) : (
        <div className="space-y-1">
          {rows.map((r) => (
            <div key={r.dtSeq}
              className="flex items-center gap-2 rounded border border-border dark:border-gray-700 px-2 py-1.5">
              <div className="min-w-0 flex-1">
                <p className="text-sm text-text dark:text-gray-200 truncate">
                  <span className="font-mono text-xs">{r.machineCode}</span>
                  {r.machineName && <span className="ml-1 text-text-muted dark:text-gray-400">{r.machineName}</span>}
                </p>
                <p className="text-xs text-text-muted dark:text-gray-400">
                  {r.reasonName ?? r.reasonCode} · {r.startHm} ~ {r.endHm}
                </p>
              </div>
              <button
                onClick={() => remove(r.dtSeq)}
                disabled={busySeq === r.dtSeq}
                title={t("common.delete")}
                className="p-1.5 rounded text-red-500 hover:bg-red-100 dark:hover:bg-red-900/30 disabled:opacity-40"
              >
                <Trash2 className="w-4 h-4" />
              </button>
            </div>
          ))}
        </div>
      )}
    </Modal>
  );
}
