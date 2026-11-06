import { BadRequestException } from '@nestjs/common';
import {
  findDbNow,
  findOeeWorkContext,
  mapSourceWorkType,
  OEE_WORK_CONTEXT_SQL,
  worktimeRangeType,
} from './oee-mobile-worktime';

describe('OEE 업무일·근무구간 (DB 기준)', () => {
  const query = jest.fn();
  const dataSource = { query };

  beforeEach(() => query.mockReset());

  it('지금 시각·업무일은 DB 의 SYSDATE 와 F_GET_WORK_ACTUAL_DATE 로 구한다', () => {
    expect(OEE_WORK_CONTEXT_SQL).toContain('SYSDATE');
    expect(OEE_WORK_CONTEXT_SQL).toContain("F_GET_WORK_ACTUAL_DATE(SYSDATE, 'A')");
    expect(OEE_WORK_CONTEXT_SQL).toContain('FROM ICOM_WORKTIME_RANGES');
  });

  it('공정별 구간 종류 — SMT 는 SMTWORKTIME, 나머지는 WORKTIME', async () => {
    expect(worktimeRangeType('SMT')).toBe('SMTWORKTIME');
    expect(worktimeRangeType('ASSY')).toBe('WORKTIME');
  });

  it.each([
    ['A', 'DAY'], ['C', 'DAY'], ['E', 'DAY'],
    ['F', 'NIGHT'], ['H', 'NIGHT'], ['J', 'NIGHT'],
  ])('근무구간 %s → %s', (workType, segment) => {
    expect(mapSourceWorkType(workType)).toBe(segment);
  });

  it('DB 가 고른 한 구간으로 업무일·근무구간·지금·업무일 시작을 돌려준다', async () => {
    const now = new Date('2026-08-08T00:30:00+09:00');
    query.mockResolvedValue([{
      workDate: '2026-08-07',
      workDay: new Date('2026-08-07T00:00:00+09:00'),
      workType: 'H',
      now,
      workStart: new Date('2026-08-07T08:30:00+09:00'),
    }]);

    await expect(findOeeWorkContext(dataSource, 'SMT', 7)).resolves.toEqual({
      workDate: '2026-08-07',
      workDay: new Date('2026-08-07T00:00:00+09:00'),
      workSegment: 'NIGHT',
      now,
      workStart: new Date('2026-08-07T08:30:00+09:00'),
    });
    expect(query).toHaveBeenCalledWith(OEE_WORK_CONTEXT_SQL, { rangeType: 'SMTWORKTIME', organizationId: 7 });
  });

  it('맞는 구간이 없거나 겹치면 막는다', async () => {
    query.mockResolvedValueOnce([]);
    await expect(findOeeWorkContext(dataSource, 'SMT', 7)).rejects.toThrow(/업무시간 구간이 없습니다/);

    const row = { workDate: '2026-08-07', workDay: new Date(), now: new Date(), workStart: new Date() };
    query.mockResolvedValueOnce([{ ...row, workType: 'A' }, { ...row, workType: 'B' }]);
    await expect(findOeeWorkContext(dataSource, 'SMT', 7)).rejects.toThrow(/겹치는 업무구간이 있습니다: A,B/);

    query.mockResolvedValueOnce([{ ...row, workType: 'A', workStart: null }]);
    await expect(findOeeWorkContext(dataSource, 'SMT', 7)).rejects.toBeInstanceOf(BadRequestException);
  });

  it('findDbNow 는 DB SYSDATE 를 돌려준다', async () => {
    const now = new Date('2026-10-13T02:14:44+09:00');
    query.mockResolvedValue([{ now }]);
    await expect(findDbNow(dataSource)).resolves.toEqual(now);
    expect(query.mock.calls[0][0]).toContain('SYSDATE');
  });
});
