/**
 * @file src/modules/system/services/sys-config.service.spec.ts
 * @description SysConfigService 단위 테스트
 *
 * 초보자 가이드:
 * - target: 테스트 대상(SUT), mock*: 모킹된 의존성
 * - 실행: `pnpm test -- -t "SysConfigService"`
 */
import { Test, TestingModule } from '@nestjs/testing';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { getRepositoryToken } from '@nestjs/typeorm';
import { NotFoundException, ConflictException, BadRequestException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { SysConfigService } from './sys-config.service';
import { SysConfig } from '../../../entities/sys-config.entity';
import { MockLoggerService } from '@test/mock-logger.service';

describe('SysConfigService', () => {
  let target: SysConfigService;
  let mockRepo: DeepMocked<Repository<SysConfig>>;

  beforeEach(async () => {
    mockRepo = createMock<Repository<SysConfig>>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SysConfigService,
        { provide: getRepositoryToken(SysConfig), useValue: mockRepo },
      ],
    })
      .setLogger(new MockLoggerService())
      .compile();

    target = module.get<SysConfigService>(SysConfigService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  // ─── findAll ───
  describe('findAll', () => {
    it('should return grouped configs', async () => {
      // Arrange
      const configs = [
        { configKey: 'ALLOW_WH_MINUS_INVENTORY', configDescription: 'Minus inventory', configValue: 'Y', isActive: 'Y', organizationId: 1 },
        { configKey: 'CURRENCY', configDescription: 'Currency', configValue: 'KRW', isActive: 'Y', organizationId: 1 },
      ] as SysConfig[];
      mockRepo.find.mockResolvedValue(configs);

      // Act
      const result = await target.findAll({} as any);

      // Assert
      expect(result.total).toBe(2);
      expect(result.grouped['MATERIAL']).toHaveLength(1);
      expect(result.grouped['SYSTEM']).toHaveLength(1);
    });

    it('should filter by search term', async () => {
      // Arrange
      const configs = [
        { configKey: 'ENABLE_LOG', configDescription: 'Enable Log', configValueDescription: null, configValue: 'Y', organizationId: 1 },
        { configKey: 'OTHER', configDescription: 'Other', configValueDescription: null, configValue: 'N', organizationId: 1 },
      ] as SysConfig[];
      mockRepo.find.mockResolvedValue(configs);

      // Act
      const result = await target.findAll({ search: 'log' } as any);

      // Assert
      expect(result.total).toBe(1);
    });

    it('should filter inferred config group in memory', async () => {
      mockRepo.find.mockResolvedValue([
        { configKey: 'AI_ENABLED', configValue: 'Y', organizationId: 1 },
        { configKey: 'CURRENCY', configValue: 'KRW', organizationId: 1 },
      ] as SysConfig[]);

      const result = await target.findAll({ configGroup: 'AI' } as any);

      expect(mockRepo.find).toHaveBeenCalledWith({
        where: {},
        order: { configKey: 'ASC' },
      });
      expect(result.data).toHaveLength(1);
      expect(result.data[0].configKey).toBe('AI_ENABLED');
    });
  });

  // ─── findAllActive ───
  describe('findAllActive', () => {
    it('should return active configs as key-value map', async () => {
      // Arrange
      const configs = [
        { configKey: 'KEY1', configValue: 'VAL1', isActive: 'Y' },
        { configKey: 'KEY2', configValue: 'VAL2', isActive: 'Y' },
      ] as SysConfig[];
      mockRepo.find.mockResolvedValue(configs);

      // Act
      const result = await target.findAllActive();

      // Assert
      expect(result.map).toEqual({ KEY1: 'VAL1', KEY2: 'VAL2' });
      expect(result.data).toEqual(expect.arrayContaining([
        expect.objectContaining({ configKey: 'KEY1', configValue: 'VAL1' }),
        expect.objectContaining({ configKey: 'KEY2', configValue: 'VAL2' }),
      ]));
    });
  });

  // ─── getValue ───
  describe('getValue', () => {
    it('should return config value when found', async () => {
      // Arrange
      mockRepo.findOne.mockResolvedValue({ configKey: 'KEY', configValue: 'VALUE' } as SysConfig);

      // Act
      const result = await target.getValue('KEY');

      // Assert
      expect(result).toBe('VALUE');
    });

    it('should return null when config not found', async () => {
      // Arrange
      mockRepo.findOne.mockResolvedValue(null);

      // Act
      const result = await target.getValue('NONE');

      // Assert
      expect(result).toBeNull();
    });
  });

  // ─── isEnabled ───
  describe('isEnabled', () => {
    it('should return true when value is Y', async () => {
      // Arrange
      mockRepo.findOne.mockResolvedValue({ configKey: 'KEY', configValue: 'Y' } as SysConfig);

      // Act
      const result = await target.isEnabled('KEY');

      // Assert
      expect(result).toBe(true);
    });

    it('should return false when value is not Y', async () => {
      // Arrange
      mockRepo.findOne.mockResolvedValue({ configKey: 'KEY', configValue: 'N' } as SysConfig);

      // Act
      const result = await target.isEnabled('KEY');

      // Assert
      expect(result).toBe(false);
    });

    it('should return false when config not found', async () => {
      // Arrange
      mockRepo.findOne.mockResolvedValue(null);

      // Act
      const result = await target.isEnabled('NONE');

      // Assert
      expect(result).toBe(false);
    });
  });

  // ─── create ───
  describe('create', () => {
    it('should create a new config', async () => {
      // Arrange
      const dto = { configGroup: 'G1', configKey: 'NEW' } as any;
      mockRepo.findOne.mockResolvedValue(null);
      const created = {
        configKey: 'NEW',
        configValue: undefined,
        configDescription: undefined,
        configValueDescription: null,
        isActive: 'Y',
        organizationId: 1,
      } as SysConfig;
      mockRepo.create.mockReturnValue(created);
      mockRepo.save.mockResolvedValue(created);

      // Act
      const result = await target.create(dto, 1);

      // Assert
      expect(result).toEqual(expect.objectContaining({ configKey: 'NEW', organizationId: 1 }));
      expect(mockRepo.findOne).toHaveBeenCalledWith({
        where: { configKey: 'NEW', organizationId: 1 },
      });
      expect(mockRepo.create).toHaveBeenCalledWith(expect.objectContaining({
        configKey: 'NEW',
        organizationId: 1,
      }));
    });

    it('should throw ConflictException when config exists', async () => {
      // Arrange
      mockRepo.findOne.mockResolvedValue({ configKey: 'EXISTING' } as SysConfig);

      // Act & Assert
      await expect(target.create({ configGroup: 'G1', configKey: 'EXISTING' } as any)).rejects.toThrow(ConflictException);
    });
  });

  // ─── update ───
  describe('update', () => {
    it('should update config', async () => {
      // Arrange
      const existing = { configKey: 'KEY', organizationId: 1, configValue: 'OLD' } as SysConfig;
      const updated = { ...existing, configValue: 'NEW_VAL' } as SysConfig;
      mockRepo.findOne.mockResolvedValueOnce(existing).mockResolvedValueOnce(updated);
      mockRepo.update.mockResolvedValue({ affected: 1 } as any);

      // Act
      const result = await target.update('KEY', { configValue: 'NEW_VAL' } as any, 1);

      // Assert
      expect(result).toEqual(expect.objectContaining({ configKey: 'KEY', configValue: 'NEW_VAL' }));
      expect(mockRepo.update).toHaveBeenCalledWith(
        { configKey: 'KEY', organizationId: 1 },
        expect.objectContaining({ configValue: 'NEW_VAL' }),
      );
    });

    it('should throw NotFoundException when config not found', async () => {
      // Arrange
      mockRepo.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(target.update('NONE', {} as any)).rejects.toThrow(NotFoundException);
    });

    it('rejects update when config belongs to a different tenant', async () => {
      const existing = { configKey: 'KEY', organizationId: 2 } as SysConfig;
      mockRepo.findOne.mockResolvedValue(existing);

      await expect(
        target.update('KEY', { configValue: 'NEW_VAL' } as any, 1),
      ).rejects.toThrow(BadRequestException);
      expect(mockRepo.update).not.toHaveBeenCalled();
    });
  });

  // ─── bulkUpdate ───
  describe('bulkUpdate', () => {
    it('should update multiple configs', async () => {
      // Arrange
      const config = { configKey: 'K1', configValue: 'V1', organizationId: 1 } as SysConfig;
      mockRepo.update.mockResolvedValue({ affected: 1 } as any);
      mockRepo.findOne.mockResolvedValue(config);

      // Act
      const result = await target.bulkUpdate({
        items: [{ id: 'K1', configValue: 'NEW_V1' }],
      } as any, 1);

      // Assert
      expect(result).toHaveLength(1);
      expect(mockRepo.update).toHaveBeenCalledWith(
        { configKey: 'K1', organizationId: 1 },
        expect.objectContaining({ configValue: 'NEW_V1' }),
      );
    });
  });

  // ─── remove ───
  describe('remove', () => {
    it('should delete config and return result', async () => {
      // Arrange
      mockRepo.findOne.mockResolvedValue({ configKey: 'KEY', organizationId: 1 } as SysConfig);
      mockRepo.delete.mockResolvedValue({ affected: 1 } as any);

      // Act
      const result = await target.remove('KEY', 1);

      // Assert
      expect(result).toEqual({ id: 'KEY', deleted: true });
      expect(mockRepo.delete).toHaveBeenCalledWith({
        configKey: 'KEY',
        organizationId: 1,
      });
    });

    it('rejects remove when config belongs to a different tenant', async () => {
      mockRepo.findOne.mockResolvedValue({ configKey: 'KEY', organizationId: 2 } as SysConfig);

      await expect(target.remove('KEY', 1)).rejects.toThrow(BadRequestException);
      expect(mockRepo.delete).not.toHaveBeenCalled();
    });

    it('should throw NotFoundException when config not found', async () => {
      // Arrange
      mockRepo.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(target.remove('NONE')).rejects.toThrow(NotFoundException);
    });
  });
});
