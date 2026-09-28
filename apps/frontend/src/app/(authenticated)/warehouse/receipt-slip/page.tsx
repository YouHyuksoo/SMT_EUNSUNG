"use client";

/**
 * @file src/app/(authenticated)/warehouse/receipt-slip/page.tsx
 * @description 자재입고전표관리 — PB w_mat_receipt_slip_master 이식
 *
 * 초보자 가이드:
 * 1. **자재 바코드(라벨)를 만드는 화면이다.** 협력사 전표를 고르고 릴 수만큼
 *    바코드를 발행하면, 바코드 한 장마다 입고 원장에 입고 한 건이 기록된다.
 * 2. **발행 전에 무엇이 만들어질지 보여준다.** 장수·수량·수량 합을 미리 계산해
 *    전표 총수량과 맞는지 화면에서 확인할 수 있다 — 어긋나면 발행 버튼이 막힌다.
 *    그 계산은 서버와 **같은 함수**(`@smt/shared`)가 한다.
 * 3. **분할은 두 갈래다.** 균등(릴 장수 × 한 장 수량)과 수동(장별 수량을 직접 적기).
 *    PB 의 체크박스와 같다.
 * 4. **되돌릴 수 없다.** 발행하면 바코드와 입고가 함께 들어간다. 그래서 확인
 *    모달에 무엇이 몇 장 만들어지는지 적어 보여준다.
 * 5. **전표 목록에 발행 장수를 세지 않는다.** 바코드 표(193만행)에 전표번호
 *    인덱스가 없어 그 열 하나 때문에 조회가 31초가 됐다 (실측). 전표를 고르면
 *    아래 바코드 목록에서 알 수 있다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Search, Tags } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import { Button, Card, CardContent, CardHeader, ConfirmModal, Input } from '@/components/ui';
import { checkReelPlan, planReelQuantities, totalReelQty } from '@smt/shared';
import api from '@/services/api';
import {
  receiptSlipBarcodeColumns,
  receiptSlipColumns,
  type ReceiptSlipBarcodeRow,
  type ReceiptSlipIssueResult,
  type ReceiptSlipRow,
} from '../receipt-slip-columns';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

export default function ReceiptSlipPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(daysAgo(0));
  const [itemCode, setItemCode] = useState('');
  const [slipNo, setSlipNo] = useState('');

  const [slips, setSlips] = useState<ReceiptSlipRow[]>([]);
  const [barcodes, setBarcodes] = useState<ReceiptSlipBarcodeRow[]>([]);
  const [selected, setSelected] = useState<ReceiptSlipRow | null>(null);
  const [loading, setLoading] = useState(false);
  const [barcodeLoading, setBarcodeLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  // 발행 입력
  const [reelQty, setReelQty] = useState('');
  const [unitQty, setUnitQty] = useState('');
  const [divideText, setDivideText] = useState('');
  const [lineType, setLineType] = useState('');
  const [supplierBarcode, setSupplierBarcode] = useState('');
  const [supplierLotNo, setSupplierLotNo] = useState('');
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    setSelected(null);
    setBarcodes([]);
    try {
      const response = await api.get('/warehouse/receipt-slip', {
        params: {
          dateFrom,
          dateTo,
          itemCode: itemCode || undefined,
          slipNo: slipNo || undefined,
        },
      });
      setSlips(response.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '입고전표 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, itemCode, slipNo]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  /** 전표를 고르면 그 전표로 발행된 바코드를 읽고, 발행 입력을 전표 값으로 채운다. */
  const selectSlip = useCallback(async (row: ReceiptSlipRow) => {
    setSelected(row);
    setReelQty(row.reelQty ? String(row.reelQty) : '');
    setUnitQty(row.receiptUnitQty ? String(row.receiptUnitQty) : '');
    setDivideText('');
    setBarcodeLoading(true);
    try {
      const response = await api.get('/warehouse/receipt-slip/barcodes', {
        params: { slipNo: row.receiptSlipNo, itemCode: row.itemCode },
      });
      setBarcodes(response.data?.data ?? []);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '바코드 조회에 실패했습니다.');
    } finally {
      setBarcodeLoading(false);
    }
  }, []);

  /** 수동 분할 입력을 숫자 목록으로 읽는다 (쉼표·공백·줄바꿈 아무거나). */
  const divideQty = useMemo(() => divideText
    .split(/[\s,]+/)
    .filter(Boolean)
    .map(Number)
    .filter((n) => !Number.isNaN(n)), [divideText]);

  /** 발행 계획. 서버와 같은 함수로 계산하므로 화면이 보여준 것과 들어가는 것이 같다. */
  const plan = useMemo(() => {
    const input = divideQty.length > 0
      ? { divideQty }
      : { reelQty: Number(reelQty) || 0, unitQty: Number(unitQty) || 0 };
    return {
      input,
      verdict: checkReelPlan(input),
      quantities: planReelQuantities(input),
      total: totalReelQty(input),
    };
  }, [divideQty, reelQty, unitQty]);

  const slipQty = Number(selected?.receiptSumQty ?? 0);
  const qtyMismatch = slipQty > 0 && plan.verdict.ok && plan.total !== slipQty;
  const canIssue = Boolean(selected) && plan.verdict.ok && !qtyMismatch && !busy;

  const issue = useCallback(async () => {
    if (!selected) return;
    setConfirmOpen(false);
    setBusy(true);
    try {
      const response = await api.post('/warehouse/receipt-slip/issue', {
        slipNo: selected.receiptSlipNo,
        itemCode: selected.itemCode,
        ...(divideQty.length > 0
          ? { divideQty }
          : { reelQty: Number(reelQty), unitQty: Number(unitQty) }),
        lineType: lineType || undefined,
        supplierBarcode: supplierBarcode || undefined,
        supplierLotNo: supplierLotNo || undefined,
      });
      const result = response.data?.data as ReceiptSlipIssueResult | undefined;
      toast.success(
        `${result?.issued ?? 0}장을 발행했습니다`
        + ` (수량 합 ${(result?.totalQty ?? 0).toLocaleString()}).`,
      );
      void selectSlip(selected);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '바코드 발행에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, divideQty, reelQty, unitQty, lineType, supplierBarcode, supplierLotNo, selectSlip]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재입고전표관리</h1>
        <p className="mt-1 text-sm text-text-muted">
          협력사 전표로 자재 바코드를 발행하고 입고를 기록합니다 ·{' '}
          {searched ? `전표 ${slips.length.toLocaleString()}건` : '조회하세요'}
          {selected ? ` · 선택 ${selected.receiptSlipNo}` : ''}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="전표일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCode} className="w-40"
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="전표번호" placeholder="전표번호" value={slipNo} className="w-44"
            onChange={(e) => setSlipNo(e.target.value)} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <div className="flex min-h-0 flex-1 gap-4">
        <div className="flex min-h-0 flex-1 flex-col gap-4">
          <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
            <CardContent className="h-full p-3">
              <DataGrid
                data={slips}
                columns={receiptSlipColumns}
                isLoading={loading}
                pageSize={50}
                enableColumnFilter
                enableExport
                exportFileName="자재입고전표"
                enableColumnPinning
                defaultPinnedColumns={{ left: ['receiptSlipNo'] }}
                emptyMessage={searched ? '기간에 전표가 없습니다.' : '조회하세요.'}
                onRowClick={(row) => void selectSlip(row as ReceiptSlipRow)}
                rowClassName={(row) => {
                  const r = row as ReceiptSlipRow;
                  return r.receiptSlipNo === selected?.receiptSlipNo
                    && r.itemCode === selected?.itemCode
                    ? 'bg-primary/10'
                    : '';
                }}
              />
            </CardContent>
          </Card>

          <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
            <CardContent className="h-full p-3">
              <DataGrid
                data={barcodes}
                columns={receiptSlipBarcodeColumns}
                isLoading={barcodeLoading}
                pageSize={50}
                enableColumnFilter
                enableExport
                exportFileName="발행바코드"
                enableColumnPinning
                defaultPinnedColumns={{ left: ['itemBarcode'] }}
                emptyMessage={selected
                  ? '이 전표로 발행된 바코드가 없습니다.'
                  : '전표를 고르면 발행된 바코드가 나옵니다.'}
              />
            </CardContent>
          </Card>
        </div>

        {/* 발행 패널. 무엇이 몇 장 만들어지는지 먼저 보여준다. */}
        <Card className="w-96 shrink-0 overflow-y-auto">
          <CardHeader title="바코드 발행" subtitle={selected
            ? `${selected.itemCode} · 전표 총수량 ${slipQty.toLocaleString()}`
            : '전표를 고르세요'} />
          <CardContent className="flex flex-col gap-3">
            <div className="flex gap-2">
              <Input label="릴 장수" value={reelQty} className="w-full"
                disabled={!selected || divideQty.length > 0}
                onChange={(e) => setReelQty(e.target.value.replace(/\D/g, ''))} />
              <Input label="한 장 수량" value={unitQty} className="w-full"
                disabled={!selected || divideQty.length > 0}
                onChange={(e) => setUnitQty(e.target.value.replace(/[^\d.]/g, ''))} />
            </div>
            <div>
              <label className="mb-1.5 block text-sm font-medium text-text">
                수동 분할 (장별 수량, 쉼표나 공백으로 구분)
              </label>
              <textarea
                className="h-20 w-full rounded-lg border border-border bg-surface p-2 text-sm text-text"
                placeholder="예: 250 250 250 100"
                value={divideText}
                disabled={!selected}
                onChange={(e) => setDivideText(e.target.value)}
              />
              <p className="mt-1 text-xs text-text-muted">
                적으면 위의 릴 장수·한 장 수량 대신 이 값으로 발행합니다.
              </p>
            </div>

            <ComCodeSelect groupCode="LINE TYPE" labelPrefix="구매유형" value={lineType}
              onChange={setLineType} className="w-full" />
            <Input label="협력사 바코드" value={supplierBarcode}
              onChange={(e) => setSupplierBarcode(e.target.value)} />
            <Input label="협력사 롯트번호" value={supplierLotNo}
              onChange={(e) => setSupplierLotNo(e.target.value)} />

            {/* 발행 전 미리보기 — 서버와 같은 함수로 계산한다. */}
            <div className="rounded-lg border border-border p-2 text-sm">
              {!selected ? (
                <span className="text-text-muted">전표를 고르면 계획을 보여줍니다.</span>
              ) : !plan.verdict.ok ? (
                <span className="text-amber-500">{plan.verdict.reason}</span>
              ) : (
                <>
                  <div className="text-text">
                    <span className="font-semibold">{plan.quantities.length}장</span>
                    {' · 수량 합 '}
                    <span className="font-semibold">{plan.total.toLocaleString()}</span>
                  </div>
                  {plan.quantities.length <= 12 && (
                    <div className="mt-1 text-xs text-text-muted">
                      {plan.quantities.map((q) => q.toLocaleString()).join(' · ')}
                    </div>
                  )}
                  {qtyMismatch && (
                    <div className="mt-1 font-semibold text-red-500">
                      전표 총수량({slipQty.toLocaleString()})과 다릅니다 — 발행할 수 없습니다.
                    </div>
                  )}
                </>
              )}
            </div>

            <Button onClick={() => setConfirmOpen(true)} disabled={!canIssue}>
              <Tags className="mr-1 h-4 w-4" />발행
            </Button>
          </CardContent>
        </Card>
      </div>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={issue}
        title="자재 바코드 발행"
        message={selected
          ? `전표 ${selected.receiptSlipNo} (${selected.itemCode}) 로`
            + ` 바코드 ${plan.quantities.length}장을 발행하고`
            + ` 입고 ${plan.quantities.length}건을 기록합니다`
            + ` (수량 합 ${plan.total.toLocaleString()}).`
            + ' 되돌릴 수 없습니다.'
          : ''}
        variant="danger"
      />
    </div>
  );
}
