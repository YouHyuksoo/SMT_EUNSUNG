"use client";

/**
 * @file src/app/(authenticated)/query/components/QueryTabs.tsx
 * @description 조회 화면의 탭 줄 + 자동갱신 컨트롤.
 *
 * 초보자 가이드:
 * 1. **PB 의 탭 컨트롤을 그대로 옮긴 것이다.** 327(4탭)·330(4탭) 이 쓴다.
 *    탭마다 건수를 함께 보여준다 — 어느 탭에 데이터가 있는지 눌러 보지 않고 안다.
 * 2. **자동갱신은 PB 의 Interval / Start / Stop 이다.** 329·330 이 쓴다.
 *    돌고 있으면 주기를 화면에 적는다 — 멈춰 있는지 돌고 있는지 보여야 한다.
 */
import type { ReactNode } from 'react';
import { Button, Input } from '@/components/ui';

export interface QueryTabDef<K extends string> {
  key: K;
  label: string;
  /** 탭 제목 옆에 붙일 건수. 0 이면 표시하지 않는다. */
  count?: number;
}

export function QueryTabs<K extends string>({
  tabs,
  active,
  onChange,
}: {
  tabs: QueryTabDef<K>[];
  active: K;
  onChange: (key: K) => void;
}) {
  return (
    <div className="flex flex-wrap gap-1 border-b border-border">
      {tabs.map((t) => (
        <button
          key={t.key}
          type="button"
          onClick={() => onChange(t.key)}
          className={`px-3 py-2 text-sm ${active === t.key
            ? 'border-b-2 border-primary font-semibold text-text'
            : 'text-text-muted hover:text-text'}`}
        >
          {t.label}
          {(t.count ?? 0) > 0 && (
            <span className="ml-1 text-xs text-text-muted">{t.count}</span>
          )}
        </button>
      ))}
    </div>
  );
}

/**
 * 자동갱신 컨트롤. 주기(초)와 시작/정지만 다룬다 — 실제 타이머는 화면이 건다
 * (무엇을 다시 읽을지는 화면마다 다르다).
 */
export function AutoRefreshControl({
  intervalSec,
  onIntervalChange,
  running,
  onToggle,
  disabled,
  children,
}: {
  intervalSec: string;
  onIntervalChange: (v: string) => void;
  running: boolean;
  onToggle: () => void;
  disabled?: boolean;
  children?: ReactNode;
}) {
  return (
    <div className="flex flex-wrap items-center gap-2">
      <label className="flex items-center gap-1 text-sm text-text">
        <Input
          aria-label="갱신 주기(초)"
          value={intervalSec}
          className="w-16"
          onChange={(e) => onIntervalChange(e.target.value.replace(/\D/g, ''))}
        />
        초
      </label>
      <Button size="sm" variant={running ? 'secondary' : 'primary'}
        onClick={onToggle} disabled={disabled}>
        {running ? '자동갱신 정지' : '자동갱신 시작'}
      </Button>
      {children}
    </div>
  );
}
