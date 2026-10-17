"use client";

/**
 * @file src/app/(authenticated)/master/product-model/page.tsx
 * @description 제품모델관리 — 모델 목록 + BOM 전개 방식 (AOI 실적 생산 품목 · 제품 입고 소비 기준)
 *
 * 초보자 가이드:
 * 1. BOM 전개 방식은 AOI 실적이 어느 반제품을 만들었는지 정하는 기준이다.
 *    설계: docs/specs/2026-10-17-wip-semi-product-from-aoi-design.md
 * 2. "자동 분류"는 BOM 모양·품목명·최근 SMT 런카드 면으로 채운다. 사람이 정한 모델은 건너뛴다.
 * 3. 행을 누르면 그 모델의 전개 방식과 면별 생산 품목을 직접 정한다.
 */
import { useMemo, useState } from "react";
import { useTranslation } from "react-i18next";
import toast from "react-hot-toast";
import { Package, RefreshCw, Search, Wand2 } from "lucide-react";
import { Button, Card, CardContent, Input } from "@/components/ui";
import DataGrid from "@/components/data-grid/DataGrid";
import api from "@/services/api";
import BomExplodeModal from "./BomExplodeModal";
import { productModelColumns, type ProductModelRow } from "./productModelColumns";
import { useProductModels } from "./useProductModels";

export default function ProductModelPage() {
  const { t } = useTranslation();
  const { data, loading, failed, refresh } = useProductModels();
  const [search, setSearch] = useState("");
  const [editing, setEditing] = useState<ProductModelRow | null>(null);
  const [classifying, setClassifying] = useState(false);
  const columns = useMemo(() => productModelColumns(t), [t]);
  const filtered = useMemo(() => {
    const keyword = search.trim().toLocaleLowerCase();
    return data.filter(row => [row.modelName, row.partNo, row.modelSpec, row.customerName, row.itemCode]
      .some(value => (value ?? "").toLocaleLowerCase().includes(keyword)));
  }, [data, search]);
  const unclassified = data.filter(row => !row.bomExplodeType || row.bomExplodeType === "NONE").length;

  const classify = async () => {
    setClassifying(true);
    try {
      const res = await api.post<{ data: { classified: number; skippedManual: number } }>(
        "/master/product-models/bom-explode/classify", {});
      const r = res.data?.data;
      toast.success(t("productModel.classifyDone", { classified: r?.classified ?? 0, skipped: r?.skippedManual ?? 0 }));
      refresh();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(message ?? t("common.saveError"));
    } finally {
      setClassifying(false);
    }
  };

  return (
    <main className="flex h-full min-w-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold">
            <Package className="h-6 w-6 text-primary" />{t("menu.master.productModel")}
          </h1>
          <p className="mt-1 text-text-muted">
            {t("productModel.subtitle")} ({filtered.length} / {data.length} · {t("productModel.unclassifiedCount", { count: unclassified })})
          </p>
        </div>
        <div className="flex gap-2">
          <Button variant="secondary" onClick={classify} disabled={classifying || loading}>
            <Wand2 className="mr-1 h-4 w-4" />{t("productModel.classify")}
          </Button>
          <Button variant="secondary" onClick={refresh} disabled={loading}>
            <RefreshCw className={`mr-1 h-4 w-4 ${loading ? "animate-spin" : ""}`} />
            {t("common.refresh")}
          </Button>
        </div>
      </header>
      {failed && <p role="alert" className="text-red-600">{t("common.loadError")}</p>}
      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid data={filtered} columns={columns} isLoading={loading} pageSize={50}
            enableColumnFilter enableExport exportFileName="product-models"
            onRowClick={row => setEditing(row)}
            toolbarLeft={<Input value={search} onChange={event => setSearch(event.target.value)}
              placeholder={t("productModel.search")} aria-label={t("productModel.search")}
              leftIcon={<Search className="h-4 w-4" />} className="w-80" />}
          />
        </CardContent>
      </Card>
      <BomExplodeModal row={editing} onClose={() => setEditing(null)}
        onSaved={() => { setEditing(null); refresh(); }} />
    </main>
  );
}
