"use client";

/**
 * @file 자재입출고수불원장 모드별 필터 패널
 *
 * 레거시 `w_mat_ledger_report`는 라디오 모드에 따라 일부 필터를 비활성화한다.
 * (예: 자재위치는 모드 1에서만 enabled=True, 나머지 모드는 '%' 고정 후 enabled=False)
 * 웹에서는 해당 모드가 실제로 쓰는 필터만 렌더한다.
 *
 * 코드성 값은 자유 입력을 만들지 않고 공통코드·기준정보 선택 컴포넌트를 재사용한다.
 * 레거시 uo_basecode 대응 코드타입은 창의 constructor에서 확인했다.
 * - ddlb_deficit        → 'RCV ISS CODE' (R=입고, I=출고)
 * - ddlb_location_code  → 'MATERIAL LOCATION CODE' (M01 원재료양품 …) — 창고 마스터가 아니다
 * - ddlb_inventory_type → 'INVENTORY TYPE' (P=양산, S=샘플)
 */

import { useTranslation } from "react-i18next";
import { Button, Input } from "@/components/ui";
import ComCodeSelect from "@/components/shared/ComCodeSelect";
import ProcessSelect from "@/components/shared/ProcessSelect";
import ProdLineSelect from "@/components/shared/ProdLineSelect";
import SupplierSelect from "@/components/shared/SupplierSelect";
import DateRangeFilter from "@/components/shared/DateRangeFilter";
import UseYnSelect from "@/components/shared/UseYnSelect";
import FilterBar from "@/components/shared/FilterBar";
import type { LedgerFilterState, LedgerMode } from "./types";

interface LedgerFiltersProps {
  mode: LedgerMode;
  filters: LedgerFilterState;
  onChange: (patch: Partial<LedgerFilterState>) => void;
  onSearch: () => void;
  loading: boolean;
}

export default function LedgerFilters({ mode, filters, onChange, onSearch, loading }: LedgerFiltersProps) {
  const { t } = useTranslation();
  const f = (key: string) => t(`materialLedger.filter.${key}`);
  const set = <K extends keyof LedgerFilterState>(key: K) => (value: LedgerFilterState[K]) => onChange({ [key]: value } as Partial<LedgerFilterState>);

  const showDateRange = mode !== "feederLayout";
  const showItemCode = true;
  const showLotNo = mode === "ledger" || mode === "barcodes" || mode === "issueLoss";
  const showKeyitem = mode === "barcodes" || mode === "feederLayout" || mode === "issueLoss";
  const showModelName = mode === "feederLayout" || mode === "issueLoss";
  const showRcvIssCode = mode === "ledger" || mode === "workstage";
  const showLineCode = mode === "ledger" || mode === "issueLoss";

  return (
    <FilterBar>
      {showDateRange && (
        <DateRangeFilter
          from={filters.dateFrom}
          to={filters.dateTo}
          onFromChange={set("dateFrom")}
          onToChange={set("dateTo")}
          label={f("period")}
          presets
        />
      )}

      {showItemCode && (
        <Input
          value={filters.itemCode}
          onChange={event => onChange({ itemCode: event.target.value })}
          placeholder={f("itemCode")}
          aria-label={f("itemCode")}
          className="w-44"
        />
      )}

      {showLotNo && (
        <Input
          value={filters.lotNo}
          onChange={event => onChange({ lotNo: event.target.value })}
          placeholder={f("lotNo")}
          aria-label={f("lotNo")}
          className="w-44"
        />
      )}

      {showModelName && (
        <Input
          value={filters.modelName}
          onChange={event => onChange({ modelName: event.target.value })}
          placeholder={f("modelName")}
          aria-label={f("modelName")}
          className="w-44"
        />
      )}

      {showRcvIssCode && (
        <ComCodeSelect
          groupCode="RCV ISS CODE"
          value={filters.rcvIssCode}
          onChange={set("rcvIssCode")}
          labelPrefix={f("rcvIssCode")}
          aria-label={f("rcvIssCode")}
          includeAll
        />
      )}

      {showLineCode && (
        <ProdLineSelect
          value={filters.lineCode}
          onChange={set("lineCode")}
          labelPrefix={f("lineCode")}
          aria-label={f("lineCode")}
          includeAll
        />
      )}

      {mode === "ledger" && (
        <>
          <ComCodeSelect
            groupCode="MATERIAL LOCATION CODE"
            value={filters.locationCode}
            onChange={set("locationCode")}
            labelPrefix={f("locationCode")}
            aria-label={f("locationCode")}
            includeAll
          />
          <ComCodeSelect
            groupCode="INVENTORY TYPE"
            value={filters.inventoryType}
            onChange={set("inventoryType")}
            labelPrefix={f("inventoryType")}
            aria-label={f("inventoryType")}
            includeAll
          />
          <ProcessSelect
            value={filters.workstageCode}
            onChange={set("workstageCode")}
            labelPrefix={f("workstageCode")}
            aria-label={f("workstageCode")}
          />
          <ComCodeSelect
            groupCode="ISSUE DEFICIT"
            value={filters.issueDeficit}
            onChange={set("issueDeficit")}
            labelPrefix={f("issueDeficit")}
            aria-label={f("issueDeficit")}
            includeAll
          />
          <SupplierSelect
            value={filters.supplierCode}
            onChange={set("supplierCode")}
            aria-label={f("supplierCode")}
            includeAll
          />
          <SupplierSelect
            value={filters.fromSupplierCode}
            onChange={set("fromSupplierCode")}
            aria-label={f("fromSupplierCode")}
            includeAll
          />
          <SupplierSelect
            value={filters.supplierIssue}
            onChange={set("supplierIssue")}
            aria-label={f("supplierIssue")}
            includeAll
          />
          <label className="flex items-center gap-2 text-sm">
            <input
              type="checkbox"
              checked={filters.includeW00}
              onChange={event => onChange({ includeW00: event.target.checked })}
            />
            {f("includeW00")}
          </label>
          <label className="flex items-center gap-2 text-sm">
            <input
              type="checkbox"
              checked={filters.excludeEtcLine}
              onChange={event => onChange({ excludeEtcLine: event.target.checked })}
            />
            {f("excludeEtcLine")}
          </label>
        </>
      )}

      {mode === "barcodes" && (
        <>
          <Input
            value={filters.slipNo}
            onChange={event => onChange({ slipNo: event.target.value })}
            placeholder={f("slipNo")}
            aria-label={f("slipNo")}
            className="w-44"
          />
          <UseYnSelect
            value={filters.lotDivide}
            onChange={set("lotDivide")}
            labelPrefix={f("lotDivide")}
            aria-label={f("lotDivide")}
          />
          <SupplierSelect
            value={filters.supplierCode}
            onChange={set("supplierCode")}
            aria-label={f("supplierCode")}
            includeAll
          />
        </>
      )}

      {showKeyitem && (
        <UseYnSelect
          value={filters.keyitemYn}
          onChange={set("keyitemYn")}
          labelPrefix={f("keyitemYn")}
          aria-label={f("keyitemYn")}
        />
      )}

      <Button onClick={onSearch} disabled={loading}>
        {t("common.search")}
      </Button>
    </FilterBar>
  );
}
