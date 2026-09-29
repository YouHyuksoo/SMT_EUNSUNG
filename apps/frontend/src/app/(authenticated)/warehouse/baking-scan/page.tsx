"use client";

/**
 * @file src/app/(authenticated)/warehouse/baking-scan/page.tsx
 * @description 베이킹이력관리 — PB w_mat_baking_dehumi_scan_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **자재를 챔버에 넣고 꺼내는 화면이다.** 세 종류가 있다 — 베이킹실(습기를 굽는다) ·
 *    진공포장 · 제습함.
 * 2. **MSL 시계가 함께 움직인다** — 이게 핵심이다. MSL 은 습기에 민감한 부품이 공기에
 *    노출된 누적 시간이고, 그 시간을 넘기면 출고할 수 없다.
 *        베이킹에서 꺼내면 → 노출시간이 **초기화**된다 (구웠으니 습기가 빠졌다)
 *        제습함에서 꺼내면 → **그 순간부터 다시 노출**이 시작된다
 *        진공·제습에 넣으면 → 개봉시각까지의 노출시간을 누적하고 시계를 멈춘다
 * 3. **폐기된 릴과 라인에 투입 중인 릴은 넣을 수 없다.**
 * 4. **꺼내려면 넣은 기록이 있어야 한다.** 챔버 번호까지 맞아야 꺼내진다.
 * 5. 지금 들어가 있는 것만 보려면 베이킹재고·진공포장재고·제습함재고 화면을 쓴다.
 *    이 화면은 넣고 꺼낸 **이력 전체**를 본다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, LogIn, LogOut, ScanLine, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import { Button, Card, CardContent, ConfirmModal, Input, Select } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { bakingHistoryColumns, CHAMBER_LABEL } from '../divide-baking-columns';
import type { BakingHistoryRow, BakingLookup } from '../divide-baking-columns';

const today = () => new Date().toISOString().slice(0, 10);
const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

const CHAMBER_OPTIONS = [
  { value: 'B', label: `${CHAMBER_LABEL.B} (B)` },
  { value: 'V', label: `${CHAMBER_LABEL.V} (V)` },
  { value: 'D', label: `${CHAMBER_LABEL.D} (D)` },
];
const FILTER_OPTIONS = [{ value: '', label: '챔버: 전체' }, ...CHAMBER_OPTIONS];

export default function BakingScanPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(today());
  const [filterType, setFilterType] = useState('');
  const [itemCode, setItemCode] = useState('');
  const [lotNo, setLotNo] = useState('');

  const [rows, setRows] = useState<BakingHistoryRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 스캔 (쓰기)
  const [chamberType, setChamberType] = useState('B');
  const [chamberCode, setChamberCode] = useState('');
  const [chamberLocation, setChamberLocation] = useState('');
  const [barcode, setBarcode] = useState('');
  const [direction, setDirection] = useState<'IN' | 'OUT'>('IN');
  const [lookup, setLookup] = useState<BakingLookup | null>(null);
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const r = await api.get('/warehouse/baking-scan', {
        params: {
          dateFrom, dateTo,
          chamberType: filterType || undefined,
          itemCode: itemCode || undefined,
          lotNo: lotNo || undefined,
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
  }, [dateFrom, dateTo, filterType, itemCode, lotNo, mark]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const runLookup = useCallback(async () => {
    const value = barcode.trim();
    if (!value) return;
    setBusy(true);
    try {
      const r = await api.get('/warehouse/baking-scan/lookup', {
        params: { barcode: value, chamberType },
      });
      const result = (r.data?.data as BakingLookup) ?? null;
      setLookup(result);
      // 이미 들어가 있으면 꺼내기로, 아니면 넣기로 맞춰 준다.
      if (result) setDirection(result.openCount > 0 ? 'OUT' : 'IN');
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '바코드를 풀어 보지 못했습니다.');
      setLookup(null);
    } finally {
      setBusy(false);
    }
  }, [barcode, chamberType]);

  const blocker = !chamberCode.trim()
    ? '챔버 번호를 넣으세요.'
    : !barcode.trim()
      ? '바코드를 찍으세요.'
      : !lookup
        ? '바코드를 먼저 풀어 보세요 (Enter).'
        : direction === 'IN'
          ? (lookup.canInput ? null : lookup.inputReason)
          : (lookup.canOutput ? null : lookup.outputReason);

  const submit = useCallback(async () => {
    setConfirmOpen(false);
    setBusy(true);
    try {
      const r = await api.post('/warehouse/baking-scan', {
        barcode: barcode.trim(),
        chamberType,
        chamberCode: chamberCode.trim(),
        direction,
        chamberLocation: chamberLocation.trim() || undefined,
      });
      const result = r.data?.data as
        { chamberLabel?: string; mslReset?: boolean } | undefined;
      toast.success(
        direction === 'IN'
          ? `${result?.chamberLabel} 에 넣었습니다.`
          : `${result?.chamberLabel} 에서 꺼냈습니다.`
            + (result?.mslReset ? ' MSL 노출시간이 초기화됐습니다.' : ''),
      );
      setBarcode('');
      setLookup(null);
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [barcode, chamberType, chamberCode, direction, chamberLocation, search]);

  const inChamber = rows.filter((r) => String(r.inChamberYn ?? '') === 'Y').length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">베이킹이력관리</h1>
        <p className="mt-1 text-sm text-text-muted">
          자재를 챔버에 넣고 꺼냅니다. MSL 노출시간이 함께 움직입니다 ·{' '}
          {searched
            ? `${rows.length.toLocaleString()}건`
              + (inChamber > 0 ? ` · 안에 있음 ${inChamber}건` : '')
            : '조회하세요'}
        </p>
      </header>

      {/* 스캔 (쓰기) */}
      <Card padding="none">
        <CardContent className="flex flex-col gap-3 p-3">
          <div className="flex flex-wrap items-center gap-3">
            <span className="flex items-center gap-1 text-sm font-semibold text-text">
              <ScanLine className="h-4 w-4" />챔버 스캔
            </span>
            <Select options={CHAMBER_OPTIONS} value={chamberType}
              onChange={setChamberType} className="w-44" />
            <Input aria-label="챔버 번호" placeholder="챔버 번호" value={chamberCode}
              className="w-36"
              onChange={(e) => setChamberCode(e.target.value)} />
            {direction === 'IN' && (
              <Input aria-label="자리" placeholder="자리 (선택)" value={chamberLocation}
                className="w-28"
                onChange={(e) => setChamberLocation(e.target.value)} />
            )}
            <Input aria-label="자재 바코드" placeholder="자재 바코드 → Enter"
              value={barcode} className="w-64"
              onChange={(e) => setBarcode(e.target.value)}
              onKeyDown={(e) => { if (e.key === 'Enter') void runLookup(); }} />
            <Button size="sm" variant={direction === 'IN' ? 'primary' : 'secondary'}
              onClick={() => setDirection('IN')}>
              <LogIn className="mr-1 h-4 w-4" />넣기
            </Button>
            <Button size="sm" variant={direction === 'OUT' ? 'primary' : 'secondary'}
              onClick={() => setDirection('OUT')}>
              <LogOut className="mr-1 h-4 w-4" />꺼내기
            </Button>
            <Button size="sm" disabled={busy || Boolean(blocker)}
              onClick={() => setConfirmOpen(true)}>
              처리
            </Button>
          </div>

          {lookup?.barcodeRow && (
            <div className="flex flex-wrap gap-x-6 gap-y-1 rounded border border-border
                            bg-surface-muted px-3 py-2 text-sm">
              <span>품목 <b>{lookup.itemCode}</b>
                {lookup.barcodeRow.itemName ? ` (${lookup.barcodeRow.itemName})` : ''}</span>
              <span>롯트 <b>{lookup.lotNo}</b></span>
              <span>수량 <b>{Number(lookup.barcodeRow.lotQty ?? 0).toLocaleString()}</b></span>
              {lookup.barcodeRow.mslLevel && <span>MSL {lookup.barcodeRow.mslLevel}</span>}
              <span>노출시간 {Number(lookup.barcodeRow.mslPassedTime ?? 0)}h</span>
              {lookup.barcodeRow.mslOpenDate && (
                <span>개봉 {lookup.barcodeRow.mslOpenDate}</span>
              )}
              <span className={lookup.openCount > 0 ? 'font-semibold text-amber-500' : ''}>
                {lookup.openCount > 0 ? '챔버에 들어가 있음' : '챔버에 없음'}
              </span>
            </div>
          )}

          {blocker && (barcode || chamberCode) && (
            <p className="flex items-start gap-1 text-sm text-amber-500">
              <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" />{blocker}
            </p>
          )}
          {direction === 'OUT' && chamberType === 'B' && (
            <p className="text-xs text-text-muted">
              베이킹실에서 꺼내면 MSL 노출시간이 초기화됩니다.
            </p>
          )}
          {direction === 'OUT' && chamberType === 'D' && (
            <p className="text-xs text-text-muted">
              제습함에서 꺼내면 그 순간부터 다시 노출이 시작됩니다.
            </p>
          )}
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="넣은 날" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Select options={FILTER_OPTIONS} value={filterType} onChange={setFilterType}
            className="w-44" />
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-44"
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="롯트번호" placeholder="롯트번호" value={lotNo}
            className="w-40"
            onChange={(e) => setLotNo(e.target.value)} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={bakingHistoryColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="베이킹이력"
            enableColumnPinning
            defaultPinnedColumns={{ left: ['chamberType'] }}
            emptyMessage={searched ? '기간 안에 이력이 없습니다.' : '조회하세요.'}
            onRowClick={(row) => setBarcode(String((row as BakingHistoryRow).itemBarcode ?? ''))}
            rowClassName={(row) => (String((row as BakingHistoryRow).inChamberYn ?? '') === 'Y'
              ? 'bg-amber-500/5'
              : '')}
          />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={submit}
        title={direction === 'IN' ? '챔버에 넣기' : '챔버에서 꺼내기'}
        message={`${lookup?.itemCode} 롯트 ${lookup?.lotNo} 를`
          + ` ${CHAMBER_LABEL[chamberType]} ${chamberCode} 에`
          + ` ${direction === 'IN' ? '넣습니다' : '에서 꺼냅니다'}.`
          + (direction === 'OUT' && chamberType === 'B'
            ? ' MSL 노출시간이 초기화됩니다.'
            : direction === 'OUT' && chamberType === 'D'
              ? ' 이 순간부터 다시 노출이 시작됩니다.'
              : '')}
        confirmText={direction === 'IN' ? '넣기' : '꺼내기'}
      />
    </div>
  );
}
