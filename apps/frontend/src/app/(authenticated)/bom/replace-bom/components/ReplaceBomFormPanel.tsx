"use client";

/**
 * @file src/app/(authenticated)/bom/replace-bom/components/ReplaceBomFormPanel.tsx
 * @description 대체품 등록·수정 우측 폼 패널 — PB w_des_replace_bom_master 의 입력부 이식
 *
 * 초보자 가이드:
 * 1. **등록/수정 공용**: `mode` 하나로 가른다. 컴포넌트를 두 개 만들지 않는다.
 * 2. **키 컬럼 잠금**: 수정일 때 상위/구성/대체 품목은 PK 라 바꿀 수 없다(PB 와 동일).
 * 3. **작성 중 보호**: 입력이 있는 상태에서 다른 행을 누르면 유실되므로 `onDirtyChange` 로
 *    부모에 알린다(부모는 useUnsavedGuard 로 확인 모달을 띄운다).
 * 4. **대상이 바뀌면 remount**: 부모가 `key` 를 바꿔 새로 마운트한다. effect 로 state 를
 *    다시 덮어쓰지 않는다(연쇄 렌더 유발).
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { Save } from 'lucide-react';
import { Button, Input } from '@/components/ui';
import DateFilter from '@/components/shared/DateFilter';
import ProcessSelect from '@/components/shared/ProcessSelect';
import api from '@/services/api';
import type { ReplaceForm } from '../types';

interface Props {
  mode: 'create' | 'edit';
  /** 등록 시 BOM 전개 행에서 가져온 초기값, 수정 시 대상 행의 값 */
  initialForm: ReplaceForm;
  onClose: () => void;
  onSave: () => void;
  animate?: boolean;
  onDirtyChange?: (dirty: boolean) => void;
}

export default function ReplaceBomFormPanel({
  mode, initialForm, onClose, onSave, animate = true, onDirtyChange,
}: Props) {
  const isEdit = mode === 'edit';
  const [form, setForm] = useState<ReplaceForm>(initialForm);
  const [saving, setSaving] = useState(false);

  const set = useCallback((key: keyof ReplaceForm, value: string | number) => {
    setForm(prev => {
      const next = { ...prev, [key]: value };
      onDirtyChange?.(JSON.stringify(next) !== JSON.stringify(initialForm));
      return next;
    });
  }, [initialForm, onDirtyChange]);

  const valid = Boolean(
    form.parentItemCode && form.childItemCode && form.replaceItemCode && form.workstageCode,
  );

  const handleSubmit = useCallback(async () => {
    if (!valid) { toast.error('상위/구성/대체 품목과 공정은 필수입니다'); return; }
    setSaving(true);
    try {
      await api.put('/bom/replace', {
        parentItemCode: form.parentItemCode, childItemCode: form.childItemCode,
        replaceItemCode: form.replaceItemCode, workstageCode: form.workstageCode,
        itemUnitQty: Number(form.itemUnitQty),
        dateset: form.dateset || undefined, dateend: form.dateend || undefined,
        bomLocationCode: form.bomLocationCode || undefined,
      });
      toast.success(isEdit ? '수정했습니다' : '등록했습니다');
      onDirtyChange?.(false);
      onSave();
    } catch (error: unknown) {
      const msg = (error as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(msg || '저장에 실패했습니다');
    } finally {
      setSaving(false);
    }
  }, [form, isEdit, onDirtyChange, onSave, valid]);

  return (
    <div className={`w-[480px] border-l border-border bg-background flex flex-col h-full overflow-hidden shadow-2xl ${animate ? 'animate-slide-in-right' : ''}`}>
      <div className="px-5 py-3 border-b border-border flex items-center justify-between flex-shrink-0">
        <h2 className="text-sm font-bold text-text">{isEdit ? '대체품 수정' : '대체품 등록'}</h2>
        <div className="flex items-center gap-2">
          <Button size="sm" variant="secondary" onClick={onClose}>취소</Button>
          <Button size="sm" onClick={handleSubmit} disabled={saving || !valid}>
            <Save className="mr-1 h-4 w-4" />{saving ? '저장 중' : '저장'}
          </Button>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto p-5">
        <div className="grid grid-cols-2 gap-3">
          <label className="col-span-1 text-sm text-text-muted">상위품목(SET)
            <Input aria-label="상위품목" value={form.parentItemCode} onChange={e => set('parentItemCode', e.target.value)} disabled={isEdit} fullWidth />
          </label>
          <label className="col-span-1 text-sm text-text-muted">구성품목
            <Input aria-label="구성품목" value={form.childItemCode} onChange={e => set('childItemCode', e.target.value)} disabled={isEdit} fullWidth />
          </label>
          <label className="col-span-2 text-sm text-text-muted">대체품목
            <Input aria-label="대체품목" value={form.replaceItemCode} onChange={e => set('replaceItemCode', e.target.value)} disabled={isEdit} fullWidth />
          </label>
          <label className="col-span-1 text-sm text-text-muted">공정
            <ProcessSelect aria-label="공정" value={form.workstageCode} onChange={v => set('workstageCode', v)} fullWidth />
          </label>
          <label className="col-span-1 text-sm text-text-muted">단위수량
            <Input aria-label="단위수량" type="number" value={String(form.itemUnitQty)} onChange={e => set('itemUnitQty', Number(e.target.value))} fullWidth />
          </label>
          <label className="col-span-1 text-sm text-text-muted">적용시작
            <DateFilter value={form.dateset} onChange={v => set('dateset', v)} todayButton={false} />
          </label>
          <label className="col-span-1 text-sm text-text-muted">적용종료
            <DateFilter value={form.dateend} onChange={v => set('dateend', v)} todayButton={false} />
          </label>
          <label className="col-span-2 text-sm text-text-muted">BOM 위치
            <Input aria-label="BOM 위치" value={form.bomLocationCode} onChange={e => set('bomLocationCode', e.target.value)} fullWidth />
          </label>
        </div>
      </div>
    </div>
  );
}
