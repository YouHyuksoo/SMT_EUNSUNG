import { BadRequestException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { EquipmentResultQueryService } from './equipment-result-query.service';

describe('EquipmentResultQueryService', () => {
  const query = jest.fn();
  const service = new EquipmentResultQueryService({ query } as unknown as DataSource);

  beforeEach(() => query.mockReset());

  it('허용된 화면만 조직·기간 조건으로 조회한다', async () => {
    query.mockResolvedValue([{ INSPECT_DATE: '2026/09/22 10:00:00', LINE_CODE: '01', PID: 'P1' }]);
    const result = await service.findAll('ict', 7, {
      dateFrom: '2026-09-01', dateTo: '2026-09-22', lineCode: '01', pid: 'P1', limit: 500,
    });

    expect(query).toHaveBeenCalledWith(expect.stringContaining('IQ_MACHINE_INSPECT_DATA_ICT'), expect.objectContaining({ organizationId: 7 }));
    expect(query.mock.calls[0][0]).toContain('ORGANIZATION_ID = :organizationId');
    expect(result.data[0]).toMatchObject({ inspectDate: '2026/09/22 10:00:00', lineCode: '01', pid: 'P1' });
  });

  it('호출마다 새 bind 객체를 전달한다', async () => {
    query.mockImplementation(async (_sql, binds) => { binds.organizationId = -1; return []; });
    await service.findAll('spi', 1, { dateFrom: '2026-09-01', dateTo: '2026-09-22' });
    await service.findAll('spi', 1, { dateFrom: '2026-09-01', dateTo: '2026-09-22' });
    expect(query.mock.calls[0][1]).not.toBe(query.mock.calls[1][1]);
    expect(query.mock.calls[1][1].organizationId).toBe(-1);
  });

  it('등록되지 않은 결과 유형을 거부한다', async () => {
    await expect(service.findAll('unknown', 1, { dateFrom: '2026-09-01', dateTo: '2026-09-22' })).rejects.toBeInstanceOf(BadRequestException);
  });
});
