'use client';

/**
 * @file oee/equip-work-result-free/components/TimeZonePicker.tsx
 * @description 타임구간 선택 — 작업시간 관리에 등록된 A~J 구간을 칩으로 보여주고 하나를 고른다.
 *
 * 초보자 가이드:
 * 1. 구간과 시간은 GET /oee/work-result-free/time-zones (작업시간 관리, WORKTIME) 에서 온다. 화면에 시간을 박아 두지 않는다.
 * 2. 처음에는 지금 시각이 속한 구간이 골라져 있다. 다른 구간의 실적을 넣을 때만 바꾼다.
 */
import { hm, type TimeZoneRow } from '../_lib/types';

interface Props {
  zones: TimeZoneRow[];
  value: string | null;
  onChange: (code: string) => void;
  /** 지금 시각이 속한 구간 */
  current: string | null;
}

export default function TimeZonePicker({ zones, value, onChange, current }: Props) {
  const picked = zones.find((z) => z.code === value) ?? null;
  return (
    <div>
      <div className="mb-1 flex items-baseline justify-between">
        <span className="text-[11px] text-text-muted">타임구간</span>
        <span className="font-mono text-[11px] text-text">
          {picked ? `${picked.code} · ${hm(picked.startTime)}~${hm(picked.endTime)}` : '선택 필요'}
        </span>
      </div>
      <div className="grid grid-cols-5 gap-1">
        {zones.map((z) => {
          const on = z.code === value;
          return (
            <button key={z.code} type="button" onClick={() => onChange(z.code)}
              title={`${z.code} ${hm(z.startTime)}~${hm(z.endTime)}${z.code === current ? ' (지금)' : ''}`}
              className={`h-10 rounded-md border leading-tight transition-colors ${
                on ? 'border-primary bg-primary text-white' : 'border-border bg-background text-text hover:border-primary/60'
              }`}>
              <span className="block text-sm font-bold">{z.code}</span>
              <span className={`block font-mono text-[9px] ${on ? 'text-white/80' : z.code === current ? 'text-primary font-semibold' : 'text-text-muted'}`}>
                {hm(z.startTime)}
              </span>
            </button>
          );
        })}
        {!zones.length && <p className="col-span-5 py-2 text-center text-[11px] text-text-muted">작업시간 관리에 등록된 타임구간이 없습니다</p>}
      </div>
    </div>
  );
}
