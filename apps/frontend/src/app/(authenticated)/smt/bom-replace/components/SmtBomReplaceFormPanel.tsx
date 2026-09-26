"use client";

/**
 * @file src/app/(authenticated)/smt/bom-replace/components/SmtBomReplaceFormPanel.tsx
 * @description 대체 BOM 등록·수정 폼 — PB w_smt_bom_replace_master 입력 영역 이식
 *
 * 초보자 가이드:
 * 1. **키 다섯 컬럼은 수정 모드에서 잠긴다** — 상위품목·원품목·대체품목·라인·위치코드.
 *    하나라도 열어두면 UPDATE 의 WHERE 가 다른 행을 가리킨다.
 * 2. **적용시작·적용종료·소요량·순번·품목유형·라인유형은 NOT NULL 이다.**
 *    비우면 DB 가 막으므로 폼에서 먼저 막는다.
 *    공정코드도 NOT NULL 이지만 이 DB 는 28,453행 전부 '*' 라 폼에서 받지 않고
 *    서버가 '*' 를 넣는다 ('WORKSTAGE CODE' 코드표 자체가 없다).
 * 3. **테이블문자는 코드표가 없다.** 위치 생성기가 만드는 값(A, B, C …)이라
 *    셀렉터가 아니라 텍스트로 받는다. 'TABLE ID' 코드표는 이 DB 에 없다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { Save, X } from 'lucide-react';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import { Button, Input } from '@/components/ui';
import api from '@/services/api';
import { SmtMachineSelect, SmtModelSelect, SmtPcbItemSelect } from '../../components/SmtSelects';
import type { SmtBomReplaceRow } from '../../types';

export interface SmtBomReplaceForm {
  parentItemCode: string;
  childItemCode: string;
  replaceItemCode: string;
  lineCode: string;
  locationCode: string;
  dateSet: string;
  dateEnd: string;
  itemUnitQty: string;
  sortSequence: string;
  itemType: string;
  lineType: string;
  machine: string;
  modelName: string;
  tableId: string;
  pcbItem: string;
  revision: string;
  feederShaft: string;
  smtModelName: string;
  comments: string;
  bomLevel: string;
}

const text = (value: unknown) => (value == null ? '' : String(value));
const day = (value: unknown) => (value ? String(value).slice(0, 10) : '');
const today = () => new Date().toISOString().slice(0, 10);

export const emptySmtBomReplaceForm = (): SmtBomReplaceForm => ({
  parentItemCode: '', childItemCode: '', replaceItemCode: '', lineCode: '', locationCode: '',
  dateSet: today(), dateEnd: '9999-12-31', itemUnitQty: '1', sortSequence: '1',
  itemType: '', lineType: '', machine: '', modelName: '',
  tableId: '', pcbItem: 'T', revision: '', feederShaft: '', smtModelName: '',
  comments: '', bomLevel: '1',
});

export const toSmtBomReplaceForm = (row: SmtBomReplaceRow): SmtBomReplaceForm => ({
  parentItemCode: row.parentItemCode,
  childItemCode: row.childItemCode,
  replaceItemCode: row.replaceItemCode,
  lineCode: row.lineCode,
  locationCode: row.locationCode,
  dateSet: day(row.dateSet),
  dateEnd: day(row.dateEnd),
  itemUnitQty: text(row.itemUnitQty),
  sortSequence: text(row.sortSequence),
  itemType: text(row.itemType),
  lineType: text(row.lineType),
  machine: text(row.machine),
  modelName: text(row.modelName),
  tableId: text(row.tableId),
  pcbItem: text(row.pcbItem),
  revision: text(row.revision),
  feederShaft: text(row.feederShaft),
  smtModelName: text(row.smtModelName),
  comments: text(row.comments),
  bomLevel: text(row.bomLevel),
});

interface Props {
  mode: 'create' | 'edit';
  initialForm: SmtBomReplaceForm;
  onClose: () => void;
  onSaved: () => void;
}

const optional = (value: string) => (value.trim() === '' ? undefined : value.trim());
const optionalNum = (value: string) => (value.trim() === '' ? undefined : Number(value));

export default function SmtBomReplaceFormPanel({ mode, initialForm, onClose, onSaved }: Props) {
  const [form, setForm] = useState<SmtBomReplaceForm>(initialForm);
  const [busy, setBusy] = useState(false);
  const edit = mode === 'edit';
  const set = <K extends keyof SmtBomReplaceForm>(key: K, value: SmtBomReplaceForm[K]) =>
    setForm((prev) => ({ ...prev, [key]: value }));

  const save = useCallback(async () => {
    const keys: Array<[string, string]> = [
      ['상위품목', form.parentItemCode], ['원 품목', form.childItemCode],
      ['대체품목', form.replaceItemCode], ['라인코드', form.lineCode],
      ['위치코드', form.locationCode],
    ];
    const missingKey = keys.find(([, v]) => v.trim() === '');
    if (missingKey) {
      toast.error(`${missingKey[0]}을(를) 입력하세요.`);
      return;
    }
    const required: Array<[string, string]> = [
      ['적용시작', form.dateSet], ['적용종료', form.dateEnd],
      ['품목유형', form.itemType], ['라인유형', form.lineType],
    ];
    const missing = required.find(([, v]) => v.trim() === '');
    if (missing) {
      toast.error(`${missing[0]}은(는) 필수입니다.`);
      return;
    }
    setBusy(true);
    const body = {
      parentItemCode: form.parentItemCode.trim(),
      childItemCode: form.childItemCode.trim(),
      replaceItemCode: form.replaceItemCode.trim(),
      lineCode: form.lineCode.trim(),
      locationCode: form.locationCode.trim(),
      dateSet: form.dateSet,
      dateEnd: form.dateEnd,
      itemUnitQty: Number(form.itemUnitQty || 0),
      sortSequence: Number(form.sortSequence || 0),
      itemType: form.itemType.trim(),
      lineType: form.lineType.trim(),
      machine: optional(form.machine),
      modelName: optional(form.modelName),
      tableId: optional(form.tableId),
      pcbItem: optional(form.pcbItem),
      revision: optional(form.revision),
      feederShaft: optional(form.feederShaft),
      smtModelName: optional(form.smtModelName),
      comments: optional(form.comments),
      bomLevel: optionalNum(form.bomLevel),
    };
    try {
      if (edit) await api.put('/smt/bom-replace', body);
      else await api.post('/smt/bom-replace', body);
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
    <aside className="flex w-[26rem] shrink-0 flex-col border-l border-border bg-surface">
      <header className="flex items-center justify-between border-b border-border p-4">
        <div>
          <b className="text-text">{edit ? '대체 BOM 수정' : '대체 BOM 등록'}</b>
          {edit && <div className="text-xs text-text-muted">키 다섯 컬럼은 바꿀 수 없습니다</div>}
        </div>
        <button type="button" onClick={onClose} aria-label="닫기">
          <X className="h-4 w-4 text-text-muted" />
        </button>
      </header>

      <div className="flex-1 space-y-3 overflow-auto p-4">
        <label className="block text-sm">
          <span className="text-text-muted">상위품목 (모델) *</span>
          <Input value={form.parentItemCode} disabled={edit}
            onChange={(e) => set('parentItemCode', e.target.value)} />
        </label>
        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">원 품목 *</span>
            <Input value={form.childItemCode} disabled={edit}
              onChange={(e) => set('childItemCode', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">대체품목 *</span>
            <Input value={form.replaceItemCode} disabled={edit}
              onChange={(e) => set('replaceItemCode', e.target.value)} />
          </label>
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
          <span className="text-text-muted">설비코드</span>
          <SmtMachineSelect value={form.machine} onChange={(v) => set('machine', v)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">모델명</span>
          <SmtModelSelect includeAll value={form.modelName}
            onChange={(v) => set('modelName', v)} />
        </label>

        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">적용시작 *</span>
            <Input type="date" value={form.dateSet}
              onChange={(e) => set('dateSet', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">적용종료 *</span>
            <Input type="date" value={form.dateEnd}
              onChange={(e) => set('dateEnd', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">소요량 *</span>
            <Input type="number" value={form.itemUnitQty}
              onChange={(e) => set('itemUnitQty', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">정렬순번 *</span>
            <Input type="number" value={form.sortSequence}
              onChange={(e) => set('sortSequence', e.target.value)} />
          </label>
        </div>

        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">품목유형 *</span>
            <ComCodeSelect groupCode="ITEM TYPE" includeAll={false}
              value={form.itemType} onChange={(v) => set('itemType', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">라인유형 *</span>
            <ComCodeSelect groupCode="LINE TYPE" includeAll={false}
              value={form.lineType} onChange={(v) => set('lineType', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">PCB 면</span>
            <SmtPcbItemSelect includeAll value={form.pcbItem}
              onChange={(v) => set('pcbItem', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">테이블문자</span>
            <Input value={form.tableId} maxLength={10}
              onChange={(e) => set('tableId', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">리비전</span>
            <Input value={form.revision} maxLength={10}
              onChange={(e) => set('revision', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">피더축</span>
            <Input value={form.feederShaft} maxLength={1}
              onChange={(e) => set('feederShaft', e.target.value)} />
          </label>
        </div>

        <label className="block text-sm">
          <span className="text-text-muted">SMT 모델명</span>
          <Input value={form.smtModelName} maxLength={50}
            onChange={(e) => set('smtModelName', e.target.value)} />
        </label>
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
