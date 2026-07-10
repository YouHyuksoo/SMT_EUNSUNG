import { Test, TestingModule } from '@nestjs/testing';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { getRepositoryToken } from '@nestjs/typeorm';
import { ConflictException, NotFoundException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { ComCodeService } from './com-code.service';
import { ComCode } from '../../../entities/com-code.entity';
import { MockLoggerService } from '@test/mock-logger.service';

describe('ComCodeService', () => {
  let target: ComCodeService;
  let mockRepo: DeepMocked<Repository<ComCode>>;

  beforeEach(async () => {
    mockRepo = createMock<Repository<ComCode>>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ComCodeService,
        { provide: getRepositoryToken(ComCode), useValue: mockRepo },
      ],
    })
      .setLogger(new MockLoggerService())
      .compile();

    target = module.get<ComCodeService>(ComCodeService);
  });

  afterEach(() => jest.clearAllMocks());

  it('returns all base codes grouped by CODE_TYPE', async () => {
    mockRepo.find.mockResolvedValue([
      { groupCode: 'PLAN STATUS', detailCode: 'W', codeName: '대기', codeNameEng: 'WAIT', codeNameLocal: 'WAIT' },
      { groupCode: 'PLAN STATUS', detailCode: 'C', codeName: '완료', codeNameEng: 'COMPLETE', codeNameLocal: 'COMPLETE' },
      { groupCode: 'DELIVERY', detailCode: '1', codeName: '수출', codeNameEng: 'EXPORT', codeNameLocal: 'EXPORT' },
    ] as ComCode[]);

    const result = await target.findAllActive(1);

    expect(result['PLAN STATUS']).toHaveLength(2);
    expect(result['PLAN STATUS'][0]).toEqual(expect.objectContaining({
      detailCode: 'W',
      codeName: '대기',
      attr3: 'WAIT',
      useYn: 'Y',
    }));
    expect(mockRepo.find).toHaveBeenCalledWith(expect.objectContaining({
      where: { organizationId: 1 },
      order: { groupCode: 'asc', detailCode: 'asc' },
    }));
  });

  it('counts groups within organization id', async () => {
    const qb: any = {
      select: jest.fn().mockReturnThis(),
      addSelect: jest.fn().mockReturnThis(),
      groupBy: jest.fn().mockReturnThis(),
      orderBy: jest.fn().mockReturnThis(),
      andWhere: jest.fn().mockReturnThis(),
      getRawMany: jest.fn().mockResolvedValue([{
        groupCode: 'PLAN STATUS',
        count: '2',
        detailCodes: 'C W',
        searchTextKo: '완료 대기',
        searchTextEn: 'COMPLETE WAIT',
        searchTextLocal: 'COMPLETE WAIT',
      }]),
    };
    mockRepo.createQueryBuilder.mockReturnValue(qb);

    const result = await target.findAllGroups(1);

    expect(result).toEqual([{
      groupCode: 'PLAN STATUS',
      count: 2,
      detailCodes: ['C', 'W'],
      searchText: {
        ko: '완료 대기',
        en: 'COMPLETE WAIT',
        zh: 'COMPLETE WAIT',
        vi: 'COMPLETE WAIT',
      },
    }]);
    expect(qb.andWhere).toHaveBeenCalledWith('code.organizationId = :organizationId', { organizationId: 1 });
  });

  it('finds a base code by CODE_TYPE and CODE_NAME', async () => {
    mockRepo.findOne.mockResolvedValue({
      groupCode: 'PLAN STATUS',
      detailCode: 'W',
      codeName: '대기',
      organizationId: 1,
    } as ComCode);

    const result = await target.findById('PLAN STATUS::W', 1);

    expect(result).toEqual(expect.objectContaining({ groupCode: 'PLAN STATUS', detailCode: 'W', useYn: 'Y' }));
    expect(mockRepo.findOne).toHaveBeenCalledWith({
      where: { groupCode: 'PLAN STATUS', detailCode: 'W', organizationId: 1 },
    });
  });

  it('throws when base code is missing', async () => {
    mockRepo.findOne.mockResolvedValue(null);

    await expect(target.findById('PLAN STATUS::X', 1)).rejects.toThrow(NotFoundException);
  });

  it('creates ISYS_BASECODE rows from the page contract', async () => {
    mockRepo.findOne.mockResolvedValue(null);
    mockRepo.create.mockImplementation((payload) => payload as ComCode);
    mockRepo.save.mockImplementation(async (payload) => payload as ComCode);

    const result = await target.create({
      groupCode: 'PLAN STATUS',
      detailCode: 'N',
      codeName: '정상',
      codeDesc: '정상 상태',
      attr1: 'NORMAL',
      attr2: 'NORMAL',
      attr3: 'NORMAL',
    } as any, 1);

    expect(mockRepo.create).toHaveBeenCalledWith(expect.objectContaining({
      groupCode: 'PLAN STATUS',
      detailCode: 'N',
      codeName: '정상',
      codeDesc: '정상 상태',
      attr1: 'NORMAL',
      codeNameLocal: 'NORMAL',
      codeNameEng: 'NORMAL',
      organizationId: 1,
    }));
    expect(result.detailCode).toBe('N');
  });

  it('rejects duplicate code within organization', async () => {
    mockRepo.findOne.mockResolvedValue({ groupCode: 'PLAN STATUS', detailCode: 'W', organizationId: 1 } as ComCode);

    await expect(target.create({ groupCode: 'PLAN STATUS', detailCode: 'W' } as any, 1)).rejects.toThrow(ConflictException);
  });

  it('updates only ISYS_BASECODE columns', async () => {
    mockRepo.findOne.mockResolvedValue({ groupCode: 'PLAN STATUS', detailCode: 'W', organizationId: 1 } as ComCode);
    mockRepo.update.mockResolvedValue({ affected: 1 } as any);

    await target.update('PLAN STATUS::W', {
      codeName: '대기중',
      sortOrder: 99,
      useYn: 'N',
      attr3: 'WAITING',
    } as any, 1);

    expect(mockRepo.update).toHaveBeenCalledWith(
      { groupCode: 'PLAN STATUS', detailCode: 'W', organizationId: 1 },
      expect.objectContaining({ codeName: '대기중', codeNameEng: 'WAITING' }),
    );
    expect(mockRepo.update).toHaveBeenCalledWith(
      expect.any(Object),
      expect.not.objectContaining({ sortOrder: expect.anything(), useYn: expect.anything() }),
    );
  });

  it('deletes by CODE_TYPE, CODE_NAME, and organization id', async () => {
    mockRepo.findOne.mockResolvedValue({ groupCode: 'PLAN STATUS', detailCode: 'W', organizationId: 1 } as ComCode);
    mockRepo.delete.mockResolvedValue({ affected: 1 } as any);

    await target.delete('PLAN STATUS::W', 1);

    expect(mockRepo.delete).toHaveBeenCalledWith({ groupCode: 'PLAN STATUS', detailCode: 'W', organizationId: 1 });
  });
});
