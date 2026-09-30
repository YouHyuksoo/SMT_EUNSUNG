"use client";

/**
 * @file src/app/(authenticated)/purchase/arrival/page.tsx
 * @description 484 자재도착관리 — PB w_mat_arrival_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **실려 온 자재가 도착했다고 확인하는 화면이다.** 출발 등록은 자재출발관리
 *    (483)가 한다 — 같은 표를 단계로 나눠 쓴다.
 * 2. **도착 확인은 출발 행의 단계를 D → A 로 바꾸는 것이다. 새 행을 만들지 않는다.**
 *    늘리면 도착수량이 두 배가 된다.
 * 3. **입고(R)까지 간 건은 손댈 수 없다.** 창고가 이미 받은 것이다.
 * 4. 취소는 지우지 않고 상태를 C 로 바꾼다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { PackageCheck, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ScreenTabs from '@/components/shared/ScreenTabs';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { arrivalColumns } from '../purchase-columns';
import type { ArrivalRow } from '../purchase-columns';

type Tab = 'pending' | 'history';

const today = () => new Date().toISOString().slice(0, 10);
const monthsAgo = (n: number) => {
  const d = new Date();
  d.setMonth(d.getMonth() - n);
  return d.toISOString().slice(0, 10);
};
const apiMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

export default function ArrivalPage() {
  const [tab, setTab] = useState<Tab>('pending');
  const [dateFrom, setDateFrom] = useState(monthsAgo(1));
  const [dateTo, setDateTo] = useState(today());
  const [supplierCond, setSupplierCond] = useState('');
  const [orderNoCond, setOrderNoCond] = useState('');
  const [statusCond, setStatusCond] = useState('');
  const [rows, setRows] = useState<ArrivalRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 도착 확인
  const [target, setTarget] = useState<ArrivalRow | null>(null);
  const [arrivalDate, setArrivalDate] = useState(today());
  const [cancelTarget, setCancelTarget] = useState<ArrivalRow | null>(null);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async (nextTab: Tab = tab) => {
    setLoading(true);
    try {
      const r = await api.get('/purchase/arrival', {
        params: {
          dateFrom,
          dateTo,
          // 도착 대기 = 아직 출발(D) 단계인 것. 이력 = 도착(A) 단계인 것.
          arrivalType: nextTab === 'pending' ? 'D' : 'A',
          arrivalStatus: statusCond || undefined,
          supplierCode: supplierCond || undefined,
          orderNo: orderNoCond.trim() || undefined,
        },
      });
      setRows(r.data?.data ?? []);
      setTarget(null);
      mark(r);
      setSearched(true);
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [tab, dateFrom, dateTo, statusCond, supplierCond, orderNoCond, mark]);

  useEffect(() => { void search('pending'); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  /** 탭을 바꾸면 이전 결과와 선택을 비운다 — PB 라디오버튼도 그랬다. */
  const changeTab = useCallback((nextTab: Tab) => {
    setTab(nextTab);
    setRows([]);
    setTarget(null);
    setSearched(false);
    void search(nextTab);
  }, [search]);

  const confirm = useCallback(async () => {
    if (!target) return;
    setBusy(true);
    try {
      await api.post('/purchase/arrival/confirm', {
        arrivalSeqNo: target.arrivalSeqNo,
        arrivalDate,
      });
      toast.success('도착으로 확인했습니다.');
      setTarget(null);
      await search();
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [target, arrivalDate, search]);

  const cancel = useCallback(async () => {
    if (!cancelTarget) return;
    setBusy(true);
    try {
      await api.post('/purchase/arrival/cancel', {
        arrivalSeqNo: cancelTarget.arrivalSeqNo,
      });
      toast.success('취소했습니다.');
      setCancelTarget(null);
      await search();
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '취소에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [cancelTarget, search]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재도착관리</h1>
        <p className="mt-1 text-sm text-text-muted">
          실려 온 자재의 도착을 확인합니다 (출발 등록은 자재출발관리에서) ·{' '}
          {searched ? `${rows.length.toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      <ScreenTabs<Tab>
        active={tab}
        onChange={changeTab}
        tabs={[
          { key: 'pending', label: '도착 대기' },
          { key: 'history', label: '도착 이력' },
        ]}
      />

      {tab === 'pending' && (
        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <span className="flex items-center gap-1 text-sm font-semibold text-text">
              <PackageCheck className="h-4 w-4" />도착 확인
            </span>
            <span className="text-sm text-text">
              {target
                ? `순번 ${target.arrivalSeqNo} · ${target.orderNo ?? ''} ·`
                  + ` ${(target.arrivalQty ?? 0).toLocaleString()}`
                : '아래에서 출발 건을 고르세요'}
            </span>
            <Input aria-label="도착일" type="date" value={arrivalDate}
              className="w-40" onChange={(e) => setArrivalDate(e.target.value)} />
            <Button size="sm" disabled={busy || !target} onClick={confirm}>
              도착 확인
            </Button>
            {target && (
              <>
                <Button size="sm" variant="secondary" onClick={() => setTarget(null)}>
                  선택 해제
                </Button>
                <Button size="sm" variant="danger" disabled={busy}
                  onClick={() => setCancelTarget(target)}>
                  출발 취소
                </Button>
              </>
            )}
          </CardContent>
        </Card>
      )}

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label={tab === 'pending' ? '출발일' : '도착일'}
            from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <SupplierSelect aria-label="협력사" includeAll labelPrefix="협력사"
            value={supplierCond} className="w-48" onChange={setSupplierCond} />
          <Input aria-label="주문번호" placeholder="주문번호" value={orderNoCond}
            className="w-40" onChange={(e) => setOrderNoCond(e.target.value)} />
          <ComCodeSelect groupCode="ARRIVAL STATUS" labelPrefix="상태"
            aria-label="상태" value={statusCond} className="w-36"
            onChange={setStatusCond} />
          <Button size="sm" onClick={() => search()} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="flex h-full flex-col gap-2 p-3">
          <span className="text-sm font-semibold text-text">
            {tab === 'pending' ? '도착 대기' : '도착 이력'} {rows.length.toLocaleString()}건
          </span>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={rows}
              columns={arrivalColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName={tab === 'pending' ? '도착대기' : '도착이력'}
              emptyMessage={searched
                ? (tab === 'pending' ? '도착을 기다리는 건이 없습니다.' : '이 기간에 도착이 없습니다.')
                : '조회하세요.'}
              onRowClick={(row) => {
                const arrival = row as ArrivalRow;
                if (arrival.arrivalStatus === 'C') {
                  toast.error('이미 취소된 건입니다.');
                  return;
                }
                if (tab !== 'pending') {
                  setCancelTarget(arrival);
                  return;
                }
                setTarget(arrival);
                setArrivalDate(today());
              }}
              rowClassName={(row) => ((row as ArrivalRow).arrivalSeqNo
                === target?.arrivalSeqNo ? 'bg-primary/10' : '')}
            />
          </div>
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={Boolean(cancelTarget)}
        onClose={() => setCancelTarget(null)}
        onConfirm={cancel}
        title="취소 처리"
        message={`순번 ${cancelTarget?.arrivalSeqNo ?? ''} (주문 ${cancelTarget?.orderNo ?? ''}) 을`
          + ' 취소 상태로 바꿉니다. 기록은 지우지 않고, 입고까지 간 건은 바뀌지 않습니다.'}
        confirmText="취소 처리"
      />
    </div>
  );
}
