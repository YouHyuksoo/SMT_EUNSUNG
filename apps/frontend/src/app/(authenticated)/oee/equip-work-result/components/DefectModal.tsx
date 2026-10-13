'use client';

/**
 * @file oee/equip-work-result/components/DefectModal.tsx
 * @description 대표 불량 등록 모달 — 작업지시 단위 대표불량 1건(IP_PRODUCT_WORK_DEFECT). 실적과 독립이다.
 *
 * 초보자 가이드:
 * 1. 열 때 GET /oee/work-result/defect?runNo 로 기존 값을 불러온다(없으면 빈 폼).
 * 2. 저장은 POST /oee/work-result/defect. 서버가 계획·실적 수량 초과를 막는다.
 * 3. 불량유형은 공통코드성 WQC 목록(GET /oee/work-result/bad-reasons)을 버튼으로 고른다.
 */
import { useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Modal } from '@/components/ui';
import api from '@/services/api';
import type { RunRow } from '../_lib/types';

interface Code { code: string; name: string }

interface Props {
  run: RunRow | null;
  onClose: () => void;
  onSaved: () => void | Promise<void>;
}

export default function DefectModal({ run, onClose, onSaved }: Props) {
  const [badReasons, setBadReasons] = useState<Code[]>([]);
  const [badCode, setBadCode] = useState('');
  const [badQty, setBadQty] = useState(0);
  const [remark, setRemark] = useState('');

  useEffect(() => {
    api.get('/oee/work-result/bad-reasons').then((r) => setBadReasons(r.data?.data?.list ?? [])).catch(() => {});
  }, []);

  useEffect(() => {
    if (!run) return;
    setBadCode(''); setBadQty(0); setRemark('');
    api.get('/oee/work-result/defect', { params: { runNo: run.runNo } })
      .then((res) => {
        const d = res.data?.data?.defect;
        if (d) { setBadCode(d.badCode ?? ''); setBadQty(d.badQty ?? 0); setRemark(d.remark ?? ''); }
      })
      .catch(() => { /* 없음 */ });
  }, [run]);

  async function save() {
    if (!run) return;
    if (!badCode) return toast.error('대표 불량유형을 선택하세요');
    try {
      await api.post('/oee/work-result/defect', { runNo: run.runNo, badCode, badQty, remark: remark || undefined });
      toast.success('불량이 저장되었습니다');
      await onSaved();
    } catch (e: unknown) {
      const msg = e && typeof e === 'object' && 'response' in e
        ? (e as { response?: { data?: { message?: string } } }).response?.data?.message : undefined;
      toast.error(msg || '불량 저장에 실패했습니다');
    }
  }

  return (
    <Modal isOpen={!!run} onClose={onClose} size="2xl" bodyMaxHeightClass="max-h-[85vh]" showCloseButton={false}
      title={<span>불량 등록 <span className="ml-2 font-mono text-base text-text-muted">{run?.runNo}</span></span>}
      headerActions={
        <div className="flex items-center gap-2">
          <button type="button" onClick={onClose}
            className="h-9 px-4 rounded-lg border border-border text-sm font-medium text-text hover:bg-surface">닫기</button>
          <button type="button" onClick={() => void save()}
            className="h-9 px-5 rounded-lg bg-primary text-white text-sm font-semibold hover:bg-primary/90">저장</button>
        </div>
      }>
      {run && (
        <div className="space-y-4">
          <div className="flex flex-col gap-1.5">
            <span className="text-sm text-text-muted">대표 불량유형 <span className="text-red-500">*</span></span>
            <div className="grid grid-cols-6 gap-2">
              {badReasons.map((b) => {
                const active = badCode === b.code;
                return (
                  <button key={b.code} type="button" onClick={() => setBadCode(b.code)}
                    className={`h-14 px-2 rounded-lg border text-sm text-center transition-colors ${active ? 'bg-primary text-white border-primary' : 'border-border bg-background text-text hover:border-primary/60'}`}>
                    <span className="block font-semibold leading-tight">{b.name}</span>
                    <span className={`block text-[10px] font-mono ${active ? 'text-white/80' : 'text-text-muted'}`}>{b.code}</span>
                  </button>
                );
              })}
              {!badReasons.length && <span className="col-span-6 text-sm text-text-muted py-2">불량유형이 없습니다</span>}
            </div>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <label className="text-sm text-text-muted flex flex-col gap-1"><span>불량수량 <span className="text-red-500">*</span></span>
              <input type="number" min="0" value={badQty} onChange={(e) => setBadQty(Number(e.target.value))}
                className="h-12 border border-border rounded-lg px-3 bg-background text-text text-right font-mono text-lg" />
            </label>
            <label className="text-sm text-text-muted flex flex-col gap-1">비고
              <input value={remark} onChange={(e) => setRemark(e.target.value)}
                className="h-12 border border-border rounded-lg px-3 bg-background text-text" />
            </label>
          </div>
          <p className="text-xs text-text-muted">
            불량수량은 계획수량({(run.planQty ?? 0).toLocaleString()}){run.resultQty > 0 ? ` · 실적수량(${run.resultQty.toLocaleString()})` : ''}을 넘을 수 없습니다.
          </p>
        </div>
      )}
    </Modal>
  );
}
