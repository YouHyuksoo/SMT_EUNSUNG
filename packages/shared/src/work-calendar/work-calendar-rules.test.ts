import { describe, it, expect } from 'vitest';
import {
  shiftNetMinutes,
  defaultWorkMinutes,
  holidayYnOf,
  isFixedHoliday,
} from './work-calendar-rules';
import type { ShiftTimeMasterLike } from './types';

const SHIFT: ShiftTimeMasterLike = {
  dayTimeStart: '08:00',
  dayTimeEnd: '20:00',
  dayBreakMinutes: 60,
  nightTimeStart: '20:00',
  nightTimeEnd: '08:00',
  nightBreakMinutes: 60,
};

describe('shiftNetMinutes = 교대 구간 - 휴식', () => {
  it('08:00~20:00, 휴식 60분이면 660분', () =>
    expect(shiftNetMinutes({ start: '08:00', end: '20:00', breakMinutes: 60 })).toBe(660));

  it('자정을 넘기는 야간 20:00~08:00, 휴식 60분이면 660분', () =>
    expect(shiftNetMinutes({ start: '20:00', end: '08:00', breakMinutes: 60 })).toBe(660));

  it('HH:MM:SS 형식도 받는다', () =>
    expect(shiftNetMinutes({ start: '08:00:00', end: '17:00:00', breakMinutes: 60 })).toBe(480));

  it('휴식이 구간보다 크면 0으로 잘린다', () =>
    expect(shiftNetMinutes({ start: '08:00', end: '09:00', breakMinutes: 120 })).toBe(0));

  it('시작=종료면 0 (24시간이 아니라 0으로 본다)', () =>
    expect(shiftNetMinutes({ start: '08:00', end: '08:00', breakMinutes: 0 })).toBe(0));
});

describe('defaultWorkMinutes', () => {
  it('OFF는 0', () => expect(defaultWorkMinutes('OFF', SHIFT)).toBe(0));
  it('WORK는 주간순 + 야간순 = 1320', () => expect(defaultWorkMinutes('WORK', SHIFT)).toBe(1320));
  it('HALF는 주간순의 절반 = 330', () => expect(defaultWorkMinutes('HALF', SHIFT)).toBe(330));
  it('SPECIAL은 주간순 = 660', () => expect(defaultWorkMinutes('SPECIAL', SHIFT)).toBe(660));
  it('교대시간 마스터가 없으면 0', () => expect(defaultWorkMinutes('WORK', null)).toBe(0));

  it('야간 미운영(시간 미설정)이면 WORK는 주간순만', () =>
    expect(
      defaultWorkMinutes('WORK', { ...SHIFT, nightTimeStart: null, nightTimeEnd: null }),
    ).toBe(660));

  it('HALF는 홀수분이면 내림한다', () =>
    expect(
      defaultWorkMinutes('HALF', { ...SHIFT, dayTimeEnd: '17:01', dayBreakMinutes: 0 }),
    ).toBe(270)); // 08:00~17:01 = 541분 → 절반 270.5 → 270
});

describe('holidayYnOf — HOLIDAY_YN은 DAY_TYPE의 미러', () => {
  it('OFF만 Y', () => expect(holidayYnOf('OFF')).toBe('Y'));
  it('WORK는 N', () => expect(holidayYnOf('WORK')).toBe('N'));
  it('HALF는 N', () => expect(holidayYnOf('HALF')).toBe('N'));
  it('SPECIAL은 N (휴일 특근이지만 근무일이다)', () => expect(holidayYnOf('SPECIAL')).toBe('N'));
});

describe('isFixedHoliday — 양력 고정공휴일만', () => {
  it('1월 1일', () => expect(isFixedHoliday('2026-01-01')).toBe(true));
  it('3월 1일', () => expect(isFixedHoliday('2026-03-01')).toBe(true));
  it('12월 25일', () => expect(isFixedHoliday('2026-12-25')).toBe(true));
  it('평일은 false', () => expect(isFixedHoliday('2026-07-14')).toBe(false));
  it('설날(음력)은 자동 반영하지 않는다', () => expect(isFixedHoliday('2026-02-17')).toBe(false));
});
