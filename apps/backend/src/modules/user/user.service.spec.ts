import { Test, TestingModule } from '@nestjs/testing';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { getRepositoryToken } from '@nestjs/typeorm';
import { ConflictException, NotFoundException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { UserService } from './user.service';
import { IsysUser } from '../../entities/isys-user.entity';
import { MockLoggerService } from '@test/mock-logger.service';

describe('UserService', () => {
  let target: UserService;
  let mockRepo: DeepMocked<Repository<IsysUser>>;

  beforeEach(async () => {
    mockRepo = createMock<Repository<IsysUser>>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UserService,
        { provide: getRepositoryToken(IsysUser), useValue: mockRepo },
      ],
    })
      .setLogger(new MockLoggerService())
      .compile();

    target = module.get<UserService>(UserService);
  });

  afterEach(() => jest.clearAllMocks());

  it('finds user by USER_ID and organization id', async () => {
    mockRepo.findOne.mockResolvedValue({
      userId: 'KDH',
      userName: '김대현',
      organizationId: 1,
      userLevel: 9,
    } as IsysUser);

    const result = await target.findOne('KDH', 1);

    expect(result.email).toBe('KDH');
    expect(result.role).toBe('ADMIN');
    expect(mockRepo.findOne).toHaveBeenCalledWith({
      where: { userId: 'KDH', organizationId: 1 },
    });
  });

  it('throws when user does not exist', async () => {
    mockRepo.findOne.mockResolvedValue(null);

    await expect(target.findOne('NONE', 1)).rejects.toThrow(NotFoundException);
  });

  it('creates ISYS_USERS rows from the page contract', async () => {
    mockRepo.findOne.mockResolvedValue(null);
    mockRepo.create.mockImplementation((payload) => payload as IsysUser);
    mockRepo.save.mockImplementation(async (payload) => payload as IsysUser);

    const result = await target.create({
      email: 'NEWID',
      password: '1234',
      name: '신규',
      dept: '1000',
      role: 'MANAGER',
    } as any, 1);

    expect(mockRepo.create).toHaveBeenCalledWith(expect.objectContaining({
      userId: 'NEWID',
      userName: '신규',
      departmentCode: '1000',
      userLevel: 5,
      organizationId: 1,
    }));
    expect(result.email).toBe('NEWID');
  });

  it('rejects duplicate user id in organization', async () => {
    mockRepo.findOne.mockResolvedValue({ userId: 'KDH', organizationId: 1 } as IsysUser);

    await expect(target.create({ email: 'KDH' } as any, 1)).rejects.toThrow(ConflictException);
  });

  it('updates only ISYS_USERS columns', async () => {
    mockRepo.findOne.mockResolvedValue({ userId: 'KDH', organizationId: 1, userLevel: 1 } as IsysUser);
    mockRepo.update.mockResolvedValue({ affected: 1 } as any);

    await target.update('KDH', { name: '변경', dept: '2000', role: 'ADMIN', status: 'INACTIVE' } as any, 1);

    expect(mockRepo.update).toHaveBeenCalledWith(
      { userId: 'KDH', organizationId: 1 },
      expect.objectContaining({ userName: '변경', departmentCode: '2000', userLevel: 9 }),
    );
  });

  it('deletes by USER_ID and organization id', async () => {
    mockRepo.findOne.mockResolvedValue({ userId: 'KDH', organizationId: 1 } as IsysUser);
    mockRepo.delete.mockResolvedValue({ affected: 1 } as any);

    await target.remove('KDH', 1);

    expect(mockRepo.delete).toHaveBeenCalledWith({ userId: 'KDH', organizationId: 1 });
  });
});
