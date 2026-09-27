"use client";

/**
 * @file src/app/(authenticated)/production/components/PlanFormPanel.tsx
 * @description 생산계획 등록·수정 폼 — MI·SMD 공용
 *
 * 초보자 가이드:
 * 1. **키는 계획일 + 계획순번이다.** 수정 모드에서 둘 다 잠긴다.
 *    등록 시 순번을 비우면 서버가 그 날짜의 최대순번 + 1 을 매긴다.
 * 2. **NOT NULL 이 두 테이블에서 다르다.** MI 는 공정코드가 필수이고,
 *    SMD 는 품목코드·작업지시번호·PCB면·마스터모델·생산유형이 필수다.
 *    서버도 막지만 폼에서 먼저 막아 왕복을 줄인다.
 * 3. **시간대 10칸은 접어 둔다.** 수량 칸과 메모 칸이 각각 10개라 펼치면
 *    폼이 길어진다. 합계를 옆에 보여 주므로 계획수량과 맞는지 바로 보인다.
 * 4. **롯트카드번호(MFS)는 폼에 없다.** 롯트카드 쪽이 쓰는 값이라 계획 화면에서
 *    손대면 두 화면이 서로 다른 값을 쓰게 된다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { ChevronDown, ChevronRight, Save, X } from 'lucide-react';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import CustomerSelect from '@/components/shared/CustomerSelect';
import ProdLineSelect from '@/components/shared/ProdLineSelect';
import UseYnSelect from '@/components/shared/UseYnSelect';
import { Button, Input } from '@/components/ui';
import api from '@/services/api';
import type { PlanRow } from '../planning-types';
import { SLOT_INDEXES } from '../planning-types';

export interface PlanForm {
  planDate: string;
  planSequence: string;
  lineCode: string;
  modelName: string;
  modelSuffix: string;
  masterModelName: string;
  parentItemCode: string;
  itemCode: string;
  workOrderNo: string;
  workstageCode: string;
  pcbItem: string;
  planQty: string;
  planPriority: string;
  planCapaQty: string;
  mcTime: string;
  planQtyD1: string;
  planQtyD2: string;
  planQtyD3: string;
  planStatus: string;
  customerCode: string;
  lotDivideYn: string;
  shiftCode: string;
  productionType: string;
  mfsGroupNo: string;
  comments: string;
  /** planTime1..10, time1Desc..10 */
  slots: Record<string, string>;
}

const text = (value: unknown) => (value == null ? '' : String(value));
const today = () => new Date().toISOString().slice(0, 10);

const emptySlots = (): Record<string, string> => {
  const out: Record<string, string> = {};
  for (const slot of SLOT_INDEXES) {
    out[`planTime${slot}`] = '';
    out[`time${slot}Desc`] = '';
  }
  return out;
};

export const emptyPlanForm = (variant: 'mi' | 'smd'): PlanForm => ({
  planDate: today(), planSequence: '', lineCode: '', modelName: '', modelSuffix: '*',
  masterModelName: '', parentItemCode: '', itemCode: '', workOrderNo: '',
  workstageCode: variant === 'mi' ? '*' : '', pcbItem: variant === 'smd' ? 'T' : '',
  planQty: '0', planPriority: '1', planCapaQty: '', mcTime: '',
  planQtyD1: '', planQtyD2: '', planQtyD3: '',
  planStatus: '', customerCode: '', lotDivideYn: 'N',
  shiftCode: '', productionType: variant === 'smd' ? 'A' : '', mfsGroupNo: '',
  comments: '', slots: emptySlots(),
});

export const toPlanForm = (row: PlanRow): PlanForm => {
  const slots: Record<string, string> = {};
  for (const slot of SLOT_INDEXES) {
    slots[`planTime${slot}`] = text(row[`planTime${slot}`]);
    slots[`time${slot}Desc`] = text(row[`time${slot}Desc`]);
  }
  return {
    planDate: String(row.planDate).slice(0, 10),
    planSequence: String(row.planSequence),
    lineCode: text(row.lineCode),
    modelName: text(row.modelName),
    modelSuffix: text(row.modelSuffix),
    masterModelName: text(row.masterModelName),
    parentItemCode: text(row.parentItemCode),
    itemCode: text(row.itemCode),
    workOrderNo: text(row.workOrderNo),
    workstageCode: text(row.workstageCode),
    pcbItem: text(row.pcbItem),
    planQty: text(row.planQty),
    planPriority: text(row.planPriority),
    planCapaQty: text(row.planCapaQty),
    mcTime: text(row.mcTime),
    planQtyD1: text(row.planQtyD1),
    planQtyD2: text(row.planQtyD2),
    planQtyD3: text(row.planQtyD3),
    planStatus: text(row.planStatus),
    customerCode: text(row.customerCode),
    lotDivideYn: text(row.lotDivideYn) || 'N',
    shiftCode: text(row.shiftCode),
    productionType: text(row.productionType),
    mfsGroupNo: text(row.mfsGroupNo),
    comments: text(row.comments),
    slots,
  };
};

interface Props {
  mode: 'create' | 'edit';
  variant: 'mi' | 'smd';
  path: string;
  initialForm: PlanForm;
  onClose: () => void;
  onSaved: () => void;
}

const optional = (value: string) => (value.trim() === '' ? undefined : value.trim());
const optionalNum = (value: string) => (value.trim() === '' ? undefined : Number(value));

export default function PlanFormPanel({
  mode, variant, path, initialForm, onClose, onSaved,
}: Props) {
  const [form, setForm] = useState<PlanForm>(initialForm);
  const [busy, setBusy] = useState(false);
  const [slotsOpen, setSlotsOpen] = useState(false);
  const edit = mode === 'edit';
  const isMi = variant === 'mi';

  const set = <K extends keyof PlanForm>(key: K, value: PlanForm[K]) =>
    setForm((prev) => ({ ...prev, [key]: value }));
  const setSlot = (key: string, value: string) =>
    setForm((prev) => ({ ...prev, slots: { ...prev.slots, [key]: value } }));

  /** 시간대 합. 계획수량과 맞는지 바로 보이게 옆에 적는다. */
  const slotSum = useMemo(
    () => SLOT_INDEXES.reduce(
      (sum, slot) => sum + (Number(form.slots[`planTime${slot}`]) || 0),
      0,
    ),
    [form.slots],
  );

  const save = useCallback(async () => {
    const required: Array<[string, string]> = [
      ['계획일', form.planDate], ['라인코드', form.lineCode],
      ['모델명', form.modelName], ['서픽스', form.modelSuffix],
    ];
    if (isMi) required.push(['공정코드', form.workstageCode]);
    else {
      required.push(
        ['품목코드', form.itemCode], ['작업지시번호', form.workOrderNo],
        ['PCB 면', form.pcbItem], ['마스터 모델명', form.masterModelName],
        ['생산유형', form.productionType],
      );
    }
    const missing = required.find(([, v]) => v.trim() === '');
    if (missing) {
      toast.error(`${missing[0]}은(는) 필수입니다.`);
      return;
    }

    setBusy(true);
    const slotBody: Record<string, unknown> = {};
    for (const slot of SLOT_INDEXES) {
      slotBody[`planTime${slot}`] = optionalNum(form.slots[`planTime${slot}`]);
      slotBody[`time${slot}Desc`] = optional(form.slots[`time${slot}Desc`]);
    }
    const body = {
      planDate: form.planDate,
      planSequence: edit ? Number(form.planSequence) : optionalNum(form.planSequence),
      lineCode: form.lineCode.trim(),
      modelName: form.modelName.trim(),
      modelSuffix: form.modelSuffix.trim(),
      masterModelName: optional(form.masterModelName),
      parentItemCode: optional(form.parentItemCode),
      itemCode: optional(form.itemCode),
      workOrderNo: optional(form.workOrderNo),
      workstageCode: isMi ? form.workstageCode.trim() : undefined,
      pcbItem: optional(form.pcbItem),
      planQty: Number(form.planQty || 0),
      planPriority: optionalNum(form.planPriority),
      planCapaQty: optionalNum(form.planCapaQty),
      mcTime: optionalNum(form.mcTime),
      planQtyD1: optionalNum(form.planQtyD1),
      planQtyD2: optionalNum(form.planQtyD2),
      planQtyD3: optionalNum(form.planQtyD3),
      planStatus: optional(form.planStatus),
      customerCode: optional(form.customerCode),
      lotDivideYn: form.lotDivideYn === 'Y' ? 'Y' : 'N',
      shiftCode: isMi ? undefined : optional(form.shiftCode),
      productionType: isMi ? undefined : optional(form.productionType),
      mfsGroupNo: isMi ? undefined : optional(form.mfsGroupNo),
      comments: optional(form.comments),
      ...slotBody,
    };
    try {
      if (edit) await api.put(path, body);
      else await api.post(path, body);
      toast.success(edit ? '수정되었습니다.' : '등록되었습니다.');
      onSaved();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '저장에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [form, edit, isMi, path, onSaved]);

  return (
    <aside className="flex w-[26rem] shrink-0 flex-col border-l border-border bg-surface">
      <header className="flex items-center justify-between border-b border-border p-4">
        <div>
          <b className="text-text">{edit ? '계획 수정' : '계획 등록'}</b>
          <div className="text-xs text-text-muted">
            {edit
              ? `${form.planDate} / 순번 ${form.planSequence} · 키는 바꿀 수 없습니다`
              : '순번을 비우면 그 날짜의 마지막 다음 번호가 붙습니다'}
          </div>
        </div>
        <button type="button" onClick={onClose} aria-label="닫기">
          <X className="h-4 w-4 text-text-muted" />
        </button>
      </header>

      <div className="flex-1 space-y-3 overflow-auto p-4">
        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">계획일 *</span>
            <Input type="date" value={form.planDate} disabled={edit}
              onChange={(e) => set('planDate', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">계획순번</span>
            <Input type="number" value={form.planSequence} disabled={edit}
              onChange={(e) => set('planSequence', e.target.value)} />
          </label>
        </div>

        <label className="block text-sm">
          <span className="text-text-muted">라인 *</span>
          <ProdLineSelect value={form.lineCode} onChange={(v) => set('lineCode', v)} />
        </label>

        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">모델명 *</span>
            <Input value={form.modelName} onChange={(e) => set('modelName', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">서픽스 *</span>
            <Input value={form.modelSuffix}
              onChange={(e) => set('modelSuffix', e.target.value)} />
          </label>
        </div>

        {isMi ? (
          <label className="block text-sm">
            <span className="text-text-muted">공정코드 *</span>
            <Input value={form.workstageCode}
              onChange={(e) => set('workstageCode', e.target.value)} />
          </label>
        ) : (
          <>
            <label className="block text-sm">
              <span className="text-text-muted">마스터 모델명 *</span>
              <Input value={form.masterModelName}
                onChange={(e) => set('masterModelName', e.target.value)} />
            </label>
            <div className="grid grid-cols-2 gap-3">
              <label className="block text-sm">
                <span className="text-text-muted">품목코드 *</span>
                <Input value={form.itemCode}
                  onChange={(e) => set('itemCode', e.target.value)} />
              </label>
              <label className="block text-sm">
                <span className="text-text-muted">작업지시번호 *</span>
                <Input value={form.workOrderNo}
                  onChange={(e) => set('workOrderNo', e.target.value)} />
              </label>
              <label className="block text-sm">
                <span className="text-text-muted">PCB 면 *</span>
                <ComCodeSelect groupCode="PCB ITEM" includeAll={false}
                  value={form.pcbItem} onChange={(v) => set('pcbItem', v)} />
              </label>
              <label className="block text-sm">
                <span className="text-text-muted">생산유형 *</span>
                <ComCodeSelect groupCode="PRODUCTION TYPE" includeAll={false}
                  value={form.productionType}
                  onChange={(v) => set('productionType', v)} />
              </label>
              <label className="block text-sm">
                <span className="text-text-muted">교대</span>
                <ComCodeSelect groupCode="SHIFT CODE" includeAll
                  value={form.shiftCode} onChange={(v) => set('shiftCode', v)} />
              </label>
              <label className="block text-sm">
                <span className="text-text-muted">MFS 그룹번호</span>
                <Input value={form.mfsGroupNo}
                  onChange={(e) => set('mfsGroupNo', e.target.value)} />
              </label>
            </div>
          </>
        )}

        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">계획수량 *</span>
            <Input type="number" value={form.planQty}
              onChange={(e) => set('planQty', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">우선순위</span>
            <Input type="number" value={form.planPriority}
              onChange={(e) => set('planPriority', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">설비능력 수량</span>
            <Input type="number" value={form.planCapaQty}
              onChange={(e) => set('planCapaQty', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">기종교체(분)</span>
            <Input type="number" value={form.mcTime}
              onChange={(e) => set('mcTime', e.target.value)} />
          </label>
        </div>

        {isMi && (
          <label className="block text-sm">
            <span className="text-text-muted">상위 품목코드</span>
            <Input value={form.parentItemCode}
              onChange={(e) => set('parentItemCode', e.target.value)} />
          </label>
        )}

        <div className="grid grid-cols-3 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">D1</span>
            <Input type="number" value={form.planQtyD1}
              onChange={(e) => set('planQtyD1', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">D2</span>
            <Input type="number" value={form.planQtyD2}
              onChange={(e) => set('planQtyD2', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">D3</span>
            <Input type="number" value={form.planQtyD3}
              onChange={(e) => set('planQtyD3', e.target.value)} />
          </label>
        </div>

        <label className="block text-sm">
          <span className="text-text-muted">계획상태</span>
          <ComCodeSelect groupCode="PLAN STATUS" includeAll
            value={form.planStatus} onChange={(v) => set('planStatus', v)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">고객</span>
          <CustomerSelect includeAll value={form.customerCode}
            onChange={(v) => set('customerCode', v)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">LOT 분할</span>
          <UseYnSelect includeAll={false} value={form.lotDivideYn}
            onChange={(v) => set('lotDivideYn', v)} />
        </label>

        <div className="rounded border border-border">
          <button type="button"
            className="flex w-full items-center justify-between p-3 text-sm"
            onClick={() => setSlotsOpen((open) => !open)}>
            <span className="text-text">시간대 10칸</span>
            <span className="flex items-center gap-2 text-text-muted">
              합 {slotSum.toLocaleString()}
              {slotSum !== Number(form.planQty || 0) && (
                <span className="text-amber-500">계획수량과 다름</span>
              )}
              {slotsOpen ? <ChevronDown className="h-4 w-4" /> : <ChevronRight className="h-4 w-4" />}
            </span>
          </button>
          {slotsOpen && (
            <div className="space-y-2 border-t border-border p-3">
              {SLOT_INDEXES.map((slot) => (
                <div key={slot} className="grid grid-cols-[3rem_6rem_1fr] items-center gap-2">
                  <span className="text-xs text-text-muted">{slot}칸</span>
                  <Input type="number" value={form.slots[`planTime${slot}`]}
                    onChange={(e) => setSlot(`planTime${slot}`, e.target.value)} />
                  <Input placeholder="메모" value={form.slots[`time${slot}Desc`]}
                    onChange={(e) => setSlot(`time${slot}Desc`, e.target.value)} />
                </div>
              ))}
            </div>
          )}
        </div>

        <label className="block text-sm">
          <span className="text-text-muted">비고</span>
          <Input value={form.comments} onChange={(e) => set('comments', e.target.value)} />
        </label>
      </div>

      <footer className="flex gap-2 border-t border-border p-4">
        <Button className="flex-1" onClick={save} disabled={busy}>
          <Save className="mr-1 h-4 w-4" />저장
        </Button>
        <Button className="flex-1" variant="secondary" onClick={onClose} disabled={busy}>
          취소
        </Button>
      </footer>
    </aside>
  );
}
