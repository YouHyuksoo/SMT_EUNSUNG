"use client";

/**
 * @file src/app/(authenticated)/material/receipt-cancel/page.tsx
 * @description 자재입고취소 — PB w_mat_receipt_cancel_master 이식
 *
 * 초보자 가이드:
 * 1. **모드**: 취소대상(RECEIPT_STATUS='N') / 이력(전체) 두 가지.
 *    PB 는 라디오버튼(rb_cancel/rb_hst)이지만 웹은 화면 전환이므로 탭으로 만든다.
 * 2. **선택**: 취소대상 모드에서만 체크박스가 붙는다. 바코드 조인으로 행이 늘어나도
 *    선택은 입고건(PK) 단위라 같은 입고건의 여러 행이 함께 체크된다.
 * 3. **취소**: 행을 지우지 않고 수량·금액을 뒤집은 상계 행을 새로 만든다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { RefreshCw, RotateCcw, Search, Undo2 } from 'lucide-react';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateFilter from '@/components/shared/DateFilter';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import SupplierSelect from '@/components/shared/SupplierSelect';
import DataGrid from '@/components/data-grid/DataGrid';
import api from '@/services/api';
import { buildReceiptCancelColumns } from './columns';
import { receiptKey, type ReceiptCancelMode, type ReceiptCancelRow } from './types';

const today = () => new Date().toISOString().slice(0, 10);
const firstDayOfMonth = () => `${new Date().toISOString().slice(0, 7)}-01`;

export default function ReceiptCancelPage() {
  const [mode, setMode] = useState<ReceiptCancelMode>('CANCEL');
  const [rows, setRows] = useState<ReceiptCancelRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [cancelling, setCancelling] = useState(false);

  const [itemCode, setItemCode] = useState('');
  const [materialMfs, setMaterialMfs] = useState('');
  const [supplierCode, setSupplierCode] = useState('');
  const [locationCode, setLocationCode] = useState('');
  const [invoiceNo, setInvoiceNo] = useState('');
  const [dateFrom, setDateFrom] = useState(firstDayOfMonth);
  const [dateTo, setDateTo] = useState(today);
  const [cancelDate, setCancelDate] = useState(today);
  const [allowLastMonth, setAllowLastMonth] = useState(false);

  const search = useCallback(async (nextMode: ReceiptCancelMode = mode) => {
    setLoading(true);
    try {
      const response = await api.get('/material/receipt-cancel', {
        params: {
          mode: nextMode,
          limit: '5000',
          itemCode: itemCode || undefined,
          materialMfs: materialMfs || undefined,
          supplierCode: supplierCode || undefined,
          locationCode: locationCode || undefined,
          invoiceNo: invoiceNo || undefined,
          dateFrom: dateFrom || undefined,
          dateTo: dateTo || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? response.data?.total ?? 0));
      setSelected(new Set());
      setSearched(true);
    } catch {
      setRows([]);
      setTotal(0);
      toast.error('입고 조회에 실패했습니다');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, invoiceNo, itemCode, locationCode, materialMfs, mode, supplierCode]);

  const changeMode = useCallback((next: ReceiptCancelMode) => {
    setMode(next);
    setRows([]);
    setSelected(new Set());
    setSearched(false);
  }, []);

  const toggle = useCallback((row: ReceiptCancelRow) => {
    setSelected(prev => {
      const next = new Set(prev);
      const key = receiptKey(row);
      if (next.has(key)) next.delete(key); else next.add(key);
      return next;
    });
  }, []);

  const toggleAll = useCallback(() => {
    setSelected(prev => (prev.size > 0 ? new Set() : new Set(rows.map(receiptKey))));
  }, [rows]);

  const columns = useMemo(
    () => buildReceiptCancelColumns(mode, { selected, toggle }),
    [mode, selected, toggle],
  );

  /** 선택된 입고건 — 화면에 중복 행이 있어도 PK 기준 1건으로 접는다 */
  const targets = useMemo(() => {
    const unique = new Map<string, { receiptDate: string; receiptSequence: number }>();
    for (const row of rows) {
      const key = receiptKey(row);
      if (selected.has(key)) unique.set(key, { receiptDate: row.receiptDate, receiptSequence: row.receiptSequence });
    }
    return [...unique.values()];
  }, [rows, selected]);

  const runCancel = useCallback(async () => {
    setCancelling(true);
    try {
      const response = await api.post('/material/receipt-cancel', {
        cancelDate,
        allowLastMonth: allowLastMonth ? 'Y' : 'N',
        targets,
      });
      const result = response.data?.data ?? {};
      const skipped = Number(result.skipped ?? 0);
      toast.success(`${Number(result.cancelled ?? 0)}건 취소했습니다${skipped > 0 ? ` (전월 이월 ${skipped}건 제외)` : ''}`);
      setConfirmOpen(false);
      await search();
    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : '';
      const apiMessage = (error as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(apiMessage || message || '입고취소에 실패했습니다');
    } finally {
      setCancelling(false);
    }
  }, [allowLastMonth, cancelDate, search, targets]);

  return (
    <main className="flex h-full min-w-0 flex-col gap-3 p-5">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <Undo2 className="h-6 w-6 text-primary" />자재입고취소
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            PB w_mat_receipt_cancel_master 기준 · {searched ? `${rows.length}/${total}건` : '조회조건을 입력하세요'}
          </p>
        </div>
        <div className="flex gap-2">
          <Button variant="secondary" size="sm" onClick={() => search()} disabled={loading}>
            <RefreshCw className={`mr-1 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />새로고침
          </Button>
          <Button size="sm" onClick={() => search()} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </div>
      </header>

      <nav className="flex flex-wrap gap-1 border-b border-border" aria-label="조회 모드">
        {([['CANCEL', '취소대상'], ['HISTORY', '이력']] as const).map(([value, label]) => (
          <button
            key={value}
            type="button"
            onClick={() => changeMode(value)}
            aria-current={mode === value ? 'page' : undefined}
            className={`px-4 py-2 text-sm font-medium transition-colors ${
              mode === value ? 'border-b-2 border-primary text-primary' : 'text-text-muted hover:text-text'
            }`}
          >
            {label}
          </button>
        ))}
      </nav>

      <Card className="shrink-0" padding="sm">
        <div className="flex flex-wrap items-center gap-2">
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCode} onChange={e => setItemCode(e.target.value)} className="w-36" />
          <Input aria-label="자재 MFS" placeholder="자재 MFS" value={materialMfs} onChange={e => setMaterialMfs(e.target.value)} className="w-36" />
          <SupplierSelect aria-label="공급업체" value={supplierCode} onChange={setSupplierCode} className="w-40" />
          <ComCodeSelect aria-label="자재위치" groupCode="MATERIAL LOCATION CODE" value={locationCode} onChange={setLocationCode} className="w-44" />
          <Input aria-label="Invoice No" placeholder="Invoice No" value={invoiceNo} onChange={e => setInvoiceNo(e.target.value)} className="w-36" />
          <DateRangeFilter label="입고일" from={dateFrom} to={dateTo} onFromChange={setDateFrom} onToChange={setDateTo} />
        </div>
      </Card>

      {mode === 'CANCEL' && (
        <Card className="shrink-0" padding="sm">
          <div className="flex flex-wrap items-center gap-3">
            <label className="flex items-center gap-1 whitespace-nowrap text-sm text-text-muted">
              취소일자
              <DateFilter value={cancelDate} onChange={setCancelDate} />
            </label>
            <label className="flex items-center gap-2 whitespace-nowrap text-sm">
              <input type="checkbox" checked={allowLastMonth} onChange={e => setAllowLastMonth(e.target.checked)} className="h-4 w-4 accent-primary" />
              전월 이월분 취소 허용
            </label>
            <Button variant="secondary" size="sm" onClick={toggleAll} disabled={rows.length === 0}>
              {selected.size > 0 ? '선택 해제' : '전체 선택'}
            </Button>
            <span className="text-sm text-text-muted">선택 <strong className="text-text">{targets.length}</strong>건</span>
            <Button size="sm" onClick={() => setConfirmOpen(true)} disabled={targets.length === 0 || cancelling}>
              <RotateCcw className="mr-1 h-4 w-4" />일괄취소
            </Button>
          </div>
        </Card>
      )}

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={columns}
            isLoading={loading}
            pageSize={50}
            enableColumnFilter
            enableExport
            exportFileName="자재입고취소"
            emptyMessage={searched ? '조회 결과가 없습니다.' : '조회 버튼을 눌러 입고내역을 확인하세요.'}
          />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={runCancel}
        isLoading={cancelling}
        variant="danger"
        title="자재입고취소"
        confirmText="일괄취소"
        message={
          <span>
            선택한 <strong>{targets.length}</strong>건을 취소합니다.
            <br />
            입고일자 <strong>{cancelDate}</strong> 로 수량·금액을 뒤집은 상계 행이 생성되고, 원본 입고건은 취소(C) 상태가 됩니다.
            {!allowLastMonth && <><br />전월 이월 입고분은 제외됩니다.</>}
          </span>
        }
      />
    </main>
  );
}
