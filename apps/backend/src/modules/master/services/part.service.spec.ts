/**
 * @file src/modules/master/services/part.service.spec.ts
 * @description PartService 단위 테스트
 *
 * 초보자 가이드:
 * - target: 테스트 대상(SUT), mock*: 모킹된 의존성
 * - 실행: `pnpm test -- -t "PartService"`
 */
import { Test, TestingModule } from '@nestjs/testing';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { getRepositoryToken } from '@nestjs/typeorm';
import { NotFoundException, ConflictException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { PartService } from './part.service';
import { ItemMaster } from '../../../entities/item-master.entity';
import { MockLoggerService } from '@test/mock-logger.service';

describe('PartService', () => {
  let target: PartService;
  let mockRepo: DeepMocked<Repository<ItemMaster>>;

  beforeEach(async () => {
    mockRepo = createMock<Repository<ItemMaster>>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PartService,
        { provide: getRepositoryToken(ItemMaster), useValue: mockRepo },
      ],
    })
      .setLogger(new MockLoggerService())
      .compile();

    target = module.get<PartService>(PartService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('findAll', () => {
    it('should apply useYn filter to the query builder', async () => {
      const qb = {
        andWhere: jest.fn().mockReturnThis(),
        orderBy: jest.fn().mockReturnThis(),
        skip: jest.fn().mockReturnThis(),
        take: jest.fn().mockReturnThis(),
        getMany: jest.fn().mockResolvedValue([]),
        getCount: jest.fn().mockResolvedValue(0),
      };
      mockRepo.createQueryBuilder.mockReturnValue(qb as any);

      await target.findAll({
        page: 1,
        limit: 20,
        useYn: 'Y',
      } as any, 1);

      expect(qb.andWhere).toHaveBeenCalledWith('p.useYn = :useYn', { useYn: 'Y' });
    });
  });

  // ─── findById ───
  describe('findById', () => {
    it('should return part when found', async () => {
      // Arrange
      const part = { itemCode: 'ITEM01', itemName: 'Part1' } as ItemMaster;
      mockRepo.findOne.mockResolvedValue(part);

      // Act
      const result = await target.findById('ITEM01');

      // Assert
      expect(result).toEqual(part);
    });

    it('should find part within tenant only', async () => {
      const part = { itemCode: 'ITEM01', itemName: 'Part1', organizationId: 1 } as ItemMaster;
      mockRepo.findOne.mockResolvedValue(part);

      await target.findById('ITEM01', 1);

      expect(mockRepo.findOne).toHaveBeenCalledWith({
        where: { itemCode: 'ITEM01', organizationId: 1 },
      });
    });

    it('should throw NotFoundException when not found', async () => {
      // Arrange
      mockRepo.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(target.findById('ITEM99')).rejects.toThrow(NotFoundException);
    });
  });

  // ─── create ───
  describe('create', () => {
    it('should create a new part', async () => {
      // Arrange
      const dto = {
        itemCode: 'ITEM01',
        itemName: 'Part1',
        itemType: 'RM',
      } as any;
      const created = { ...dto, useYn: 'Y' } as ItemMaster;
      mockRepo.findOne.mockResolvedValue(null);
      mockRepo.create.mockReturnValue(created);
      mockRepo.save.mockResolvedValue(created);

      // Act
      const result = await target.create(dto, 1);

      // Assert
      expect(result).toEqual(created);
      expect(mockRepo.findOne).toHaveBeenCalledWith({
        where: { itemCode: 'ITEM01', organizationId: 1 },
      });
    });

    it('should throw ConflictException when item code exists', async () => {
      // Arrange
      const dto = { itemCode: 'ITEM01', itemName: 'Part1' } as any;
      mockRepo.findOne.mockResolvedValue({ itemCode: 'ITEM01' } as ItemMaster);

      // Act & Assert
      await expect(target.create(dto)).rejects.toThrow(ConflictException);
    });

  });

  // ─── update ───
  describe('update', () => {
    it('should update and return part', async () => {
      // Arrange
      const existing = {
        itemCode: 'ITEM01',
        itemName: 'Old',
      } as ItemMaster;
      mockRepo.findOne.mockResolvedValue(existing);
      mockRepo.update.mockResolvedValue({ affected: 1 } as any);

      // Act
      const result = await target.update('ITEM01', { itemName: 'New' } as any, 1);

      // Assert
      expect(result).toEqual(existing);
      expect(mockRepo.update).toHaveBeenCalledWith(
        { itemCode: 'ITEM01', organizationId: 1 },
        expect.objectContaining({ itemName: 'New' }),
      );
    });

    it('should strip key and tenant columns from update payload', async () => {
      const existing = {
        itemCode: 'ITEM01',
        itemName: 'Old',
        organizationId: 1,
      } as ItemMaster;
      mockRepo.findOne.mockResolvedValue(existing);
      mockRepo.update.mockResolvedValue({ affected: 1 } as any);

      await target.update('ITEM01', {
        itemCode: 'ITEM99',
        itemName: 'New',
        organizationId: 2,
      } as any, 1);

      expect(mockRepo.update).toHaveBeenCalledWith(
        { itemCode: 'ITEM01', organizationId: 1 },
        { itemName: 'New' },
      );
    });

    it('does not pass arbitrary fields from update payload to the repository', async () => {
      const existing = {
        itemCode: 'ITEM01',
        itemName: 'Old',
        organizationId: 1,
      } as ItemMaster;
      mockRepo.findOne.mockResolvedValue(existing);
      mockRepo.update.mockResolvedValue({ affected: 1 } as any);

      await target.update('ITEM01', {
        itemName: 'New',
        externalSource: 'ERP',
      } as any, 1);

      expect(mockRepo.update).toHaveBeenCalledWith(
        { itemCode: 'ITEM01', organizationId: 1 },
        { itemName: 'New' },
      );
    });
  });

  // ─── delete ───
  describe('delete', () => {
    it('should delete and return itemCode', async () => {
      // Arrange
      const existing = { itemCode: 'ITEM01' } as ItemMaster;
      mockRepo.findOne.mockResolvedValue(existing);
      mockRepo.delete.mockResolvedValue({ affected: 1 } as any);

      // Act
      const result = await target.delete('ITEM01', 1);

      // Assert
      expect(result).toEqual({ itemCode: 'ITEM01' });
      expect(mockRepo.delete).toHaveBeenCalledWith({ itemCode: 'ITEM01', organizationId: 1 });
    });
  });

  // ─── findByType ───
  describe('updateImage', () => {
    it('should update imageUrl and return the part', async () => {
      const existing = { itemCode: 'ITEM01', imageUrl: null } as ItemMaster;
      const updated = { itemCode: 'ITEM01', imageUrl: '/uploads/parts/item.png' } as ItemMaster;
      mockRepo.findOne.mockResolvedValueOnce(existing).mockResolvedValueOnce(updated);
      mockRepo.update.mockResolvedValue({ affected: 1 } as any);

      const result = await target.updateImage('ITEM01', '/uploads/parts/item.png', 1);

      expect(mockRepo.update).toHaveBeenCalledWith(
        { itemCode: 'ITEM01', organizationId: 1 },
        { imageUrl: '/uploads/parts/item.png' },
      );
      expect(result).toEqual(updated);
    });
  });

  describe('findByType', () => {
    it('should return active parts of given type', async () => {
      // Arrange
      const parts = [{ itemCode: 'ITEM01', itemType: 'RM' }] as ItemMaster[];
      mockRepo.find.mockResolvedValue(parts);

      // Act
      const result = await target.findByType('RM', 1);

      // Assert
      expect(result).toEqual(parts);
      expect(mockRepo.find).toHaveBeenCalledWith({
        where: { itemType: 'RM', useYn: 'Y', organizationId: 1 },
        order: { itemCode: 'asc' },
      });
    });
  });
});
