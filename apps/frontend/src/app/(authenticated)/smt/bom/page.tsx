"use client";

/**
 * @file src/app/(authenticated)/smt/bom/page.tsx
 * @description SMT BOM 관리 — PB w_smt_bom_create_master 이식
 *
 * 초보자 가이드:
 * 1. **모델을 먼저 골라야 조회된다.** 28,417행이라 모델 없이 훑으면 전부 끌어온다.
 *    PB 도 모델을 등호로 받았다.
 * 2. **한 줄이 "이 모델의 이 라인·설비·테이블·자리에 이 부품" 이다.** 같은 부품이
 *    여러 자리에 물리면 여러 줄이다.
 * 3. **일괄작업 세 개**는 되돌릴 수 없으니 확인 모달에 범위를 적어 둔다.
 *    - 라인 교체: 두 라인의 BOM 을 서로 맞바꾼다. 설비코드 앞 두 자리도 함께 바뀐다.
 *    - 모델명 변경: BOM·대체BOM·배포계획을 함께 바꾼다.
 *    - 범위 삭제: 모델 + 라인 + 면의 BOM 과 대체BOM 을 지운다.
 *      배포된 계획이 있으면 거부된다.
 * 4. **PB 의 '위치 주소 일괄이동' 은 없다.** PB 조건(`위치코드 길이 4`)에 맞는 행이
 *    이 DB 에 0건이라 아무 일도 하지 않는 기능이었다. 필요하면 따로 합의해 넣는다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { ArrowLeftRight, Edit2, Plus, Search, Tag, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { SmtMachineSelect, SmtModelSelect, SmtPcbItemSelect } from '../components/SmtSelects';
import { smtBomColumns } from '../columns';
import type { SmtBomRow } from '../types';
import SmtBomFormPanel, {
  emptySmtBomForm,
  toSmtBomForm,
  type SmtBomForm,
} from './components/SmtBomFormPanel';
import SmtBomBatchModal, { type SmtBomBatchKind } from './components/SmtBomBatchModal';

export default function SmtBomPage() {
  const [rows, setRows] = useState<SmtBomRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [modelName, setModelName] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [machine, setMachine] = useState('');
  const [pcbItem, setPcbItem] = useState('');
  const [revision, setRevision] = useState('');

  const [selected, setSelected] = useState<SmtBomRow | null>(null);
  const [panel, setPanel] = useState<{ mode: 'create' | 'edit'; form: SmtBomForm } | null>(null);
  const [deleteOpen, setDeleteOpen] = useState(false);
  const [batch, setBatch] = useState<SmtBomBatchKind | null>(null);

  const search = useCallback(async () => {
    if (modelName.trim() === '') {
      toast.error('모델을 먼저 고르세요. BOM 은 28,417행이라 모델 없이 조회하지 않습니다.');
      return;
    }
    setLoading(true);
    try {
      const response = await api.get('/smt/bom', {
        params: {
          modelName,
          lineCode: lineCode || undefined,
          machine: machine || undefined,
          pcbItem: pcbItem || undefined,
          revision: revision || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setSelected(null);
    } catch {
      toast.error('BOM 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [modelName, lineCode, machine, pcbItem, revision]);

  const remove = useCallback(async () => {
    if (!selected) return;
    setDeleteOpen(false);
    try {
      await api.delete('/smt/bom', {
        data: {
          parentItemCode: selected.parentItemCode,
          childItemCode: selected.childItemCode,
          dateSet: selected.dateSet,
          locationCode: selected.locationCode,
          lineCode: selected.lineCode,
          machine: selected.machine,
          pcbItem: selected.pcbItem,
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

  const columns = useMemo(() => smtBomColumns, []);

  return (
    <div className="flex h-full">
      <main className="flex min-w-0 flex-1 flex-col gap-4 p-6">
        <header className="flex items-center justify-between gap-4">
          <div>
            <h1 className="text-xl font-bold text-text">SMT BOM 관리</h1>
            <p className="mt-1 text-sm text-text-muted">
              모델별 피더 자리와 부품을 관리합니다 ·{' '}
              {searched ? `${rows.length}/${total}건` : '모델을 고르고 조회하세요'}
            </p>
          </div>
          <div className="flex flex-wrap gap-2">
            <Button size="sm" onClick={search} disabled={loading}>
              <Search className="mr-1 h-4 w-4" />조회
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected}
              onClick={() => selected && setPanel({ mode: 'edit', form: toSmtBomForm(selected) })}>
              <Edit2 className="mr-1 h-4 w-4" />수정
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected}
              onClick={() => setDeleteOpen(true)}>
              <Trash2 className="mr-1 h-4 w-4 text-red-500" />삭제
            </Button>
            <Button size="sm"
              onClick={() => setPanel({ mode: 'create', form: emptySmtBomForm(modelName) })}>
              <Plus className="mr-1 h-4 w-4" />등록
            </Button>
          </div>
        </header>

        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <SmtModelSelect labelPrefix="모델" value={modelName}
              onChange={setModelName} className="w-64" />
            <Input aria-label="라인코드" placeholder="라인코드" value={lineCode}
              className="w-36" onChange={(e) => setLineCode(e.target.value)} />
            <SmtMachineSelect labelPrefix="설비" value={machine}
              onChange={setMachine} className="w-52" />
            <SmtPcbItemSelect labelPrefix="PCB면" value={pcbItem}
              onChange={setPcbItem} className="w-44" />
            <Input aria-label="리비전" placeholder="리비전" value={revision}
              className="w-32" onChange={(e) => setRevision(e.target.value)} />
            <div className="ml-auto flex gap-2">
              <Button size="sm" variant="secondary" onClick={() => setBatch('line-swap')}>
                <ArrowLeftRight className="mr-1 h-4 w-4" />라인 교체
              </Button>
              <Button size="sm" variant="secondary" onClick={() => setBatch('model-rename')}>
                <Tag className="mr-1 h-4 w-4" />모델명 변경
              </Button>
              <Button size="sm" variant="secondary" onClick={() => setBatch('delete-scope')}>
                <Trash2 className="mr-1 h-4 w-4 text-red-500" />범위 삭제
              </Button>
            </div>
          </CardContent>
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
              exportFileName="SMT_BOM관리"
              emptyMessage="모델을 고르고 조회 버튼을 누르세요."
              onRowClick={(row) => setSelected(row as SmtBomRow)}
              getRowId={(row) => {
                const r = row as SmtBomRow;
                return [r.parentItemCode, r.childItemCode, r.dateSet, r.locationCode,
                  r.lineCode, r.machine, r.pcbItem].join('|');
              }}
            />
          </CardContent>
        </Card>
      </main>

      {panel && (
        <SmtBomFormPanel
          key={`${panel.mode}-${panel.form.childItemCode}-${panel.form.locationCode}`}
          mode={panel.mode}
          initialForm={panel.form}
          onClose={() => setPanel(null)}
          onSaved={() => { setPanel(null); void search(); }}
        />
      )}

      {batch && (
        <SmtBomBatchModal
          kind={batch}
          defaultModelName={modelName}
          defaultLineCode={lineCode}
          onClose={() => setBatch(null)}
          onDone={() => { setBatch(null); void search(); }}
        />
      )}

      <ConfirmModal
        isOpen={deleteOpen}
        onClose={() => setDeleteOpen(false)}
        onConfirm={remove}
        title="BOM 행 삭제"
        message={selected
          ? `${selected.childItemCode} (${selected.lineCode} / ${selected.machine}`
            + ` / ${selected.locationCode} / ${selected.pcbItem}면) 을 지울까요?`
          : ''}
        variant="danger"
      />
    </div>
  );
}
