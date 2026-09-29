"use client";

/**
 * @file src/app/(authenticated)/purchase/order-plan/page.tsx
 * @description 478 자재발주계획 — PB w_mat_purchase_order_plan_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **"언제 무엇을 얼마나 발주할지"를 계산해 내는 화면이다.** 생산·납품계획을
 *    BOM 으로 펴서 자재 소요량을 구하고, 거기서 **이미 있는 것을 빼면** 발주량이다.
 * 2. **무엇을 뺄지는 아래 체크박스가 정한다.** 창고재고 · 발주잔량 · 도착분 ·
 *    공정재고 · 무상재고. 켠 것만 빠진다. 하나도 안 켜면 소요량이 그대로 발주량이 된다.
 * 3. **생성은 조직 단위로 갈아끼운다.** 돌릴 때마다 기존 발주계획이 통째로 새로
 *    만들어진다 — PB 와 같다.
 * 4. **확정하면 계획이 실제 주문이 되고 계획에서는 사라진다.** 두 번 발주되지
 *    않게 하려는 것이다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Calculator, Play, Search, Tag } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ScreenTabs from '@/components/shared/ScreenTabs';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent, ConfirmModal, Input, Select } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { orderPlanColumns, requirementOrderColumns } from '../purchase-columns';
import type { OrderPlanRow, RequirementOrderRow } from '../purchase-columns';

type Tab = 'plan' | 'requirement';

/** PB 라디오버튼(계획 원천). */
const PLAN_SOURCES = [
  { value: 'productionPlan', label: '생산계획' },
  { value: 'productionPlanByTime', label: '생산계획(시간별)' },
  { value: 'salePlan', label: '납품계획' },
  { value: 'salePlanByTime', label: '납품계획(시간별)' },
  { value: 'manual', label: '수기계획' },
];

/** PB 체크박스(소요량에서 뺄 재고). 켠 것만 빠진다. */
const INVENTORY_ARMS = [
  { value: 'inventory', label: '창고재고' },
  { value: 'order', label: '발주잔량' },
  { value: 'arrival', label: '도착분' },
  { value: 'workstageInventory', label: '공정재고' },
  { value: 'freeInventory', label: '무상재고' },
];

const today = () => new Date().toISOString().slice(0, 10);
const daysFromNow = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() + n);
  return d.toISOString().slice(0, 10);
};
const apiMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

export default function OrderPlanPage() {
  const [tab, setTab] = useState<Tab>('plan');
  const [plans, setPlans] = useState<OrderPlanRow[]>([]);
  const [requirements, setRequirements] = useState<RequirementOrderRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 조회 조건
  const [supplierCond, setSupplierCond] = useState('');
  const [itemCond, setItemCond] = useState('');
  const [lineTypeCond, setLineTypeCond] = useState('');
  const [pendingOnly, setPendingOnly] = useState(true);

  // 생성 조건
  const [source, setSource] = useState('productionPlan');
  const [dateFrom, setDateFrom] = useState(today());
  const [dateTo, setDateTo] = useState(daysFromNow(30));
  const [orderDate, setOrderDate] = useState(today());
  const [arms, setArms] = useState<string[]>(['inventory', 'order', 'arrival']);
  const [applyOrderRule, setApplyOrderRule] = useState(true);
  const [applyUnitPrice, setApplyUnitPrice] = useState(true);
  const [applyLeadTime, setApplyLeadTime] = useState(true);

  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [pending, setPending] = useState<'generate' | 'purchase' | 'price' | null>(null);
  const [busy, setBusy] = useState(false);

  const rowKey = (row: OrderPlanRow) => `${row.itemCode ?? ''}|${row.lineType ?? ''}`;

  const search = useCallback(async (nextTab: Tab = tab) => {
    setLoading(true);
    try {
      if (nextTab === 'plan') {
        const r = await api.get('/purchase/order-plan', {
          params: {
            supplierCode: supplierCond || undefined,
            itemCode: itemCond.trim() || undefined,
            lineType: lineTypeCond || undefined,
            pendingOnly: pendingOnly || undefined,
          },
        });
        setPlans(r.data?.data ?? []);
        setSelected(new Set());
        mark(r);
      } else {
        const r = await api.get('/purchase/order-plan/requirements');
        setRequirements(r.data?.data ?? []);
        mark(r);
      }
      setSearched(true);
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [tab, supplierCond, itemCond, lineTypeCond, pendingOnly, mark]);

  useEffect(() => { void search('plan'); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const changeTab = useCallback((nextTab: Tab) => {
    setTab(nextTab);
    setSearched(false);
    setSelected(new Set());
    void search(nextTab);
  }, [search]);

  const toggleArm = useCallback((value: string) => {
    setArms((prev) => (prev.includes(value)
      ? prev.filter((v) => v !== value)
      : [...prev, value]));
  }, []);

  const run = useCallback(async () => {
    if (!pending) return;
    setBusy(true);
    try {
      if (pending === 'generate') {
        const r = await api.post('/purchase/order-plan/generate', {
          source,
          dateFrom,
          dateTo,
          orderDate,
          itemCode: itemCond.trim() || undefined,
          inventorySources: arms,
          applyOrderRule,
          applyUnitPrice,
          applyLeadTime,
        });
        const d = r.data?.data ?? {};
        toast.success(
          `발주계획을 만들었습니다 — 소요량 ${d.requirementRows ?? 0}건 → 계획 ${d.planRows ?? 0}건.`,
        );
        await search('plan');
      } else if (pending === 'price') {
        const r = await api.post('/purchase/order-plan/price-reset', {
          supplierCode: supplierCond || undefined,
        });
        toast.success(`단가를 다시 붙였습니다 (${r.data?.data?.updated ?? 0}건).`);
        await search('plan');
      } else {
        const itemCodes = plans
          .filter((row) => selected.has(rowKey(row)))
          .map((row) => ({ itemCode: row.itemCode, lineType: row.lineType }));
        const r = await api.post('/purchase/order-plan/purchase', { orderDate, itemCodes });
        toast.success(`${r.data?.data?.created ?? 0}건을 주문으로 넘겼습니다.`);
        await search('plan');
      }
      setPending(null);
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [pending, source, dateFrom, dateTo, orderDate, itemCond, arms, applyOrderRule,
    applyUnitPrice, applyLeadTime, supplierCond, plans, selected, search]);

  const confirmText = {
    generate: {
      title: '발주계획 생성',
      message: `${PLAN_SOURCES.find((s) => s.value === source)?.label} ${dateFrom} ~ ${dateTo} 를`
        + ' BOM 으로 펴서 발주계획을 만듭니다.'
        + ` 소요량에서 ${arms.length === 0 ? '아무것도 빼지 않습니다' : `${arms.length}가지 재고를 뺍니다`}.`
        + ' **기존 발주계획은 통째로 새로 만들어집니다.**',
    },
    price: {
      title: '단가 재설정',
      message: '단가 기준정보에서 납품구분·단가·통화를 다시 붙입니다 (유효기간 안의 단가만).',
    },
    purchase: {
      title: '발주 확정',
      message: `고른 ${selected.size}건을 실제 주문으로 넘깁니다.`
        + ' 넘어간 계획은 발주계획에서 사라집니다.',
    },
  }[pending ?? 'generate'];

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재발주계획</h1>
        <p className="mt-1 text-sm text-text-muted">
          생산·납품계획에서 자재 발주량을 산출합니다 (소요량 − 보유분) ·{' '}
          {searched
            ? `${(tab === 'plan' ? plans.length : requirements.length).toLocaleString()}건`
            : '조회하세요'}
        </p>
      </header>

      <ScreenTabs<Tab>
        active={tab}
        onChange={changeTab}
        tabs={[
          { key: 'plan', label: '발주계획' },
          { key: 'requirement', label: '소요량' },
        ]}
      />

      {/* 발주계획 생성 (쓰기) */}
      <Card padding="none">
        <CardContent className="flex flex-col gap-3 p-3">
          <div className="flex flex-wrap items-center gap-3">
            <span className="flex items-center gap-1 text-sm font-semibold text-text">
              <Calculator className="h-4 w-4" />계획 원천
            </span>
            <Select aria-label="계획 원천" value={source} className="w-48"
              onChange={setSource} options={PLAN_SOURCES} />
            <DateRangeFilter label="계획기간" from={dateFrom} to={dateTo}
              onFromChange={setDateFrom} onToChange={setDateTo} />
            <label className="text-sm text-text" htmlFor="order-date">발주일</label>
            <Input id="order-date" type="date" value={orderDate}
              className="w-40" onChange={(e) => setOrderDate(e.target.value)} />
          </div>

          <div className="flex flex-wrap items-center gap-3">
            <span className="text-sm font-semibold text-text">소요량에서 뺄 재고</span>
            {INVENTORY_ARMS.map((arm) => (
              <label key={arm.value} className="flex items-center gap-1 text-sm text-text">
                <input type="checkbox" checked={arms.includes(arm.value)}
                  onChange={() => toggleArm(arm.value)} />
                {arm.label}
              </label>
            ))}
            <span className="ml-4 h-4 w-px bg-border" />
            <label className="flex items-center gap-1 text-sm text-text">
              <input type="checkbox" checked={applyOrderRule}
                onChange={(e) => setApplyOrderRule(e.target.checked)} />
              발주속성(최소·포장·불량율)
            </label>
            <label className="flex items-center gap-1 text-sm text-text">
              <input type="checkbox" checked={applyUnitPrice}
                onChange={(e) => setApplyUnitPrice(e.target.checked)} />
              단가 적용
            </label>
            <label className="flex items-center gap-1 text-sm text-text">
              <input type="checkbox" checked={applyLeadTime}
                onChange={(e) => setApplyLeadTime(e.target.checked)} />
              리드타임 반영
            </label>
            <Button size="sm" className="ml-auto" disabled={busy}
              onClick={() => setPending('generate')}>
              <Play className="mr-1 h-4 w-4" />발주계획 생성
            </Button>
          </div>
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <SupplierSelect aria-label="협력사" includeAll labelPrefix="협력사"
            value={supplierCond} className="w-48" onChange={setSupplierCond} />
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCond}
            className="w-40" onChange={(e) => setItemCond(e.target.value)} />
          <ComCodeSelect groupCode="LINE TYPE" labelPrefix="거래유형"
            aria-label="거래유형" value={lineTypeCond} className="w-40"
            onChange={setLineTypeCond} />
          {tab === 'plan' && (
            <label className="flex items-center gap-1 text-sm text-text">
              <input type="checkbox" checked={pendingOnly}
                onChange={(e) => setPendingOnly(e.target.checked)} />
              발주할 것만
            </label>
          )}
          <Button size="sm" onClick={() => search()} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          {tab === 'plan' && (
            <span className="ml-auto flex items-center gap-3">
              <Button size="sm" variant="secondary" disabled={busy || plans.length === 0}
                onClick={() => setPending('price')}>
                <Tag className="mr-1 h-4 w-4" />단가 재설정
              </Button>
              <Button size="sm" disabled={busy || selected.size === 0}
                onClick={() => setPending('purchase')}>
                발주 확정 ({selected.size})
              </Button>
            </span>
          )}
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'plan' ? (
            <DataGrid
              data={plans}
              columns={orderPlanColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="발주계획"
              emptyMessage={searched ? '발주계획이 없습니다. 위에서 생성하세요.' : '조회하세요.'}
              onRowClick={(row) => {
                const plan = row as OrderPlanRow;
                if (Number(plan.purchaseOrderQty ?? 0) <= 0) {
                  toast.error('발주할 수량이 없는 계획입니다.');
                  return;
                }
                const key = rowKey(plan);
                setSelected((prev) => {
                  const next = new Set(prev);
                  if (next.has(key)) next.delete(key); else next.add(key);
                  return next;
                });
              }}
              rowClassName={(row) => (selected.has(rowKey(row as OrderPlanRow))
                ? 'bg-primary/10' : '')}
            />
          ) : (
            <DataGrid
              data={requirements}
              columns={requirementOrderColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="발주소요량"
              emptyMessage={searched ? '소요량이 없습니다. 발주계획을 생성하세요.' : '조회하세요.'}
            />
          )}
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={Boolean(pending)}
        onClose={() => setPending(null)}
        onConfirm={run}
        title={confirmText.title}
        message={confirmText.message}
        confirmText={confirmText.title}
      />
    </div>
  );
}
