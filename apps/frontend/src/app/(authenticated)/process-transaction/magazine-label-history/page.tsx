"use client";

import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { History, RefreshCw, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import ProcessSelect from '@/components/shared/ProcessSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { magazineLabelColumns } from './columns';
import { matrixColumnKeys, pivotMagazineMatrix } from './matrix';
import type { MagazineLabelHistoryRow, MagazineLabelViewMode } from './types';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const monthAgo = () => { const date = new Date(); date.setMonth(date.getMonth() - 1); return isoDate(date); };

export default function MagazineLabelHistoryPage() {
  const [rows, setRows] = useState<MagazineLabelHistoryRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [viewMode, setViewMode] = useState<MagazineLabelViewMode>('history');
  const [lineCode, setLineCode] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [magazineLabelNo, setMagazineLabelNo] = useState('');
  const [runNo, setRunNo] = useState('');
  const [dateFrom, setDateFrom] = useState(monthAgo);
  const [dateTo, setDateTo] = useState(today);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/process-transaction/magazine-label-history', { params: {
        viewMode, lineCode: lineCode || undefined, workstageCode: workstageCode || undefined,
        modelName: modelName || undefined, magazineLabelNo: magazineLabelNo || undefined,
        runNo: runNo || undefined, dateFrom, dateTo, limit: 5000,
      } });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
    } catch {
      setRows([]); setTotal(0); toast.error('매거진발행이력 조회에 실패했습니다');
    } finally { setLoading(false); }
  }, [dateFrom, dateTo, lineCode, magazineLabelNo, modelName, runNo, viewMode, workstageCode]);

  const lotQty = useMemo(() => rows.reduce((sum, row) => sum + Number(row.lotQty ?? 0), 0), [rows]);
  const displayedRows = useMemo(() => viewMode === 'matrix' ? pivotMagazineMatrix(rows) : rows, [rows, viewMode]);
  const columns = useMemo(() => magazineLabelColumns(viewMode, viewMode === 'matrix' ? matrixColumnKeys(rows) : []), [rows, viewMode]);

  return <main className="flex h-full min-w-0 flex-col gap-3 p-5">
    <header className="flex items-center justify-between gap-4">
      <div><h1 className="flex items-center gap-2 text-xl font-bold text-text"><History className="h-6 w-6 text-primary" />매거진발행이력</h1>
        <p className="mt-1 text-sm text-text-muted">PB W_PLN_PRODUCT_MAGAZINE_LABEL_QUERY 기준 · {searched ? `${rows.length}/${total}건` : '조회조건을 입력하세요'}</p></div>
      <div className="flex gap-2"><Button variant="secondary" size="sm" onClick={search} disabled={loading}><RefreshCw className={`mr-1 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />새로고침</Button><Button size="sm" onClick={search} disabled={loading}><Search className="mr-1 h-4 w-4" />조회</Button></div>
    </header>
    <Card className="shrink-0" padding="sm"><div className="flex flex-wrap items-center gap-2">
      <LineSelect labelPrefix="라인" value={lineCode} onChange={setLineCode} className="w-40" />
      <ProcessSelect labelPrefix="공정" value={workstageCode} onChange={setWorkstageCode} className="w-44" />
      <Input aria-label="모델명" placeholder="모델명" value={modelName} onChange={e => setModelName(e.target.value)} className="w-40" />
      <Input aria-label="매거진 라벨번호" placeholder="매거진 라벨번호" value={magazineLabelNo} onChange={e => setMagazineLabelNo(e.target.value)} className="w-48" />
      <Input aria-label="RUN NO" placeholder="RUN NO" value={runNo} onChange={e => setRunNo(e.target.value)} className="w-40" />
      <DateRangeFilter label="발행일" from={dateFrom} to={dateTo} onFromChange={setDateFrom} onToChange={setDateTo} />
    </div></Card>
    <nav className="flex flex-wrap gap-1 border-b border-border" aria-label="조회 모드">
      {([['history', '이력'], ['summary', '집계'], ['matrix', '매트릭스']] as const).map(([value, label]) => (
        <button
          key={value}
          type="button"
          onClick={() => setViewMode(value)}
          aria-current={viewMode === value ? 'page' : undefined}
          className={`px-4 py-2 text-sm font-medium transition-colors ${
            viewMode === value ? 'border-b-2 border-primary text-primary' : 'text-text-muted hover:text-text'
          }`}
        >
          {label}
        </button>
      ))}
    </nav>
    <div className="text-sm text-text-muted">수량 합계: <strong className="text-text">{lotQty.toLocaleString(undefined, { maximumFractionDigits: 3 })}</strong></div>
    <Card className="min-h-0 flex-1 overflow-hidden" padding="none"><CardContent className="h-full p-3"><DataGrid data={displayedRows} columns={columns} isLoading={loading} pageSize={50} enableColumnFilter enableExport exportFileName="매거진발행이력" emptyMessage={searched ? '조회 결과가 없습니다.' : '조회 버튼을 눌러 발행이력을 확인하세요.'} /></CardContent></Card>
  </main>;
}
