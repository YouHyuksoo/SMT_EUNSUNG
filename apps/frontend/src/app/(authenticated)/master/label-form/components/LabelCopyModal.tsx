"use client";

/**
 * @file src/app/(authenticated)/master/label-form/components/LabelCopyModal.tsx
 * @description 고른 라벨 양식을 다른 모델로 복사하는 창 (양식 파일·이미지·V1~V20 포함)
 */
import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import { Button, Modal } from "@/components/ui";
import ModelSearchField from "@/components/shared/ModelSearchField";
import api from "@/services/api";
import type { LabelForm } from "../types";

interface Props {
  isOpen: boolean;
  sources: LabelForm[];
  onClose: () => void;
  onCopied: (targetModelName: string) => void;
}

export default function LabelCopyModal({ isOpen, sources, onClose, onCopied }: Props) {
  const [target, setTarget] = useState("");
  const [copying, setCopying] = useState(false);

  useEffect(() => { if (isOpen) setTarget(""); }, [isOpen]);

  const copy = async () => {
    setCopying(true);
    try {
      const res = await api.post("/master/label-forms/copy", {
        sources: sources.map((s) => ({ modelName: s.modelName, labelFormNo: s.labelFormNo })),
        targetModelName: target.trim(),
      });
      toast.success(res.data?.message ?? "라벨 양식을 복사했습니다.");
      onCopied(target.trim());
    } catch { /* API 오류는 인터셉터가 알린다 */ }
    finally { setCopying(false); }
  };

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title="다른 모델로 양식 복사"
      size="md"
      footer={
        <>
          <Button variant="secondary" onClick={onClose}>취소</Button>
          <Button onClick={copy} disabled={!target.trim() || sources.length === 0 || copying} isLoading={copying}>복사</Button>
        </>
      }
    >
      <div className="space-y-4 text-sm">
        <div>
          <p className="mb-1 font-medium text-text">복사할 양식 {sources.length}건</p>
          <ul className="max-h-40 overflow-y-auto rounded border border-border text-xs">
            {sources.map((s) => (
              <li key={`${s.modelName}::${s.labelFormNo}`} className="flex gap-2 border-b border-border px-2 py-1 last:border-b-0">
                <span className="font-mono">{s.modelName}</span>
                <span className="text-text-muted">양식 {s.labelFormNo}</span>
                <span className="truncate text-text-muted">{s.labelFormName}</span>
              </li>
            ))}
          </ul>
        </div>
        <ModelSearchField label="대상 모델" required value={target} onChange={(v) => setTarget(v)} className="w-full" />
        <p className="text-xs text-text-muted">
          양식 파일·이미지·V1~V20 값을 그대로 복사합니다. 대상 모델에 같은 양식번호가 이미 있으면 아무것도 복사하지 않습니다.
        </p>
      </div>
    </Modal>
  );
}
