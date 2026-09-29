"use client";

/**
 * @file src/app/(authenticated)/warehouse/barcode-receipt/page.tsx
 * @description 자재바코드입고관리 — PB w_mat_other_receipt_barcode_master 이식
 *
 * 초보자 가이드:
 * 1. **입고대조를 하는 화면이다.** 협력사가 붙여 보낸 바코드와 우리가 붙인 바코드를
 *    **둘 다 찍어서** 같은 물건인지 맞춰 본다. 맞으면 그 자리에서 입고가 된다.
 * 2. **대조되지 않은 바코드는 재고가 아니다.** 라벨은 있지만 입고 원장에 없으므로
 *    출고할 수 없다. '대조 대기' 탭에 남아 있는 것이 그것이다.
 * 3. **스캐너는 키보드처럼 입력된다.** 별도 연동이 없고, 입력칸에서 Enter 가 곧 스캔이다.
 *    협력사 바코드 → Enter → 자사 바코드 → Enter 순서로 찍는다.
 * 4. **자사 바코드를 찍으면 먼저 풀어 본다.** 품목·롯트·수량과 전표 상태를 보여주고,
 *    품목 설정에 따라 협력사 롯트 입력칸을 연다. 실제 입고는 '대조' 를 눌러야 한다 —
 *    PB 는 찍는 순간 입고까지 해버려서 잘못 찍으면 되돌릴 수 없었다.
 * 5. **탭 4개**는 PB 라디오버튼 묶음과 우측 버튼에 대응한다.
 *    대조 대기 / 바코드 이력 / 입고 이력 / 미입고 발행.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, ScanLine, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import {
  barcodeColumns,
  barcodeReceiptColumns,
  noReceiptBarcodeColumns,
} from '../barcode-receipt-columns';
import type {
  BarcodeCompareResult,
  BarcodeReceiptRow,
  BarcodeRow,
  BarcodeScanLookup,
  NoReceiptBarcodeRow,
} from '../barcode-receipt-columns';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

type TabKey = 'waiting' | 'barcodes' | 'receipts' | 'noReceipt';

const TAB_LABELS: Record<TabKey, string> = {
  waiting: '대조 대기',
  barcodes: '바코드 이력',
  receipts: '입고 이력',
  noReceipt: '미입고 발행',
};

export default function BarcodeReceiptPage() {
  const [tab, setTab] = useState<TabKey>('waiting');

  // 조회 조건
  const [itemCode, setItemCode] = useState('');
  const [barcodeCond, setBarcodeCond] = useState('');
  const [lotNo, setLotNo] = useState('');
  const [slipNo, setSlipNo] = useState('');
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(daysAgo(0));

  const [waiting, setWaiting] = useState<BarcodeRow[]>([]);
  const [barcodes, setBarcodes] = useState<BarcodeRow[]>([]);
  const [receipts, setReceipts] = useState<BarcodeReceiptRow[]>([]);
  const [noReceipt, setNoReceipt] = useState<NoReceiptBarcodeRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 스캔(쓰기)
  const [supplierBarcode, setSupplierBarcode] = useState('');
  const [ourBarcode, setOurBarcode] = useState('');
  const [supplierLotNo, setSupplierLotNo] = useState('');
  const [originSupplierCode, setOriginSupplierCode] = useState('');
  const [ignoreSupplierBarcode, setIgnoreSupplierBarcode] = useState(false);
  const [lookup, setLookup] = useState<BarcodeScanLookup | null>(null);
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const listParams = {
        itemCode: itemCode || undefined,
        barcode: barcodeCond || undefined,
        lotNo: lotNo || undefined,
        slipNo: slipNo || undefined,
      };
      if (tab === 'waiting') {
        const r = await api.get('/warehouse/barcode-receipt/waiting', {
          params: { ...listParams, receiptCompareYn: 'N' },
        });
        setWaiting(r.data?.data ?? []);
        mark(r);
      } else if (tab === 'barcodes') {
        const r = await api.get('/warehouse/barcode-receipt/barcodes', {
          params: listParams,
        });
        setBarcodes(r.data?.data ?? []);
        mark(r);
      } else if (tab === 'receipts') {
        const r = await api.get('/warehouse/barcode-receipt/receipts', {
          params: {
            dateFrom,
            dateTo,
            itemCode: itemCode || undefined,
            slipNo: slipNo || undefined,
            lotNo: lotNo || undefined,
          },
        });
        setReceipts(r.data?.data ?? []);
        mark(r);
      } else {
        const r = await api.get('/warehouse/barcode-receipt/no-receipt');
        setNoReceipt(r.data?.data ?? []);
        mark(r);
      }
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [tab, itemCode, barcodeCond, lotNo, slipNo, dateFrom, dateTo, mark]);

  // 탭을 바꾸면 그 탭을 조회한다. PB 는 모드마다 다른 DataWindow 를 띄웠다.
  useEffect(() => { void search(); }, [tab]); // eslint-disable-line react-hooks/exhaustive-deps

  /** 자사 바코드를 풀어 본다 (읽기 전용). 입고는 하지 않는다. */
  const runLookup = useCallback(async () => {
    const value = ourBarcode.trim();
    if (!value) return;
    setBusy(true);
    try {
      const r = await api.post('/warehouse/barcode-receipt/lookup', {
        barcode: value,
        supplierBarcode: supplierBarcode.trim() || undefined,
      });
      const result = r.data?.data as BarcodeScanLookup | undefined;
      setLookup(result ?? null);
      if (result?.item?.ecoCheckYn === 'Y') {
        toast(`4M 변경 품목입니다: ${result.item.ecoCheckComments ?? ''}`,
          { icon: '⚠️' });
      }
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '바코드를 풀어 보지 못했습니다.');
      setLookup(null);
    } finally {
      setBusy(false);
    }
  }, [ourBarcode, supplierBarcode]);

  /** 입고대조 + 입고 기록 (쓰기). 확인 모달을 거친다. */
  const compare = useCallback(async () => {
    setConfirmOpen(false);
    setBusy(true);
    try {
      const r = await api.post('/warehouse/barcode-receipt/compare', {
        supplierBarcode: supplierBarcode.trim(),
        barcode: ourBarcode.trim(),
        supplierLotNo: supplierLotNo.trim() || undefined,
        originSupplierCode: originSupplierCode.trim() || undefined,
        ignoreSupplierBarcode,
      });
      const result = r.data?.data as BarcodeCompareResult | undefined;
      toast.success(
        `입고했습니다: ${result?.itemCode} ${Number(result?.receiptQty ?? 0)
          .toLocaleString()}개 (전표 ${result?.slipNo} · 창고 ${result?.locationCode})`,
      );
      setSupplierBarcode('');
      setOurBarcode('');
      setSupplierLotNo('');
      setLookup(null);
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '입고대조에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [supplierBarcode, ourBarcode, supplierLotNo, originSupplierCode,
    ignoreSupplierBarcode, search]);

  /** 대조를 막는 이유. 있으면 버튼을 잠그고 그 이유를 보여준다. */
  const blocker = useMemo(() => {
    if (!supplierBarcode.trim()) return '협력사 바코드를 찍으세요.';
    if (!ourBarcode.trim()) return '자사 바코드를 찍으세요.';
    if (!ignoreSupplierBarcode && supplierBarcode.trim() === ourBarcode.trim()) {
      return '두 바코드가 같습니다 — 한 장을 두 번 찍었습니다.';
    }
    if (!lookup) return '바코드를 먼저 풀어 보세요 (Enter).';
    if (!lookup.itemCode) return '바코드에서 품목을 찾을 수 없습니다.';
    if (!lookup.itemExists) return '사용 기간이 지난 품목입니다.';
    if (lookup.itemMatches === false) {
      return `협력사 품목(${lookup.supplierItemCode})과 자사 품목(${lookup.itemCode})이 다릅니다.`;
    }
    if (!lookup.barcodeRow) return '발행 이력이 없는 바코드입니다.';
    if (!lookup.barcodeRow.receiptSlipNo) return '전표번호가 없는 바코드입니다.';
    if (lookup.barcodeRow.barcodeStatus === 'C') return '취소된 바코드입니다.';
    if (lookup.barcodeRow.receiptCompareYn === 'Y') return '이미 입고대조됐습니다.';
    if (lookup.needsSupplierLot && !supplierLotNo.trim()) {
      return '이 품목은 협력사 롯트번호가 필요합니다.';
    }
    if (lookup.item?.itemClass === 'PCB' && !lookup.barcodeRow.manufactureWeek) {
      return 'PCB 는 제조주차가 있어야 입고할 수 있습니다.';
    }
    if (lookup.item?.itemClass === 'PCB' && !lookup.barcodeRow.pcbCoatingDate) {
      return 'PCB 는 코팅일이 있어야 입고할 수 있습니다.';
    }
    return null;
  }, [supplierBarcode, ourBarcode, ignoreSupplierBarcode, lookup, supplierLotNo]);

  const counts: Record<TabKey, number> = {
    waiting: waiting.length,
    barcodes: barcodes.length,
    receipts: receipts.length,
    noReceipt: noReceipt.length,
  };

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재바코드입고관리</h1>
        <p className="mt-1 text-sm text-text-muted">
          협력사 바코드와 자사 바코드를 맞춰 보고 그 자리에서 입고합니다 ·{' '}
          {searched ? `${TAB_LABELS[tab]} ${counts[tab].toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      {/* 스캔(쓰기). 스캐너는 키보드처럼 입력되므로 Enter 가 곧 스캔이다. */}
      <Card padding="none">
        <CardContent className="flex flex-col gap-3 p-3">
          <div className="flex flex-wrap items-center gap-3">
            <span className="flex items-center gap-1 text-sm font-semibold text-text">
              <ScanLine className="h-4 w-4" />스캔
            </span>
            <Input aria-label="협력사 바코드" placeholder="① 협력사 바코드"
              value={supplierBarcode} className="w-64"
              onChange={(e) => setSupplierBarcode(e.target.value)} />
            <Input aria-label="자사 바코드" placeholder="② 자사 바코드 → Enter"
              value={ourBarcode} className="w-64"
              onChange={(e) => setOurBarcode(e.target.value)}
              onKeyDown={(e) => { if (e.key === 'Enter') void runLookup(); }} />
            <Button size="sm" variant="secondary" disabled={busy || !ourBarcode.trim()}
              onClick={runLookup}>
              풀어 보기
            </Button>
            {lookup?.needsSupplierLot && (
              <>
                <Input aria-label="협력사 롯트번호" placeholder="협력사 롯트번호"
                  value={supplierLotNo} className="w-48"
                  onChange={(e) => setSupplierLotNo(e.target.value)} />
                <Input aria-label="원 협력사코드" placeholder="원 협력사코드"
                  value={originSupplierCode} className="w-44"
                  onChange={(e) => setOriginSupplierCode(e.target.value)} />
              </>
            )}
            <label className="flex items-center gap-2 text-sm text-text">
              <input type="checkbox" checked={ignoreSupplierBarcode}
                onChange={(e) => setIgnoreSupplierBarcode(e.target.checked)} />
              같은 바코드 허용
            </label>
            <Button size="sm" disabled={busy || Boolean(blocker)}
              onClick={() => setConfirmOpen(true)}>
              대조 + 입고
            </Button>
          </div>

          {/* 풀어 본 결과. 무엇이 들어갈지 보여주고 나서 누르게 한다. */}
          {lookup && (
            <div className="flex flex-wrap gap-x-6 gap-y-1 rounded border border-border
                            bg-surface-muted px-3 py-2 text-sm">
              <span>품목 <b>{lookup.itemCode ?? '-'}</b>
                {lookup.item?.itemName ? ` (${lookup.item.itemName})` : ''}</span>
              <span>롯트 <b>{lookup.lotNo ?? '-'}</b></span>
              <span>수량 <b>{Number(lookup.scanQty ?? 0).toLocaleString()}</b></span>
              <span>전표 <b>{lookup.barcodeRow?.receiptSlipNo ?? '없음'}</b></span>
              <span>분류 {lookup.item?.itemClass ?? '-'}</span>
              {lookup.item?.keyitemYn === 'Y' && (
                <span className="font-semibold text-amber-500">KEY ITEM</span>
              )}
            </div>
          )}
          {blocker && (supplierBarcode || ourBarcode) && (
            <p className="flex items-center gap-1 text-sm text-amber-500">
              <AlertTriangle className="h-4 w-4" />{blocker}
            </p>
          )}
        </CardContent>
      </Card>

      <ScreenTabs
        tabs={(Object.keys(TAB_LABELS) as TabKey[]).map((k) => ({
          key: k, label: TAB_LABELS[k], count: counts[k],
        }))}
        active={tab}
        onChange={setTab}
      />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          {tab === 'receipts' && (
            <DateRangeFilter label="입고일" from={dateFrom} to={dateTo}
              onFromChange={setDateFrom} onToChange={setDateTo} />
          )}
          {tab !== 'noReceipt' && (
            <>
              <Input aria-label="품목코드" placeholder="품목코드" value={itemCode}
                className="w-44"
                onChange={(e) => setItemCode(e.target.value)}
                onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
              <Input aria-label="롯트번호" placeholder="롯트번호" value={lotNo}
                className="w-40"
                onChange={(e) => setLotNo(e.target.value)} />
              <Input aria-label="전표번호" placeholder="전표번호" value={slipNo}
                className="w-40"
                onChange={(e) => setSlipNo(e.target.value)} />
            </>
          )}
          {(tab === 'waiting' || tab === 'barcodes') && (
            <Input aria-label="자재 바코드" placeholder="자재 바코드" value={barcodeCond}
              className="w-56"
              onChange={(e) => setBarcodeCond(e.target.value)} />
          )}
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          {tab === 'noReceipt' && (
            <span className="text-sm text-text-muted">
              라벨은 발행됐지만 아직 대조되지 않아 재고에 없는 바코드입니다.
            </span>
          )}
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'receipts' ? (
            <DataGrid
              data={receipts}
              columns={barcodeReceiptColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재바코드_입고이력"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['receiptDate'] }}
              emptyMessage={searched ? '조건에 맞는 입고가 없습니다.' : '조회하세요.'}
            />
          ) : tab === 'noReceipt' ? (
            <DataGrid
              data={noReceipt}
              columns={noReceiptBarcodeColumns}
              isLoading={loading}
              pageSize={100}
              enableExport
              exportFileName="자재바코드_미입고발행"
              emptyMessage={searched ? '미입고 발행 바코드가 없습니다.' : '조회하세요.'}
            />
          ) : (
            <DataGrid
              data={tab === 'waiting' ? waiting : barcodes}
              columns={barcodeColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName={tab === 'waiting' ? '자재바코드_대조대기' : '자재바코드_이력'}
              enableColumnPinning
              defaultPinnedColumns={{ left: ['itemBarcode'] }}
              emptyMessage={searched ? '조건에 맞는 바코드가 없습니다.' : '조회하세요.'}
              onRowClick={(row) => setOurBarcode((row as BarcodeRow).itemBarcode)}
            />
          )}
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={compare}
        title="입고대조"
        message={`${lookup?.itemCode} 롯트 ${lookup?.lotNo} ·`
          + ` ${Number(lookup?.scanQty ?? 0).toLocaleString()}개를 입고 처리합니다.`
          + ` 전표 ${lookup?.barcodeRow?.receiptSlipNo}. 되돌릴 수 없습니다.`}
        confirmText="입고"
      />
    </div>
  );
}
