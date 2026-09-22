import { BadRequestException } from '@nestjs/common';
import { WorkstagePassService } from './workstage-pass.service';

describe('WorkstagePassService', () => {
  const query = jest.fn();
  const transaction = jest.fn();
  const callProcScalar = jest.fn();
  const service = new WorkstagePassService({ query, transaction } as never, { callProcScalar } as never);

  beforeEach(() => { query.mockReset(); transaction.mockReset(); callProcScalar.mockReset(); });

  it('조회 시 조직 바인드와 PB 공정통과 테이블을 사용한다', async () => {
    query.mockResolvedValueOnce([{ total: 1 }]).mockResolvedValueOnce([{ serialNo: 'PID-1' }]);
    const result = await service.find({ mode: 'history', dateFrom: '2026-09-01', dateTo: '2026-09-22' }, 7);
    expect(result.total).toBe(1);
    expect(query.mock.calls[0][0]).toContain('IP_PRODUCT_WORKSTAGE_IO');
    expect(query.mock.calls[0][0]).toContain('ORGANIZATION_ID = :organizationId');
    expect(query.mock.calls[0][1]).toMatchObject({ organizationId: 7 });
  });

  it('스캔 전에 PB 인터록과 PID 상태를 검사한다', async () => {
    query
      .mockResolvedValueOnce([{ interlockCheckType: 'A' }])
      .mockResolvedValueOnce([{ status: 'NG' }]);
    callProcScalar.mockResolvedValue({ result: 'OK', message: '' });
    await expect(service.scan({ pid: 'PID-1', lineCode: 'L1', workstageCode: 'WS1' }, 7, 'tester'))
      .rejects.toBeInstanceOf(BadRequestException);
    expect(callProcScalar).toHaveBeenCalledWith('P_INTERLOCK_CHECK', expect.any(Array), expect.objectContaining({ lineCode: 'L1', serialNo: 'PID-1' }));
    expect(transaction).not.toHaveBeenCalled();
  });
});
