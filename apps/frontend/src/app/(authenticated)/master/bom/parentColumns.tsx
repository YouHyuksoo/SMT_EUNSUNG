/**
 * @file src/app/(authenticated)/master/bom/parentColumns.tsx
 * @description BOM관리 좌측 제품/반제품(모품목) 그리드 컬럼
 *
 * 순서: 품목코드 · 차종 · 고객 · 구분 · BOM · 품목명 (품목명은 길어서 맨 뒤)
 * - 차종: 모델마스터 PRODUCT_CLASS → 공통코드 PRODUCT CLASS 이름
 * - 구분: 품목구분 ITEM DIVISION (F 제품 / W 반제품 / R 원자재)
 */
import type { ColumnDef } from "@tanstack/react-table";
import type { ParentPart } from "./types";

interface ParentColumnLabels {
  productClass: Record<string, string>;
  itemDivision: Record<string, string>;
}

const codeName = (map: Record<string, string>, code: string | null | undefined) =>
  code ? map[code] || code : "";

export function parentColumns(labels: ParentColumnLabels): ColumnDef<ParentPart, unknown>[] {
  return [
    {
      accessorKey: "itemCode",
      header: "품목코드",
      size: 130,
      meta: { filterType: "text" },
      cell: (c) => <span className="font-mono">{c.getValue() as string}</span>,
    },
    {
      id: "productClass",
      accessorFn: (row) => codeName(labels.productClass, row.productClass),
      header: "차종",
      size: 110,
      meta: { filterType: "text" },
    },
    {
      accessorKey: "customerCode",
      header: "고객",
      size: 70,
      meta: { filterType: "text" },
      cell: (c) => <span className="font-mono">{(c.getValue() as string | null) ?? ""}</span>,
    },
    {
      id: "itemDivision",
      accessorFn: (row) => codeName(labels.itemDivision, row.itemDivision),
      header: "구분",
      size: 64,
      meta: { filterType: "text" },
    },
    {
      accessorKey: "bomCount",
      header: "BOM",
      size: 56,
      meta: { filterType: "number", align: "right" },
    },
    {
      accessorKey: "itemName",
      header: "품목명",
      size: 220,
      meta: { filterType: "text" },
    },
  ];
}
