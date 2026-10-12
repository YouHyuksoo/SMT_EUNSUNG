import { describe, expect, it } from 'vitest';
import {
  buildMagazineLabelNo,
  checkMagazinePrint,
  checkMagazineSplit,
  MAGAZINE_LABEL_TYPE,
  planMagazineLabels,
  planMagazineSplit,
} from './magazine-label';

describe('buildMagazineLabelNo', () => {
  it('실측 라벨번호 형태와 같아야 한다 (라인2 + 날짜3 + 순번4 = 9자)', () => {
    expect(buildMagazineLabelNo('10', '69S', 6199)).toBe('1069S6199');
    expect(buildMagazineLabelNo('11', '69S', 6205)).toBe('1169S6205');
  });

  it('순번은 4자리로 0 을 채운다', () => {
    expect(buildMagazineLabelNo('01', '69S', 7)).toBe('0169S0007');
  });

  it('순번이 4자리를 넘으면 자르지 않는다 (번호가 바뀌면 안 된다)', () => {
    expect(buildMagazineLabelNo('12', '69S', 12345)).toBe('1269S12345');
  });
});

describe('checkMagazinePrint', () => {
  const base = {
    planQty: 1000,
    magazineQty: 0,
    okQty: 400,
    packingPcsQty: 400,
    printQty: 1,
  };

  it('정상 입력은 통과한다', () => {
    expect(checkMagazinePrint(base).ok).toBe(true);
  });

  it('이미 발행한 수량 + 이번 수량이 지시수량을 넘으면 거절한다', () => {
    const verdict = checkMagazinePrint({ ...base, magazineQty: 800, okQty: 400 });
    expect(verdict.ok).toBe(false);
    expect(verdict.reason).toContain('지시수량');
  });

  it('딱 맞아떨어지는 것은 통과한다', () => {
    expect(checkMagazinePrint({ ...base, magazineQty: 600, okQty: 400 }).ok).toBe(true);
  });

  it('불량·포함수량도 지시수량 비교에 들어간다', () => {
    const verdict = checkMagazinePrint({
      ...base, magazineQty: 500, okQty: 400, ngQty: 50, okIncludeQty: 100,
    });
    expect(verdict.ok).toBe(false);
  });

  it('장입수량이 0 이면 거절한다 (PB 는 여기서 라벨을 끝없이 찍었다)', () => {
    const verdict = checkMagazinePrint({ ...base, packingPcsQty: 0 });
    expect(verdict.ok).toBe(false);
    expect(verdict.reason).toContain('장입수량');
  });

  it('발행 장수가 0 이면 거절한다', () => {
    expect(checkMagazinePrint({ ...base, printQty: 0 }).ok).toBe(false);
  });

  it('발행할 수량이 아예 없으면 거절한다', () => {
    expect(checkMagazinePrint({ ...base, okQty: 0, ngQty: 0 }).ok).toBe(false);
  });

  it('정상 수량이 음수면 거절한다', () => {
    expect(checkMagazinePrint({ ...base, okQty: -1 }).ok).toBe(false);
  });
});

describe('planMagazineLabels', () => {
  it('장입수량 단위로 떼어 간다', () => {
    expect(planMagazineLabels({
      planQty: 2000, magazineQty: 0, okQty: 1200, packingPcsQty: 400, printQty: 3,
    })).toEqual([400, 400, 400]);
  });

  it('마지막 상자는 남은 만큼만 담는다', () => {
    expect(planMagazineLabels({
      planQty: 2000, magazineQty: 0, okQty: 1000, packingPcsQty: 400, printQty: 3,
    })).toEqual([400, 400, 200]);
  });

  it('요청한 장수보다 수량이 적으면 수량이 먼저 끝난다', () => {
    expect(planMagazineLabels({
      planQty: 2000, magazineQty: 0, okQty: 500, packingPcsQty: 400, printQty: 5,
    })).toEqual([400, 100]);
  });

  it('요청 장수가 적으면 남은 수량이 있어도 거기서 멈춘다', () => {
    expect(planMagazineLabels({
      planQty: 2000, magazineQty: 0, okQty: 1200, packingPcsQty: 400, printQty: 2,
    })).toEqual([400, 400]);
  });

  it('라벨 수량의 합은 절대 정상수량을 넘지 않는다', () => {
    for (const printQty of [1, 2, 3, 5, 10]) {
      const labels = planMagazineLabels({
        planQty: 5000, magazineQty: 0, okQty: 970, packingPcsQty: 400, printQty,
      });
      expect(labels.reduce((s, q) => s + q, 0)).toBeLessThanOrEqual(970);
      expect(labels.every((q) => q > 0)).toBe(true);
    }
  });

  it('거절되는 입력은 빈 계획을 낸다 (장입수량 0 무한루프 방지)', () => {
    expect(planMagazineLabels({
      planQty: 1000, magazineQty: 0, okQty: 400, packingPcsQty: 0, printQty: 1,
    })).toEqual([]);
  });
});

describe('checkMagazineSplit', () => {
  it('원본보다 많이 나누면 거절한다', () => {
    const verdict = checkMagazineSplit({ lotQty: 400, divideQty: 300, ngQty: 200 });
    expect(verdict.ok).toBe(false);
    expect(verdict.reason).toContain('원본 수량');
  });

  it('딱 맞게 나누는 것은 통과한다', () => {
    expect(checkMagazineSplit({ lotQty: 400, divideQty: 300, ngQty: 100 }).ok).toBe(true);
  });

  it('나눌 수량이 없으면 거절한다', () => {
    expect(checkMagazineSplit({ lotQty: 400, divideQty: 0 }).ok).toBe(false);
  });

  it('음수는 거절한다', () => {
    expect(checkMagazineSplit({ lotQty: 400, divideQty: -10, ngQty: 50 }).ok).toBe(false);
  });
});

describe('planMagazineSplit', () => {
  it('잔량 → 분할 → 불량 → 폐기 순으로 조각을 만든다 (PB 순서)', () => {
    const plan = planMagazineSplit({
      lotQty: 400, divideQty: 100, ngQty: 50, destroyQty: 20,
    });
    expect(plan.pieces).toEqual([
      { labelType: MAGAZINE_LABEL_TYPE.normal, qty: 230 },
      { labelType: MAGAZINE_LABEL_TYPE.normal, qty: 100 },
      { labelType: MAGAZINE_LABEL_TYPE.bad, qty: 50 },
      { labelType: MAGAZINE_LABEL_TYPE.destroy, qty: 20 },
    ]);
  });

  it('잔량이 0 이면 잔량 조각을 만들지 않는다', () => {
    const plan = planMagazineSplit({ lotQty: 400, divideQty: 400 });
    expect(plan.pieces).toEqual([
      { labelType: MAGAZINE_LABEL_TYPE.normal, qty: 400 },
    ]);
  });

  it('조각 수량의 합은 언제나 원본 수량과 같다 (수량이 늘지도 줄지도 않는다)', () => {
    const cases = [
      { lotQty: 400, divideQty: 100 },
      { lotQty: 400, divideQty: 100, ngQty: 50 },
      { lotQty: 400, divideQty: 399, destroyQty: 1 },
      { lotQty: 1, divideQty: 1 },
      { lotQty: 1000, divideQty: 300, ngQty: 200, destroyQty: 500 },
    ];
    for (const input of cases) {
      expect(planMagazineSplit(input).totalQty).toBe(input.lotQty);
    }
  });
});
