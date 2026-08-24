import { BadRequestException, ConflictException, NotFoundException } from '@nestjs/common';
import { validate } from 'class-validator';
import { DataSource, Repository } from 'typeorm';
import { OeeDowntimeReason } from '../../entities/oee-downtime-reason.entity';
import { OeeResource } from '../../entities/oee-resource.entity';
import {
  ReasonUpsertDto,
  ResourceCreateDto,
  ResourceUpdateDto,
} from './oee.dto';
import { OeeMasterService } from './oee-master.service';

type TenantScopedMaster = {
  listResources(organizationId: number): Promise<unknown[]>;
  listResourceCandidates(organizationId: number): Promise<unknown[]>;
  createResource(dto: ResourceCreateDto, organizationId: number): Promise<void>;
  updateResource(resourceId: number, dto: ResourceUpdateDto, organizationId: number): Promise<void>;
  deleteResource(resourceId: number, organizationId: number): Promise<void>;
  listReasons(organizationId: number): Promise<OeeDowntimeReason[]>;
  upsertReason(dto: ReasonUpsertDto, isUpdate: boolean, organizationId: number): Promise<void>;
};

describe('OeeMasterService tenant isolation', () => {
  const resourceRepo = {
    find: jest.fn().mockResolvedValue([]),
    findOne: jest.fn().mockResolvedValue(null),
    update: jest.fn().mockResolvedValue({ affected: 1 }),
    insert: jest.fn().mockResolvedValue({ identifiers: [] }),
    delete: jest.fn().mockResolvedValue({ affected: 1 }),
  } as unknown as Repository<OeeResource>;
  const reasonRepo = {
    find: jest.fn().mockResolvedValue([]),
    update: jest.fn().mockResolvedValue({ affected: 1 }),
    insert: jest.fn().mockResolvedValue({ identifiers: [] }),
  } as unknown as Repository<OeeDowntimeReason>;
  const dataSource = {
    query: jest.fn().mockResolvedValue([]),
  } as unknown as DataSource;

  beforeEach(() => {
    jest.clearAllMocks();
    (resourceRepo.findOne as jest.Mock).mockResolvedValue(null);
    (resourceRepo.update as jest.Mock).mockResolvedValue({ affected: 1 });
    (resourceRepo.insert as jest.Mock).mockResolvedValue({ identifiers: [] });
    (resourceRepo.delete as jest.Mock).mockResolvedValue({ affected: 1 });
    (dataSource.query as jest.Mock).mockResolvedValue([]);
  });

  function createTarget(): TenantScopedMaster {
    return new OeeMasterService(resourceRepo, reasonRepo, dataSource) as unknown as TenantScopedMaster;
  }

  it('validates the approved resource process and type enums', async () => {
    const dto = Object.assign(new ResourceCreateDto(), {
      lineCode: '01',
      processCode: 'PERF',
      resourceType: 'MACHINE',
    });

    const errors = await validate(dto);

    expect(errors.map((error) => error.property)).toEqual(expect.arrayContaining(['processCode', 'resourceType']));
  });

  it('lists canonical tenant resources from IP_PRODUCT_LINE', async () => {
    const target = createTarget();
    (dataSource.query as jest.Mock).mockResolvedValueOnce([
      {
        resourceId: 10,
        lineCode: '01',
        lineName: 'Canonical line',
        processCode: 'SMT',
        resourceType: 'LINE',
      },
    ]);

    await expect(target.listResources(7)).resolves.toEqual([
      expect.objectContaining({ lineCode: '01', lineName: 'Canonical line' }),
    ]);

    const [sql, binds] = (dataSource.query as jest.Mock).mock.calls[0];
    expect(sql).toContain('IP_PRODUCT_LINE');
    expect(sql).toContain('LINE_CODE');
    expect(sql).toContain('LINE_NAME');
    expect(sql).toContain(':organizationId');
    expect(sql).not.toContain('l.ACTIVE_YN');
    expect(binds).toEqual({ organizationId: 7 });
  });

  it('lists all tenant line candidates not already registered, including inactive lines', async () => {
    const target = createTarget();
    (dataSource.query as jest.Mock).mockResolvedValueOnce([
      { lineCode: '99', lineName: 'Waiting line', parentLineCode: '99' },
    ]);

    await expect(target.listResourceCandidates(7)).resolves.toEqual([
      { lineCode: '99', lineName: 'Waiting line', parentLineCode: '99' },
    ]);

    const [sql, binds] = (dataSource.query as jest.Mock).mock.calls[0];
    expect(sql).toContain('IP_PRODUCT_LINE');
    expect(sql).toContain('NOT EXISTS');
    expect(sql).not.toContain('ACTIVE_YN');
    expect(binds).toEqual({ organizationId: 7 });
  });

  it('uses the authenticated organization and canonical line values when creating a resource', async () => {
    const target = createTarget();
    (dataSource.query as jest.Mock).mockResolvedValueOnce([
      { lineCode: '01', lineName: 'Canonical line', sortOrder: null },
    ]);
    const dto = {
      lineCode: '01',
      processCode: 'SMT',
      resourceType: 'LINE',
      organizationId: 999,
      lineName: 'Spoofed name',
    } as ResourceCreateDto & { organizationId: number; lineName: string };

    await target.createResource(dto, 7);

    expect(resourceRepo.findOne).toHaveBeenCalledWith({ where: { organizationId: 7, refCode: '01' } });
    expect(resourceRepo.insert).toHaveBeenCalledWith({
      organizationId: 7,
      processCode: 'SMT',
      resourceType: 'LINE',
      refCode: '01',
      resourceName: 'Canonical line',
      idealCt: null,
      useYn: 'Y',
      sortOrder: 1,
    });
  });

  it('uses mesDisplaySequence before the numeric line code for resource sorting', async () => {
    const target = createTarget();
    (dataSource.query as jest.Mock).mockResolvedValueOnce([
      { lineCode: '01', lineName: 'Canonical line', mesDisplaySequence: 12 },
    ]);

    await target.createResource(
      { lineCode: '01', processCode: 'SMT', resourceType: 'LINE' },
      7,
    );

    expect(resourceRepo.insert).toHaveBeenCalledWith(expect.objectContaining({ sortOrder: 12 }));
  });

  it('rejects a resource when the authenticated organization has no matching line', async () => {
    const target = createTarget();

    await expect(
      target.createResource({ lineCode: '404', processCode: 'SMT', resourceType: 'LINE' }, 7),
    ).rejects.toThrow(NotFoundException);
    expect(resourceRepo.insert).not.toHaveBeenCalled();
  });

  it('rejects duplicate organization and line registrations with Conflict', async () => {
    const target = createTarget();
    (dataSource.query as jest.Mock).mockResolvedValueOnce([
      { lineCode: '01', lineName: 'Canonical line', sortOrder: 1 },
    ]);
    (resourceRepo.findOne as jest.Mock).mockResolvedValueOnce({ resourceId: 10 });

    await expect(
      target.createResource({ lineCode: '01', processCode: 'ASSY', resourceType: 'CELL' }, 7),
    ).rejects.toThrow(ConflictException);
    expect(resourceRepo.insert).not.toHaveBeenCalled();
  });

  it('keeps lineCode immutable and migrates process/type history atomically', async () => {
    const target = createTarget();
    (resourceRepo.findOne as jest.Mock).mockResolvedValueOnce({
      resourceId: 10,
      organizationId: 7,
      refCode: '01',
      processCode: 'SMT',
      resourceType: 'LINE',
    });
    await target.updateResource(
      10,
      { lineCode: '01', processCode: 'ASSY', resourceType: 'CELL' },
      7,
    );

    const [sql, binds] = (dataSource.query as jest.Mock).mock.calls[0];
    expect(sql).toContain('UPDATE OEE_DOWNTIME_EVENT');
    expect(sql).toContain('UPDATE OEE_OPERATION_LOG');
    expect(sql).toContain('UPDATE OEE_PRODUCTION_RESULT');
    expect(sql).toContain('UPDATE OEE_DAILY_SUMMARY');
    expect(sql).toContain('UPDATE OEE_RESOURCE');
    expect(binds).toEqual({
      organizationId: 7,
      resourceId: 10,
      resourceCode: '01',
      oldProcessCode: 'SMT',
      oldResourceType: 'LINE',
      newProcessCode: 'ASSY',
      newResourceType: 'CELL',
    });
  });

  it('rejects attempts to change the immutable lineCode', async () => {
    const target = createTarget();
    (resourceRepo.findOne as jest.Mock).mockResolvedValueOnce({
      resourceId: 10,
      organizationId: 7,
      refCode: '01',
      processCode: 'SMT',
      resourceType: 'LINE',
    });

    await expect(
      target.updateResource(10, { lineCode: '02', processCode: 'SMT', resourceType: 'LINE' }, 7),
    ).rejects.toThrow(BadRequestException);
    expect(resourceRepo.update).not.toHaveBeenCalled();
  });

  it('migrates process/type changes when resource history exists', async () => {
    const target = createTarget();
    (resourceRepo.findOne as jest.Mock).mockResolvedValueOnce({
      resourceId: 10,
      organizationId: 7,
      refCode: '01',
      processCode: 'SMT',
      resourceType: 'LINE',
    });
    await expect(
      target.updateResource(10, { lineCode: '01', processCode: 'ASSY', resourceType: 'CELL' }, 7),
    ).resolves.toBeUndefined();
    expect(dataSource.query).toHaveBeenCalledTimes(1);
  });

  it('physically deletes an unreferenced tenant resource', async () => {
    const target = createTarget();
    (resourceRepo.findOne as jest.Mock).mockResolvedValueOnce({
      resourceId: 10,
      organizationId: 7,
      refCode: '01',
      processCode: 'SMT',
      resourceType: 'LINE',
    });
    (dataSource.query as jest.Mock).mockResolvedValueOnce([
      { operationLog: 0, planTime: 0, productionResult: 0, dailySummary: 0, downtimeEvent: 0 },
    ]);

    await target.deleteResource(10, 7);

    expect(resourceRepo.delete).toHaveBeenCalledWith({ resourceId: 10, organizationId: 7 });
  });

  it('returns OEE_RESOURCE_IN_USE and reference counts instead of deleting history-bound resources', async () => {
    const target = createTarget();
    (resourceRepo.findOne as jest.Mock).mockResolvedValueOnce({
      resourceId: 10,
      organizationId: 7,
      refCode: '01',
      processCode: 'SMT',
      resourceType: 'LINE',
    });
    (dataSource.query as jest.Mock).mockResolvedValueOnce([
      { operationLog: 2, planTime: 1, productionResult: 3, dailySummary: 4, downtimeEvent: 5 },
    ]);

    const error = await target.deleteResource(10, 7).catch((value: unknown) => value);

    expect(error).toBeInstanceOf(ConflictException);
    expect((error as ConflictException).getResponse()).toEqual({
      errorCode: 'OEE_RESOURCE_IN_USE',
      message: expect.any(String),
      details: {
        counts: {
          operationLog: 2,
          planTime: 1,
          productionResult: 3,
          dailySummary: 4,
          downtimeEvent: 5,
        },
      },
    });
    const [sql, binds] = (dataSource.query as jest.Mock).mock.calls[0];
    for (const table of [
      'OEE_OPERATION_LOG',
      'OEE_PLAN_TIME',
      'OEE_PRODUCTION_RESULT',
      'OEE_DAILY_SUMMARY',
      'OEE_DOWNTIME_EVENT',
    ]) {
      expect(sql).toContain(table);
    }
    expect(binds).toEqual({
      organizationId: 7,
      resourceId: 10,
      processCode: 'SMT',
      resourceType: 'LINE',
      resourceCode: '01',
    });
    expect(resourceRepo.delete).not.toHaveBeenCalled();
  });

  it('uses a distinct named bind object for each raw query call', async () => {
    const target = createTarget();
    (dataSource.query as jest.Mock)
      .mockResolvedValueOnce([])
      .mockResolvedValueOnce([]);

    await target.listResources(7);
    await target.listResourceCandidates(7);

    const firstBinds = (dataSource.query as jest.Mock).mock.calls[0][1];
    const secondBinds = (dataSource.query as jest.Mock).mock.calls[1][1];
    expect(firstBinds).toEqual({ organizationId: 7 });
    expect(secondBinds).toEqual({ organizationId: 7 });
    expect(firstBinds).not.toBe(secondBinds);
  });

  it('filters reason list by the authenticated organization', async () => {
    const target = createTarget();

    await target.listResources(7);
    await target.listReasons(7);

    expect(reasonRepo.find).toHaveBeenCalledWith({
      where: { organizationId: 7, useYn: 'Y' },
      order: { sortOrder: 'ASC' },
    });
  });

  it('uses the authenticated organization for reason writes and update criteria', async () => {
    const target = createTarget();
    const dto = {
      reasonCode: 'STOP',
      reasonName: '정지',
      lossBucket: 'AVAIL_DOWN',
      oeeFactor: 'AVAILABILITY',
    } as ReasonUpsertDto;

    await target.upsertReason(dto, true, 7);

    expect(reasonRepo.update).toHaveBeenCalledWith(
      { reasonCode: 'STOP', organizationId: 7 },
      expect.objectContaining({ organizationId: 7 }),
    );
  });

  it('rejects service calls without an authenticated organization', async () => {
    const target = new OeeMasterService(resourceRepo, reasonRepo, dataSource);

    await expect(target.listResources(undefined)).rejects.toThrow(BadRequestException);
  });

  it('does not report success when a tenant-scoped update finds no row', async () => {
    const target = createTarget();
    (resourceRepo.findOne as jest.Mock).mockResolvedValueOnce({
      resourceId: 10,
      organizationId: 7,
      refCode: '01',
      processCode: 'SMT',
      resourceType: 'LINE',
    });
    (dataSource.query as jest.Mock).mockRejectedValueOnce({
      code: 'ORA-20003',
      message: 'ORA-20003: OEE resource changed during update',
    });

    await expect(
      target.updateResource(10, { lineCode: '01', processCode: 'ASSY', resourceType: 'CELL' }, 7),
    ).rejects.toThrow(NotFoundException);
  });
});
