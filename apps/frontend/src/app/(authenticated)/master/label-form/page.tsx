"use client";

/**
 * @file src/app/(authenticated)/master/label-form/page.tsx
 * @description 제품별 라벨양식 관리 — 모델별 BarTender 라벨 양식(ISYS_LABEL_FORM)을 관리한다
 *
 * 초보자 가이드:
 * 1. 한 모델에 양식번호별로 양식이 있다. 양식 파일(.btw)과 미리보기 이미지는 DB 에 저장한다.
 * 2. 행을 누르면 우측 패널에서 기본정보·V1~V20 값 칸을 고치고 파일을 올리고 내려받는다.
 * 3. 앞 칸에서 양식을 고른 뒤 '다른 모델로 복사'로 같은 양식을 다른 모델에 만든다.
 */
import { useCallback, useEffect, useMemo, useState } from "react";
import { Copy, Plus, RefreshCw, Tags } from "lucide-react";
import { Button, Card, CardContent } from "@/components/ui";
import DataGrid from "@/components/data-grid/DataGrid";
import ModelSearchField from "@/components/shared/ModelSearchField";
import { useComCodeMap } from "@/hooks/useComCode";
import api from "@/services/api";
import { labelFormColumns } from "./columns";
import LabelCopyModal from "./components/LabelCopyModal";
import LabelFormPanel from "./components/LabelFormPanel";
import { labelFormKey, type LabelForm } from "./types";

export default function LabelFormPage() {
  const [rows, setRows] = useState<LabelForm[]>([]);
  const [loading, setLoading] = useState(false);
  const [modelName, setModelName] = useState("");
  const [editing, setEditing] = useState<LabelForm | null>(null);
  const [panelOpen, setPanelOpen] = useState(false);
  const [checked, setChecked] = useState<Set<string>>(new Set());
  const [copyOpen, setCopyOpen] = useState(false);
  const formTypes = useComCodeMap("LABEL FORM TYPE");

  const search = useCallback(async (keyword?: string, reselect?: { modelName: string; labelFormNo: number } | null) => {
    setLoading(true);
    try {
      const name = keyword ?? modelName;
      const res = await api.get("/master/label-forms", { params: name ? { modelName: name } : {} });
      const list: LabelForm[] = res.data?.data ?? [];
      setRows(list);
      // 저장·파일 변경 뒤에는 같은 양식을 다시 골라 패널을 새 값으로 채운다
      if (reselect !== undefined) {
        const found = reselect ? list.find((r) => r.modelName === reselect.modelName && r.labelFormNo === reselect.labelFormNo) ?? null : null;
        setEditing(found);
        setPanelOpen(!!found);
      }
    } catch { setRows([]); }
    finally { setLoading(false); }
  }, [modelName]);

  useEffect(() => { void search(); }, [search]);

  const toggle = useCallback((key: string) => {
    setChecked((prev) => { const next = new Set(prev); if (next.has(key)) next.delete(key); else next.add(key); return next; });
  }, []);
  const columns = useMemo(() => labelFormColumns(formTypes, checked, toggle), [formTypes, checked, toggle]);
  const selectedForms = useMemo(() => rows.filter((r) => checked.has(labelFormKey(r))), [rows, checked]);

  return (
    <div className="flex h-full overflow-hidden">
      <main className="flex min-w-0 flex-1 flex-col gap-3 p-5">
        <header className="flex items-center justify-between gap-4">
          <div>
            <h1 className="flex items-center gap-2 text-xl font-bold text-text"><Tags className="h-6 w-6 text-primary" />제품별 라벨양식 관리</h1>
            <p className="mt-1 text-sm text-text-muted">모델별 BarTender 라벨 양식 파일과 값 칸(V1~V20)을 관리합니다 · {rows.length}건</p>
          </div>
          <div className="flex gap-2">
            <Button variant="secondary" size="sm" onClick={() => setCopyOpen(true)} disabled={selectedForms.length === 0}>
              <Copy className="mr-1 h-4 w-4" />다른 모델로 복사{selectedForms.length > 0 ? ` (${selectedForms.length})` : ""}
            </Button>
            <Button size="sm" onClick={() => { setEditing(null); setPanelOpen(true); }}><Plus className="mr-1 h-4 w-4" />신규 양식</Button>
          </div>
        </header>
        <Card padding="sm">
          <div className="flex flex-wrap items-center gap-2">
            <ModelSearchField placeholder="모델명" value={modelName} onChange={(v) => setModelName(v)} className="w-60" />
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
              exportFileName="제품별라벨양식"
              exportExcludeColumns={["check"]}
              getRowId={labelFormKey}
              selectedRowId={editing ? labelFormKey(editing) : undefined}
              onRowClick={(row) => { setEditing(row); setPanelOpen(true); }}
              emptyMessage="등록된 라벨 양식이 없습니다."
            />
          </CardContent>
        </Card>
      </main>
      {panelOpen && (
        <LabelFormPanel
          editing={editing}
          onClose={() => { setPanelOpen(false); setEditing(null); }}
          onChanged={(key) => void search(undefined, key)}
        />
      )}
      <LabelCopyModal
        isOpen={copyOpen}
        sources={selectedForms}
        onClose={() => setCopyOpen(false)}
        onCopied={(target) => { setCopyOpen(false); setChecked(new Set()); setModelName(target); }}
      />
    </div>
  );
}
