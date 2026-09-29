"use client";

/**
 * @file src/app/(authenticated)/product/components/FgScanPanel.tsx
 * @description 302·304·307·308 이 함께 쓰는 스캔 패널.
 *
 * 초보자 가이드:
 * 1. **네 화면이 하는 일은 같다** — 바코드를 찍어 DB 프로시저에 넘긴다. 다른 것은
 *    수량을 받는지(모델단위), 고객을 받는지(출하)뿐이라 한 곳에 모았다.
 * 2. **정상과 취소는 같은 버튼 묶음이다.** 프로시저도 `p_txn` 코드만 다르다.
 *    취소를 고르면 버튼이 빨개져서 무엇을 누르는지 헷갈리지 않는다.
 * 3. **찍으면 바로 처리하고 입력칸을 비운다.** 현장은 연속으로 찍는다.
 * 4. **창고코드는 브라우저에 기억시킨다** — PB 는 PC 설정 파일에 저장했다.
 */
import { useCallback, useEffect, useRef, useState } from 'react';
import toast from 'react-hot-toast';
import { ScanLine, Undo2 } from 'lucide-react';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';

export interface FgScanPanelProps {
  /** 호출할 엔드포인트 (예: `/product/fg/receipt`). */
  endpoint: string;
  /** 패널 제목. */
  title: string;
  /** 수량을 받는지 (모델단위 화면). */
  withQty?: boolean;
  /** 고객을 받는지 (출하 화면). */
  withCustomer?: boolean;
  /** 창고코드 기본값. PB 고정값은 제품창고 `P01` 이다. */
  defaultLocation?: string;
  /** 창고코드를 기억할 자리. 화면마다 따로 기억한다. */
  storageKey: string;
  /** 처리 성공 뒤 목록을 다시 읽는다. */
  onDone: () => void | Promise<void>;
}

export default function FgScanPanel({
  endpoint,
  title,
  withQty = false,
  withCustomer = false,
  defaultLocation = 'P01',
  storageKey,
  onDone,
}: FgScanPanelProps) {
  const [barcode, setBarcode] = useState('');
  const [qty, setQty] = useState('');
  const [customerCode, setCustomerCode] = useState('');
  const [locationCode, setLocationCode] = useState(defaultLocation);
  const [cancel, setCancel] = useState(false);
  const [busy, setBusy] = useState(false);
  const [lastResult, setLastResult] = useState<string | null>(null);
  const barcodeRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    try {
      const saved = window.localStorage.getItem(storageKey);
      if (saved) setLocationCode(saved);
    } catch { /* 저장소를 못 쓰면 기본값을 쓴다 */ }
  }, [storageKey]);

  useEffect(() => {
    try {
      if (locationCode) window.localStorage.setItem(storageKey, locationCode);
    } catch { /* 무시 */ }
  }, [locationCode, storageKey]);

  const blocker = !barcode.trim()
    ? '바코드를 찍으세요.'
    : !locationCode.trim()
      ? '창고코드를 넣으세요.'
      : withQty && !(Number(qty) > 0)
        ? '수량을 1 이상으로 넣으세요.'
        : withCustomer && !customerCode.trim()
          ? '고객코드를 넣으세요.'
          : null;

  const submit = useCallback(async () => {
    if (blocker) return;
    setBusy(true);
    try {
      await api.post(endpoint, {
        barcode: barcode.trim(),
        locationCode: locationCode.trim(),
        cancel,
        ...(withQty ? { qty: Number(qty) } : {}),
        ...(withCustomer ? { customerCode: customerCode.trim() } : {}),
      });
      setLastResult(`${cancel ? '취소했습니다' : '처리했습니다'}: ${barcode.trim()}`);
      setBarcode('');
      await onDone();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '처리에 실패했습니다.');
      setLastResult(null);
      setBarcode('');
    } finally {
      setBusy(false);
      barcodeRef.current?.focus();
    }
  }, [blocker, endpoint, barcode, locationCode, cancel, withQty, qty,
    withCustomer, customerCode, onDone]);

  return (
    <Card padding="none">
      <CardContent className="flex flex-wrap items-center gap-3 p-3">
        <span className="flex items-center gap-1 text-sm font-semibold text-text">
          <ScanLine className="h-4 w-4" />{title}
        </span>
        <div className="flex gap-1">
          <Button size="sm" variant={cancel ? 'secondary' : 'primary'}
            onClick={() => { setCancel(false); barcodeRef.current?.focus(); }}>
            정상
          </Button>
          <Button size="sm" variant={cancel ? 'danger' : 'secondary'}
            onClick={() => { setCancel(true); barcodeRef.current?.focus(); }}>
            <Undo2 className="mr-1 h-4 w-4" />취소
          </Button>
        </div>
        <Input ref={barcodeRef} aria-label="바코드" placeholder="바코드" value={barcode}
          className="w-64" autoFocus disabled={busy}
          onChange={(e) => setBarcode(e.target.value)}
          onKeyDown={(e) => { if (e.key === 'Enter') void submit(); }} />
        {withQty && (
          <Input aria-label="수량" placeholder="수량" value={qty} className="w-28"
            inputMode="numeric" disabled={busy}
            onChange={(e) => setQty(e.target.value)} />
        )}
        {withCustomer && (
          <Input aria-label="고객코드" placeholder="고객코드" value={customerCode}
            className="w-36" disabled={busy}
            onChange={(e) => setCustomerCode(e.target.value)} />
        )}
        <Input aria-label="창고코드" placeholder="창고코드" value={locationCode}
          className="w-28" disabled={busy}
          onChange={(e) => setLocationCode(e.target.value)} />
        <Button size="sm" disabled={busy || Boolean(blocker)} onClick={submit}
          variant={cancel ? 'danger' : 'primary'}>
          {cancel ? '취소 처리' : '처리'}
        </Button>
        {lastResult && (
          <span className={`text-sm font-medium ${cancel ? 'text-red-500' : 'text-emerald-500'}`}>
            {lastResult}
          </span>
        )}
        {blocker && barcode && (
          <span className="text-sm text-amber-500">{blocker}</span>
        )}
      </CardContent>
    </Card>
  );
}
