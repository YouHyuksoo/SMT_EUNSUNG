"use client";

/**
 * @file src/app/(authenticated)/master/product-model/BomExplodeModal.tsx
 * @description 모델 한 건의 BOM 전개 방식 · 면별 생산 품목을 사람이 정한다 (PATCH /master/product-models/bom-explode)
 *
 * 초보자 가이드:
 * 1. 후보는 제품 자신과 그 BOM 의 반제품이다 (GET .../candidates?modelName=). 면 추정은 품목명·코드로 한 것이다.
 *    모델 키는 모델명이다 — 고객사품번은 여러 모델이 같이 쓴다.
 * 2. 단면 반제품·원자재만인 제품은 실적을 셀 면 하나만 채운다. 채운 면의 AOI 만 실적으로 센다.
 * 3. 여기서 저장하면 "사람이 정함"이 되고, 자동 분류가 다시 덮어쓰지 않는다.
 */
import { useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";
import toast from "react-hot-toast";
import { Button, Modal, Select } from "@/components/ui";
import ComCodeSelect from "@/components/shared/ComCodeSelect";
import api from "@/services/api";
import type { ProductModelRow } from "./productModelColumns";

interface Candidate {
  itemCode: string;
  itemName: string | null;
  side: string;
  semi: boolean;
}

interface Props {
  row: ProductModelRow | null;
  onClose: () => void;
  onSaved: () => void;
}

export default function BomExplodeModal({ row, onClose, onSaved }: Props) {
  const { t } = useTranslation();
  const [type, setType] = useState("");
  const [top, setTop] = useState("");
  const [bottom, setBottom] = useState("");
  const [sub, setSub] = useState("");
  const [candidates, setCandidates] = useState<Candidate[]>([]);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (!row) return;
    setType(row.bomExplodeType ?? "NONE");
    setTop(row.topItemCode ?? "");
    setBottom(row.bottomItemCode ?? "");
    setSub(row.subItemCode ?? "");
    setCandidates([]);
    if (!row.itemCode || !row.modelName) return;
    const controller = new AbortController();
    api.get<{ data: Candidate[] }>("/master/product-models/bom-explode/candidates",
      { params: { modelName: row.modelName }, signal: controller.signal })
      .then(res => setCandidates(res.data?.data ?? []))
      .catch(() => { if (!controller.signal.aborted) toast.error(t("productModel.candidatesError")); });
    return () => controller.abort();
  }, [row, t]);

  const options = useMemo(() => [
    { value: "", label: t("productModel.selectNone") },
    ...candidates.map(c => ({
      value: c.itemCode,
      label: `${c.itemCode} ${c.itemName ?? ""}${c.semi ? "" : ` (${t("productModel.productSelf")})`}${c.side ? ` [${c.side}]` : ""}`,
    })),
  ], [candidates, t]);

  const save = async () => {
    if (!row) return;
    setSaving(true);
    try {
      await api.patch("/master/product-models/bom-explode", {
        modelName: row.modelName, bomExplodeType: type, topItemCode: top || undefined, bottomItemCode: bottom || undefined,
        subItemCode: sub || undefined,
      });
      toast.success(t("common.saved"));
      onSaved();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(message ?? t("common.saveError"));
    } finally {
      setSaving(false);
    }
  };

  return (
    <Modal isOpen={!!row} onClose={onClose} size="lg"
      title={t("productModel.editTitle")}
      subtitle={row ? `${row.modelName ?? ""} · ${row.itemCode ?? ""} ${row.itemName ?? ""}` : ""}
      footer={(
        <div className="flex justify-end gap-2">
          <Button variant="secondary" onClick={onClose}>{t("common.cancel")}</Button>
          <Button onClick={save} disabled={saving || !row?.itemCode}>{t("common.save")}</Button>
        </div>
      )}>
      <div className="flex flex-col gap-4">
        {!row?.itemCode && <p role="alert" className="text-red-600">{t("productModel.noItemCode")}</p>}
        <ComCodeSelect groupCode="BOM EXPLODE TYPE" label={t("productModel.bomExplodeType")}
          placeholder={t("productModel.bomExplodeType")} value={type} onChange={setType} fullWidth />
        <Select label={t("productModel.topItem")} options={options} value={top} onChange={setTop} fullWidth />
        <Select label={t("productModel.bottomItem")} options={options} value={bottom} onChange={setBottom} fullWidth />
        <Select label={t("productModel.subItem")} options={options} value={sub} onChange={setSub} fullWidth />
        <p className="text-sm text-text-muted">{t("productModel.editHint")}</p>
        {row?.bomExplodeNote && <p className="text-sm text-amber-600">{row.bomExplodeNote}</p>}
      </div>
    </Modal>
  );
}
