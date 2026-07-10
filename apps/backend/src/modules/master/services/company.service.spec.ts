import { Test, TestingModule } from '@nestjs/testing';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { getRepositoryToken } from '@nestjs/typeorm';
import { ConflictException, NotFoundException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { CompanyService } from './company.service';
import { IsysOrganization } from '../../../entities/isys-organization.entity';
import { MockLoggerService } from '@test/mock-logger.service';

describe('CompanyService', () => {
  let target: CompanyService;
  let mockRepo: DeepMocked<Repository<IsysOrganization>>;

  beforeEach(async () => {
    mockRepo = createMock<Repository<IsysOrganization>>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CompanyService,
        { provide: getRepositoryToken(IsysOrganization), useValue: mockRepo },
      ],
    })
      .setLogger(new MockLoggerService())
      .compile();

    target = module.get<CompanyService>(CompanyService);
  });

  afterEach(() => jest.clearAllMocks());

  it('finds company by organization id encoded in the page key', async () => {
    mockRepo.findOne.mockResolvedValue({
      organizationId: 1,
      companyCode: 'EUNSUNG',
      organizationName: '은성전장',
    } as IsysOrganization);

    const result = await target.findById('EUNSUNG::1');

    expect(result.companyCode).toBe('EUNSUNG');
    expect(result.plant).toBe('1');
    expect(mockRepo.findOne).toHaveBeenCalledWith({ where: { organizationId: 1 } });
  });

  it('throws when company does not exist', async () => {
    mockRepo.findOne.mockResolvedValue(null);

    await expect(target.findById('EUNSUNG::1')).rejects.toThrow(NotFoundException);
  });

  it('creates organization rows in ISYS_ORGANIZATION shape', async () => {
    const queryBuilder = {
      select: jest.fn().mockReturnThis(),
      getRawOne: jest.fn().mockResolvedValue({ maxId: 1 }),
    };
    mockRepo.findOne.mockResolvedValue(null);
    mockRepo.createQueryBuilder.mockReturnValue(queryBuilder as any);
    mockRepo.create.mockImplementation((payload) => payload as IsysOrganization);
    mockRepo.save.mockImplementation(async (payload) => payload as IsysOrganization);

    const result = await target.create({ companyCode: 'NEWCO', companyName: 'New Company' } as any, 'admin', '1');

    expect(mockRepo.create).toHaveBeenCalledWith(expect.objectContaining({
      organizationId: 2,
      companyCode: 'NEWCO',
      organizationName: 'New Company',
    }));
    expect(result.companyCode).toBe('NEWCO');
  });

  it('rejects duplicate company code', async () => {
    mockRepo.findOne.mockResolvedValue({ organizationId: 1 } as IsysOrganization);

    await expect(target.create({ companyCode: 'EUNSUNG' } as any)).rejects.toThrow(ConflictException);
  });

  it('updates ISYS_ORGANIZATION columns by organization id', async () => {
    mockRepo.findOne.mockResolvedValue({
      organizationId: 1,
      companyCode: 'EUNSUNG',
      organizationName: '은성전장',
    } as IsysOrganization);
    mockRepo.update.mockResolvedValue({ affected: 1 } as any);

    await target.update('EUNSUNG::1', { companyName: 'Updated', tel: '123' } as any, 'admin', '1');

    expect(mockRepo.update).toHaveBeenCalledWith(
      { organizationId: 1 },
      expect.objectContaining({ organizationName: 'Updated', telNo: '123' }),
    );
  });

  it('deletes by organization id', async () => {
    mockRepo.findOne.mockResolvedValue({ organizationId: 1, companyCode: 'EUNSUNG' } as IsysOrganization);
    mockRepo.delete.mockResolvedValue({ affected: 1 } as any);

    await target.delete('EUNSUNG::1');

    expect(mockRepo.delete).toHaveBeenCalledWith({ organizationId: 1 });
  });
});
