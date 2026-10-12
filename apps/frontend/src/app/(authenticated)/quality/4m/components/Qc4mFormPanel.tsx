"use client";

/**
 * @file src/app/(authenticated)/quality/4m/components/Qc4mFormPanel.tsx
 * @description 4M 이력 등록·수정 폼 — PB w_qc_4m_master 입력 영역 이식
 *
 * 초보자 가이드:
 * 1. **키는 모델명 + 서픽스 + 변경일자**다. 수정할 때 이 셋은 잠긴다 —
 *    바꾸면 UPDATE 의 WHERE 가 안 맞아 저장이 조용히 실패한다.
 * 2. 코드성 값은 기초코드 선택이다. 자유 입력은 모델명·리비전·변경점 본문뿐이다.
 * 3. 첨부파일은 이관 범위 밖이라 폼에 없다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { Save, X } from 'lucide-react';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import ProcessSelect from '@/components/shared/ProcessSelect';
import { Button, Input } from '@/components/ui';
import api from '@/services/api';
import type { Qc4mRow } from '../../qc-columns';

export interface Qc4mForm {
  modelName: string;
  modelSuffix: string;
  ecoDate: string;
  applyDate: string;
  firstProductDate: string;
  lastProductDate: string;
  workstageCode: string;
  ecoStatus: string;
  ecoType: string;
  ecoDivision: string;
  pcbItem: string;
  hwRevision: string;
  swRevision: string;
  ecoPoint: string;
  ecoComments: string;
  ecoReason: string;
}

const today = () => new Date().toISOString().slice(0, 10);
const text = (value: unknown) => (value == null ? '' : String(value));
const dateInput = (value: unknown) => (value ? String(value).slice(0, 10) : '');

export const emptyQc4mForm = (): Qc4mForm => ({
  modelName: '', modelSuffix: '*', ecoDate: today(), applyDate: '',
  firstProductDate: '', lastProductDate: '',
  workstageCode: '', ecoStatus: '', ecoType: '', ecoDivision: '', pcbItem: '',
  hwRevision: '', swRevision: '', ecoPoint: '', ecoComments: '', ecoReason: '',
});

export const toQc4mForm = (row: Qc4mRow): Qc4mForm => ({
  modelName: text(row.modelName),
  modelSuffix: text(row.modelSuffix),
  ecoDate: dateInput(row.ecoDate),
  applyDate: dateInput(row.applyDate),
  firstProductDate: dateInput(row.firstProductDate),
  lastProductDate: dateInput(row.lastProductDate),
  workstageCode: text(row.workstageCode),
  ecoStatus: text(row.ecoStatus),
  ecoType: text(row.ecoType),
  ecoDivision: text(row.ecoDivision),
  pcbItem: text(row.pcbItem),
  hwRevision: text(row.hwRevision),
  swRevision: text(row.swRevision),
  ecoPoint: text(row.ecoPoint),
  ecoComments: text(row.ecoComments),
  ecoReason: text(row.ecoReason),
});

interface Props {
  mode: 'create' | 'edit';
  initialForm: Qc4mForm;
  onClose: () => void;
  onSaved: () => void;
}

const optional = (value: string) => (value.trim() === '' ? undefined : value.trim());

export default function Qc4mFormPanel({ mode, initialForm, onClose, onSaved }: Props) {
  const [form, setForm] = useState<Qc4mForm>(initialForm);
  const [busy, setBusy] = useState(false);
  const set = <K extends keyof Qc4mForm>(key: K, value: Qc4mForm[K]) =>
    setForm((prev) => ({ ...prev, [key]: value }));
  const locked = mode === 'edit';

  const save = useCallback(async () => {
    if (!form.modelName.trim()) return toast.error('모델명을 입력하세요.');
    if (!form.modelSuffix.trim()) return toast.error('서픽스를 입력하세요.');
    if (!form.ecoDate) return toast.error('변경일자를 입력하세요.');
    setBusy(true);
    const body = {
      modelName: form.modelName.trim(),
      modelSuffix: form.modelSuffix.trim(),
      ecoDate: form.ecoDate,
      applyDate: optional(form.applyDate),
      firstProductDate: optional(form.firstProductDate),
      lastProductDate: optional(form.lastProductDate),
      workstageCode: optional(form.workstageCode),
      ecoStatus: optional(form.ecoStatus),
      ecoType: optional(form.ecoType),
      ecoDivision: optional(form.ecoDivision),
      pcbItem: optional(form.pcbItem),
      hwRevision: optional(form.hwRevision),
      swRevision: optional(form.swRevision),
      ecoPoint: optional(form.ecoPoint),
      ecoComments: optional(form.ecoComments),
      ecoReason: optional(form.ecoReason),
    };
    try {
      if (mode === 'create') await api.post('/quality/4m', body);
      else await api.put('/quality/4m', body);
      toast.success(mode === 'create' ? '등록되었습니다.' : '수정되었습니다.');
      onSaved();
    } catch {
      toast.error(mode === 'create'
        ? '같은 변경일자의 이력이 이미 있습니다.'
        : '저장에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [form, mode, onSaved]);

  return (
    <aside className="flex w-96 shrink-0 flex-col border-l border-border bg-surface">
      <header className="flex items-center justify-between border-b border-border p-4">
        <b className="text-text">{mode === 'create' ? '4M 이력 등록' : '4M 이력 수정'}</b>
        <button type="button" onClick={onClose} aria-label="닫기">
          <X className="h-4 w-4 text-text-muted" />
        </button>
      </header>

      <div className="flex-1 space-y-3 overflow-auto p-4">
        <label className="block text-sm">
          <span className="text-text-muted">모델명</span>
          <Input value={form.modelName} disabled={locked}
            onChange={(e) => set('modelName', e.target.value)} />
        </label>
        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">서픽스</span>
            <Input value={form.modelSuffix} disabled={locked}
              onChange={(e) => set('modelSuffix', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">변경일자</span>
            <Input type="date" value={form.ecoDate} disabled={locked}
              onChange={(e) => set('ecoDate', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">4M 구분</span>
            <ComCodeSelect groupCode="ECO DIVISION" includeAll={false}
              value={form.ecoDivision} onChange={(v) => set('ecoDivision', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">변경유형</span>
            <ComCodeSelect groupCode="ECO TYPE" includeAll={false}
              value={form.ecoType} onChange={(v) => set('ecoType', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">진행상태</span>
            <ComCodeSelect groupCode="ECO STATUS" includeAll={false}
              value={form.ecoStatus} onChange={(v) => set('ecoStatus', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">T/B</span>
            <ComCodeSelect groupCode="PCB ITEM" includeAll={false}
              value={form.pcbItem} onChange={(v) => set('pcbItem', v)} />
          </label>
        </div>
        <label className="block text-sm">
          <span className="text-text-muted">공정</span>
          <ProcessSelect value={form.workstageCode}
            onChange={(v) => set('workstageCode', v)} />
        </label>
        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">적용일자</span>
            <Input type="date" value={form.applyDate}
              onChange={(e) => set('applyDate', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">초생산일</span>
            <Input type="date" value={form.firstProductDate}
              onChange={(e) => set('firstProductDate', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">최종생산일</span>
            <Input type="date" value={form.lastProductDate}
              onChange={(e) => set('lastProductDate', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">H/W Rev</span>
            <Input value={form.hwRevision} onChange={(e) => set('hwRevision', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">S/W Rev</span>
            <Input value={form.swRevision} onChange={(e) => set('swRevision', e.target.value)} />
          </label>
        </div>
        <label className="block text-sm">
          <span className="text-text-muted">변경점</span>
          <Input value={form.ecoPoint} onChange={(e) => set('ecoPoint', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">변경사유</span>
          <Input value={form.ecoReason} onChange={(e) => set('ecoReason', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">변경내용</span>
          <Input value={form.ecoComments} onChange={(e) => set('ecoComments', e.target.value)} />
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
