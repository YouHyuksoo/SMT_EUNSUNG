"use client";

/**
 * @file src/app/(authenticated)/jig/input-history/page.tsx
 * @description 지그 투입이력조회 — PB w_mcn_jig_input_history_master 이식 (조회 전용)
 *
 * 초보자 가이드:
 * 1. PB 는 조회조건을 `값 + '%'` 로 만들어 LIKE 에 넘긴다. 빈 값이면 전체 조회다.
 * 2. 지그유형은 자유 입력이 아니라 기초코드 'JIG TYPE' 선택이다.
 * 3. 기간은 공용 DateRangeFilter 를 쓴다. Input type="date" 를 새로 만들지 않는다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Search, Wrench } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { jigInputHistoryColumns } from './columns';
import type { JigInputHistoryRow } from './types';
import PartSearchField from '@/components/shared/PartSearchField';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const monthAgo = () => {
  const date = new Date();
  date.setMonth(date.getMonth() - 1);
  return isoDate(date);
};

export default function JigInputHistoryPage() {
  const [rows, setRows] = useState<JigInputHistoryRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [dateFrom, setDateFrom] = useState(monthAgo);
  const [dateTo, setDateTo] = useState(today);
  const [lineCode, setLineCode] = useState('');
  const [jigType, setJigType] = useState('');
  const [jigLotNo, setJigLotNo] = useState('');
  const [modelItem, setModelItem] = useState('');

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/jig/input-history', {
        params: {
          dateFrom,
          dateTo,
          lineCode: lineCode || undefined,
          jigType: jigType || undefined,
          jigLotNo: jigLotNo || undefined,
          modelItem: modelItem || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
    } catch {
      toast.error('지그 투입이력 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, lineCode, jigType, jigLotNo, modelItem]);

  const columns = useMemo(() => jigInputHistoryColumns, []);

  return (
    <div className="flex h-full min-h-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <Wrench className="h-6 w-6 text-primary" />지그 투입이력조회
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            라인·지그유형별 지그 투입 이력과 누적타수를 조회합니다 · {searched ? `${rows.length}/${total}건` : '조회조건을 선택하세요'}
          </p>
        </div>
        <div className="flex gap-2">
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </div>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter
            label="투입일"
            from={dateFrom}
            to={dateTo}
            onFromChange={setDateFrom}
            onToChange={setDateTo}
          />
          <LineSelect labelPrefix="라인" value={lineCode} onChange={setLineCode} className="w-44" />
          <ComCodeSelect groupCode="JIG TYPE" value={jigType} onChange={setJigType} className="w-44" />
          <Input
            placeholder="지그 LOT 번호"
            value={jigLotNo}
            onChange={(event) => setJigLotNo(event.target.value)}
            className="w-44"
          />
          <PartSearchField
            placeholder="품목코드"
            value={modelItem}
            onChange={(event) => setModelItem(event.target.value)}
            className="w-44"
          />
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={columns}
            isLoading={loading}
            pageSize={50}
            enableColumnFilter
            enableExport
            exportFileName="지그투입이력"
            emptyMessage="조회 버튼을 눌러 투입이력을 확인하세요."
          />
        </CardContent>
      </Card>
    </div>
  );
}
