"use client";

/**
 * @file src/app/(authenticated)/product/fg-stocktake/page.tsx
 * @description 제품 실사 — 창고의 제품 박스를 세어 제품재고를 맞춘다
 *
 * 초보자 가이드:
 * 1. **순서**: 실사 시작(지금 제품재고를 장부로 고정) → 박스 바코드 스캔·엑셀 → 일괄 조정.
 *    실사 중에는 제품 입출고를 멈춘다 (장부가 시작 시점에 고정된다).
 * 2. **제품재고는 박스 단위다.** 찍힌 박스는 있는 것, 안 찍힌 박스는 없는 것(실사 0)으로 본다.
 * 3. **일괄 조정**은 박스별 (실사 − 장부)를 재고에 더한다. 입고·출고 내역에는 들어가지 않고 재고조정으로
 *    따로 남으며, 월마감의 '조정' 칸에 합산된다. 이미 넣은 조정은 빼고 넣으므로 다시 눌러도 두 번 들어가지 않는다.
 * 4. 입력은 count-card.tsx, API 는 fg-stocktake.ts, 컬럼은 columns.tsx.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { ClipboardCheck, RefreshCw, Scale } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, ConfirmModal, Input, Select } from '@/components/ui';
import CountCard from './count-card';
import { fgCheckColumns } from './columns';
import {
  apiMessage, fgApi, type FgCheckList, type FgCheckRow, type FgListFilter, type FgSession, type FgStatusFilter,
} from './fg-stocktake';

const thisMonth = () => {
  const d = new Date();
  return `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}`;
};

type Pending = 'start' | 'regenerate' | 'adjust' | null;

const EMPTY_LIST: FgCheckList = { data: [], total: 0, truncated: false };

export default function FgStocktakePage() {
  const [session, setSession] = useState<FgSession | null>(null);
  const [loaded, setLoaded] = useState(false);
  const [list, setList] = useState<FgCheckList>(EMPTY_LIST);
  const [filter, setFilter] = useState<FgListFilter>({ status: '', barcode: '', modelName: '' });
  const [loading, setLoading] = useState(false);
  const [pending, setPending] = useState<Pending>(null);
  const [busy, setBusy] = useState(false);
  const startMonth = thisMonth();

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const s = await fgApi.active();
      setSession(s);
      setList(s ? await fgApi.list(s.yyyymm, filter) : EMPTY_LIST);
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
      setLoaded(true);
    }
  }, [filter]);

  useEffect(() => { void load(); }, [load]);

  const run = async () => {
    if (!pending) return;
    setBusy(true);
    try {
      if (pending === 'adjust' && session) {
        const r = await fgApi.adjustAll(session.yyyymm);
        toast.success(`${r.adjusted.toLocaleString()}박스를 조정했습니다 (수량 ${r.adjustedQty.toLocaleString()}).`);
      } else {
        const ym = pending === 'regenerate' && session ? session.yyyymm : startMonth;
        const r = await fgApi.start(ym, pending === 'regenerate');
        toast.success(`${r.yyyymm} 제품 실사표를 만들었습니다 — ${r.boxes.toLocaleString()}박스.`);
      }
      setPending(null);
      await load();
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  };

  const canStartNew = !session || session.yyyymm !== startMonth;
  const unscanned = session ? Math.max(0, session.boxes - session.scannedBoxes) : 0;
  const message = pending === 'adjust' && session
    ? `${session.yyyymm} 제품 실사 결과로 제품재고를 조정합니다.`
      + `\n\n· 조정할 박스 ${session.pendingBoxes.toLocaleString()}개 (센 박스 ${session.scannedBoxes.toLocaleString()}개)`
      + `\n· 안 센 박스 ${unscanned.toLocaleString()}개는 실사 0 으로 재고가 0 이 된다 — 다 찍은 뒤에 눌러야 한다.`
      + `\n· 조정은 ${session.yyyymm} 마지막 날짜의 재고조정으로 남고 입고·출고 내역에는 들어가지 않습니다.`
    : pending === 'regenerate' && session
      ? `${session.yyyymm} 실사표의 장부 수량을 지금 제품재고로 다시 고정합니다. 센 수량은 그대로 남습니다.`
      : `${startMonth} 제품 실사를 시작합니다. 지금 제품재고(수량 0 이 아닌 박스)를 실사표에 고정합니다.`
        + '\n\n실사가 끝날 때까지 제품 입고·출고를 멈추세요.';

  const setStatus = (status: FgStatusFilter) => setFilter((f) => ({ ...f, status }));

  return (
    <div className="flex h-full flex-col gap-3 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">제품실사</h1>
        <p className="mt-1 text-sm text-text-muted">
          창고의 제품 박스를 세어 제품재고를 맞춥니다 · 차이 = 실사 − 장부
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <ClipboardCheck className="h-4 w-4" />제품 실사
          </span>
          {session ? (
            <span className="text-sm text-text">
              {session.yyyymm} · 장부 {session.bookBoxes.toLocaleString()}박스 ({session.bookQty.toLocaleString()}) · 센 박스{' '}
              {session.scannedBoxes.toLocaleString()} (실사 {session.checkQty.toLocaleString()}) ·
              <span className={session.pendingBoxes ? 'text-amber-500' : 'text-emerald-500'}>
                {' '}조정할 박스 {session.pendingBoxes.toLocaleString()}
              </span>
            </span>
          ) : (
            <span className="text-sm text-text-muted">{loaded ? '진행 중인 제품 실사가 없습니다.' : ''}</span>
          )}
          <div className="ml-auto flex gap-2">
            {session && (
              <>
                <Button size="sm" variant="secondary" disabled={busy}
                  data-tooltip="장부 수량을 지금 제품재고로 다시 고정합니다. 센 수량은 남습니다. 조정을 넣기 전에만 됩니다."
                  onClick={() => setPending('regenerate')}>
                  <RefreshCw className="mr-1 h-4 w-4" />장부 다시 고정
                </Button>
                <Button size="sm" disabled={busy || !session.pendingBoxes}
                  data-tooltip="박스별 차이를 제품재고에 더하고 재고조정으로 남깁니다."
                  onClick={() => setPending('adjust')}>
                  <Scale className="mr-1 h-4 w-4" />일괄 조정
                </Button>
              </>
            )}
            {canStartNew && (
              <Button size="sm" variant={session ? 'secondary' : 'primary'} disabled={busy}
                data-tooltip="지금 제품재고를 실사표에 고정하고 스캔을 받습니다."
                onClick={() => setPending('start')}>
                <ClipboardCheck className="mr-1 h-4 w-4" />{startMonth} 실사 시작
              </Button>
            )}
          </div>
        </CardContent>
      </Card>

      {session && <CountCard session={session} onCounted={() => { void load(); }} />}

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Select aria-label="상태" placeholder="전체" value={filter.status}
            onChange={(v) => setStatus(v as FgStatusFilter)}
            options={[{ value: '', label: '전체' }, { value: 'diff', label: '차이만' }, { value: 'unscanned', label: '안 센 것만' }]} />
          <Input aria-label="박스 바코드" placeholder="박스 바코드 (앞부분)" className="w-64" value={filter.barcode}
            onChange={(e) => setFilter((f) => ({ ...f, barcode: e.target.value }))} />
          <Input aria-label="모델" placeholder="모델명 (앞부분)" className="w-48" value={filter.modelName}
            onChange={(e) => setFilter((f) => ({ ...f, modelName: e.target.value }))} />
          {list.truncated && (
            <span className="text-sm text-amber-500">
              일부만 표시합니다 (최대 {list.total.toLocaleString()}행). 상태·바코드·모델로 좁혀 보세요.
            </span>
          )}
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={list.data}
            columns={fgCheckColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName={`제품실사_${session?.yyyymm ?? ''}`}
            getRowId={(r) => `${(r as FgCheckRow).barcode}|${(r as FgCheckRow).locationCode}`}
            emptyMessage="실사표가 없습니다. 실사를 시작하세요."
            rowClassName={(row) => (Number((row as FgCheckRow).differenceQty) !== 0 ? 'bg-amber-500/5' : '')}
          />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={Boolean(pending)}
        onClose={() => setPending(null)}
        onConfirm={run}
        title={pending === 'adjust' ? '일괄 조정' : pending === 'regenerate' ? '장부 다시 고정' : '제품 실사 시작'}
        message={message}
        confirmText={pending === 'adjust' ? '조정' : '확인'}
      />
    </div>
  );
}
