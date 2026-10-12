"use client";

/**
 * @file src/app/(authenticated)/warehouse/barcode-divide/page.tsx
 * @description 자재분할관리 — PB w_mat_receipt_barcode_divide_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **릴 하나를 여러 조각으로 쪼개는 화면이다.** 3,000개 릴을 1,200/800/1,000 으로
 *    나누면 릴이 세 개가 된다.
 * 2. **원본 릴은 없어지지 않고 마지막 조각이 된다.** 위 예에서 새 바코드는 **두 개**
 *    (1,200 · 800)가 만들어지고, 원본 바코드의 수량이 1,000 으로 바뀐다.
 *    **새 라벨을 두 장 붙이고 원본 라벨도 다시 붙여야 한다.**
 * 3. **조각 수량 합이 릴 수량과 같아야 한다.** 다르면 거절한다 — PB 는 검사하지 않아
 *    잘못 적으면 재고가 늘거나 줄었다.
 * 4. **폐기·보류된 릴은 나눌 수 없다.** 찍으면 화면이 이유를 알려 준다.
 * 5. 분할은 출고 원장에 쌍으로 남는다 (재고가 움직이는 것이 아니라 롯트가 갈라진
 *    것을 기록한다).
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, ScanLine, Scissors, Search } from 'lucide-react';
import { checkLotDivide, planLotDivide } from '@smt/shared';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { dividedColumns } from '../divide-baking-columns';
import type { DivideLookup, DivideResult, DividedRow } from '../divide-baking-columns';
import PartSearchField from '@/components/shared/PartSearchField';

const today = () => new Date().toISOString().slice(0, 10);
const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

/** 조각 입력을 숫자 목록으로 바꾼다 (쉼표·공백·줄바꿈 구분). */
const parsePieces = (text: string) => text
  .split(/[\s,]+/)
  .filter((s) => s.length > 0)
  .map((s) => Number(s))
  .filter((n) => Number.isFinite(n));

export default function BarcodeDividePage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(today());
  const [itemCode, setItemCode] = useState('');
  const [lotNo, setLotNo] = useState('');

  const [rows, setRows] = useState<DividedRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 분할 (쓰기)
  const [barcode, setBarcode] = useState('');
  const [pieceText, setPieceText] = useState('');
  const [divideReason, setDivideReason] = useState('');
  const [reel, setReel] = useState(false);
  const [lookup, setLookup] = useState<DivideLookup | null>(null);
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const r = await api.get('/warehouse/barcode-divide', {
        params: {
          dateFrom, dateTo,
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
  }, [dateFrom, dateTo, itemCode, lotNo, mark]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const runLookup = useCallback(async () => {
    const value = barcode.trim();
    if (!value) return;
    setBusy(true);
    try {
      const r = await api.post('/warehouse/barcode-divide/lookup', { barcode: value });
      setLookup((r.data?.data as DivideLookup) ?? null);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '바코드를 풀어 보지 못했습니다.');
      setLookup(null);
    } finally {
      setBusy(false);
    }
  }, [barcode]);

  const originQty = Number(lookup?.barcodeRow?.currentQty ?? 0);

  // 화면과 서버가 **같은 공유 함수**로 계획을 만든다.
  const plan = useMemo(() => {
    const pieces = parsePieces(pieceText);
    const verdict = checkLotDivide(pieces, originQty);
    if (!verdict.ok) return { pieces, verdict, detail: null as null | ReturnType<typeof planLotDivide> };
    return { pieces, verdict, detail: planLotDivide(pieces, originQty) };
  }, [pieceText, originQty]);

  const blocker = !barcode.trim()
    ? '바코드를 찍으세요.'
    : !lookup
      ? '바코드를 먼저 풀어 보세요 (Enter).'
      : !lookup.dividable
        ? lookup.reason
        : !plan.verdict.ok
          ? plan.verdict.reason ?? null
          : null;

  const submit = useCallback(async () => {
    setConfirmOpen(false);
    setBusy(true);
    try {
      const r = await api.post('/warehouse/barcode-divide', {
        barcode: barcode.trim(),
        divideQty: parsePieces(pieceText),
        reel,
        divideReason: divideReason.trim() || undefined,
      });
      const result = r.data?.data as DivideResult | undefined;
      toast.success(
        `${result?.pieceCount}조각으로 나눴습니다. 새 라벨 ${result?.created.length}장 +`
        + ` 원본 라벨(${result?.originalBarcode})을 다시 붙이세요.`,
        { duration: 10000 },
      );
      setBarcode(''); setPieceText(''); setLookup(null);
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '분할에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [barcode, pieceText, reel, divideReason, search]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재분할관리</h1>
        <p className="mt-1 text-sm text-text-muted">
          릴 하나를 여러 조각으로 나눕니다. 원본 릴은 마지막 조각이 됩니다 ·{' '}
          {searched ? `분할 ${rows.length.toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      {/* 분할 (쓰기) */}
      <Card padding="none">
        <CardContent className="flex flex-col gap-3 p-3">
          <div className="flex flex-wrap items-center gap-3">
            <span className="flex items-center gap-1 text-sm font-semibold text-text">
              <ScanLine className="h-4 w-4" />분할
            </span>
            <Input aria-label="자재 바코드" placeholder="나눌 릴 바코드 → Enter"
              value={barcode} className="w-64"
              onChange={(e) => setBarcode(e.target.value)}
              onKeyDown={(e) => { if (e.key === 'Enter') void runLookup(); }} />
            <Button size="sm" variant="secondary" disabled={busy || !barcode.trim()}
              onClick={runLookup}>
              풀어 보기
            </Button>
            <Input aria-label="조각 수량" placeholder="조각 수량 (예: 1200, 800, 1000)"
              value={pieceText} className="w-72"
              onChange={(e) => setPieceText(e.target.value)} />
            <Input aria-label="분할사유" placeholder="분할사유" value={divideReason}
              className="w-40"
              onChange={(e) => setDivideReason(e.target.value)} />
            <label className="flex items-center gap-2 text-sm text-text">
              <input type="checkbox" checked={reel}
                onChange={(e) => setReel(e.target.checked)} />
              릴 분할
            </label>
            <Button size="sm" disabled={busy || Boolean(blocker)}
              onClick={() => setConfirmOpen(true)}>
              <Scissors className="mr-1 h-4 w-4" />나누기
            </Button>
          </div>

          {lookup?.barcodeRow && (
            <div className="flex flex-wrap gap-x-6 gap-y-1 rounded border border-border
                            bg-surface-muted px-3 py-2 text-sm">
              <span>품목 <b>{lookup.itemCode}</b>
                {lookup.barcodeRow.itemName ? ` (${lookup.barcodeRow.itemName})` : ''}</span>
              <span>롯트 <b>{lookup.lotNo}</b></span>
              <span>릴 수량 <b>{originQty.toLocaleString()}</b></span>
              <span>전표 {lookup.barcodeRow.receiptSlipNo ?? '없음'}</span>
            </div>
          )}

          {/* 미리 보기 — 새 바코드 몇 장, 원본이 얼마가 되는지 */}
          {plan.detail && (
            <div className="rounded border border-border bg-surface-muted px-3 py-2 text-sm">
              <div>
                <b>{plan.detail.pieceCount}</b>조각 · 합계{' '}
                <b>{plan.detail.totalQty.toLocaleString()}</b>
              </div>
              <div className="mt-1">
                새 라벨 <b>{plan.detail.newPieces.length}장</b> —{' '}
                {plan.detail.newPieces.map((q) => q.toLocaleString()).join(' · ')}
              </div>
              <div className="mt-1 text-text-muted">
                원본 릴({lookup?.lotNo})은{' '}
                <b>{plan.detail.originalPiece.toLocaleString()}</b>개가 되고 라벨을
                다시 붙여야 합니다.
              </div>
            </div>
          )}

          {blocker && (barcode || pieceText) && (
            <p className="flex items-start gap-1 text-sm text-amber-500">
              <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" />{blocker}
            </p>
          )}
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="분할일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode}
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
            columns={dividedColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="자재분할"
            enableColumnPinning
            defaultPinnedColumns={{ left: ['lotDivideDate'] }}
            emptyMessage={searched ? '기간 안에 분할이 없습니다.' : '조회하세요.'}
          />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={submit}
        title="릴 분할"
        message={`${lookup?.itemCode} 롯트 ${lookup?.lotNo}`
          + ` (${originQty.toLocaleString()}개)를 ${plan.detail?.pieceCount}조각으로`
          + ` 나눕니다. 새 라벨 ${plan.detail?.newPieces.length}장이 나오고 원본 릴은`
          + ` ${plan.detail?.originalPiece.toLocaleString()}개가 됩니다.`
          + ' 되돌릴 수 없습니다.'}
        confirmText="나누기"
      />
    </div>
  );
}
