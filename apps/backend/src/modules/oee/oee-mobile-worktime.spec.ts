import { resolveOeeMobileWorkContext, WorktimeRangeRow } from './oee-mobile-worktime';

const rows: WorktimeRangeRow[] = [
  { workType: 'A', startTime: '083000', endTime: '103000', attribute01: null, attribute02: null },
  { workType: 'B', startTime: '103000', endTime: '123000', attribute01: null, attribute02: null },
  { workType: 'C', startTime: '123000', endTime: '143000', attribute01: null, attribute02: null },
  { workType: 'D', startTime: '143000', endTime: '163000', attribute01: null, attribute02: null },
  { workType: 'E', startTime: '163000', endTime: '203000', attribute01: null, attribute02: null },
  { workType: 'F', startTime: '203000', endTime: '223000', attribute01: null, attribute02: null },
  { workType: 'G', startTime: '223000', endTime: '003000', attribute01: '0', attribute02: '1' },
  { workType: 'H', startTime: '003000', endTime: '023000', attribute01: '1', attribute02: '1' },
  { workType: 'I', startTime: '023000', endTime: '063000', attribute01: '1', attribute02: '1' },
  { workType: 'J', startTime: '063000', endTime: '083000', attribute01: '1', attribute02: '1' },
];

describe('resolveOeeMobileWorkContext', () => {
  it.each([
    ['2026-08-07T08:29:59+09:00', '2026-08-06', 'NIGHT'],
    ['2026-08-07T08:30:00+09:00', '2026-08-07', 'DAY'],
    ['2026-08-07T16:30:00+09:00', '2026-08-07', 'DAY'],
    ['2026-08-07T20:29:59+09:00', '2026-08-07', 'DAY'],
    ['2026-08-07T20:30:00+09:00', '2026-08-07', 'NIGHT'],
    ['2026-08-07T22:30:00+09:00', '2026-08-07', 'NIGHT'],
    ['2026-08-08T00:30:00+09:00', '2026-08-07', 'NIGHT'],
    ['2026-08-08T08:29:59+09:00', '2026-08-07', 'NIGHT'],
  ])('resolves %s as workDate=%s segment=%s', (iso, workDate, workSegment) => {
    expect(resolveOeeMobileWorkContext(new Date(iso), rows)).toEqual({ workDate, workSegment });
  });

  it('uses Asia/Seoul regardless of the host timezone', () => {
    const previousTimezone = process.env.TZ;
    process.env.TZ = 'UTC';

    try {
      expect(
        resolveOeeMobileWorkContext(new Date('2026-08-07T08:30:00+09:00'), rows),
      ).toEqual({ workDate: '2026-08-07', workSegment: 'DAY' });
    } finally {
      if (previousTimezone === undefined) delete process.env.TZ;
      else process.env.TZ = previousTimezone;
    }
  });

  it('rejects invalid times, offsets, and unmatched times explicitly', () => {
    expect(() =>
      resolveOeeMobileWorkContext(new Date('2026-08-07T08:30:00+09:00'), [
        { ...rows[0], startTime: 'not-a-time' },
      ]),
    ).toThrow(/START_TIME/);

    expect(() =>
      resolveOeeMobileWorkContext(new Date('2026-08-07T08:30:00+09:00'), [
        { ...rows[0], attribute01: 'not-a-number' },
      ]),
    ).toThrow(/ATTRIBUTE01/);

    expect(() =>
      resolveOeeMobileWorkContext(new Date('2026-08-07T08:30:00+09:00'), [
        { workType: 'A', startTime: '090000', endTime: '100000', attribute01: null, attribute02: null },
      ]),
    ).toThrow(/일치하는 업무구간/);

    expect(() =>
      resolveOeeMobileWorkContext(new Date('2026-08-07T08:30:00+09:00'), [
        { ...rows[0], workType: 'K' },
      ]),
    ).toThrow(/WORK_TYPE/);
  });
});
