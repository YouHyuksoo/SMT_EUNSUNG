import { Test, TestingModule } from '@nestjs/testing';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { getRepositoryToken } from '@nestjs/typeorm';
import { ConflictException, NotFoundException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { DepartmentService } from './department.service';
import { DepartmentMaster } from '../../../entities/department-master.entity';
import { MockLoggerService } from '@test/mock-logger.service';

describe('DepartmentService', () => {
  let target: DepartmentService;
  let mockRepo: DeepMocked<Repository<DepartmentMaster>>;

  beforeEach(async () => {
    mockRepo = createMock<Repository<DepartmentMaster>>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DepartmentService,
        { provide: getRepositoryToken(DepartmentMaster), useValue: mockRepo },
      ],
    })
      .setLogger(new MockLoggerService())
      .compile();

    target = module.get<DepartmentService>(DepartmentService);
  });

  afterEach(() => jest.clearAllMocks());

  it('finds department within organization id', async () => {
    mockRepo.findOne.mockResolvedValue({
      deptCode: '1000',
      deptName: '생산관리',
      organizationId: 1,
      parentDeptCode: '0000',
    } as DepartmentMaster);

    const result = await target.findById('1000', 1);

    expect(result.deptName).toBe('생산관리');
    expect(mockRepo.findOne).toHaveBeenCalledWith({
      where: { deptCode: '1000', organizationId: 1 },
    });
  });

  it('throws when department does not exist', async () => {
    mockRepo.findOne.mockResolvedValue(null);

    await expect(target.findById('9999', 1)).rejects.toThrow(NotFoundException);
  });

  it('creates ISYS_DEPARTMENT rows', async () => {
    mockRepo.findOne.mockResolvedValue(null);
    mockRepo.create.mockImplementation((payload) => payload as DepartmentMaster);
    mockRepo.save.mockImplementation(async (payload) => payload as DepartmentMaster);

    const result = await target.create({ deptCode: '9000', deptName: '개발' } as any, 1);

    expect(mockRepo.create).toHaveBeenCalledWith(expect.objectContaining({
      deptCode: '9000',
      organizationId: 1,
      deptName: '개발',
      parentDeptCode: '*',
    }));
    expect(result.useYn).toBe('Y');
  });

  it('rejects duplicate department code in organization', async () => {
    mockRepo.findOne.mockResolvedValue({ deptCode: '1000', organizationId: 1 } as DepartmentMaster);

    await expect(target.create({ deptCode: '1000' } as any, 1)).rejects.toThrow(ConflictException);
  });

  it('updates only ISYS_DEPARTMENT columns', async () => {
    mockRepo.findOne.mockResolvedValue({ deptCode: '1000', organizationId: 1 } as DepartmentMaster);
    mockRepo.update.mockResolvedValue({ affected: 1 } as any);

    await target.update('1000', { deptName: '변경', parentDeptCode: '' } as any, 1);

    expect(mockRepo.update).toHaveBeenCalledWith(
      { deptCode: '1000', organizationId: 1 },
      expect.objectContaining({ deptName: '변경', deptNameLocal: '변경', parentDeptCode: '*' }),
    );
  });

  it('deletes by department code and organization id', async () => {
    mockRepo.findOne.mockResolvedValue({ deptCode: '1000', organizationId: 1 } as DepartmentMaster);
    mockRepo.delete.mockResolvedValue({ affected: 1 } as any);

    await target.delete('1000', 1);

    expect(mockRepo.delete).toHaveBeenCalledWith({ deptCode: '1000', organizationId: 1 });
  });
});
