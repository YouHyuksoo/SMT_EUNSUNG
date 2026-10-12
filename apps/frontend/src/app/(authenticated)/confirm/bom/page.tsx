"use client";

/**
 * @file src/app/(authenticated)/confirm/bom/page.tsx
 * @description 설계BOM승인 — PB w_des_bom_confirm_master 이식
 *
 * 초보자 가이드:
 * 1. **작업공간은 확정 전 BOM 이다.** 위 표에서 작업번호를 고르면 아래에 그 BOM 이
 *    나온다. '반영' 을 누르면 실제 BOM(ID_ENG_BOM)으로 옮겨진다.
 * 2. **옮기는 일은 DB 함수가 한다** (PKG_DESIGN.BOM_TRANSLATION). PB 도 같은
 *    함수를 불렀다 — BOM 전개·레벨 계산 규칙이 갈리면 설계와 생산이 다른 BOM 을 본다.
 * 3. **'새 BOM 행수' 가 0이면 반영할 수 없다.** PB 가 걸던 검사다.
 *    새로 넣을 것이 없는데 옮기면 기존 BOM 만 흔든다.
 * 4. **'작업공간 비우기' 는 작업번호 단위 전체 삭제다.** 되돌릴 수 없다.
 * 5. **이 표는 현재 0행이다** — 은성이 아직 설계BOM 승인 절차를 쓰지 않는다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { CheckCircle2, Search, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, ConfirmModal } from '@/components/ui';
import api from '@/services/api';
import { bomWorkNumberColumns, bomWorkspaceColumns } from '../confirm-columns';
import type { BomWorkNumberRow, BomWorkspaceRow } from '../confirm-types';
import PartSearchField from '@/components/shared/PartSearchField';

export default function BomConfirmPage() {
  const [workNumbers, setWorkNumbers] = useState<BomWorkNumberRow[]>([]);
  const [rows, setRows] = useState<BomWorkspaceRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [rowsLoading, setRowsLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [selected, setSelected] = useState<BomWorkNumberRow | null>(null);
  const [parentItemCode, setParentItemCode] = useState('');

  const [applyOpen, setApplyOpen] = useState(false);
  const [clearOpen, setClearOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const loadWorkNumbers = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/confirm/bom/work-numbers');
      setWorkNumbers(response.data?.data ?? []);
      setSearched(true);
    } catch {
      toast.error('작업번호 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { void loadWorkNumbers(); }, [loadWorkNumbers]);

  const loadRows = useCallback(async (bomWorkNo: number) => {
    setRowsLoading(true);
    try {
      const response = await api.get('/confirm/bom', {
        params: { bomWorkNo, parentItemCode: parentItemCode || undefined },
      });
      setRows(response.data?.data ?? []);
    } catch {
      toast.error('작업공간 조회에 실패했습니다.');
      setRows([]);
    } finally {
      setRowsLoading(false);
    }
  }, [parentItemCode]);

  useEffect(() => {
    if (!selected) {
      setRows([]);
      return;
    }
    void loadRows(selected.bomWorkNo);
  }, [selected, loadRows]);

  const apply = useCallback(async () => {
    if (!selected?.itemCode) return;
    setApplyOpen(false);
    setBusy(true);
    try {
      const response = await api.post('/confirm/bom/apply', {
        bomWorkNo: selected.bomWorkNo,
        itemCode: selected.itemCode,
      });
      const data = response.data?.data;
      toast.success(
        `BOM 을 반영했습니다 — ${selected.itemCode} BOM 행수 `
        + `${data?.bomRowsBefore ?? 0} → ${data?.bomRowsAfter ?? 0}`,
      );
      void loadWorkNumbers();
      void loadRows(selected.bomWorkNo);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? 'BOM 반영에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, loadWorkNumbers, loadRows]);

  const clear = useCallback(async () => {
    if (!selected) return;
    setClearOpen(false);
    setBusy(true);
    try {
      const response = await api.delete('/confirm/bom', {
        data: { bomWorkNo: selected.bomWorkNo },
      });
      toast.success(`${response.data?.data?.deleted ?? 0}행을 지웠습니다.`);
      setSelected(null);
      void loadWorkNumbers();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '작업공간 비우기에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, loadWorkNumbers]);

  const canApply = Boolean(selected?.itemCode) && Number(selected?.newRowCount ?? 0) > 0;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-text">설계BOM승인</h1>
          <p className="mt-1 text-sm text-text-muted">
            확정 전 BOM 작업공간을 검토하고 실제 BOM 으로 반영합니다 ·{' '}
            {searched ? `작업번호 ${workNumbers.length}건` : '읽는 중'}
          </p>
        </div>
        <div className="flex flex-wrap gap-2">
          <Button size="sm" onClick={loadWorkNumbers} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <Button size="sm" disabled={!canApply || busy} onClick={() => setApplyOpen(true)}>
            <CheckCircle2 className="mr-1 h-4 w-4" />반영
          </Button>
          <Button size="sm" variant="secondary" disabled={!selected || busy}
            onClick={() => setClearOpen(true)}>
            <Trash2 className="mr-1 h-4 w-4 text-red-500" />작업공간 비우기
          </Button>
        </div>
      </header>

      {searched && workNumbers.length === 0 && (
        <div className="rounded border border-amber-500/40 bg-amber-500/10 p-3 text-sm text-text">
          작업공간(ID_ENG_BOM_WORKSPACE)에 행이 없습니다 — 은성은 아직 설계BOM 승인
          절차를 쓰지 않습니다. 절차를 시작하면 이 화면에 작업번호가 올라옵니다.
        </div>
      )}

      <Card className="h-56 shrink-0 overflow-hidden" padding="none">
        <CardContent className="flex h-full flex-col gap-2 p-3">
          <b className="text-sm text-text">작업번호</b>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={workNumbers}
              columns={bomWorkNumberColumns}
              isLoading={loading}
              pageSize={50}
              emptyMessage="작업공간이 비어 있습니다."
              onRowClick={(row) => setSelected(row as BomWorkNumberRow)}
              rowClassName={(row) =>
                (row as BomWorkNumberRow).bomWorkNo === selected?.bomWorkNo
                  ? 'bg-primary/10' : ''}
              getRowId={(row) => String((row as BomWorkNumberRow).bomWorkNo)}
            />
          </div>
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <PartSearchField aria-label="상위 품목코드" placeholder="상위 품목코드" value={parentItemCode}
            className="w-48" onChange={(e) => setParentItemCode(e.target.value)} />
          <Button size="sm" variant="secondary" disabled={!selected}
            onClick={() => selected && void loadRows(selected.bomWorkNo)}>
            <Search className="mr-1 h-4 w-4" />작업공간 다시 읽기
          </Button>
          {selected && (
            <span className="text-sm text-text-muted">
              작업번호 {selected.bomWorkNo} · SET {selected.itemCode ?? '(없음)'} ·
              새 BOM {selected.newRowCount}행
              {selected.newRowCount === 0 && (
                <span className="ml-2 text-amber-500">새 BOM 행이 없어 반영할 수 없습니다</span>
              )}
            </span>
          )}
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={bomWorkspaceColumns}
            isLoading={rowsLoading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="설계BOM작업공간"
            emptyMessage={selected ? '이 작업번호에 행이 없습니다.' : '위에서 작업번호를 고르세요.'}
            getRowId={(row) => {
              const r = row as BomWorkspaceRow;
              return [r.bomWorkNo, r.parentItemCode, r.childItemCode, r.dateSet].join('|');
            }}
          />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={applyOpen}
        onClose={() => setApplyOpen(false)}
        onConfirm={apply}
        title="설계BOM 반영"
        message={selected
          ? `작업번호 ${selected.bomWorkNo} (SET ${selected.itemCode}) 의 BOM 을`
            + ' 실제 BOM 으로 반영합니까? 되돌리려면 BOM 을 직접 손봐야 합니다.'
          : ''}
      />

      <ConfirmModal
        isOpen={clearOpen}
        onClose={() => setClearOpen(false)}
        onConfirm={clear}
        title="작업공간 비우기"
        message={selected
          ? `작업번호 ${selected.bomWorkNo} 의 작업공간 ${selected.rowCount}행을 전부 지울까요?`
            + ' 되돌릴 수 없습니다.'
          : ''}
        variant="danger"
      />
    </div>
  );
}
