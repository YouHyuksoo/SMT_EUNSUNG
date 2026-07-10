"use client";

/**
 * @file src/app/(authenticated)/master/process/page.tsx
 * @description 공정관리 페이지 - 좌측 공정 목록 + 우측 배치 설비 목록 (IP_PRODUCT_WORKSTAGE)
 *
 * 초보자 가이드:
 * 1. 좌측: 공정 목록 - 클릭 시 해당 공정 선택
 * 2. 우측: 선택된 공정에 배치된 설비 DataGrid (IMCN_MACHINE.WORKSTAGE_CODE 기준)
 * 3. 공정 CRUD는 우측 슬라이드 패널로 처리
 */
import { useState, useCallback, useMemo, useEffect, useRef } from "react";
import { useTranslation } from "react-i18next";
import { Workflow, RefreshCw } from "lucide-react";
import { Button, Modal, Select, ConfirmModal } from "@/components/ui";
import { useUnsavedGuard } from "@/hooks/useUnsavedGuard";
import api from "@/services/api";
import ProcessList from "./components/ProcessList";
import ProcessEquipGrid from "./components/ProcessEquipGrid";
import { FieldCodeSelect, FieldInput, FieldSelect } from "./components/ProcessFieldHelp";
import type { Equipment, NumericProcessField, Process } from "./types";
import { WILDCARD_CODE } from "./types";

/** 폼에서 숫자 필드를 다룰 때 빈 문자열과 0을 구분하기 위한 변환 */
function toNumberOrNull(raw: string): number | null {
  if (raw.trim() === "") return null;
  const parsed = Number(raw);
  return Number.isNaN(parsed) ? null : parsed;
}

function numberValue(value: number | null | undefined): string {
  return value == null ? "" : String(value);
}

/** 섹션 헤더 - 폼이 길어 시각적 구분이 필요하다 */
function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="space-y-3">
      <h3 className="text-xs font-semibold uppercase tracking-wide text-text-muted border-b border-border pb-1">
        {title}
      </h3>
      <div className="grid grid-cols-2 gap-3">{children}</div>
    </section>
  );
}

export default function ProcessPage() {
  const { t } = useTranslation();

  /* ── 공정 목록 상태 ── */
  const [processes, setProcesses] = useState<Process[]>([]);
  const [loading, setLoading] = useState(false);
  const [selectedCode, setSelectedCode] = useState("");

  /* ── 설비 목록 상태 ── */
  const [equipments, setEquipments] = useState<Equipment[]>([]);
  const [allEquipments, setAllEquipments] = useState<Equipment[]>([]);
  const [equipLoading, setEquipLoading] = useState(false);
  const [allEquipCounts, setAllEquipCounts] = useState<Record<string, number>>({});

  /* ── 패널 상태 ── */
  const [isPanelOpen, setIsPanelOpen] = useState(false);
  const [editingItem, setEditingItem] = useState<Process | null>(null);
  const [formData, setFormData] = useState<Partial<Process>>({});
  const [saving, setSaving] = useState(false);
  const initialFormRef = useRef<Partial<Process>>({});
  const panelAnimateRef = useRef(true);
  const { markDirty, guard, guardModalProps } = useUnsavedGuard();
  const [deleteTarget, setDeleteTarget] = useState<Process | null>(null);
  const [removeEquipmentTarget, setRemoveEquipmentTarget] = useState<Equipment | null>(null);
  const [assignModalOpen, setAssignModalOpen] = useState(false);
  const [assignEquipCode, setAssignEquipCode] = useState("");

  /* ── 공정 목록 조회 ── */
  const fetchProcesses = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get("/master/processes", {
        params: { limit: "5000" },
      });
      if (res.data.success) {
        const data: Process[] = res.data.data || [];
        setProcesses(data);
        setSelectedCode((prev) => prev || (data.length > 0 ? data[0].processCode : ""));
      }
    } catch {
      setProcesses([]);
    } finally {
      setLoading(false);
    }
  }, []);

  /* ── 전체 설비 수 카운트 (공정별) ── */
  const fetchEquipCounts = useCallback(async () => {
    try {
      const res = await api.get("/master/processes/equipment-counts");
      if (res.data.success) {
        setAllEquipCounts(res.data.data || {});
      }
    } catch {
      setAllEquipCounts({});
    }
  }, []);

  const fetchAllEquipments = useCallback(async () => {
    try {
      const res = await api.get("/equipment/equips", {
        params: { limit: "10000", useYn: "Y" },
      });
      if (res.data.success) {
        setAllEquipments(res.data.data || []);
      }
    } catch {
      setAllEquipments([]);
    }
  }, []);

  /* ── 선택된 공정의 설비 목록 조회 ── */
  const fetchEquipments = useCallback(async (processCode: string) => {
    if (!processCode) {
      setEquipments([]);
      return;
    }
    setEquipLoading(true);
    try {
      const res = await api.get(`/master/processes/${encodeURIComponent(processCode)}/equipments`);
      if (res.data.success) {
        setEquipments(res.data.data || []);
      }
    } catch {
      setEquipments([]);
    } finally {
      setEquipLoading(false);
    }
  }, []);

  /* ── 초기 로드 ── */
  useEffect(() => {
    fetchProcesses();
    fetchEquipCounts();
    fetchAllEquipments();
  }, [fetchProcesses, fetchEquipCounts, fetchAllEquipments]);

  /* ── 공정 선택 시 설비 조회 ── */
  useEffect(() => {
    if (selectedCode) {
      fetchEquipments(selectedCode);
    }
  }, [selectedCode, fetchEquipments]);

  const selectedProcess = useMemo(
    () => processes.find((p) => p.processCode === selectedCode),
    [processes, selectedCode],
  );

  /* ── CRUD 핸들러 ── */
  const handleAdd = useCallback(() => {
    guard(() => {
      panelAnimateRef.current = true;
      const init: Partial<Process> = {
        processType: "I",
        sortOrder: 0,
        startYn: "N",
        lineCode: WILDCARD_CODE,
        mesDisplayGroup: WILDCARD_CODE,
      };
      setEditingItem(null);
      setFormData(init);
      initialFormRef.current = init;
      setIsPanelOpen(true);
    });
  }, [guard]);

  const handleEdit = useCallback((item: Process) => {
    guard(() => {
      const init = { ...item };
      setEditingItem(item);
      setFormData(init);
      initialFormRef.current = init;
      setIsPanelOpen(true);
    });
  }, [guard]);

  // 작성 중(저장 안 됨) 여부 계산 후 보고 — 항목 전환 시 유실 방어
  const dirty = useMemo(
    () => isPanelOpen && JSON.stringify(formData) !== JSON.stringify(initialFormRef.current),
    [isPanelOpen, formData],
  );
  useEffect(() => { markDirty(dirty); }, [dirty, markDirty]);

  const isFormValid = Boolean(
    formData.processCode && formData.processName && formData.processType && formData.sortOrder != null,
  );

  const handleSave = useCallback(async () => {
    if (!isFormValid) return;
    setSaving(true);
    try {
      if (editingItem) {
        await api.put(`/master/processes/${encodeURIComponent(editingItem.processCode)}`, formData);
      } else {
        await api.post("/master/processes", formData);
      }
      markDirty(false);
      setIsPanelOpen(false);
      fetchProcesses();
    } catch (e: unknown) {
      console.error("Save failed:", e);
    } finally {
      setSaving(false);
    }
  }, [isFormValid, formData, editingItem, fetchProcesses, markDirty]);

  const handleDeleteConfirm = useCallback(async () => {
    if (!deleteTarget) return;
    try {
      await api.delete(`/master/processes/${encodeURIComponent(deleteTarget.processCode)}`);
      setDeleteTarget(null);
      if (selectedCode === deleteTarget.processCode) {
        setSelectedCode("");
        setEquipments([]);
      }
      fetchProcesses();
      fetchEquipCounts();
    } catch (e: unknown) {
      console.error("Delete failed:", e);
    }
  }, [deleteTarget, selectedCode, fetchProcesses, fetchEquipCounts]);

  const handleRefresh = useCallback(() => {
    fetchProcesses();
    fetchEquipCounts();
    fetchAllEquipments();
    if (selectedCode) fetchEquipments(selectedCode);
  }, [fetchProcesses, fetchEquipCounts, fetchAllEquipments, fetchEquipments, selectedCode]);

  const handleOpenAssign = useCallback(() => {
    setAssignEquipCode("");
    setAssignModalOpen(true);
  }, []);

  const refreshEquipmentViews = useCallback(() => {
    if (selectedCode) fetchEquipments(selectedCode);
    fetchEquipCounts();
    fetchAllEquipments();
  }, [selectedCode, fetchEquipments, fetchEquipCounts, fetchAllEquipments]);

  const handleAssignEquipment = useCallback(async () => {
    if (!selectedCode || !assignEquipCode) return;
    try {
      await api.post(`/master/processes/${encodeURIComponent(selectedCode)}/equipments`, {
        equipCode: assignEquipCode,
      });
      setAssignModalOpen(false);
      setAssignEquipCode("");
      refreshEquipmentViews();
    } catch (e: unknown) {
      console.error("Assign equipment failed:", e);
    }
  }, [selectedCode, assignEquipCode, refreshEquipmentViews]);

  const confirmEquipmentRemoval = useCallback(async () => {
    if (!selectedCode || !removeEquipmentTarget) return;
    try {
      await api.delete(
        `/master/processes/${encodeURIComponent(selectedCode)}/equipments/${encodeURIComponent(removeEquipmentTarget.equipCode)}`,
      );
      setRemoveEquipmentTarget(null);
      refreshEquipmentViews();
    } catch (e: unknown) {
      console.error("Remove equipment failed:", e);
    }
  }, [selectedCode, removeEquipmentTarget, refreshEquipmentViews]);

  /* 설비는 한 공정에만 속한다. 이미 이 공정에 배치된 설비는 후보에서 뺀다. */
  const assignOptions = useMemo(
    () => allEquipments
      .filter((equipment) => !equipments.some((assigned) => assigned.equipCode === equipment.equipCode))
      .map((equipment) => ({
        value: equipment.equipCode,
        label: `${equipment.equipCode} - ${equipment.equipName}`,
      })),
    [allEquipments, equipments],
  );

  const machineOptions = useMemo(
    () => [
      { value: "", label: t("common.none", { defaultValue: "지정 안 함" }) },
      ...allEquipments.map((equipment) => ({
        value: equipment.equipCode,
        label: `${equipment.equipCode} - ${equipment.equipName}`,
      })),
    ],
    [allEquipments, t],
  );

  const ynOptions = useMemo(
    () => [
      { value: "", label: t("common.none", { defaultValue: "지정 안 함" }) },
      { value: "Y", label: t("common.yes", { defaultValue: "예" }) },
      { value: "N", label: t("common.no", { defaultValue: "아니오" }) },
    ],
    [t],
  );

  const setField = useCallback(
    <K extends keyof Process>(key: K, value: Process[K]) =>
      setFormData((prev) => ({ ...prev, [key]: value })),
    [],
  );

  /** 숫자 필드만 골라 공통 렌더 — 라벨/도움말 키가 필드명과 1:1이라 반복을 줄인다 */
  const numberField = (key: NumericProcessField, label: string) => (
    <FieldInput
      field={key}
      label={label}
      type="number"
      value={numberValue(formData[key])}
      onChange={(e) => setField(key, toNumberOrNull(e.target.value))}
    />
  );

  return (
    <div className="h-full flex flex-col overflow-hidden p-6 gap-4 animate-fade-in">
      {/* 헤더 */}
      <div className="flex justify-between items-center flex-shrink-0">
        <div>
          <h1 className="text-xl font-bold text-text flex items-center gap-2">
            <Workflow className="w-7 h-7 text-primary" />
            {t("master.process.title")}
          </h1>
          <p className="text-text-muted mt-1">{t("master.process.subtitle")}</p>
        </div>
        <div className="flex gap-2">
          <Button variant="secondary" size="sm" onClick={handleRefresh}>
            <RefreshCw className={`w-4 h-4 mr-1 ${loading ? "animate-spin" : ""}`} />
            {t("common.refresh")}
          </Button>
        </div>
      </div>

      {/* 본문: 좌측 공정 + 우측 설비 + 슬라이드 패널 */}
      <div className="flex-1 min-h-0 flex overflow-hidden">
        <div className="flex-1 min-w-0 grid grid-cols-12 gap-6">
          <div className="col-span-7 flex flex-col min-h-0">
            <ProcessList
              processes={processes}
              selectedCode={selectedCode}
              onSelect={setSelectedCode}
              isLoading={loading}
              equipCounts={allEquipCounts}
              onAdd={handleAdd}
              onEdit={handleEdit}
              onDelete={setDeleteTarget}
            />
          </div>
          <div className="col-span-5 flex flex-col min-h-0">
            <ProcessEquipGrid
              processCode={selectedCode}
              processName={selectedProcess?.processName ?? ""}
              equipments={equipments}
              isLoading={equipLoading}
              onAdd={handleOpenAssign}
              onRemove={setRemoveEquipmentTarget}
            />
          </div>
        </div>

        {/* 공정 추가/수정 슬라이드 패널 */}
        {isPanelOpen && (
          <div
            className={`w-[520px] ml-4 border-l border-border bg-background flex flex-col h-full overflow-hidden shadow-2xl text-xs ${
              panelAnimateRef.current ? "animate-slide-in-right" : ""
            }`}
          >
            <div className="px-5 py-3 border-b border-border flex items-center justify-between flex-shrink-0">
              <h2 className="text-sm font-bold text-text">
                {editingItem ? t("master.process.editProcess") : t("master.process.addProcess")}
              </h2>
              <div className="flex items-center gap-2">
                <Button size="sm" variant="secondary" onClick={() => guard(() => setIsPanelOpen(false))}>
                  {t("common.cancel")}
                </Button>
                <Button size="sm" onClick={handleSave} disabled={saving || !isFormValid}>
                  {saving ? t("common.saving") : t("common.save", "저장")}
                </Button>
              </div>
            </div>

            <div className="flex-1 overflow-y-auto px-5 py-4 space-y-6">
              <Section title={t("master.process.sectionBasic")}>
                <FieldInput
                  field="processCode"
                  label={t("master.process.processCode")}
                  value={formData.processCode || ""}
                  onChange={(e) => setField("processCode", e.target.value.toUpperCase())}
                  disabled={!!editingItem}
                  required
                />
                <FieldCodeSelect
                  field="processType"
                  groupCode="WORKSTAGE TYPE"
                  label={t("master.process.processType")}
                  value={formData.processType || ""}
                  onChange={(v) => setField("processType", v)}
                  required
                />
                <FieldInput
                  field="processName"
                  label={t("master.process.processName")}
                  value={formData.processName || ""}
                  onChange={(e) => setField("processName", e.target.value)}
                  required
                  wrapperClassName="col-span-2"
                />
                <FieldInput
                  field="sortOrder"
                  label={t("master.process.sortOrder")}
                  type="number"
                  value={numberValue(formData.sortOrder)}
                  onChange={(e) => setField("sortOrder", toNumberOrNull(e.target.value) ?? 0)}
                  required
                />
                <FieldCodeSelect
                  field="startYn"
                  groupCode="WORKSTAGE START YN"
                  label={t("master.process.startYn")}
                  value={formData.startYn || "N"}
                  onChange={(v) => setField("startYn", v)}
                />
                <FieldCodeSelect
                  field="codeGroup"
                  groupCode="WORKSTAGE CODE GROUP"
                  label={t("master.process.codeGroup")}
                  value={formData.codeGroup || ""}
                  onChange={(v) => setField("codeGroup", v)}
                />
                <FieldCodeSelect
                  field="workstageStatus"
                  groupCode="WORKSTAGE STATUS"
                  label={t("master.process.workstageStatus")}
                  value={formData.workstageStatus || ""}
                  onChange={(v) => setField("workstageStatus", v)}
                />
                <FieldCodeSelect
                  field="lineCode"
                  groupCode="LINE CODE"
                  label={t("master.process.lineCode")}
                  sentinel={{ value: WILDCARD_CODE, label: t("master.process.lineAny") }}
                  value={formData.lineCode || ""}
                  onChange={(v) => setField("lineCode", v)}
                />
                <FieldCodeSelect
                  field="departmentCode"
                  groupCode="DEPARTMENT CODE"
                  label={t("master.process.departmentCode")}
                  value={formData.departmentCode || ""}
                  onChange={(v) => setField("departmentCode", v)}
                />
                <FieldCodeSelect
                  field="shiftCode"
                  groupCode="SHIFT CODE"
                  label={t("master.process.shiftCode")}
                  value={formData.shiftCode || ""}
                  onChange={(v) => setField("shiftCode", v)}
                />
                <FieldSelect
                  field="machineCode"
                  label={t("master.process.machineCode")}
                  options={machineOptions}
                  value={formData.machineCode || ""}
                  onChange={(v) => setField("machineCode", v)}
                />
                <FieldInput
                  field="costCenterCode"
                  label={t("master.process.costCenterCode")}
                  value={formData.costCenterCode || ""}
                  onChange={(e) => setField("costCenterCode", e.target.value)}
                />
                <FieldInput
                  field="mesDisplayGroup"
                  label={t("master.process.mesDisplayGroup")}
                  value={formData.mesDisplayGroup || ""}
                  onChange={(e) => setField("mesDisplayGroup", e.target.value)}
                />
                <FieldInput
                  field="actualPlcAddress"
                  label={t("master.process.actualPlcAddress")}
                  value={formData.actualPlcAddress || ""}
                  onChange={(e) => setField("actualPlcAddress", e.target.value)}
                />
              </Section>

              <Section title={t("master.process.sectionCapacity")}>
                {numberField("uphValue", t("master.process.uphValue"))}
                {numberField("standardQty", t("master.process.standardQty"))}
                {numberField("capacity", t("master.process.capacity"))}
                <FieldCodeSelect
                  field="capacityUom"
                  groupCode="CAPACITY UOM"
                  label={t("master.process.capacityUom")}
                  showCode
                  value={formData.capacityUom || ""}
                  onChange={(v) => setField("capacityUom", v)}
                />
                {numberField("useRate", t("master.process.useRate"))}
                {numberField("workingEfficiency", t("master.process.workingEfficiency"))}
                {numberField("machineEfficiency", t("master.process.machineEfficiency"))}
                {numberField("workerQty", t("master.process.workerQty"))}
                {numberField("machineQty", t("master.process.machineQty"))}
              </Section>

              <Section title={t("master.process.sectionTime")}>
                {numberField("stValue", t("master.process.stValue"))}
                {numberField("otValue", t("master.process.otValue"))}
                {numberField("workerWorkTime", t("master.process.workerWorkTime"))}
                {numberField("machineWorkTime", t("master.process.machineWorkTime"))}
                {numberField("prepareTime", t("master.process.prepareTime"))}
                {numberField("waitTime", t("master.process.waitTime"))}
                {numberField("moveTime", t("master.process.moveTime"))}
                {numberField("totalWorkTime", t("master.process.totalWorkTime"))}
              </Section>

              <Section title={t("master.process.sectionCost")}>
                {numberField("wageRate", t("master.process.wageRate"))}
                {numberField("expenseRate", t("master.process.expenseRate"))}
                {numberField("machineryRate", t("master.process.machineryRate"))}
                <FieldCodeSelect
                  field="assyExpYn"
                  groupCode="ASSY EXP YN"
                  label={t("master.process.assyExpYn")}
                  value={formData.assyExpYn || ""}
                  onChange={(v) => setField("assyExpYn", v)}
                />
              </Section>

              <Section title={t("master.process.sectionDefect")}>
                <FieldCodeSelect
                  field="badRateControl"
                  groupCode="BAD RATE CONTROL"
                  label={t("master.process.badRateControl")}
                  value={formData.badRateControl || ""}
                  onChange={(v) => setField("badRateControl", v)}
                />
                {numberField("badMaxRate", t("master.process.badMaxRate"))}
                <FieldSelect
                  field="badQtyExtractYn"
                  label={t("master.process.badQtyExtractYn")}
                  options={ynOptions}
                  value={formData.badQtyExtractYn || ""}
                  onChange={(v) => setField("badQtyExtractYn", v)}
                />
                <FieldCodeSelect
                  field="genSubMfsYn"
                  groupCode="GEN SUB MFS YN"
                  label={t("master.process.genSubMfsYn")}
                  value={formData.genSubMfsYn || ""}
                  onChange={(v) => setField("genSubMfsYn", v)}
                />
              </Section>
            </div>
          </div>
        )}
      </div>

      {/* 설비 배치 */}
      <Modal
        isOpen={assignModalOpen}
        onClose={() => setAssignModalOpen(false)}
        title={t("master.process.assignEquipment", "설비 배치")}
        size="md"
      >
        <div className="space-y-4">
          <div className="text-sm text-text-muted">
            {selectedProcess?.processCode} ({selectedProcess?.processName})
          </div>
          <Select
            label={t("equipment.master.equipName", { defaultValue: "설비" })}
            options={assignOptions}
            value={assignEquipCode}
            onChange={setAssignEquipCode}
            fullWidth
          />
          <p className="text-xs text-text-muted">{t("master.process.assignEquipmentHint")}</p>
          <div className="flex justify-end gap-2 pt-2">
            <Button variant="secondary" onClick={() => setAssignModalOpen(false)}>
              {t("common.cancel")}
            </Button>
            <Button onClick={handleAssignEquipment} disabled={!assignEquipCode}>
              {t("common.add")}
            </Button>
          </div>
        </div>
      </Modal>

      <ConfirmModal
        isOpen={!!deleteTarget}
        onClose={() => setDeleteTarget(null)}
        onConfirm={handleDeleteConfirm}
        title={t("common.deleteConfirm", { defaultValue: "삭제 확인" })}
        message={`${deleteTarget?.processCode} (${deleteTarget?.processName}) ${t("common.deleteMessage", { defaultValue: "을(를) 삭제하시겠습니까?" })}`}
        confirmText={t("common.delete")}
        variant="danger"
      />
      <ConfirmModal
        isOpen={!!removeEquipmentTarget}
        onClose={() => setRemoveEquipmentTarget(null)}
        onConfirm={confirmEquipmentRemoval}
        title={t("master.process.removeEquipmentConfirm")}
        message={`${removeEquipmentTarget?.equipCode ?? ""} (${removeEquipmentTarget?.equipName ?? ""}) ${t("master.process.removeEquipmentMessage")}`}
        confirmText={t("common.delete")}
        variant="danger"
      />
      <ConfirmModal {...guardModalProps} />
    </div>
  );
}
