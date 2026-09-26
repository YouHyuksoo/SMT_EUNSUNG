"use client";

/**
 * @file src/app/(authenticated)/mold/order/page.tsx
 * @description S-PARTS 주문관리 — PB w_mcn_mold_purchase_order_master 이식
 *
 * 초보자 가이드:
 * 1. **기간 조건은 납기일 기준이다.** PB 가 DELIVERY_DATE 로 걸렀다 — 주문일이 아니다.
 * 2. PB 라디오버튼(주문 / 주문그룹) 묶음을 탭으로 만들었다. 탭을 바꾸면 선택을 비운다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Search, ShoppingCart } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { moldOrderColumns, moldOrderGroupColumns } from '../columns';
import type { MoldOrderGroupRow, MoldOrderRow } from '../types';
import OrderActionPanel from './components/OrderActionPanel';

type Mode = 'orders' | 'groups';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const monthAgo = () => {
  const date = new Date();
  date.setMonth(date.getMonth() - 1);
  return isoDate(date);
};

export default function MoldOrderPage() {
  const [mode, setMode] = useState<Mode>('orders');
  const [orders, setOrders] = useState<MoldOrderRow[]>([]);
  const [groups, setGroups] = useState<MoldOrderGroupRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [dateFrom, setDateFrom] = useState(monthAgo);
  const [dateTo, setDateTo] = useState(today);
  const [supplierCode, setSupplierCode] = useState('');
  const [moldCode, setMoldCode] = useState('');

  const [selected, setSelected] = useState<MoldOrderRow | null>(null);

  const search = useCallback(async () => {
    setLoading(true);
    const params = {
      dateFrom,
      dateTo,
      supplierCode: supplierCode || undefined,
      moldCode: moldCode || undefined,
    };
    try {
      if (mode === 'orders') {
        const response = await api.get('/mold/order', { params });
        setOrders(response.data?.data ?? []);
        setTotal(Number(response.data?.meta?.total ?? 0));
      } else {
        const response = await api.get('/mold/order/groups', { params });
        const data: MoldOrderGroupRow[] = response.data?.data ?? [];
        setGroups(data);
        setTotal(data.length);
      }
      setSearched(true);
      setSelected(null);
    } catch {
      toast.error('S-PARTS 주문 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [mode, dateFrom, dateTo, supplierCode, moldCode]);

  /** 탭을 바꾸면 이전 조회 결과·선택을 비운다 */
  const changeMode = useCallback((next: Mode) => {
    setMode(next);
    setOrders([]);
    setGroups([]);
    setTotal(0);
    setSearched(false);
    setSelected(null);
  }, []);

  const orderCols = useMemo(() => moldOrderColumns, []);
  const groupCols = useMemo(() => moldOrderGroupColumns, []);
  const shown = mode === 'orders' ? orders.length : groups.length;

  return (
    <main className="flex h-full min-w-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <ShoppingCart className="h-6 w-6 text-primary" />S-PARTS 주문관리
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            납기일 기준으로 S-PARTS 주문을 등록하고 그룹별로 집계합니다 ·{' '}
            {searched ? `${shown}/${total}건` : '조회조건을 선택하세요'}
          </p>
        </div>
        <Button size="sm" onClick={search} disabled={loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="납기일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <SupplierSelect labelPrefix="공급처" value={supplierCode}
            onChange={setSupplierCode} className="w-56" />
          <Input aria-label="S-PARTS 코드" placeholder="S-PARTS 코드" value={moldCode}
            className="w-48" onChange={(e) => setMoldCode(e.target.value)} />
        </CardContent>
      </Card>

      {mode === 'orders' && (
        <OrderActionPanel selected={selected} onChanged={search} />
      )}

      <nav className="flex gap-1 border-b border-border" aria-label="조회 모드">
        {([['orders', '주문'], ['groups', '주문그룹 집계']] as const).map(([key, label]) => (
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
          {mode === 'orders' ? (
            <DataGrid
              data={orders}
              columns={orderCols}
              isLoading={loading}
              pageSize={50}
              enableColumnFilter
              enableExport
              exportFileName="S-PARTS주문"
              emptyMessage="조회 버튼을 눌러 주문을 확인하세요."
              onRowClick={(row) => setSelected(row as MoldOrderRow)}
              getRowId={(row) => (row as MoldOrderRow).orderNo}
            />
          ) : (
            <DataGrid
              data={groups}
              columns={groupCols}
              isLoading={loading}
              pageSize={50}
              enableColumnFilter
              enableExport
              exportFileName="S-PARTS주문그룹"
              emptyMessage="조회 버튼을 눌러 주문그룹을 확인하세요."
              getRowId={(row) => String((row as MoldOrderGroupRow).orderGroupNo ?? '')}
            />
          )}
        </CardContent>
      </Card>
    </main>
  );
}
