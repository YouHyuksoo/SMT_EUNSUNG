'use client';

/**
 * @file oee/equip-work-result/components/RunPickerModal.tsx
 * @description 작업지시 선택 모달 — 선택한 라인의 계획일 작업지시를 카드로 보여주고 하나를 고른다.
 *
 * 초보자 가이드:
 * 1. 조회는 GET /oee/work-result?fromDate=toDate=계획일&lineCode (SMT 라인 제외). 검색은 받은 목록 안에서
 *    작업지시번호·품번·모델로 거른다(서버 keyword 는 작업지시번호를 보지 않는다).
 * 2. 카드를 누르면 바로 선택되고 모달이 닫힌다(확인 버튼 없음 — 터치 1번).
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import { RefreshCw, Search } from 'lucide-react';
import toast from 'react-hot-toast';
import { Input, Modal } from '@/components/ui';
import api from '@/services/api';
import { todayStr } from '../_lib/scope';
import { runState, RUN_STATE_CLASS, RUN_STATE_LABEL, type RunRow } from '../_lib/types';

interface Props {
  isOpen: boolean;
  onClose: () => void;
  lineCode: string;
  lineName: string;
  /** 고른 공정 — 그 공정 지시와 공정 미지정 지시만 보여준다 (지시는 공정마다 따로 내려간다) */
  workstageCode?: string;
  selectedRunNo: string | null;
  onSelect: (run: RunRow) => void;
}

export default function RunPickerModal({ isOpen, onClose, lineCode, lineName, workstageCode, selectedRunNo, onSelect }: Props) {
  const [date, setDate] = useState(todayStr());
  const [keyword, setKeyword] = useState('');
  const [rows, setRows] = useState<RunRow[]>([]);
  const [loading, setLoading] = useState(false);

  const search = useCallback(async () => {
    if (!lineCode) return;
    setLoading(true);
    try {
      const res = await api.get('/oee/work-result', {
        params: { fromDate: date, toDate: date, lineCode, excludeSmt: 'Y', workstageCode: workstageCode || undefined },
      });
      setRows(res.data?.data?.list ?? []);
    } catch {
      toast.error('작업지시 조회에 실패했습니다');
    } finally {
      setLoading(false);
    }
  }, [date, lineCode, workstageCode]);

  // 단말을 켜 둔 채 작업일이 바뀌어도(08:30) 열 때마다 오늘 작업일로 맞춘다
  useEffect(() => { if (isOpen) setDate(todayStr()); }, [isOpen]);
  useEffect(() => { if (isOpen) void search(); }, [isOpen, search]);

  const filtered = useMemo(() => {
    const q = keyword.trim().toUpperCase();
    if (!q) return rows;
    return rows.filter((r) => [r.runNo, r.workOrderNo, r.itemCode, r.modelName].some((v) => (v ?? '').toUpperCase().includes(q)));
  }, [rows, keyword]);

  return (
    <Modal isOpen={isOpen} onClose={onClose} size="full" bodyMaxHeightClass="max-h-[85vh]"
      title={<span>작업지시 선택 <span className="ml-2 text-sm font-normal text-text-muted">{lineName}</span></span>}
      headerActions={
        <button type="button" onClick={onClose}
          className="h-9 px-4 rounded-lg border border-border text-sm font-medium text-text hover:bg-surface">닫기</button>
      }>
      <div className="flex items-end gap-2 mb-3">
        <label className="text-xs text-text-muted flex flex-col gap-1">계획일
          <input type="date" value={date} onChange={(e) => setDate(e.target.value)}
            className="border border-border rounded px-2 h-10 bg-background text-text text-sm" />
        </label>
        <div className="flex-1">
          <Input placeholder="품번·모델·작업지시번호" value={keyword} onChange={(e) => setKeyword(e.target.value)}
            leftIcon={<Search className="w-4 h-4" />} fullWidth />
        </div>
        <button type="button" onClick={() => void search()}
          className="h-10 px-3 rounded-lg border border-border text-sm text-text-muted hover:bg-surface flex items-center gap-1">
          <RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />조회
        </button>
      </div>

      <div className="grid grid-cols-4 gap-2">
        {filtered.map((r) => {
          const st = runState(r);
          const plan = r.planQty ?? 0;
          const pct = plan > 0 ? Math.min(100, Math.round((r.resultQty / plan) * 100)) : 0;
          const on = r.runNo === selectedRunNo;
          return (
            <button key={r.runNo} type="button" onClick={() => onSelect(r)}
              className={`text-left rounded-lg border p-3 transition-colors ${on ? 'border-primary ring-2 ring-primary/40 bg-primary/5' : 'border-border hover:border-primary/60'}`}>
              <div className="flex items-center justify-between gap-2">
                <span className="min-w-0">
                  <span className="block font-mono text-sm font-semibold text-text truncate">{r.workOrderNo ?? r.runNo}</span>
                  {r.workOrderNo && <span className="block font-mono text-[11px] text-text-muted truncate">롯트 {r.runNo}</span>}
                  {!r.workstageCode && <span className="mt-0.5 inline-block rounded border border-border px-1.5 text-[11px] text-text-muted">공정 미지정</span>}
                </span>
                <span className={`text-xs px-2 py-0.5 rounded-full ${RUN_STATE_CLASS[st]}`}>{RUN_STATE_LABEL[st]}</span>
              </div>
              <div className="mt-1 text-base font-bold text-text truncate">{r.modelName ?? r.itemName ?? '-'}</div>
              <div className="text-xs text-text-muted font-mono truncate">{r.itemCode ?? '-'} | {r.revision ?? '-'} · {r.shiftCode ?? '-'}</div>
              <div className="mt-2 flex items-center gap-2">
                <div className="flex-1 h-1.5 bg-surface rounded-full overflow-hidden">
                  <div className="h-full bg-primary" style={{ width: `${pct}%` }} />
                </div>
                <span className="text-xs font-mono text-text">{r.resultQty.toLocaleString()} / {plan.toLocaleString()}</span>
              </div>
            </button>
          );
        })}
        {!loading && !filtered.length && (
          <div className="col-span-4 p-10 text-center text-sm text-text-muted">해당 계획일의 작업지시가 없습니다</div>
        )}
      </div>
    </Modal>
  );
}
