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
 * 6. **제품납품계획(출하지시)을 고르면** 출고한 박스가 그 지시에 쌓이고 고객은 지시의 고객으로 고정된다.
 *    지시를 고르지 않으면 지금처럼 고객만 넣고 내보낸다. 취소는 박스 기록으로 지시를 찾아 되돌린다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { ClipboardList, Search, X } from 'lucide-react';
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
import ShippingOrderPickerModal from '../components/ShippingOrderPickerModal';
import type { ShippingOrderRow } from '../shipping-order/types';
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
  const [shipOrder, setShipOrder] = useState<ShippingOrderRow | null>(null);
  const [pickerOpen, setPickerOpen] = useState(false);

  /** 출고 뒤 고른 지시의 잔량을 다시 읽는다. 다 차면 선택을 푼다. */
  const refreshOrder = useCallback(async () => {
    if (!shipOrder) return;
    try {
      const r = await api.get('/product/shipping-orders', {
        params: { dateFrom: shipOrder.planDate, dateTo: shipOrder.planDate },
      });
      const next = (r.data?.data as ShippingOrderRow[] | undefined)?.find((o) => o.shipOrderNo === shipOrder.shipOrderNo) ?? null;
      if (next && next.planStatus === 'C') {
        toast.success(`제품납품계획 ${next.shipOrderNo} 출고가 끝났습니다.`);
        setShipOrder(null);
      } else {
        setShipOrder(next);
      }
    } catch {
      // 잔량 표시만 못 바꾼다. 출고 자체는 이미 끝났다.
    }
  }, [shipOrder]);

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
        withQty={false} withCustomer storageKey="mes-fg-issue-location"
        onDone={async () => { await refreshOrder(); await search(); }}
        extraBody={shipOrder ? { shipOrderNo: shipOrder.shipOrderNo } : undefined}
        fixedCustomerCode={shipOrder?.customerCode ?? undefined}
        headerSlot={shipOrder ? (
          <span className="flex items-center gap-2 rounded-md border border-primary/40 bg-primary/5 px-2 py-1 text-sm">
            <span className="font-mono font-semibold text-text">{shipOrder.shipOrderNo}</span>
            <span className="text-text">{shipOrder.modelName}</span>
            <span className="text-text-muted">잔량 {Number(shipOrder.remainQty).toLocaleString()}</span>
            <button type="button" aria-label="제품납품계획 선택 해제" onClick={() => setShipOrder(null)}
              className="text-text-muted hover:text-text"><X className="h-4 w-4" /></button>
          </span>
        ) : (
          <Button size="sm" variant="secondary" onClick={() => setPickerOpen(true)}>
            <ClipboardList className="mr-1 h-4 w-4" />제품납품계획 선택
          </Button>
        )} />
      <ShippingOrderPickerModal isOpen={pickerOpen} onClose={() => setPickerOpen(false)}
        onPick={(o) => { setShipOrder(o); setPickerOpen(false); }} />

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
