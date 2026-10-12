"use client";

/**
 * @file src/app/(authenticated)/production/components/PlanFormPanel.tsx
 * @description 생산계획 등록·수정 폼 — MI·SMD 공용
 *
 * 초보자 가이드:
 * 1. **키는 계획일 + 계획순번이다.** 수정 모드에서 둘 다 잠긴다.
 *    계획순번은 등록할 때 서버가 시퀀스(SEQ_PLAN_DATE_SEQUENCE)에서 받는다 — 입력칸이 없다.
 * 2. **NOT NULL 이 두 테이블에서 다르다.** MI 는 공정코드가 필수이고,
 *    SMD 는 품목코드·작업지시번호·PCB면·마스터모델·생산유형이 필수다.
 *    서버도 막지만 폼에서 먼저 막아 왕복을 줄인다.
 * 5. **작업자가 고르는 것은 라인·품목코드·PCB 면(SMD)·공정(MI)·계획수량이다.**
 *    품목코드는 모델마스터(IP_PRODUCT_MODEL_MASTER)의 한 행을 고르는 것이라
 *    모델명·서픽스·마스터 모델명이 그 행에서 함께 채워진다 (오기재 방지, 읽기 전용).
 *    품목코드 하나에 모델이 둘인 경우가 있어(10건) 코드 직접 입력은 받지 않는다.
 * 6. **작업지시번호·MFS 그룹번호는 저장할 때 서버가 만든다** (WO+등록일+순번 / 라인그룹+순번).
 *    SMD 의 생산유형 P(양산)·교대 A·계획상태 W(대기), 두 화면의 우선순위 1·상위품목 '*' 는
 *    기존 계획 데이터가 (거의) 모두 이 값이라 등록 기본값으로 넣는다.
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
import ModelSearchField from '@/components/shared/ModelSearchField';
import type { ModelItem } from '@/components/shared/ModelSearchModal';
import ProcessSelect from '@/components/shared/ProcessSelect';
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

/**
 * 등록 기본값. 자동 채움 값의 근거는 기존 계획 데이터(최근 180일)다 —
 * SMD: 서픽스 '*'·상위품목 '*'·우선순위 1·계획상태 W·교대 A(3219/3220)·생산유형 P 가 전부,
 * MI: 서픽스 '*'·상위품목 '*'·우선순위 1 이 전부 (계획상태·마스터모델은 비어 있다).
 */
export const emptyPlanForm = (variant: 'mi' | 'smd'): PlanForm => ({
  planDate: today(), planSequence: '', lineCode: '', modelName: '', modelSuffix: '*',
  masterModelName: '', parentItemCode: '*', itemCode: '', workOrderNo: '',
  workstageCode: '', pcbItem: variant === 'smd' ? 'T' : '',
  planQty: '', planPriority: '1', planCapaQty: '', mcTime: '',
  planQtyD1: '', planQtyD2: '', planQtyD3: '',
  planStatus: variant === 'smd' ? 'W' : '', customerCode: '', lotDivideYn: 'N',
  shiftCode: variant === 'smd' ? 'A' : '', productionType: variant === 'smd' ? 'P' : '',
  mfsGroupNo: '',
  comments: '', slots: emptySlots(),
});

/** 낯선 항목 설명 — 라벨에 마우스를 올리면 뜬다 (data-tooltip). */
const TIP = {
  planSequence: '저장할 때 자동으로 붙는 번호입니다. 제품·반제품 계획이 같은 번호 체계를 씁니다.',
  itemCode: '모델마스터에서 고릅니다. 고르면 모델명·서픽스·마스터 모델명이 함께 채워집니다.',
  modelName: '고른 품목코드의 모델마스터 모델명입니다.',
  modelSuffixSmd: "모델의 사양 구분값입니다. 모델마스터 값을 가져오며 지금은 모든 모델이 '*'(구분 없음)입니다.\n"
    + '반제품 실적은 모델명·서픽스·PCB 면이 같은 계획에 붙습니다.',
  modelSuffixMi: "모델의 사양 구분값입니다. 모델마스터 값을 가져오며 지금은 모든 모델이 '*'(구분 없음)입니다.",
  masterModelName: '모델마스터에 등록된 대표 모델명입니다. 이 계획으로 롯트카드를 만들 때 함께 옮겨 적습니다.',
  workOrderNo: "계획 한 건의 작업지시번호입니다. 저장할 때 'WO' + 등록일(YYMMDD) + 계획순번으로 붙습니다.\n"
    + '예) 2026-10-12 등록, 순번 221262 → WO261012221262',
  pcbItem: 'T 는 1차면(Top), B 는 2차면(Bottom)입니다. 반제품 실적은 같은 면의 계획에 붙습니다.',
  productionType: 'P 양산 · S 샘플 · D 개발. 등록하는 계획은 양산(P)으로 저장합니다.',
  shiftCode: '롯트카드를 만들 때 롯트카드의 교대로 옮겨 적습니다. 등록하는 계획은 1교대(A)로 저장합니다.',
  mfsGroupNo: '이 계획으로 만드는 롯트카드에 그대로 옮겨 적는 묶음번호입니다.\n'
    + '저장할 때 라인그룹(예: SMD) + 계획순번으로 붙습니다. 예) SMD221262',
  parentItemCode: "등록하는 계획은 '*'(없음)로 저장합니다.",
} as const;

/** 라벨. tip 이 있으면 마우스를 올렸을 때 설명이 뜬다. */
function FieldLabel({ text, required, tip }: { text: string; required?: boolean; tip?: string }) {
  return (
    <span
      className={`text-text-muted ${tip ? 'cursor-help underline decoration-dotted underline-offset-2' : ''}`}
      data-tooltip={tip}
    >
      {text}{required ? ' *' : ''}
    </span>
  );
}

/** 자동으로 채우는 칸 — 값은 보이고 고칠 수 없다. */
function AutoField({ value, placeholder }: { value: string; placeholder?: string }) {
  return (
    <Input value={value} readOnly tabIndex={-1} placeholder={placeholder}
      className="cursor-default bg-background" />
  );
}

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

  /** 품목코드(모델마스터 한 행)를 고르면 모델명·서픽스·마스터 모델명을 그 행 값으로 채운다. */
  const pickModel = (model: ModelItem | null) =>
    setForm((prev) => ({
      ...prev,
      itemCode: model?.itemCode ?? '',
      modelName: model?.modelName ?? '',
      modelSuffix: model ? model.modelSuffix || '*' : '*',
      // MI 계획은 마스터 모델명을 쓰지 않는다 (기존 데이터 전부 비어 있음)
      masterModelName: isMi ? prev.masterModelName : model?.masterModelName ?? '',
    }));

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
      ['계획일', form.planDate], ['라인', form.lineCode], ['품목코드', form.itemCode],
    ];
    // MI 는 우선순위가 NOT NULL 이다 (SMD 는 비워도 된다). 실측 확인.
    if (isMi) {
      required.push(['공정코드', form.workstageCode], ['우선순위', form.planPriority]);
    }
    else {
      required.push(['PCB 면', form.pcbItem]);
    }
    required.push(['계획수량', form.planQty]);
    const missing = required.find(([, v]) => v.trim() === '');
    if (missing) {
      toast.error(`${missing[0]}은(는) 필수입니다.`);
      return;
    }
    // 품목코드로 채워지는 칸. 비어 있으면 모델마스터 값이 빠진 것이다.
    const autoFilled: Array<[string, string]> = [
      ['모델명', form.modelName], ['서픽스', form.modelSuffix],
    ];
    if (!isMi) {
      autoFilled.push(['마스터 모델명', form.masterModelName], ['생산유형', form.productionType]);
      // 작업지시번호는 등록 때 서버가 만든다. 수정 때는 기존 값이 있어야 한다.
      if (edit) autoFilled.push(['작업지시번호', form.workOrderNo]);
    }
    const missingAuto = autoFilled.find(([, v]) => v.trim() === '');
    if (missingAuto) {
      toast.error(`${missingAuto[0]}이(가) 비어 있습니다. 모델마스터에서 품목코드를 다시 고르세요.`);
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
      // 등록 때는 보내지 않는다 — 서버가 시퀀스에서 받는다.
      planSequence: edit ? Number(form.planSequence) : undefined,
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
      if (edit) {
        await api.put(path, body);
        toast.success('수정되었습니다.');
      } else {
        const response = await api.post(path, body);
        const saved = response.data?.data;
        toast.success(saved?.workOrderNo
          ? `등록되었습니다 — 순번 ${saved.planSequence} · 작업지시 ${saved.workOrderNo}`
          : '등록되었습니다.');
      }
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
              : '품목코드를 고르면 모델 정보가 채워집니다. 순번·작업지시번호는 저장할 때 붙습니다'}
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
          <div className="block text-sm">
            <FieldLabel text="계획순번" tip={TIP.planSequence} />
            <AutoField value={form.planSequence} placeholder="저장 시 자동" />
          </div>
        </div>

        <label className="block text-sm">
          <span className="text-text-muted">라인 *</span>
          <ProdLineSelect value={form.lineCode} onChange={(v) => set('lineCode', v)} />
        </label>

        {/* label 로 감싸지 않는다 — 모달 안 클릭이 label 을 거쳐 버튼을 다시 누르게 된다 */}
        <div className="block text-sm">
          <FieldLabel text="품목코드" required tip={TIP.itemCode} />
          <ModelSearchField valueKey="itemCode" value={form.itemCode} className="w-full"
            placeholder="품목코드 조회" aria-label="품목코드 조회"
            onChange={(_value, model) => pickModel(model)} />
        </div>

        <div className="grid grid-cols-2 gap-3">
          <div className="block text-sm">
            <FieldLabel text="모델명" required tip={TIP.modelName} />
            <AutoField value={form.modelName} placeholder="품목코드를 고르세요" />
          </div>
          <div className="block text-sm">
            <FieldLabel text="서픽스" required
              tip={isMi ? TIP.modelSuffixMi : TIP.modelSuffixSmd} />
            <AutoField value={form.modelSuffix} />
          </div>
        </div>

        {isMi ? (
          <div className="grid grid-cols-2 gap-3">
            <label className="block text-sm">
              <span className="text-text-muted">공정코드 *</span>
              <ProcessSelect value={form.workstageCode} placeholder="공정 선택"
                onChange={(v) => set('workstageCode', v)} />
            </label>
            <div className="block text-sm">
              <FieldLabel text="작업지시번호" tip={TIP.workOrderNo} />
              <AutoField value={form.workOrderNo} placeholder="저장 시 자동" />
            </div>
          </div>
        ) : (
          <>
            <div className="block text-sm">
              <FieldLabel text="마스터 모델명" required tip={TIP.masterModelName} />
              <AutoField value={form.masterModelName} placeholder="품목코드를 고르세요" />
            </div>
            <div className="grid grid-cols-2 gap-3">
              <div className="block text-sm">
                <FieldLabel text="작업지시번호" required tip={TIP.workOrderNo} />
                <AutoField value={form.workOrderNo} placeholder="저장 시 자동" />
              </div>
              <label className="block text-sm">
                <FieldLabel text="PCB 면" required tip={TIP.pcbItem} />
                <ComCodeSelect groupCode="PCB ITEM" includeAll={false}
                  value={form.pcbItem} onChange={(v) => set('pcbItem', v)} />
              </label>
              <div className="block text-sm">
                <FieldLabel text="생산유형" required tip={TIP.productionType} />
                <ComCodeSelect groupCode="PRODUCTION TYPE" includeAll={false} disabled
                  value={form.productionType} />
              </div>
              <div className="block text-sm">
                <FieldLabel text="교대" tip={TIP.shiftCode} />
                <ComCodeSelect groupCode="SHIFT CODE" includeAll={false} disabled
                  value={form.shiftCode} />
              </div>
              <div className="col-span-2 block text-sm">
                <FieldLabel text="MFS 그룹번호" tip={TIP.mfsGroupNo} />
                <AutoField value={form.mfsGroupNo} placeholder="저장 시 자동" />
              </div>
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
            <span className="text-text-muted">우선순위{isMi ? ' *' : ''}</span>
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
          <div className="block text-sm">
            <FieldLabel text="상위 품목코드" tip={TIP.parentItemCode} />
            <AutoField value={form.parentItemCode} />
          </div>
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
