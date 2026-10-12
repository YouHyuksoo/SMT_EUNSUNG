import { computeShiftActual, DAY_TIME_DIVISIONS, NIGHT_TIME_DIVISIONS, sqlInList } from './smd-shift-actual';

describe('computeShiftActual', () => {
  it('수기가 없으면 자동 실적으로 잔량을 계산한다', () => {
    expect(
      computeShiftActual({
        planQty: 27488,
        dayAutoQty: 11464,
        nightAutoQty: 10096,
        dayManualQty: null,
        nightManualQty: null,
      }),
    ).toEqual({
      dayActualQty: 11464,
      nightActualQty: 10096,
      dayRemainQty: 16024,
      nightRemainQty: 5928,
    });
  });

  it('근무조별로 수기가 있으면 수기를 쓴다 (0 도 수기 값이다)', () => {
    expect(
      computeShiftActual({
        planQty: 1000,
        dayAutoQty: 84,
        nightAutoQty: 920,
        dayManualQty: 0,
        nightManualQty: null,
      }),
    ).toEqual({ dayActualQty: 0, nightActualQty: 920, dayRemainQty: 1000, nightRemainQty: 80 });
  });

  it('초과 생산이면 잔량을 음수로 둔다', () => {
    const r = computeShiftActual({
      planQty: 1152,
      dayAutoQty: 1184,
      nightAutoQty: 0,
      dayManualQty: null,
      nightManualQty: null,
    });
    expect(r.dayRemainQty).toBe(-32);
    expect(r.nightRemainQty).toBe(-32);
  });

  it('Oracle NUMBER 가 문자열로 와도 숫자로 계산한다', () => {
    expect(
      computeShiftActual({
        planQty: '2000',
        dayAutoQty: '347',
        nightAutoQty: null,
        dayManualQty: null,
        nightManualQty: '10',
      }),
    ).toEqual({ dayActualQty: 347, nightActualQty: 10, dayRemainQty: 1653, nightRemainQty: 1643 });
  });
});

describe('시간구분', () => {
  it('주간 A~E, 야간 F~J 이고 겹치지 않는다', () => {
    expect(sqlInList(DAY_TIME_DIVISIONS)).toBe("'A', 'B', 'C', 'D', 'E'");
    expect(sqlInList(NIGHT_TIME_DIVISIONS)).toBe("'F', 'G', 'H', 'I', 'J'");
  });
});
