"use client";

/**
 * @file src/app/(authenticated)/bom/raw-bom/page.tsx
 * @description 원단위BOM마스터 — PB w_des_raw_bom_master ("Raw BOM Master") 이식
 *
 * 초보자 가이드:
 * 1. **조회**: 모품목·자품목 코드 앞부분으로 ID_ENG_BOM 을 조회한다. 유효기간 조건이 없어
 *    종료된 행도 나오며, 종료일자가 오늘 이전인 행은 빨간 글자로 보인다(PB 와 같다).
 * 2. **품명 필터**: 받아온 행 안에서 자품목 품명으로 거른다(서버 재조회 없음, PB 와 같다).
 * 3. **수정만**: 행을 누르면 우측 패널에서 수정한다. PB 에 등록·삭제가 없어 여기에도 없다.
 * 4. **순환 검사**: 모품목(없으면 자품목) 코드가 있으면 그 품목 하위 범위를, 둘 다 비면
 *    조직 전체를 검사한다. 읽기 전용이며 유효기간과 관계없이 모든 행을 본다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Network, RefreshCw, Search } from 'lucide-react';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import DataGrid from '@/components/data-grid/DataGrid';
import api from '@/services/api';
import { useUnsavedGuard } from '@/hooks/useUnsavedGuard';
import { readRowLimit, readTruncated, TruncationNotice } from '@/app/(authenticated)/report/components/TruncationNotice';
import RawBomFormPanel from './components/RawBomFormPanel';
import LoopCheckModal from './components/LoopCheckModal';
import { rawBomColumns } from './columns';
import type { RawBomForm, RawBomLoopResult, RawBomRow } from './types';
import PartSearchField from '@/components/shared/PartSearchField';

const rowKey = (row: Pick<RawBomRow, 'parentItemCode' | 'childItemCode' | 'dateset'>) =>
  `${row.parentItemCode}::${row.childItemCode}::${row.dateset}`;

const toForm = (row: RawBomRow): RawBomForm => ({
  parentItemCode: row.parentItemCode,
  childItemCode: row.childItemCode,
  dateset: row.dateset,
  assyExplosionYn: row.assyExplosionYn ?? '',
  itemType: row.itemType ?? '',
  lineType: row.lineType ?? '',
  itemUnitQty: row.itemUnitQty == null ? '' : String(row.itemUnitQty),
  itemUnitQtyExt: row.itemUnitQtyExt == null ? '' : String(row.itemUnitQtyExt),
  workstageCode: row.workstageCode ?? '',
  sortSequence: row.sortSequence == null ? '' : String(row.sortSequence),
  dateend: row.dateend ?? '',
});

export default function RawBomPage() {
  const [loading, setLoading] = useState(false);
  const [rows, setRows] = useState<RawBomRow[]>([]);
  const [searched, setSearched] = useState(false);
  const [truncated, setTruncated] = useState(false);
  const [rowLimit, setRowLimit] = useState(10000);

  const [parentCode, setParentCode] = useState('');
  const [childCode, setChildCode] = useState('');
  const [nameFilter, setNameFilter] = useState('');

  const [checking, setChecking] = useState(false);
  const [loopResult, setLoopResult] = useState<RawBomLoopResult | null>(null);

  const [editing, setEditing] = useState<RawBomForm | null>(null);
  const { markDirty, guard, guardModalProps } = useUnsavedGuard();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get('/bom/raw-bom', {
        params: { parentItemCode: parentCode.trim() || undefined, childItemCode: childCode.trim() || undefined },
      });
      setRows(res.data?.data ?? []);
      setTruncated(readTruncated(res));
      setRowLimit(readRowLimit(res));
      setSearched(true);
    } catch (error: unknown) {
      setRows([]); setTruncated(false);
      const msg = (error as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(msg || '원단위BOM 조회에 실패했습니다');
    } finally {
      setLoading(false);
    }
  }, [childCode, parentCode]);

  const loopCheck = useCallback(async () => {
    const itemCode = parentCode.trim() || childCode.trim();
    setChecking(true);
    try {
      const res = await api.get('/bom/raw-bom/loop-check', { params: { itemCode: itemCode || undefined } });
      const result = res.data?.data as RawBomLoopResult | undefined;
      if (!result || result.total === 0) {
        toast.success(`순환 없음 (${itemCode ? `${itemCode} 하위 전개 범위` : '조직 전체'})`);
      } else {
        setLoopResult(result);
      }
    } catch (error: unknown) {
      const msg = (error as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(msg || '순환 검사에 실패했습니다');
    } finally {
      setChecking(false);
    }
  }, [childCode, parentCode]);

  /** PB ue_editchange: ITEM_NAME LIKE '%입력%' — 받아온 행 안에서만 거른다 */
  const visibleRows = useMemo(() => {
    const keyword = nameFilter.trim().toUpperCase();
    if (!keyword) return rows;
    return rows.filter(r => (r.itemName ?? '').toUpperCase().includes(keyword));
  }, [nameFilter, rows]);

  const openEdit = useCallback((row: RawBomRow) => {
    guard(() => setEditing(toForm(row)));
  }, [guard]);

  const closePanel = useCallback(() => {
    guard(() => setEditing(null));
  }, [guard]);

  const onPanelSaved = useCallback(async () => {
    markDirty(false);
    setEditing(null);
    if (searched) await search();
  }, [markDirty, search, searched]);

  const countText = !searched
    ? '조회조건을 입력하세요'
    : nameFilter.trim() ? `${visibleRows.length}/${rows.length}건` : `${rows.length}건`;

  return (
    <div className="flex h-full animate-fade-in">
      <main className="flex h-full min-w-0 flex-1 flex-col gap-3 p-5">
        <header>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <Network className="h-6 w-6 text-primary" />원단위BOM마스터
          </h1>
          <p className="mt-1 text-sm text-text-muted">ID_ENG_BOM 을 모품목·자품목으로 조회하고 행을 눌러 수정합니다. 종료일자가 지난 행은 빨간 글자입니다</p>
        </header>

        <Card className="shrink-0" padding="sm">
          <div className="flex flex-wrap items-center gap-2">
            <div className="flex items-center gap-1">
              <PartSearchField aria-label="모품목코드" placeholder="모품목코드" value={parentCode}
                onChange={e => setParentCode(e.target.value)} onKeyDown={e => { if (e.key === 'Enter') void search(); }} className="w-44" />
            </div>
            <div className="flex items-center gap-1">
              <PartSearchField aria-label="자품목코드" placeholder="자품목코드" value={childCode}
                onChange={e => setChildCode(e.target.value)} onKeyDown={e => { if (e.key === 'Enter') void search(); }} className="w-44" />
            </div>
            <Input aria-label="품명 필터" placeholder="품명 필터(조회 결과 안에서)" value={nameFilter}
              onChange={e => setNameFilter(e.target.value)} className="w-52" />
            <Button size="sm" onClick={search} disabled={loading}><Search className="mr-1 h-4 w-4" />조회</Button>
            <Button size="sm" variant="outline" onClick={loopCheck} disabled={checking}
              title="모품목(없으면 자품목) 코드가 정확히 일치하는 품목의 하위 범위, 둘 다 비면 조직 전체. 유효기간과 관계없이 모든 행을 검사합니다">
              <RefreshCw className="mr-1 h-4 w-4" />{checking ? '검사 중' : '순환 검사'}
            </Button>
            <span className="text-sm text-text-muted">{countText}</span>
          </div>
        </Card>

        <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

        <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
          <CardContent className="h-full p-3">
            <DataGrid data={visibleRows} columns={rawBomColumns} isLoading={loading} pageSize={50}
              onRowClick={openEdit}
              rowClassName={row => row.expiredYn === 'Y' ? 'text-red-500' : ''}
              getRowId={rowKey} selectedRowId={editing ? rowKey(editing) : undefined}
              enableColumnFilter enableExport exportFileName="원단위BOM"
              emptyMessage={searched ? '조회 결과가 없습니다.' : '조회 버튼을 눌러 BOM 을 확인하세요.'} />
          </CardContent>
        </Card>
      </main>

      {editing && (
        <RawBomFormPanel
          key={rowKey(editing)}
          initialForm={editing}
          onClose={closePanel}
          onSave={onPanelSaved}
          onDirtyChange={markDirty}
        />
      )}

      <LoopCheckModal result={loopResult} onClose={() => setLoopResult(null)} />
      <ConfirmModal {...guardModalProps} />
    </div>
  );
}
