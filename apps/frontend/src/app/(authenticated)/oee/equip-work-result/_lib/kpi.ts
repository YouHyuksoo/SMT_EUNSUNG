/**
 * @file oee/equip-work-result/_lib/kpi.ts
 * @description 생산 현황 하단 지표 — 계획·실적·목표·달성율·계획달성율·UPH 계산
 *
 * 초보자 가이드:
 * 1. 업무일은 08:30 에 시작한다. 00:00~08:30 은 전날 업무일이다.
 * 2. 목표 = 오늘 업무 시작부터 지금까지 경과 초 ÷ C/T (계획수량을 넘지 않는다).
 *    작업지시 계획일이 오늘 업무일이 아니면 목표는 계획수량이다. 휴식시간은 빼지 않는다.
 * 3. UPH = 실적 ÷ (실적 등록 때 입력한 작업시간 합계 ÷ 60). 작업시간이 없으면 계산하지 않는다.
 * 4. 계산할 수 없는 값은 null 로 돌려 화면이 '-' 로 보여준다(0 으로 위장하지 않는다).
 */
import type { ResultHistoryRow, RunRow } from './types';

const DAY_START_MIN = 8 * 60 + 30;

const pad = (n: number) => String(n).padStart(2, '0');
const ymd = (d: Date) => `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;

/** 지금 시각이 속한 업무일 시작 시각(08:30) */
export function businessDayStart(now: Date): Date {
  const start = new Date(now);
  start.setHours(8, 30, 0, 0);
  if (now.getHours() * 60 + now.getMinutes() < DAY_START_MIN) start.setDate(start.getDate() - 1);
  return start;
}

export function businessDate(now: Date): string {
  return ymd(businessDayStart(now));
}

export interface Kpis {
  plan: number;
  result: number;
  target: number | null;
  achieveRate: number | null;
  planRate: number | null;
  uph: number | null;
}

export function computeKpis(run: RunRow, history: ResultHistoryRow[], now: Date): Kpis {
  const plan = Number(run.planQty ?? 0);
  const result = Number(run.resultQty ?? 0);

  let target: number | null = null;
  if (run.runDate !== businessDate(now)) {
    target = plan || null;
  } else if (run.ct && run.ct > 0) {
    const elapsedSec = Math.max(0, (now.getTime() - businessDayStart(now).getTime()) / 1000);
    target = Math.floor(elapsedSec / run.ct);
    if (plan > 0) target = Math.min(target, plan);
  }

  const workMin = history
    .filter((h) => h.resultStatus !== 'CANCEL')
    .reduce((sum, h) => sum + Number(h.workTime ?? 0), 0);

  return {
    plan,
    result,
    target,
    achieveRate: target && target > 0 ? (result / target) * 100 : null,
    planRate: plan > 0 ? (result / plan) * 100 : null,
    uph: workMin > 0 ? result / (workMin / 60) : null,
  };
}
