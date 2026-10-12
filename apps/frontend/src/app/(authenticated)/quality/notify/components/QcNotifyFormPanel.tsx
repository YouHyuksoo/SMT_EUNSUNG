"use client";

/**
 * @file src/app/(authenticated)/quality/notify/components/QcNotifyFormPanel.tsx
 * @description 품질이상발생 등록·수정 폼 — PB w_qc_notify_master 입력 영역 이식
 *
 * 초보자 가이드:
 * 1. **발생일자·발생항번은 폼에 없다.** 등록 시 서버가 오늘 날짜와
 *    SEQ_QC_NOTIFY_SEQUENCE 채번값을 넣는다 — 그 둘이 키다.
 * 2. **조치상태·완료여부도 폼에 없다.** 목록의 완료처리 버튼으로 바꾼다 (별도 API).
 * 3. **첨부파일은 이관 범위 밖이라 폼에 없다.**
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { Save, X } from 'lucide-react';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import LineSelect from '@/components/shared/LineSelect';
import ProcessSelect from '@/components/shared/ProcessSelect';
import { Button, Input } from '@/components/ui';
import api from '@/services/api';
import type { QcNotifyRow } from '../../notify-columns';
import PartSearchField from '@/components/shared/PartSearchField';

export interface QcNotifyForm {
  /** 수정일 때만 채워진다 (읽기 전용) */
  actionDate: string;
  notifySequence: number | null;

  modelName: string;
  lineCode: string;
  workstageCode: string;
  machineCode: string;
  itemCode: string;
  runNo: string;
  grade: string;
  badReasonCode: string;
  detectLocation: string;
  materialMaker: string;
  locationInfo: string;
  badDescription: string;
  inspectCharger: string;
  inspectManager: string;
  departmentCode: string;
  lineStatusNotify: string;
  comments: string;
  qcComments: string;
  inspectQty: string;
  inspectBadQty: string;
  startTime: string;
  endTime: string;
}

const text = (value: unknown) => (value == null ? '' : String(value));
const timeInput = (value: unknown) =>
  (value ? String(value).slice(0, 16).replace(' ', 'T') : '');

export const emptyQcNotifyForm = (): QcNotifyForm => ({
  actionDate: '', notifySequence: null,
  modelName: '', lineCode: '', workstageCode: '', machineCode: '', itemCode: '',
  runNo: '', grade: '', badReasonCode: '', detectLocation: '', materialMaker: '',
  locationInfo: '', badDescription: '', inspectCharger: '', inspectManager: '',
  departmentCode: '', lineStatusNotify: '', comments: '', qcComments: '',
  inspectQty: '0', inspectBadQty: '0', startTime: '', endTime: '',
});

export const toQcNotifyForm = (row: QcNotifyRow): QcNotifyForm => ({
  actionDate: String(row.actionDate).slice(0, 10),
  notifySequence: row.notifySequence,
  modelName: text(row.modelName),
  lineCode: text(row.lineCode),
  workstageCode: text(row.workstageCode),
  machineCode: text(row.machineCode),
  itemCode: text(row.itemCode),
  runNo: text(row.runNo),
  grade: text(row.grade),
  badReasonCode: text(row.badReasonCode),
  detectLocation: text(row.detectLocation),
  materialMaker: text(row.materialMaker),
  locationInfo: text(row.locationInfo),
  badDescription: text(row.badDescription),
  inspectCharger: text(row.inspectCharger),
  inspectManager: text(row.inspectManager),
  departmentCode: text(row.departmentCode),
  lineStatusNotify: text(row.lineStatusNotify),
  comments: text(row.comments),
  qcComments: text(row.qcComments),
  inspectQty: text(row.inspectQty),
  inspectBadQty: text(row.inspectBadQty),
  startTime: timeInput(row.startTime),
  endTime: timeInput(row.endTime),
});

interface Props {
  mode: 'create' | 'edit';
  initialForm: QcNotifyForm;
  onClose: () => void;
  onSaved: () => void;
}

const optional = (value: string) => (value.trim() === '' ? undefined : value.trim());
const optionalNum = (value: string) => (value.trim() === '' ? undefined : Number(value));

export default function QcNotifyFormPanel({ mode, initialForm, onClose, onSaved }: Props) {
  const [form, setForm] = useState<QcNotifyForm>(initialForm);
  const [busy, setBusy] = useState(false);
  const set = <K extends keyof QcNotifyForm>(key: K, value: QcNotifyForm[K]) =>
    setForm((prev) => ({ ...prev, [key]: value }));

  const save = useCallback(async () => {
    if (!form.badDescription.trim()) return toast.error('불량내용을 입력하세요.');
    setBusy(true);
    const body = {
      modelName: optional(form.modelName),
      lineCode: optional(form.lineCode),
      workstageCode: optional(form.workstageCode),
      machineCode: optional(form.machineCode),
      itemCode: optional(form.itemCode),
      runNo: optional(form.runNo),
      grade: optional(form.grade),
      badReasonCode: optional(form.badReasonCode),
      detectLocation: optional(form.detectLocation),
      materialMaker: optional(form.materialMaker),
      locationInfo: optional(form.locationInfo),
      badDescription: optional(form.badDescription),
      inspectCharger: optional(form.inspectCharger),
      inspectManager: optional(form.inspectManager),
      departmentCode: optional(form.departmentCode),
      lineStatusNotify: optional(form.lineStatusNotify),
      comments: optional(form.comments),
      qcComments: optional(form.qcComments),
      inspectQty: optionalNum(form.inspectQty),
      inspectBadQty: optionalNum(form.inspectBadQty),
      startTime: optional(form.startTime),
      endTime: optional(form.endTime),
    };
    try {
      if (mode === 'create') {
        const response = await api.post('/quality/notify', body);
        toast.success(`발생항번 ${response.data?.data?.notifySequence ?? ''}번 등록`);
      } else {
        await api.put('/quality/notify', {
          ...body,
          actionDate: form.actionDate,
          notifySequence: form.notifySequence,
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
          <b className="text-text">
            {mode === 'create' ? '품질이상발생 등록' : '품질이상발생 수정'}
          </b>
          <div className="text-xs text-text-muted">
            {mode === 'edit'
              ? `발생항번 ${form.notifySequence} · ${form.actionDate}`
              : '발생일자·항번은 서버가 채웁니다'}
          </div>
        </div>
        <button type="button" onClick={onClose} aria-label="닫기">
          <X className="h-4 w-4 text-text-muted" />
        </button>
      </header>

      <div className="flex-1 space-y-3 overflow-auto p-4">
        <label className="block text-sm">
          <span className="text-text-muted">불량내용 (필수)</span>
          <Input value={form.badDescription}
            onChange={(e) => set('badDescription', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">모델명</span>
          <Input value={form.modelName} onChange={(e) => set('modelName', e.target.value)} />
        </label>
        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">품목코드</span>
            <PartSearchField value={form.itemCode} onChange={(e) => set('itemCode', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">RUN번호</span>
            <Input value={form.runNo} onChange={(e) => set('runNo', e.target.value)} />
          </label>
        </div>
        <label className="block text-sm">
          <span className="text-text-muted">라인</span>
          <LineSelect value={form.lineCode} onChange={(v) => set('lineCode', v)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">공정</span>
          <ProcessSelect value={form.workstageCode}
            onChange={(v) => set('workstageCode', v)} />
        </label>
        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">설비코드</span>
            <Input value={form.machineCode}
              onChange={(e) => set('machineCode', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">등급</span>
            <ComCodeSelect groupCode="GRADE" includeAll={false}
              value={form.grade} onChange={(v) => set('grade', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">불량원인</span>
            <ComCodeSelect groupCode="BAD REASON CODE" includeAll={false}
              value={form.badReasonCode} onChange={(v) => set('badReasonCode', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">발견장소</span>
            <ComCodeSelect groupCode="DETECT LOCATION" includeAll={false}
              value={form.detectLocation} onChange={(v) => set('detectLocation', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">검사수량</span>
            <Input type="number" value={form.inspectQty}
              onChange={(e) => set('inspectQty', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">불량수량</span>
            <Input type="number" value={form.inspectBadQty}
              onChange={(e) => set('inspectBadQty', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">시작시각</span>
            <Input type="datetime-local" value={form.startTime}
              onChange={(e) => set('startTime', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">종료시각</span>
            <Input type="datetime-local" value={form.endTime}
              onChange={(e) => set('endTime', e.target.value)} />
          </label>
        </div>
        <label className="block text-sm">
          <span className="text-text-muted">자재메이커</span>
          <Input value={form.materialMaker}
            onChange={(e) => set('materialMaker', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">위치정보</span>
          <Input value={form.locationInfo}
            onChange={(e) => set('locationInfo', e.target.value)} />
        </label>
        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">검사담당</span>
            <Input value={form.inspectCharger}
              onChange={(e) => set('inspectCharger', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">검사책임</span>
            <Input value={form.inspectManager}
              onChange={(e) => set('inspectManager', e.target.value)} />
          </label>
        </div>
        <label className="block text-sm">
          <span className="text-text-muted">비고</span>
          <Input value={form.comments} onChange={(e) => set('comments', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">QC 의견</span>
          <Input value={form.qcComments} onChange={(e) => set('qcComments', e.target.value)} />
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
