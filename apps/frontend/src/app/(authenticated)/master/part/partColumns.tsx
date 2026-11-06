"use client";

/**
 * @file src/app/(authenticated)/master/part/partColumns.tsx
 * @description 품목마스터 그리드 컬럼 — ID_ITEM 109개 컬럼 전부.
 *
 * 컬럼 순서·라벨은 @smt/shared ITEM_MASTER_COLUMNS 의 구역 순서(기본정보 → … → 이력)를 따르고,
 * 맨 앞은 품목코드 → 품명이다 (gridItemColumnOrder 규칙).
 * 기준코드 컬럼은 코드 뜻을 배지로, 날짜는 KST 일자로 보여 준다. 코드성 컬럼은 다중선택 필터다.
 */
import type { MutableRefObject } from "react";
import type { TFunction } from "i18next";
import { Edit2, Trash2 } from "lucide-react";
import type { ColumnDef } from "@tanstack/react-table";
import type { ItemMasterColumn } from "@smt/shared";
import { ComCodeBadge } from "@/components/ui";
import { kstDate, kstDateTime, ORDERED_ITEM_COLUMNS } from "./components/PartFieldHelp";
import { Part } from "./types";

interface CreatePartGridColumnsOptions {
  t: TFunction;
  isPanelOpen: boolean;
  panelAnimateRef: MutableRefObject<boolean>;
  guard: (action: () => void) => void;
  onEditPart: (part: Part) => void;
  onDeletePart: (part: Part) => void;
}

/** 다중선택 필터를 거는 입력 방식 */
const MULTI_INPUTS = new Set(["code", "yn", "abc", "supplier", "customer", "line"]);

/** 고정 폭 — 긴 글자 컬럼 */
const WIDE = new Set(["itemName", "spec", "imageUrl", "remark", "ecoCheckComments", "hsName", "hsSpec", "hsNameSale", "itemNo"]);

function columnDef(col: ItemMasterColumn): ColumnDef<Part> {
  const right = col.type === "number";
  const filterType = MULTI_INPUTS.has(col.input) ? "multi" : right ? "number" : "text";
  return {
    id: col.key,
    accessorKey: col.key,
    header: col.label,
    size: WIDE.has(col.key) ? 200 : Math.max(80, col.label.length * 14 + 30),
    meta: { filterType, ...(right ? { align: "right" as const } : {}) },
    cell: ({ getValue }) => {
      const value = getValue();
      if (value === null || value === undefined || value === "") return "";
      if (col.input === "code" && col.codeGroup) {
        return <ComCodeBadge groupCode={col.codeGroup} code={String(value)} />;
      }
      if (col.type === "date") return col.section === "audit" ? kstDateTime(value) : kstDate(value);
      if (col.type === "number") return Number(value).toLocaleString();
      return String(value);
    },
  };
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
    ...ORDERED_ITEM_COLUMNS.map(columnDef),
  ];
}
