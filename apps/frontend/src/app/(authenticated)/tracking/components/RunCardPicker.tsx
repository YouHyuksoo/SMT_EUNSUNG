"use client";

/**
 * @file src/app/(authenticated)/tracking/components/RunCardPicker.tsx
 * @description 318·319 위쪽 롯트카드 표. 두 화면이 같은 표를 쓴다.
 *
 * 초보자 가이드:
 * 1. **행을 클릭하면 아래 상세가 그 롯트로 바뀐다.** PB 의 rowfocuschanged 와 같다.
 * 2. **기간은 필수다.** PB 는 빈 조건에 `'%'` 를 붙여 전체를 봤는데, 지시일 범위는
 *    남겨야 목록이 쓸 만한 크기로 유지된다. 라인·모델·Run No 는 앞부분 일치다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { runCardColumns } from '../tracking-columns';
import type { RunCardRow } from '../tracking-types';

/** 기본 기간 — 최근 7일. 롯트카드는 최근 것을 보는 일이 대부분이다. */
const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

export interface RunCardPickerProps {
  selected: RunCardRow | null;
  onSelect: (row: RunCardRow) => void;
}

export default function RunCardPicker({ selected, onSelect }: RunCardPickerProps) {
  const [rows, setRows] = useState<RunCardRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [lineCode, setLineCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [runNo, setRunNo] = useState('');
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(daysAgo(0));

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/tracking/pid/run-cards', {
        params: {
          lineCode: lineCode || undefined,
          modelName: modelName || undefined,
          runNo: runNo || undefined,
          dateFrom,
          dateTo,
        },
      });
      setRows(response.data?.data ?? []);
      setSearched(true);
    } catch {
      toast.error('롯트카드 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [lineCode, modelName, runNo, dateFrom, dateTo]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  return (
    <>
      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <div className="w-44">
            <LineSelect value={lineCode} onChange={setLineCode} labelPrefix="라인" />
          </div>
          <Input aria-label="모델명" placeholder="모델명" value={modelName} className="w-40"
            onChange={(e) => setModelName(e.target.value)} />
          <Input aria-label="Run No" placeholder="Run No" value={runNo} className="w-40"
            onChange={(e) => setRunNo(e.target.value)} />
          <DateRangeFilter label="지시일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <span className="text-sm text-text-muted">
            {searched ? `롯트카드 ${rows.length}건` : '읽는 중'}
            {selected ? ` · 선택 ${selected.runNo}` : ' · 행을 클릭하면 아래에 상세가 나옵니다'}
          </span>
        </CardContent>
      </Card>

      <Card className="h-64 shrink-0 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={runCardColumns}
            isLoading={loading}
            pageSize={50}
            enableColumnFilter
            emptyMessage="조건에 맞는 롯트카드가 없습니다."
            onRowClick={(row) => onSelect(row as RunCardRow)}
            rowClassName={(row) =>
              (row as RunCardRow).runNo === selected?.runNo ? 'bg-primary/10' : ''}
            getRowId={(row) => (row as RunCardRow).runNo}
          />
        </CardContent>
      </Card>
    </>
  );
}
