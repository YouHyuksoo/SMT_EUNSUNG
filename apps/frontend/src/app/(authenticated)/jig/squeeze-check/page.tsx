"use client";

/**
 * @file src/app/(authenticated)/jig/squeeze-check/page.tsx
 * @description 스퀴즈검사관리 — PB w_mcn_jig_squeeze_check_master 이식 (조회 전용)
 *
 * 초보자 가이드:
 * 1. PB 는 `값 + '%'` LIKE 로 조회한다. 빈 값이면 전체다.
 * 2. 체크상태는 자유 입력이 아니라 기초코드 'JIG CHECK STATUS' 선택이다.
 * 3. 검사 등록·승인은 PB 원본에 있으나 이번 범위에서 제외했다(조회 먼저).
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { RefreshCw, Search, SprayCan } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { squeezeCheckColumns, type SqueezeCheckRow } from './columns';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const monthAgo = () => {
  const date = new Date();
  date.setMonth(date.getMonth() - 1);
  return isoDate(date);
};

export default function SqueezeCheckPage() {
  const [rows, setRows] = useState<SqueezeCheckRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [dateFrom, setDateFrom] = useState(monthAgo);
  const [dateTo, setDateTo] = useState(today);
  const [jigLotNo, setJigLotNo] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [jigCheckStatus, setJigCheckStatus] = useState('');

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/jig/squeeze-check', {
        params: {
          dateFrom,
          dateTo,
          jigLotNo: jigLotNo || undefined,
          lineCode: lineCode || undefined,
          jigCheckStatus: jigCheckStatus || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
    } catch {
      toast.error('스퀴즈검사 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, jigLotNo, lineCode, jigCheckStatus]);

  const columns = useMemo(() => squeezeCheckColumns, []);

  return (
    <div className="flex h-full min-h-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <SprayCan className="h-6 w-6 text-primary" />스퀴즈검사관리
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            스퀴즈 지그의 세척·핀홀·공기압력 검사 결과를 조회합니다 · {searched ? `${rows.length}/${total}건` : '조회조건을 선택하세요'}
          </p>
        </div>
        <div className="flex gap-2">
          <Button variant="secondary" size="sm" onClick={search} disabled={loading}>
            <RefreshCw className={`mr-1 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />새로고침
          </Button>
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </div>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="검사일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input placeholder="지그LOT" value={jigLotNo} className="w-44"
            onChange={(e) => setJigLotNo(e.target.value)} />
          <LineSelect labelPrefix="라인" value={lineCode} onChange={setLineCode} className="w-44" />
          <ComCodeSelect groupCode="JIG CHECK STATUS" value={jigCheckStatus}
            onChange={setJigCheckStatus} className="w-44" />
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid data={rows} columns={columns} isLoading={loading} pageSize={50}
            enableColumnFilter enableExport exportFileName="스퀴즈검사"
            emptyMessage="조회 버튼을 눌러 검사결과를 확인하세요." />
        </CardContent>
      </Card>
    </div>
  );
}
