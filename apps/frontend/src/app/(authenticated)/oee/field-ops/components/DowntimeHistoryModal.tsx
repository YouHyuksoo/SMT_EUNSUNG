'use client';

/**
 * @file (authenticated)/oee/field-ops/components/DowntimeHistoryModal.tsx
 * @description 비가동 이력(이전 30일) 팝업 — 설비 운영 현황의 우측 목록을 그대로 옮겨 담는다.
 */
import { Modal } from '@/components/ui';
import type { RecentRow } from '../../equip-ops-status/types';

interface Props {
  isOpen: boolean;
  onClose: () => void;
  scopeLabel: string | null;
  recent: { list: RecentRow[]; totalCount: number; totalMinutes: number };
}

export default function DowntimeHistoryModal({ isOpen, onClose, scopeLabel, recent }: Props) {
  return (
    <Modal isOpen={isOpen} onClose={onClose} size="xl"
      title="비가동 이력 (이전 30일)" subtitle={scopeLabel ?? undefined}>
      <div className="flex items-baseline justify-end mb-2">
        <span className="text-[11px] text-text-muted">
          총 <span className="font-semibold text-text">{recent.totalCount}</span>회 ·
          <span className="font-semibold text-text"> {recent.totalMinutes.toLocaleString()}</span>분
        </span>
      </div>
      <div className="max-h-[60vh] overflow-auto border border-border rounded">
        <table className="w-full text-xs">
          <thead className="sticky top-0 bg-surface text-text-muted">
            <tr><th className="p-1.5 text-center font-medium">설비</th><th className="p-1.5 text-center font-medium">시작</th><th className="p-1.5 text-center font-medium">종료</th><th className="p-1.5 text-center font-medium">소요</th></tr>
          </thead>
          <tbody>
            {recent.list.map((d) => (
              <tr key={d.dtSeq} className="border-t border-border">
                <td className="p-1.5 text-center font-mono">
                  {d.machineCode}
                  {d.causeYn === 'Y' && (
                    <span className="ml-1 px-1 py-0.5 rounded bg-amber-500/15 text-amber-600 text-[10px] font-sans" title="라인 정지의 원인설비">원인</span>
                  )}
                </td>
                <td className="p-1.5 text-center font-mono">{d.startTime ?? '-'}</td>
                <td className="p-1.5 text-center font-mono">{d.endTime ?? <span className="text-red-500">진행중</span>}</td>
                <td className="p-1.5 text-center font-mono tabular-nums">{d.durationMin.toLocaleString()}분</td>
              </tr>
            ))}
            {!recent.list.length && (
              <tr><td colSpan={4} className="p-6 text-center text-text-muted">이전 30일 비가동 이력이 없습니다</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </Modal>
  );
}
