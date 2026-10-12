"use client";

/**
 * @file src/app/(authenticated)/process-transaction/magazine-pid/page.tsx
 * @description 231 매거진-PID 매핑관리 — PB w_pln_product_barcode_create_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **어느 상자에 어느 기판이 들어갔는지 적는 화면이다.** 매거진 라벨을 먼저 찍고,
 *    담는 기판의 PID 를 하나씩 찍는다. 찍을 때마다 한 건씩 등록된다.
 * 2. **PID 는 10자 이상이어야 한다.** 짧으면 스캐너가 덜 읽은 것이라 거절한다.
 * 3. **같은 PID 를 두 번 찍으면 거절한다.** 다른 상자에 이미 들어간 PID 도 막는다 —
 *    PB 는 화면 목록만 봐서 이것을 놓쳤다. 같은 기판이 두 상자에 있다고 기록되면
 *    추적이 끊긴다.
 * 4. **취소는 이 상자에 들어간 것만 뺀다.** 검사가 이미 읽어 간 기록은 지우지 않는다.
 * 5. **엑셀 일괄등록은 옮기지 않았다** — 파일 업로드·검증 규칙이 따로 필요해
 *    스캔 경로부터 맞췄다.
 */
import { useCallback, useRef, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, Box, ScanLine, Undo2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { magazinePidColumns } from '../magazine-columns';
import type { MagazinePidRow } from '../magazine-columns';

interface Magazine {
  magazineLabelNo: string;
  runNo: string | null;
  itemCode: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  pcbItem: string | null;
  lotQty: number | null;
  receiptDate: string | null;
}

/** 스캔 모드 — PB `rb_normal` / `rb_repair` / `rb_cancel`. */
type ScanMode = 'normal' | 'repair' | 'cancel';

const MODE_LABEL: Record<ScanMode, string> = {
  normal: '정상 등록',
  repair: '수리품 등록',
  cancel: '취소(빼기)',
};

export default function MagazinePidPage() {
  const [magazineScan, setMagazineScan] = useState('');
  const [magazine, setMagazine] = useState<Magazine | null>(null);
  const [rows, setRows] = useState<MagazinePidRow[]>([]);
  const [mode, setMode] = useState<ScanMode>('normal');
  const [pid, setPid] = useState('');
  const [loading, setLoading] = useState(false);
  const [busy, setBusy] = useState(false);
  const [lastResult, setLastResult] = useState<string | null>(null);
  const { truncated, rowLimit, mark } = useTruncation();
  const pidRef = useRef<HTMLInputElement>(null);

  const loadRows = useCallback(async (magazineLabelNo: string) => {
    const r = await api.get('/process-transaction/magazine-pid', {
      params: { magazineLabelNo },
    });
    setRows(r.data?.data ?? []);
    mark(r);
  }, [mark]);

  const lookupMagazine = useCallback(async () => {
    const value = magazineScan.trim();
    if (!value) return;
    setLoading(true);
    try {
      const r = await api.post('/process-transaction/magazine-pid/lookup', {
        magazineLabelNo: value,
      });
      const data = r.data?.data as { magazine: Magazine | null; reason: string | null };
      if (!data?.magazine) {
        toast.error(data?.reason ?? '매거진 라벨을 찾을 수 없습니다.');
        setMagazine(null);
        setRows([]);
        return;
      }
      setMagazine(data.magazine);
      setLastResult(null);
      await loadRows(data.magazine.magazineLabelNo);
      pidRef.current?.focus();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [magazineScan, loadRows]);

  /** PID 를 찍으면 바로 처리하고 입력칸을 비운다 (현장은 연속으로 찍는다). */
  const scanPid = useCallback(async () => {
    const serialNo = pid.trim();
    if (!magazine || !serialNo) return;
    setBusy(true);
    try {
      if (mode === 'cancel') {
        await api.post('/process-transaction/magazine-pid/cancel', {
          magazineLabelNo: magazine.magazineLabelNo,
          serialNo,
        });
        setLastResult(`뺐습니다: ${serialNo}`);
      } else {
        await api.post('/process-transaction/magazine-pid', {
          magazineLabelNo: magazine.magazineLabelNo,
          serialNo,
          repair: mode === 'repair',
        });
        setLastResult(`등록했습니다: ${serialNo}`);
      }
      setPid('');
      await loadRows(magazine.magazineLabelNo);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '처리에 실패했습니다.');
      setLastResult(null);
      setPid('');
    } finally {
      setBusy(false);
      pidRef.current?.focus();
    }
  }, [magazine, pid, mode, loadRows]);

  const lotQty = Number(magazine?.lotQty ?? 0);
  const over = lotQty > 0 && rows.length > lotQty;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">매거진-PID 매핑관리</h1>
        <p className="mt-1 text-sm text-text-muted">
          상자에 담는 기판의 일련번호를 하나씩 찍습니다 ·{' '}
          {magazine
            ? `${magazine.magazineLabelNo} · ${rows.length.toLocaleString()}`
              + `${lotQty > 0 ? ` / ${lotQty.toLocaleString()}` : ''}건`
            : '매거진 라벨을 찍으세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <Box className="h-4 w-4" />매거진 라벨
          </span>
          <Input aria-label="매거진라벨번호" placeholder="매거진라벨번호"
            value={magazineScan} className="w-56" autoFocus
            onChange={(e) => setMagazineScan(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void lookupMagazine(); }} />
          <Button size="sm" onClick={lookupMagazine} disabled={loading}>조회</Button>
          {magazine && (
            <span className="text-sm text-text-muted">
              {magazine.modelName} · {magazine.lineName ?? magazine.lineCode}
              {magazine.runNo ? ` · 런카드 ${magazine.runNo}` : ''}
              {lotQty > 0 ? ` · 상자 수량 ${lotQty.toLocaleString()}` : ''}
            </span>
          )}
        </CardContent>
      </Card>

      {/* PID 스캔 (쓰기) */}
      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <ScanLine className="h-4 w-4" />PID 스캔
          </span>
          <div className="flex gap-1">
            {(['normal', 'repair', 'cancel'] as ScanMode[]).map((m) => (
              <Button key={m} size="sm"
                variant={mode === m ? 'primary' : 'secondary'}
                onClick={() => { setMode(m); pidRef.current?.focus(); }}>
                {m === 'cancel' && <Undo2 className="mr-1 h-4 w-4" />}
                {MODE_LABEL[m]}
              </Button>
            ))}
          </div>
          <Input ref={pidRef} aria-label="PID" placeholder="PID (10자 이상)"
            value={pid} className="w-72" disabled={!magazine || busy}
            onChange={(e) => setPid(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void scanPid(); }} />
          <Button size="sm" disabled={!magazine || busy || !pid.trim()}
            onClick={scanPid}>
            {mode === 'cancel' ? '빼기' : '등록'}
          </Button>
          {lastResult && (
            <span className="text-sm font-medium text-emerald-500">{lastResult}</span>
          )}
          {!magazine && (
            <span className="text-sm text-text-muted">
              매거진 라벨을 먼저 찍으세요.
            </span>
          )}
        </CardContent>
      </Card>

      {over && (
        <p className="flex items-center gap-1 text-sm text-amber-500">
          <AlertTriangle className="h-4 w-4" />
          등록된 PID({rows.length.toLocaleString()})가 상자 수량
          ({lotQty.toLocaleString()})보다 많습니다. 확인하세요.
        </p>
      )}

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={magazinePidColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="매거진PID매핑"
            enableColumnPinning
            defaultPinnedColumns={{ left: ['serialNo'] }}
            emptyMessage={magazine
              ? '이 상자에 등록된 PID 가 없습니다.'
              : '매거진 라벨을 찍으세요.'}
            onRowClick={(row) => {
              setPid((row as MagazinePidRow).serialNo);
              setMode('cancel');
              pidRef.current?.focus();
            }}
          />
        </CardContent>
      </Card>
    </div>
  );
}
