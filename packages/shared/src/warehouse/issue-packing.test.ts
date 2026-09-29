/**
 * @file packages/shared/src/warehouse/issue-packing.test.ts
 * @description 출고 포장단위 올림 규칙 테스트.
 *
 * 출고는 재고를 빼는 경로라 실행 검증을 할 수 없다 (사용자 결정: 쓰기는 parse 까지만).
 * 올림이 한 단계 어긋나면 재고가 그만큼 틀어지므로 여기서 못 박는다.
 */
import { describe, expect, it } from 'vitest';
import { applyIssuePacking } from './issue-packing';

describe('applyIssuePacking — 포장 단위 올림', () => {
  it('요청이 0 이면 0 이다 (PB 첫 줄)', () => {
    expect(applyIssuePacking(0, 250)).toBe(0);
  });

  it('포장 단위가 없거나 0 이면 요청 수량 그대로다', () => {
    expect(applyIssuePacking(300, 0)).toBe(300);
    expect(applyIssuePacking(300, null)).toBe(300);
    expect(applyIssuePacking(300)).toBe(300);
  });

  it('포장 단위가 요청보다 크거나 같으면 한 봉지가 통째로 나간다', () => {
    expect(applyIssuePacking(100, 250)).toBe(250);
    expect(applyIssuePacking(250, 250)).toBe(250);
  });

  it('배수로 떨어지면 그대로다', () => {
    expect(applyIssuePacking(500, 250)).toBe(500);
    expect(applyIssuePacking(1000, 250)).toBe(1000);
  });

  it('나머지가 있으면 한 봉지 더 올린다', () => {
    expect(applyIssuePacking(300, 250)).toBe(500);
    expect(applyIssuePacking(501, 250)).toBe(750);
    expect(applyIssuePacking(251, 250)).toBe(500);
  });

  it('올린 값은 항상 포장 단위의 배수이고 요청보다 작지 않다', () => {
    for (const qty of [1, 7, 99, 100, 249, 250, 251, 999, 4321]) {
      const out = applyIssuePacking(qty, 250);
      expect(out % 250).toBe(0);
      expect(out).toBeGreaterThanOrEqual(qty);
    }
  });

  /**
   * **PB 의 결함을 그대로 둔 자리다.** PB 는 `포장단위 >= 요청수량` 을 먼저 보는데
   * 음수 요청은 항상 이 분기에 걸려 **양수 포장단위**가 나온다 — 반납(음수)이
   * 출고(양수)로 뒤집힌다. 순수 함수는 PB 와 같은 값을 내야 하므로 고치지 않고,
   * **서비스에서 '포장단위 적용 + 음수 수량' 조합을 거절한다.**
   */
  it('음수 요청은 PB 와 똑같이 양수 포장단위를 낸다 (그래서 서비스가 막는다)', () => {
    expect(applyIssuePacking(-300, 250)).toBe(250);
    expect(applyIssuePacking(-500, 250)).toBe(250);
    expect(applyIssuePacking(-100, 250)).toBe(250);
  });

  it('소수 포장 단위도 배수로 맞춘다', () => {
    expect(applyIssuePacking(1, 0.5)).toBe(1);
    expect(applyIssuePacking(0.7, 0.5)).toBeCloseTo(1, 10);
  });
});
