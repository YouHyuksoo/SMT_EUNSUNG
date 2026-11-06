"use client";

/**
 * @file src/app/(authenticated)/quality/product-destroy/page.tsx
 * @description 공정폐기관리 — PB w_pln_product_pcb_destroy_master 이식
 *
 * 초보자 가이드:
 * 1. **폐기등록 모드**: 시리얼을 스캔해 목록에 쌓고 불량사유·부서를 고른 뒤 실행하면 시리얼마다
 *    공정폐기 원장(IP_PRODUCT_DESTROY)에 폐기보관(D) 1건이 쌓인다. 수리판정(IP_PRODUCT_WORK_QC)과는 따로다.
 * 2. **반품/반품취소**: 원장 상태를 폐기보관(D) ↔ 반품(R) 으로 바꾼다.
 * 3. **이력조회 모드**: 원장을 상태(폐기보관·반품·취소)별로 본다.
 * 4. **팀별 양식 (26.10.22 요청)**: 생산1팀(SMT)·생산2팀(조립)마다 불량유형·공정 칸이 다르다 (DestroyDetailFields).
 * 5. **품번 + 수량**: 바코드 미각인 제품은 품번과 수량으로 등록한다. 시리얼이 바코드 이력에 없을 때도 고른 품번을 쓴다.
 * 6. **폐기 취소**: 잘못 등록한 폐기를 골라 취소(C)로 바꾼다. 행은 지우지 않고 취소일시·취소자·사유를 남긴다.
 *    취소된 건은 폐기현황 집계에서 빠지고, 같은 시리얼을 다시 폐기할 수 있다.
 * 7. **폐기현황 탭**: 팀별 월 불량유형·주야·원인별 수량/금액. **LCR 폐기 탭**: LCR 측정 자재 폐기 등록·월 집계.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Ban, Plus, RotateCcw, Search, Trash2, X } from 'lucide-react';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import BarcodeScanInput from '@/components/shared/BarcodeScanInput';
import DepartmentSelect from '@/components/shared/DepartmentSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ScreenTabs from '@/components/shared/ScreenTabs';
import LineSelect from '@/components/shared/LineSelect';
import ModelSearchField from '@/components/shared/ModelSearchField';
import ProcessSelect from '@/components/shared/ProcessSelect';
import PartSearchField from '@/components/shared/PartSearchField';
import QtyInput from '@/components/shared/QtyInput';
import DataGrid from '@/components/data-grid/DataGrid';
import api from '@/services/api';
import { selectColumn } from '../../purchase/purchase-columns';
import { destroyHistoryColumns, serialColumns } from './columns';
import type { DestroyItemEntry, DestroyResponse, DestroyTeam, ProductDestroyMode, ProductDestroyRow } from './types';
import DestroyDetailFields, { emptyDetail, isDetailComplete, type DestroyDetail } from './components/DestroyDetailFields';
import DestroySummaryTab from './components/DestroySummaryTab';
import LcrDestroyTab from './components/LcrDestroyTab';

import { getTodayLocal } from '@/utils/date';
const today = () => getTodayLocal();
const parseSerials = (text: string) => text.split(/[\s,;]+/).map(s => s.trim().toUpperCase()).filter(Boolean);

export default function ProductDestroyPage() {
  const [mode, setMode] = useState<ProductDestroyMode>('DESTROY');
  const [loading, setLoading] = useState(false);
  const [running, setRunning] = useState(false);
  const [confirmOpen, setConfirmOpen] = useState(false);

  // 폐기등록 모드
  const [team, setTeam] = useState<DestroyTeam>('1');
  const [detail, setDetail] = useState<DestroyDetail>(emptyDetail);
  const [serials, setSerials] = useState<string[]>([]);
  const [items, setItems] = useState<DestroyItemEntry[]>([]);
  const [itemCode, setItemCode] = useState('');
  const [itemQty, setItemQty] = useState(1);
  const [departmentCode, setDepartmentCode] = useState('');
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
  const [status, setStatus] = useState('');
  const [checked, setChecked] = useState<Set<number>>(new Set());
  const [cancelOpen, setCancelOpen] = useState(false);
  const [cancelReason, setCancelReason] = useState('');
  const [cancelling, setCancelling] = useState(false);

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

  // 팀마다 불량유형·공정 코드가 달라 팀을 바꾸면 그 칸들을 비운다
  const changeTeam = useCallback((next: DestroyTeam) => {
    setTeam(next);
    setDetail(prev => ({ ...prev, badReasonCode: '', detectProcessCode: '', occurProcessCode: '', badCategory: '', causeBy: 'M' }));
  }, []);

  const addItem = useCallback(() => {
    const code = itemCode.trim();
    if (!code || itemQty < 1) return;
    setItems(prev => [...prev.filter(i => i.itemCode !== code), { itemCode: code, qty: itemQty }]);
    setItemCode('');
    setItemQty(1);
  }, [itemCode, itemQty]);

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
          status: status || undefined,
          dateFrom: dateFrom || undefined,
          dateTo: dateTo || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setChecked(new Set());
    } catch {
      setRows([]);
      setTotal(0);
      setChecked(new Set());
      toast.error('폐기이력 조회에 실패했습니다');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, lineCode, modelName, serialNo, status, workstageCode]);

  const runDestroy = useCallback(async () => {
    setRunning(true);
    try {
      const response = await api.post('/quality/product-destroy', {
        team,
        badReasonCode: detail.badReasonCode,
        productType: detail.productType,
        shiftCode: detail.shiftCode,
        causeBy: detail.causeBy,
        detectProcessCode: detail.detectProcessCode,
        occurProcessCode: team === '2' ? detail.occurProcessCode : undefined,
        badCategory: team === '2' ? detail.badCategory : undefined,
        worker: detail.worker.trim(),
        lineCode: detail.lineCode || undefined,
        departmentCode,
        fallbackWorkstageCode: fallbackWorkstageCode || undefined,
        fallbackItemCode: itemCode.trim() || undefined,
        serialNos: serials,
        items,
      });
      const result: DestroyResponse = response.data?.data;
      setOutcome(result);
      toast.success(`폐기 ${result.ok}건 · 건너뜀 ${result.skip}건 · 실패 ${result.fail}건`);
      setConfirmOpen(false);
      setItems([]);
      if (serials.length > 0) await loadSerial(serials[0]);
    } catch (error: unknown) {
      const apiMessage = (error as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(apiMessage || '폐기 등록에 실패했습니다');
    } finally {
      setRunning(false);
    }
  }, [departmentCode, detail, fallbackWorkstageCode, itemCode, items, loadSerial, serials, team]);

  // 이미 취소된 건은 고를 수 없다
  const cancellable = useMemo(() => rows.filter(row => row.destroyStatus !== 'C'), [rows]);
  const allChecked = cancellable.length > 0 && cancellable.every(row => checked.has(row.destroySeq));
  const historyColumns = useMemo(() => [
    selectColumn<ProductDestroyRow>({
      isSelected: row => checked.has(row.destroySeq),
      isSelectable: row => row.destroyStatus !== 'C',
      onToggle: row => setChecked(prev => {
        const next = new Set(prev);
        if (next.has(row.destroySeq)) next.delete(row.destroySeq);
        else next.add(row.destroySeq);
        return next;
      }),
      allSelected: allChecked,
      onToggleAll: () => setChecked(allChecked ? new Set() : new Set(cancellable.map(row => row.destroySeq))),
    }),
    ...destroyHistoryColumns,
  ], [allChecked, cancellable, checked]);

  const cancelDestroy = useCallback(async () => {
    const reason = cancelReason.trim();
    if (!reason) {
      toast.error('취소 사유를 넣으세요');
      return;
    }
    setCancelling(true);
    try {
      const response = await api.post('/quality/product-destroy/cancel', { destroySeqs: [...checked], reason });
      toast.success(`폐기 ${response.data?.data?.cancelled ?? 0}건을 취소했습니다`);
      setCancelOpen(false);
      setCancelReason('');
      await searchHistory();
    } catch (error: unknown) {
      const apiMessage = (error as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(apiMessage || '폐기 취소에 실패했습니다');
    } finally {
      setCancelling(false);
    }
  }, [cancelReason, checked, searchHistory]);

  const toggleIssue = useCallback(async (path: 'issue' | 'issue-cancel', row: ProductDestroyRow | null) => {
    if (!row) return;
    try {
      await api.post(`/quality/product-destroy/${path}`, { destroySeq: row.destroySeq });
      toast.success(path === 'issue' ? '반품 처리했습니다' : '반품을 취소했습니다');
      if (row.serialNo) await loadSerial(row.serialNo);
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
          시리얼별 공정 폐기를 등록하고 반품 여부를 관리합니다 · 폐기는 공정폐기 원장에 쌓이고, 잘못 등록한 건은 지우지 않고 취소로 남긴다
        </p>
      </header>

      <ScreenTabs
        tabs={[
          { key: 'DESTROY', label: '폐기등록' },
          { key: 'HISTORY', label: '폐기이력', count: searched ? total : undefined },
          { key: 'SUMMARY', label: '폐기현황' },
          { key: 'LCR', label: 'LCR 폐기' },
        ]}
        active={mode}
        onChange={setMode}
      />

      {mode === 'SUMMARY' && <DestroySummaryTab />}
      {mode === 'LCR' && <LcrDestroyTab />}
      {mode === 'DESTROY' ? (
        <>
          <Card className="shrink-0" padding="sm">
            <div className="flex flex-wrap items-center gap-2">
              <div className="flex overflow-hidden rounded-md border border-border" role="group" aria-label="팀">
                {(['1', '2'] as const).map(value => (
                  <button key={value} type="button" onClick={() => changeTeam(value)}
                    className={`px-3 py-1.5 text-sm ${team === value ? 'bg-primary text-primary-foreground' : 'bg-background text-text hover:bg-surface'}`}>
                    {value === '1' ? '생산1팀 (SMT)' : '생산2팀 (조립)'}
                  </button>
                ))}
              </div>
              <BarcodeScanInput aria-label="시리얼 스캔" placeholder="시리얼 스캔" autoClear onScan={addSerials} className="w-48" />
              <PartSearchField aria-label="품번" placeholder="품번 (미각인 제품)" value={itemCode} onChange={e => setItemCode(e.target.value)}
                onKeyDown={e => { if (e.key === 'Enter') addItem(); }} className="w-44" />
              <QtyInput aria-label="수량" placeholder="수량" value={itemQty} onChange={setItemQty} className="w-20" />
              <Button size="sm" variant="secondary" onClick={addItem} disabled={!itemCode.trim() || itemQty < 1}
                data-tooltip="바코드가 없는 제품을 품번과 수량으로 목록에 넣는다">
                <Plus className="mr-1 h-4 w-4" />품번 추가
              </Button>
              <DepartmentSelect aria-label="부서" placeholder="부서 선택" value={departmentCode} onChange={value => setDepartmentCode(value)} className="w-32" />
              <ProcessSelect aria-label="공정(대체값)" labelPrefix="공정" value={fallbackWorkstageCode} onChange={value => setFallbackWorkstageCode(value)} className="w-40" />
              <Button variant="secondary" size="sm" data-tooltip="스캔·품번 목록과 아래 폐기/반품 목록을 비운다" onClick={() => { setSerials([]); setItems([]); setOutcome(null); setDestroyList([]); setIssueList([]); }}>
                <RotateCcw className="mr-1 h-4 w-4" />초기화
              </Button>
            </div>
            <div className="mt-2 flex flex-wrap items-center gap-2">
              <DestroyDetailFields team={team} value={detail} onChange={setDetail} />
              <Button size="sm" onClick={() => setConfirmOpen(true)}
                disabled={(serials.length === 0 && items.length === 0) || !isDetailComplete(team, detail) || !departmentCode || running}>
                <Trash2 className="mr-1 h-4 w-4" />폐기 실행
              </Button>
            </div>
            <div className="mt-2 flex max-h-20 flex-wrap items-center gap-1 overflow-y-auto text-xs">
              <span className="mr-1 text-text-muted">스캔 {serials.length}건 · 품번 {items.length}건</span>
              {items.map(item => (
                <span key={item.itemCode} className="flex items-center gap-1 rounded border border-primary/40 bg-surface px-1.5 py-0.5 font-mono text-text">
                  {item.itemCode} × {item.qty.toLocaleString()}
                  <button type="button" aria-label={`${item.itemCode} 빼기`} onClick={() => setItems(prev => prev.filter(i => i.itemCode !== item.itemCode))} className="text-text-muted hover:text-red-600">
                    <X className="h-3 w-3" />
                  </button>
                </span>
              ))}
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
                <span className="text-sm font-semibold text-text">폐기보관 목록</span>
                <Button size="sm" variant="secondary" onClick={() => toggleIssue('issue', selectedDestroy)} disabled={!selectedDestroy}>반품 처리</Button>
              </div>
              <CardContent className="min-h-0 flex-1 p-3">
                <DataGrid data={destroyList} columns={serialColumns} pageSize={20}
                  getRowId={row => String(row.destroySeq)} selectedRowId={selectedDestroy ? String(selectedDestroy.destroySeq) : undefined}
                  onRowClick={row => setSelectedDestroy(row)} emptyMessage="시리얼을 조회하세요." />
              </CardContent>
            </Card>
            <Card className="flex min-h-0 flex-1 flex-col overflow-hidden" padding="none">
              <div className="flex items-center justify-between border-b border-border px-3 py-2">
                <span className="text-sm font-semibold text-text">반품 목록</span>
                <Button size="sm" variant="secondary" onClick={() => toggleIssue('issue-cancel', selectedIssue)} disabled={!selectedIssue}>반품 취소</Button>
              </div>
              <CardContent className="min-h-0 flex-1 p-3">
                <DataGrid data={issueList} columns={serialColumns} pageSize={20}
                  getRowId={row => String(row.destroySeq)} selectedRowId={selectedIssue ? String(selectedIssue.destroySeq) : undefined}
                  onRowClick={row => setSelectedIssue(row)} emptyMessage="반품 처리된 건이 없습니다." />
              </CardContent>
            </Card>
          </div>
        </>
      ) : mode === 'HISTORY' && (
        <>
          <Card className="shrink-0" padding="sm">
            <div className="flex flex-wrap items-center gap-2">
              <BarcodeScanInput aria-label="PCB 시리얼" placeholder="시리얼 스캔" value={serialNo} onChange={setSerialNo} onScan={searchHistory} className="w-44" />
              <ModelSearchField value={modelName} onChange={(v) => setModelName(v)} className="w-40" aria-label="모델명" placeholder="모델명" />
              <LineSelect aria-label="라인" labelPrefix="라인" value={lineCode} onChange={value => setLineCode(value)} className="w-40" />
              <ProcessSelect aria-label="공정" labelPrefix="공정" value={workstageCode} onChange={value => setWorkstageCode(value)} className="w-44" />
              <ComCodeSelect groupCode="DESTROY STATUS" labelPrefix="상태" aria-label="상태" value={status} onChange={value => setStatus(value)} className="w-40" />
              <DateRangeFilter label="폐기일자" from={dateFrom} to={dateTo} onFromChange={setDateFrom} onToChange={setDateTo} />
              <Button size="sm" onClick={() => searchHistory()} disabled={loading}>
                <Search className="mr-1 h-4 w-4" />조회
              </Button>
              <Button size="sm" variant="danger" onClick={() => setCancelOpen(true)} disabled={checked.size === 0 || cancelling}
                data-tooltip="잘못 등록한 폐기를 취소로 바꾼다. 행은 남고 폐기현황 집계에서 빠진다">
                <Ban className="mr-1 h-4 w-4" />폐기 취소{checked.size > 0 && ` (${checked.size})`}
              </Button>
              <span className="text-sm text-text-muted">{searched ? `${rows.length}/${total}건` : '조회조건을 입력하세요'}</span>
            </div>
          </Card>
          <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
            <CardContent className="h-full p-3">
              <DataGrid data={rows} columns={historyColumns} isLoading={loading} pageSize={50} getRowId={row => String(row.destroySeq)}
                enableColumnFilter enableExport exportFileName="공정폐기이력"
                emptyMessage={searched ? '조회 결과가 없습니다.' : '조회 버튼을 눌러 폐기이력을 확인하세요.'} />
            </CardContent>
          </Card>
        </>
      )}

      <ConfirmModal
        isOpen={cancelOpen}
        onClose={() => setCancelOpen(false)}
        onConfirm={cancelDestroy}
        isLoading={cancelling}
        variant="danger"
        title="폐기 취소"
        confirmText="폐기 취소"
        message={
          <span className="flex flex-col gap-2">
            <span>고른 폐기 <strong>{checked.size}</strong>건을 취소로 바꿉니다. 이력은 남고 폐기현황 집계에서 빠집니다.</span>
            <Input aria-label="취소 사유" placeholder="취소 사유 (필수)" value={cancelReason} maxLength={150}
              onChange={e => setCancelReason(e.target.value)} fullWidth />
          </span>
        }
      />

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
            시리얼 <strong>{serials.length}</strong>건{items.length > 0 && <>, 품번 <strong>{items.length}</strong>건(수량 {items.reduce((sum, i) => sum + i.qty, 0).toLocaleString()})</>}을 폐기 처리합니다.
            <br />
            시리얼·품번마다 공정폐기 원장에 <strong>폐기보관</strong> 1건이 쌓입니다. 이미 폐기된 시리얼은 건너뜁니다.
            {itemCode.trim() && <><br />바코드 이력에 없는 시리얼은 품번 <strong>{itemCode.trim()}</strong> 으로 등록합니다.</>}
          </span>
        }
      />
    </main>
  );
}
