/**
 * @file src/modules/master/services/plant.service.spec.ts
 * @description PlantService 단위 테스트
 *
 * 초보자 가이드:
 * - target: 테스트 대상(SUT), mock*: 모킹된 의존성
 * - 실행: `pnpm test -- -t "PlantService"`
 */
import { Test, TestingModule } from '@nestjs/testing';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { getRepositoryToken } from '@nestjs/typeorm';
import { BadRequestException, NotFoundException, ConflictException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { PlantService } from './plant.service';
import { Plant } from '../../../entities/plant.entity';
import { MockLoggerService } from '@test/mock-logger.service';

describe('PlantService', () => {
  let target: PlantService;
  let mockRepo: DeepMocked<Repository<Plant>>;

  const tenant = { company: 'EUNSUNG', plantCd: '1' };
  const cellKey = {
    plantCode: 'EUNSUNG',
    shopCode: '2F',
    lineCode: 'PROD2',
    cellCode: '50',
  };

  beforeEach(async () => {
    mockRepo = createMock<Repository<Plant>>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PlantService,
        { provide: getRepositoryToken(Plant), useValue: mockRepo },
      ],
    })
      .setLogger(new MockLoggerService())
      .compile();

    target = module.get<PlantService>(PlantService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  // ─── findAll ───
  describe('findAll', () => {
    it('always scopes the query and sorts by sort order then hierarchy key', async () => {
      const queryBuilder = {
        where: jest.fn().mockReturnThis(),
        andWhere: jest.fn().mockReturnThis(),
        orderBy: jest.fn().mockReturnThis(),
        addOrderBy: jest.fn().mockReturnThis(),
        skip: jest.fn().mockReturnThis(),
        take: jest.fn().mockReturnThis(),
        getMany: jest.fn().mockResolvedValue([]),
        getCount: jest.fn().mockResolvedValue(0),
      };
      mockRepo.createQueryBuilder.mockReturnValue(queryBuilder as never);

      await target.findAll({ page: 1, limit: 10 } as any, tenant.company, tenant.plantCd);

      expect(queryBuilder.where).toHaveBeenCalledWith('plant.company = :company', {
        company: tenant.company,
      });
      expect(queryBuilder.andWhere).toHaveBeenCalledWith('plant.plantCd = :plantCd', {
        plantCd: tenant.plantCd,
      });
      expect(queryBuilder.orderBy).toHaveBeenCalledWith('plant.sortOrder', 'ASC');
      expect(queryBuilder.addOrderBy).toHaveBeenNthCalledWith(1, 'plant.plantCode', 'ASC');
      expect(queryBuilder.addOrderBy).toHaveBeenNthCalledWith(2, 'plant.shopCode', 'ASC');
      expect(queryBuilder.addOrderBy).toHaveBeenNthCalledWith(3, 'plant.lineCode', 'ASC');
      expect(queryBuilder.addOrderBy).toHaveBeenNthCalledWith(4, 'plant.cellCode', 'ASC');
    });
  });

  // ─── findById ───
  describe('findById', () => {
    it('should return plant when found with composite key', async () => {
      // Arrange
      const plant = { ...cellKey } as Plant;
      mockRepo.findOne.mockResolvedValue(plant);

      // Act
      const result = await target.findById(
        cellKey.plantCode,
        cellKey.shopCode,
        cellKey.lineCode,
        cellKey.cellCode,
        tenant.company,
        tenant.plantCd,
      );

      // Assert
      expect(result).toEqual(plant);
      expect(mockRepo.findOne).toHaveBeenCalledWith({
        where: { ...cellKey, ...tenant },
      });
    });

    it('should throw NotFoundException when not found', async () => {
      // Arrange
      mockRepo.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(
        target.findById('EUNSUNG', '-', '-', '-', tenant.company, tenant.plantCd),
      ).rejects.toThrow(NotFoundException);
    });

    it('requires both tenant values before querying', async () => {
      await expect(
        target.findById('EUNSUNG', '-', '-', '-', '', tenant.plantCd),
      ).rejects.toThrow(BadRequestException);
      expect(mockRepo.findOne).not.toHaveBeenCalled();
    });
  });

  // ─── findHierarchy ───
  describe('findHierarchy', () => {
    it('should return all tenant plants when no plantCode given', async () => {
      // Arrange
      const plants = [{ plantCode: 'PL01' }] as Plant[];
      mockRepo.find.mockResolvedValue(plants);

      // Act
      const result = await target.findHierarchy(undefined, tenant.company, tenant.plantCd);

      // Assert
      expect(result).toEqual(plants);
      expect(mockRepo.find).toHaveBeenCalledWith({
        where: tenant,
        order: {
          sortOrder: 'ASC',
          plantCode: 'ASC',
          shopCode: 'ASC',
          lineCode: 'ASC',
          cellCode: 'ASC',
        },
      });
    });

    it('should filter by plantCode when given', async () => {
      // Arrange
      mockRepo.find.mockResolvedValue([]);

      // Act
      await target.findHierarchy('EUNSUNG', tenant.company, tenant.plantCd);

      // Assert
      expect(mockRepo.find).toHaveBeenCalledWith({
        where: { plantCode: 'EUNSUNG', ...tenant },
        order: {
          sortOrder: 'ASC',
          plantCode: 'ASC',
          shopCode: 'ASC',
          lineCode: 'ASC',
          cellCode: 'ASC',
        },
      });
    });
  });

  // ─── create ───
  describe('create', () => {
    it('should create a new plant', async () => {
      // Arrange
      const dto = { ...cellKey, plantName: 'CELL 50' } as any;
      const created = { ...dto, ...tenant, useYn: 'Y' } as Plant;
      mockRepo.findOne.mockResolvedValue(null);
      mockRepo.create.mockReturnValue(created);
      mockRepo.save.mockResolvedValue(created);

      // Act
      const result = await target.create(dto, tenant.company, tenant.plantCd);

      // Assert
      expect(result).toEqual(created);
      expect(mockRepo.findOne).toHaveBeenCalledWith({
        where: { ...cellKey, ...tenant },
      });
      expect(mockRepo.create).toHaveBeenCalledWith(expect.objectContaining({
        ...cellKey,
        ...tenant,
      }));
    });

    it('should throw ConflictException when plant exists', async () => {
      // Arrange
      const dto = { ...cellKey, plantName: 'CELL 50' } as any;
      mockRepo.findOne.mockResolvedValue({ plantCode: 'PL01' } as Plant);

      // Act & Assert
      await expect(target.create(dto, tenant.company, tenant.plantCd)).rejects.toThrow(ConflictException);
    });
  });

  // ─── update ───
  describe('update', () => {
    it('should update and return plant', async () => {
      // Arrange
      const existing = { ...cellKey } as Plant;
      mockRepo.findOne.mockResolvedValue(existing);
      mockRepo.update.mockResolvedValue({ affected: 1 } as any);

      // Act
      const result = await target.update(
        cellKey.plantCode,
        { plantName: 'Updated' } as any,
        cellKey.shopCode,
        cellKey.lineCode,
        cellKey.cellCode,
        tenant.company,
        tenant.plantCd,
      );

      // Assert
      expect(result).toEqual(existing);
      expect(mockRepo.update).toHaveBeenCalledWith(
        { ...cellKey, ...tenant },
        { plantName: 'Updated' },
      );
    });

    it('updates a CELL by the complete composite key without changing identifiers', async () => {
      const existing = { ...cellKey } as Plant;
      mockRepo.findOne.mockResolvedValue(existing);
      mockRepo.update.mockResolvedValue({ affected: 1 } as any);

      await target.update(
        cellKey.plantCode,
        { plantName: 'CMA', plantType: 'CELL', sortOrder: 50, useYn: 'Y' },
        cellKey.shopCode,
        cellKey.lineCode,
        cellKey.cellCode,
        tenant.company,
        tenant.plantCd,
      );

      expect(mockRepo.update).toHaveBeenCalledWith(
        { ...cellKey, ...tenant },
        { plantName: 'CMA', plantType: 'CELL', sortOrder: 50, useYn: 'Y' },
      );
    });
  });

  // ─── delete ───
  describe('delete', () => {
    it('should delete and return composite key', async () => {
      // Arrange
      const existing = { ...cellKey } as Plant;
      mockRepo.findOne.mockResolvedValue(existing);
      mockRepo.delete.mockResolvedValue({ affected: 1 } as any);

      // Act
      const result = await target.delete(
        cellKey.plantCode,
        cellKey.shopCode,
        cellKey.lineCode,
        cellKey.cellCode,
        tenant.company,
        tenant.plantCd,
      );

      // Assert
      expect(result).toEqual(cellKey);
      expect(mockRepo.delete).toHaveBeenCalledWith({ ...cellKey, ...tenant });
    });
  });

  // ─── findByType ───
  describe('findByType', () => {
    it('should return active plants of given type', async () => {
      // Arrange
      const plants = [{ plantCode: 'EUNSUNG', plantType: 'PLANT' }] as Plant[];
      mockRepo.find.mockResolvedValue(plants);

      // Act
      const result = await target.findByType('PLANT', tenant.company, tenant.plantCd);

      // Assert
      expect(result).toEqual(plants);
      expect(mockRepo.find).toHaveBeenCalledWith({
        where: { plantType: 'PLANT', useYn: 'Y', ...tenant },
        order: {
          sortOrder: 'ASC',
          plantCode: 'ASC',
          shopCode: 'ASC',
          lineCode: 'ASC',
          cellCode: 'ASC',
        },
      });
    });
  });
});
