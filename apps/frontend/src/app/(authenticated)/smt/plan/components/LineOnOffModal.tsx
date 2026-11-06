"use client";

/**
 * @file src/app/(authenticated)/smt/plan/components/LineOnOffModal.tsx
 * @description 라인 ON(장착)/OFF(회수) — 현장 PDA 와 같은 프로시저(P_CHECK_PDA_TB_INOUT_PS_USER)를 런카드로 부른다
 *
 * 초보자 가이드:
 * 1. 프로시저는 런카드 번호로 모델·면을 찾는다. 그래서 Summary 에서 고른 계획의 최근 런카드를 골라 넘긴다.
 *    목록에 없으면 런카드 번호를 직접 스캔한다.
 * 2. 양산/샘플(PB 기본: 양산)은 프로시저의 P_PS 로 넘어가 지그·샘플 장착 이력을 가른다.
 * 3. ON 은 계획을 활성으로 바꾸고 라인 ON 이력을 남긴다. OFF 는 회수하고 라인을 초기화한다.
 */
import { useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Button, Modal } from '@/components/ui';
import Select from '@/components/ui/Select';
import BarcodeScanInput from '@/components/shared/BarcodeScanInput';
import api from '@/services/api';
import { formatDisplayDate } from '@/utils/date';
import type { SmtPlanSummaryRow } from '../../types';

interface RunCard {
  runNo: string;
  runDate: string | null;
  lineCode: string | null;
  pcbItem: string | null;
  runStatus: string | null;
  lotSize: number | null;
}

interface Props {
  mode: 'ON' | 'OFF';
  plan: SmtPlanSummaryRow;
  onClose: () => void;
  onDone: () => void;
}

export default function LineOnOffModal({ mode, plan, onClose, onDone }: Props) {
  const [runCards, setRunCards] = useState<RunCard[]>([]);
  const [runNo, setRunNo] = useState('');
  const [ps, setPs] = useState<'P' | 'S'>('P');
  const [busy, setBusy] = useState(false);
  const pcbItem = plan.pcbItem === 'B' ? 'B' : 'T';

  useEffect(() => {
    api.get('/smt/plan/run-cards', { params: { lineCode: plan.lineCode, modelName: plan.modelName, pcbItem } })
      .then((res) => {
        const list: RunCard[] = res.data?.data ?? [];
        setRunCards(list);
        if (list[0]) setRunNo(list[0].runNo);
      })
      .catch(() => setRunCards([]));
  }, [plan.lineCode, plan.modelName, pcbItem]);

  const submit = async () => {
    if (!runNo.trim()) return;
    setBusy(true);
    try {
      await api.post('/smt/plan/line-onoff', { lineCode: plan.lineCode, runNo: runNo.trim(), pcbItem, onOff: mode, ps });
      toast.success(`라인 ${mode} 완료 — ${plan.lineCode} / ${runNo.trim()}`);
      onDone();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(message ?? `라인 ${mode} 에 실패했습니다.`, { duration: 8000 });
    } finally {
      setBusy(false);
    }
  };

  return (
    <Modal
      isOpen
      onClose={onClose}
      title={mode === 'ON' ? 'Line On (장착)' : 'Line Off (회수)'}
      size="md"
      footer={
        <>
          <Button variant="secondary" onClick={onClose}>취소</Button>
          <Button variant={mode === 'OFF' ? 'danger' : 'primary'} onClick={submit} disabled={!runNo.trim() || busy} isLoading={busy}>
            {mode === 'ON' ? 'Line On' : 'Line Off'}
          </Button>
        </>
      }
    >
      <div className="space-y-4 text-sm">
        <p className="text-text">
          <b>{plan.lineCode}</b> 라인 · <b>{plan.modelName}</b> · {pcbItem === 'T' ? 'Top' : 'Bottom'}
        </p>
        <Select
          label="런카드"
          options={[
            { value: '', label: runCards.length ? '런카드를 고르세요' : '최근 60일 런카드가 없습니다 — 아래에 스캔하세요' },
            ...runCards.map((r) => ({
              value: r.runNo,
              label: `${r.runNo} · ${formatDisplayDate(r.runDate)} · ${r.lineCode ?? ''}${r.pcbItem ?? ''} · 상태 ${r.runStatus ?? '-'}`,
            })),
          ]}
          value={runCards.some((r) => r.runNo === runNo) ? runNo : ''}
          onChange={setRunNo}
          fullWidth
        />
        <BarcodeScanInput aria-label="런카드 번호" placeholder="런카드 번호 스캔·입력" value={runNo} onChange={setRunNo} onScan={setRunNo} maintainFocus={false} />
        <div className="flex items-center gap-4">
          <span className="font-medium text-text">구분</span>
          <label className="flex items-center gap-1"><input type="radio" checked={ps === 'P'} onChange={() => setPs('P')} />양산</label>
          <label className="flex items-center gap-1"><input type="radio" checked={ps === 'S'} onChange={() => setPs('S')} />샘플</label>
        </div>
        <p className="text-xs text-text-muted">
          {mode === 'ON'
            ? '현장 PDA 의 라인 장착과 같은 처리입니다. 계획을 활성으로 바꾸고 라인 ON 이력·지그·솔더 투입을 기록합니다.'
            : '현장 PDA 의 라인 회수와 같은 처리입니다. 라인 OFF 이력을 남기고 라인 인터락·센서를 초기화합니다.'}
        </p>
      </div>
    </Modal>
  );
}
