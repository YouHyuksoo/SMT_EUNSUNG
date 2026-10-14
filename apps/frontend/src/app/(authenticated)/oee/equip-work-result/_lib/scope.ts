/**
 * @file oee/equip-work-result/_lib/scope.ts
 * @description 설비별 작업 실적관리 — 라인·공정·설비 선택과 작업지시를 단말기(localStorage)에 기억한다.
 *
 * 초보자 가이드:
 * 1. 현장 PC 는 한 설비 앞에 놓인다. 한 번 고른 라인·공정·설비를 기억했다가 진입 때 자동 선택한다.
 * 2. 작업지시는 날짜가 지나면 의미가 없어서 업무일(08:30 기준)과 함께 저장하고, 오늘 업무일이 아니면 버린다.
 * 3. localStorage 를 못 쓰는 환경(시크릿 모드 등)은 매번 고르면 된다 — 실패는 조용히 무시한다.
 */
import type { OpsLine, OpsMachine } from '../../equip-ops-status/types';
import { businessDate } from './kpi';

export interface Scope {
  lineCode: string;
  workstageCode: string;
  machineCode: string;
}

const SCOPE_KEY = 'oee:equip-work-result:scope';
const RUN_KEY = 'oee:equip-work-result:run';

/** 오늘 업무일 'YYYY-MM-DD' — 08:30 이전은 전날이다(작업지시 계획일과 같은 기준) */
export function todayStr() {
  return businessDate(new Date());
}

export function loadScope(): Scope | null {
  try {
    const raw = localStorage.getItem(SCOPE_KEY);
    if (!raw) return null;
    const s = JSON.parse(raw) as Partial<Scope>;
    return s.lineCode && s.machineCode
      ? { lineCode: s.lineCode, workstageCode: s.workstageCode ?? '', machineCode: s.machineCode }
      : null;
  } catch {
    return null;
  }
}

export function saveScope(scope: Scope) {
  try { localStorage.setItem(SCOPE_KEY, JSON.stringify(scope)); } catch { /* 저장 실패 무시 */ }
}

/** 오늘 고른 작업지시만 되살린다. 지시일(runDate)이 오늘이 아니어도 그 날짜로 다시 찾는다 */
export function loadRunNo(): { runNo: string; runDate: string | null } | null {
  try {
    const raw = localStorage.getItem(RUN_KEY);
    if (!raw) return null;
    const r = JSON.parse(raw) as { runNo?: string; runDate?: string; savedOn?: string };
    return r.runNo && r.savedOn === todayStr() ? { runNo: r.runNo, runDate: r.runDate ?? null } : null;
  } catch {
    return null;
  }
}

export function saveRunNo(runNo: string | null, runDate?: string) {
  try {
    if (runNo) localStorage.setItem(RUN_KEY, JSON.stringify({ runNo, runDate, savedOn: todayStr() }));
    else localStorage.removeItem(RUN_KEY);
  } catch { /* 저장 실패 무시 */ }
}

/** 설비 목록에서 공정(코드·이름) 목록을 뽑는다 — 공정 마스터가 아니라 실제 설비가 있는 공정만 */
export function workstagesOf(machines: OpsMachine[]): { code: string; name: string }[] {
  const map = new Map<string, string>();
  for (const m of machines) {
    // '*' 는 공정 미지정이다 — 고를 수 있는 공정이 아니다
    if (m.workstageCode && m.workstageCode !== '*' && !map.has(m.workstageCode)) map.set(m.workstageCode, m.workstageName ?? m.workstageCode);
  }
  return [...map.entries()].map(([code, name]) => ({ code, name })).sort((a, b) => a.code.localeCompare(b.code));
}

export function lineLabel(line: OpsLine | null | undefined, lineCode: string | null | undefined) {
  return line ? line.lineName ?? line.lineCode : lineCode ?? '-';
}
