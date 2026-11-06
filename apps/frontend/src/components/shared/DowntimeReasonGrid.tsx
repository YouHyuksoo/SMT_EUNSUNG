'use client';

/**
 * @file src/components/shared/DowntimeReasonGrid.tsx
 * @description 비가동 사유 선택 버튼 그리드 — 비가동 사유를 고르는 화면은 모두 이 모양을 쓴다.
 *
 * 버튼마다 사유명(굵게) + 코드(작게)를 보이고, 고른 버튼은 primary 로 칠한다.
 * allowClear 면 같은 버튼을 다시 눌러 선택을 푼다(onChange('')).
 * 감싸는 곳(인라인/모달/패널)은 호출하는 쪽이 정한다.
 *
 * 사용 예:
 *   <DowntimeReasonGrid reasons={list} value={code} onChange={setCode} />
 *   <DowntimeReasonGrid reasons={list} value={code} onChange={pick} columns={3} dense />
 */
import type { Ref } from 'react';

export interface DowntimeReasonOption {
  code: string;
  name: string;
}

interface Props {
  reasons: DowntimeReasonOption[];
  value: string | null | undefined;
  onChange: (code: string) => void;
  /** 열 수 (기본 2) */
  columns?: 2 | 3 | 4;
  /** 좁은 패널용 — 버튼 높이만 줄인다 */
  dense?: boolean;
  /** 같은 버튼을 다시 누르면 선택 해제 (기본 true) */
  allowClear?: boolean;
  disabled?: boolean;
  emptyText?: string;
  /** 모달을 열 때 첫 버튼에 포커스를 주고 싶을 때 */
  firstButtonRef?: Ref<HTMLButtonElement>;
}

const COLS = { 2: 'grid-cols-2', 3: 'grid-cols-3', 4: 'grid-cols-4' } as const;
const SPAN = { 2: 'col-span-2', 3: 'col-span-3', 4: 'col-span-4' } as const;

export default function DowntimeReasonGrid({
  reasons, value, onChange, columns = 2, dense = false, allowClear = true, disabled = false,
  emptyText = '연계된 비가동 사유가 없습니다', firstButtonRef,
}: Props) {
  return (
    <div className={`grid ${COLS[columns]} gap-2`}>
      {reasons.map((r, index) => {
        const active = value === r.code;
        return (
          <button
            key={r.code}
            ref={index === 0 ? firstButtonRef : undefined}
            type="button"
            disabled={disabled}
            aria-pressed={active}
            onClick={() => onChange(active && allowClear ? '' : r.code)}
            className={`flex flex-col items-center justify-center rounded border px-2 text-xs text-center transition-colors disabled:cursor-not-allowed disabled:opacity-50 ${
              dense ? 'min-h-[34px] py-1' : 'min-h-[44px] py-1.5'
            } ${active ? 'bg-primary text-white border-primary' : 'border-border bg-background text-text hover:border-primary/60'}`}
          >
            <span className="block font-medium leading-tight">{r.name}</span>
            <span className={`block text-[10px] font-mono ${active ? 'text-white/80' : 'text-text-muted'}`}>{r.code}</span>
          </button>
        );
      })}
      {!reasons.length && <span className={`${SPAN[columns]} py-2 text-xs text-text-muted`}>{emptyText}</span>}
    </div>
  );
}
