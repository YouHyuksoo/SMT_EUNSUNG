import { GUARDS_METADATA } from '@nestjs/common/constants';
import { WorkCalendarController } from './work-calendar.controller';
import { WorkCalendarService } from '../services/work-calendar.service';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';

describe('WorkCalendarController', () => {
  const service = {
    findDays: jest.fn(),
    bulkUpdateDays: jest.fn(),
    generateYear: jest.fn(),
    copyFromCompany: jest.fn(),
    confirm: jest.fn(),
    unconfirm: jest.fn(),
    getSummary: jest.fn(),
  };
  let target: WorkCalendarController;

  beforeEach(() => {
    jest.clearAllMocks();
    target = new WorkCalendarController(service as unknown as WorkCalendarService);
  });

  it('requires JwtAuthGuard so OrganizationId is populated', () => {
    const guards = Reflect.getMetadata(GUARDS_METADATA, WorkCalendarController) ?? [];
    expect(guards).toContain(JwtAuthGuard);
  });

  it('forwards the server organization id to every read endpoint', async () => {
    service.findDays.mockResolvedValue([]);
    service.getSummary.mockResolvedValue({});

    await target.findDays({ month: '2026-07' }, 40);
    await target.getSummary({ year: '2026' }, 40);

    expect(service.findDays).toHaveBeenCalledWith(expect.any(Object), 40);
    expect(service.getSummary).toHaveBeenCalledWith(expect.any(Object), 40);
  });

  it('forwards the server organization id to every write endpoint', async () => {
    service.bulkUpdateDays.mockResolvedValue(0);
    service.generateYear.mockResolvedValue(0);
    service.copyFromCompany.mockResolvedValue(0);
    service.confirm.mockResolvedValue(0);
    service.unconfirm.mockResolvedValue(0);

    const daysDto = { days: [] } as never;
    const generateDto = { year: '2026' } as never;
    const copyDto = { year: '2026', lineCode: 'L1' } as never;
    const confirmDto = { year: '2026' } as never;

    await target.bulkUpdateDays(daysDto, 40, 'tester');
    await target.generate(generateDto, 40, 'tester');
    await target.copyFromCompany(copyDto, 40, 'tester');
    await target.confirm(confirmDto, 40, 'tester');
    await target.unconfirm(confirmDto, 40, 'tester');

    expect(service.bulkUpdateDays).toHaveBeenCalledWith(daysDto, 40, 'tester');
    expect(service.generateYear).toHaveBeenCalledWith(generateDto, 40, 'tester');
    expect(service.copyFromCompany).toHaveBeenCalledWith(copyDto, 40, 'tester');
    expect(service.confirm).toHaveBeenCalledWith(confirmDto, 40, 'tester');
    expect(service.unconfirm).toHaveBeenCalledWith(confirmDto, 40, 'tester');
  });

  it('forwards undefined userId when the request carries no authenticated user id', async () => {
    service.generateYear.mockResolvedValue(0);
    const generateDto = { year: '2026' } as never;

    await target.generate(generateDto, 40, undefined);

    expect(service.generateYear).toHaveBeenCalledWith(generateDto, 40, undefined);
  });
});
