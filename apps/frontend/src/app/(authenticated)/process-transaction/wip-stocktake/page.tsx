"use client";

/**
 * @file src/app/(authenticated)/process-transaction/wip-stocktake/page.tsx
 * @description 공정 실사 — 라인에 있는 자재를 세어 공정재고(품목 단위)를 맞춘다
 *
 * 초보자 가이드:
 * 1. **순서**: 실사 시작(지금 공정재고를 장부로 고정) → 입력(릴 바코드 스캔 · 품목코드+수량 · 엑셀)
 *    → 일괄 조정. 실사 중에는 라인 투입·생산 실적을 멈춘다 (장부가 시작 시점에 고정된다).
 * 2. **공정재고는 품목 단위다.** 같은 품목의 입력은 모두 더해 그 품목의 실사수량이 된다.
 *    입력이 없는 품목은 0 으로 보고 조정 때 공정재고에서 뺀다.
 * 3. **일괄 조정**은 품목별 (장부 − 실사) 를 그 달 마지막 날짜의 공정출고로 넣는다. 이미 넣은 조정은
 *    빼고 넣으므로 다시 눌러도 두 번 들어가지 않는다. 조정 뒤에는 장부를 다시 고정할 수 없다.
 * 4. 입력은 count-card.tsx, API 는 wip-stocktake.ts, 컬럼은 columns.tsx.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { ClipboardCheck, RefreshCw, Scale } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, ConfirmModal } from '@/components/ui';
import CountCard from './count-card';
import { wipCheckColumns, wipEntryColumns } from './columns';
import { apiMessage, wipApi, type WipCheckRow, type WipEntryRow, type WipSession } from './wip-stocktake';

const thisMonth = () => {
  const d = new Date();
  return `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}`;
};

type TabKey = 'check' | 'entries';
type Pending = 'start' | 'regenerate' | 'adjust' | null;

export default function WipStocktakePage() {
  const [session, setSession] = useState<WipSession | null>(null);
  const [loaded, setLoaded] = useState(false);
  const [tab, setTab] = useState<TabKey>('check');
  const [checks, setChecks] = useState<WipCheckRow[]>([]);
  const [entries, setEntries] = useState<WipEntryRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [pending, setPending] = useState<Pending>(null);
  const [busy, setBusy] = useState(false);
  const startMonth = thisMonth();

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const s = await wipApi.active();
      setSession(s);
      if (s) {
        const [c, e] = await Promise.all([wipApi.list(s.yyyymm), wipApi.entries(s.yyyymm)]);
        setChecks(c);
        setEntries(e);
      } else {
        setChecks([]);
        setEntries([]);
      }
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
      setLoaded(true);
    }
  }, []);

  useEffect(() => { void load(); }, [load]);

  const run = async () => {
    if (!pending) return;
    setBusy(true);
    try {
      if (pending === 'adjust' && session) {
        const r = await wipApi.adjustAll(session.yyyymm);
        toast.success(`${r.adjusted.toLocaleString()}개 품목을 조정했습니다.`);
      } else {
        const ym = pending === 'regenerate' && session ? session.yyyymm : startMonth;
        const r = await wipApi.start(ym, pending === 'regenerate');
        toast.success(`${r.yyyymm} 공정 실사표를 만들었습니다 — ${r.items.toLocaleString()}개 품목.`);
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
  const message = pending === 'adjust' && session
    ? `${session.yyyymm} 공정 실사 결과로 공정재고를 조정합니다.`
      + `\n\n· 조정할 품목 ${session.pendingItems.toLocaleString()}개 (입력 있는 품목 ${session.countedItems.toLocaleString()}개)`
      + '\n· 입력이 없는 품목은 0 으로 보고 공정재고에서 뺍니다.'
      + `\n· 조정은 ${session.yyyymm} 마지막 날짜의 공정출고로 들어갑니다.`
    : pending === 'regenerate' && session
      ? `${session.yyyymm} 실사표의 장부 수량을 지금 공정재고로 다시 고정합니다. 넣은 입력은 그대로 반영됩니다.`
      : `${startMonth} 공정 실사를 시작합니다. 지금 공정재고를 실사표에 고정합니다.`
        + '\n\n실사가 끝날 때까지 라인 투입과 생산 실적 등록을 멈추세요.';

  return (
    <div className="flex h-full flex-col gap-3 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">공정실사</h1>
        <p className="mt-1 text-sm text-text-muted">
          라인에 있는 자재를 세어 공정재고(품목 단위)를 맞춥니다 · 차이 = 실사 − 장부
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <ClipboardCheck className="h-4 w-4" />공정 실사
          </span>
          {session ? (
            <span className="text-sm text-text">
              {session.yyyymm} · 장부 {session.bookItems.toLocaleString()}품목 · 입력 있는 품목 {session.countedItems.toLocaleString()}
              {' '}({session.entries.toLocaleString()}건) ·
              <span className={session.pendingItems ? 'text-amber-500' : 'text-emerald-500'}>
                {' '}조정할 품목 {session.pendingItems.toLocaleString()}
              </span>
            </span>
          ) : (
            <span className="text-sm text-text-muted">{loaded ? '진행 중인 공정 실사가 없습니다.' : ''}</span>
          )}
          <div className="ml-auto flex gap-2">
            {session && (
              <>
                <Button size="sm" variant="secondary" disabled={busy}
                  data-tooltip="장부 수량을 지금 공정재고로 다시 고정합니다. 조정을 넣기 전에만 됩니다."
                  onClick={() => setPending('regenerate')}>
                  <RefreshCw className="mr-1 h-4 w-4" />장부 다시 고정
                </Button>
                <Button size="sm" disabled={busy || !session.pendingItems}
                  data-tooltip="품목별 차이를 그 달 마지막 날짜의 공정출고로 넣습니다."
                  onClick={() => setPending('adjust')}>
                  <Scale className="mr-1 h-4 w-4" />일괄 조정
                </Button>
              </>
            )}
            {canStartNew && (
              <Button size="sm" variant={session ? 'secondary' : 'primary'} disabled={busy}
                data-tooltip="지금 공정재고를 실사표에 고정하고 입력을 받습니다."
                onClick={() => setPending('start')}>
                <ClipboardCheck className="mr-1 h-4 w-4" />{startMonth} 실사 시작
              </Button>
            )}
          </div>
        </CardContent>
      </Card>

      {session && <CountCard session={session} onCounted={() => { void load(); }} />}

      <ScreenTabs
        tabs={[
          { key: 'check' as TabKey, label: '실사표', count: checks.length },
          { key: 'entries' as TabKey, label: '입력 기록', count: entries.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'check' ? (
            <DataGrid
              data={checks}
              columns={wipCheckColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName={`공정실사_${session?.yyyymm ?? ''}`}
              emptyMessage="실사표가 없습니다. 실사를 시작하세요."
              rowClassName={(row) => (Number((row as WipCheckRow).differenceQty) !== 0 ? 'bg-amber-500/5' : '')}
            />
          ) : (
            <DataGrid
              data={entries}
              columns={wipEntryColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName={`공정실사_입력_${session?.yyyymm ?? ''}`}
              emptyMessage="입력이 없습니다."
            />
          )}
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={Boolean(pending)}
        onClose={() => setPending(null)}
        onConfirm={run}
        title={pending === 'adjust' ? '일괄 조정' : pending === 'regenerate' ? '장부 다시 고정' : '공정 실사 시작'}
        message={message}
        confirmText={pending === 'adjust' ? '조정' : '확인'}
      />
    </div>
  );
}
