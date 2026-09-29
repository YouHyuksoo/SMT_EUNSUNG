"use client";

/**
 * @file src/app/(authenticated)/query/feeder-monitor/page.tsx
 * @description SMT 피더별 모니터링 — PB w_smt_plan_feeder_monitoring_master 이식
 *
 * 초보자 가이드:
 * 1. **라인 하나의 피더 자리를 전부 펼쳐 놓고 잔량을 본다.** 잔량이 0 이하인 자리가
 *    빨갛게 보인다 — 곧 떨어질 자리를 미리 찾는 게 이 화면의 목적이다.
 * 2. **자동갱신이 있다** (PB Interval / Auto Retrieve / Stop). 기본 60초.
 * 3. **'피더 잔량 세팅' 은 쓰기다** (PB 'Set Feeding Qty'). 마지막 CCS 투입 이후
 *    스캔된 수량을 합쳐 계획의 잔량에 적는다. PB 는 행마다 조회·수정을 돌렸고
 *    여기서는 한 문장으로 한다 — 결과는 같고 왕복이 300배 줄어든다.
 * 4. **NSNP 제어는 321·335 와 같은 서비스다.** 잠금·해제·사용·미사용 네 동작이고
 *    사용자 레벨 8 이상만 할 수 있다 (PB 가드 유지). 라인을 세우는 일이다.
 * 5. **자리를 고르면 아래에 그 자리의 투입 이력이 나온다** (PB 'Show Change History').
 *    마지막 CCS 이후만 본다 — 그 전은 이전 롯트 얘기다.
 */
import { useCallback, useEffect, useRef, useState } from 'react';
import toast from 'react-hot-toast';
import { Gauge, Lock, RefreshCw, Search, Unlock } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { AutoRefreshControl } from '../components/QueryTabs';
import { feederSlotColumns, slotHistoryColumns } from '../query-columns';
import type { FeederSlotRow, SlotHistoryRow } from '../query-types';

type NsnpAction = 'lock' | 'unlock' | 'use' | 'noUse';

const NSNP_LABEL: Record<NsnpAction, string> = {
  lock: 'NSNP 잠금',
  unlock: 'NSNP 강제해제',
  use: 'NSNP 사용',
  noUse: 'NSNP 미사용',
};

export default function FeederMonitorPage() {
  const [lineCode, setLineCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [itemCode, setItemCode] = useState('');

  const [slots, setSlots] = useState<FeederSlotRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [selected, setSelected] = useState<FeederSlotRow | null>(null);
  const [history, setHistory] = useState<SlotHistoryRow[]>([]);
  const [histLoading, setHistLoading] = useState(false);

  const [intervalSec, setIntervalSec] = useState('60');
  const [autoOn, setAutoOn] = useState(false);
  const [busy, setBusy] = useState(false);
  const [feedingOpen, setFeedingOpen] = useState(false);
  const [nsnpOpen, setNsnpOpen] = useState<NsnpAction | null>(null);

  const search = useCallback(async () => {
    if (!lineCode) return;
    setLoading(true);
    try {
      const response = await api.get('/query/feeder-monitor', {
        params: {
          lineCode,
          modelName: modelName || undefined,
          itemCode: itemCode || undefined,
        },
      });
      setSlots(response.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '피더 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [lineCode, modelName, itemCode]);

  // 자동갱신. 목록만 다시 읽는다 — 이력까지 매번 다시 읽으면 고른 자리가 흔들린다.
  const autoRef = useRef(search);
  autoRef.current = search;
  useEffect(() => {
    if (!autoOn || !lineCode) return;
    const sec = Math.max(5, Number(intervalSec) || 60);
    const id = setInterval(() => { void autoRef.current(); }, sec * 1000);
    return () => clearInterval(id);
  }, [autoOn, intervalSec, lineCode]);

  const pick = useCallback(async (row: FeederSlotRow) => {
    setSelected(row);
    setHistLoading(true);
    try {
      const response = await api.get('/query/feeder-monitor/slot-history', {
        params: {
          lineCode: row.lineCode,
          lotName: row.modelName,
          locationCode: row.locationCode,
          itemCode: row.itemCode,
        },
      });
      setHistory(response.data?.data ?? []);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '투입 이력 조회에 실패했습니다.');
      setHistory([]);
    } finally {
      setHistLoading(false);
    }
  }, []);

  const setFeedingQty = useCallback(async () => {
    setFeedingOpen(false);
    setBusy(true);
    try {
      const response = await api.put('/query/feeder-monitor/feeding-qty', {
        lineCode,
        modelName: modelName || undefined,
        itemCode: itemCode || undefined,
      });
      toast.success(`${response.data?.data?.changed ?? 0}개 자리의 잔량을 다시 세팅했습니다.`);
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '잔량 세팅에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [lineCode, modelName, itemCode, search]);

  const applyNsnp = useCallback(async (action: NsnpAction) => {
    setNsnpOpen(null);
    setBusy(true);
    try {
      const response = await api.put('/query/feeder-monitor/nsnp', { lineCode, action });
      const after = response.data?.data?.after;
      toast.success(
        `${NSNP_LABEL[action]} 처리했습니다 — NSNP ${after?.nsnpStatus ?? '?'}`
        + ` · 설비 ${after?.useStatus ?? '?'}`,
      );
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? 'NSNP 처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [lineCode]);

  const slotKey = (r: FeederSlotRow) =>
    [r.lineCode, r.machine, r.tableId, r.locationCode, r.itemCode].join('|');
  const emptyCount = slots.filter((r) => Number(r.feedingQty ?? 0) <= 0).length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header className="flex items-start justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-text">SMT 피더별 모니터링</h1>
          <p className="mt-1 text-sm text-text-muted">
            라인의 피더 자리별 자재와 잔량을 봅니다 ·{' '}
            {searched ? `${slots.length}자리` : '라인을 고르세요'}
            {emptyCount > 0 && (
              <span className="ml-1 text-red-500">· 잔량 없는 자리 {emptyCount}곳</span>
            )}
            {autoOn && <span className="ml-1 text-primary">· 자동갱신 {intervalSec}초</span>}
          </p>
        </div>
        <AutoRefreshControl
          intervalSec={intervalSec}
          onIntervalChange={setIntervalSec}
          running={autoOn}
          onToggle={() => setAutoOn((v) => !v)}
          disabled={!lineCode}
        />
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <div className="w-44">
            <LineSelect value={lineCode} onChange={setLineCode} labelPrefix="라인" />
          </div>
          <Input aria-label="모델명" placeholder="모델명" value={modelName} className="w-40"
            onChange={(e) => setModelName(e.target.value)} />
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCode} className="w-36"
            onChange={(e) => setItemCode(e.target.value)} />
          <Button size="sm" onClick={search} disabled={!lineCode || loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <Button size="sm" variant="secondary" disabled={!lineCode || busy}
            onClick={() => setFeedingOpen(true)}>
            <Gauge className="mr-1 h-4 w-4" />피더 잔량 세팅
          </Button>
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-2 p-3">
          <b className="text-sm text-text">NSNP 제어</b>
          <Button size="sm" variant="secondary" disabled={!lineCode || busy}
            onClick={() => setNsnpOpen('lock')}>
            <Lock className="mr-1 h-4 w-4" />잠금
          </Button>
          <Button size="sm" variant="secondary" disabled={!lineCode || busy}
            onClick={() => setNsnpOpen('unlock')}>
            <Unlock className="mr-1 h-4 w-4" />해제
          </Button>
          <Button size="sm" variant="secondary" disabled={!lineCode || busy}
            onClick={() => setNsnpOpen('use')}>
            <RefreshCw className="mr-1 h-4 w-4" />사용
          </Button>
          <Button size="sm" variant="secondary" disabled={!lineCode || busy}
            onClick={() => setNsnpOpen('noUse')}>
            <RefreshCw className="mr-1 h-4 w-4" />미사용
          </Button>
          <span className="text-sm text-text-muted">사용자 레벨 8 이상만 가능합니다</span>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="flex h-full flex-col gap-2 p-3">
          <b className="text-sm text-text">
            피더 자리{' '}
            <span className="font-normal text-text-muted">
              — 행을 클릭하면 아래에 그 자리의 투입 이력이 나옵니다
            </span>
          </b>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={slots}
              columns={feederSlotColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="피더모니터링"
              emptyMessage={searched ? '이 라인에 활성 피더 계획이 없습니다.' : '라인을 고르세요.'}
              onRowClick={(row) => void pick(row as FeederSlotRow)}
              rowClassName={(row) => {
                const r = row as FeederSlotRow;
                if (selected && slotKey(r) === slotKey(selected)) return 'bg-primary/10';
                return Number(r.feedingQty ?? 0) <= 0 ? 'bg-red-500/5' : '';
              }}
              getRowId={(row) => slotKey(row as FeederSlotRow)}
            />
          </div>
        </CardContent>
      </Card>

      <Card className="h-56 shrink-0 overflow-hidden" padding="none">
        <CardContent className="flex h-full flex-col gap-2 p-3">
          <div className="flex flex-wrap items-baseline gap-3">
            <b className="text-sm text-text">투입 이력 (마지막 CCS 이후)</b>
            {selected && (
              <span className="text-sm text-text-muted">
                {selected.machine} · {selected.tableId} · {selected.locationCode} ·{' '}
                {selected.itemCode}
              </span>
            )}
          </div>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={history}
              columns={slotHistoryColumns}
              isLoading={histLoading}
              pageSize={50}
              emptyMessage={selected
                ? '이 자리에 마지막 CCS 이후 투입 기록이 없습니다.'
                : '위에서 피더 자리를 고르세요.'}
            />
          </div>
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={feedingOpen}
        onClose={() => setFeedingOpen(false)}
        onConfirm={setFeedingQty}
        title="피더 잔량 세팅"
        message={`라인 ${lineCode} 의 피더 잔량을 마지막 CCS 투입 이후 스캔수량으로`
          + ' 다시 계산해 덮어씁니다. 지금 화면의 조건에 해당하는 자리 전부가 대상입니다.'}
      />

      <ConfirmModal
        isOpen={nsnpOpen !== null}
        onClose={() => setNsnpOpen(null)}
        onConfirm={() => nsnpOpen && applyNsnp(nsnpOpen)}
        title={nsnpOpen ? NSNP_LABEL[nsnpOpen] : ''}
        message={nsnpOpen
          ? `라인 ${lineCode} 에 ${NSNP_LABEL[nsnpOpen]} 을 적용합니다. `
            + (nsnpOpen === 'lock'
              ? '잠그면 이 라인의 생산이 멈춥니다.'
              : nsnpOpen === 'unlock'
                ? '해제하면 오삽 방지 잠금이 풀립니다. 원인을 확인한 뒤 누르세요.'
                : nsnpOpen === 'noUse'
                  ? '미사용으로 바꾸면 잠금이 풀리고 오삽 감지가 멈춥니다.'
                  : '사용으로 바꾸면 오삽 감지가 다시 동작합니다.')
          : ''}
        variant={nsnpOpen === 'unlock' || nsnpOpen === 'noUse' ? 'danger' : undefined}
      />
    </div>
  );
}
