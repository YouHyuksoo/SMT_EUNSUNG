"use client";

/**
 * @file src/app/(authenticated)/quality/oqc-lot/page.tsx
 * @description OQC 검사이력관리(LOT) — PB w_qc_oqc_inspect_history_4_lot_master 이식
 *
 * 초보자 가이드:
 * 1. **LOT 단위는 매거진 포장 건을 본다** — `IP_PRODUCT_PACK_MASTER` 에서
 *    PACK_TYPE='M'(매거진) 이면서 DIVIDE_FLAG='N'(미분할) 인 것만. PB 조건 그대로다.
 * 2. **포장바코드를 스캔해 검사이력을 남긴다.** 이력 자체는 PID 화면과 같은 테이블
 *    (IQ_OQC_INSPECT_HISTORY) 에 쌓이고, PRODUCT_ID 에 포장바코드가 들어간다.
 * 3. 하단은 그 포장바코드로 남은 검사이력이다.
 */
import { useCallback, useMemo, useRef, useState } from 'react';
import toast from 'react-hot-toast';
import { Boxes, ScanLine, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ModelSearchField from '@/components/shared/ModelSearchField';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import {
  oqcHistoryColumns,
  oqcLotColumns,
  type OqcHistoryRow,
  type OqcLotRow,
} from '../notify-columns';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const weekAgo = () => {
  const date = new Date();
  date.setDate(date.getDate() - 7);
  return isoDate(date);
};

export default function OqcLotPage() {
  const scanRef = useRef<HTMLInputElement>(null);
  const [rows, setRows] = useState<OqcLotRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [dateFrom, setDateFrom] = useState(weekAgo);
  const [dateTo, setDateTo] = useState(today);
  const [packBarcode, setPackBarcode] = useState('');
  const [modelName, setModelName] = useState('');

  const [barcode, setBarcode] = useState('');
  const [scanResult, setScanResult] = useState('P');
  const [badReasonCode, setBadReasonCode] = useState('');
  const [comments, setComments] = useState('');
  const [busy, setBusy] = useState(false);

  const [history, setHistory] = useState<OqcHistoryRow[]>([]);
  const [historyLoading, setHistoryLoading] = useState(false);
  const [lastBarcode, setLastBarcode] = useState('');

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/quality/oqc/lots', {
        params: {
          dateFrom, dateTo,
          packBarcode: packBarcode || undefined,
          modelName: modelName || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
    } catch {
      toast.error('OQC 검사대상 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, packBarcode, modelName]);

  const loadHistory = useCallback(async (code: string) => {
    setHistoryLoading(true);
    try {
      const response = await api.get('/quality/oqc', {
        params: { dateFrom: '2000-01-01', dateTo: today(), productId: code },
      });
      setHistory(response.data?.data ?? []);
      setLastBarcode(code);
    } catch {
      toast.error('검사이력 조회에 실패했습니다.');
    } finally {
      setHistoryLoading(false);
    }
  }, []);

  const scan = useCallback(async () => {
    const code = barcode.trim();
    if (!code || busy) return;
    if (scanResult === 'R' && !badReasonCode) {
      toast.error('불합격이면 불량원인을 고르세요.');
      return;
    }
    setBusy(true);
    try {
      const matched = rows.find((row) => row.packBarcode === code);
      const response = await api.post('/quality/oqc', {
        productId: code,
        modelName: matched?.modelName ?? undefined,
        modelSuffix: matched?.modelSuffix ?? undefined,
        inspectResult: scanResult,
        badReasonCode: scanResult === 'R' ? badReasonCode : undefined,
        inspectQty: matched?.packQty ?? 1,
        defectQty: scanResult === 'R' ? (matched?.packQty ?? 1) : 0,
        comments: comments || undefined,
      });
      toast.success(`${code} 검사 ${response.data?.data?.inspectSequence ?? ''}번 등록`);
      void loadHistory(code);
    } catch {
      toast.error('등록에 실패했습니다.');
    } finally {
      setBusy(false);
      setBarcode('');
      scanRef.current?.focus();
    }
  }, [barcode, busy, scanResult, badReasonCode, comments, rows, loadHistory]);

  const lotCols = useMemo(() => oqcLotColumns, []);
  const historyCols = useMemo(() => oqcHistoryColumns, []);

  return (
    <main className="flex h-full min-w-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <Boxes className="h-6 w-6 text-primary" />OQC 검사이력관리 (LOT)
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            매거진 포장 단위로 출하검사를 등록하고 검사대상을 조회합니다 ·{' '}
            {searched ? `${rows.length}/${total}건` : '기간을 정하고 조회하세요'}
          </p>
        </div>
        <Button size="sm" onClick={search} disabled={loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-end gap-3 p-3">
          <div className="flex items-center gap-2 self-center">
            <ScanLine className="h-5 w-5 text-primary" />
            <span className="text-sm font-semibold text-text">검사 등록</span>
          </div>
          <label className="text-xs text-text-muted">
            판정
            <ComCodeSelect groupCode="INSPECT RESULT" includeAll={false}
              value={scanResult} onChange={setScanResult} className="w-32" />
          </label>
          <label className="text-xs text-text-muted">
            불량원인
            <ComCodeSelect groupCode="BAD REASON CODE" includeAll={false}
              value={badReasonCode} onChange={setBadReasonCode} className="w-40" />
          </label>
          <label className="text-xs text-text-muted">
            비고
            <Input value={comments} className="w-48"
              onChange={(e) => setComments(e.target.value)} />
          </label>
          <label className="text-xs text-text-muted">
            포장바코드 스캔
            <Input
              ref={scanRef}
              autoFocus
              placeholder="포장바코드를 스캔하세요"
              value={barcode}
              disabled={busy}
              className="w-60"
              onChange={(e) => setBarcode(e.target.value)}
              onKeyDown={(e) => { if (e.key === 'Enter') void scan(); }}
            />
          </label>
          <span className="self-center text-xs text-text-muted">
            검사수량은 그 포장의 수량으로 들어갑니다
          </span>
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="포장일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input aria-label="포장바코드" placeholder="포장바코드" value={packBarcode}
            className="w-52" onChange={(e) => setPackBarcode(e.target.value)} />
          <ModelSearchField value={modelName} onChange={(v) => setModelName(v)}
            className="w-44" aria-label="모델명" placeholder="모델명" />
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={lotCols}
            isLoading={loading}
            pageSize={50}
            enableColumnFilter
            enableExport
            exportFileName="OQC검사대상LOT"
            emptyMessage="조회 버튼을 눌러 검사대상을 확인하세요."
            onRowClick={(row) => void loadHistory((row as OqcLotRow).packBarcode)}
            getRowId={(row) => (row as OqcLotRow).packBarcode}
          />
        </CardContent>
      </Card>

      {lastBarcode && (
        <Card padding="none" className="h-48 shrink-0 overflow-hidden">
          <CardContent className="flex h-full flex-col p-3">
            <b className="mb-2 text-sm text-text">검사이력 — {lastBarcode}</b>
            <div className="min-h-0 flex-1">
              <DataGrid
                data={history}
                columns={historyCols}
                isLoading={historyLoading}
                pageSize={20}
                emptyMessage="검사이력이 없습니다."
                getRowId={(row) => {
                  const r = row as OqcHistoryRow;
                  return `${r.inspectDate}|${r.inspectSequence}`;
                }}
              />
            </div>
          </CardContent>
        </Card>
      )}
    </main>
  );
}
