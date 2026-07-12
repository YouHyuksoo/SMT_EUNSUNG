"use client";

import { useState, type MutableRefObject } from "react";
import type { TFunction } from "i18next";
import { Edit2, ImageIcon, Trash2 } from "lucide-react";
import type { ColumnDef } from "@tanstack/react-table";
import { ComCodeBadge } from "@/components/ui";
import { createPartColumns as createBasePartColumns } from "@/lib/table-utils";
import { Part } from "./types";

interface CreatePartGridColumnsOptions {
  t: TFunction;
  isPanelOpen: boolean;
  panelAnimateRef: MutableRefObject<boolean>;
  guard: (action: () => void) => void;
  onEditPart: (part: Part) => void;
  onDeletePart: (part: Part) => void;
}

/** 품목 썸네일 - 이미지 로드 실패 시 placeholder 아이콘으로 fallback */
function PartImageThumb({ src, alt }: { src: string; alt: string }) {
  const [errored, setErrored] = useState(false);
  if (errored) return <ImageIcon className="w-4 h-4 text-text-muted mx-auto" />;
  return (
    <img
      src={src}
      alt={alt}
      onError={() => setErrored(true)}
      className="w-8 h-8 object-cover rounded border border-border bg-surface mx-auto"
    />
  );
}

export function createPartGridColumns({
  t,
  isPanelOpen,
  panelAnimateRef,
  guard,
  onEditPart,
  onDeletePart,
}: CreatePartGridColumnsOptions): ColumnDef<Part>[] {
  return [
    {
      id: "actions",
      header: t("common.actions"),
      size: 80,
      meta: { align: "center" as const, filterType: "none" as const },
      cell: ({ row }) => (
        <div className="flex gap-1">
          <button
            onClick={(e) => {
              e.stopPropagation();
              guard(() => {
                panelAnimateRef.current = !isPanelOpen;
                onEditPart(row.original);
              });
            }}
            className="p-1 hover:bg-surface rounded"
          >
            <Edit2 className="w-4 h-4 text-primary" />
          </button>
          <button
            onClick={(e) => {
              e.stopPropagation();
              onDeletePart(row.original);
            }}
            className="p-1 hover:bg-surface rounded"
          >
            <Trash2 className="w-4 h-4 text-red-500" />
          </button>
        </div>
      ),
    },
    { accessorKey: "itemNo", header: t("master.part.partNo", "품번"), size: 120, meta: { filterType: "text" as const } },
    {
      accessorKey: "imageUrl",
      header: t("master.part.image", "사진"),
      size: 55,
      meta: { align: "center" as const, filterType: "none" as const },
      cell: ({ getValue, row }) => {
        const imageUrl = getValue() as string | null | undefined;
        return imageUrl ? (
          <PartImageThumb src={imageUrl} alt={row.original.itemName} />
        ) : (
          <ImageIcon className="w-4 h-4 text-text-muted mx-auto" />
        );
      },
    },
    ...createBasePartColumns<Part>(t).map((col) => ({ ...col, size: 140 })),
    {
      accessorKey: "itemType",
      header: t("master.part.type"),
      size: 70,
      meta: { filterType: "multi" as const },
      cell: ({ getValue }) => <ComCodeBadge groupCode="ITEM_TYPE" code={getValue() as string} />,
    },
    {
      accessorKey: "itemClass",
      header: t("master.part.itemClass", "품목분류"),
      size: 80,
      meta: { filterType: "multi" as const },
      cell: ({ getValue }) => <ComCodeBadge groupCode="ITEM_CLASS" code={getValue() as string} />,
    },
    { accessorKey: "modelName", header: t("master.part.modelName", "차종"), size: 100, meta: { filterType: "text" as const }, cell: ({ getValue }) => getValue() || "-" },
    {
      accessorKey: "modelSuffix",
      header: t("master.part.modelSuffix", "모델접미"),
      size: 80,
      meta: { filterType: "multi" as const },
      cell: ({ getValue }) => {
        const v = getValue() as string;
        return <span className="text-xs">{v || "-"}</span>;
      },
    },
    { accessorKey: "spec", header: t("master.part.spec"), size: 130, meta: { filterType: "text" as const } },
    { accessorKey: "rev", header: t("master.part.rev", "Rev"), size: 45 },
    { accessorKey: "markingText", header: t("master.part.markingText", "마킹문구"), size: 120, meta: { filterType: "text" as const }, cell: ({ getValue }) => getValue() || "-" },
    { accessorKey: "custPartNo", header: t("master.part.custPartNo", "고객품번"), size: 120, meta: { filterType: "text" as const }, cell: ({ getValue }) => getValue() || "-" },
    {
      accessorKey: "itemUom",
      header: t("master.part.unit"),
      size: 90,
      cell: ({ getValue }) => <ComCodeBadge groupCode="ITEM_UOM" code={getValue() as string} />,
    },
    { accessorKey: "color", header: t("master.part.color", "색상"), size: 80, meta: { filterType: "text" as const }, cell: ({ getValue }) => getValue() || "-" },
    { accessorKey: "boxQty", header: t("master.part.boxQty", "박스장입수량"), size: 90, meta: { filterType: "number" as const }, cell: ({ getValue }) => { const v = getValue() as number; return v ? v.toLocaleString() : "-"; } },
    { accessorKey: "minPackQty", header: t("master.part.minPackQty", "최소불출단위수량(자재)"), size: 135, meta: { filterType: "number" as const }, cell: ({ getValue }) => { const v = getValue() as number; return v > 0 ? v.toLocaleString() : "-"; } },
    { accessorKey: "lotUnitQty", header: t("master.part.lotUnitQty", "묶음단위수량(생산공정품)"), size: 150, meta: { filterType: "number" as const }, cell: ({ getValue }) => { const v = getValue() as number; return v != null ? v.toLocaleString() : "-"; } },
    { accessorKey: "expiryDate", header: t("master.part.expiryDate", "유효기간"), size: 70, meta: { filterType: "number" as const }, cell: ({ getValue }) => { const v = getValue() as number; return v > 0 ? t("master.part.daysSuffix", "{{count}}일", { count: v }) : "-"; } },
    { accessorKey: "expiryExtDays", header: t("master.part.expiryExtDays", "연장기간"), size: 70, meta: { filterType: "number" as const }, cell: ({ getValue }) => { const v = getValue() as number; return v > 0 ? t("master.part.daysSuffix", "{{count}}일", { count: v }) : "-"; } },
    { accessorKey: "packUnit", header: t("master.part.palletUnit", "팔레트구성단위"), size: 90, meta: { filterType: "number" as const }, cell: ({ getValue }) => { const v = getValue() as number; return v ? v.toLocaleString() : "-"; } },
    { accessorKey: "storageLocation", header: t("master.part.storageLocation", "품목고정 적재로케이션"), size: 130, cell: ({ getValue }) => getValue() || "-" },
    {
      accessorKey: "mesDisplayYn",
      header: t("common.useYn", "사용여부"),
      size: 60,
      meta: { filterType: "multi" as const },
      cell: ({ getValue }) => {
        const v = getValue() as string;
        return (
          <span className={`px-1.5 py-0.5 text-xs rounded ${v === "Y"
            ? "bg-green-100 text-green-700 dark:bg-green-900 dark:text-green-300"
            : "bg-red-100 text-red-700 dark:bg-red-900 dark:text-red-300"}`}>
            {v === "Y" ? "Y" : "N"}
          </span>
        );
      },
    },
  ];
}
