"use client";

/**
 * @file src/app/(authenticated)/mold/order/components/OrderActionPanel.tsx
 * @description S-PARTS 주문 등록·삭제 — PB w_mcn_mold_purchase_order_master 의 저장 분기 이식
 *
 * 초보자 가이드:
 * 1. **주문번호는 입력하지 않는다.** PB 규칙(`주문일자 + SEQ_PURCHASE_ORDER_NO`)대로 서버가 만든다.
 * 2. **단가를 비우면 서버가 유효한 구매단가를 끌어온다.** PB 도 공급처·S-PARTS 가 바뀌면
 *    f_get_mold_unit_price 로 단가를 채웠다. 단가가 없으면 0 으로 들어간다.
 * 3. **입고가 잡힌 주문은 삭제되지 않는다** — 서버가 막는다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { FilePlus2, Trash2 } from 'lucide-react';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import type { MoldOrderRow } from '../../types';

const today = () => new Date().toISOString().slice(0, 10);

interface Props {
  selected: MoldOrderRow | null;
  onChanged: () => void;
}

export default function OrderActionPanel({ selected, onChanged }: Props) {
  const [moldCode, setMoldCode] = useState('');
  const [supplierCode, setSupplierCode] = useState('');
  const [orderQty, setOrderQty] = useState('1');
  const [purchaseOrderDate, setPurchaseOrderDate] = useState(today);
  const [deliveryDate, setDeliveryDate] = useState(today);
  const [unitPrice, setUnitPrice] = useState('');
  const [deliveryMethod, setDeliveryMethod] = useState('');
  const [lineType, setLineType] = useState('');
  const [busy, setBusy] = useState(false);
  const [deleteOpen, setDeleteOpen] = useState(false);

  const create = useCallback(async () => {
    if (!moldCode.trim()) return toast.error('S-PARTS 코드를 입력하세요.');
    if (!supplierCode) return toast.error('공급처를 고르세요.');
    setBusy(true);
    try {
      const response = await api.post('/mold/order', {
        moldCode: moldCode.trim(),
        supplierCode,
        purchaseOrderDate,
        deliveryDate,
        orderQty: Number(orderQty),
        unitPrice: unitPrice.trim() === '' ? undefined : Number(unitPrice),
        deliveryMethod: deliveryMethod || undefined,
        lineType: lineType || undefined,
      });
      toast.success(`주문 ${response.data?.data?.orderNo ?? ''} 등록`);
      setMoldCode('');
      setOrderQty('1');
      setUnitPrice('');
      onChanged();
    } catch {
      toast.error('등록에 실패했습니다. S-PARTS·공급처를 확인하세요.');
    } finally {
      setBusy(false);
    }
  }, [moldCode, supplierCode, purchaseOrderDate, deliveryDate, orderQty, unitPrice,
    deliveryMethod, lineType, onChanged]);

  const remove = useCallback(async () => {
    if (!selected) return;
    setDeleteOpen(false);
    setBusy(true);
    try {
      await api.delete('/mold/order', { data: { orderNo: selected.orderNo } });
      toast.success('삭제되었습니다.');
      onChanged();
    } catch {
      toast.error('이미 입고된 주문은 삭제할 수 없습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, onChanged]);

  return (
    <Card padding="none">
      <CardContent className="flex flex-wrap items-end gap-3 p-3">
        <div className="flex items-center gap-2 self-center">
          <FilePlus2 className="h-5 w-5 text-primary" />
          <span className="text-sm font-semibold text-text">주문 등록</span>
        </div>
        <label className="text-xs text-text-muted">
          S-PARTS 코드
          <Input value={moldCode} className="w-40"
            onChange={(e) => setMoldCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void create(); }} />
        </label>
        <label className="text-xs text-text-muted">
          공급처
          <SupplierSelect includeAll={false} value={supplierCode}
            onChange={setSupplierCode} className="w-48" />
        </label>
        <label className="text-xs text-text-muted">
          주문일자
          <Input type="date" value={purchaseOrderDate} className="w-40"
            onChange={(e) => setPurchaseOrderDate(e.target.value)} />
        </label>
        <label className="text-xs text-text-muted">
          납기일자
          <Input type="date" value={deliveryDate} className="w-40"
            onChange={(e) => setDeliveryDate(e.target.value)} />
        </label>
        <label className="text-xs text-text-muted">
          수량
          <Input type="number" value={orderQty} className="w-24"
            onChange={(e) => setOrderQty(e.target.value)} />
        </label>
        <label className="text-xs text-text-muted">
          단가 (비우면 구매단가)
          <Input type="number" value={unitPrice} className="w-36" placeholder="자동"
            onChange={(e) => setUnitPrice(e.target.value)} />
        </label>
        <label className="text-xs text-text-muted">
          운송방법
          <ComCodeSelect groupCode="DELIVERY METHOD" includeAll={false}
            value={deliveryMethod} onChange={setDeliveryMethod} className="w-36" />
        </label>
        <label className="text-xs text-text-muted">
          거래유형
          <ComCodeSelect groupCode="LINE TYPE" includeAll={false}
            value={lineType} onChange={setLineType} className="w-40" />
        </label>
        <Button size="sm" onClick={create} disabled={busy}>
          <FilePlus2 className="mr-1 h-4 w-4" />주문
        </Button>
        <Button size="sm" variant="secondary" disabled={!selected || busy}
          onClick={() => setDeleteOpen(true)}>
          <Trash2 className="mr-1 h-4 w-4 text-red-500" />주문삭제
        </Button>
      </CardContent>

      <ConfirmModal
        isOpen={deleteOpen}
        onClose={() => setDeleteOpen(false)}
        onConfirm={remove}
        title="주문 삭제"
        message={selected ? `주문 ${selected.orderNo} 을(를) 삭제할까요?` : ''}
        variant="danger"
      />
    </Card>
  );
}
