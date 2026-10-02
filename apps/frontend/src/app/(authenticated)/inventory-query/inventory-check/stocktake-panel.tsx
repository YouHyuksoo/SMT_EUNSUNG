/**
 * @file src/app/(authenticated)/inventory-query/inventory-check/stocktake-panel.tsx
 * @description 272 바코드 실사 진행 — 실사 시작 · 장부 다시 고정 · 일괄 조정
 *
 * 초보자 가이드:
 * 1. 실사 시작: 지금 장부(재고가 있는 롯트)를 실사표에 고정한다. 그 뒤 바코드를 찍는다
 *    (자재바코드스캔실사 화면 또는 PDA 자재 재고실사).
 * 2. 일괄 조정: 찍힌 롯트는 바코드 수량, 안 찍힌 롯트는 0 으로 보고 차이를 그 달 말일 조정으로
 *    넣는다. 이미 넣은 조정은 빼고 넣으므로 다시 눌러도 두 번 들어가지 않는다.
 * 3. 실사 중에는 입출고를 멈춘다 — 장부는 실사 시작 시점에 고정된다.
 */
import { useState } from 'react';
import toast from 'react-hot-toast';
import { ClipboardCheck, RefreshCw, Scale } from 'lucide-react';
import { Button, Card, CardContent, ConfirmModal } from '@/components/ui';
import { apiMessage, stocktakeApi, type StocktakeSession } from '../stocktake';

const thisMonth = () => {
  const d = new Date();
  return `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}`;
};

type Pending = 'start' | 'regenerate' | 'adjust' | null;

interface Props {
  session: StocktakeSession | null;
  /** 실사를 시작하거나 조정한 뒤 화면을 다시 읽는다. */
  onChanged: (yyyymm: string) => void;
}

export default function StocktakePanel({ session, onChanged }: Props) {
  const [pending, setPending] = useState<Pending>(null);
  const [busy, setBusy] = useState(false);
  const startMonth = thisMonth();

  const run = async () => {
    if (!pending) return;
    setBusy(true);
    try {
      if (pending === 'adjust' && session) {
        const r = await stocktakeApi.adjustAll(session.yyyymm);
        toast.success(`${r.adjusted.toLocaleString()}개 롯트를 조정했습니다.`);
        if (r.skipped.length) {
          toast.error(`재고 행이 없어 ${r.skipped.length}개 롯트를 건너뛰었습니다: `
            + r.skipped.slice(0, 5).map((s) => s.lotNo).join(', '), { duration: 10_000 });
        }
        onChanged(session.yyyymm);
      } else {
        const ym = pending === 'regenerate' && session ? session.yyyymm : startMonth;
        const r = await stocktakeApi.start(ym, pending === 'regenerate');
        toast.success(`${r.yyyymm} 실사표를 만들었습니다 — ${r.lots.toLocaleString()}개 롯트.`);
        onChanged(r.yyyymm);
      }
      setPending(null);
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  };

  const message = pending === 'adjust' && session
    ? `${session.yyyymm} 실사 결과로 재고를 조정합니다.`
      + `\n\n· 부족 ${session.shortLots.toLocaleString()}개 롯트, 초과 ${session.overLots.toLocaleString()}개 롯트`
      + `\n· 조정은 ${session.yyyymm} 마지막 날짜로 들어갑니다.`
      + '\n· 안 찍은 롯트는 없는 것으로 보고 재고에서 뺍니다.'
    : pending === 'regenerate' && session
      ? `${session.yyyymm} 실사표의 장부 수량을 지금 재고로 다시 고정합니다. 찍은 바코드는 그대로 반영됩니다.`
      : `${startMonth} 실사를 시작합니다. 지금 재고가 있는 롯트를 실사표에 고정합니다.`
        + '\n\n실사가 끝날 때까지 입출고를 멈추세요.';

  return (
    <Card padding="none">
      <CardContent className="flex flex-wrap items-center gap-3 p-3">
        <span className="flex items-center gap-1 text-sm font-semibold text-text">
          <ClipboardCheck className="h-4 w-4" />바코드 실사
        </span>
        {session ? (
          <span className="text-sm text-text">
            {session.yyyymm} 진행 중 · 장부 {session.bookLots.toLocaleString()}롯트 ·
            찍음 {session.countedLots.toLocaleString()} · 일치 {session.matchedLots.toLocaleString()} ·
            <span className="text-red-500"> 부족 {session.shortLots.toLocaleString()}</span> ·
            <span className="text-emerald-500"> 초과 {session.overLots.toLocaleString()}</span>
          </span>
        ) : (
          <span className="text-sm text-text-muted">진행 중인 실사가 없습니다.</span>
        )}
        <div className="ml-auto flex gap-2">
          {session ? (
            <>
              <Button size="sm" variant="secondary" disabled={busy}
                data-tooltip="장부 수량을 지금 재고로 다시 고정합니다. 조정을 넣기 전에만 됩니다."
                onClick={() => setPending('regenerate')}>
                <RefreshCw className="mr-1 h-4 w-4" />장부 다시 고정
              </Button>
              <Button size="sm" disabled={busy}
                data-tooltip="실사표의 차이를 그 달 마지막 날짜의 재고조정으로 넣습니다."
                onClick={() => setPending('adjust')}>
                <Scale className="mr-1 h-4 w-4" />일괄 조정
              </Button>
            </>
          ) : (
            <Button size="sm" disabled={busy}
              data-tooltip="지금 재고가 있는 롯트를 실사표에 고정하고 바코드 스캔을 받습니다."
              onClick={() => setPending('start')}>
              <ClipboardCheck className="mr-1 h-4 w-4" />{startMonth} 실사 시작
            </Button>
          )}
        </div>
      </CardContent>
      <ConfirmModal
        isOpen={Boolean(pending)}
        onClose={() => setPending(null)}
        onConfirm={run}
        title={pending === 'adjust' ? '일괄 조정' : pending === 'regenerate' ? '장부 다시 고정' : '실사 시작'}
        message={message}
        confirmText={pending === 'adjust' ? '조정' : '확인'}
      />
    </Card>
  );
}
