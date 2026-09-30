"use client";

/**
 * @file src/app/(authenticated)/quality/repair-query/page.tsx
 * @description 281 공정수리이력조회 — PB w_pln_product_pcb_repair_query 이식 (조회 전용)
 *
 * 초보자 가이드:
 * 1. **공정에서 난 불량이 언제·어디서 얼마나 났는지 모아 보는 화면이다.**
 *    **일별**은 날짜 × 불량사유로, **위치별**은 자리(LOCATION) × 불량사유로 모은다.
 * 2. **위치별이 이 화면의 핵심이다.** 같은 자리에서 같은 불량이 반복되면 설비나
 *    부품 문제다 — 건별 목록으로는 잘 안 보인다.
 * 3. **건별 목록은 공정수리이력조회(`/quality/repair-history`)에 이미 있다.**
 *    같은 표를 보므로 여기서 다시 만들지 않았다.
 * 4. **모으는 일은 DB 가 한다.** 잘린 목록 안에서 합계를 내면 숫자가 틀린다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import ModelSearchField from '@/components/shared/ModelSearchField';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { repairSummaryColumns } from '../repair-query-columns';
import type { RepairSummaryRow } from '../repair-query-columns';

const today = () => new Date().toISOString().slice(0, 10);
const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

type TabKey = 'daily' | 'position';

export default function RepairQueryPage() {
  const [tab, setTab] = useState<TabKey>('daily');
  const [dateFrom, setDateFrom] = useState(daysAgo(30));
  const [dateTo, setDateTo] = useState(today());
  const [lineCode, setLineCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [rows, setRows] = useState<RepairSummaryRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const r = await api.get(`/quality/repair-query/${tab}`, {
        params: {
          dateFrom,
          dateTo,
          lineCode: lineCode || undefined,
          modelName: modelName || undefined,
        },
      });
      setRows(r.data?.data ?? []);
      mark(r);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [tab, dateFrom, dateTo, lineCode, modelName, mark]);

  useEffect(() => { void search(); }, [tab]); // eslint-disable-line react-hooks/exhaustive-deps

  const totalBad = rows.reduce((sum, r) => sum + Number(r.badQty ?? 0), 0);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">공정수리이력조회</h1>
        <p className="mt-1 text-sm text-text-muted">
          공정 불량을 날짜별·위치별로 모아 봅니다 ·{' '}
          {searched
            ? `${rows.length.toLocaleString()}건 · 불량 ${totalBad.toLocaleString()}`
            : '조회하세요'}
        </p>
      </header>

      <ScreenTabs
        tabs={[
          { key: 'daily' as TabKey, label: '일별 요약' },
          { key: 'position' as TabKey, label: '위치별 요약' },
        ]}
        active={tab}
        onChange={setTab}
      />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="검사일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <LineSelect labelPrefix="라인" value={lineCode} className="w-40"
            onChange={setLineCode} />
          <ModelSearchField value={modelName} className="w-40"
            onChange={(v) => setModelName(v)} aria-label="모델" placeholder="모델" />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <span className="text-sm text-text-muted">
            건별 내역은 공정수리이력조회 화면에서 봅니다.
          </span>
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={repairSummaryColumns(tab === 'daily' ? '검사일' : '위치')}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName={tab === 'daily' ? '공정불량_일별' : '공정불량_위치별'}
            enableColumnPinning
            defaultPinnedColumns={{ left: ['groupKey'] }}
            emptyMessage={searched ? '이 기간에 불량이 없습니다.' : '조회하세요.'}
          />
        </CardContent>
      </Card>
    </div>
  );
}
