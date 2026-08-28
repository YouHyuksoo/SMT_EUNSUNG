"use client";

/**
 * @file src/components/ui/Modal.tsx
 * @description 모달 다이얼로그 컴포넌트
 *
 * 초보자 가이드:
 * 1. **isOpen**: 모달 표시 여부
 * 2. **onClose**: 닫기 콜백
 * 3. **size**: 모달 크기 (sm, md, lg, xl, full)
 * 4. **Portal**: body에 직접 렌더링하여 z-index 문제 방지
 */
import { useEffect, useCallback, useRef, useState, Fragment } from 'react';
import { createPortal } from 'react-dom';
import { useTranslation } from 'react-i18next';
import { X, AlertTriangle, HelpCircle, Copy, Check } from 'lucide-react';
import Button from './Button';

export interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title?: string;
  subtitle?: string;
  children: React.ReactNode;
  size?: 'sm' | 'md' | 'lg' | 'xl' | '2xl' | 'full';
  showCloseButton?: boolean;
  closeOnOverlayClick?: boolean;
  closeOnEsc?: boolean;
  footer?: React.ReactNode;
  initialFocusRef?: React.RefObject<HTMLElement | null>;
}

const FOCUSABLE_SELECTOR = [
  'a[href]:not([tabindex="-1"])',
  'button:not([disabled]):not([tabindex="-1"])',
  'input:not([disabled]):not([type="hidden"]):not([tabindex="-1"])',
  'select:not([disabled]):not([tabindex="-1"])',
  'textarea:not([disabled]):not([tabindex="-1"])',
  '[contenteditable="true"]:not([tabindex="-1"])',
  '[tabindex]:not([tabindex="-1"])',
].join(',');

function getFocusableElements(container: HTMLElement): HTMLElement[] {
  return Array.from(container.querySelectorAll<HTMLElement>(FOCUSABLE_SELECTOR)).filter(
    (element) => !element.hasAttribute('hidden') && element.getAttribute('aria-hidden') !== 'true',
  );
}

function Modal({
  isOpen,
  onClose,
  title,
  subtitle,
  children,
  size = 'md',
  showCloseButton = true,
  closeOnOverlayClick = true,
  closeOnEsc = true,
  footer,
  initialFocusRef,
}: ModalProps) {
  const { t } = useTranslation();
  const modalRef = useRef<HTMLDivElement>(null);
  const openerRef = useRef<HTMLElement | null>(null);
  const bodyOverflowRef = useRef('');
  const openerCapturedRef = useRef(false);
  const onCloseRef = useRef(onClose);
  const closeOnEscRef = useRef(closeOnEsc);

  useEffect(() => {
    onCloseRef.current = onClose;
    closeOnEscRef.current = closeOnEsc;
  }, [closeOnEsc, onClose]);

  // ESC 키로 닫고 Tab 키는 다이얼로그 내부에 가둔다.
  const handleKeyDown = useCallback(
    (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        if (closeOnEscRef.current) onCloseRef.current();
        return;
      }

      if (e.key !== 'Tab') return;

      const panel = modalRef.current;
      if (!panel) return;

      const focusableElements = getFocusableElements(panel);
      if (focusableElements.length === 0) {
        e.preventDefault();
        panel.focus();
        return;
      }

      const firstFocusable = focusableElements[0];
      const lastFocusable = focusableElements[focusableElements.length - 1];
      const activeElement = document.activeElement;
      const focusIsInside = activeElement instanceof HTMLElement && panel.contains(activeElement);

      if (e.shiftKey && (!focusIsInside || activeElement === firstFocusable || activeElement === panel)) {
        e.preventDefault();
        lastFocusable.focus();
      } else if (!e.shiftKey && (!focusIsInside || activeElement === lastFocusable || activeElement === panel)) {
        e.preventDefault();
        firstFocusable.focus();
      }
    },
    [],
  );

  useEffect(() => {
    if (!isOpen) return;

    if (!openerCapturedRef.current) {
      const activeElement = document.activeElement;
      openerRef.current = activeElement instanceof HTMLElement ? activeElement : null;
      bodyOverflowRef.current = document.body.style.overflow;
      openerCapturedRef.current = true;
    }

    document.addEventListener('keydown', handleKeyDown);
    document.body.style.overflow = 'hidden';

    const focusFrame = window.requestAnimationFrame(() => {
      const panel = modalRef.current;
      if (!panel) return;
      const preferredFocus = initialFocusRef?.current;
      const firstFocusable = getFocusableElements(panel)[0];
      (preferredFocus && panel.contains(preferredFocus) ? preferredFocus : firstFocusable ?? panel).focus();
    });

    return () => {
      document.removeEventListener('keydown', handleKeyDown);
      window.cancelAnimationFrame(focusFrame);
      document.body.style.overflow = bodyOverflowRef.current;

      if (openerCapturedRef.current) {
        openerCapturedRef.current = false;
        const opener = openerRef.current;
        openerRef.current = null;
        if (opener?.isConnected) opener.focus();
      }
    };
  }, [handleKeyDown, initialFocusRef, isOpen]);

  if (!isOpen) return null;

  // Size 스타일
  const sizeStyles = {
    sm: 'max-w-sm',         // 384px (확인/알림용)
    md: 'max-w-lg',         // 512px (일반 폼)
    lg: 'max-w-xl',         // 576px (복잡한 폼)
    xl: 'max-w-2xl',        // 672px (대형 폼/테이블)
    '2xl': 'max-w-5xl',     // 1024px (다컬럼 테이블 모달)
    full: 'max-w-[90vw] max-h-[90vh]',
  };

  const modalContent = (
    <Fragment>
      {/* Overlay */}
      <div
        className="fixed inset-0 z-50 bg-black/50 backdrop-blur-sm animate-fade-in"
        onClick={closeOnOverlayClick ? onClose : undefined}
        aria-hidden="true"
      />

      {/* Modal */}
      <div className="pointer-events-none fixed inset-0 z-50 flex items-center justify-center p-4">
        <div
          className={`
            pointer-events-auto w-full ${sizeStyles[size]}
            bg-surface
            rounded-[var(--radius)]
            shadow-2xl
            animate-slide-up
          `}
          ref={modalRef}
          role="dialog"
          aria-modal="true"
          aria-labelledby={title ? 'modal-title' : undefined}
          tabIndex={-1}
          onClick={(e) => e.stopPropagation()}
        >
          {/* Header */}
          {(title || subtitle || showCloseButton) && (
            <div className="flex items-center justify-between p-4 border-b border-border">
              {(title || subtitle) && (
                <div>
                  {title && (
                    <h2
                      id="modal-title"
                      className="text-lg font-semibold text-text"
                    >
                      {title}
                    </h2>
                  )}
                  {subtitle && (
                    <p className="mt-1 text-sm text-text-muted">
                      {subtitle}
                    </p>
                  )}
                </div>
              )}
              {showCloseButton && (
                <button
                  type="button"
                  onClick={onClose}
                  className="p-1 rounded-md text-text-muted hover:text-text hover:bg-background transition-colors"
                  aria-label={t('common.close')}
                >
                  <X className="w-5 h-5" />
                </button>
              )}
            </div>
          )}

          {/* Content */}
          <div className="p-4 overflow-y-auto max-h-[75vh]">{children}</div>

          {/* Footer */}
          {footer && (
            <div className="flex items-center justify-end gap-3 p-4 border-t border-border">
              {footer}
            </div>
          )}
        </div>
      </div>
    </Fragment>
  );

  // Portal로 body에 렌더링
  return createPortal(modalContent, document.body);
}

// 확인 다이얼로그 헬퍼
export interface ConfirmModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  title?: string;
  message: React.ReactNode;
  confirmText?: string;
  cancelText?: string;
  variant?: 'default' | 'danger';
  isLoading?: boolean;
}

export function ConfirmModal({
  isOpen,
  onClose,
  onConfirm,
  title,
  message,
  confirmText,
  cancelText,
  variant = 'default',
  isLoading = false,
}: ConfirmModalProps) {
  const { t } = useTranslation();
  const [copied, setCopied] = useState(false);
  const actualTitle = title ?? t('common.confirm');
  const actualConfirmText = confirmText ?? t('common.confirm');
  const actualCancelText = cancelText ?? t('common.cancel');

  const isDanger = variant === 'danger';
  const Icon = isDanger ? AlertTriangle : HelpCircle;
  const iconColor = isDanger ? 'text-red-500' : 'text-primary';
  const iconRing = isDanger
    ? 'border-red-500/30 bg-red-500/10'
    : 'border-primary/30 bg-primary/10';

  // 메시지가 문자열일 때만 복사 가능
  const copyText = typeof message === 'string' ? message : null;

  const handleClose = useCallback(() => {
    setCopied(false);
    onClose();
  }, [onClose]);

  const handleCopy = useCallback(async () => {
    if (!copyText) return;
    try {
      await navigator.clipboard.writeText(copyText);
      setCopied(true);
      setTimeout(() => setCopied(false), 1500);
    } catch {
      // 클립보드 접근 불가 시 무시
    }
  }, [copyText]);

  return (
    <Modal
      isOpen={isOpen}
      onClose={handleClose}
      title={actualTitle}
      size="md"
      footer={
        <>
          <Button variant="ghost" onClick={handleClose} disabled={isLoading}>
            {actualCancelText}
          </Button>
          <Button
            variant={isDanger ? 'danger' : 'primary'}
            onClick={onConfirm}
            isLoading={isLoading}
          >
            {actualConfirmText}
          </Button>
        </>
      }
    >
      <div className="flex gap-4">
        <div
          className={`flex-shrink-0 w-11 h-11 rounded-full border flex items-center justify-center ${iconRing}`}
        >
          <Icon className={`w-6 h-6 ${iconColor}`} />
        </div>
        <div className="flex-1 min-w-0 pt-0.5">
          <div className="text-text leading-relaxed whitespace-pre-line">{message}</div>
          {copyText && (
            <button
              type="button"
              onClick={handleCopy}
              className="mt-3 inline-flex items-center gap-1.5 text-xs text-text-muted hover:text-text transition-colors"
            >
              {copied ? (
                <>
                  <Check className="w-3.5 h-3.5 text-green-500" />
                  {t('common.copied', '복사됨')}
                </>
              ) : (
                <>
                  <Copy className="w-3.5 h-3.5" />
                  {t('common.copy', '복사')}
                </>
              )}
            </button>
          )}
        </div>
      </div>
    </Modal>
  );
}

export default Modal;
