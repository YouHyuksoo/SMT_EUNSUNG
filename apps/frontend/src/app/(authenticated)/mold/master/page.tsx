"use client";

/**
 * @file src/app/(authenticated)/mold/master/page.tsx
 * @description S-PARTS 관리 — PB w_mcn_mold_master 이식
 *
 * 초보자 가이드:
 * 1. **목록 행수 ≠ S-PARTS 건수.** 마스터에 재고(버전·SET번호)를 좌측 외부조인하므로
 *    재고가 여러 개인 S-PARTS 는 여러 줄로 나온다. PB 도 같다.
 *    그래서 그룹 컬럼을 맨 앞에 두고 그룹으로 정렬해 같은 묶음이 붙어 보이게 했다.
 * 2. **삭제는 연쇄삭제다.** 단가·부족이력·대여·출고·수리·입고·재고를 먼저 지우고
 *    마스터를 지운다. 되돌릴 수 없으므로 확인 모달에 지워지는 범위를 적어 둔다.
 * 3. **품목생성**은 아직 품목이 없는 S-PARTS 를 ID_ITEM 에 일괄로 만든다.
 *    이미 있으면 건너뛰므로 여러 번 눌러도 안전하다.
 * 4. 하단 두 탭은 선택 행 기준이다 — 소요품목(BOM)과 재고.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Boxes, Edit2, Layers, Plus, Search, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import MoldCodeField from '../components/MoldCodeField';
import {
  moldBillColumns,
  moldInventoryColumns,
  moldMasterColumns,
} from '../columns';
import type { MoldBillRow, MoldInventoryRow, MoldMasterRow } from '../types';
import MoldMasterFormPanel, {
  emptyMoldForm,
  toMoldForm,
  type MoldForm,
} from './components/MoldMasterFormPanel';

type DetailTab = 'bills' | 'inventory';

export default function MoldMasterPage() {
  const [rows, setRows] = useState<MoldMasterRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [moldCode, setMoldCode] = useState('');
  const [moldGroup, setMoldGroup] = useState('');

  const [selected, setSelected] = useState<MoldMasterRow | null>(null);
  const [tab, setTab] = useState<DetailTab>('bills');
  const [bills, setBills] = useState<MoldBillRow[]>([]);
  const [inventory, setInventory] = useState<MoldInventoryRow[]>([]);
  const [detailLoading, setDetailLoading] = useState(false);

  const [panel, setPanel] = useState<{ mode: 'create' | 'edit'; form: MoldForm } | null>(null);
  const [deleteOpen, setDeleteOpen] = useState(false);
  const [generateOpen, setGenerateOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/mold/master', {
        params: { moldCode: moldCode || undefined, moldGroup: moldGroup || undefined },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setSelected(null);
      setBills([]);
      setInventory([]);
    } catch {
      toast.error('S-PARTS 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [moldCode, moldGroup]);

  /** 선택 행이 바뀌거나 탭이 바뀌면 그 탭의 상세만 읽는다 */
  useEffect(() => {
    if (!selected) return;
    let cancelled = false;
    setDetailLoading(true);
    const path = tab === 'bills' ? '/mold/master/bills' : '/mold/master/inventory';
    api.get(path, { params: { moldCode: selected.moldCode } })
      .then((response) => {
        if (cancelled) return;
        const data = response.data?.data ?? [];
        if (tab === 'bills') setBills(data);
        else setInventory(data);
      })
      .catch(() => { if (!cancelled) toast.error('상세 조회에 실패했습니다.'); })
      .finally(() => { if (!cancelled) setDetailLoading(false); });
    return () => { cancelled = true; };
  }, [selected, tab]);

  const removeMold = useCallback(async () => {
    if (!selected) return;
    setDeleteOpen(false);
    setBusy(true);
    try {
      await api.delete('/mold/master', { data: { moldCode: selected.moldCode } });
      toast.success('삭제되었습니다.');
      void search();
    } catch {
      toast.error('삭제에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, search]);

  const generateItems = useCallback(async () => {
    setGenerateOpen(false);
    setBusy(true);
    try {
      const response = await api.post('/mold/master/generate-items', {});
      const created = Number(response.data?.data?.created ?? 0);
      toast.success(created > 0 ? `품목 ${created}건을 만들었습니다.` : '새로 만들 품목이 없습니다.');
    } catch {
      toast.error('품목생성에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, []);

  const columns = useMemo(() => moldMasterColumns, []);
  const billColumns = useMemo(() => moldBillColumns, []);
  const inventoryColumns = useMemo(() => moldInventoryColumns, []);

  return (
    <div className="flex h-full">
      <main className="flex min-w-0 flex-1 flex-col gap-4 p-6">
        <header className="flex items-center justify-between gap-4">
          <div>
            <h1 className="flex items-center gap-2 text-xl font-bold text-text">
              <Layers className="h-6 w-6 text-primary" />S-PARTS 관리
            </h1>
            <p className="mt-1 text-sm text-text-muted">
              S-PARTS 기준정보와 소요품목·재고를 관리합니다 ·{' '}
              {searched ? `${rows.length}/${total}건` : '조회조건을 선택하세요'}
            </p>
          </div>
          <div className="flex gap-2">
            <Button size="sm" onClick={search} disabled={loading}>
              <Search className="mr-1 h-4 w-4" />조회
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected || busy}
              onClick={() => selected && setPanel({ mode: 'edit', form: toMoldForm(selected) })}>
              <Edit2 className="mr-1 h-4 w-4" />수정
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected || busy}
              onClick={() => setDeleteOpen(true)}>
              <Trash2 className="mr-1 h-4 w-4 text-red-500" />삭제
            </Button>
            <Button size="sm" variant="secondary" disabled={busy}
              onClick={() => setGenerateOpen(true)}>
              <Boxes className="mr-1 h-4 w-4" />품목생성
            </Button>
            <Button size="sm" onClick={() => setPanel({ mode: 'create', form: emptyMoldForm() })}>
              <Plus className="mr-1 h-4 w-4" />등록
            </Button>
          </div>
        </header>

        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <MoldCodeField popupId="mold-search" returnKey="moldCode"
              label="S-PARTS 코드" placeholder="S-PARTS 코드"
              value={moldCode} onChange={setMoldCode} />
            <ComCodeSelect groupCode="MOLD GROUP" labelPrefix="그룹"
              value={moldGroup} onChange={setMoldGroup} className="w-56" />
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
              exportFileName="S-PARTS"
              emptyMessage="조회 버튼을 눌러 S-PARTS 를 확인하세요."
              onRowClick={(row) => setSelected(row as MoldMasterRow)}
              getRowId={(row) => {
                const mold = row as MoldMasterRow;
                return `${mold.moldCode}|${mold.moldVersion ?? ''}|${mold.moldSetSerial ?? ''}`;
              }}
            />
          </CardContent>
        </Card>

        <Card padding="none" className="h-60 shrink-0 overflow-hidden">
          <CardContent className="flex h-full flex-col p-3">
            <nav className="mb-2 flex gap-1 border-b border-border" aria-label="상세 탭">
              {([['bills', '소요품목'], ['inventory', '재고']] as const).map(([key, label]) => (
                <button
                  key={key}
                  type="button"
                  onClick={() => setTab(key)}
                  className={`px-3 py-1.5 text-sm ${
                    tab === key
                      ? 'border-b-2 border-primary font-semibold text-text'
                      : 'text-text-muted'
                  }`}
                >
                  {label}
                </button>
              ))}
              <span className="ml-auto self-center text-xs text-text-muted">
                {selected ? selected.moldCode : 'S-PARTS 를 선택하세요'}
              </span>
            </nav>
            <div className="min-h-0 flex-1">
              {tab === 'bills' ? (
                <DataGrid
                  data={bills}
                  columns={billColumns}
                  isLoading={detailLoading}
                  pageSize={20}
                  emptyMessage={selected ? '소요품목이 없습니다.' : 'S-PARTS 를 선택하세요.'}
                  getRowId={(row) => {
                    const bill = row as MoldBillRow;
                    return `${bill.itemCode}|${bill.sequence}`;
                  }}
                />
              ) : (
                <DataGrid
                  data={inventory}
                  columns={inventoryColumns}
                  isLoading={detailLoading}
                  pageSize={20}
                  emptyMessage={selected ? '재고가 없습니다.' : 'S-PARTS 를 선택하세요.'}
                  getRowId={(row) => {
                    const inv = row as MoldInventoryRow;
                    return `${inv.moldCode}|${inv.moldVersion ?? ''}|${inv.moldSetSerial ?? ''}`;
                  }}
                />
              )}
            </div>
          </CardContent>
        </Card>
      </main>

      {panel && (
        <MoldMasterFormPanel
          key={`${panel.mode}-${panel.form.moldCode}`}
          mode={panel.mode}
          initialForm={panel.form}
          onClose={() => setPanel(null)}
          onSaved={() => { setPanel(null); void search(); }}
        />
      )}

      <ConfirmModal
        isOpen={deleteOpen}
        onClose={() => setDeleteOpen(false)}
        onConfirm={removeMold}
        title="S-PARTS 연쇄삭제"
        message={selected
          ? `${selected.moldCode} 을(를) 지우면 그 S-PARTS 의 구매단가·부족이력·대여·출고·수리·입고·재고가 함께 지워집니다. 되돌릴 수 없습니다.`
          : ''}
        variant="danger"
      />

      <ConfirmModal
        isOpen={generateOpen}
        onClose={() => setGenerateOpen(false)}
        onConfirm={generateItems}
        title="품목 일괄생성"
        message="아직 품목이 없는 S-PARTS 를 품목마스터에 만듭니다. 이미 있는 것은 건너뜁니다."
      />
    </div>
  );
}
