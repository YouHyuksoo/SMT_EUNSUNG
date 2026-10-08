"use client";

/**
 * @file src/app/(authenticated)/process-transaction/wip-close/page.tsx
 * @description 공정재고마감 — 품목 단위 월마감
 *
 * 초보자 가이드:
 * 1. **기말 = 기초 + 입고 − 출고.** 공정입고·공정출고(취소 반영)를 품목별로 모은다.
 *    출고에 들어 있는 공정실사 조정은 "재고조정" 열에 따로도 보인다 (출고에 포함).
 * 2. **단가**는 그 달 원자재 마감의 월평균단가다. 없으면 직전 달 공정 마감 단가, 그것도 없으면 0 원.
 *    그래서 원자재 재고마감을 먼저 해야 마감할 수 있다.
 * 3. **순서**: 계산(미리보기)은 언제든 된다. 마감은 첫 마감이거나 마지막 마감월의 다음 달만,
 *    그 달이 끝난 뒤에 된다. 취소는 마지막 마감월만 된다.
 * 4. 첫 마감의 기초는 현재 공정재고에서 그 달 이후 움직임을 뺀 값이고, 그 다음 달부터는 전월 기말이다.
 * 5. 공정실사 조정이 남아 있으면 경고가 뜬다. 마감을 막지는 않지만 조정을 끝내고 마감하는 것이 맞다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Calculator, Lock, Unlock } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import { wipCloseColumns } from './columns';
import { apiMessage, wipCloseApi, type WipCloseLine, type WipCloseStatus } from './wip-close';

const TIP = {
  month: '마감할 달입니다. 입고일·출고일 기준으로 그 달 1일부터 말일까지를 모읍니다.',
  preview: '저장하지 않고 계산만 해서 보여 줍니다. 마감한 달이면 저장된 결과를 보여 줍니다.',
  close: '계산 결과를 마감으로 저장합니다. 다음 달 기초가 이 달 기말이 됩니다.',
  cancel: '이 달 마감을 지우고 미마감으로 돌립니다. 마지막 마감월만 취소할 수 있습니다.',
} as const;

const thisMonth = () => {
  const d = new Date();
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`;
};
const qty = (n: number) => n.toLocaleString();

export default function WipClosePage() {
  const [month, setMonth] = useState(thisMonth());
  const [itemCode, setItemCode] = useState('');
  const [status, setStatus] = useState<WipCloseStatus | null>(null);
  const [lines, setLines] = useState<WipCloseLine[]>([]);
  const [unpriced, setUnpriced] = useState(0);
  const [loading, setLoading] = useState(false);
  const [busy, setBusy] = useState(false);
  const [pending, setPending] = useState<'close' | 'cancel' | null>(null);
  const yyyymm = month.replace('-', '');

  const load = useCallback(async () => {
    if (!/^\d{6}$/.test(yyyymm)) return;
    setLoading(true);
    try {
      const r = await wipCloseApi.preview(yyyymm);
      setStatus(r?.status ?? null);
      setLines(r?.lines ?? []);
      setUnpriced(r?.unpriced ?? 0);
    } catch (error: unknown) {
      setLines([]);
      setUnpriced(0);
      try {
        setStatus(await wipCloseApi.status(yyyymm));
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
        const r = await wipCloseApi.close(yyyymm);
        toast.success(`${month} 마감했습니다 — ${r.lines.toLocaleString()}품목, 기말금액 ${qty(Math.round(r.endingAmt))}.`);
      } else {
        await wipCloseApi.cancel(yyyymm);
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
    const sum = (k: keyof WipCloseLine) => shown.reduce((s, l) => s + Number(l[k] ?? 0), 0);
    return {
      openingQty: sum('openingQty'), openingAmt: sum('openingAmt'),
      receiptQty: sum('receiptQty'), receiptAmt: sum('receiptAmt'),
      issueQty: sum('issueQty'), issueAmt: sum('issueAmt'),
      adjustQty: sum('adjustQty'), adjustAmt: sum('adjustAmt'),
      endingQty: sum('endingQty'), endingAmt: sum('endingAmt'),
    };
  }, [shown]);

  const statusText = !status ? ''
    : status.closed ? '마감됨'
      : `미마감 · 기초: ${status.openingSource === 'inventory' ? '현재 공정재고에서 역산(첫 마감)'
        : status.openingSource === 'previousClose' ? '전월 마감 기말' : '-'}`
        + (status.lastClosed ? ` · 마지막 마감 ${status.lastClosed}` : ' · 마감 이력 없음');

  const cards: [string, number, number][] = [
    ['기초', total.openingQty, total.openingAmt],
    ['입고', total.receiptQty, total.receiptAmt],
    ['출고', total.issueQty, total.issueAmt],
    ['재고조정', total.adjustQty, total.adjustAmt],
    ['기말', total.endingQty, total.endingAmt],
  ];

  return (
    <div className="flex h-full flex-col gap-3 p-6">
      <header className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-xl font-bold text-text">공정재고마감</h1>
          <p className="mt-1 text-sm text-text-muted">
            공정재고 월마감 (품목 단위) · 기말 = 기초 + 입고 − 출고
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
          <label className="text-sm font-semibold text-text" htmlFor="wip-close-month" data-tooltip={TIP.month}>
            마감월
          </label>
          <Input id="wip-close-month" type="month" value={month} className="w-40"
            onChange={(e) => setMonth(e.target.value)} />
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCode} className="w-48"
            onChange={(e) => setItemCode(e.target.value)} />
          <span className={`text-sm ${status?.closed ? 'text-primary' : 'text-text-muted'}`}>{statusText}</span>
          {status && !status.closed && status.reason && (
            <span className="text-sm text-amber-500">{status.reason}</span>
          )}
        </CardContent>
      </Card>

      {status?.openingSource === 'inventory' && !status.closed && (
        <div className="rounded-md border border-border bg-surface px-3 py-2 text-sm text-text-muted">
          첫 마감 — 기초는 현재 공정재고에서 그 달 이후 움직임을 뺀 값입니다.
        </div>
      )}
      {status && !status.closed && !status.materialClosed && (
        <div className="rounded-md border border-amber-500/40 bg-amber-500/10 px-3 py-2 text-sm text-amber-600">
          원자재 재고마감을 먼저 해야 마감할 수 있습니다. 단가를 그 달 원자재 마감 월평균단가에서 가져옵니다.
        </div>
      )}
      {status && !status.closed && status.pendingAdjustItems > 0 && (
        <div className="rounded-md border border-amber-500/40 bg-amber-500/10 px-3 py-2 text-sm text-amber-600">
          이 달 공정실사 조정이 {status.pendingAdjustItems.toLocaleString()}품목 남아 있습니다.
          공정실사에서 일괄 조정을 끝낸 뒤 마감하면 조정 수량이 기말에 반영됩니다.
        </div>
      )}
      {status && !status.closed && unpriced > 0 && (
        <div className="rounded-md border border-amber-500/40 bg-amber-500/10 px-3 py-2 text-sm text-amber-600">
          단가 없는 품목 {unpriced.toLocaleString()}개(금액 0)가 있습니다.
        </div>
      )}

      <div className="grid grid-cols-2 gap-3 md:grid-cols-5">
        {cards.map(([label, q, a]) => (
          <Card key={label} padding="none">
            <CardContent className="p-3">
              <div className="text-xs text-text-muted">{label}</div>
              <div className="mt-1 text-lg font-semibold text-text">{qty(Math.round(q * 10000) / 10000)}</div>
              <div className="text-xs text-text-muted">금액 {qty(Math.round(a))}</div>
            </CardContent>
          </Card>
        ))}
      </div>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            toolbarLeft={(
              <span className="text-sm font-semibold text-text">
                {month} 공정 {shown.length.toLocaleString()}품목 · 기말 = 기초 + 입고 − 출고 · 단가 = 그 달 원자재 마감 월평균단가
              </span>
            )}
            data={shown}
            columns={wipCloseColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName={`공정마감_${yyyymm}`}
            getRowId={(r) => (r as WipCloseLine).itemCode}
            emptyMessage="이 달에 기초·입고·출고가 있는 공정 품목이 없습니다."
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
          : `${month} 공정재고를 품목 단위로 마감합니다.`
            + `\n\n· 기말수량 ${qty(total.endingQty)}, 기말금액 ${qty(Math.round(total.endingAmt))} (기초 ${qty(total.openingQty)} + 입고 ${qty(total.receiptQty)} − 출고 ${qty(total.issueQty)}).`
            + (status && status.pendingAdjustItems > 0 ? `\n· 공정실사 조정 ${status.pendingAdjustItems.toLocaleString()}품목이 아직 안 들어갔습니다.` : '')
            + (unpriced > 0 ? `\n· 단가 없는 품목 ${unpriced.toLocaleString()}개는 금액이 0 입니다.` : '')
            + '\n· 마감한 달의 기말이 다음 달 기초가 됩니다.'}
        confirmText={pending === 'cancel' ? '마감 취소' : '마감'}
      />
    </div>
  );
}
