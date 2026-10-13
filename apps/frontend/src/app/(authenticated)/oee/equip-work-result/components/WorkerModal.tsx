'use client';

/**
 * @file oee/equip-work-result/components/WorkerModal.tsx
 * @description 작업자 선택 모달 — 작업자 마스터(WORKER_MASTERS)에서 고른다. 부모가 단말기에 기억한다.
 */
import { useMemo, useState } from 'react';
import { Search } from 'lucide-react';
import { Input, Modal } from '@/components/ui';
import { useWorkerOptions } from '@/hooks/useMasterOptions';

export interface Worker { code: string; name: string }

interface Props {
  isOpen: boolean;
  onClose: () => void;
  value: Worker | null;
  onSelect: (w: Worker) => void;
  /** 모달 위쪽 안내 문구 — 실적 입력이 막혀서 열렸을 때 이유를 알려준다 */
  notice?: string | null;
}

export default function WorkerModal({ isOpen, onClose, value, onSelect, notice }: Props) {
  const { workers } = useWorkerOptions();
  const [q, setQ] = useState('');
  const list = useMemo(() => {
    const s = q.trim().toLowerCase();
    const all = workers.map((w) => ({ code: String(w.workerCode ?? w.id ?? ''), name: w.workerName ?? '', dept: w.dept ?? '' }));
    return s ? all.filter((w) => `${w.code} ${w.name} ${w.dept}`.toLowerCase().includes(s)) : all;
  }, [workers, q]);

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="작업자 선택" size="full" bodyMaxHeightClass="max-h-[85vh]"
      headerActions={
        <button type="button" onClick={onClose}
          className="h-9 px-4 rounded-lg border border-border text-sm font-medium text-text hover:bg-surface">닫기</button>
      }>
      {notice && (
        <p className="mb-3 rounded-lg border border-amber-500/40 bg-amber-500/10 px-3 py-2 text-sm font-semibold text-amber-700 dark:text-amber-300">{notice}</p>
      )}
      <div className="mb-3">
        <Input placeholder="사번·이름·부서" value={q} onChange={(e) => setQ(e.target.value)} leftIcon={<Search className="w-4 h-4" />} fullWidth />
      </div>
      <div className="grid grid-cols-8 gap-2">
        {list.map((w) => {
          const on = value?.code === w.code;
          return (
            <button key={w.code} type="button" onClick={() => onSelect({ code: w.code, name: w.name })}
              className={`h-14 rounded-lg border px-2 text-center transition-colors ${on ? 'bg-primary text-white border-primary' : 'border-border bg-background text-text hover:border-primary/60'}`}>
              <span className="block font-semibold truncate">{w.name || w.code}</span>
              <span className={`block text-[11px] truncate ${on ? 'text-white/80' : 'text-text-muted'}`}>{w.dept || w.code}</span>
            </button>
          );
        })}
        {!list.length && <p className="col-span-8 p-6 text-center text-sm text-text-muted">작업자가 없습니다</p>}
      </div>
    </Modal>
  );
}
