"use client";

/**
 * @file src/app/(authenticated)/smt/bom-replace/page.tsx
 * @description SMT BOM 대체관리 — PB w_smt_bom_replace_master 이식
 *
 * 초보자 가이드:
 * 1. **대체 BOM 은 "이 자리에 원래 품목 대신 이것도 쓸 수 있다" 는 표다.**
 *    계획배포 때 '대체' 표시가 붙은 행으로 함께 펼쳐진다.
 * 2. **'오늘 유효한 것만' 을 켜면** 적용시작 ≤ 오늘 ≤ 적용종료 인 행만 나온다.
 *    PB 의 수정용 DataWindow 와 같은 조건이다.
 * 3. **키가 여섯 컬럼이다** — 상위품목·원품목·대체품목·라인·위치코드·조직.
 *    수정할 때 앞 다섯 개가 잠긴다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Edit2, Plus, Search, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { SmtMachineSelect, SmtModelSelect } from '../components/SmtSelects';
import { smtBomReplaceColumns } from '../columns';
import type { SmtBomReplaceRow } from '../types';
import SmtBomReplaceFormPanel, {
  emptySmtBomReplaceForm,
  toSmtBomReplaceForm,
  type SmtBomReplaceForm,
} from './components/SmtBomReplaceFormPanel';

export default function SmtBomReplacePage() {
  const [rows, setRows] = useState<SmtBomReplaceRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [modelName, setModelName] = useState('');
  const [childItemCode, setChildItemCode] = useState('');
  const [replaceItemCode, setReplaceItemCode] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [machine, setMachine] = useState('');
  const [effectiveOnly, setEffectiveOnly] = useState(false);

  const [selected, setSelected] = useState<SmtBomReplaceRow | null>(null);
  const [panel, setPanel] = useState<{ mode: 'create' | 'edit'; form: SmtBomReplaceForm } | null>(null);
  const [deleteOpen, setDeleteOpen] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/smt/bom-replace', {
        params: {
          modelName: modelName || undefined,
          childItemCode: childItemCode || undefined,
          replaceItemCode: replaceItemCode || undefined,
          lineCode: lineCode || undefined,
          machine: machine || undefined,
          effectiveOnly: effectiveOnly ? 'Y' : undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setSelected(null);
    } catch {
      toast.error('대체 BOM 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [modelName, childItemCode, replaceItemCode, lineCode, machine, effectiveOnly]);

  const remove = useCallback(async () => {
    if (!selected) return;
    setDeleteOpen(false);
    try {
      await api.delete('/smt/bom-replace', {
        data: {
          parentItemCode: selected.parentItemCode,
          childItemCode: selected.childItemCode,
          replaceItemCode: selected.replaceItemCode,
          lineCode: selected.lineCode,
          locationCode: selected.locationCode,
        },
      });
      toast.success('삭제되었습니다.');
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '삭제에 실패했습니다.');
    }
  }, [selected, search]);

  const columns = useMemo(() => smtBomReplaceColumns, []);

  return (
    <div className="flex h-full">
      <main className="flex min-w-0 flex-1 flex-col gap-4 p-6">
        <header className="flex items-center justify-between gap-4">
          <div>
            <h1 className="text-xl font-bold text-text">SMT BOM 대체관리</h1>
            <p className="mt-1 text-sm text-text-muted">
              피더 자리별 대체 품목을 관리합니다 ·{' '}
              {searched ? `${rows.length}/${total}건` : '조회하세요'}
            </p>
          </div>
          <div className="flex flex-wrap gap-2">
            <Button size="sm" onClick={search} disabled={loading}>
              <Search className="mr-1 h-4 w-4" />조회
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected}
              onClick={() => selected
                && setPanel({ mode: 'edit', form: toSmtBomReplaceForm(selected) })}>
              <Edit2 className="mr-1 h-4 w-4" />수정
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected}
              onClick={() => setDeleteOpen(true)}>
              <Trash2 className="mr-1 h-4 w-4 text-red-500" />삭제
            </Button>
            <Button size="sm"
              onClick={() => setPanel({ mode: 'create', form: emptySmtBomReplaceForm() })}>
              <Plus className="mr-1 h-4 w-4" />등록
            </Button>
          </div>
        </header>

        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <SmtModelSelect labelPrefix="모델" value={modelName}
              onChange={setModelName} className="w-56" />
            <Input aria-label="원 품목코드" placeholder="원 품목코드" value={childItemCode}
              className="w-44" onChange={(e) => setChildItemCode(e.target.value)} />
            <Input aria-label="대체 품목코드" placeholder="대체 품목코드" value={replaceItemCode}
              className="w-44" onChange={(e) => setReplaceItemCode(e.target.value)} />
            <Input aria-label="라인코드" placeholder="라인코드" value={lineCode}
              className="w-36" onChange={(e) => setLineCode(e.target.value)} />
            <SmtMachineSelect labelPrefix="설비" value={machine}
              onChange={setMachine} className="w-52" />
            <label className="flex items-center gap-2 text-sm text-text">
              <input type="checkbox" checked={effectiveOnly}
                onChange={(e) => setEffectiveOnly(e.target.checked)} />
              오늘 유효한 것만
            </label>
          </CardContent>
        </Card>

        <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
          <CardContent className="h-full p-3">
            <DataGrid
              data={rows}
              columns={columns}
              isLoading={loading}
              pageSize={50}
              enableColumnFilter
              enableExport
              exportFileName="SMT_BOM대체관리"
              emptyMessage="조회 버튼을 눌러 대체 BOM 을 확인하세요."
              onRowClick={(row) => setSelected(row as SmtBomReplaceRow)}
              getRowId={(row) => {
                const r = row as SmtBomReplaceRow;
                return [r.parentItemCode, r.childItemCode, r.replaceItemCode,
                  r.lineCode, r.locationCode].join('|');
              }}
            />
          </CardContent>
        </Card>
      </main>

      {panel && (
        <SmtBomReplaceFormPanel
          key={`${panel.mode}-${panel.form.parentItemCode}-${panel.form.childItemCode}-${panel.form.replaceItemCode}`}
          mode={panel.mode}
          initialForm={panel.form}
          onClose={() => setPanel(null)}
          onSaved={() => { setPanel(null); void search(); }}
        />
      )}

      <ConfirmModal
        isOpen={deleteOpen}
        onClose={() => setDeleteOpen(false)}
        onConfirm={remove}
        title="대체 BOM 삭제"
        message={selected
          ? `${selected.childItemCode} → ${selected.replaceItemCode}`
            + ` (${selected.lineCode} / ${selected.locationCode}) 를 지울까요?`
          : ''}
        variant="danger"
      />
    </div>
  );
}
