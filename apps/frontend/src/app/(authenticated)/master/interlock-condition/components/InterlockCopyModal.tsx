"use client";

/**
 * @file src/app/(authenticated)/master/interlock-condition/components/InterlockCopyModal.tsx
 * @description 한 라인의 인터락 조건을 다른 라인으로 복사하는 창
 */
import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import { Button, Modal } from "@/components/ui";
import LineSelect from "@/components/shared/LineSelect";
import api from "@/services/api";

interface Props {
  isOpen: boolean;
  defaultFromLine: string;
  onClose: () => void;
  onCopied: (toLineCode: string) => void;
}

export default function InterlockCopyModal({ isOpen, defaultFromLine, onClose, onCopied }: Props) {
  const [fromLineCode, setFromLineCode] = useState("");
  const [toLineCode, setToLineCode] = useState("");
  const [copying, setCopying] = useState(false);

  useEffect(() => {
    if (isOpen) { setFromLineCode(defaultFromLine); setToLineCode(""); }
  }, [isOpen, defaultFromLine]);

  const copy = async () => {
    setCopying(true);
    try {
      const res = await api.post("/master/interlock-conditions/copy", { fromLineCode, toLineCode });
      toast.success(res.data?.message ?? "인터락 조건을 복사했습니다.");
      onCopied(toLineCode);
    } catch { /* API 오류는 인터셉터가 알린다 */ }
    finally { setCopying(false); }
  };

  const valid = fromLineCode && toLineCode && fromLineCode !== toLineCode;

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title="라인 인터락 조건 복사"
      size="md"
      footer={
        <>
          <Button variant="secondary" onClick={onClose}>취소</Button>
          <Button onClick={copy} disabled={!valid || copying} isLoading={copying}>복사</Button>
        </>
      }
    >
      <div className="space-y-4 text-sm">
        <LineSelect label="원본 라인" value={fromLineCode} onChange={setFromLineCode} fullWidth />
        <LineSelect label="대상 라인" value={toLineCode} onChange={setToLineCode} fullWidth />
        <p className="text-xs text-text-muted">
          원본 라인의 조건을 전부 대상 라인으로 복사합니다. 대상 라인에 같은 공정·설비·검사유형·품목 조건이 이미 있으면 그 조건은 건너뜁니다.
        </p>
      </div>
    </Modal>
  );
}
