"use client";

/**
 * @file src/app/(authenticated)/quality/wqc/page.tsx
 * @description 공정품질검사이력관리 — PB w_qc_workstage_inspect_data_master_es 이식
 *
 * 초보자 가이드:
 * 1. **PID 스캔 1회 = 검사 1건.** 현장 스캐너는 키보드 방식이라 Enter 핸들러 하나면 된다.
 * 2. **라인·공정을 먼저 고른다.** PB 도 안 고르면 스캔을 받지 않았다.
 *    한 번 고르면 연속 스캔이 되도록 스캔 후 입력칸만 비우고 포커스를 되돌린다.
 * 3. **취소는 같은 PID·라인·공정의 최신 1건만 지운다** — PB 조건 그대로다.
 * 4. 하단은 스캔한 PID 의 검사내역이다. 같은 PID 가 여러 공정에서 검사되므로 여러 줄이 나온다.
 */
import { useCallback, useMemo, useRef, useState } from 'react';
import toast from 'react-hot-toast';
import { ClipboardCheck, ScanLine, Search, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import ProcessSelect from '@/components/shared/ProcessSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { wqcColumns, type WqcRow } from '../qc-columns';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const weekAgo = () => {
  const date = new Date();
  date.setDate(date.getDate() - 7);
  return isoDate(date);
};

export default function WqcPage() {
  const scanRef = useRef<HTMLInputElement>(null);
  const [rows, setRows] = useState<WqcRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [dateFrom, setDateFrom] = useState(weekAgo);
  const [dateTo, setDateTo] = useState(today);
  const [lineCode, setLineCode] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [serialNo, setSerialNo] = useState('');

  const [scanLine, setScanLine] = useState('');
  const [scanWorkstage, setScanWorkstage] = useState('');
  const [badReasonCode, setBadReasonCode] = useState('NG');
  const [machineCode, setMachineCode] = useState('');
  const [comments, setComments] = useState('');
  const [barcode, setBarcode] = useState('');
  const [busy, setBusy] = useState(false);

  const [pidRows, setPidRows] = useState<WqcRow[]>([]);
  const [pidLoading, setPidLoading] = useState(false);
  const [lastPid, setLastPid] = useState('');
  const [cancelOpen, setCancelOpen] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/quality/wqc', {
        params: {
          dateFrom, dateTo,
          lineCode: lineCode || undefined,
          workstageCode: workstageCode || undefined,
          modelName: modelName || undefined,
          serialNo: serialNo || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
    } catch {
      toast.error('공정품질검사 이력 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, lineCode, workstageCode, modelName, serialNo]);

  const loadPid = useCallback(async (pid: string) => {
    setPidLoading(true);
    try {
      const response = await api.get('/quality/wqc/by-pid', { params: { serialNo: pid } });
      setPidRows(response.data?.data ?? []);
      setLastPid(pid);
    } catch {
      toast.error('PID 검사내역 조회에 실패했습니다.');
    } finally {
      setPidLoading(false);
    }
  }, []);

  const scan = useCallback(async () => {
    const pid = barcode.trim();
    if (!pid || busy) return;
    if (!scanLine) return toast.error('라인을 고르세요.');
    if (!scanWorkstage) return toast.error('공정을 고르세요.');
    setBusy(true);
    try {
      const response = await api.post('/quality/wqc/scan', {
        serialNo: pid,
        lineCode: scanLine,
        workstageCode: scanWorkstage,
        badReasonCode,
        machineCode: machineCode || undefined,
        comments: comments || undefined,
      });
      toast.success(`${pid} 검사 ${response.data?.data?.inspectSequence ?? ''}번 등록`);
      void loadPid(pid);
    } catch {
      toast.error('등록되지 않은 PID 이거나 등록에 실패했습니다.');
    } finally {
      setBusy(false);
      setBarcode('');
      scanRef.current?.focus();
    }
  }, [barcode, busy, scanLine, scanWorkstage, badReasonCode, machineCode, comments, loadPid]);

  const cancel = useCallback(async () => {
    setCancelOpen(false);
    if (!lastPid || !scanLine || !scanWorkstage) return;
    setBusy(true);
    try {
      await api.delete('/quality/wqc/cancel', {
        data: { serialNo: lastPid, lineCode: scanLine, workstageCode: scanWorkstage },
      });
      toast.success('최신 검사 1건을 취소했습니다.');
      void loadPid(lastPid);
    } catch {
      toast.error('취소할 검사내역이 없습니다.');
    } finally {
      setBusy(false);
    }
  }, [lastPid, scanLine, scanWorkstage, loadPid]);

  const columns = useMemo(() => wqcColumns, []);

  return (
    <main className="flex h-full min-w-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <ClipboardCheck className="h-6 w-6 text-primary" />공정품질검사이력관리
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            PID 를 스캔해 공정 품질검사를 등록하고 이력을 조회합니다 ·{' '}
            {searched ? `${rows.length}/${total}건` : '기간을 정하고 조회하세요'}
          </p>
        </div>
        <Button size="sm" onClick={search} disabled={loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-end gap-3 p-3">
          <div className="flex items-center gap-2 self-center">
            <ScanLine className="h-5 w-5 text-primary" />
            <span className="text-sm font-semibold text-text">검사 등록</span>
          </div>
          <label className="text-xs text-text-muted">
            라인 (필수)
            <LineSelect value={scanLine}
              onChange={setScanLine} className="w-40" />
          </label>
          <label className="text-xs text-text-muted">
            공정 (필수)
            <ProcessSelect value={scanWorkstage}
              onChange={setScanWorkstage} className="w-44" />
          </label>
          <label className="text-xs text-text-muted">
            판정
            <ComCodeSelect groupCode="REPAIR RESULT" includeAll={false}
              value={badReasonCode} onChange={setBadReasonCode} className="w-32" />
          </label>
          <label className="text-xs text-text-muted">
            설비코드
            <Input value={machineCode} className="w-32"
              onChange={(e) => setMachineCode(e.target.value)} />
          </label>
          <label className="text-xs text-text-muted">
            비고
            <Input value={comments} className="w-48"
              onChange={(e) => setComments(e.target.value)} />
          </label>
          <label className="text-xs text-text-muted">
            PID 스캔
            <Input
              ref={scanRef}
              autoFocus
              placeholder="PID 를 스캔하세요"
              value={barcode}
              disabled={busy}
              className="w-56"
              onChange={(e) => setBarcode(e.target.value)}
              onKeyDown={(e) => { if (e.key === 'Enter') void scan(); }}
            />
          </label>
          <Button size="sm" variant="secondary" disabled={!lastPid || busy}
            onClick={() => setCancelOpen(true)}>
            <Trash2 className="mr-1 h-4 w-4 text-red-500" />최신 검사 취소
          </Button>
        </CardContent>
      </Card>

      {lastPid && (
        <Card padding="none" className="h-44 shrink-0 overflow-hidden">
          <CardContent className="flex h-full flex-col p-3">
            <b className="mb-2 text-sm text-text">스캔한 PID 검사내역 — {lastPid}</b>
            <div className="min-h-0 flex-1">
              <DataGrid
                data={pidRows}
                columns={columns}
                isLoading={pidLoading}
                pageSize={20}
                emptyMessage="검사내역이 없습니다."
                getRowId={(row) => {
                  const w = row as WqcRow;
                  return `${w.inspectDate}|${w.inspectSequence}`;
                }}
              />
            </div>
          </CardContent>
        </Card>
      )}

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="검사일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <LineSelect labelPrefix="라인" value={lineCode} onChange={setLineCode} className="w-40" />
          <ProcessSelect labelPrefix="공정" value={workstageCode}
            onChange={setWorkstageCode} className="w-44" />
          <Input aria-label="모델명" placeholder="모델명" value={modelName}
            className="w-44" onChange={(e) => setModelName(e.target.value)} />
          <Input aria-label="PID" placeholder="PID" value={serialNo}
            className="w-48" onChange={(e) => setSerialNo(e.target.value)} />
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
            exportFileName="공정품질검사이력"
            emptyMessage="조회 버튼을 눌러 이력을 확인하세요."
            getRowId={(row) => {
              const w = row as WqcRow;
              return `${w.inspectDate}|${w.inspectSequence}`;
            }}
          />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={cancelOpen}
        onClose={() => setCancelOpen(false)}
        onConfirm={cancel}
        title="검사 취소"
        message={`${lastPid} 의 ${scanLine} / ${scanWorkstage} 공정 검사 중 가장 최근 1건을 지웁니다.`}
        variant="danger"
      />
    </main>
  );
}
