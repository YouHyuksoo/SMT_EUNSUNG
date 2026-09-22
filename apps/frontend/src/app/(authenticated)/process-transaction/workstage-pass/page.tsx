"use client";

import { useCallback, useMemo, useRef, useState } from 'react';
import toast from 'react-hot-toast';
import { GitPullRequestArrow, RefreshCw, ScanLine, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import LineSelect from '@/components/shared/LineSelect';
import ProcessSelect from '@/components/shared/ProcessSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { workstagePassColumns } from './columns';
import type { WorkstagePassMode, WorkstagePassRow } from './types';

const iso = (date: Date) => date.toISOString().slice(0, 10);
const modeLabels: Record<WorkstagePassMode, string> = { wait: '입고대기', history: '통과이력', inventory: '재공현황', today: '당일현황', workstageSummary: '공정집계' };

export default function WorkstagePassPage() {
  const pidRef = useRef<HTMLInputElement>(null);
  const [rows, setRows] = useState<WorkstagePassRow[]>([]); const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false); const [searched, setSearched] = useState(false);
  const [mode, setMode] = useState<WorkstagePassMode>('history'); const [pid, setPid] = useState('');
  const [lineCode, setLineCode] = useState(''); const [workstageCode, setWorkstageCode] = useState('');
  const [modelName, setModelName] = useState(''); const [serialNo, setSerialNo] = useState('');
  const [dateFrom, setDateFrom] = useState(() => iso(new Date())); const [dateTo, setDateTo] = useState(() => iso(new Date()));
  const [cancel, setCancel] = useState(false); const [rework, setRework] = useState(false); const [confirmPid, setConfirmPid] = useState<string | null>(null);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/process-transaction/workstage-pass', { params: { mode, lineCode: lineCode || undefined, workstageCode: workstageCode || undefined, modelName: modelName || undefined, serialNo: serialNo || undefined, dateFrom, dateTo, limit: 5000 } });
      setRows(response.data?.data ?? []); setTotal(Number(response.data?.meta?.total ?? 0)); setSearched(true);
    } catch { setRows([]); setTotal(0); toast.error('공정통과이력 조회에 실패했습니다.'); }
    finally { setLoading(false); }
  }, [dateFrom, dateTo, lineCode, mode, modelName, serialNo, workstageCode]);

  const submitScan = useCallback(async (scanPid: string) => {
    if (!lineCode || !workstageCode) { toast.error('라인과 공정을 선택하세요.'); return; }
    setLoading(true);
    try {
      const response = await api.post('/process-transaction/workstage-pass/scan', { pid: scanPid, lineCode, workstageCode, cancel, rework });
      toast.success(response.data?.data?.action === 'cancel' || cancel ? '최근 공정통과를 취소했습니다.' : '공정통과를 등록했습니다.');
      setPid(''); setConfirmPid(null); await search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } }).response?.data?.message;
      toast.error(message || '공정통과 처리에 실패했습니다.');
    } finally { setLoading(false); pidRef.current?.focus(); }
  }, [cancel, lineCode, rework, search, workstageCode]);

  const requestScan = () => { const value = pid.trim(); if (!value) return; if (cancel) setConfirmPid(value); else void submitScan(value); };
  const columns = useMemo(() => workstagePassColumns(mode), [mode]);

  return <main className="flex h-full min-w-0 flex-col gap-3 p-5">
    <header className="flex items-center justify-between gap-4"><div><h1 className="flex items-center gap-2 text-xl font-bold text-text"><GitPullRequestArrow className="h-6 w-6 text-primary" />공정통과이력 관리</h1><p className="mt-1 text-sm text-text-muted">PB W_PLN_PRODUCT_INOUT_SCAN_MASTER 기준 · {searched ? `${rows.length}/${total}건` : '라인·공정을 선택하고 PID를 스캔하세요'}</p></div><div className="flex gap-2"><Button variant="secondary" size="sm" onClick={search} disabled={loading}><RefreshCw className={`mr-1 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />새로고침</Button><Button size="sm" onClick={search} disabled={loading}><Search className="mr-1 h-4 w-4" />조회</Button></div></header>
    <Card padding="sm"><div className="flex flex-wrap items-center gap-2"><LineSelect labelPrefix="라인" value={lineCode} onChange={setLineCode} className="w-40" /><ProcessSelect labelPrefix="공정" value={workstageCode} onChange={setWorkstageCode} className="w-44" /><Input ref={pidRef} aria-label="PID 스캔" placeholder="PID 또는 매거진 라벨 스캔" value={pid} onChange={e => setPid(e.target.value)} onKeyDown={e => { if (e.key === 'Enter') requestScan(); }} className="w-64" /><Button onClick={requestScan} disabled={loading || !pid.trim()} variant={cancel ? 'danger' : 'primary'}><ScanLine className="mr-1 h-4 w-4" />{cancel ? '통과취소' : '통과등록'}</Button><label className="flex items-center gap-1 text-sm"><input type="checkbox" checked={cancel} onChange={e => setCancel(e.target.checked)} />취소</label><label className="flex items-center gap-1 text-sm"><input type="checkbox" checked={rework} onChange={e => setRework(e.target.checked)} />재작업 허용</label></div></Card>
    <Card padding="sm"><div className="flex flex-wrap items-center gap-2"><Input aria-label="모델명" placeholder="모델명" value={modelName} onChange={e => setModelName(e.target.value)} className="w-40" /><Input aria-label="시리얼번호" placeholder="시리얼번호" value={serialNo} onChange={e => setSerialNo(e.target.value)} className="w-44" /><Input aria-label="시작일" type="date" value={dateFrom} onChange={e => setDateFrom(e.target.value)} className="w-40" /><span>~</span><Input aria-label="종료일" type="date" value={dateTo} onChange={e => setDateTo(e.target.value)} className="w-40" /><div className="flex rounded-md border border-border p-0.5">{(Object.keys(modeLabels) as WorkstagePassMode[]).map(value => <button key={value} type="button" onClick={() => setMode(value)} className={`rounded px-3 py-1.5 text-sm ${mode === value ? 'bg-primary text-white' : 'text-text-muted'}`}>{modeLabels[value]}</button>)}</div></div></Card>
    <Card className="min-h-0 flex-1 overflow-hidden" padding="none"><CardContent className="h-full p-3"><DataGrid data={rows} columns={columns} isLoading={loading} pageSize={50} enableColumnFilter enableExport exportFileName="공정통과이력" emptyMessage={searched ? '조회 결과가 없습니다.' : '조회 버튼을 눌러 공정통과이력을 확인하세요.'} /></CardContent></Card>
    <ConfirmModal isOpen={confirmPid !== null} onClose={() => setConfirmPid(null)} onConfirm={() => { if (confirmPid) void submitScan(confirmPid); }} title="공정통과 취소" message={`${confirmPid ?? ''}의 현재 공정통과 이력을 취소하시겠습니까?`} confirmText="통과취소" variant="danger" isLoading={loading} />
  </main>;
}
