/**
 * @file src/app/(authenticated)/inventory-query/inventory-check/scan-card.tsx
 * @description 274 바코드 스캔 입력 — 진행 중인 실사월에 바코드를 기록한다
 *
 * 초보자 가이드:
 * 1. 스캐너는 키보드처럼 입력하고 Enter 를 보낸다. 입력칸에 포커스를 두면 연속으로 찍힌다.
 * 2. 센 수량은 비워 두면 바코드 수량으로 센다. 일부 쓴 릴·벌크만 수량을 넣고 찍는다.
 * 3. "취소" 를 켜고 찍으면 그 바코드의 스캔 기록을 지운다.
 * 4. 엑셀 업로드는 바코드 목록을 한꺼번에 찍는 것이다 (../stocktake-upload-modal.tsx).
 */
import { useEffect, useRef, useState } from 'react';
import { FileSpreadsheet, ScanLine } from 'lucide-react';
import { Button, Card, CardContent, Input } from '@/components/ui';
import StocktakeUploadModal from '../stocktake-upload-modal';
import {
  apiMessage,
  stocktakeApi,
  type StocktakeSession,
} from '../stocktake';

interface Props {
  session: StocktakeSession;
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
  const [uploadOpen, setUploadOpen] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => { inputRef.current?.focus(); }, []);

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

  return (
    <Card padding="none">
      <CardContent className="flex flex-col gap-2 p-3">
        <div className="flex flex-wrap items-center gap-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <ScanLine className="h-4 w-4" />{session.yyyymm} 자재 실사 입력
          </span>
          <Input ref={inputRef} aria-label="자재 바코드" placeholder="자재 바코드를 찍으세요"
            value={barcode} className="w-80" disabled={busy} autoComplete="off"
            onChange={(e) => setBarcode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') { e.preventDefault(); void submit(); } }} />
          <Input aria-label="센 수량" placeholder="수량 (비우면 바코드 수량)"
            value={qty} className="w-56" inputMode="decimal" disabled={cancelMode}
            onChange={(e) => setQty(e.target.value)} />
          <label className="flex items-center gap-1 text-sm text-text">
            <input type="checkbox" checked={cancelMode}
              onChange={(e) => { setCancelMode(e.target.checked); inputRef.current?.focus(); }} />
            취소
          </label>
          <Button size="sm" variant="secondary" className="ml-auto" onClick={() => setUploadOpen(true)}
            data-tooltip="바코드(또는 롯트번호)·수량 목록 엑셀을 한꺼번에 반영합니다.">
            <FileSpreadsheet className="mr-1 h-4 w-4" />엑셀 업로드
          </Button>
        </div>
        {last && (
          <div className={`text-sm font-semibold ${last.ok ? 'text-emerald-600' : 'text-red-500'}`}>
            {last.text}
          </div>
        )}
      </CardContent>
      <StocktakeUploadModal isOpen={uploadOpen} title={`${session.yyyymm} 자재 실사`}
        endpoint="/inventory-query/stocktake/upload"
        template={{ headers: ['바코드', '롯트번호', '수량'], fileName: '자재재고실사_양식.xlsx' }}
        guide={<>첫 시트의 머리글에 <b>바코드</b> 또는 <b>롯트번호</b> 열이 있어야 합니다. <b>수량</b>을 비우면 바코드
          수량으로 셉니다. 이미 찍은 롯트는 엑셀 수량으로 고칩니다.</>}
        onClose={() => { setUploadOpen(false); inputRef.current?.focus(); }} onDone={onScanned} />
    </Card>
  );
}
