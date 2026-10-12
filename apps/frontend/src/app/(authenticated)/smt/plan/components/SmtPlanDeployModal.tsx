"use client";

/**
 * @file src/app/(authenticated)/smt/plan/components/SmtPlanDeployModal.tsx
 * @description 계획 배포 — PB w_smt_plan_master cb('Create Feeder Layout') 이식
 *
 * 초보자 가이드:
 * 1. **PCB 면은 필수다.** 배포 SQL 이 면을 등호로 쓰기 때문에 '양면' 이 없다.
 *    앞면과 뒷면을 각각 배포한다.
 * 2. **이미 배포된 행이 있으면 거부된다.** 다시 배포하려면 먼저 배포취소를 한다.
 *    활성 계획이 있으면 취소도 막히므로 비활성으로 바꾼 뒤 취소한다.
 * 3. 배포된 계획은 비활성(ACTIVE_YN='N') 으로 들어간다. 현장에 넘기려면
 *    목록 화면에서 활성화를 누른다.
 */
import { useState } from 'react';
import toast from 'react-hot-toast';
import { Play } from 'lucide-react';
import { Button, Input, Modal } from '@/components/ui';
import api from '@/services/api';
import { SmtModelSelect, SmtPcbItemSelect } from '../../components/SmtSelects';

interface Props {
  defaultModelName: string;
  defaultLineCode: string;
  onClose: () => void;
  onDone: () => void;
}

export default function SmtPlanDeployModal({
  defaultModelName, defaultLineCode, onClose, onDone,
}: Props) {
  const [modelName, setModelName] = useState(defaultModelName);
  const [lineCode, setLineCode] = useState(defaultLineCode);
  const [pcbItem, setPcbItem] = useState<string>('T');
  const [feederShaft, setFeederShaft] = useState('');
  const [busy, setBusy] = useState(false);

  const submit = async () => {
    if (modelName.trim() === '' || lineCode.trim() === '') {
      toast.error('모델명과 라인코드를 입력하세요.');
      return;
    }
    if (pcbItem !== 'T' && pcbItem !== 'B') {
      toast.error('PCB 면을 고르세요. 배포는 면 단위로만 됩니다.');
      return;
    }
    setBusy(true);
    try {
      const response = await api.post('/smt/plan/deploy', {
        modelName: modelName.trim(),
        lineCode: lineCode.trim(),
        pcbItem,
        feederShaft: feederShaft.trim() || undefined,
      });
      const data = response.data?.data;
      toast.success(`계획 ${data?.deployed ?? 0}행을 배포했습니다 (비활성 상태).`);
      onDone();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '배포에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  };

  return (
    <Modal isOpen onClose={onClose} title="계획 배포">
      <div className="space-y-4">
        <p className="text-sm text-text-muted">
          SMT BOM 과 대체 BOM 을 골라 놓은 라인·면의 현장 계획으로 펼칩니다.
          배포된 계획은 비활성 상태로 들어갑니다.
        </p>

        <label className="block text-sm">
          <span className="text-text-muted">모델명 *</span>
          <SmtModelSelect includeAll value={modelName} onChange={setModelName} />
        </label>

        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">라인코드 *</span>
            <Input value={lineCode} onChange={(e) => setLineCode(e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">PCB 면 * (양면 불가)</span>
            <SmtPcbItemSelect value={pcbItem} onChange={setPcbItem} />
          </label>
        </div>

        <label className="block text-sm">
          <span className="text-text-muted">피더축 (비우면 전부)</span>
          <Input value={feederShaft} maxLength={1}
            onChange={(e) => setFeederShaft(e.target.value)} />
        </label>
      </div>

      <div className="mt-6 flex justify-end gap-2">
        <Button variant="secondary" onClick={onClose} disabled={busy}>취소</Button>
        <Button onClick={submit} disabled={busy}>
          <Play className="mr-1 h-4 w-4" />배포
        </Button>
      </div>
    </Modal>
  );
}
