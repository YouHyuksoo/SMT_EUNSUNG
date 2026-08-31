"use client";

/**
 * @file master/work-calendar/components/PlanDowntimePanel.tsx
 * @description 설비 계획 비가동 등록 패널 — 좌측 3단(설비/라인 · 사유 · 시간)
 *
 * 초보자 가이드:
 * 1. 대상 설비는 두 모드 중 하나로 고른다. [설비]는 전체 목록, [라인]은 콤보로 고른 라인에
 *    배정된 설비만. 모드를 바꾸면 이전 모드의 체크는 비운다(무엇을 고른 건지 헷갈리지 않게).
 * 2. 사유 버튼은 REASON_TYPE='PLAN' 전체다. 설비 매핑과 무관하게 고정이라 설비를 바꿔도
 *    버튼과 선택이 흔들리지 않는다.
 * 3. 자정 넘김은 허용하지 않는다 — 종료 <= 시작이면 등록 버튼이 잠긴다(서버도 400으로 재확인).
 * 4. 등록 대상 일자는 이 패널이 아니라 우측 캘린더의 체크박스가 정한다.
 */
import { useCallback, useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";
import toast from "react-hot-toast";
import { Button, Input, Select } from "@/components/ui";
import api from "@/services/api";
import type { PlanLine, PlanMachine, PlanReason } from "../types";

interface Props {
  /** 캘린더에서 체크한 일자 (YYYY-MM-DD) */
  selectedDates: string[];
  /** 등록 성공 후 부모가 캘린더/뱃지를 다시 읽도록 */
  onRegistered: () => void;
}

type Mode = "MACHINE" | "LINE";

export default function PlanDowntimePanel({ selectedDates, onRegistered }: Props) {
  const { t } = useTranslation();

  const [mode, setMode] = useState<Mode>("MACHINE");
  const [lineCode, setLineCode] = useState("");
  const [lines, setLines] = useState<PlanLine[]>([]);
  const [machines, setMachines] = useState<PlanMachine[]>([]);
  const [checked, setChecked] = useState<Set<string>>(new Set());
  const [codeQuery, setCodeQuery] = useState("");
  const [nameQuery, setNameQuery] = useState("");

  const [reasons, setReasons] = useState<PlanReason[]>([]);
  const [reasonCode, setReasonCode] = useState("");
  const [startHm, setStartHm] = useState("08:00");
  const [endHm, setEndHm] = useState("17:00");
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    api.get("/oee/equip-ops/lines")
      .then((r) => setLines(r.data?.data?.list ?? []))
      .catch(() => setLines([]));
    api.get("/oee/work-result/downtime-reasons", { params: { reasonType: "PLAN" } })
      .then((r) => setReasons(r.data?.data?.list ?? []))
      .catch(() => setReasons([]));
  }, []);

  // 라인 모드에서 라인을 안 고르면 조회하지 않는다 — 전체 설비가 쏟아지는 것을 막는다.
  const machineParams = useMemo(
    () => (mode === "LINE" ? (lineCode ? { lineCode } : null) : {}),
    [mode, lineCode],
  );

  // 조회 조건이 없으면(라인 미선택) 아무것도 부르지 않는다. 목록 비우기는 아래 핸들러가 한다
  // — effect 본문에서 동기 setState를 하면 연쇄 렌더가 된다.
  useEffect(() => {
    if (machineParams === null) return;
    api.get("/oee/equip-ops/machines", { params: machineParams })
      .then((r) => setMachines(r.data?.data?.list ?? []))
      .catch(() => setMachines([]));
  }, [machineParams]);

  const changeMode = (next: Mode) => {
    setMode(next);
    setChecked(new Set());
    // 라인 모드로 가면 라인을 고르기 전까지 보여줄 목록이 없다.
    if (next === "LINE") setMachines([]);
  };

  const changeLine = (v: string) => {
    setLineCode(v);
    setChecked(new Set());
    if (!v) setMachines([]);
  };

  const visible = useMemo(() => {
    const code = codeQuery.trim().toUpperCase();
    const name = nameQuery.trim().toUpperCase();
    return machines.filter(
      (m) =>
        (!code || m.machineCode.toUpperCase().includes(code)) &&
        (!name || (m.machineName ?? "").toUpperCase().includes(name)),
    );
  }, [machines, codeQuery, nameQuery]);

  const allVisibleChecked = visible.length > 0 && visible.every((m) => checked.has(m.machineCode));

  const toggleAllVisible = () => {
    setChecked((prev) => {
      const next = new Set(prev);
      if (allVisibleChecked) visible.forEach((m) => next.delete(m.machineCode));
      else visible.forEach((m) => next.add(m.machineCode));
      return next;
    });
  };

  const toggleOne = (machineCode: string) => {
    setChecked((prev) => {
      const next = new Set(prev);
      if (next.has(machineCode)) next.delete(machineCode);
      else next.add(machineCode);
      return next;
    });
  };

  const timeInvalid = endHm <= startHm;
  const canRegister =
    checked.size > 0 && !!reasonCode && selectedDates.length > 0 && !timeInvalid && !busy;

  const register = useCallback(async () => {
    setBusy(true);
    try {
      const res = await api.post("/oee/work-result/downtimes/plan", {
        machineCodes: [...checked],
        reasonCode,
        dates: selectedDates,
        startHm,
        endHm,
      });
      const d = res.data?.data ?? {};
      // 건수는 그대로 덧붙인다 — 특히 '제외'는 기존 비가동과 겹쳐 안 들어간 건이라
      // 알리지 않으면 사용자가 저장된 줄 안다.
      const parts = [t("master.workCalendar.planRegistered", { count: d.inserted ?? 0 })];
      if (d.replaced) parts.push(t("master.workCalendar.planReplaced", { count: d.replaced }));
      if (d.skipped) parts.push(t("master.workCalendar.planSkipped", { count: d.skipped }));
      toast.success(`${t("master.workCalendar.planSaved")} ${parts.join(" · ")}`);
      onRegistered();
    } catch { /* interceptor */ } finally { setBusy(false); }
  }, [checked, reasonCode, selectedDates, startHm, endHm, onRegistered, t]);

  return (
    <div className="flex flex-col gap-3 min-h-0">
      {/* ① 설비 / 라인 선택 */}
      <div className="rounded border border-border dark:border-gray-700 p-2 flex flex-col min-h-0">
        <div className="flex items-center gap-2 mb-2">
          <Button size="sm" variant={mode === "MACHINE" ? "primary" : "secondary"}
            className="!h-7 !px-3 !text-xs" onClick={() => changeMode("MACHINE")}>
            {t("master.workCalendar.byMachine")}
          </Button>
          <Button size="sm" variant={mode === "LINE" ? "primary" : "secondary"}
            className="!h-7 !px-3 !text-xs" onClick={() => changeMode("LINE")}>
            {t("master.workCalendar.byLine")}
          </Button>
          <Select
            value={lineCode}
            onChange={changeLine}
            disabled={mode !== "LINE"}
            className="!h-7 !text-xs flex-1"
            options={[
              { value: "", label: t("master.workCalendar.selectLine") },
              ...lines.map((l) => ({
                value: l.lineCode,
                label: `${l.lineName ?? l.lineCode} (${l.machineCount})`,
              })),
            ]}
          />
        </div>

        {/* 검색행 고정 + 설비 목록 */}
        <div className="border border-border dark:border-gray-700 rounded overflow-hidden">
          <div className="grid grid-cols-[28px_1fr_1fr] gap-1 bg-surface dark:bg-slate-800 p-1">
            <input type="checkbox" checked={allVisibleChecked} onChange={toggleAllVisible}
              disabled={visible.length === 0}
              aria-label={t("master.workCalendar.selectAllDays")}
              className="w-3.5 h-3.5 m-auto cursor-pointer rounded border-border dark:border-gray-600" />
            <Input value={codeQuery} onChange={(e) => setCodeQuery(e.target.value)}
              placeholder={t("master.workCalendar.machineCode")} className="!h-6 !text-[11px] !px-1.5" fullWidth />
            <Input value={nameQuery} onChange={(e) => setNameQuery(e.target.value)}
              placeholder={t("master.workCalendar.machineName")} className="!h-6 !text-[11px] !px-1.5" fullWidth />
          </div>
          <div className="max-h-[225px] overflow-y-auto">
            {visible.length === 0 ? (
              <p className="p-3 text-center text-xs text-text-muted dark:text-gray-400">
                {mode === "LINE" && !lineCode
                  ? t("master.workCalendar.pickLineFirst")
                  : t("master.workCalendar.noMachines")}
              </p>
            ) : (
              visible.map((m) => (
                <label key={m.machineCode}
                  className="grid grid-cols-[28px_1fr_1fr] gap-1 items-center px-1 py-1 border-t border-border dark:border-gray-700 cursor-pointer hover:bg-surface dark:hover:bg-slate-800">
                  <input type="checkbox" checked={checked.has(m.machineCode)}
                    onChange={() => toggleOne(m.machineCode)}
                    className="w-3.5 h-3.5 m-auto cursor-pointer rounded border-border dark:border-gray-600" />
                  <span className="text-[11px] font-mono text-text dark:text-gray-200 truncate">{m.machineCode}</span>
                  <span className="text-[11px] text-text-muted dark:text-gray-400 truncate">{m.machineName ?? "-"}</span>
                </label>
              ))
            )}
          </div>
        </div>
        <p className="mt-1 text-[11px] text-primary">
          {t("master.workCalendar.machineChecked", { count: checked.size })}
        </p>
      </div>

      {/* ② 비가동 사유 (계획) */}
      <div className="rounded border border-border dark:border-gray-700 p-2">
        <p className="mb-1.5 text-xs font-medium text-text dark:text-gray-200">
          {t("master.workCalendar.planReason")}
        </p>
        <div className="grid grid-cols-2 gap-2">
          {reasons.map((r) => {
            const active = reasonCode === r.code;
            return (
              <button key={r.code} type="button" onClick={() => setReasonCode(active ? "" : r.code)}
                className={`h-[38px] flex flex-col items-center justify-center px-2 rounded border text-xs text-center transition-colors ${active ? "bg-primary text-white border-primary" : "border-border bg-background text-text hover:border-primary/60"}`}>
                <span className="block font-medium leading-tight">{r.name}</span>
                <span className={`block text-[10px] font-mono ${active ? "text-white/80" : "text-text-muted"}`}>{r.code}</span>
              </button>
            );
          })}
          {reasons.length === 0 && (
            <span className="col-span-2 py-2 text-xs text-text-muted dark:text-gray-400">
              {t("master.workCalendar.noPlanReasons")}
            </span>
          )}
        </div>
      </div>

      {/* ③ 비가동 시간 + 등록 */}
      <div className="rounded border border-border dark:border-gray-700 p-2">
        <p className="mb-1.5 text-xs font-medium text-text dark:text-gray-200">
          {t("master.workCalendar.downtimeSpan")}
          <span className="ml-1 font-normal text-text-muted dark:text-gray-400">
            {t("master.workCalendar.downtimeSpanHint")}
          </span>
        </p>
        <div className="flex items-center gap-2">
          <Input type="time" value={startHm} onChange={(e) => setStartHm(e.target.value)} fullWidth />
          <span className="text-xs text-text-muted dark:text-gray-400">~</span>
          <Input type="time" value={endHm} onChange={(e) => setEndHm(e.target.value)} fullWidth />
        </div>
        {timeInvalid && (
          <p className="mt-1 text-[11px] text-red-500">{t("master.workCalendar.endBeforeStart")}</p>
        )}
        <Button className="mt-2 w-full" disabled={!canRegister} onClick={register}>
          {t("master.workCalendar.registerPlanDowntime")}
        </Button>
        <p className="mt-1 text-[11px] text-text-muted dark:text-gray-400">
          {t("master.workCalendar.planTargetHint", {
            days: selectedDates.length,
            machines: checked.size,
            rows: selectedDates.length * checked.size,
          })}
        </p>
      </div>
    </div>
  );
}
