"use client";

/**
 * @file master/process/components/ProcessList.tsx
 * @description 공정관리 좌측 패널 - DataGrid 형태의 공정 목록 (IP_PRODUCT_WORKSTAGE)
 *
 * 초보자 가이드:
 * 1. DataGrid로 공정 목록 표시, 행 클릭 시 우측에 배치 설비 표시
 * 2. 선택된 행 하이라이트 (selectedRowId)
 * 3. 수정/삭제 액션 버튼 포함
 */
import { useMemo } from "react";
import { useTranslation } from "react-i18next";
import { Edit2, Trash2, Plus } from "lucide-react";
import { Card, CardContent, ComCodeBadge, Button } from "@/components/ui";
import DataGrid from "@/components/data-grid/DataGrid";
import StatusHeaderHelp from "@/components/shared/StatusHeaderHelp";
import { useComCodeOptions } from "@/hooks/useComCode";
import { ColumnDef } from "@tanstack/react-table";
import type { Process } from "../types";

export type { Process };

interface ProcessListProps {
  processes: Process[];
  selectedCode: string;
  onSelect: (code: string) => void;
  isLoading: boolean;
  equipCounts: Record<string, number>;
  onAdd: () => void;
  onEdit: (item: Process) => void;
  onDelete: (item: Process) => void;
}

export default function ProcessList({
  processes,
  selectedCode,
  onSelect,
  isLoading,
  equipCounts,
  onAdd,
  onEdit,
  onDelete,
}: ProcessListProps) {
  const { t } = useTranslation();

  const codeGroupOptions = useComCodeOptions("WORKSTAGE CODE GROUP");
  const lineCodeOptions = useComCodeOptions("LINE CODE");

  const columns = useMemo<ColumnDef<Process>[]>(
    () => [
      {
        id: "actions",
        header: "",
        size: 60,
        meta: { align: "center" as const, filterType: "none" as const },
        cell: ({ row }) => (
          <div className="flex gap-1">
            <button
              onClick={(e) => {
                e.stopPropagation();
                onEdit(row.original);
              }}
              className="p-1 hover:bg-surface rounded"
            >
              <Edit2 className="w-3.5 h-3.5 text-primary" />
            </button>
            <button
              onClick={(e) => {
                e.stopPropagation();
                onDelete(row.original);
              }}
              className="p-1 hover:bg-surface rounded"
            >
              <Trash2 className="w-3.5 h-3.5 text-red-500" />
            </button>
          </div>
        ),
      },
      {
        accessorKey: "processCode",
        header: t("master.process.processCode"),
        size: 90,
      },
      {
        accessorKey: "processName",
        header: t("master.process.processName"),
        size: 140,
      },
      {
        accessorKey: "processType",
        header: () => (
          <StatusHeaderHelp
            label={t("master.process.processType")}
            codeType="WORKSTAGE TYPE"
            align="center"
          />
        ),
        size: 90,
        cell: ({ getValue }) => (
          <ComCodeBadge groupCode="WORKSTAGE TYPE" code={getValue() as string} />
        ),
      },
      {
        accessorKey: "codeGroup",
        header: t("master.process.codeGroup"),
        size: 90,
        meta: {
          filterType: "multi" as const,
          filterOptions: codeGroupOptions,
        },
        cell: ({ getValue }) => {
          const v = getValue() as string | null;
          return v ? <ComCodeBadge groupCode="WORKSTAGE CODE GROUP" code={v} /> : "-";
        },
      },
      {
        accessorKey: "lineCode",
        header: t("master.process.lineCode"),
        size: 80,
        meta: {
          filterType: "multi" as const,
          filterOptions: lineCodeOptions,
        },
        cell: ({ getValue }) => (getValue() as string) || "-",
      },
      {
        accessorKey: "startYn",
        header: () => (
          <StatusHeaderHelp
            label={t("master.process.startYn")}
            codeType="WORKSTAGE START YN"
            align="center"
          />
        ),
        size: 70,
        meta: { align: "center" as const, filterType: "multi" as const },
        cell: ({ getValue }) => {
          const v = getValue() as string | null;
          return v === "Y" ? (
            <span className="px-1.5 py-0.5 text-xs rounded bg-blue-100 text-blue-700 dark:bg-blue-900 dark:text-blue-300">
              {t("master.process.startYn")}
            </span>
          ) : (
            "-"
          );
        },
      },
      {
        id: "equipCount",
        header: t("master.process.equipCount"),
        size: 60,
        meta: { align: "center" as const, filterType: "none" as const },
        cell: ({ row }) => {
          const count = equipCounts[row.original.processCode] ?? 0;
          return (
            <span
              className={`px-2 py-0.5 text-xs rounded-full ${
                count > 0
                  ? "bg-blue-100 text-blue-700 dark:bg-blue-900 dark:text-blue-300"
                  : "bg-surface text-text-muted"
              }`}
            >
              {count}
            </span>
          );
        },
      },
      {
        accessorKey: "uphValue",
        header: t("master.process.uphValue"),
        size: 70,
        meta: { align: "right" as const },
        cell: ({ getValue }) => {
          const v = getValue() as number | null;
          return v == null ? "-" : v.toLocaleString();
        },
      },
      {
        accessorKey: "sortOrder",
        header: t("master.process.sortOrder"),
        size: 60,
        meta: { align: "right" as const },
      },
    ],
    [t, equipCounts, onEdit, onDelete, codeGroupOptions, lineCodeOptions],
  );

  return (
    <Card className="flex-1 flex flex-col min-h-0">
      <CardContent className="flex-1 min-h-0 overflow-hidden">
        <DataGrid
          data={processes}
          columns={columns}
          isLoading={isLoading}
          enableColumnFilter
          enableExport
          exportFileName={t("master.process.title")}
          onRowClick={(row) => onSelect(row.processCode)}
          selectedRowId={selectedCode}
          getRowId={(row) => row.processCode}
          toolbarLeft={
            <Button size="sm" onClick={onAdd}>
              <Plus className="w-4 h-4 mr-1" />
              {t("master.process.addProcess")}
            </Button>
          }
          sqlQuery={`SELECT *\nFROM IP_PRODUCT_WORKSTAGE\nWHERE ORGANIZATION_ID = :organizationId\nORDER BY WORKSTAGE_SORT_ORDER, WORKSTAGE_CODE`}
        />
      </CardContent>
    </Card>
  );
}
