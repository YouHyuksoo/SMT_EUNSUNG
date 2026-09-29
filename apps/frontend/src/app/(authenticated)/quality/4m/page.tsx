"use client";

/**
 * @file src/app/(authenticated)/quality/4m/page.tsx
 * @description 4M 이력관리 — PB w_qc_4m_master 이식
 *
 * 초보자 가이드:
 * 1. **4M = MAN / MATERIAL / MACHINE / METHODE.** 생산 조건이 바뀐 이력을 남겨
 *    나중에 불량이 나면 무엇이 바뀌었는지 되짚는 데 쓴다.
 * 2. **키는 모델명 + 서픽스 + 변경일자**다. 수정할 때 이 셋은 바꿀 수 없다.
 * 3. **키워드는 변경점·변경내용·변경사유 세 컬럼을 한 번에 훑는다** — PB 조건 그대로다.
 * 4. **첨부파일은 이관 범위 밖이다.** 목록에 있는지만(1/2) 보여준다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Edit2, GitCompareArrows, Plus, Search, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ModelSearchField from '@/components/shared/ModelSearchField';
import ProcessSelect from '@/components/shared/ProcessSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { qc4mColumns, type Qc4mRow } from '../qc-columns';
import Qc4mFormPanel, { emptyQc4mForm, toQc4mForm, type Qc4mForm } from './components/Qc4mFormPanel';

export default function Qc4mPage() {
  const [rows, setRows] = useState<Qc4mRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [modelName, setModelName] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');
  const [ecoDivision, setEcoDivision] = useState('');
  const [ecoStatus, setEcoStatus] = useState('');
  const [keyword, setKeyword] = useState('');
  const [dateFrom, setDateFrom] = useState('');
  const [dateTo, setDateTo] = useState('');

  const [selected, setSelected] = useState<Qc4mRow | null>(null);
  const [panel, setPanel] = useState<{ mode: 'create' | 'edit'; form: Qc4mForm } | null>(null);
  const [deleteOpen, setDeleteOpen] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/quality/4m', {
        params: {
          modelName: modelName || undefined,
          workstageCode: workstageCode || undefined,
          ecoDivision: ecoDivision || undefined,
          ecoStatus: ecoStatus || undefined,
          keyword: keyword || undefined,
          dateFrom: dateFrom || undefined,
          dateTo: dateTo || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setSelected(null);
    } catch {
      toast.error('4M 이력 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [modelName, workstageCode, ecoDivision, ecoStatus, keyword, dateFrom, dateTo]);

  const remove = useCallback(async () => {
    if (!selected) return;
    setDeleteOpen(false);
    try {
      await api.delete('/quality/4m', {
        data: {
          modelName: selected.modelName,
          modelSuffix: selected.modelSuffix,
          ecoDate: String(selected.ecoDate).slice(0, 10),
        },
      });
      toast.success('삭제되었습니다.');
      void search();
    } catch {
      toast.error('삭제에 실패했습니다.');
    }
  }, [selected, search]);

  const columns = useMemo(() => qc4mColumns, []);
  /** 키에 NULL 이 있는 행은 수정·삭제 API 로 잡을 수 없다 (실측 1행이 그렇다) */
  const keyable = Boolean(selected?.modelName && selected?.modelSuffix && selected?.ecoDate);

  return (
    <div className="flex h-full">
      <main className="flex min-w-0 flex-1 flex-col gap-4 p-6">
        <header className="flex items-center justify-between gap-4">
          <div>
            <h1 className="flex items-center gap-2 text-xl font-bold text-text">
              <GitCompareArrows className="h-6 w-6 text-primary" />4M 이력관리
            </h1>
            <p className="mt-1 text-sm text-text-muted">
              사람·자재·설비·방법 변경 이력을 등록하고 변경점으로 검색합니다 ·{' '}
              {searched ? `${rows.length}/${total}건` : '조회 버튼을 누르세요'}
            </p>
          </div>
          <div className="flex gap-2">
            <Button size="sm" onClick={search} disabled={loading}>
              <Search className="mr-1 h-4 w-4" />조회
            </Button>
            <Button size="sm" variant="secondary" disabled={!keyable}
              onClick={() => selected && setPanel({ mode: 'edit', form: toQc4mForm(selected) })}>
              <Edit2 className="mr-1 h-4 w-4" />수정
            </Button>
            <Button size="sm" variant="secondary" disabled={!keyable}
              onClick={() => setDeleteOpen(true)}>
              <Trash2 className="mr-1 h-4 w-4 text-red-500" />삭제
            </Button>
            <Button size="sm" onClick={() => setPanel({ mode: 'create', form: emptyQc4mForm() })}>
              <Plus className="mr-1 h-4 w-4" />등록
            </Button>
          </div>
        </header>

        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <ModelSearchField value={modelName} onChange={(v) => setModelName(v)}
              className="w-48" aria-label="모델명" placeholder="모델명" />
            <ProcessSelect labelPrefix="공정" value={workstageCode}
              onChange={setWorkstageCode} className="w-44" />
            <ComCodeSelect groupCode="ECO DIVISION" labelPrefix="4M 구분"
              value={ecoDivision} onChange={setEcoDivision} className="w-44" />
            <ComCodeSelect groupCode="ECO STATUS" labelPrefix="진행상태"
              value={ecoStatus} onChange={setEcoStatus} className="w-44" />
            <Input aria-label="변경점 검색" placeholder="변경점·내용·사유 검색" value={keyword}
              className="w-56" onChange={(e) => setKeyword(e.target.value)} />
            <DateRangeFilter label="변경일" from={dateFrom} to={dateTo}
              onFromChange={setDateFrom} onToChange={setDateTo} />
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
              exportFileName="4M이력"
              emptyMessage="조회 버튼을 눌러 4M 이력을 확인하세요."
              onRowClick={(row) => setSelected(row as Qc4mRow)}
              getRowId={(row) => {
                const r = row as Qc4mRow;
                return `${r.modelName ?? ''}|${r.modelSuffix ?? ''}|${String(r.ecoDate ?? '')}`;
              }}
            />
          </CardContent>
        </Card>
      </main>

      {panel && (
        <Qc4mFormPanel
          key={`${panel.mode}-${panel.form.modelName}-${panel.form.ecoDate}`}
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
        title="4M 이력 삭제"
        message={selected
          ? `${selected.modelName} / ${selected.modelSuffix} / ${String(selected.ecoDate).slice(0, 10)} 이력을 삭제할까요?`
          : ''}
        variant="danger"
      />
    </div>
  );
}
