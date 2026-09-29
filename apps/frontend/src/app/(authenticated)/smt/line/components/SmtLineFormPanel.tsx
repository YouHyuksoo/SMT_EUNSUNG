"use client";

/**
 * @file src/app/(authenticated)/smt/line/components/SmtLineFormPanel.tsx
 * @description SMT 라인·설비 등록·수정 폼 — PB w_smt_line_master 입력 영역 이식
 *
 * 초보자 가이드:
 * 1. **라인코드와 설비코드는 키다.** 수정 모드에서 잠긴다 — 열어두면 UPDATE 의
 *    WHERE 가 다른 행을 가리키고 화면에는 "찾을 수 없습니다" 만 나온다.
 * 2. **설비명은 NOT NULL 이다.** 비우면 저장이 안 되므로 폼에서 먼저 막는다.
 * 3. **LINE_SHAFT_TYPE 은 없다.** 39행 전부 NULL 이고 코드표도 없어 다루지 않는다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { Save, X } from 'lucide-react';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import UseYnSelect from '@/components/shared/UseYnSelect';
import { Button, Input } from '@/components/ui';
import api from '@/services/api';
import type { SmtLineRow } from '../../types';

export interface SmtLineForm {
  lineCode: string;
  machine: string;
  lineName: string;
  machineName: string;
  lineDivision: string;
  lineStatus: string;
  machineGroup: string;
  showTableYn: string;
}

const text = (value: unknown) => (value == null ? '' : String(value));

export const emptySmtLineForm = (): SmtLineForm => ({
  lineCode: '', machine: '', lineName: '', machineName: '',
  lineDivision: '', lineStatus: '', machineGroup: '', showTableYn: 'Y',
});

export const toSmtLineForm = (row: SmtLineRow): SmtLineForm => ({
  lineCode: row.lineCode,
  machine: row.machine,
  lineName: text(row.lineName),
  machineName: text(row.machineName),
  lineDivision: text(row.lineDivision),
  lineStatus: text(row.lineStatus),
  machineGroup: text(row.machineGroup),
  showTableYn: text(row.showTableYn) || 'Y',
});

interface Props {
  mode: 'create' | 'edit';
  initialForm: SmtLineForm;
  onClose: () => void;
  onSaved: () => void;
}

const optional = (value: string) => (value.trim() === '' ? undefined : value.trim());

export default function SmtLineFormPanel({ mode, initialForm, onClose, onSaved }: Props) {
  const [form, setForm] = useState<SmtLineForm>(initialForm);
  const [busy, setBusy] = useState(false);
  const edit = mode === 'edit';
  const set = <K extends keyof SmtLineForm>(key: K, value: SmtLineForm[K]) =>
    setForm((prev) => ({ ...prev, [key]: value }));

  const save = useCallback(async () => {
    if (form.lineCode.trim() === '' || form.machine.trim() === '') {
      toast.error('라인코드와 설비코드를 입력하세요.');
      return;
    }
    if (form.machineName.trim() === '') {
      toast.error('설비명은 필수입니다.');
      return;
    }
    setBusy(true);
    const body = {
      lineCode: form.lineCode.trim(),
      machine: form.machine.trim(),
      machineName: form.machineName.trim(),
      lineName: optional(form.lineName),
      lineDivision: optional(form.lineDivision),
      lineStatus: optional(form.lineStatus),
      machineGroup: optional(form.machineGroup),
      showTableYn: form.showTableYn === 'N' ? 'N' : 'Y',
    };
    try {
      if (edit) await api.put('/smt/line', body);
      else await api.post('/smt/line', body);
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
          <b className="text-text">{edit ? '라인·설비 수정' : '라인·설비 등록'}</b>
          {edit && (
            <div className="text-xs text-text-muted">
              {form.lineCode} / {form.machine} · 키는 바꿀 수 없습니다
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
            <span className="text-text-muted">설비코드 *</span>
            <Input value={form.machine} disabled={edit}
              onChange={(e) => set('machine', e.target.value)} />
          </label>
        </div>
        <label className="block text-sm">
          <span className="text-text-muted">라인명</span>
          <Input value={form.lineName} onChange={(e) => set('lineName', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">설비명 *</span>
          <Input value={form.machineName}
            onChange={(e) => set('machineName', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">라인상태</span>
          <ComCodeSelect groupCode="LINE STATUS" includeAll={false}
            value={form.lineStatus} onChange={(v) => set('lineStatus', v)} />
        </label>
        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">라인구분</span>
            <Input value={form.lineDivision}
              onChange={(e) => set('lineDivision', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">설비그룹</span>
            <Input value={form.machineGroup}
              onChange={(e) => set('machineGroup', e.target.value)} />
          </label>
        </div>
        <label className="block text-sm">
          <span className="text-text-muted">테이블 표시</span>
          <UseYnSelect includeAll={false} value={form.showTableYn}
            onChange={(v) => set('showTableYn', v)} />
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
