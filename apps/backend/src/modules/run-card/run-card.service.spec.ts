import { RunCardService } from './run-card.service';

describe('RunCardService production-result contract', () => {
  it('counts run-card results from IP_PRODUCT_SENSOR_ACTUAL', async () => {
    const query = jest.fn().mockResolvedValue([]);
    const service = new RunCardService({ manager: { query } } as never);

    await service.list({ fromDate: '2026-08-26', toDate: '2026-09-25' });

    const sql = String(query.mock.calls[0][0]);
    expect(sql).toContain('IP_PRODUCT_SENSOR_ACTUAL');
    expect(sql).not.toContain('IP_PRODUCT_WORK_RESULT');
  });

  it('checks IP_PRODUCT_SENSOR_ACTUAL before deleting a run card', async () => {
    const query = jest.fn()
      .mockResolvedValueOnce([{ CNT: 1 }])
      .mockResolvedValueOnce([{ PID_CNT: 0, RESULT_CNT: 0, DETAIL_CNT: 0 }])
      .mockResolvedValue([]);
    const transaction = jest.fn(async (callback) => callback({ query }));
    const service = new RunCardService({ manager: { transaction } } as never);

    await service.remove('RUN-001');

    const guardSql = String(query.mock.calls[1][0]);
    expect(guardSql).toContain('IP_PRODUCT_SENSOR_ACTUAL');
    expect(guardSql).not.toContain('IP_PRODUCT_WORK_RESULT');
  });
});
