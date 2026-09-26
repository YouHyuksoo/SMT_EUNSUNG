"use client";

/**
 * @file src/app/(authenticated)/jig/pm/page.tsx
 * @description 지그자주보전관리 — PB w_mcn_jig_pm_master 이식 (조회 전용)
 *
 * 초보자 가이드:
 * 1. PB 는 `값 + '%'` LIKE 로 조회한다. 빈 값이면 전체다.
 * 2. PM 유형·주기·승인은 기초코드(PM TYPE / PM DIVISION / CONFIRM YN)에서 고른다.
 * 3. 계획 등록·승인은 PB 원본에 있으나 이번 범위에서 제외했다(조회 먼저).
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { CalendarCheck, RefreshCw, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { jigPmColumns, type JigPmRow } from './columns';

export default function JigPmPage() {
  const [rows, setRows] = useState<JigPmRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [lineCode, setLineCode] = useState('');
  const [jigCode, setJigCode] = useState('');
  const [jigLotNo, setJigLotNo] = useState('');
  const [pmType, setPmType] = useState('');
  const [confirmYn, setConfirmYn] = useState('');

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/jig/pm', {
        params: {
          lineCode: lineCode || undefined,
          jigCode: jigCode || undefined,
          jigLotNo: jigLotNo || undefined,
          pmType: pmType || undefined,
          confirmYn: confirmYn || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
    } catch {
      toast.error('자주보전 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [lineCode, jigCode, jigLotNo, pmType, confirmYn]);

  const columns = useMemo(() => jigPmColumns, []);

  return (
    <div className="flex h-full min-h-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <CalendarCheck className="h-6 w-6 text-primary" />지그자주보전관리
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            지그별 자주보전 계획과 실시 결과를 조회합니다 · {searched ? `${rows.length}/${total}건` : '조회조건을 선택하세요'}
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
          <LineSelect labelPrefix="라인" value={lineCode} onChange={setLineCode} className="w-44" />
          <Input placeholder="지그코드" value={jigCode} className="w-44"
            onChange={(e) => setJigCode(e.target.value)} />
          <Input placeholder="지그LOT" value={jigLotNo} className="w-44"
            onChange={(e) => setJigLotNo(e.target.value)} />
          <ComCodeSelect groupCode="PM TYPE" value={pmType} onChange={setPmType} className="w-56" />
          <ComCodeSelect groupCode="CONFIRM YN" value={confirmYn} onChange={setConfirmYn} className="w-40" />
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid data={rows} columns={columns} isLoading={loading} pageSize={50}
            enableColumnFilter enableExport exportFileName="지그자주보전"
            emptyMessage="조회 버튼을 눌러 보전계획을 확인하세요." />
        </CardContent>
      </Card>
    </div>
  );
}
