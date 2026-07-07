'use client';

/**
 * @file (authenticated)/oee/entry/_components/IntervalEditor.tsx
 * @description 가동/비가동 구간 추가·편집 UI. DOWN이면 사유 select 노출.
 */
import type { SaveInterval } from '../page';

interface Reason {
  reasonCode: string;
  reasonName: string;
}

interface Props {
  intervals: SaveInterval[];
  reasons: Reason[];
  onChange: (next: SaveInterval[]) => void;
}

export default function IntervalEditor({ intervals, reasons, onChange }: Props) {
  function update(i: number, patch: Partial<SaveInterval>) {
    onChange(intervals.map((iv, idx) => (idx === i ? { ...iv, ...patch } : iv)));
  }
  function add() {
    onChange([...intervals, { startMin: 0, endMin: 0, status: 'RUN', reasonCode: null, runNo: null, remark: null }]);
  }
  function remove(i: number) {
    onChange(intervals.filter((_, idx) => idx !== i));
  }

  return (
    <div className="space-y-2">
      {intervals.map((iv, i) => (
        <div key={i} className="flex flex-wrap gap-2 items-center border border-border rounded p-2 bg-surface">
          <input type="number" value={iv.startMin} onChange={(e) => update(i, { startMin: Number(e.target.value) })} className="border border-border rounded p-2 w-24 bg-background text-text" placeholder="시작(분)" />
          <span className="text-text-muted">~</span>
          <input type="number" value={iv.endMin} onChange={(e) => update(i, { endMin: Number(e.target.value) })} className="border border-border rounded p-2 w-24 bg-background text-text" placeholder="종료(분)" />
          <select
            value={iv.status}
            onChange={(e) => update(i, { status: e.target.value as 'RUN' | 'DOWN', reasonCode: e.target.value === 'RUN' ? null : iv.reasonCode })}
            className="border border-border rounded p-2 bg-background text-text"
          >
            <option value="RUN">가동</option>
            <option value="DOWN">비가동</option>
          </select>
          {iv.status === 'DOWN' && (
            <select value={iv.reasonCode ?? ''} onChange={(e) => update(i, { reasonCode: e.target.value || null })} className="border border-border rounded p-2 bg-background text-text">
              <option value="">사유 선택</option>
              {reasons.map((r) => <option key={r.reasonCode} value={r.reasonCode}>{r.reasonName}</option>)}
            </select>
          )}
          <input value={iv.runNo ?? ''} onChange={(e) => update(i, { runNo: e.target.value || null })} className="border border-border rounded p-2 w-32 bg-background text-text" placeholder="RUN_NO(선택)" />
          <button onClick={() => remove(i)} className="text-red-600 ml-auto px-2">삭제</button>
        </div>
      ))}
      <button onClick={add} className="border border-border text-text px-3 py-1.5 rounded hover:bg-surface">+ 구간 추가</button>
    </div>
  );
}
