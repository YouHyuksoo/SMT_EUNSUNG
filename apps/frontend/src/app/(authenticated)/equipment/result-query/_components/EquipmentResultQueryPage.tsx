"use client";

import { useCallback, useMemo, useState } from 'react';
import type { ColumnDef } from '@tanstack/react-table';
import { ClipboardList, RefreshCw, Search } from 'lucide-react';
import toast from 'react-hot-toast';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ProdLineSelect from '@/components/shared/ProdLineSelect';
import { Button, Card, CardContent, Input, Select } from '@/components/ui';
import api from '@/services/api';
import type { ResultQueryDefinition } from '../_lib/result-query-definitions';

type ResultRow = Record<string, unknown>;
const today = () => new Date().toISOString().slice(0, 10);
const monthAgo = () => { const date = new Date(); date.setMonth(date.getMonth() - 1); return date.toISOString().slice(0, 10); };
const resultOptions = ['', 'OK', 'NG', 'USEROK', 'USERNG'].map(value => ({ value, label: value || '전체 결과' }));
const formatValue = (value: unknown) => value instanceof Date ? value.toLocaleString('ko-KR') : value == null ? '' : String(value);

export default function EquipmentResultQueryPage({ definition }: { definition: ResultQueryDefinition }) {
  const [rows, setRows] = useState<ResultRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [dateFrom, setDateFrom] = useState(monthAgo);
  const [dateTo, setDateTo] = useState(today);
  const [lineCode, setLineCode] = useState('');
  const [pid, setPid] = useState('');
  const [modelName, setModelName] = useState('');
  const [runNo, setRunNo] = useState('');
  const [result, setResult] = useState('');
  const [reviewResult, setReviewResult] = useState('');
  const [jobFile, setJobFile] = useState('');

  const columns = useMemo<ColumnDef<ResultRow>[]>(() => definition.columns.map(column => ({
    accessorKey: column.key,
    header: column.label,
    size: column.width ?? 130,
    cell: ({ getValue }) => formatValue(getValue()),
  })), [definition.columns]);

  const search = useCallback(async () => {
    if (dateFrom > dateTo) { toast.error('시작일은 종료일보다 늦을 수 없습니다.'); return; }
    setLoading(true);
    try {
      const response = await api.get(`/equipment/result-queries/${definition.type}`, { params: {
        dateFrom, dateTo, lineCode: lineCode || undefined, pid: pid || undefined,
        modelName: modelName || undefined, runNo: runNo || undefined,
        result: result || undefined, reviewResult: reviewResult || undefined,
        jobFile: jobFile || undefined, limit: 5000,
      } });
      setRows(response.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      setRows([]);
      toast.error(error instanceof Error ? error.message : `${definition.title} 조회에 실패했습니다.`);
    } finally { setLoading(false); }
  }, [dateFrom, dateTo, definition.title, definition.type, jobFile, lineCode, modelName, pid, result, reviewResult, runNo]);

  return <main className="flex h-full min-w-0 flex-col gap-3 p-5">
    <header className="flex items-center justify-between gap-4">
      <div><h1 className="flex items-center gap-2 text-xl font-bold text-text"><ClipboardList className="h-6 w-6 text-primary" />{definition.title}</h1><p className="mt-1 text-sm text-text-muted">{definition.table} · {definition.pbWindow} · {searched ? `${rows.length.toLocaleString()}건` : '조회조건을 입력하세요'}</p></div>
      <div className="flex gap-2"><Button variant="secondary" size="sm" onClick={search} disabled={loading}><RefreshCw className={`mr-1 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />새로고침</Button><Button size="sm" onClick={search} disabled={loading}><Search className="mr-1 h-4 w-4" />조회</Button></div>
    </header>
    <Card className="shrink-0" padding="sm"><div className="flex flex-wrap items-center gap-2">
      <DateRangeFilter label="기간" from={dateFrom} to={dateTo} onFromChange={setDateFrom} onToChange={setDateTo} />
      {definition.filters.line ? <ProdLineSelect includeAll value={lineCode} onChange={setLineCode} className="w-40" /> : null}
      {definition.filters.pid ? <Input aria-label={definition.filters.pid} placeholder={definition.filters.pid} value={pid} onChange={event => setPid(event.target.value)} className="w-44" /> : null}
      {definition.filters.model ? <Input aria-label="모델명" placeholder="모델명" value={modelName} onChange={event => setModelName(event.target.value)} className="w-40" /> : null}
      {definition.filters.runNo ? <Input aria-label="작업지시" placeholder="작업지시" value={runNo} onChange={event => setRunNo(event.target.value)} className="w-40" /> : null}
      {definition.filters.jobFile ? <Input aria-label="Job File" placeholder="Job File" value={jobFile} onChange={event => setJobFile(event.target.value)} className="w-44" /> : null}
      {definition.filters.result ? <Select aria-label="검사결과" options={resultOptions} value={result} onChange={setResult} className="w-36" /> : null}
      {definition.filters.review ? <Select aria-label="리뷰결과" options={resultOptions} value={reviewResult} onChange={setReviewResult} className="w-36" /> : null}
    </div></Card>
    <Card className="min-h-0 flex-1 overflow-hidden" padding="none"><CardContent className="h-full p-3"><DataGrid data={rows} columns={columns} isLoading={loading} pageSize={50} enableColumnFilter enableExport exportFileName={definition.title} emptyMessage={searched ? '조회 결과가 없습니다.' : '조회 버튼을 눌러 결과를 확인하세요.'} /></CardContent></Card>
  </main>;
}
