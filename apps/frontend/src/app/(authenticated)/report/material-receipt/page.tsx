"use client";

/**
 * @file src/app/(authenticated)/report/material-receipt/page.tsx
 * @description 자재입고리포트 — PB w_mat_receipt_report 이식
 *
 * 초보자 가이드:
 * 1. **네 갈래로 본다.** 일자별 상세 · 협력사별 · 반품 · 품목×일자 매트릭스다.
 * 2. **기준단가가 입고단가와 다르면 주황으로 보인다.** PB 와 같은 DB 함수가
 *    기준단가를 계산한다 — 단가확인이 안 된 입고를 찾는 것이 이 열의 목적이다.
 * 3. **매트릭스는 열이 조회 기간에 따라 달라진다** (DataWindow processing=4).
 *    서버가 `(품목, 일자, 수량)` 목록을 주고 피벗은 화면에서 돌린다.
 * 4. **취소된 입고는 안 나온다** (PB 고정조건 `RECEIPT_STATUS <> 'C'`).
 *    반품 탭은 입출고구분이 '2' 인 건만 본다.
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
  materialReceiptColumns,
  materialReceiptSupplierColumns,
} from '../report-b-columns';
import type {
  MaterialReceiptMatrixRow,
  MaterialReceiptRow,
  MaterialReceiptSupplierRow,
} from '../report-b-types';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

type Tab = 'detail' | 'supplier' | 'return' | 'matrix';

export default function MaterialReceiptReportPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(daysAgo(0));
  const [supplierCode, setSupplierCode] = useState('');
  const [itemCode, setItemCode] = useState('');
  const [itemClass, setItemClass] = useState('');
  const [locationCode, setLocationCode] = useState('');

  const [tab, setTab] = useState<Tab>('detail');
  const [detail, setDetail] = useState<MaterialReceiptRow[]>([]);
  const [bySupplier, setBySupplier] = useState<MaterialReceiptSupplierRow[]>([]);
  const [returns, setReturns] = useState<MaterialReceiptSupplierRow[]>([]);
  const [matrix, setMatrix] = useState<MaterialReceiptMatrixRow[]>([]);
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
        itemClass: itemClass || undefined,
        locationCode: locationCode || undefined,
      };
      const [d, s, r, m] = await Promise.all([
        api.get('/report/material-receipt/detail', { params }),
        api.get('/report/material-receipt/supplier', { params }),
        api.get('/report/material-receipt/return', { params }),
        api.get('/report/material-receipt/matrix', { params }),
      ]);
      setDetail(d.data?.data ?? []);
      setBySupplier(s.data?.data ?? []);
      setReturns(r.data?.data ?? []);
      setMatrix(m.data?.data ?? []);
      mark(d, s, r, m);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '자재입고 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, supplierCode, itemCode, itemClass, locationCode]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const spec = useMemo<CrosstabSpec<MaterialReceiptMatrixRow>>(() => ({
    rowKey: (r) => r.itemCode ?? '',
    rowLabels: [
      { header: '품목코드', value: (r) => r.itemCode ?? '', width: 150 },
      { header: '품목명', value: (r) => r.itemName ?? '', width: 170 },
      { header: '규격', value: (r) => r.itemSpec ?? '' },
      { header: '단위', value: (r) => r.itemUom ?? '' },
    ],
    colKey: (r) => r.receiptDate,
    // 열이 30개면 연도는 자리만 차지한다.
    colHeader: (k) => k.slice(5),
    value: (r) => Number(r.receiptQty ?? 0),
  }), []);

  const priceMismatch = detail.filter((r) => r.checkUnitPrice != null
    && r.unitPrice != null
    && Number(r.checkUnitPrice) !== Number(r.unitPrice)).length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재입고리포트</h1>
        <p className="mt-1 text-sm text-text-muted">
          자재 입고를 일자별·협력사별·반품·매트릭스로 봅니다 ·{' '}
          {searched
            ? `상세 ${detail.length.toLocaleString()}건`
              + `${priceMismatch > 0 ? ` · 단가 불일치 ${priceMismatch.toLocaleString()}건` : ''}`
            : '조회하세요'}
        </p>
      </header>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} what="단가 불일치 건수" />

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
          <ComCodeSelect groupCode="ITEM CLASS" labelPrefix="품목분류" value={itemClass}
            onChange={setItemClass} className="w-48" />
          <ComCodeSelect groupCode="MATERIAL LOCATION CODE" labelPrefix="창고"
            value={locationCode} onChange={setLocationCode} className="w-48" />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <ScreenTabs
        tabs={[
          { key: 'detail', label: '일자별 상세', count: detail.length },
          { key: 'supplier', label: '협력사별', count: bySupplier.length },
          { key: 'return', label: '반품', count: returns.length },
          { key: 'matrix', label: '품목 × 일자', count: matrix.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'detail' && (
            <DataGrid
              data={detail}
              columns={materialReceiptColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재입고상세"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['receiptDate'] }}
              emptyMessage={searched ? '기간에 입고가 없습니다.' : '조회하세요.'}
            />
          )}
          {tab === 'supplier' && (
            <DataGrid
              data={bySupplier}
              columns={materialReceiptSupplierColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재입고_협력사별"
              emptyMessage={searched ? '기간에 입고가 없습니다.' : '조회하세요.'}
            />
          )}
          {tab === 'return' && (
            <DataGrid
              data={returns}
              columns={materialReceiptSupplierColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재입고_반품"
              emptyMessage={searched ? '기간에 반품이 없습니다.' : '조회하세요.'}
            />
          )}
          {tab === 'matrix' && (
            <CrosstabGrid
              rows={matrix}
              spec={spec}
              isLoading={loading}
              exportFileName="자재입고_품목별일자"
              emptyMessage={searched ? '기간에 입고가 없습니다.' : '조회하세요.'}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
