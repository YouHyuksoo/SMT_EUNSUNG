"use client";

/**
 * @file src/app/(authenticated)/quality/oqc/page.tsx
 * @description OQC 검사이력관리(PID) — PB w_qc_oqc_inspect_history_master 이식
 *
 * 초보자 가이드:
 * 1. **PID 단위 출하검사 이력이다.** 항번은 SEQ_QC_OQC_INSPECT_NO 로 서버가 채번한다.
 * 2. **PID 스캔 1회 = 검사 1건.** 현장 스캐너는 키보드 방식이라 Enter 핸들러 하나면 된다.
 * 3. 이 테이블은 이 DB 에서 0행이다 — 은성에서 아직 쓰지 않은 기능이다.
 * 4. LOT 단위 검사는 별도 화면이다 (OQC 검사이력(LOT)).
 */
import { useCallback, useMemo, useRef, useState } from 'react';
import toast from 'react-hot-toast';
import { PackageCheck, ScanLine, Search, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ModelSearchField from '@/components/shared/ModelSearchField';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { oqcHistoryColumns, type OqcHistoryRow } from '../notify-columns';
import PartSearchField from '@/components/shared/PartSearchField';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const weekAgo = () => {
  const date = new Date();
  date.setDate(date.getDate() - 7);
  return isoDate(date);
};

export default function OqcPage() {
  const scanRef = useRef<HTMLInputElement>(null);
  const [rows, setRows] = useState<OqcHistoryRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [dateFrom, setDateFrom] = useState(weekAgo);
  const [dateTo, setDateTo] = useState(today);
  const [productId, setProductId] = useState('');
  const [modelName, setModelName] = useState('');
  const [itemCode, setItemCode] = useState('');
  const [inspectResult, setInspectResult] = useState('');

  const [barcode, setBarcode] = useState('');
  const [scanResult, setScanResult] = useState('P');
  const [badReasonCode, setBadReasonCode] = useState('');
  const [inspectQty, setInspectQty] = useState('1');
  const [comments, setComments] = useState('');
  const [busy, setBusy] = useState(false);

  const [selected, setSelected] = useState<OqcHistoryRow | null>(null);
  const [deleteOpen, setDeleteOpen] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/quality/oqc', {
        params: {
          dateFrom, dateTo,
          productId: productId || undefined,
          modelName: modelName || undefined,
          itemCode: itemCode || undefined,
          inspectResult: inspectResult || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setSelected(null);
    } catch {
      toast.error('OQC 검사이력 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, productId, modelName, itemCode, inspectResult]);

  const scan = useCallback(async () => {
    const pid = barcode.trim();
    if (!pid || busy) return;
    if (scanResult === 'R' && !badReasonCode) {
      toast.error('불합격이면 불량원인을 고르세요.');
      return;
    }
    setBusy(true);
    try {
      const response = await api.post('/quality/oqc', {
        productId: pid,
        inspectResult: scanResult,
        badReasonCode: scanResult === 'R' ? badReasonCode : undefined,
        inspectQty: inspectQty.trim() === '' ? undefined : Number(inspectQty),
        defectQty: scanResult === 'R' ? Number(inspectQty || 1) : 0,
        comments: comments || undefined,
      });
      toast.success(`${pid} 검사 ${response.data?.data?.inspectSequence ?? ''}번 등록`);
      void search();
    } catch {
      toast.error('등록에 실패했습니다.');
    } finally {
      setBusy(false);
      setBarcode('');
      scanRef.current?.focus();
    }
  }, [barcode, busy, scanResult, badReasonCode, inspectQty, comments, search]);

  const remove = useCallback(async () => {
    if (!selected) return;
    setDeleteOpen(false);
    try {
      await api.delete('/quality/oqc', {
        data: {
          inspectDateKey: selected.inspectDateKey,
          inspectSequence: selected.inspectSequence,
        },
      });
      toast.success('삭제되었습니다.');
      void search();
    } catch {
      toast.error('삭제에 실패했습니다.');
    }
  }, [selected, search]);

  const columns = useMemo(() => oqcHistoryColumns, []);

  return (
    <main className="flex h-full min-w-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <PackageCheck className="h-6 w-6 text-primary" />OQC 검사이력관리 (PID)
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            PID 단위 출하검사를 등록하고 이력을 조회합니다 ·{' '}
            {searched ? `${rows.length}/${total}건` : '기간을 정하고 조회하세요'}
          </p>
        </div>
        <div className="flex gap-2">
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <Button size="sm" variant="secondary" disabled={!selected}
            onClick={() => setDeleteOpen(true)}>
            <Trash2 className="mr-1 h-4 w-4 text-red-500" />삭제
          </Button>
        </div>
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
            검사수량
            <Input type="number" value={inspectQty} className="w-24"
              onChange={(e) => setInspectQty(e.target.value)} />
          </label>
          <label className="text-xs text-text-muted">
            비고
            <Input value={comments} className="w-48"
              onChange={(e) => setComments(e.target.value)} />
          </label>
          <label className="text-xs text-text-muted">
            PID 스캔
            <Input
              ref={scanRef}
              autoFocus
              placeholder="PID 를 스캔하세요"
              value={barcode}
              disabled={busy}
              className="w-56"
              onChange={(e) => setBarcode(e.target.value)}
              onKeyDown={(e) => { if (e.key === 'Enter') void scan(); }}
            />
          </label>
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="검사일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input aria-label="PID" placeholder="PID" value={productId}
            className="w-52" onChange={(e) => setProductId(e.target.value)} />
          <ModelSearchField value={modelName} onChange={(v) => setModelName(v)}
            className="w-44" aria-label="모델명" placeholder="모델명" />
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-40" onChange={(e) => setItemCode(e.target.value)} />
          <ComCodeSelect groupCode="INSPECT RESULT" labelPrefix="판정"
            value={inspectResult} onChange={setInspectResult} className="w-40" />
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
            exportFileName="OQC검사이력"
            emptyMessage="조회 버튼을 눌러 검사이력을 확인하세요."
            onRowClick={(row) => setSelected(row as OqcHistoryRow)}
            getRowId={(row) => {
              const r = row as OqcHistoryRow;
              return `${r.inspectDate}|${r.inspectSequence}`;
            }}
          />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={deleteOpen}
        onClose={() => setDeleteOpen(false)}
        onConfirm={remove}
        title="OQC 검사이력 삭제"
        message={selected ? `검사항번 ${selected.inspectSequence} 이력을 삭제할까요?` : ''}
        variant="danger"
      />
    </main>
  );
}
