"use client";

/**
 * @file src/app/(authenticated)/mold/repair/components/RepairProcessPanel.tsx
 * @description S-PARTS 수리 처리·확정 — PB w_mcn_mold_repair_master 의 저장/Confirm/Cancel 이식
 *
 * 초보자 가이드:
 * 1. **저장하면 상태가 '수리중'으로 올라간다.** PB 도 수리일을 오늘로 찍었다.
 * 2. **확정('수리완료')하면 더 수정할 수 없다.** 되돌리기로 '신청'까지 돌릴 수 있다 — PB 와 같다.
 * 3. 수리품목은 기본키 제약 때문에 **수리 1건당 1행**이다. 넣으면 기존 행을 덮어쓴다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { CheckCircle2, RotateCcw, Save } from 'lucide-react';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import type { MoldRepairRow } from '../../types';
import PartSearchField from '@/components/shared/PartSearchField';

interface Props {
  selected: MoldRepairRow | null;
  onChanged: () => void;
}

const text = (value: unknown) => (value == null ? '' : String(value));
const dateInput = (value: unknown) => (value ? String(value).slice(0, 10) : '');
const optional = (value: string) => (value.trim() === '' ? undefined : value.trim());
const optionalNum = (value: string) => (value.trim() === '' ? undefined : Number(value));

export default function RepairProcessPanel({ selected, onChanged }: Props) {
  const [repairBy, setRepairBy] = useState('');
  const [repairVendorCode, setRepairVendorCode] = useState('');
  const [repairReasonCode, setRepairReasonCode] = useState('');
  const [repairComments, setRepairComments] = useState('');
  const [repairQty, setRepairQty] = useState('');
  const [repairAmt, setRepairAmt] = useState('');
  const [repairTime, setRepairTime] = useState('');
  const [currency, setCurrency] = useState('');
  const [repairReceiptDate, setRepairReceiptDate] = useState('');
  const [repairIssueDate, setRepairIssueDate] = useState('');
  const [itemCode, setItemCode] = useState('');
  const [itemQty, setItemQty] = useState('');
  const [busy, setBusy] = useState(false);
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [revertOpen, setRevertOpen] = useState(false);

  /** 선택 행이 바뀌면 입력을 그 행의 값으로 맞춘다 */
  useEffect(() => {
    setRepairBy(text(selected?.repairBy));
    setRepairVendorCode(text(selected?.repairVendorCode));
    setRepairReasonCode(text(selected?.repairReasonCode));
    setRepairComments(text(selected?.repairComments));
    setRepairQty(text(selected?.repairQty));
    setRepairAmt(text(selected?.repairAmt));
    setRepairTime(text(selected?.repairTime));
    setCurrency(text(selected?.currency));
    setRepairReceiptDate(dateInput(selected?.repairReceiptDate));
    setRepairIssueDate(dateInput(selected?.repairIssueDate));
    setItemCode('');
    setItemQty('');
  }, [selected]);

  const done = selected?.repairStatus === 'C';

  const save = useCallback(async () => {
    if (!selected) return;
    setBusy(true);
    try {
      await api.put('/mold/repair', {
        moldCode: selected.moldCode,
        repairSequence: selected.repairSequence,
        repairBy: optional(repairBy),
        repairVendorCode: optional(repairVendorCode),
        repairReasonCode: optional(repairReasonCode),
        repairComments: optional(repairComments),
        repairQty: optionalNum(repairQty),
        repairAmt: optionalNum(repairAmt),
        repairTime: optionalNum(repairTime),
        currency: optional(currency),
        repairReceiptDate: optional(repairReceiptDate),
        repairIssueDate: optional(repairIssueDate),
      });
      if (itemCode.trim()) {
        await api.post('/mold/repair/items', {
          moldCode: selected.moldCode,
          repairSequence: selected.repairSequence,
          repairItemCode: itemCode.trim(),
          repairItemQty: optionalNum(itemQty),
        });
      }
      toast.success('저장되었습니다. 상태가 수리중으로 바뀌었습니다.');
      onChanged();
    } catch {
      toast.error('저장에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, repairBy, repairVendorCode, repairReasonCode, repairComments, repairQty,
    repairAmt, repairTime, currency, repairReceiptDate, repairIssueDate, itemCode, itemQty,
    onChanged]);

  const changeStatus = useCallback(async (action: 'confirm' | 'revert') => {
    if (!selected) return;
    setConfirmOpen(false);
    setRevertOpen(false);
    setBusy(true);
    try {
      await api.put('/mold/repair/status', {
        moldCode: selected.moldCode,
        repairSequence: selected.repairSequence,
        action,
      });
      toast.success(action === 'confirm' ? '수리완료로 확정했습니다.' : '신청 상태로 되돌렸습니다.');
      onChanged();
    } catch {
      toast.error('상태를 바꿀 수 없습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, onChanged]);

  return (
    <Card padding="none">
      <CardContent className="flex flex-wrap items-end gap-3 p-3">
        <div className="self-center text-sm">
          <b className="text-text">수리 처리</b>
          <div className="text-text-muted">
            {selected
              ? `${selected.moldCode} / 수리항번 ${selected.repairSequence} · ${selected.repairStatusName ?? selected.repairStatus ?? ''}`
              : '아래 목록에서 수리건을 고르세요'}
          </div>
        </div>
        <label className="text-xs text-text-muted">
          수리자
          <Input value={repairBy} className="w-32" disabled={!selected || done}
            onChange={(e) => setRepairBy(e.target.value)} />
        </label>
        <label className="text-xs text-text-muted">
          수리업체
          <SupplierSelect includeAll={false} disabled={!selected || done} value={repairVendorCode}
            onChange={setRepairVendorCode} className="w-44" />
        </label>
        <label className="text-xs text-text-muted">
          수리원인
          <ComCodeSelect groupCode="REPAIR REASON CODE" includeAll={false} disabled={!selected || done}
            value={repairReasonCode} onChange={setRepairReasonCode} className="w-36" />
        </label>
        <label className="text-xs text-text-muted">
          수리수량
          <Input type="number" value={repairQty} className="w-24" disabled={!selected || done}
            onChange={(e) => setRepairQty(e.target.value)} />
        </label>
        <label className="text-xs text-text-muted">
          수리시간
          <Input type="number" value={repairTime} className="w-24" disabled={!selected || done}
            onChange={(e) => setRepairTime(e.target.value)} />
        </label>
        <label className="text-xs text-text-muted">
          수리금액
          <Input type="number" value={repairAmt} className="w-32" disabled={!selected || done}
            onChange={(e) => setRepairAmt(e.target.value)} />
        </label>
        <label className="text-xs text-text-muted">
          통화
          <ComCodeSelect groupCode="CURRENCY" includeAll={false} disabled={!selected || done}
            value={currency} onChange={setCurrency} className="w-32" />
        </label>
        <label className="text-xs text-text-muted">
          수리입고일
          <Input type="date" value={repairReceiptDate} className="w-40" disabled={!selected || done}
            onChange={(e) => setRepairReceiptDate(e.target.value)} />
        </label>
        <label className="text-xs text-text-muted">
          수리출고일
          <Input type="date" value={repairIssueDate} className="w-40" disabled={!selected || done}
            onChange={(e) => setRepairIssueDate(e.target.value)} />
        </label>
        <label className="text-xs text-text-muted">
          수리내용
          <Input value={repairComments} className="w-64" disabled={!selected || done}
            onChange={(e) => setRepairComments(e.target.value)} />
        </label>
        <label className="text-xs text-text-muted">
          수리품목 (1건만)
          <PartSearchField value={itemCode} className="w-36" disabled={!selected || done}
            placeholder="품목코드" onChange={(e) => setItemCode(e.target.value)} />
        </label>
        <label className="text-xs text-text-muted">
          품목수량
          <Input type="number" value={itemQty} className="w-24" disabled={!selected || done}
            onChange={(e) => setItemQty(e.target.value)} />
        </label>

        <Button size="sm" onClick={save} disabled={!selected || done || busy}>
          <Save className="mr-1 h-4 w-4" />저장
        </Button>
        <Button size="sm" variant="secondary" disabled={!selected || done || busy}
          onClick={() => setConfirmOpen(true)}>
          <CheckCircle2 className="mr-1 h-4 w-4 text-green-600" />수리완료
        </Button>
        <Button size="sm" variant="secondary" disabled={!selected || busy}
          onClick={() => setRevertOpen(true)}>
          <RotateCcw className="mr-1 h-4 w-4" />되돌리기
        </Button>
      </CardContent>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={() => changeStatus('confirm')}
        title="수리완료 확정"
        message={selected
          ? `${selected.moldCode} / 수리항번 ${selected.repairSequence} 을(를) 수리완료로 확정합니다. 확정 후에는 수정할 수 없습니다.`
          : ''}
      />
      <ConfirmModal
        isOpen={revertOpen}
        onClose={() => setRevertOpen(false)}
        onConfirm={() => changeStatus('revert')}
        title="신청 상태로 되돌리기"
        message={selected
          ? `${selected.moldCode} / 수리항번 ${selected.repairSequence} 을(를) 신청 상태로 되돌립니다.`
          : ''}
      />
    </Card>
  );
}
