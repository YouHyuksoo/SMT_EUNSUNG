/**
 * @file src/app/(authenticated)/master/part/components/PartFormModal.tsx
 * @description ID_ITEM 품목 추가/수정 모달
 *
 * 초보자 가이드:
 * 1. **기본정보**: 품목코드, 품번, 품명, 유형, 규격, 리비전 등
 * 2. **수량/관리**: 박스장입수량, 최소불출단위, 묶음단위, 안전재고, 유효기간
 * 3. **API**: POST /master/parts (생성), PUT /master/parts/:id (수정)
 */

"use client";

import { useState, useMemo } from "react";
import { useTranslation } from "react-i18next";
import { Button, Modal } from "@/components/ui";
import { useLocationOptions } from "@/hooks/useMasterOptions";
import api from "@/services/api";
import { Part } from "../types";
import { FieldComCodeSelect, FieldInput, FieldSelect, FieldYnRadio, Field } from "./PartFieldHelp";
import { QtyInput } from "@/components/shared";

interface Props {
  isOpen: boolean;
  onClose: () => void;
  editingPart: Part | null;
  onSave: () => void;
}

const PACKAGING_QTY_OPTIONS = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];

export default function PartFormModal({ isOpen, onClose, editingPart, onSave }: Props) {
  const { t } = useTranslation();
  const isEdit = !!editingPart;
  const { options: rawLocationOptions, isLoading: locationLoading } = useLocationOptions();
  const locationOptions = useMemo(
    () => [{ value: "", label: t("common.select", "선택하세요") }, ...rawLocationOptions],
    [rawLocationOptions, t],
  );


  const [form, setForm] = useState(() => ({
    itemCode: editingPart?.itemCode || "",
    itemName: editingPart?.itemName || "",
    itemNo: editingPart?.itemNo || "",
    custPartNo: editingPart?.custPartNo || "",
    itemType: editingPart?.itemType || "T",
    itemClass: editingPart?.itemClass || "*",
    modelName: editingPart?.modelName || "",
    spec: editingPart?.spec || "",
    rev: editingPart?.rev || "",
    markingText: editingPart?.markingText || "",
    itemUom: editingPart?.itemUom || "EA",
    color: editingPart?.color || "",
    boxQty: editingPart?.boxQty ?? 0,
    minPackQty: editingPart?.minPackQty ?? 0,
    lotUnitQty: editingPart?.lotUnitQty ?? 0,
    safetyStock: editingPart?.safetyStock ?? 0,
    expiryDate: editingPart?.expiryDate ?? 0,
    expiryExtDays: editingPart?.expiryExtDays ?? 0,
    mesDisplayYn: editingPart?.mesDisplayYn || "Y",
    packUnit: editingPart?.packUnit ?? 0,
    storageLocation: editingPart?.storageLocation || "",
    remark: editingPart?.remark || "",
  }));
  const [saving, setSaving] = useState(false);
  const canSave = !saving
    && !!form.itemCode.trim()
    && !!form.itemNo.trim()
    && !!form.itemName.trim();

  const setField = (key: string, value: string | number) => {
    setForm(prev => ({ ...prev, [key]: value }));
  };

  const handleSubmit = async () => {
    if (!canSave) return;
    setSaving(true);
    try {
      const payload = {
        ...form,
        itemNo: form.itemNo,
        custPartNo: form.custPartNo || undefined,
        itemClass: form.itemClass,
        modelName: form.modelName || undefined,
        spec: form.spec || undefined,
        rev: form.rev || undefined,
        markingText: form.markingText || undefined,
        color: form.color || undefined,
        remark: form.remark || undefined,
        packUnit: form.packUnit || undefined,
        storageLocation: form.storageLocation || undefined,
        lotUnitQty: form.lotUnitQty || undefined,
        minPackQty: form.minPackQty,
        expiryExtDays: form.expiryExtDays,
        mesDisplayYn: form.mesDisplayYn,
      };

      if (isEdit && editingPart?.itemCode) {
        await api.put(`/master/parts/${editingPart.itemCode}`, payload);
      } else {
        await api.post("/master/parts", payload);
      }
      onSave();
      onClose();
    } catch {
      // 에러는 api 인터셉터에서 처리
    } finally {
      setSaving(false);
    }
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose}
      title={isEdit ? t("master.part.editPart") : t("master.part.addPart")} size="xl">

      {/* 기본정보 섹션 */}
      <h3 className="text-sm font-semibold text-text-muted mb-3">
        {t("master.part.sectionBasic", "기본정보")}
      </h3>
      <div className="grid grid-cols-4 gap-4 mb-6">
        <FieldInput field="itemCode" label={t("master.part.partCode")} required
          value={form.itemCode} onChange={e => setField("itemCode", e.target.value)}
          disabled={isEdit} fullWidth />
        <FieldInput field="itemNo" label={t("master.part.partNo", "품번")} required
          value={form.itemNo} onChange={e => setField("itemNo", e.target.value)} fullWidth />
        <FieldInput field="custPartNo" label={t("master.part.custPartNo", "고객품번")}
          value={form.custPartNo} onChange={e => setField("custPartNo", e.target.value)} fullWidth />
        <FieldInput field="rev" label={t("master.part.rev", "리비전")}
          value={form.rev} onChange={e => setField("rev", e.target.value)} fullWidth />
        <FieldInput field="markingText" label={t("master.part.markingText", "마킹문구")} wrapperClassName="col-span-2"
          value={form.markingText} maxLength={100}
          onChange={e => setField("markingText", e.target.value)} fullWidth />
        <FieldInput field="itemName" label={t("master.part.partName")} required wrapperClassName="col-span-2"
          value={form.itemName} onChange={e => setField("itemName", e.target.value)} fullWidth />
        <FieldComCodeSelect field="itemType" groupCode="ITEM_TYPE" includeAll={false} label={t("master.part.type")}
          value={form.itemType} onChange={v => setField("itemType", v)} fullWidth required />
        <FieldComCodeSelect field="itemClass" groupCode="ITEM_CLASS" includeAll={false}
          label={t("master.part.itemClass", "품목분류")}
          value={form.itemClass} onChange={v => setField("itemClass", v)} fullWidth />
        <FieldInput field="modelName" label={t("master.part.modelName", "차종")}
          value={form.modelName} onChange={e => setField("modelName", e.target.value)} fullWidth />
        <FieldInput field="spec" label={t("master.part.spec")} wrapperClassName="col-span-2"
          value={form.spec} onChange={e => setField("spec", e.target.value)} fullWidth />
        <FieldComCodeSelect field="itemUom" groupCode="ITEM_UOM" includeAll={false} label={t("master.part.unit")}
          value={form.itemUom} onChange={v => setField("itemUom", v)} fullWidth />
        <FieldInput field="color" label={t("master.part.color", "색상")}
          value={form.color} onChange={e => setField("color", e.target.value)} fullWidth />
        <FieldYnRadio field="mesDisplayYn" label={t("common.useYn", "사용여부")} value={form.mesDisplayYn} onChange={v => setField("mesDisplayYn", v)} />
      </div>

      {/* 수량 섹션 */}
      <div className="grid grid-cols-4 gap-4 mb-6">
        <div>
          <Field field="boxQty" label={t("master.part.boxQty", "박스장입수량")}>
            <QtyInput value={Number(form.boxQty) || 0} onChange={(n) => setField("boxQty", n)} fullWidth />
          </Field>
          <datalist id="part-modal-box-qty-options">
            {PACKAGING_QTY_OPTIONS.map(qty => <option key={qty} value={qty} />)}
          </datalist>
        </div>
        <Field field="minPackQty" label={t("master.part.minPackQty", "최소불출단위수량(자재)")}>
          <QtyInput value={Number(form.minPackQty) || 0} onChange={(n) => setField("minPackQty", n)} fullWidth />
        </Field>
        <Field field="lotUnitQty" label={t("master.part.lotUnitQty", "묶음단위수량(생산공정품)")}>
          <QtyInput value={Number(form.lotUnitQty) || 0} onChange={(n) => setField("lotUnitQty", n)} fullWidth />
        </Field>
        <Field field="safetyStock" label={t("master.part.safetyStock")}>
          <QtyInput value={Number(form.safetyStock) || 0} onChange={(n) => setField("safetyStock", n)} fullWidth />
        </Field>
        <Field field="expiryDate" label={t("master.part.expiryDate", "유효기간(일)")}>
          <QtyInput value={Number(form.expiryDate) || 0} onChange={(n) => setField("expiryDate", n)} fullWidth />
        </Field>
        <Field field="expiryExtDays" label={t("master.part.expiryExtDays", "유효기간 연장(일)")}>
          <QtyInput value={Number(form.expiryExtDays) || 0} onChange={(n) => setField("expiryExtDays", n)} fullWidth />
        </Field>
        <Field field="packUnit" label={t("master.part.palletUnit", "팔레트구성단위")}>
          <QtyInput value={Number(form.packUnit) || 0} onChange={(n) => setField("packUnit", n)} fullWidth />
        </Field>
        <FieldSelect field="storageLocation" label={t("master.part.storageLocation", "품목고정 적재로케이션")}
          options={locationOptions}
          value={form.storageLocation} onChange={v => setField("storageLocation", v)}
          disabled={locationLoading} fullWidth />
      </div>

      {/* 비고 */}
      <div className="mb-4">
        <FieldInput field="remark" label={t("common.remark")}
          value={form.remark} onChange={e => setField("remark", e.target.value)} fullWidth />
      </div>

      <div className="flex justify-end gap-2 pt-4 border-t border-border">
        <Button variant="secondary" onClick={onClose}>{t("common.cancel")}</Button>
        <Button onClick={handleSubmit} disabled={!canSave}>
          {saving ? t("common.saving") : t("common.save", "저장")}
        </Button>
      </div>
    </Modal>
  );
}
