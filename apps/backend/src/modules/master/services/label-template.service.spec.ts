import { Test, TestingModule } from '@nestjs/testing';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { getRepositoryToken } from '@nestjs/typeorm';
import { BadRequestException, ConflictException, NotFoundException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { LabelTemplate } from '../../../entities/label-template.entity';
import { MockLoggerService } from '@test/mock-logger.service';
import { LabelTemplateService } from './label-template.service';

describe('LabelTemplateService', () => {
  let target: LabelTemplateService;
  let mockRepo: DeepMocked<Repository<LabelTemplate>>;
  let mockQb: any;

  beforeEach(async () => {
    mockRepo = createMock<Repository<LabelTemplate>>();
    mockQb = {
      update: jest.fn().mockReturnThis(),
      set: jest.fn().mockReturnThis(),
      where: jest.fn().mockReturnThis(),
      andWhere: jest.fn().mockReturnThis(),
      execute: jest.fn().mockResolvedValue({ affected: 1 }),
    };
    mockRepo.createQueryBuilder.mockReturnValue(mockQb);

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        LabelTemplateService,
        { provide: getRepositoryToken(LabelTemplate), useValue: mockRepo },
      ],
    })
      .setLogger(new MockLoggerService())
      .compile();

    target = module.get<LabelTemplateService>(LabelTemplateService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('finds a template within tenant only', async () => {
    const item = { templateName: 'BOX', category: 'FG', organizationId: 1 } as LabelTemplate;
    mockRepo.findOne.mockResolvedValue(item);

    const result = await target.findById('BOX::FG', 1);

    expect(result).toEqual(item);
    expect(mockRepo.findOne).toHaveBeenCalledWith({
      where: { templateName: 'BOX', category: 'FG', organizationId: 1 },
    });
  });

  it('throws when tenant scoped template is missing', async () => {
    mockRepo.findOne.mockResolvedValue(null);

    await expect(target.findById('BOX::FG', 1)).rejects.toThrow(NotFoundException);
  });

  it('throws when matched template tenant differs from request tenant', async () => {
    mockRepo.findOne.mockResolvedValue({ templateName: 'BOX', category: 'FG', organizationId: 2 } as LabelTemplate);

    await expect(target.findById('BOX::FG', 1)).rejects.toThrow(BadRequestException);
  });

  it('creates a template within tenant and clears default only in tenant', async () => {
    const created = { templateName: 'BOX', category: 'FG', organizationId: 1 } as LabelTemplate;
    mockRepo.findOne.mockResolvedValue(null);
    mockRepo.create.mockReturnValue(created);
    mockRepo.save.mockResolvedValue(created);

    await target.create({ templateName: 'BOX', category: 'FG', designData: {}, isDefault: true } as any, 1);

    expect(mockRepo.create).toHaveBeenCalledWith(expect.objectContaining({
      templateName: 'BOX',
      category: 'FG',
      organizationId: 1,
    }));
    expect(mockQb.andWhere).toHaveBeenCalledWith('organizationId = :organizationId', { organizationId: 1 });
  });

  it('rejects duplicate template name and category within tenant', async () => {
    mockRepo.findOne.mockResolvedValue({ templateName: 'BOX', category: 'FG', organizationId: 1 } as LabelTemplate);

    await expect(target.create({
      templateName: 'BOX',
      category: 'FG',
      designData: {},
    } as any, 1)).rejects.toThrow(ConflictException);
    expect(mockRepo.save).not.toHaveBeenCalled();
  });

  it('updates a template within tenant and strips key columns from payload', async () => {
    const item = { templateName: 'BOX', category: 'FG', designData: '{}', organizationId: 1 } as LabelTemplate;
    mockRepo.findOne.mockResolvedValue(item);
    mockRepo.save.mockImplementation(async (value) => value as LabelTemplate);

    const result = await target.update('BOX::FG', {
      templateName: 'OTHER',
      category: 'WIP',
      remark: 'New',
    } as any, 1);

    expect(result).toEqual(expect.objectContaining({
      templateName: 'BOX',
      category: 'FG',
      remark: 'New',
      organizationId: 1,
    }));
  });

  it('deletes a template within tenant only', async () => {
    const item = { templateName: 'BOX', category: 'FG', organizationId: 1 } as LabelTemplate;
    mockRepo.findOne.mockResolvedValue(item);
    mockRepo.remove.mockResolvedValue(item);

    await target.delete('BOX::FG', 1);

    expect(mockRepo.findOne).toHaveBeenCalledWith({
      where: { templateName: 'BOX', category: 'FG', organizationId: 1 },
    });
  });
});
