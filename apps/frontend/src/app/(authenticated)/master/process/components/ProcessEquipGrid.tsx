"use client";

import { useMemo, useState } from "react";
import { useTranslation } from "react-i18next";
import { Monitor, Plus, Trash2, Save } from "lucide-react";
import { Card, CardContent, ComCodeBadge, Button } from "@/components/ui";
import DataGrid from "@/components/data-grid/DataGrid";
import StatusHeaderHelp from "@/components/shared/StatusHeaderHelp";
import StatusBadge from "@/components/shared/StatusBadge";
import { ProdLineSelect } from "@/components/shared";
import { ColumnDef } from "@tanstack/react-table";
import type { Equipment } from "../types";

interface ProcessEquipGridProps {
  processCode: string;
  processName: string;
  equipments: Equipment[];
  isLoading: boolean;
  onAdd: () => void;
  onRemove: (equipment: Equipment) => void;
  onLineChange: (equipment: Equipment, lineCode: string) => void;
}

export default function ProcessEquipGrid({
  processCode,
  processName,
  equipments,
  isLoading,
  onAdd,
  onRemove,
  onLineChange,
}: ProcessEquipGridProps) {
  const { t } = useTranslation();
  // 라인 편집 대기값 (행별) — 저장 버튼으로 확정
  const [pendingLines, setPendingLines] = useState<Record<string, string>>({});

  const columns = useMemo<ColumnDef<Equipment>[]>(
    () => [
      { accessorKey: "equipCode", header: t("equipment.master.equipCode", { defaultValue: "설비코드" }), size: 120 },
      { accessorKey: "equipName", header: t("equipment.master.equipName", { defaultValue: "설비명" }), size: 160 },
      {
        accessorKey: "equipType",
        header: t("equipment.master.equipType", { defaultValue: "설비유형" }),
        size: 110,
        cell: ({ getValue }) => {
          const v = getValue() as string | null;
          return v ? <ComCodeBadge groupCode="MACHINE TYPE" code={v} /> : "-";
        },
      },
      { accessorKey: "modelName", header: t("equipment.master.modelName", { defaultValue: "모델명" }), size: 130, cell: ({ getValue }) => (getValue() as string) || "-" },
      { accessorKey: "maker", header: t("equipment.master.maker", { defaultValue: "제조사" }), size: 110, cell: ({ getValue }) => (getValue() as string) || "-" },
      {
        accessorKey: "lineCode",
        header: t("equipment.master.lineCode", { defaultValue: "라인코드" }),
        size: 230,
        meta: { filterType: "none" as const },
        cell: ({ row }) => {
          const orig = (row.original.lineCode as string) || "";
          const pending = pendingLines[row.original.equipCode];
          const current = pending ?? orig;
          const dirty = pending !== undefined && pending !== orig;
          return (
            <div className="flex items-center gap-1" onClick={(e) => e.stopPropagation()}>
              <div className="flex-1 min-w-0">
                <ProdLineSelect
                  value={current}
                  onChange={(v) => setPendingLines((p) => ({ ...p, [row.original.equipCode]: v }))}
                  includeUnassigned
                  fullWidth
                  className="!h-8 text-xs"
                />
              </div>
              <button
                onClick={() => {
                  onLineChange(row.original, current);
                  setPendingLines((p) => { const n = { ...p }; delete n[row.original.equipCode]; return n; });
                }}
                disabled={!dirty}
                title={t("common.save", { defaultValue: "저장" })}
                className="p-1.5 rounded text-primary hover:bg-surface disabled:opacity-30 disabled:cursor-not-allowed flex-shrink-0"
              >
                <Save className="w-4 h-4" />
              </button>
            </div>
          );
        },
      },
      {
        accessorKey: "status",
        header: () => <StatusHeaderHelp label={t("equipment.master.status", { defaultValue: "상태" })} codeType="EQUIP_STATUS" align="center" />,
        size: 80,
        cell: ({ getValue }) => <ComCodeBadge groupCode="EQUIP_STATUS" code={getValue() as string} />,
      },
      {
        accessorKey: "useYn",
        header: () => <StatusHeaderHelp label={t("common.useYn", { defaultValue: "사용여부" })} codeType="USE_YN" align="center" />,
        size: 60,
        cell: ({ getValue }) => <StatusBadge codeType="USE_YN" value={getValue() as string} />,
      },
      {
        id: "actions",
        header: "",
        size: 50,
        meta: { align: "center" as const, filterType: "none" as const },
        cell: ({ row }) => (
          <button
            onClick={(event) => {
              event.stopPropagation();
              onRemove(row.original);
            }}
            className="p-1 hover:bg-surface rounded"
          >
            <Trash2 className="w-3.5 h-3.5 text-red-500" />
          </button>
        ),
      },
    ],
    [t, onRemove, onLineChange, pendingLines],
  );

  if (!processCode) {
    return (
      <Card className="flex-1 flex items-center justify-center min-w-0 min-h-0 w-full max-w-full overflow-hidden">
        <div className="text-center text-text-muted">
          <Monitor className="w-12 h-12 mx-auto mb-3 opacity-30" />
          <p className="text-sm">{t("master.process.noProcessSelected")}</p>
        </div>
      </Card>
    );
  }

  return (
    <Card padding="none" className="flex-1 flex flex-col min-w-0 min-h-0 w-full max-w-full overflow-hidden">
      <CardContent className="flex-1 min-w-0 min-h-0 overflow-hidden px-4 pt-1 pb-3">
        <DataGrid
          data={equipments}
          columns={columns}
          isLoading={isLoading}
          enableColumnFilter
          enableExport
          exportFileName={`${processCode}_${t("master.process.assignedEquipments")}`}
          sqlQuery={`SELECT *\nFROM IMCN_MACHINE\nWHERE WORKSTAGE_CODE = :processCode\n  AND ORGANIZATION_ID = :organizationId\nORDER BY MACHINE_CODE`}
          toolbarLeft={
            /* assigned-equipment-toolbar:start */
            <div className="flex min-w-0 items-center gap-2">
              <Button size="sm" className="!h-7 flex-shrink-0 !px-2 !text-xs" onClick={onAdd}>
                <Plus className="mr-1 h-3.5 w-3.5" />
                {t("master.process.assignEquipment", "설비 배치")}
              </Button>
              <h3 className="flex min-w-0 items-center gap-2 text-sm font-semibold text-text">
                <Monitor className="h-4 w-4 flex-shrink-0 text-primary" />
                <span className="whitespace-nowrap">{t("master.process.assignedEquipments")}</span>
                <span className="truncate font-normal text-text-muted">
                  - {processCode} ({processName}) · {equipments.length}{t("common.count", { defaultValue: "건" })}
                </span>
              </h3>
            </div>
            /* assigned-equipment-toolbar:end */
          }
        />
      </CardContent>
    </Card>
  );
}
