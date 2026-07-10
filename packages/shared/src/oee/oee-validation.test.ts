import { describe, it, expect } from 'vitest';
import { validateIntervals } from './oee-validation';
import type { LogInterval } from './types';

const run = (s: number, e: number): LogInterval => ({ startMin: s, endMin: e, status: 'RUN', reasonCode: null });
const down = (s: number, e: number, r: string | null): LogInterval => ({ startMin: s, endMin: e, status: 'DOWN', reasonCode: r });

describe('validateIntervals', () => {
  it('정상 구간이면 오류 없음', () => {
    expect(validateIntervals([run(0, 60), down(60, 90, 'SETUP')], 480)).toEqual([]);
  });
  it('역전 구간 검출', () => {
    const errs = validateIntervals([run(60, 60)], 480);
    expect(errs.map((e) => e.code)).toContain('REVERSED');
  });
  it('겹침 검출', () => {
    const errs = validateIntervals([run(0, 60), run(30, 90)], 480);
    expect(errs.map((e) => e.code)).toContain('OVERLAP');
  });
  it('계획가동 초과 검출', () => {
    const errs = validateIntervals([run(0, 300), run(300, 600)], 480);
    expect(errs.map((e) => e.code)).toContain('EXCEEDS_LOAD');
  });
  it('비가동인데 사유 없으면 검출', () => {
    const errs = validateIntervals([down(0, 30, null)], 480);
    expect(errs.map((e) => e.code)).toContain('REASON_REQUIRED');
  });
});
