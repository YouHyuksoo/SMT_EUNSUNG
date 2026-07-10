import { describe, it, expect } from 'vitest';
import { availability, performance, quality, oee } from './oee-calc';

describe('availability = 실제가동 / 계획가동', () => {
  it('완전 가동이면 1', () => expect(availability(480, 480)).toBe(1));
  it('절반 가동이면 0.5', () => expect(availability(240, 480)).toBe(0.5));
  it('계획가동 0이면 0 (0으로 나누기 방지)', () => expect(availability(100, 0)).toBe(0));
});

describe('performance = (이론CT초 × 총생산) / 가동초', () => {
  it('이론CT 6초, 100개, 10분 가동이면 1', () => expect(performance(6, 100, 10)).toBe(1));
  it('가동 0분이면 0', () => expect(performance(6, 100, 0)).toBe(0));
});

describe('quality = 양품 / 총생산', () => {
  it('95/100 = 0.95', () => expect(quality(95, 100)).toBe(0.95));
  it('총생산 0이면 0', () => expect(quality(0, 0)).toBe(0));
});

describe('oee = 가동 × 성능 × 양품', () => {
  it('세 비율의 곱', () => expect(oee(0.5, 0.5, 0.5)).toBe(0.125));
});
