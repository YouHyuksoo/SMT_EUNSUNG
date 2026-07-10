"use client";

/**
 * @file components/master/ProdLineTab.tsx
 * @description 생산라인 탭 - IP_PRODUCT_LINE 기반 Oracle API 연동 CRUD
 *
 * 초보자 가이드:
 * 1. API: GET/POST/PUT/DELETE /master/prod-lines
 * 2. DataGrid로 목록 표시 + 우측 패널로 등록/수정
 * 3. activeYn은 사용여부가 아니라 라인 가동 활성 상태(Y=활성, N=대기)다.
 */
import { useState, useEffect, useCallback, useMemo, useRef, type ReactNode } from "react";
import { useTranslation } from "react-i18next";
import { Plus, Edit2, Trash2, Search, RefreshCw } from "lucide-react";
import { Card, CardContent, Button, Input, ConfirmModal } from "@/components/ui";
import DataGrid from "@/components/data-grid/DataGrid";
import { ColumnDef } from "@tanstack/react-table";
import {
  LINE_DIVISION_VALUES,
  LINE_DIVISION_LABELS,
  LINE_PRODUCT_DIVISION_VALUES,
  LINE_PRODUCT_DIVISION_LABELS,
  LINE_STATUS_VALUES,
  LINE_STATUS_LABELS,
  LINE_CAPACITY_UOM_VALUES,
  LINE_ACTIVE_YN_VALUES,
  LINE_ACTIVE_YN_LABELS,
} from "@smt/shared";
import api from "@/services/api";
import { FieldInput, FieldSelect } from "@/app/(authenticated)/master/prod-line/components/ProdLineFieldHelp";
import { useUnsavedGuard } from "@/hooks/useUnsavedGuard";

interface ProdLine {
  lineCode: string;
  lineName: string;
  lineDivision: string;
  lineProductDivision?: string;
  lineCodeGroup?: string | null;
  lineStatus?: string | null;
  capacity?: number | null;
  capacityUom?: string | null;
  uphValue?: number | null;
  mesDisplayYn?: string | null;
  mesDisplaySequence?: number | null;
  activeYn?: string | null;
  comments?: string | null;
}

interface Props {
  onHeaderActions?: (actions: ReactNode) => void;
}

const LINE_DIVISION_OPTIONS = LINE_DIVISION_VALUES.map((v) => ({ value: v, label: `${v} · ${LINE_DIVISION_LABELS[v]}` }));
const LINE_PRODUCT_DIVISION_OPTIONS = LINE_PRODUCT_DIVISION_VALUES.map((v) => ({ value: v, label: `${v} · ${LINE_PRODUCT_DIVISION_LABELS[v]}` }));
const LINE_STATUS_OPTIONS = LINE_STATUS_VALUES.map((v) => ({ value: v, label: `${v} · ${LINE_STATUS_LABELS[v]}` }));
const CAPACITY_UOM_OPTIONS = LINE_CAPACITY_UOM_VALUES.map((v) => ({ value: v, label: v }));
const ACTIVE_YN_OPTIONS = LINE_ACTIVE_YN_VALUES.map((v) => ({ value: v, label: LINE_ACTIVE_YN_LABELS[v] }));
const MES_DISPLAY_YN_OPTIONS = [
  { value: "Y", label: "Y" },
  { value: "N", label: "N" },
];

/** 빈 문자열을 보내면 Oracle NOT NULL/코드 검증에 걸리므로 undefined로 정리한다. */
function toPayload(form: Partial<ProdLine>) {
  const clean = <T,>(v: T | "" | null | undefined) => (v === "" || v === null ? undefined : v);
  const num = (v: unknown) => (v === "" || v === null || v === undefined ? undefined : Number(v));
  return {
    lineCode: form.lineCode,
    lineName: form.lineName,
    lineDivision: form.lineDivision,
    lineProductDivision: clean(form.lineProductDivision),
    lineCodeGroup: clean(form.lineCodeGroup),
    lineStatus: clean(form.lineStatus),
    capacity: num(form.capacity),
    capacityUom: clean(form.capacityUom),
    uphValue: num(form.uphValue),
    mesDisplayYn: clean(form.mesDisplayYn),
    mesDisplaySequence: num(form.mesDisplaySequence),
    activeYn: clean(form.activeYn),
    comments: clean(form.comments),
  };
}

export default function ProdLineTab({ onHeaderActions }: Props) {
  const { t } = useTranslation();
  const [lines, setLines] = useState<ProdLine[]>([]);
  const [loading, setLoading] = useState(false);
  const [searchText, setSearchText] = useState("");
  const [isPanelOpen, setIsPanelOpen] = useState(false);
  const [editingLine, setEditingLine] = useState<ProdLine | null>(null);
  const [deleteTarget, setDeleteTarget] = useState<ProdLine | null>(null);
  const [formData, setFormData] = useState<Partial<ProdLine>>({});
  const [saving, setSaving] = useState(false);
  const initialFormRef = useRef<Partial<ProdLine>>({});
  const panelAnimateRef = useRef(true);
  const { markDirty, guard, guardModalProps } = useUnsavedGuard();

  const fetchLines = useCallback(async () => {
    setLoading(true);
    try {
      const params: Record<string, string> = { limit: "5000" };
      if (searchText) params.search = searchText;
      const res = await api.get("/master/prod-lines", { params });
      if (res.data.success) setLines(res.data.data || []);
    } catch {
      setLines([]);
    } finally {
      setLoading(false);
    }
  }, [searchText]);

  useEffect(() => { fetchLines(); }, [fetchLines]);

  const openCreate = useCallback(() => {
    panelAnimateRef.current = true;
    const init: Partial<ProdLine> = {
      lineProductDivision: "FIXED",
      lineStatus: "N",
      mesDisplayYn: "N",
      activeYn: "N",
    };
    setEditingLine(null);
    setFormData(init);
    initialFormRef.current = init;
    setIsPanelOpen(true);
  }, []);

  const openEdit = useCallback((line: ProdLine) => {
    setEditingLine(line);
    const init = { ...line };
    setFormData(init);
    initialFormRef.current = init;
    setIsPanelOpen(true);
  }, []);

  useEffect(() => {
    onHeaderActions?.(
      <>
        <Button variant="secondary" size="sm" onClick={fetchLines}>
          <RefreshCw className={`w-4 h-4 mr-1 ${loading ? "animate-spin" : ""}`} />{t("common.refresh")}
        </Button>
        <Button size="sm" onClick={() => guard(openCreate)}>
          <Plus className="w-4 h-4 mr-1" />{t("master.prodLine.addLine")}
        </Button>
      </>
    );
  }, [onHeaderActions, fetchLines, openCreate, guard, loading, t]);

  // 작성 중(저장 안 됨) 여부 계산 후 보고 — 행 전환 시 유실 방어
  const dirty = useMemo(
    () => isPanelOpen && JSON.stringify(formData) !== JSON.stringify(initialFormRef.current),
    [isPanelOpen, formData],
  );
  useEffect(() => { markDirty(dirty); }, [dirty, markDirty]);

  const handleSave = useCallback(async () => {
    if (!formData.lineCode || !formData.lineName || !formData.lineDivision) return;
    setSaving(true);
    try {
      const payload = toPayload(formData);
      if (editingLine) {
        await api.put(`/master/prod-lines/${editingLine.lineCode}`, payload);
      } else {
        await api.post("/master/prod-lines", payload);
      }
      markDirty(false);
      setIsPanelOpen(false);
      fetchLines();
    } catch (e: unknown) {
      console.error("Save failed:", e);
    } finally {
      setSaving(false);
    }
  }, [formData, editingLine, fetchLines, markDirty]);

  const handleDelete = useCallback(async () => {
    if (!deleteTarget) return;
    try {
      await api.delete(`/master/prod-lines/${deleteTarget.lineCode}`);
      setDeleteTarget(null);
      fetchLines();
    } catch (e: unknown) {
      console.error("Delete failed:", e);
    }
  }, [deleteTarget, fetchLines]);

  const columns = useMemo<ColumnDef<ProdLine>[]>(() => [
    { id: "actions", header: t("common.actions"), size: 80,
      meta: { align: "center" as const, filterType: "none" as const },
      cell: ({ row }) => (
        <div className="flex gap-1">
          <button onClick={(e) => { e.stopPropagation(); guard(() => openEdit(row.original)); }} className="p-1 hover:bg-surface rounded">
            <Edit2 className="w-4 h-4 text-primary" />
          </button>
          <button onClick={(e) => { e.stopPropagation(); setDeleteTarget(row.original); }} className="p-1 hover:bg-surface rounded">
            <Trash2 className="w-4 h-4 text-red-500" />
          </button>
        </div>
      ),
    },
    { accessorKey: "lineCode", header: t("master.prodLine.lineCode"), size: 90, meta: { filterType: "text" as const } },
    { accessorKey: "lineName", header: t("master.prodLine.lineName"), size: 180, meta: { filterType: "text" as const } },
    { accessorKey: "lineDivision", header: t("master.prodLine.lineDivision"), size: 110,
      meta: { filterType: "multi" as const },
      cell: ({ getValue }) => {
        const v = getValue() as string;
        if (!v) return <span className="text-text-muted">-</span>;
        const label = LINE_DIVISION_LABELS[v as keyof typeof LINE_DIVISION_LABELS] ?? v;
        return <span className="px-2 py-0.5 text-xs rounded-full bg-blue-100 dark:bg-blue-900/50 text-blue-700 dark:text-blue-300">{label}</span>;
      },
    },
    { accessorKey: "lineCodeGroup", header: t("master.prodLine.lineCodeGroup"), size: 100,
      meta: { filterType: "multi" as const },
      cell: ({ getValue }) => (getValue() as string) || "-",
    },
    { accessorKey: "lineProductDivision", header: t("master.prodLine.lineProductDivision"), size: 100,
      meta: { filterType: "multi" as const },
      cell: ({ getValue }) => {
        const v = getValue() as string;
        return v ? (LINE_PRODUCT_DIVISION_LABELS[v as keyof typeof LINE_PRODUCT_DIVISION_LABELS] ?? v) : "-";
      },
    },
    { accessorKey: "lineStatus", header: t("master.prodLine.lineStatus"), size: 100,
      meta: { filterType: "multi" as const },
      cell: ({ getValue }) => {
        const v = getValue() as string;
        if (!v) return <span className="text-text-muted">-</span>;
        const label = LINE_STATUS_LABELS[v as keyof typeof LINE_STATUS_LABELS] ?? v;
        return <span className={v === "N" ? "text-text" : "text-amber-600 dark:text-amber-400"}>{label}</span>;
      },
    },
    { accessorKey: "capacity", header: t("master.prodLine.capacity"), size: 90,
      meta: { align: "right" as const, filterType: "text" as const },
      cell: ({ row }) => {
        const { capacity, capacityUom } = row.original;
        if (capacity === null || capacity === undefined) return <span className="text-text-muted">-</span>;
        return <span className="font-mono text-xs">{capacity.toLocaleString()}{capacityUom ? ` ${capacityUom}` : ""}</span>;
      },
    },
    { accessorKey: "uphValue", header: t("master.prodLine.uphValue"), size: 80,
      meta: { align: "right" as const, filterType: "text" as const },
      cell: ({ getValue }) => {
        const v = getValue() as number | null;
        return v === null || v === undefined ? <span className="text-text-muted">-</span> : <span className="font-mono text-xs">{v.toLocaleString()}</span>;
      },
    },
    { accessorKey: "mesDisplayYn", header: t("master.prodLine.mesDisplayYn"), size: 80,
      meta: { align: "center" as const, filterType: "multi" as const },
      cell: ({ getValue }) => (
        <span className={`w-2 h-2 rounded-full inline-block ${getValue() === "Y" ? "bg-green-500" : "bg-gray-400"}`} />
      ),
    },
    { accessorKey: "mesDisplaySequence", header: t("master.prodLine.mesDisplaySequence"), size: 80,
      meta: { align: "right" as const, filterType: "text" as const },
      cell: ({ getValue }) => {
        const v = getValue() as number | null;
        return v === null || v === undefined ? "-" : <span className="font-mono text-xs">{v}</span>;
      },
    },
    { accessorKey: "activeYn", header: t("master.prodLine.activeYn"), size: 70,
      meta: { align: "center" as const, filterType: "multi" as const },
      cell: ({ getValue }) => {
        const v = getValue() as string | null;
        return (
          <span className={`px-2 py-0.5 text-xs rounded-full ${v === "Y"
            ? "bg-green-100 dark:bg-green-900/50 text-green-700 dark:text-green-300"
            : "bg-gray-100 dark:bg-gray-800 text-text-muted"}`}>
            {v === "Y" ? LINE_ACTIVE_YN_LABELS.Y : LINE_ACTIVE_YN_LABELS.N}
          </span>
        );
      },
    },
    { accessorKey: "comments", header: t("master.prodLine.comments"), size: 160,
      meta: { filterType: "text" as const },
      cell: ({ getValue }) => (getValue() as string) || "-",
    },
  ], [t, openEdit, guard]);

  return (
    <div className="h-full flex overflow-hidden">
      <div className="flex-1 min-w-0 flex flex-col">
        <Card className="flex-1 min-h-0 overflow-hidden">
          <CardContent className="h-full">
            <DataGrid
              sqlQuery={`SELECT LINE_CODE, LINE_NAME, LINE_DIVISION, LINE_CODE_GROUP,\n       LINE_PRODUCT_DIVISION, LINE_STATUS, CAPACITY, CAPACITY_UOM,\n       UPH_VALUE, MES_DISPLAY_YN, MES_DISPLAY_SEQUENCE, ACTIVE_YN, COMMENTS\nFROM IP_PRODUCT_LINE\nWHERE ORGANIZATION_ID = :organizationId\nORDER BY LINE_CODE ASC`}
              data={lines}
              columns={columns}
              isLoading={loading}
              enableColumnFilter
              enableExport
              exportFileName={t("master.prodLine.title", "생산라인")}
              onRowClick={(row) => { if (isPanelOpen) guard(() => openEdit(row)); }}
              toolbarLeft={
                <div className="flex gap-3 flex-1 min-w-0">
                  <div className="flex-1 min-w-0">
                    <Input placeholder={t("master.prodLine.searchPlaceholder")} value={searchText}
                      onChange={(e) => setSearchText(e.target.value)} leftIcon={<Search className="w-4 h-4" />} fullWidth />
                  </div>
                </div>
              }
            />
          </CardContent>
        </Card>
      </div>

      {isPanelOpen && (
        <div className={`w-[440px] ml-4 border-l border-border bg-background flex flex-col h-full overflow-hidden shadow-2xl text-xs ${panelAnimateRef.current ? "animate-slide-in-right" : ""}`}>
          <div className="px-5 py-3 border-b border-border flex items-center justify-between flex-shrink-0">
            <h2 className="text-sm font-bold text-text">
              {editingLine ? t("master.prodLine.editLine") : t("master.prodLine.addLine")}
            </h2>
            <div className="flex items-center gap-2">
              <Button size="sm" variant="secondary" onClick={() => guard(() => setIsPanelOpen(false))}>
                {t("common.cancel")}
              </Button>
              <Button size="sm" onClick={handleSave} disabled={saving || !formData.lineCode || !formData.lineName || !formData.lineDivision}>
                {saving ? t("common.saving") : t("common.save", "저장")}
              </Button>
            </div>
          </div>
          <div className="flex-1 overflow-y-auto px-5 py-3 space-y-4">
            <div className="grid grid-cols-2 gap-3">
              <FieldInput field="lineCode" label={t("master.prodLine.lineCode")} placeholder="38"
                value={formData.lineCode || ""} onChange={(e) => setFormData((p) => ({ ...p, lineCode: e.target.value }))}
                disabled={!!editingLine} required />
              <FieldInput field="lineName" label={t("master.prodLine.lineName")} placeholder={t("master.prodLine.lineName")}
                value={formData.lineName || ""} onChange={(e) => setFormData((p) => ({ ...p, lineName: e.target.value }))} required />

              <FieldSelect field="lineDivision" label={t("master.prodLine.lineDivision")} options={LINE_DIVISION_OPTIONS}
                value={formData.lineDivision || ""} onChange={(v) => setFormData((p) => ({ ...p, lineDivision: v }))} required />
              <FieldInput field="lineCodeGroup" label={t("master.prodLine.lineCodeGroup")} placeholder="ASM"
                value={formData.lineCodeGroup || ""} onChange={(e) => setFormData((p) => ({ ...p, lineCodeGroup: e.target.value }))} />

              <FieldSelect field="lineProductDivision" label={t("master.prodLine.lineProductDivision")} options={LINE_PRODUCT_DIVISION_OPTIONS}
                value={formData.lineProductDivision || ""} onChange={(v) => setFormData((p) => ({ ...p, lineProductDivision: v }))} />
              <FieldSelect field="lineStatus" label={t("master.prodLine.lineStatus")} options={LINE_STATUS_OPTIONS}
                value={formData.lineStatus || ""} onChange={(v) => setFormData((p) => ({ ...p, lineStatus: v }))} />

              <FieldInput field="capacity" label={t("master.prodLine.capacity")} type="number" placeholder="0"
                value={formData.capacity ?? ""} onChange={(e) => setFormData((p) => ({ ...p, capacity: e.target.value === "" ? null : Number(e.target.value) }))} />
              <FieldSelect field="capacityUom" label={t("master.prodLine.capacityUom")} options={CAPACITY_UOM_OPTIONS}
                value={formData.capacityUom || ""} onChange={(v) => setFormData((p) => ({ ...p, capacityUom: v }))} />

              <FieldInput field="uphValue" label={t("master.prodLine.uphValue")} type="number" placeholder="0"
                value={formData.uphValue ?? ""} onChange={(e) => setFormData((p) => ({ ...p, uphValue: e.target.value === "" ? null : Number(e.target.value) }))} />
              <FieldSelect field="activeYn" label={t("master.prodLine.activeYn")} options={ACTIVE_YN_OPTIONS}
                value={formData.activeYn || ""} onChange={(v) => setFormData((p) => ({ ...p, activeYn: v }))} />

              <FieldSelect field="mesDisplayYn" label={t("master.prodLine.mesDisplayYn")} options={MES_DISPLAY_YN_OPTIONS}
                value={formData.mesDisplayYn || ""} onChange={(v) => setFormData((p) => ({ ...p, mesDisplayYn: v }))} />
              <FieldInput field="mesDisplaySequence" label={t("master.prodLine.mesDisplaySequence")} type="number" placeholder="0"
                value={formData.mesDisplaySequence ?? ""} onChange={(e) => setFormData((p) => ({ ...p, mesDisplaySequence: e.target.value === "" ? null : Number(e.target.value) }))} />

              <FieldInput field="comments" label={t("master.prodLine.comments")} placeholder={t("master.prodLine.comments")}
                value={formData.comments || ""} onChange={(e) => setFormData((p) => ({ ...p, comments: e.target.value }))}
                wrapperClassName="col-span-2" />
            </div>
          </div>
        </div>
      )}

      <ConfirmModal
        isOpen={!!deleteTarget}
        onClose={() => setDeleteTarget(null)}
        onConfirm={handleDelete}
        title={t("common.delete")}
        message={`${deleteTarget?.lineCode ?? ""} (${deleteTarget?.lineName ?? ""}) ${t("common.deleteMessage", { defaultValue: "을(를) 삭제하시겠습니까?" })}`}
        confirmText={t("common.delete")}
        variant="danger"
      />
      <ConfirmModal {...guardModalProps} />
    </div>
  );
}
