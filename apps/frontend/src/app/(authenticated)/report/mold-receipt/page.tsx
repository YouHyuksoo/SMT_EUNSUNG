"use client";

/**
 * @file src/app/(authenticated)/report/mold-receipt/page.tsx
 * @description S-PARTS입고리포트 — PB w_mcn_mold_receipt_rpt 이식
 *
 * 초보자 가이드:
 * 1. **S-PARTS(소모성 부품) 입고 이력을 본다.**
 * 2. **이 표는 현재 0행이다** (IMCN_MOLD_RECEIPT 실측 0건). 화면은 동작하지만
 *    볼 것이 없다 — 은성이 S-PARTS 를 이 표에 쌓지 않는다. 조건이 틀린 게 아니다.
 * 3. **PB 고정조건을 유지했다.** `MOLD_CODE <> '*'`(더미 마스터 제외) ·
 *    `RECEIPT_STATUS = 'N'`(정상 입고만). 빼면 취소분과 더미 행이 섞인다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent } from '@/components/ui';
import api from '@/services/api';
import { TruncationNotice, useTruncation } from '../components/TruncationNotice';
import { moldReceiptColumns } from '../report-b-columns';
import type { MoldReceiptRow } from '../report-b-types';
import MoldCodeField from '@/app/(authenticated)/mold/components/MoldCodeField';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

export default function MoldReceiptReportPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(30));
  const [dateTo, setDateTo] = useState(daysAgo(0));
  const [moldCode, setMoldCode] = useState('');
  const [supplierCode, setSupplierCode] = useState('');

  const [rows, setRows] = useState<MoldReceiptRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/report/mold-receipt', {
        params: {
          dateFrom,
          dateTo,
          moldCode: moldCode || undefined,
          supplierCode: supplierCode || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      mark(response);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? 'S-PARTS 입고 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, moldCode, supplierCode]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">S-PARTS입고리포트</h1>
        <p className="mt-1 text-sm text-text-muted">
          S-PARTS 입고 이력을 봅니다 (정상 입고만) ·{' '}
          {searched ? `${rows.length.toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="입고일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <MoldCodeField popupId="mold-search" returnKey="moldCode" placeholder="S-PARTS 코드" value={moldCode} onChange={setMoldCode} onEnter={() => void search()} className="w-44" />
          <div className="w-52">
            <SupplierSelect includeAll value={supplierCode} onChange={setSupplierCode} />
          </div>
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={moldReceiptColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="S-PARTS입고"
            emptyMessage={searched
              ? 'S-PARTS 입고 기록이 없습니다 (이 표는 현재 비어 있습니다).'
              : '조회하세요.'}
          />
        </CardContent>
      </Card>
    </div>
  );
}
