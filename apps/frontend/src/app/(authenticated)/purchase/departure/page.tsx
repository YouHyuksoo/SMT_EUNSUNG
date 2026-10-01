"use client";

/**
 * @file src/app/(authenticated)/purchase/departure/page.tsx
 * @description 483 자재출발관리 — PB w_mat_departure_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **협력사가 물건을 실어 보냈다고 올리는 화면이다.** 도착 확인은 자재도착관리
 *    (484)가 한다 — 같은 표를 단계(D→A)로 나눠 쓴다.
 * 2. **주문 잔량을 넘겨 잡을 수 없다.** 잔량 = 주문수량 − 이미 잡힌 출발·도착
 *    (취소분 제외). 서버가 INSERT 문 안에서 다시 세므로 둘이 동시에 잡아도 안 넘는다.
 *    PB 는 이걸 막지 않았다.
 * 3. **취소는 지우는 게 아니라 상태를 C 로 바꾼다.** 협력사와 맞춰볼 근거가
 *    남아야 한다. 입고(R)까지 간 건은 손댈 수 없다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, Search, Truck } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { getTodayLocal } from '@/utils/date';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { arrivalColumns, orderForArrivalColumns } from '../purchase-columns';
import type { ArrivalRow, OrderForArrivalRow } from '../purchase-columns';

const today = () => getTodayLocal();
const monthsAgo = (n: number) => {
  const d = new Date();
  d.setMonth(d.getMonth() - n);
  return getTodayLocal(d);
};
const apiMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

export default function DeparturePage() {
  const [dateFrom, setDateFrom] = useState(monthsAgo(1));
  const [dateTo, setDateTo] = useState(today());
  const [supplierCond, setSupplierCond] = useState('');
  const [orderNoCond, setOrderNoCond] = useState('');
  const [departures, setDepartures] = useState<ArrivalRow[]>([]);
  const [orders, setOrders] = useState<OrderForArrivalRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 출발 등록 폼
  const [picked, setPicked] = useState<OrderForArrivalRow | null>(null);
  const [departureDate, setDepartureDate] = useState(today());
  const [arrivalQty, setArrivalQty] = useState('');
  const [cancelTarget, setCancelTarget] = useState<ArrivalRow | null>(null);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const [list, order] = await Promise.all([
        api.get('/purchase/arrival', {
          params: {
            dateFrom,
            dateTo,
            arrivalType: 'D',
            supplierCode: supplierCond || undefined,
            orderNo: orderNoCond.trim() || undefined,
          },
        }),
        api.get('/purchase/arrival/orders', {
          params: {
            supplierCode: supplierCond || undefined,
            orderNo: orderNoCond.trim() || undefined,
          },
        }),
      ]);
      setDepartures(list.data?.data ?? []);
      setOrders(order.data?.data ?? []);
      mark(list);
      setSearched(true);
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, supplierCond, orderNoCond, mark]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  /** 주문을 고르면 잔량을 기본 수량으로 채운다 — 대개 잔량 전부를 실어 보낸다. */
  const pickOrder = useCallback((row: OrderForArrivalRow) => {
    setPicked(row);
    setArrivalQty(String(row.remainQty ?? ''));
    setDepartureDate(today());
  }, []);

  const qty = Number(arrivalQty);
  const remain = picked?.remainQty ?? 0;
  const blocker = !picked
    ? '출발로 잡을 주문을 고르세요.'
    : !Number.isInteger(qty) || qty < 1
      ? '출발수량은 1 이상의 정수입니다.'
      : qty > remain
        ? `잔량 ${remain.toLocaleString()} 을 넘길 수 없습니다.`
        : null;

  const submit = useCallback(async () => {
    if (blocker || !picked) return;
    setBusy(true);
    try {
      const r = await api.post('/purchase/arrival/departure', {
        orderNo: picked.orderNo,
        departureDate,
        arrivalQty: qty,
      });
      toast.success(`출발을 등록했습니다 (순번 ${r.data?.data?.arrivalSeqNo ?? '-'}).`);
      setPicked(null);
      setArrivalQty('');
      await search();
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '등록에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [blocker, picked, departureDate, qty, search]);

  const cancel = useCallback(async () => {
    if (!cancelTarget) return;
    setBusy(true);
    try {
      await api.post('/purchase/arrival/cancel', {
        arrivalSeqNo: cancelTarget.arrivalSeqNo,
      });
      toast.success('출발을 취소했습니다.');
      setCancelTarget(null);
      await search();
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '취소에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [cancelTarget, search]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재출발관리</h1>
        <p className="mt-1 text-sm text-text-muted">
          협력사가 실어 보낸 자재를 출발로 올립니다 (도착 확인은 자재도착관리에서) ·{' '}
          {searched ? `${departures.length.toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      {/* 출발 등록 (쓰기) */}
      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <Truck className="h-4 w-4" />출발 등록
          </span>
          <span className="text-sm text-text">
            {picked
              ? `${picked.orderNo} · ${picked.itemName ?? picked.itemCode ?? ''}`
              : '아래에서 주문을 고르세요'}
          </span>
          {picked && (
            <span className="text-sm text-text-muted">
              주문 {(picked.orderQty ?? 0).toLocaleString()} ·
              {' '}잔량 <span className="font-semibold text-text">{remain.toLocaleString()}</span>
            </span>
          )}
          <Input aria-label="출발일" type="date" value={departureDate}
            className="w-40" onChange={(e) => setDepartureDate(e.target.value)} />
          <Input aria-label="출발수량" type="number" min={1} placeholder="출발수량"
            value={arrivalQty} className="w-32"
            onChange={(e) => setArrivalQty(e.target.value)} />
          <Button size="sm" disabled={busy || Boolean(blocker)} onClick={submit}>
            출발 등록
          </Button>
          {picked && (
            <Button size="sm" variant="secondary" onClick={() => { setPicked(null); setArrivalQty(''); }}>
              선택 해제
            </Button>
          )}
          {blocker && picked && (
            <span className="flex items-center gap-1 text-sm text-amber-500">
              <AlertTriangle className="h-4 w-4" />{blocker}
            </span>
          )}
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="출발일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <SupplierSelect aria-label="협력사" includeAll labelPrefix="협력사"
            value={supplierCond} className="w-48" onChange={setSupplierCond} />
          <Input aria-label="주문번호" placeholder="주문번호" value={orderNoCond}
            className="w-40" onChange={(e) => setOrderNoCond(e.target.value)} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <div className="grid min-h-0 flex-1 gap-4 lg:grid-cols-2">
        <Card className="min-h-0 overflow-hidden" padding="none">
          <CardContent className="flex h-full flex-col gap-2 p-3">
            <span className="text-sm font-semibold text-text">
              출발로 잡을 수 있는 주문 {orders.length.toLocaleString()}건 — 고르면 폼에 들어갑니다
            </span>
            <div className="min-h-0 flex-1">
              <DataGrid
                data={orders}
                columns={orderForArrivalColumns}
                isLoading={loading}
                pageSize={100}
                enableColumnFilter
                emptyMessage="잔량이 남은 주문이 없습니다."
                onRowClick={(row) => pickOrder(row as OrderForArrivalRow)}
                rowClassName={(row) => ((row as OrderForArrivalRow).orderNo
                  === picked?.orderNo ? 'bg-primary/10' : '')}
              />
            </div>
          </CardContent>
        </Card>

        <Card className="min-h-0 overflow-hidden" padding="none">
          <CardContent className="flex h-full flex-col gap-2 p-3">
            <div className="flex items-center gap-3">
              <span className="text-sm font-semibold text-text">
                출발 {departures.length.toLocaleString()}건
              </span>
              <span className="text-sm text-text-muted">줄을 누르면 취소할 수 있습니다</span>
            </div>
            <div className="min-h-0 flex-1">
              <DataGrid
                data={departures}
                columns={arrivalColumns}
                pageSize={100}
                enableColumnFilter
                enableExport
                exportFileName="자재출발"
                emptyMessage={searched ? '이 기간에 출발이 없습니다.' : '조회하세요.'}
                onRowClick={(row) => {
                  const arrival = row as ArrivalRow;
                  if (arrival.arrivalStatus === 'C') {
                    toast.error('이미 취소된 건입니다.');
                    return;
                  }
                  if (arrival.arrivalType !== 'D') {
                    toast.error('출발 단계인 건만 여기서 취소합니다.');
                    return;
                  }
                  setCancelTarget(arrival);
                }}
              />
            </div>
          </CardContent>
        </Card>
      </div>

      <ConfirmModal
        isOpen={Boolean(cancelTarget)}
        onClose={() => setCancelTarget(null)}
        onConfirm={cancel}
        title="출발 취소"
        message={`순번 ${cancelTarget?.arrivalSeqNo ?? ''} (주문 ${cancelTarget?.orderNo ?? ''}) 을`
          + ' 취소 상태로 바꿉니다. 기록은 지우지 않습니다.'}
        confirmText="취소 처리"
      />
    </div>
  );
}
