/**
 * @file src/components/shared/ModelSearchModal.tsx
 * @description 모델 검색 공통 모달 — IP_PRODUCT_MODEL_MASTER 기준 (모델코드=PART_NO/모델명/규격/고객명)
 *
 * 표준시간관리·설비마스터 등 모델 선택이 필요한 화면에서 공통으로 사용한다.
 * 사용 예:
 *   <ModelSearchModal isOpen={open} onClose={() => setOpen(false)} onSelect={(m) => setCode(m.partNo)} />
 */

"use client";

import { useState, useCallback, useEffect, useMemo } from "react";
import { Search } from "lucide-react";
import { ColumnDef } from "@tanstack/react-table";
import { Modal, Input } from "@/components/ui";
import DataGrid from "@/components/data-grid/DataGrid";
import api from "@/services/api";

/** 모델 데이터 타입 */
export interface ModelItem {
  partNo: string; // 모델코드(고객사품번)
  modelName: string; // 모델명
  modelSpec: string; // 규격
  customerName: string; // 고객명
}

interface ModelSearchModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSelect: (model: ModelItem) => void;
  modalSize?: "xl" | "2xl";
}

interface ApiModelRow {
  partNo: string;
  modelName: string | null;
  modelSpec: string | null;
  customerName: string | null;
}

export default function ModelSearchModal({ isOpen, onClose, onSelect, modalSize = "2xl" }: ModelSearchModalProps) {
  const [keyword, setKeyword] = useState("");
  const [data, setData] = useState<ModelItem[]>([]);
  const [loading, setLoading] = useState(false);

  const fetchModels = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get("/master/product-models");
      const rows: ApiModelRow[] = res.data?.data?.list ?? res.data?.data ?? [];
      setData(rows.map((r) => ({
        partNo: r.partNo,
        modelName: r.modelName ?? "",
        modelSpec: r.modelSpec ?? "",
        customerName: r.customerName ?? "",
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
    if (!data.length) fetchModels();
  }, [isOpen, data.length, fetchModels]);

  // 통합검색 — 모델코드·모델명·고객명에서 매칭 (클라이언트 필터)
  const filtered = useMemo(() => {
    const q = keyword.trim().toLowerCase();
    if (!q) return data;
    return data.filter((m) => `${m.partNo} ${m.modelName} ${m.customerName}`.toLowerCase().includes(q));
  }, [data, keyword]);

  const handleRowClick = useCallback((row: ModelItem) => {
    onSelect(row);
    onClose();
  }, [onSelect, onClose]);

  const columns = useMemo<ColumnDef<ModelItem, unknown>[]>(() => [
    { accessorKey: "partNo", header: "모델코드", size: 160 },
    { accessorKey: "modelName", header: "모델명", size: 220 },
    { accessorKey: "modelSpec", header: "규격", size: 200 },
    { accessorKey: "customerName", header: "고객명", size: 140 },
  ], []);

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="모델 검색" size={modalSize}>
      <div className="flex items-end gap-2 mb-3">
        <Input
          placeholder="모델코드·모델명·고객명 검색"
          value={keyword}
          onChange={(e) => setKeyword(e.target.value)}
          leftIcon={<Search className="w-4 h-4" />}
          fullWidth
        />
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
