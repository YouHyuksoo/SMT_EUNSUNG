/**
 * @file src/app/(authenticated)/production/smd-plan-board/board-types.ts
 * @description 반제품생산계획 현황판 — 응답 타입과 화면 행으로 바꾸는 규칙.
 *
 * 초보자 가이드:
 * 1. 계획 행은 기존 반제품생산계획 API(PlanRow)를 그대로 쓴다. 시간대 10칸은
 *    planTime1..10(계획) / actualTime1..10(센서 실적, A..J)이다.
 * 2. 한 계획을 두 줄로 펼친다. 주간 = 1~5칸(A~E, 08:30~20:30),
 *    야간 = 6~10칸(F~J, 20:30~다음날 08:30). 엑셀의 A~E TIME 다섯 칸이
 *    야간 줄에서는 F~J 를 뜻한다. 구간 시각은 서버가 ICOM_WORKTIME_RANGES 에서 내려준다.
 */
import type { PlanRow } from '../planning-types';

export interface BoardSlot {
  /** 센서 시간구분 A..J */
  code: string;
  /** HHMM */
  startTime: string;
  /** HHMM */
  endTime: string;
}

export interface BoardLine {
  lineCode: string;
  lineName: string | null;
}

export interface BoardNoteGroup {
  lines: string[];
  enterBy: string | null;
  enterDate: string | null;
}

/** 같은 날 계획과 맞지 않는 센서 실적 (전날 이전 계획을 이어서 생산한 것 등) */
export interface ExtraActualRow {
  lineCode: string;
  modelName: string | null;
  modelSuffix: string | null;
  pcbItem: string | null;
  pcbItemName: string | null;
  [key: string]: unknown;
}

export interface BoardMeta {
  date: string;
  slots: BoardSlot[];
  lines: BoardLine[];
  extraActuals: ExtraActualRow[];
  notice: BoardNoteGroup;
  lineNotes: Record<string, BoardNoteGroup>;
}

/** 근무조 한 줄의 시간대 5칸 */
export interface ShiftCells {
  plan: Array<number | null>;
  actual: Array<number | null>;
  actualSum: number;
}

/** 블록 안의 한 항목 (계획 또는 계획 외 실적). 주간·야간 두 줄로 그린다. */
export interface BoardItem {
  key: string;
  kind: 'plan' | 'extra';
  modelName: string;
  modelSuffix: string | null;
  pcbItem: string | null;
  pcbItemName: string | null;
  itemCode: string | null;
  /** LOT 수량 = 계획수량(PLAN_QTY). 롯트카드 LOT_SIZE 와 같은 값이다. */
  lotQty: number | null;
  /** 생산계획 = 시간대 계획 10칸 합 */
  planSum: number | null;
  day: ShiftCells;
  night: ShiftCells;
}

/** 근무조 한 줄의 칸 수 */
export const SHIFT_SLOT_COUNT = 5;

export const SHIFTS = [
  { key: 'day', label: '주간', firstSlot: 1 },
  { key: 'night', label: '야간', firstSlot: 6 },
] as const;

const toNum = (value: unknown): number | null => {
  if (value === null || value === undefined || value === '') return null;
  const n = Number(value);
  return Number.isFinite(n) ? n : null;
};

function shiftCells(row: Record<string, unknown>, firstSlot: number, withPlan: boolean): ShiftCells {
  const plan: Array<number | null> = [];
  const actual: Array<number | null> = [];
  for (let i = 0; i < SHIFT_SLOT_COUNT; i += 1) {
    const slot = firstSlot + i;
    plan.push(withPlan ? toNum(row[`planTime${slot}`]) : null);
    actual.push(toNum(row[`actualTime${slot}`]));
  }
  return { plan, actual, actualSum: actual.reduce<number>((sum, v) => sum + (v ?? 0), 0) };
}

export function planToItem(row: PlanRow): BoardItem {
  return {
    key: `plan|${row.planDate}|${row.planSequence}`,
    kind: 'plan',
    modelName: row.modelName,
    modelSuffix: row.modelSuffix,
    pcbItem: row.pcbItem,
    pcbItemName: row.pcbItemName,
    itemCode: row.itemCode,
    lotQty: toNum(row.planQty),
    planSum: toNum(row.planTimeSum),
    day: shiftCells(row, 1, true),
    night: shiftCells(row, 6, true),
  };
}

export function extraToItem(row: ExtraActualRow): BoardItem {
  return {
    key: `extra|${row.lineCode}|${row.modelName}|${row.modelSuffix}|${row.pcbItem}`,
    kind: 'extra',
    modelName: row.modelName ?? '',
    modelSuffix: row.modelSuffix,
    pcbItem: row.pcbItem,
    pcbItemName: row.pcbItemName,
    itemCode: null,
    lotQty: null,
    planSum: null,
    day: shiftCells(row, 1, false),
    night: shiftCells(row, 6, false),
  };
}

/** 근무조별 시간대 합계 (블록 맨 아래 합계 줄) */
export function shiftTotals(items: BoardItem[], shift: 'day' | 'night'): { slots: number[]; sum: number } {
  const slots = Array.from({ length: SHIFT_SLOT_COUNT }, (_, i) =>
    items.reduce((sum, item) => sum + (item[shift].actual[i] ?? 0), 0));
  return { slots, sum: slots.reduce((a, b) => a + b, 0) };
}

/** 'A라인' → 'A'. 라인 글자가 아닌 이름(OFFLINE 등)은 그대로 둔다. */
export function lineLetter(line: BoardLine): string {
  const name = (line.lineName ?? line.lineCode).trim();
  const short = name.replace(/\s*라인$/, '');
  return short.length > 0 && short.length <= 2 ? short : name;
}

/** '0830' → '08:30' */
export const hhmm = (value: string | null | undefined) =>
  value && value.length === 4 ? `${value.slice(0, 2)}:${value.slice(2)}` : value ?? '';
