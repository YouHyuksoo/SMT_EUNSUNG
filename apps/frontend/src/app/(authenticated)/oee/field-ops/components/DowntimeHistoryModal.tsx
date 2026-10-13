'use client';

/**
 * @file (authenticated)/oee/field-ops/components/DowntimeHistoryModal.tsx
 * @description 비가동 이력(이전 30일) 팝업 — 설비 운영 현황의 우측 목록을 그대로 옮겨 담는다.
 */
import { Modal } from '@/components/ui';
import DataGrid from '@/components/data-grid/DataGrid';
import type { RecentRow } from '../../equip-ops-status/types';
import { recentColumns } from '../../equip-ops-status/components/downtime-columns';

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
      <DataGrid
        data={recent.list}
        columns={recentColumns}
        pageSize={100}
        maxHeight="60vh"
        enableFullscreen={false}
        enableExport
        exportFileName="비가동이력_30일"
        getRowId={(d) => String(d.dtSeq)}
        emptyMessage="이전 30일 비가동 이력이 없습니다"
      />
    </Modal>
  );
}
