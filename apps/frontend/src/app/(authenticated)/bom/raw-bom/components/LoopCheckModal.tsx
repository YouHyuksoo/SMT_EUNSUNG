"use client";

/**
 * @file src/app/(authenticated)/bom/raw-bom/components/LoopCheckModal.tsx
 * @description 원단위BOM 순환 검사 결과 모달 — PB Loop Check / Show Loop 버튼 대체
 *
 * 초보자 가이드:
 * 1. 순환이 있을 때만 연다(없으면 부모가 토스트로 알린다).
 * 2. 경로는 가장 작은 품목코드부터 시작해 같은 품목으로 끝난다.
 * 3. 검사는 유효기간과 관계없이 ID_ENG_BOM 의 모든 행을 본다(PB 와 같다).
 */
import { Modal } from '@/components/ui';
import type { RawBomLoopResult } from '../types';

interface Props {
  result: RawBomLoopResult | null;
  onClose: () => void;
}

export default function LoopCheckModal({ result, onClose }: Props) {
  return (
    <Modal
      isOpen={!!result}
      onClose={onClose}
      size="lg"
      title="BOM 순환 검사 결과"
      subtitle={result ? `${result.itemCode ? `${result.itemCode} 하위 전개 범위` : '조직 전체'} · 순환 ${result.total}건 · 유효기간 무관 전체 행 기준` : undefined}
    >
      <ol className="space-y-2">
        {result?.loops.map((loop) => (
          <li key={loop.path.join('>')} className="rounded-md border border-red-500/40 bg-red-500/5 p-2 text-sm">
            <span className="mr-2 text-xs text-text-muted">{loop.length === 1 ? '자기참조' : `${loop.length}단계`}</span>
            <span className="font-mono text-text">{loop.path.join(' → ')}</span>
          </li>
        ))}
      </ol>
    </Modal>
  );
}
