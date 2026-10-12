"use client";

/**
 * @file src/app/(authenticated)/jig/mask-check/components/MaskTensionScanPanel.tsx
 * @description 메탈마스크 장력검사 등록 — PB w_mcn_jig_mask_tension_check_master 의 스캔·저장부 이식
 *
 * 초보자 가이드:
 * 1. 스캐너는 키보드 방식이다. 바코드를 스캔하면 Enter 가 따라오므로 그때 기준정보를 읽는다.
 * 2. PB 가 스캔 직후 막던 두 가지를 그대로 옮겼다 —
 *    (a) 장력 기준(min/max)이 없는 지그는 등록 불가
 *    (b) 이미 장력측정 완료(TENSION_CHECK_YN='Y')이고 사용중(U)이면 재등록 불가
 * 3. 판정은 장력 5개가 전부 기준 범위 안이면 합격(P), 하나라도 벗어나면 불합격(N)이다.
 *    범위를 벗어난 칸은 빨간색으로 보인다(PB 의 backcolor 규칙).
 * 4. 저장은 PKG_MES_MAC.SP_MASK_TENSION_CHECK 가 한다 — 검사 1건 등록 + 지그 상태 갱신.
 */
import { useCallback, useMemo, useRef, useState } from 'react';
import toast from 'react-hot-toast';
import { Save, ScanLine } from 'lucide-react';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';

interface JigScanInfo {
  jigCode: string;
  jigLotNo: string;
  jigName: string | null;
  jigSpec: string | null;
  minTension: number | null;
  maxTension: number | null;
  useStatus: string | null;
  tensionCheckYn: string | null;
  lastCleanDate: string | null;
  breakValue: number | null;
  hitValue: number | null;
}

interface Props {
  onRegistered: () => void;
}

const TENSION_KEYS = [0, 1, 2, 3, 4] as const;

export default function MaskTensionScanPanel({ onRegistered }: Props) {
  const inputRef = useRef<HTMLInputElement>(null);
  const [barcode, setBarcode] = useState('');
  const [info, setInfo] = useState<JigScanInfo | null>(null);
  const [tensions, setTensions] = useState<string[]>(['', '', '', '', '']);
  const [cleanYn, setCleanYn] = useState(false);
  const [comments, setComments] = useState('');
  const [busy, setBusy] = useState(false);

  const reset = useCallback(() => {
    setBarcode('');
    setInfo(null);
    setTensions(['', '', '', '', '']);
    setCleanYn(false);
    setComments('');
    inputRef.current?.focus();
  }, []);

  /** 스캔 → 기준정보 조회 + PB 가 막던 두 조건 검사 */
  const lookup = useCallback(async () => {
    const value = barcode.trim();
    if (!value || busy) return;
    setBusy(true);
    try {
      const response = await api.get('/jig/scan-lookup', {
        params: { jigLotNo: value, jigType: 'M' },
      });
      const found = response.data?.data as JigScanInfo;
      if (found.minTension == null || found.maxTension == null) {
        toast.error('장력 기준이 등록되지 않은 메탈마스크입니다.');
        reset();
        return;
      }
      if (found.tensionCheckYn === 'Y' && found.useStatus === 'U') {
        toast.error('이미 장력측정이 끝나 사용중인 메탈마스크입니다.');
        reset();
        return;
      }
      setInfo(found);
    } catch {
      toast.error('등록되지 않은 메탈마스크 바코드입니다.');
      reset();
    } finally {
      setBusy(false);
    }
  }, [barcode, busy, reset]);

  /** 기준 범위를 벗어난 칸 판정 (PB 의 backcolor 규칙) */
  const outOfRange = useMemo(() => tensions.map((text) => {
    if (!info || text.trim() === '') return false;
    const value = Number(text);
    if (Number.isNaN(value)) return true;
    return value < Number(info.minTension) || value > Number(info.maxTension);
  }), [tensions, info]);

  const save = useCallback(async () => {
    if (!info || busy) return;
    const entered = tensions.filter((t) => t.trim() !== '');
    if (entered.length === 0) return toast.error('장력을 1개 이상 입력하세요.');
    setBusy(true);
    try {
      await api.post('/jig/mask-check', {
        jigLotNo: info.jigLotNo,
        checkStatus: outOfRange.some(Boolean) ? 'N' : 'P',
        cleanYn: cleanYn ? 'Y' : 'N',
        tension1: tensions[0] === '' ? undefined : Number(tensions[0]),
        tension2: tensions[1] === '' ? undefined : Number(tensions[1]),
        tension3: tensions[2] === '' ? undefined : Number(tensions[2]),
        tension4: tensions[3] === '' ? undefined : Number(tensions[3]),
        tension5: tensions[4] === '' ? undefined : Number(tensions[4]),
        comments: comments || undefined,
      });
      toast.success(outOfRange.some(Boolean) ? '불합격으로 등록했습니다.' : '합격으로 등록했습니다.');
      reset();
      onRegistered();
    } catch {
      toast.error('장력검사 등록에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [info, busy, tensions, outOfRange, cleanYn, comments, reset, onRegistered]);

  return (
    <Card padding="none">
      <CardContent className="flex flex-col gap-3 p-3">
        <div className="flex flex-wrap items-center gap-4">
          <div className="flex items-center gap-2">
            <ScanLine className="h-5 w-5 text-primary" />
            <span className="text-sm font-semibold text-text">메탈마스크 바코드 스캔</span>
          </div>
          <Input
            ref={inputRef}
            autoFocus
            placeholder="바코드를 스캔하세요"
            value={barcode}
            disabled={busy || !!info}
            className="w-64"
            onChange={(event) => setBarcode(event.target.value)}
            onKeyDown={(event) => { if (event.key === 'Enter') void lookup(); }}
          />
          {info && (
            <>
              <span className="text-sm text-text">{info.jigName ?? info.jigCode}</span>
              <span className="text-sm text-text-muted">
                기준 {info.minTension} ~ {info.maxTension}
              </span>
              <span className="text-sm text-text-muted">
                최종세척 {info.lastCleanDate ? String(info.lastCleanDate).slice(0, 10) : '없음'}
              </span>
            </>
          )}
        </div>

        {info && (
          <div className="flex flex-wrap items-center gap-3">
            {TENSION_KEYS.map((index) => (
              <Input
                key={index}
                type="number"
                placeholder={`장력${index + 1}`}
                value={tensions[index]}
                className={`w-28 ${outOfRange[index] ? 'border-red-500 text-red-600' : ''}`}
                onChange={(event) => {
                  const next = [...tensions];
                  next[index] = event.target.value;
                  setTensions(next);
                }}
              />
            ))}
            <label className="flex items-center gap-1 text-sm text-text">
              <input type="checkbox" checked={cleanYn} onChange={(e) => setCleanYn(e.target.checked)} />
              세척
            </label>
            <Input
              placeholder="설명"
              value={comments}
              className="w-56"
              onChange={(event) => setComments(event.target.value)}
            />
            <Button size="sm" onClick={save} disabled={busy}>
              <Save className="mr-1 h-4 w-4" />
              {outOfRange.some(Boolean) ? '불합격 등록' : '합격 등록'}
            </Button>
            <Button size="sm" variant="secondary" onClick={reset} disabled={busy}>취소</Button>
          </div>
        )}
      </CardContent>
    </Card>
  );
}
