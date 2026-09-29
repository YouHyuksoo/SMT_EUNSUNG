"use client";

/**
 * @file src/app/(authenticated)/jig/sample/components/SampleFormPanel.tsx
 * @description 샘플마스터 등록·수정 우측 폼 패널 — PB w_mcn_sample_master 의 dw_2 이식
 *
 * 초보자 가이드:
 * 1. **등록/수정 공용**: `mode` 하나로 가른다. 컴포넌트를 두 개 만들지 않는다.
 * 2. **키 컬럼 잠금**: 수정일 때 샘플코드·샘플LOT 은 키(XPKIMCN_SAMPLE)라 바꿀 수 없다.
 *    샘플LOT 은 조직 안에서 유일해야 한다(IXIMCN_SAMPLE2) — 중복이면 서버가 409 로 막는다.
 * 3. **PB 기본값**: 등록 시 사용중(U), 라인·공정 '*', 적용일 오늘, 유효 12개월.
 * 4. **감사컬럼 없음**: 등록자·수정자·일시는 서버가 채운다(PB f_set_security_row).
 * 5. 샘플바코드는 스캐너(키보드 방식)로 찍어 넣어도 된다.
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
import type { SampleMasterRow } from '../columns';

export interface SampleForm {
  sampleCode: string;
  sampleLotNo: string;
  sampleName: string;
  sampleType: string;
  sampleSpec: string;
  sampleStatus: string;
  sampleSection: string;
  useStatus: string;
  sampleApplyDate: string;
  validMonths: string;
  lineCode: string;
  workstageCode: string;
  modelName: string;
  sampleBarcode: string;
  locationAddress: string;
  managementCommnets: string;
}

const todayIso = () => new Date().toISOString().slice(0, 10);

/** PB 'INSERT' 분기의 기본값 */
export const emptySampleForm = (): SampleForm => ({
  sampleCode: '', sampleLotNo: '', sampleName: '', sampleType: '', sampleSpec: '',
  sampleStatus: '', sampleSection: '', useStatus: 'U',
  sampleApplyDate: todayIso(), validMonths: '12',
  lineCode: '*', workstageCode: '*', modelName: '',
  sampleBarcode: '', locationAddress: '', managementCommnets: '',
});

export function toSampleForm(row: SampleMasterRow): SampleForm {
  const text = (value: unknown) => (value == null ? '' : String(value));
  return {
    sampleCode: row.sampleCode,
    sampleLotNo: text(row.sampleLotNo),
    sampleName: text(row.sampleName),
    sampleType: text(row.sampleType),
    sampleSpec: text(row.sampleSpec),
    sampleStatus: text(row.sampleStatus),
    sampleSection: text(row.sampleSection),
    useStatus: text(row.useStatus),
    sampleApplyDate: row.sampleApplyDate ? String(row.sampleApplyDate).slice(0, 10) : '',
    validMonths: text(row.validMonths),
    lineCode: text(row.lineCode),
    workstageCode: text(row.workstageCode),
    modelName: text(row.modelName),
    sampleBarcode: text(row.sampleBarcode),
    locationAddress: text(row.locationAddress),
    managementCommnets: text(row.managementCommnets),
  };
}

interface Props {
  mode: 'create' | 'edit';
  initialForm: SampleForm;
  onClose: () => void;
  onSaved: () => void;
}

export default function SampleFormPanel({ mode, initialForm, onClose, onSaved }: Props) {
  const isEdit = mode === 'edit';
  const [form, setForm] = useState<SampleForm>(initialForm);
  const [saving, setSaving] = useState(false);

  const set = useCallback(<K extends keyof SampleForm>(key: K, value: SampleForm[K]) => {
    setForm((prev) => ({ ...prev, [key]: value }));
  }, []);

  const save = useCallback(async () => {
    if (!form.sampleCode.trim()) return toast.error('샘플코드를 입력하세요.');
    if (!form.sampleLotNo.trim()) return toast.error('샘플LOT을 입력하세요.');
    if (!form.sampleName.trim()) return toast.error('샘플명을 입력하세요.');
    if (!form.sampleType) return toast.error('샘플유형을 선택하세요.');
    setSaving(true);
    try {
      const payload = {
        ...form,
        sampleApplyDate: form.sampleApplyDate || undefined,
        validMonths: form.validMonths.trim() === '' ? undefined : Number(form.validMonths),
      };
      if (isEdit) await api.put('/jig/sample', payload);
      else await api.post('/jig/sample', payload);
      toast.success('저장되었습니다.');
      onSaved();
    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : '';
      toast.error(message.includes('409') ? '이미 등록된 샘플코드 또는 샘플LOT 입니다.' : '저장에 실패했습니다.');
    } finally {
      setSaving(false);
    }
  }, [form, isEdit, onSaved]);

  return (
    <aside className="flex h-full w-[480px] shrink-0 flex-col border-l border-border bg-background shadow-xl">
      <header className="flex h-14 items-center justify-between border-b border-border px-5">
        <h2 className="font-bold text-text">{isEdit ? '샘플 수정' : '샘플 등록'}</h2>
        <button type="button" title="닫기" onClick={onClose}>
          <X className="h-5 w-5 text-text-muted" />
        </button>
      </header>

      <div className="flex-1 space-y-3 overflow-y-auto p-5 text-sm">
        <div className="grid grid-cols-2 gap-3">
          <Input label="샘플코드" value={form.sampleCode} disabled={isEdit} required
            onChange={(e) => set('sampleCode', e.target.value)} />
          <Input label="샘플LOT" value={form.sampleLotNo} disabled={isEdit} required
            onChange={(e) => set('sampleLotNo', e.target.value)} />
          <Input label="샘플명" value={form.sampleName} required
            onChange={(e) => set('sampleName', e.target.value)} />
          <ComCodeSelect label="샘플유형" groupCode="SAMPLE TYPE" includeAll={false}
            value={form.sampleType} onChange={(v) => set('sampleType', v)} />
          <Input label="규격" value={form.sampleSpec}
            onChange={(e) => set('sampleSpec', e.target.value)} />
          <ComCodeSelect label="샘플상태" groupCode="SAMPLE STATUS" includeAll={false}
            value={form.sampleStatus} onChange={(v) => set('sampleStatus', v)} />
          <ComCodeSelect label="구역" groupCode="SAMPLE SECTION" includeAll={false}
            value={form.sampleSection} onChange={(v) => set('sampleSection', v)} />
          <ComCodeSelect label="사용상태" groupCode="USE STATUS" includeAll={false}
            value={form.useStatus} onChange={(v) => set('useStatus', v)} />
          <div>
            <label className="mb-1 block font-medium text-text">적용일자</label>
            <DateFilter value={form.sampleApplyDate} onChange={(v) => set('sampleApplyDate', v)} />
          </div>
          <Input label="유효개월" type="number" value={form.validMonths}
            onChange={(e) => set('validMonths', e.target.value)} />
          <LineSelect label="라인" value={form.lineCode} onChange={(v) => set('lineCode', v)} />
          <ProcessSelect label="공정" value={form.workstageCode}
            onChange={(v) => set('workstageCode', v)} />
          <Input label="모델명" value={form.modelName}
            onChange={(e) => set('modelName', e.target.value)} />
          <Input label="샘플바코드 (스캔 가능)" value={form.sampleBarcode}
            onChange={(e) => set('sampleBarcode', e.target.value)} />
          <Input label="보관위치" value={form.locationAddress}
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
