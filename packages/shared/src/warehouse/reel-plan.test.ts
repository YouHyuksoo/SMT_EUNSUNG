/**
 * @file packages/shared/src/warehouse/reel-plan.test.ts
 * @description 릴 분할 규칙 테스트.
 *
 * **왜 이 테스트가 필요한가.** 자재 바코드 발행은 운영 입고 원장에 쓰는 경로라
 * 실제로 돌려 볼 수 없다 (사용자 결정: 쓰기는 parse 까지만). SQL parse 는 장수가
 * 맞는지, 수량 합이 전표와 맞는지 **아무것도 말해주지 않는다.**
 * 그래서 위험한 부분(분할 계획)을 순수 함수로 떼어 여기서 못 박는다.
 */
import { describe, expect, it } from 'vitest';
import {
  buildReelBarcode,
  buildReelLotNo,
  checkReelPlan,
  planReelBarcodes,
  planReelQuantities,
  REEL_PLAN_MAX,
  totalReelQty,
} from './reel-plan';

describe('checkReelPlan — 발행 가능 판정', () => {
  it('균등: 릴 장수와 단위수량이 있으면 발행할 수 있다', () => {
    expect(checkReelPlan({ reelQty: 5, unitQty: 100 })).toEqual({ ok: true });
  });

  it('균등: 단위수량이 없으면 거절한다 (PB 가 두 곳에서 막는 조건)', () => {
    const verdict = checkReelPlan({ reelQty: 5 });
    expect(verdict.ok).toBe(false);
    expect(verdict.reason).toContain('단위수량');
  });

  it('균등: 단위수량이 0 이면 거절한다 — 수량 0짜리 바코드가 릴 수만큼 나온다', () => {
    expect(checkReelPlan({ reelQty: 5, unitQty: 0 }).ok).toBe(false);
  });

  it('균등: 릴 장수가 0 이하이거나 소수면 거절한다', () => {
    expect(checkReelPlan({ reelQty: 0, unitQty: 100 }).ok).toBe(false);
    expect(checkReelPlan({ reelQty: -1, unitQty: 100 }).ok).toBe(false);
    expect(checkReelPlan({ reelQty: 2.5, unitQty: 100 }).ok).toBe(false);
  });

  it('수동: 분할 목록이 있으면 릴 장수·단위수량이 없어도 된다', () => {
    expect(checkReelPlan({ divideQty: [30, 40, 30] })).toEqual({ ok: true });
  });

  it('수동: 분할 목록이 우선한다 (릴 장수·단위수량을 무시)', () => {
    const quantities = planReelQuantities({ reelQty: 9, unitQty: 1, divideQty: [7, 8] });
    expect(quantities).toEqual([7, 8]);
  });

  it('수동: 0 이하가 섞이면 거절한다', () => {
    expect(checkReelPlan({ divideQty: [10, 0, 5] }).ok).toBe(false);
    expect(checkReelPlan({ divideQty: [10, -3] }).ok).toBe(false);
  });

  it('두 갈래 모두 상한을 넘으면 거절한다 (PB 에는 상한이 없었다)', () => {
    expect(checkReelPlan({ reelQty: REEL_PLAN_MAX + 1, unitQty: 1 }).ok).toBe(false);
    expect(checkReelPlan({
      divideQty: Array.from({ length: REEL_PLAN_MAX + 1 }, () => 1),
    }).ok).toBe(false);
  });

  it('빈 분할 목록은 수동이 아니라 균등으로 본다', () => {
    // 빈 배열을 수동으로 치면 0장이 발행된다. 균등 갈래로 떨어져 단위수량을 요구해야 한다.
    expect(checkReelPlan({ divideQty: [], reelQty: 3, unitQty: 50 }).ok).toBe(true);
    expect(checkReelPlan({ divideQty: [] }).ok).toBe(false);
  });
});

describe('planReelQuantities — 장수와 수량', () => {
  it('균등: 장수 = 릴 장수, 각 수량 = 단위수량', () => {
    expect(planReelQuantities({ reelQty: 4, unitQty: 250 })).toEqual([250, 250, 250, 250]);
  });

  it('수동: 장수 = 적은 개수, 각 수량 = 적은 값 그대로', () => {
    expect(planReelQuantities({ divideQty: [120, 80, 300] })).toEqual([120, 80, 300]);
  });

  it('발행 불가한 입력은 빈 목록이다 (판정은 checkReelPlan 이 한다)', () => {
    expect(planReelQuantities({ reelQty: 5 })).toEqual([]);
  });
});

describe('totalReelQty — 수량 합', () => {
  it('균등의 합은 릴 장수 × 단위수량이다', () => {
    expect(totalReelQty({ reelQty: 6, unitQty: 500 })).toBe(3000);
  });

  it('수동의 합은 적은 값들의 합이다', () => {
    expect(totalReelQty({ divideQty: [100, 250, 150] })).toBe(500);
  });

  it('전표 수량과 맞는지 비교할 수 있다 — 이 값이 어긋나면 원장이 틀어진다', () => {
    const slipQty = 1000;
    expect(totalReelQty({ reelQty: 4, unitQty: 250 })).toBe(slipQty);
    expect(totalReelQty({ divideQty: [400, 300, 300] })).toBe(slipQty);
    expect(totalReelQty({ divideQty: [400, 300, 200] })).not.toBe(slipQty);
  });
});

describe('롯트번호·바코드 형식 (PB 문자열 연결 그대로)', () => {
  it('롯트번호 = 날짜접두어 + 시퀀스', () => {
    expect(buildReelLotNo('20260928', 96510)).toBe('2026092896510');
  });

  it('바코드 = 품목코드-롯트번호-수량', () => {
    expect(buildReelBarcode('E1851600020', '2026092896510', 250))
      .toBe('E1851600020-2026092896510-250');
  });
});

describe('planReelBarcodes — 발행 목록', () => {
  const base = { itemCode: 'E1851600020', datePrefix: '20260928' };

  it('장마다 다른 시퀀스로 다른 롯트번호를 만든다', () => {
    const plans = planReelBarcodes({ ...base, reelQty: 3, unitQty: 100 }, [11, 12, 13]);
    expect(plans).toEqual([
      { lotNo: '2026092811', itemBarcode: 'E1851600020-2026092811-100', scanQty: 100 },
      { lotNo: '2026092812', itemBarcode: 'E1851600020-2026092812-100', scanQty: 100 },
      { lotNo: '2026092813', itemBarcode: 'E1851600020-2026092813-100', scanQty: 100 },
    ]);
  });

  it('수동 분할은 장마다 수량이 다르고 바코드에도 그 수량이 들어간다', () => {
    const plans = planReelBarcodes({ ...base, divideQty: [70, 30] }, [21, 22]);
    expect(plans.map((p) => p.scanQty)).toEqual([70, 30]);
    expect(plans[0].itemBarcode).toBe('E1851600020-2026092821-70');
    expect(plans[1].itemBarcode).toBe('E1851600020-2026092822-30');
  });

  it('롯트번호가 장마다 다르다 — 겹치면 바코드가 중복된다', () => {
    const plans = planReelBarcodes({ ...base, reelQty: 5, unitQty: 10 }, [1, 2, 3, 4, 5]);
    expect(new Set(plans.map((p) => p.lotNo)).size).toBe(5);
    expect(new Set(plans.map((p) => p.itemBarcode)).size).toBe(5);
  });

  it('시퀀스 개수가 장수와 다르면 던진다 — 모자라거나 남은 채 발행하면 안 된다', () => {
    expect(() => planReelBarcodes({ ...base, reelQty: 3, unitQty: 100 }, [1, 2]))
      .toThrow(/시퀀스 개수/);
    expect(() => planReelBarcodes({ ...base, divideQty: [10, 20] }, [1, 2, 3]))
      .toThrow(/시퀀스 개수/);
  });

  it('발행 불가한 입력은 던진다 (조용히 0장을 만들지 않는다)', () => {
    expect(() => planReelBarcodes({ ...base, reelQty: 3 }, [1, 2, 3]))
      .toThrow(/단위수량/);
  });

  it('수량 합이 계획과 일치한다', () => {
    const input = { ...base, divideQty: [123, 456, 21] };
    const plans = planReelBarcodes(input, [1, 2, 3]);
    expect(plans.reduce((s, p) => s + p.scanQty, 0)).toBe(totalReelQty(input));
    expect(plans.reduce((s, p) => s + p.scanQty, 0)).toBe(600);
  });
});
