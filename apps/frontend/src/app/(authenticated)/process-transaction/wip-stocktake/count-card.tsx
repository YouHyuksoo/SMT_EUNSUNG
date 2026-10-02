/**
 * @file src/app/(authenticated)/process-transaction/wip-stocktake/count-card.tsx
 * @description 공정 실사 입력 — 릴 바코드를 찍거나, 바코드 없는 자재는 품목코드와 수량을 넣는다
 *
 * 초보자 가이드:
 * 1. 바코드 칸: 스캐너는 키보드처럼 입력하고 Enter 를 보낸다. 수량을 비우면 라벨 수량, 쓰다 남은 릴은
 *    남은 수량을 먼저 넣고 찍는다.
 * 2. 품목 칸: 바코드가 없는 자재는 품목코드와 수량을 넣고 Enter. 같은 품목·라인을 다시 넣으려면 취소 후 넣는다.
 * 3. 라인은 기록용이다 (공정재고는 품목 단위라 라인별로 나누지 않는다).
 * 4. "취소" 를 켜고 넣으면 그 입력을 지운다.
 */
import { useEffect, useRef, useState } from 'react';
import { FileSpreadsheet, ScanLine } from 'lucide-react';
import { Button, Card, CardContent, Input } from '@/components/ui';
import LineSelect from '@/components/shared/LineSelect';
import PartSearchField from '@/components/shared/PartSearchField';
import StocktakeUploadModal from '../../inventory-query/stocktake-upload-modal';
import { apiMessage, wipApi, type WipSession } from './wip-stocktake';

interface Props {
  session: WipSession;
  onCounted: () => void;
}

export default function CountCard({ session, onCounted }: Props) {
  const [barcode, setBarcode] = useState('');
  const [itemCode, setItemCode] = useState('');
  const [qty, setQty] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [cancelMode, setCancelMode] = useState(false);
  const [busy, setBusy] = useState(false);
  const [last, setLast] = useState<{ ok: boolean; text: string } | null>(null);
  const [uploadOpen, setUploadOpen] = useState(false);
  const barcodeRef = useRef<HTMLInputElement>(null);

  useEffect(() => { barcodeRef.current?.focus(); }, []);

  const submit = async (by: 'barcode' | 'item') => {
    const code = (by === 'barcode' ? barcode : itemCode).trim();
    if (!code || busy) return;
    const input = {
      ...(by === 'barcode' ? { barcode: code } : { itemCode: code }),
      ...(qty.trim() === '' ? {} : { qty: Number(qty) }),
      ...(lineCode ? { lineCode } : {}),
    };
    setBusy(true);
    try {
      if (cancelMode) {
        const r = await wipApi.cancel(input);
        setLast({ ok: true, text: `취소함 · ${r.itemCode}${r.lotNo === '*' ? '' : ` / ${r.lotNo}`}` });
      } else {
        const r = (await wipApi.count(input)).last;
        if (r) {
          setLast({
            ok: true,
            text: `${r.itemCode} ${r.itemName ?? ''}${r.lotNo === '*' ? '' : ` / ${r.lotNo}`} · ${r.qty.toLocaleString()} 셈`
              + ` · 품목 실사 ${r.countedQty.toLocaleString()} / 장부 ${r.bookQty.toLocaleString()}`,
          });
        }
        setQty('');
      }
      onCounted();
    } catch (error: unknown) {
      setLast({ ok: false, text: apiMessage(error) ?? '처리에 실패했습니다.' });
    } finally {
      if (by === 'barcode') setBarcode(''); else setItemCode('');
      setBusy(false);
      if (by === 'barcode') barcodeRef.current?.focus();
    }
  };

  return (
    <Card padding="none">
      <CardContent className="flex flex-col gap-2 p-3">
        <div className="flex flex-wrap items-center gap-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <ScanLine className="h-4 w-4" />{session.yyyymm} 공정 실사 입력
          </span>
          <Input ref={barcodeRef} aria-label="자재 바코드" placeholder="릴 바코드를 찍으세요"
            value={barcode} className="w-72" disabled={busy} autoComplete="off"
            onChange={(e) => setBarcode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') { e.preventDefault(); void submit('barcode'); } }} />
          <PartSearchField aria-label="품목코드" placeholder="바코드 없는 자재 품목코드" value={itemCode}
            className="w-56" onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') { e.preventDefault(); void submit('item'); } }} />
          <Input aria-label="센 수량" placeholder="수량 (바코드는 비우면 라벨 수량)"
            value={qty} className="w-60" inputMode="decimal" disabled={cancelMode}
            onChange={(e) => setQty(e.target.value)} />
          <LineSelect labelPrefix="라인" value={lineCode} onChange={setLineCode} className="w-40" />
          <label className="flex items-center gap-1 text-sm text-text">
            <input type="checkbox" checked={cancelMode} onChange={(e) => setCancelMode(e.target.checked)} />
            취소
          </label>
          <Button size="sm" variant="secondary" className="ml-auto" onClick={() => setUploadOpen(true)}
            data-tooltip="바코드·품목코드·수량·라인 목록 엑셀을 한꺼번에 반영합니다.">
            <FileSpreadsheet className="mr-1 h-4 w-4" />엑셀 업로드
          </Button>
        </div>
        {last && (
          <div className={`text-sm font-semibold ${last.ok ? 'text-emerald-600' : 'text-red-500'}`}>{last.text}</div>
        )}
      </CardContent>
      <StocktakeUploadModal isOpen={uploadOpen} title={`${session.yyyymm} 공정 실사`}
        endpoint={wipApi.uploadEndpoint}
        template={{ headers: ['바코드', '품목코드', '수량', '라인'], fileName: '공정실사_양식.xlsx' }}
        guide={<>첫 시트의 머리글에 <b>바코드</b>(또는 롯트번호)나 <b>품목코드</b> 열이 있어야 합니다. 바코드 줄은
          <b> 수량</b>을 비우면 라벨 수량, 품목코드 줄은 수량이 꼭 있어야 합니다. <b>라인</b>은 기록용입니다.
          이미 넣은 롯트·품목은 엑셀 수량으로 고칩니다.</>}
        onClose={() => { setUploadOpen(false); barcodeRef.current?.focus(); }} onDone={onCounted} />
    </Card>
  );
}
