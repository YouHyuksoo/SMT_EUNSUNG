"use client";

/**
 * @file src/app/(authenticated)/product/fg-issue-query/page.tsx
 * @description 제품출하조회 — 제품출하 이력과 거래처별 · 품목별 · 일자별 합계 (읽기 전용)
 *
 * 초보자 가이드:
 * 1. **출하 입력은 제품출하관리(`/product/fg-issue`) 화면에서 한다.** 이 화면은 조회만 한다.
 * 2. **탭이 네 개다** — 출하 이력(박스 한 건씩) · 거래처별 · 품목별 · 일자별 합계.
 *    합계는 서버에서 묶어 오므로 이력이 행 제한에 걸려도 합계는 정확하다.
 * 3. **수량 부호**: 출하(3)는 +, 출하취소(4)는 −. 순출하수량 = 출하수량 − 취소수량.
 * 4. **일자는 출하일시(`ISSUE_DATE`)의 날짜다.** 조회 기간도 같은 컬럼으로 거른다.
 * 5. **기본 기간이 7일이다.** 출하 이력은 기간 컬럼에 인덱스가 없어 한 달이면 수 초가 걸린다.
 *    합계 탭은 한 달도 빠르다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import type { ColumnDef } from '@tanstack/react-table';
import DataGrid from '@/components/data-grid/DataGrid';
import CustomerSelect from '@/components/shared/CustomerSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ModelSearchField from '@/components/shared/ModelSearchField';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import {
  fgIssueColumns,
  fgIssueCustomerSummaryColumns,
  fgIssueDateSummaryColumns,
  fgIssueItemSummaryColumns,
} from '../shipping-columns';
import type { FgIssueRow, FgIssueSummaryRow } from '../shipping-columns';

type SummaryKey = 'customer' | 'item' | 'date';
type TabKey = 'history' | SummaryKey;

/** 합계 탭 정의 — 백엔드 `groupBy` 값과 키를 맞춘다. */
const SUMMARY_TABS: Record<
  SummaryKey,
  { label: string; columns: ColumnDef<FgIssueSummaryRow>[]; exportName: string }
> = {
  customer: { label: '거래처별', columns: fgIssueCustomerSummaryColumns, exportName: '제품출하_거래처별' },
  item: { label: '품목별', columns: fgIssueItemSummaryColumns, exportName: '제품출하_품목별' },
  date: { label: '일자별', columns: fgIssueDateSummaryColumns, exportName: '제품출하_일자별' },
};

const today = () => new Date().toISOString().slice(0, 10);
const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

const sumOf = <T,>(list: T[], pick: (row: T) => unknown) =>
  list.reduce((sum, row) => sum + Number(pick(row) ?? 0), 0);

export default function FgIssueQueryPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(today());
  const [customerCode, setCustomerCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [barcode, setBarcode] = useState('');
  const [tab, setTab] = useState<TabKey>('history');
  const [rows, setRows] = useState<FgIssueRow[]>([]);
  const [summary, setSummary] = useState<Record<SummaryKey, FgIssueSummaryRow[]>>({
    customer: [],
    item: [],
    date: [],
  });
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const params = {
        dateFrom,
        dateTo,
        customerCode: customerCode || undefined,
        modelName: modelName || undefined,
        barcode: barcode || undefined,
      };
      if (tab === 'history') {
        const r = await api.get('/product/fg/issues', { params });
        setRows(r.data?.data ?? []);
        mark(r);
      } else {
        const r = await api.get('/product/fg/issues/summary', {
          params: { ...params, groupBy: tab },
        });
        const data: FgIssueSummaryRow[] = r.data?.data ?? [];
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
  }, [tab, dateFrom, dateTo, customerCode, modelName, barcode, mark]);

  useEffect(() => { void search(); }, [tab]); // eslint-disable-line react-hooks/exhaustive-deps

  const headline = (() => {
    if (!searched) return '조회하세요';
    if (tab === 'history') {
      return `${rows.length.toLocaleString()}건 · 순출하 ${sumOf(rows, (r) => r.qty).toLocaleString()}`;
    }
    const list = summary[tab];
    return `${list.length.toLocaleString()}행 · 출하 ${sumOf(list, (r) => r.issueQty).toLocaleString()}`
      + ` · 취소 ${sumOf(list, (r) => r.cancelQty).toLocaleString()}`
      + ` · 순출하 ${sumOf(list, (r) => r.qty).toLocaleString()}`;
  })();

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">제품출하조회</h1>
        <p className="mt-1 text-sm text-text-muted">
          제품출하 이력과 거래처별 · 품목별 · 일자별 합계 · {headline}
        </p>
      </header>

      <ScreenTabs
        tabs={[
          { key: 'history' as TabKey, label: '출하 이력', count: rows.length },
          ...(Object.keys(SUMMARY_TABS) as SummaryKey[]).map((key) => ({
            key: key as TabKey,
            label: SUMMARY_TABS[key].label,
            count: summary[key].length,
          })),
        ]}
        active={tab}
        onChange={setTab}
      />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="출하일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <div className="w-60">
            <CustomerSelect aria-label="거래처 조건" includeAll
              value={customerCode} onChange={setCustomerCode} />
          </div>
          <ModelSearchField aria-label="모델 조건" placeholder="모델" value={modelName}
            className="w-36"
            onChange={(v) => setModelName(v)} />
          <Input aria-label="바코드 조건" placeholder="바코드" value={barcode}
            className="w-52"
            onChange={(e) => setBarcode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
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
              columns={fgIssueColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="제품출하이력"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['barcode'] }}
              emptyMessage={searched ? '이 기간에 출하 내역이 없습니다.' : '조회하세요.'}
            />
          ) : (
            <DataGrid
              key={tab}
              data={summary[tab]}
              columns={SUMMARY_TABS[tab].columns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName={SUMMARY_TABS[tab].exportName}
              emptyMessage={searched ? '이 기간에 출하가 없습니다.' : '조회하세요.'}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
