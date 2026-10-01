"use client";

/**
 * @file src/app/(authenticated)/report/run-card/page.tsx
 * @description 런카드리포트 — PB w_product_run_card_rpt 이식
 *
 * 초보자 가이드:
 * 1. **런카드(생산지시 한 장)를 상세·합계로 본다.** 합계는 지시일·라인·모델·마킹번호로
 *    묶어 몇 장을 지시했는지 센다.
 * 2. **라벨·투입·산출 수량은 기본으로 꺼져 있다.** 그 셋은 PB 와 같은 DB 함수가
 *    세는데, 함수 하나가 런카드마다 1억행 넘는 표를 한 번씩 센다 (25일치 523건에서
 *    47초 — 실측). 함수를 TypeScript 로 다시 쓰면 PB 와 숫자가 갈리므로 바꾸지 않고
 *    **필요할 때만 켜게** 했다.
 * 3. **켰다 껐다 할 때 열이 나타나고 사라진다.** 꺼져 있을 때 빈 열을 보여주면
 *    '0장' 으로 오해하므로 열 자체를 내지 않는다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import ModelSearchField from '@/components/shared/ModelSearchField';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { TruncationNotice, useTruncation } from '../components/TruncationNotice';
import { runCardReportColumns, runCardSummaryColumns } from '../report-columns';
import type { RunCardReportRow, RunCardSummaryRow } from '../report-types';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

type Tab = 'summary' | 'detail';

export default function RunCardReportPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(daysAgo(0));
  const [runNo, setRunNo] = useState('');
  const [modelName, setModelName] = useState('');
  const [markingNo, setMarkingNo] = useState('');
  const [lotNo, setLotNo] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [runStatus, setRunStatus] = useState('');
  const [withQty, setWithQty] = useState(false);

  const [tab, setTab] = useState<Tab>('summary');
  const [summary, setSummary] = useState<RunCardSummaryRow[]>([]);
  const [detail, setDetail] = useState<RunCardReportRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();
  /** 마지막 조회가 수량을 포함했는지. 체크박스 상태가 아니라 이 값으로 열을 정한다. */
  const [qtyShown, setQtyShown] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const params = {
        dateFrom,
        dateTo,
        runNo: runNo || undefined,
        modelName: modelName || undefined,
        markingNo: markingNo || undefined,
        lotNo: lotNo || undefined,
        lineCode: lineCode || undefined,
        runStatus: runStatus || undefined,
      };
      const [s, d] = await Promise.all([
        api.get('/report/run-card/summary', { params: { ...params, withQty } }),
        api.get('/report/run-card/detail', { params }),
      ]);
      setSummary(s.data?.data ?? []);
      setDetail(d.data?.data ?? []);
      setQtyShown(withQty);
      mark(s, d);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '런카드리포트 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, runNo, modelName, markingNo, lotNo, lineCode, runStatus, withQty]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const summaryColumns = useMemo(() => runCardSummaryColumns(qtyShown), [qtyShown]);
  const totalCards = summary.reduce((sum, r) => sum + Number(r.runCardCount ?? 0), 0);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">런카드리포트</h1>
        <p className="mt-1 text-sm text-text-muted">
          생산지시(런카드)를 상세·합계로 봅니다 ·{' '}
          {searched
            ? `합계 ${summary.length}건 · 런카드 ${totalCards.toLocaleString()}장`
            : '조회하세요'}
        </p>
      </header>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} what="런카드 장수" />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="지시일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input aria-label="Run No" placeholder="Run No" value={runNo} className="w-36"
            onChange={(e) => setRunNo(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <ModelSearchField aria-label="모델명" placeholder="모델명" value={modelName} className="w-36"
            onChange={(v) => setModelName(v)} />
          <Input aria-label="마킹번호" placeholder="마킹번호" value={markingNo} className="w-32"
            onChange={(e) => setMarkingNo(e.target.value)} />
          <Input aria-label="롯트번호" placeholder="롯트번호" value={lotNo} className="w-32"
            onChange={(e) => setLotNo(e.target.value)} />
          <div className="w-40">
            <LineSelect value={lineCode} onChange={setLineCode} labelPrefix="라인" />
          </div>
          <ComCodeSelect groupCode="RUN STATUS" labelPrefix="진행상태" value={runStatus}
            onChange={setRunStatus} className="w-44" />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
        <CardContent className="flex flex-wrap items-center gap-2 border-t border-border p-3">
          <label className="flex items-center gap-2 text-sm text-text">
            <input type="checkbox" checked={withQty}
              onChange={(e) => setWithQty(e.target.checked)} />
            합계에 라벨·투입·산출 수량 포함
          </label>
          <span className="text-xs text-text-muted">
            켜면 런카드마다 1억행 넘는 표를 세 번 셉니다 (25일치 523건 = 47초 실측).
          </span>
        </CardContent>
      </Card>

      <ScreenTabs
        tabs={[
          { key: 'summary', label: '합계', count: summary.length },
          { key: 'detail', label: '상세', count: detail.length },
        ]}
        active={tab}
        onChange={setTab}
      />

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
              exportFileName="런카드합계"
              emptyMessage={searched ? '기간에 런카드가 없습니다.' : '조회하세요.'}
            />
          ) : (
            <DataGrid
              data={detail}
              columns={runCardReportColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="런카드상세"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['runNo'] }}
              emptyMessage={searched ? '기간에 런카드가 없습니다.' : '조회하세요.'}
              getRowId={(row) => (row as RunCardReportRow).runNo}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
