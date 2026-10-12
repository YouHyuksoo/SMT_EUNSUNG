"use client";

/**
 * @file src/app/(authenticated)/warehouse/recycle-check/page.tsx
 * @description SMT 공릴체크 — PB w_smt_recycle_check_rpt 이식
 *
 * 초보자 가이드:
 * 1. **다 쓴 릴(공릴)을 버리기 전에 맞는지 확인한 기록이다.** 작업자가 릴 바코드를
 *    찍으면 시스템이 "정말 다 썼나" 를 판정하고 결과를 남긴다.
 * 2. **오류 건이 이 화면을 보는 이유다.** 실측 판정 분포는 통과 419건 · 오류 158건이고
 *    오류는 사유 열에 이유가 들어 있다 — 아직 남은 릴을 버리려 했다는 뜻이다.
 * 3. **조회 전용이다.** PB 에 저장 코드가 있지만 편집 가능한 컬럼이 없어 무동작이다
 *    (DataWindow 12개 컬럼 전부 편집 불가 — 실측).
 * 4. **자료가 2020-10 ~ 2026-06 에 걸쳐 577건뿐이다.** 기간을 넓게 잡아야 보인다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, Input, Select } from '@/components/ui';
import api from '@/services/api';
import { recycleCheckColumns } from '../warehouse-columns';
import type { RecycleCheckRow } from '../warehouse-types';

const monthsAgo = (n: number) => {
  const d = new Date();
  d.setMonth(d.getMonth() - n);
  return d.toISOString().slice(0, 10);
};
const today = () => new Date().toISOString().slice(0, 10);

const STATUS_OPTIONS = [
  { value: '', label: '판정: 전체' },
  { value: 'E', label: '오류만' },
  { value: 'P', label: '통과만' },
];

export default function RecycleCheckPage() {
  // 577건이 6년에 걸쳐 있어 기본 기간을 1년으로 둔다 (7일로 두면 늘 빈 화면이다).
  const [dateFrom, setDateFrom] = useState(monthsAgo(12));
  const [dateTo, setDateTo] = useState(today());
  const [lineCode, setLineCode] = useState('');
  const [checkStatus, setCheckStatus] = useState('');
  const [scanPartName, setScanPartName] = useState('');

  const [rows, setRows] = useState<RecycleCheckRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/warehouse/recycle-check', {
        params: {
          dateFrom,
          dateTo,
          lineCode: lineCode || undefined,
          checkStatus: checkStatus || undefined,
          scanPartName: scanPartName || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '공릴체크 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, lineCode, checkStatus, scanPartName]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const errorCount = rows.filter((r) => r.checkStatus === 'E').length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">SMT 공릴체크</h1>
        <p className="mt-1 text-sm text-text-muted">
          다 쓴 릴을 버리기 전 확인한 기록을 봅니다 ·{' '}
          {searched
            ? `${rows.length}건${errorCount > 0 ? ` · 오류 ${errorCount}건` : ''}`
            : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="체크일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <div className="w-44">
            <LineSelect value={lineCode} onChange={setLineCode} labelPrefix="라인" />
          </div>
          <Select options={STATUS_OPTIONS} value={checkStatus} onChange={setCheckStatus}
            className="w-36" />
          <Input aria-label="스캔 바코드" placeholder="스캔 바코드" value={scanPartName}
            className="w-56"
            onChange={(e) => setScanPartName(e.target.value)}
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
            columns={recycleCheckColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="SMT공릴체크"
            enableColumnPinning
            defaultPinnedColumns={{ left: ['checkDate'] }}
            emptyMessage={searched
              ? '기간에 공릴체크 기록이 없습니다 (전체 577건이 2020-10 ~ 2026-06 에 걸쳐 있습니다).'
              : '조회하세요.'}
            rowClassName={(row) => ((row as RecycleCheckRow).checkStatus === 'E'
              ? 'bg-red-500/5'
              : '')}
          />
        </CardContent>
      </Card>
    </div>
  );
}
