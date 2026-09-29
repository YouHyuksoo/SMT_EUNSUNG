"use client";

/**
 * @file src/app/(authenticated)/production/smd-actual/page.tsx
 * @description 반제품생산실적관리 — PB w_pln_assembly_actual_master 이식
 *
 * 초보자 가이드:
 * 1. **이 표는 라인 센서가 올린 생산실적이다.** 카운트가 올라갈 때마다 한 줄 쌓인다.
 *    109,644행 있고 계속 늘어나므로 기간을 정해 조회한다.
 * 2. **고칠 수 있는 것은 실적수량과 보정수량뿐이다.** '센서 원시값' 컬럼은
 *    읽기 전용이다 — 고치면 센서 이력과 화면이 갈려 원인을 못 찾는다.
 * 3. **합계 탭**은 같은 조건으로 라인·모델별로 접어 본다. 목록 행수가 많을 때
 *    먼저 여기서 보고 이상한 라인만 목록으로 내려간다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Edit2, Search, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ProdLineSelect from '@/components/shared/ProdLineSelect';
import { Button, Card, CardContent, ConfirmModal, Input, Modal } from '@/components/ui';
import api from '@/services/api';
import { smdActualColumns, smdActualSummaryColumns } from '../planning-columns';
import type { SmdActualRow, SmdActualSummaryRow } from '../planning-types';

type Tab = 'list' | 'summary';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const weekAgo = () => {
  const date = new Date();
  date.setDate(date.getDate() - 7);
  return isoDate(date);
};

export default function SmdActualPage() {
  const [tab, setTab] = useState<Tab>('list');

  const [rows, setRows] = useState<SmdActualRow[]>([]);
  const [summary, setSummary] = useState<SmdActualSummaryRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [dateFrom, setDateFrom] = useState(weekAgo);
  const [dateTo, setDateTo] = useState(today);
  const [lineCode, setLineCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');

  const [selected, setSelected] = useState<SmdActualRow | null>(null);
  const [editOpen, setEditOpen] = useState(false);
  const [editQty, setEditQty] = useState('');
  const [editAdjust, setEditAdjust] = useState('');
  const [deleteOpen, setDeleteOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const params = useMemo(
    () => ({
      dateFrom,
      dateTo,
      lineCode: lineCode || undefined,
      modelName: modelName || undefined,
      workstageCode: workstageCode || undefined,
    }),
    [dateFrom, dateTo, lineCode, modelName, workstageCode],
  );

  const search = useCallback(async () => {
    setLoading(true);
    try {
      if (tab === 'list') {
        const response = await api.get('/production/smd-actual', { params });
        setRows(response.data?.data ?? []);
        setTotal(Number(response.data?.meta?.total ?? 0));
      } else {
        const response = await api.get('/production/smd-actual/summary', { params });
        setSummary(response.data?.data ?? []);
      }
      setSearched(true);
      setSelected(null);
    } catch {
      toast.error('생산실적 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [tab, params]);

  const openEdit = useCallback(() => {
    if (!selected) return;
    setEditQty(String(selected.productActualQty ?? 0));
    setEditAdjust(String(selected.adjustQty ?? ''));
    setEditOpen(true);
  }, [selected]);

  const saveEdit = useCallback(async () => {
    if (!selected) return;
    setBusy(true);
    try {
      await api.put('/production/smd-actual', {
        receiptDateKey: selected.receiptDateKey,
        receiptSequence: selected.receiptSequence,
        productActualQty: Number(editQty || 0),
        adjustQty: editAdjust.trim() === '' ? undefined : Number(editAdjust),
      });
      toast.success('수정되었습니다.');
      setEditOpen(false);
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '수정에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, editQty, editAdjust, search]);

  const remove = useCallback(async () => {
    if (!selected) return;
    setDeleteOpen(false);
    try {
      await api.delete('/production/smd-actual', {
        data: {
          receiptDateKey: selected.receiptDateKey,
          receiptSequence: selected.receiptSequence,
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

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-text">반제품생산실적관리</h1>
          <p className="mt-1 text-sm text-text-muted">
            라인 센서가 올린 생산실적을 확인하고 보정합니다 ·{' '}
            {!searched
              ? '기간을 정하고 조회하세요'
              : tab === 'list'
                ? `${rows.length}/${total}건`
                : `${summary.length}개 라인·모델`}
          </p>
        </div>
        <div className="flex flex-wrap gap-2">
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <Button size="sm" variant="secondary" disabled={!selected || tab !== 'list'}
            onClick={openEdit}>
            <Edit2 className="mr-1 h-4 w-4" />수정
          </Button>
          <Button size="sm" variant="secondary" disabled={!selected || tab !== 'list'}
            onClick={() => setDeleteOpen(true)}>
            <Trash2 className="mr-1 h-4 w-4 text-red-500" />삭제
          </Button>
        </div>
      </header>

      <div className="flex gap-1 border-b border-border">
        {([
          { key: 'list' as Tab, label: '실적 목록' },
          { key: 'summary' as Tab, label: '라인·모델 합계' },
        ]).map((t) => (
          <button
            key={t.key}
            type="button"
            onClick={() => { setTab(t.key); setSelected(null); }}
            className={`px-4 py-2 text-sm ${
              tab === t.key
                ? 'border-b-2 border-primary font-semibold text-text'
                : 'text-text-muted'
            }`}
          >
            {t.label}
          </button>
        ))}
      </div>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="집계일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <ProdLineSelect labelPrefix="라인" value={lineCode}
            onChange={setLineCode} className="w-56" />
          <Input aria-label="모델명" placeholder="모델명" value={modelName}
            className="w-48" onChange={(e) => setModelName(e.target.value)} />
          <Input aria-label="공정코드" placeholder="공정코드" value={workstageCode}
            className="w-36" onChange={(e) => setWorkstageCode(e.target.value)} />
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'list' ? (
            <DataGrid
              data={rows}
              columns={smdActualColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="반제품생산실적"
              emptyMessage="조회 버튼을 눌러 실적을 확인하세요."
              onRowClick={(row) => setSelected(row as SmdActualRow)}
              getRowId={(row) => {
                const r = row as SmdActualRow;
                return `${r.receiptDateKey}|${r.receiptSequence}`;
              }}
            />
          ) : (
            <DataGrid
              data={summary}
              columns={smdActualSummaryColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="반제품생산실적_합계"
              emptyMessage="조회 버튼을 눌러 합계를 확인하세요."
              getRowId={(row) => {
                const r = row as SmdActualSummaryRow;
                return `${r.lineCode}|${r.modelName}`;
              }}
            />
          )}
        </CardContent>
      </Card>

      <Modal isOpen={editOpen} onClose={() => setEditOpen(false)} title="실적 수정">
        <div className="space-y-4">
          {selected && (
            <p className="text-sm text-text-muted">
              {String(selected.receiptDate).slice(0, 19).replace('T', ' ')} / 순번{' '}
              {selected.receiptSequence} · {selected.lineCode} / {selected.modelName}
            </p>
          )}
          <label className="block text-sm">
            <span className="text-text-muted">실적수량</span>
            <Input type="number" value={editQty} onChange={(e) => setEditQty(e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">보정수량 (음수 가능, 비우면 지움)</span>
            <Input type="number" value={editAdjust}
              onChange={(e) => setEditAdjust(e.target.value)} />
          </label>
          <p className="text-xs text-text-muted">
            센서 원시값({selected?.originCount ?? '-'})은 바꾸지 않습니다 — 고치면
            센서 이력과 화면 값이 갈려 원인을 추적할 수 없습니다.
          </p>
        </div>
        <div className="mt-6 flex justify-end gap-2">
          <Button variant="secondary" onClick={() => setEditOpen(false)} disabled={busy}>
            취소
          </Button>
          <Button onClick={saveEdit} disabled={busy}>저장</Button>
        </div>
      </Modal>

      <ConfirmModal
        isOpen={deleteOpen}
        onClose={() => setDeleteOpen(false)}
        onConfirm={remove}
        title="실적 삭제"
        message={selected
          ? `${String(selected.receiptDate).slice(0, 19).replace('T', ' ')} / 순번`
            + ` ${selected.receiptSequence} 실적을 지울까요?`
          : ''}
        variant="danger"
      />
    </div>
  );
}
