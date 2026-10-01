"use client";

/**
 * @file src/app/(authenticated)/warehouse/etc-receipt/page.tsx
 * @description 자재기타입고관리 — PB w_mat_other_receipt_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **바코드 없이 재고를 더하거나 빼는 화면이다.** 재고 실사 차이를 맞추거나
 *    전표 없이 들어온 물건을 넣을 때 쓴다.
 * 2. **수량이 음수면 차감이다.** PB 가 수량 부호로 입고/차감을 정한다 — 실제로도
 *    기타입고 1,829건 중 1,778건이 차감(음수)이다.
 * 3. **왼쪽 재고 목록에서 품목을 고르고 오른쪽 폼에서 수량을 넣는다.** 재고 목록은
 *    기본으로 **재고가 있는 것만** 보여준다 — 전체는 180만 행이라 잘린 채로 나온다.
 * 4. **고칠 수 있는 항목이 정해져 있다.** 수량은 바꿀 수 없고(PB 도 같다),
 *    바코드로 만들어진 입고는 아예 대상이 아니다. 수량을 잘못 넣었으면 지우고
 *    다시 넣는다.
 * 5. **이미 출고된 입고분을 고치는 것은 막지 못한다** — 시스템에 그것을 판별할 자료가
 *    없다. 고치기 전에 현장에서 확인하세요.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, Minus, Plus, Search, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { receiptColumns, receiptInventoryColumns } from '../receipt-manage-columns';
import type { ReceiptInventoryRow, ReceiptRow } from '../receipt-manage-columns';
import PartSearchField from '@/components/shared/PartSearchField';
import ComCodeSelect from '@/components/shared/ComCodeSelect';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

type Mode = 'create' | 'edit';

export default function EtcReceiptPage() {
  // 조회
  const [dateFrom, setDateFrom] = useState(daysAgo(30));
  const [dateTo, setDateTo] = useState(daysAgo(0));
  const [invItemCode, setInvItemCode] = useState('');
  const [invLocationCode, setInvLocationCode] = useState('');
  const [includeZero, setIncludeZero] = useState(false);

  const [inventory, setInventory] = useState<ReceiptInventoryRow[]>([]);
  const [history, setHistory] = useState<ReceiptRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 폼 (등록/수정 한 패널)
  const [mode, setMode] = useState<Mode>('create');
  const [selected, setSelected] = useState<ReceiptRow | null>(null);
  const [itemCode, setItemCode] = useState('');
  const [receiptQty, setReceiptQty] = useState('');
  const [locationCode, setLocationCode] = useState('');
  const [materialMfs, setMaterialMfs] = useState('');
  const [supplierCode, setSupplierCode] = useState('');
  const [lineType, setLineType] = useState('');
  const [unitPrice, setUnitPrice] = useState('');
  const [invoiceNo, setInvoiceNo] = useState('');
  const [comments, setComments] = useState('');
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [deleteOpen, setDeleteOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const [inv, hist] = await Promise.all([
        api.get('/warehouse/receipt-manage/inventory', {
          params: {
            itemCode: invItemCode || undefined,
            locationCode: invLocationCode || undefined,
            includeZero: includeZero || undefined,
          },
        }),
        api.get('/warehouse/receipt-manage/history', {
          params: { dateFrom, dateTo, receiptType: 'E' },
        }),
      ]);
      setInventory(inv.data?.data ?? []);
      setHistory(hist.data?.data ?? []);
      mark(inv, hist);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [invItemCode, invLocationCode, includeZero, dateFrom, dateTo, mark]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const resetForm = useCallback(() => {
    setMode('create');
    setSelected(null);
    setItemCode(''); setReceiptQty(''); setLocationCode(''); setMaterialMfs('');
    setSupplierCode(''); setLineType(''); setUnitPrice(''); setInvoiceNo('');
    setComments('');
  }, []);

  /** 재고 행을 고르면 등록 폼을 그 품목으로 채운다 (PB 가 dw_1 → dw_2 로 옮기던 값). */
  const pickInventory = useCallback((row: ReceiptInventoryRow) => {
    setMode('create');
    setSelected(null);
    setItemCode(row.itemCode);
    setLocationCode(row.locationCode ?? '');
    setMaterialMfs(row.materialMfs ?? '*');
    setSupplierCode(row.supplierCode ?? '');
    setLineType(row.lineType ?? '');
    setUnitPrice('');
    setInvoiceNo('');
    setComments('');
  }, []);

  /** 이력 행을 고르면 수정 폼으로 바꾼다. */
  const pickHistory = useCallback((row: ReceiptRow) => {
    setMode('edit');
    setSelected(row);
    setItemCode(row.itemCode ?? '');
    setReceiptQty(String(row.receiptQty ?? ''));
    setLocationCode(row.locationCode ?? '');
    setMaterialMfs(row.materialMfs ?? '');
    setSupplierCode(row.supplierCode ?? '');
    setLineType(row.lineType ?? '');
    setUnitPrice(String(row.unitPrice ?? ''));
    setInvoiceNo(row.invoiceNo ?? '');
    setComments(row.comments ?? '');
  }, []);

  const blocker = useMemo(() => {
    if (mode === 'create') {
      if (!itemCode.trim()) return '왼쪽 재고 목록에서 품목을 고르세요.';
      const qty = Number(receiptQty);
      if (!Number.isFinite(qty) || qty === 0) {
        return '수량은 0 이 아닌 값이어야 합니다 (음수는 차감).';
      }
      return null;
    }
    if (!selected) return '고칠 건을 이력에서 고르세요.';
    if (selected.barcode) return '바코드로 만들어진 입고는 고칠 수 없습니다.';
    if (selected.receiptType !== 'E') return '기타입고가 아닌 건은 고칠 수 없습니다.';
    return null;
  }, [mode, itemCode, receiptQty, selected]);

  const submit = useCallback(async () => {
    setConfirmOpen(false);
    setBusy(true);
    try {
      if (mode === 'create') {
        const r = await api.post('/warehouse/receipt-manage', {
          itemCode: itemCode.trim(),
          receiptQty: Number(receiptQty),
          locationCode: locationCode.trim() || undefined,
          materialMfs: materialMfs.trim() || undefined,
          supplierCode: supplierCode.trim() || undefined,
          lineType: lineType.trim() || undefined,
          unitPrice: unitPrice === '' ? undefined : Number(unitPrice),
          invoiceNo: invoiceNo.trim() || undefined,
          comments: comments.trim() || undefined,
        });
        const result = r.data?.data as { receiptDeficit?: number; invoiceNo?: string }
          | undefined;
        toast.success(
          `${result?.receiptDeficit === 2 ? '차감' : '입고'} 했습니다`
          + ` (전표 ${result?.invoiceNo}).`,
        );
        resetForm();
      } else if (selected) {
        await api.patch('/warehouse/receipt-manage', {
          receiptDate: selected.receiptDate,
          receiptSequence: selected.receiptSequence,
          locationCode: locationCode.trim() || undefined,
          materialMfs: materialMfs.trim() || undefined,
          lineType: lineType.trim() || undefined,
          unitPrice: unitPrice === '' ? undefined : Number(unitPrice),
          invoiceNo: invoiceNo.trim() || undefined,
          comments: comments.trim() || undefined,
        });
        toast.success('고쳤습니다.');
      }
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [mode, itemCode, receiptQty, locationCode, materialMfs, supplierCode, lineType,
    unitPrice, invoiceNo, comments, selected, search, resetForm]);

  const remove = useCallback(async () => {
    setDeleteOpen(false);
    if (!selected) return;
    setBusy(true);
    try {
      await api.delete('/warehouse/receipt-manage', {
        data: {
          receiptDate: selected.receiptDate,
          receiptSequence: selected.receiptSequence,
        },
      });
      toast.success('지웠습니다.');
      resetForm();
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '삭제에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, search, resetForm]);

  const qty = Number(receiptQty);
  const isMinus = Number.isFinite(qty) && qty < 0;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재기타입고관리</h1>
        <p className="mt-1 text-sm text-text-muted">
          바코드 없이 재고를 더하거나 뺍니다. 수량이 음수면 차감입니다 ·{' '}
          {searched
            ? `재고 ${inventory.length.toLocaleString()}건 · 기타입고 ${history.length.toLocaleString()}건`
            : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <PartSearchField aria-label="재고 품목코드" placeholder="재고 품목코드" value={invItemCode}
            className="w-44"
            onChange={(e) => setInvItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <ComCodeSelect groupCode="MATERIAL LOCATION CODE" labelPrefix="재고창고" value={invLocationCode} onChange={setInvLocationCode} className="w-44" />
          <label className="flex items-center gap-2 text-sm text-text">
            <input type="checkbox" checked={includeZero}
              onChange={(e) => setIncludeZero(e.target.checked)} />
            재고 0 이하도 보기 (느립니다)
          </label>
          <DateRangeFilter label="기타입고 기간" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <div className="grid min-h-0 flex-1 gap-4 lg:grid-cols-[1fr_340px]">
        <div className="flex min-h-0 flex-col gap-4">
          <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
            <CardContent className="h-full p-3">
              <DataGrid
                data={inventory}
                columns={receiptInventoryColumns}
                isLoading={loading}
                pageSize={50}
                enableColumnFilter
                enableExport
                exportFileName="기타입고_현재고"
                emptyMessage={searched ? '조건에 맞는 재고가 없습니다.' : '조회하세요.'}
                onRowClick={(row) => pickInventory(row as ReceiptInventoryRow)}
              />
            </CardContent>
          </Card>

          <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
            <CardContent className="h-full p-3">
              <DataGrid
                data={history}
                columns={receiptColumns}
                isLoading={loading}
                pageSize={50}
                enableColumnFilter
                enableExport
                exportFileName="기타입고_이력"
                emptyMessage={searched ? '기간 안에 기타입고가 없습니다.' : '조회하세요.'}
                onRowClick={(row) => pickHistory(row as ReceiptRow)}
                rowClassName={(row) => (Number((row as ReceiptRow).receiptQty ?? 0) < 0
                  ? 'bg-red-500/5'
                  : '')}
              />
            </CardContent>
          </Card>
        </div>

        {/* 등록·수정 폼 한 패널 */}
        <Card className="min-h-0 overflow-auto" padding="none">
          <CardContent className="flex flex-col gap-3 p-3">
            <div className="flex items-center justify-between">
              <h2 className="text-sm font-semibold text-text">
                {mode === 'create' ? '기타입고 등록' : '기타입고 수정'}
              </h2>
              {mode === 'edit' && (
                <Button size="sm" variant="secondary" onClick={resetForm}>
                  등록으로
                </Button>
              )}
            </div>

            <PartSearchField label="품목코드" value={itemCode} readOnly={mode === 'edit'}
              onChange={(e) => setItemCode(e.target.value)} />

            {mode === 'create' ? (
              <>
                <Input label="수량 (음수는 차감)" value={receiptQty} inputMode="numeric"
                  onChange={(e) => setReceiptQty(e.target.value)} />
                <div className="flex items-center gap-2 text-sm">
                  {isMinus
                    ? <span className="flex items-center gap-1 font-semibold text-red-500">
                      <Minus className="h-4 w-4" />차감 {Math.abs(qty).toLocaleString()}
                    </span>
                    : Number.isFinite(qty) && qty > 0
                      ? <span className="flex items-center gap-1 font-semibold text-emerald-500">
                        <Plus className="h-4 w-4" />입고 {qty.toLocaleString()}
                      </span>
                      : <span className="text-text-muted">수량을 넣으세요</span>}
                </div>
              </>
            ) : (
              <div className="rounded border border-border bg-surface-muted px-3 py-2 text-sm">
                수량 <b>{Number(selected?.receiptQty ?? 0).toLocaleString()}</b>{' '}
                ({Number(selected?.receiptQty ?? 0) < 0 ? '차감' : '입고'}) ·
                입고일 {selected?.receiptDate} · 순번 {selected?.receiptSequence}
                <div className="mt-1 text-xs text-text-muted">
                  수량은 바꿀 수 없습니다 (PB 도 같습니다). 틀렸으면 지우고 다시 넣으세요.
                </div>
              </div>
            )}

            <Input label="창고코드" value={locationCode}
              onChange={(e) => setLocationCode(e.target.value)} />
            <Input label="자재 롯트 (MATERIAL_MFS)" value={materialMfs}
              onChange={(e) => setMaterialMfs(e.target.value)} />
            <Input label="협력사코드" value={supplierCode} readOnly={mode === 'edit'}
              onChange={(e) => setSupplierCode(e.target.value)} />
            <Input label="구매유형" value={lineType}
              onChange={(e) => setLineType(e.target.value)} />
            <Input label="단가" value={unitPrice} inputMode="numeric"
              onChange={(e) => setUnitPrice(e.target.value)} />
            <Input label="전표번호 (비우면 자동)" value={invoiceNo}
              onChange={(e) => setInvoiceNo(e.target.value)} />
            <Input label="비고" value={comments}
              onChange={(e) => setComments(e.target.value)} />

            {blocker && (
              <p className="flex items-start gap-1 text-sm text-amber-500">
                <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" />{blocker}
              </p>
            )}

            <Button disabled={busy || Boolean(blocker)} onClick={() => setConfirmOpen(true)}>
              {mode === 'create' ? '등록' : '수정'}
            </Button>
            {mode === 'edit' && (
              <Button variant="danger" disabled={busy || Boolean(blocker)}
                onClick={() => setDeleteOpen(true)}>
                <Trash2 className="mr-1 h-4 w-4" />삭제
              </Button>
            )}
            <p className="text-xs text-text-muted">
              이미 출고된 입고분을 고치는 것은 막지 못합니다. 고치기 전에 현장에서
              확인하세요.
            </p>
          </CardContent>
        </Card>
      </div>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={submit}
        title={mode === 'create' ? '기타입고 등록' : '기타입고 수정'}
        message={mode === 'create'
          ? `${itemCode} 를 ${isMinus ? '차감' : '입고'}`
            + ` ${Math.abs(qty).toLocaleString()} 합니다. 재고가 바로 바뀝니다.`
          : `입고일 ${selected?.receiptDate} 순번 ${selected?.receiptSequence} 건을 고칩니다.`}
        confirmText={mode === 'create' ? '등록' : '수정'}
      />
      <ConfirmModal
        isOpen={deleteOpen}
        onClose={() => setDeleteOpen(false)}
        onConfirm={remove}
        title="기타입고 삭제"
        message={`입고일 ${selected?.receiptDate} 순번 ${selected?.receiptSequence} 건을`
          + ' 지웁니다. 되돌릴 수 없습니다.'}
        confirmText="삭제"
      />
    </div>
  );
}
