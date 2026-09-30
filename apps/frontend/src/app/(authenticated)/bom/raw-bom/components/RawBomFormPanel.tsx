"use client";

/**
 * @file src/app/(authenticated)/bom/raw-bom/components/RawBomFormPanel.tsx
 * @description 원단위BOM 수정 우측 폼 패널 — PB w_des_raw_bom_master 의 dw_1 편집 이식
 *
 * 초보자 가이드:
 * 1. **수정만 한다**: PB 화면에 등록·삭제가 없으므로 여기에도 없다.
 * 2. **키 잠금**: 모품목/자품목/시작일자는 PK 라 바꿀 수 없다.
 * 3. **필수값**: 반제품전개·품목유형·구입유형·단위수량·공정·정렬순번·종료일자는
 *    ID_ENG_BOM 의 NOT NULL 컬럼이다. 종료일자는 시작일자보다 빠를 수 없다.
 * 4. **공정 '*'**: 현재 BOM 행은 공정 기준정보에 없는 '*' 를 쓴다. 목록에 없는 현재값은
 *    그대로 선택지에 넣어 두어 저장 시 값이 비지 않게 한다.
 * 5. **대상이 바뀌면 remount**: 부모가 `key` 를 바꿔 새로 마운트한다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Save } from 'lucide-react';
import { Button, Input, Select } from '@/components/ui';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateFilter from '@/components/shared/DateFilter';
import { useProcessOptions } from '@/hooks/useMasterOptions';
import api from '@/services/api';
import type { RawBomForm } from '../types';

interface Props {
  initialForm: RawBomForm;
  onClose: () => void;
  onSave: () => void;
  animate?: boolean;
  onDirtyChange?: (dirty: boolean) => void;
}

const isNonNegative = (value: string) => value.trim() !== '' && Number.isFinite(Number(value)) && Number(value) >= 0;

export default function RawBomFormPanel({
  initialForm, onClose, onSave, animate = true, onDirtyChange,
}: Props) {
  const [form, setForm] = useState<RawBomForm>(initialForm);
  const [saving, setSaving] = useState(false);
  const { options: processOptions, isLoading: processLoading } = useProcessOptions();

  const workstageOptions = useMemo(() => {
    const current = initialForm.workstageCode;
    if (!current || processOptions.some(o => o.value === current)) return processOptions;
    return [{ value: current, label: current }, ...processOptions];
  }, [initialForm.workstageCode, processOptions]);

  const set = useCallback((key: keyof RawBomForm, value: string) => {
    setForm(prev => {
      const next = { ...prev, [key]: value };
      onDirtyChange?.(JSON.stringify(next) !== JSON.stringify(initialForm));
      return next;
    });
  }, [initialForm, onDirtyChange]);

  const error = useMemo(() => {
    if (!form.assyExplosionYn || !form.itemType || !form.lineType) return '반제품전개·품목유형·구입유형은 필수입니다';
    if (!isNonNegative(form.itemUnitQty)) return '단위수량은 0 이상 숫자여야 합니다';
    if (form.itemUnitQtyExt.trim() !== '' && !isNonNegative(form.itemUnitQtyExt)) return '단위수량(기타)은 0 이상 숫자여야 합니다';
    if (!form.workstageCode) return '공정은 필수입니다';
    if (form.sortSequence.trim() === '' || !Number.isFinite(Number(form.sortSequence))) return '정렬순번은 숫자여야 합니다';
    if (!form.dateend) return '종료일자는 필수입니다';
    if (form.dateend < form.dateset) return '종료일자는 시작일자보다 빠를 수 없습니다';
    return null;
  }, [form]);

  const handleSubmit = useCallback(async () => {
    if (error) { toast.error(error); return; }
    setSaving(true);
    try {
      await api.put('/bom/raw-bom', {
        parentItemCode: form.parentItemCode,
        childItemCode: form.childItemCode,
        dateset: form.dateset,
        assyExplosionYn: form.assyExplosionYn,
        itemType: form.itemType,
        lineType: form.lineType,
        itemUnitQty: Number(form.itemUnitQty),
        itemUnitQtyExt: form.itemUnitQtyExt.trim() === '' ? null : Number(form.itemUnitQtyExt),
        workstageCode: form.workstageCode,
        sortSequence: Number(form.sortSequence),
        dateend: form.dateend,
      });
      toast.success('수정했습니다');
      onDirtyChange?.(false);
      onSave();
    } catch (err: unknown) {
      const msg = (err as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(msg || '저장에 실패했습니다');
    } finally {
      setSaving(false);
    }
  }, [error, form, onDirtyChange, onSave]);

  return (
    <div className={`w-[480px] border-l border-border bg-background flex flex-col h-full overflow-hidden shadow-2xl ${animate ? 'animate-slide-in-right' : ''}`}>
      <div className="px-5 py-3 border-b border-border flex items-center justify-between flex-shrink-0">
        <h2 className="text-sm font-bold text-text">원단위BOM 수정</h2>
        <div className="flex items-center gap-2">
          <Button size="sm" variant="secondary" onClick={onClose}>취소</Button>
          <Button size="sm" onClick={handleSubmit} disabled={saving || Boolean(error)}>
            <Save className="mr-1 h-4 w-4" />{saving ? '저장 중' : '저장'}
          </Button>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto p-5">
        <div className="grid grid-cols-2 gap-3">
          <label className="col-span-1 text-sm text-text-muted">모품목코드
            <Input aria-label="모품목코드" value={form.parentItemCode} disabled fullWidth />
          </label>
          <label className="col-span-1 text-sm text-text-muted">자품목코드
            <Input aria-label="자품목코드" value={form.childItemCode} disabled fullWidth />
          </label>
          <label className="col-span-1 text-sm text-text-muted">시작일자
            <Input aria-label="시작일자" value={form.dateset} disabled fullWidth />
          </label>
          <label className="col-span-1 text-sm text-text-muted">종료일자
            <DateFilter value={form.dateend} onChange={v => set('dateend', v)} todayButton={false} />
          </label>
          <label className="col-span-1 text-sm text-text-muted">반제품전개
            <ComCodeSelect groupCode="ASSY EXPLOSION YN" includeAll={false} aria-label="반제품전개"
              value={form.assyExplosionYn} onChange={v => set('assyExplosionYn', v)} fullWidth />
          </label>
          <label className="col-span-1 text-sm text-text-muted">품목유형
            <ComCodeSelect groupCode="ITEM TYPE" includeAll={false} aria-label="품목유형"
              value={form.itemType} onChange={v => set('itemType', v)} fullWidth />
          </label>
          <label className="col-span-1 text-sm text-text-muted">구입유형
            <ComCodeSelect groupCode="LINE TYPE" includeAll={false} aria-label="구입유형"
              value={form.lineType} onChange={v => set('lineType', v)} fullWidth />
          </label>
          <label className="col-span-1 text-sm text-text-muted">공정
            <Select aria-label="공정" options={workstageOptions} value={form.workstageCode}
              onChange={v => set('workstageCode', v)} disabled={processLoading} fullWidth />
          </label>
          <label className="col-span-1 text-sm text-text-muted">단위수량
            <Input aria-label="단위수량" type="number" min={0} step="any" value={form.itemUnitQty}
              onChange={e => set('itemUnitQty', e.target.value)} fullWidth />
          </label>
          <label className="col-span-1 text-sm text-text-muted">단위수량(기타)
            <Input aria-label="단위수량(기타)" type="number" min={0} step="any" value={form.itemUnitQtyExt}
              onChange={e => set('itemUnitQtyExt', e.target.value)} fullWidth />
          </label>
          <label className="col-span-1 text-sm text-text-muted">정렬순번
            <Input aria-label="정렬순번" type="number" value={form.sortSequence}
              onChange={e => set('sortSequence', e.target.value)} fullWidth />
          </label>
        </div>
        {error && <p className="mt-3 text-sm text-red-500">{error}</p>}
      </div>
    </div>
  );
}
