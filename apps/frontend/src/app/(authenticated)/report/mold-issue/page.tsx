"use client";

/**
 * @file src/app/(authenticated)/report/mold-issue/page.tsx
 * @description S-PARTS출고리포트 — PB w_mcn_mold_issue_rpt 이식
 *
 * 초보자 가이드:
 * 1. **S-PARTS 를 어느 라인·설비로 내보냈는지 본다.** 출고계정으로 비용 계정을 가른다.
 * 2. **이 표는 현재 0행이다** (IMCN_MOLD_ISSUE 실측 0건). 화면은 동작하지만
 *    볼 것이 없다 — 조건이 틀린 게 아니다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { moldIssueColumns } from '../report-b-columns';
import type { MoldIssueRow } from '../report-b-types';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

export default function MoldIssueReportPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(30));
  const [dateTo, setDateTo] = useState(daysAgo(0));
  const [moldCode, setMoldCode] = useState('');

  const [rows, setRows] = useState<MoldIssueRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/report/mold-issue', {
        params: {
          dateFrom,
          dateTo,
          moldCode: moldCode || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? 'S-PARTS 출고 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, moldCode]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">S-PARTS출고리포트</h1>
        <p className="mt-1 text-sm text-text-muted">
          S-PARTS 출고 이력을 봅니다 ·{' '}
          {searched ? `${rows.length.toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="출고일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input aria-label="S-PARTS 코드" placeholder="S-PARTS 코드" value={moldCode}
            className="w-44"
            onChange={(e) => setMoldCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={moldIssueColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="S-PARTS출고"
            emptyMessage={searched
              ? 'S-PARTS 출고 기록이 없습니다 (이 표는 현재 비어 있습니다).'
              : '조회하세요.'}
          />
        </CardContent>
      </Card>
    </div>
  );
}
