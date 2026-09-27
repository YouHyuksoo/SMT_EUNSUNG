"use client";

/**
 * @file src/app/(authenticated)/report/material-barcode-slip/page.tsx
 * @description 자재전표바코드리포트 — PB w_mat_receipt_issue_barcode_history_report 이식
 *
 * 초보자 가이드:
 * 1. **자재 바코드를 언제 누가 스캔했는지 본다.** 입고 대조와 출고 대조가 각각
 *    끝났는지 한 줄에서 확인한다.
 * 2. **PB 는 롯트를 쪼갠 바코드만 보여줬다** (고정조건 `LOT_DIVIDE_YN='Y'`).
 *    그 조건을 화면에서 끌 수 있게 했지만 기본은 PB 와 같이 켬이다 — 끄면
 *    193만행이 대상이 된다.
 * 3. **기간이 필수다.** 구동 표의 날짜 인덱스는 SCAN_DATE 다 (실측).
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import { Button, Card, CardContent, Input, Select } from '@/components/ui';
import api from '@/services/api';
import { TruncationNotice, useTruncation } from '../components/TruncationNotice';
import { materialBarcodeSlipColumns } from '../report-b-columns';
import type { MaterialBarcodeSlipRow } from '../report-b-types';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

const DIVIDE_OPTIONS = [
  { value: 'Y', label: '롯트분할: 분할분만 (PB 기본)' },
  { value: 'N', label: '롯트분할: 분할 아닌 것만' },
  { value: 'ALL', label: '롯트분할: 전체' },
];

export default function MaterialBarcodeSlipPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(daysAgo(0));
  const [itemCode, setItemCode] = useState('');
  const [lotNo, setLotNo] = useState('');
  const [lotDivideYn, setLotDivideYn] = useState('Y');

  const [rows, setRows] = useState<MaterialBarcodeSlipRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/report/material-barcode-slip', {
        params: {
          dateFrom,
          dateTo,
          itemCode: itemCode || undefined,
          lotNo: lotNo || undefined,
          lotDivideYn,
        },
      });
      setRows(response.data?.data ?? []);
      mark(response);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '자재전표바코드 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, itemCode, lotNo, lotDivideYn]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const notCompared = rows.filter((r) => r.receiptCompareYn !== 'Y').length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재전표바코드리포트</h1>
        <p className="mt-1 text-sm text-text-muted">
          자재 바코드 스캔 이력과 입고·출고 대조 상태를 봅니다 ·{' '}
          {searched
            ? `${rows.length.toLocaleString()}건${notCompared > 0 ? ` · 입고 미대조 ${notCompared.toLocaleString()}건` : ''}`
            : '조회하세요'}
        </p>
      </header>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} what="입고 미대조 건수" />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="스캔일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCode} className="w-40"
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="자재 롯트" placeholder="자재 롯트" value={lotNo} className="w-40"
            onChange={(e) => setLotNo(e.target.value)} />
          {/* PB 가 고정으로 걸던 조건. 끄면 대상이 193만행이 된다. */}
          <Select options={DIVIDE_OPTIONS} value={lotDivideYn} onChange={setLotDivideYn}
            className="w-60" />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={materialBarcodeSlipColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="자재전표바코드"
            enableColumnPinning
            defaultPinnedColumns={{ left: ['itemBarcode'] }}
            emptyMessage={searched ? '기간에 스캔 이력이 없습니다.' : '조회하세요.'}
            getRowId={(row) => (row as MaterialBarcodeSlipRow).itemBarcode}
          />
        </CardContent>
      </Card>
    </div>
  );
}
