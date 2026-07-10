/**
 * @file src/modules/master/services/process.service.ts
 * @description 공정(Workstage)마스터 비즈니스 로직 서비스 - TypeORM / IP_PRODUCT_WORKSTAGE
 *
 * 설비 배치는 별도 중간 테이블 없이 IMCN_MACHINE.WORKSTAGE_CODE(= EquipMaster.processCode)로
 * 관리한다. 설비는 한 번에 하나의 공정에만 속하며, 배치 해제는 UNASSIGNED_PROCESS_CODE로 되돌린다.
 */

import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProcessMaster } from '../../../entities/process-master.entity';
import { EquipMaster } from '../../../entities/equip-master.entity';
import { CreateProcessDto, UpdateProcessDto, ProcessQueryDto } from '../dto/process.dto';

/** IMCN_MACHINE.WORKSTAGE_CODE에서 "공정 미배치"를 나타내는 현장 관례값 */
const UNASSIGNED_PROCESS_CODE = '*';

/** update 시 반영을 허용하는 컬럼 (PK/테넌트/감사 컬럼 제외) */
const UPDATABLE_FIELDS = [
  'processName',
  'processType',
  'sortOrder',
  'startYn',
  'codeGroup',
  'workstageStatus',
  'lineCode',
  'departmentCode',
  'shiftCode',
  'machineCode',
  'costCenterCode',
  'mesDisplayGroup',
  'actualPlcAddress',
  'stValue',
  'otValue',
  'standardQty',
  'uphValue',
  'capacity',
  'capacityUom',
  'useRate',
  'waitTime',
  'moveTime',
  'prepareTime',
  'totalWorkTime',
  'workerWorkTime',
  'machineWorkTime',
  'workerQty',
  'machineQty',
  'workingEfficiency',
  'machineEfficiency',
  'wageRate',
  'expenseRate',
  'machineryRate',
  'badRateControl',
  'badMaxRate',
  'badQtyExtractYn',
  'genSubMfsYn',
  'assyExpYn',
] as const satisfies readonly (keyof ProcessMaster)[];

type UpdatableField = (typeof UPDATABLE_FIELDS)[number];

@Injectable()
export class ProcessService {
  constructor(
    @InjectRepository(ProcessMaster)
    private readonly processRepository: Repository<ProcessMaster>,
    @InjectRepository(EquipMaster)
    private readonly equipRepository: Repository<EquipMaster>,
  ) {}

  private tenantWhere(organizationId?: number) {
    return {
      ...(organizationId != null ? { organizationId } : {}),
    };
  }

  async findAll(query: ProcessQueryDto, organizationId?: number) {
    const { page = 1, limit = 10, search, processType, codeGroup, lineCode } = query;
    const skip = (page - 1) * limit;

    const queryBuilder = this.processRepository.createQueryBuilder('process');

    if (organizationId != null) {
      queryBuilder.andWhere('process.organizationId = :organizationId', { organizationId });
    }

    if (processType) {
      queryBuilder.andWhere('process.processType = :processType', { processType });
    }

    if (codeGroup) {
      queryBuilder.andWhere('process.codeGroup = :codeGroup', { codeGroup });
    }

    if (lineCode) {
      queryBuilder.andWhere('process.lineCode = :lineCode', { lineCode });
    }

    if (search) {
      const upper = search.toUpperCase();
      queryBuilder.andWhere(
        '(process.processCode LIKE :search OR process.processName LIKE :searchRaw)',
        { search: `%${upper}%`, searchRaw: `%${search}%` }
      );
    }

    const [data, total] = await Promise.all([
      queryBuilder
        .orderBy('process.sortOrder', 'ASC')
        .addOrderBy('process.processCode', 'ASC')
        .skip(skip)
        .take(limit)
        .getMany(),
      queryBuilder.getCount(),
    ]);

    return { data, total, page, limit };
  }

  async findById(processCode: string, organizationId?: number) {
    const process = await this.processRepository.findOne({
      where: { processCode, ...this.tenantWhere(organizationId) },
    });
    if (!process) throw new NotFoundException(`공정을 찾을 수 없습니다: ${processCode}`);
    return process;
  }

  async create(dto: CreateProcessDto, organizationId?: number) {
    const existing = await this.processRepository.findOne({
      where: { processCode: dto.processCode, ...this.tenantWhere(organizationId) },
    });
    if (existing) throw new ConflictException(`이미 존재하는 공정 코드입니다: ${dto.processCode}`);

    const process = this.processRepository.create({
      ...dto,
      processType: dto.processType ?? 'I',
      startYn: dto.startYn ?? 'N',
      lineCode: dto.lineCode ?? UNASSIGNED_PROCESS_CODE,
      mesDisplayGroup: dto.mesDisplayGroup ?? UNASSIGNED_PROCESS_CODE,
      organizationId,
    });

    return this.processRepository.save(process);
  }

  async update(processCode: string, dto: UpdateProcessDto, organizationId?: number) {
    await this.findById(processCode, organizationId);

    const updateData: Partial<Pick<ProcessMaster, UpdatableField>> = {};
    for (const field of UPDATABLE_FIELDS) {
      const value = dto[field];
      if (value !== undefined) {
        Object.assign(updateData, { [field]: value });
      }
    }

    await this.processRepository.update({ processCode, ...this.tenantWhere(organizationId) }, updateData);
    return this.findById(processCode, organizationId);
  }

  async delete(processCode: string, organizationId?: number) {
    await this.findById(processCode, organizationId);
    await this.processRepository.delete({ processCode, ...this.tenantWhere(organizationId) });
    return { processCode };
  }

  async findEquipments(processCode: string, organizationId?: number): Promise<EquipMaster[]> {
    await this.findById(processCode, organizationId);

    return this.equipRepository.find({
      where: { processCode, ...this.tenantWhere(organizationId) },
      order: { equipCode: 'ASC' },
    });
  }

  async getEquipmentCounts(organizationId?: number): Promise<Record<string, number>> {
    const qb = this.equipRepository
      .createQueryBuilder('equip')
      .select('equip.processCode', 'processCode')
      .addSelect('COUNT(*)', 'count')
      .where('equip.processCode IS NOT NULL')
      .andWhere('equip.processCode != :unassigned', { unassigned: UNASSIGNED_PROCESS_CODE });

    if (organizationId != null) qb.andWhere('equip.organizationId = :organizationId', { organizationId });

    const rows = await qb
      .groupBy('equip.processCode')
      .getRawMany<{ processCode: string; count: string }>();

    return rows.reduce<Record<string, number>>((acc, row) => {
      acc[row.processCode] = Number(row.count);
      return acc;
    }, {});
  }

  async assignEquipment(processCode: string, equipCode: string, organizationId?: number) {
    await this.findById(processCode, organizationId);

    const equipment = await this.equipRepository.findOne({
      where: { equipCode, ...this.tenantWhere(organizationId) },
    });
    if (!equipment) {
      throw new NotFoundException(`설비를 찾을 수 없습니다: ${equipCode}`);
    }

    if (equipment.processCode === processCode) {
      throw new ConflictException(`이미 배치된 설비입니다: ${equipCode}`);
    }

    await this.equipRepository.update(
      { equipCode, ...this.tenantWhere(organizationId) },
      { processCode },
    );

    return { processCode, equipCode };
  }

  async removeEquipment(processCode: string, equipCode: string, organizationId?: number) {
    await this.findById(processCode, organizationId);

    await this.equipRepository.update(
      { equipCode, processCode, ...this.tenantWhere(organizationId) },
      { processCode: UNASSIGNED_PROCESS_CODE },
    );

    return { processCode, equipCode };
  }
}
