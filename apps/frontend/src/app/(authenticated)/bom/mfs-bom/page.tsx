"use client";

/**
 * @file src/app/(authenticated)/bom/mfs-bom/page.tsx
 * @description 제조BOM관리 — PB w_des_mfs_bom_master 이식
 *
 * 초보자 가이드:
 * 1. **4개 영역**: 모델 목록(좌상) · 피더 레이아웃(우상) · MFS 목록(좌하) · MFS 상세(우하).
 *    모델을 고르면 그 품목의 MFS 목록을, MFS 를 고르면 상세와 피더 레이아웃을 읽는다.
 * 2. **처리**: 생성·복사는 우측 패널, 삭제·승인·승인취소·전체 사용/미사용은 확인 모달을 거친다.
 *    처리 후에는 MFS 목록과 상세를 다시 읽는다.
 * 3. **승인된 MFS** 는 서버가 생성(덮어쓰기)과 삭제를 막는다. 승인취소 후 진행한다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { CheckCircle, Copy, Layers, Play, Search, Trash2, Undo2 } from 'lucide-react';
import { Button, Card, CardContent, ConfirmModal } from '@/components/ui';
import ModelSearchField from '@/components/shared/ModelSearchField';
import DataGrid from '@/components/data-grid/DataGrid';
import api from '@/services/api';
import MfsActionPanel from './components/MfsActionPanel';
import { detailColumns, feederColumns, mfsColumns, modelColumns } from './columns';
import type {
  MfsConfirmAction, MfsDetailRow, MfsFeederRow, MfsModelRow, MfsPanelMode, MfsSummaryRow,
} from './types';
import PartSearchField from '@/components/shared/PartSearchField';

const errorMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

/** 확인 모달로 실행하는 작업의 문구와 API */
const ACTIONS: Record<MfsConfirmAction, { title: string; verb: string; url: string; body?: Record<string, string>; danger?: boolean }> = {
  drop: { title: '제조BOM 삭제', verb: '삭제', url: '/bom/mfs/drop', danger: true },
  confirm: { title: '제조BOM 승인', verb: '승인', url: '/bom/mfs/confirm' },
  unconfirm: { title: '제조BOM 승인취소', verb: '승인취소', url: '/bom/mfs/unconfirm' },
  usedY: { title: '전체 사용', verb: '전체 사용으로 변경', url: '/bom/mfs/used', body: { usedYn: 'Y' } },
  usedN: { title: '전체 미사용', verb: '전체 미사용으로 변경', url: '/bom/mfs/used', body: { usedYn: 'N' } },
};

export default function MfsBomPage() {
  // 조회조건
  const [qModel, setQModel] = useState('');
  const [qItem, setQItem] = useState('');

  // (1) 모델
  const [models, setModels] = useState<MfsModelRow[]>([]);
  const [modelsSearched, setModelsSearched] = useState(false);
  const [modelsLoading, setModelsLoading] = useState(false);
  const [model, setModel] = useState<MfsModelRow | null>(null);

  // (3) MFS 목록
  const [mfsList, setMfsList] = useState<MfsSummaryRow[]>([]);
  const [mfsLoading, setMfsLoading] = useState(false);
  const [mfs, setMfs] = useState<MfsSummaryRow | null>(null);

  // (4) 상세 · (2) 피더
  const [detail, setDetail] = useState<MfsDetailRow[]>([]);
  const [feeder, setFeeder] = useState<MfsFeederRow[]>([]);
  const [detailLoading, setDetailLoading] = useState(false);
  const [childFilter, setChildFilter] = useState('');

  // 처리
  const [panelMode, setPanelMode] = useState<MfsPanelMode | null>(null);
  const [confirmAction, setConfirmAction] = useState<MfsConfirmAction | null>(null);
  const [running, setRunning] = useState(false);

  const searchModels = useCallback(async () => {
    setModelsLoading(true);
    try {
      const res = await api.get('/bom/mfs/models', {
        params: { modelName: qModel || undefined, itemCode: qItem.trim() || undefined },
      });
      setModels(res.data?.data ?? []);
      setModelsSearched(true);
      setModel(null); setMfsList([]); setMfs(null); setDetail([]); setFeeder([]);
    } catch (error: unknown) {
      setModels([]);
      toast.error(errorMessage(error) || '모델 조회에 실패했습니다');
    } finally {
      setModelsLoading(false);
    }
  }, [qItem, qModel]);

  const loadMfsData = useCallback(async (target: MfsModelRow, row: MfsSummaryRow) => {
    setDetailLoading(true);
    try {
      const [d, f] = await Promise.all([
        api.get('/bom/mfs/detail', { params: { itemCode: row.itemCode, mfs: row.mfs } }),
        target.smtModelName
          ? api.get('/bom/mfs/feeder', { params: { smtModelName: target.smtModelName, mfs: row.mfs } })
          : Promise.resolve(null),
      ]);
      setDetail(d.data?.data ?? []);
      setFeeder(f?.data?.data ?? []);
    } catch (error: unknown) {
      setDetail([]); setFeeder([]);
      toast.error(errorMessage(error) || 'MFS 상세 조회에 실패했습니다');
    } finally {
      setDetailLoading(false);
    }
  }, []);

  /** MFS 목록을 읽고, keepMfs 가 있으면 그 MFS 를 다시 선택한다 */
  const loadMfsList = useCallback(async (target: MfsModelRow, keepMfs?: string) => {
    if (!target.itemCode) { setMfsList([]); setMfs(null); return; }
    setMfsLoading(true);
    try {
      const res = await api.get('/bom/mfs', { params: { itemCode: target.itemCode } });
      const rows: MfsSummaryRow[] = res.data?.data ?? [];
      setMfsList(rows);
      const next = keepMfs ? rows.find(r => r.mfs === keepMfs) ?? null : null;
      setMfs(next);
      if (next) await loadMfsData(target, next);
      else { setDetail([]); setFeeder([]); }
    } catch (error: unknown) {
      setMfsList([]);
      toast.error(errorMessage(error) || 'MFS 목록 조회에 실패했습니다');
    } finally {
      setMfsLoading(false);
    }
  }, [loadMfsData]);

  const selectModel = useCallback((row: MfsModelRow) => {
    setModel(row);
    setChildFilter('');
    setPanelMode(null);
    if (!row.itemCode) toast.error('품목코드가 없는 모델입니다');
    void loadMfsList(row);
  }, [loadMfsList]);

  const selectMfs = useCallback((row: MfsSummaryRow) => {
    if (!model) return;
    setMfs(row);
    setChildFilter('');
    void loadMfsData(model, row);
  }, [loadMfsData, model]);

  const runConfirmAction = useCallback(async () => {
    if (!confirmAction || !mfs || !model) return;
    const action = ACTIONS[confirmAction];
    setRunning(true);
    try {
      await api.post(action.url, { itemCode: mfs.itemCode, mfs: mfs.mfs, ...action.body });
      toast.success(`${mfs.mfs} ${action.verb} 처리했습니다`);
      setConfirmAction(null);
      await loadMfsList(model, confirmAction === 'drop' ? undefined : mfs.mfs);
    } catch (error: unknown) {
      setConfirmAction(null);
      toast.error(errorMessage(error) || `${action.verb}에 실패했습니다`);
    } finally {
      setRunning(false);
    }
  }, [confirmAction, loadMfsList, mfs, model]);

  const onPanelDone = useCallback(async (newMfs: string) => {
    setPanelMode(null);
    if (model) await loadMfsList(model, newMfs);
  }, [loadMfsList, model]);

  const filteredDetail = useMemo(() => {
    const q = childFilter.trim().toUpperCase();
    return q ? detail.filter(r => r.childItemCode?.toUpperCase().includes(q)) : detail;
  }, [childFilter, detail]);

  const hasModel = Boolean(model?.itemCode);
  const hasMfs = Boolean(mfs);
  const busy = running || detailLoading || mfsLoading;

  return (
    <div className="flex h-full animate-fade-in">
      <main className="flex h-full min-w-0 flex-1 flex-col gap-3 p-5">
        <header>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <Layers className="h-6 w-6 text-primary" />제조BOM관리
          </h1>
          <p className="mt-1 text-sm text-text-muted">제품 모델별로 설계BOM 을 전개해 제조BOM(MFS)을 만들고 승인·사용 여부를 관리합니다</p>
        </header>

        <Card className="shrink-0" padding="sm">
          <div className="flex flex-wrap items-center gap-2">
            <ModelSearchField value={qModel} onChange={v => setQModel(v)} className="w-56" />
            <PartSearchField aria-label="품목코드" placeholder="품목코드 (앞부분 일치)" value={qItem}
              onChange={e => setQItem(e.target.value)} onKeyDown={e => { if (e.key === 'Enter') void searchModels(); }} className="w-52" />
            <Button size="sm" onClick={searchModels} disabled={modelsLoading}>
              <Search className="mr-1 h-4 w-4" />조회
            </Button>
            <span className="text-sm text-text-muted">
              {modelsSearched ? `모델 ${models.length}건` : '조회조건을 입력하세요'}
              {model && ` · 선택: ${model.modelName} (${model.itemCode ?? '품목코드 없음'})`}
            </span>
          </div>
        </Card>

        <div className="grid min-h-0 flex-1 grid-cols-1 gap-3 lg:grid-cols-2 lg:grid-rows-2">
          {/* (1) 모델 목록 */}
          <Card className="flex min-h-0 flex-col overflow-hidden" padding="none">
            <div className="shrink-0 border-b border-border px-3 py-2 text-sm font-semibold text-text">모델 목록</div>
            <CardContent className="min-h-0 flex-1 p-3">
              <DataGrid data={models} columns={modelColumns} isLoading={modelsLoading} pageSize={50}
                onRowClick={selectModel}
                getRowId={r => r.modelName} selectedRowId={model?.modelName}
                emptyMessage={modelsSearched ? '조회 결과가 없습니다.' : '조회 버튼을 눌러 모델을 확인하세요.'} />
            </CardContent>
          </Card>

          {/* (2) 피더 레이아웃 */}
          <Card className="flex min-h-0 flex-col overflow-hidden" padding="none">
            <div className="shrink-0 border-b border-border px-3 py-2 text-sm font-semibold text-text">
              피더 레이아웃
              <span className="ml-2 font-normal text-text-muted">
                {mfs ? `SMT 모델 ${model?.smtModelName ?? '없음'} · 리비전 ${mfs.mfs}` : 'MFS 를 선택하세요'}
              </span>
            </div>
            <CardContent className="min-h-0 flex-1 p-3">
              <DataGrid data={feeder} columns={feederColumns} isLoading={detailLoading} pageSize={50}
                emptyMessage={mfs ? '이 MFS 리비전의 피더 레이아웃이 없습니다.' : 'MFS 를 선택하면 표시됩니다.'} />
            </CardContent>
          </Card>

          {/* (3) MFS 목록 */}
          <Card className="flex min-h-0 flex-col overflow-hidden" padding="none">
            <div className="flex shrink-0 flex-wrap items-center gap-1 border-b border-border px-3 py-2">
              <span className="mr-auto text-sm font-semibold text-text">제조BOM(MFS) 목록</span>
              <Button size="sm" onClick={() => setPanelMode('generate')} disabled={!hasModel || busy}>
                <Play className="mr-1 h-4 w-4" />생성
              </Button>
              <Button size="sm" variant="secondary" onClick={() => setPanelMode('copy')} disabled={!hasMfs || busy}>
                <Copy className="mr-1 h-4 w-4" />복사
              </Button>
              <Button size="sm" variant="secondary" onClick={() => setConfirmAction('confirm')} disabled={!hasMfs || busy}>
                <CheckCircle className="mr-1 h-4 w-4" />승인
              </Button>
              <Button size="sm" variant="secondary" onClick={() => setConfirmAction('unconfirm')} disabled={!hasMfs || busy}>
                <Undo2 className="mr-1 h-4 w-4" />승인취소
              </Button>
              <Button size="sm" variant="danger" onClick={() => setConfirmAction('drop')} disabled={!hasMfs || busy}>
                <Trash2 className="mr-1 h-4 w-4" />삭제
              </Button>
            </div>
            <CardContent className="min-h-0 flex-1 p-3">
              <DataGrid data={mfsList} columns={mfsColumns} isLoading={mfsLoading} pageSize={50}
                onRowClick={selectMfs}
                getRowId={r => r.mfs} selectedRowId={mfs?.mfs}
                emptyMessage={hasModel ? '이 품목의 제조BOM 이 없습니다. 생성 버튼으로 만드세요.' : '모델을 선택하세요.'} />
            </CardContent>
          </Card>

          {/* (4) MFS 상세 */}
          <Card className="flex min-h-0 flex-col overflow-hidden" padding="none">
            <div className="flex shrink-0 flex-wrap items-center gap-1 border-b border-border px-3 py-2">
              <span className="mr-auto text-sm font-semibold text-text">
                MFS 상세
                <span className="ml-2 font-normal text-text-muted">
                  {mfs ? `${mfs.mfs} · ${filteredDetail.length}/${detail.length}행` : ''}
                </span>
              </span>
              <PartSearchField aria-label="구성품목 필터" placeholder="구성품목 필터" value={childFilter}
                onChange={e => setChildFilter(e.target.value)} className="w-40" disabled={!hasMfs} />
              <Button size="sm" variant="secondary" onClick={() => setConfirmAction('usedY')} disabled={!hasMfs || busy}>전체 사용</Button>
              <Button size="sm" variant="secondary" onClick={() => setConfirmAction('usedN')} disabled={!hasMfs || busy}>전체 미사용</Button>
            </div>
            <CardContent className="min-h-0 flex-1 p-3">
              <DataGrid data={filteredDetail} columns={detailColumns} isLoading={detailLoading} pageSize={100}
                enableExport exportFileName={`제조BOM_${mfs?.itemCode ?? ''}_${mfs?.mfs ?? ''}`}
                rowClassName={row => row.lineType === 'T' ? 'bg-green-50 dark:bg-green-900/20' : ''}
                emptyMessage={mfs ? '상세 행이 없습니다.' : 'MFS 를 선택하세요.'} />
            </CardContent>
          </Card>
        </div>

        <ConfirmModal
          isOpen={!!confirmAction}
          onClose={() => setConfirmAction(null)}
          onConfirm={runConfirmAction}
          isLoading={running}
          variant={confirmAction && ACTIONS[confirmAction].danger ? 'danger' : 'default'}
          title={confirmAction ? ACTIONS[confirmAction].title : ''}
          confirmText={confirmAction ? ACTIONS[confirmAction].verb : ''}
          message={confirmAction && mfs
            ? <span>{mfs.itemCode} 의 <strong>{mfs.mfs}</strong> 제조BOM {mfs.rowCount}행을 {ACTIONS[confirmAction].verb}합니다.</span>
            : ''} />
      </main>

      {panelMode && model?.itemCode && (
        <MfsActionPanel
          key={`${panelMode}-${model.itemCode}-${mfs?.mfs ?? ''}`}
          mode={panelMode}
          itemCode={model.itemCode}
          modelName={model.modelName}
          sourceMfs={mfs?.mfs}
          existingMfs={mfsList.map(r => r.mfs)}
          onClose={() => setPanelMode(null)}
          onDone={onPanelDone}
        />
      )}
    </div>
  );
}
