"use client";

import { useMemo, useState } from "react";
import { useTranslation } from "react-i18next";
import { Package, RefreshCw, Search } from "lucide-react";
import { Button, Card, CardContent, Input } from "@/components/ui";
import DataGrid from "@/components/data-grid/DataGrid";
import { productModelColumns } from "./productModelColumns";
import { useProductModels } from "./useProductModels";

export default function ProductModelPage() {
  const { t } = useTranslation();
  const { data, loading, failed, refresh } = useProductModels();
  const [search, setSearch] = useState("");
  const columns = useMemo(() => productModelColumns(t), [t]);
  const filtered = useMemo(() => {
    const keyword = search.trim().toLocaleLowerCase();
    return data.filter(row => [row.modelName, row.partNo, row.modelSpec, row.customerName]
      .some(value => (value ?? "").toLocaleLowerCase().includes(keyword)));
  }, [data, search]);

  return (
    <main className="flex h-full min-w-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold">
            <Package className="h-6 w-6 text-primary" />{t("menu.master.productModel")}
          </h1>
          <p className="mt-1 text-text-muted">{t("productModel.readOnly")} ({filtered.length} / {data.length})</p>
        </div>
        <Button variant="secondary" onClick={refresh} disabled={loading}>
          <RefreshCw className={`mr-1 h-4 w-4 ${loading ? "animate-spin" : ""}`} />
          {t("common.refresh")}
        </Button>
      </header>
      {failed && <p role="alert" className="text-red-600">{t("common.loadError")}</p>}
      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid data={filtered} columns={columns} isLoading={loading} pageSize={50}
            enableColumnFilter enableExport exportFileName="product-models"
            toolbarLeft={<Input value={search} onChange={event => setSearch(event.target.value)}
              placeholder={t("productModel.search")} aria-label={t("productModel.search")}
              leftIcon={<Search className="h-4 w-4" />} className="w-80" />}
          />
        </CardContent>
      </Card>
    </main>
  );
}
