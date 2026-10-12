"use client";

/**
 * @file src/app/(authenticated)/production/smd-plan-board/components/NoteEditor.tsx
 * @description 특이사항·공지 편집칸 — 한 줄이 메모 한 줄이다. 저장하면 그 날짜+라인의 메모를 통째로 바꾼다.
 *
 * 기존 메모가 있는데 전부 지우고 저장하면 확인창을 띄운다 (삭제와 같기 때문).
 */
import { useState } from 'react';
import { Button, ConfirmModal } from '@/components/ui';

interface NoteEditorProps {
  initialLines: string[];
  placeholder: string;
  saving: boolean;
  onSave: (lines: string[]) => void;
  onCancel: () => void;
}

const MAX_LINES = 30;
const MAX_LENGTH = 500;

export default function NoteEditor({ initialLines, placeholder, saving, onSave, onCancel }: NoteEditorProps) {
  const [text, setText] = useState(initialLines.join('\n'));
  const [confirmClear, setConfirmClear] = useState(false);

  const lines = text.split('\n').map((line) => line.trim()).filter((line) => line.length > 0);
  const tooMany = lines.length > MAX_LINES;
  const tooLong = lines.some((line) => line.length > MAX_LENGTH);

  const submit = () => {
    if (lines.length === 0 && initialLines.length > 0) {
      setConfirmClear(true);
      return;
    }
    onSave(lines);
  };

  return (
    <div className="flex flex-col gap-2">
      <textarea
        autoFocus
        rows={Math.min(Math.max(initialLines.length + 1, 3), 10)}
        value={text}
        placeholder={placeholder}
        onChange={(e) => setText(e.target.value)}
        className="w-full resize-y rounded-lg border border-border bg-background px-3 py-2 text-sm text-text focus:outline-none focus:ring-2 focus:ring-primary/40"
      />
      <div className="flex items-center justify-between gap-2">
        <span className={`text-xs ${tooMany || tooLong ? 'text-error' : 'text-text-muted'}`}>
          줄마다 한 항목으로 저장됩니다 · {lines.length}/{MAX_LINES}줄{tooLong ? ` · 한 줄은 ${MAX_LENGTH}자까지` : ''}
        </span>
        <div className="flex gap-2">
          <Button size="sm" variant="ghost" onClick={onCancel} disabled={saving}>취소</Button>
          <Button size="sm" onClick={submit} disabled={saving || tooMany || tooLong}>
            {saving ? '저장 중' : '저장'}
          </Button>
        </div>
      </div>
      <ConfirmModal
        isOpen={confirmClear}
        onClose={() => setConfirmClear(false)}
        onConfirm={() => { setConfirmClear(false); onSave([]); }}
        title="메모 삭제"
        message={`저장된 ${initialLines.length}줄을 모두 지웁니다.`}
        confirmText="삭제"
        variant="danger"
      />
    </div>
  );
}
