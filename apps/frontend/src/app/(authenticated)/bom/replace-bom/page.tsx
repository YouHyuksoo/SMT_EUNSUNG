"use client";

/**
 * @file src/app/(authenticated)/bom/replace-bom/page.tsx
 * @description 대체BOM관리 — PB w_des_replace_bom_master ("ENG BOM Replace Master") 이식
 *
 * 초보자 가이드:
 * 1. **관리 모드**: SET 품목의 BOM 을 전개(PKG_DESIGN.BOM_QUERY)하고, 구성품 행을 고른 뒤
 *    대체품을 등록한다. 전개는 임시테이블을 쓰지만 서버가 커넥션 반납 시 자동 정리한다.
 * 2. **목록 모드**: 등록된 대체품(ID_ITEM_REPLACE)을 조회/수정/삭제한다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { GitFork, RefreshCw, Search } from 'lucide-react';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import DateFilter from '@/components/shared/DateFilter';
import DataGrid from '@/components/data-grid/DataGrid';
import api from '@/services/api';
import { useUnsavedGuard } from '@/hooks/useUnsavedGuard';
import ReplaceBomFormPanel from './components/ReplaceBomFormPanel';
import { bomExpandColumns, replaceColumns } from './columns';
import type { BomExpandRow, ReplaceBomMode, ReplaceForm, ReplaceRow } from './types';

const today = () => new Date().toISOString().slice(0, 10);
const emptyForm = (): ReplaceForm => ({
  parentItemCode: '', childItemCode: '', replaceItemCode: '', workstageCode: '',
  itemUnitQty: 1, dateset: today(), dateend: '9999-12-31', bomLocationCode: '',
});

export default function ReplaceBomPage() {
  const [mode, setMode] = useState<ReplaceBomMode>('MANAGE');
  const [loading, setLoading] = useState(false);

  // 관리 모드
  const [setItemCode, setSetItemCode] = useState('');
  const [expandDate, setExpandDate] = useState(today());
  const [bomRows, setBomRows] = useState<BomExpandRow[]>([]);
  const [bomSearched, setBomSearched] = useState(false);

  // 목록 모드
  const [rows, setRows] = useState<ReplaceRow[]>([]);
  const [total, setTotal] = useState(0);
  const [searched, setSearched] = useState(false);
  const [qParent, setQParent] = useState('');
  const [qChild, setQChild] = useState('');
  const [qReplace, setQReplace] = useState('');

  // 등록/수정 우측 패널 + 삭제
  const [isPanelOpen, setIsPanelOpen] = useState(false);
  const [panelMode, setPanelMode] = useState<'create' | 'edit'>('create');
  const [form, setForm] = useState<ReplaceForm>(emptyForm);
  const { markDirty, guard, guardModalProps } = useUnsavedGuard();
  const [deleteTarget, setDeleteTarget] = useState<ReplaceRow | null>(null);

  const expandBom = useCallback(async () => {
    if (!setItemCode.trim()) { toast.error('SET 품목코드를 입력하세요'); return; }
    setLoading(true);
    try {
      const res = await api.get('/bom/replace/expand', { params: { setItemCode: setItemCode.trim(), dateset: expandDate || undefined } });
      setBomRows(res.data?.data?.data ?? []);
      setBomSearched(true);
    } catch (error: unknown) {
      setBomRows([]);
      const msg = (error as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(msg || 'BOM 전개에 실패했습니다');
    } finally {
      setLoading(false);
    }
  }, [expandDate, setItemCode]);

  const searchList = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get('/bom/replace', {
        params: { limit: '5000', setItemCode: qParent || undefined, childItemCode: qChild || undefined, replaceItemCode: qReplace || undefined },
      });
      setRows(res.data?.data ?? []);
      setTotal(Number(res.data?.meta?.total ?? 0));
      setSearched(true);
    } catch {
      setRows([]); setTotal(0);
      toast.error('대체품 조회에 실패했습니다');
    } finally {
      setLoading(false);
    }
  }, [qChild, qParent, qReplace]);

  /** 관리 모드에서 BOM 구성품 행을 고르면 그 품목을 대상으로 대체품 등록 폼을 연다 */
  const openAddFromBom = useCallback((row: BomExpandRow) => {
    guard(() => {
    setForm({
      ...emptyForm(),
      parentItemCode: row.parentItemCode ?? '',
      childItemCode: row.childItemCode ?? '',
      workstageCode: row.workstageCode ?? '',
      itemUnitQty: Number(row.itemUnitQty ?? 1),
    });
    setPanelMode('create');
    setIsPanelOpen(true);
    });
  }, [guard]);

  const openEdit = useCallback((row: ReplaceRow) => {
    guard(() => {
    setForm({
      parentItemCode: row.parentItemCode, childItemCode: row.childItemCode,
      replaceItemCode: row.replaceItemCode, workstageCode: row.workstageCode ?? '',
      itemUnitQty: Number(row.itemUnitQty ?? 1),
      dateset: (row.dateset ?? today()).slice(0, 10),
      dateend: (row.dateend ?? '9999-12-31').slice(0, 10),
      bomLocationCode: row.bomLocationCode ?? '',
    });
    setPanelMode('edit');
    setIsPanelOpen(true);
    });
  }, [guard]);

  const doDelete = useCallback(async () => {
    if (!deleteTarget) return;
    try {
      await api.delete('/bom/replace', { data: {
        parentItemCode: deleteTarget.parentItemCode, childItemCode: deleteTarget.childItemCode,
        replaceItemCode: deleteTarget.replaceItemCode,
      } });
      toast.success('삭제했습니다');
      setDeleteTarget(null);
      await searchList();
    } catch (error: unknown) {
      const msg = (error as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(msg || '삭제에 실패했습니다');
    }
  }, [deleteTarget, searchList]);

  // 작성 중이면 확인 모달을 거쳐 닫는다 (저장소 공용 useUnsavedGuard).
  const closePanel = useCallback(() => {
    guard(() => setIsPanelOpen(false));
  }, [guard]);

  const onPanelSaved = useCallback(async () => {
    markDirty(false);
    setIsPanelOpen(false);
    if (mode === 'LIST' && searched) await searchList();
  }, [markDirty, mode, searchList, searched]);

  const listColumns = useMemo(() => replaceColumns(openEdit, setDeleteTarget), [openEdit]);

  return (
    <div className="flex h-full animate-fade-in">
      <main className="flex h-full min-w-0 flex-1 flex-col gap-3 p-5">
        <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <GitFork className="h-6 w-6 text-primary" />대체BOM관리
          </h1>
          <p className="mt-1 text-sm text-text-muted">PB w_des_replace_bom_master · SET 품목 BOM 전개 후 구성품별 대체품 등록</p>
        </div>
        <nav className="flex flex-wrap gap-1 border-b border-border" aria-label="조회 모드">
          {([['MANAGE', '대체품 관리'], ['LIST', '대체품 목록']] as const).map(([value, label]) => (
            <button
              key={value}
              type="button"
              onClick={() => setMode(value)}
              aria-current={mode === value ? 'page' : undefined}
              className={`px-4 py-2 text-sm font-medium transition-colors ${
                mode === value ? 'border-b-2 border-primary text-primary' : 'text-text-muted hover:text-text'
              }`}
            >
              {label}
            </button>
          ))}
        </nav>
      </header>

      {mode === 'MANAGE' ? (
        <>
          <Card className="shrink-0" padding="sm">
            <div className="flex flex-wrap items-center gap-2">
              <Input aria-label="SET 품목코드" placeholder="SET 품목코드" value={setItemCode} onChange={e => setSetItemCode(e.target.value)} className="w-52" />
              <label className="flex items-center gap-1 whitespace-nowrap text-sm text-text-muted">
                기준일자
                <DateFilter value={expandDate} onChange={setExpandDate} />
              </label>
              <Button size="sm" onClick={expandBom} disabled={loading}>
                <Search className="mr-1 h-4 w-4" />BOM 전개
              </Button>
              <span className="text-sm text-text-muted">{bomSearched ? `${bomRows.length}건 · 행을 클릭해 대체품 등록` : 'SET 품목을 전개하세요'}</span>
            </div>
          </Card>
          <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
            <CardContent className="h-full p-3">
              <DataGrid data={bomRows} columns={bomExpandColumns} isLoading={loading} pageSize={50}
                onRowClick={openAddFromBom}
                emptyMessage={bomSearched ? 'BOM 구성품이 없습니다.' : 'SET 품목코드로 BOM 을 전개하세요.'} />
            </CardContent>
          </Card>
        </>
      ) : (
        <>
          <Card className="shrink-0" padding="sm">
            <div className="flex flex-wrap items-center gap-2">
              <Input aria-label="상위품목" placeholder="상위품목(SET)" value={qParent} onChange={e => setQParent(e.target.value)} className="w-44" />
              <Input aria-label="구성품목" placeholder="구성품목" value={qChild} onChange={e => setQChild(e.target.value)} className="w-44" />
              <Input aria-label="대체품목" placeholder="대체품목" value={qReplace} onChange={e => setQReplace(e.target.value)} className="w-44" />
              <Button size="sm" onClick={searchList} disabled={loading}><Search className="mr-1 h-4 w-4" />조회</Button>
              <Button variant="secondary" size="sm" onClick={searchList} disabled={loading}><RefreshCw className={`mr-1 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />새로고침</Button>
              <span className="text-sm text-text-muted">{searched ? `${rows.length}/${total}건` : '조회조건을 입력하세요'}</span>
            </div>
          </Card>
          <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
            <CardContent className="h-full p-3">
              <DataGrid data={rows} columns={listColumns} isLoading={loading} pageSize={50}
                enableColumnFilter enableExport exportFileName="대체BOM"
                emptyMessage={searched ? '조회 결과가 없습니다.' : '조회 버튼을 눌러 대체품을 확인하세요.'} />
            </CardContent>
          </Card>
        </>
      )}

        <ConfirmModal isOpen={!!deleteTarget} onClose={() => setDeleteTarget(null)} onConfirm={doDelete}
          variant="danger" title="대체품 삭제" confirmText="삭제"
          message={deleteTarget ? <span>{deleteTarget.parentItemCode} / {deleteTarget.childItemCode} → <strong>{deleteTarget.replaceItemCode}</strong> 대체품을 삭제합니다.</span> : ''} />
      </main>

      {isPanelOpen && (
        <ReplaceBomFormPanel
          key={`${panelMode}-${form.parentItemCode}-${form.childItemCode}-${form.replaceItemCode}`}
          mode={panelMode}
          initialForm={form}
          onClose={closePanel}
          onSave={onPanelSaved}
          onDirtyChange={markDirty}
        />
      )}

      <ConfirmModal {...guardModalProps} />
    </div>
  );
}
