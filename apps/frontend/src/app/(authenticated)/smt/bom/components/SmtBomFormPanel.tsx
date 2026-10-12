"use client";

/**
 * @file src/app/(authenticated)/smt/bom/components/SmtBomFormPanel.tsx
 * @description SMT BOM 행 등록·수정 폼 — PB w_smt_bom_create_master 입력 영역 이식
 *
 * 초보자 가이드:
 * 1. **키가 일곱 컬럼이다** — 상위품목·하위품목·적용시작·위치코드·라인·설비·PCB면.
 *    **적용시작(DATESET)도 키다.** 수정 모드에서 일곱 개 모두 잠긴다.
 *    적용기간을 바꾸려면 적용종료만 고친다.
 * 2. **SMT 모델명·PCB면은 NOT NULL 이다.**
 * 3. 공정코드는 폼에 없다 — 이 DB 는 전부 '*' 라 서버가 넣는다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { Save, X } from 'lucide-react';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import { Button, Input } from '@/components/ui';
import api from '@/services/api';
import { SmtMachineSelect, SmtPcbItemSelect } from '../../components/SmtSelects';
import type { SmtBomRow } from '../../types';
import PartSearchField from '@/components/shared/PartSearchField';

export interface SmtBomForm {
  parentItemCode: string;
  childItemCode: string;
  dateSet: string;
  locationCode: string;
  lineCode: string;
  machine: string;
  pcbItem: string;
  dateEnd: string;
  itemUnitQty: string;
  sortSequence: string;
  itemType: string;
  lineType: string;
  smtModelName: string;
  tableId: string;
  revision: string;
  feederShaft: string;
  feederType: string;
  locationInfo: string;
  comments: string;
  bomLevel: string;
  modelName: string;
}

const text = (value: unknown) => (value == null ? '' : String(value));
const day = (value: unknown) => (value ? String(value).slice(0, 10) : '');
const today = () => new Date().toISOString().slice(0, 10);

export const emptySmtBomForm = (modelName = ''): SmtBomForm => ({
  parentItemCode: modelName, childItemCode: '', dateSet: today(), locationCode: '',
  lineCode: '', machine: '', pcbItem: 'T', dateEnd: '9999-12-31',
  itemUnitQty: '1', sortSequence: '1', itemType: '', lineType: '',
  smtModelName: modelName, tableId: '', revision: '', feederShaft: '',
  feederType: '', locationInfo: '', comments: '', bomLevel: '1', modelName,
});

export const toSmtBomForm = (row: SmtBomRow): SmtBomForm => ({
  parentItemCode: row.parentItemCode,
  childItemCode: row.childItemCode,
  dateSet: day(row.dateSet),
  locationCode: row.locationCode,
  lineCode: row.lineCode,
  machine: row.machine,
  pcbItem: row.pcbItem,
  dateEnd: day(row.dateEnd),
  itemUnitQty: text(row.itemUnitQty),
  sortSequence: text(row.sortSequence),
  itemType: text(row.itemType),
  lineType: text(row.lineType),
  smtModelName: text(row.smtModelName),
  tableId: text(row.tableId),
  revision: text(row.revision),
  feederShaft: text(row.feederShaft),
  feederType: text(row.feederType),
  locationInfo: text(row.locationInfo),
  comments: text(row.comments),
  bomLevel: text(row.bomLevel),
  modelName: text(row.modelName),
});

interface Props {
  mode: 'create' | 'edit';
  initialForm: SmtBomForm;
  onClose: () => void;
  onSaved: () => void;
}

const optional = (value: string) => (value.trim() === '' ? undefined : value.trim());
const optionalNum = (value: string) => (value.trim() === '' ? undefined : Number(value));

export default function SmtBomFormPanel({ mode, initialForm, onClose, onSaved }: Props) {
  const [form, setForm] = useState<SmtBomForm>(initialForm);
  const [busy, setBusy] = useState(false);
  const edit = mode === 'edit';
  const set = <K extends keyof SmtBomForm>(key: K, value: SmtBomForm[K]) =>
    setForm((prev) => ({ ...prev, [key]: value }));

  const save = useCallback(async () => {
    const keys: Array<[string, string]> = [
      ['상위품목', form.parentItemCode], ['하위품목', form.childItemCode],
      ['적용시작', form.dateSet], ['위치코드', form.locationCode],
      ['라인코드', form.lineCode], ['설비코드', form.machine], ['PCB 면', form.pcbItem],
    ];
    const missingKey = keys.find(([, v]) => v.trim() === '');
    if (missingKey) {
      toast.error(`${missingKey[0]}을(를) 입력하세요. 키의 일부입니다.`);
      return;
    }
    const required: Array<[string, string]> = [
      ['적용종료', form.dateEnd], ['품목유형', form.itemType],
      ['라인유형', form.lineType], ['SMT 모델명', form.smtModelName],
    ];
    const missing = required.find(([, v]) => v.trim() === '');
    if (missing) {
      toast.error(`${missing[0]}은(는) 필수입니다.`);
      return;
    }
    setBusy(true);
    const body = {
      parentItemCode: form.parentItemCode.trim(),
      childItemCode: form.childItemCode.trim(),
      dateSet: form.dateSet,
      locationCode: form.locationCode.trim(),
      lineCode: form.lineCode.trim(),
      machine: form.machine.trim(),
      pcbItem: form.pcbItem.trim(),
      dateEnd: form.dateEnd,
      itemUnitQty: Number(form.itemUnitQty || 0),
      sortSequence: Number(form.sortSequence || 0),
      itemType: form.itemType.trim(),
      lineType: form.lineType.trim(),
      smtModelName: form.smtModelName.trim(),
      tableId: optional(form.tableId),
      revision: optional(form.revision),
      feederShaft: optional(form.feederShaft),
      feederType: optional(form.feederType),
      locationInfo: optional(form.locationInfo),
      comments: optional(form.comments),
      bomLevel: optionalNum(form.bomLevel),
      modelName: optional(form.modelName),
    };
    try {
      if (edit) await api.put('/smt/bom', body);
      else await api.post('/smt/bom', body);
      toast.success(edit ? '수정되었습니다.' : '등록되었습니다.');
      onSaved();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '저장에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [form, edit, onSaved]);

  return (
    <aside className="flex w-[26rem] shrink-0 flex-col border-l border-border bg-surface">
      <header className="flex items-center justify-between border-b border-border p-4">
        <div>
          <b className="text-text">{edit ? 'BOM 행 수정' : 'BOM 행 등록'}</b>
          <div className="text-xs text-text-muted">
            {edit
              ? '키 일곱 컬럼(적용시작 포함)은 바꿀 수 없습니다'
              : '적용시작도 키입니다 — 나중에 바꿀 수 없습니다'}
          </div>
        </div>
        <button type="button" onClick={onClose} aria-label="닫기">
          <X className="h-4 w-4 text-text-muted" />
        </button>
      </header>

      <div className="flex-1 space-y-3 overflow-auto p-4">
        <label className="block text-sm">
          <span className="text-text-muted">상위품목 (모델) *</span>
          <PartSearchField value={form.parentItemCode} disabled={edit}
            onChange={(e) => set('parentItemCode', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">하위품목 (부품) *</span>
          <PartSearchField value={form.childItemCode} disabled={edit}
            onChange={(e) => set('childItemCode', e.target.value)} />
        </label>
        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">라인코드 *</span>
            <Input value={form.lineCode} disabled={edit}
              onChange={(e) => set('lineCode', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">설비코드 *</span>
            <SmtMachineSelect value={form.machine} disabled={edit}
              onChange={(v) => set('machine', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">위치코드 *</span>
            <Input value={form.locationCode} disabled={edit}
              onChange={(e) => set('locationCode', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">PCB 면 *</span>
            <SmtPcbItemSelect value={form.pcbItem} disabled={edit}
              onChange={(v) => set('pcbItem', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">적용시작 * (키)</span>
            <Input type="date" value={form.dateSet} disabled={edit}
              onChange={(e) => set('dateSet', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">적용종료 *</span>
            <Input type="date" value={form.dateEnd}
              onChange={(e) => set('dateEnd', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">소요량 *</span>
            <Input type="number" value={form.itemUnitQty}
              onChange={(e) => set('itemUnitQty', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">정렬순번 *</span>
            <Input type="number" value={form.sortSequence}
              onChange={(e) => set('sortSequence', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">품목유형 *</span>
            <ComCodeSelect groupCode="ITEM TYPE" includeAll={false}
              value={form.itemType} onChange={(v) => set('itemType', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">라인유형 *</span>
            <ComCodeSelect groupCode="LINE TYPE" includeAll={false}
              value={form.lineType} onChange={(v) => set('lineType', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">테이블문자</span>
            <Input value={form.tableId} maxLength={10}
              onChange={(e) => set('tableId', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">리비전</span>
            <Input value={form.revision} maxLength={10}
              onChange={(e) => set('revision', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">피더축</span>
            <Input value={form.feederShaft} maxLength={1}
              onChange={(e) => set('feederShaft', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">피더유형</span>
            <Input value={form.feederType} maxLength={50}
              onChange={(e) => set('feederType', e.target.value)} />
          </label>
        </div>
        <label className="block text-sm">
          <span className="text-text-muted">SMT 모델명 *</span>
          <Input value={form.smtModelName} maxLength={50}
            onChange={(e) => set('smtModelName', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">위치정보</span>
          <Input value={form.locationInfo}
            onChange={(e) => set('locationInfo', e.target.value)} />
        </label>
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
