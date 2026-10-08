/**
 * @file src/app/(authenticated)/product/fg-stocktake/count-card.tsx
 * @description 제품 실사 입력 — 박스 바코드를 찍는다
 *
 * 초보자 가이드:
 * 1. 바코드 칸: 스캐너는 키보드처럼 입력하고 Enter 를 보낸다. 수량을 비우면 장부 수량으로 센다
 *    (장부에 없던 박스는 박스 라벨 수량). 쓰다 만 박스만 센 수량을 먼저 넣고 찍는다.
 * 2. "취소" 를 켜고 찍으면 센 것을 지운다. 이미 조정이 들어간 박스는 취소할 수 없다.
 * 3. 엑셀 업로드는 박스 바코드 목록을 한꺼번에 찍는 것이다.
 */
import { useEffect, useRef, useState } from 'react';
import { FileSpreadsheet, ScanLine } from 'lucide-react';
import { Button, Card, CardContent, Input } from '@/components/ui';
import StocktakeUploadModal from '../../inventory-query/stocktake-upload-modal';
import { apiMessage, fgApi, type FgSession } from './fg-stocktake';

interface Props {
  session: FgSession;
  onCounted: () => void;
}

export default function CountCard({ session, onCounted }: Props) {
  const [barcode, setBarcode] = useState('');
  const [qty, setQty] = useState('');
  const [cancelMode, setCancelMode] = useState(false);
  const [busy, setBusy] = useState(false);
  const [last, setLast] = useState<{ ok: boolean; text: string } | null>(null);
  const [uploadOpen, setUploadOpen] = useState(false);
  const barcodeRef = useRef<HTMLInputElement>(null);

  useEffect(() => { barcodeRef.current?.focus(); }, []);

  const submit = async () => {
    const code = barcode.trim();
    if (!code || busy) return;
    const input = { barcode: code, ...(qty.trim() === '' ? {} : { qty: Number(qty) }) };
    setBusy(true);
    try {
      if (cancelMode) {
        const r = await fgApi.cancel(input);
        setLast({ ok: true, text: `취소함 · ${r.barcode}` });
      } else {
        const r = (await fgApi.scan(input)).last;
        if (r) {
          setLast({
            ok: true,
            text: `${r.barcode} · ${r.modelName ?? ''}${r.modelSuffix && r.modelSuffix !== '*' ? ` ${r.modelSuffix}` : ''}`
              + ` · ${r.locationCode} · ${r.qty.toLocaleString()} 셈 (장부 ${r.bookQty.toLocaleString()})`
              + (r.newBox ? ' · 장부에 없던 박스' : ''),
          });
        }
        setQty('');
      }
      onCounted();
    } catch (error: unknown) {
      setLast({ ok: false, text: apiMessage(error) ?? '처리에 실패했습니다.' });
    } finally {
      setBarcode('');
      setBusy(false);
      barcodeRef.current?.focus();
    }
  };

  return (
    <Card padding="none">
      <CardContent className="flex flex-col gap-2 p-3">
        <div className="flex flex-wrap items-center gap-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <ScanLine className="h-4 w-4" />{session.yyyymm} 제품 실사 입력
          </span>
          <Input ref={barcodeRef} aria-label="박스 바코드" placeholder="박스 바코드를 찍으세요"
            value={barcode} className="w-80" disabled={busy} autoComplete="off"
            onChange={(e) => setBarcode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') { e.preventDefault(); void submit(); } }} />
          <Input aria-label="센 수량" placeholder="수량 (비우면 장부 수량, 쓰다 만 박스만)"
            value={qty} className="w-72" inputMode="decimal" disabled={cancelMode}
            onChange={(e) => setQty(e.target.value)} />
          <label className="flex items-center gap-1 text-sm text-text">
            <input type="checkbox" checked={cancelMode} onChange={(e) => setCancelMode(e.target.checked)} />
            취소
          </label>
          <Button size="sm" variant="secondary" className="ml-auto" onClick={() => setUploadOpen(true)}
            data-tooltip="박스 바코드와 수량 목록 엑셀을 한꺼번에 반영합니다.">
            <FileSpreadsheet className="mr-1 h-4 w-4" />엑셀 업로드
          </Button>
        </div>
        {last && (
          <div className={`text-sm font-semibold ${last.ok ? 'text-emerald-600' : 'text-red-500'}`}>{last.text}</div>
        )}
      </CardContent>
      <StocktakeUploadModal isOpen={uploadOpen} title={`${session.yyyymm} 제품 실사`}
        endpoint={fgApi.uploadEndpoint}
        template={{ headers: ['바코드', '수량'], fileName: '제품실사_양식.xlsx' }}
        guide={<>첫 시트의 머리글에 <b>바코드</b> 열이 있어야 합니다. <b>수량</b>을 비우면 장부 수량(장부에 없던
          박스는 박스 라벨 수량)으로 셉니다. 이미 센 박스는 엑셀 수량으로 고칩니다.</>}
        onClose={() => { setUploadOpen(false); barcodeRef.current?.focus(); }} onDone={onCounted} />
    </Card>
  );
}
