"use client";

/**
 * @file src/app/(authenticated)/smt/line/page.tsx
 * @description SMT 라인관리 — PB w_smt_line_master 이식
 *
 * 초보자 가이드:
 * 1. **한 줄이 "라인 × 설비" 다.** 라인 하나에 마운터가 여러 대 달리므로
 *    라인코드가 같은 줄이 여러 개 나온다. 라인 목록이 아니다.
 * 2. **아래 그리드는 선택한 라인·설비의 피더 위치다.** 위 줄을 고르면 읽는다.
 * 3. **위치 일괄생성**은 테이블문자 + 주소범위 + 좌/우 조합으로 위치코드를 만든다.
 *    예) 테이블 C, 주소 1~3, 좌우 → C01L C01R C02L C02R C03L C03R.
 *    이미 있는 위치는 건너뛰므로 여러 번 눌러도 안전하다.
 * 4. **위치 일괄삭제는 선택한 라인·설비 범위만 지운다.** PB 는 WHERE 가 없어
 *    모든 라인·설비·조직의 위치를 지웠다. 그리고 배포된 계획이 그 위치를 쓰고 있으면
 *    지우지 않는다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Edit2, Plus, Search, Trash2, Wand2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import { Button, Card, CardContent, ConfirmModal } from '@/components/ui';
import LineSelect from '@/components/shared/LineSelect';
import api from '@/services/api';
import { SmtMachineSelect } from '../components/SmtSelects';
import { smtLineColumns, smtLineLocationColumns } from '../columns';
import type { SmtLineRow, SmtLocationRow } from '../types';
import SmtLineFormPanel, {
  emptySmtLineForm,
  toSmtLineForm,
  type SmtLineForm,
} from './components/SmtLineFormPanel';
import SmtLocationGenerateModal from './components/SmtLocationGenerateModal';

export default function SmtLinePage() {
  const [rows, setRows] = useState<SmtLineRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [lineCode, setLineCode] = useState('');
  const [machine, setMachine] = useState('');
  const [lineStatus, setLineStatus] = useState('');

  const [selected, setSelected] = useState<SmtLineRow | null>(null);
  const [locations, setLocations] = useState<SmtLocationRow[]>([]);
  const [locationLoading, setLocationLoading] = useState(false);

  const [panel, setPanel] = useState<{ mode: 'create' | 'edit'; form: SmtLineForm } | null>(null);
  const [deleteOpen, setDeleteOpen] = useState(false);
  const [deleteLocationsOpen, setDeleteLocationsOpen] = useState(false);
  const [generateOpen, setGenerateOpen] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/smt/line', {
        params: {
          lineCode: lineCode || undefined,
          machine: machine || undefined,
          lineStatus: lineStatus || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setSelected(null);
      setLocations([]);
    } catch {
      toast.error('라인 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [lineCode, machine, lineStatus]);

  const loadLocations = useCallback(async (row: SmtLineRow) => {
    setLocationLoading(true);
    try {
      const response = await api.get('/smt/line/locations', {
        params: { lineCode: row.lineCode, machine: row.machine },
      });
      setLocations(response.data?.data ?? []);
    } catch {
      toast.error('위치 조회에 실패했습니다.');
      setLocations([]);
    } finally {
      setLocationLoading(false);
    }
  }, []);

  useEffect(() => {
    if (!selected) {
      setLocations([]);
      return;
    }
    void loadLocations(selected);
  }, [selected, loadLocations]);

  const remove = useCallback(async () => {
    if (!selected) return;
    setDeleteOpen(false);
    try {
      await api.delete('/smt/line', {
        data: { lineCode: selected.lineCode, machine: selected.machine },
      });
      toast.success('삭제되었습니다.');
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '삭제에 실패했습니다.');
    }
  }, [selected, search]);

  const removeLocations = useCallback(async () => {
    if (!selected) return;
    setDeleteLocationsOpen(false);
    try {
      const response = await api.delete('/smt/line/locations', {
        data: { lineCode: selected.lineCode, machine: selected.machine },
      });
      toast.success(`위치 ${response.data?.data?.deleted ?? 0}건을 지웠습니다.`);
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '위치 삭제에 실패했습니다.');
    }
  }, [selected, search]);

  const columns = useMemo(() => smtLineColumns, []);
  const locationColumns = useMemo(() => smtLineLocationColumns, []);

  return (
    <div className="flex h-full">
      <main className="flex min-w-0 flex-1 flex-col gap-4 p-6">
        <header className="flex items-center justify-between gap-4">
          <div>
            <h1 className="text-xl font-bold text-text">SMT 라인관리</h1>
            <p className="mt-1 text-sm text-text-muted">
              라인과 마운터 설비, 그 아래 피더 위치를 관리합니다 ·{' '}
              {searched ? `${rows.length}/${total}건` : '조회하세요'}
            </p>
          </div>
          <div className="flex flex-wrap gap-2">
            <Button size="sm" onClick={search} disabled={loading}>
              <Search className="mr-1 h-4 w-4" />조회
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected}
              onClick={() => selected && setPanel({ mode: 'edit', form: toSmtLineForm(selected) })}>
              <Edit2 className="mr-1 h-4 w-4" />수정
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected}
              onClick={() => setDeleteOpen(true)}>
              <Trash2 className="mr-1 h-4 w-4 text-red-500" />삭제
            </Button>
            <Button size="sm"
              onClick={() => setPanel({ mode: 'create', form: emptySmtLineForm() })}>
              <Plus className="mr-1 h-4 w-4" />등록
            </Button>
          </div>
        </header>

        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <LineSelect labelPrefix="라인" value={lineCode} onChange={setLineCode} className="w-44" />
            <SmtMachineSelect labelPrefix="설비" value={machine}
              onChange={setMachine} className="w-56" />
            <ComCodeSelect groupCode="LINE STATUS" labelPrefix="라인상태"
              value={lineStatus} onChange={setLineStatus} className="w-48" />
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
              exportFileName="SMT라인관리"
              emptyMessage="조회 버튼을 눌러 라인을 확인하세요."
              onRowClick={(row) => setSelected(row as SmtLineRow)}
              getRowId={(row) => {
                const r = row as SmtLineRow;
                return `${r.lineCode}|${r.machine}`;
              }}
            />
          </CardContent>
        </Card>

        <Card className="h-72 shrink-0 overflow-hidden" padding="none">
          <CardContent className="flex h-full flex-col gap-2 p-3">
            <div className="flex items-center justify-between gap-2">
              <b className="text-sm text-text">
                피더 위치
                {selected ? ` — ${selected.lineCode} / ${selected.machine} (${locations.length}건)` : ''}
              </b>
              <div className="flex gap-2">
                <Button size="sm" variant="secondary" disabled={!selected}
                  onClick={() => setGenerateOpen(true)}>
                  <Wand2 className="mr-1 h-4 w-4" />위치 일괄생성
                </Button>
                <Button size="sm" variant="secondary"
                  disabled={!selected || locations.length === 0}
                  onClick={() => setDeleteLocationsOpen(true)}>
                  <Trash2 className="mr-1 h-4 w-4 text-red-500" />위치 일괄삭제
                </Button>
              </div>
            </div>
            <div className="min-h-0 flex-1">
              <DataGrid
                data={locations}
                columns={locationColumns}
                isLoading={locationLoading}
                pageSize={50}
                emptyMessage={selected ? '이 라인·설비에 위치가 없습니다.' : '위에서 라인을 고르세요.'}
                getRowId={(row) => String((row as SmtLocationRow).locationCode)}
              />
            </div>
          </CardContent>
        </Card>
      </main>

      {panel && (
        <SmtLineFormPanel
          key={`${panel.mode}-${panel.form.lineCode}-${panel.form.machine}`}
          mode={panel.mode}
          initialForm={panel.form}
          onClose={() => setPanel(null)}
          onSaved={() => { setPanel(null); void search(); }}
        />
      )}

      {generateOpen && selected && (
        <SmtLocationGenerateModal
          lineCode={selected.lineCode}
          machine={selected.machine}
          onClose={() => setGenerateOpen(false)}
          onDone={() => { setGenerateOpen(false); void loadLocations(selected); void search(); }}
        />
      )}

      <ConfirmModal
        isOpen={deleteOpen}
        onClose={() => setDeleteOpen(false)}
        onConfirm={remove}
        title="라인·설비 삭제"
        message={selected
          ? `${selected.lineCode} / ${selected.machine} 을 지울까요?`
            + ' 아래 피더 위치가 남아 있으면 삭제되지 않습니다.'
          : ''}
        variant="danger"
      />

      <ConfirmModal
        isOpen={deleteLocationsOpen}
        onClose={() => setDeleteLocationsOpen(false)}
        onConfirm={removeLocations}
        title="위치 일괄삭제"
        message={selected
          ? `${selected.lineCode} / ${selected.machine} 의 위치 ${locations.length}건을 지울까요?`
            + ' 배포된 계획이 그 위치를 쓰고 있으면 지워지지 않습니다.'
          : ''}
        variant="danger"
      />
    </div>
  );
}
