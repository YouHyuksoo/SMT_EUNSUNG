/**
 * @file src/app/(authenticated)/master/interlock-condition/columns.tsx
 * @description 인터락조건관리 그리드 컬럼
 */
import type { ColumnDef } from "@tanstack/react-table";
import type { ComCodeItem } from "@/hooks/useComCode";
import { formatDisplayDate } from "@/utils/date";
import type { InterlockCondition } from "./types";

const codeName = (code: string | null, name: string | null) => (code ? (name ? `${code} - ${name}` : code) : "");

export function interlockColumns(checkTypes: Record<string, ComCodeItem>): ColumnDef<InterlockCondition, unknown>[] {
  return [
    { accessorKey: "lineCode", header: "라인", size: 110, meta: { filterType: "multi" }, cell: (ctx) => codeName(ctx.row.original.lineCode, ctx.row.original.lineName) },
    { accessorKey: "workstageCode", header: "공정", size: 140, meta: { filterType: "multi" }, cell: (ctx) => codeName(ctx.row.original.workstageCode, ctx.row.original.workstageName) },
    { accessorKey: "machineCode", header: "설비", size: 110, meta: { filterType: "text" }, cell: (ctx) => ctx.row.original.machineCode ?? "전체" },
    { accessorKey: "checkSequence", header: "순서", size: 60, meta: { align: "right", filterType: "number" } },
    {
      id: "interlockCheckType",
      accessorFn: (row) => checkTypes[row.interlockCheckType]?.codeName ?? row.interlockCheckType,
      header: "검사유형",
      size: 320,
      meta: { filterType: "multi" },
      cell: (ctx) => (
        <span title={ctx.row.original.interlockCheckType}>
          <span className="font-mono text-text-muted">{ctx.row.original.interlockCheckType}</span>
          {checkTypes[ctx.row.original.interlockCheckType] && <span className="ml-1">{checkTypes[ctx.row.original.interlockCheckType].codeName}</span>}
        </span>
      ),
    },
    { accessorKey: "checkLimitTime", header: "검사한계시간", size: 100, meta: { align: "right", filterType: "number" } },
    { accessorKey: "itemCode", header: "품목코드", size: 130, meta: { filterType: "text" }, cell: (ctx) => ctx.row.original.itemCode === "*" ? "* (전 품목)" : ctx.row.original.itemCode ?? "" },
    { accessorKey: "itemName", header: "품목명", size: 180, meta: { filterType: "text" } },
    { accessorKey: "modelName", header: "모델명", size: 140, meta: { filterType: "text" } },
    {
      accessorKey: "useYn",
      header: "사용",
      size: 60,
      meta: { align: "center", filterType: "multi" },
      cell: (ctx) => <span className={ctx.row.original.useYn === "N" ? "text-red-600 dark:text-red-400" : ""}>{ctx.row.original.useYn === "N" ? "미사용" : "사용"}</span>,
    },
    { accessorKey: "lastModifyBy", header: "수정자", size: 90, meta: { filterType: "text" } },
    { accessorKey: "lastModifyDate", header: "수정일시", size: 140, cell: (ctx) => formatDisplayDate(ctx.row.original.lastModifyDate) },
  ];
}
