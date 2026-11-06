/**
 * @file oee/equip-inspect-result/_lib/inspect.ts
 * @description 설비별 검사실적관리 — 단말기 기억(라인·공정·설비·작업지시·검사자)과 이력 타입·지표 계산.
 *
 * 초보자 가이드:
 * 1. 설비별 작업 실적관리와 같은 방식으로 단말기(localStorage)에 기억하지만 키는 따로 쓴다.
 *    같은 PC 에서 두 화면을 쓰더라도 서로의 선택(검사설비 ↔ 생산설비)을 덮어쓰지 않는다.
 * 2. 작업지시는 업무일(08:30 기준)과 함께 저장하고, 오늘 업무일이 아니면 버린다.
 * 3. 지표는 취소 제외 이력으로 계산한다. 계산할 수 없으면 null('-').
 */
import { todayStr, type Scope } from '../../equip-work-result/_lib/scope';

export type { Scope };

const SCOPE_KEY = 'oee:equip-inspect-result:scope';
const RUN_KEY = 'oee:equip-inspect-result:run';
const INSPECTOR_KEY = 'oee:equip-inspect-result:inspector';

export interface Inspector { code: string; name: string }

/** GET /oee/inspect-result/results?runNo 한 행 */
export interface InspectHistoryRow {
  seqNo: number;
  machineCode: string | null;
  machineName: string | null;
  workstageCode: string | null;
  /** P=합격, R=불합격 */
  inspectResult: 'P' | 'R';
  inspectQty: number;
  badReasonCode: string | null;
  badReasonName: string | null;
  inspectorName: string | null;
  /** DONE | CANCEL */
  resultStatus: string;
  /** 'YYYY-MM-DD HH24:MI:SS' */
  enteredAt: string | null;
  /** 오늘 업무일 등록이면 'Y' — 취소 가능 */
  today: 'Y' | 'N';
}

export const VERDICT_LABEL = { P: '합격', R: '불합격' } as const;

export interface InspectKpis {
  inspected: number;
  pass: number;
  fail: number;
  passRate: number | null;
}

export function computeInspectKpis(history: InspectHistoryRow[]): InspectKpis {
  let pass = 0;
  let fail = 0;
  for (const h of history) {
    if (h.resultStatus === 'CANCEL') continue;
    if (h.inspectResult === 'P') pass += Number(h.inspectQty ?? 0);
    else fail += Number(h.inspectQty ?? 0);
  }
  const inspected = pass + fail;
  return { inspected, pass, fail, passRate: inspected > 0 ? (pass / inspected) * 100 : null };
}

function read<T>(key: string): T | null {
  try {
    const raw = localStorage.getItem(key);
    return raw ? (JSON.parse(raw) as T) : null;
  } catch {
    return null;
  }
}

function write(key: string, value: unknown) {
  try {
    if (value == null) localStorage.removeItem(key);
    else localStorage.setItem(key, JSON.stringify(value));
  } catch { /* 저장 실패 무시 */ }
}

export function loadScope(): Scope | null {
  const s = read<Partial<Scope>>(SCOPE_KEY);
  return s?.lineCode && s.machineCode
    ? { lineCode: s.lineCode, workstageCode: s.workstageCode ?? '', machineCode: s.machineCode }
    : null;
}

export function saveScope(scope: Scope) {
  write(SCOPE_KEY, scope);
}

/** 오늘 고른 작업지시만 되살린다 */
export function loadRunNo(): string | null {
  const r = read<{ runNo?: string; savedOn?: string }>(RUN_KEY);
  return r?.runNo && r.savedOn === todayStr() ? r.runNo : null;
}

export function saveRunNo(runNo: string | null) {
  write(RUN_KEY, runNo ? { runNo, savedOn: todayStr() } : null);
}

export function loadInspector(): Inspector | null {
  const w = read<Inspector>(INSPECTOR_KEY);
  return w?.code ? w : null;
}

export function saveInspector(w: Inspector) {
  write(INSPECTOR_KEY, w);
}
