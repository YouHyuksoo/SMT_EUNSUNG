"use client";

/**
 * @file warehouse/barcode-issue/IssueCancelModal.tsx
 * @description 출고 취소 창 — PB Cancel Issue 버튼이 열던 w_mat_issue_cancel_4_barcode_popup.
 *
 * 초보자 가이드:
 * 1. 출고된 릴 바코드를 찍으면 취소할 출고(그 롯트의 가장 늦은 출고)를 보여준다.
 * 2. '출고 취소' 를 누르면 한 트랜잭션으로 바코드 원장을 출고 전으로 돌리고 그 출고를 역분개한다
 *    (출고취소 화면과 같은 처리). 처리한 건은 아래 목록에 쌓인다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import BarcodeScanInput from '@/components/shared/BarcodeScanInput';
import { Button, Modal } from '@/components/ui';
import api from '@/services/api';

interface CancelLookup {
  itemCode: string | null;
  lotNo: string | null;
  cancelable: boolean;
  reason: string | null;
  issue: {
    issueDate: string; issueSequence: number; issueQty: number; lineCode: string | null;
    workstageCode: string | null; modelName: string | null; issueDivision: string | null;
    enterDate: string | null; enterBy: string | null; itemName: string | null;
  } | null;
}

const QUIET = { suppressErrorModal: true, skipSuccessToast: true } as const;
const errorMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

export default function IssueCancelModal({ isOpen, onClose, onCanceled }: {
  isOpen: boolean; onClose: () => void; onCanceled: () => void;
}) {
  const [barcode, setBarcode] = useState('');
  const [lookup, setLookup] = useState<CancelLookup | null>(null);
  const [busy, setBusy] = useState(false);
  const [log, setLog] = useState<string[]>([]);

  const runLookup = useCallback(async (scanned?: string) => {
    const value = (scanned ?? barcode).trim();
    if (!value) return;
    setBarcode(value);
    setBusy(true);
    try {
      const r = await api.post('/warehouse/barcode-issue/cancel/lookup', { barcode: value }, QUIET);
      setLookup((r.data?.data as CancelLookup | undefined) ?? null);
    } catch (error: unknown) {
      toast.error(errorMessage(error) ?? '바코드를 풀어 보지 못했습니다.');
      setLookup(null);
    } finally {
      setBusy(false);
    }
  }, [barcode]);

  const cancel = useCallback(async () => {
    setBusy(true);
    try {
      await api.post('/warehouse/barcode-issue/cancel', { barcode: barcode.trim() }, QUIET);
      toast.success(`출고를 취소했습니다: ${barcode.trim()}`);
      setLog((prev) => [`${barcode.trim()} · ${lookup?.issue?.issueDate} #${lookup?.issue?.issueSequence}`, ...prev]);
      setBarcode('');
      setLookup(null);
      onCanceled();
    } catch (error: unknown) {
      toast.error(errorMessage(error) ?? '출고 취소에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [barcode, lookup, onCanceled]);

  const close = () => { setBarcode(''); setLookup(null); onClose(); };

  return (
    <Modal isOpen={isOpen} onClose={close} title="출고 취소" size="lg"
      footer={(
        <div className="flex justify-end gap-2">
          <Button variant="secondary" size="sm" onClick={close}>닫기</Button>
          <Button size="sm" disabled={busy || !lookup?.cancelable} onClick={() => void cancel()}>출고 취소</Button>
        </div>
      )}>
      <div className="flex flex-col gap-3 text-sm">
        <p className="text-text-muted">취소할 자재 바코드를 찍으세요. 바코드가 출고 전으로 돌아가고 그 출고는 역분개됩니다.</p>
        <div className="flex items-center gap-2">
          <div className="min-w-0 flex-1">
            <BarcodeScanInput aria-label="취소 바코드" placeholder="취소할 자재 바코드 스캔" value={barcode}
              onChange={setBarcode} onScan={(v) => void runLookup(v)} className="w-full" />
          </div>
          <Button size="sm" variant="secondary" disabled={busy || !barcode.trim()} onClick={() => void runLookup()}>풀어 보기</Button>
        </div>
        {lookup && (
          lookup.cancelable && lookup.issue ? (
            <div className="flex flex-wrap gap-x-6 gap-y-1 rounded border border-border bg-surface-muted px-3 py-2">
              <span>품목 <b>{lookup.itemCode}</b>{lookup.issue.itemName ? ` (${lookup.issue.itemName})` : ''}</span>
              <span>롯트 <b>{lookup.lotNo}</b></span>
              <span>출고 {lookup.issue.issueDate} #{lookup.issue.issueSequence}</span>
              <span>수량 <b>{Number(lookup.issue.issueQty ?? 0).toLocaleString()}</b></span>
              <span>라인 {lookup.issue.lineCode ?? '-'} · 공정 {lookup.issue.workstageCode ?? '-'}</span>
              <span>모델 {lookup.issue.modelName ?? '-'} ({lookup.issue.issueDivision ?? '-'})</span>
              <span className="text-text-muted">{lookup.issue.enterBy} {lookup.issue.enterDate}</span>
            </div>
          ) : (
            <p className="text-text-muted">{lookup.reason}</p>
          )
        )}
        <div>
          <p className="mb-1 text-xs text-text-muted">이번에 취소한 건 {log.length}건</p>
          <div className="max-h-40 overflow-y-auto rounded border border-border px-3 py-2 font-mono text-xs">
            {log.length === 0 ? <span className="text-text-muted">없음</span> : log.map((l) => <div key={l}>{l}</div>)}
          </div>
        </div>
      </div>
    </Modal>
  );
}
