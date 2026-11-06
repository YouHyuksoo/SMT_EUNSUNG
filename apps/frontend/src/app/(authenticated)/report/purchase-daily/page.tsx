"use client";

/**
 * @file src/app/(authenticated)/report/purchase-daily/page.tsx
 * @description 구매팀 일보 — 공급사별 원자재 수불 요약과 품목별 상세
 *
 * 초보자 가이드:
 * 1. **원자재 장부 수불**이다. 창고·외주·재공·제품 속 원자재를 모두 센다 (구매팀 엑셀과 같은 정의).
 * 2. **거래처별 요약**은 금액을 백만 원 단위로 보여준다 (기초·입고누계·출고누계·현재고).
 *    줄을 누르면 품목별 상세가 그 거래처로 걸러진다.
 * 3. 출고누계는 제품출고 수량을 BOM 으로 풀어 원자재로 바꾼 값이다. 정의는 백엔드
 *    purchase-daily.service.ts 머리말에 있다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, Select } from '@/components/ui';
import api from '@/services/api';
import { getTodayLocal } from '@/utils/date';
import { TruncationNotice, useTruncation } from '../components/TruncationNotice';
import {
  purchaseDailyDetailColumns,
  purchaseDailySummaryColumns,
  type PurchaseDailyDetailRow,
  type PurchaseDailySummaryRow,
} from './columns';

type Tab = 'summary' | 'detail';

/** 이번 달 1일. */
const monthStart = () => {
  const d = new Date();
  d.setDate(1);
  return getTodayLocal(d);
};

export default function PurchaseDailyPage() {
  const [dateFrom, setDateFrom] = useState(monthStart());
  const [dateTo, setDateTo] = useState(getTodayLocal());
  const [bookGroup, setBookGroup] = useState('');
  const [tab, setTab] = useState<Tab>('summary');
  const [summary, setSummary] = useState<PurchaseDailySummaryRow[]>([]);
  const [detail, setDetail] = useState<PurchaseDailyDetailRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const [s, d] = await Promise.all([
        api.get('/report/purchase-daily/summary', { params: { dateFrom, dateTo } }),
        api.get('/report/purchase-daily/detail', { params: { dateFrom, dateTo } }),
      ]);
      setSummary(s.data?.data ?? []);
      setDetail(d.data?.data ?? []);
      mark(d);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '구매팀 일보 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, mark]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const endTotal = summary.reduce((s, r) => s + Number(r.endAmt ?? 0), 0);
  const detailRows = bookGroup ? detail.filter((r) => r.bookGroup === bookGroup) : detail;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">구매팀 일보</h1>
        <p className="mt-1 text-sm text-text-muted">
          원자재 장부 수불(창고·외주·재공·제품 포함) · 출고는 제품출고를 BOM 으로 푼 값 ·{' '}
          {searched
            ? `거래처 ${summary.length.toLocaleString()}곳 · 현재고 ${(endTotal / 1_000_000).toLocaleString(undefined, { maximumFractionDigits: 1 })}백만`
            : '조회하세요'}
        </p>
      </header>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} what="상세 합계" />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="기간" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Select
            options={[{ value: '', label: '거래처: 전체' }, ...summary.map((r) => ({ value: r.bookGroup, label: r.bookGroup }))]}
            value={bookGroup} onChange={setBookGroup} className="w-52" />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <ScreenTabs
        tabs={[
          { key: 'summary', label: '거래처별 요약', count: summary.length },
          { key: 'detail', label: bookGroup ? `품목별 상세 (${bookGroup})` : '품목별 상세', count: detailRows.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'summary' && (
            <DataGrid
              data={summary}
              columns={purchaseDailySummaryColumns}
              isLoading={loading}
              onRowClick={(row: PurchaseDailySummaryRow) => { setBookGroup(row.bookGroup); setTab('detail'); }}
              pageSize={100}
              enableExport
              exportFileName="구매팀일보_거래처별요약"
              emptyMessage={searched ? '기간에 수불이 없습니다.' : '조회하세요.'}
            />
          )}
          {tab === 'detail' && (
            <DataGrid
              data={detailRows}
              columns={purchaseDailyDetailColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="구매팀일보_품목별상세"
              emptyMessage={searched ? '기간에 수불이 없습니다.' : '조회하세요.'}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
