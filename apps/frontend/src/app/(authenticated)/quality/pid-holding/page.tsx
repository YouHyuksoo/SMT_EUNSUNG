"use client";

/**
 * @file src/app/(authenticated)/quality/pid-holding/page.tsx
 * @description PID 홀딩관리 — PB w_pln_product_barcode_holding 이식
 *
 * 초보자 가이드:
 * 1. **PID · RUN번호 · 매거진번호 · BOX번호 중 최소 하나를 넣어야 조회된다.**
 *    제품바코드가 1억 8천만 행이고 이 넷에만 인덱스가 있다. 모델명·라인은 인덱스가 없어
 *    단독으로 쓰면 전체를 훑는다. PB 는 현장에서 늘 PID 를 찍어 썼다.
 * 2. **결과를 잘라 주지 않는다.** 홀딩 화면에서 잘린 목록은 "그 PID 가 없다" 와 구분이 안 된다.
 *    그래서 조건 없이 조회하면 결과를 주는 대신 무엇을 넣어야 하는지 알려 준다.
 * 3. **홀딩은 바코드상태를 바꾸는 것뿐이다** — 홀딩 'H' / 정상 'N'. 여러 PID 를 한 번에 바꾼다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Lock, LockOpen, Search, ShieldAlert } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { pidHoldingColumns, type PidHoldingRow } from '../pid-columns';

export default function PidHoldingPage() {
  const [rows, setRows] = useState<PidHoldingRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [serialNo, setSerialNo] = useState('');
  const [runNo, setRunNo] = useState('');
  const [magazineNo, setMagazineNo] = useState('');
  const [boxNo, setBoxNo] = useState('');
  const [modelName, setModelName] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [barcodeStatus, setBarcodeStatus] = useState('');

  const [picked, setPicked] = useState<Set<string>>(new Set());
  const [busy, setBusy] = useState(false);
  const [confirm, setConfirm] = useState<'H' | 'N' | null>(null);

  /** 인덱스가 있어 단독으로 조회를 좁힐 수 있는 조건 */
  const hasRequired = Boolean(
    serialNo.trim() || runNo.trim() || magazineNo.trim() || boxNo.trim(),
  );

  const search = useCallback(async () => {
    if (!hasRequired) {
      toast.error('PID · RUN번호 · 매거진번호 · BOX번호 중 최소 하나를 입력하세요.');
      return;
    }
    setLoading(true);
    try {
      const response = await api.get('/quality/pid/holding', {
        params: {
          serialNo: serialNo || undefined,
          runNo: runNo || undefined,
          magazineNo: magazineNo || undefined,
          boxNo: boxNo || undefined,
          modelName: modelName || undefined,
          lineCode: lineCode || undefined,
          barcodeStatus: barcodeStatus || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setPicked(new Set());
    } catch {
      toast.error('PID 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [hasRequired, serialNo, runNo, magazineNo, boxNo, modelName, lineCode, barcodeStatus]);

  const apply = useCallback(async (status: 'H' | 'N') => {
    setConfirm(null);
    if (picked.size === 0) return;
    setBusy(true);
    try {
      const response = await api.put('/quality/pid/holding', {
        serialNos: [...picked],
        barcodeStatus: status,
      });
      const changed = Number(response.data?.data?.changed ?? 0);
      toast.success(`${changed}건을 ${status === 'H' ? '홀딩' : '홀딩해제'} 했습니다.`);
      void search();
    } catch {
      toast.error('상태 변경에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [picked, search]);

  const toggle = useCallback((row: PidHoldingRow) => {
    setPicked((prev) => {
      const next = new Set(prev);
      if (next.has(row.serialNo)) next.delete(row.serialNo);
      else next.add(row.serialNo);
      return next;
    });
  }, []);

  const columns = useMemo(() => pidHoldingColumns, []);

  return (
    <main className="flex h-full min-w-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <ShieldAlert className="h-6 w-6 text-primary" />PID 홀딩관리
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            제품 PID 를 홀딩·해제해 후속 공정 진행을 막습니다 ·{' '}
            {searched ? `${rows.length}/${total}건 · ${picked.size}건 선택` : 'PID 를 입력하고 조회하세요'}
          </p>
        </div>
        <Button size="sm" onClick={search} disabled={loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-col gap-3 p-3">
          <div className="flex flex-wrap items-center gap-3">
            <span className="text-xs font-semibold text-text">
              아래 넷 중 최소 하나 (필수)
            </span>
            <Input aria-label="PID" placeholder="PID" value={serialNo}
              className="w-52" onChange={(e) => setSerialNo(e.target.value)}
              onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
            <Input aria-label="RUN번호" placeholder="RUN번호" value={runNo}
              className="w-40" onChange={(e) => setRunNo(e.target.value)} />
            <Input aria-label="매거진번호" placeholder="매거진번호" value={magazineNo}
              className="w-40" onChange={(e) => setMagazineNo(e.target.value)} />
            <Input aria-label="BOX번호" placeholder="BOX번호" value={boxNo}
              className="w-40" onChange={(e) => setBoxNo(e.target.value)} />
            {!hasRequired && (
              <span className="text-xs text-amber-600">
                제품바코드는 1억 8천만 행입니다. 이 조건 없이는 조회할 수 없습니다.
              </span>
            )}
          </div>
          <div className="flex flex-wrap items-center gap-3">
            <span className="text-xs text-text-muted">추가 조건</span>
            <Input aria-label="모델명" placeholder="모델명" value={modelName}
              className="w-44" onChange={(e) => setModelName(e.target.value)} />
            <LineSelect labelPrefix="라인" value={lineCode}
              onChange={setLineCode} className="w-40" />
            <ComCodeSelect groupCode="BARCODE STATUS" labelPrefix="바코드상태"
              value={barcodeStatus} onChange={setBarcodeStatus} className="w-48" />
          </div>
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="text-sm text-text-muted">
            {picked.size > 0 ? `${picked.size}건 선택` : '행을 클릭해 선택하세요'}
          </span>
          <Button size="sm" disabled={picked.size === 0 || busy}
            onClick={() => setConfirm('H')}>
            <Lock className="mr-1 h-4 w-4" />홀딩
          </Button>
          <Button size="sm" variant="secondary" disabled={picked.size === 0 || busy}
            onClick={() => setConfirm('N')}>
            <LockOpen className="mr-1 h-4 w-4" />홀딩해제
          </Button>
          {picked.size > 0 && (
            <Button size="sm" variant="secondary" onClick={() => setPicked(new Set())}>
              선택 해제
            </Button>
          )}
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={columns}
            isLoading={loading}
            pageSize={50}
            enableColumnFilter
            enableExport
            exportFileName="PID홀딩"
            emptyMessage="PID · RUN · 매거진 · BOX 중 하나를 넣고 조회하세요."
            onRowClick={(row) => toggle(row as PidHoldingRow)}
            rowClassName={(row) =>
              picked.has((row as PidHoldingRow).serialNo)
                ? 'bg-primary/10'
                : (row as PidHoldingRow).barcodeStatus === 'H'
                  ? 'bg-amber-50 dark:bg-amber-950/20'
                  : ''}
            getRowId={(row) => (row as PidHoldingRow).serialNo}
          />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={confirm !== null}
        onClose={() => setConfirm(null)}
        onConfirm={() => confirm && apply(confirm)}
        title={confirm === 'H' ? 'PID 홀딩' : 'PID 홀딩해제'}
        message={confirm === 'H'
          ? `선택한 ${picked.size}건을 홀딩합니다. 홀딩된 PID 는 후속 공정을 진행할 수 없습니다.`
          : `선택한 ${picked.size}건의 홀딩을 해제합니다.`}
        variant={confirm === 'H' ? 'danger' : undefined}
      />
    </main>
  );
}
