import type { ColumnDef } from "@tanstack/react-table";
import type { TFunction } from "i18next";
import { comCodeCell } from "@/components/shared/codeCells";

export interface ProductModelRow {
  partNo: string;
  modelName: string | null;
  modelSpec: string | null;
  customerName: string | null;
  itemCode: string | null;
  itemName: string | null;
  /** BOM 전개 방식 (공통코드 BOM EXPLODE TYPE) */
  bomExplodeType: string | null;
  /** A = 자동 분류, M = 사람이 정함 */
  bomExplodeSource: string | null;
  bomExplodeNote: string | null;
  /** AOI T면 실적이 만드는 품목 */
  topItemCode: string | null;
  topItemName: string | null;
  /** AOI B면 실적이 만드는 품목 */
  bottomItemCode: string | null;
  bottomItemName: string | null;
  /** SUB 공정 품목 (SUB-Assy, 모델 마스터 INSERT_ITEM_CODE) */
  subItemCode: string | null;
  subItemName: string | null;
}

const codeName = (code: string | null, name: string | null) =>
  code ? (name ? `${code} ${name}` : code) : "";

export function productModelColumns(t: TFunction): ColumnDef<ProductModelRow>[] {
  return [
    { accessorKey: "modelName", header: t("productModel.modelName"), size: 220 },
    { accessorKey: "partNo", header: t("productModel.partNo"), size: 180 },
    { accessorKey: "itemCode", header: t("productModel.itemCode"), size: 140 },
    { accessorKey: "bomExplodeType", header: t("productModel.bomExplodeType"), size: 170, cell: comCodeCell("BOM EXPLODE TYPE") },
    { id: "topItem", header: t("productModel.topItem"), size: 260, accessorFn: r => codeName(r.topItemCode, r.topItemName) },
    { id: "bottomItem", header: t("productModel.bottomItem"), size: 260, accessorFn: r => codeName(r.bottomItemCode, r.bottomItemName) },
    { id: "subItem", header: t("productModel.subItem"), size: 260, accessorFn: r => codeName(r.subItemCode, r.subItemName) },
    {
      id: "bomExplodeSource", header: t("productModel.bomExplodeSource"), size: 90,
      accessorFn: r => r.bomExplodeSource === "M" ? t("productModel.sourceManual")
        : r.bomExplodeSource === "A" ? t("productModel.sourceAuto") : "",
    },
    { accessorKey: "bomExplodeNote", header: t("productModel.bomExplodeNote"), size: 320 },
    { accessorKey: "modelSpec", header: t("productModel.modelSpec"), size: 240 },
    { accessorKey: "customerName", header: t("productModel.customerName"), size: 160 },
  ];
}
