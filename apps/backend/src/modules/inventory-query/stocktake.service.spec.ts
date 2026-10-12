import { isStocktakeMonthAllowed } from './stocktake.service';

describe('isStocktakeMonthAllowed', () => {
  const today = new Date(2026, 0, 15); // 2026-01-15

  it('이번 달과 지난달(해를 넘어도)만 받는다', () => {
    expect(isStocktakeMonthAllowed('202601', today)).toBe(true);
    expect(isStocktakeMonthAllowed('202512', today)).toBe(true);
    expect(isStocktakeMonthAllowed('202511', today)).toBe(false);
    expect(isStocktakeMonthAllowed('202602', today)).toBe(false);
    expect(isStocktakeMonthAllowed('202613', today)).toBe(false);
  });
});
