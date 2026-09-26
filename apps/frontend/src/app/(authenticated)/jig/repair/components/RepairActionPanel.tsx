"use client";

/**
 * @file src/app/(authenticated)/jig/repair/components/RepairActionPanel.tsx
 * @description 지그 수리 접수·처리 — PB w_mcn_jig_repair_request_master / w_mcn_jig_repair_master 이식
 *
 * 초보자 가이드:
 * 1. **접수**: 지그코드·LOT 을 넣으면 SEQ_JIG_REPAIR_SEQUENCE 로 채번해 상태 'R' 로 한 건 만든다.
 *    지그LOT 은 스캐너(키보드 방식)로 찍어도 되고 손으로 쳐도 된다.
 * 2. **처리**: 목록에서 고른 수리건의 상태를 바꾼다. PB 버튼 두 개가 그대로 대응한다 —
 *    Repair OK → 'P'(수리중), Line Issue → 'C'(수리완료).
 * 3. 수리일자·수리자·시간·금액·내용은 넘긴 값이 있을 때만 갱신된다(PB 와 동일).
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { CheckCircle2, PlusCircle, Wrench } from 'lucide-react';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import type { JigRepairRow } from '../columns';

interface Props {
  /** 목록에서 고른 수리건 (없으면 처리 버튼 비활성) */
  selected: JigRepairRow | null;
  onChanged: () => void;
}

type PendingStatus = { status: string; label: string } | null;

export default function RepairActionPanel({ selected, onChanged }: Props) {
  const [jigCode, setJigCode] = useState('');
  const [jigLotNo, setJigLotNo] = useState('');
  const [reasonCode, setReasonCode] = useState('');
  const [vendorCode, setVendorCode] = useState('');
  const [comments, setComments] = useState('');
  const [busy, setBusy] = useState(false);

  const [repairBy, setRepairBy] = useState('');
  const [repairAmt, setRepairAmt] = useState('');
  const [repairComments, setRepairComments] = useState('');
  const [pending, setPending] = useState<PendingStatus>(null);

  const request = useCallback(async () => {
    if (!jigCode.trim() || !jigLotNo.trim()) return toast.error('지그코드와 지그LOT을 입력하세요.');
    setBusy(true);
    try {
      const response = await api.post('/jig/repair', {
        jigCode: jigCode.trim(),
        jigLotNo: jigLotNo.trim(),
        repairReasonCode: reasonCode || undefined,
        repairVendorCode: vendorCode || undefined,
        comments: comments || undefined,
      });
      toast.success(`수리신청 ${response.data?.data?.repairSequence ?? ''}건 접수`);
      setJigCode(''); setJigLotNo(''); setReasonCode(''); setVendorCode(''); setComments('');
      onChanged();
    } catch {
      toast.error('등록되지 않은 지그입니다.');
    } finally {
      setBusy(false);
    }
  }, [jigCode, jigLotNo, reasonCode, vendorCode, comments, onChanged]);

  const applyStatus = useCallback(async () => {
    if (!selected || !pending) return;
    const next = pending;
    setPending(null);
    setBusy(true);
    try {
      await api.put('/jig/repair/status', {
        jigCode: selected.jigCode,
        jigLotNo: selected.jigLotNo ?? '',
        repairSequence: selected.repairSequence,
        repairStatus: next.status,
        repairDate: new Date().toISOString().slice(0, 10),
        repairBy: repairBy || undefined,
        repairAmt: repairAmt.trim() === '' ? undefined : Number(repairAmt),
        repairComments: repairComments || undefined,
      });
      toast.success(`${next.label} 처리했습니다.`);
      setRepairBy(''); setRepairAmt(''); setRepairComments('');
      onChanged();
    } catch {
      toast.error('수리 처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, pending, repairBy, repairAmt, repairComments, onChanged]);

  return (
    <Card padding="none">
      <CardContent className="flex flex-col gap-3 p-3">
        <div className="flex flex-wrap items-center gap-3">
          <div className="flex items-center gap-2">
            <PlusCircle className="h-5 w-5 text-primary" />
            <span className="text-sm font-semibold text-text">수리신청 접수</span>
          </div>
          <Input placeholder="지그코드" value={jigCode} className="w-40"
            onChange={(e) => setJigCode(e.target.value)} />
          <Input placeholder="지그LOT (스캔 가능)" value={jigLotNo} className="w-52"
            onChange={(e) => setJigLotNo(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void request(); }} />
          <ComCodeSelect groupCode="REPAIR REASON CODE" includeAll={false}
            value={reasonCode} onChange={setReasonCode} className="w-44" />
          <ComCodeSelect groupCode="REPAIR VENDOR CODE" includeAll={false}
            value={vendorCode} onChange={setVendorCode} className="w-44" />
          <Input placeholder="신청내용" value={comments} className="w-56"
            onChange={(e) => setComments(e.target.value)} />
          <Button size="sm" onClick={request} disabled={busy}>
            <PlusCircle className="mr-1 h-4 w-4" />접수
          </Button>
        </div>

        <div className="flex flex-wrap items-center gap-3 border-t border-border pt-3">
          <div className="flex items-center gap-2">
            <Wrench className="h-5 w-5 text-primary" />
            <span className="text-sm font-semibold text-text">
              수리 처리{selected ? ` — ${selected.jigCode} / ${selected.repairSequence}차` : ''}
            </span>
          </div>
          <Input placeholder="수리자" value={repairBy} className="w-32" disabled={!selected}
            onChange={(e) => setRepairBy(e.target.value)} />
          <Input placeholder="수리금액" type="number" value={repairAmt} className="w-32" disabled={!selected}
            onChange={(e) => setRepairAmt(e.target.value)} />
          <Input placeholder="수리내용" value={repairComments} className="w-64" disabled={!selected}
            onChange={(e) => setRepairComments(e.target.value)} />
          <Button size="sm" variant="secondary" disabled={!selected || busy}
            onClick={() => setPending({ status: 'P', label: '수리중' })}>
            <Wrench className="mr-1 h-4 w-4" />수리중(P)
          </Button>
          <Button size="sm" disabled={!selected || busy}
            onClick={() => setPending({ status: 'C', label: '수리완료' })}>
            <CheckCircle2 className="mr-1 h-4 w-4" />수리완료(C)
          </Button>
        </div>
      </CardContent>

      <ConfirmModal
        isOpen={!!pending}
        onClose={() => setPending(null)}
        onConfirm={applyStatus}
        title="수리 상태 변경"
        message={selected && pending
          ? `${selected.jigCode} / ${selected.repairSequence}차 수리건을 "${pending.label}" 로 바꿉니다.`
          : ''}
      />
    </Card>
  );
}
