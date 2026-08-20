import { BadRequestException, NotFoundException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { OeeDowntimeReason } from '../../entities/oee-downtime-reason.entity';
import { OeeResource } from '../../entities/oee-resource.entity';
import { ReasonUpsertDto, ResourceUpsertDto } from './oee.dto';
import { OeeMasterService } from './oee-master.service';

type TenantScopedMaster = {
  listResources(organizationId: number): Promise<OeeResource[]>;
  upsertResource(dto: ResourceUpsertDto, organizationId: number): Promise<void>;
  listReasons(organizationId: number): Promise<OeeDowntimeReason[]>;
  upsertReason(dto: ReasonUpsertDto, isUpdate: boolean, organizationId: number): Promise<void>;
};

describe('OeeMasterService tenant isolation', () => {
  const resourceRepo = {
    find: jest.fn().mockResolvedValue([]),
    update: jest.fn().mockResolvedValue({ affected: 1 }),
    insert: jest.fn().mockResolvedValue({ identifiers: [] }),
  } as unknown as Repository<OeeResource>;
  const reasonRepo = {
    find: jest.fn().mockResolvedValue([]),
    update: jest.fn().mockResolvedValue({ affected: 1 }),
    insert: jest.fn().mockResolvedValue({ identifiers: [] }),
  } as unknown as Repository<OeeDowntimeReason>;

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('filters resource and reason lists by the authenticated organization', async () => {
    const target = new OeeMasterService(resourceRepo, reasonRepo) as unknown as TenantScopedMaster;

    await target.listResources(7);
    await target.listReasons(7);

    expect(resourceRepo.find).toHaveBeenCalledWith({
      where: { organizationId: 7, useYn: 'Y' },
      order: { processCode: 'ASC', sortOrder: 'ASC' },
    });
    expect(reasonRepo.find).toHaveBeenCalledWith({
      where: { organizationId: 7, useYn: 'Y' },
      order: { sortOrder: 'ASC' },
    });
  });

  it('uses the authenticated organization for resource writes and update criteria', async () => {
    const target = new OeeMasterService(resourceRepo, reasonRepo) as unknown as TenantScopedMaster;
    const dto = {
      resourceId: 10,
      processCode: 'SMT',
      resourceType: 'LINE',
      resourceName: 'Line 1',
    } as ResourceUpsertDto;

    await target.upsertResource(dto, 7);

    expect(resourceRepo.update).toHaveBeenCalledWith(
      { resourceId: 10, organizationId: 7 },
      expect.objectContaining({ organizationId: 7 }),
    );
  });

  it('uses the authenticated organization for reason writes and update criteria', async () => {
    const target = new OeeMasterService(resourceRepo, reasonRepo) as unknown as TenantScopedMaster;
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
    const target = new OeeMasterService(resourceRepo, reasonRepo);

    await expect(target.listResources(undefined)).rejects.toThrow(BadRequestException);
  });

  it('does not report success when a tenant-scoped update finds no row', async () => {
    const target = new OeeMasterService(resourceRepo, reasonRepo) as unknown as TenantScopedMaster;
    (resourceRepo.update as jest.Mock).mockResolvedValueOnce({ affected: 0 });
    const dto = {
      resourceId: 10,
      processCode: 'SMT',
      resourceType: 'LINE',
      resourceName: 'Line 1',
    } as ResourceUpsertDto;

    await expect(target.upsertResource(dto, 7)).rejects.toThrow(NotFoundException);
  });
});
