"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import { Coins, Plus, RefreshCw, Search, X } from "lucide-react";
import { Button, Card, CardContent, Input } from "@/components/ui";
import DataGrid from "@/components/data-grid/DataGrid";
import ComCodeSelect from "@/components/shared/ComCodeSelect";
import SupplierSelect from "@/components/shared/SupplierSelect";
import PartSearchModal, { type PartItem } from "@/components/shared/PartSearchModal";
import api from "@/services/api";
import { createPurchasePriceGridColumns } from "./purchasePriceColumns";
import type { PurchasePriceItem } from "./types";
import PurchasePriceFormPanel from "./components/PurchasePriceFormPanel";

const today = () => new Date().toISOString().slice(0, 10);

export default function PurchasePricePage() {
  const [data, setData] = useState<PurchasePriceItem[]>([]);
  const [loading, setLoading] = useState(false);
  const [baseDate, setBaseDate] = useState(today);
  const [validOnly, setValidOnly] = useState(true);
  const [item, setItem] = useState<PartItem | null>(null);
  const [supplierCode, setSupplierCode] = useState("");
  const [lineType, setLineType] = useState("");
  const [priceType, setPriceType] = useState("");
  const [partSearchOpen, setPartSearchOpen] = useState(false);
  const [panelOpen, setPanelOpen] = useState(false);
  const [editingItem, setEditingItem] = useState<PurchasePriceItem | null>(null);

  const fetchData = useCallback(async () => {
    setLoading(true);
    try {
      const params: Record<string, string> = { limit: "5000", baseDate, validOnly: validOnly ? "Y" : "N" };
      if (item?.itemCode) params.itemCode = item.itemCode;
      if (supplierCode) params.supplierCode = supplierCode;
      if (lineType) params.lineType = lineType;
      if (priceType) params.priceType = priceType;
      const response = await api.get("/master/purchase-prices", { params });
      setData(response.data?.data ?? []);
    } catch {
      setData([]);
    } finally {
      setLoading(false);
    }
  }, [baseDate, validOnly, item, supplierCode, lineType, priceType]);

  useEffect(() => { void fetchData(); }, [fetchData]);
  const columns = useMemo(() => createPurchasePriceGridColumns(), []);

  const openCreate = () => {
    setEditingItem(null);
    setPanelOpen(true);
  };

  const openEdit = (row: PurchasePriceItem) => {
    setEditingItem(row);
    setPanelOpen(true);
  };

  return (
    <div className="flex h-full overflow-hidden">
      <main className="flex flex-1 min-w-0 flex-col gap-3 p-5">
        <header className="flex items-center justify-between gap-4">
          <div className="min-w-0">
            <h1 className="flex items-center gap-2 text-xl font-bold text-text">
              <Coins className="h-6 w-6 text-primary" />구매단가관리
            </h1>
            <p className="mt-1 text-sm text-text-muted">품목·공급사별 적용 기간과 구매단가를 관리합니다.</p>
          </div>
          <div className="flex shrink-0 gap-2">
            <Button variant="secondary" size="sm" onClick={fetchData}>
              <RefreshCw className={`mr-1 h-4 w-4 ${loading ? "animate-spin" : ""}`} />새로고침
            </Button>
            <Button size="sm" onClick={openCreate}><Plus className="mr-1 h-4 w-4" />신규 단가</Button>
          </div>
        </header>

        <Card className="flex-1 min-h-0 overflow-hidden" padding="none">
          <CardContent className="h-full p-3">
            <DataGrid
              data={data}
              columns={columns}
              isLoading={loading}
              onRowClick={openEdit}
              pageSize={50}
              enableColumnFilter
              enableExport
              exportFileName="구매단가관리"
              getRowId={(row) => {
                const value = row as PurchasePriceItem;
                return `${value.dateset}_${value.itemCode}_${value.supplierCode}_${value.lineType}`;
              }}
              toolbarLeft={
                <div className="flex min-w-0 flex-1 flex-wrap items-center gap-2">
                  <Input type="date" value={baseDate} onChange={(event) => setBaseDate(event.target.value)} className="w-36" />
                  <div className="flex h-10 min-w-52 items-center rounded-[var(--radius)] border border-border bg-surface px-2">
                    <button type="button" className="flex min-w-0 flex-1 items-center gap-2 text-sm" onClick={() => setPartSearchOpen(true)}>
                      <Search className="h-4 w-4 shrink-0 text-text-muted" />
                      <span className="truncate">{item ? `${item.itemCode} - ${item.itemName}` : "품목 선택"}</span>
                    </button>
                    {item && <button type="button" title="품목 선택 해제" onClick={() => setItem(null)}><X className="h-4 w-4" /></button>}
                  </div>
                  <SupplierSelect includeAll value={supplierCode} onChange={setSupplierCode} className="w-56" />
                  <ComCodeSelect groupCode="LINE TYPE" value={lineType} onChange={setLineType} className="w-36" />
                  <ComCodeSelect groupCode="PRICE TYPE" value={priceType} onChange={setPriceType} className="w-32" />
                  <label className="flex h-10 items-center gap-2 whitespace-nowrap text-sm text-text">
                    <input type="checkbox" checked={validOnly} onChange={(event) => setValidOnly(event.target.checked)} className="h-4 w-4 accent-primary" />
                    유효단가만
                  </label>
                </div>
              }
            />
          </CardContent>
        </Card>
      </main>

      {panelOpen && (
        <PurchasePriceFormPanel
          editingItem={editingItem}
          onClose={() => setPanelOpen(false)}
          onSaved={() => { setPanelOpen(false); void fetchData(); }}
        />
      )}
      <PartSearchModal isOpen={partSearchOpen} onClose={() => setPartSearchOpen(false)} onSelect={(selected) => { setItem(selected); setPartSearchOpen(false); }} />
    </div>
  );
}
