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
 * 8. **생성 옵션은 우측 패널에서 고른다** (components/OrderPlanGeneratePanel).
 *    화면 위에는 조회 조건과 실행 버튼만 두어 두 표가 넓게 보이게 했다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Play, Search, Send, Tag } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent, ConfirmModal } from '@/components/ui';
import api from '@/services/api';
import { getTodayLocal } from '@/utils/date';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { orderPlanColumns, requirementOrderColumns, selectColumn } from '../purchase-columns';
import type { OrderPlanRow, RequirementOrderRow } from '../purchase-columns';
import OrderPlanGeneratePanel, {
  INVENTORY_ARMS,
  PLAN_SOURCES,
  type OrderPlanGenerateValues,
} from './components/OrderPlanGeneratePanel';
import OrderPlanPreviewModal from './components/OrderPlanPreviewModal';
import PartSearchField from '@/components/shared/PartSearchField';
import { notifySkippedBom } from '../skipped-bom';

// 생성 옵션(계획 원천·뺄 재고·계산 옵션)과 그 설명은 우측 생성 패널(components/OrderPlanGeneratePanel)에 있다.
const TIP = {
  itemCode: '특정 품목만 봅니다. 비우면 전부입니다. 생성할 때도 이 조건이 걸립니다.',
  openGenerate: '계획 원천·기간·뺄 재고·계산 옵션을 오른쪽 패널에서 고르고 발주계획을 만듭니다.',
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

  // 생성 조건 — 우측 생성 패널에서 고른다 (기본값은 PB 화면을 열었을 때와 같다)
  const [generateOpen, setGenerateOpen] = useState(false);
  const [previewOpen, setPreviewOpen] = useState(false);
  const [gen, setGen] = useState<OrderPlanGenerateValues>(() => ({
    source: 'productionPlan',
    dateFrom: today(),
    dateTo: daysFromNow(3),
    orderDate: today(),
    arms: ['inventory'],
    applyOrderRule: true,
    distinctMfs: true,
    roundQty: true,
    applyLeadTime: false,
    applyCalendar: false,
  }));
  // 미리보기와 생성이 같은 본문을 쓴다 — 미리 본 계산이 그대로 저장된다.
  const genBody = useMemo(() => ({
    source: gen.source,
    dateFrom: gen.dateFrom,
    dateTo: gen.dateTo,
    orderDate: gen.orderDate,
    itemCode: itemCond.trim() || undefined,
    inventorySources: gen.arms,
    applyOrderRule: gen.applyOrderRule,
    distinctMfs: gen.distinctMfs,
    roundQty: gen.roundQty,
    applyLeadTime: gen.applyLeadTime,
    applyCalendar: gen.applyCalendar,
  }), [gen, itemCond]);
  const patchGen = useCallback(
    (patch: Partial<OrderPlanGenerateValues>) => setGen((prev) => ({ ...prev, ...patch })),
    [],
  );

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

  const run = useCallback(async () => {
    if (!pending) return;
    setBusy(true);
    try {
      if (pending === 'generate') {
        const r = await api.post('/purchase/order-plan/generate', genBody, { timeout: 180_000 });
        const d = r.data?.data ?? {};
        toast.success(
          `발주계획을 만들었습니다 — 소요량 ${d.requirementRows ?? 0}건 → 계획 ${d.planRows ?? 0}건.`,
        );
        notifySkippedBom(d.skippedItems);
        setGenerateOpen(false);
      } else if (pending === 'price') {
        const r = await api.post('/purchase/order-plan/price-reset', {
          supplierCode: supplierCond || undefined,
        });
        toast.success(`단가를 다시 붙였습니다 (${r.data?.data?.updated ?? 0}건).`);
      } else {
        const itemCodes = plans
          .filter((row) => selected.has(rowKey(row)))
          .map((row) => ({ itemCode: row.itemCode, lineType: row.lineType }));
        const r = await api.post('/purchase/order-plan/purchase', { orderDate: gen.orderDate, itemCodes });
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
  }, [pending, gen, itemCond, supplierCond, plans, selected, search]);

  const sourceLabel = PLAN_SOURCES.find((s) => s.value === gen.source)?.label ?? '';
  const armLabels = INVENTORY_ARMS
    .filter((a) => gen.arms.includes(a.value))
    .map((a) => a.label);

  const confirmText = {
    generate: {
      title: '발주계획 생성',
      message: `${sourceLabel} ${gen.dateFrom} ~ ${gen.dateTo} 를 BOM 으로 펴서 발주계획을 만듭니다.`
        + `\n\n· 소요량에서 빼는 것: ${armLabels.length === 0 ? '없음 (소요량이 그대로 발주량이 됩니다)' : armLabels.join(' · ')}`
        + '\n· 기존 발주계획은 통째로 새로 만들어집니다.'
        + '\n· 단가 기준정보가 없는 계획은 상태 P 로 남아 확정되지 않습니다.',
    },
    price: {
      title: '단가 재설정',
      message: '단가 기준정보에서 납품구분·단가·통화를 다시 붙입니다 (유효기간 안의 단가만).'
        + '\n\n· 발주량은 바뀌지 않습니다.',
    },
    purchase: {
      title: '발주 확정',
      message: `고른 ${selected.size}건을 실제 주문으로 넘깁니다.`
        + `\n\n· 발주일: ${gen.orderDate}`
        + '\n· 계획은 지워지지 않고 확정 표시만 남습니다 (두 번 발주되지 않게).'
        + '\n· 단가 기준정보가 없는 계획(상태 P)은 넘어가지 않습니다.',
    },
  }[pending ?? 'generate'];

  const count = (n: number) => (searched ? `${n.toLocaleString()}건` : '');

  return (
    <div className="flex h-full">
    <main className="flex h-full min-w-0 flex-1 flex-col gap-3 p-6">
      <header className="flex items-start justify-between gap-3">
        <div>
          <h1 className="text-xl font-bold text-text">자재발주계획</h1>
          <p className="mt-1 text-sm text-text-muted">
            생산·납품계획에서 자재 발주량을 산출합니다 (소요량 − 보유분) ·{' '}
            <span className="text-text">① 발주계획 생성 → ② 확인 → ③ 발주 확정</span>
          </p>
        </div>
        {/* ① 생성 옵션은 우측 패널에서 고른다 */}
        <Button size="sm" disabled={busy} data-tooltip={TIP.openGenerate}
          onClick={() => setGenerateOpen(true)}>
          <Play className="mr-1 h-4 w-4" />① 발주계획 생성
        </Button>
      </header>

      {/* ② 확인 + ③ 실행 — 두 표를 같이 보므로 한 줄로 합쳐 세로 공간을 아낀다 */}
      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="text-sm font-semibold text-text">② 확인</span>
          <SupplierSelect aria-label="협력사" includeAll labelPrefix="협력사"
            value={supplierCond} className="w-44" onChange={setSupplierCond} />
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCond}
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
                  ? '발주계획이 없습니다. 오른쪽 위 ① 발주계획 생성으로 만드세요.'
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
                  ? '소요량이 없습니다. 오른쪽 위 ① 발주계획 생성으로 만드세요.'
                  : '조회하세요.'}
              />
            </div>
          </CardContent>
        </Card>
      </div>
    </main>

      {generateOpen && (
        <OrderPlanGeneratePanel
          values={gen}
          onChange={patchGen}
          itemCode={itemCond}
          busy={busy}
          onGenerate={() => setPending('generate')}
          onPreview={() => setPreviewOpen(true)}
          onClose={() => setGenerateOpen(false)}
        />
      )}

      <OrderPlanPreviewModal
        isOpen={previewOpen}
        onClose={() => setPreviewOpen(false)}
        body={genBody}
        onGenerate={() => { setPreviewOpen(false); setPending('generate'); }}
      />

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
