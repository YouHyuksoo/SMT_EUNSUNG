"use client";

/**
 * @file src/app/(authenticated)/jig/sample-input-history/page.tsx
 * @description 샘플마스터 장착이력조회 — PB w_mcn_sample_input_history_master 이식 (조회 전용)
 *
 * 초보자 가이드:
 * 1. PB 는 조회조건을 `값 + '%'` 로 만들어 LIKE 에 넘긴다. 빈 값이면 전체 조회다.
 * 2. 샘플유형은 자유 입력이 아니라 기초코드 'SAMPLE TYPE' 선택이다.
 * 3. 기간은 공용 DateRangeFilter 를 쓴다. Input type="date" 를 새로 만들지 않는다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { FlaskConical, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { sampleInputHistoryColumns } from './columns';
import type { SampleInputHistoryRow } from './types';
import PartSearchField from '@/components/shared/PartSearchField';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const monthAgo = () => {
  const date = new Date();
  date.setMonth(date.getMonth() - 1);
  return isoDate(date);
};

export default function SampleInputHistoryPage() {
  const [rows, setRows] = useState<SampleInputHistoryRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [dateFrom, setDateFrom] = useState(monthAgo);
  const [dateTo, setDateTo] = useState(today);
  const [lineCode, setLineCode] = useState('');
  const [sampleType, setSampleType] = useState('');
  const [sampleLotNo, setSampleLotNo] = useState('');
  const [modelItem, setModelItem] = useState('');

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/jig/sample-input-history', {
        params: {
          dateFrom,
          dateTo,
          lineCode: lineCode || undefined,
          sampleType: sampleType || undefined,
          sampleLotNo: sampleLotNo || undefined,
          modelItem: modelItem || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
    } catch {
      toast.error('샘플 장착이력 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, lineCode, sampleType, sampleLotNo, modelItem]);

  const columns = useMemo(() => sampleInputHistoryColumns, []);

  return (
    <div className="flex h-full min-h-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <FlaskConical className="h-6 w-6 text-primary" />샘플마스터 장착이력조회
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            라인·샘플유형별 샘플마스터 장착 이력과 적용일을 조회합니다 · {searched ? `${rows.length}/${total}건` : '조회조건을 선택하세요'}
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
            label="장착일"
            from={dateFrom}
            to={dateTo}
            onFromChange={setDateFrom}
            onToChange={setDateTo}
          />
          <LineSelect labelPrefix="라인" value={lineCode} onChange={setLineCode} className="w-44" />
          <ComCodeSelect groupCode="SAMPLE TYPE" value={sampleType} onChange={setSampleType} className="w-44" />
          <Input
            placeholder="샘플 LOT 번호"
            value={sampleLotNo}
            onChange={(event) => setSampleLotNo(event.target.value)}
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
            exportFileName="샘플장착이력"
            emptyMessage="조회 버튼을 눌러 장착이력을 확인하세요."
          />
        </CardContent>
      </Card>
    </div>
  );
}
