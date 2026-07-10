import { Test, TestingModule } from '@nestjs/testing';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { getMetadataArgsStorage } from 'typeorm';
import { ProcessService } from './process.service';
import { ProcessMaster } from '../../../entities/process-master.entity';
import { EquipMaster } from '../../../entities/equip-master.entity';
import { MockLoggerService } from '@test/mock-logger.service';

describe('ProcessService equipment assignments', () => {
  let target: ProcessService;
  let processRepo: DeepMocked<Repository<ProcessMaster>>;
  let equipRepo: DeepMocked<Repository<EquipMaster>>;

  beforeEach(async () => {
    processRepo = createMock<Repository<ProcessMaster>>();
    equipRepo = createMock<Repository<EquipMaster>>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProcessService,
        { provide: getRepositoryToken(ProcessMaster), useValue: processRepo },
        { provide: getRepositoryToken(EquipMaster), useValue: equipRepo },
      ],
    })
      .setLogger(new MockLoggerService())
      .compile();

    target = module.get<ProcessService>(ProcessService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('maps the process master onto IP_PRODUCT_WORKSTAGE with a tenant-composite key', () => {
    const table = getMetadataArgsStorage().tables.find((t) => t.target === ProcessMaster);
    expect(table?.name).toBe('IP_PRODUCT_WORKSTAGE');

    const primaryColumnNames = getMetadataArgsStorage()
      .columns
      .filter((column) => column.target === ProcessMaster && column.options.primary)
      .map((column) => column.propertyName);

    expect(primaryColumnNames).toEqual(expect.arrayContaining(['processCode', 'organizationId']));
  });

  it('assigns equipment by moving IMCN_MACHINE.WORKSTAGE_CODE within tenant only', async () => {
    processRepo.findOne.mockResolvedValue({ processCode: 'W020', organizationId: 1 } as ProcessMaster);
    equipRepo.findOne.mockResolvedValue({ equipCode: 'EQ-001', processCode: '*', organizationId: 1 } as EquipMaster);
    equipRepo.update.mockResolvedValue({ affected: 1 } as never);

    await target.assignEquipment('W020', 'EQ-001', 1);

    expect(processRepo.findOne).toHaveBeenCalledWith({
      where: { processCode: 'W020', organizationId: 1 },
    });
    expect(equipRepo.findOne).toHaveBeenCalledWith({
      where: { equipCode: 'EQ-001', organizationId: 1 },
    });
    expect(equipRepo.update).toHaveBeenCalledWith(
      { equipCode: 'EQ-001', organizationId: 1 },
      { processCode: 'W020' },
    );
  });

  it('reassigns equipment that currently belongs to another process', async () => {
    processRepo.findOne.mockResolvedValue({ processCode: 'W030', organizationId: 1 } as ProcessMaster);
    equipRepo.findOne.mockResolvedValue({ equipCode: 'EQ-001', processCode: 'W020', organizationId: 1 } as EquipMaster);
    equipRepo.update.mockResolvedValue({ affected: 1 } as never);

    await target.assignEquipment('W030', 'EQ-001', 1);

    expect(equipRepo.update).toHaveBeenCalledWith(
      { equipCode: 'EQ-001', organizationId: 1 },
      { processCode: 'W030' },
    );
  });

  it('rejects assigning equipment that already belongs to the same process', async () => {
    processRepo.findOne.mockResolvedValue({ processCode: 'W020', organizationId: 1 } as ProcessMaster);
    equipRepo.findOne.mockResolvedValue({ equipCode: 'EQ-001', processCode: 'W020', organizationId: 1 } as EquipMaster);

    await expect(target.assignEquipment('W020', 'EQ-001', 1)).rejects.toThrow('이미 배치된 설비입니다');
    expect(equipRepo.update).not.toHaveBeenCalled();
  });

  it('rejects assigning an equipment code that does not exist', async () => {
    processRepo.findOne.mockResolvedValue({ processCode: 'W020', organizationId: 1 } as ProcessMaster);
    equipRepo.findOne.mockResolvedValue(null);

    await expect(target.assignEquipment('W020', 'MISSING', 1)).rejects.toThrow('설비를 찾을 수 없습니다');
    expect(equipRepo.update).not.toHaveBeenCalled();
  });

  it('finds assigned equipment within tenant only', async () => {
    processRepo.findOne.mockResolvedValue({ processCode: 'W020', organizationId: 1 } as ProcessMaster);
    equipRepo.find.mockResolvedValue([]);

    await target.findEquipments('W020', 1);

    expect(equipRepo.find).toHaveBeenCalledWith({
      where: { processCode: 'W020', organizationId: 1 },
      order: { equipCode: 'ASC' },
    });
  });

  it('releases equipment back to the unassigned sentinel', async () => {
    processRepo.findOne.mockResolvedValue({ processCode: 'W020', organizationId: 1 } as ProcessMaster);
    equipRepo.update.mockResolvedValue({ affected: 1 } as never);

    await target.removeEquipment('W020', 'EQ-001', 1);

    expect(equipRepo.update).toHaveBeenCalledWith(
      { equipCode: 'EQ-001', processCode: 'W020', organizationId: 1 },
      { processCode: '*' },
    );
  });

  it('counts assigned equipment per process, excluding the unassigned sentinel', async () => {
    const qb: {
      select: jest.Mock;
      addSelect: jest.Mock;
      where: jest.Mock;
      andWhere: jest.Mock;
      groupBy: jest.Mock;
      getRawMany: jest.Mock;
    } = {
      select: jest.fn().mockReturnThis(),
      addSelect: jest.fn().mockReturnThis(),
      where: jest.fn().mockReturnThis(),
      andWhere: jest.fn().mockReturnThis(),
      groupBy: jest.fn().mockReturnThis(),
      getRawMany: jest.fn().mockResolvedValue([{ processCode: 'W020', count: '18' }]),
    };
    equipRepo.createQueryBuilder.mockReturnValue(qb as never);

    const result = await target.getEquipmentCounts(1);

    expect(result).toEqual({ W020: 18 });
    expect(qb.andWhere).toHaveBeenCalledWith('equip.processCode != :unassigned', { unassigned: '*' });
    expect(qb.andWhere).toHaveBeenCalledWith('equip.organizationId = :organizationId', { organizationId: 1 });
  });

  it('updates a process within tenant and strips key/tenant columns from payload', async () => {
    processRepo.findOne.mockResolvedValue({ processCode: 'W020', organizationId: 1 } as ProcessMaster);
    processRepo.update.mockResolvedValue({ affected: 1 } as never);

    await target.update('W020', {
      processCode: 'W021',
      processName: 'SOLDER PASTE PRINTER',
    } as never, 1);

    expect(processRepo.update).toHaveBeenCalledWith(
      { processCode: 'W020', organizationId: 1 },
      { processName: 'SOLDER PASTE PRINTER' },
    );
  });

  it('does not pass arbitrary fields from update payload to the repository', async () => {
    processRepo.findOne.mockResolvedValue({ processCode: 'W020', organizationId: 1 } as ProcessMaster);
    processRepo.update.mockResolvedValue({ affected: 1 } as never);

    await target.update('W020', {
      processName: 'SP',
      externalSource: 'ERP',
    } as never, 1);

    expect(processRepo.update).toHaveBeenCalledWith(
      { processCode: 'W020', organizationId: 1 },
      { processName: 'SP' },
    );
  });

  it('persists the legacy workstage fields on update', async () => {
    processRepo.findOne.mockResolvedValue({ processCode: 'W020', organizationId: 1 } as ProcessMaster);
    processRepo.update.mockResolvedValue({ affected: 1 } as never);

    await target.update('W020', {
      uphValue: 1200,
      badRateControl: 'Y',
      badMaxRate: 3.5,
      codeGroup: 'SMT',
      startYn: 'Y',
    }, 1);

    expect(processRepo.update).toHaveBeenCalledWith(
      { processCode: 'W020', organizationId: 1 },
      { uphValue: 1200, badRateControl: 'Y', badMaxRate: 3.5, codeGroup: 'SMT', startYn: 'Y' },
    );
  });
});
