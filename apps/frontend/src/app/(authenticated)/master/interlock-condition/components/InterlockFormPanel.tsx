"use client";

/**
 * @file src/app/(authenticated)/master/interlock-condition/components/InterlockFormPanel.tsx
 * @description 인터락 조건 등록·수정·삭제 우측 패널
 */
import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import { Trash2, X } from "lucide-react";
import { Button, ConfirmModal, Input, Select } from "@/components/ui";
import ComCodeSelect from "@/components/shared/ComCodeSelect";
import EquipSelect from "@/components/shared/EquipSelect";
import LineSelect from "@/components/shared/LineSelect";
import PartSearchField from "@/components/shared/PartSearchField";
import ProcessSelect from "@/components/shared/ProcessSelect";
import api from "@/services/api";
import type { InterlockCondition } from "../types";

const EMPTY = { lineCode: "", workstageCode: "", machineCode: "", interlockCheckType: "", checkSequence: "", checkLimitTime: "", itemCode: "", useYn: "Y" };

interface Props {
  editing: InterlockCondition | null;
  /** 신규 등록 때 필터에서 고른 라인·공정을 미리 채운다 */
  defaults: { lineCode: string; workstageCode: string };
  onClose: () => void;
  onSaved: () => void;
}

export default function InterlockFormPanel({ editing, defaults, onClose, onSaved }: Props) {
  const [form, setForm] = useState(EMPTY);
  const [saving, setSaving] = useState(false);
  const [confirmDelete, setConfirmDelete] = useState(false);

  useEffect(() => {
    if (!editing) { setForm({ ...EMPTY, lineCode: defaults.lineCode, workstageCode: defaults.workstageCode }); return; }
    setForm({
      lineCode: editing.lineCode,
      workstageCode: editing.workstageCode,
      machineCode: editing.machineCode ?? "",
      interlockCheckType: editing.interlockCheckType ?? "",
      checkSequence: editing.checkSequence != null ? String(editing.checkSequence) : "",
      checkLimitTime: editing.checkLimitTime != null ? String(editing.checkLimitTime) : "",
      itemCode: editing.itemCode ?? "",
      useYn: editing.useYn ?? "Y",
    });
  }, [editing, defaults.lineCode, defaults.workstageCode]);

  const set = (key: keyof typeof EMPTY, value: string) => setForm((prev) => ({ ...prev, [key]: value }));
  const valid = form.lineCode && form.workstageCode && form.interlockCheckType;

  const save = async () => {
    if (!valid) return;
    setSaving(true);
    try {
      const body = {
        lineCode: form.lineCode,
        workstageCode: form.workstageCode,
        machineCode: form.machineCode || undefined,
        interlockCheckType: form.interlockCheckType,
        checkSequence: form.checkSequence === "" ? undefined : Number(form.checkSequence),
        checkLimitTime: form.checkLimitTime === "" ? undefined : Number(form.checkLimitTime),
        itemCode: form.itemCode || undefined,
        useYn: form.useYn,
      };
      if (editing) await api.put(`/master/interlock-conditions/${encodeURIComponent(editing.rowKey)}`, body);
      else await api.post("/master/interlock-conditions", body);
      toast.success(editing ? "인터락 조건을 수정했습니다." : "인터락 조건을 등록했습니다.");
      onSaved();
    } catch { /* API 오류는 인터셉터가 알린다 */ }
    finally { setSaving(false); }
  };

  const remove = async () => {
    if (!editing) return;
    setSaving(true);
    try {
      await api.delete(`/master/interlock-conditions/${encodeURIComponent(editing.rowKey)}`);
      toast.success("인터락 조건을 삭제했습니다.");
      setConfirmDelete(false);
      onSaved();
    } catch { /* API 오류는 인터셉터가 알린다 */ }
    finally { setSaving(false); }
  };

  return (
    <aside className="flex h-full w-[440px] shrink-0 flex-col border-l border-border bg-background shadow-xl">
      <header className="flex h-14 items-center justify-between border-b border-border px-5">
        <h2 className="font-bold text-text">{editing ? "인터락 조건 수정" : "인터락 조건 등록"}</h2>
        <button title="닫기" onClick={onClose}><X className="h-5 w-5" /></button>
      </header>
      <div className="flex-1 space-y-4 overflow-y-auto p-5 text-sm">
        <LineSelect label="라인 *" value={form.lineCode} onChange={(v) => set("lineCode", v)} fullWidth />
        <ProcessSelect label="공정 *" value={form.workstageCode} onChange={(v) => set("workstageCode", v)} fullWidth />
        <ComCodeSelect label="검사유형 *" groupCode="INTERLOCK CHECK TYPE" includeAll={false} showCode value={form.interlockCheckType} onChange={(v) => set("interlockCheckType", v)} fullWidth />
        <div className="grid grid-cols-2 gap-3">
          <Input label="검사 순서" type="number" min="0" value={form.checkSequence} onChange={(e) => set("checkSequence", e.target.value)} fullWidth />
          <Input label="검사한계시간" type="number" min="0" value={form.checkLimitTime} onChange={(e) => set("checkLimitTime", e.target.value)} fullWidth />
        </div>
        <div>
          <EquipSelect label="설비" processCode={form.workstageCode || undefined} labelPrefix="설비" value={form.machineCode} onChange={(v) => set("machineCode", v)} fullWidth />
          <p className="mt-1 text-xs text-text-muted">비우면 설비 구분 없이 적용합니다.</p>
        </div>
        <div>
          <PartSearchField label="품목코드" value={form.itemCode} onChange={(e) => set("itemCode", e.target.value)} onPartSelect={(part) => set("itemCode", part.itemCode)} fullWidth />
          <p className="mt-1 text-xs text-text-muted">비우거나 * 를 넣으면 전 품목에 적용합니다.</p>
        </div>
        <Select label="사용 여부" options={[{ value: "Y", label: "사용" }, { value: "N", label: "미사용" }]} value={form.useYn} onChange={(v) => set("useYn", v)} fullWidth />
        {editing && (
          <p className="border-t border-border pt-3 text-xs text-text-muted">
            수정·삭제 이력은 인터락 조건 변경 로그에 자동으로 남습니다.
          </p>
        )}
      </div>
      <footer className="flex items-center justify-between gap-2 border-t border-border p-4">
        {editing ? (
          <Button variant="danger" onClick={() => setConfirmDelete(true)} disabled={saving}><Trash2 className="mr-1 h-4 w-4" />삭제</Button>
        ) : <span />}
        <div className="flex gap-2">
          <Button variant="secondary" onClick={onClose}>취소</Button>
          <Button onClick={save} disabled={!valid || saving} isLoading={saving}>저장</Button>
        </div>
      </footer>
      <ConfirmModal
        isOpen={confirmDelete}
        onClose={() => setConfirmDelete(false)}
        onConfirm={remove}
        title="인터락 조건 삭제"
        message={editing ? `라인 ${editing.lineCode} · 공정 ${editing.workstageCode} 의 ${editing.interlockCheckType} 조건을 삭제합니다. 이 라인·공정의 공정통과에서 이 검사를 더 하지 않습니다.` : ""}
        confirmText="삭제"
        variant="danger"
        isLoading={saving}
      />
    </aside>
  );
}
