import { wipCloseAggregateSql, wipCloseLine } from './wip-close.service';

const info = { itemName: null, itemSpec: null, itemUom: null, lineType: 'A' };

describe('wipCloseLine', () => {
  it('첫 마감 기초는 0 이다 — 입고가 소비보다 많으면 남은 만큼이 기말이다', () => {
    const l = wipCloseLine({ itemCode: 'A', receiptQty: 200, issueQty: 50, adjustQty: 0 }, false, 2, info);
    expect(l.openingQty).toBe(0);
    expect(l.endingQty).toBe(150);
    expect(l.endingAmt).toBe(300);
  });

  it('첫 마감에서 소비가 입고보다 많으면 모자란 만큼을 기초로 두어 기말이 0 이 된다', () => {
    const l = wipCloseLine({ itemCode: 'A', receiptQty: 200, issueQty: 500, adjustQty: 0 }, false, 2, info);
    expect(l.openingQty).toBe(300);
    expect(l.openingAmt).toBe(600);
    expect(l.endingQty).toBe(0);
  });

  it('이후 마감은 직전 달 기말을 기초로 쓰고 기초 금액도 그대로 잇는다', () => {
    const l = wipCloseLine(
      { itemCode: 'A', prevQty: 500, prevAmt: 1500, receiptQty: 100, issueQty: 40, adjustQty: 10 },
      true, 3, info,
    );
    expect(l.openingQty).toBe(500);
    expect(l.openingAmt).toBe(1500);
    expect(l.endingQty).toBe(560);
    expect(l.issueAmt).toBe(120);
    expect(l.adjustAmt).toBe(30);
  });

  it('단가가 없으면 금액은 0 이다', () => {
    const l = wipCloseLine({ itemCode: 'A', prevQty: 5, receiptQty: 0, issueQty: 0, adjustQty: 0 }, true, 0, info);
    expect(l.endingAmt).toBe(0);
  });

  it('직전 마감을 읽는 집계는 previousClose 일 때만 마감 표를 읽는다', () => {
    expect(wipCloseAggregateSql(false)).not.toContain(':prevYyyymm');
    expect(wipCloseAggregateSql(true)).toContain(':prevYyyymm');
  });
});
