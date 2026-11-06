import { GUARDS_METADATA } from '@nestjs/common/constants';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { PurchaseDailyController } from './purchase-daily.controller';

describe('PurchaseDailyController', () => {
  it('JwtAuthGuard 를 컨트롤러에 건다', () => {
    const guards = Reflect.getMetadata(GUARDS_METADATA, PurchaseDailyController) ?? [];
    expect(guards).toContain(JwtAuthGuard);
  });

  it('조직 ID 는 서버가 주입한 값만 서비스에 넘긴다', async () => {
    const service = {
      findSummary: jest.fn().mockResolvedValue({ data: [], total: 0, truncated: false }),
      findDetail: jest.fn().mockResolvedValue({ data: [], total: 0, truncated: false }),
    };
    const controller = new PurchaseDailyController(service as never);
    const query = { dateFrom: '2026-11-01', dateTo: '2026-11-05' };
    await controller.summary(query, 7);
    await controller.detail({ ...query, bookGroup: '인팩' }, 7);
    expect(service.findSummary).toHaveBeenCalledWith(query, 7);
    expect(service.findDetail).toHaveBeenCalledWith({ ...query, bookGroup: '인팩' }, 7);
  });
});
