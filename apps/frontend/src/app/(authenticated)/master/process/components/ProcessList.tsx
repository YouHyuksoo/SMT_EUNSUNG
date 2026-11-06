"use client";

/**
 * @file master/process/components/ProcessList.tsx
 * @description 공정관리 좌측 패널 - DataGrid 형태의 공정 목록 (IP_PRODUCT_WORKSTAGE)
 *
 * 초보자 가이드:
 * 1. DataGrid로 공정 목록 표시, 행 클릭 시 우측에 배치 설비 표시
 * 2. 선택된 행 하이라이트 (selectedRowId)
 * 3. 수정/삭제 액션 버튼 포함
 * 4. 툴바 검색어·공정유형·코드그룹으로 화면에서 걸러 본다
 */
import { useMemo, useState } from "react";
import { useTranslation } from "react-i18next";
import { Edit2, Trash2, Search } from "lucide-react";
import { Card, CardContent, ComCodeBadge, Input } from "@/components/ui";
import DataGrid from "@/components/data-grid/DataGrid";
import StatusHeaderHelp from "@/components/shared/StatusHeaderHelp";
import ComCodeSelect from "@/components/shared/ComCodeSelect";
import { useComCodeOptions } from "@/hooks/useComCode";
import { ColumnDef } from "@tanstack/react-table";
import type { Process } from "../types";

/** 공정유형 배지 색 — 제조(I)·최종(L)·검사(Q) */
const PROCESS_TYPE_COLOR: Record<string, string> = {
  I: "bg-blue-100 text-blue-700 dark:bg-blue-500/20 dark:text-blue-300",
  L: "bg-violet-100 text-violet-700 dark:bg-violet-500/20 dark:text-violet-300",
  Q: "bg-amber-100 text-amber-800 dark:bg-amber-500/20 dark:text-amber-300",
};

/** 공정그룹 배지 색 — SMT·후공정(PBA)·포장·수리·창고 */
const CODE_GROUP_COLOR: Record<string, string> = {
  SMT: "bg-sky-100 text-sky-700 dark:bg-sky-500/20 dark:text-sky-300",
  PBA: "bg-emerald-100 text-emerald-700 dark:bg-emerald-500/20 dark:text-emerald-300",
  PACKING: "bg-orange-100 text-orange-700 dark:bg-orange-500/20 dark:text-orange-300",
  REPAIR: "bg-rose-100 text-rose-700 dark:bg-rose-500/20 dark:text-rose-300",
  WAREHOUSE: "bg-slate-200 text-slate-700 dark:bg-slate-500/20 dark:text-slate-300",
};

export type { Process };

interface ProcessListProps {
  processes: Process[];
  selectedCode: string;
  onSelect: (code: string) => void;
  isLoading: boolean;
  equipCounts: Record<string, number>;
  onEdit: (item: Process) => void;
  onDelete: (item: Process) => void;
}

export default function ProcessList({
  processes,
  selectedCode,
  onSelect,
  isLoading,
  equipCounts,
  onEdit,
  onDelete,
}: ProcessListProps) {
  const { t } = useTranslation();

  const codeGroupOptions = useComCodeOptions("WORKSTAGE CODE GROUP");
  const [searchText, setSearchText] = useState("");
  const [processType, setProcessType] = useState("");
  const [codeGroup, setCodeGroup] = useState("");

  const filtered = useMemo(() => {
    const q = searchText.trim().toLowerCase();
    return processes.filter((p) =>
      (!q || p.processCode.toLowerCase().includes(q) || (p.processName ?? "").toLowerCase().includes(q))
      && (!processType || p.processType === processType)
      && (!codeGroup || p.codeGroup === codeGroup),
    );
  }, [processes, searchText, processType, codeGroup]);

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
          <ComCodeBadge groupCode="WORKSTAGE TYPE" code={getValue() as string} colorMap={PROCESS_TYPE_COLOR} />
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
          return v ? <ComCodeBadge groupCode="WORKSTAGE CODE GROUP" code={v} colorMap={CODE_GROUP_COLOR} /> : "-";
        },
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
        accessorKey: "sortOrder",
        header: t("master.process.sortOrder"),
        size: 60,
        meta: { align: "right" as const },
      },
    ],
    [t, equipCounts, onEdit, onDelete, codeGroupOptions],
  );

  return (
    <Card padding="none" className="flex-1 flex flex-col min-w-0 min-h-0 w-full max-w-full overflow-hidden">
      <CardContent className="flex-1 min-w-0 min-h-0 overflow-hidden px-4 py-3">
        <DataGrid
          data={filtered}
          columns={columns}
          isLoading={isLoading}
          enableColumnFilter
          enableExport
          exportFileName={t("master.process.title")}
          onRowClick={(row) => onSelect(row.processCode)}
          selectedRowId={selectedCode}
          getRowId={(row) => row.processCode}
          toolbarLeft={
            <div className="flex flex-wrap gap-3 flex-1 min-w-0">
              <div className="flex-1 min-w-[14rem] max-w-sm">
                <Input placeholder="공정코드·공정명 검색" aria-label="공정 검색" value={searchText}
                  onChange={(e) => setSearchText(e.target.value)}
                  leftIcon={<Search className="w-4 h-4" />} fullWidth />
              </div>
              <div className="w-44 flex-shrink-0">
                <ComCodeSelect groupCode="WORKSTAGE TYPE" value={processType} onChange={setProcessType} labelPrefix={t("master.process.processType")} fullWidth />
              </div>
              <div className="w-44 flex-shrink-0">
                <ComCodeSelect groupCode="WORKSTAGE CODE GROUP" value={codeGroup} onChange={setCodeGroup} labelPrefix={t("master.process.codeGroup")} fullWidth />
              </div>
            </div>
          }
          sqlQuery={`SELECT *\nFROM IP_PRODUCT_WORKSTAGE\nWHERE ORGANIZATION_ID = :organizationId\nORDER BY WORKSTAGE_SORT_ORDER, WORKSTAGE_CODE`}
        />
      </CardContent>
    </Card>
  );
}
