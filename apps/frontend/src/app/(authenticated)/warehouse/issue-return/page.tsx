"use client";

/**
 * @file src/app/(authenticated)/warehouse/issue-return/page.tsx
 * @description 출고바코드반품 — PB w_mat_other_mass_issue_barcode_return_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **라인에서 쓰다 남은 릴을 창고로 되돌리는 화면이다.** 릴에 붙은 바코드를 찍고
 *    남은 수량을 넣으면 그 릴이 다시 창고 재고가 된다.
 * 2. **반품하면 바코드가 바뀐다.** 1,000개로 나갔다가 300개가 남아 돌아오면 그
 *    바코드는 `품목-롯트-300` 으로 다시 만들어진다. **새 라벨을 붙여야 한다.**
 * 3. **실사 수량을 따로 넣으면 차이가 로스로 남는다.** 비우면 반품 수량과 같게 보아
 *    로스 0 이다.
 * 4. **아직 라인으로 나가지 않은 바코드는 반품할 수 없다.** 찍으면 화면이 이유를
 *    알려 준다.
 * 5. **라인은 그 롯트가 마지막으로 나간 라인이 자동으로 채워진다.** 못 찾으면 직접
 *    넣는다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, ScanLine, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { issueLossColumns, issueReturnColumns } from '../issue-return-columns';
import type {
  IssueLossRow,
  IssueReturnLookup,
  IssueReturnResult,
  IssueReturnRow,
} from '../issue-return-columns';

const today = () => new Date().toISOString().slice(0, 10);
const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

type TabKey = 'returns' | 'losses';

export default function IssueReturnPage() {
  const [tab, setTab] = useState<TabKey>('returns');
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(today());
  const [itemCode, setItemCode] = useState('');
  const [lotNo, setLotNo] = useState('');

  const [returns, setReturns] = useState<IssueReturnRow[]>([]);
  const [losses, setLosses] = useState<IssueLossRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 스캔·반품 (쓰기)
  const [barcode, setBarcode] = useState('');
  const [returnQty, setReturnQty] = useState('');
  const [actualQty, setActualQty] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [lookup, setLookup] = useState<IssueReturnLookup | null>(null);
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const params = {
        dateFrom, dateTo,
        itemCode: itemCode || undefined,
        lotNo: lotNo || undefined,
      };
      if (tab === 'returns') {
        const r = await api.get('/warehouse/issue-return', { params });
        setReturns(r.data?.data ?? []);
        mark(r);
      } else {
        const r = await api.get('/warehouse/issue-return/losses', { params });
        setLosses(r.data?.data ?? []);
        mark(r);
      }
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [tab, dateFrom, dateTo, itemCode, lotNo, mark]);

  useEffect(() => { void search(); }, [tab]); // eslint-disable-line react-hooks/exhaustive-deps

  /** 바코드를 풀어 본다 (읽기 전용). 반품은 '반품' 을 눌러야 한다. */
  const runLookup = useCallback(async () => {
    const value = barcode.trim();
    if (!value) return;
    setBusy(true);
    try {
      const r = await api.post('/warehouse/issue-return/lookup', { barcode: value });
      const result = r.data?.data as IssueReturnLookup | undefined;
      setLookup(result ?? null);
      // 마지막으로 나간 라인과 현재 수량을 폼에 미리 채운다 (PB 와 같다).
      if (result?.lastIssueLineCode) setLineCode(result.lastIssueLineCode);
      if (result?.barcodeRow?.currentQty != null) {
        setReturnQty(String(result.barcodeRow.currentQty));
      }
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '바코드를 풀어 보지 못했습니다.');
      setLookup(null);
    } finally {
      setBusy(false);
    }
  }, [barcode]);

  const qty = Number(returnQty);
  const actual = actualQty === '' ? qty : Number(actualQty);
  const lossQty = Number.isFinite(qty) && Number.isFinite(actual) ? qty - actual : 0;

  const blocker = !barcode.trim()
    ? '바코드를 찍으세요.'
    : !lookup
      ? '바코드를 먼저 풀어 보세요 (Enter).'
      : !lookup.returnable
        ? lookup.reason
        : !(Number.isFinite(qty) && qty >= 1)
          ? '반품 수량은 1 이상이어야 합니다.'
          : !lineCode.trim()
            ? '라인코드를 넣으세요.'
            : null;

  const submit = useCallback(async () => {
    setConfirmOpen(false);
    setBusy(true);
    try {
      const r = await api.post('/warehouse/issue-return', {
        barcode: barcode.trim(),
        returnQty: qty,
        actualQty: actualQty === '' ? undefined : Number(actualQty),
        lineCode: lineCode.trim(),
      });
      const result = r.data?.data as IssueReturnResult | undefined;
      toast.success(
        `반품했습니다. 새 바코드는 ${result?.newBarcode} 입니다 — 라벨을 다시 붙이세요.`
        + (Number(result?.lossQty ?? 0) !== 0
          ? ` (로스 ${Number(result?.lossQty).toLocaleString()})`
          : ''),
        { duration: 8000 },
      );
      setBarcode(''); setReturnQty(''); setActualQty(''); setLookup(null);
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '반품에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [barcode, qty, actualQty, lineCode, search]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">출고바코드반품</h1>
        <p className="mt-1 text-sm text-text-muted">
          라인에서 남은 릴을 창고로 되돌립니다. 반품하면 바코드가 새 수량으로 바뀝니다 ·{' '}
          {searched
            ? `${tab === 'returns' ? '반품' : '로스'}`
              + ` ${(tab === 'returns' ? returns : losses).length.toLocaleString()}건`
            : '조회하세요'}
        </p>
      </header>

      {/* 스캔·반품 (쓰기) */}
      <Card padding="none">
        <CardContent className="flex flex-col gap-3 p-3">
          <div className="flex flex-wrap items-center gap-3">
            <span className="flex items-center gap-1 text-sm font-semibold text-text">
              <ScanLine className="h-4 w-4" />반품 스캔
            </span>
            <Input aria-label="자재 바코드" placeholder="자재 바코드 → Enter"
              value={barcode} className="w-64"
              onChange={(e) => setBarcode(e.target.value)}
              onKeyDown={(e) => { if (e.key === 'Enter') void runLookup(); }} />
            <Button size="sm" variant="secondary" disabled={busy || !barcode.trim()}
              onClick={runLookup}>
              풀어 보기
            </Button>
            <Input aria-label="반품 수량" placeholder="반품 수량" value={returnQty}
              className="w-32" inputMode="numeric"
              onChange={(e) => setReturnQty(e.target.value)} />
            <Input aria-label="실사 수량" placeholder="실사 수량 (비우면 로스 0)"
              value={actualQty} className="w-44" inputMode="numeric"
              onChange={(e) => setActualQty(e.target.value)} />
            <Input aria-label="라인코드" placeholder="라인코드" value={lineCode}
              className="w-32"
              onChange={(e) => setLineCode(e.target.value)} />
            <Button size="sm" disabled={busy || Boolean(blocker)}
              onClick={() => setConfirmOpen(true)}>
              반품
            </Button>
          </div>

          {lookup?.barcodeRow && (
            <div className="flex flex-wrap gap-x-6 gap-y-1 rounded border border-border
                            bg-surface-muted px-3 py-2 text-sm">
              <span>품목 <b>{lookup.itemCode}</b>
                {lookup.barcodeRow.itemName ? ` (${lookup.barcodeRow.itemName})` : ''}</span>
              <span>롯트 <b>{lookup.lotNo}</b></span>
              <span>현재 수량 <b>
                {Number(lookup.barcodeRow.currentQty ?? 0).toLocaleString()}</b></span>
              <span>전표 {lookup.barcodeRow.receiptSlipNo ?? '없음'}</span>
              <span>마지막 출고 라인 {lookup.lastIssueLineCode ?? '없음'}</span>
              {lossQty !== 0 && Number.isFinite(lossQty) && (
                <span className="font-semibold text-red-500">
                  로스 {lossQty.toLocaleString()}
                </span>
              )}
            </div>
          )}
          {blocker && barcode && (
            <p className="flex items-center gap-1 text-sm text-amber-500">
              <AlertTriangle className="h-4 w-4" />{blocker}
            </p>
          )}
        </CardContent>
      </Card>

      <ScreenTabs
        tabs={[
          { key: 'returns' as TabKey, label: '반품 이력', count: returns.length },
          { key: 'losses' as TabKey, label: '로스', count: losses.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label={tab === 'returns' ? '반품일' : '발생일'}
            from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
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
          {tab === 'returns' ? (
            <DataGrid
              data={returns}
              columns={issueReturnColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="출고바코드반품"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['issueDate'] }}
              emptyMessage={searched ? '기간 안에 반품이 없습니다.' : '조회하세요.'}
            />
          ) : (
            <DataGrid
              data={losses}
              columns={issueLossColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="반품로스"
              emptyMessage={searched ? '기간 안에 로스가 없습니다.' : '조회하세요.'}
            />
          )}
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={submit}
        title="출고바코드반품"
        message={`${lookup?.itemCode} 롯트 ${lookup?.lotNo} 를`
          + ` ${Number(returnQty || 0).toLocaleString()} 반품합니다.`
          + ` 바코드가 ${lookup?.itemCode}-${lookup?.lotNo}-${Number(returnQty || 0)} 로`
          + ' 바뀌므로 라벨을 다시 붙여야 합니다.'
          + (lossQty !== 0 ? ` 로스 ${lossQty.toLocaleString()} 이 기록됩니다.` : '')}
        confirmText="반품"
      />
    </div>
  );
}
