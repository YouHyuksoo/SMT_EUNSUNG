import { closeMonth, type CloseInput } from './inventory-close.calc';

const input = (p: Partial<CloseInput>): CloseInput => ({
  openingQty: 0, openingAmt: 0, openingPrice: 0, receiptQty: 0, receiptAmt: 0,
  massQty: 0, badQty: 0, freeQty: 0, saleQty: 0, extraQty: 0, ...p,
});

describe('closeMonth (월총평균법)', () => {
  it('월평균단가 = (기초금액 + 입고금액) ÷ (기초수량 + 입고수량)', () => {
    // 기초 100개 @10 = 1,000 / 입고 300개 3,600 (@12) → 평균 (1000+3600)/400 = 11.5
    const r = closeMonth(input({ openingQty: 100, openingAmt: 1000, openingPrice: 10,
      receiptQty: 300, receiptAmt: 3600, massQty: 250 }));
    expect(r.avgPrice).toBe(11.5);
    expect(r.issueQty).toBe(250);
    expect(r.issueAmt).toBe(2875);
    expect(r.endingQty).toBe(150);
    expect(r.endingAmt).toBe(1725); // 1000 + 3600 - 2875
  });

  it('기말금액은 기초+입고-출고로 끝자리를 흡수한다', () => {
    // 3개 1,000원 → 평균 333.3333, 1개 출고 333 → 기말 667 (2 × 333.3333 = 666.67 이 아니라)
    const r = closeMonth(input({ receiptQty: 3, receiptAmt: 1000, massQty: 1 }));
    expect(r.avgPrice).toBe(333.3333);
    expect(r.issueAmt).toBe(333);
    expect(r.endingAmt).toBe(667);
  });

  it('다 나가면 기말금액 0, 남은 끝자리는 출고가 가져간다', () => {
    const r = closeMonth(input({ receiptQty: 3, receiptAmt: 1000, massQty: 3 }));
    expect(r.endingQty).toBe(0);
    expect(r.endingAmt).toBe(0);
    expect(r.issueAmt).toBe(1000);
    expect(r.massAmt).toBe(1000);
  });

  it('입고·기초가 없으면 기초단가로 출고를 평가한다', () => {
    const r = closeMonth(input({ openingPrice: 7, massQty: -2 })); // 출고반품만
    expect(r.avgPrice).toBe(7);
    expect(r.issueAmt).toBe(-14);
    expect(r.endingQty).toBe(2);
    expect(r.endingAmt).toBe(14);
  });

  it('출고 계정별 금액 합은 총 출고금액과 같다', () => {
    const r = closeMonth(input({ receiptQty: 7, receiptAmt: 1000, massQty: 3, badQty: 2, extraQty: 1 }));
    expect(r.massAmt + r.badAmt + r.freeAmt + r.saleAmt + r.extraAmt).toBe(r.issueAmt);
  });

  it('무상(0원) 자재는 수량만 마감된다', () => {
    const r = closeMonth(input({ openingQty: 50, receiptQty: 100, massQty: 120 }));
    expect([r.avgPrice, r.issueAmt, r.endingQty, r.endingAmt]).toEqual([0, 0, 30, 0]);
  });
});
