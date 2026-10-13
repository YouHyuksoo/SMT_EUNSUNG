"use client";

/**
 * @file src/app/(authenticated)/quality/product-destroy/page.tsx
 * @description 공정폐기관리 — PB w_pln_product_pcb_destroy_master 이식
 *
 * 초보자 가이드:
 * 1. **폐기등록 모드**: 시리얼을 스캔해 목록에 쌓고 불량사유·부서를 고른 뒤 실행하면 시리얼마다
 *    IP_PRODUCT_WORK_QC 에 검사처리 'D'(폐기) 행이 1건 쌓인다. 행 삭제가 아니다.
 * 2. **반품/반품취소**: 폐기 행의 불량구분을 1(입고) ↔ 2(반품) 로 토글한다.
 * 3. **이력조회 모드**: 검사처리 'D' 만 모아 본다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { RotateCcw, Search, Trash2, X } from 'lucide-react';
import { Button, Card, CardContent, ConfirmModal } from '@/components/ui';
import BarcodeScanInput from '@/components/shared/BarcodeScanInput';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DepartmentSelect from '@/components/shared/DepartmentSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ScreenTabs from '@/components/shared/ScreenTabs';
import LineSelect from '@/components/shared/LineSelect';
import ModelSearchField from '@/components/shared/ModelSearchField';
import ProcessSelect from '@/components/shared/ProcessSelect';
import DataGrid from '@/components/data-grid/DataGrid';
import api from '@/services/api';
import { destroyHistoryColumns, serialColumns } from './columns';
import type { DestroyResponse, ProductDestroyMode, ProductDestroyRow } from './types';

import { getTodayLocal } from '@/utils/date';
const today = () => getTodayLocal();
const parseSerials = (text: string) => text.split(/[\s,;]+/).map(s => s.trim().toUpperCase()).filter(Boolean);

export default function ProductDestroyPage() {
  const [mode, setMode] = useState<ProductDestroyMode>('DESTROY');
  const [loading, setLoading] = useState(false);
  const [running, setRunning] = useState(false);
  const [confirmOpen, setConfirmOpen] = useState(false);

  // 폐기등록 모드
  const [serials, setSerials] = useState<string[]>([]);
  const [badReasonCode, setBadReasonCode] = useState('');
  const [departmentCode, setDepartmentCode] = useState('');
  const [fallbackLineCode, setFallbackLineCode] = useState('');
  const [fallbackWorkstageCode, setFallbackWorkstageCode] = useState('');
  const [destroyList, setDestroyList] = useState<ProductDestroyRow[]>([]);
  const [issueList, setIssueList] = useState<ProductDestroyRow[]>([]);
  const [outcome, setOutcome] = useState<DestroyResponse | null>(null);
  const [selectedDestroy, setSelectedDestroy] = useState<ProductDestroyRow | null>(null);
  const [selectedIssue, setSelectedIssue] = useState<ProductDestroyRow | null>(null);

  // 이력조회 모드
  const [rows, setRows] = useState<ProductDestroyRow[]>([]);
  const [total, setTotal] = useState(0);
  const [searched, setSearched] = useState(false);
  const [serialNo, setSerialNo] = useState('');
  const [modelName, setModelName] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');
  const [dateFrom, setDateFrom] = useState(today);
  const [dateTo, setDateTo] = useState(today);

  const loadSerial = useCallback(async (target: string) => {
    if (!target) return;
    try {
      const response = await api.get('/quality/product-destroy/serial', { params: { serialNo: target } });
      setDestroyList(response.data?.data?.destroyList ?? []);
      setIssueList(response.data?.data?.issueList ?? []);
    } catch {
      setDestroyList([]);
      setIssueList([]);
    }
  }, []);

  // 스캔 한 번에 시리얼 하나가 들어오지만, 여러 개를 붙여넣어도 나눠서 쌓는다
  const addSerials = useCallback(async (value: string) => {
    const scanned = parseSerials(value);
    if (scanned.length === 0) return;
    setSerials(prev => [...prev, ...scanned.filter(s => !prev.includes(s))]);
    await loadSerial(scanned[scanned.length - 1]);
  }, [loadSerial]);

  const searchHistory = useCallback(async (scannedSerial?: string) => {
    const serial = scannedSerial ?? serialNo;
    setLoading(true);
    try {
      const response = await api.get('/quality/product-destroy/history', {
        params: {
          limit: '5000',
          serialNo: serial || undefined,
          modelName: modelName || undefined,
          lineCode: lineCode || undefined,
          workstageCode: workstageCode || undefined,
          dateFrom: dateFrom || undefined,
          dateTo: dateTo || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
    } catch {
      setRows([]);
      setTotal(0);
      toast.error('폐기이력 조회에 실패했습니다');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, lineCode, modelName, serialNo, workstageCode]);

  const runDestroy = useCallback(async () => {
    setRunning(true);
    try {
      const response = await api.post('/quality/product-destroy', {
        badReasonCode,
        departmentCode,
        fallbackLineCode: fallbackLineCode || undefined,
        fallbackWorkstageCode: fallbackWorkstageCode || undefined,
        serialNos: serials,
      });
      const result: DestroyResponse = response.data?.data;
      setOutcome(result);
      toast.success(`폐기 ${result.ok}건 · 건너뜀 ${result.skip}건 · 실패 ${result.fail}건`);
      setConfirmOpen(false);
      if (serials.length > 0) await loadSerial(serials[0]);
    } catch (error: unknown) {
      const apiMessage = (error as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(apiMessage || '폐기 등록에 실패했습니다');
    } finally {
      setRunning(false);
    }
  }, [badReasonCode, departmentCode, fallbackLineCode, fallbackWorkstageCode, loadSerial, serials]);

  const toggleIssue = useCallback(async (path: 'issue' | 'issue-cancel', row: ProductDestroyRow | null) => {
    if (!row) return;
    try {
      await api.post(`/quality/product-destroy/${path}`, { serialNo: row.serialNo, qcSequence: row.qcSequence });
      toast.success(path === 'issue' ? '반품 처리했습니다' : '반품을 취소했습니다');
      await loadSerial(row.serialNo);
      setSelectedDestroy(null);
      setSelectedIssue(null);
    } catch (error: unknown) {
      const apiMessage = (error as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(apiMessage || '처리에 실패했습니다');
    }
  }, [loadSerial]);

  return (
    <main className="flex h-full min-w-0 flex-col gap-3 p-5">
      <header>
        <h1 className="flex items-center gap-2 text-xl font-bold text-text">
          <Trash2 className="h-6 w-6 text-primary" />공정폐기관리
        </h1>
        <p className="mt-1 text-sm text-text-muted">
          시리얼별 공정 폐기를 등록하고 반품 여부를 관리합니다 · 폐기는 삭제가 아니라 검사처리 D 이력으로 쌓인다
        </p>
      </header>

      <ScreenTabs
        tabs={[
          { key: 'DESTROY', label: '폐기등록' },
          { key: 'HISTORY', label: '폐기이력', count: searched ? total : undefined },
        ]}
        active={mode}
        onChange={setMode}
      />

      {mode === 'DESTROY' ? (
        <>
          <Card className="shrink-0" padding="sm">
            <div className="flex flex-wrap items-center gap-2">
              <BarcodeScanInput aria-label="시리얼 스캔" placeholder="시리얼 스캔" autoClear onScan={addSerials} className="w-52" />
              <ComCodeSelect groupCode="BAD REASON CODE" includeAll={false} aria-label="불량사유" placeholder="불량사유 선택" value={badReasonCode} onChange={value => setBadReasonCode(value)} className="w-40" />
              <DepartmentSelect aria-label="부서" placeholder="부서 선택" value={departmentCode} onChange={value => setDepartmentCode(value)} className="w-36" />
              <LineSelect aria-label="라인(대체값)" labelPrefix="라인" value={fallbackLineCode} onChange={value => setFallbackLineCode(value)} className="w-36" />
              <ProcessSelect aria-label="공정(대체값)" labelPrefix="공정" value={fallbackWorkstageCode} onChange={value => setFallbackWorkstageCode(value)} className="w-40" />
              <Button size="sm" onClick={() => setConfirmOpen(true)} disabled={serials.length === 0 || !badReasonCode || !departmentCode || running}>
                <Trash2 className="mr-1 h-4 w-4" />폐기 실행
              </Button>
              <Button variant="secondary" size="sm" onClick={() => { setSerials([]); setOutcome(null); setDestroyList([]); setIssueList([]); }}>
                <RotateCcw className="mr-1 h-4 w-4" />초기화
              </Button>
            </div>
            <div className="mt-2 flex max-h-20 flex-wrap items-center gap-1 overflow-y-auto text-xs">
              <span className="mr-1 text-text-muted">스캔 {serials.length}건</span>
              {serials.map(serial => (
                <span key={serial} className="flex items-center gap-1 rounded border border-border bg-surface px-1.5 py-0.5 font-mono text-text">
                  <button type="button" data-tooltip="이 시리얼의 폐기·반품 현황 보기" onClick={() => loadSerial(serial)} className="hover:text-primary">{serial}</button>
                  <button type="button" aria-label={`${serial} 빼기`} onClick={() => setSerials(prev => prev.filter(s => s !== serial))} className="text-text-muted hover:text-red-600">
                    <X className="h-3 w-3" />
                  </button>
                </span>
              ))}
            </div>
            {outcome && (
              <div className="mt-2 flex flex-wrap gap-3 text-sm">
                <span className="text-emerald-600">성공 {outcome.ok}</span>
                <span className="text-amber-600">건너뜀 {outcome.skip}</span>
                <span className="text-red-600">실패 {outcome.fail}</span>
                {outcome.results.filter(r => r.status !== 'OK').slice(0, 5).map(r => (
                  <span key={r.serialNo} className="text-text-muted">{r.serialNo}: {r.reason}</span>
                ))}
              </div>
            )}
          </Card>

          <div className="flex min-h-0 flex-1 gap-3">
            <Card className="flex min-h-0 flex-1 flex-col overflow-hidden" padding="none">
              <div className="flex items-center justify-between border-b border-border px-3 py-2">
                <span className="text-sm font-semibold text-text">폐기 목록 (불량구분 1)</span>
                <Button size="sm" variant="secondary" onClick={() => toggleIssue('issue', selectedDestroy)} disabled={!selectedDestroy}>반품 처리</Button>
              </div>
              <CardContent className="min-h-0 flex-1 p-3">
                <DataGrid data={destroyList} columns={serialColumns} pageSize={20}
                  getRowId={row => String(row.qcSequence)} selectedRowId={selectedDestroy ? String(selectedDestroy.qcSequence) : undefined}
                  onRowClick={row => setSelectedDestroy(row)} emptyMessage="시리얼을 조회하세요." />
              </CardContent>
            </Card>
            <Card className="flex min-h-0 flex-1 flex-col overflow-hidden" padding="none">
              <div className="flex items-center justify-between border-b border-border px-3 py-2">
                <span className="text-sm font-semibold text-text">반품 목록 (불량구분 2)</span>
                <Button size="sm" variant="secondary" onClick={() => toggleIssue('issue-cancel', selectedIssue)} disabled={!selectedIssue}>반품 취소</Button>
              </div>
              <CardContent className="min-h-0 flex-1 p-3">
                <DataGrid data={issueList} columns={serialColumns} pageSize={20}
                  getRowId={row => String(row.qcSequence)} selectedRowId={selectedIssue ? String(selectedIssue.qcSequence) : undefined}
                  onRowClick={row => setSelectedIssue(row)} emptyMessage="반품 처리된 건이 없습니다." />
              </CardContent>
            </Card>
          </div>
        </>
      ) : (
        <>
          <Card className="shrink-0" padding="sm">
            <div className="flex flex-wrap items-center gap-2">
              <BarcodeScanInput aria-label="PCB 시리얼" placeholder="시리얼 스캔" value={serialNo} onChange={setSerialNo} onScan={searchHistory} className="w-44" />
              <ModelSearchField value={modelName} onChange={(v) => setModelName(v)} className="w-40" aria-label="모델명" placeholder="모델명" />
              <LineSelect aria-label="라인" labelPrefix="라인" value={lineCode} onChange={value => setLineCode(value)} className="w-40" />
              <ProcessSelect aria-label="공정" labelPrefix="공정" value={workstageCode} onChange={value => setWorkstageCode(value)} className="w-44" />
              <DateRangeFilter label="폐기일자" from={dateFrom} to={dateTo} onFromChange={setDateFrom} onToChange={setDateTo} />
              <Button size="sm" onClick={() => searchHistory()} disabled={loading}>
                <Search className="mr-1 h-4 w-4" />조회
              </Button>
              <span className="text-sm text-text-muted">{searched ? `${rows.length}/${total}건` : '조회조건을 입력하세요'}</span>
            </div>
          </Card>
          <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
            <CardContent className="h-full p-3">
              <DataGrid data={rows} columns={destroyHistoryColumns} isLoading={loading} pageSize={50}
                enableColumnFilter enableExport exportFileName="공정폐기이력"
                emptyMessage={searched ? '조회 결과가 없습니다.' : '조회 버튼을 눌러 폐기이력을 확인하세요.'} />
            </CardContent>
          </Card>
        </>
      )}

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={runDestroy}
        isLoading={running}
        variant="danger"
        title="공정폐기"
        confirmText="폐기 실행"
        message={
          <span>
            시리얼 <strong>{serials.length}</strong>건을 폐기 처리합니다.
            <br />
            각 시리얼마다 검사처리 <strong>D(폐기)</strong> 이력이 1건 생성됩니다. 이미 폐기된 시리얼은 건너뜁니다.
          </span>
        }
      />
    </main>
  );
}
