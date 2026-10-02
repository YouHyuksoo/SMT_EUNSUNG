/**
 * @file warehouse.service.spec.ts
 * @description WarehouseService 단위 테스트
 */
import { Test, TestingModule } from '@nestjs/testing';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { getRepositoryToken } from '@nestjs/typeorm';
import { NotFoundException, ConflictException } from '@nestjs/common';
import { Repository, DataSource, getMetadataArgsStorage } from 'typeorm';
import { WarehouseService } from './warehouse.service';
import { Warehouse } from '../../../entities/warehouse.entity';
import { WarehouseLocation } from '../../../entities/warehouse-location.entity';
import { MockLoggerService } from '@test/mock-logger.service';

describe('WarehouseService', () => {
  let target: WarehouseService;
  let mockWhRepo: DeepMocked<Repository<Warehouse>>;
  let mockLocRepo: DeepMocked<Repository<WarehouseLocation>>;
  let mockDataSource: DeepMocked<DataSource>;

  beforeEach(async () => {
    mockWhRepo = createMock<Repository<Warehouse>>();
    mockLocRepo = createMock<Repository<WarehouseLocation>>();
    mockDataSource = createMock<DataSource>();
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        WarehouseService,
        { provide: getRepositoryToken(Warehouse), useValue: mockWhRepo },
        { provide: getRepositoryToken(WarehouseLocation), useValue: mockLocRepo },
        { provide: DataSource, useValue: mockDataSource },
      ],
    }).setLogger(new MockLoggerService()).compile();
    target = module.get<WarehouseService>(WarehouseService);
  });
  afterEach(() => jest.clearAllMocks());

  it('includes tenant columns in warehouse primary key metadata', () => {
    const primaryColumnNames = getMetadataArgsStorage()
      .columns
      .filter((column) => column.target === Warehouse && column.options.primary)
      .map((column) => column.propertyName);

    expect(primaryColumnNames).toEqual(expect.arrayContaining(['organizationId', 'warehouseCode']));
  });

  describe('findOne', () => {
    it('should return warehouse', async () => {
      mockWhRepo.findOne.mockResolvedValue({ warehouseCode: 'WH-001' } as any);
      expect((await target.findOne('WH-001')).warehouseCode).toBe('WH-001');
    });
    it('should scope lookup by organizationId', async () => {
      mockWhRepo.findOne.mockResolvedValue({ warehouseCode: 'WH-001', organizationId: 1 } as any);

      await target.findOne('WH-001', 1);

      expect(mockWhRepo.findOne).toHaveBeenCalledWith({
        where: { warehouseCode: 'WH-001', organizationId: 1 },
      });
    });
    it('should throw NotFoundException', async () => {
      mockWhRepo.findOne.mockResolvedValue(null);
      await expect(target.findOne('X')).rejects.toThrow(NotFoundException);
    });
  });

  describe('create', () => {
    it('should create warehouse', async () => {
      mockWhRepo.findOne.mockResolvedValue(null);
      const saved = { warehouseCode: 'WH-001' } as any;
      mockWhRepo.create.mockReturnValue(saved);
      mockWhRepo.save.mockResolvedValue(saved);
      const r = await target.create({ warehouseCode: 'WH-001', warehouseName: 'Test', warehouseType: 'RM' } as any);
      expect(r.warehouseCode).toBe('WH-001');
    });
    it('should persist organizationId from tenant context', async () => {
      mockWhRepo.findOne.mockResolvedValue(null);
      const saved = { warehouseCode: 'WH-001', organizationId: 7 } as any;
      mockWhRepo.create.mockReturnValue(saved);
      mockWhRepo.save.mockResolvedValue(saved);

      const r = await target.create(
        { warehouseCode: 'WH-001', warehouseName: 'Test', warehouseType: 'RM' } as any,
        7,
      );

      expect(r).toBe(saved);
      expect(mockWhRepo.create).toHaveBeenCalledWith(expect.objectContaining({
        warehouseCode: 'WH-001',
        organizationId: 7,
      }));
    });
    it('should keep plantCode null when dto plantCode is omitted (조직으로 기본값을 채우지 않는다)', async () => {
      mockWhRepo.findOne.mockResolvedValue(null);
      const saved = { warehouseCode: 'WH-001', organizationId: 1, plantCode: null } as any;
      mockWhRepo.create.mockReturnValue(saved);
      mockWhRepo.save.mockResolvedValue(saved);

      await target.create(
        { warehouseCode: 'WH-001', warehouseName: 'Test', warehouseType: 'RM' } as any,
        1,
      );

      expect(mockWhRepo.create).toHaveBeenCalledWith(expect.objectContaining({
        plantCode: null,
        organizationId: 1,
      }));
    });
    it('should check duplicate warehouse code within tenant only', async () => {
      mockWhRepo.findOne.mockResolvedValue(null);
      const saved = { warehouseCode: 'WH-001', organizationId: 1 } as any;
      mockWhRepo.create.mockReturnValue(saved);
      mockWhRepo.save.mockResolvedValue(saved);

      await target.create(
        { warehouseCode: 'WH-001', warehouseName: 'Test', warehouseType: 'RM' } as any,
        1,
      );

      expect(mockWhRepo.findOne).toHaveBeenCalledWith({
        where: { warehouseCode: 'WH-001', organizationId: 1 },
      });
    });
    it('should throw ConflictException', async () => {
      mockWhRepo.findOne.mockResolvedValue({ warehouseCode: 'WH-001' } as any);
      await expect(target.create({ warehouseCode: 'WH-001' } as any)).rejects.toThrow(ConflictException);
    });
  });

  describe('update', () => {
    it('should update warehouse within tenant only', async () => {
      mockWhRepo.findOne
        .mockResolvedValueOnce({ warehouseCode: 'WH-001', organizationId: 1 } as any)
        .mockResolvedValueOnce({ warehouseCode: 'WH-001', warehouseName: 'Changed', organizationId: 1 } as any);
      mockWhRepo.update.mockResolvedValue({ affected: 1 } as any);

      await target.update('WH-001', { warehouseName: 'Changed' } as any, 1);

      expect(mockWhRepo.findOne).toHaveBeenNthCalledWith(1, {
        where: { warehouseCode: 'WH-001', organizationId: 1 },
      });
      expect(mockWhRepo.update).toHaveBeenCalledWith(
        { warehouseCode: 'WH-001', organizationId: 1 },
        expect.objectContaining({ warehouseName: 'Changed' }),
      );
      expect(mockWhRepo.findOne).toHaveBeenNthCalledWith(2, {
        where: { warehouseCode: 'WH-001', organizationId: 1 },
      });
    });
  });

  describe('remove', () => {
    it('should throw when stock exists', async () => {
      mockWhRepo.findOne.mockResolvedValue({ warehouseCode: 'WH-001' } as any);
      // 창고 로케이션에 재고가 남아 있으면 삭제할 수 없다
      mockLocRepo.find.mockResolvedValue([{ locationCode: 'L-01' } as WarehouseLocation]);
      mockDataSource.query.mockResolvedValue([{ HAS_STOCK: 1 }]);
      await expect(target.remove('WH-001')).rejects.toThrow(ConflictException);
    });
    it('should remove empty warehouse', async () => {
      mockWhRepo.findOne.mockResolvedValue({ warehouseCode: 'WH-001' } as any);
      // 로케이션이 없으면 재고 조회 없이 삭제한다
      mockLocRepo.find.mockResolvedValue([]);
      mockWhRepo.delete.mockResolvedValue({ affected: 1 } as any);
      const r = await target.remove('WH-001');
      expect(r.deleted).toBe(true);
    });
    it('should check stock and delete warehouse within tenant only', async () => {
      mockWhRepo.findOne.mockResolvedValue({ warehouseCode: 'WH-001', organizationId: 1 } as any);
      mockLocRepo.find.mockResolvedValue([{ locationCode: 'L-01' } as WarehouseLocation]);
      mockDataSource.query.mockResolvedValue([]);
      mockWhRepo.delete.mockResolvedValue({ affected: 1 } as any);

      await target.remove('WH-001', 1);

      expect(mockWhRepo.findOne).toHaveBeenCalledWith({
        where: { warehouseCode: 'WH-001', organizationId: 1 },
      });
      expect(mockLocRepo.find).toHaveBeenCalledWith({
        where: { warehouseCode: 'WH-001', organizationId: 1 },
        select: ['locationCode'],
      });
      // 재고 조회도 같은 조직으로 한정한다 (로케이션 코드 + ORGANIZATION_ID 바인드)
      expect(mockDataSource.query).toHaveBeenCalledWith(
        expect.stringContaining('ORGANIZATION_ID = :2'),
        ['L-01', 1],
      );
      expect(mockWhRepo.delete).toHaveBeenCalledWith({ warehouseCode: 'WH-001', organizationId: 1 });
    });
  });

  describe('findAll', () => {
    it('should return warehouses', async () => {
      mockWhRepo.find.mockResolvedValue([]);
      mockWhRepo.count.mockResolvedValue(0);
      const r = await target.findAll();
      expect(r.data).toEqual([]);
    });
  });

  describe('getOrCreateFloorWarehouse', () => {
    it('should return existing warehouse', async () => {
      mockWhRepo.findOne.mockResolvedValue({ warehouseCode: 'FLOOR_L1_P01' } as any);
      const r = await target.getOrCreateFloorWarehouse('L1', 'P01');
      expect(r.warehouseCode).toBe('FLOOR_L1_P01');
    });
    it('should create new warehouse when not found', async () => {
      mockWhRepo.findOne.mockResolvedValue(null);
      const newWh = { warehouseCode: 'FLOOR_L1_P01' } as any;
      mockWhRepo.create.mockReturnValue(newWh);
      mockWhRepo.save.mockResolvedValue(newWh);
      const r = await target.getOrCreateFloorWarehouse('L1', 'P01');
      expect(r.warehouseCode).toBe('FLOOR_L1_P01');
    });
    it('should find and create floor warehouse within tenant only', async () => {
      mockWhRepo.findOne.mockResolvedValue(null);
      const newWh = { warehouseCode: 'FLOOR_L1_P01', organizationId: 1 } as any;
      mockWhRepo.create.mockReturnValue(newWh);
      mockWhRepo.save.mockResolvedValue(newWh);

      await target.getOrCreateFloorWarehouse('L1', 'P01', 1);

      expect(mockWhRepo.findOne).toHaveBeenCalledWith({
        where: { warehouseCode: 'FLOOR_L1_P01', organizationId: 1 },
      });
      expect(mockWhRepo.create).toHaveBeenCalledWith(expect.objectContaining({
        warehouseCode: 'FLOOR_L1_P01',
        plantCode: null,
        organizationId: 1,
      }));
    });
  });

  describe('initDefaultWarehouses', () => {
    it('should initialize default warehouses within tenant only', async () => {
      mockWhRepo.find.mockResolvedValue([{ warehouseCode: 'RM_MAIN' } as Warehouse]);
      mockWhRepo.create.mockImplementation((payload) => payload as Warehouse);
      mockWhRepo.save.mockResolvedValue([] as any);

      await target.initDefaultWarehouses(1);

      expect(mockWhRepo.find).toHaveBeenCalledWith({
        where: expect.arrayContaining([
          { warehouseCode: 'RM_MAIN', organizationId: 1 },
        ]),
        select: ['warehouseCode'],
      });
      expect(mockWhRepo.create).toHaveBeenCalledWith(expect.objectContaining({
        warehouseCode: 'RM_SUB',
        plantCode: null,
        organizationId: 1,
      }));
    });
  });

  describe('getDefaultWarehouse', () => {
    it('should lookup default warehouse within tenant only', async () => {
      mockWhRepo.findOne.mockResolvedValue({ warehouseCode: 'RM_MAIN' } as any);

      await target.getDefaultWarehouse('RM', 1);

      expect(mockWhRepo.findOne).toHaveBeenCalledWith({
        where: { warehouseType: 'RM', isDefault: 'Y', useYn: 'Y', organizationId: 1 },
      });
    });
  });
});
