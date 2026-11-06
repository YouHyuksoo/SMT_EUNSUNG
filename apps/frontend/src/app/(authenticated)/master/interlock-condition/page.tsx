"use client";

/**
 * @file src/app/(authenticated)/master/interlock-condition/page.tsx
 * @description 인터락조건관리 — 라인·공정별로 공정 통과 때 돌릴 인터락 검사를 등록한다 (IQ_INTERLOCK_CHECK_CONDITION)
 *
 * 초보자 가이드:
 * 1. 공정통과 등록 때 그 라인·공정의 사용 중인 조건을 검사 순서대로 P_INTERLOCK_CHECK 로 검사한다.
 * 2. 행을 누르면 우측 패널에서 수정·삭제, '신규 조건'으로 등록, '라인 복사'로 한 라인의 조건을 다른 라인에 복사한다.
 */
import { useCallback, useEffect, useMemo, useState } from "react";
import { Copy, Plus, RefreshCw, ShieldAlert } from "lucide-react";
import { Button, Card, CardContent, Select } from "@/components/ui";
import DataGrid from "@/components/data-grid/DataGrid";
import ComCodeSelect from "@/components/shared/ComCodeSelect";
import LineSelect from "@/components/shared/LineSelect";
import ProcessSelect from "@/components/shared/ProcessSelect";
import { useComCodeMap } from "@/hooks/useComCode";
import api from "@/services/api";
import { interlockColumns } from "./columns";
import InterlockCopyModal from "./components/InterlockCopyModal";
import InterlockFormPanel from "./components/InterlockFormPanel";
import type { InterlockCondition } from "./types";

export default function InterlockConditionPage() {
  const [rows, setRows] = useState<InterlockCondition[]>([]);
  const [loading, setLoading] = useState(false);
  const [lineCode, setLineCode] = useState("");
  const [workstageCode, setWorkstageCode] = useState("");
  const [checkType, setCheckType] = useState("");
  const [useYn, setUseYn] = useState("");
  const [editing, setEditing] = useState<InterlockCondition | null>(null);
  const [panelOpen, setPanelOpen] = useState(false);
  const [copyOpen, setCopyOpen] = useState(false);
  const checkTypes = useComCodeMap("INTERLOCK CHECK TYPE");

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const params: Record<string, string> = {};
      if (lineCode) params.lineCode = lineCode;
      if (workstageCode) params.workstageCode = workstageCode;
      if (checkType) params.interlockCheckType = checkType;
      if (useYn) params.useYn = useYn;
      const res = await api.get("/master/interlock-conditions", { params });
      setRows(res.data?.data ?? []);
    } catch { setRows([]); }
    finally { setLoading(false); }
  }, [lineCode, workstageCode, checkType, useYn]);

  useEffect(() => { void search(); }, [search]);

  const columns = useMemo(() => interlockColumns(checkTypes), [checkTypes]);
  const closePanel = () => { setPanelOpen(false); setEditing(null); };

  return (
    <div className="flex h-full overflow-hidden">
      <main className="flex min-w-0 flex-1 flex-col gap-3 p-5">
        <header className="flex items-center justify-between gap-4">
          <div>
            <h1 className="flex items-center gap-2 text-xl font-bold text-text"><ShieldAlert className="h-6 w-6 text-primary" />인터락조건관리</h1>
            <p className="mt-1 text-sm text-text-muted">라인·공정별로 공정 통과 때 검사할 인터락 조건과 검사 순서를 관리합니다 · {rows.length}건</p>
          </div>
          <div className="flex gap-2">
            <Button variant="secondary" size="sm" onClick={() => setCopyOpen(true)}><Copy className="mr-1 h-4 w-4" />라인 복사</Button>
            <Button size="sm" onClick={() => { setEditing(null); setPanelOpen(true); }}><Plus className="mr-1 h-4 w-4" />신규 조건</Button>
          </div>
        </header>
        <Card padding="sm">
          <div className="flex flex-wrap items-center gap-2">
            <LineSelect labelPrefix="라인" value={lineCode} onChange={setLineCode} className="w-44" />
            <ProcessSelect labelPrefix="공정" value={workstageCode} onChange={setWorkstageCode} className="w-48" />
            <ComCodeSelect labelPrefix="검사유형" groupCode="INTERLOCK CHECK TYPE" value={checkType} onChange={setCheckType} className="w-72" />
            <Select options={[{ value: "", label: "사용: 전체" }, { value: "Y", label: "사용: 사용" }, { value: "N", label: "사용: 미사용" }]} value={useYn} onChange={setUseYn} className="w-32" />
            <Button size="sm" variant="secondary" onClick={() => void search()} disabled={loading}><RefreshCw className={`mr-1 h-4 w-4 ${loading ? "animate-spin" : ""}`} />조회</Button>
          </div>
        </Card>
        <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
          <CardContent className="h-full p-3">
            <DataGrid
              data={rows}
              columns={columns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="인터락조건"
              getRowId={(row) => row.rowKey}
              selectedRowId={editing?.rowKey}
              onRowClick={(row) => { setEditing(row); setPanelOpen(true); }}
              emptyMessage="등록된 인터락 조건이 없습니다."
            />
          </CardContent>
        </Card>
      </main>
      {panelOpen && (
        <InterlockFormPanel
          editing={editing}
          defaults={{ lineCode, workstageCode }}
          onClose={closePanel}
          onSaved={() => { closePanel(); void search(); }}
        />
      )}
      <InterlockCopyModal
        isOpen={copyOpen}
        defaultFromLine={lineCode}
        onClose={() => setCopyOpen(false)}
        onCopied={(toLine) => { setCopyOpen(false); setLineCode(toLine); }}
      />
    </div>
  );
}
