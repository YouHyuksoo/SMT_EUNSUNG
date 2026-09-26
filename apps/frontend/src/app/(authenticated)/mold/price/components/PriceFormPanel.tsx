"use client";

/**
 * @file src/app/(authenticated)/mold/price/components/PriceFormPanel.tsx
 * @description S-PARTS 구매단가 등록·수정 폼 — PB w_mcn_mold_buy_price_master 의 입력 영역 이식
 *
 * 초보자 가이드:
 * 1. **키는 적용일 + S-PARTS 코드 + 공급처**다. 수정할 때 이 셋은 바꿀 수 없다.
 * 2. **승인 컬럼은 이 폼이 건드리지 않는다.** 단가승인은 별도 화면의 일이다.
 * 3. 종료일을 비우면 등록 시 9999-12-31 로 들어간다 — PB 기본값이다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { Save, X } from 'lucide-react';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Input } from '@/components/ui';
import api from '@/services/api';
import type { MoldPriceRow } from '../../types';

export interface PriceForm {
  moldCode: string;
  supplierCode: string;
  dateset: string;
  dateend: string;
  unitPrice: string;
  standardUnitPrice: string;
  taxRate: string;
  currency: string;
  priceType: string;
  lineType: string;
  delivery: string;
  approvalNo: string;
  priceChangeReason: string;
}

const today = () => new Date().toISOString().slice(0, 10);

export const emptyPriceForm = (): PriceForm => ({
  moldCode: '', supplierCode: '', dateset: today(), dateend: '',
  unitPrice: '0', standardUnitPrice: '0', taxRate: '0',
  currency: 'KRW', priceType: 'T', lineType: 'G', delivery: '2',
  approvalNo: '', priceChangeReason: '',
});

const text = (value: unknown) => (value == null ? '' : String(value));

export const toPriceForm = (row: MoldPriceRow): PriceForm => ({
  moldCode: row.moldCode,
  supplierCode: row.supplierCode,
  dateset: String(row.dateset).slice(0, 10),
  dateend: row.dateend ? String(row.dateend).slice(0, 10) : '',
  unitPrice: text(row.unitPrice),
  standardUnitPrice: text(row.standardUnitPrice),
  taxRate: text(row.taxRate),
  currency: text(row.currency),
  priceType: text(row.priceType),
  lineType: text(row.lineType),
  delivery: text(row.delivery),
  approvalNo: text(row.approvalNo),
  priceChangeReason: text(row.priceChangeReason),
});

interface Props {
  mode: 'create' | 'edit';
  initialForm: PriceForm;
  onClose: () => void;
  onSaved: () => void;
}

const optional = (value: string) => (value.trim() === '' ? undefined : value.trim());
const optionalNum = (value: string) => (value.trim() === '' ? undefined : Number(value));

export default function PriceFormPanel({ mode, initialForm, onClose, onSaved }: Props) {
  const [form, setForm] = useState<PriceForm>(initialForm);
  const [busy, setBusy] = useState(false);
  const set = <K extends keyof PriceForm>(key: K, value: PriceForm[K]) =>
    setForm((prev) => ({ ...prev, [key]: value }));
  const locked = mode === 'edit';

  const save = useCallback(async () => {
    if (!form.moldCode.trim()) return toast.error('S-PARTS 코드를 입력하세요.');
    if (!form.supplierCode) return toast.error('공급처를 고르세요.');
    if (!form.dateset) return toast.error('적용일을 입력하세요.');
    setBusy(true);
    const body = {
      moldCode: form.moldCode.trim(),
      supplierCode: form.supplierCode,
      dateset: form.dateset,
      dateend: optional(form.dateend),
      unitPrice: optionalNum(form.unitPrice),
      standardUnitPrice: optionalNum(form.standardUnitPrice),
      taxRate: optionalNum(form.taxRate),
      currency: optional(form.currency),
      priceType: optional(form.priceType),
      lineType: optional(form.lineType),
      delivery: optional(form.delivery),
      approvalNo: optional(form.approvalNo),
      priceChangeReason: optional(form.priceChangeReason),
    };
    try {
      if (mode === 'create') await api.post('/mold/price', body);
      else await api.put('/mold/price', body);
      toast.success(mode === 'create' ? '등록되었습니다.' : '수정되었습니다.');
      onSaved();
    } catch {
      toast.error(mode === 'create' ? '같은 적용일의 단가가 이미 있습니다.' : '저장에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [form, mode, onSaved]);

  return (
    <aside className="flex w-96 shrink-0 flex-col border-l border-border bg-surface">
      <header className="flex items-center justify-between border-b border-border p-4">
        <b className="text-text">{mode === 'create' ? '구매단가 등록' : '구매단가 수정'}</b>
        <button type="button" onClick={onClose} aria-label="닫기">
          <X className="h-4 w-4 text-text-muted" />
        </button>
      </header>

      <div className="flex-1 space-y-3 overflow-auto p-4">
        <label className="block text-sm">
          <span className="text-text-muted">S-PARTS 코드</span>
          <Input value={form.moldCode} disabled={locked}
            onChange={(e) => set('moldCode', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">공급처</span>
          <SupplierSelect includeAll={false} disabled={locked} value={form.supplierCode}
            onChange={(v) => set('supplierCode', v)} />
        </label>
        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">적용일</span>
            <Input type="date" value={form.dateset} disabled={locked}
              onChange={(e) => set('dateset', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">종료일</span>
            <Input type="date" value={form.dateend}
              onChange={(e) => set('dateend', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">단가</span>
            <Input type="number" value={form.unitPrice}
              onChange={(e) => set('unitPrice', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">기준단가</span>
            <Input type="number" value={form.standardUnitPrice}
              onChange={(e) => set('standardUnitPrice', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">세율</span>
            <Input type="number" value={form.taxRate}
              onChange={(e) => set('taxRate', e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">통화</span>
            <ComCodeSelect groupCode="CURRENCY" includeAll={false}
              value={form.currency} onChange={(v) => set('currency', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">단가유형</span>
            <ComCodeSelect groupCode="PRICE TYPE" includeAll={false}
              value={form.priceType} onChange={(v) => set('priceType', v)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">수출/내수</span>
            <ComCodeSelect groupCode="DELIVERY" includeAll={false}
              value={form.delivery} onChange={(v) => set('delivery', v)} />
          </label>
        </div>
        <label className="block text-sm">
          <span className="text-text-muted">거래유형</span>
          <ComCodeSelect groupCode="LINE TYPE" includeAll={false}
            value={form.lineType} onChange={(v) => set('lineType', v)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">승인번호</span>
          <Input value={form.approvalNo} onChange={(e) => set('approvalNo', e.target.value)} />
        </label>
        <label className="block text-sm">
          <span className="text-text-muted">변경사유</span>
          <Input value={form.priceChangeReason}
            onChange={(e) => set('priceChangeReason', e.target.value)} />
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
