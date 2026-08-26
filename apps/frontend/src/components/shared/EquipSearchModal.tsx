/**
 * @file src/components/shared/EquipSearchModal.tsx
 * @description 설비 검색 공통 모달 — 설비마스터(IMCN_MACHINE) 전체 (설비코드/설비명/유형/라인/공정)
 *   모델 검색 팝업(ModelSearchModal)과 동일 규격. 단일 선택.
 * 사용 예:
 *   <EquipSearchModal isOpen={open} onClose={() => setOpen(false)} onSelect={(e) => setCode(e.equipCode)} />
 */

"use client";

import { useState, useCallback, useEffect, useMemo } from "react";
import { Search } from "lucide-react";
import { ColumnDef } from "@tanstack/react-table";
import { Modal, Input } from "@/components/ui";
import DataGrid from "@/components/data-grid/DataGrid";
import api from "@/services/api";

export interface EquipItem {
  equipCode: string; equipName: string; equipType: string; lineCode: string; processCode: string;
}

interface EquipSearchModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSelect: (equip: EquipItem) => void;
  modalSize?: "xl" | "2xl";
}

interface ApiEquipRow {
  equipCode: string; equipName: string | null; equipType: string | null; lineCode: string | null; processCode: string | null;
}

export default function EquipSearchModal({ isOpen, onClose, onSelect, modalSize = "2xl" }: EquipSearchModalProps) {
  const [keyword, setKeyword] = useState("");
  const [data, setData] = useState<EquipItem[]>([]);
  const [loading, setLoading] = useState(false);

  const fetchEquips = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get("/equipment/equips", { params: { limit: 1000 } });
      const rows: ApiEquipRow[] = res.data?.data ?? res.data?.data?.list ?? [];
      setData(rows.map((r) => ({
        equipCode: r.equipCode,
        equipName: r.equipName ?? "",
        equipType: r.equipType ?? "",
        lineCode: r.lineCode ?? "",
        processCode: r.processCode ?? "",
      })));
    } catch {
      setData([]);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    if (!isOpen) return;
    setKeyword("");
    if (!data.length) fetchEquips();
  }, [isOpen, data.length, fetchEquips]);

  const filtered = useMemo(() => {
    const q = keyword.trim().toLowerCase();
    if (!q) return data;
    return data.filter((m) => `${m.equipCode} ${m.equipName}`.toLowerCase().includes(q));
  }, [data, keyword]);

  const handleRowClick = useCallback((row: EquipItem) => { onSelect(row); onClose(); }, [onSelect, onClose]);

  const columns = useMemo<ColumnDef<EquipItem, unknown>[]>(() => [
    { accessorKey: "equipCode", header: "설비코드", size: 160 },
    { accessorKey: "equipName", header: "설비명", size: 200 },
    { accessorKey: "equipType", header: "유형", size: 100 },
    { accessorKey: "lineCode", header: "라인", size: 90 },
    { accessorKey: "processCode", header: "공정", size: 100 },
  ], []);

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="설비 검색" size={modalSize}>
      <div className="flex items-end gap-2 mb-3">
        <Input placeholder="설비코드·설비명 검색" value={keyword} onChange={(e) => setKeyword(e.target.value)} leftIcon={<Search className="w-4 h-4" />} fullWidth />
      </div>
      <DataGrid
        data={filtered}
        columns={columns}
        isLoading={loading}
        onRowClick={handleRowClick}
        pageSize={15}
        enableColumnFilter={false}
        enableColumnReordering={false}
      />
    </Modal>
  );
}
