"use client";

/**
 * @file src/app/(authenticated)/mold/master/components/MoldMasterFormPanel.tsx
 * @description S-PARTS 등록·수정 폼 — PB w_mcn_mold_master 의 입력 영역 이식
 *
 * 초보자 가이드:
 * 1. **코드성 값은 기초코드 선택이다.** 자유 입력은 코드·명칭·규격·도면번호처럼
 *    정해진 목록이 없는 것뿐이다.
 * 2. 등록·수정을 한 패널로 쓴다. `mode` 로 갈리고 수정일 때 코드는 못 바꾼다(키다).
 * 3. 감사컬럼은 보내지 않는다 — 서버가 채운다(PB f_set_security_row).
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { Save, X } from 'lucide-react';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import SupplierSelect from '@/components/shared/SupplierSelect';
import UseYnSelect from '@/components/shared/UseYnSelect';
import { Button, Input } from '@/components/ui';
import api from '@/services/api';
import type { MoldMasterRow } from '../../types';

export interface MoldForm {
  moldCode: string;
  moldName: string;
  moldGroup: string;
  moldSpec: string;
  moldUom: string;
  moldType: string;
  moldLineType: string;
  drawingNo: string;
  rawMaterial: string;
  punchNo: string;
  nationCode: string;
  supplierCode: string;
  itemCode: string;
  barcode: string;
  comments: string;
  gasYn: string;
  autoReceiptYn: string;
  safetyInventory: string;
  orderLeadtime: string;
  itemUnitQty: string;
  cycleTime: string;
  machineCapacity: string;
  itemGasQty: string;
}

export const emptyMoldForm = (): MoldForm => ({
  moldCode: '', moldName: '', moldGroup: '', moldSpec: '', moldUom: 'EA',
  moldType: '', moldLineType: '', drawingNo: '', rawMaterial: '', punchNo: '',
  nationCode: '', supplierCode: '', itemCode: '', barcode: '', comments: '',
  gasYn: 'N', autoReceiptYn: 'N',
  safetyInventory: '0', orderLeadtime: '0', itemUnitQty: '0',
  cycleTime: '0', machineCapacity: '0', itemGasQty: '0',
});

const text = (value: unknown) => (value == null ? '' : String(value));
const numText = (value: unknown) => (value == null ? '' : String(value));

export const toMoldForm = (row: MoldMasterRow): MoldForm => ({
  moldCode: row.moldCode,
  moldName: text(row.moldName),
  moldGroup: text(row.moldGroup),
  moldSpec: text(row.moldSpec),
  moldUom: text(row.moldUom),
  moldType: text(row.moldType),
  moldLineType: text(row.moldLineType),
  drawingNo: text(row.drawingNo),
  rawMaterial: text(row.rawMaterial),
  punchNo: text(row.punchNo),
  nationCode: text(row.nationCode),
  supplierCode: text(row.supplierCode),
  itemCode: text(row.itemCode),
  barcode: text(row.barcode),
  comments: text(row.comments),
  gasYn: text(row.gasYn) || 'N',
  autoReceiptYn: text(row.autoReceiptYn) || 'N',
  safetyInventory: numText(row.safetyInventory),
  orderLeadtime: numText(row.orderLeadtime),
  itemUnitQty: numText(row.itemUnitQty),
  cycleTime: numText(row.cycleTime),
  machineCapacity: numText(row.machineCapacity),
  itemGasQty: numText(row.itemGasQty),
});

interface Props {
  mode: 'create' | 'edit';
  initialForm: MoldForm;
  onClose: () => void;
  onSaved: () => void;
}

/** 빈 문자열은 보내지 않는다 — 서버가 NULL 로 채운다 */
const optional = (value: string) => (value.trim() === '' ? undefined : value.trim());
const optionalNum = (value: string) => (value.trim() === '' ? undefined : Number(value));

export default function MoldMasterFormPanel({ mode, initialForm, onClose, onSaved }: Props) {
  const [form, setForm] = useState<MoldForm>(initialForm);
  const [busy, setBusy] = useState(false);
  const set = <K extends keyof MoldForm>(key: K, value: MoldForm[K]) =>
    setForm((prev) => ({ ...prev, [key]: value }));

  const save = useCallback(async () => {
    if (!form.moldCode.trim()) return toast.error('S-PARTS 코드를 입력하세요.');
    if (!form.moldName.trim()) return toast.error('S-PARTS 명을 입력하세요.');
    setBusy(true);
    const body = {
      moldCode: form.moldCode.trim(),
      moldName: form.moldName.trim(),
      moldGroup: optional(form.moldGroup),
      moldSpec: optional(form.moldSpec),
      moldUom: optional(form.moldUom),
      moldType: optional(form.moldType),
      moldLineType: optional(form.moldLineType),
      drawingNo: optional(form.drawingNo),
      rawMaterial: optional(form.rawMaterial),
      punchNo: optional(form.punchNo),
      nationCode: optional(form.nationCode),
      supplierCode: optional(form.supplierCode),
      itemCode: optional(form.itemCode),
      barcode: optional(form.barcode),
      comments: optional(form.comments),
      gasYn: optional(form.gasYn),
      autoReceiptYn: optional(form.autoReceiptYn),
      safetyInventory: optionalNum(form.safetyInventory),
      orderLeadtime: optionalNum(form.orderLeadtime),
      itemUnitQty: optionalNum(form.itemUnitQty),
      cycleTime: optionalNum(form.cycleTime),
      machineCapacity: optionalNum(form.machineCapacity),
      itemGasQty: optionalNum(form.itemGasQty),
    };
    try {
      if (mode === 'create') await api.post('/mold/master', body);
      else await api.put('/mold/master', body);
      toast.success(mode === 'create' ? '등록되었습니다.' : '수정되었습니다.');
      onSaved();
    } catch {
      toast.error(mode === 'create' ? '이미 등록된 코드입니다.' : '저장에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [form, mode, onSaved]);

  return (
    <aside className="flex w-96 shrink-0 flex-col border-l border-border bg-surface">
      <header className="flex items-center justify-between border-b border-border p-4">
        <b className="text-text">{mode === 'create' ? 'S-PARTS 등록' : 'S-PARTS 수정'}</b>
        <button type="button" onClick={onClose} aria-label="닫기">
          <X className="h-4 w-4 text-text-muted" />
        </button>
      </header>

      <div className="flex-1 space-y-3 overflow-auto p-4">
        <label className="block text-sm">
          <span className="text-text-muted">S-PARTS 코드</span>
          <Input value={form.moldCode} disabled={mode === 'edit'}
            onChange={(e) => set('moldCode', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">S-PARTS 명</span>
          <Input value={form.moldName} onChange={(e) => set('moldName', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">S-PARTS 그룹</span>
          <ComCodeSelect groupCode="MOLD GROUP" includeAll={false}
            value={form.moldGroup} onChange={(v) => set('moldGroup', v)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">규격</span>
          <Input value={form.moldSpec} onChange={(e) => set('moldSpec', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">S-PARTS 유형</span>
          <ComCodeSelect groupCode="MOLD TYPE" includeAll={false}
            value={form.moldType} onChange={(v) => set('moldType', v)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">거래유형</span>
          <ComCodeSelect groupCode="MOLD LINE TYPE" includeAll={false}
            value={form.moldLineType} onChange={(v) => set('moldLineType', v)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">공급처</span>
          <SupplierSelect includeAll={false}
            value={form.supplierCode} onChange={(v) => set('supplierCode', v)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">단위</span>
          <Input value={form.moldUom} onChange={(e) => set('moldUom', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">도면번호</span>
          <Input value={form.drawingNo} onChange={(e) => set('drawingNo', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">재질</span>
          <Input value={form.rawMaterial} onChange={(e) => set('rawMaterial', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">펀치번호</span>
          <Input value={form.punchNo} onChange={(e) => set('punchNo', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">품목코드</span>
          <Input value={form.itemCode} onChange={(e) => set('itemCode', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">바코드</span>
          <Input value={form.barcode} onChange={(e) => set('barcode', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">국가코드</span>
          <Input value={form.nationCode} onChange={(e) => set('nationCode', e.target.value)} />
        </label>

        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">안전재고</span>
            <Input type="number" value={form.safetyInventory}
              onChange={(e) => set('safetyInventory', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">발주 L/T</span>
            <Input type="number" value={form.orderLeadtime}
              onChange={(e) => set('orderLeadtime', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">품목당 수량</span>
            <Input type="number" value={form.itemUnitQty}
              onChange={(e) => set('itemUnitQty', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">C/T</span>
            <Input type="number" value={form.cycleTime}
              onChange={(e) => set('cycleTime', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">설비능력</span>
            <Input type="number" value={form.machineCapacity}
              onChange={(e) => set('machineCapacity', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">가스량</span>
            <Input type="number" value={form.itemGasQty}
              onChange={(e) => set('itemGasQty', e.target.value)} />
          </label>
        </div>

        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">가스사용</span>
            <UseYnSelect includeAll={false} value={form.gasYn} onChange={(v) => set('gasYn', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">자동입고</span>
            <ComCodeSelect groupCode="AUTO RECEIPT YN" includeAll={false}
              value={form.autoReceiptYn} onChange={(v) => set('autoReceiptYn', v)} />
          </label>
        </div>

        <label className="block text-sm">
          <span className="text-text-muted">설명</span>
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
