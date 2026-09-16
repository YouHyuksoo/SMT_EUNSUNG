import type { ColumnDef } from "@tanstack/react-table";
import type { TFunction } from "i18next";

export interface ProductModelRow {
  partNo: string;
  modelName: string | null;
  modelSpec: string | null;
  customerName: string | null;
}

export function productModelColumns(t: TFunction): ColumnDef<ProductModelRow>[] {
  return [
    { accessorKey: "modelName", header: t("productModel.modelName"), size: 220 },
    { accessorKey: "partNo", header: t("productModel.partNo"), size: 200 },
    { accessorKey: "modelSpec", header: t("productModel.modelSpec"), size: 280 },
    { accessorKey: "customerName", header: t("productModel.customerName"), size: 180 },
  ];
}
