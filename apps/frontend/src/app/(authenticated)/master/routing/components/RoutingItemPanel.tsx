"use client";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import toast from "react-hot-toast";
import { Plus, RefreshCw, Search, Trash2 } from "lucide-react";
import { Button, ConfirmModal, Input, Modal } from "@/components/ui";
import api from "@/services/api";
import DataGrid from "@/components/data-grid/DataGrid";
import type { RoutingCandidateItem, RoutingItem } from "../types";
import { routingErrorMessage } from "./routing-errors";
import { routingItemColumns } from "./routing-item-columns";

type Props = {
  routingCode: string | null;
  selectedItemCode: string | null;
  onSelectItem: (itemCode: string | null) => void;
  /** 품목을 붙이거나 뗀 뒤 라우팅 목록의 품목 수를 다시 읽게 한다. */
  onChanged: () => void;
  /** 값이 바뀌면 적용 품목을 다시 읽는다 (밖에서 품목을 붙였을 때). */
  reloadKey?: number;
};

const errorMessage = routingErrorMessage;

export default function RoutingItemPanel({ routingCode, selectedItemCode, onSelectItem, onChanged, reloadKey = 0 }: Props) {
  const [items, setItems] = useState<RoutingItem[]>([]);
  const [loading, setLoading] = useState(false);
  const [addOpen, setAddOpen] = useState(false);
  const [removeTarget, setRemoveTarget] = useState<RoutingItem | null>(null);
  const [saving, setSaving] = useState(false);
  const itemColumns = useMemo(() => routingItemColumns({ onRemove: setRemoveTarget }), []);
  const generation = useRef(0);
  const selectedRef = useRef(selectedItemCode);
  useEffect(() => { selectedRef.current = selectedItemCode; }, [selectedItemCode]);

  const load = useCallback(async () => {
    const current = ++generation.current;
    if (!routingCode) { setItems([]); onSelectItem(null); return; }
    setLoading(true);
    try {
      const response = await api.get(`/master/routing-groups/${routingCode}/items`);
      if (current !== generation.current) return;
      const rows: RoutingItem[] = response.data?.data ?? [];
      setItems(rows);
      if (!rows.some((row) => row.itemCode === selectedRef.current)) onSelectItem(rows[0]?.itemCode ?? null);
    } catch (error: unknown) {
      if (current === generation.current) { setItems([]); onSelectItem(null); toast.error(errorMessage(error, "적용 품목 조회 중 오류가 발생했습니다.")); }
    } finally {
      if (current === generation.current) setLoading(false);
    }
  }, [routingCode, onSelectItem]);

  useEffect(() => { void load(); }, [load, reloadKey]);

  const unassign = async () => {
    if (!routingCode || !removeTarget) return;
    setSaving(true);
    try {
      await api.put(`/master/routing-groups/${routingCode}/items`, { assign: [], unassign: [removeTarget.itemCode] });
      setRemoveTarget(null);
      toast.success("품목을 라우팅에서 뺐습니다.");
      await load();
      onChanged();
    } catch (error: unknown) {
      toast.error(errorMessage(error, "품목을 빼는 중 오류가 발생했습니다."));
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="flex h-full min-h-0 flex-col">
      <div className="flex items-center justify-between px-3 py-2">
        <b className="text-sm">적용 품목{routingCode ? ` (${items.length})` : ""}</b>
        <Button size="sm" disabled={!routingCode} onClick={() => setAddOpen(true)}><Plus className="mr-1 h-4 w-4" />품목</Button>
      </div>
      <p className="px-3 pb-1 text-xs text-text-muted">이 라우팅을 따르는 반제품·완제품입니다. 품목을 누르면 그 품목의 BOM 자재를 공정에 배정할 수 있습니다.</p>
      <div className="min-h-0 flex-1 px-3 pb-3">
        <DataGrid
          data={items}
          columns={itemColumns}
          isLoading={loading}
          onRowClick={(item) => onSelectItem(item.itemCode)}
          getRowId={(item) => item.itemCode}
          selectedRowId={selectedItemCode ?? undefined}
          pageSize={100}
          enableColumnFilter={false}
          enableExport={false}
          showFooter={false}
          emptyMessage={routingCode ? "이 라우팅을 따르는 품목이 없습니다." : "라우팅을 선택하세요."}
        />
      </div>
      {addOpen && routingCode && (
        <CandidateModal routingCode={routingCode} onClose={() => setAddOpen(false)} onSaved={async () => { setAddOpen(false); await load(); onChanged(); }} />
      )}
      <ConfirmModal
        isOpen={!!removeTarget}
        onClose={() => setRemoveTarget(null)}
        onConfirm={unassign}
        title="적용 품목 빼기"
        message={`${removeTarget?.itemCode ?? ""} 품목을 이 라우팅에서 뺍니다. 투입자재가 배정되어 있으면 먼저 지워야 합니다.`}
        variant="danger"
        isLoading={saving}
      />
    </div>
  );
}

function CandidateModal({ routingCode, onClose, onSaved }: { routingCode: string; onClose: () => void; onSaved: () => Promise<void> }) {
  const [search, setSearch] = useState("");
  const [rows, setRows] = useState<RoutingCandidateItem[]>([]);
  const [total, setTotal] = useState(0);
  const [checked, setChecked] = useState<Set<string>>(new Set());
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const generation = useRef(0);

  const query = useCallback(async (text: string) => {
    const current = ++generation.current;
    setLoading(true);
    try {
      const response = await api.get("/master/routing-groups/candidate-items", { params: { search: text || undefined, limit: 50 } });
      if (current !== generation.current) return;
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? response.data?.total ?? 0));
    } catch (error: unknown) {
      if (current === generation.current) { setRows([]); toast.error(errorMessage(error, "품목 조회 중 오류가 발생했습니다.")); }
    } finally {
      if (current === generation.current) setLoading(false);
    }
  }, []);

  useEffect(() => { void query(""); }, [query]);

  const toggle = (code: string, on: boolean) => setChecked((prev) => { const next = new Set(prev); if (on) next.add(code); else next.delete(code); return next; });

  const save = async () => {
    if (checked.size === 0) { toast.error("붙일 품목을 선택하세요."); return; }
    setSaving(true);
    try {
      await api.put(`/master/routing-groups/${routingCode}/items`, { assign: [...checked], unassign: [] });
      toast.success("저장되었습니다.");
      await onSaved();
    } catch (error: unknown) {
      toast.error(errorMessage(error, "저장 중 오류가 발생했습니다."));
    } finally {
      setSaving(false);
    }
  };

  return (
    <Modal isOpen onClose={onClose} title="적용 품목 추가" size="xl">
      <div className="flex gap-2">
        <Input value={search} placeholder="품목코드·품명·모델명" leftIcon={<Search className="h-4 w-4" />} onChange={(event) => setSearch(event.target.value)} onKeyDown={(event) => { if (event.key === "Enter") void query(search); }} />
        <Button variant="secondary" onClick={() => void query(search)}>조회</Button>
      </div>
      <div className="mt-3 max-h-[50vh] overflow-auto">
        {loading ? <RefreshCw className="m-auto my-8 animate-spin" /> : (
          <table className="w-full text-xs">
            <thead className="sticky top-0 bg-surface text-text-muted"><tr><th className="p-1" /><th className="p-1 text-left">품목</th><th className="p-1 text-left">모델</th><th className="p-1">구분</th><th className="p-1 text-left">현재 라우팅</th><th className="p-1">BOM</th></tr></thead>
            <tbody>
              {rows.map((row) => {
                const mine = row.routingCode === routingCode;
                return (
                  <tr key={row.itemCode} className="border-t">
                    <td className="p-1 text-center"><input type="checkbox" checked={mine || checked.has(row.itemCode)} disabled={mine} onChange={(event) => toggle(row.itemCode, event.target.checked)} /></td>
                    <td className="p-1"><b>{row.itemName}</b><div className="text-text-muted">{row.itemCode}</div></td>
                    <td className="p-1">{row.modelName ?? "-"}</td>
                    <td className="p-1 text-center">{row.itemDivision === "F" ? "완제품" : "반제품"}</td>
                    <td className="p-1">{row.routingCode ? `${row.routingCode} ${row.routingName ?? ""}` : "-"}</td>
                    <td className="p-1 text-center">{row.bomRegisteredYn === "Y" ? "있음" : "없음"}</td>
                  </tr>
                );
              })}
              {rows.length === 0 && <tr><td colSpan={6} className="p-6 text-center text-text-muted">조회된 품목이 없습니다.</td></tr>}
            </tbody>
          </table>
        )}
      </div>
      <div className="mt-3 flex items-center justify-between">
        <span className="text-xs text-text-muted">{total > rows.length ? `${total}건 중 ${rows.length}건 표시. 검색어로 좁히세요.` : `${rows.length}건`}</span>
        <div className="flex gap-2">
          <Button variant="secondary" onClick={onClose}>취소</Button>
          <Button onClick={save} disabled={saving || checked.size === 0}>{checked.size}개 붙이기</Button>
        </div>
      </div>
    </Modal>
  );
}
