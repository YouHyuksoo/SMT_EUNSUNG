"use client";

/**
 * @file src/app/(authenticated)/product/shipping-order/page.tsx
 * @description 제품납품계획(출하지시) — IP_PRODUCT_DELIVERY_PLAN 등록·조회
 *
 * 초보자 가이드:
 * 1. **고객에게 언제 무엇을 얼마나 보낼지 정하는 지시다.** 생산지시(런카드)와 따로 내려간다.
 * 2. 제품출하관리 화면에서 이 지시를 고르고 박스를 스캔하면 출고 수량이 쌓이고, 다 차면 완료(C)가 된다.
 * 3. 행을 누르면 수정·삭제 창이 열린다. 출고된 박스가 있으면 지울 수 없다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import type { ColumnDef } from '@tanstack/react-table';
import { Plus, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import CustomerSelect from '@/components/shared/CustomerSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ModelSearchField from '@/components/shared/ModelSearchField';
import ComCodeBadge from '@/components/ui/ComCodeBadge';
import { Button, Card, CardContent } from '@/components/ui';
import api from '@/services/api';
import { getTodayLocal } from '@/utils/date';
import ShippingOrderFormModal from './components/ShippingOrderFormModal';
import type { ShippingOrderRow } from './types';

const shiftDays = (ymd: string, days: number) => {
  const d = new Date(`${ymd}T00:00:00`);
  d.setDate(d.getDate() + days);
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
};
const num = (v: unknown) => Number(v ?? 0).toLocaleString();

export default function ShippingOrderPage() {
  const today = getTodayLocal();
  const [dateFrom, setDateFrom] = useState(today);
  const [dateTo, setDateTo] = useState(shiftDays(today, 14));
  const [customerCode, setCustomerCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [rows, setRows] = useState<ShippingOrderRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [editing, setEditing] = useState<ShippingOrderRow | null>(null);
  const [formOpen, setFormOpen] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get('/product/shipping-orders', {
        params: { dateFrom, dateTo, customerCode: customerCode || undefined, modelName: modelName || undefined },
      });
      setRows(res.data?.data ?? []);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, customerCode, modelName]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const columns = useMemo<ColumnDef<ShippingOrderRow>[]>(() => [
    { accessorKey: 'shipOrderNo', header: '출하지시번호', size: 130 },
    { accessorKey: 'planDate', header: '납기일', size: 100 },
    { id: 'customer', header: '고객', size: 160, accessorFn: (r) => r.customerName ?? r.customerCode ?? '' },
    { accessorKey: 'modelName', header: '모델', size: 220 },
    { accessorKey: 'planQty', header: '지시수량', size: 90, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
    { accessorKey: 'actualQty', header: '출고수량', size: 90, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
    { accessorKey: 'remainQty', header: '잔량', size: 90, meta: { align: 'right' }, cell: (c) => num(c.getValue()) },
    {
      accessorKey: 'planStatus', header: '상태', size: 80,
      cell: (c) => <ComCodeBadge groupCode="PLAN STATUS" code={String(c.getValue() ?? 'W')} />,
    },
    { accessorKey: 'comments', header: '비고', size: 200 },
  ], []);

  const total = rows.reduce((s, r) => s + Number(r.remainQty ?? 0), 0);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header className="flex items-start justify-between gap-3">
        <div>
          <h1 className="text-xl font-bold text-text">제품납품계획</h1>
          <p className="mt-1 text-sm text-text-muted">
            고객별 출하지시를 등록합니다 · {rows.length.toLocaleString()}건 · 잔량 {total.toLocaleString()}
          </p>
        </div>
        <Button onClick={() => { setEditing(null); setFormOpen(true); }}>
          <Plus className="mr-1 h-4 w-4" />제품납품계획 등록
        </Button>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="납기일" from={dateFrom} to={dateTo} onFromChange={setDateFrom} onToChange={setDateTo} />
          <CustomerSelect aria-label="고객 조건" includeAll value={customerCode} onChange={setCustomerCode} className="w-48" />
          <ModelSearchField aria-label="모델 조건" placeholder="모델" value={modelName} className="w-44"
            onChange={(v) => setModelName(v)} />
          <Button size="sm" onClick={() => void search()} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={columns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="제품납품계획"
            getRowId={(r) => (r as ShippingOrderRow).shipOrderNo}
            onRowClick={(r) => { setEditing(r as ShippingOrderRow); setFormOpen(true); }}
            emptyMessage="기간 안에 제품납품계획이 없습니다."
          />
        </CardContent>
      </Card>

      <ShippingOrderFormModal isOpen={formOpen} order={editing} onClose={() => setFormOpen(false)}
        onSaved={() => { setFormOpen(false); void search(); }} />
    </div>
  );
}
