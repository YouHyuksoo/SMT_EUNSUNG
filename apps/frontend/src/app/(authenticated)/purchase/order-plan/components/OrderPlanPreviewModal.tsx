"use client";

/**
 * @file src/app/(authenticated)/purchase/order-plan/components/OrderPlanPreviewModal.tsx
 * @description 478 자재발주계획 — 생성 전에 발주량 계산 결과를 미리 본다 (저장하지 않음)
 *
 * 초보자 가이드:
 * 1. 서버가 생성과 **같은 계산**을 하고 저장하지 않는다 (POST /purchase/order-plan/preview).
 * 2. 줄마다 왜 그 발주량인지 보이게 나눠 보여 준다:
 *    소요량 → 재고(가지별) → 차감 → 불량 가산 → 올림(최소·포장) → 발주량.
 * 3. 상태 P 는 확정되지 않는 줄이다 — 사유 열에 이유가 나온다 (단가 기준정보 없음·공급처 미지정).
 * 4. "이대로 생성"을 누르면 페이지의 생성 확인 모달로 넘어간다.
 */
import { useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import type { ColumnDef } from '@tanstack/react-table';
import { Play } from 'lucide-react';
import { Button, Modal } from '@/components/ui';
import DataGrid from '@/components/data-grid/DataGrid';
import api from '@/services/api';

export interface OrderPlanPreviewLine {
  itemCode: string;
  itemName: string | null;
  lineType: string;
  supplierCode: string;
  supplierName: string | null;
  mfs: string;
  planDate: string;
  deliveryDate: string;
  orderQty: number;
  invStock: number;
  invOrder: number;
  invArrival: number;
  invWorkstage: number;
  invFree: number;
  appliedQty: number;
  badQty: number;
  roundUpQty: number;
  purchaseQty: number;
  unitPrice: number;
  currency: string;
  status: 'N' | 'P';
  statusReason: string | null;
}

interface PreviewData {
  lines: OrderPlanPreviewLine[];
  skippedItems: string[];
  summary: { lines: number; orderLines: number; heldLines: number; purchaseQty: number };
}

interface Props {
  isOpen: boolean;
  onClose: () => void;
  /** 생성과 같은 요청 본문 */
  body: Record<string, unknown>;
  onGenerate: () => void;
}

const qty = (v: unknown) => {
  const n = Number(v ?? 0);
  return n ? n.toLocaleString(undefined, { maximumFractionDigits: 4 }) : '';
};
const numCol = (key: keyof OrderPlanPreviewLine, header: string, size = 90): ColumnDef<OrderPlanPreviewLine> => ({
  accessorKey: key, header, size, meta: { align: 'right' }, cell: (c) => qty(c.getValue()),
});
const day = (v: string) => (v.endsWith(' 00:00:00') ? v.slice(0, 10) : v.slice(0, 16));

const columns: ColumnDef<OrderPlanPreviewLine>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 130 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'lineType', header: '거래유형', size: 70 },
  { id: 'supplier', header: '공급처', size: 120, accessorFn: (r) => r.supplierName ?? r.supplierCode },
  { id: 'deliveryDate', header: '납기', size: 110, accessorFn: (r) => day(r.deliveryDate) },
  numCol('orderQty', '소요량', 100),
  numCol('invStock', '창고재고'),
  numCol('invOrder', '발주잔량'),
  numCol('invArrival', '도착분'),
  numCol('invWorkstage', '공정재고'),
  numCol('invFree', '무상재고'),
  numCol('appliedQty', '차감'),
  numCol('badQty', '불량가산', 80),
  numCol('roundUpQty', '올림', 80),
  {
    accessorKey: 'purchaseQty', header: '발주량', size: 100, meta: { align: 'right' },
    cell: (c) => <span className="font-semibold">{qty(c.getValue())}</span>,
  },
  numCol('unitPrice', '단가', 80),
  {
    id: 'status', header: '상태', size: 150,
    accessorFn: (r) => (r.status === 'N' ? '확정 가능' : `P · ${r.statusReason ?? ''}`),
    cell: (c) => {
      const text = String(c.getValue());
      return <span className={text.startsWith('P') ? 'text-amber-500' : ''}>{text}</span>;
    },
  },
  { accessorKey: 'mfs', header: '작업지시', size: 140 },
];

export default function OrderPlanPreviewModal({ isOpen, onClose, body, onGenerate }: Props) {
  const [data, setData] = useState<PreviewData | null>(null);
  const [loading, setLoading] = useState(false);
  const bodyKey = useMemo(() => JSON.stringify(body), [body]);

  useEffect(() => {
    if (!isOpen) return;
    let alive = true;
    setLoading(true);
    api.post('/purchase/order-plan/preview', JSON.parse(bodyKey), { timeout: 180_000 })
      .then((r) => { if (alive) setData(r.data?.data as PreviewData); })
      .catch(() => { if (alive) toast.error('미리보기 계산에 실패했습니다.'); })
      .finally(() => { if (alive) setLoading(false); });
    return () => { alive = false; };
  }, [isOpen, bodyKey]);

  const s = data?.summary;
  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title="발주량 미리보기"
      subtitle="생성과 같은 계산입니다. 저장하지 않습니다."
      size="full"
      footer={
        <div className="flex w-full items-center justify-between gap-3">
          <span className="text-sm text-text-muted">
            {s
              ? `${s.lines.toLocaleString()}줄 · 발주할 줄 ${s.orderLines.toLocaleString()} · 확정 제외(P) ${s.heldLines.toLocaleString()} · 발주량 합 ${qty(s.purchaseQty)}`
              : ''}
            {data?.skippedItems.length
              ? ` · BOM 없어 뺀 품목 ${data.skippedItems.length}개: ${data.skippedItems.slice(0, 5).join(', ')}${data.skippedItems.length > 5 ? ' …' : ''}`
              : ''}
          </span>
          <div className="flex gap-2">
            <Button variant="secondary" onClick={onClose}>닫기</Button>
            <Button onClick={onGenerate} disabled={loading || !data}>
              <Play className="mr-1 h-4 w-4" />이대로 생성
            </Button>
          </div>
        </div>
      }
    >
      <div className="h-[65vh] min-h-0">
        <DataGrid
          data={data?.lines ?? []}
          columns={columns}
          isLoading={loading}
          pageSize={100}
          enableColumnFilter
          enableExport
          exportFileName="발주량_미리보기"
          getRowId={(r) => {
            const l = r as OrderPlanPreviewLine;
            return `${l.itemCode}|${l.lineType}|${l.supplierCode}|${l.deliveryDate}|${l.mfs}`;
          }}
          emptyMessage="계산된 발주 줄이 없습니다. 기간·계획 원천을 확인하세요."
        />
      </div>
    </Modal>
  );
}
