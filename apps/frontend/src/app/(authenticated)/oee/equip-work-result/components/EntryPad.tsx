'use client';

/**
 * @file oee/equip-work-result/components/EntryPad.tsx
 * @description 실적 입력판 — 숫자패드를 화면에 상시 두고 수량·작업시간·인원을 바로 입력해 저장한다.
 *
 * 초보자 가이드:
 * 1. 칸(수량/작업시간/인원)을 누르면 숫자패드가 그 칸에 입력한다. 기본 칸은 수량이다.
 * 2. 저장하면 바로 확정(DONE)되어 완제품 실적이 되고, 조립라인이면 공정재고(제품 입고 + 소모)에 반영된다. 잘못 넣은 실적은 이력에서 취소한다.
 * 3. 저장 후 수량·작업시간은 비우고 인원은 유지한다(같은 조가 이어서 넣는 경우가 많다).
 * 4. 입력할 수 없는 상태(작업자·작업지시 미선택 등)에서 누르면 onBlocked 로 알려 부모가 선택 창을 연다
 *    — 버튼을 조용히 막지 않는다.
 */
import { useState } from 'react';

type Field = 'qty' | 'time' | 'crew';
const FIELDS: { key: Field; label: string }[] = [
  { key: 'qty', label: '수량' },
  { key: 'time', label: '작업시간(분)' },
  { key: 'crew', label: '인원' },
];
const KEYS = ['7', '8', '9', '4', '5', '6', '1', '2', '3', 'CLR', '0', 'BS'] as const;

interface Props {
  disabledReason: string | null;
  subtitle: string;
  onSave: (v: { qty: number; time: number; crew: number }) => Promise<boolean>;
  /** 입력할 수 없는 상태에서 칸·숫자패드·저장을 눌렀을 때 */
  onBlocked: () => void;
}

export default function EntryPad({ disabledReason, subtitle, onSave, onBlocked }: Props) {
  const [vals, setVals] = useState<Record<Field, string>>({ qty: '0', time: '0', crew: '1' });
  const [field, setField] = useState<Field>('qty');
  const [saving, setSaving] = useState(false);

  function press(k: (typeof KEYS)[number]) {
    if (disabledReason) { onBlocked(); return; }
    setVals((prev) => {
      const cur = prev[field];
      const next = k === 'CLR' ? '0' : k === 'BS' ? (cur.length > 1 ? cur.slice(0, -1) : '0') : cur.length >= 6 ? cur : cur === '0' ? k : cur + k;
      return { ...prev, [field]: next };
    });
  }

  const qty = Number(vals.qty);
  const canSave = !disabledReason && qty > 0 && !saving;

  async function save() {
    if (disabledReason) { onBlocked(); return; }
    if (!canSave) return;
    setSaving(true);
    try {
      const ok = await onSave({ qty, time: Number(vals.time), crew: Number(vals.crew) });
      if (ok) { setVals((p) => ({ ...p, qty: '0', time: '0' })); setField('qty'); }
    } finally {
      setSaving(false);
    }
  }

  return (
    <section className="w-[300px] flex-shrink-0 flex flex-col gap-2.5 rounded-xl border border-border bg-surface p-3.5" aria-label="실적 입력">
      <div className="flex items-baseline justify-between gap-2">
        <h2 className="text-base font-bold text-text">실적 입력</h2>
        <span className="text-[11px] text-text-muted truncate" title={subtitle}>{subtitle}</span>
      </div>

      <div className="grid grid-cols-[1.4fr_1fr_0.8fr] gap-1.5">
        {FIELDS.map((f) => (
          <button key={f.key} type="button" onClick={() => (disabledReason ? onBlocked() : setField(f.key))}
            className={`text-left rounded-lg border px-2 py-1.5 min-w-0 bg-background transition-shadow ${
              field === f.key ? 'border-primary ring-2 ring-primary/30' : 'border-border'
            }`}>
            <span className="block text-[11px] text-text-muted">{f.label}</span>
            <span className="block text-right font-mono text-2xl font-semibold text-text truncate">{Number(vals[f.key]).toLocaleString()}</span>
          </button>
        ))}
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
        {saving ? '저장 중…' : '실적 저장'}
      </button>
      <p className={`text-[11px] leading-snug ${disabledReason ? 'text-amber-600 dark:text-amber-400 font-semibold' : 'text-text-muted'}`}>
        {disabledReason ?? '저장하면 바로 생산현황에 반영됩니다. 잘못 넣은 실적은 이력에서 [취소]하세요.'}
      </p>
    </section>
  );
}
