"use client";

/**
 * @file src/app/(authenticated)/purchase/order-plan/page.tsx
 * @description 478 자재발주계획 — PB w_mat_purchase_order_plan_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **"언제 무엇을 얼마나 발주할지"를 계산해 내는 화면이다.** 생산·납품계획을
 *    BOM 으로 펴서 자재 소요량을 구하고, 거기서 **이미 있는 것을 빼면** 발주량이다.
 *    (재고를 빼지 않은 순소요는 477 자재소요량관리가 낸다.)
 * 2. **두 표를 위아래로 같이 본다.** 위가 결과(발주계획), 아래가 재고를 빼기 전의
 *    소요량이다. 발주량이 이상할 때 아래를 보면 소요량 자체가 문제인지, 재고 차감이
 *    문제인지 바로 갈린다. 발주계획이 열이 많아 넓어야 하므로 위아래로 놓았다.
 * 3. **순서가 있다.** ① 발주계획 생성 → ② 확인 → ③ 발주 확정.
 * 4. **무엇을 뺄지는 체크박스가 정한다.** 창고재고 · 발주잔량 · 도착분 · 공정재고 ·
 *    무상재고. 켠 것만 빠진다. 하나도 안 켜면 소요량이 그대로 발주량이 된다.
 *    PB 는 조합마다 SQL 을 따로 적어 두었고(실측 40개), 웹은 켠 가지만 이어 붙인다.
 * 5. **생성은 조직 단위로 갈아끼운다.** 돌릴 때마다 기존 발주계획이 통째로 새로
 *    만들어진다 — PB 와 같다.
 * 6. **확정해도 계획은 지워지지 않는다.** `PURCHASE_ORDER_STATUS` 가 `'Y'` 가 될
 *    뿐이다 — 어느 계획에서 나온 주문인지 되짚을 수 있어야 한다.
 * 7. 버튼·체크박스 설명은 `data-tooltip` 으로 붙였다 (전역 툴팁 시스템).
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Calculator, Play, Search, Send, Tag } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent, ConfirmModal, Input, Select } from '@/components/ui';
import api from '@/services/api';
import { getTodayLocal } from '@/utils/date';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { orderPlanColumns, requirementOrderColumns, selectColumn } from '../purchase-columns';
import type { OrderPlanRow, RequirementOrderRow } from '../purchase-columns';

/** PB 라디오버튼(계획 원천). 어느 계획에서 BOM 을 펼지. */
const PLAN_SOURCES = [
  { value: 'productionPlan', label: '생산계획' },
  { value: 'productionPlanByTime', label: '생산계획(시간별)' },
  { value: 'salePlan', label: '납품계획' },
  { value: 'salePlanByTime', label: '납품계획(시간별)' },
  { value: 'manual', label: '수기계획' },
];

const SOURCE_TIP: Record<string, string> = {
  productionPlan: '생산계획(IP_PRODUCT_MI_PLAN)에서 아직 못 만든 수량(계획 − 실적)만 펼칩니다.',
  productionPlanByTime: '생산계획을 같은 날 안에서도 시:분 단위로 나눠 봅니다.'
    + ' 하루에 여러 번 투입하는 라인에 씁니다.',
  salePlan: '납품계획에서 아직 안 보낸 수량을 펼칩니다. 지시번호로 잡힌 실적까지 뺍니다.',
  salePlanByTime: '납품계획을 시:분:초 단위로 나눠 봅니다.',
  manual: '손으로 넣어 둔 발주 기준계획(IM_ITEM_MASTER_PLAN_4_PO)을 펼칩니다.',
};

/** PB 체크박스(소요량에서 뺄 재고). 켠 것만 빠진다. */
const INVENTORY_ARMS = [
  {
    value: 'inventory',
    label: '창고재고',
    tip: '자재창고(M01)에 지금 있는 재고를 뺍니다. 가장 기본입니다.',
  },
  {
    value: 'order',
    label: '발주잔량',
    tip: '이미 발주했지만 아직 안 들어온 수량을 뺍니다. 안 켜면 같은 자재를 두 번 발주하게 됩니다.',
  },
  {
    value: 'arrival',
    label: '도착분',
    tip: '협력사에서 도착했지만 아직 입고 처리가 안 된 수량을 뺍니다.',
  },
  {
    value: 'workstageInventory',
    label: '공정재고',
    tip: '라인·공정에 이미 깔려 있는 재고를 뺍니다.'
      + ' 이 표에는 거래유형 컬럼이 없어 품목 기준정보에서 가져옵니다.',
  },
  {
    value: 'freeInventory',
    label: '무상재고',
    tip: '무상으로 받아 둔 재고를 뺍니다.',
  },
];

const TIP = {
  source: '어느 계획에서 BOM 을 펼지 고릅니다. 고르면 옆에 설명이 바뀝니다.',
  range: '이 기간에 든 계획만 펼칩니다.',
  orderDate: '만들어지는 발주계획에 찍히는 발주일입니다. 실제 주문으로 넘길 때도 이 날짜를 씁니다.',
  itemCode: '특정 품목만 봅니다. 비우면 전부입니다. 생성할 때도 이 조건이 걸립니다.',
  orderRule: '협력사별 최소주문량·포장단위·불량율을 발주량에 반영합니다.'
    + ' 예: 포장단위가 100이고 계산값이 120이면 200으로 올립니다.'
    + ' 올려서 남는 만큼은 같은 자재의 뒤 계획줄이 덜 발주하도록 되돌립니다.',
  unitPrice: '단가 기준정보에서 유효기간 안의 단가·통화·납품구분을 붙입니다.',
  leadTime: '제조 리드타임만큼 납기를 앞으로 당깁니다 — 자재가 생산 시작 전에 들어와야'
    + ' 하기 때문입니다. 안 켜면 자재가 필요한 날이 곧 납기가 됩니다.',
  calendar: '당긴 납기가 휴무일이면 일하는 날로 옮깁니다. 리드타임 반영과는 별개 단계입니다.',
  generate: '고른 계획을 BOM 으로 펴고, 켜 둔 재고를 빼서 발주계획을 만듭니다.'
    + ' 기존 발주계획은 통째로 새로 만들어집니다.',
  search: '두 표를 다시 읽어옵니다.',
  pendingOnly: '발주할 수량이 남아 있고 아직 확정하지 않은 계획만 봅니다.'
    + ' 재고로 다 충당된 것과 이미 확정한 것은 숨깁니다.',
  priceReset: '단가만 다시 붙입니다. 발주량은 그대로 두고 단가 기준정보가 바뀐 것을 반영할 때 씁니다.',
  purchase: '고른 계획을 실제 주문으로 넘깁니다. 계획은 지워지지 않고 확정 표시만 남아,'
    + ' 어느 계획에서 나온 주문인지 되짚을 수 있습니다. 한 번의 확정이 한 발주그룹입니다.',
  gridPlan: '계산이 끝난 발주계획입니다. 줄을 눌러 고른 뒤 발주 확정으로 넘깁니다.',
  gridRequirement: '재고를 빼기 전의 소요량입니다. 발주량이 이상하면 여기를 먼저 봅니다 —'
    + ' 소요량 자체가 문제인지, 재고 차감이 문제인지 갈립니다.',
} as const;

const today = () => getTodayLocal();
const daysFromNow = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() + n);
  return getTodayLocal(d);
};
const rowKey = (row: OrderPlanRow) => `${row.itemCode ?? ''}|${row.lineType ?? ''}`;
/** 발주할 수량이 남은 계획만 고를 수 있다. 재고로 다 충당된 줄은 넘길 것이 없다. */
const isPurchasable = (row: OrderPlanRow) => Number(row.purchaseOrderQty ?? 0) > 0;
const apiMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

export default function OrderPlanPage() {
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
  const [applyCalendar, setApplyCalendar] = useState(true);

  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [pending, setPending] = useState<'generate' | 'purchase' | 'price' | null>(null);
  const [busy, setBusy] = useState(false);

  const toggleRow = useCallback((plan: OrderPlanRow) => {
    if (!isPurchasable(plan)) {
      toast.error('발주할 수량이 없는 계획입니다 (재고로 다 충당됨).');
      return;
    }
    const key = rowKey(plan);
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(key)) next.delete(key); else next.add(key);
      return next;
    });
  }, []);

  const selectableKeys = useMemo(
    () => [...new Set(plans.filter(isPurchasable).map(rowKey))],
    [plans],
  );
  const allSelected = selectableKeys.length > 0
    && selectableKeys.every((key) => selected.has(key));
  const planColumns = useMemo(() => [
    selectColumn<OrderPlanRow>({
      isSelected: (row) => selected.has(rowKey(row)),
      onToggle: toggleRow,
      isSelectable: isPurchasable,
      allSelected,
      onToggleAll: () => setSelected(allSelected ? new Set() : new Set(selectableKeys)),
    }),
    ...orderPlanColumns,
  ], [selected, toggleRow, allSelected, selectableKeys]);

  /** 두 표를 한 번에 읽는다. 결과(발주계획)와 그 전 단계(소요량)를 같이 보는 화면이다. */
  const search = useCallback(async () => {
    setLoading(true);
    try {
      const [plan, requirement] = await Promise.all([
        api.get('/purchase/order-plan', {
          params: {
            supplierCode: supplierCond || undefined,
            itemCode: itemCond.trim() || undefined,
            lineType: lineTypeCond || undefined,
            pendingOnly: pendingOnly || undefined,
          },
        }),
        api.get('/purchase/order-plan/requirements'),
      ]);
      setPlans(plan.data?.data ?? []);
      setRequirements(requirement.data?.data ?? []);
      setSelected(new Set());
      mark(plan);
      setSearched(true);
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [supplierCond, itemCond, lineTypeCond, pendingOnly, mark]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

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
          applyCalendar,
        });
        const d = r.data?.data ?? {};
        toast.success(
          `발주계획을 만들었습니다 — 소요량 ${d.requirementRows ?? 0}건 → 계획 ${d.planRows ?? 0}건.`,
        );
      } else if (pending === 'price') {
        const r = await api.post('/purchase/order-plan/price-reset', {
          supplierCode: supplierCond || undefined,
        });
        toast.success(`단가를 다시 붙였습니다 (${r.data?.data?.updated ?? 0}건).`);
      } else {
        const itemCodes = plans
          .filter((row) => selected.has(rowKey(row)))
          .map((row) => ({ itemCode: row.itemCode, lineType: row.lineType }));
        const r = await api.post('/purchase/order-plan/purchase', { orderDate, itemCodes });
        const created = r.data?.data?.created ?? 0;
        const skipped = r.data?.data?.skipped ?? 0;
        toast.success(`${created}건을 주문으로 넘겼습니다.`);
        // 납품구분이 안 붙은 계획은 단가·통화도 비어 있어 주문이 될 수 없다.
        if (skipped > 0) {
          toast.error(
            `${skipped}건은 넘어가지 못했습니다 — 납품구분이 비어 있습니다.`
            + ' 단가 재설정을 먼저 실행해 보세요.',
          );
        }
      }
      setPending(null);
      await search();
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [pending, source, dateFrom, dateTo, orderDate, itemCond, arms, applyOrderRule,
    applyUnitPrice, applyLeadTime, applyCalendar, supplierCond, plans, selected, search]);

  const sourceLabel = PLAN_SOURCES.find((s) => s.value === source)?.label ?? '';
  const armLabels = INVENTORY_ARMS
    .filter((a) => arms.includes(a.value))
    .map((a) => a.label);

  const confirmText = {
    generate: {
      title: '발주계획 생성',
      message: `${sourceLabel} ${dateFrom} ~ ${dateTo} 를 BOM 으로 펴서 발주계획을 만듭니다.`
        + `\n\n· 소요량에서 빼는 것: ${armLabels.length === 0 ? '없음 (소요량이 그대로 발주량이 됩니다)' : armLabels.join(' · ')}`
        + '\n· 기존 발주계획은 통째로 새로 만들어집니다.',
    },
    price: {
      title: '단가 재설정',
      message: '단가 기준정보에서 납품구분·단가·통화를 다시 붙입니다 (유효기간 안의 단가만).'
        + '\n\n· 발주량은 바뀌지 않습니다.',
    },
    purchase: {
      title: '발주 확정',
      message: `고른 ${selected.size}건을 실제 주문으로 넘깁니다.`
        + `\n\n· 발주일: ${orderDate}`
        + '\n· 계획은 지워지지 않고 확정 표시만 남습니다 (두 번 발주되지 않게).'
        + '\n· 납품구분이 빈 계획은 넘어가지 않습니다.',
    },
  }[pending ?? 'generate'];

  const count = (n: number) => (searched ? `${n.toLocaleString()}건` : '');

  return (
    <div className="flex h-full flex-col gap-3 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재발주계획</h1>
        <p className="mt-1 text-sm text-text-muted">
          생산·납품계획에서 자재 발주량을 산출합니다 (소요량 − 보유분) ·{' '}
          <span className="text-text">① 발주계획 생성 → ② 확인 → ③ 발주 확정</span>
        </p>
      </header>

      {/* ① 생성 — 무엇을 펼지 */}
      <Card padding="none">
        <CardContent className="flex flex-col gap-3 p-3">
          <div className="flex flex-wrap items-end gap-3">
            <span className="flex items-center gap-1 self-center text-sm font-semibold text-text">
              <Calculator className="h-4 w-4" />① 발주계획 생성
            </span>
            <div className="flex flex-col gap-1">
              <label className="text-xs text-text-muted" htmlFor="plan-source"
                data-tooltip={TIP.source}>
                계획 원천
              </label>
              <Select id="plan-source" aria-label="계획 원천" value={source} className="w-48"
                data-tooltip={SOURCE_TIP[source]}
                onChange={setSource} options={PLAN_SOURCES} />
            </div>
            <span className="self-center" data-tooltip={TIP.range}>
              <DateRangeFilter label="계획기간" from={dateFrom} to={dateTo}
                onFromChange={setDateFrom} onToChange={setDateTo} />
            </span>
            <div className="flex flex-col gap-1">
              <label className="text-xs text-text-muted" htmlFor="order-date"
                data-tooltip={TIP.orderDate}>
                발주일
              </label>
              <Input id="order-date" type="date" value={orderDate} className="w-40"
                data-tooltip={TIP.orderDate}
                onChange={(e) => setOrderDate(e.target.value)} />
            </div>
            <span className="self-center text-sm text-text-muted">
              {SOURCE_TIP[source]}
            </span>
          </div>

          {/* 무엇을 뺄지 — 이 다섯이 발주량을 정한다 */}
          <div className="flex flex-wrap items-center gap-3 rounded border border-border bg-surface/40 p-2">
            <span className="text-sm font-semibold text-text">소요량에서 뺄 재고</span>
            {INVENTORY_ARMS.map((arm) => (
              <label key={arm.value} data-tooltip={arm.tip}
                className="flex items-center gap-1 text-sm text-text">
                <input type="checkbox" checked={arms.includes(arm.value)}
                  onChange={() => toggleArm(arm.value)} />
                {arm.label}
              </label>
            ))}
            {arms.length === 0 && (
              <span className="text-sm text-amber-500">
                하나도 안 켜면 소요량이 그대로 발주량이 됩니다
              </span>
            )}
          </div>

          {/* 계산 옵션 — 수량·단가·납기를 손보는 것들 */}
          <div className="flex flex-wrap items-center gap-3">
            <span className="text-sm font-semibold text-text">계산 옵션</span>
            <label data-tooltip={TIP.orderRule}
              className="flex items-center gap-1 text-sm text-text">
              <input type="checkbox" checked={applyOrderRule}
                onChange={(e) => setApplyOrderRule(e.target.checked)} />
              발주속성 (최소·포장·불량율)
            </label>
            <label data-tooltip={TIP.unitPrice}
              className="flex items-center gap-1 text-sm text-text">
              <input type="checkbox" checked={applyUnitPrice}
                onChange={(e) => setApplyUnitPrice(e.target.checked)} />
              단가 적용
            </label>
            <label data-tooltip={TIP.leadTime}
              className="flex items-center gap-1 text-sm text-text">
              <input type="checkbox" checked={applyLeadTime}
                onChange={(e) => setApplyLeadTime(e.target.checked)} />
              리드타임 반영
            </label>
            <label data-tooltip={TIP.calendar}
              className="flex items-center gap-1 text-sm text-text">
              <input type="checkbox" checked={applyCalendar}
                onChange={(e) => setApplyCalendar(e.target.checked)} />
              작업일 보정
            </label>
            <Button size="sm" className="ml-auto" disabled={busy}
              data-tooltip={TIP.generate}
              onClick={() => setPending('generate')}>
              <Play className="mr-1 h-4 w-4" />발주계획 생성
            </Button>
          </div>
        </CardContent>
      </Card>

      {/* ② 확인 + ③ 실행 — 두 표를 같이 보므로 한 줄로 합쳐 세로 공간을 아낀다 */}
      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="text-sm font-semibold text-text">② 확인</span>
          <SupplierSelect aria-label="협력사" includeAll labelPrefix="협력사"
            value={supplierCond} className="w-44" onChange={setSupplierCond} />
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCond}
            className="w-36" data-tooltip={TIP.itemCode}
            onChange={(e) => setItemCond(e.target.value)} />
          <ComCodeSelect groupCode="LINE TYPE" labelPrefix="거래유형"
            aria-label="거래유형" value={lineTypeCond} className="w-36"
            onChange={setLineTypeCond} />
          <label data-tooltip={TIP.pendingOnly}
            className="flex items-center gap-1 text-sm text-text">
            <input type="checkbox" checked={pendingOnly}
              onChange={(e) => setPendingOnly(e.target.checked)} />
            발주할 것만
          </label>
          <Button size="sm" variant="secondary" data-tooltip={TIP.search}
            onClick={() => search()} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>

          <span className="mx-2 h-4 w-px bg-border" />
          <span className="text-sm font-semibold text-text">③ 실행</span>
          <Button size="sm" variant="secondary" disabled={busy || plans.length === 0}
            data-tooltip={TIP.priceReset}
            onClick={() => setPending('price')}>
            <Tag className="mr-1 h-4 w-4" />단가 재설정
          </Button>
          <span className="ml-auto flex items-center gap-3">
            <span className="text-sm text-text-muted">
              위 표에서 줄을 누르면 골라집니다
            </span>
            <Button size="sm" disabled={busy || selected.size === 0}
              data-tooltip={TIP.purchase}
              onClick={() => setPending('purchase')}>
              <Send className="mr-1 h-4 w-4" />발주 확정 ({selected.size})
            </Button>
          </span>
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      {/* 위: 결과(발주계획, 열이 많아 넓게) / 아래: 재고 차감 전 소요량 */}
      <div className="flex min-h-0 flex-1 flex-col gap-3">
        <Card className="min-h-0 flex-[3] overflow-hidden" padding="none">
          <CardContent className="flex h-full flex-col gap-2 p-3">
            <span className="text-sm font-semibold text-text" data-tooltip={TIP.gridPlan}>
              ② 발주계획 {count(plans.length)}
              <span className="ml-2 text-xs font-normal text-text-muted">
                맨 앞 체크박스나 줄을 누르면 골라집니다
              </span>
            </span>
            <div className="min-h-0 flex-1">
              <DataGrid
                data={plans}
                columns={planColumns}
                isLoading={loading}
                pageSize={100}
                enableColumnFilter
                enableExport
                exportFileName="발주계획"
                emptyMessage={searched
                  ? '발주계획이 없습니다. 위 ① 에서 생성하세요.'
                  : '조회하세요.'}
                onRowClick={(row) => toggleRow(row as OrderPlanRow)}
                rowClassName={(row) => (selected.has(rowKey(row as OrderPlanRow))
                  ? 'bg-primary/15' : '')}
              />
            </div>
          </CardContent>
        </Card>

        <Card className="min-h-0 flex-[2] overflow-hidden" padding="none">
          <CardContent className="flex h-full flex-col gap-2 p-3">
            <span className="text-sm font-semibold text-text"
              data-tooltip={TIP.gridRequirement}>
              소요량 (재고 차감 전) {count(requirements.length)}
              <span className="ml-2 text-xs font-normal text-text-muted">
                발주량이 이상하면 여기를 먼저 봅니다
              </span>
            </span>
            <div className="min-h-0 flex-1">
              <DataGrid
                data={requirements}
                columns={requirementOrderColumns}
                isLoading={loading}
                pageSize={100}
                enableColumnFilter
                enableExport
                exportFileName="발주소요량"
                emptyMessage={searched
                  ? '소요량이 없습니다. 위 ① 에서 발주계획을 생성하세요.'
                  : '조회하세요.'}
              />
            </div>
          </CardContent>
        </Card>
      </div>

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
