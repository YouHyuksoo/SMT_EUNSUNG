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
import { NotFoundException, ConflictException, BadRequestException } from '@nestjs/common';
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
    it('should apply mesDisplayYn filter to the query builder', async () => {
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
        mesDisplayYn: 'Y',
      } as any, 1);

      expect(qb.andWhere).toHaveBeenCalledWith('p.mesDisplayYn = :mesDisplayYn', { mesDisplayYn: 'Y' });
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
        lineType: 'G',
        itemDivision: 'R',
      } as any;
      const created = { ...dto } as ItemMaster;
      mockRepo.findOne.mockResolvedValue(null);
      mockRepo.create.mockReturnValue(created);
      mockRepo.save.mockResolvedValue(created);

      // Act
      const result = await target.create(dto, 1, 'USER1');

      // Assert
      expect(result).toEqual(created);
      expect(mockRepo.findOne).toHaveBeenCalledWith({
        where: { itemCode: 'ITEM01', organizationId: 1 },
      });
      // 품목구분은 보낸 값 그대로(예전에는 품목유형을 넣었다), 비운 NOT NULL 칸은 등록 기본값
      expect(mockRepo.create).toHaveBeenCalledWith(expect.objectContaining({
        itemDivision: 'R', lineType: 'G', itemType: 'T', isSplittable: 'N', rev: 'C',
        spec: '*', itemUom: 'EA', routeNo: '*', organizationId: 1, createdBy: 'USER1',
        dateend: new Date('9999-12-31T00:00:00+09:00'),
      }));
    });

    it('rejects create without a NOT NULL column that has no default', async () => {
      mockRepo.findOne.mockResolvedValue(null);
      await expect(target.create({ itemCode: 'ITEM01', itemName: 'P', lineType: 'G' } as any, 1))
        .rejects.toThrow(BadRequestException);
      expect(mockRepo.save).not.toHaveBeenCalled();
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

      const payload = mockRepo.update.mock.calls[0][1] as Record<string, unknown>;
      expect(Object.keys(payload).sort()).toEqual(['itemName', 'updatedAt', 'updatedBy']);
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

      const payload = mockRepo.update.mock.calls[0][1] as Record<string, unknown>;
      expect(Object.keys(payload).sort()).toEqual(['itemName', 'updatedAt', 'updatedBy']);
    });

    // 트리거(TRG_ID_ITEM_UPD)는 SET 에 들어가기만 해도 돈다 — 안 바뀐 컬럼은 SET 하지 않는다
    it('sets only columns whose value changed', async () => {
      const existing = {
        itemCode: 'ITEM01', itemName: 'Old', lineType: 'G', supplierCode: 'IP', customerCode: null,
        safetyStock: 10, dateset: new Date('2020-12-31T00:00:00+09:00'), organizationId: 1,
      } as unknown as ItemMaster;
      mockRepo.findOne.mockResolvedValue(existing);
      mockRepo.update.mockResolvedValue({ affected: 1 } as any);

      await target.update('ITEM01', {
        itemName: 'Old', lineType: 'G', supplierCode: 'IP', customerCode: '',
        safetyStock: 10, dateset: '2020-12-31', itemType: 'S',
      } as any, 1);

      const payload = mockRepo.update.mock.calls[0][1] as Record<string, unknown>;
      expect(Object.keys(payload).sort()).toEqual(['itemType', 'updatedAt', 'updatedBy']);
    });

    it('does not update when nothing changed', async () => {
      mockRepo.findOne.mockResolvedValue({ itemCode: 'ITEM01', itemName: 'Same', organizationId: 1 } as ItemMaster);
      await target.update('ITEM01', { itemName: 'Same' } as any, 1);
      expect(mockRepo.update).not.toHaveBeenCalled();
    });

    it('rejects clearing a NOT NULL column', async () => {
      mockRepo.findOne.mockResolvedValue({ itemCode: 'ITEM01', itemName: 'Old', organizationId: 1 } as ItemMaster);
      await expect(target.update('ITEM01', { itemDivision: '' } as any, 1)).rejects.toThrow(BadRequestException);
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
  describe('findByType', () => {
    it('should return active parts of given type', async () => {
      // Arrange
      const parts = [{ itemCode: 'ITEM01', itemType: 'T' }] as ItemMaster[];
      mockRepo.find.mockResolvedValue(parts);

      // Act
      const result = await target.findByType('T', 1);

      // Assert
      expect(result).toEqual(parts);
      expect(mockRepo.find).toHaveBeenCalledWith({
        where: { itemType: 'T', mesDisplayYn: 'Y', organizationId: 1 },
        order: { itemCode: 'asc' },
      });
    });
  });
});
