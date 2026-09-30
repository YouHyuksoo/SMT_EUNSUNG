"use client";

/**
 * @file src/app/(authenticated)/production/pcb-result/page.tsx
 * @description 기간별 생산실적 조회 — PB w_pln_product_pcb_result_query 이식
 *
 * 초보자 가이드:
 * 1. **세 단계로 좁혀 본다.** PB DataWindow 세 개와 같은 순서다.
 *      기간 집계 → (행 선택) 작업지시별 공정 집계 → (행 선택) 그 공정의 PID 목록
 * 2. **실적의 원천은 공정 통과 이력이다** (IP_PRODUCT_WORKSTAGE_IO, 245,717행).
 *    PID 한 장이 공정을 지날 때마다 한 줄이라 기간을 좁히지 않으면 무겁다.
 * 3. **PID 목록은 5,000건에서 끊는다.** 잘리면 화면에 그렇다고 적는다 —
 *    잘린 목록을 "그게 전부" 로 읽으면 수량을 잘못 센다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ModelSearchField from '@/components/shared/ModelSearchField';
import ProdLineSelect from '@/components/shared/ProdLineSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import {
  resultPeriodColumns,
  resultRunColumns,
  resultSerialColumns,
} from '../planning-columns';
import type {
  ResultPeriodRow,
  ResultRunRow,
  ResultSerialRow,
} from '../planning-types';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const weekAgo = () => {
  const date = new Date();
  date.setDate(date.getDate() - 7);
  return isoDate(date);
};

export default function PcbResultPage() {
  const [rows, setRows] = useState<ResultPeriodRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [dateFrom, setDateFrom] = useState(weekAgo);
  const [dateTo, setDateTo] = useState(today);
  const [modelName, setModelName] = useState('');
  const [runNo, setRunNo] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');

  const [selectedRun, setSelectedRun] = useState<string | null>(null);
  const [runRows, setRunRows] = useState<ResultRunRow[]>([]);
  const [runLoading, setRunLoading] = useState(false);

  const [selectedStage, setSelectedStage] = useState<ResultRunRow | null>(null);
  const [serials, setSerials] = useState<ResultSerialRow[]>([]);
  const [serialLoading, setSerialLoading] = useState(false);
  const [serialTruncated, setSerialTruncated] = useState(false);
  const [serialLimit, setSerialLimit] = useState(0);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/production/pcb-result', {
        params: {
          dateFrom,
          dateTo,
          modelName: modelName || undefined,
          runNo: runNo || undefined,
          lineCode: lineCode || undefined,
          workstageCode: workstageCode || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setSelectedRun(null);
      setRunRows([]);
      setSelectedStage(null);
      setSerials([]);
    } catch {
      toast.error('생산실적 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, modelName, runNo, lineCode, workstageCode]);

  const loadRun = useCallback(async (run: string) => {
    setSelectedRun(run);
    setSelectedStage(null);
    setSerials([]);
    setRunLoading(true);
    try {
      const response = await api.get('/production/pcb-result/by-run', {
        params: { runNo: run },
      });
      setRunRows(response.data?.data ?? []);
    } catch {
      toast.error('작업지시별 실적 조회에 실패했습니다.');
      setRunRows([]);
    } finally {
      setRunLoading(false);
    }
  }, []);

  const loadSerials = useCallback(async (row: ResultRunRow) => {
    setSelectedStage(row);
    setSerialLoading(true);
    try {
      const response = await api.get('/production/pcb-result/serials', {
        params: {
          runNo: row.runNo,
          lineCode: row.lineCode ?? '',
          workstageCode: row.workstageCode ?? '',
        },
      });
      const data = response.data?.data;
      setSerials(data?.data ?? []);
      setSerialTruncated(Boolean(data?.truncated));
      setSerialLimit(Number(data?.limit ?? 0));
    } catch {
      toast.error('PID 목록 조회에 실패했습니다.');
      setSerials([]);
    } finally {
      setSerialLoading(false);
    }
  }, []);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-text">기간별 생산실적 조회</h1>
          <p className="mt-1 text-sm text-text-muted">
            공정 통과 이력을 기간·작업지시·공정 순으로 좁혀 봅니다 ·{' '}
            {searched ? `${rows.length}/${total}건` : '기간을 정하고 조회하세요'}
          </p>
        </div>
        <Button size="sm" onClick={search} disabled={loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="생산일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <ModelSearchField aria-label="모델명" placeholder="모델명" value={modelName}
            className="w-48" onChange={(v) => setModelName(v)} />
          <Input aria-label="작업지시번호" placeholder="작업지시번호" value={runNo}
            className="w-44" onChange={(e) => setRunNo(e.target.value)} />
          <ProdLineSelect labelPrefix="라인" value={lineCode}
            onChange={setLineCode} className="w-56" />
          <Input aria-label="공정코드" placeholder="공정코드" value={workstageCode}
            className="w-36" onChange={(e) => setWorkstageCode(e.target.value)} />
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="flex h-full flex-col gap-2 p-3">
          <b className="text-sm text-text">기간 집계</b>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={rows}
              columns={resultPeriodColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="기간별생산실적"
              emptyMessage="조회 버튼을 눌러 실적을 확인하세요."
              onRowClick={(row) => {
                const r = row as ResultPeriodRow;
                if (r.runNo) void loadRun(r.runNo);
              }}
              getRowId={(row) => {
                const r = row as ResultPeriodRow;
                return [r.modelName, r.runNo, r.lineCode, r.workstageCode].join('|');
              }}
            />
          </div>
        </CardContent>
      </Card>

      <div className="flex h-72 shrink-0 gap-4">
        <Card className="flex-1 overflow-hidden" padding="none">
          <CardContent className="flex h-full flex-col gap-2 p-3">
            <b className="text-sm text-text">
              작업지시별 공정 실적{selectedRun ? ` — ${selectedRun}` : ''}
            </b>
            <div className="min-h-0 flex-1">
              <DataGrid
                data={runRows}
                columns={resultRunColumns}
                isLoading={runLoading}
                pageSize={50}
                emptyMessage={selectedRun ? '실적이 없습니다.' : '위에서 행을 고르세요.'}
                onRowClick={(row) => void loadSerials(row as ResultRunRow)}
                getRowId={(row) => {
                  const r = row as ResultRunRow;
                  return `${r.lineCode}|${r.workstageCode}`;
                }}
              />
            </div>
          </CardContent>
        </Card>

        <Card className="flex-1 overflow-hidden" padding="none">
          <CardContent className="flex h-full flex-col gap-2 p-3">
            <b className="text-sm text-text">
              PID 목록
              {selectedStage
                ? ` — ${selectedStage.lineCode} / ${selectedStage.workstageCode} (${serials.length}장)`
                : ''}
            </b>
            {serialTruncated && (
              <span className="text-xs text-amber-500">
                {serialLimit.toLocaleString()}건에서 잘렸습니다 — 조건을 좁혀 보세요.
              </span>
            )}
            <div className="min-h-0 flex-1">
              <DataGrid
                data={serials}
                columns={resultSerialColumns}
                isLoading={serialLoading}
                pageSize={100}
                enableExport
                exportFileName="공정통과PID"
                emptyMessage={selectedStage ? 'PID 가 없습니다.' : '왼쪽에서 공정을 고르세요.'}
                getRowId={(row) => {
                  const r = row as ResultSerialRow;
                  return `${r.serialNo}|${r.ioDate}`;
                }}
              />
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
