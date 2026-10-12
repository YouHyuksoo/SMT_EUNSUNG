"use client";

/**
 * @file src/app/(authenticated)/production/run-card-pid/page.tsx
 * @description 롯트카드-PID 매핑관리 — PB w_pln_product_pcb_kitting_scan_master 이식
 *
 * 초보자 가이드:
 * 1. **무엇을 하는 화면인가**: 작업지시(롯트카드) 하나에 실제 PCB 한 장씩(PID)을
 *    바코드로 찍어 붙인다. 이후 모든 공정·검사 이력이 이 PID 를 따라간다.
 * 2. **위에서 롯트카드를 고르면 아래에 그 PID 들이 나온다.** 롯트카드를 고르지 않으면
 *    PID 를 조회하지 않는다 — 제품바코드는 1.8억 행이라 작업지시 조건이 필수다.
 * 3. **스캐너는 키보드 방식이다.** 입력칸에 커서를 두고 찍으면 그대로 들어온다.
 *    별도 연동이 없고, 엔터까지 오면 바로 처리한다.
 * 4. **모델매칭**을 켜면 PID 7~11번째 다섯 글자가 롯트카드 모델과 같아야 통과한다.
 *    PB 체크박스와 같은 규칙이다.
 * 5. **QC 검사된 PID 는 취소할 수 없다.** 검사이력이 가리키는 바코드가 사라진다.
 */
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import toast from 'react-hot-toast';
import { Ban, ScanLine, Search, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { kittingPidColumns, kittingRunCardColumns } from '../planning-columns';
import type { KittingPidRow, KittingRunCardRow } from '../planning-types';

type ScanMode = 'scan' | 'cancel';

export default function RunCardPidPage() {
  const [runCards, setRunCards] = useState<KittingRunCardRow[]>([]);
  const [pids, setPids] = useState<KittingPidRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [pidLoading, setPidLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [runNoFilter, setRunNoFilter] = useState('');
  const [mfsGroupNo, setMfsGroupNo] = useState('');

  const [selected, setSelected] = useState<KittingRunCardRow | null>(null);
  const [mode, setMode] = useState<ScanMode>('scan');
  const [modelMatching, setModelMatching] = useState(true);
  const [scanValue, setScanValue] = useState('');
  const [status, setStatus] = useState<{ ok: boolean; text: string } | null>(null);
  const [scanCount, setScanCount] = useState(0);
  const [clearOpen, setClearOpen] = useState(false);
  const [busy, setBusy] = useState(false);
  const scanRef = useRef<HTMLInputElement>(null);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/production/run-card-pid/run-cards', {
        params: {
          runNo: runNoFilter || undefined,
          mfsGroupNo: mfsGroupNo || undefined,
        },
      });
      setRunCards(response.data?.data ?? []);
      setSearched(true);
      setSelected(null);
      setPids([]);
    } catch {
      toast.error('롯트카드 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [runNoFilter, mfsGroupNo]);

  const loadPids = useCallback(async (runNo: string) => {
    setPidLoading(true);
    try {
      const response = await api.get('/production/run-card-pid/pids', {
        params: { runNo },
      });
      setPids(response.data?.data ?? []);
    } catch {
      toast.error('PID 조회에 실패했습니다.');
      setPids([]);
    } finally {
      setPidLoading(false);
    }
  }, []);

  useEffect(() => {
    if (!selected) {
      setPids([]);
      return;
    }
    setScanCount(0);
    setStatus(null);
    void loadPids(selected.runNo);
  }, [selected, loadPids]);

  /** 스캔 한 건 처리. 성공하면 입력칸을 비우고 다시 포커스를 준다. */
  const handleScan = useCallback(async () => {
    const serialNo = scanValue.trim();
    if (!selected || serialNo === '') return;
    setBusy(true);
    try {
      const path = mode === 'scan'
        ? '/production/run-card-pid/scan'
        : '/production/run-card-pid/cancel';
      const body = mode === 'scan'
        ? { runNo: selected.runNo, serialNo, modelMatching: modelMatching ? 'Y' : 'N' }
        : { runNo: selected.runNo, serialNo };
      const response = await api.post(path, body);
      const count = Number(response.data?.data?.pidCount ?? 0);
      setStatus({
        ok: true,
        text: mode === 'scan' ? `매핑 완료 (${count}장)` : `취소 완료 (${count}장)`,
      });
      setScanCount((n) => n + 1);
      await loadPids(selected.runNo);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      setStatus({ ok: false, text: message ?? '처리에 실패했습니다.' });
    } finally {
      setScanValue('');
      setBusy(false);
      scanRef.current?.focus();
    }
  }, [scanValue, selected, mode, modelMatching, loadPids]);

  const clear = useCallback(async () => {
    if (!selected) return;
    setClearOpen(false);
    try {
      const response = await api.delete('/production/run-card-pid', {
        data: { runNo: selected.runNo },
      });
      toast.success(`PID ${response.data?.data?.deleted ?? 0}장을 해제했습니다.`);
      await loadPids(selected.runNo);
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '전체 해제에 실패했습니다.');
    }
  }, [selected, loadPids, search]);

  const qcScanned = useMemo(
    () => pids.filter((p) => p.qcScanYn === 'Y').length,
    [pids],
  );

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-text">롯트카드-PID 매핑관리</h1>
          <p className="mt-1 text-sm text-text-muted">
            작업지시에 제품 바코드(PID)를 붙입니다 ·{' '}
            {searched ? `롯트카드 ${runCards.length}건` : '조회하세요'}
          </p>
        </div>
        <Button size="sm" onClick={search} disabled={loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="작업지시번호" placeholder="작업지시번호" value={runNoFilter}
            className="w-44" onChange={(e) => setRunNoFilter(e.target.value)} />
          <Input aria-label="MFS 그룹번호" placeholder="MFS 그룹번호" value={mfsGroupNo}
            className="w-44" onChange={(e) => setMfsGroupNo(e.target.value)} />
        </CardContent>
      </Card>

      <Card className="h-64 shrink-0 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={runCards}
            columns={kittingRunCardColumns}
            isLoading={loading}
            pageSize={50}
            enableColumnFilter
            emptyMessage="조회 버튼을 눌러 롯트카드를 고르세요."
            onRowClick={(row) => setSelected(row as KittingRunCardRow)}
            getRowId={(row) => String((row as KittingRunCardRow).runNo)}
          />
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <div className="flex gap-1">
            {([
              { key: 'scan' as ScanMode, label: '스캔(매핑)' },
              { key: 'cancel' as ScanMode, label: '취소' },
            ]).map((m) => (
              <Button key={m.key} size="sm"
                variant={mode === m.key ? 'primary' : 'secondary'}
                onClick={() => { setMode(m.key); setStatus(null); scanRef.current?.focus(); }}>
                {m.key === 'scan'
                  ? <ScanLine className="mr-1 h-4 w-4" />
                  : <Ban className="mr-1 h-4 w-4" />}
                {m.label}
              </Button>
            ))}
          </div>
          <Input
            ref={scanRef}
            aria-label="PID 스캔"
            placeholder={selected ? 'PID 를 스캔하세요' : '먼저 위에서 롯트카드를 고르세요'}
            value={scanValue}
            disabled={!selected || busy}
            className="w-72"
            onChange={(e) => setScanValue(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === 'Enter') {
                e.preventDefault();
                void handleScan();
              }
            }}
          />
          {mode === 'scan' && (
            <label className="flex items-center gap-2 text-sm text-text">
              <input type="checkbox" checked={modelMatching}
                onChange={(e) => setModelMatching(e.target.checked)} />
              모델매칭 확인
            </label>
          )}
          <span className="text-sm text-text-muted">이번 세션 {scanCount}건</span>
          {status && (
            <span
              className={`rounded px-2 py-1 text-sm ${
                status.ok ? 'bg-emerald-500/15 text-emerald-600' : 'bg-red-500/15 text-red-600'
              }`}
            >
              {status.text}
            </span>
          )}
          <Button size="sm" variant="secondary" className="ml-auto"
            disabled={!selected || pids.length === 0}
            onClick={() => setClearOpen(true)}>
            <Trash2 className="mr-1 h-4 w-4 text-red-500" />전체 해제
          </Button>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="flex h-full flex-col gap-2 p-3">
          <b className="text-sm text-text">
            매핑된 PID
            {selected
              ? ` — ${selected.runNo} (${pids.length}장${qcScanned > 0 ? `, QC검사 ${qcScanned}장` : ''})`
              : ''}
          </b>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={pids}
              columns={kittingPidColumns}
              isLoading={pidLoading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="롯트카드PID매핑"
              emptyMessage={selected ? '아직 매핑된 PID 가 없습니다.' : '위에서 롯트카드를 고르세요.'}
              getRowId={(row) => String((row as KittingPidRow).serialNo)}
            />
          </div>
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={clearOpen}
        onClose={() => setClearOpen(false)}
        onConfirm={clear}
        title="PID 전체 해제"
        message={selected
          ? `${selected.runNo} 의 PID ${pids.length}장을 전부 해제할까요?`
            + (qcScanned > 0
              ? ` QC 검사된 PID ${qcScanned}장이 있어 거부됩니다.`
              : '')
          : ''}
        variant="danger"
      />
    </div>
  );
}
