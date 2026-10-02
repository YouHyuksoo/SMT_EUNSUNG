/**
 * @file src/modules/inventory-query/inventory-close.calc.ts
 * @description 271 자재재고마감 — 월총평균법 계산 (순수 함수)
 *
 * 초보자 가이드:
 * 1. 한 줄 = 품목·거래유형·창고의 한 달. SQL 이 기초·입고·출고 수량과 입고금액을 모아 주면
 *    여기서 단가와 금액을 정한다.
 * 2. 월평균단가 = (기초금액 + 입고금액) ÷ (기초수량 + 입고수량).
 *    분모가 0 이하(기초·입고가 없거나 반품이 더 많음)면 기초단가를 그대로 쓴다.
 * 3. 출고금액 = 출고수량 × 월평균단가 (원 단위 반올림). 출고 계정별(양산·불량·무상·유상·기타·조정)
 *    금액도 같은 단가로 나누고, 반올림 끝자리는 총 출고금액에 맞춘다.
 * 4. 기말금액 = 기초금액 + 입고금액 − 출고금액 (끝자리 차이는 기말이 흡수한다).
 *    기말수량이 0 이면 기말금액도 0 이어야 하므로 남는 금액은 출고금액에 붙인다.
 */

export interface CloseInput {
  openingQty: number;
  openingAmt: number;
  openingPrice: number;
  receiptQty: number;
  receiptAmt: number;
  /** 출고 계정별 수량 */
  massQty: number;
  badQty: number;
  freeQty: number;
  saleQty: number;
  extraQty: number;
  /** 재고조정 (실사 차이). 모자람 +, 남음 − */
  adjustQty: number;
}

export interface CloseResult {
  avgPrice: number;
  issueQty: number;
  issueAmt: number;
  massAmt: number;
  badAmt: number;
  freeAmt: number;
  saleAmt: number;
  extraAmt: number;
  adjustAmt: number;
  endingQty: number;
  endingAmt: number;
}

/** Oracle ROUND 와 같은 반올림 (0.5 는 0 에서 먼 쪽) */
export const roundHalfUp = (value: number, digits = 0): number => {
  const f = 10 ** digits;
  return (Math.sign(value) * Math.round(Math.abs(value) * f + 1e-9)) / f;
};

/** 수량 합에 쌓이는 부동소수 잔차를 지운다 (수량은 소수 6자리면 충분하다) */
const qty6 = (value: number) => roundHalfUp(value, 6);

export function closeMonth(input: CloseInput): CloseResult {
  const baseQty = qty6(input.openingQty + input.receiptQty);
  const baseAmt = input.openingAmt + input.receiptAmt;
  const avgPrice = baseQty > 0 ? roundHalfUp(baseAmt / baseQty, 4) : roundHalfUp(input.openingPrice, 4);

  const issueQty = qty6(input.massQty + input.badQty + input.freeQty + input.saleQty + input.extraQty + input.adjustQty);
  const endingQty = qty6(input.openingQty + input.receiptQty - issueQty);

  let issueAmt = roundHalfUp(issueQty * avgPrice);
  let endingAmt = roundHalfUp(baseAmt - issueAmt);
  if (endingQty === 0) {
    // 다 나갔으면 남은 금액도 0 — 단가 반올림으로 남은 끝자리는 출고가 가져간다.
    issueAmt = roundHalfUp(baseAmt);
    endingAmt = 0;
  }

  // 계정별 금액: 같은 단가로 나누고 끝자리 차이는 가장 큰 계정(보통 양산)에 맞춘다.
  const parts = {
    massAmt: roundHalfUp(input.massQty * avgPrice),
    badAmt: roundHalfUp(input.badQty * avgPrice),
    freeAmt: roundHalfUp(input.freeQty * avgPrice),
    saleAmt: roundHalfUp(input.saleQty * avgPrice),
    extraAmt: roundHalfUp(input.extraQty * avgPrice),
    adjustAmt: roundHalfUp(input.adjustQty * avgPrice),
  };
  const sum = parts.massAmt + parts.badAmt + parts.freeAmt + parts.saleAmt + parts.extraAmt + parts.adjustAmt;
  const diff = roundHalfUp(issueAmt - sum);
  if (diff !== 0) {
    const qtys: [keyof typeof parts, number][] = [
      ['massAmt', input.massQty], ['badAmt', input.badQty], ['freeAmt', input.freeQty],
      ['saleAmt', input.saleQty], ['extraAmt', input.extraQty], ['adjustAmt', input.adjustQty],
    ];
    const largest = qtys.reduce((a, b) => (Math.abs(b[1]) > Math.abs(a[1]) ? b : a))[0];
    parts[largest] = roundHalfUp(parts[largest] + diff);
  }

  return { avgPrice, issueQty, issueAmt, ...parts, endingQty, endingAmt };
}
