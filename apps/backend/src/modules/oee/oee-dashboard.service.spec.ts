import { DataSource } from 'typeorm';
import { OeeDashboardService } from './oee-dashboard.service';

describe('OeeDashboardService drilldown', () => {
  afterEach(() => jest.useRealTimers());

  it('uses the 08:30 business-date boundary for the default date', async () => {
    jest.useFakeTimers().setSystemTime(new Date('2026-08-13T08:29:59+09:00'));
    const query = jest.fn().mockResolvedValue([]);
    const service = new OeeDashboardService({ query } as unknown as DataSource);

    await service.drilldown('SMT');

    expect(query.mock.calls[0][1]).toEqual(['2026-08-12', 'SMT']);
  });

  it('returns the source operands required to verify each OEE calculation', async () => {
    const query = jest.fn().mockResolvedValue([]);
    const service = new OeeDashboardService({ query } as unknown as DataSource);

    await service.drilldown('SMT', '2999-01-01');

    const sql = query.mock.calls[0][0] as string;
    for (const column of [
      'l.LINE_CODE AS RESOURCE_CODE',
      'r.RESOURCE_TYPE',
      'l.LINE_NAME AS RESOURCE_NAME',
      'v.SHIFT',
      'v.NET_LOAD_MIN',
      'v.RUN_MIN',
      'v.DOWNTIME_MIN',
      'v.IDEAL_CT',
      'v.PLAN_QTY',
      'v.OUTPUT_QTY',
      'v.GOOD_QTY',
      'v.TOTAL_QTY',
    ]) {
      expect(sql).toContain(column);
    }
  });

  it('uses mobile downtime events for the loss Pareto', async () => {
    const query = jest.fn().mockResolvedValue([]);
    const service = new OeeDashboardService({ query } as unknown as DataSource);

    await service.lossPareto('2026-08-08');

    const sql = query.mock.calls[0][0] as string;
    expect(sql).toContain('OEE_DOWNTIME_EVENT');
    expect(sql).not.toContain('OEE_OPERATION_LOG');
    expect(sql).toContain('START_TIME');
    expect(sql).toContain('END_TIME');
  });
});
