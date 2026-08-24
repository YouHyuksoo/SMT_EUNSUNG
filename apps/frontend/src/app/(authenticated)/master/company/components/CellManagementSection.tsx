"use client";

import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { Layers3, Pencil, RefreshCw } from "lucide-react";
import { useTranslation } from "react-i18next";
import toast from "react-hot-toast";
import { Button, ConfirmModal, Input, Modal } from "@/components/ui";
import UseYnSelect from "@/components/shared/UseYnSelect";
import api from "@/services/api";
import { getPlantKey, getPlantPath, Plant } from "../types";

interface Props {
  onDirtyChange?: (dirty: boolean) => void;
}

interface CellDraft {
  plantName: string;
  useYn: string;
  sortOrder: string;
}

const isProduction2Cell = (plant: Plant) =>
  plant.plantCode === "EUNSUNG" &&
  plant.shopCode === "2F" &&
  plant.lineCode === "PROD2" &&
  plant.plantType === "CELL";

const toCellDraft = (cell: Plant): CellDraft => ({
  plantName: cell.plantName,
  useYn: cell.useYn,
  sortOrder: String(cell.sortOrder ?? 0),
});

const isValidSortOrder = (value: string) => {
  if (!/^\d+$/.test(value.trim())) return false;
  return Number.isSafeInteger(Number(value)) && Number(value) >= 0;
};

export default function CellManagementSection({ onDirtyChange }: Props) {
  const { t } = useTranslation();
  const [cells, setCells] = useState<Plant[]>([]);
  const [loading, setLoading] = useState(false);
  const [loadError, setLoadError] = useState(false);
  const [editingCell, setEditingCell] = useState<Plant | null>(null);
  const [draft, setDraft] = useState<CellDraft | null>(null);
  const initialDraftRef = useRef<CellDraft | null>(null);
  const [attempted, setAttempted] = useState(false);
  const [saving, setSaving] = useState(false);
  const [discardConfirmOpen, setDiscardConfirmOpen] = useState(false);

  const fetchCells = useCallback(async () => {
    setLoading(true);
    setLoadError(false);
    try {
      const res = await api.get("/master/plants", {
        params: { plantType: "CELL", page: "1", limit: "10000" },
        suppressErrorModal: true,
      });
      const all: Plant[] = Array.isArray(res.data?.data) ? res.data.data : [];
      setCells(all.filter(isProduction2Cell));
    } catch (error: unknown) {
      setCells([]);
      setLoadError(true);
      toast.error(t("master.company.cellLoadError", "CELL 목록을 불러오지 못했습니다."));
    } finally {
      setLoading(false);
    }
  }, [t]);

  useEffect(() => {
    void fetchCells();
  }, [fetchCells]);

  const cellDirty = useMemo(() => {
    if (!draft) return false;
    return JSON.stringify(draft) !== JSON.stringify(initialDraftRef.current);
  }, [draft]);

  useEffect(() => {
    onDirtyChange?.(cellDirty);
  }, [cellDirty, onDirtyChange]);

  useEffect(() => () => onDirtyChange?.(false), [onDirtyChange]);

  const sortOrderValid = !!draft && isValidSortOrder(draft.sortOrder);
  const nameValid = !!draft?.plantName.trim();
  const canSave = !!editingCell && !!draft && nameValid && sortOrderValid && !saving;

  const openEditor = (cell: Plant) => {
    const nextDraft = toCellDraft(cell);
    setEditingCell(cell);
    setDraft(nextDraft);
    initialDraftRef.current = nextDraft;
    setAttempted(false);
  };

  const closeEditor = useCallback(() => {
    if (saving) return;
    setEditingCell(null);
    setDraft(null);
    initialDraftRef.current = null;
    setAttempted(false);
    setDiscardConfirmOpen(false);
  }, [saving]);

  const requestCloseEditor = () => {
    if (saving) return;
    if (cellDirty) {
      setDiscardConfirmOpen(true);
      return;
    }
    closeEditor();
  };

  const handleSave = async () => {
    setAttempted(true);
    if (!editingCell || !draft || !nameValid || !sortOrderValid || saving) return;

    const sortOrder = Number(draft.sortOrder);
    const cellPayload = {
      plantName: draft.plantName.trim(),
      useYn: draft.useYn,
      sortOrder: sortOrder,
    };

    setSaving(true);
    try {
      await api.put(`/master/plants/${getPlantPath(editingCell)}`, cellPayload, {
        skipSuccessToast: true,
        suppressErrorModal: true,
      });

      const key = getPlantKey(editingCell);
      setCells((current) =>
        current.map((cell) => (getPlantKey(cell) === key ? { ...cell, ...cellPayload } : cell)),
      );
      toast.success(t("master.company.cellSaveSuccess", "CELL이 저장되었습니다."));
      closeEditor();
    } catch (error: unknown) {
      toast.error(t("master.company.cellSaveError", "CELL 저장에 실패했습니다."));
    } finally {
      setSaving(false);
    }
  };

  return (
    <section className="border-t border-border pt-3">
      <div className="flex items-center justify-between mb-2">
        <h3 className="text-xs font-semibold text-text-muted flex items-center gap-1">
          <Layers3 className="w-3.5 h-3.5" />
          {t("master.company.cellSection", "2F > PROD2 > CELL 관리")}
          <span className="ml-1 px-1.5 py-0.5 text-[10px] rounded-full bg-primary/10 text-primary font-medium">
            {cells.length}
          </span>
        </h3>
        <button
          type="button"
          onClick={() => void fetchCells()}
          disabled={loading}
          className="p-1 rounded hover:bg-surface text-text-muted hover:text-text disabled:opacity-50"
          aria-label={t("master.company.cellRetry", "CELL 목록 다시 조회")}
          title={t("master.company.cellRetry", "CELL 목록 다시 조회")}
        >
          <RefreshCw className={`w-3.5 h-3.5 ${loading ? "animate-spin" : ""}`} />
        </button>
      </div>

      {loading ? (
        <div className="rounded-lg border border-dashed border-border bg-surface py-4 text-center text-text-muted" role="status">
          {t("master.company.cellLoading", "CELL 목록을 불러오는 중...")}
        </div>
      ) : loadError ? (
        <div className="rounded-lg border border-red-200 dark:border-red-900/40 bg-red-50/60 dark:bg-red-900/10 px-3 py-3 text-center" role="alert">
          <p className="text-red-600 dark:text-red-300">{t("master.company.cellLoadError", "CELL 목록을 불러오지 못했습니다.")}</p>
          <Button size="sm" variant="secondary" onClick={() => void fetchCells()} className="mt-2">
            {t("master.company.cellRetry", "다시 시도")}
          </Button>
        </div>
      ) : cells.length === 0 ? (
        <div className="rounded-lg border border-dashed border-border bg-surface py-4 text-center text-text-muted">
          {t("master.company.cellEmpty", "등록된 CELL이 없습니다.")}
        </div>
      ) : (
        <div className="border border-border rounded-lg overflow-hidden">
          <table className="w-full table-fixed text-xs">
            <thead className="bg-surface">
              <tr>
                <th className="w-[23%] text-left px-2 py-1.5 text-text-muted font-medium">
                  {t("master.company.cellCode", "CELL 코드")}
                </th>
                <th className="text-left px-2 py-1.5 text-text-muted font-medium">
                  {t("master.company.cellName", "CELL 명칭")}
                </th>
                <th className="w-[18%] text-center px-1 py-1.5 text-text-muted font-medium">
                  {t("master.company.cellUseYn", "사용")}
                </th>
                <th className="w-[14%] text-right px-1 py-1.5 text-text-muted font-medium">
                  {t("master.company.cellSortOrder", "순서")}
                </th>
                <th className="w-10 px-1 py-1.5" aria-label={t("master.company.cellEdit", "수정")} />
              </tr>
            </thead>
            <tbody>
              {cells.map((cell) => (
                <tr key={getPlantKey(cell)} className="border-t border-border hover:bg-surface/50">
                  <td className="px-2 py-1.5 font-mono font-medium text-text">
                    <div>{cell.cellCode || "-"}</div>
                    <div className="text-[10px] font-sans font-normal text-text-muted">
                      {cell.shopCode || "-"} &gt; {cell.lineCode || "-"}
                    </div>
                  </td>
                  <td className="px-2 py-1.5 text-text truncate" title={cell.plantName}>{cell.plantName}</td>
                  <td className="px-1 py-1.5 text-center">
                    <span className={`inline-flex rounded-full px-1.5 py-0.5 text-[10px] font-medium ${cell.useYn === "Y" ? "bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-300" : "bg-gray-100 text-gray-600 dark:bg-gray-800 dark:text-gray-300"}`}>
                      {cell.useYn === "Y" ? t("common.useY", "사용") : t("common.useN", "미사용")}
                    </span>
                  </td>
                  <td className="px-1 py-1.5 text-right tabular-nums text-text">{cell.sortOrder}</td>
                  <td className="px-1 py-1.5 text-center">
                    <button
                      type="button"
                      onClick={() => openEditor(cell)}
                      className="inline-flex items-center justify-center rounded p-1 text-primary hover:bg-primary/10"
                      aria-label={`${t("master.company.cellEdit", "수정")}: ${cell.cellCode || "-"}`}
                      title={t("master.company.cellEdit", "수정")}
                    >
                      <Pencil className="w-3.5 h-3.5" />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      <Modal
        isOpen={!!editingCell && !!draft}
        onClose={requestCloseEditor}
        title={t("master.company.cellEditTitle", "CELL 수정")}
        size="sm"
        closeOnOverlayClick={!saving}
        closeOnEsc={!saving}
        footer={(
          <>
            <Button variant="secondary" onClick={requestCloseEditor} disabled={saving}>
              {t("common.cancel")}
            </Button>
            <Button onClick={handleSave} disabled={!canSave} isLoading={saving}>
              {t("common.save", "저장")}
            </Button>
          </>
        )}
      >
        {editingCell && draft && (
          <div className="space-y-3">
            <div className="grid grid-cols-2 gap-2 rounded-lg bg-background p-2 text-xs">
              <div data-field="plantCode" aria-readonly="true">
                <span className="block text-text-muted">{t("master.company.cellPlantCode", "사업장 코드")}</span>
                <code className="font-mono text-text">{editingCell.plantCode}</code>
              </div>
              <div data-field="shopCode" aria-readonly="true">
                <span className="block text-text-muted">{t("master.company.cellShopCode", "공장동 코드")}</span>
                <code className="font-mono text-text">{editingCell.shopCode || "-"}</code>
              </div>
              <div data-field="lineCode" aria-readonly="true">
                <span className="block text-text-muted">{t("master.company.cellLineCode", "라인 코드")}</span>
                <code className="font-mono text-text">{editingCell.lineCode || "-"}</code>
              </div>
              <div data-field="cellCode" aria-readonly="true">
                <span className="block text-text-muted">{t("master.company.cellCode", "CELL 코드")}</span>
                <code className="font-mono text-text">{editingCell.cellCode || "-"}</code>
              </div>
            </div>

            <Input
              label={t("master.company.cellName", "CELL 명칭")}
              value={draft.plantName}
              maxLength={200}
              onChange={(event) => setDraft((current) => current ? { ...current, plantName: event.target.value } : current)}
              error={attempted && !nameValid ? t("master.company.cellNameRequired", "CELL 명칭을 입력하세요.") : undefined}
              disabled={saving}
              fullWidth
              required
            />
            <UseYnSelect
              label={t("master.company.cellUseYn", "사용여부")}
              includeAll={false}
              value={draft.useYn}
              onChange={(value) => setDraft((current) => current ? { ...current, useYn: value } : current)}
              disabled={saving}
              fullWidth
            />
            <Input
              label={t("master.company.cellSortOrder", "정렬 순서")}
              type="number"
              min={0}
              step={1}
              inputMode="numeric"
              value={draft.sortOrder}
              onChange={(event) => setDraft((current) => current ? { ...current, sortOrder: event.target.value } : current)}
              error={attempted && !sortOrderValid ? t("master.company.cellSortOrderInvalid", "정렬 순서는 0 이상의 정수만 입력하세요.") : undefined}
              disabled={saving}
              fullWidth
              required
            />
          </div>
        )}
      </Modal>

      <ConfirmModal
        isOpen={discardConfirmOpen}
        onClose={() => setDiscardConfirmOpen(false)}
        onConfirm={closeEditor}
        message={t("master.company.cellDiscardConfirm", "저장하지 않은 CELL 변경사항을 버리고 닫으시겠습니까?")}
      />
    </section>
  );
}
