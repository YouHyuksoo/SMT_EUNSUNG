"use client";

/**
 * @file src/app/(authenticated)/jig/master/components/JigMasterFormPanel.tsx
 * @description 지그 등록·수정 우측 폼 패널 — PB w_mcn_jig_master 의 dw_2(d_mcn_jig_mst) 이식
 *
 * 초보자 가이드:
 * 1. **등록/수정 공용**: `mode` 하나로 가른다. 컴포넌트를 두 개 만들지 않는다.
 * 2. **키 컬럼 잠금**: 수정일 때 지그코드·지그LOT 은 키(XPKIMCN_JIG)라 바꿀 수 없다.
 * 3. **감사컬럼 없음**: 등록자·수정자·일시는 입력하지 않는다. 서버가 채운다
 *    (PB f_set_security_row 가 하던 일).
 * 4. **코드성 값은 선택 컴포넌트**: 지그유형·상태·취득유형 등은 기초코드에서 고른다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { Save, X } from 'lucide-react';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateFilter from '@/components/shared/DateFilter';
import LineSelect from '@/components/shared/LineSelect';
import ProcessSelect from '@/components/shared/ProcessSelect';
import { Button, Input } from '@/components/ui';
import api from '@/services/api';
import type { JigMasterRow } from '../types';
import PartSearchField from '@/components/shared/PartSearchField';

export interface JigForm {
  jigCode: string;
  jigLotNo: string;
  jigName: string;
  jigType: string;
  jigStatus: string;
  useStatus: string;
  acquisitionType: string;
  acquisitionDate: string;
  lineCode: string;
  workstageCode: string;
  machineCode: string;
  itemCode: string;
  jigModelName: string;
  jigSpec: string;
  pcbItem: string;
  solderType: string;
  customerCode: string;
  supplierCode: string;
  locationAddress: string;
  managementCommnets: string;
  useTpmYn: string;
  tensionCheckYn: string;
  breakValue: string;
  hitValue: string;
  minTension: string;
  maxTension: string;
}

export const emptyJigForm: JigForm = {
  jigCode: '', jigLotNo: '', jigName: '', jigType: '', jigStatus: '', useStatus: '',
  acquisitionType: '', acquisitionDate: '', lineCode: '', workstageCode: '', machineCode: '',
  itemCode: '', jigModelName: '', jigSpec: '', pcbItem: '', solderType: '',
  customerCode: '', supplierCode: '', locationAddress: '', managementCommnets: '',
  useTpmYn: 'N', tensionCheckYn: 'N',
  breakValue: '', hitValue: '', minTension: '', maxTension: '',
};

export function toJigForm(row: JigMasterRow): JigForm {
  const text = (value: unknown) => (value == null ? '' : String(value));
  return {
    jigCode: row.jigCode, jigLotNo: row.jigLotNo,
    jigName: text(row.jigName), jigType: text(row.jigType), jigStatus: text(row.jigStatus),
    useStatus: text(row.useStatus), acquisitionType: text(row.acquisitionType),
    acquisitionDate: row.acquisitionDate ? String(row.acquisitionDate).slice(0, 10) : '',
    lineCode: text(row.lineCode), workstageCode: text(row.workstageCode),
    machineCode: text(row.machineCode), itemCode: text(row.itemCode),
    jigModelName: text(row.jigModelName), jigSpec: text(row.jigSpec),
    pcbItem: text(row.pcbItem), solderType: text(row.solderType),
    customerCode: text(row.customerCode), supplierCode: text(row.supplierCode),
    locationAddress: text(row.locationAddress), managementCommnets: text(row.managementCommnets),
    useTpmYn: text(row.useTpmYn) || 'N', tensionCheckYn: text(row.tensionCheckYn) || 'N',
    breakValue: text(row.breakValue), hitValue: text(row.hitValue),
    minTension: text(row.minTension), maxTension: text(row.maxTension),
  };
}

interface Props {
  mode: 'create' | 'edit';
  initialForm: JigForm;
  onClose: () => void;
  onSaved: () => void;
}

export default function JigMasterFormPanel({ mode, initialForm, onClose, onSaved }: Props) {
  const isEdit = mode === 'edit';
  const [form, setForm] = useState<JigForm>(initialForm);
  const [saving, setSaving] = useState(false);

  const set = useCallback(<K extends keyof JigForm>(key: K, value: JigForm[K]) => {
    setForm((prev) => ({ ...prev, [key]: value }));
  }, []);

  const numeric = (value: string) => (value.trim() === '' ? undefined : Number(value));

  const save = useCallback(async () => {
    if (!form.jigCode.trim()) return toast.error('지그코드를 입력하세요.');
    if (!form.jigLotNo.trim()) return toast.error('지그LOT을 입력하세요.');
    if (!form.jigName.trim()) return toast.error('지그명을 입력하세요.');
    if (!form.jigType) return toast.error('지그유형을 선택하세요.');
    setSaving(true);
    try {
      const payload = {
        ...form,
        acquisitionDate: form.acquisitionDate || undefined,
        breakValue: numeric(form.breakValue),
        hitValue: numeric(form.hitValue),
        minTension: numeric(form.minTension),
        maxTension: numeric(form.maxTension),
      };
      if (isEdit) await api.put('/jig/master', payload);
      else await api.post('/jig/master', payload);
      toast.success('저장되었습니다.');
      onSaved();
    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : '';
      toast.error(message.includes('409') ? '이미 등록된 지그입니다.' : '저장에 실패했습니다.');
    } finally {
      setSaving(false);
    }
  }, [form, isEdit, onSaved]);

  return (
    <aside className="flex h-full w-[520px] shrink-0 flex-col border-l border-border bg-background shadow-xl">
      <header className="flex h-14 items-center justify-between border-b border-border px-5">
        <h2 className="font-bold text-text">{isEdit ? '지그 수정' : '지그 등록'}</h2>
        <button type="button" title="닫기" onClick={onClose}>
          <X className="h-5 w-5 text-text-muted" />
        </button>
      </header>

      <div className="flex-1 space-y-3 overflow-y-auto p-5 text-sm">
        <div className="grid grid-cols-2 gap-3">
          <Input label="지그코드" value={form.jigCode} disabled={isEdit} required
            onChange={(e) => set('jigCode', e.target.value)} />
          <Input label="지그LOT" value={form.jigLotNo} disabled={isEdit} required
            onChange={(e) => set('jigLotNo', e.target.value)} />
          <Input label="지그명" value={form.jigName} required
            onChange={(e) => set('jigName', e.target.value)} />
          <ComCodeSelect label="지그유형" groupCode="JIG TYPE" includeAll={false}
            value={form.jigType} onChange={(v) => set('jigType', v)} />
          <ComCodeSelect label="지그상태" groupCode="JIG STATUS" includeAll={false}
            value={form.jigStatus} onChange={(v) => set('jigStatus', v)} />
          <ComCodeSelect label="사용상태" groupCode="USE STATUS" includeAll={false}
            value={form.useStatus} onChange={(v) => set('useStatus', v)} />
          <LineSelect label="라인" value={form.lineCode} onChange={(v) => set('lineCode', v)} />
          <ProcessSelect label="공정" value={form.workstageCode}
            onChange={(v) => set('workstageCode', v)} />
          <Input label="설비코드" value={form.machineCode}
            onChange={(e) => set('machineCode', e.target.value)} />
          <PartSearchField label="품목코드" value={form.itemCode}
            onChange={(e) => set('itemCode', e.target.value)} />
          <Input label="지그모델명" value={form.jigModelName}
            onChange={(e) => set('jigModelName', e.target.value)} />
          <Input label="지그규격" value={form.jigSpec}
            onChange={(e) => set('jigSpec', e.target.value)} />
          <ComCodeSelect label="T/B" groupCode="PCB ITEM" includeAll={false}
            value={form.pcbItem} onChange={(v) => set('pcbItem', v)} />
          <ComCodeSelect label="솔더타입" groupCode="SOLDER TYPE" includeAll={false}
            value={form.solderType} onChange={(v) => set('solderType', v)} />
          <ComCodeSelect label="취득유형" groupCode="ACQUISITION TYPE" includeAll={false}
            value={form.acquisitionType} onChange={(v) => set('acquisitionType', v)} />
          <div>
            <label className="mb-1 block font-medium text-text">취득일자</label>
            <DateFilter value={form.acquisitionDate}
              onChange={(v) => set('acquisitionDate', v)} />
          </div>
          <Input label="한계수명" type="number" value={form.breakValue}
            onChange={(e) => set('breakValue', e.target.value)} />
          <Input label="사용횟수" type="number" value={form.hitValue}
            onChange={(e) => set('hitValue', e.target.value)} />
          <Input label="최소장력" type="number" value={form.minTension}
            onChange={(e) => set('minTension', e.target.value)} />
          <Input label="최대장력" type="number" value={form.maxTension}
            onChange={(e) => set('maxTension', e.target.value)} />
          <ComCodeSelect label="장력측정여부" groupCode="USE TPM YN" includeAll={false}
            value={form.tensionCheckYn} onChange={(v) => set('tensionCheckYn', v)} />
          <ComCodeSelect label="자주보전사용" groupCode="USE TPM YN" includeAll={false}
            value={form.useTpmYn} onChange={(v) => set('useTpmYn', v)} />
          <Input label="고객코드" value={form.customerCode}
            onChange={(e) => set('customerCode', e.target.value)} />
          <Input label="제작처" value={form.supplierCode}
            onChange={(e) => set('supplierCode', e.target.value)} />
          <Input label="자재위치" value={form.locationAddress}
            onChange={(e) => set('locationAddress', e.target.value)} />
          <Input label="관리설명" value={form.managementCommnets}
            onChange={(e) => set('managementCommnets', e.target.value)} />
        </div>
      </div>

      <footer className="flex justify-end gap-2 border-t border-border p-4">
        <Button variant="secondary" onClick={onClose}>취소</Button>
        <Button onClick={save} disabled={saving}>
          <Save className="mr-1 h-4 w-4" />{saving ? '저장 중...' : '저장'}
        </Button>
      </footer>
    </aside>
  );
}
