"use client";

/**
 * @file src/app/(authenticated)/report/pickup-rate/page.tsx
 * @description SMT PICKUP 리포트 — PB w_smt_pickup_rate_rpt 이식
 *
 * 초보자 가이드:
 * 1. **마운터가 부품을 집다가 흘린 양과 그 금액을 본다.** 미스율이 아니라 **금액**이
 *    이 리포트의 목적이다 — 비싼 부품 한 개가 싼 부품 천 개보다 아프다.
 * 2. **미스 금액 = (미스 + 인식오류) × 구매단가.** PB 와 같은 식이다.
 * 3. **단가 하한을 걸 수 있다.** PB 가 비싼 자재만 보려고 둔 조건을 그대로 옮겼다.
 * 4. **기간이 필수다.** 구동 표(IQ_MACHINE_INSPECT_PICKUP_QRY, 97만행)의 인덱스가
 *    ACTUAL_DATE 뿐이라 기간 없이는 전체를 훑는다.
 * 5. **라인 집어올림·픽업률은 [라인 시간대] 탭에서 본다.** PB SMT Pickup Inquiry(HEAD) 와 같은 집계로
 *    주간 A~E·야간 F~J 시간대와 릴교체를 함께 낸다. 금액 집계 표의 집어올림은 피더 줄마다 설비 값이
 *    되풀이돼 있어 더하지 않는다. 라인 시간대는 하루씩 집계해 7일까지 조회한다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { TruncationNotice, useTruncation } from '../components/TruncationNotice';
import { pickupAmountColumns, pickupDetailColumns, pickupHeadColumns } from '../report-columns';
import type { PickupAmountRow, PickupDetailRow, PickupHeadRow } from '../report-types';
import PartSearchField from '@/components/shared/PartSearchField';

import { getTodayLocal } from '@/utils/date';
const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return getTodayLocal(d);
};

type Tab = 'head' | 'amount' | 'detail';
/** 라인 시간대 집계 최대 일수 (백엔드 PICKUP_HEAD_MAX_DAYS 와 같다) */
const HEAD_MAX_DAYS = 7;

export default function PickupRateReportPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(0));
  const [dateTo, setDateTo] = useState(daysAgo(0));
  const [lineCode, setLineCode] = useState('');
  const [itemCode, setItemCode] = useState('');
  const [minUnitPrice, setMinUnitPrice] = useState('0');

  const [tab, setTab] = useState<Tab>('head');
  const [head, setHead] = useState<PickupHeadRow[]>([]);
  const [amount, setAmount] = useState<PickupAmountRow[]>([]);
  const [detail, setDetail] = useState<PickupDetailRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const params = {
        dateFrom,
        dateTo,
        lineCode: lineCode || undefined,
        itemCode: itemCode || undefined,
        minUnitPrice: Number(minUnitPrice) > 0 ? Number(minUnitPrice) : undefined,
      };
      // 라인 시간대는 하루씩 집계해 7일까지만 받는다 — 넘으면 그 탭만 비운다.
      const days = (Date.parse(dateTo) - Date.parse(dateFrom)) / 86400000 + 1;
      const headAllowed = days <= HEAD_MAX_DAYS;
      const [h, a, d] = await Promise.all([
        headAllowed ? api.get('/report/pickup-rate/head', { params }) : Promise.resolve({ data: { data: [] } }),
        api.get('/report/pickup-rate/amount', { params }),
        api.get('/report/pickup-rate/detail', { params }),
      ]);
      setHead(h.data?.data ?? []);
      if (!headAllowed) toast(`라인 시간대 집계는 ${HEAD_MAX_DAYS}일까지 봅니다. 기간을 줄이면 나옵니다.`);
      setAmount(a.data?.data ?? []);
      setDetail(d.data?.data ?? []);
      mark(h, a, d);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? 'PICKUP 리포트 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, lineCode, itemCode, minUnitPrice]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const totalMiss = amount.reduce((sum, r) => sum + Number(r.missAmount ?? 0), 0);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">SMT PICKUP 리포트</h1>
        <p className="mt-1 text-sm text-text-muted">
          마운터 집어올림 미스와 그 금액을 봅니다 ·{' '}
          {searched
            ? `미스 금액 합계 ${Math.round(totalMiss).toLocaleString()}`
            : '조회하세요'}
        </p>
      </header>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} what="미스 금액 합계" />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="실적일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <div className="w-44">
            <LineSelect value={lineCode} onChange={setLineCode} labelPrefix="라인" />
          </div>
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode} className="w-40"
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          {/* PB 의 단가 하한. 비싼 자재의 미스만 보려고 둔 조건이다. */}
          <Input aria-label="단가 이상" placeholder="단가 이상" value={minUnitPrice}
            className="w-32"
            onChange={(e) => setMinUnitPrice(e.target.value.replace(/[^\d.]/g, ''))} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <ScreenTabs
        tabs={[
          { key: 'head', label: '라인 시간대', count: head.length },
          { key: 'amount', label: '금액 집계', count: amount.length },
          { key: 'detail', label: '상세', count: detail.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'head' ? (
            <DataGrid
              data={head}
              columns={pickupHeadColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="PICKUP라인시간대"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['actualDate', 'lineName'] }}
              emptyMessage={searched ? '기간에 HEAD 픽업 실적이 없습니다.' : '조회하세요.'}
            />
          ) : tab === 'amount' ? (
            <DataGrid
              data={amount}
              columns={pickupAmountColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="PICKUP금액집계"
              emptyMessage={searched ? '기간에 픽업 실적이 없습니다.' : '조회하세요.'}
            />
          ) : (
            <DataGrid
              data={detail}
              columns={pickupDetailColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="PICKUP상세"
              emptyMessage={searched ? '기간에 픽업 실적이 없습니다.' : '조회하세요.'}
              rowClassName={(row) => (Number((row as PickupDetailRow).missAmount ?? 0) > 0
                ? 'bg-red-500/5'
                : '')}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
