"use client";

/**
 * @file src/app/(authenticated)/process-transaction/wip-ledger/page.tsx
 * @description 공정입출고내역 — 공정(라인)재고가 언제 무엇으로 늘고 줄었는지 본다 (조회)
 *
 * 초보자 가이드:
 * 1. **공정재고는 자재를 라인으로 출고하면 늘고(입고), 생산 실적으로 자재가 소모되면 준다(생산투입).**
 *    공정재고실사 일괄 조정도 공정재고를 줄이거나 늘린다(실사조정).
 * 2. **품목별 합계** 탭에서 기간 안의 입고·생산투입·실사조정과 순증감, 지금 공정재고를 본다.
 *    줄을 누르면 그 품목의 건별 내역으로 넘어간다.
 * 3. **건별 내역**은 한 줄이 한 건이다. 생산투입은 어느 제품을 만들며 썼는지(투입 제품)를 보여 준다.
 *    출고 건수가 많아서 품목을 안 고르면 7일까지만 조회된다.
 * 4. API 는 /process-transaction/wip-ledger (건별) · /summary (품목별).
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import PartSearchField from '@/components/shared/PartSearchField';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, Select } from '@/components/ui';
import api from '@/services/api';
import { getRecentDaysRange } from '@/utils/date';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import {
  detailColumns,
  summaryColumns,
  type WipLedgerDetailRow,
  type WipLedgerKind,
  type WipLedgerSummaryRow,
} from './columns';

type TabKey = 'summary' | 'detail';

export default function WipLedgerPage() {
  const initial = useMemo(() => getRecentDaysRange(1), []);
  const [tab, setTab] = useState<TabKey>('summary');
  const [dateFrom, setDateFrom] = useState(initial.from);
  const [dateTo, setDateTo] = useState(initial.to);
  const [itemCode, setItemCode] = useState('');
  const [kind, setKind] = useState<'' | WipLedgerKind>('');
  const [summary, setSummary] = useState<WipLedgerSummaryRow[]>([]);
  const [detail, setDetail] = useState<WipLedgerDetailRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const params = {
        dateFrom, dateTo,
        itemCode: itemCode.trim() || undefined,
        kind: kind || undefined,
      };
      if (tab === 'summary') {
        const r = await api.get('/process-transaction/wip-ledger/summary', { params });
        setSummary(r.data?.data ?? []);
        mark(r);
      } else {
        const r = await api.get('/process-transaction/wip-ledger', { params });
        setDetail(r.data?.data ?? []);
        mark(r);
      }
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [tab, itemCode, dateFrom, dateTo, kind, mark]);

  useEffect(() => { void search(); }, [tab]); // eslint-disable-line react-hooks/exhaustive-deps

  /** 품목별 합계에서 줄을 누르면 그 품목의 건별 내역을 연다 (탭이 바뀌면 위 effect 가 조회한다). */
  const openItem = (row: WipLedgerSummaryRow) => {
    setItemCode(row.itemCode);
    setTab('detail');
  };

  const rows = tab === 'summary' ? summary : detail;

  return (
    <div className="flex h-full flex-col gap-3 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">공정입출고내역</h1>
        <p className="mt-1 text-sm text-text-muted">
          라인으로 출고된 자재(입고)와 생산에 쓰인 자재(생산투입), 실사조정으로 공정재고가 늘고 준 내역 ·{' '}
          {searched ? `${rows.length.toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="기간" from={dateFrom} to={dateTo} onFromChange={setDateFrom} onToChange={setDateTo} />
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode} className="w-44"
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Select aria-label="구분" placeholder="전체" value={kind}
            onChange={(v) => setKind(v as '' | WipLedgerKind)}
            options={[
              { value: '', label: '전체' },
              { value: 'R', label: '입고' },
              { value: 'I', label: '생산투입' },
              { value: 'A', label: '실사조정' },
            ]} />
          <Button size="sm" onClick={() => void search()} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          {tab === 'detail' && !itemCode.trim() && (
            <span className="text-sm text-text-muted">품목을 고르지 않으면 7일까지 조회됩니다.</span>
          )}
        </CardContent>
      </Card>

      <ScreenTabs
        tabs={[
          { key: 'summary' as TabKey, label: '품목별 합계', count: summary.length },
          { key: 'detail' as TabKey, label: '건별 내역', count: detail.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      {tab === 'detail' && <TruncationNotice truncated={truncated} rowLimit={rowLimit} />}

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'summary' ? (
            <DataGrid
              data={summary}
              columns={summaryColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName={`공정입출고_품목별_${dateFrom}_${dateTo}`}
              emptyMessage={searched ? '이 기간에 공정 입출고가 없습니다.' : '조회하세요.'}
              onRowClick={(row) => openItem(row as WipLedgerSummaryRow)}
            />
          ) : (
            <DataGrid
              data={detail}
              columns={detailColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName={`공정입출고_건별_${dateFrom}_${dateTo}`}
              emptyMessage={searched ? '이 기간에 공정 입출고가 없습니다.' : '조회하세요.'}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
