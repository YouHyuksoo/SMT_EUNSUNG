"use client";

/**
 * @file src/app/(authenticated)/master/part/page.tsx
 * @description ID_ITEM 품목 기준정보 관리 페이지
 *
 * 초보자 가이드:
 * 1. **품목 목록**: GET /master/parts API로 실제 DB 데이터 조회 — ID_ITEM 109개 컬럼 전부
 * 2. **조회조건**: 품목구분·품목유형·구입유형·품목분류·공급상은 서버에서 거른다.
 *    나머지 컬럼은 그리드 머리글 필터로 거른다.
 * 3. **CRUD**: 추가/수정/삭제 모두 API를 통해 DB에 반영
 */

import { useState, useMemo, useEffect, useCallback, useRef } from "react";
import { useTranslation } from "react-i18next";
import { Plus, Search, Package, RefreshCw } from "lucide-react";
import { Card, CardContent, Button, Input, ConfirmModal } from "@/components/ui";
import { ComCodeSelect } from "@/components/shared";
import SupplierSelect from "@/components/shared/SupplierSelect";
import DataGrid from "@/components/data-grid/DataGrid";
import api from "@/services/api";
import { Part } from "./types";
import { useUnsavedGuard } from "@/hooks/useUnsavedGuard";

import PartFormPanel from "./components/PartFormPanel";
import { createPartGridColumns } from "./partColumns";

export default function PartPage() {
  const { t } = useTranslation();
  const [parts, setParts] = useState<Part[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searchText, setSearchText] = useState("");
  const [debouncedSearch, setDebouncedSearch] = useState("");
  const [partTypeFilter, setPartTypeFilter] = useState("");
  /** 서버에서 거르는 코드 컬럼 — 키는 /master/parts 조회 파라미터 이름 */
  const [codeFilters, setCodeFilters] = useState({
    itemDivision: "", lineType: "", itemClass: "", supplierCode: "",
  });
  const setCodeFilter = (key: keyof typeof codeFilters) => (value: string) =>
    setCodeFilters((prev) => ({ ...prev, [key]: value }));

  const [isPanelOpen, setIsPanelOpen] = useState(false);
  const [editingPart, setEditingPart] = useState<Part | null>(null);
  const [deleteTarget, setDeleteTarget] = useState<Part | null>(null);
  const panelAnimateRef = useRef(true);
  const { markDirty, guard, guardModalProps } = useUnsavedGuard();

  /** 검색어 디바운스 (300ms) */
  useEffect(() => {
    const timer = setTimeout(() => setDebouncedSearch(searchText), 300);
    return () => clearTimeout(timer);
  }, [searchText]);

  /** DB에서 품목 목록 조회 */
  const fetchParts = useCallback(async () => {
    setLoading(true);
    try {
      const params: Record<string, string | number> = { limit: 5000 };
      if (partTypeFilter) params.itemType = partTypeFilter;
      if (debouncedSearch) params.search = debouncedSearch;
      for (const [key, value] of Object.entries(codeFilters)) {
        if (value) params[key] = value;
      }

      const partsRes = await api.get("/master/parts", { params });
      const partsBody = partsRes.data;
      if (partsBody.success) {
        setParts(partsBody.data || []);
        setTotal(partsBody.meta?.total || 0);
      }
    } catch {
      setParts([]);
    } finally {
      setLoading(false);
    }
  }, [partTypeFilter, debouncedSearch, codeFilters]);

  /** 초기 로드 */
  useEffect(() => { fetchParts(); }, [fetchParts]);

  const handleSearch = (val: string) => { setSearchText(val); };
  const handleTypeFilter = (val: string) => { setPartTypeFilter(val); };

  const handleDeleteConfirm = useCallback(async () => {
    if (!deleteTarget) return;
    try {
      await api.delete(`/master/parts/${deleteTarget.itemCode}`);
      fetchParts();
    } catch (e: any) {
      console.error("Delete failed:", e);
    } finally {
      setDeleteTarget(null);
    }
  }, [deleteTarget, fetchParts]);

  const columns = useMemo(() => createPartGridColumns({
    t,
    isPanelOpen,
    panelAnimateRef,
    guard,
    onEditPart: (part) => {
      setEditingPart(part);
      setIsPanelOpen(true);
    },
    onDeletePart: setDeleteTarget,
  }), [t, isPanelOpen, guard]);

  const handlePanelClose = useCallback(() => {
    setIsPanelOpen(false);
    setEditingPart(null);
    panelAnimateRef.current = true;
  }, []);

  const handlePanelSave = useCallback(() => {
    fetchParts();
  }, [fetchParts]);

  return (
    <div className="flex h-full animate-fade-in">
      {/* 좌측: 메인 콘텐츠 */}
      <div className="flex-1 min-w-0 flex flex-col overflow-hidden p-6 gap-4">
        <div className="flex justify-between items-center flex-shrink-0">
          <div>
            <h1 className="text-xl font-bold text-text flex items-center gap-2">
              <Package className="w-7 h-7 text-primary" />{t("master.part.title")}
            </h1>
            <p className="text-text-muted mt-1">{t("master.part.subtitle")} ({total}건)</p>
          </div>
          <div className="flex gap-2 items-center">
            <Button variant="secondary" size="sm" onClick={() => { fetchParts(); }}>
              <RefreshCw className={`w-4 h-4 mr-1 ${loading ? "animate-spin" : ""}`} />{t("common.refresh")}
            </Button>
            <Button size="sm" onClick={() => guard(() => { panelAnimateRef.current = !isPanelOpen; setEditingPart(null); setIsPanelOpen(true); })}>
              <Plus className="w-4 h-4 mr-1" />{t("master.part.addPart")}
            </Button>
          </div>
        </div>

        <Card className="flex-1 min-h-0 overflow-hidden" padding="none"><CardContent className="h-full p-4">
          <DataGrid
            data={parts}
            columns={columns}
            isLoading={loading}
            enableColumnFilter
            enableExport
            enableColumnPinning
            exportFileName={t("master.part.title")}
            onRowClick={(row) => { if (isPanelOpen) guard(() => setEditingPart(row)); }}
            rowClassName={(row) => row.mesDisplayYn === "N" ? "!text-red-500 dark:!text-red-400" : ""}
            toolbarLeft={
              <div className="flex flex-wrap gap-3 flex-1 min-w-0">
                <div className="flex-1 min-w-[16rem]">
                  <Input placeholder={t("master.part.searchPlaceholder")} value={searchText}
                    onChange={e => handleSearch(e.target.value)}
                    leftIcon={<Search className="w-4 h-4" />} fullWidth />
                </div>
                <div className="w-40 flex-shrink-0">
                  <ComCodeSelect groupCode="ITEM DIVISION" value={codeFilters.itemDivision} onChange={setCodeFilter("itemDivision")} labelPrefix="품목구분" fullWidth />
                </div>
                <div className="w-40 flex-shrink-0">
                  <ComCodeSelect groupCode="ITEM TYPE" value={partTypeFilter} onChange={handleTypeFilter} labelPrefix="품목유형" fullWidth />
                </div>
                <div className="w-44 flex-shrink-0">
                  <ComCodeSelect groupCode="LINE TYPE" value={codeFilters.lineType} onChange={setCodeFilter("lineType")} labelPrefix="구입유형" fullWidth />
                </div>
                <div className="w-48 flex-shrink-0">
                  <ComCodeSelect groupCode="ITEM CLASS" value={codeFilters.itemClass} onChange={setCodeFilter("itemClass")} labelPrefix="품목분류" fullWidth />
                </div>
                <div className="w-48 flex-shrink-0">
                  <SupplierSelect includeAll labelPrefix="공급상" value={codeFilters.supplierCode} onChange={setCodeFilter("supplierCode")} fullWidth />
                </div>
              </div>
            }

          sqlQuery={`SELECT *\nFROM ID_ITEM\nWHERE ORGANIZATION_ID = :organizationId\nORDER BY ITEM_CODE`}/>
        </CardContent></Card>
      </div>


      {/* 우측: 품목 추가/수정 슬라이드 패널 */}
      {isPanelOpen && (
        <PartFormPanel
          editingPart={editingPart}
          onClose={() => guard(handlePanelClose)}
          onSave={handlePanelSave}
          animate={panelAnimateRef.current}
          onDirtyChange={markDirty}
        />
      )}

      <ConfirmModal {...guardModalProps} />

      <ConfirmModal
        isOpen={!!deleteTarget}
        onClose={() => setDeleteTarget(null)}
        onConfirm={handleDeleteConfirm}
        variant="danger"
        message={t("master.part.deleteConfirmMessage", "'{{itemCode}} ({{itemName}})'을(를) 삭제하시겠습니까?", { itemCode: deleteTarget?.itemCode || "", itemName: deleteTarget?.itemName || "" })}
      />
    </div>
  );
}
