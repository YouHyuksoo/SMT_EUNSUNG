import { netOrderLines, roundHalfUp, type NettingLine } from './order-plan.netting';

const line = (p: Partial<NettingLine>): NettingLine => ({
  itemCode: 'M1', lineType: 'F', qty: 0, minQty: 0, packQty: 0, badRate: 0, countUnit: true, ...p,
});
const on = { applyInventory: true, applyOrderRule: true };

describe('netOrderLines (478 재고 차감·발주속성)', () => {
  it('재고를 앞 납기 줄부터 떼어 준다', () => {
    const r = netOrderLines(
      [line({ qty: 70 }), line({ qty: 50 }), line({ qty: 40 })],
      new Map([['M1|F', 100]]),
      on,
    );
    expect(r.map((x) => [x.applied, x.purchaseQty])).toEqual([[70, 0], [30, 20], [0, 40]]);
  });

  it('품목·거래유형이 다르면 재고를 나눠 쓰지 않는다', () => {
    const r = netOrderLines(
      [line({ qty: 10, lineType: 'Y' }), line({ qty: 10, itemCode: 'M2' })],
      new Map([['M1|F', 100]]),
      on,
    );
    expect(r.map((x) => x.purchaseQty)).toEqual([10, 10]);
  });

  it('포장단위로 올리고, 남은 만큼은 뒤 줄이 덜 발주한다 (재고 행이 없어도)', () => {
    const r = netOrderLines(
      [line({ qty: 120, packQty: 100 }), line({ qty: 50, packQty: 100 })],
      new Map(),
      on,
    );
    // 120 → 200 (80 남음), 다음 50 은 남은 80 에서 받아 0
    expect(r.map((x) => [x.applied, x.roundUpQty, x.purchaseQty])).toEqual([[0, 80, 200], [50, 0, 0]]);
  });

  it('포장단위 이하는 포장단위, 최소주문량 미만은 최소주문량', () => {
    const r = netOrderLines(
      [line({ qty: 30, packQty: 100 }), line({ itemCode: 'M2', qty: 30, minQty: 50 })],
      new Map(),
      on,
    );
    expect(r.map((x) => x.purchaseQty)).toEqual([100, 50]);
  });

  it('불량율은 개수 단위면 정수, 아니면 소수 4자리로 더한다', () => {
    const r = netOrderLines(
      [line({ qty: 101, badRate: 1.5 }), line({ itemCode: 'M2', qty: 101, badRate: 1.5, countUnit: false })],
      new Map(),
      on,
    );
    expect(r.map((x) => x.purchaseQty)).toEqual([103, 102.515]);
  });

  it('소요량이 0 이하면 발주하지 않는다', () => {
    const r = netOrderLines([line({ qty: -5 })], new Map([['M1|F', 10]]), on);
    expect(r[0]).toEqual({ applied: 0, badQty: 0, roundUpQty: 0, purchaseQty: 0 });
  });

  it('재고 가지를 다 끄면 소요량이 그대로 발주량 (발주속성도 안 탄다)', () => {
    const r = netOrderLines([line({ qty: 30, packQty: 100 })], new Map([['M1|F', 10]]),
      { applyInventory: false, applyOrderRule: true });
    expect(r[0].purchaseQty).toBe(30);
  });

  it('발주속성을 끄면 재고만 뺀다', () => {
    const r = netOrderLines([line({ qty: 130, packQty: 100 })], new Map([['M1|F', 10]]),
      { applyInventory: true, applyOrderRule: false });
    expect(r[0].purchaseQty).toBe(120);
  });

  it('roundHalfUp 은 Oracle ROUND 와 같다', () => {
    expect(roundHalfUp(2.5, 0)).toBe(3);
    expect(roundHalfUp(-2.5, 0)).toBe(-3);
    expect(roundHalfUp(1.00005, 4)).toBe(1.0001);
  });
});
