import { GUARDS_METADATA } from '@nestjs/common/constants';
import { ShiftTimeController } from './shift-time.controller';
import { ShiftTimeService } from '../services/shift-time.service';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';

describe('ShiftTimeController', () => {
  const service = {
    findAll: jest.fn(),
    create: jest.fn(),
    update: jest.fn(),
    remove: jest.fn(),
  };
  let target: ShiftTimeController;

  beforeEach(() => {
    jest.clearAllMocks();
    target = new ShiftTimeController(service as unknown as ShiftTimeService);
  });

  it('requires JwtAuthGuard so OrganizationId is populated', () => {
    const guards = Reflect.getMetadata(GUARDS_METADATA, ShiftTimeController) ?? [];
    expect(guards).toContain(JwtAuthGuard);
  });

  it('forwards the server organization id to every endpoint', async () => {
    service.findAll.mockResolvedValue([]);
    service.create.mockResolvedValue({});
    service.update.mockResolvedValue({});
    service.remove.mockResolvedValue(undefined);

    const createDto = { dateset: '2026-07-01' } as never;
    const updateDto = { dayTimeStart: '09:00' } as never;

    await target.findAll(40);
    await target.create(createDto, 40, 'tester');
    await target.update('2026-07-01', updateDto, 40, 'tester');
    await target.remove('2026-07-01', 40);

    expect(service.findAll).toHaveBeenCalledWith(40);
    expect(service.create).toHaveBeenCalledWith(createDto, 40, 'tester');
    expect(service.update).toHaveBeenCalledWith('2026-07-01', updateDto, 40, 'tester');
    expect(service.remove).toHaveBeenCalledWith('2026-07-01', 40);
  });
});
