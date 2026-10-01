"use client";

/**
 * @file src/app/(authenticated)/warehouse/manual-input/page.tsx
 * @description IMD 라인 자재투입관리 — PB w_mat_manual_input_history_query 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **바코드 없이 라인에 자재를 넣은 것을 손으로 적는 화면이다.** IMD 라인처럼
 *    스캐너가 없는 공정에서 쓴다.
 * 2. **이 이력은 아직 비어 있다** — 표가 0행이다. PB 에도 기능은 있지만 현장에서
 *    쓰기 시작한 적이 없다. 빈 화면만 보고 "왜 안 나오나" 로 헷갈리지 않도록
 *    여기에 적어 둔다.
 * 3. **런번호를 넣으면 모델명이 따라온다** (작업지시에서 찾는다). 런번호 없이도
 *    적을 수 있다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, PlusCircle, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { manualInputColumns } from '../reprint-msl-columns';
import type { ManualInputRow } from '../reprint-msl-columns';
import ProcessSelect from '@/components/shared/ProcessSelect';

const today = () => new Date().toISOString().slice(0, 10);
const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

export default function ManualInputPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(today());
  const [filterLine, setFilterLine] = useState('');
  const [runNoCond, setRunNoCond] = useState('');

  const [rows, setRows] = useState<ManualInputRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 등록 (쓰기)
  const [inputDate, setInputDate] = useState(today());
  const [lineCode, setLineCode] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');
  const [materialLot, setMaterialLot] = useState('');
  const [runNo, setRunNo] = useState('');
  const [comments, setComments] = useState('');
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const r = await api.get('/warehouse/manual-input', {
        params: {
          dateFrom, dateTo,
          lineCode: filterLine || undefined,
          runNo: runNoCond || undefined,
        },
      });
      setRows(r.data?.data ?? []);
      mark(r);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, filterLine, runNoCond, mark]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const blocker = !lineCode
    ? '라인을 고르세요.'
    : !workstageCode.trim()
      ? '공정코드를 넣으세요.'
      : !materialLot.trim()
        ? '자재 롯트번호를 넣으세요.'
        : null;

  const submit = useCallback(async () => {
    setConfirmOpen(false);
    setBusy(true);
    try {
      await api.post('/warehouse/manual-input', {
        inputDate,
        lineCode,
        workstageCode: workstageCode.trim(),
        materialLot: materialLot.trim(),
        runNo: runNo.trim() || undefined,
        comments: comments.trim() || undefined,
      });
      toast.success('투입 이력을 남겼습니다.');
      setMaterialLot('');
      setComments('');
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '등록에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [inputDate, lineCode, workstageCode, materialLot, runNo, comments, search]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">IMD 라인 자재투입관리</h1>
        <p className="mt-1 text-sm text-text-muted">
          바코드 없이 라인에 넣은 자재를 손으로 적습니다 ·{' '}
          {searched ? `${rows.length.toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      {/* 등록 (쓰기) */}
      <Card padding="none">
        <CardContent className="flex flex-wrap items-end gap-3 p-3">
          <span className="flex items-center gap-1 pb-2 text-sm font-semibold text-text">
            <PlusCircle className="h-4 w-4" />투입 등록
          </span>
          <Input label="투입일" type="date" value={inputDate} className="w-40"
            onChange={(e) => setInputDate(e.target.value)} />
          <div className="w-40">
            <LineSelect value={lineCode} onChange={setLineCode} labelPrefix="라인" />
          </div>
          <ProcessSelect labelPrefix="공정" value={workstageCode} onChange={setWorkstageCode} className="w-44" />
          <Input aria-label="자재 롯트" placeholder="자재 롯트번호" value={materialLot}
            className="w-44"
            onChange={(e) => setMaterialLot(e.target.value)} />
          <Input aria-label="런번호" placeholder="런번호 (선택)" value={runNo}
            className="w-40"
            onChange={(e) => setRunNo(e.target.value)} />
          <Input aria-label="비고" placeholder="비고" value={comments}
            className="w-56"
            onChange={(e) => setComments(e.target.value)} />
          <Button size="sm" disabled={busy || Boolean(blocker)}
            onClick={() => setConfirmOpen(true)}>
            등록
          </Button>
          {blocker && (
            <span className="flex items-center gap-1 pb-2 text-sm text-amber-500">
              <AlertTriangle className="h-4 w-4" />{blocker}
            </span>
          )}
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="투입일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <div className="w-44">
            <LineSelect value={filterLine} onChange={setFilterLine} labelPrefix="라인" />
          </div>
          <Input aria-label="런번호" placeholder="런번호" value={runNoCond}
            className="w-40"
            onChange={(e) => setRunNoCond(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      {searched && rows.length === 0 && (
        <p className="text-sm text-text-muted">
          이 이력은 아직 비어 있습니다 — PB 에도 기능은 있지만 현장에서 쓰기 시작한
          적이 없습니다.
        </p>
      )}

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={manualInputColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="IMD_자재투입이력"
            emptyMessage={searched ? '기간 안에 투입 이력이 없습니다.' : '조회하세요.'}
          />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={submit}
        title="자재투입 등록"
        message={`${inputDate} 라인 ${lineCode} 공정 ${workstageCode} 에`
          + ` 자재 롯트 ${materialLot} 를 투입한 것으로 남깁니다.`}
        confirmText="등록"
      />
    </div>
  );
}
