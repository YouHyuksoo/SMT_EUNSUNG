"use client";

/**
 * @file src/app/(authenticated)/report/jig/page.tsx
 * @description 지그리포트 — PB w_mcn_jig_rpt 이식
 *
 * 초보자 가이드:
 * 1. **세 갈래로 본다.** 지그 목록 · 이력카드(수리이력 포함) · 출고 이력이다.
 * 2. **살아있는 자료는 목록과 이력카드다** (지그 1,944건 · 수리 12건 — 실측).
 *    출고 이력이 읽는 IMCN_JIG_ISSUE 는 0행이다.
 * 3. **수리 기록이 없는 지그도 이력카드에 남는다** (외부조인). 수리 이력이 없는
 *    지그를 찾는 것도 이 표의 목적이라 내부조인으로 두면 사라진다.
 * 4. **타발수가 한계값을 넘으면 빨강으로 보인다** — 교체 대상이다.
 * 5. **바코드 라벨은 옮기지 않았다.** 값(`*코드*`)은 목록에 컬럼으로 있고, 라벨은
 *    CSV 로 내보내 라벨 소프트웨어가 찍는다 (340 라인설비바코드와 같은 결정).
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { TruncationNotice, useTruncation } from '../components/TruncationNotice';
import {
  jigCardColumns,
  jigIssueReportColumns,
  jigReportColumns,
} from '../report-b-columns';
import type { JigCardRow, JigIssueReportRow, JigReportRow } from '../report-b-types';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

type Tab = 'list' | 'card' | 'issue';

export default function JigReportPage() {
  const [jigCode, setJigCode] = useState('');
  const [jigType, setJigType] = useState('');
  const [dateFrom, setDateFrom] = useState(daysAgo(30));
  const [dateTo, setDateTo] = useState(daysAgo(0));

  const [tab, setTab] = useState<Tab>('list');
  const [list, setList] = useState<JigReportRow[]>([]);
  const [cards, setCards] = useState<JigCardRow[]>([]);
  const [issues, setIssues] = useState<JigIssueReportRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const base = { jigCode: jigCode || undefined };
      const [l, c, i] = await Promise.all([
        api.get('/report/jig', { params: base }),
        api.get('/report/jig/card', { params: base }),
        api.get('/report/jig/issue', {
          params: { ...base, jigType: jigType || undefined, dateFrom, dateTo },
        }),
      ]);
      setList(l.data?.data ?? []);
      setCards(c.data?.data ?? []);
      setIssues(i.data?.data ?? []);
      mark(l, c, i);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '지그리포트 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [jigCode, jigType, dateFrom, dateTo]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const overLimit = list.filter((r) => Number(r.breakValue ?? 0) > 0
    && Number(r.hitValue ?? 0) >= Number(r.breakValue ?? 0)).length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">지그리포트</h1>
        <p className="mt-1 text-sm text-text-muted">
          지그 마스터와 수리·출고 이력을 봅니다 ·{' '}
          {searched
            ? `${list.length.toLocaleString()}건${overLimit > 0 ? ` · 한계값 초과 ${overLimit}건` : ''}`
            : '조회하세요'}
        </p>
      </header>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} what="한계값 초과 건수" />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="지그코드" placeholder="지그코드" value={jigCode} className="w-40"
            onChange={(e) => setJigCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <ComCodeSelect groupCode="JIG TYPE" labelPrefix="지그유형" value={jigType}
            onChange={setJigType} className="w-48" />
          <DateRangeFilter label="출고일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <ScreenTabs
        tabs={[
          { key: 'list', label: '지그 목록', count: list.length },
          { key: 'card', label: '이력카드', count: cards.length },
          { key: 'issue', label: '출고 이력', count: issues.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'list' && (
            <DataGrid
              data={list}
              columns={jigReportColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="지그목록"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['jigCode'] }}
              emptyMessage={searched ? '조건에 맞는 지그가 없습니다.' : '조회하세요.'}
            />
          )}
          {tab === 'card' && (
            <DataGrid
              data={cards}
              columns={jigCardColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="지그이력카드"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['jigCode'] }}
              emptyMessage={searched ? '조건에 맞는 지그가 없습니다.' : '조회하세요.'}
              rowClassName={(row) => ((row as JigCardRow).repairSequence == null
                ? 'text-text-muted'
                : '')}
            />
          )}
          {tab === 'issue' && (
            <DataGrid
              data={issues}
              columns={jigIssueReportColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="지그출고이력"
              emptyMessage={searched
                ? '지그 출고 기록이 없습니다 (이 표는 현재 비어 있습니다).'
                : '조회하세요.'}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
