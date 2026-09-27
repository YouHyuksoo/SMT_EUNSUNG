"use client";

/**
 * @file src/app/(authenticated)/report/material-receipt-sum/page.tsx
 * @description 자재입고합계리포트 — PB w_mat_receipt_sum_report 이식
 *
 * 초보자 가이드:
 * 1. **다섯 갈래로 본다.** 품목별 · 협력사용(연락처 포함) · 협력사별 · 창고별 ·
 *    입출고 매트릭스다.
 * 2. **'협력사용' 은 협력사에 보내는 인쇄물이다.** 품목별 합계와 같은 집계에
 *    주소·전화·팩스를 붙인 것이다 (PB 가 DataWindow 를 따로 둔 이유다).
 * 3. **단가는 단순 평균이다** (PB `AVG(unit_price)`). 수량 가중 평균이 아니므로
 *    수량이 크게 다른 입고가 섞이면 금액과 맞지 않는다 — PB 와 같은 값을 유지한다.
 * 4. **매트릭스는 입고와 출고를 함께 본다** (UNION ALL). 열은 일자이고 조회 기간에
 *    따라 달라지므로 피벗은 화면에서 돌린다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ScreenTabs from '@/components/shared/ScreenTabs';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { TruncationNotice, useTruncation } from '../components/TruncationNotice';
import { CrosstabGrid, type CrosstabSpec } from '../components/CrosstabGrid';
import {
  materialReceiptSumItemColumns,
  materialReceiptSumSupplierColumns,
  materialReceiptSumWarehouseColumns,
} from '../report-b-columns';
import type {
  MaterialReceiptSumItemRow,
  MaterialReceiptSumSupplierRow,
  MaterialReceiptSumWarehouseRow,
  MaterialTxnMatrixRow,
} from '../report-b-types';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

type Tab = 'item' | 'contact' | 'supplier' | 'warehouse' | 'matrix';

export default function MaterialReceiptSumPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(daysAgo(0));
  const [supplierCode, setSupplierCode] = useState('');
  const [itemCode, setItemCode] = useState('');
  const [invoiceNo, setInvoiceNo] = useState('');
  const [locationCode, setLocationCode] = useState('');

  const [tab, setTab] = useState<Tab>('item');
  const [byItem, setByItem] = useState<MaterialReceiptSumItemRow[]>([]);
  const [withContact, setWithContact] = useState<MaterialReceiptSumItemRow[]>([]);
  const [bySupplier, setBySupplier] = useState<MaterialReceiptSumSupplierRow[]>([]);
  const [byWarehouse, setByWarehouse] = useState<MaterialReceiptSumWarehouseRow[]>([]);
  const [matrix, setMatrix] = useState<MaterialTxnMatrixRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const params = {
        dateFrom,
        dateTo,
        supplierCode: supplierCode || undefined,
        itemCode: itemCode || undefined,
        invoiceNo: invoiceNo || undefined,
        locationCode: locationCode || undefined,
      };
      const [i, c, s, w, m] = await Promise.all([
        api.get('/report/material-receipt-sum/item', { params }),
        api.get('/report/material-receipt-sum/item-with-contact', { params }),
        api.get('/report/material-receipt-sum/supplier', { params }),
        api.get('/report/material-receipt-sum/warehouse', { params }),
        api.get('/report/material-receipt-sum/matrix', { params }),
      ]);
      setByItem(i.data?.data ?? []);
      setWithContact(c.data?.data ?? []);
      setBySupplier(s.data?.data ?? []);
      setByWarehouse(w.data?.data ?? []);
      setMatrix(m.data?.data ?? []);
      mark(i, c, s, w, m);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '자재입고합계 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, supplierCode, itemCode, invoiceNo, locationCode]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const itemColumns = useMemo(() => materialReceiptSumItemColumns(false), []);
  const contactColumns = useMemo(() => materialReceiptSumItemColumns(true), []);

  const spec = useMemo<CrosstabSpec<MaterialTxnMatrixRow>>(() => ({
    // 입고와 출고를 같은 품목·위치에서 따로 줄로 놓는다 — 섞으면 상계돼 버린다.
    rowKey: (r) => [r.itemCode, r.txnKind, r.locationCode, r.supplierCode, r.deficit].join('|'),
    rowLabels: [
      { header: '품목코드', value: (r) => r.itemCode ?? '', width: 150 },
      { header: '구분', value: (r) => (r.txnKind === 'RECEIPT' ? '입고' : '출고') },
      { header: '입출고', value: (r) => r.deficitName ?? r.deficit ?? '' },
      { header: '창고', value: (r) => r.locationName ?? r.locationCode ?? '' },
      { header: '협력사', value: (r) => r.supplierName ?? r.supplierCode ?? '' },
    ],
    colKey: (r) => r.txnDate,
    colHeader: (k) => k.slice(5),
    value: (r) => Number(r.qty ?? 0),
  }), []);

  const totalQty = byItem.reduce((sum, r) => sum + Number(r.receiptQty ?? 0), 0);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재입고합계리포트</h1>
        <p className="mt-1 text-sm text-text-muted">
          자재 입고를 품목·협력사·창고별로 합계 냅니다 ·{' '}
          {searched
            ? `품목별 ${byItem.length.toLocaleString()}건 · 입고수량 합계 ${totalQty.toLocaleString()}`
            : '조회하세요'}
        </p>
      </header>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} what="입고수량 합계" />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="입고일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <div className="w-52">
            <SupplierSelect includeAll value={supplierCode} onChange={setSupplierCode} />
          </div>
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCode} className="w-40"
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="전표번호" placeholder="전표번호" value={invoiceNo} className="w-40"
            onChange={(e) => setInvoiceNo(e.target.value)} />
          <ComCodeSelect groupCode="MATERIAL LOCATION CODE" labelPrefix="창고"
            value={locationCode} onChange={setLocationCode} className="w-48" />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <ScreenTabs
        tabs={[
          { key: 'item', label: '품목별', count: byItem.length },
          { key: 'contact', label: '협력사용', count: withContact.length },
          { key: 'supplier', label: '협력사별', count: bySupplier.length },
          { key: 'warehouse', label: '창고별', count: byWarehouse.length },
          { key: 'matrix', label: '입출고 × 일자', count: matrix.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'item' && (
            <DataGrid
              data={byItem}
              columns={itemColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재입고합계_품목별"
              emptyMessage={searched ? '기간에 입고가 없습니다.' : '조회하세요.'}
            />
          )}
          {tab === 'contact' && (
            <DataGrid
              data={withContact}
              columns={contactColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재입고합계_협력사용"
              emptyMessage={searched ? '기간에 입고가 없습니다.' : '조회하세요.'}
            />
          )}
          {tab === 'supplier' && (
            <DataGrid
              data={bySupplier}
              columns={materialReceiptSumSupplierColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재입고합계_협력사별"
              emptyMessage={searched ? '기간에 입고가 없습니다.' : '조회하세요.'}
            />
          )}
          {tab === 'warehouse' && (
            <DataGrid
              data={byWarehouse}
              columns={materialReceiptSumWarehouseColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재입고합계_창고별"
              emptyMessage={searched ? '기간에 입고가 없습니다.' : '조회하세요.'}
            />
          )}
          {tab === 'matrix' && (
            <CrosstabGrid
              rows={matrix}
              spec={spec}
              isLoading={loading}
              exportFileName="자재입출고_일자별"
              emptyMessage={searched ? '기간에 입출고가 없습니다.' : '조회하세요.'}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
