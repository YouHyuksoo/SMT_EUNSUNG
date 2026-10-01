"use client";

/**
 * @file src/app/(authenticated)/purchase/order/page.tsx
 * @description 481 자재주문관리 — PB w_mat_purchase_order_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **협력사에 "이만큼 보내 달라"고 거는 주문을 만드는 화면이다.** 여기서 만든
 *    주문이 뒤에 출발(483) → 도착(484) → 입고로 이어진다.
 * 2. **도착분이 잡힌 주문은 고치지도 지우지도 못한다.** 이미 물건이 움직였는데
 *    주문수량을 바꾸면 잔량이 어긋난다. 막는 것은 서버다.
 * 3. **발주그룹**은 한 번에 내보내는 주문 묶음이다. 오른쪽 합계가 그 묶음 단위다.
 * 4. 주문번호는 화면이 만들지 않는다 — 서버가 시퀀스에서 받아온다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, FilePlus, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { getTodayLocal } from '@/utils/date';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import {
  purchaseOrderColumns,
  purchaseOrderGroupColumns,
} from '../purchase-columns';
import type { PurchaseOrderGroupRow, PurchaseOrderRow } from '../purchase-columns';
import PartSearchField from '@/components/shared/PartSearchField';

const today = () => getTodayLocal();
const monthsAgo = (n: number) => {
  const d = new Date();
  d.setMonth(d.getMonth() - n);
  return getTodayLocal(d);
};
const apiMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

export default function PurchaseOrderPage() {
  const [dateFrom, setDateFrom] = useState(monthsAgo(3));
  const [dateTo, setDateTo] = useState(today());
  const [supplierCond, setSupplierCond] = useState('');
  const [itemCond, setItemCond] = useState('');
  const [orderTypeCond, setOrderTypeCond] = useState('');
  const [rows, setRows] = useState<PurchaseOrderRow[]>([]);
  const [groups, setGroups] = useState<PurchaseOrderGroupRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 주문 폼 (등록/수정 겸용)
  const [editing, setEditing] = useState<PurchaseOrderRow | null>(null);
  const [orderGroupNo, setOrderGroupNo] = useState('');
  const [supplierCode, setSupplierCode] = useState('');
  const [itemCode, setItemCode] = useState('');
  const [purchaseOrderDate, setPurchaseOrderDate] = useState(today());
  const [deliveryDate, setDeliveryDate] = useState(today());
  const [delivery, setDelivery] = useState('');
  const [lineType, setLineType] = useState('');
  const [orderType, setOrderType] = useState('');
  const [currency, setCurrency] = useState('');
  const [deliveryMethod, setDeliveryMethod] = useState('');
  const [orderQty, setOrderQty] = useState('');
  const [unitPrice, setUnitPrice] = useState('');
  const [deleteTarget, setDeleteTarget] = useState<PurchaseOrderRow | null>(null);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const params = {
        dateFrom,
        dateTo,
        supplierCode: supplierCond || undefined,
        itemCode: itemCond.trim() || undefined,
        orderType: orderTypeCond || undefined,
      };
      const [list, group] = await Promise.all([
        api.get('/purchase/order', { params }),
        api.get('/purchase/order/groups', { params }),
      ]);
      setRows(list.data?.data ?? []);
      setGroups(group.data?.data ?? []);
      mark(list);
      setSearched(true);
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, supplierCond, itemCond, orderTypeCond, mark]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const resetForm = useCallback(() => {
    setEditing(null);
    setOrderGroupNo('');
    setSupplierCode('');
    setItemCode('');
    setPurchaseOrderDate(today());
    setDeliveryDate(today());
    setDelivery('');
    setLineType('');
    setOrderType('');
    setCurrency('');
    setDeliveryMethod('');
    setOrderQty('');
    setUnitPrice('');
  }, []);

  /** 도착분이 잡힌 주문은 서버가 거절한다. 화면에서도 먼저 알려 준다. */
  const pick = useCallback((row: PurchaseOrderRow) => {
    if ((row.arrivalQty ?? 0) > 0) {
      toast.error('도착분이 잡힌 주문입니다. 고칠 수 없습니다.');
      return;
    }
    setEditing(row);
    setOrderGroupNo(row.orderGroupNo ?? '');
    setSupplierCode(row.supplierCode ?? '');
    setItemCode(row.itemCode ?? '');
    setPurchaseOrderDate(row.purchaseOrderDate ?? today());
    setDeliveryDate(row.deliveryDate ?? today());
    setDelivery(row.delivery ?? '');
    setLineType(row.lineType ?? '');
    setOrderType(row.orderType ?? '');
    setCurrency(row.currency ?? '');
    setDeliveryMethod(row.deliveryMethod ?? '');
    setOrderQty(String(row.orderQty ?? ''));
    setUnitPrice(row.unitPrice == null ? '' : String(row.unitPrice));
  }, []);

  const qty = Number(orderQty);
  const blocker = !orderGroupNo.trim()
    ? '발주그룹을 넣으세요.'
    : !supplierCode
      ? '협력사를 고르세요.'
      : !itemCode.trim()
        ? '품목을 넣으세요.'
        : !delivery
          ? '납품구분을 고르세요.'
          : !lineType
            ? '거래유형을 고르세요.'
            : !Number.isInteger(qty) || qty < 1
              ? '주문수량은 1 이상의 정수입니다.'
              : null;

  const amount = useMemo(() => {
    const price = Number(unitPrice);
    if (!Number.isFinite(price) || !Number.isFinite(qty)) return null;
    return price * qty;
  }, [unitPrice, qty]);

  const submit = useCallback(async () => {
    if (blocker) return;
    setBusy(true);
    try {
      await api.post('/purchase/order', {
        orderNo: editing?.orderNo,
        orderGroupNo: orderGroupNo.trim(),
        supplierCode,
        itemCode: itemCode.trim(),
        purchaseOrderDate,
        deliveryDate,
        delivery,
        lineType,
        orderType: orderType || undefined,
        currency: currency || undefined,
        deliveryMethod: deliveryMethod || undefined,
        orderQty: qty,
        unitPrice: unitPrice === '' ? undefined : Number(unitPrice),
      });
      toast.success(editing ? '주문을 고쳤습니다.' : '주문을 등록했습니다.');
      resetForm();
      await search();
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [blocker, editing, orderGroupNo, supplierCode, itemCode, purchaseOrderDate,
    deliveryDate, delivery, lineType, orderType, currency, deliveryMethod, qty,
    unitPrice, resetForm, search]);

  const remove = useCallback(async () => {
    if (!deleteTarget) return;
    setBusy(true);
    try {
      await api.delete('/purchase/order', { data: { orderNo: deleteTarget.orderNo } });
      toast.success('주문을 지웠습니다.');
      setDeleteTarget(null);
      resetForm();
      await search();
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '삭제에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [deleteTarget, resetForm, search]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재주문관리</h1>
        <p className="mt-1 text-sm text-text-muted">
          협력사에 거는 자재 주문을 등록·수정합니다 (도착분이 잡히면 잠깁니다) ·{' '}
          {searched ? `${rows.length.toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      {/* 주문 등록·수정 (쓰기) */}
      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <FilePlus className="h-4 w-4" />
            {editing ? `주문 수정 (${editing.orderNo})` : '주문 등록'}
          </span>
          <Input aria-label="발주그룹" placeholder="발주그룹" value={orderGroupNo}
            className="w-36" onChange={(e) => setOrderGroupNo(e.target.value)} />
          <SupplierSelect aria-label="협력사" value={supplierCode}
            className="w-48" onChange={setSupplierCode} />
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-40" onChange={(e) => setItemCode(e.target.value)} />
          <Input aria-label="주문일" type="date" value={purchaseOrderDate}
            className="w-40" onChange={(e) => setPurchaseOrderDate(e.target.value)} />
          <Input aria-label="납기일" type="date" value={deliveryDate}
            className="w-40" onChange={(e) => setDeliveryDate(e.target.value)} />
          <ComCodeSelect groupCode="DELIVERY" includeAll={false} labelPrefix="납품"
            aria-label="납품구분" value={delivery} className="w-36" onChange={setDelivery} />
          <ComCodeSelect groupCode="LINE TYPE" includeAll={false} labelPrefix="거래"
            aria-label="거래유형" value={lineType} className="w-40" onChange={setLineType} />
          <ComCodeSelect groupCode="ORDER TYPE" labelPrefix="주문유형"
            aria-label="주문유형" value={orderType} className="w-40" onChange={setOrderType} />
          <ComCodeSelect groupCode="CURRENCY" labelPrefix="통화"
            aria-label="통화" value={currency} className="w-32" onChange={setCurrency} />
          <ComCodeSelect groupCode="DELIVERY METHOD" labelPrefix="운송"
            aria-label="운송" value={deliveryMethod} className="w-36"
            onChange={setDeliveryMethod} />
          <Input aria-label="주문수량" type="number" min={1} placeholder="주문수량"
            value={orderQty} className="w-28"
            onChange={(e) => setOrderQty(e.target.value)} />
          <Input aria-label="단가" type="number" placeholder="단가" value={unitPrice}
            className="w-28" onChange={(e) => setUnitPrice(e.target.value)} />
          {amount != null && amount > 0 && (
            <span className="text-sm text-text-muted">
              금액 {amount.toLocaleString()}
            </span>
          )}
          <Button size="sm" disabled={busy || Boolean(blocker)} onClick={submit}>
            {editing ? '수정' : '등록'}
          </Button>
          {editing && (
            <>
              <Button size="sm" variant="secondary" onClick={resetForm}>새 주문</Button>
              <Button size="sm" variant="danger" disabled={busy}
                onClick={() => setDeleteTarget(editing)}>
                삭제
              </Button>
            </>
          )}
          {blocker && orderGroupNo && (
            <span className="flex items-center gap-1 text-sm text-amber-500">
              <AlertTriangle className="h-4 w-4" />{blocker}
            </span>
          )}
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="주문일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <SupplierSelect aria-label="협력사 조건" includeAll labelPrefix="협력사"
            value={supplierCond} className="w-48" onChange={setSupplierCond} />
          <PartSearchField aria-label="품목코드 조건" placeholder="품목코드" value={itemCond}
            className="w-40" onChange={(e) => setItemCond(e.target.value)} />
          <ComCodeSelect groupCode="ORDER TYPE" labelPrefix="주문유형"
            aria-label="주문유형 조건" value={orderTypeCond} className="w-40"
            onChange={setOrderTypeCond} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <div className="grid min-h-0 flex-1 gap-4 lg:grid-cols-[1.6fr_1fr]">
        <Card className="min-h-0 overflow-hidden" padding="none">
          <CardContent className="flex h-full flex-col gap-2 p-3">
            <span className="text-sm font-semibold text-text">
              주문 {rows.length.toLocaleString()}건 — 고르면 폼에 들어갑니다
            </span>
            <div className="min-h-0 flex-1">
              <DataGrid
                data={rows}
                columns={purchaseOrderColumns}
                isLoading={loading}
                pageSize={100}
                enableColumnFilter
                enableExport
                exportFileName="자재주문"
                emptyMessage={searched ? '이 기간에 주문이 없습니다.' : '조회하세요.'}
                onRowClick={(row) => pick(row as PurchaseOrderRow)}
                rowClassName={(row) => ((row as PurchaseOrderRow).orderNo
                  === editing?.orderNo ? 'bg-primary/10' : '')}
              />
            </div>
          </CardContent>
        </Card>

        <Card className="min-h-0 overflow-hidden" padding="none">
          <CardContent className="flex h-full flex-col gap-2 p-3">
            <span className="text-sm font-semibold text-text">
              발주그룹 {groups.length.toLocaleString()}건
            </span>
            <div className="min-h-0 flex-1">
              <DataGrid
                data={groups}
                columns={purchaseOrderGroupColumns}
                pageSize={100}
                enableColumnFilter
                emptyMessage="발주그룹이 없습니다."
              />
            </div>
          </CardContent>
        </Card>
      </div>

      <ConfirmModal
        isOpen={Boolean(deleteTarget)}
        onClose={() => setDeleteTarget(null)}
        onConfirm={remove}
        title="주문 삭제"
        message={`주문 ${deleteTarget?.orderNo ?? ''} 을 지웁니다.`
          + ' 도착분이 잡혔거나 출발·도착 기록이 붙은 주문은 지워지지 않습니다.'}
        confirmText="삭제"
      />
    </div>
  );
}
