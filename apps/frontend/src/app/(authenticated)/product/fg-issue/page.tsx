"use client";

/**
 * @file src/app/(authenticated)/product/fg-issue/page.tsx
 * @description 307 제품출하관리 — PB w_prd_product_fg_issue 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **제품창고의 박스를 고객에게 내보내는 화면이다.** 박스 바코드와 고객을 찍는다.
 * 2. **계산은 DB 프로시저가 한다** (`P_PRODUCT_FG_ISSUE`). PB 도 같은 프로시저를 불렀으므로
 *    PB 로 넣든 웹으로 넣든 결과가 같다.
 * 3. **취소는 같은 프로시저의 다른 코드다.** 정상/취소 버튼으로 고른다.
 * 4. **아래 표는 출하가능 목록이다** (제품창고에 있고 파렛트에 안 실린 것).
 *    현장은 이 목록에서 골라 바코드를 찍는다. 출하 이력과 거래처별 · 품목별 · 일자별
 *    합계는 제품출하조회(`/product/fg-issue-query`) 화면에서 본다.
 * 5. **기본 기간이 7일이다.** 재고일 기준으로 거른다.
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
import { fgIssuableColumns } from '../shipping-columns';
import type { FgIssuableRow } from '../shipping-columns';

import { getTodayLocal } from '@/utils/date';
const today = () => getTodayLocal();

export default function FgIssuePage() {
  const [dateFrom, setDateFrom] = useState(today());
  const [dateTo, setDateTo] = useState(today());
  const [barcode, setBarcode] = useState('');
  const [modelName, setModelName] = useState('');
  const [issuable, setIssuable] = useState<FgIssuableRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const r = await api.get('/product/fg/issuable', {
        params: {
          dateFrom,
          dateTo,
          barcode: barcode || undefined,
          modelName: modelName || undefined,
        },
      });
      setIssuable(r.data?.data ?? []);
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

  const count = issuable.length;
  const total = issuable.reduce((sum, r) => sum + Number(r.qty ?? 0), 0);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">제품출하관리</h1>
        <p className="mt-1 text-sm text-text-muted">
          제품을 고객에게 내보냅니다 ·{' '}
          {searched
            ? `출하가능 ${count.toLocaleString()}건 · 수량 ${total.toLocaleString()}`
            : '조회하세요'}
        </p>
      </header>

      <FgScanPanel endpoint="/product/fg/issue" title="제품 출하"
        withQty={false} withCustomer storageKey="mes-fg-issue-location" onDone={search} />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="재고일" from={dateFrom} to={dateTo}
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
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={issuable}
            columns={fgIssuableColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="제품출하가능"
            enableColumnPinning
            defaultPinnedColumns={{ left: ['barcode'] }}
            emptyMessage={searched ? '출하할 수 있는 재고가 없습니다.' : '조회하세요.'}
          />
        </CardContent>
      </Card>
    </div>
  );
}
