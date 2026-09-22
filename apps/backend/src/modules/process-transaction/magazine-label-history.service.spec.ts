import { MagazineLabelHistoryService } from './magazine-label-history.service';

describe('MagazineLabelHistoryService', () => {
  const query = jest.fn();
  const service = new MagazineLabelHistoryService({ query } as never);

  beforeEach(() => query.mockReset());

  it('preserves the PB history filters and tenant bind', async () => {
    query.mockResolvedValueOnce([{ total: 1 }]).mockResolvedValueOnce([{ runNo: 'RUN-1' }]);

    const result = await service.find({
      viewMode: 'history', lineCode: 'L1', workstageCode: 'SMT', modelName: 'MODEL',
      magazineLabelNo: 'MAG', runNo: 'RUN', dateFrom: '2026-09-01', dateTo: '2026-09-22', page: 1, limit: 50,
    }, 7);

    expect(result.total).toBe(1);
    expect(query).toHaveBeenCalledTimes(2);
    const [countSql, countBinds] = query.mock.calls[0];
    expect(countSql).toContain('IP_PRODUCT_RUN_CARD_IO');
    expect(countSql).toContain('ORGANIZATION_ID = :organizationId');
    expect(countBinds).toMatchObject({ organizationId: 7, lineCode: 'L1%', workstageCode: 'SMT%', modelName: 'MODEL%', magazineLabelNo: 'MAG%', runNo: 'RUN%' });
  });

  it('groups summary rows and aggregates matrix rows by date and label type', async () => {
    query.mockResolvedValue([]);
    await service.find({ viewMode: 'summary', page: 1, limit: 50 }, 7);
    expect(query.mock.calls[0][0]).toContain('GROUP BY');

    query.mockClear();
    query.mockResolvedValue([]);
    await service.find({ viewMode: 'matrix', page: 1, limit: 50 }, 7);
    expect(query.mock.calls[0][0]).toContain('MAGAZINE_LABEL_TYPE AS "magazineLabelType"');
    expect(query.mock.calls[0][0]).toContain('SUM(io.LOT_QTY) AS "lotQty"');
  });
});
