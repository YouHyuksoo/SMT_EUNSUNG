/**
 * @file src/app/(authenticated)/master/label-form/columns.tsx
 * @description 제품별 라벨양식 목록 그리드 컬럼 (앞 칸은 다른 모델로 복사할 양식 선택)
 */
import type { ColumnDef } from "@tanstack/react-table";
import type { ComCodeItem } from "@/hooks/useComCode";
import { formatDisplayDate } from "@/utils/date";
import { labelFormKey, type LabelForm } from "./types";

const size = (bytes: number) => (bytes > 0 ? `${(bytes / 1024).toFixed(1)} KB` : "-");

export function labelFormColumns(
  formTypes: Record<string, ComCodeItem>,
  checked: Set<string>,
  toggle: (key: string) => void,
): ColumnDef<LabelForm, unknown>[] {
  return [
    {
      id: "check",
      header: "복사",
      size: 48,
      enableSorting: false,
      meta: { align: "center" },
      cell: (ctx) => {
        const key = labelFormKey(ctx.row.original);
        return <input type="checkbox" aria-label="복사할 양식 선택" checked={checked.has(key)} onClick={(e) => e.stopPropagation()} onChange={() => toggle(key)} />;
      },
    },
    { accessorKey: "modelName", header: "모델명", size: 180, meta: { filterType: "text" } },
    { accessorKey: "labelFormNo", header: "양식번호", size: 70, meta: { align: "right", filterType: "number" } },
    {
      id: "labelFormType",
      accessorFn: (row) => formTypes[row.labelFormType]?.codeName ?? row.labelFormType,
      header: "유형",
      size: 80,
      meta: { align: "center", filterType: "multi" },
    },
    { accessorKey: "labelFormName", header: "양식 파일", size: 260, meta: { filterType: "text" } },
    { accessorKey: "syntaxSize", header: "파일 크기", size: 80, meta: { align: "right" }, cell: (ctx) => size(ctx.row.original.syntaxSize) },
    { accessorKey: "imageSize", header: "이미지", size: 70, meta: { align: "right" }, cell: (ctx) => size(ctx.row.original.imageSize) },
    {
      accessorKey: "useFlag",
      header: "사용",
      size: 60,
      meta: { align: "center", filterType: "multi" },
      cell: (ctx) => (ctx.row.original.useFlag === "N" ? <span className="text-red-600 dark:text-red-400">미사용</span> : ctx.row.original.useFlag === "Y" ? "사용" : "-"),
    },
    { accessorKey: "comments", header: "비고", size: 160, meta: { filterType: "text" } },
    { accessorKey: "lastModifyBy", header: "수정자", size: 90, meta: { filterType: "text" } },
    { accessorKey: "lastModifyDate", header: "수정일시", size: 140, cell: (ctx) => formatDisplayDate(ctx.row.original.lastModifyDate) },
  ];
}
