"use client";

/**
 * @file src/app/(authenticated)/smt/location/page.tsx
 * @description 라인별 테이블 관리 — PB w_smt_location_master 이식
 *
 * 초보자 가이드:
 * 1. **키는 라인코드 + 위치코드다. 설비는 키가 아니다.**
 *    같은 라인에서는 설비가 달라도 위치코드가 겹칠 수 없다.
 * 2. **'계획사용' 이 0 보다 크면 배포된 계획이 그 위치를 쓰고 있다.** 그 위치는
 *    지워지지 않는다 — 지우면 계획행이 없는 위치를 가리킨다.
 * 3. 위치를 한꺼번에 만드는 것은 SMT 라인관리 화면의 '위치 일괄생성' 이다.
 *    여기서는 한 건씩 손보거나 지운다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Edit2, Plus, Search, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { SmtMachineSelect } from '../components/SmtSelects';
import { smtLocationColumns } from '../columns';
import type { SmtLocationRow } from '../types';
import SmtLocationFormPanel, {
  emptySmtLocationForm,
  toSmtLocationForm,
  type SmtLocationForm,
} from './components/SmtLocationFormPanel';

export default function SmtLocationPage() {
  const [rows, setRows] = useState<SmtLocationRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [lineCode, setLineCode] = useState('');
  const [machine, setMachine] = useState('');
  const [tableId, setTableId] = useState('');
  const [locationCode, setLocationCode] = useState('');

  const [selected, setSelected] = useState<SmtLocationRow | null>(null);
  const [panel, setPanel] = useState<{ mode: 'create' | 'edit'; form: SmtLocationForm } | null>(null);
  const [deleteOpen, setDeleteOpen] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/smt/location', {
        params: {
          lineCode: lineCode || undefined,
          machine: machine || undefined,
          tableId: tableId || undefined,
          locationCode: locationCode || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setSelected(null);
    } catch {
      toast.error('위치 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [lineCode, machine, tableId, locationCode]);

  const remove = useCallback(async () => {
    if (!selected) return;
    setDeleteOpen(false);
    try {
      await api.delete('/smt/location', {
        data: { lineCode: selected.lineCode, locationCode: selected.locationCode },
      });
      toast.success('삭제되었습니다.');
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '삭제에 실패했습니다.');
    }
  }, [selected, search]);

  const columns = useMemo(() => smtLocationColumns, []);

  return (
    <div className="flex h-full">
      <main className="flex min-w-0 flex-1 flex-col gap-4 p-6">
        <header className="flex items-center justify-between gap-4">
          <div>
            <h1 className="text-xl font-bold text-text">라인별 테이블 관리</h1>
            <p className="mt-1 text-sm text-text-muted">
              마운터 테이블과 피더 위치를 관리합니다 ·{' '}
              {searched ? `${rows.length}/${total}건` : '조회하세요'}
            </p>
          </div>
          <div className="flex flex-wrap gap-2">
            <Button size="sm" onClick={search} disabled={loading}>
              <Search className="mr-1 h-4 w-4" />조회
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected}
              onClick={() => selected
                && setPanel({ mode: 'edit', form: toSmtLocationForm(selected) })}>
              <Edit2 className="mr-1 h-4 w-4" />수정
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected}
              onClick={() => setDeleteOpen(true)}>
              <Trash2 className="mr-1 h-4 w-4 text-red-500" />삭제
            </Button>
            <Button size="sm"
              onClick={() => setPanel({ mode: 'create', form: emptySmtLocationForm() })}>
              <Plus className="mr-1 h-4 w-4" />등록
            </Button>
          </div>
        </header>

        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <Input aria-label="라인코드" placeholder="라인코드" value={lineCode}
              className="w-40" onChange={(e) => setLineCode(e.target.value)} />
            <SmtMachineSelect labelPrefix="설비" value={machine}
              onChange={setMachine} className="w-56" />
            <Input aria-label="테이블문자" placeholder="테이블문자" value={tableId}
              className="w-32" onChange={(e) => setTableId(e.target.value)} />
            <Input aria-label="위치코드" placeholder="위치코드" value={locationCode}
              className="w-40" onChange={(e) => setLocationCode(e.target.value)} />
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
              exportFileName="라인별테이블관리"
              emptyMessage="조회 버튼을 눌러 위치를 확인하세요."
              onRowClick={(row) => setSelected(row as SmtLocationRow)}
              getRowId={(row) => {
                const r = row as SmtLocationRow;
                return `${r.lineCode}|${r.locationCode}`;
              }}
            />
          </CardContent>
        </Card>
      </main>

      {panel && (
        <SmtLocationFormPanel
          key={`${panel.mode}-${panel.form.lineCode}-${panel.form.locationCode}`}
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
        title="위치 삭제"
        message={selected
          ? `${selected.lineCode} / ${selected.locationCode} 을 지울까요?`
            + (Number(selected.planUseCount ?? 0) > 0
              ? ` 배포된 계획 ${selected.planUseCount}건이 이 위치를 쓰고 있어 삭제가 거부됩니다.`
              : '')
          : ''}
        variant="danger"
      />
    </div>
  );
}
