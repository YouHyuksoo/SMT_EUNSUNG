/**
 * @file 자재입출고수불원장 5개 모드의 그리드 컬럼 정의
 *
 * 컬럼 구성과 순서는 레거시 DataWindow의 detail band x좌표 순서를 그대로 옮긴 것이다.
 * 설계: docs/specs/2026-09-16-material-receipt-issue-ledger-design.md
 */

import type { ColumnDef } from "@tanstack/react-table";
import type { TFunction } from "i18next";
import type {
  FeederLayoutRow,
  IssueLossRow,
  LedgerRow,
  ReceiptBarcodeRow,
  WorkstageLedgerRow,
} from "./types";

/** 'YYYY-MM-DD HH:mm' — 레거시 [shortdate] [time] 포맷에 대응 */
function formatDateTime(value: unknown): string {
  if (!value) return "";
  const parsed = new Date(String(value));
  if (Number.isNaN(parsed.getTime())) return String(value);
  const pad = (n: number) => String(n).padStart(2, "0");
  return `${parsed.getFullYear()}-${pad(parsed.getMonth() + 1)}-${pad(parsed.getDate())} `
    + `${pad(parsed.getHours())}:${pad(parsed.getMinutes())}`;
}

/** 'YYYY-MM-DD' — 레거시 yyyy/mm/dd 포맷에 대응 */
function formatDate(value: unknown): string {
  if (!value) return "";
  const parsed = new Date(String(value));
  if (Number.isNaN(parsed.getTime())) return String(value);
  const pad = (n: number) => String(n).padStart(2, "0");
  return `${parsed.getFullYear()}-${pad(parsed.getMonth() + 1)}-${pad(parsed.getDate())}`;
}

/** 레거시 ###,###,##0 포맷에 대응 */
function formatQty(value: unknown): string {
  if (value === null || value === undefined || value === "") return "";
  const num = Number(value);
  return Number.isNaN(num) ? String(value) : num.toLocaleString();
}

const dateTimeCell = { cell: (ctx: { getValue: () => unknown }) => formatDateTime(ctx.getValue()) };
const dateCell = { cell: (ctx: { getValue: () => unknown }) => formatDate(ctx.getValue()) };
const qtyCell = {
  cell: (ctx: { getValue: () => unknown }) => formatQty(ctx.getValue()),
  meta: { align: "right" as const },
};

/** 모드 1 — 수불원장 (레거시 d_mat_daily_receipt_issue_rpt, 33컬럼) */
export function ledgerColumns(t: TFunction): ColumnDef<LedgerRow>[] {
  const c = (key: string) => t(`materialLedger.col.${key}`);
  return [
    { accessorKey: "inventoryType", header: c("inventoryType"), size: 100 },
    { accessorKey: "locationCode", header: c("locationCode"), size: 100 },
    { accessorKey: "labelType", header: c("labelType"), size: 90 },
    { accessorKey: "receiptType", header: c("receiptType"), size: 90 },
    { accessorKey: "lotDivideYn", header: c("lotDivideYn"), size: 90 },
    { accessorKey: "lineCode", header: c("lineCode"), size: 90 },
    { accessorKey: "feederLocationCode", header: c("feederLocationCode"), size: 110 },
    { accessorKey: "feederShaft", header: c("feederShaft"), size: 90 },
    { accessorKey: "fromSupplierCode", header: c("fromSupplierCode"), size: 120 },
    { accessorKey: "modelName", header: c("modelName"), size: 140 },
    { accessorKey: "rcvIssCode", header: c("rcvIssCode"), size: 90 },
    { accessorKey: "enterDate", header: c("enterDate"), size: 150, ...dateTimeCell },
    { accessorKey: "locationAddress", header: c("locationAddress"), size: 110 },
    { accessorKey: "itemCode", header: c("itemCode"), size: 140 },
    { accessorKey: "materialMfs", header: c("materialMfs"), size: 140 },
    { accessorKey: "manufactureWeek", header: c("manufactureWeek"), size: 100 },
    { accessorKey: "itemName", header: c("itemName"), size: 180 },
    { accessorKey: "itemSpec", header: c("itemSpec"), size: 180 },
    { accessorKey: "qty", header: c("qty"), size: 100, ...qtyCell },
    { accessorKey: "receiptIssueDeficit", header: c("receiptIssueDeficit"), size: 110 },
    { accessorKey: "invoiceNo", header: c("invoiceNo"), size: 130 },
    { accessorKey: "workstageCode", header: c("workstageCode"), size: 90 },
    { accessorKey: "supplierCode", header: c("supplierCode"), size: 110 },
    { accessorKey: "receiptIssueType", header: c("receiptIssueType"), size: 100 },
    { accessorKey: "receiptIssueStatus", header: c("receiptIssueStatus"), size: 100 },
    { accessorKey: "barcode", header: c("barcode"), size: 160 },
    { accessorKey: "originMfs", header: c("originMfs"), size: 140 },
    { accessorKey: "vendorLotno", header: c("vendorLotno"), size: 130 },
    { accessorKey: "vendorCode", header: c("vendorCode"), size: 110 },
    { accessorKey: "ledRankInfo", header: c("ledRankInfo"), size: 110 },
    { accessorKey: "feedingDate", header: c("feedingDate"), size: 150, ...dateTimeCell },
    { accessorKey: "reelDestroyDate", header: c("reelDestroyDate"), size: 150, ...dateTimeCell },
    { accessorKey: "receiptIssueDate", header: c("receiptIssueDate"), size: 120, ...dateCell },
  ];
}

/** 모드 2 — 공정 수불원장 (레거시 d_mat_ws_receipt_issue_rpt, 9컬럼) */
export function workstageLedgerColumns(t: TFunction): ColumnDef<WorkstageLedgerRow>[] {
  const c = (key: string) => t(`materialLedger.col.${key}`);
  return [
    { accessorKey: "rcvIssCode", header: c("rcvIssCode"), size: 90 },
    { accessorKey: "enterDate", header: c("enterDate"), size: 150, ...dateTimeCell },
    { accessorKey: "locationAddress", header: c("locationAddress"), size: 110 },
    { accessorKey: "itemCode", header: c("itemCode"), size: 140 },
    { accessorKey: "itemName", header: c("itemName"), size: 200 },
    { accessorKey: "itemSpec", header: c("itemSpec"), size: 200 },
    { accessorKey: "qty", header: c("qty"), size: 100, ...qtyCell },
    { accessorKey: "receiptIssueDeficit", header: c("receiptIssueDeficit"), size: 110 },
    { accessorKey: "receiptIssueDate", header: c("receiptIssueDate"), size: 120, ...dateCell },
  ];
}

/** 모드 3 — 입고 바코드 (레거시 d_mat_receipt_barcode_rpt, 27컬럼) */
export function receiptBarcodeColumns(t: TFunction): ColumnDef<ReceiptBarcodeRow>[] {
  const c = (key: string) => t(`materialLedger.col.${key}`);
  return [
    { accessorKey: "lotDivideYn", header: c("lotDivideYn"), size: 90 },
    { accessorKey: "receiptCompareYn", header: c("receiptCompareYn"), size: 100 },
    { accessorKey: "receiptType", header: c("receiptType"), size: 90 },
    { accessorKey: "issueCompareYn", header: c("issueCompareYn"), size: 100 },
    { accessorKey: "issueType", header: c("issueType"), size: 90 },
    { accessorKey: "supplierCode", header: c("supplierCode"), size: 110 },
    { accessorKey: "fromSupplierCode", header: c("fromSupplierCode"), size: 120 },
    { accessorKey: "scanDate", header: c("scanDate"), size: 150, ...dateTimeCell },
    { accessorKey: "locationAddress", header: c("locationAddress"), size: 110 },
    { accessorKey: "itemCode", header: c("itemCode"), size: 140 },
    { accessorKey: "lotNo", header: c("lotNo"), size: 140 },
    { accessorKey: "receiptSlipNo", header: c("receiptSlipNo"), size: 140 },
    { accessorKey: "scanQty", header: c("scanQty"), size: 100, ...qtyCell },
    { accessorKey: "itemBarcode", header: c("itemBarcode"), size: 170 },
    { accessorKey: "receiptCompareDate", header: c("receiptCompareDate"), size: 150, ...dateTimeCell },
    { accessorKey: "issueCompareDate", header: c("issueCompareDate"), size: 150, ...dateTimeCell },
    { accessorKey: "receiptCompareBy", header: c("receiptCompareBy"), size: 110 },
    { accessorKey: "issueCompareBy", header: c("issueCompareBy"), size: 110 },
    { accessorKey: "barcodeStatus", header: c("barcodeStatus"), size: 100 },
    { accessorKey: "supplierBarcode", header: c("supplierBarcode"), size: 170 },
    { accessorKey: "originSupplierCode", header: c("originSupplierCode"), size: 120 },
    { accessorKey: "supplierItemCode", header: c("supplierItemCode"), size: 140 },
    { accessorKey: "supplierLotNo", header: c("supplierLotNo"), size: 140 },
    { accessorKey: "originItemBarcode", header: c("originItemBarcode"), size: 170 },
    { accessorKey: "vendorLotno", header: c("vendorLotno"), size: 130 },
    { accessorKey: "vendorCode", header: c("vendorCode"), size: 110 },
    { accessorKey: "labelType", header: c("labelType"), size: 90 },
  ];
}

/** 모드 4 — 라인 피더 레이아웃 (레거시 d_mat_item_feeder_layout_detail_rpt, 8컬럼) */
export function feederLayoutColumns(t: TFunction): ColumnDef<FeederLayoutRow>[] {
  const c = (key: string) => t(`materialLedger.col.${key}`);
  return [
    { accessorKey: "itemCode", header: c("itemCode"), size: 140 },
    { accessorKey: "itemName", header: c("itemName"), size: 200 },
    { accessorKey: "itemSpec", header: c("itemSpec"), size: 200 },
    { accessorKey: "locationAddress", header: c("locationAddress"), size: 120 },
    { accessorKey: "mslLevel", header: c("mslLevel"), size: 90 },
    { accessorKey: "inventoryQty", header: c("inventoryQty"), size: 110, ...qtyCell },
    { accessorKey: "unitQty", header: c("unitQty"), size: 100, ...qtyCell },
    { accessorKey: "workstageInventoryQty", header: c("workstageInventoryQty"), size: 130, ...qtyCell },
  ];
}

/** 모드 5 — 출고 로스 (레거시 d_mat_item_issue_loss_lst, 13컬럼) */
export function issueLossColumns(t: TFunction): ColumnDef<IssueLossRow>[] {
  const c = (key: string) => t(`materialLedger.col.${key}`);
  return [
    { accessorKey: "issueDate", header: c("issueDate"), size: 120, ...dateCell },
    { accessorKey: "issueSequence", header: c("issueSequence"), size: 90 },
    { accessorKey: "itemCode", header: c("itemCode"), size: 140 },
    { accessorKey: "itemName", header: c("itemName"), size: 180 },
    { accessorKey: "itemSpec", header: c("itemSpec"), size: 180 },
    { accessorKey: "materialMfs", header: c("materialMfs"), size: 140 },
    { accessorKey: "lineCode", header: c("lineCode"), size: 90 },
    { accessorKey: "modelName", header: c("modelName"), size: 140 },
    { accessorKey: "issueQty", header: c("issueQty"), size: 100, ...qtyCell },
    { accessorKey: "enterDate", header: c("enterDate"), size: 150, ...dateTimeCell },
    { accessorKey: "enterBy", header: c("enterBy"), size: 110 },
    { accessorKey: "lastModifyDate", header: c("lastModifyDate"), size: 150, ...dateTimeCell },
    { accessorKey: "lastModifyBy", header: c("lastModifyBy"), size: 110 },
  ];
}
