"use client";

/**
 * @file src/app/(authenticated)/purchase/requirement/components/RequirementPlanFormPanel.tsx
 * @description 477 자재소요량관리 — 기준계획 한 줄 등록 우측 패널
 *
 * 초보자 가이드:
 * 1. 기준일자는 화면 맨 위 값을 그대로 쓴다. 패널에서는 보여 주기만 한다.
 * 2. 같은 기준일자·계획일·품목이면 서버가 수량만 바꾼다(덮어쓰기).
 * 3. 저장 뒤 패널을 닫지 않고 품목·수량만 비운다 — 여러 줄을 이어서 넣기 위해서다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { Save, X } from 'lucide-react';
import PartSearchField from '@/components/shared/PartSearchField';
import { Button, Input } from '@/components/ui';
import api from '@/services/api';
import { getTodayLocal } from '@/utils/date';

interface Props {
  /** 기준일자 — 이번 계산을 묶는 번호표 */
  requirementPlanDate: string;
  onClose: () => void;
  onSaved: () => void;
}

const apiMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

export default function RequirementPlanFormPanel({ requirementPlanDate, onClose, onSaved }: Props) {
  const [planDate, setPlanDate] = useState(getTodayLocal());
  const [itemCode, setItemCode] = useState('');
  const [orderQty, setOrderQty] = useState('');
  const [saving, setSaving] = useState(false);

  const qty = Number(orderQty);
  const blocker = !itemCode.trim()
    ? '품목코드를 넣으세요.'
    : orderQty === '' || !Number.isFinite(qty) || qty < 0
      ? '수량은 0 이상 숫자입니다.'
      : null;

  const save = useCallback(async () => {
    if (blocker) return toast.error(blocker);
    setSaving(true);
    try {
      await api.post('/purchase/requirement/master-plan', {
        requirementPlanDate,
        planDate,
        itemCode: itemCode.trim(),
        orderQty: qty,
      });
      toast.success('기준계획을 저장했습니다.');
      setItemCode('');
      setOrderQty('');
      onSaved();
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '저장에 실패했습니다.');
    } finally {
      setSaving(false);
    }
  }, [blocker, requirementPlanDate, planDate, itemCode, qty, onSaved]);

  return (
    <aside className="flex h-full w-[380px] shrink-0 flex-col border-l border-border bg-background shadow-xl">
      <header className="flex h-14 items-center justify-between border-b border-border px-5">
        <h2 className="font-bold text-text">① 기준계획 등록</h2>
        <button type="button" title="닫기" onClick={onClose}>
          <X className="h-5 w-5 text-text-muted" />
        </button>
      </header>

      <div className="flex-1 space-y-3 overflow-y-auto p-5 text-sm">
        <Input label="기준일자" value={requirementPlanDate} disabled fullWidth
          data-tooltip="화면 맨 위 기준일자를 씁니다. 바꾸려면 맨 위에서 바꿉니다." />
        <Input label="계획일 (필요한 날)" type="date" value={planDate} fullWidth
          data-tooltip="그 자재가 실제로 필요한 날입니다. 한 기준일자 안에 여러 계획일을 넣을 수 있습니다."
          onChange={(e) => setPlanDate(e.target.value)} />
        <PartSearchField label="품목코드 (펼 제품)" value={itemCode} required fullWidth
          data-tooltip="BOM 을 펼 제품(또는 반제품) 코드입니다."
          onChange={(e) => setItemCode(e.target.value)} />
        <Input label="수량" type="number" min={0} placeholder="0" value={orderQty} required fullWidth
          data-tooltip="그 날 만들 수량입니다. 자재 소요량 = BOM 단위수량 × 이 수량."
          onChange={(e) => setOrderQty(e.target.value)}
          onKeyDown={(e) => { if (e.key === 'Enter') void save(); }} />
        <p className="text-xs text-text-muted">
          같은 기준일자·계획일·품목이 이미 있으면 수량만 바뀝니다.
        </p>
      </div>

      <footer className="flex justify-end gap-2 border-t border-border p-4">
        <Button variant="secondary" onClick={onClose}>닫기</Button>
        <Button onClick={save} disabled={saving || Boolean(blocker)}>
          <Save className="mr-1 h-4 w-4" />{saving ? '저장 중...' : '저장'}
        </Button>
      </footer>
    </aside>
  );
}
