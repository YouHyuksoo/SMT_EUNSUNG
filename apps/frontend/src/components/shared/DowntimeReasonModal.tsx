'use client';

/**
 * @file src/components/shared/DowntimeReasonModal.tsx
 * @description 비가동 사유 선택 모달 — 설비정지 모달(EquipDowntimePanel)과 같은 껍데기·사유 칸을 쓴다.
 *
 * 껍데기: Modal 2xl + 헤더 [닫기]. 본문: "비가동 사유" 라벨 + DowntimeReasonGrid(2열).
 * 사유를 고르면 onChange 후 닫는다(선택 해제는 닫지 않는다).
 *
 * 사용 예:
 *   <DowntimeReasonModal isOpen={open} onClose={close} reasons={list} value={code} onChange={setCode} required />
 */
import type { RefObject } from 'react';
import { Loader2, RefreshCw } from 'lucide-react';
import { Modal } from '@/components/ui';
import DowntimeReasonGrid, { type DowntimeReasonOption } from './DowntimeReasonGrid';

interface Props {
  isOpen: boolean;
  onClose: () => void;
  reasons: DowntimeReasonOption[];
  value: string | null | undefined;
  onChange: (code: string) => void;
  /** 필수 표시(*) — 종료처럼 사유가 꼭 있어야 할 때 */
  required?: boolean;
  /** 같은 버튼을 다시 눌러 선택 해제 (기본 true) */
  allowClear?: boolean;
  title?: string;
  loading?: boolean;
  error?: string | null;
  onRetry?: () => void;
  emptyText?: string;
  firstButtonRef?: RefObject<HTMLButtonElement | null>;
}

export default function DowntimeReasonModal({
  isOpen, onClose, reasons, value, onChange, required = false, allowClear = true,
  title = '비가동 사유 선택', loading = false, error = null, onRetry, emptyText, firstButtonRef,
}: Props) {
  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title={title}
      size="2xl"
      bodyMaxHeightClass="max-h-[85vh]"
      initialFocusRef={firstButtonRef}
      headerActions={
        <button type="button" onClick={onClose}
          className="h-9 px-4 rounded-lg border border-border text-sm font-medium text-text hover:bg-surface">닫기</button>
      }
    >
      <div className="flex flex-col gap-1.5" data-testid="downtime-reason-modal">
        <span className="text-sm text-text-muted">
          비가동 사유 {required ? <span className="text-red-500">*</span> : <span className="text-[11px]">(선택)</span>}
        </span>
        {loading && (
          <p className="flex min-h-[44px] items-center gap-2 text-sm text-text-muted">
            <Loader2 className="h-5 w-5 animate-spin" aria-hidden="true" />사유 목록을 불러오는 중입니다.
          </p>
        )}
        {!loading && error && (
          <div className="flex items-center justify-between gap-2 rounded border border-red-300 bg-red-500/5 p-2 text-sm text-red-600">
            <span>{error}</span>
            {onRetry && (
              <button type="button" onClick={onRetry}
                className="inline-flex h-9 items-center gap-1.5 rounded-lg border border-border px-3 font-medium text-text hover:bg-surface">
                <RefreshCw className="h-4 w-4" aria-hidden="true" />다시 시도
              </button>
            )}
          </div>
        )}
        {!loading && !error && (
          <DowntimeReasonGrid
            reasons={reasons}
            value={value}
            allowClear={allowClear}
            firstButtonRef={firstButtonRef}
            emptyText={emptyText}
            onChange={(code) => {
              onChange(code);
              if (code) onClose();
            }}
          />
        )}
      </div>
    </Modal>
  );
}
