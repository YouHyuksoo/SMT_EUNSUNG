"use client";

/**
 * @file product/shipping-order/components/ShippingOrderFormModal.tsx
 * @description 제품납품계획 등록·수정·삭제 모달
 *
 * 초보자 가이드:
 * 1. 납기일·고객·모델·수량을 넣는다. 번호(DLV+납기일+순번)와 품목·서픽스는 서버가 채운다.
 * 2. 출고된 박스가 있으면 모델을 바꾸거나 지울 수 없고, 수량은 출고 수량보다 작게 줄일 수 없다(서버가 막는다).
 */
import { useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import CustomerSelect from '@/components/shared/CustomerSelect';
import ModelSearchField from '@/components/shared/ModelSearchField';
import { Button, ConfirmModal, Input, Modal } from '@/components/ui';
import api from '@/services/api';
import { getTodayLocal } from '@/utils/date';
import type { ShippingOrderRow } from '../types';

interface Props {
  isOpen: boolean;
  /** 수정할 지시. 없으면 신규 */
  order: ShippingOrderRow | null;
  onClose: () => void;
  onSaved: () => void;
}

const serverMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

export default function ShippingOrderFormModal({ isOpen, order, onClose, onSaved }: Props) {
  const [planDate, setPlanDate] = useState(getTodayLocal());
  const [customerCode, setCustomerCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [planQty, setPlanQty] = useState('');
  const [comments, setComments] = useState('');
  const [saving, setSaving] = useState(false);
  const [confirmDelete, setConfirmDelete] = useState(false);

  useEffect(() => {
    if (!isOpen) return;
    setPlanDate(order?.planDate ?? getTodayLocal());
    setCustomerCode(order?.customerCode ?? '');
    setModelName(order?.modelName ?? '');
    setPlanQty(order ? String(order.planQty) : '');
    setComments(order?.comments ?? '');
  }, [isOpen, order]);

  const shipped = Number(order?.actualQty ?? 0) > 0;

  const save = async () => {
    const qty = Number(planQty);
    if (!customerCode) { toast.error('고객을 고르세요.'); return; }
    if (!modelName) { toast.error('모델을 고르세요.'); return; }
    if (!Number.isInteger(qty) || qty < 1) { toast.error('수량은 1 이상 정수로 넣으세요.'); return; }
    setSaving(true);
    try {
      const body = { planDate, customerCode, modelName, planQty: qty, comments: comments || undefined };
      if (order) await api.put(`/product/shipping-orders/${encodeURIComponent(order.shipOrderNo)}`, body);
      else await api.post('/product/shipping-orders', body);
      toast.success(order ? '제품납품계획을 고쳤습니다.' : '제품납품계획을 등록했습니다.');
      onSaved();
    } catch (error: unknown) {
      toast.error(serverMessage(error) ?? '저장에 실패했습니다.');
    } finally {
      setSaving(false);
    }
  };

  const remove = async () => {
    if (!order) return;
    setSaving(true);
    try {
      await api.delete(`/product/shipping-orders/${encodeURIComponent(order.shipOrderNo)}`);
      toast.success('제품납품계획을 지웠습니다.');
      setConfirmDelete(false);
      onSaved();
    } catch (error: unknown) {
      toast.error(serverMessage(error) ?? '삭제에 실패했습니다.');
    } finally {
      setSaving(false);
    }
  };

  return (
    <>
      <Modal isOpen={isOpen} onClose={onClose} size="md"
        title={order ? `제품납품계획 수정 · ${order.shipOrderNo}` : '제품납품계획 등록'}
        footer={(
          <div className="flex w-full items-center gap-2">
            {order && (
              <Button variant="danger" onClick={() => setConfirmDelete(true)} disabled={saving || shipped}>삭제</Button>
            )}
            <div className="ml-auto flex gap-2">
              <Button variant="secondary" onClick={onClose} disabled={saving}>닫기</Button>
              <Button onClick={() => void save()} disabled={saving}>저장</Button>
            </div>
          </div>
        )}>
        <div className="grid grid-cols-[6rem_1fr] items-center gap-3">
          <label className="text-sm text-text-muted" htmlFor="ship-plan-date">납기일</label>
          <Input id="ship-plan-date" type="date" value={planDate} onChange={(e) => setPlanDate(e.target.value)} />
          <span className="text-sm text-text-muted">고객</span>
          <CustomerSelect aria-label="고객" value={customerCode} onChange={setCustomerCode} fullWidth />
          <span className="text-sm text-text-muted">모델</span>
          <ModelSearchField aria-label="모델" value={modelName} onChange={(v) => setModelName(v)} disabled={shipped} />
          <label className="text-sm text-text-muted" htmlFor="ship-plan-qty">수량</label>
          <Input id="ship-plan-qty" type="number" min={1} value={planQty} onChange={(e) => setPlanQty(e.target.value)} />
          <label className="text-sm text-text-muted" htmlFor="ship-comments">비고</label>
          <Input id="ship-comments" value={comments} onChange={(e) => setComments(e.target.value)} />
        </div>
        {shipped && (
          <p className="mt-3 text-sm text-text-muted">
            출고 {Number(order?.actualQty ?? 0).toLocaleString()}개가 이 지시로 나가 모델은 바꿀 수 없고 지울 수 없습니다.
          </p>
        )}
      </Modal>
      <ConfirmModal isOpen={confirmDelete} onClose={() => setConfirmDelete(false)} onConfirm={() => void remove()}
        variant="danger" title="제품납품계획 삭제" isLoading={saving}
        message={`${order?.shipOrderNo ?? ''} 를 지웁니다.`} confirmText="삭제" />
    </>
  );
}
