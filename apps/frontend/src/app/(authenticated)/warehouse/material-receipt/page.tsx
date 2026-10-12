"use client";

/**
 * @file src/app/(authenticated)/warehouse/material-receipt/page.tsx
 * @description 자재입고관리 — PB w_mat_receipt_master 이식 (조회)
 *
 * 초보자 가이드:
 * 1. **입고 원장을 보는 화면이다.** 바코드로 들어온 입고(자재입고전표관리·
 *    자재바코드입고관리)와 사람이 직접 넣은 기타입고가 모두 한 표에 쌓인다.
 * 2. **이 화면에서는 등록·수정을 하지 않는다.** PB 의 등록 그리드는 왼쪽 입고예정
 *    목록에서 고른 행으로만 채워지는데, 이 현장에서는 그 목록이 **항상 비어 있다**
 *    (입고예정을 만드는 구매발주·반품 화면을 쓰지 않는다). 그래서 PB 에서도 이 화면의
 *    등록 경로가 동작하지 않는다.
 * 3. **수량이 음수면 차감이다.** 기타입고 쪽에서 들어온 건이며 빨간색으로 보인다.
 * 4. **바코드 열에 값이 있으면** 라벨을 대조해 만들어진 입고다. 그 건은
 *    자재기타입고관리에서도 고칠 수 없다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { arrivalColumns, receiptColumns } from '../receipt-manage-columns';
import type { ArrivalRow, ReceiptRow } from '../receipt-manage-columns';
import PartSearchField from '@/components/shared/PartSearchField';
import SupplierSelect from '@/components/shared/SupplierSelect';
import ComCodeSelect from '@/components/shared/ComCodeSelect';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

type TabKey = 'history' | 'arrivals';

export default function MaterialReceiptPage() {
  const [tab, setTab] = useState<TabKey>('history');
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(daysAgo(0));
  const [itemCode, setItemCode] = useState('');
  const [materialMfs, setMaterialMfs] = useState('');
  const [supplierCode, setSupplierCode] = useState('');
  const [locationCode, setLocationCode] = useState('');
  const [invoiceNo, setInvoiceNo] = useState('');

  const [rows, setRows] = useState<ReceiptRow[]>([]);
  const [arrivals, setArrivals] = useState<ArrivalRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const params = {
        dateFrom,
        dateTo,
        itemCode: itemCode || undefined,
        materialMfs: materialMfs || undefined,
        supplierCode: supplierCode || undefined,
        locationCode: locationCode || undefined,
        invoiceNo: invoiceNo || undefined,
      };
      if (tab === 'history') {
        const r = await api.get('/warehouse/receipt-manage/history', { params });
        setRows(r.data?.data ?? []);
        mark(r);
      } else {
        const r = await api.get('/warehouse/receipt-manage/arrivals', { params });
        setArrivals(r.data?.data ?? []);
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
  }, [tab, dateFrom, dateTo, itemCode, materialMfs, supplierCode, locationCode,
    invoiceNo, mark]);

  useEffect(() => { void search(); }, [tab]); // eslint-disable-line react-hooks/exhaustive-deps

  const totalQty = rows.reduce((sum, r) => sum + Number(r.receiptQty ?? 0), 0);
  const minusCount = rows.filter((r) => Number(r.receiptQty ?? 0) < 0).length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재입고관리</h1>
        <p className="mt-1 text-sm text-text-muted">
          입고 원장을 봅니다 ·{' '}
          {searched && tab === 'history'
            ? `${rows.length.toLocaleString()}건 · 수량 합 ${totalQty.toLocaleString()}`
              + (minusCount > 0 ? ` · 차감 ${minusCount}건` : '')
            : searched
              ? `${arrivals.length.toLocaleString()}건`
              : '조회하세요'}
        </p>
      </header>

      <ScreenTabs
        tabs={[
          { key: 'history' as TabKey, label: '입고 이력', count: rows.length },
          { key: 'arrivals' as TabKey, label: '입고예정', count: arrivals.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter
            label={tab === 'history' ? '입고일' : '입고예정일'}
            from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-44"
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <SupplierSelect includeAll labelPrefix="협력사" value={supplierCode} onChange={setSupplierCode} className="w-44" />
          <Input aria-label="전표번호" placeholder="전표번호" value={invoiceNo}
            className="w-40"
            onChange={(e) => setInvoiceNo(e.target.value)} />
          {tab === 'history' && (
            <>
              <Input aria-label="자재 롯트" placeholder="자재 롯트" value={materialMfs}
                className="w-40"
                onChange={(e) => setMaterialMfs(e.target.value)} />
              <ComCodeSelect groupCode="MATERIAL LOCATION CODE" labelPrefix="창고" value={locationCode} onChange={setLocationCode} className="w-44" />
            </>
          )}
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      {tab === 'arrivals' && searched && arrivals.length === 0 && (
        <p className="text-sm text-text-muted">
          입고예정은 구매발주·반품 화면이 만듭니다. 이 현장에서는 그 화면을 쓰지 않아
          항상 비어 있습니다.
        </p>
      )}

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'history' ? (
            <DataGrid
              data={rows}
              columns={receiptColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재입고"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['receiptDate'] }}
              emptyMessage={searched ? '조건에 맞는 입고가 없습니다.' : '조회하세요.'}
              rowClassName={(row) => (Number((row as ReceiptRow).receiptQty ?? 0) < 0
                ? 'bg-red-500/5'
                : '')}
            />
          ) : (
            <DataGrid
              data={arrivals}
              columns={arrivalColumns}
              isLoading={loading}
              pageSize={100}
              enableExport
              exportFileName="입고예정"
              emptyMessage={searched ? '입고예정이 없습니다.' : '조회하세요.'}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
