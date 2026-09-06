import { Test, TestingModule } from '@nestjs/testing';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { getRepositoryToken } from '@nestjs/typeorm';
import { BadRequestException, ConflictException, NotFoundException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { ProdLineMaster } from '../../../entities/prod-line-master.entity';
import { MockLoggerService } from '@test/mock-logger.service';
import { ProdLineService } from './prod-line.service';

describe('ProdLineService', () => {
  let target: ProdLineService;
  let mockRepo: DeepMocked<Repository<ProdLineMaster>>;

  beforeEach(async () => {
    mockRepo = createMock<Repository<ProdLineMaster>>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProdLineService,
        { provide: getRepositoryToken(ProdLineMaster), useValue: mockRepo },
      ],
    })
      .setLogger(new MockLoggerService())
      .compile();

    target = module.get<ProdLineService>(ProdLineService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('finds production line within tenant only', async () => {
    const line = { lineCode: 'L01', lineName: 'Line 1', organizationId: 1 } as ProdLineMaster;
    mockRepo.findOne.mockResolvedValue(line);

    const result = await target.findById('L01', 1);

    expect(result).toEqual(line);
    expect(mockRepo.findOne).toHaveBeenCalledWith({
      where: { lineCode: 'L01', organizationId: 1 },
    });
  });

  it('throws NotFoundException when tenant scoped production line is missing', async () => {
    mockRepo.findOne.mockResolvedValue(null);

    await expect(target.findById('L99', 1)).rejects.toThrow(NotFoundException);
  });

  it('creates production line within tenant only', async () => {
    const dto = { lineCode: 'L01', lineName: 'Line 1', lineDivision: 'L' } as any;
    const created = { ...dto, organizationId: 1, lineProductDivision: 'FIXED' } as ProdLineMaster;
    mockRepo.findOne.mockResolvedValue(null);
    mockRepo.create.mockReturnValue(created);
    mockRepo.save.mockResolvedValue(created);

    const result = await target.create(dto, 1);

    expect(result).toEqual(created);
    expect(mockRepo.findOne).toHaveBeenCalledWith({
      where: { lineCode: 'L01', organizationId: 1 },
    });
    expect(mockRepo.create).toHaveBeenCalledWith(expect.objectContaining({
      lineCode: 'L01',
      organizationId: 1,
      processCode: 'SMT',
      resourceType: 'LINE',
      parentLineCode: 'L01',
    }));
  });

  it('normalizes a LINE parent to its own line code', async () => {
    mockRepo.findOne.mockResolvedValue(null);
    mockRepo.create.mockImplementation((value) => value as ProdLineMaster);
    mockRepo.save.mockImplementation(async (value) => value as ProdLineMaster);

    await target.create({
      lineCode: 'L01', lineName: 'Line 1', lineDivision: 'L',
      processCode: 'ASSY', resourceType: 'LINE', parentLineCode: 'L99',
    }, 1);

    expect(mockRepo.create).toHaveBeenCalledWith(expect.objectContaining({
      processCode: 'ASSY', resourceType: 'LINE', parentLineCode: 'L01',
    }));
  });

  it('accepts a tenant-scoped different parent for CELL', async () => {
    mockRepo.findOne
      .mockResolvedValueOnce(null)
      .mockResolvedValueOnce({ lineCode: 'L02', organizationId: 1 } as ProdLineMaster);
    mockRepo.create.mockImplementation((value) => value as ProdLineMaster);
    mockRepo.save.mockImplementation(async (value) => value as ProdLineMaster);

    await target.create({
      lineCode: 'C01', lineName: 'Cell 1', lineDivision: 'L',
      resourceType: 'CELL', parentLineCode: 'L02',
    }, 1);

    expect(mockRepo.findOne).toHaveBeenNthCalledWith(2, {
      where: { lineCode: 'L02', organizationId: 1 },
    });
    expect(mockRepo.create).toHaveBeenCalledWith(expect.objectContaining({
      resourceType: 'CELL', parentLineCode: 'L02',
    }));
  });

  it.each([
    ['missing', undefined],
    ['self', 'C01'],
  ])('rejects a %s CELL parent', async (_caseName, parentLineCode) => {
    mockRepo.findOne.mockResolvedValueOnce(null);

    await expect(target.create({
      lineCode: 'C01', lineName: 'Cell 1', lineDivision: 'L',
      resourceType: 'CELL', parentLineCode,
    }, 1)).rejects.toThrow(BadRequestException);
  });

  it('rejects a CELL parent missing from the same organization', async () => {
    mockRepo.findOne.mockResolvedValueOnce(null).mockResolvedValueOnce(null);

    await expect(target.create({
      lineCode: 'C01', lineName: 'Cell 1', lineDivision: 'L',
      resourceType: 'CELL', parentLineCode: 'L02',
    }, 1)).rejects.toThrow(BadRequestException);

    expect(mockRepo.findOne).toHaveBeenNthCalledWith(2, {
      where: { lineCode: 'L02', organizationId: 1 },
    });
  });

  it('validates a CELL parent when a partial update changes the resource type', async () => {
    const existing = {
      lineCode: 'C01', lineName: 'Cell 1', organizationId: 1,
      processCode: 'SMT', resourceType: 'LINE', parentLineCode: 'C01',
    } as ProdLineMaster;
    mockRepo.findOne
      .mockResolvedValueOnce(existing)
      .mockResolvedValueOnce({ lineCode: 'L02', organizationId: 1 } as ProdLineMaster)
      .mockResolvedValueOnce({ ...existing, resourceType: 'CELL', parentLineCode: 'L02' });
    mockRepo.update.mockResolvedValue({ affected: 1 } as never);

    await target.update('C01', { resourceType: 'CELL', parentLineCode: 'L02' }, 1);

    expect(mockRepo.update).toHaveBeenCalledWith(
      { lineCode: 'C01', organizationId: 1 },
      expect.objectContaining({ processCode: 'SMT', resourceType: 'CELL', parentLineCode: 'L02' }),
    );
  });

  it('throws ConflictException when line code exists in tenant', async () => {
    mockRepo.findOne.mockResolvedValue({ lineCode: 'L01' } as ProdLineMaster);

    await expect(target.create({ lineCode: 'L01', lineName: 'Line 1' } as any, 1))
      .rejects.toThrow(ConflictException);
  });

  it('updates production line within tenant and strips key columns from payload', async () => {
    const existing = { lineCode: 'L01', lineName: 'Old', organizationId: 1 } as ProdLineMaster;
    mockRepo.findOne.mockResolvedValue(existing);
    mockRepo.update.mockResolvedValue({ affected: 1 } as any);

    await target.update('L01', {
      lineCode: 'L99',
      lineName: 'New',
      organizationId: 2,
    } as any, 1);

    expect(mockRepo.update).toHaveBeenCalledWith(
      { lineCode: 'L01', organizationId: 1 },
      expect.not.objectContaining({
        lineCode: expect.anything(),
        organizationId: expect.anything(),
      }),
    );
  });

  it('deletes production line within tenant only', async () => {
    const existing = { lineCode: 'L01', organizationId: 1 } as ProdLineMaster;
    mockRepo.findOne.mockResolvedValue(existing);
    mockRepo.delete.mockResolvedValue({ affected: 1 } as any);

    const result = await target.delete('L01', 1);

    expect(result).toEqual({ lineCode: 'L01' });
    expect(mockRepo.delete).toHaveBeenCalledWith({ lineCode: 'L01', organizationId: 1 });
  });
});
