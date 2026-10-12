"use client";

/**
 * @file src/app/(authenticated)/mold/receipt/page.tsx
 * @description S-PARTS 입고관리 — PB w_mcn_mold_receipt_master 이식
 *
 * 초보자 가이드:
 * 1. **탭 2개** — 입고이력(기간 조회)과 입고대상(등록할 S-PARTS 고르기).
 *    PB 도 화면 위/아래로 같은 구조였다. 탭을 바꾸면 선택을 비운다.
 * 2. **입고취소는 행을 지우지 않는다.** 원본을 '취소'로 바꾸고 부호를 뒤집은
 *    상계행을 오늘 날짜로 새로 넣는다(역분개). 이력이 남아야 한다.
 * 3. **단가는 승인된 구매단가만 쓴다.** 대상 목록의 승인단가가 '단가없음'이면
 *    단가 0 으로 들어간다 — PB 와 같다.
 * 4. 이 DB 의 입고 테이블에는 비고 컬럼이 없어 비고 입력을 두지 않았다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Ban, PackagePlus, Search, Truck } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import MoldCodeField from '../components/MoldCodeField';
import { moldReceiptColumns, moldReceiptTargetColumns } from '../columns';
import type { MoldReceiptRow, MoldReceiptTargetRow } from '../types';

type Mode = 'history' | 'targets';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const monthAgo = () => {
  const date = new Date();
  date.setMonth(date.getMonth() - 1);
  return isoDate(date);
};

export default function MoldReceiptPage() {
  const [mode, setMode] = useState<Mode>('history');
  const [history, setHistory] = useState<MoldReceiptRow[]>([]);
  const [targets, setTargets] = useState<MoldReceiptTargetRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [dateFrom, setDateFrom] = useState(monthAgo);
  const [dateTo, setDateTo] = useState(today);
  const [moldCode, setMoldCode] = useState('');
  const [supplierCode, setSupplierCode] = useState('');

  const [selectedHistory, setSelectedHistory] = useState<MoldReceiptRow | null>(null);
  const [selectedTarget, setSelectedTarget] = useState<MoldReceiptTargetRow | null>(null);
  const [receiptQty, setReceiptQty] = useState('1');
  const [invoiceNo, setInvoiceNo] = useState('');
  const [locationCode, setLocationCode] = useState('');
  const [busy, setBusy] = useState(false);
  const [cancelOpen, setCancelOpen] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      if (mode === 'history') {
        const response = await api.get('/mold/receipt', {
          params: {
            dateFrom, dateTo,
            moldCode: moldCode || undefined,
            supplierCode: supplierCode || undefined,
          },
        });
        setHistory(response.data?.data ?? []);
        setTotal(Number(response.data?.meta?.total ?? 0));
      } else {
        const response = await api.get('/mold/receipt/targets', {
          params: {
            moldCode: moldCode || undefined,
            supplierCode: supplierCode || undefined,
          },
        });
        const data: MoldReceiptTargetRow[] = response.data?.data ?? [];
        setTargets(data);
        setTotal(data.length);
      }
      setSearched(true);
      setSelectedHistory(null);
      setSelectedTarget(null);
    } catch {
      toast.error('S-PARTS 입고 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [mode, dateFrom, dateTo, moldCode, supplierCode]);

  const changeMode = useCallback((next: Mode) => {
    setMode(next);
    setHistory([]);
    setTargets([]);
    setTotal(0);
    setSearched(false);
    setSelectedHistory(null);
    setSelectedTarget(null);
  }, []);

  const create = useCallback(async () => {
    if (!selectedTarget) return toast.error('입고할 S-PARTS 를 고르세요.');
    if (!selectedTarget.supplierCode) return toast.error('공급처가 없는 S-PARTS 는 입고할 수 없습니다.');
    setBusy(true);
    try {
      const response = await api.post('/mold/receipt', {
        moldCode: selectedTarget.moldCode,
        supplierCode: selectedTarget.supplierCode,
        receiptQty: Number(receiptQty),
        invoiceNo: invoiceNo || undefined,
        locationCode: locationCode || selectedTarget.locationCode || undefined,
        moldVersion: selectedTarget.moldVersion ?? undefined,
        moldSetSerial: selectedTarget.moldSetSerial ?? undefined,
      });
      toast.success(`입고 ${response.data?.data?.receiptSequence ?? ''}번 등록`);
      setReceiptQty('1');
      setInvoiceNo('');
      setLocationCode('');
      void search();
    } catch {
      toast.error('입고 등록에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selectedTarget, receiptQty, invoiceNo, locationCode, search]);

  const cancel = useCallback(async () => {
    if (!selectedHistory) return;
    setCancelOpen(false);
    setBusy(true);
    try {
      await api.put('/mold/receipt/cancel', {
        receiptDate: String(selectedHistory.receiptDate).slice(0, 10),
        receiptSequence: selectedHistory.receiptSequence,
      });
      toast.success('입고를 취소했습니다.');
      void search();
    } catch {
      toast.error('이미 취소되었거나 찾을 수 없는 입고건입니다.');
    } finally {
      setBusy(false);
    }
  }, [selectedHistory, search]);

  const historyCols = useMemo(() => moldReceiptColumns, []);
  const targetCols = useMemo(() => moldReceiptTargetColumns, []);
  const shown = mode === 'history' ? history.length : targets.length;

  return (
    <main className="flex h-full min-w-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <Truck className="h-6 w-6 text-primary" />S-PARTS 입고관리
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            S-PARTS 입고를 등록하고 취소(역분개)합니다 ·{' '}
            {searched ? `${shown}/${total}건` : '조회조건을 선택하세요'}
          </p>
        </div>
        <Button size="sm" onClick={search} disabled={loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          {mode === 'history' && (
            <DateRangeFilter label="입고일" from={dateFrom} to={dateTo}
              onFromChange={setDateFrom} onToChange={setDateTo} />
          )}
          <MoldCodeField popupId="mold-search" returnKey="moldCode"
            label="S-PARTS 코드" placeholder="S-PARTS 코드"
            value={moldCode} onChange={setMoldCode} />
          <SupplierSelect labelPrefix="공급처" value={supplierCode}
            onChange={setSupplierCode} className="w-56" />
        </CardContent>
      </Card>

      {mode === 'targets' ? (
        <Card padding="none">
          <CardContent className="flex flex-wrap items-end gap-3 p-3">
            <div className="flex items-center gap-2 self-center">
              <PackagePlus className="h-5 w-5 text-primary" />
              <span className="text-sm font-semibold text-text">입고 등록</span>
            </div>
            <span className="self-center text-sm text-text-muted">
              {selectedTarget
                ? `${selectedTarget.moldCode} / ${selectedTarget.supplierName ?? selectedTarget.supplierCode ?? '공급처 없음'}`
                : '아래 목록에서 입고할 S-PARTS 를 고르세요'}
            </span>
            <label className="text-xs text-text-muted">
              입고수량
              <Input type="number" value={receiptQty} className="w-28"
                onChange={(e) => setReceiptQty(e.target.value)} />
            </label>
            <label className="text-xs text-text-muted">
              인보이스
              <Input value={invoiceNo} className="w-44"
                onChange={(e) => setInvoiceNo(e.target.value)} />
            </label>
            <label className="text-xs text-text-muted">
              보관위치 (비우면 재고 위치)
              <MoldCodeField popupId="mold-location-search" returnKey="moldLocationCode"
                label="보관위치" className="w-40"
                value={locationCode} onChange={setLocationCode} />
            </label>
            <Button size="sm" onClick={create} disabled={!selectedTarget || busy}>
              <PackagePlus className="mr-1 h-4 w-4" />입고
            </Button>
          </CardContent>
        </Card>
      ) : (
        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <span className="text-sm text-text-muted">
              {selectedHistory
                ? `${selectedHistory.moldCode} / 입고항번 ${selectedHistory.receiptSequence}`
                : '취소할 입고건을 고르세요'}
            </span>
            <Button size="sm" variant="secondary" disabled={!selectedHistory || busy}
              onClick={() => setCancelOpen(true)}>
              <Ban className="mr-1 h-4 w-4 text-red-500" />입고취소
            </Button>
          </CardContent>
        </Card>
      )}

      <nav className="flex gap-1 border-b border-border" aria-label="조회 모드">
        {([['history', '입고이력'], ['targets', '입고대상']] as const).map(([key, label]) => (
          <button
            key={key}
            type="button"
            onClick={() => changeMode(key)}
            className={`px-3 py-1.5 text-sm ${
              mode === key
                ? 'border-b-2 border-primary font-semibold text-text'
                : 'text-text-muted'
            }`}
          >
            {label}
          </button>
        ))}
      </nav>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {mode === 'history' ? (
            <DataGrid
              data={history}
              columns={historyCols}
              isLoading={loading}
              pageSize={50}
              enableColumnFilter
              enableExport
              exportFileName="S-PARTS입고"
              emptyMessage="조회 버튼을 눌러 입고이력을 확인하세요."
              onRowClick={(row) => setSelectedHistory(row as MoldReceiptRow)}
              getRowId={(row) => {
                const receipt = row as MoldReceiptRow;
                return `${receipt.receiptDate}|${receipt.receiptSequence}`;
              }}
            />
          ) : (
            <DataGrid
              data={targets}
              columns={targetCols}
              isLoading={loading}
              pageSize={50}
              enableColumnFilter
              enableExport
              exportFileName="S-PARTS입고대상"
              emptyMessage="조회 버튼을 눌러 입고대상을 확인하세요."
              onRowClick={(row) => setSelectedTarget(row as MoldReceiptTargetRow)}
              getRowId={(row) => {
                const target = row as MoldReceiptTargetRow;
                return `${target.moldCode}|${target.moldVersion ?? ''}|${target.moldSetSerial ?? ''}`;
              }}
            />
          )}
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={cancelOpen}
        onClose={() => setCancelOpen(false)}
        onConfirm={cancel}
        title="입고 취소"
        message={selectedHistory
          ? `${selectedHistory.moldCode} / 입고항번 ${selectedHistory.receiptSequence} 을(를) 취소합니다. 행은 지워지지 않고 수량·금액 부호를 뒤집은 상계행이 오늘 날짜로 생깁니다.`
          : ''}
        variant="danger"
      />
    </main>
  );
}
