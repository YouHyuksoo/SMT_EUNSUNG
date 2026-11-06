"use client";

/**
 * @file warehouse/barcode-issue/IssueReturnWork.tsx
 * @description 자재바코드출고관리의 출고반품 작업부 — PB Process · Mass Issue Return 묶음.
 *
 * 초보자 가이드:
 * 1. 반품 조건(형태 · Bad · Line Manual Check · Auto Print · Auto Set Qty · Invoice)은 왼쪽
 *    패널에서 정하고 여기로 넘어온다.
 * 2. 바코드를 찍으면 서버가 풀어 본다 (창고 · 라인 · 현재 수량). Auto Set Qty 면 반품 수량에
 *    현재 수량이 채워진다. '반품' 을 눌러야 기록된다.
 * 3. 양품 반품은 바코드가 `품목-롯트-수량` 으로 바뀌므로 Auto Print 면 새 라벨을 바로 찍는다.
 *    Bad 반품은 불량 창고(M02)로만 넣고 라벨은 찍지 않는다 (PB 그대로).
 * 4. 아래 탭은 반품 이력과 로스(출고바코드반품 화면과 같은 조회)다.
 */
import { useCallback, useEffect, useRef, useState } from 'react';
import { flushSync } from 'react-dom';
import toast from 'react-hot-toast';
import { Printer, ScanLine, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import BarcodeScanInput from '@/components/shared/BarcodeScanInput';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import PartSearchField from '@/components/shared/PartSearchField';
import QtyInput from '@/components/shared/QtyInput';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { printPngLabelsInBrowser, renderLabelNodeToPngBase64, type LabelPrintMethod } from '@/services/label-print';
import { printAgentPng, PrintAgentUnavailableError } from '@/services/print-agent';
import { getTodayLocal } from '@/utils/date';
import { TruncationNotice, useTruncation } from '../../report/components/TruncationNotice';
import { issueLossColumns, issueReturnColumns } from '../issue-return-columns';
import type { IssueLossRow, IssueReturnRow } from '../issue-return-columns';
import ReelLabelSheet, { makeCode128Png, REEL_LABEL_MM, type ReelLabelItem, type ReelLabelRow } from './ReelLabelSheet';

export interface ReturnConditions {
  bad: boolean;
  lineManual: boolean;
  lineCode: string;
  autoPrint: boolean;
  autoQty: boolean;
  invoiceNo: string;
  modelName: string;
  printMethod: LabelPrintMethod;
}

interface ReturnLookup {
  itemCode: string | null;
  lotNo: string | null;
  labelType: string | null;
  locationCode: string | null;
  lineCode: string | null;
  currentQty: number | null;
  returnable: boolean;
  reason: string | null;
  barcodeRow: { receiptSlipNo?: string | null; itemName?: string | null; itemSpec?: string | null } | null;
}

interface ReturnResult {
  bad: boolean;
  itemCode: string;
  lotNo: string;
  lineCode: string;
  locationCode: string;
  returnQty: number;
  lossQty: number;
  newBarcode: string;
}

const LOCATION_NAMES: Record<string, string> = { M01: '양산 M01', M02: '불량 M02', M05: '벌크 M05', M06: '리볼대기 M06' };
/** 이 화면은 성공·실패를 직접 토스트로 알린다 — 공용 오류 창·성공 토스트를 겹쳐 띄우지 않는다. */
const QUIET = { suppressErrorModal: true, skipSuccessToast: true } as const;

const errorMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

type TabKey = 'returns' | 'losses';

export default function IssueReturnWork({ conditions }: { conditions: ReturnConditions }) {
  const [barcode, setBarcode] = useState('');
  const [lookup, setLookup] = useState<ReturnLookup | null>(null);
  const [returnQty, setReturnQty] = useState(0);
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [busy, setBusy] = useState(false);
  const [labelItems, setLabelItems] = useState<ReelLabelItem[]>([]);
  const labelRef = useRef<HTMLDivElement>(null);

  const [tab, setTab] = useState<TabKey>('returns');
  const [dateFrom, setDateFrom] = useState(getTodayLocal());
  const [dateTo, setDateTo] = useState(getTodayLocal());
  const [itemCode, setItemCode] = useState('');
  const [lotNo, setLotNo] = useState('');
  const [returns, setReturns] = useState<IssueReturnRow[]>([]);
  const [losses, setLosses] = useState<IssueLossRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const params = { dateFrom, dateTo, itemCode: itemCode || undefined, lotNo: lotNo || undefined };
      const r = await api.get(tab === 'returns' ? '/warehouse/issue-return' : '/warehouse/issue-return/losses', { params });
      if (tab === 'returns') setReturns(r.data?.data ?? []); else setLosses(r.data?.data ?? []);
      mark(r);
      setSearched(true);
    } catch (error: unknown) {
      toast.error(errorMessage(error) ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [tab, dateFrom, dateTo, itemCode, lotNo, mark]);

  useEffect(() => { void search(); }, [tab]); // eslint-disable-line react-hooks/exhaustive-deps

  const lookupBody = useCallback((value: string) => ({
    barcode: value,
    bad: conditions.bad,
    lineManual: conditions.lineManual,
    lineCode: conditions.lineCode || undefined,
  }), [conditions]);

  // 반품 조건이 바뀌면 다시 풀어 본다 (창고·라인이 조건에 따라 달라진다).
  const runLookup = useCallback(async (scanned?: string) => {
    const value = (scanned ?? barcode).trim();
    if (!value) return;
    setBarcode(value);
    setBusy(true);
    try {
      const r = await api.post('/warehouse/barcode-issue/return/lookup', lookupBody(value), QUIET);
      const result = r.data?.data as ReturnLookup | undefined;
      setLookup(result ?? null);
      if (conditions.autoQty && result?.currentQty != null) setReturnQty(Number(result.currentQty));
    } catch (error: unknown) {
      toast.error(errorMessage(error) ?? '바코드를 풀어 보지 못했습니다.');
      setLookup(null);
    } finally {
      setBusy(false);
    }
  }, [barcode, lookupBody, conditions.autoQty]);

  useEffect(() => { if (barcode.trim() && lookup) void runLookup(); },
    [conditions.bad, conditions.lineManual, conditions.lineCode]); // eslint-disable-line react-hooks/exhaustive-deps

  /** 반품 뒤 새 라벨 — PB Auto Print (d_mat_receipt_lot_barcode_rpt). */
  const printLabel = useCallback(async (code: string, lot: string) => {
    const r = await api.get('/warehouse/barcode-issue/reel-label', { params: { itemCode: code, lotNo: lot } });
    const rows = (r.data?.data ?? []) as ReelLabelRow[];
    if (rows.length === 0) throw new Error('출력할 라벨을 찾지 못했습니다.');
    const items = await Promise.all(rows.map(async (row) => ({ row, barcodeSrc: await makeCode128Png(row.itemBarcode) })));
    flushSync(() => setLabelItems(items));
    try {
      const nodes = Array.from(labelRef.current?.children ?? []).filter((n): n is HTMLElement => n instanceof HTMLElement);
      const { width, height } = REEL_LABEL_MM;
      const pngs: string[] = [];
      for (const node of nodes) pngs.push(await renderLabelNodeToPngBase64(node, width, height));
      if (conditions.printMethod === 'BROWSER') {
        await printPngLabelsInBrowser('자재 릴 라벨', pngs, width, height);
        return;
      }
      for (let i = 0; i < pngs.length; i += 1) {
        await printAgentPng({ jobId: `REEL-${items[i].row.itemBarcode}`, widthMm: width, heightMm: height, copies: 1, contentBase64: pngs[i] });
      }
    } catch (error: unknown) {
      if (error instanceof PrintAgentUnavailableError) {
        throw new Error('라벨 프린트 에이전트에 연결할 수 없습니다. 출력 방식을 \'브라우저 인쇄\'로 바꾸세요.');
      }
      throw error;
    } finally {
      setLabelItems([]);
    }
  }, [conditions.printMethod]);

  const submit = useCallback(async () => {
    setConfirmOpen(false);
    setBusy(true);
    try {
      const r = await api.post('/warehouse/barcode-issue/return', {
        ...lookupBody(barcode.trim()),
        returnQty,
        invoiceNo: conditions.invoiceNo.trim() || undefined,
        modelName: conditions.modelName.trim() || undefined,
      }, QUIET);
      const result = r.data?.data as ReturnResult | undefined;
      toast.success(result?.bad
        ? `불량 반품했습니다 (${result.locationCode} · 라인 ${result.lineCode}).`
        : `반품했습니다. 새 바코드 ${result?.newBarcode}`
          + (Number(result?.lossQty ?? 0) !== 0 ? ` (로스 ${Number(result?.lossQty).toLocaleString()})` : ''),
        { duration: 8000 });
      // 양품 반품만 새 라벨을 찍는다 (PB: Bad 면 Auto Print 를 끈다).
      if (result && !result.bad && conditions.autoPrint) {
        await printLabel(result.itemCode, result.lotNo).catch((error: unknown) =>
          toast.error(error instanceof Error ? `반품은 됐고 라벨 출력에 실패했습니다: ${error.message}` : '라벨 출력에 실패했습니다.'));
      }
      setBarcode(''); setLookup(null); setReturnQty(0);
      void search();
    } catch (error: unknown) {
      toast.error(errorMessage(error) ?? '반품에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [barcode, returnQty, lookupBody, conditions, printLabel, search]);

  const blocker = !barcode.trim()
    ? '바코드를 찍으세요.'
    : !lookup ? '바코드를 먼저 풀어 보세요 (Enter).'
      : !lookup.returnable ? lookup.reason
        : returnQty < 1 ? '반품 수량을 넣으세요.' : null;

  return (
    <div className="flex min-w-0 flex-1 flex-col gap-4">
      <Card padding="none">
        <CardContent className="flex flex-col gap-3 p-3">
          <div className="flex flex-wrap items-center gap-3">
            <span className="flex items-center gap-1 text-sm font-semibold text-text"><ScanLine className="h-4 w-4" />반품 스캔</span>
            <span className="rounded bg-primary/10 px-2 py-0.5 text-xs font-medium text-primary">
              Mass Return{conditions.bad ? ' · Bad' : ''}
            </span>
            <BarcodeScanInput aria-label="반품 바코드" placeholder="반품 바코드 스캔" value={barcode}
              onChange={setBarcode} onScan={(v) => void runLookup(v)} className="w-72" />
            <span className="text-sm text-text-muted">Scan Qty <b className="text-text">{lookup?.currentQty != null ? Number(lookup.currentQty).toLocaleString() : '-'}</b></span>
            <QtyInput aria-label="반품 수량" placeholder="반품 수량" value={returnQty} onChange={setReturnQty} className="w-28" />
            <Button size="sm" variant="secondary" disabled={busy || !barcode.trim()} onClick={() => void runLookup()}>풀어 보기</Button>
            <Button size="sm" disabled={busy || Boolean(blocker)} onClick={() => setConfirmOpen(true)}>반품</Button>
            {blocker && barcode && <span className="text-sm text-text-muted">{blocker}</span>}
          </div>
          {lookup?.itemCode && (
            <div className="flex flex-wrap gap-x-6 gap-y-1 rounded border border-border bg-surface-muted px-3 py-2 text-sm">
              <span>품목 <b>{lookup.itemCode}</b>{lookup.barcodeRow?.itemName ? ` (${lookup.barcodeRow.itemName})` : ''}</span>
              <span>롯트 <b>{lookup.lotNo ?? '-'}</b></span>
              <span>라벨유형 {lookup.labelType ?? '-'}</span>
              <span>창고 <b>{lookup.locationCode ? LOCATION_NAMES[lookup.locationCode] ?? lookup.locationCode : '-'}</b></span>
              <span>라인 <b>{lookup.lineCode ?? '-'}</b></span>
              <span>전표 {lookup.barcodeRow?.receiptSlipNo ?? '없음'}</span>
              {returnQty > 0 && lookup.currentQty != null && !conditions.bad && returnQty - Number(lookup.currentQty) !== 0 && (
                <span className="font-semibold text-red-500">로스 {(returnQty - Number(lookup.currentQty)).toLocaleString()}</span>
              )}
              {conditions.autoPrint && !conditions.bad && <span className="flex items-center gap-1 text-text-muted"><Printer className="h-4 w-4" />반품 뒤 새 라벨 출력</span>}
            </div>
          )}
        </CardContent>
      </Card>

      <ScreenTabs
        tabs={[
          { key: 'returns' as TabKey, label: '반품 이력', count: returns.length },
          { key: 'losses' as TabKey, label: '로스', count: losses.length },
        ]}
        active={tab}
        onChange={setTab}
      />
      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label={tab === 'returns' ? '반품일' : '발생일'} from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode} className="w-44"
            onChange={(e) => setItemCode(e.target.value)} onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="롯트번호" placeholder="롯트번호" value={lotNo} className="w-40" onChange={(e) => setLotNo(e.target.value)} />
          <Button size="sm" onClick={search} disabled={loading}><Search className="mr-1 h-4 w-4" />조회</Button>
        </CardContent>
      </Card>
      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />
      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'returns' ? (
            <DataGrid data={returns} columns={issueReturnColumns} isLoading={loading} pageSize={100}
              enableColumnFilter enableExport exportFileName="출고반품" enableColumnPinning
              defaultPinnedColumns={{ left: ['issueDate'] }}
              emptyMessage={searched ? '기간 안에 반품이 없습니다.' : '조회하세요.'} />
          ) : (
            <DataGrid data={losses} columns={issueLossColumns} isLoading={loading} pageSize={100}
              enableColumnFilter enableExport exportFileName="반품로스"
              emptyMessage={searched ? '기간 안에 로스가 없습니다.' : '조회하세요.'} />
          )}
        </CardContent>
      </Card>

      {/* 라벨 PNG 변환용 — 화면 밖에 그린다 */}
      <div ref={labelRef} aria-hidden style={{ position: 'fixed', left: -10000, top: 0 }}>
        {labelItems.map((item) => <ReelLabelSheet key={item.row.itemBarcode} item={item} />)}
      </div>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={submit}
        title={conditions.bad ? '불량 반품' : '출고반품'}
        message={conditions.bad
          ? `${lookup?.itemCode} ${returnQty.toLocaleString()}개를 불량 창고(M02)·라인 ${lookup?.lineCode} 로 반품합니다.`
          : `${lookup?.itemCode} 롯트 ${lookup?.lotNo} 를 ${returnQty.toLocaleString()}개로 반품합니다.`
            + ` 바코드가 ${lookup?.itemCode}-${lookup?.lotNo}-${returnQty} 로 바뀌므로 새 라벨을 붙여야 합니다.`}
        confirmText="반품"
      />
    </div>
  );
}
