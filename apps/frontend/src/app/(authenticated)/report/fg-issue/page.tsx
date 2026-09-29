"use client";

/**
 * @file src/app/(authenticated)/report/fg-issue/page.tsx
 * @description 제품 판매실적 — PB w_prd_product_fg_issue_rpt 이식
 *
 * 초보자 가이드:
 * 1. **세 갈래로 본다.** 상세는 출하 한 건씩, 합계는 모델·고객·위치별, 크로스탭은
 *    일자 × 모델 행렬이다.
 * 2. **수량에 부호가 붙는다.** 출고는 +, 출고취소는 − 다 (PB 와 같은 규칙).
 *    합계·크로스탭에서는 취소가 차감돼 있다 — 그래서 합계가 음수일 수도 있다.
 * 3. **크로스탭의 열은 조회한 기간에 따라 달라진다.** 서버가 `(일자, 모델, 수량)`
 *    목록을 주고 피벗은 화면에서 돌린다 — PB 도 표현 계층에서 돌렸다.
 * 4. **단가는 컬럼이 아니라 DB 함수가 계산한다** (F_GET_SAL_LAST_PRICE_CFM).
 *    TypeScript 로 다시 쓰면 PB 와 금액이 갈리므로 그대로 호출한다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { TruncationNotice, useTruncation } from '../components/TruncationNotice';
import { CrosstabGrid, type CrosstabSpec } from '../components/CrosstabGrid';
import { fgIssueDetailColumns, fgIssueSummaryColumns } from '../report-columns';
import type {
  FgIssueCrosstabRow,
  FgIssueDetailRow,
  FgIssueSummaryRow,
} from '../report-types';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

type Tab = 'summary' | 'detail' | 'crosstab';

export default function FgIssueReportPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(daysAgo(0));
  const [modelName, setModelName] = useState('');
  const [barcode, setBarcode] = useState('');

  const [tab, setTab] = useState<Tab>('summary');
  const [summary, setSummary] = useState<FgIssueSummaryRow[]>([]);
  const [detail, setDetail] = useState<FgIssueDetailRow[]>([]);
  const [crosstab, setCrosstab] = useState<FgIssueCrosstabRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const params = {
        dateFrom,
        dateTo,
        modelName: modelName || undefined,
        barcode: barcode || undefined,
      };
      const [s, d, c] = await Promise.all([
        api.get('/report/fg-issue/summary', { params }),
        api.get('/report/fg-issue/detail', { params }),
        api.get('/report/fg-issue/crosstab', { params }),
      ]);
      setSummary(s.data?.data ?? []);
      setDetail(d.data?.data ?? []);
      setCrosstab(c.data?.data ?? []);
      mark(s, d, c);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '제품 판매실적 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, modelName, barcode]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const spec = useMemo<CrosstabSpec<FgIssueCrosstabRow>>(() => ({
    rowKey: (r) => [r.modelName, r.modelSuffix, r.customerCode, r.locationCode].join('|'),
    rowLabels: [
      { header: '모델', value: (r) => r.modelName ?? '', width: 140 },
      { header: '모델 SFX', value: (r) => r.modelSuffix ?? '' },
      { header: '고객', value: (r) => r.customerCode ?? '' },
      { header: '위치', value: (r) => r.locationCode ?? '' },
    ],
    colKey: (r) => r.issueDate,
    // 'YYYY-MM-DD' 에서 월/일만 보여준다 — 열이 30개면 연도가 자리만 차지한다.
    colHeader: (k) => k.slice(5),
    value: (r) => Number(r.qty ?? 0),
  }), []);

  const totalQty = summary.reduce((sum, r) => sum + Number(r.qty ?? 0), 0);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">제품 판매실적</h1>
        <p className="mt-1 text-sm text-text-muted">
          제품 출하를 상세·합계·크로스탭으로 봅니다 (출고취소는 차감) ·{' '}
          {searched
            ? `합계 ${summary.length}건 · 수량 ${totalQty.toLocaleString()}`
            : '조회하세요'}
        </p>
      </header>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} what="수량 합계" />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="출하일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input aria-label="모델명" placeholder="모델명" value={modelName} className="w-44"
            onChange={(e) => setModelName(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          {/* 제품 바코드는 상세에만 걸린다 (합계·크로스탭은 집계라 개별 바코드가 없다). */}
          <Input aria-label="제품 바코드" placeholder="제품 바코드 (상세)" value={barcode}
            className="w-48"
            onChange={(e) => setBarcode(e.target.value)} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <ScreenTabs
        tabs={[
          { key: 'summary', label: '합계', count: summary.length },
          { key: 'detail', label: '상세', count: detail.length },
          { key: 'crosstab', label: '일자 × 모델', count: crosstab.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'summary' && (
            <DataGrid
              data={summary}
              columns={fgIssueSummaryColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="제품판매실적합계"
              emptyMessage={searched ? '기간에 출하 실적이 없습니다.' : '조회하세요.'}
            />
          )}
          {tab === 'detail' && (
            <DataGrid
              data={detail}
              columns={fgIssueDetailColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="제품판매실적상세"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['issueDate'] }}
              emptyMessage={searched ? '기간에 출하 실적이 없습니다.' : '조회하세요.'}
              rowClassName={(row) => (Number((row as FgIssueDetailRow).qty ?? 0) < 0
                ? 'bg-red-500/5'
                : '')}
            />
          )}
          {tab === 'crosstab' && (
            <CrosstabGrid
              rows={crosstab}
              spec={spec}
              isLoading={loading}
              exportFileName="제품판매실적_일자별"
              emptyMessage={searched ? '기간에 출하 실적이 없습니다.' : '조회하세요.'}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
