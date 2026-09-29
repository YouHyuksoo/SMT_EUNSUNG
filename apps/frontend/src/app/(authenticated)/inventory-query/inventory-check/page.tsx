"use client";

/**
 * @file src/app/(authenticated)/inventory-query/inventory-check/page.tsx
 * @description 자재재고조사 — PB w_mat_inventory_check_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **실사(實査)는 장부와 실제를 맞추는 일이다.** 창고에서 센 수량이 장부와 다르면
 *    그 차이만큼 원장을 조정한다.
 * 2. **차이의 부호가 방향을 정한다.** 실제가 더 많으면(+) 그만큼 나간 것으로,
 *    적으면(−) 돌아온 것으로 처리한다.
 * 3. **조정은 마감월의 마지막 날짜로 들어간다.** 오늘 날짜로 넣으면 다음 달 수불로
 *    새어 나가기 때문이다.
 * 4. **이 현장은 실사를 아직 돌린 적이 없다** — 실사표와 조정 이력이 모두 비어 있다.
 *    빈 화면만 보고 헷갈리지 않도록 적어 둔다.
 * 5. **되돌릴 수 없다.** 조정을 잘못했으면 반대 부호로 한 번 더 조정해야 한다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, Scale, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { adjustHistoryColumns, inventoryCheckColumns } from '../inventory-query-columns';
import type { AdjustHistoryRow, InventoryCheckRow } from '../inventory-query-columns';

const lastMonth = () => {
  const d = new Date();
  d.setMonth(d.getMonth() - 1);
  return `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}`;
};

type TabKey = 'check' | 'adjust';

export default function InventoryCheckPage() {
  const [tab, setTab] = useState<TabKey>('check');
  const [yyyymm, setYyyymm] = useState(lastMonth());
  const [itemCodeCond, setItemCodeCond] = useState('');
  const [lotNoCond, setLotNoCond] = useState('');

  const [checks, setChecks] = useState<InventoryCheckRow[]>([]);
  const [adjusts, setAdjusts] = useState<AdjustHistoryRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 조정 (쓰기)
  const [itemCode, setItemCode] = useState('');
  const [lotNo, setLotNo] = useState('');
  const [differenceQty, setDifferenceQty] = useState('');
  const [locationCode, setLocationCode] = useState('');
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    if (!/^\d{6}$/.test(yyyymm)) {
      toast.error('마감월을 YYYYMM 여섯 자리로 넣으세요.');
      return;
    }
    setLoading(true);
    try {
      const params = {
        yyyymm,
        itemCode: itemCodeCond || undefined,
        lotNo: lotNoCond || undefined,
      };
      if (tab === 'check') {
        const r = await api.get('/inventory-query/check', { params });
        setChecks(r.data?.data ?? []);
        mark(r);
      } else {
        const r = await api.get('/inventory-query/check/adjust-history', { params });
        setAdjusts(r.data?.data ?? []);
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
  }, [tab, yyyymm, itemCodeCond, lotNoCond, mark]);

  useEffect(() => { void search(); }, [tab]); // eslint-disable-line react-hooks/exhaustive-deps

  /** 실사 목록에서 한 줄을 고르면 조정 폼을 그 줄로 채운다. */
  const pick = useCallback((row: InventoryCheckRow) => {
    setItemCode(row.itemCode ?? '');
    setLotNo(row.lotNo ?? '');
    setDifferenceQty(String(row.differenceQty ?? ''));
    setLocationCode(row.locationCode ?? '');
  }, []);

  const diff = Number(differenceQty);
  const blocker = !itemCode.trim()
    ? '품목코드를 넣으세요.'
    : !lotNo.trim()
      ? '롯트번호를 넣으세요.'
      : !(Number.isFinite(diff) && diff !== 0)
        ? '차이 수량이 0 이면 조정할 것이 없습니다.'
        : null;

  const submit = useCallback(async () => {
    setConfirmOpen(false);
    setBusy(true);
    try {
      const r = await api.post('/inventory-query/check/adjust', {
        yyyymm,
        itemCode: itemCode.trim(),
        lotNo: lotNo.trim(),
        differenceQty: diff,
        locationCode: locationCode.trim() || undefined,
      });
      const result = r.data?.data as { issueDeficit?: number } | undefined;
      toast.success(
        `조정했습니다 (${result?.issueDeficit === 3 ? '실제 많음' : '실제 적음'}`
        + ` ${Math.abs(diff).toLocaleString()}).`,
      );
      setDifferenceQty('');
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조정에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [yyyymm, itemCode, lotNo, diff, locationCode, search]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재재고조사</h1>
        <p className="mt-1 text-sm text-text-muted">
          실사 수량과 장부 수량의 차이만큼 재고를 조정합니다 ·{' '}
          {searched
            ? `${(tab === 'check' ? checks : adjusts).length.toLocaleString()}건`
            : '조회하세요'}
        </p>
      </header>

      {/* 조정 (쓰기) */}
      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <Scale className="h-4 w-4" />재고 조정
          </span>
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-44"
            onChange={(e) => setItemCode(e.target.value)} />
          <Input aria-label="롯트번호" placeholder="롯트번호" value={lotNo}
            className="w-40"
            onChange={(e) => setLotNo(e.target.value)} />
          <Input aria-label="차이 수량" placeholder="차이 (실사 − 장부)"
            value={differenceQty} className="w-40" inputMode="numeric"
            onChange={(e) => setDifferenceQty(e.target.value)} />
          <Input aria-label="창고코드" placeholder="창고코드 (선택)" value={locationCode}
            className="w-36"
            onChange={(e) => setLocationCode(e.target.value)} />
          {Number.isFinite(diff) && diff !== 0 && (
            <span className={`text-sm font-semibold ${diff > 0 ? 'text-emerald-500' : 'text-red-500'}`}>
              {diff > 0 ? '실제가 더 많음' : '실제가 적음'} {Math.abs(diff).toLocaleString()}
            </span>
          )}
          <Button size="sm" disabled={busy || Boolean(blocker)}
            onClick={() => setConfirmOpen(true)}>
            조정
          </Button>
          {blocker && (itemCode || differenceQty) && (
            <span className="flex items-center gap-1 text-sm text-amber-500">
              <AlertTriangle className="h-4 w-4" />{blocker}
            </span>
          )}
        </CardContent>
      </Card>

      <ScreenTabs
        tabs={[
          { key: 'check' as TabKey, label: '실사 목록', count: checks.length },
          { key: 'adjust' as TabKey, label: '조정 이력', count: adjusts.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="마감월" placeholder="마감월 (YYYYMM)" value={yyyymm}
            className="w-36" inputMode="numeric"
            onChange={(e) => setYyyymm(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="품목코드 조건" placeholder="품목코드" value={itemCodeCond}
            className="w-44"
            onChange={(e) => setItemCodeCond(e.target.value)} />
          {tab === 'check' && (
            <Input aria-label="롯트번호 조건" placeholder="롯트번호" value={lotNoCond}
              className="w-40"
              onChange={(e) => setLotNoCond(e.target.value)} />
          )}
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          {searched && (tab === 'check' ? checks : adjusts).length === 0 && (
            <span className="text-sm text-text-muted">
              비어 있습니다 — 이 현장은 재고조사를 아직 돌린 적이 없습니다.
            </span>
          )}
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'check' ? (
            <DataGrid
              data={checks}
              columns={inventoryCheckColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재재고조사"
              emptyMessage={searched ? '실사 자료가 없습니다.' : '조회하세요.'}
              onRowClick={(row) => pick(row as InventoryCheckRow)}
              rowClassName={(row) => (Number((row as InventoryCheckRow).differenceQty ?? 0) !== 0
                ? 'bg-amber-500/5'
                : '')}
            />
          ) : (
            <DataGrid
              data={adjusts}
              columns={adjustHistoryColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="재고조정이력"
              emptyMessage={searched ? '조정 이력이 없습니다.' : '조회하세요.'}
            />
          )}
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={submit}
        title="재고 조정"
        message={`${itemCode} 롯트 ${lotNo} 를`
          + ` ${diff > 0 ? '실제가 더 많은' : '실제가 적은'} 것으로`
          + ` ${Math.abs(diff).toLocaleString()} 조정합니다.`
          + ` ${yyyymm} 마지막 날짜로 원장에 들어갑니다. 되돌릴 수 없습니다`
          + ' (반대 부호로 한 번 더 조정해야 합니다).'}
        confirmText="조정"
      />
    </div>
  );
}
