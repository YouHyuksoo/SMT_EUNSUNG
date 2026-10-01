"use client";

/**
 * @file src/app/(authenticated)/inventory-query/inventory-close/page.tsx
 * @description 자재재고마감 — PB w_mat_inventory_close_report 이식 (조회 전용)
 *
 * 초보자 가이드:
 * 1. **한 달 동안 자재가 어떻게 드나들었는지 보는 화면이다.** 네 덩어리가 차례로
 *    나온다: (1) 전월말 재고 → (2) 입고 → (3) 출고 → (4) 당월말 재고.
 *    그래서 `(1) + (2) − (3) = (4)` 가 맞는지 눈으로 확인할 수 있다.
 * 2. **(1)과 (4)는 월마감을 돌려야 생긴다.** 이 현장은 아직 월마감을 돌린 적이 없어
 *    **앞뒤 잔액 줄이 비어 있고 (2)입고·(3)출고만 나온다.** 화면에 그렇게 적었다.
 * 3. **마감월이 필수다** — 입고 22만 / 출고 260만 행이라 월이 없으면 전 기간을 훑는다.
 * 4. 마감 요약 탭은 품목 단위 월마감이다. 이 표도 아직 비어 있고, 채워지면
 *    마감값과 현재고를 나란히 견줄 수 있다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { closeSummaryColumns, ledgerColumns } from '../inventory-query-columns';
import type { CloseSummaryRow, LedgerRow } from '../inventory-query-columns';
import PartSearchField from '@/components/shared/PartSearchField';

/** 지난달 `YYYYMM` — 마감은 보통 지난달을 본다. */
const lastMonth = () => {
  const d = new Date();
  d.setMonth(d.getMonth() - 1);
  return `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}`;
};

type TabKey = 'ledger' | 'summary';

export default function InventoryClosePage() {
  const [tab, setTab] = useState<TabKey>('ledger');
  const [yyyymm, setYyyymm] = useState(lastMonth());
  const [itemCode, setItemCode] = useState('');
  const [locationCode, setLocationCode] = useState('');
  const [itemDivision, setItemDivision] = useState('');

  const [ledger, setLedger] = useState<LedgerRow[]>([]);
  const [summary, setSummary] = useState<CloseSummaryRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    if (!/^\d{6}$/.test(yyyymm)) {
      toast.error('마감월을 YYYYMM 여섯 자리로 넣으세요.');
      return;
    }
    setLoading(true);
    try {
      if (tab === 'ledger') {
        const r = await api.get('/inventory-query/close/ledger', {
          params: {
            yyyymm,
            itemCode: itemCode || undefined,
            locationCode: locationCode || undefined,
          },
        });
        setLedger(r.data?.data ?? []);
        mark(r);
      } else {
        const r = await api.get('/inventory-query/close/summary', {
          params: {
            yyyymm,
            itemCode: itemCode || undefined,
            itemDivision: itemDivision || undefined,
          },
        });
        setSummary(r.data?.data ?? []);
        mark(r);
      }
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [tab, yyyymm, itemCode, locationCode, itemDivision, mark]);

  useEffect(() => { void search(); }, [tab]); // eslint-disable-line react-hooks/exhaustive-deps

  /** 잔액 줄(전월말·당월말)이 하나라도 있는지 — 월마감을 돌렸는지 알려 준다. */
  const hasBalance = ledger.some((r) => String(r.div ?? '').startsWith('(1)')
    || String(r.div ?? '').startsWith('(4)'));

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재재고마감</h1>
        <p className="mt-1 text-sm text-text-muted">
          한 달 동안의 수불명세를 봅니다 (전월말 → 입고 → 출고 → 당월말) ·{' '}
          {searched
            ? `${(tab === 'ledger' ? ledger : summary).length.toLocaleString()}건`
            : '조회하세요'}
        </p>
      </header>

      <ScreenTabs
        tabs={[
          { key: 'ledger' as TabKey, label: '수불명세', count: ledger.length },
          { key: 'summary' as TabKey, label: '마감 요약', count: summary.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="마감월" placeholder="마감월 (YYYYMM)" value={yyyymm}
            className="w-36" inputMode="numeric"
            onChange={(e) => setYyyymm(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-44"
            onChange={(e) => setItemCode(e.target.value)} />
          {tab === 'ledger' ? (
            <Input aria-label="창고코드" placeholder="창고코드" value={locationCode}
              className="w-32"
              onChange={(e) => setLocationCode(e.target.value)} />
          ) : (
            <Input aria-label="품목구분" placeholder="품목구분" value={itemDivision}
              className="w-36"
              onChange={(e) => setItemDivision(e.target.value)} />
          )}
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      {searched && tab === 'ledger' && ledger.length > 0 && !hasBalance && (
        <p className="text-sm text-amber-500">
          전월말·당월말 잔액 줄이 없습니다 — 이 달의 월마감을 아직 돌리지 않았습니다.
          입고·출고 내역만 보입니다.
        </p>
      )}
      {searched && tab === 'summary' && summary.length === 0 && (
        <p className="text-sm text-text-muted">
          품목 단위 마감표가 비어 있습니다 — 월마감 배치가 돌면 채워집니다.
        </p>
      )}

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'ledger' ? (
            <DataGrid
              data={ledger}
              columns={ledgerColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재수불명세"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['div'] }}
              emptyMessage={searched ? '이 달에 수불이 없습니다.' : '조회하세요.'}
            />
          ) : (
            <DataGrid
              data={summary}
              columns={closeSummaryColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재재고마감"
              emptyMessage={searched ? '마감 자료가 없습니다.' : '조회하세요.'}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
