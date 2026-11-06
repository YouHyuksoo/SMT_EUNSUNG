"use client";

/**
 * @file src/app/(authenticated)/quality/temperature/components/TemperatureCheckFormPanel.tsx
 * @description 온습도 이상 점검이력 등록·수정 — PB w_pln_product_tempreture_history_query dw_5 이식
 *
 * 초보자 가이드:
 * 1. **설비는 온도 노드 목록에서 고른다.** 수정할 때는 설비·점검항번이 키라 잠긴다.
 * 2. **이상 시작·종료는 둘 다 넣어야 하고 시작이 종료보다 늦으면 안 된다** (PB 저장 검사).
 * 3. 점검항번·확인일시·등록자는 서버가 채운다. 확인여부를 비우면 대기(W)로 들어간다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Save, X } from 'lucide-react';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import { Button, Input, Select } from '@/components/ui';
import api from '@/services/api';
import type { TemperatureCheckRow, TemperatureNodeRow } from '../../qc-columns';

export interface TemperatureCheckForm {
  machineCode: string;
  /** 수정일 때만 있다 */
  checkSequence: number | null;
  /** datetime-local 값 'YYYY-MM-DDTHH:mm:ss' — 초까지 둔다 (PB 값을 그대로 보존) */
  checkStartDate: string;
  checkEndDate: string;
  ngReasonCode: string;
  actionCode: string;
  confirmYn: string;
  comments: string;
}

const pad = (n: number) => String(n).padStart(2, '0');

/** API 일시 → 로컬(KST) datetime-local 값 (초 포함). 초를 버리면 수정 저장 때 DB 값이 깎인다. */
export function toLocalInput(value: unknown): string {
  if (!value) return '';
  const text = String(value);
  if (/^\d{4}-\d{2}-\d{2}[T ]\d{2}:\d{2}/.test(text) && !/[zZ]|[+-]\d{2}:?\d{2}$/.test(text)) {
    const local = text.replace(' ', 'T').slice(0, 19);
    return local.length === 16 ? `${local}:00` : local;
  }
  const d = new Date(text);
  if (Number.isNaN(d.getTime())) return '';
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`
    + `T${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`;
}

export const emptyTemperatureCheckForm = (
  machineCode = '', startDate: unknown = null,
): TemperatureCheckForm => ({
  machineCode,
  checkSequence: null,
  checkStartDate: toLocalInput(startDate),
  checkEndDate: '',
  ngReasonCode: '',
  actionCode: '',
  confirmYn: 'W',
  comments: '',
});

export const toTemperatureCheckForm = (row: TemperatureCheckRow): TemperatureCheckForm => ({
  machineCode: row.machineCode,
  checkSequence: row.checkSequence,
  checkStartDate: toLocalInput(row.checkStartDate),
  checkEndDate: toLocalInput(row.checkEndDate),
  ngReasonCode: row.ngReasonCode ?? '',
  actionCode: row.actionCode ?? '',
  confirmYn: row.confirmYn ?? '',
  comments: row.comments ?? '',
});

interface Props {
  mode: 'create' | 'edit';
  initialForm: TemperatureCheckForm;
  onClose: () => void;
  onSaved: () => void;
}

export default function TemperatureCheckFormPanel({ mode, initialForm, onClose, onSaved }: Props) {
  const [form, setForm] = useState<TemperatureCheckForm>(initialForm);
  const [busy, setBusy] = useState(false);
  const [nodes, setNodes] = useState<TemperatureNodeRow[]>([]);
  const set = <K extends keyof TemperatureCheckForm>(key: K, value: TemperatureCheckForm[K]) =>
    setForm((prev) => ({ ...prev, [key]: value }));
  const locked = mode === 'edit';

  useEffect(() => {
    let alive = true;
    api.get('/quality/temperature/nodes')
      .then((response) => { if (alive) setNodes(response.data?.data ?? []); })
      .catch(() => { /* 오류 창은 api 인터셉터가 띄운다 */ });
    return () => { alive = false; };
  }, []);

  const nodeOptions = useMemo(() => nodes.map((n) => ({
    value: n.nodeId,
    label: n.machineName && n.machineName !== n.nodeId ? `${n.machineName} (${n.nodeId})` : n.nodeId,
  })), [nodes]);

  const save = useCallback(async () => {
    if (!form.machineCode) return toast.error('설비를 고르세요.');
    if (!form.checkStartDate || !form.checkEndDate) return toast.error('이상 시작·종료일시를 모두 넣으세요.');
    if (form.checkStartDate > form.checkEndDate) return toast.error('이상 시작일시가 종료일시보다 늦습니다.');
    setBusy(true);
    const body = {
      machineCode: form.machineCode,
      checkStartDate: form.checkStartDate,
      checkEndDate: form.checkEndDate,
      ngReasonCode: form.ngReasonCode || undefined,
      actionCode: form.actionCode || undefined,
      confirmYn: form.confirmYn || undefined,
      comments: form.comments.trim() || undefined,
    };
    try {
      if (mode === 'create') {
        const response = await api.post('/quality/temperature/checks', body);
        toast.success(`점검항번 ${response.data?.data?.checkSequence ?? ''}번 등록`);
      } else {
        await api.put('/quality/temperature/checks', { ...body, checkSequence: form.checkSequence });
        toast.success('수정되었습니다.');
      }
      onSaved();
    } catch {
      // 원인은 api 인터셉터의 오류 창이 보여 준다
      toast.error('저장에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [form, mode, onSaved]);

  return (
    <aside className="flex w-96 shrink-0 flex-col border-l border-border bg-surface">
      <header className="flex items-center justify-between border-b border-border p-4">
        <div>
          <b className="text-text">{mode === 'create' ? '이상 점검 등록' : '이상 점검 수정'}</b>
          <div className="text-xs text-text-muted">
            {mode === 'edit' ? `점검항번 ${form.checkSequence}` : '점검항번·확인일시는 서버가 채웁니다'}
          </div>
        </div>
        <button type="button" onClick={onClose} aria-label="닫기">
          <X className="h-4 w-4 text-text-muted" />
        </button>
      </header>

      <div className="flex-1 space-y-3 overflow-auto p-4">
        <label className="block text-sm">
          <span className="text-text-muted">설비 (필수)</span>
          <Select fullWidth options={nodeOptions} value={form.machineCode} disabled={locked}
            placeholder="온도 노드 선택" onChange={(v) => set('machineCode', v)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">이상 시작 (필수)</span>
          <Input fullWidth type="datetime-local" step={1} value={form.checkStartDate}
            onChange={(e) => set('checkStartDate', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">이상 종료 (필수)</span>
          <Input fullWidth type="datetime-local" step={1} value={form.checkEndDate}
            onChange={(e) => set('checkEndDate', e.target.value)} />
        </label>
        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">이상원인</span>
            <ComCodeSelect groupCode="NG REASON CODE" includeAll={false} fullWidth placeholder="선택"
              value={form.ngReasonCode} onChange={(v) => set('ngReasonCode', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">조치</span>
            <ComCodeSelect groupCode="ACTION CODE" includeAll={false} fullWidth placeholder="선택"
              value={form.actionCode} onChange={(v) => set('actionCode', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">확인</span>
            <ComCodeSelect groupCode="CONFIRM YN" includeAll={false} fullWidth placeholder="선택"
              value={form.confirmYn} onChange={(v) => set('confirmYn', v)} />
          </label>
        </div>
        <label className="block text-sm">
          <span className="text-text-muted">조치 내용</span>
          <textarea
            value={form.comments}
            maxLength={1000}
            rows={4}
            onChange={(e) => set('comments', e.target.value)}
            className="w-full rounded-[var(--radius)] border border-gray-400 bg-surface px-3 py-2 text-sm text-text focus:outline-none focus:ring-2 focus:ring-primary dark:border-gray-500"
          />
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
