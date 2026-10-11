import { getClosePeriod, isStocktakePeriodAllowed, periodBoundsSql, periodEnded, shiftMonth, firstCloseGate } from './close-period';
import { generateYearPeriods } from './close-date.service';

const fakeDb = (rows: Record<string, unknown>[][]) => {
  const queue = [...rows];
  return { query: async () => queue.shift() ?? [] };
};

describe('getClosePeriod', () => {
  it('등록된 기간이 있으면 그 시작일~종료일을 쓰고 종료일 다음 날 0시까지 센다', async () => {
    const p = await getClosePeriod(fakeDb([[{ s: '2026-09-26', e: '2026-10-25', x: '2026-10-26' }]]), '202610', 1);
    expect(p).toEqual({ yyyymm: '202610', start: '2026-09-26', end: '2026-10-25', endExclusive: '2026-10-26', registered: true });
  });

  it('등록이 없으면 달력 월이다', async () => {
    const p = await getClosePeriod(fakeDb([[]]), '202602', 1);
    expect(p).toEqual({ yyyymm: '202602', start: '2026-02-01', end: '2026-02-28', endExclusive: '2026-03-01', registered: false });
  });
});

describe('periodEnded', () => {
  const p = { yyyymm: '202610', start: '2026-09-26', end: '2026-10-25', endExclusive: '2026-10-26', registered: true };
  it('종료일 당일에는 아직 안 끝났고 다음 날 0시(한국 시간)부터 끝난 것이다', () => {
    expect(periodEnded(p, new Date('2026-10-25T23:59:59+09:00'))).toBe(false);
    expect(periodEnded(p, new Date('2026-10-26T00:00:00+09:00'))).toBe(true);
  });
});

describe('generateYearPeriods', () => {
  it('시작일 1 이면 달력 월이다 (윤년 2월 포함)', () => {
    const y = generateYearPeriods(2028, 1);
    expect(y[0]).toEqual({ yyyymm: '202801', startDate: '2028-01-01', endDate: '2028-01-31' });
    expect(y[1].endDate).toBe('2028-02-29');
    expect(y[11].endDate).toBe('2028-12-31');
  });

  it('시작일 26 이면 전달 26일 ~ 이번 달 25일이고 1월은 전년 12월에서 시작한다', () => {
    const y = generateYearPeriods(2026, 26);
    expect(y[0]).toEqual({ yyyymm: '202601', startDate: '2025-12-26', endDate: '2026-01-25' });
    expect(y[9]).toEqual({ yyyymm: '202610', startDate: '2026-09-26', endDate: '2026-10-25' });
  });

  it('12개월이 빈틈 없이 이어진다', () => {
    for (const day of [1, 11, 26]) {
      const y = generateYearPeriods(2026, day);
      for (let i = 1; i < 12; i += 1) {
        const prevEnd = new Date(`${y[i - 1].endDate}T00:00:00Z`);
        prevEnd.setUTCDate(prevEnd.getUTCDate() + 1);
        expect(prevEnd.toISOString().slice(0, 10)).toBe(y[i].startDate);
      }
    }
  });
});

describe('isStocktakePeriodAllowed', () => {
  const calendar = () => false;
  it('오늘이 속한 기간과 직전 기간만 허용한다', async () => {
    const db = () => fakeDb([[{ ym: '202611' }]]);
    expect(await isStocktakePeriodAllowed(db(), '202611', 1, calendar)).toBe(true);
    expect(await isStocktakePeriodAllowed(db(), '202610', 1, calendar)).toBe(true);
    expect(await isStocktakePeriodAllowed(db(), '202609', 1, calendar)).toBe(false);
  });

  it('오늘이 등록된 기간에 없으면 달력 기준으로 본다', async () => {
    expect(await isStocktakePeriodAllowed(fakeDb([[{ ym: null }]]), '202610', 1, () => true)).toBe(true);
  });
});

describe('보조', () => {
  it('shiftMonth 는 해를 넘긴다', () => {
    expect(shiftMonth('202601', -1)).toBe('202512');
    expect(shiftMonth('202512', 1)).toBe('202601');
  });
  it('기간 조건 SQL 은 종료일 다음 날 앞까지다', () => {
    expect(periodBoundsSql('s.ISSUE_DATE', ':yyyymm', ':organizationId')).toContain('TRUNC(F_GET_INVENTORY_CLOSE_DATE(:yyyymm, \'END\'');
  });
});

describe('firstCloseGate', () => {
  it('시작월이 없으면 막는다', () => {
    expect(firstCloseGate('202611', null, null).reason).toMatch(/시작월을 먼저/);
  });
  it('시작월 전 달은 마감하지 않는다', () => {
    expect(firstCloseGate('202610', '202611', null)).toEqual(expect.objectContaining({ first: false, reason: expect.stringMatching(/202611 부터/) }));
  });
  it('마감한 달이 없으면 시작월만 첫 마감이다', () => {
    expect(firstCloseGate('202611', '202611', null)).toEqual({ first: true, reason: null });
    expect(firstCloseGate('202612', '202611', null).reason).toMatch(/202611 을 먼저/);
  });
  it('이미 마감한 달이 있으면 보통의 마감으로 넘긴다', () => {
    expect(firstCloseGate('202612', '202611', '202611')).toEqual({ first: false, reason: null });
  });
});
