"use client";

/**
 * @file src/app/(authenticated)/quality/iqc-history/components/IqcHistoryFormPanel.tsx
 * @description IQC 검사이력 등록·수정 폼 — PB w_qc_iqc_inspect_history_master 입력 영역 이식
 *
 * 초보자 가이드:
 * 1. **검사일시·검사항번은 폼에 없다.** 등록 시 서버가 지금 시각과
 *    SEQ_IQC_INSPECT_HISTORY_SEQ 채번값을 넣는다 — 그 둘이 이 행의 키다.
 *    수정할 때는 헤더에 읽기 전용으로 보여준다.
 * 2. 코드성 값은 기초코드 선택이다. 자유 입력은 모델명·LOT·검사자·비고뿐이다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { Save, X } from 'lucide-react';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Input } from '@/components/ui';
import api from '@/services/api';
import type { IqcInspectHistoryRow } from '../../pid-columns';

export interface IqcHistoryForm {
  /** 수정일 때만 채워진다 (읽기 전용) */
  inspectDate: string;
  /** 서버가 내려준 불투명 키. 그대로 되돌려 보낸다 — ISO 로 바꾸면 시간대가 밀린다. */
  inspectDateKey: string;
  inspectSequence: number | null;

  modelName: string;
  modelSuffix: string;
  itemCode: string;
  itemClass: string;
  lotNo: string;
  defectCode: string;
  inspectType: string;
  inspectResult: string;
  badReasonCode: string;
  supplierCode: string;
  inspector: string;
  inspectorName: string;
  comments: string;
  inspectQty: string;
  defectQty: string;
}

const text = (value: unknown) => (value == null ? '' : String(value));

export const emptyIqcHistoryForm = (): IqcHistoryForm => ({
  inspectDate: '', inspectDateKey: '', inspectSequence: null,
  modelName: '', modelSuffix: '*', itemCode: '', itemClass: '', lotNo: '',
  defectCode: '', inspectType: '', inspectResult: 'P', badReasonCode: '',
  supplierCode: '', inspector: '', inspectorName: '', comments: '',
  inspectQty: '0', defectQty: '0',
});

export const toIqcHistoryForm = (row: IqcInspectHistoryRow): IqcHistoryForm => ({
  inspectDate: String(row.inspectDate),
  inspectDateKey: row.inspectDateKey,
  inspectSequence: row.inspectSequence,
  modelName: text(row.modelName),
  modelSuffix: text(row.modelSuffix),
  itemCode: text(row.itemCode),
  itemClass: text(row.itemClass),
  lotNo: text(row.lotNo),
  defectCode: text(row.defectCode),
  inspectType: text(row.inspectType),
  inspectResult: text(row.inspectResult),
  badReasonCode: text(row.badReasonCode),
  supplierCode: text(row.supplierCode),
  inspector: text(row.inspector),
  inspectorName: text(row.inspectorName),
  comments: text(row.comments),
  inspectQty: text(row.inspectQty),
  defectQty: text(row.defectQty),
});

interface Props {
  mode: 'create' | 'edit';
  initialForm: IqcHistoryForm;
  onClose: () => void;
  onSaved: () => void;
}

const optional = (value: string) => (value.trim() === '' ? undefined : value.trim());
const optionalNum = (value: string) => (value.trim() === '' ? undefined : Number(value));

export default function IqcHistoryFormPanel({ mode, initialForm, onClose, onSaved }: Props) {
  const [form, setForm] = useState<IqcHistoryForm>(initialForm);
  const [busy, setBusy] = useState(false);
  const set = <K extends keyof IqcHistoryForm>(key: K, value: IqcHistoryForm[K]) =>
    setForm((prev) => ({ ...prev, [key]: value }));

  const save = useCallback(async () => {
    setBusy(true);
    const body = {
      modelName: optional(form.modelName),
      modelSuffix: optional(form.modelSuffix),
      itemCode: optional(form.itemCode),
      itemClass: optional(form.itemClass),
      lotNo: optional(form.lotNo),
      defectCode: optional(form.defectCode),
      inspectType: optional(form.inspectType),
      inspectResult: optional(form.inspectResult),
      badReasonCode: optional(form.badReasonCode),
      supplierCode: optional(form.supplierCode),
      inspector: optional(form.inspector),
      inspectorName: optional(form.inspectorName),
      comments: optional(form.comments),
      inspectQty: optionalNum(form.inspectQty),
      defectQty: optionalNum(form.defectQty),
    };
    try {
      if (mode === 'create') {
        const response = await api.post('/quality/iqc-history', body);
        toast.success(`검사항번 ${response.data?.data?.inspectSequence ?? ''}번 등록`);
      } else {
        await api.put('/quality/iqc-history', {
          ...body,
          inspectDateKey: form.inspectDateKey,
          inspectSequence: form.inspectSequence,
        });
        toast.success('수정되었습니다.');
      }
      onSaved();
    } catch {
      toast.error('저장에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [form, mode, onSaved]);

  return (
    <aside className="flex w-96 shrink-0 flex-col border-l border-border bg-surface">
      <header className="flex items-center justify-between border-b border-border p-4">
        <div>
          <b className="text-text">{mode === 'create' ? '검사이력 등록' : '검사이력 수정'}</b>
          {mode === 'edit' && (
            <div className="text-xs text-text-muted">
              검사항번 {form.inspectSequence} · {String(form.inspectDate).slice(0, 19).replace('T', ' ')}
            </div>
          )}
          {mode === 'create' && (
            <div className="text-xs text-text-muted">검사일시·항번은 서버가 채웁니다</div>
          )}
        </div>
        <button type="button" onClick={onClose} aria-label="닫기">
          <X className="h-4 w-4 text-text-muted" />
        </button>
      </header>

      <div className="flex-1 space-y-3 overflow-auto p-4">
        <label className="block text-sm">
          <span className="text-text-muted">모델명</span>
          <Input value={form.modelName} onChange={(e) => set('modelName', e.target.value)} />
        </label>
        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">서픽스</span>
            <Input value={form.modelSuffix}
              onChange={(e) => set('modelSuffix', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">품목코드</span>
            <Input value={form.itemCode} onChange={(e) => set('itemCode', e.target.value)} />
          </label>
        </div>
        <label className="block text-sm">
          <span className="text-text-muted">품목분류</span>
          <ComCodeSelect groupCode="ITEM CLASS" includeAll={false}
            value={form.itemClass} onChange={(v) => set('itemClass', v)} />
        </label>
        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">LOT번호</span>
            <Input value={form.lotNo} onChange={(e) => set('lotNo', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">결함코드</span>
            <Input value={form.defectCode} onChange={(e) => set('defectCode', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">판정</span>
            <ComCodeSelect groupCode="INSPECT RESULT" includeAll={false}
              value={form.inspectResult} onChange={(v) => set('inspectResult', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">불량원인</span>
            <ComCodeSelect groupCode="BAD REASON CODE" includeAll={false}
              value={form.badReasonCode} onChange={(v) => set('badReasonCode', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">검사유형</span>
            <ComCodeSelect groupCode="INSPECT METHOD" includeAll={false}
              value={form.inspectType} onChange={(v) => set('inspectType', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">검사수량</span>
            <Input type="number" value={form.inspectQty}
              onChange={(e) => set('inspectQty', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">결함수량</span>
            <Input type="number" value={form.defectQty}
              onChange={(e) => set('defectQty', e.target.value)} />
          </label>
        </div>
        <label className="block text-sm">
          <span className="text-text-muted">공급처</span>
          <SupplierSelect includeAll={false} value={form.supplierCode}
            onChange={(v) => set('supplierCode', v)} />
        </label>
        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">검사자</span>
            <Input value={form.inspector} onChange={(e) => set('inspector', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">검사자명</span>
            <Input value={form.inspectorName}
              onChange={(e) => set('inspectorName', e.target.value)} />
          </label>
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
