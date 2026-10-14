'use client';

/**
 * @file oee/equip-inspect-result/components/InspectEntryPad.tsx
 * @description 검사실적 입력판 — 판정(합격/불합격)을 고르고 숫자패드로 수량을 넣어 저장한다.
 *              설비별 작업 실적관리 EntryPad 와 같은 배치다.
 *
 * 초보자 가이드:
 * 1. 판정을 [합격]/[불합격] 중에서 고른다. 기본은 합격이다.
 * 2. 불합격이면 불량원인을 반드시 고른다(불량원인 칸을 누르면 선택 창이 뜬다). 합격은 불량원인이 없다.
 * 3. 저장 후 수량·불량원인은 비우고 판정은 합격으로 돌린다.
 * 4. 입력할 수 없는 상태(검사자·작업지시 미선택 등)에서 누르면 onBlocked 로 알려 부모가 선택 창을 연다.
 */
import { useState } from 'react';
import { Modal } from '@/components/ui';

export interface BadReason { code: string; name: string }

const KEYS = ['7', '8', '9', '4', '5', '6', '1', '2', '3', 'CLR', '0', 'BS'] as const;

interface Props {
  disabledReason: string | null;
  subtitle: string;
  badReasons: BadReason[];
  onSave: (v: { verdict: 'P' | 'R'; qty: number; badReasonCode: string | null }) => Promise<boolean>;
  onBlocked: () => void;
}

export default function InspectEntryPad({ disabledReason, subtitle, badReasons, onSave, onBlocked }: Props) {
  const [verdict, setVerdict] = useState<'P' | 'R'>('P');
  const [qty, setQty] = useState('0');
  const [reason, setReason] = useState<BadReason | null>(null);
  const [reasonOpen, setReasonOpen] = useState(false);
  const [saving, setSaving] = useState(false);

  function press(k: (typeof KEYS)[number]) {
    if (disabledReason) { onBlocked(); return; }
    setQty((cur) => (k === 'CLR' ? '0' : k === 'BS' ? (cur.length > 1 ? cur.slice(0, -1) : '0') : cur.length >= 6 ? cur : cur === '0' ? k : cur + k));
  }

  function pickVerdict(v: 'P' | 'R') {
    if (disabledReason) { onBlocked(); return; }
    setVerdict(v);
    if (v === 'P') setReason(null);
  }

  const n = Number(qty);
  const missingReason = verdict === 'R' && !reason;
  const canSave = !disabledReason && n > 0 && !missingReason && !saving;

  async function save() {
    if (disabledReason) { onBlocked(); return; }
    if (!canSave) return;
    setSaving(true);
    try {
      const ok = await onSave({ verdict, qty: n, badReasonCode: verdict === 'R' ? reason?.code ?? null : null });
      if (ok) { setQty('0'); setVerdict('P'); setReason(null); }
    } finally {
      setSaving(false);
    }
  }

  const hint = disabledReason
    ?? (missingReason ? '불합격은 불량원인을 골라야 저장됩니다.' : '저장하면 바로 확정됩니다. 잘못 넣은 검사실적은 이력에서 [취소]하세요.');

  return (
    <section className="w-[300px] flex-shrink-0 flex flex-col gap-2.5 rounded-xl border border-border bg-surface p-3.5" aria-label="검사실적 입력">
      <div className="flex items-baseline justify-between gap-2">
        <h2 className="text-base font-bold text-text">검사실적 입력</h2>
        <span className="text-[11px] text-text-muted truncate" title={subtitle}>{subtitle}</span>
      </div>

      {/* 판정 */}
      <div className="grid grid-cols-2 gap-1.5" role="radiogroup" aria-label="판정">
        {(['P', 'R'] as const).map((v) => {
          const on = verdict === v;
          const tone = v === 'P'
            ? (on ? 'bg-emerald-600 border-emerald-600 text-white' : 'border-border text-emerald-600 dark:text-emerald-400')
            : (on ? 'bg-red-600 border-red-600 text-white' : 'border-border text-red-600 dark:text-red-400');
          return (
            <button key={v} type="button" role="radio" aria-checked={on} onClick={() => pickVerdict(v)}
              className={`h-12 rounded-lg border bg-background text-lg font-bold transition-colors ${tone} ${disabledReason ? 'opacity-50' : ''}`}>
              {v === 'P' ? '합격' : '불합격'}
            </button>
          );
        })}
      </div>

      {/* 수량 · 불량원인 */}
      <div className="grid grid-cols-[1fr_1.3fr] gap-1.5">
        <div className="rounded-lg border border-primary ring-2 ring-primary/30 px-2 py-1.5 min-w-0 bg-background">
          <span className="block text-[11px] text-text-muted">수량</span>
          <span className="block text-right font-mono text-2xl font-semibold text-text truncate">{n.toLocaleString()}</span>
        </div>
        <button type="button" disabled={verdict === 'P'}
          onClick={() => (disabledReason ? onBlocked() : setReasonOpen(true))}
          className={`text-left rounded-lg border px-2 py-1.5 min-w-0 bg-background disabled:opacity-40 ${
            missingReason ? 'border-red-500 ring-2 ring-red-500/30' : 'border-border'
          }`}>
          <span className="block text-[11px] text-text-muted">불량원인</span>
          <span className={`block text-sm font-semibold truncate ${reason ? 'text-text' : 'text-text-muted'}`}>
            {verdict === 'P' ? '없음(합격)' : reason ? reason.name : '눌러서 선택'}
          </span>
        </button>
      </div>

      <div className="grid grid-cols-3 gap-1.5">
        {KEYS.map((k) => (
          <button key={k} type="button" onClick={() => press(k)}
            className={`h-12 rounded-lg border border-border bg-background active:bg-primary/10 ${disabledReason ? 'opacity-50' : ''} ${
              k === 'CLR' || k === 'BS' ? 'text-sm font-semibold text-text-muted' : 'font-mono text-2xl font-semibold text-text'
            }`}>
            {k === 'CLR' ? '지움' : k === 'BS' ? '⌫' : k}
          </button>
        ))}
      </div>

      <button type="button" onClick={() => void save()} disabled={!disabledReason && !canSave}
        className={`h-14 rounded-xl bg-primary text-white text-lg font-bold hover:bg-primary/90 disabled:opacity-40 ${disabledReason ? 'opacity-50' : ''}`}>
        {saving ? '저장 중…' : '검사실적 저장'}
      </button>
      <p className={`text-[11px] leading-snug ${disabledReason || missingReason ? 'text-amber-600 dark:text-amber-400 font-semibold' : 'text-text-muted'}`}>
        {hint}
      </p>

      <Modal isOpen={reasonOpen} onClose={() => setReasonOpen(false)} title="불량원인 선택" size="2xl" bodyMaxHeightClass="max-h-[85vh]"
        headerActions={
          <button type="button" onClick={() => setReasonOpen(false)}
            className="h-9 px-4 rounded-lg border border-border text-sm font-medium text-text hover:bg-surface">닫기</button>
        }>
        <div className="grid grid-cols-4 gap-2">
          {badReasons.map((r) => {
            const on = reason?.code === r.code;
            return (
              <button key={r.code} type="button" onClick={() => { setReason(r); setReasonOpen(false); }}
                className={`h-14 rounded-lg border px-2 text-center transition-colors ${on ? 'bg-red-600 text-white border-red-600' : 'border-border bg-background text-text hover:border-red-500'}`}>
                <span className="block font-semibold truncate">{r.name}</span>
                <span className={`block text-[11px] font-mono ${on ? 'text-white/80' : 'text-text-muted'}`}>{r.code}</span>
              </button>
            );
          })}
          {!badReasons.length && <p className="col-span-4 p-6 text-center text-sm text-text-muted">불량원인 코드가 없습니다</p>}
        </div>
      </Modal>
    </section>
  );
}
