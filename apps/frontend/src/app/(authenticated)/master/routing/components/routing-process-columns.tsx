/**
 * @file src/app/(authenticated)/master/routing/components/routing-process-columns.tsx
 * @description 라우팅관리 공정 구성 그리드 컬럼 (RoutingGroupManager 오른쪽 목록)
 *
 * - 공정: 공정명 뒤에 [공정코드]를 붙여 보여준다.
 * - 구분: executionType SUBCON → 외주, 그 외 → 내작
 * - 관리(맨 앞): 수정/삭제 버튼. 버튼 클릭은 행 선택으로 번지지 않는다.
 */
import type { ColumnDef } from "@tanstack/react-table";
import { Edit2, Trash2 } from "lucide-react";
import type { RoutingProcessItem } from "../types";

interface RoutingProcessColumnHandlers {
  onEdit: (process: RoutingProcessItem) => void;
  onDelete: (process: RoutingProcessItem) => void;
}

export function routingProcessColumns({ onEdit, onDelete }: RoutingProcessColumnHandlers): ColumnDef<RoutingProcessItem, unknown>[] {
  return [
    {
      id: "actions",
      header: "관리",
      size: 70,
      enableSorting: false,
      meta: { align: "center", filterType: "none" },
      cell: ({ row }) => (
        <div className="flex justify-center gap-1">
          <button onClick={(e) => { e.stopPropagation(); onEdit(row.original); }}>
            <Edit2 className="h-3.5 w-3.5" />
          </button>
          <button onClick={(e) => { e.stopPropagation(); onDelete(row.original); }}>
            <Trash2 className="h-3.5 w-3.5 text-red-500" />
          </button>
        </div>
      ),
    },
    {
      accessorKey: "seq",
      header: "순번",
      size: 60,
      meta: { align: "center", filterType: "number" },
    },
    {
      id: "workstageName",
      accessorFn: (p) => p.workstageName ?? p.workstageCode,
      header: "공정",
      size: 220,
      meta: { filterType: "text" },
      cell: ({ row }) => (
        <>
          {row.original.workstageName ?? row.original.workstageCode}
          <small className="ml-1">[{row.original.workstageCode}]</small>
        </>
      ),
    },
    {
      id: "executionType",
      accessorFn: (p) => (p.executionType === "SUBCON" ? "외주" : "내작"),
      header: "구분",
      size: 70,
      meta: { align: "center", filterType: "multi" },
    },
    {
      accessorKey: "jobOrderYn",
      header: "작업지시",
      size: 80,
      meta: { align: "center", filterType: "multi" },
    },
    {
      accessorKey: "useYn",
      header: "사용",
      size: 60,
      meta: { align: "center", filterType: "multi" },
    },
  ];
}
