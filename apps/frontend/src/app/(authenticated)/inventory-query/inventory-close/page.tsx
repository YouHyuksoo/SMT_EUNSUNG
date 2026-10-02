"use client";

/**
 * @file src/app/(authenticated)/inventory-query/inventory-close/page.tsx
 * @description 271 자재재고마감 — 원자재 월마감 (월총평균법)
 *
 * 초보자 가이드:
 * 1. **월평균단가 = (기초금액 + 입고금액) ÷ (기초수량 + 입고수량).** 출고와 기말은 그 단가로
 *    금액을 매긴다. 기말금액 = 기초 + 입고 − 출고 (끝자리 차이는 기말이 흡수).
 * 2. **입고금액**은 입고 때 기록된 금액을 쓰고, 비어 있으면 입고일에 유효한 단가표로 채운다.
 *    단가 등록이 없는 입고는 0원으로 들어가고 '단가 미등록 입고' 열에 건수가 나온다.
 * 3. **순서**: 계산(미리보기)은 언제든 된다. 마감은 첫 마감이거나 마지막 마감월의 다음 달만,
 *    그 달이 끝난 뒤에 된다. 취소는 마지막 마감월만 된다.
 * 4. 첫 마감의 기초는 원장(입고 − 출고) 합계, 그 다음 달부터는 전월 기말이다.
 * 5. 단위는 품목·창고다. 원장의 거래유형이 시기마다 섞여 있어 품목 단위로 평균한다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Calculator, Lock, Unlock } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import PartSearchField from '@/components/shared/PartSearchField';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { closeColumns, type CloseLine } from './close-columns';

interface CloseStatus {
  yyyymm: string;
  closed: boolean;
  closedAt: string | null;
  lastClosed: string | null;
  openingSource: 'ledger' | 'previousClose' | null;
  canClose: boolean;
  canCancel: boolean;
  reason: string | null;
}

const TIP = {
  month: '마감할 달입니다. 거래일 기준으로 그 달 1일부터 말일까지의 입고·출고를 모읍니다.',
  preview: '저장하지 않고 계산만 해서 보여 줍니다. 마감한 달이면 저장된 결과를 보여 줍니다.',
  close: '계산 결과를 마감으로 저장합니다. 다음 달 기초가 이 달 기말이 됩니다.',
  cancel: '이 달 마감을 지우고 미마감으로 돌립니다. 마지막 마감월만 취소할 수 있습니다.',
} as const;

const thisMonth = () => {
  const d = new Date();
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`;
};
const won = (n: number) => `${Math.round(n).toLocaleString()}원`;
const apiMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

export default function InventoryClosePage() {
  const [month, setMonth] = useState(thisMonth());
  const [itemCode, setItemCode] = useState('');
  const [status, setStatus] = useState<CloseStatus | null>(null);
  const [lines, setLines] = useState<CloseLine[]>([]);
  const [loading, setLoading] = useState(false);
  const [busy, setBusy] = useState(false);
  const [pending, setPending] = useState<'close' | 'cancel' | null>(null);
  const yyyymm = month.replace('-', '');

  const load = useCallback(async () => {
    if (!/^\d{6}$/.test(yyyymm)) return;
    setLoading(true);
    try {
      const r = await api.get('/inventory-query/close/preview', { params: { yyyymm }, timeout: 180_000 });
      setStatus(r.data?.data?.status ?? null);
      setLines(r.data?.data?.lines ?? []);
    } catch (error: unknown) {
      setLines([]);
      try {
        const s = await api.get('/inventory-query/close/status', { params: { yyyymm } });
        setStatus(s.data?.data ?? null);
      } catch {
        setStatus(null);
      }
      toast.error(apiMessage(error) ?? '계산에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [yyyymm]);

  useEffect(() => { void load(); }, [load]);

  const run = useCallback(async () => {
    if (!pending) return;
    setBusy(true);
    try {
      if (pending === 'close') {
        const r = await api.post('/inventory-query/close', { yyyymm }, { timeout: 180_000 });
        toast.success(`${month} 마감했습니다 — ${r.data?.data?.lines ?? 0}품목, 기말 ${won(r.data?.data?.endingAmt ?? 0)}.`);
      } else {
        await api.post('/inventory-query/close/cancel', { yyyymm });
        toast.success(`${month} 마감을 취소했습니다.`);
      }
      setPending(null);
      await load();
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [pending, yyyymm, month, load]);

  const shown = useMemo(() => {
    const q = itemCode.trim().toUpperCase();
    return q ? lines.filter((l) => l.itemCode.toUpperCase().includes(q)) : lines;
  }, [lines, itemCode]);

  const total = useMemo(() => {
    const sum = (k: keyof CloseLine) => shown.reduce((s, l) => s + Number(l[k] ?? 0), 0);
    return {
      opening: sum('openingAmt'),
      receipt: sum('receiptAmt'),
      issue: sum('issueAmt'),
      ending: sum('endingAmt'),
      unpriced: sum('unpriced'),
      negative: shown.filter((l) => l.endingQty < 0).length,
    };
  }, [shown]);

  const statusText = !status ? ''
    : status.closed ? `마감됨 · ${status.closedAt ?? ''}`
      : `미마감 · 기초: ${status.openingSource === 'ledger' ? '원장 합계(첫 마감)'
        : status.openingSource === 'previousClose' ? '전월 마감 기말' : '-'}`
        + (status.lastClosed ? ` · 마지막 마감 ${status.lastClosed}` : ' · 마감 이력 없음');

  return (
    <div className="flex h-full flex-col gap-3 p-6">
      <header className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-xl font-bold text-text">자재재고마감</h1>
          <p className="mt-1 text-sm text-text-muted">
            원자재 월마감 · 월평균단가 = (기초금액 + 입고금액) ÷ (기초수량 + 입고수량)
          </p>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          <Button size="sm" variant="secondary" data-tooltip={TIP.preview}
            onClick={() => load()} disabled={loading}>
            <Calculator className="mr-1 h-4 w-4" />계산
          </Button>
          <Button size="sm" data-tooltip={status?.reason ?? TIP.close}
            disabled={busy || loading || !status?.canClose} onClick={() => setPending('close')}>
            <Lock className="mr-1 h-4 w-4" />마감
          </Button>
          <Button size="sm" variant="secondary" data-tooltip={TIP.cancel}
            disabled={busy || loading || !status?.canCancel} onClick={() => setPending('cancel')}>
            <Unlock className="mr-1 h-4 w-4" />마감 취소
          </Button>
        </div>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <label className="text-sm font-semibold text-text" htmlFor="close-month" data-tooltip={TIP.month}>
            마감월
          </label>
          <Input id="close-month" type="month" value={month} className="w-40"
            onChange={(e) => setMonth(e.target.value)} />
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-40" onChange={(e) => setItemCode(e.target.value)} />
          <span className={`text-sm ${status?.closed ? 'text-primary' : 'text-text-muted'}`}>{statusText}</span>
          {status && !status.closed && status.reason && (
            <span className="text-sm text-amber-500">{status.reason}</span>
          )}
        </CardContent>
      </Card>

      <div className="grid grid-cols-2 gap-3 md:grid-cols-6">
        {[
          ['기초금액', won(total.opening)],
          ['입고금액', won(total.receipt)],
          ['출고금액', won(total.issue)],
          ['기말금액', won(total.ending)],
          ['단가 미등록 입고', `${total.unpriced.toLocaleString()}건`],
          ['기말 음수 품목', `${total.negative.toLocaleString()}품목`],
        ].map(([label, value]) => (
          <Card key={label} padding="none">
            <CardContent className="p-3">
              <div className="text-xs text-text-muted">{label}</div>
              <div className="mt-1 text-lg font-semibold text-text">{value}</div>
            </CardContent>
          </Card>
        ))}
      </div>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            toolbarLeft={(
              <span className="text-sm font-semibold text-text">
                {month} 원자재 {shown.length.toLocaleString()}품목
              </span>
            )}
            data={shown}
            columns={closeColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName={`원자재마감_${yyyymm}`}
            getRowId={(r) => `${(r as CloseLine).itemCode}|${(r as CloseLine).locationCode}`}
            emptyMessage="이 달에 기초·입고·출고가 있는 원자재가 없습니다."
          />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={Boolean(pending)}
        onClose={() => setPending(null)}
        onConfirm={run}
        title={pending === 'cancel' ? '마감 취소' : '월마감'}
        message={pending === 'cancel'
          ? `${month} 마감 결과를 지우고 미마감으로 돌립니다.`
          : `${month} 원자재를 월총평균법으로 마감합니다.`
            + `\n\n· 기말금액 ${won(total.ending)}, 단가 미등록 입고 ${total.unpriced.toLocaleString()}건(0원 처리).`
            + '\n· 마감한 달의 기말이 다음 달 기초가 됩니다.'}
        confirmText={pending === 'cancel' ? '마감 취소' : '마감'}
      />
    </div>
  );
}
