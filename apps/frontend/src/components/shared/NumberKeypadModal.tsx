'use client';

/**
 * @file components/shared/NumberKeypadModal.tsx
 * @description 현장 터치 입력용 숫자 키패드 — 실적 모달 위에 겹쳐 뜨는 작은 모달.
 *
 * 초보자 가이드:
 * 1. 값은 문자열 버퍼로 들고 있다가 [확인]에서 한 번에 숫자로 바꿔 돌려준다.
 *    입력 중 상태를 부모와 공유하지 않아 취소가 자연스럽다.
 *    버퍼는 마운트 시 1회만 초기화한다 — 부모가 필드별 key로 새로 마운트시킨다.
 * 2. 삭제는 마지막 한 자리, 초기화는 전체를 지운다. 빈 값은 0으로 본다.
 * 3. 부모(실적 등록 모달)보다 작게 띄운다 — size="md"(512px)로 부모 xl(672px)의 약 70%.
 */
import { useState } from 'react';
import { Delete, RotateCcw } from 'lucide-react';
import { Modal } from '@/components/ui';

interface Props {
  isOpen: boolean;
  /** 어떤 값을 입력받는지 (예: 실적수량) */
  label: string;
  /** 열릴 때의 현재값 */
  value: number;
  /** 값 뒤에 붙일 단위 (예: 분, 명) */
  unit?: string;
  onConfirm: (value: number) => void;
  onClose: () => void;
}

const KEYS = ['7', '8', '9', '4', '5', '6', '1', '2', '3', '00', '0'];

export default function NumberKeypadModal({ isOpen, label, value, unit, onConfirm, onClose }: Props) {
  // 열 때마다 새로 마운트되므로(부모가 key로 구분) 현재값으로 한 번만 초기화한다.
  // 0은 빈 값으로 둬야 덧입력이 자연스럽다.
  const [buf, setBuf] = useState(() => (value ? String(value) : ''));

  const push = (k: string) => setBuf((b) => (b === '0' ? k : (b + k).slice(0, 9)));
  const parsed = Number(buf || 0);

  return (
    <Modal isOpen={isOpen} onClose={onClose} size="md" title={label} showCloseButton={false}>
      <div className="space-y-3">
        {/* 입력값 표시 */}
        <div className="flex items-baseline justify-end gap-2 rounded-lg border-2 border-slate-300 dark:border-slate-600 bg-background px-4 py-3">
          <span className="font-mono text-3xl font-semibold text-text tabular-nums">
            {parsed.toLocaleString()}
          </span>
          {unit && <span className="text-sm text-text-muted">{unit}</span>}
        </div>

        <div className="grid grid-cols-3 gap-2">
          {KEYS.map((k) => (
            <button key={k} type="button" onClick={() => push(k)}
              className={`h-14 rounded-lg border-2 border-slate-300 dark:border-slate-600 bg-surface text-xl font-semibold text-text shadow-sm hover:border-primary active:bg-background active:scale-[0.98] transition-[transform,border-color] ${
                k === '0' ? 'col-span-2' : ''
              }`}>
              {k}
            </button>
          ))}
        </div>

        <div className="grid grid-cols-2 gap-2">
          <button type="button" onClick={() => setBuf((b) => b.slice(0, -1))}
            className="h-12 rounded-lg border-2 border-slate-300 dark:border-slate-600 text-sm font-medium text-text flex items-center justify-center gap-1.5 hover:bg-surface hover:border-primary">
            <Delete className="w-4 h-4" />삭제
          </button>
          <button type="button" onClick={() => setBuf('')}
            className="h-12 rounded-lg border-2 border-slate-300 dark:border-slate-600 text-sm font-medium text-text flex items-center justify-center gap-1.5 hover:bg-surface hover:border-primary">
            <RotateCcw className="w-4 h-4" />초기화
          </button>
        </div>

        <div className="grid grid-cols-2 gap-2">
          <button type="button" onClick={onClose}
            className="h-12 rounded-lg border-2 border-slate-300 dark:border-slate-600 text-sm font-medium text-text hover:bg-surface hover:border-primary">
            취소
          </button>
          <button type="button" onClick={() => { onConfirm(parsed); onClose(); }}
            className="h-12 rounded-lg bg-primary text-white text-sm font-semibold hover:bg-primary/90">
            확인
          </button>
        </div>
      </div>
    </Modal>
  );
}
