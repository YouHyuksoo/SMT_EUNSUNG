"use client";

/**
 * @file product/components/ShippingOrderPickerModal.tsx
 * @description 출고 화면에서 제품납품계획(출하지시)을 고르는 모달 — 완료되지 않은 지시만 보여준다
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Modal } from '@/components/ui';
import api from '@/services/api';
import { getTodayLocal } from '@/utils/date';
import type { ShippingOrderRow } from '../shipping-order/types';

const shiftDays = (ymd: string, days: number) => {
  const d = new Date(`${ymd}T00:00:00`);
  d.setDate(d.getDate() + days);
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
};

interface Props {
  isOpen: boolean;
  onClose: () => void;
  onPick: (order: ShippingOrderRow) => void;
}

export default function ShippingOrderPickerModal({ isOpen, onClose, onPick }: Props) {
  const [rows, setRows] = useState<ShippingOrderRow[]>([]);
  const [loading, setLoading] = useState(false);

  const load = useCallback(async () => {
    const today = getTodayLocal();
    setLoading(true);
    try {
      const res = await api.get('/product/shipping-orders', {
        // 완료되지 않은 지시는 납기가 지났어도 출고할 수 있어야 한다 — 지난 1년치를 본다
        params: { dateFrom: shiftDays(today, -365), dateTo: shiftDays(today, 30), openOnly: 'Y' },
      });
      setRows(res.data?.data ?? []);
    } catch {
      toast.error('제품납품계획 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { if (isOpen) void load(); }, [isOpen, load]);

  return (
    <Modal isOpen={isOpen} onClose={onClose} size="full" bodyMaxHeightClass="max-h-[80vh]" title="제품납품계획 선택">
      {loading ? (
        <p className="p-6 text-center text-text-muted">불러오는 중…</p>
      ) : rows.length === 0 ? (
        <p className="p-6 text-center text-text-muted">출고할 제품납품계획이 없습니다 (납기일 1년 전 ~ 30일 후, 완료 제외).</p>
      ) : (
        <div className="grid grid-cols-4 gap-3">
          {rows.map((r) => (
            <button key={r.shipOrderNo} type="button" onClick={() => onPick(r)}
              className="rounded-lg border border-border p-3 text-left transition-colors hover:border-primary/60">
              <div className="flex items-center justify-between gap-2">
                <span className="font-mono text-sm font-semibold text-text">{r.shipOrderNo}</span>
                <span className="text-xs text-text-muted">납기 {r.planDate}</span>
              </div>
              <div className="mt-1 truncate text-base font-bold text-text">{r.modelName}</div>
              <div className="truncate text-sm text-text-muted">{r.customerName ?? r.customerCode ?? '-'}</div>
              <div className="mt-1 text-sm text-text">
                잔량 <span className="font-semibold">{Number(r.remainQty).toLocaleString()}</span>
                <span className="text-text-muted"> / {Number(r.planQty).toLocaleString()}</span>
              </div>
            </button>
          ))}
        </div>
      )}
    </Modal>
  );
}
