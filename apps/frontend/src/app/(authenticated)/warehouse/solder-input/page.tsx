"use client";

/**
 * @file src/app/(authenticated)/warehouse/solder-input/page.tsx
 * @description 솔더라인투입이력조회 — PB w_mat_solder_input_move_query 이식
 *
 * 초보자 가이드:
 * 1. **솔더가 어느 라인·설비에 언제 투입됐는지 본다.** 한 통이 여러 라인에 나눠
 *    쓰이면 줄이 여러 개 나온다.
 * 2. **조회 전용이다.** PB 에 244 에서 복붙한 저장 함수가 남아 있지만 **호출부가 없고**
 *    `dw.update()` 도 주석 처리돼 있다 (실측). 화면에 저장 버튼도 없다.
 * 3. **품목·종류를 함께 보여준다.** PB 는 롯트번호만 보여줘서 무슨 솔더인지
 *    알 수 없었다 — 솔더 마스터를 붙였다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { solderInputHistoryColumns } from '../solder-columns';
import type { SolderInputHistoryRow } from '../warehouse-types';
import EquipSelect from '@/components/shared/EquipSelect';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

export default function SolderInputHistoryPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(daysAgo(0));
  const [solderLotNo, setSolderLotNo] = useState('');
  const [machineCode, setMachineCode] = useState('');

  const [rows, setRows] = useState<SolderInputHistoryRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/warehouse/solder-input', {
        params: {
          dateFrom,
          dateTo,
          solderLotNo: solderLotNo || undefined,
          machineCode: machineCode || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '솔더 라인투입이력 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, solderLotNo, machineCode]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const lots = new Set(rows.map((r) => r.solderLotNo)).size;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">솔더라인투입이력조회</h1>
        <p className="mt-1 text-sm text-text-muted">
          솔더가 어느 라인·설비에 언제 투입됐는지 봅니다 ·{' '}
          {searched
            ? `${rows.length.toLocaleString()}건 · 솔더 ${lots}통`
            : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="투입일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input aria-label="솔더 롯트" placeholder="솔더 롯트" value={solderLotNo}
            className="w-44"
            onChange={(e) => setSolderLotNo(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <EquipSelect labelPrefix="설비" value={machineCode} onChange={setMachineCode} className="w-44" />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={solderInputHistoryColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="솔더라인투입이력"
            enableColumnPinning
            defaultPinnedColumns={{ left: ['inputDate'] }}
            emptyMessage={searched ? '기간에 투입 이력이 없습니다.' : '조회하세요.'}
          />
        </CardContent>
      </Card>
    </div>
  );
}
