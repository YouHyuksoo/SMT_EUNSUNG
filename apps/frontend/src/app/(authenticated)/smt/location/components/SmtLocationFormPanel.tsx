"use client";

/**
 * @file src/app/(authenticated)/smt/location/components/SmtLocationFormPanel.tsx
 * @description 위치 등록·수정 폼 — PB w_smt_location_master 입력 영역 이식
 *
 * 키는 라인코드 + 위치코드다. 수정 모드에서 그 둘만 잠긴다 —
 * 설비는 키가 아니라 고칠 수 있다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { Save, X } from 'lucide-react';
import { Button, Input } from '@/components/ui';
import api from '@/services/api';
import { SmtMachineSelect } from '../../components/SmtSelects';
import type { SmtLocationRow } from '../../types';

export interface SmtLocationForm {
  lineCode: string;
  locationCode: string;
  machine: string;
  tableId: string;
  tableNo: string;
  comments: string;
}

const text = (value: unknown) => (value == null ? '' : String(value));

export const emptySmtLocationForm = (): SmtLocationForm => ({
  lineCode: '', locationCode: '', machine: '', tableId: '', tableNo: '', comments: '',
});

export const toSmtLocationForm = (row: SmtLocationRow): SmtLocationForm => ({
  lineCode: row.lineCode,
  locationCode: row.locationCode,
  machine: text(row.machine),
  tableId: text(row.tableId),
  tableNo: text(row.tableNo),
  comments: text(row.comments),
});

interface Props {
  mode: 'create' | 'edit';
  initialForm: SmtLocationForm;
  onClose: () => void;
  onSaved: () => void;
}

const optional = (value: string) => (value.trim() === '' ? undefined : value.trim());

export default function SmtLocationFormPanel({ mode, initialForm, onClose, onSaved }: Props) {
  const [form, setForm] = useState<SmtLocationForm>(initialForm);
  const [busy, setBusy] = useState(false);
  const edit = mode === 'edit';
  const set = <K extends keyof SmtLocationForm>(key: K, value: SmtLocationForm[K]) =>
    setForm((prev) => ({ ...prev, [key]: value }));

  const save = useCallback(async () => {
    if (form.lineCode.trim() === '' || form.locationCode.trim() === '') {
      toast.error('라인코드와 위치코드를 입력하세요.');
      return;
    }
    if (form.machine.trim() === '' || form.tableId.trim() === '') {
      toast.error('설비코드와 테이블문자는 필수입니다.');
      return;
    }
    setBusy(true);
    const body = {
      lineCode: form.lineCode.trim(),
      locationCode: form.locationCode.trim(),
      machine: form.machine.trim(),
      tableId: form.tableId.trim(),
      tableNo: optional(form.tableNo),
      comments: optional(form.comments),
    };
    try {
      if (edit) await api.put('/smt/location', body);
      else await api.post('/smt/location', body);
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
    <aside className="flex w-96 shrink-0 flex-col border-l border-border bg-surface">
      <header className="flex items-center justify-between border-b border-border p-4">
        <div>
          <b className="text-text">{edit ? '위치 수정' : '위치 등록'}</b>
          {edit && (
            <div className="text-xs text-text-muted">
              {form.lineCode} / {form.locationCode} · 키는 바꿀 수 없습니다
            </div>
          )}
        </div>
        <button type="button" onClick={onClose} aria-label="닫기">
          <X className="h-4 w-4 text-text-muted" />
        </button>
      </header>

      <div className="flex-1 space-y-3 overflow-auto p-4">
        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">라인코드 *</span>
            <Input value={form.lineCode} disabled={edit}
              onChange={(e) => set('lineCode', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">위치코드 *</span>
            <Input value={form.locationCode} disabled={edit}
              onChange={(e) => set('locationCode', e.target.value)} />
          </label>
        </div>
        <label className="block text-sm">
          <span className="text-text-muted">설비코드 *</span>
          <SmtMachineSelect value={form.machine} onChange={(v) => set('machine', v)} />
        </label>
        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">테이블문자 *</span>
            <Input value={form.tableId} maxLength={10}
              onChange={(e) => set('tableId', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">테이블번호</span>
            <Input value={form.tableNo} maxLength={10}
              onChange={(e) => set('tableNo', e.target.value)} />
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
