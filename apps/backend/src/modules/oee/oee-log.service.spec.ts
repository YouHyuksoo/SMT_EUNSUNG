import { BadRequestException, NotFoundException } from '@nestjs/common';
import { DataSource, Repository } from 'typeorm';
import { OeeOperationLog } from '../../entities/oee-operation-log.entity';
import { OeeDowntimeReason } from '../../entities/oee-downtime-reason.entity';
import { OeeResource } from '../../entities/oee-resource.entity';
import { LogSaveDto } from './oee.dto';
import { OeeLogService, ShiftLogRow } from './oee-log.service';

type TenantScopedLog = {
  loadShift(
    resourceId: number,
    workDate: string,
    shift: string,
    organizationId: number,
  ): Promise<ShiftLogRow[]>;
  saveShift(dto: LogSaveDto, organizationId: number, userId: string): Promise<void>;
};

describe('OeeLogService tenant isolation', () => {
  const logRepo = {
    find: jest.fn().mockResolvedValue([]),
  } as unknown as Repository<OeeOperationLog>;
  const resourceRepo = {
    findOne: jest.fn(),
  };
  const reasonRepo = {
    find: jest.fn(),
  };
  const manager = {
    delete: jest.fn().mockResolvedValue({ affected: 1 }),
    insert: jest.fn().mockResolvedValue({ identifiers: [] }),
  };
  const dataSource = {
    transaction: jest.fn(async (work: (transactionManager: typeof manager) => Promise<void>) => work(manager)),
  } as unknown as DataSource;
  const ServiceConstructor = OeeLogService as unknown as new (
    dataSource: DataSource,
    logRepo: Repository<OeeOperationLog>,
    resourceRepo: Repository<OeeResource>,
    reasonRepo: Repository<OeeDowntimeReason>,
  ) => OeeLogService;

  beforeEach(() => {
    jest.clearAllMocks();
    resourceRepo.findOne.mockResolvedValue({ resourceId: 10, organizationId: 7, processCode: 'SMT' });
    reasonRepo.find.mockResolvedValue([]);
  });

  it('scopes shift reads to the authenticated organization', async () => {
    const target = new ServiceConstructor(
      dataSource,
      logRepo,
      resourceRepo as unknown as Repository<OeeResource>,
      reasonRepo as unknown as Repository<OeeDowntimeReason>,
    ) as unknown as TenantScopedLog;

    await target.loadShift(10, '2026-08-20', 'DAY', 7);

    expect(logRepo.find).toHaveBeenCalledWith({
      where: { resourceId: 10, workDate: expect.any(Date), shift: 'DAY', organizationId: 7 },
      order: { startTime: 'ASC' },
    });
  });

  it('validates the resource tenant and uses authenticated values for delete and insert', async () => {
    const target = new ServiceConstructor(
      dataSource,
      logRepo,
      resourceRepo as unknown as Repository<OeeResource>,
      reasonRepo as unknown as Repository<OeeDowntimeReason>,
    ) as unknown as TenantScopedLog;
    const dto = {
      resourceId: 10,
      workDate: '2026-08-20',
      shift: 'DAY',
      netLoadMinutes: 60,
      intervals: [{ startMin: 0, endMin: 60, status: 'RUN' }],
    } as LogSaveDto;

    await target.saveShift(dto, 7, 'authenticated-user');

    expect(resourceRepo.findOne).toHaveBeenCalledWith({ where: { resourceId: 10, organizationId: 7 } });
    expect(manager.delete).toHaveBeenCalledWith(OeeOperationLog, {
      resourceId: 10,
      workDate: expect.any(Date),
      shift: 'DAY',
      organizationId: 7,
    });
    expect(manager.insert).toHaveBeenCalledWith(
      OeeOperationLog,
      expect.objectContaining({ organizationId: 7, processCode: 'SMT', createdBy: 'authenticated-user' }),
    );
  });

  it('rejects a resource outside the authenticated organization before replacing logs', async () => {
    const target = new ServiceConstructor(
      dataSource,
      logRepo,
      resourceRepo as unknown as Repository<OeeResource>,
      reasonRepo as unknown as Repository<OeeDowntimeReason>,
    ) as unknown as TenantScopedLog;
    resourceRepo.findOne.mockResolvedValue(null);

    const dto = {
      resourceId: 10,
      workDate: '2026-08-20',
      shift: 'DAY',
      netLoadMinutes: 60,
      intervals: [],
    } as LogSaveDto;

    await expect(target.saveShift(dto, 7, 'authenticated-user')).rejects.toThrow(NotFoundException);
    expect(dataSource.transaction).not.toHaveBeenCalled();
  });

  it('requires an authenticated user for writes', async () => {
    const target = new ServiceConstructor(
      dataSource,
      logRepo,
      resourceRepo as unknown as Repository<OeeResource>,
      reasonRepo as unknown as Repository<OeeDowntimeReason>,
    ) as unknown as TenantScopedLog;
    const dto = {
      resourceId: 10,
      workDate: '2026-08-20',
      shift: 'DAY',
      netLoadMinutes: 60,
      intervals: [],
    } as LogSaveDto;

    await expect(target.saveShift(dto, 7, '')).rejects.toThrow(BadRequestException);
  });

  it('rejects a downtime reason outside the authenticated organization or resource process', async () => {
    const target = new ServiceConstructor(
      dataSource,
      logRepo,
      resourceRepo as unknown as Repository<OeeResource>,
      reasonRepo as unknown as Repository<OeeDowntimeReason>,
    ) as unknown as TenantScopedLog;
    const dto = {
      resourceId: 10,
      workDate: '2026-08-20',
      shift: 'DAY',
      netLoadMinutes: 60,
      intervals: [{ startMin: 0, endMin: 60, status: 'DOWN', reasonCode: 'FOREIGN' }],
    } as LogSaveDto;

    await expect(target.saveShift(dto, 7, 'authenticated-user')).rejects.toThrow(BadRequestException);
    expect(reasonRepo.find).toHaveBeenCalledWith({
      where: {
        organizationId: 7,
        reasonCode: expect.anything(),
        processCode: expect.anything(),
        useYn: 'Y',
      },
    });
    expect(dataSource.transaction).not.toHaveBeenCalled();
  });
});
