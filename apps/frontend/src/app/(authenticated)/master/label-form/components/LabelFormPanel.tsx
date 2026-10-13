"use client";

/**
 * @file src/app/(authenticated)/master/label-form/components/LabelFormPanel.tsx
 * @description 라벨 양식 상세 우측 패널 — 기본정보, V1~V20 값 칸, 양식 파일(.btw)·미리보기 이미지 올리기/내려받기
 *
 * 초보자 가이드:
 * 1. V1~V20 은 BarTender 양식의 값 칸에 넣을 항목이다. 공통코드 LABEL STEP 에서 고르거나 고정 문자를 직접 쓴다.
 * 2. 미리보기 값은 저장된 값 기준이다. 값을 바꾸면 저장한 뒤에 미리보기가 바뀐다.
 * 3. 파일은 양식을 먼저 저장한 뒤에 올릴 수 있다.
 */
import { useCallback, useEffect, useRef, useState } from "react";
import toast from "react-hot-toast";
import { Download, Trash2, Upload, X } from "lucide-react";
import { Button, ConfirmModal, Input, Select } from "@/components/ui";
import ComCodeSelect from "@/components/shared/ComCodeSelect";
import ModelSearchField from "@/components/shared/ModelSearchField";
import { useComCodeMap } from "@/hooks/useComCode";
import api from "@/services/api";
import type { LabelForm, LabelValueSlot } from "../types";

const VALUE_KEYS = Array.from({ length: 20 }, (_, i) => `v${i + 1}`);
const EMPTY_VALUES = Object.fromEntries(VALUE_KEYS.map((k) => [k, ""])) as Record<string, string>;
const EMPTY = { modelName: "", labelFormNo: "1", labelFormType: "B", useFlag: "", comments: "" };

interface Props {
  editing: LabelForm | null;
  onClose: () => void;
  /** 저장·삭제·파일 변경 뒤 목록을 다시 읽는다. 저장한 양식의 키를 넘긴다 */
  onChanged: (key: { modelName: string; labelFormNo: number } | null) => void;
}

/** Content-Disposition 에서 파일 이름을 꺼낸다 */
function fileNameOf(disposition: string | undefined, fallback: string) {
  const encoded = /filename\*=UTF-8''([^;]+)/i.exec(disposition ?? "")?.[1];
  return encoded ? decodeURIComponent(encoded) : fallback;
}

export default function LabelFormPanel({ editing, onClose, onChanged }: Props) {
  const [form, setForm] = useState(EMPTY);
  const [values, setValues] = useState<Record<string, string>>(EMPTY_VALUES);
  const [previews, setPreviews] = useState<Record<string, string | null>>({});
  const [loadingValues, setLoadingValues] = useState(false);
  const [saving, setSaving] = useState(false);
  const [confirmDelete, setConfirmDelete] = useState(false);
  const [imageUrl, setImageUrl] = useState<string | null>(null);
  const syntaxInput = useRef<HTMLInputElement>(null);
  const imageInput = useRef<HTMLInputElement>(null);
  const steps = useComCodeMap("LABEL STEP");
  const key = editing ? { modelName: editing.modelName, labelFormNo: editing.labelFormNo } : null;

  const loadValues = useCallback(async () => {
    if (!editing) { setValues(EMPTY_VALUES); setPreviews({}); return; }
    setLoadingValues(true);
    try {
      const res = await api.get("/master/label-forms/values", { params: { modelName: editing.modelName, labelFormNo: editing.labelFormNo } });
      const slots: LabelValueSlot[] = res.data?.data?.values ?? [];
      setValues({ ...EMPTY_VALUES, ...Object.fromEntries(slots.map((s) => [s.key, s.value ?? ""])) });
      setPreviews(Object.fromEntries(slots.map((s) => [s.key, s.preview])));
    } catch { setPreviews({}); }
    finally { setLoadingValues(false); }
  }, [editing]);

  useEffect(() => {
    setForm(editing
      ? { modelName: editing.modelName, labelFormNo: String(editing.labelFormNo), labelFormType: editing.labelFormType, useFlag: editing.useFlag ?? "", comments: editing.comments ?? "" }
      : EMPTY);
    void loadValues();
  }, [editing, loadValues]);

  // 미리보기 이미지
  useEffect(() => {
    let url: string | null = null;
    setImageUrl(null);
    if (!editing || editing.imageSize <= 0) return;
    api.get("/master/label-forms/file", { params: { modelName: editing.modelName, labelFormNo: editing.labelFormNo, kind: "image" }, responseType: "blob" })
      .then((res) => { url = URL.createObjectURL(res.data); setImageUrl(url); })
      .catch(() => setImageUrl(null));
    return () => { if (url) URL.revokeObjectURL(url); };
  }, [editing]);

  const set = (k: keyof typeof EMPTY, v: string) => setForm((prev) => ({ ...prev, [k]: v }));
  const valid = form.modelName.trim() && Number(form.labelFormNo) >= 1 && form.labelFormType;

  const save = async () => {
    if (!valid) return;
    setSaving(true);
    try {
      const body = {
        modelName: form.modelName.trim(),
        labelFormNo: Number(form.labelFormNo),
        labelFormName: editing?.labelFormName ?? undefined,
        labelFormType: form.labelFormType,
        useFlag: form.useFlag || undefined,
        comments: form.comments,
        values,
      };
      if (editing) await api.put("/master/label-forms", { ...body, originalModelName: editing.modelName, originalLabelFormNo: editing.labelFormNo });
      else await api.post("/master/label-forms", body);
      toast.success(editing ? "라벨 양식을 수정했습니다." : "라벨 양식을 등록했습니다. 이제 양식 파일을 올릴 수 있습니다.");
      onChanged({ modelName: body.modelName, labelFormNo: body.labelFormNo });
    } catch { /* API 오류는 인터셉터가 알린다 */ }
    finally { setSaving(false); }
  };

  const remove = async () => {
    if (!key) return;
    setSaving(true);
    try {
      await api.delete("/master/label-forms", { params: key });
      toast.success("라벨 양식을 삭제했습니다.");
      setConfirmDelete(false);
      onChanged(null);
    } catch { /* API 오류는 인터셉터가 알린다 */ }
    finally { setSaving(false); }
  };

  const upload = async (kind: "syntax" | "image", file: File | undefined) => {
    if (!key || !file) return;
    const data = new FormData();
    data.append("file", file);
    try {
      await api.post("/master/label-forms/file", data, { params: { ...key, kind }, headers: { "Content-Type": "multipart/form-data" } });
      toast.success(kind === "syntax" ? "양식 파일을 올렸습니다." : "이미지를 올렸습니다.");
      onChanged(key);
    } catch { /* API 오류는 인터셉터가 알린다 */ }
    finally {
      if (syntaxInput.current) syntaxInput.current.value = "";
      if (imageInput.current) imageInput.current.value = "";
    }
  };

  const download = async (kind: "syntax" | "image") => {
    if (!key) return;
    try {
      const res = await api.get("/master/label-forms/file", { params: { ...key, kind }, responseType: "blob" });
      const url = URL.createObjectURL(res.data);
      const a = document.createElement("a");
      a.href = url;
      a.download = fileNameOf(res.headers["content-disposition"], `${key.modelName}_${key.labelFormNo}${kind === "syntax" ? ".btw" : ""}`);
      a.click();
      URL.revokeObjectURL(url);
    } catch { /* API 오류는 인터셉터가 알린다 */ }
  };

  return (
    <aside className="flex h-full w-[560px] shrink-0 flex-col border-l border-border bg-background shadow-xl">
      <header className="flex h-14 items-center justify-between border-b border-border px-5">
        <h2 className="font-bold text-text">{editing ? `${editing.modelName} · 양식 ${editing.labelFormNo}` : "라벨 양식 등록"}</h2>
        <button title="닫기" onClick={onClose}><X className="h-5 w-5" /></button>
      </header>
      <div className="flex-1 space-y-5 overflow-y-auto p-5 text-sm">
        <section className="space-y-3">
          <ModelSearchField label="모델명" required value={form.modelName} onChange={(v) => set("modelName", v)} className="w-full" />
          <div className="grid grid-cols-3 gap-3">
            <Input label="양식번호 *" type="number" min="1" value={form.labelFormNo} onChange={(e) => set("labelFormNo", e.target.value)} fullWidth />
            <ComCodeSelect label="유형 *" groupCode="LABEL FORM TYPE" includeAll={false} value={form.labelFormType} onChange={(v) => set("labelFormType", v)} fullWidth />
            <Select label="사용" options={[{ value: "", label: "-" }, { value: "Y", label: "사용" }, { value: "N", label: "미사용" }]} value={form.useFlag} onChange={(v) => set("useFlag", v)} fullWidth />
          </div>
          <Input label="비고" value={form.comments} onChange={(e) => set("comments", e.target.value)} maxLength={1000} fullWidth />
        </section>

        <section className="space-y-2 rounded-[var(--radius)] border border-border p-3">
          <h3 className="font-semibold text-text">양식 파일 · 미리보기 이미지</h3>
          {!editing ? (
            <p className="text-xs text-text-muted">양식을 먼저 저장하면 파일을 올릴 수 있습니다.</p>
          ) : (
            <>
              <div className="flex items-center gap-2">
                <span className="min-w-0 flex-1 truncate" title={editing.labelFormName ?? ""}>
                  {editing.syntaxSize > 0 ? `${editing.labelFormName ?? "(이름 없음)"} · ${(editing.syntaxSize / 1024).toFixed(1)} KB` : <span className="text-text-muted">양식 파일 없음</span>}
                </span>
                <input ref={syntaxInput} type="file" accept=".btw" className="hidden" onChange={(e) => void upload("syntax", e.target.files?.[0])} />
                <Button size="sm" variant="secondary" onClick={() => syntaxInput.current?.click()}><Upload className="mr-1 h-4 w-4" />양식 올리기</Button>
                <Button size="sm" variant="secondary" onClick={() => void download("syntax")} disabled={editing.syntaxSize <= 0}><Download className="mr-1 h-4 w-4" />내려받기</Button>
              </div>
              <div className="flex items-center gap-2">
                <span className="min-w-0 flex-1 truncate">
                  {editing.imageSize > 0 ? `미리보기 이미지 · ${(editing.imageSize / 1024).toFixed(1)} KB` : <span className="text-text-muted">미리보기 이미지 없음</span>}
                </span>
                <input ref={imageInput} type="file" accept=".bmp,.png,.jpg,.jpeg" className="hidden" onChange={(e) => void upload("image", e.target.files?.[0])} />
                <Button size="sm" variant="secondary" onClick={() => imageInput.current?.click()}><Upload className="mr-1 h-4 w-4" />이미지 올리기</Button>
                <Button size="sm" variant="secondary" onClick={() => void download("image")} disabled={editing.imageSize <= 0}><Download className="mr-1 h-4 w-4" />내려받기</Button>
              </div>
              {imageUrl && <img src={imageUrl} alt="라벨 미리보기" className="max-h-56 rounded border border-border bg-white object-contain" />}
            </>
          )}
        </section>

        <section className="space-y-2">
          <div className="flex items-baseline justify-between">
            <h3 className="font-semibold text-text">라벨 값 칸 (V1~V20)</h3>
            <span className="text-xs text-text-muted">{loadingValues ? "미리보기 값을 만드는 중…" : "미리보기는 저장된 값 기준"}</span>
          </div>
          <datalist id="label-step-codes">
            {Object.values(steps).map((s) => <option key={s.detailCode} value={s.detailCode}>{s.codeName}</option>)}
          </datalist>
          <table className="w-full table-fixed border-collapse text-xs">
            <thead>
              <tr className="bg-surface text-text-muted">
                <th className="w-12 border border-border px-2 py-1 text-left">칸</th>
                <th className="w-44 border border-border px-2 py-1 text-left">항목</th>
                <th className="border border-border px-2 py-1 text-left">의미</th>
                <th className="border border-border px-2 py-1 text-left">미리보기 값</th>
              </tr>
            </thead>
            <tbody>
              {VALUE_KEYS.map((k) => {
                const code = values[k]?.trim() ?? "";
                const meaning = code ? (steps[code]?.codeName ?? "고정 문자") : "";
                return (
                  <tr key={k}>
                    <td className="border border-border px-2 py-0.5 font-mono">{k.toUpperCase()}</td>
                    <td className="border border-border p-0.5">
                      <input
                        list="label-step-codes"
                        aria-label={`${k.toUpperCase()} 항목`}
                        value={values[k] ?? ""}
                        maxLength={50}
                        onChange={(e) => setValues((prev) => ({ ...prev, [k]: e.target.value }))}
                        className="h-7 w-full rounded border border-transparent bg-transparent px-1.5 font-mono focus:border-primary focus:outline-none"
                      />
                    </td>
                    <td className="truncate border border-border px-2 py-0.5 text-text-muted" title={meaning}>{meaning}</td>
                    <td className="truncate border border-border px-2 py-0.5 font-mono" title={previews[k] ?? ""}>{previews[k] ?? ""}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </section>
      </div>
      <footer className="flex items-center justify-between gap-2 border-t border-border p-4">
        {editing ? <Button variant="danger" onClick={() => setConfirmDelete(true)} disabled={saving}><Trash2 className="mr-1 h-4 w-4" />삭제</Button> : <span />}
        <div className="flex gap-2">
          <Button variant="secondary" onClick={onClose}>취소</Button>
          <Button onClick={save} disabled={!valid || saving} isLoading={saving}>저장</Button>
        </div>
      </footer>
      <ConfirmModal
        isOpen={confirmDelete}
        onClose={() => setConfirmDelete(false)}
        onConfirm={remove}
        title="라벨 양식 삭제"
        message={editing ? `${editing.modelName} 의 양식 ${editing.labelFormNo} 을(를) 양식 파일·이미지와 함께 삭제합니다. 이 모델의 라벨 발행에서 이 양식을 더 쓸 수 없습니다.` : ""}
        confirmText="삭제"
        variant="danger"
        isLoading={saving}
      />
    </aside>
  );
}
