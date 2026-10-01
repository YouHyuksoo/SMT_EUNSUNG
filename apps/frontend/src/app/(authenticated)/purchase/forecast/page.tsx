"use client";

/**
 * @file src/app/(authenticated)/purchase/forecast/page.tsx
 * @description 480 자재주문예정관리 — PB w_mat_forecast_order_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **주문을 걸기 전에 "이만큼 걸 예정"이라고 올려 두고 결재받는 화면이다.**
 *    확정(Y)하면 그때 실제 주문(481)이 만들어진다.
 * 2. **승인단계는 셋이다** — 아니오(N) · 대기(W) · 확정(Y). 대기는 결재 요청,
 *    확정은 주문 생성이다.
 * 3. **확정해도 예정 기록은 지우지 않는다.** 어느 예정에서 넘어온 주문인지
 *    되짚어야 하기 때문이다.
 * 4. 여러 줄을 한 번에 바꾼다 — PB 도 체크한 줄을 모두 처리했다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { CheckCircle2, Clock, Search, XCircle } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent, ConfirmModal } from '@/components/ui';
import api from '@/services/api';
import { getTodayLocal } from '@/utils/date';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { forecastOrderColumns, selectColumn } from '../purchase-columns';
import type { PurchaseOrderRow } from '../purchase-columns';
import PartSearchField from '@/components/shared/PartSearchField';

type Confirm = 'N' | 'W' | 'Y';

const today = () => getTodayLocal();
const monthsAgo = (n: number) => {
  const d = new Date();
  d.setMonth(d.getMonth() - n);
  return getTodayLocal(d);
};
const apiMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

const ACTION_TEXT: Record<Confirm, { label: string; message: string }> = {
  W: { label: '결재 요청', message: '고른 예정을 대기(W) 로 올립니다.' },
  Y: {
    label: '확정',
    message: '고른 예정을 확정(Y) 합니다. **실제 주문이 만들어집니다.**'
      + ' 예정 기록은 지우지 않고 확정 표시만 남습니다.',
  },
  N: { label: '되돌리기', message: '고른 예정을 아니오(N) 로 되돌립니다.' },
};

export default function ForecastOrderPage() {
  const [dateFrom, setDateFrom] = useState(monthsAgo(3));
  const [dateTo, setDateTo] = useState(today());
  const [supplierCond, setSupplierCond] = useState('');
  const [itemCond, setItemCond] = useState('');
  const [confirmCond, setConfirmCond] = useState('');
  const [rows, setRows] = useState<PurchaseOrderRow[]>([]);
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [pending, setPending] = useState<Confirm | null>(null);
  const [busy, setBusy] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const r = await api.get('/purchase/forecast', {
        params: {
          dateFrom,
          dateTo,
          supplierCode: supplierCond || undefined,
          itemCode: itemCond.trim() || undefined,
          confirmYn: confirmCond || undefined,
        },
      });
      setRows(r.data?.data ?? []);
      setSelected(new Set());
      mark(r);
      setSearched(true);
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, supplierCond, itemCond, confirmCond, mark]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const toggle = useCallback((orderNo: string) => {
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(orderNo)) next.delete(orderNo); else next.add(orderNo);
      return next;
    });
  }, []);

  /** 확정된 줄은 다시 확정할 게 없다. 고를 수 있는 것만 전체선택 대상이다. */
  const selectableNos = useMemo(
    () => rows.map((row) => row.orderNo),
    [rows],
  );
  const allSelected = selectableNos.length > 0
    && selectableNos.every((no) => selected.has(no));
  const columns = useMemo(() => [
    selectColumn<PurchaseOrderRow>({
      isSelected: (row) => selected.has(row.orderNo),
      onToggle: (row) => toggle(row.orderNo),
      allSelected,
      onToggleAll: () => setSelected(allSelected ? new Set() : new Set(selectableNos)),
    }),
    ...forecastOrderColumns,
  ], [selected, toggle, allSelected, selectableNos]);

  const apply = useCallback(async () => {
    if (!pending || selected.size === 0) return;
    setBusy(true);
    try {
      const r = await api.post('/purchase/forecast/confirm', {
        orderNos: [...selected],
        confirmYn: pending,
      });
      const changed = r.data?.data?.changed ?? selected.size;
      toast.success(`${ACTION_TEXT[pending].label} 처리했습니다 (${changed}건).`);
      setPending(null);
      await search();
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [pending, selected, search]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재주문예정관리</h1>
        <p className="mt-1 text-sm text-text-muted">
          주문을 걸기 전 예정을 올리고 결재합니다 (확정하면 주문이 만들어집니다) ·{' '}
          {searched ? `${rows.length.toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="주문일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <SupplierSelect aria-label="협력사" includeAll labelPrefix="협력사"
            value={supplierCond} className="w-48" onChange={setSupplierCond} />
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCond}
            className="w-40" onChange={(e) => setItemCond(e.target.value)} />
          <ComCodeSelect groupCode="CONFIRM YN" labelPrefix="승인"
            aria-label="승인단계" value={confirmCond} className="w-36"
            onChange={setConfirmCond} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      {/* 승인단계 변경 (쓰기) */}
      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="text-sm font-semibold text-text">
            고른 예정 {selected.size.toLocaleString()}건
          </span>
          <Button size="sm" variant="secondary" disabled={rows.length === 0}
            onClick={() => setSelected(allSelected ? new Set() : new Set(selectableNos))}>
            {allSelected ? '전체 해제' : '전체 선택'}
          </Button>
          <Button size="sm" disabled={busy || selected.size === 0}
            onClick={() => setPending('Y')}>
            <CheckCircle2 className="mr-1 h-4 w-4" />확정
          </Button>
          <Button size="sm" variant="secondary" disabled={busy || selected.size === 0}
            onClick={() => setPending('W')}>
            <Clock className="mr-1 h-4 w-4" />결재 요청
          </Button>
          <Button size="sm" variant="secondary" disabled={busy || selected.size === 0}
            onClick={() => setPending('N')}>
            <XCircle className="mr-1 h-4 w-4" />되돌리기
          </Button>
          <span className="text-sm text-text-muted">
            줄을 눌러 고릅니다. 확정하면 실제 주문이 만들어집니다.
          </span>
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={columns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="자재주문예정"
            emptyMessage={searched ? '이 기간에 예정이 없습니다.' : '조회하세요.'}
            onRowClick={(row) => toggle((row as PurchaseOrderRow).orderNo)}
            rowClassName={(row) => (selected.has((row as PurchaseOrderRow).orderNo)
              ? 'bg-primary/15' : '')}
          />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={Boolean(pending)}
        onClose={() => setPending(null)}
        onConfirm={apply}
        title={pending ? ACTION_TEXT[pending].label : ''}
        message={pending
          ? `${selected.size}건 — ${ACTION_TEXT[pending].message}`
          : ''}
        confirmText={pending ? ACTION_TEXT[pending].label : ''}
      />
    </div>
  );
}
