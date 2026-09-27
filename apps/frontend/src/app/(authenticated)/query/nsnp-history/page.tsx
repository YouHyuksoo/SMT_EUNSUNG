"use client";

/**
 * @file src/app/(authenticated)/query/nsnp-history/page.tsx
 * @description NSNP 처리이력조회 — PB w_pln_product_nsnp_history_query 이식
 *
 * 초보자 가이드:
 * 1. **위쪽은 라인 상태, 아래쪽은 이력이다.** 라인마다 NSNP 가 잠겼는지, 설비를
 *    쓰는지(사용/미사용)를 보고 아래에서 발생 이력을 본다.
 * 2. **이력은 두 원장을 합친 것이다.** NSNP 감지 이력과 라인 ON/OFF 이력이다.
 *    라인이 꺼져 있던 구간을 함께 봐야 '왜 안 잡혔나' 를 판단할 수 있다.
 *    '원장' 열이 어느 쪽에서 온 기록인지 알려준다 — PB 는 구분할 방법이 없었다.
 * 3. **제어 5가지는 모두 쓰기다.** 잠금·해제·사용·미사용·이력초기화.
 *    **사용자 레벨 8 이상만** 할 수 있다 (PB 가드 유지). 라인을 세우는 일이다.
 * 4. **이력 초기화는 되돌릴 수 없다.** 라인 하나에 10만 건 가까이 쌓인다 —
 *    지울 건수를 확인 모달에 띄우고, 지운 뒤 전후 건수를 보여준다.
 * 5. **PB 는 이력을 `LIKE 라인||'%'` 로 지웠다.** 라인코드가 '1' 이면 '10'·'11'·'12'
 *    까지 함께 사라진다. 등호로 바꿨다 — 현재 데이터로는 결과가 같다 (실측).
 * 6. **PB 의 위쪽 표 '저장' 은 무동작이었다** (갱신 대상 테이블이 없다). 조회 전용이다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Lock, RefreshCw, Search, Trash2, Unlock } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { nsnpHistoryColumns, nsnpLineColumns } from '../query-columns';
import type { NsnpHistoryRow, NsnpLineRow } from '../query-types';

type NsnpAction = 'lock' | 'unlock' | 'use' | 'noUse';

const NSNP_LABEL: Record<NsnpAction, string> = {
  lock: 'NSNP 잠금',
  unlock: 'NSNP 강제해제',
  use: 'NSNP 사용',
  noUse: 'NSNP 미사용',
};

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

export default function NsnpHistoryPage() {
  const [lines, setLines] = useState<NsnpLineRow[]>([]);
  const [selected, setSelected] = useState<NsnpLineRow | null>(null);
  const [linesLoading, setLinesLoading] = useState(false);

  const [modelName, setModelName] = useState('');
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(daysAgo(0));
  const [history, setHistory] = useState<NsnpHistoryRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [busy, setBusy] = useState(false);
  const [nsnpOpen, setNsnpOpen] = useState<NsnpAction | null>(null);
  const [resetOpen, setResetOpen] = useState(false);

  const loadLines = useCallback(async () => {
    setLinesLoading(true);
    try {
      const response = await api.get('/query/nsnp-history/lines');
      setLines(response.data?.data ?? []);
    } catch {
      toast.error('라인 상태 조회에 실패했습니다.');
    } finally {
      setLinesLoading(false);
    }
  }, []);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/query/nsnp-history', {
        params: {
          lineCode: selected?.lineCode || undefined,
          modelName: modelName || undefined,
          dateFrom,
          dateTo,
        },
      });
      setHistory(response.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? 'NSNP 이력 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [selected, modelName, dateFrom, dateTo]);

  useEffect(() => { void loadLines(); }, [loadLines]);
  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const applyNsnp = useCallback(async (action: NsnpAction) => {
    setNsnpOpen(null);
    if (!selected) return;
    setBusy(true);
    try {
      const response = await api.put('/query/nsnp-history/control', {
        lineCode: selected.lineCode,
        action,
      });
      const after = response.data?.data?.after;
      toast.success(
        `${NSNP_LABEL[action]} 처리했습니다 — NSNP ${after?.nsnpStatus ?? '?'}`
        + ` · 설비 ${after?.useStatus ?? '?'}`,
      );
      void loadLines();
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? 'NSNP 처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, loadLines, search]);

  const resetLog = useCallback(async () => {
    setResetOpen(false);
    if (!selected) return;
    setBusy(true);
    try {
      const response = await api.delete('/query/nsnp-history/log', {
        data: { lineCode: selected.lineCode },
      });
      const data = response.data?.data;
      toast.success(
        `이력 ${data?.deleted ?? 0}건을 지웠습니다`
        + ` (${data?.rowsBefore ?? 0} → ${data?.rowsAfter ?? 0}).`,
      );
      void loadLines();
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '이력 초기화에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, loadLines, search]);

  const lockedCount = lines.filter(
    (r) => r.nsnpStatus && r.nsnpStatus !== 'N',
  ).length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">NSNP 처리이력조회</h1>
        <p className="mt-1 text-sm text-text-muted">
          라인별 오삽 방지 상태와 발생 이력을 봅니다 ·{' '}
          라인 {lines.length}곳
          {lockedCount > 0 && <span className="ml-1 text-red-500">· 잠김 {lockedCount}곳</span>}
          {selected ? ` · 선택 ${selected.lineName ?? selected.lineCode}` : ' · 라인을 클릭하세요'}
        </p>
      </header>

      <Card className="h-56 shrink-0 overflow-hidden" padding="none">
        <CardContent className="flex h-full flex-col gap-2 p-3">
          <b className="text-sm text-text">라인 상태</b>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={lines}
              columns={nsnpLineColumns}
              isLoading={linesLoading}
              pageSize={50}
              emptyMessage="모니터링 대상 라인이 없습니다."
              onRowClick={(row) => setSelected(row as NsnpLineRow)}
              rowClassName={(row) => {
                const r = row as NsnpLineRow;
                if (r.lineCode === selected?.lineCode) return 'bg-primary/10';
                return r.nsnpStatus && r.nsnpStatus !== 'N' ? 'bg-red-500/5' : '';
              }}
              getRowId={(row) => (row as NsnpLineRow).lineCode}
            />
          </div>
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-2 p-3">
          <b className="text-sm text-text">NSNP 제어</b>
          <Button size="sm" variant="secondary" disabled={!selected || busy}
            onClick={() => setNsnpOpen('lock')}>
            <Lock className="mr-1 h-4 w-4" />잠금
          </Button>
          <Button size="sm" variant="secondary" disabled={!selected || busy}
            onClick={() => setNsnpOpen('unlock')}>
            <Unlock className="mr-1 h-4 w-4" />해제
          </Button>
          <Button size="sm" variant="secondary" disabled={!selected || busy}
            onClick={() => setNsnpOpen('use')}>
            <RefreshCw className="mr-1 h-4 w-4" />사용
          </Button>
          <Button size="sm" variant="secondary" disabled={!selected || busy}
            onClick={() => setNsnpOpen('noUse')}>
            <RefreshCw className="mr-1 h-4 w-4" />미사용
          </Button>
          <Button size="sm" variant="secondary" disabled={!selected || busy}
            onClick={() => setResetOpen(true)}>
            <Trash2 className="mr-1 h-4 w-4 text-red-500" />
            이력 초기화{selected ? ` (${selected.historyRows.toLocaleString()}건)` : ''}
          </Button>
          <span className="text-sm text-text-muted">사용자 레벨 8 이상만 가능합니다</span>
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="모델명" placeholder="모델명" value={modelName} className="w-44"
            onChange={(e) => setModelName(e.target.value)} />
          <DateRangeFilter label="발생일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />이력 조회
          </Button>
          <span className="text-sm text-text-muted">
            {searched ? `${history.length}건` : ''}
            {selected ? ` · 라인 ${selected.lineCode}` : ' · 라인을 고르지 않으면 전체'}
          </span>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={history}
            columns={nsnpHistoryColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="NSNP이력"
            emptyMessage={searched ? '이 기간에 NSNP·라인 ON/OFF 이력이 없습니다.' : '조회하세요.'}
            rowClassName={(row) =>
              (row as NsnpHistoryRow).sourceKind === 'LINE_ONOFF' ? 'bg-surface/50' : ''}
          />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={nsnpOpen !== null}
        onClose={() => setNsnpOpen(null)}
        onConfirm={() => nsnpOpen && applyNsnp(nsnpOpen)}
        title={nsnpOpen ? NSNP_LABEL[nsnpOpen] : ''}
        message={nsnpOpen && selected
          ? `라인 ${selected.lineName ?? selected.lineCode} 에 `
            + `${NSNP_LABEL[nsnpOpen]} 을 적용합니다. `
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

      <ConfirmModal
        isOpen={resetOpen}
        onClose={() => setResetOpen(false)}
        onConfirm={resetLog}
        title="NSNP 이력 초기화"
        message={selected
          ? `라인 ${selected.lineName ?? selected.lineCode} 의 NSNP 이력 `
            + `${selected.historyRows.toLocaleString()}건을 전부 지웁니다. 되돌릴 수 없습니다.`
          : ''}
        variant="danger"
      />
    </div>
  );
}
