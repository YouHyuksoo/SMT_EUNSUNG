"use client";

/**
 * @file src/app/(authenticated)/jig/squeeze-check/components/SqueezeScanPanel.tsx
 * @description 스퀴즈 바코드 스캔 등록 — PB w_mcn_jig_squeeze_check_master 의 sle_barcode 이식
 *
 * 초보자 가이드:
 * 1. 현장 스캐너는 키보드 방식이라 별도 연동이 없다. 스캔하면 입력칸에 문자열이 찍히고
 *    Enter 가 따라온다. 그래서 Enter 핸들러 하나면 된다.
 * 2. 스캔 1회가 조회·판정·등록·지그상태 변경까지다(PKG_MES_MAC.SP_SQUEEZE_CHECK_SCAN).
 *    판정은 한계수명 < 사용횟수 이면 불합격(N)이다.
 * 3. 연속 스캔이 되도록 처리 후 입력칸을 비우고 포커스를 되돌린다.
 */
import { useCallback, useRef, useState } from 'react';
import toast from 'react-hot-toast';
import { ScanLine } from 'lucide-react';
import { Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';

interface Props {
  /** 등록 후 목록을 다시 읽는다 */
  onRegistered: () => void;
}

interface LastResult {
  jigLotNo: string;
  jigCheckStatus: string;
  breakValue: number | null;
  hitValue: number | null;
}

export default function SqueezeScanPanel({ onRegistered }: Props) {
  const inputRef = useRef<HTMLInputElement>(null);
  const [barcode, setBarcode] = useState('');
  const [busy, setBusy] = useState(false);
  const [last, setLast] = useState<LastResult | null>(null);

  const submit = useCallback(async () => {
    const value = barcode.trim();
    if (!value || busy) return;
    setBusy(true);
    try {
      const response = await api.post('/jig/squeeze-check/scan', { jigLotNo: value });
      const saved = response.data?.data ?? {};
      const status = String(saved.jigCheckStatus ?? '');
      setLast({
        jigLotNo: value,
        jigCheckStatus: status,
        breakValue: saved.breakValue ?? null,
        hitValue: saved.hitValue ?? null,
      });
      if (status === 'P') toast.success(`${value} 합격 등록`);
      else toast.error(`${value} 불합격 — 한계수명을 넘었습니다`);
      onRegistered();
    } catch {
      toast.error('등록되지 않은 스퀴즈 바코드입니다.');
    } finally {
      setBusy(false);
      setBarcode('');
      inputRef.current?.focus();
    }
  }, [barcode, busy, onRegistered]);

  return (
    <Card padding="none">
      <CardContent className="flex flex-wrap items-center gap-4 p-3">
        <div className="flex items-center gap-2">
          <ScanLine className="h-5 w-5 text-primary" />
          <span className="text-sm font-semibold text-text">스퀴즈 바코드 스캔</span>
        </div>
        <Input
          ref={inputRef}
          autoFocus
          placeholder="바코드를 스캔하세요"
          value={barcode}
          disabled={busy}
          className="w-72"
          onChange={(event) => setBarcode(event.target.value)}
          onKeyDown={(event) => { if (event.key === 'Enter') void submit(); }}
        />
        {last && (
          <div className="flex items-center gap-3 text-sm">
            <span className="text-text-muted">{last.jigLotNo}</span>
            <span className={last.jigCheckStatus === 'P' ? 'font-semibold text-emerald-600' : 'font-semibold text-red-600'}>
              {last.jigCheckStatus === 'P' ? '합격' : '불합격'}
            </span>
            <span className="text-text-muted">
              사용 {last.hitValue ?? 0} / 한계 {last.breakValue ?? 0}
            </span>
          </div>
        )}
      </CardContent>
    </Card>
  );
}
