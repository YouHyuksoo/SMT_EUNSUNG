"use client";

/**
 * @file src/app/(authenticated)/purchase/order-plan/components/OrderPlanGeneratePanel.tsx
 * @description 478 자재발주계획 — ① 발주계획 생성 조건을 고르는 우측 패널
 *
 * 초보자 가이드:
 * 1. 생성에만 쓰는 옵션(계획 원천·기간·발주일·뺄 재고·계산 옵션)을 화면 위에서 빼
 *    이 패널로 모았다. 화면 위에는 조회 조건만 남는다.
 * 2. 값(state)은 페이지가 들고 있고 이 패널은 보여주고 바꾸기만 한다 — 생성 확인 모달과
 *    생성 API 호출은 페이지가 그대로 한다.
 * 3. 툴팁으로만 보이던 설명을 옵션 아래 한 줄로 풀어 적었다.
 */
import { Eye, Play, X } from 'lucide-react';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import { Button, Input, Select } from '@/components/ui';

/** PB 라디오버튼(계획 원천). 어느 계획에서 BOM 을 펼지. */
export const PLAN_SOURCES = [
  { value: 'productionPlan', label: '생산계획' },
  { value: 'productionPlanByTime', label: '생산계획(시간별)' },
  { value: 'salePlan', label: '납품계획' },
  { value: 'salePlanByTime', label: '납품계획(시간별)' },
  { value: 'manual', label: '수기계획' },
];

export const SOURCE_TIP: Record<string, string> = {
  productionPlan: '생산계획(IP_PRODUCT_MI_PLAN)에서 아직 못 만든 수량(계획 − 실적)만 펼칩니다.',
  productionPlanByTime: '생산계획을 같은 날 안에서도 시:분 단위로 나눠 봅니다.'
    + ' 하루에 여러 번 투입하는 라인에 씁니다.',
  salePlan: '납품계획에서 아직 안 보낸 수량을 펼칩니다. 지시번호로 잡힌 실적까지 뺍니다.',
  salePlanByTime: '납품계획을 시:분:초 단위로 나눠 봅니다.',
  manual: '손으로 넣어 둔 발주 기준계획(IM_ITEM_MASTER_PLAN_4_PO)을 펼칩니다.',
};

/** PB 체크박스(소요량에서 뺄 재고). 켠 것만 빠진다. */
export const INVENTORY_ARMS = [
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

export const GENERATE_TIP = {
  range: '이 기간에 든 계획만 펼칩니다.',
  orderDate: '만들어지는 발주계획에 찍히는 발주일입니다. 실제 주문으로 넘길 때도 이 날짜를 씁니다.',
  orderRule: '발주규칙이 자동(A)인 품목만 계획하고, 협력사별 최소주문량·포장단위·불량율을'
    + ' 발주량에 반영합니다. 예: 포장단위가 100이고 계산값이 120이면 200으로 올립니다.'
    + ' 끄면 전 품목을 소요량 그대로 계획합니다.',
  distinctMfs: '같은 품목·거래유형을 한 줄로 합칩니다. 납기는 가장 이른 날이 됩니다.'
    + ' 끄면 작업지시·계획일별로 줄이 나뉩니다.',
  roundQty: '발주량을 소수 4자리로 반올림합니다.',
  unitPrice: '단가는 항상 단가 기준정보에서 붙입니다. 단가가 0 이어도 등록돼 있으면 붙고,'
    + ' 등록이 없으면 거래처를 확정할 수 없어 상태 P 로 남고 확정되지 않습니다.',
  leadTime: '제조 리드타임만큼 납기를 앞으로 당깁니다 — 자재가 생산 시작 전에 들어와야'
    + ' 하기 때문입니다. 안 켜면 자재가 필요한 날이 곧 납기가 됩니다.',
  calendar: '당긴 납기가 휴무일이면 일하는 날로 옮깁니다. 리드타임 반영과는 별개 단계입니다.',
  preview: '생성과 같은 계산을 하고 저장하지 않습니다. 줄마다 소요량·재고 차감·올림·발주량을 봅니다.',
  generate: '고른 계획을 BOM 으로 펴고, 켜 둔 재고를 빼서 발주계획을 만듭니다.'
    + ' 기존 발주계획은 통째로 새로 만들어집니다.',
} as const;

export interface OrderPlanGenerateValues {
  source: string;
  dateFrom: string;
  dateTo: string;
  orderDate: string;
  arms: string[];
  applyOrderRule: boolean;
  distinctMfs: boolean;
  roundQty: boolean;
  applyLeadTime: boolean;
  applyCalendar: boolean;
}

interface Props {
  values: OrderPlanGenerateValues;
  onChange: (patch: Partial<OrderPlanGenerateValues>) => void;
  /** 화면 위 품목코드 조건 — 생성에도 걸리므로 알려준다 */
  itemCode: string;
  busy: boolean;
  onGenerate: () => void;
  onPreview: () => void;
  onClose: () => void;
}

/** 체크박스 + 이름 + 설명 한 줄 */
function OptionRow({ checked, onToggle, label, desc }: {
  checked: boolean;
  onToggle: () => void;
  label: string;
  desc: string;
}) {
  return (
    <label className="flex cursor-pointer gap-2 rounded px-2 py-1.5 hover:bg-surface">
      <input type="checkbox" className="mt-0.5" checked={checked} onChange={onToggle} />
      <span className="min-w-0">
        <span className="block text-sm text-text">{label}</span>
        <span className="block text-xs text-text-muted">{desc}</span>
      </span>
    </label>
  );
}

export default function OrderPlanGeneratePanel({
  values, onChange, itemCode, busy, onGenerate, onPreview, onClose,
}: Props) {
  const toggleArm = (value: string) => onChange({
    arms: values.arms.includes(value)
      ? values.arms.filter((v) => v !== value)
      : [...values.arms, value],
  });

  return (
    <div className="flex h-full w-[480px] flex-shrink-0 flex-col overflow-hidden border-l border-border bg-background shadow-2xl animate-slide-in-right">
      <div className="flex flex-shrink-0 items-center justify-between border-b border-border px-5 py-3">
        <h2 className="text-sm font-bold text-text">① 발주계획 생성</h2>
        <div className="flex items-center gap-2">
          <Button size="sm" variant="secondary" onClick={onClose} disabled={busy}>
            <X className="mr-1 h-4 w-4" />닫기
          </Button>
          <Button size="sm" variant="secondary" onClick={onPreview} disabled={busy}
            data-tooltip={GENERATE_TIP.preview}>
            <Eye className="mr-1 h-4 w-4" />미리보기
          </Button>
          <Button size="sm" onClick={onGenerate} disabled={busy} data-tooltip={GENERATE_TIP.generate}>
            <Play className="mr-1 h-4 w-4" />생성
          </Button>
        </div>
      </div>

      <div className="flex-1 space-y-5 overflow-y-auto p-5">
        {/* 1. 무엇을 펼지 */}
        <section className="space-y-3">
          <h3 className="text-sm font-semibold text-text">무엇을 펼지</h3>
          <div className="flex flex-col gap-1">
            <label className="text-xs text-text-muted" htmlFor="plan-source">계획 원천</label>
            <Select id="plan-source" aria-label="계획 원천" value={values.source} fullWidth
              onChange={(v) => onChange({ source: v })} options={PLAN_SOURCES} />
            <p className="text-xs text-text-muted">{SOURCE_TIP[values.source]}</p>
          </div>
          <div className="flex flex-col gap-1">
            <DateRangeFilter label="계획기간" from={values.dateFrom} to={values.dateTo}
              onFromChange={(v) => onChange({ dateFrom: v })}
              onToChange={(v) => onChange({ dateTo: v })} />
            <p className="text-xs text-text-muted">{GENERATE_TIP.range}</p>
          </div>
          <div className="flex flex-col gap-1">
            <label className="text-xs text-text-muted" htmlFor="order-date">발주일</label>
            <Input id="order-date" type="date" value={values.orderDate} className="w-44"
              onChange={(e) => onChange({ orderDate: e.target.value })} />
            <p className="text-xs text-text-muted">{GENERATE_TIP.orderDate}</p>
          </div>
          <p className="rounded bg-surface/60 px-2 py-1.5 text-xs text-text-muted">
            품목 조건: {itemCode.trim()
              ? <span className="font-mono text-text">{itemCode.trim()}</span>
              : '전체'} — 화면 위 품목코드 조건이 생성에도 걸립니다.
          </p>
        </section>

        {/* 2. 소요량에서 뺄 재고 — 이 다섯이 발주량을 정한다 */}
        <section className="space-y-1">
          <h3 className="text-sm font-semibold text-text">소요량에서 뺄 재고</h3>
          {INVENTORY_ARMS.map((arm) => (
            <OptionRow key={arm.value} checked={values.arms.includes(arm.value)}
              onToggle={() => toggleArm(arm.value)} label={arm.label} desc={arm.tip} />
          ))}
          {values.arms.length === 0 && (
            <p className="px-2 text-xs text-amber-500">하나도 안 켜면 소요량이 그대로 발주량이 됩니다.</p>
          )}
        </section>

        {/* 3. 계산 옵션 — 수량·단가·납기를 손보는 것들 */}
        <section className="space-y-1">
          <h3 className="text-sm font-semibold text-text">계산 옵션</h3>
          <OptionRow checked={values.applyOrderRule}
            onToggle={() => onChange({ applyOrderRule: !values.applyOrderRule })}
            label="자동발주 품목·발주속성 (최소·포장·불량율)" desc={GENERATE_TIP.orderRule} />
          <OptionRow checked={values.distinctMfs}
            onToggle={() => onChange({ distinctMfs: !values.distinctMfs })}
            label="품목별 한 줄로 합치기" desc={GENERATE_TIP.distinctMfs} />
          <OptionRow checked={values.roundQty}
            onToggle={() => onChange({ roundQty: !values.roundQty })}
            label="소수 4자리 반올림" desc={GENERATE_TIP.roundQty} />
          <OptionRow checked={values.applyLeadTime}
            onToggle={() => onChange({ applyLeadTime: !values.applyLeadTime })}
            label="리드타임 반영" desc={GENERATE_TIP.leadTime} />
          <OptionRow checked={values.applyCalendar}
            onToggle={() => onChange({ applyCalendar: !values.applyCalendar })}
            label="작업일 보정" desc={GENERATE_TIP.calendar} />
          <p className="px-2 pt-1 text-xs text-text-muted">{GENERATE_TIP.unitPrice}</p>
        </section>

        <p className="text-xs text-text-muted">{GENERATE_TIP.generate}</p>
      </div>
    </div>
  );
}
