/**
 * @file routing-material-columns.tsx
 * @description 라우팅관리 투입자재 그리드 컬럼 (RoutingMaterialEditor)
 *
 * - 선택: 이 공정에 배정할 자재. 다른 공정 배정·BOM 불일치·이미 저장된 배정은 체크를 바꿀 수 없다.
 * - 자재: 자재명 뒤에 [자재코드]. BOM에 없으면 사유를 함께 보여 준다.
 * - 관리: 이 공정에 저장된 배정만 명시적으로 삭제 요청한다.
 * 입력 칸(체크박스·수량·투입방식)은 행 데이터를 읽기만 하고 변경은 onChange 로 올린다.
 */
import type { ColumnDef } from "@tanstack/react-table";
import { AlertTriangle, Trash2 } from "lucide-react";
import type { EditableRoutingMaterial } from "../types";

interface Handlers {
  /** 편집 중인 공정 순번 */
  seq: number;
  onChange: (childItemCode: string, patch: Partial<EditableRoutingMaterial>) => void;
  onDelete: (row: EditableRoutingMaterial) => void;
}

const inOtherProcess = (row: EditableRoutingMaterial, seq: number) => row.assignedProcessSeq != null && row.assignedProcessSeq !== seq;

export function routingMaterialColumns({ seq, onChange, onDelete }: Handlers): ColumnDef<EditableRoutingMaterial, unknown>[] {
  return [
    {
      id: "select",
      header: "선택",
      size: 60,
      enableSorting: false,
      meta: { align: "center", filterType: "none" },
      cell: ({ row }) => {
        const x = row.original;
        const locked = inOtherProcess(x, seq) || x.bomMatchYn === "N" || x.assignedProcessSeq === seq || x.selectableYn === "N";
        return (
          <input
            type="checkbox"
            checked={x.selected && !x.deleteRequested}
            disabled={locked}
            onChange={(e) => onChange(x.childItemCode, { selected: e.target.checked, deleteRequested: false })}
          />
        );
      },
    },
    {
      id: "childItemName",
      accessorFn: (x) => x.childItemName ?? x.childItemCode,
      header: "자재",
      size: 240,
      meta: { filterType: "text" },
      cell: ({ row }) => {
        const x = row.original;
        return (
          <>
            {x.childItemName ?? x.childItemCode}
            <small className="ml-1">[{x.childItemCode}]</small>
            {x.bomMatchYn === "N" && (
              <div className="flex items-center gap-1 text-amber-700"><AlertTriangle className="h-3 w-3" />{x.mismatchReason ?? "현재 BOM에 없음"}</div>
            )}
          </>
        );
      },
    },
    {
      id: "bomMatch",
      accessorFn: (x) => (x.bomMatchYn === "N" ? "불일치" : "일치"),
      header: "BOM 일치",
      size: 80,
      meta: { align: "center", filterType: "multi" },
    },
    {
      id: "assignedProcessSeq",
      accessorFn: (x) => (x.assignedProcessSeq == null ? "-" : `${x.assignedProcessSeq}${inOtherProcess(x, seq) ? " (다른 공정)" : ""}`),
      header: "배정 공정",
      size: 100,
      meta: { align: "center", filterType: "text" },
    },
    {
      id: "bomQty",
      accessorFn: (x) => x.bomQty ?? "-",
      header: "BOM 수량",
      size: 80,
      meta: { align: "center", filterType: "none" },
    },
    {
      id: "allocQty",
      header: "투입수량",
      size: 110,
      enableSorting: false,
      meta: { filterType: "none" },
      cell: ({ row }) => {
        const x = row.original;
        return (
          <input
            className="w-24 border bg-surface p-1 text-right"
            type="number"
            min="0.000001"
            step="0.000001"
            value={x.allocQtyInput}
            disabled={!x.selected || inOtherProcess(x, seq) || x.deleteRequested}
            onChange={(e) => onChange(x.childItemCode, { allocQtyInput: e.target.value })}
          />
        );
      },
    },
    {
      id: "issueMethod",
      header: "투입방식",
      size: 100,
      enableSorting: false,
      meta: { filterType: "none" },
      cell: ({ row }) => {
        const x = row.original;
        return (
          <select
            className="border bg-surface p-1"
            value={x.issueMethod}
            disabled={!x.selected || inOtherProcess(x, seq) || x.deleteRequested}
            onChange={(e) => onChange(x.childItemCode, { issueMethod: e.target.value as "BACKFLUSH" | "PRE_ISSUE" })}
          >
            <option value="BACKFLUSH">백플러시</option>
            <option value="PRE_ISSUE">선투입</option>
          </select>
        );
      },
    },
    {
      id: "actions",
      header: "관리",
      size: 50,
      enableSorting: false,
      meta: { align: "center", filterType: "none" },
      cell: ({ row }) => row.original.assignedProcessSeq === seq && (
        <button title="명시적 삭제" onClick={(e) => { e.stopPropagation(); onDelete(row.original); }}>
          <Trash2 className="h-3.5 w-3.5 text-red-500" />
        </button>
      ),
    },
  ];
}
