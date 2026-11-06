"use client";

/**
 * @file production/run-card/components/PrintPreviewModal.tsx
 * @description 출력 미리보기 + 브라우저 인쇄
 *
 * 초보자 가이드:
 * 1. **미리보기와 인쇄본은 같은 내용을 두 번 그린다.** 미리보기는 모달 안에, 인쇄본은 body 바로 아래
 *    `.lot-card-print-root` 에 그린다. 인쇄할 때는 CSS 로 그 밖의 모든 것(화면·모달)을 숨긴다.
 * 2. **용지 크기는 `@page` 로 준다.** 롯트카드·출고계획은 A4, PID 라벨은 9×12mm 한 장씩이다.
 *    라벨 프린터는 드라이버에 같은 용지가 잡혀 있어야 한다.
 * 3. 바코드 이미지는 비동기로 그려진다. 미리보기에 바코드가 보인 뒤 인쇄를 누른다.
 */
import { useEffect, useState } from 'react';
import { createPortal } from 'react-dom';
import { Printer } from 'lucide-react';
import { Button } from '@/components/ui';
import Modal from '@/components/ui/Modal';

export default function PrintPreviewModal({ isOpen, title, pageSize, onClose, children, summary }: {
  isOpen: boolean;
  title: string;
  /** CSS @page size — 예: 'A4 portrait', '9mm 12mm' */
  pageSize: string;
  onClose: () => void;
  children: React.ReactNode;
  summary?: React.ReactNode;
}) {
  const [mounted, setMounted] = useState(false);
  useEffect(() => { setMounted(true); }, []);

  return (
    <Modal isOpen={isOpen} onClose={onClose} title={title} size="full">
      <div className="flex h-[78vh] flex-col gap-3">
        <div className="flex items-center justify-between gap-3">
          <div className="text-sm text-text-muted">{summary}</div>
          <div className="flex gap-2">
            <Button variant="secondary" onClick={onClose}>닫기</Button>
            <Button onClick={() => window.print()}>
              <Printer className="mr-1 h-4 w-4" />인쇄
            </Button>
          </div>
        </div>
        <div className="min-h-0 flex-1 overflow-auto rounded border border-border bg-slate-200 p-4 dark:bg-slate-700">
          <div className="lot-card-preview flex flex-wrap items-start gap-4">{children}</div>
        </div>
      </div>
      {isOpen && mounted && createPortal(
        <div className="lot-card-print-root">
          <style>{`
            .lot-card-print-root { display: none; }
            @media print {
              body > *:not(.lot-card-print-root) { display: none !important; }
              .lot-card-print-root { display: block; }
              .lot-card-print-root .print-page { break-after: page; box-shadow: none !important; margin: 0 !important; }
              .lot-card-print-root .print-page:last-child { break-after: auto; }
              @page { size: ${pageSize}; margin: 0; }
              html, body { background: #fff !important; }
            }
          `}</style>
          {children}
        </div>,
        document.body,
      )}
    </Modal>
  );
}
