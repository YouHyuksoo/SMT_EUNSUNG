/**
 * @file src/app/(authenticated)/inventory-query/barcode-check/scan-card.tsx
 * @description 274 바코드 스캔 입력 — 진행 중인 실사월에 바코드를 기록한다
 *
 * 초보자 가이드:
 * 1. 스캐너는 키보드처럼 입력하고 Enter 를 보낸다. 입력칸에 포커스를 두면 연속으로 찍힌다.
 * 2. 센 수량은 비워 두면 바코드 수량으로 센다. 일부 쓴 릴·벌크만 수량을 넣고 찍는다.
 * 3. "취소" 를 켜고 찍으면 그 바코드의 스캔 기록을 지운다.
 */
import { useEffect, useRef, useState } from 'react';
import { ScanLine } from 'lucide-react';
import { Card, CardContent, Input } from '@/components/ui';
import {
  apiMessage,
  stocktakeApi,
  type StocktakeSession,
} from '../stocktake';

interface Props {
  session: StocktakeSession | null;
  /** 한 건 처리 뒤 목록·현황을 다시 읽는다. */
  onScanned: () => void;
}

type Last =
  | { ok: true; text: string }
  | { ok: false; text: string };

export default function ScanCard({ session, onScanned }: Props) {
  const [barcode, setBarcode] = useState('');
  const [qty, setQty] = useState('');
  const [cancelMode, setCancelMode] = useState(false);
  const [busy, setBusy] = useState(false);
  const [last, setLast] = useState<Last | null>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => { inputRef.current?.focus(); }, [session]);

  const submit = async () => {
    const code = barcode.trim();
    if (!code || busy) return;
    setBusy(true);
    try {
      if (cancelMode) {
        const r = await stocktakeApi.cancel(code);
        setLast({ ok: true, text: `취소함 · ${r.itemCode} / ${r.lotNo}` });
      } else {
        const counted = qty.trim() === '' ? undefined : Number(qty);
        const r = await stocktakeApi.scan(code, counted);
        const diff = r.differenceQty;
        setLast({
          ok: true,
          text: `${r.itemCode} ${r.itemName ?? ''} / ${r.lotNo} · 장부 ${r.bookQty.toLocaleString()}`
            + ` · 실사 ${r.countedQty.toLocaleString()}`
            + (diff === 0 ? ' · 일치' : ` · 차이 ${diff > 0 ? '+' : ''}${diff.toLocaleString()}`),
        });
        setQty('');
      }
      onScanned();
    } catch (error: unknown) {
      setLast({ ok: false, text: apiMessage(error) ?? '처리에 실패했습니다.' });
    } finally {
      setBarcode('');
      setBusy(false);
      inputRef.current?.focus();
    }
  };

  if (!session) {
    return (
      <Card padding="none">
        <CardContent className="p-3 text-sm text-text-muted">
          진행 중인 실사가 없습니다. 자재재고조사 화면에서 실사를 시작하면 여기서 바코드를 찍을 수 있습니다.
        </CardContent>
      </Card>
    );
  }

  return (
    <Card padding="none">
      <CardContent className="flex flex-col gap-2 p-3">
        <div className="flex flex-wrap items-center gap-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <ScanLine className="h-4 w-4" />{session.yyyymm} 실사 스캔
          </span>
          <Input ref={inputRef} aria-label="자재 바코드" placeholder="자재 바코드를 찍으세요"
            value={barcode} className="w-80" disabled={busy} autoComplete="off"
            onChange={(e) => setBarcode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') { e.preventDefault(); void submit(); } }} />
          <Input aria-label="센 수량" placeholder="센 수량 (비우면 바코드 수량)"
            value={qty} className="w-56" inputMode="decimal" disabled={cancelMode}
            onChange={(e) => setQty(e.target.value)} />
          <label className="flex items-center gap-1 text-sm text-text">
            <input type="checkbox" checked={cancelMode}
              onChange={(e) => { setCancelMode(e.target.checked); inputRef.current?.focus(); }} />
            취소
          </label>
          <span className="text-sm text-text-muted">
            찍음 {session.countedLots.toLocaleString()} / 장부 {session.bookLots.toLocaleString()}롯트
          </span>
        </div>
        {last && (
          <div className={`text-sm font-semibold ${last.ok ? 'text-emerald-600' : 'text-red-500'}`}>
            {last.text}
          </div>
        )}
      </CardContent>
    </Card>
  );
}
