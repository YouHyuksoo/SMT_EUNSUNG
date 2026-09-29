"use client";

/**
 * @file src/app/(authenticated)/query/marking/page.tsx
 * @description 마킹이력조회 — PB w_pln_product_pcb_marking_query 이식
 *
 * 초보자 가이드:
 * 1. **PCB 에 레이저로 PID 를 새긴 기록을 본다.** 마킹이 생산의 출발점이라
 *    '언제 몇 장을 새겼나' 가 생산량의 기준이 된다.
 * 2. **두 갈래로 본다.** 상세는 PID 한 줄씩, 요약은 설비 롯트·판정별 집계다.
 *    요약의 모델명은 PB 와 같이 DB 함수(F_GET_MODEL_NAME_BY_RUN_NO)가 붙인다.
 * 3. **PB 의 '저장' 은 아무 일도 하지 않았다.** 요약 DataWindow 에 갱신 대상
 *    테이블이 지정돼 있지 않아 `dw_2.update()` 가 무동작이다 (실측).
 *    이 화면은 조회 전용이다.
 * 4. **마킹시각은 문자열이다** ('YYYY/MM/DD HH24:MI:SS'). PB 도 문자열로 비교했다 —
 *    이 형식은 사전순이 시간순과 같아서 성립한다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { QueryTabs } from '../components/QueryTabs';
import { markingDetailColumns, markingSummaryColumns } from '../query-columns';
import type { MarkingDetailRow, MarkingSummaryRow } from '../query-types';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

type Tab = 'detail' | 'summary';

export default function MarkingQueryPage() {
  const [runNo, setRunNo] = useState('');
  const [serialNo, setSerialNo] = useState('');
  const [dateFrom, setDateFrom] = useState(daysAgo(1));
  const [dateTo, setDateTo] = useState(daysAgo(0));

  const [tab, setTab] = useState<Tab>('summary');
  const [detail, setDetail] = useState<MarkingDetailRow[]>([]);
  const [summary, setSummary] = useState<MarkingSummaryRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const params = {
        runNo: runNo || undefined,
        serialNo: serialNo || undefined,
        dateFrom,
        dateTo,
      };
      const [d, s] = await Promise.all([
        api.get('/query/marking/detail', { params }),
        api.get('/query/marking/summary', { params }),
      ]);
      setDetail(d.data?.data ?? []);
      setSummary(s.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '마킹이력 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [runNo, serialNo, dateFrom, dateTo]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const totalPid = summary.reduce((sum, r) => sum + Number(r.pidQty ?? 0), 0);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">마킹이력조회</h1>
        <p className="mt-1 text-sm text-text-muted">
          PCB 에 PID 를 새긴 기록을 상세·요약 두 갈래로 봅니다 ·{' '}
          {searched
            ? `요약 ${summary.length}건 · 마킹 PID 합계 ${totalPid.toLocaleString()}장`
            : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="Run No" placeholder="Run No" value={runNo} className="w-40"
            onChange={(e) => setRunNo(e.target.value)} />
          <Input aria-label="PID" placeholder="PID" value={serialNo} className="w-44"
            onChange={(e) => setSerialNo(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <DateRangeFilter label="마킹일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <QueryTabs
        tabs={[
          { key: 'summary', label: '요약', count: summary.length },
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
              columns={markingSummaryColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="마킹요약"
              emptyMessage={searched ? '이 기간에 마킹 기록이 없습니다.' : '조회하세요.'}
              getRowId={(row) => {
                const r = row as MarkingSummaryRow;
                return [r.lotId, r.equipmentId, r.resultCode, r.runNo].join('|');
              }}
            />
          ) : (
            <DataGrid
              data={detail}
              columns={markingDetailColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="마킹상세"
              emptyMessage={searched ? '이 기간에 마킹 기록이 없습니다.' : '조회하세요.'}
              getRowId={(row) => {
                const r = row as MarkingDetailRow;
                return [r.pid, r.markingDate, r.cstId, r.seq].join('|');
              }}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
