"use client";

/**
 * @file src/app/(authenticated)/product/fg-receipt/page.tsx
 * @description 302 제품입고관리(PID) — PB w_prd_product_fg_receipt 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **포장이 끝난 박스를 제품창고에 넣는 화면이다.** 박스 바코드를 찍으면 한 건씩 입고된다.
 * 2. **계산은 DB 프로시저가 한다** (`P_PRODUCT_FG_RECEIPT`). PB 도 같은 프로시저를 불렀으므로
 *    PB 로 넣든 웹으로 넣든 결과가 같다.
 * 3. **취소는 같은 프로시저의 다른 코드다.** 정상/취소 버튼으로 고른다.
 * 4. **조회 탭이 네 개다** — 입고 이력(박스 한 건씩) · 품목별 · 일자별 합계 · 일자 × 모델
 *    크로스탭(출하조회와 같은 구성). 취소(2)는 −로 계산해 탭 간 수량이 맞는다.
 * 5. **기본 기간이 7일이다.** 이 표는 기간 컬럼에 인덱스가 없어 한 달을 보면
 *    9,000행에 8.7초가 걸린다 (7일이면 2.4초).
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import type { ColumnDef } from '@tanstack/react-table';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, Input } from '@/components/ui';
import ModelSearchField from '@/components/shared/ModelSearchField';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { useCrosstab, type CrosstabSpec } from '../../report/components/crosstab';
import FgScanPanel from '../components/FgScanPanel';
import {
  fgReceiptColumns,
  fgReceiptDateSummaryColumns,
  fgReceiptItemSummaryColumns,
} from '../shipping-columns';
import type {
  FgReceiptCrosstabRow,
  FgReceiptRow,
  FgReceiptSummaryRow,
} from '../shipping-columns';

import { getTodayLocal } from '@/utils/date';
type SummaryKey = 'item' | 'date';
type TabKey = 'history' | SummaryKey | 'crosstab';

const isSummaryTab = (tab: TabKey): tab is SummaryKey => tab === 'item' || tab === 'date';

/** 합계 탭 정의 — 백엔드 `groupBy` 값과 키를 맞춘다. */
const SUMMARY_TABS: Record<
  SummaryKey,
  { label: string; columns: ColumnDef<FgReceiptSummaryRow>[]; exportName: string }
> = {
  item: { label: '품목별', columns: fgReceiptItemSummaryColumns, exportName: '제품입고_품목별' },
  date: { label: '일자별', columns: fgReceiptDateSummaryColumns, exportName: '제품입고_일자별' },
};

const today = () => getTodayLocal();

const sumOf = <T,>(list: T[], pick: (row: T) => unknown) =>
  list.reduce((sum, row) => sum + Number(pick(row) ?? 0), 0);

export default function FgReceiptPage() {
  const [dateFrom, setDateFrom] = useState(today());
  const [dateTo, setDateTo] = useState(today());
  const [barcode, setBarcode] = useState('');
  const [modelName, setModelName] = useState('');
  const [tab, setTab] = useState<TabKey>('history');
  const [rows, setRows] = useState<FgReceiptRow[]>([]);
  const [summary, setSummary] = useState<Record<SummaryKey, FgReceiptSummaryRow[]>>({
    item: [],
    date: [],
  });
  const [crosstab, setCrosstab] = useState<FgReceiptCrosstabRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const params = {
        dateFrom,
        dateTo,
        barcode: barcode || undefined,
        modelName: modelName || undefined,
      };
      if (tab === 'history') {
        const r = await api.get('/product/fg/receipts', { params });
        setRows(r.data?.data ?? []);
        mark(r);
      } else if (tab === 'crosstab') {
        const r = await api.get('/product/fg/receipts/crosstab', { params });
        setCrosstab(r.data?.data ?? []);
        mark(r);
      } else {
        const r = await api.get('/product/fg/receipts/summary', {
          params: { ...params, groupBy: tab },
        });
        const data: FgReceiptSummaryRow[] = r.data?.data ?? [];
        setSummary((prev) => ({ ...prev, [tab]: data }));
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
  }, [tab, dateFrom, dateTo, barcode, modelName, mark]);

  useEffect(() => { void search(); }, [tab]); // eslint-disable-line react-hooks/exhaustive-deps

  const crosstabSpec = useMemo<CrosstabSpec<FgReceiptCrosstabRow>>(() => ({
    rowKey: (r) => [r.modelName, r.modelSuffix, r.locationCode].join('|'),
    rowLabels: [
      { id: 'modelName', header: '모델', value: (r) => r.modelName ?? '', width: 220 },
      { id: 'modelSuffix', header: '모델 SFX', value: (r) => r.modelSuffix ?? '', width: 90 },
      { id: 'locationCode', header: '창고', value: (r) => r.locationCode ?? '', width: 90 },
    ],
    colKey: (r) => r.receiptDate,
    colHeader: (k) => k.slice(5),
    value: (r) => Number(r.qty ?? 0),
  }), []);
  const crosstabGrid = useCrosstab(crosstab, crosstabSpec);

  const headline = (() => {
    if (!searched) return '조회하세요';
    if (tab === 'history') {
      return `${rows.length.toLocaleString()}건 · 순수량 ${sumOf(rows, (r) => r.qty).toLocaleString()}`;
    }
    if (tab === 'crosstab') {
      return `순입고 ${sumOf(crosstab, (r) => r.qty).toLocaleString()}`;
    }
    const list = summary[tab];
    return `${list.length.toLocaleString()}행 · 입고 ${sumOf(list, (r) => r.receiptQty).toLocaleString()}`
      + ` · 취소 ${sumOf(list, (r) => r.cancelQty).toLocaleString()}`
      + ` · 순입고 ${sumOf(list, (r) => r.qty).toLocaleString()}`;
  })();

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">제품입고관리(PID)</h1>
        <p className="mt-1 text-sm text-text-muted">
          포장된 박스를 제품창고에 넣습니다 · {headline}
        </p>
      </header>

      <FgScanPanel endpoint="/product/fg/receipt" title="박스 입고"
        withQty={false} storageKey="mes-fg-receipt-location" onDone={search} />

      <ScreenTabs
        tabs={[
          { key: 'history' as TabKey, label: '입고 이력', count: rows.length },
          ...(Object.keys(SUMMARY_TABS) as SummaryKey[]).map((key) => ({
            key: key as TabKey,
            label: SUMMARY_TABS[key].label,
            count: summary[key].length,
          })),
          { key: 'crosstab' as TabKey, label: '일자 × 모델', count: crosstab.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="입고일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input aria-label="바코드 조건" placeholder="바코드" value={barcode}
            className="w-52"
            onChange={(e) => setBarcode(e.target.value)} />
          <ModelSearchField aria-label="모델 조건" placeholder="모델" value={modelName}
            className="w-36"
            onChange={(v) => setModelName(v)} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <span className="text-sm text-text-muted">
            취소분은 수량이 음수로 나옵니다.
          </span>
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'history' ? (
            <DataGrid
              data={rows}
              columns={fgReceiptColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="제품입고"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['barcode'] }}
              emptyMessage={searched ? '이 기간에 입고 내역이 없습니다.' : '조회하세요.'}
            />
          ) : tab === 'crosstab' ? (
            <DataGrid
              key={crosstabGrid.gridKey}
              data={crosstabGrid.data}
              columns={crosstabGrid.columns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="제품입고_일자별모델"
              enableColumnPinning
              defaultPinnedColumns={crosstabGrid.pinned}
              emptyMessage={searched ? '이 기간에 입고가 없습니다.' : '조회하세요.'}
            />
          ) : isSummaryTab(tab) && (
            <DataGrid
              key={tab}
              data={summary[tab]}
              columns={SUMMARY_TABS[tab].columns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName={SUMMARY_TABS[tab].exportName}
              emptyMessage={searched ? '이 기간에 입고가 없습니다.' : '조회하세요.'}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
