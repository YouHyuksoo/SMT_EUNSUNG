"use client";

/**
 * @file src/app/(authenticated)/jig/sample-bcr-history/page.tsx
 * @description 샘플마스터 투입이력조회(BCR) — PB w_mcn_sample_bcr_input_history_master 이식 (조회 전용)
 *
 * 초보자 가이드:
 * 1. PB 라디오버튼 rb_list / rb_ng 묶음을 웹은 탭으로 만든다. 탭을 바꾸면 이전 조회 결과를 비운다.
 * 2. 샘플유형은 기초코드 'SAMPLE TYPE' 선택이다. 자유 입력은 샘플 LOT 뿐이다.
 * 3. NG 판정은 그리드에서 색으로만 구분한다 — PB 의 경고음(f_play_sound)은 옮기지 않는다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { ScanBarcode, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { sampleBcrHistoryColumns } from './columns';
import type { SampleBcrHistoryRow, SampleBcrMode } from './types';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const monthAgo = () => {
  const date = new Date();
  date.setMonth(date.getMonth() - 1);
  return isoDate(date);
};

const MODES: { value: SampleBcrMode; label: string }[] = [
  { value: 'ALL', label: '전체' },
  { value: 'NG', label: 'NG' },
];

export default function SampleBcrHistoryPage() {
  const [mode, setMode] = useState<SampleBcrMode>('ALL');
  const [rows, setRows] = useState<SampleBcrHistoryRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [dateFrom, setDateFrom] = useState(monthAgo);
  const [dateTo, setDateTo] = useState(today);
  const [lineCode, setLineCode] = useState('');
  const [sampleType, setSampleType] = useState('');
  const [sampleLotNo, setSampleLotNo] = useState('');

  const search = useCallback(async (nextMode: SampleBcrMode = mode) => {
    setLoading(true);
    try {
      const response = await api.get('/jig/sample-bcr-history', {
        params: {
          mode: nextMode,
          dateFrom,
          dateTo,
          lineCode: lineCode || undefined,
          sampleType: sampleType || undefined,
          sampleLotNo: sampleLotNo || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
    } catch {
      toast.error('샘플 투입이력 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [mode, dateFrom, dateTo, lineCode, sampleType, sampleLotNo]);

  /** 모드를 바꾸면 이전 조회 결과를 비운다 (PB 라디오버튼 전환과 같은 동작) */
  const changeMode = useCallback((next: SampleBcrMode) => {
    setMode(next);
    setRows([]);
    setTotal(0);
    setSearched(false);
  }, []);

  const columns = useMemo(() => sampleBcrHistoryColumns, []);

  return (
    <div className="flex h-full min-h-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <ScanBarcode className="h-6 w-6 text-primary" />샘플마스터 투입이력조회
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            바코드로 투입한 샘플마스터의 공정별 이력과 판정결과를 조회합니다 · {searched ? `${rows.length}/${total}건` : '조회조건을 선택하세요'}
          </p>
        </div>
        <div className="flex gap-2">
          <Button size="sm" onClick={() => search()} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </div>
      </header>

      <nav className="flex flex-wrap gap-1 border-b border-border" aria-label="조회 모드">
        {MODES.map((item) => (
          <button
            key={item.value}
            type="button"
            onClick={() => changeMode(item.value)}
            className={`-mb-px border-b-2 px-4 py-2 text-sm ${
              mode === item.value
                ? 'border-primary font-semibold text-primary'
                : 'border-transparent text-text-muted hover:text-text'
            }`}
          >
            {item.label}
          </button>
        ))}
      </nav>

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
          <ComCodeSelect groupCode="SAMPLE TYPE" value={sampleType} onChange={setSampleType} className="w-44" />
          <Input
            placeholder="샘플 LOT 번호"
            value={sampleLotNo}
            onChange={(event) => setSampleLotNo(event.target.value)}
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
            exportFileName={mode === 'NG' ? '샘플투입이력_NG' : '샘플투입이력'}
            emptyMessage="조회 버튼을 눌러 투입이력을 확인하세요."
          />
        </CardContent>
      </Card>
    </div>
  );
}
