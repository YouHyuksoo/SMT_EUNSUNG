"use client";

/**
 * @file src/app/(authenticated)/quality/iqc/page.tsx
 * @description IQC 관리 — PB w_qc_iqc_master 이식
 *
 * 초보자 가이드:
 * 1. **판정 단위는 입고전표다.** 행을 고르면 그 행의 전표 전체가 판정 대상이 된다.
 *    같은 전표의 바코드가 여러 줄이면 한 번 판정으로 전부 처리된다 — PB 도 같다.
 * 2. **탭 3개** — 판정대기 / 판정취소 / 검사이력. 탭을 바꾸면 이전 결과·선택을 비운다.
 * 3. **기간은 필수다.** `IM_ITEM_RECEIPT_BARCODE` 가 190만 행이라 스캔일자 인덱스로
 *    좁히지 않으면 전체를 훑는다. PB 는 현장에서 늘 기간을 넣어 썼다.
 * 4. **ESD 점검주기가 10 이면 합격 버튼이 막힌다.** 먼저 ESD 점검을 처리해야 한다 — PB 규칙이다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { CheckCircle2, RotateCcw, Search, ShieldCheck, XCircle, Zap } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { ESD_CHECK_LIMIT, iqcHistoryColumns, iqcTargetColumns } from './columns';
import type { IqcHistoryRow, IqcTargetRow } from './types';
import PartSearchField from '@/components/shared/PartSearchField';

type Mode = 'wait' | 'cancel' | 'history';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const weekAgo = () => {
  const date = new Date();
  date.setDate(date.getDate() - 7);
  return isoDate(date);
};

export default function IqcPage() {
  const [mode, setMode] = useState<Mode>('wait');
  const [targets, setTargets] = useState<IqcTargetRow[]>([]);
  const [history, setHistory] = useState<IqcHistoryRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [dateFrom, setDateFrom] = useState(weekAgo);
  const [dateTo, setDateTo] = useState(today);
  const [itemCode, setItemCode] = useState('');
  const [itemName, setItemName] = useState('');
  const [itemBarcode, setItemBarcode] = useState('');
  const [receiptSlipNo, setReceiptSlipNo] = useState('');

  const [selected, setSelected] = useState<IqcTargetRow | null>(null);
  const [badReasonCode, setBadReasonCode] = useState('');
  const [busy, setBusy] = useState(false);
  const [confirm, setConfirm] = useState<'pass' | 'fail' | 'cancel' | 'esd' | null>(null);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      if (mode === 'history') {
        const response = await api.get('/quality/iqc/history', {
          params: {
            dateFrom, dateTo,
            itemCode: itemCode || undefined,
            iqcInspectNo: receiptSlipNo || undefined,
          },
        });
        setHistory(response.data?.data ?? []);
        setTotal(Number(response.data?.meta?.total ?? 0));
      } else {
        const response = await api.get('/quality/iqc/targets', {
          params: {
            dateFrom, dateTo, mode,
            itemCode: itemCode || undefined,
            itemName: itemName || undefined,
            itemBarcode: itemBarcode || undefined,
            receiptSlipNo: receiptSlipNo || undefined,
          },
        });
        setTargets(response.data?.data ?? []);
        setTotal(Number(response.data?.meta?.total ?? 0));
      }
      setSearched(true);
      setSelected(null);
    } catch {
      toast.error('IQC 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [mode, dateFrom, dateTo, itemCode, itemName, itemBarcode, receiptSlipNo]);

  const changeMode = useCallback((next: Mode) => {
    setMode(next);
    setTargets([]);
    setHistory([]);
    setTotal(0);
    setSearched(false);
    setSelected(null);
  }, []);

  const esdBlocked = Number(selected?.esdCheckCycleValue ?? 0) >= ESD_CHECK_LIMIT;

  const judge = useCallback(async (inspectResult: 'P' | 'R') => {
    if (!selected) return;
    setConfirm(null);
    setBusy(true);
    try {
      const response = await api.post('/quality/iqc/judge', {
        receiptSlipNo: selected.receiptSlipNo,
        inspectResult,
        badReasonCode: inspectResult === 'R' ? badReasonCode : undefined,
      });
      const created = Number(response.data?.data?.created ?? 0);
      toast.success(
        `${selected.receiptSlipNo} ${inspectResult === 'P' ? '합격' : '불합격'} 처리 · 검사이력 ${created}건`,
      );
      void search();
    } catch {
      toast.error(inspectResult === 'P'
        ? '합격 처리에 실패했습니다. ESD 점검주기를 확인하세요.'
        : '불합격 처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, badReasonCode, search]);

  const cancelJudge = useCallback(async () => {
    if (!selected) return;
    setConfirm(null);
    setBusy(true);
    try {
      const response = await api.put('/quality/iqc/cancel', {
        receiptSlipNo: selected.receiptSlipNo,
      });
      toast.success(`판정을 취소했습니다 · ${response.data?.data?.reverted ?? 0}건 대기로 복귀`);
      void search();
    } catch {
      toast.error('판정취소에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, search]);

  const esdCheckDone = useCallback(async () => {
    if (!selected?.supplierCode || !selected?.itemCode) return;
    setConfirm(null);
    setBusy(true);
    try {
      await api.put('/quality/iqc/esd-check', {
        supplierCode: selected.supplierCode,
        itemCode: selected.itemCode,
      });
      toast.success('ESD 점검을 처리했습니다. 점검주기가 초기화됐습니다.');
      void search();
    } catch {
      toast.error('ESD 점검 처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, search]);

  const targetCols = useMemo(() => iqcTargetColumns, []);
  const historyCols = useMemo(() => iqcHistoryColumns, []);
  const shown = mode === 'history' ? history.length : targets.length;

  return (
    <main className="flex h-full min-w-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <ShieldCheck className="h-6 w-6 text-primary" />IQC 관리
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            입고전표 단위로 수입검사를 판정하고 검사이력을 확인합니다 ·{' '}
            {searched ? `${shown}/${total}건` : '기간을 정하고 조회하세요'}
          </p>
        </div>
        <Button size="sm" onClick={search} disabled={loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter
            label={mode === 'history' ? '검사일' : '스캔일'}
            from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo}
          />
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-40" onChange={(e) => setItemCode(e.target.value)} />
          <Input aria-label="입고전표" placeholder="입고전표" value={receiptSlipNo}
            className="w-40" onChange={(e) => setReceiptSlipNo(e.target.value)} />
          {mode !== 'history' && (
            <>
              <Input aria-label="품목명" placeholder="품목명" value={itemName}
                className="w-40" onChange={(e) => setItemName(e.target.value)} />
              <Input aria-label="자재바코드" placeholder="자재바코드" value={itemBarcode}
                className="w-44" onChange={(e) => setItemBarcode(e.target.value)} />
            </>
          )}
        </CardContent>
      </Card>

      {mode !== 'history' && (
        <Card padding="none">
          <CardContent className="flex flex-wrap items-end gap-3 p-3">
            <div className="self-center text-sm">
              <b className="text-text">{mode === 'wait' ? 'IQC 판정' : '판정 취소'}</b>
              <div className="text-text-muted">
                {selected
                  ? `${selected.receiptSlipNo} · ${selected.itemCode ?? ''}${esdBlocked ? ' · ESD 점검필요' : ''}`
                  : '아래 목록에서 전표를 고르세요'}
              </div>
            </div>

            {mode === 'wait' ? (
              <>
                <Button size="sm" disabled={!selected || busy || esdBlocked}
                  onClick={() => setConfirm('pass')}>
                  <CheckCircle2 className="mr-1 h-4 w-4" />합격
                </Button>
                <label className="text-xs text-text-muted">
                  불량원인
                  <ComCodeSelect groupCode="BAD REASON CODE" includeAll={false}
                    value={badReasonCode} onChange={setBadReasonCode} className="w-40" />
                </label>
                <Button size="sm" variant="secondary"
                  disabled={!selected || busy || !badReasonCode}
                  onClick={() => setConfirm('fail')}>
                  <XCircle className="mr-1 h-4 w-4 text-red-500" />불합격
                </Button>
                <Button size="sm" variant="secondary"
                  disabled={!selected || busy || !esdBlocked}
                  onClick={() => setConfirm('esd')}>
                  <Zap className="mr-1 h-4 w-4 text-amber-500" />ESD 점검완료
                </Button>
              </>
            ) : (
              <Button size="sm" variant="secondary" disabled={!selected || busy}
                onClick={() => setConfirm('cancel')}>
                <RotateCcw className="mr-1 h-4 w-4" />판정취소
              </Button>
            )}
          </CardContent>
        </Card>
      )}

      <nav className="flex gap-1 border-b border-border" aria-label="조회 모드">
        {([['wait', '판정대기'], ['cancel', '판정취소'], ['history', '검사이력']] as const)
          .map(([key, label]) => (
            <button
              key={key}
              type="button"
              onClick={() => changeMode(key)}
              className={`px-3 py-1.5 text-sm ${
                mode === key
                  ? 'border-b-2 border-primary font-semibold text-text'
                  : 'text-text-muted'
              }`}
            >
              {label}
            </button>
          ))}
      </nav>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {mode === 'history' ? (
            <DataGrid
              data={history}
              columns={historyCols}
              isLoading={loading}
              pageSize={50}
              enableColumnFilter
              enableExport
              exportFileName="IQC검사이력"
              emptyMessage="조회 버튼을 눌러 검사이력을 확인하세요."
              getRowId={(row) => {
                const h = row as IqcHistoryRow;
                return `${h.inspectDate}|${h.inspectSequence}`;
              }}
            />
          ) : (
            <DataGrid
              data={targets}
              columns={targetCols}
              isLoading={loading}
              pageSize={50}
              enableColumnFilter
              enableExport
              exportFileName={mode === 'wait' ? 'IQC판정대기' : 'IQC판정취소대상'}
              emptyMessage="조회 버튼을 눌러 대상을 확인하세요."
              onRowClick={(row) => setSelected(row as IqcTargetRow)}
              rowClassName={(row) =>
                Number((row as IqcTargetRow).esdCheckCycleValue ?? 0) >= ESD_CHECK_LIMIT
                  ? 'bg-amber-50 dark:bg-amber-950/20'
                  : ''}
              getRowId={(row) => (row as IqcTargetRow).itemBarcode}
            />
          )}
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={confirm === 'pass'}
        onClose={() => setConfirm(null)}
        onConfirm={() => judge('P')}
        title="IQC 합격 판정"
        message={selected
          ? `입고전표 ${selected.receiptSlipNo} 을(를) 합격 처리합니다. 그 전표의 바코드 전부가 합격으로 바뀌고 검사이력이 남습니다.`
          : ''}
      />
      <ConfirmModal
        isOpen={confirm === 'fail'}
        onClose={() => setConfirm(null)}
        onConfirm={() => judge('R')}
        title="IQC 불합격 판정"
        message={selected
          ? `입고전표 ${selected.receiptSlipNo} 을(를) 불합격 처리합니다. 불량원인: ${badReasonCode}`
          : ''}
        variant="danger"
      />
      <ConfirmModal
        isOpen={confirm === 'cancel'}
        onClose={() => setConfirm(null)}
        onConfirm={cancelJudge}
        title="IQC 판정취소"
        message={selected
          ? `입고전표 ${selected.receiptSlipNo} 의 판정을 대기로 되돌립니다. 검사이력은 지워지지 않습니다. 이미 입고대조가 끝난 바코드는 되돌아가지 않습니다.`
          : ''}
        variant="danger"
      />
      <ConfirmModal
        isOpen={confirm === 'esd'}
        onClose={() => setConfirm(null)}
        onConfirm={esdCheckDone}
        title="ESD 점검 완료"
        message={selected
          ? `${selected.supplierCode} / ${selected.itemCode} 의 ESD 점검주기를 0 으로 되돌립니다. 그래야 합격 판정을 할 수 있습니다.`
          : ''}
      />
    </main>
  );
}
