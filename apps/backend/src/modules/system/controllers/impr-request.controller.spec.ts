import { ImprRequestController } from './impr-request.controller';
import { ImprRequestService } from '../services/impr-request.service';
import { BadRequestException } from '@nestjs/common';

describe('ImprRequestController', () => {
  it('findAll scopes by JwtAuthGuard user organizationId', async () => {
    const service = {
      findAll: jest.fn().mockResolvedValue({ data: [], total: 0, page: 1, limit: 20 }),
    } as unknown as ImprRequestService;
    const controller = new ImprRequestController(service);

    await controller.findAll({} as any, {
      headers: {},
      user: { organizationId: 1 },
    } as any);

    expect(service.findAll).toHaveBeenCalledWith(expect.anything(), 1);
  });

  it('create uses JwtAuthGuard user id instead of raw bearer token when present', async () => {
    const service = {
      create: jest.fn().mockResolvedValue({ imprId: 'REQ-1' }),
    } as unknown as ImprRequestService;
    const controller = new ImprRequestController(service);

    await controller.create({ description: 'fix', pageUrl: '/dashboard' } as any, {
      headers: { authorization: 'Bearer stale-token' },
      user: { id: 'GUARD_USER', organizationId: 1 },
    } as any);

    expect(service.create).toHaveBeenCalledWith(expect.anything(), 'GUARD_USER', null, 1);
  });

  // 조직 정보가 없으면 기본값으로 대체하지 않고 거부한다.
  it('does not silently default missing organizationId', async () => {
    const service = {
      findAll: jest.fn(),
    } as unknown as ImprRequestService;
    const controller = new ImprRequestController(service);

    await expect(controller.findAll({} as any, { headers: {} } as any)).rejects.toThrow(BadRequestException);
    expect(service.findAll).not.toHaveBeenCalled();
  });
});
