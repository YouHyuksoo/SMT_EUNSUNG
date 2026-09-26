"use client";

/**
 * @file src/app/(authenticated)/jig/pm/page.tsx
 * @description 지그자주보전관리 — PB w_mcn_jig_pm_master 이식 (조회 전용)
 *
 * 초보자 가이드:
 * 1. PB 는 `값 + '%'` LIKE 로 조회한다. 빈 값이면 전체다.
 * 2. PM 유형·주기·승인은 기초코드(PM TYPE / PM DIVISION / CONFIRM YN)에서 고른다.
 * 3. 보전 실시(Confirm)는 이력을 남기고 사용횟수를 0 으로 리셋한다 — PB cb_confirm 과 같다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { CalendarCheck, CheckCircle2, RefreshCw, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
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
  const [selected, setSelected] = useState<JigPmRow | null>(null);
  const [confirmOpen, setConfirmOpen] = useState(false);

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
      setSelected(null);
    } catch {
      toast.error('자주보전 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [lineCode, jigCode, jigLotNo, pmType, confirmYn]);

  const confirmPm = useCallback(async () => {
    if (!selected) return;
    setConfirmOpen(false);
    try {
      await api.post('/jig/pm/confirm', {
        lineCode: selected.lineCode ?? '',
        jigCode: selected.jigCode,
        jigLotNo: selected.jigLotNo ?? '',
        pmType: selected.pmType ?? '',
      });
      toast.success('보전 실시를 기록했습니다.');
      void search();
    } catch {
      toast.error('보전 계획을 찾을 수 없습니다.');
    }
  }, [selected, search]);

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
          <Button size="sm" disabled={!selected} onClick={() => setConfirmOpen(true)}>
            <CheckCircle2 className="mr-1 h-4 w-4" />보전 실시
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
            emptyMessage="조회 버튼을 눌러 보전계획을 확인하세요."
            onRowClick={(row) => setSelected(row as JigPmRow)}
            getRowId={(row) => {
              const pm = row as JigPmRow;
              return `${pm.jigCode}|${pm.jigLotNo ?? ''}|${pm.pmType ?? ''}`;
            }} />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={confirmPm}
        title="보전 실시"
        message={selected
          ? `${selected.jigCode} / ${selected.pmTypeName ?? selected.pmType ?? ''} 보전을 실시 처리합니다. 실시 이력이 남고 사용횟수가 0 으로 리셋됩니다.`
          : ''}
      />
    </div>
  );
}
