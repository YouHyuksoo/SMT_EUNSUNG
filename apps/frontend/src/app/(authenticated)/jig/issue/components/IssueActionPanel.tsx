"use client";

/**
 * @file src/app/(authenticated)/jig/issue/components/IssueActionPanel.tsx
 * @description 지그 출고 등록·취소 — PB w_mcn_jig_issue_master 의 'INSERT' 분기 이식
 *
 * 초보자 가이드:
 * 1. **등록 기본값은 PB 그대로**: 출고일=오늘, 출고구분='3'(3출고), 출고상태='N'(정상).
 *    출고순번은 SEQ_MAT_ISSUE 로 채번한다 — PB 가 자재 출고 시퀀스를 그대로 쓴다.
 * 2. **취소는 행을 지우지 않는다**: ISSUE_STATUS 를 'C' 로 바꾼다. 이력이 남아야 한다.
 * 3. 지그LOT 은 스캐너(키보드 방식)로 찍고 Enter 로 바로 등록할 수 있다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { Ban, PackagePlus } from 'lucide-react';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import ProcessSelect from '@/components/shared/ProcessSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import type { JigIssueRow } from '../columns';

interface Props {
  selected: JigIssueRow | null;
  onChanged: () => void;
}

export default function IssueActionPanel({ selected, onChanged }: Props) {
  const [jigCode, setJigCode] = useState('');
  const [jigLotNo, setJigLotNo] = useState('');
  const [issueQty, setIssueQty] = useState('1');
  const [issueAccount, setIssueAccount] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');
  const [machineCode, setMachineCode] = useState('');
  const [busy, setBusy] = useState(false);
  const [cancelOpen, setCancelOpen] = useState(false);

  const create = useCallback(async () => {
    if (!jigCode.trim() || !jigLotNo.trim()) return toast.error('지그코드와 지그LOT을 입력하세요.');
    setBusy(true);
    try {
      const response = await api.post('/jig/issue', {
        jigCode: jigCode.trim(),
        jigLotNo: jigLotNo.trim(),
        issueQty: issueQty.trim() === '' ? undefined : Number(issueQty),
        issueAccount: issueAccount || undefined,
        workstageCode: workstageCode || undefined,
        machineCode: machineCode || undefined,
      });
      toast.success(`출고 ${response.data?.data?.issueSequence ?? ''}번 등록`);
      setJigCode(''); setJigLotNo(''); setIssueQty('1');
      onChanged();
    } catch {
      toast.error('등록되지 않은 지그입니다.');
    } finally {
      setBusy(false);
    }
  }, [jigCode, jigLotNo, issueQty, issueAccount, workstageCode, machineCode, onChanged]);

  const cancel = useCallback(async () => {
    if (!selected) return;
    setCancelOpen(false);
    setBusy(true);
    try {
      await api.put('/jig/issue/cancel', {
        issueDate: String(selected.issueDate ?? '').slice(0, 10),
        issueSequence: selected.issueSequence,
      });
      toast.success('출고를 취소했습니다.');
      onChanged();
    } catch {
      toast.error('이미 취소되었거나 찾을 수 없는 출고건입니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, onChanged]);

  return (
    <Card padding="none">
      <CardContent className="flex flex-wrap items-center gap-3 p-3">
        <div className="flex items-center gap-2">
          <PackagePlus className="h-5 w-5 text-primary" />
          <span className="text-sm font-semibold text-text">출고 등록</span>
        </div>
        <Input placeholder="지그코드" value={jigCode} className="w-36"
          onChange={(e) => setJigCode(e.target.value)} />
        <Input placeholder="지그LOT (스캔 가능)" value={jigLotNo} className="w-48"
          onChange={(e) => setJigLotNo(e.target.value)}
          onKeyDown={(e) => { if (e.key === 'Enter') void create(); }} />
        <Input placeholder="수량" type="number" value={issueQty} className="w-24"
          onChange={(e) => setIssueQty(e.target.value)} />
        <ComCodeSelect groupCode="JIG ISSUE ACCOUNT" includeAll={false}
          value={issueAccount} onChange={setIssueAccount} className="w-44" />
        <ProcessSelect labelPrefix="공정" value={workstageCode}
          onChange={setWorkstageCode} className="w-44" />
        <Input placeholder="설비코드" value={machineCode} className="w-36"
          onChange={(e) => setMachineCode(e.target.value)} />
        <Button size="sm" onClick={create} disabled={busy}>
          <PackagePlus className="mr-1 h-4 w-4" />출고
        </Button>
        <Button size="sm" variant="secondary" disabled={!selected || busy}
          onClick={() => setCancelOpen(true)}>
          <Ban className="mr-1 h-4 w-4 text-red-500" />출고취소
        </Button>
      </CardContent>

      <ConfirmModal
        isOpen={cancelOpen}
        onClose={() => setCancelOpen(false)}
        onConfirm={cancel}
        title="출고 취소"
        message={selected
          ? `${selected.jigCode} / 출고순번 ${selected.issueSequence} 건을 취소 상태로 바꿉니다. 행은 삭제되지 않습니다.`
          : ''}
        variant="danger"
      />
    </Card>
  );
}
