"use client";

/**
 * @file src/app/(authenticated)/product/fg-model-receipt/page.tsx
 * @description 304 제품입고관리(모델단위) — PB w_prd_product_fg_4_model_receipt 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **박스가 아니라 모델과 수량으로 넣는 화면이다.** 박스를 만들지 않고 들어오는 물량에 쓴다 (실측 1,183건).
 * 2. **계산은 DB 프로시저가 한다** (`P_PRODUCT_FG_MODEL_RECEIPT`). PB 도 같은 프로시저를 불렀으므로
 *    PB 로 넣든 웹으로 넣든 결과가 같다.
 * 3. **취소는 같은 프로시저의 다른 코드다.** 정상/취소 버튼으로 고른다.
 * 4. **기본 기간이 7일이다.** 이 표는 기간 컬럼에 인덱스가 없어 한 달을 보면
 *    9,000행에 8.7초가 걸린다 (7일이면 2.4초).
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import { Button, Card, CardContent, Input } from '@/components/ui';
import ModelSearchField from '@/components/shared/ModelSearchField';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import FgScanPanel from '../components/FgScanPanel';
import { fgReceiptColumns } from '../shipping-columns';
import type { FgReceiptRow } from '../shipping-columns';

const today = () => new Date().toISOString().slice(0, 10);
const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

export default function FgModelReceiptPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(today());
  const [barcode, setBarcode] = useState('');
  const [modelName, setModelName] = useState('');
  const [rows, setRows] = useState<FgReceiptRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const r = await api.get('/product/fg/receipts', {
        params: {
          dateFrom,
          dateTo,
          barcode: barcode || undefined,
          modelName: modelName || undefined,
        },
      });
      setRows(r.data?.data ?? []);
      mark(r);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, barcode, modelName, mark]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const total = rows.reduce((sum, r) => sum + Number(r.qty ?? 0), 0);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">제품입고관리(모델단위)</h1>
        <p className="mt-1 text-sm text-text-muted">
          모델과 수량으로 제품창고에 넣습니다 ·{' '}
          {searched
            ? `${rows.length.toLocaleString()}건 · 순수량 ${total.toLocaleString()}`
            : '조회하세요'}
        </p>
      </header>

      <FgScanPanel endpoint="/product/fg/model-receipt" title="모델단위 입고"
        withQty={true} storageKey="mes-fg-model-receipt-location" onDone={search} />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="입고일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input aria-label="바코드 조건" placeholder="바코드" value={barcode}
            className="w-52"
            onChange={(e) => setBarcode(e.target.value)} />
          <ModelSearchField aria-label="모델 조건" placeholder="모델" value={modelName}
            className="w-36"
            onChange={(v) => setModelName(v)} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <span className="text-sm text-text-muted">
            취소분은 수량이 음수로 나옵니다.
          </span>
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={fgReceiptColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="제품입고_모델단위"
            enableColumnPinning
            defaultPinnedColumns={{ left: ['barcode'] }}
            emptyMessage={searched ? '이 기간에 입고 내역이 없습니다.' : '조회하세요.'}
          />
        </CardContent>
      </Card>
    </div>
  );
}
