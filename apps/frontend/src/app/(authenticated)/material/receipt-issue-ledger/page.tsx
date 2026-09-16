"use client";

/**
 * @file 자재입출고수불원장 화면
 *
 * 레거시 PowerBuilder `w_mat_ledger_report`(메뉴 '자재입출고수불원장')를 옮긴 것이다.
 * 레거시는 라디오 5개로 dw_1~dw_5를 bringtotop 전환한다. 웹에서는 탭으로 구현한다.
 * 설계: docs/specs/2026-09-16-material-receipt-issue-ledger-design.md
 */

import { useCallback, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";
import { ClipboardList, RefreshCw } from "lucide-react";
import { Button, Card, CardContent } from "@/components/ui";
import DataGrid from "@/components/data-grid/DataGrid";
import { getRecentDaysRange } from "@/utils/date";
import LedgerFilters from "./LedgerFilters";
import { LEDGER_ROW_LIMIT, useLedgerQuery } from "./useLedgerQuery";
import {
  feederLayoutColumns,
  issueLossColumns,
  ledgerColumns,
  receiptBarcodeColumns,
  workstageLedgerColumns,
} from "./ledgerColumns";
import {
  LEDGER_MODES,
  createEmptyFilters,
  type LedgerFilterState,
  type LedgerMode,
} from "./types";

export default function ReceiptIssueLedgerPage() {
  const { t } = useTranslation();
  const initialRange = useMemo(() => getRecentDaysRange(7), []);
  const [mode, setMode] = useState<LedgerMode>("ledger");
  const [filters, setFilters] = useState<LedgerFilterState>(() =>
    createEmptyFilters(initialRange.from, initialRange.to));
  const { rows, total, loading, error, loaded, search, reset } = useLedgerQuery();

  const patchFilters = useCallback((patch: Partial<LedgerFilterState>) => {
    setFilters(prev => ({ ...prev, ...patch }));
  }, []);

  const changeMode = useCallback((next: LedgerMode) => {
    setMode(next);
    reset();
  }, [reset]);

  const runSearch = useCallback(() => {
    void search(mode, filters);
  }, [search, mode, filters]);

  const columns = useMemo(() => {
    switch (mode) {
      case "ledger": return ledgerColumns(t);
      case "workstage": return workstageLedgerColumns(t);
      case "barcodes": return receiptBarcodeColumns(t);
      case "feederLayout": return feederLayoutColumns(t);
      case "issueLoss": return issueLossColumns(t);
    }
  }, [mode, t]);

  const truncated = total > rows.length;

  return (
    <main className="flex h-full min-w-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold">
            <ClipboardList className="h-6 w-6 text-primary" />
            {t("menu.material.receiptIssueLedger")}
          </h1>
          <p className="mt-1 text-text-muted">
            {loaded
              ? t("materialLedger.resultCount", { shown: rows.length, total })
              : t("materialLedger.searchPrompt")}
          </p>
        </div>
        <Button variant="secondary" onClick={runSearch} disabled={loading}>
          <RefreshCw className={`mr-1 h-4 w-4 ${loading ? "animate-spin" : ""}`} />
          {t("common.refresh")}
        </Button>
      </header>

      <nav className="flex flex-wrap gap-1 border-b border-border" aria-label={t("materialLedger.modeTabs")}>
        {LEDGER_MODES.map(item => (
          <button
            key={item}
            type="button"
            onClick={() => changeMode(item)}
            aria-current={mode === item ? "page" : undefined}
            className={`px-4 py-2 text-sm font-medium transition-colors ${
              mode === item
                ? "border-b-2 border-primary text-primary"
                : "text-text-muted hover:text-text"
            }`}
          >
            {t(`materialLedger.mode.${item}`)}
          </button>
        ))}
      </nav>

      <LedgerFilters
        mode={mode}
        filters={filters}
        onChange={patchFilters}
        onSearch={runSearch}
        loading={loading}
      />

      {mode === "issueLoss" && (
        <p className="text-sm text-text-muted">{t("materialLedger.notice.issueLossEndDate")}</p>
      )}
      {mode === "feederLayout" && (
        <p className="text-sm text-text-muted">{t("materialLedger.notice.feederLayoutNoOrg")}</p>
      )}
      {truncated && (
        <p role="status" className="text-sm text-amber-600">
          {t("materialLedger.notice.truncated", { limit: LEDGER_ROW_LIMIT, total })}
        </p>
      )}
      {error && <p role="alert" className="text-red-600">{error}</p>}

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows as never[]}
            columns={columns as never}
            isLoading={loading}
            pageSize={50}
            enableColumnFilter
            enableExport
            exportFileName={`material-ledger-${mode}`}
            emptyMessage={loaded ? t("common.noData") : t("materialLedger.searchPrompt")}
          />
        </CardContent>
      </Card>
    </main>
  );
}
