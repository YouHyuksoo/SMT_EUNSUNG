"use client";

/**
 * @file src/app/(authenticated)/warehouse/barcode-reprint/page.tsx
 * @description 자재바코드재발행 — PB w_mat_receipt_barcode_reprint_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **라벨이 찢어지거나 수량이 달라졌을 때 바코드를 다시 만드는 화면이다.**
 * 2. **원장은 바뀌지 않는다.** 수량이 실제로 줄어 재고에 반영해야 하면
 *    **출고바코드반품** 화면을 써야 한다. 여기는 라벨만 다시 만드는 자리다.
 * 3. **조회하려면 키를 하나는 넣어야 한다** — 조건 없이 훑으면 190만 행을 보느라
 *    12초가 걸리고 아무 의미 없는 1만 건이 나온다. 다시 뽑을 릴은 이미 정해져 있다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, Printer, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { reprintColumns } from '../reprint-msl-columns';
import type { ReprintRow } from '../reprint-msl-columns';

export default function BarcodeReprintPage() {
  const [itemCode, setItemCode] = useState('');
  const [barcodeCond, setBarcodeCond] = useState('');
  const [lotNo, setLotNo] = useState('');
  const [slipNo, setSlipNo] = useState('');

  const [rows, setRows] = useState<ReprintRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 재발행 (쓰기)
  const [selected, setSelected] = useState<ReprintRow | null>(null);
  const [newQty, setNewQty] = useState('');
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const hasKey = [itemCode, barcodeCond, lotNo, slipNo]
    .some((v) => v.trim().length > 0);

  const search = useCallback(async () => {
    if (!hasKey) {
      toast.error('품목코드·바코드·롯트번호·전표번호 중 하나는 넣으세요.');
      return;
    }
    setLoading(true);
    try {
      const r = await api.get('/warehouse/barcode-reprint', {
        params: {
          itemCode: itemCode || undefined,
          barcode: barcodeCond || undefined,
          lotNo: lotNo || undefined,
          slipNo: slipNo || undefined,
        },
      });
      setRows(r.data?.data ?? []);
      setSelected(null);
      mark(r);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [hasKey, itemCode, barcodeCond, lotNo, slipNo, mark]);

  const pick = useCallback((row: ReprintRow) => {
    setSelected(row);
    setNewQty(String(row.scanQty ?? ''));
  }, []);

  const qty = Number(newQty);
  const blocker = !selected
    ? '목록에서 다시 만들 바코드를 고르세요.'
    : !(Number.isFinite(qty) && qty >= 1)
      ? '새 수량은 1 이상이어야 합니다.'
      : null;

  const submit = useCallback(async () => {
    setConfirmOpen(false);
    if (!selected) return;
    setBusy(true);
    try {
      const r = await api.post('/warehouse/barcode-reprint', {
        barcode: selected.itemBarcode,
        newQty: qty,
      });
      const result = r.data?.data as { newBarcode?: string } | undefined;
      toast.success(
        `새 바코드는 ${result?.newBarcode} 입니다 — 라벨을 다시 붙이세요.`,
        { duration: 8000 },
      );
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '재발행에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, qty, search]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재바코드재발행</h1>
        <p className="mt-1 text-sm text-text-muted">
          바코드를 새 수량으로 다시 만듭니다. 재고 원장은 바뀌지 않습니다 ·{' '}
          {searched ? `${rows.length.toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-44"
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="자재 바코드" placeholder="자재 바코드" value={barcodeCond}
            className="w-56"
            onChange={(e) => setBarcodeCond(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="롯트번호" placeholder="롯트번호" value={lotNo}
            className="w-40"
            onChange={(e) => setLotNo(e.target.value)} />
          <Input aria-label="전표번호" placeholder="전표번호" value={slipNo}
            className="w-40"
            onChange={(e) => setSlipNo(e.target.value)} />
          <Button size="sm" onClick={search} disabled={loading || !hasKey}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          {!hasKey && (
            <span className="text-sm text-text-muted">
              키를 하나는 넣으세요 (조건 없이는 의미 있는 결과가 나오지 않습니다).
            </span>
          )}
        </CardContent>
      </Card>

      {/* 재발행 (쓰기) */}
      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <Printer className="h-4 w-4" />재발행
          </span>
          {selected ? (
            <span className="text-sm">
              <b>{selected.itemBarcode}</b> · 지금 수량{' '}
              <b>{Number(selected.scanQty ?? 0).toLocaleString()}</b>
            </span>
          ) : (
            <span className="text-sm text-text-muted">목록에서 한 줄을 고르세요.</span>
          )}
          <Input aria-label="새 수량" placeholder="새 수량" value={newQty}
            className="w-32" inputMode="numeric"
            onChange={(e) => setNewQty(e.target.value)} />
          {selected && Number.isFinite(qty) && qty >= 1 && (
            <span className="text-sm text-text-muted">
              새 바코드: <b className="font-mono">
                {selected.itemCode}-{selected.lotNo}-{qty}
              </b>
            </span>
          )}
          <Button size="sm" disabled={busy || Boolean(blocker)}
            onClick={() => setConfirmOpen(true)}>
            다시 만들기
          </Button>
          {blocker && selected && (
            <span className="flex items-center gap-1 text-sm text-amber-500">
              <AlertTriangle className="h-4 w-4" />{blocker}
            </span>
          )}
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={reprintColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="자재바코드재발행"
            enableColumnPinning
            defaultPinnedColumns={{ left: ['itemBarcode'] }}
            emptyMessage={searched ? '조건에 맞는 바코드가 없습니다.' : '조회하세요.'}
            onRowClick={(row) => pick(row as ReprintRow)}
          />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={submit}
        title="바코드 재발행"
        message={`${selected?.itemBarcode} 를`
          + ` ${selected?.itemCode}-${selected?.lotNo}-${qty} 로 다시 만듭니다.`
          + ' 라벨을 다시 붙여야 합니다. 재고 원장은 바뀌지 않습니다.'}
        confirmText="다시 만들기"
      />
    </div>
  );
}
