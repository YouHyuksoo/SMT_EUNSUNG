"use client";

/**
 * @file src/app/(authenticated)/product/fg-close/page.tsx
 * @description 제품 재고마감 — 모델 단위 월마감 (수량)
 *
 * 초보자 가이드:
 * 1. **기말 = 기초 + 입고 − 출고 + 조정.** 제품에는 원가가 없어 수량만 마감한다.
 *    입고·출고는 제품입고·제품출고(취소 반영), 조정은 제품 실사의 재고조정이다.
 * 2. **순서**: 계산(미리보기)은 언제든 된다. 마감은 첫 마감이거나 마지막 마감월의 다음 달만,
 *    그 달이 끝난 뒤에 된다. 취소는 마지막 마감월만 된다.
 * 3. 첫 마감의 기초는 입고 − 출고 + 조정 합계, 그 다음 달부터는 전월 기말이다. 자재 마감과 따로 닫는다.
 * 4. 실사 조정이 남아 있으면 경고가 뜬다. 마감을 막지는 않지만 조정을 끝내고 마감하는 것이 맞다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Calculator, Lock, Unlock } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import { fgCloseColumns } from './columns';
import { apiMessage, fgCloseApi, type FgCloseLine, type FgCloseStatus } from './fg-close';

const TIP = {
  month: '마감할 달입니다. 입고일·출고일·조정일 기준으로 그 달 1일부터 말일까지를 모읍니다.',
  preview: '저장하지 않고 계산만 해서 보여 줍니다. 마감한 달이면 저장된 결과를 보여 줍니다.',
  close: '계산 결과를 마감으로 저장합니다. 다음 달 기초가 이 달 기말이 됩니다.',
  cancel: '이 달 마감을 지우고 미마감으로 돌립니다. 마지막 마감월만 취소할 수 있습니다.',
} as const;

const thisMonth = () => {
  const d = new Date();
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`;
};
const qty = (n: number) => n.toLocaleString();

export default function FgClosePage() {
  const [month, setMonth] = useState(thisMonth());
  const [modelName, setModelName] = useState('');
  const [status, setStatus] = useState<FgCloseStatus | null>(null);
  const [lines, setLines] = useState<FgCloseLine[]>([]);
  const [loading, setLoading] = useState(false);
  const [busy, setBusy] = useState(false);
  const [pending, setPending] = useState<'close' | 'cancel' | null>(null);
  const yyyymm = month.replace('-', '');

  const load = useCallback(async () => {
    if (!/^\d{6}$/.test(yyyymm)) return;
    setLoading(true);
    try {
      const r = await fgCloseApi.preview(yyyymm);
      setStatus(r?.status ?? null);
      setLines(r?.lines ?? []);
    } catch (error: unknown) {
      setLines([]);
      try {
        setStatus(await fgCloseApi.status(yyyymm));
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
        const r = await fgCloseApi.close(yyyymm);
        toast.success(`${month} 마감했습니다 — ${r.lines.toLocaleString()}모델, 기말 ${qty(r.endingQty)}.`);
      } else {
        await fgCloseApi.cancel(yyyymm);
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
    const q = modelName.trim().toUpperCase();
    return q ? lines.filter((l) => l.modelName.toUpperCase().includes(q)) : lines;
  }, [lines, modelName]);

  const total = useMemo(() => {
    const sum = (k: keyof FgCloseLine) => shown.reduce((s, l) => s + Number(l[k] ?? 0), 0);
    return {
      opening: sum('openingQty'),
      receipt: sum('receiptQty'),
      issue: sum('issueQty'),
      adjust: sum('adjustQty'),
      ending: sum('endingQty'),
      negative: shown.filter((l) => l.endingQty < 0).length,
    };
  }, [shown]);

  const statusText = !status ? ''
    : status.closed ? `마감됨 · ${status.closedAt ?? ''}`
      : `미마감 · 기초: ${status.openingSource === 'ledger' ? '수불 합계(첫 마감)'
        : status.openingSource === 'previousClose' ? '전월 마감 기말' : '-'}`
        + (status.lastClosed ? ` · 마지막 마감 ${status.lastClosed}` : ' · 마감 이력 없음');

  return (
    <div className="flex h-full flex-col gap-3 p-6">
      <header className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-xl font-bold text-text">제품재고마감</h1>
          <p className="mt-1 text-sm text-text-muted">
            제품 월마감 (모델 단위, 수량) · 기말 = 기초 + 입고 − 출고 + 조정
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
          <label className="text-sm font-semibold text-text" htmlFor="fg-close-month" data-tooltip={TIP.month}>
            마감월
          </label>
          <Input id="fg-close-month" type="month" value={month} className="w-40"
            onChange={(e) => setMonth(e.target.value)} />
          <Input aria-label="모델" placeholder="모델명" value={modelName} className="w-48"
            onChange={(e) => setModelName(e.target.value)} />
          <span className={`text-sm ${status?.closed ? 'text-primary' : 'text-text-muted'}`}>{statusText}</span>
          {status && !status.closed && status.reason && (
            <span className="text-sm text-amber-500">{status.reason}</span>
          )}
        </CardContent>
      </Card>

      {status && !status.closed && status.pendingAdjustBoxes > 0 && (
        <div className="rounded-md border border-amber-500/40 bg-amber-500/10 px-3 py-2 text-sm text-amber-600">
          이 달 실사 조정이 {status.pendingAdjustBoxes.toLocaleString()}박스 남아 있습니다.
          제품실사에서 일괄 조정을 끝낸 뒤 마감하면 조정 수량이 기말에 반영됩니다.
        </div>
      )}

      <div className="grid grid-cols-2 gap-3 md:grid-cols-6">
        {[
          ['기초수량', qty(total.opening)],
          ['입고수량', qty(total.receipt)],
          ['출고수량', qty(total.issue)],
          ['재고조정', qty(total.adjust)],
          ['기말수량', qty(total.ending)],
          ['기말 음수 모델', `${total.negative.toLocaleString()}모델`],
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
                {month} 제품 {shown.length.toLocaleString()}모델 · 기말 = 기초 + 입고 − 출고 + 조정
              </span>
            )}
            data={shown}
            columns={fgCloseColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName={`제품마감_${yyyymm}`}
            getRowId={(r) => `${(r as FgCloseLine).modelName}|${(r as FgCloseLine).modelSuffix}`}
            emptyMessage="이 달에 기초·입고·출고·조정이 있는 제품이 없습니다."
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
          : `${month} 제품을 모델 단위로 마감합니다.`
            + `\n\n· 기말수량 ${qty(total.ending)} (기초 ${qty(total.opening)} + 입고 ${qty(total.receipt)} − 출고 ${qty(total.issue)} + 조정 ${qty(total.adjust)}).`
            + (status && status.pendingAdjustBoxes > 0 ? `\n· 실사 조정 ${status.pendingAdjustBoxes.toLocaleString()}박스가 아직 안 들어갔습니다.` : '')
            + '\n· 마감한 달의 기말이 다음 달 기초가 됩니다.'}
        confirmText={pending === 'cancel' ? '마감 취소' : '마감'}
      />
    </div>
  );
}
