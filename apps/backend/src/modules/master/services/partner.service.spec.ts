/**
 * @file src/modules/master/services/partner.service.spec.ts
 * @description PartnerService 단위 테스트
 *
 * 초보자 가이드:
 * - target: 테스트 대상(SUT), mock*: 모킹된 의존성
 * - 실행: `pnpm test -- -t "PartnerService"`
 */
import { Test, TestingModule } from '@nestjs/testing';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { getRepositoryToken } from '@nestjs/typeorm';
import { NotFoundException, ConflictException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { PartnerService } from './partner.service';
import { SupplierMaster } from '../../../entities/supplier-master.entity';
import { MockLoggerService } from '@test/mock-logger.service';

describe('PartnerService', () => {
  let target: PartnerService;
  let mockRepo: DeepMocked<Repository<SupplierMaster>>;

  beforeEach(async () => {
    mockRepo = createMock<Repository<SupplierMaster>>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PartnerService,
        { provide: getRepositoryToken(SupplierMaster), useValue: mockRepo },
      ],
    })
      .setLogger(new MockLoggerService())
      .compile();

    target = module.get<PartnerService>(PartnerService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('maps ICOM_SUPPLIER columns to the existing partner API contract', async () => {
    mockRepo.findOne.mockResolvedValue({
      supplierCode: 'SUP01',
      supplierName: '공급사',
      organizationId: 1,
      businessNo: '123',
      ownerName: '대표',
      telNo: '02-1234',
      businessStatus: 'A',
    } as SupplierMaster);

    await expect(target.findById('SUP01', 1)).resolves.toEqual(expect.objectContaining({
      partnerCode: 'SUP01',
      partnerName: '공급사',
      partnerType: 'SUPPLIER',
      bizNo: '123',
      ceoName: '대표',
      tel: '02-1234',
      useYn: 'Y',
    }));
    expect(mockRepo.findOne).toHaveBeenCalledWith({
      where: { supplierCode: 'SUP01', organizationId: 1 },
    });
  });

  // ─── findById ───
  describe('findById', () => {
    it('should return partner when found', async () => {
      // Arrange
      const partner = { supplierCode: 'P01', supplierName: 'Vendor1', businessStatus: 'A' } as SupplierMaster;
      mockRepo.findOne.mockResolvedValue(partner);

      // Act
      const result = await target.findById('P01', 1);

      // Assert
      expect(result).toEqual(expect.objectContaining({ partnerCode: 'P01', partnerName: 'Vendor1' }));
      expect(mockRepo.findOne).toHaveBeenCalledWith({
        where: { supplierCode: 'P01', organizationId: 1 },
      });
    });

    it('should throw NotFoundException when not found', async () => {
      // Arrange
      mockRepo.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(target.findById('P99')).rejects.toThrow(NotFoundException);
    });
  });

  // ─── create ───
  describe('create', () => {
    it('should create a new partner', async () => {
      // Arrange
      const dto = { partnerCode: 'P01', partnerName: 'Vendor1', partnerType: 'SUPPLIER' } as any;
      const created = { supplierCode: 'P01', supplierName: 'Vendor1', businessStatus: 'A' } as SupplierMaster;
      mockRepo.findOne.mockResolvedValue(null);
      mockRepo.create.mockReturnValue(created);
      mockRepo.save.mockResolvedValue(created);

      // Act
      const result = await target.create(dto, 1);

      // Assert
      expect(result).toEqual(expect.objectContaining({ partnerCode: 'P01', partnerName: 'Vendor1' }));
      expect(mockRepo.findOne).toHaveBeenCalledWith({
        where: { supplierCode: 'P01', organizationId: 1 },
      });
      expect(mockRepo.create).toHaveBeenCalledWith(expect.objectContaining({
        organizationId: 1,
      }));
    });

    it('should throw ConflictException when partner code exists', async () => {
      // Arrange
      const dto = { partnerCode: 'P01', partnerName: 'Vendor1' } as any;
      mockRepo.findOne.mockResolvedValue({ supplierCode: 'P01' } as SupplierMaster);

      // Act & Assert
      await expect(target.create(dto)).rejects.toThrow(ConflictException);
    });
  });

  // ─── update ───
  describe('update', () => {
    it('should update and return partner', async () => {
      // Arrange
      const existing = { supplierCode: 'P01', supplierName: 'Old' } as SupplierMaster;
      mockRepo.findOne.mockResolvedValue(existing);
      mockRepo.update.mockResolvedValue({ affected: 1 } as any);

      // Act
      const result = await target.update('P01', { partnerName: 'New' } as any, 1);

      // Assert
      expect(result).toEqual(expect.objectContaining({ partnerCode: 'P01', partnerName: 'Old' }));
      expect(mockRepo.update).toHaveBeenCalledWith(
        { supplierCode: 'P01', organizationId: 1 },
        expect.objectContaining({ supplierName: 'New' }),
      );
    });

    it('should strip key and tenant columns from update payload', async () => {
      const existing = { supplierCode: 'P01', supplierName: 'Old', organizationId: 1 } as SupplierMaster;
      mockRepo.findOne.mockResolvedValue(existing);
      mockRepo.update.mockResolvedValue({ affected: 1 } as any);

      await target.update('P01', {
        partnerCode: 'P99',
        partnerName: 'New',
        organizationId: 2,
      } as any, 1);

      expect(mockRepo.update).toHaveBeenCalledWith(
        { supplierCode: 'P01', organizationId: 1 },
        expect.objectContaining({ supplierName: 'New' }),
      );
    });

    it('does not pass arbitrary fields from update payload to the repository', async () => {
      const existing = { supplierCode: 'P01', supplierName: 'Old', organizationId: 1 } as SupplierMaster;
      mockRepo.findOne.mockResolvedValue(existing);
      mockRepo.update.mockResolvedValue({ affected: 1 } as any);

      await target.update('P01', {
        partnerName: 'New',
        externalSource: 'ERP',
      } as any, 1);

      expect(mockRepo.update).toHaveBeenCalledWith(
        { supplierCode: 'P01', organizationId: 1 },
        expect.objectContaining({ supplierName: 'New' }),
      );
    });
  });

  // ─── delete ───
  describe('delete', () => {
    it('should delete and return partnerCode', async () => {
      // Arrange
      const existing = { supplierCode: 'P01' } as SupplierMaster;
      mockRepo.findOne.mockResolvedValue(existing);
      mockRepo.delete.mockResolvedValue({ affected: 1 } as any);

      // Act
      const result = await target.delete('P01', 1);

      // Assert
      expect(result).toEqual({ partnerCode: 'P01' });
      expect(mockRepo.delete).toHaveBeenCalledWith({ supplierCode: 'P01', organizationId: 1 });
    });
  });

  // ─── findByType ───
  describe('findByType', () => {
    it('should return active partners of given type', async () => {
      // Arrange
      const partners = [{ supplierCode: 'P01', supplierName: 'Vendor1', businessStatus: 'A' }] as SupplierMaster[];
      mockRepo.find.mockResolvedValue(partners);

      // Act
      const result = await target.findByType('SUPPLIER', 1);

      // Assert
      expect(result).toEqual([expect.objectContaining({ partnerCode: 'P01', partnerType: 'SUPPLIER' })]);
      expect(mockRepo.find).toHaveBeenCalledWith({
        where: { businessStatus: 'A', organizationId: 1 },
        order: { supplierCode: 'asc' },
      });
    });
  });

  // ─── getStatistics ───
  describe('getStatistics', () => {
    it('should return count statistics', async () => {
      // Arrange
      const qb = createMock<any>();
      qb.select.mockReturnThis();
      qb.addSelect.mockReturnThis();
      qb.getRawOne.mockResolvedValue({
        totalCount: '100',
        supplierCount: '60',
        customerCount: '30',
        activeCount: '80',
      });
      mockRepo.createQueryBuilder.mockReturnValue(qb);

      // Act
      const result = await target.getStatistics(1);

      // Assert
      expect(qb.andWhere).toHaveBeenCalledWith('supplier.organizationId = :organizationId', { organizationId: 1 });
      expect(result).toEqual({
        totalCount: 100,
        supplierCount: 100,
        customerCount: 0,
        activeCount: 80,
      });
    });
  });
});
