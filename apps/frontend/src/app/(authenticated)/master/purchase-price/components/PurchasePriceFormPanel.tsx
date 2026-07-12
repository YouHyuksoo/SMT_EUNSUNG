"use client";

import { useEffect, useMemo, useState } from "react";
import { Search, X } from "lucide-react";
import { Button, ConfirmModal, Input } from "@/components/ui";
import ComCodeSelect from "@/components/shared/ComCodeSelect";
import SupplierSelect from "@/components/shared/SupplierSelect";
import PartSearchModal, { type PartItem } from "@/components/shared/PartSearchModal";
import api from "@/services/api";
import type { PurchasePriceImpact, PurchasePriceItem } from "../types";

interface Props {
  editingItem: PurchasePriceItem | null;
  onClose: () => void;
  onSaved: () => void;
}

const initialForm = {
  dateset: new Date().toISOString().slice(0, 10), dateend: "9999-12-31",
  itemCode: "", itemName: "", supplierCode: "", lineType: "G",
  unitPrice: "", standardUnitPrice: "", taxRate: "", currency: "KRW",
  delivery: "2", priceType: "F", priceChangeReason: "N",
};

const dateOnly = (value?: string | null) => value ? value.slice(0, 10) : "";

export default function PurchasePriceFormPanel({ editingItem, onClose, onSaved }: Props) {
  const isEdit = !!editingItem;
  const [form, setForm] = useState(initialForm);
  const [partSearchOpen, setPartSearchOpen] = useState(false);
  const [impact, setImpact] = useState<PurchasePriceImpact | null>(null);
  const [checking, setChecking] = useState(false);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (!editingItem) { setForm(initialForm); return; }
    setForm({
      dateset: dateOnly(editingItem.dateset), dateend: dateOnly(editingItem.dateend),
      itemCode: editingItem.itemCode, itemName: editingItem.itemName ?? "",
      supplierCode: editingItem.supplierCode, lineType: editingItem.lineType,
      unitPrice: String(editingItem.unitPrice), standardUnitPrice: String(editingItem.standardUnitPrice ?? ""),
      taxRate: String(editingItem.taxRate ?? ""), currency: editingItem.currency,
      delivery: editingItem.delivery, priceType: editingItem.priceType,
      priceChangeReason: editingItem.priceChangeReason,
    });
  }, [editingItem]);

  const setField = (key: keyof typeof form, value: string) => setForm((previous) => ({ ...previous, [key]: value }));
  const valid = form.itemCode && form.supplierCode && form.lineType && form.dateset && form.dateend && form.unitPrice;

  const payload = useMemo(() => ({
    dateset: form.dateset, dateend: form.dateend, itemCode: form.itemCode,
    supplierCode: form.supplierCode, lineType: form.lineType,
    unitPrice: Number(form.unitPrice),
    standardUnitPrice: form.standardUnitPrice ? Number(form.standardUnitPrice) : undefined,
    taxRate: form.taxRate ? Number(form.taxRate) : undefined,
    currency: form.currency, delivery: form.delivery, priceType: form.priceType,
    priceChangeReason: form.priceChangeReason,
    ...(isEdit ? { originalDateset: dateOnly(editingItem?.dateset) } : {}),
  }), [form, isEdit, editingItem]);

  const checkImpact = async () => {
    if (!valid) return;
    setChecking(true);
    try {
      const response = await api.get("/master/purchase-prices/impact", {
        params: { mode: isEdit ? "update" : "create", itemCode: form.itemCode, supplierCode: form.supplierCode, lineType: form.lineType, dateset: form.dateset },
      });
      setImpact(response.data?.data);
    } catch {
      setImpact(null);
    } finally {
      setChecking(false);
    }
  };

  const save = async () => {
    setSaving(true);
    try {
      if (isEdit) await api.put("/master/purchase-prices", payload);
      else await api.post("/master/purchase-prices", payload);
      setImpact(null);
      onSaved();
    } catch {
      // API interceptor preserves and displays Oracle error text.
    } finally {
      setSaving(false);
    }
  };

  const impactMessage = impact
    ? isEdit
      ? `입고 ${impact.affectedRows.toLocaleString()}건(기존 합계 ${impact.affectedAmount.toLocaleString()}원)의 금액이 새 단가로 재계산됩니다.`
      : `기존 단가 ${impact.closingRows.length.toLocaleString()}건이 적용 시작일 전날로 마감되고, 입고 ${impact.affectedRows.toLocaleString()}건(기존 합계 ${impact.affectedAmount.toLocaleString()}원)의 금액이 새 단가로 재계산됩니다.`
    : "";

  return (
    <aside className="flex h-full w-[520px] shrink-0 flex-col overflow-hidden border-l border-border bg-background shadow-xl">
      <header className="flex h-14 items-center justify-between border-b border-border px-5">
        <h2 className="font-bold text-text">{isEdit ? "구매단가 수정" : "신규 구매단가"}</h2>
        <button type="button" title="닫기" onClick={onClose}><X className="h-5 w-5" /></button>
      </header>
      <div className="flex-1 space-y-4 overflow-y-auto p-5 text-sm">
        <div>
          <label className="mb-1.5 block font-medium">품목 *</label>
          <div className="flex gap-2">
            <Input value={form.itemCode ? `${form.itemCode} - ${form.itemName}` : ""} readOnly fullWidth />
            <Button variant="secondary" onClick={() => setPartSearchOpen(true)} disabled={isEdit} title="품목 검색"><Search className="h-4 w-4" /></Button>
          </div>
        </div>
        <SupplierSelect label="공급사" value={form.supplierCode} onChange={(value) => setField("supplierCode", value)} disabled={isEdit} required fullWidth />
        <div className="grid grid-cols-2 gap-3">
          <ComCodeSelect label="구입유형" groupCode="LINE TYPE" includeAll={false} value={form.lineType} onChange={(value) => setField("lineType", value)} disabled={isEdit} required />
          <ComCodeSelect label="단가형태" groupCode="PRICE TYPE" includeAll={false} value={form.priceType} onChange={(value) => setField("priceType", value)} required />
        </div>
        <div className="grid grid-cols-2 gap-3">
          <Input label="시작일" type="date" value={form.dateset} onChange={(event) => setField("dateset", event.target.value)} required />
          <Input label="종료일" type="date" value={form.dateend} onChange={(event) => setField("dateend", event.target.value)} required />
        </div>
        <div className="grid grid-cols-2 gap-3">
          <Input label="단가" type="number" min="0" step="0.0001" value={form.unitPrice} onChange={(event) => setField("unitPrice", event.target.value)} required />
          <Input label="기준단가" type="number" min="0" step="0.0001" value={form.standardUnitPrice} onChange={(event) => setField("standardUnitPrice", event.target.value)} />
        </div>
        <div className="grid grid-cols-2 gap-3">
          <ComCodeSelect label="통화" groupCode="CURRENCY" includeAll={false} showCode value={form.currency} onChange={(value) => setField("currency", value)} required />
          <Input label="세율(%)" type="number" min="0" step="0.01" value={form.taxRate} onChange={(event) => setField("taxRate", event.target.value)} />
        </div>
        <div className="grid grid-cols-2 gap-3">
          <ComCodeSelect label="납선" groupCode="DELIVERY" includeAll={false} value={form.delivery} onChange={(value) => setField("delivery", value)} required />
          <ComCodeSelect label="변경사유" groupCode="PRICE CHANGE REASON" includeAll={false} value={form.priceChangeReason} onChange={(value) => setField("priceChangeReason", value)} required />
        </div>
        {isEdit && (
          <div className="grid grid-cols-2 gap-3 border-t border-border pt-4 text-text-muted">
            <Input label="승인여부" value={editingItem?.priceChangeConfirmYn ?? "N"} readOnly />
            <Input label="승인번호" value={editingItem?.approvalNo ?? ""} readOnly />
            <Input label="승인자" value={editingItem?.confirmBy ?? ""} readOnly />
            <Input label="승인일" value={dateOnly(editingItem?.confirmDate)} readOnly />
          </div>
        )}
      </div>
      <footer className="flex justify-end gap-2 border-t border-border p-4">
        <Button variant="secondary" onClick={onClose}>취소</Button>
        <Button onClick={checkImpact} disabled={!valid || checking}>{checking ? "영향 확인 중" : "저장"}</Button>
      </footer>

      <PartSearchModal isOpen={partSearchOpen} onClose={() => setPartSearchOpen(false)} onSelect={(part: PartItem) => { setField("itemCode", part.itemCode); setField("itemName", part.itemName); setPartSearchOpen(false); }} />
      <ConfirmModal isOpen={!!impact} onClose={() => setImpact(null)} onConfirm={save} title="저장 영향 확인" message={impactMessage} confirmText="확인 후 저장" isLoading={saving} />
    </aside>
  );
}
