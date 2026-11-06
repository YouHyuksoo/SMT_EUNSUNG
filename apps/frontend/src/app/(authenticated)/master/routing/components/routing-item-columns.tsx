/**
 * @file routing-item-columns.tsx
 * @description 라우팅관리 적용 품목 그리드 컬럼 (RoutingItemPanel)
 *
 * - 품목: 품명 뒤에 [품목코드]를 붙여 보여준다.
 * - 투입자재: 이 라우팅에서 그 품목에 배정된 자재 건수
 * - 관리(맨 앞): 라우팅에서 빼기. 버튼 클릭은 행 선택으로 번지지 않는다.
 */
import type { ColumnDef } from "@tanstack/react-table";
import { Trash2 } from "lucide-react";
import type { RoutingItem } from "../types";

export function routingItemColumns({ onRemove }: { onRemove: (item: RoutingItem) => void }): ColumnDef<RoutingItem, unknown>[] {
  return [
    {
      id: "actions",
      header: "관리",
      size: 50,
      enableSorting: false,
      meta: { align: "center", filterType: "none" },
      cell: ({ row }) => (
        <button title="라우팅에서 빼기" onClick={(e) => { e.stopPropagation(); onRemove(row.original); }}>
          <Trash2 className="h-3.5 w-3.5 text-red-500" />
        </button>
      ),
    },
    {
      id: "itemName",
      accessorFn: (item) => item.itemName,
      header: "품목",
      size: 240,
      meta: { filterType: "text" },
      cell: ({ row }) => (
        <>
          {row.original.itemName}
          <small className="ml-1">[{row.original.itemCode}]</small>
        </>
      ),
    },
    {
      accessorKey: "modelName",
      header: "모델",
      size: 140,
      meta: { filterType: "text" },
      cell: ({ row }) => row.original.modelName ?? "-",
    },
    {
      id: "itemDivision",
      accessorFn: (item) => (item.itemDivision === "F" ? "완제품" : "반제품"),
      header: "구분",
      size: 70,
      meta: { align: "center", filterType: "multi" },
    },
    {
      id: "materialCount",
      accessorFn: (item) => item.materialCount,
      header: "투입자재",
      size: 80,
      meta: { align: "center", filterType: "number" },
      cell: ({ row }) => `${row.original.materialCount}건`,
    },
  ];
}
