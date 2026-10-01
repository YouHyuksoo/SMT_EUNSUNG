"use client";

/**
 * @file src/app/(authenticated)/purchase/requirement/components/ExplodeFailuresModal.tsx
 * @description 477 자재소요량관리 — 소요량 전개 실패내역
 *
 * 초보자 가이드:
 * 1. 전개는 BOM 이 없는 기준계획 줄을 건너뛰고 나머지만 편다. 여기서 빠진 줄을 본다.
 * 2. 서버가 전개와 같은 조건으로 그때그때 계산한다 — 전개 전에 열면 "전개하면 빠질 줄"이다.
 * 3. BOM 을 등록한 뒤 다시 전개하면 이 목록에서 사라진다.
 */
import { useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import type { ColumnDef } from '@tanstack/react-table';
import { Modal } from '@/components/ui';
import DataGrid from '@/components/data-grid/DataGrid';
import api from '@/services/api';

interface FailureRow {
  planDate: string;
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  orderQty: number;
  reason: string;
}

interface Props {
  isOpen: boolean;
  onClose: () => void;
  requirementPlanDate: string;
}

const columns: ColumnDef<FailureRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 220 },
  { accessorKey: 'itemSpec', header: '규격', size: 120 },
  { accessorKey: 'planDate', header: '계획일', size: 100 },
  {
    accessorKey: 'orderQty',
    header: '수량',
    size: 90,
    meta: { align: 'right' },
    cell: (c) => Number(c.getValue() ?? 0).toLocaleString(),
  },
  { accessorKey: 'reason', header: '실패 사유', size: 200 },
];

export default function ExplodeFailuresModal({ isOpen, onClose, requirementPlanDate }: Props) {
  const [rows, setRows] = useState<FailureRow[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!isOpen) return;
    let alive = true;
    setLoading(true);
    api.get('/purchase/requirement/explode-failures', { params: { requirementPlanDate } })
      .then((r) => { if (alive) setRows((r.data?.data ?? []) as FailureRow[]); })
      .catch(() => { if (alive) toast.error('실패내역 조회에 실패했습니다.'); })
      .finally(() => { if (alive) setLoading(false); });
    return () => { alive = false; };
  }, [isOpen, requirementPlanDate]);

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title="전개 실패내역"
      subtitle={`기준일자 ${requirementPlanDate} — BOM 이 없어 소요량 전개에서 빠지는 기준계획입니다. BOM 을 등록한 뒤 다시 전개하세요.`}
      size="xl"
    >
      <div className="h-[55vh] min-h-0">
        <DataGrid
          data={rows}
          columns={columns}
          isLoading={loading}
          pageSize={100}
          enableExport
          exportFileName="소요량전개_실패내역"
          getRowId={(r) => `${(r as FailureRow).planDate}|${(r as FailureRow).itemCode}`}
          emptyMessage="실패한 기준계획이 없습니다."
        />
      </div>
    </Modal>
  );
}
