/**
 * @file src/modules/equipment/services/equip-master.service.ts
 * @description 설비마스터 비즈니스 로직 서비스 (TypeORM)
 *
 * 초보자 가이드:
 * 1. **CRUD**: 설비 생성, 조회, 수정, 삭제
 * 2. **상태 관리**: NORMAL(정상) / MAINT(정비중) / STOP(가동중지)
 * 3. **조회 기능**:
 *    - 라인별 설비 조회
 *    - 유형별 설비 조회
 *    - 상태별 설비 조회
 *
 * 설비 상태 의미:
 * - NORMAL: 정상 가동 상태
 * - MAINT: 정비/점검 중 (예방정비 또는 고장정비)
 * - STOP: 가동 중지 (장기 미사용 또는 폐기 예정)
 */

import {
  Injectable,
  NotFoundException,
  ConflictException,
  Logger,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { EquipMaster } from '../../../entities/equip-master.entity';
import { ProdLineMaster } from '../../../entities/prod-line-master.entity';
import { ProcessMaster } from '../../../entities/process-master.entity';
import { WorkerMaster } from '../../../entities/worker-master.entity';
import {
  CreateEquipMasterDto,
  UpdateEquipMasterDto,
  EquipMasterQueryDto,
  ChangeEquipStatusDto,
  AssignJobOrderDto,
  AssignWorkerCodesDto,
} from '../dto/equip-master.dto';
import { parseDateStart } from '../../../shared/date.util';

@Injectable()
export class EquipMasterService {
  private readonly logger = new Logger(EquipMasterService.name);

  constructor(
    @InjectRepository(EquipMaster)
    private readonly equipMasterRepository: Repository<EquipMaster>,
    @InjectRepository(ProdLineMaster)
    private readonly lineRepository: Repository<ProdLineMaster>,
    @InjectRepository(ProcessMaster)
    private readonly processRepository: Repository<ProcessMaster>,
    @InjectRepository(WorkerMaster)
    private readonly workerRepository: Repository<WorkerMaster>,
  ) {}

  private tenantWhere(organizationId?: number) {
    return {
      ...(organizationId != null ? { organizationId } : {}),
    };
  }

  private withClientId(equip: EquipMaster) {
    return { ...equip, id: equip.equipCode };
  }

  private normalizeWorkerCodes(value: AssignWorkerCodesDto['workerCodes']): string[] {
    const raw = Array.isArray(value)
      ? value
      : typeof value === 'string'
        ? value.split(',')
        : [];
    return [...new Set(raw.map((code) => code.trim()).filter(Boolean))];
  }

  // =============================================
  // CRUD 기본 기능
  // =============================================

  /**
   * 설비 목록 조회 (페이지네이션)
   * - 검색어 필터링을 DB 레벨 QueryBuilder WHERE/LIKE로 처리
   */
  async findAll(query: EquipMasterQueryDto) {
    const {
      page = 1,
      limit = 20,
      equipType,
      lineCode,
      status,
      commType,
      useYn,
      search,
      organizationId,
    } = query;
    const skip = (page - 1) * limit;

    const qb = this.equipMasterRepository.createQueryBuilder('e');

    if (equipType) qb.andWhere('e.equipType = :equipType', { equipType });
    if (lineCode) qb.andWhere('e.lineCode = :lineCode', { lineCode });
    if (query.processCode) qb.andWhere('e.processCode = :processCode', { processCode: query.processCode });
    if (status) qb.andWhere('e.status = :status', { status });
    if (commType) qb.andWhere('e.commType = :commType', { commType });
    if (useYn) qb.andWhere('e.useYn = :useYn', { useYn });
    if (organizationId != null) qb.andWhere('e.organizationId = :organizationId', { organizationId });

    if (search) {
      const upper = search.toUpperCase();
      qb.andWhere(
        '(e.equipCode LIKE :searchCode OR e.equipName LIKE :searchRaw OR e.modelName LIKE :searchRaw)',
        { searchCode: `%${upper}%`, searchRaw: `%${search}%` },
      );
    }

    const [data, total] = await Promise.all([
      qb.clone()
        .orderBy('e.equipCode', 'ASC')
        .skip(skip)
        .take(limit)
        .getMany(),
      qb.clone().getCount(),
    ]);

    // 공정명·라인구분 매핑 — PROCESS_MASTERS 단일 출처 (단일 IN 조회, N+1 회피)
    const processCodes = [...new Set(data.map((e) => e.processCode).filter((c): c is string => !!c))];
    const procMap = new Map<string, { processName: string; lineType: string | null }>();
    if (processCodes.length) {
      const processes = await this.processRepository.find({
        where: { processCode: In(processCodes) },
        select: ['processCode', 'processName', 'lineType'],
      });
      processes.forEach((p) =>
        procMap.set(p.processCode, { processName: p.processName, lineType: p.lineType }),
      );
    }
    const enriched = data.map((e) => ({
      ...this.withClientId(e),
      processName: e.processCode ? procMap.get(e.processCode)?.processName ?? null : null,
      lineType: e.processCode ? procMap.get(e.processCode)?.lineType ?? null : null,
    }));

    return { data: enriched, total, page, limit };
  }

  /**
   * 설비 단건 조회 (ID)
   */
  async findById(equipCode: string, organizationId?: number) {
    const equip = await this.equipMasterRepository.findOne({
      where: { equipCode, ...this.tenantWhere(organizationId) },
    });

    if (!equip) {
      throw new NotFoundException(`설비를 찾을 수 없습니다: ${equipCode}`);
    }

    return this.withClientId(equip);
  }

  /**
   * 설비 단건 조회 (코드)
   */
  async findByCode(equipCode: string, organizationId?: number) {
    const equip = await this.equipMasterRepository.findOne({
      where: { equipCode, ...this.tenantWhere(organizationId) },
    });

    if (!equip) {
      throw new NotFoundException(`설비를 찾을 수 없습니다: ${equipCode}`);
    }

    return this.withClientId(equip);
  }

  /**
   * 설비 생성
   */
  async create(dto: CreateEquipMasterDto, organizationId?: number) {
    // 중복 코드 확인
    const existing = await this.equipMasterRepository.findOne({
      where: { equipCode: dto.equipCode, ...this.tenantWhere(organizationId) },
    });

    if (existing) {
      throw new ConflictException(`이미 존재하는 설비 코드입니다: ${dto.equipCode}`);
    }

    const equip = this.equipMasterRepository.create({
      equipCode: dto.equipCode,
      equipName: dto.equipName,
      equipType: dto.equipType,
      modelName: dto.modelName,
      imageUrl: dto.imageUrl ?? null,
      maker: dto.maker,
      lineCode: dto.lineCode,
      processCode: dto.processCode,
      ipAddress: dto.ipAddress,
      port: dto.port,
      commType: dto.commType,
      commConfig: dto.commConfig ? JSON.stringify(dto.commConfig) : null,
      installDate: parseDateStart(dto.installDate),
      status: dto.status ?? 'NORMAL',
      useYn: dto.useYn ?? 'Y',
      ...this.tenantWhere(organizationId),
    });

    return this.equipMasterRepository.save(equip);
  }

  /**
   * 설비 수정
   */
  async update(equipCode: string, dto: UpdateEquipMasterDto, organizationId?: number) {
    await this.findById(equipCode, organizationId);

    const updateData: Partial<EquipMaster> = {};

    if (dto.equipName !== undefined) updateData.equipName = dto.equipName;
    if (dto.equipType !== undefined) updateData.equipType = dto.equipType;
      if (dto.modelName !== undefined) updateData.modelName = dto.modelName;
    if (dto.imageUrl !== undefined) updateData.imageUrl = dto.imageUrl;
      if (dto.maker !== undefined) updateData.maker = dto.maker;
    if (dto.lineCode !== undefined) updateData.lineCode = dto.lineCode;
    if (dto.processCode !== undefined) updateData.processCode = dto.processCode;
    if (dto.ipAddress !== undefined) updateData.ipAddress = dto.ipAddress;
    if (dto.port !== undefined) updateData.port = dto.port;
    if (dto.commType !== undefined) updateData.commType = dto.commType;
    if (dto.commConfig !== undefined) updateData.commConfig = dto.commConfig ? JSON.stringify(dto.commConfig) : null;
    if (dto.installDate !== undefined) updateData.installDate = parseDateStart(dto.installDate);
    if (dto.status !== undefined) updateData.status = dto.status;
    if (dto.useYn !== undefined) updateData.useYn = dto.useYn;

    await this.equipMasterRepository.update({ equipCode, ...this.tenantWhere(organizationId) }, updateData);
    return this.findById(equipCode, organizationId);
  }

  /**
   * 설비 삭제 (소프트 삭제)
   */
  async delete(equipCode: string, organizationId?: number) {
    await this.findById(equipCode, organizationId);

    await this.equipMasterRepository.delete({ equipCode, ...this.tenantWhere(organizationId) });
    return { equipCode, deleted: true };
  }

  async updateImage(equipCode: string, imageUrl: string | null, organizationId?: number) {
    await this.findById(equipCode, organizationId);
    await this.equipMasterRepository.update({ equipCode, ...this.tenantWhere(organizationId) }, { imageUrl });
    return this.findById(equipCode, organizationId);
  }

  // =============================================
  // 상태 관리
  // =============================================

  /**
   * 설비 상태 변경
   */
  async changeStatus(equipCode: string, dto: ChangeEquipStatusDto, organizationId?: number) {
    const equip = await this.findById(equipCode, organizationId);

    this.logger.log(
      `설비 상태 변경: ${equip.equipCode} (${equip.status} -> ${dto.status}), 사유: ${dto.reason ?? '없음'}`
    );

    await this.equipMasterRepository.update(
      { equipCode, ...this.tenantWhere(organizationId) },
      { status: dto.status },
    );
    return this.findById(equipCode, organizationId);
  }

  /**
   * 상태별 설비 목록 조회
   */
  async findByStatus(status: string, organizationId?: number) {
    const equips = await this.equipMasterRepository.find({
      where: { status, useYn: 'Y', ...this.tenantWhere(organizationId) },
      order: { equipCode: 'ASC' },
    });
    return equips.map((equip) => this.withClientId(equip));
  }

  // =============================================
  // 필터링 조회
  // =============================================

  /**
   * 라인별 설비 목록 조회
   */
  async findByLineCode(lineCode: string, organizationId?: number) {
    const equips = await this.equipMasterRepository.find({
      where: { lineCode, useYn: 'Y', ...this.tenantWhere(organizationId) },
      order: { equipCode: 'ASC' },
    });
    return equips.map((equip) => this.withClientId(equip));
  }

  /**
   * 유형별 설비 목록 조회
   */
  async findByType(equipType: string, organizationId?: number) {
    const equips = await this.equipMasterRepository.find({
      where: { equipType, useYn: 'Y', ...this.tenantWhere(organizationId) },
      order: { equipCode: 'ASC' },
    });
    return equips.map((equip) => this.withClientId(equip));
  }

  // =============================================
  // 통계 및 현황
  // =============================================

  /**
   * 설비 현황 통계
   */
  async getEquipmentStats(organizationId?: number) {
    // 상태별 통계
    const statusStats = await this.equipMasterRepository
      .createQueryBuilder('equip')
      .select('equip.status', 'status')
      .addSelect('COUNT(*)', 'count')
      .where('equip.useYn = :useYn', { useYn: 'Y' })
    if (organizationId != null) statusStats.andWhere('equip.organizationId = :organizationId', { organizationId });
    const statusRows = await statusStats.groupBy('equip.status').getRawMany();

    // 유형별 통계
    const typeStats = await this.equipMasterRepository
      .createQueryBuilder('equip')
      .select('equip.equipType', 'equipType')
      .addSelect('COUNT(*)', 'count')
      .where('equip.useYn = :useYn', { useYn: 'Y' })
    if (organizationId != null) typeStats.andWhere('equip.organizationId = :organizationId', { organizationId });
    const typeRows = await typeStats.groupBy('equip.equipType').getRawMany();

    // 전체 개수
    const totalCount = await this.equipMasterRepository.count({
      where: { useYn: 'Y', ...this.tenantWhere(organizationId) },
    });

    return {
      total: totalCount,
      byStatus: statusRows.map((s) => ({
        status: s.status,
        count: parseInt(s.count, 10),
      })),
      byType: typeRows.map((t) => ({
        equipType: t.equipType ?? 'UNKNOWN',
        count: parseInt(t.count, 10),
      })),
    };
  }

  /**
   * 정비중/중지 설비 목록 조회
   */
  async getMaintenanceEquipments(organizationId?: number) {
    const equips = await this.equipMasterRepository.find({
      where: {
        status: In(['MAINT', 'STOP']),
        useYn: 'Y',
        ...this.tenantWhere(organizationId),
      },
      order: { updatedAt: 'DESC' },
    });
    return equips.map((equip) => this.withClientId(equip));
  }

  // =============================================
  // 라인 및 공정 정보
  // =============================================

  /**
   * 라인 목록 조회 (설비 선택용)
   */
  async getLines(organizationId?: number) {
    return this.lineRepository.find({
      where: { useYn: 'Y', ...this.tenantWhere(organizationId) },
      select: ['lineCode', 'lineName', 'lineType', 'oper'],
      order: { lineCode: 'ASC' },
    });
  }

  /**
   * 공정 목록 조회 (설비 선택용)
   */
  async getProcesses(organizationId?: number) {
    return this.processRepository.find({
      where: { useYn: 'Y', ...this.tenantWhere(organizationId) },
      select: ['processCode', 'processName', 'processType', 'processCategory'],
      order: { sortOrder: 'ASC', processCode: 'ASC' },
    });
  }

  // =============================================
  // 작업지시 할당
  // =============================================

  /**
   * 설비에 작업지시 할당/해제
   */
  async assignJobOrder(equipCode: string, dto: AssignJobOrderDto, organizationId?: number) {
    const equip = await this.findById(equipCode, organizationId);

    // 작업지시 할당 시 설비 상태 검증 — 비정상 상태면 할당 차단
    if (dto.orderNo && ['MAINT', 'STOP', 'INTERLOCK'].includes(equip.status)) {
      throw new ConflictException(
        `설비 [${equip.equipCode}]가 "${equip.status}" 상태이므로 작업지시를 할당할 수 없습니다.`,
      );
    }

    await this.equipMasterRepository.update(
      { equipCode, ...this.tenantWhere(organizationId) },
      { currentJobOrderId: dto.orderNo ?? null },
    );

    this.logger.log(
      dto.orderNo
        ? `설비 작업지시 할당: ${equip.equipCode} → ${dto.orderNo}`
        : `설비 작업지시 해제: ${equip.equipCode}`,
    );

    return this.findById(equipCode, organizationId);
  }

  /**
   * 설비에 현재 작업자 코드 목록 할당/해제
   */
  async assignWorkerCodes(equipCode: string, dto: AssignWorkerCodesDto, organizationId?: number) {
    const equip = await this.findById(equipCode, organizationId);
    const workerCodes = this.normalizeWorkerCodes(dto.workerCodes);

    if (workerCodes.length > 0) {
      const workers = await this.workerRepository.find({
        where: {
          workerCode: In(workerCodes),
          useYn: 'Y',
          ...this.tenantWhere(organizationId),
        },
        select: ['workerCode'],
      });
      const found = new Set(workers.map((worker) => worker.workerCode));
      const missing = workerCodes.filter((code) => !found.has(code));
      if (missing.length > 0) {
        throw new NotFoundException(`작업자를 찾을 수 없습니다: ${missing.join(',')}`);
      }
    }

    await this.equipMasterRepository.update(
      { equipCode, ...this.tenantWhere(organizationId) },
      { currentWorkerCodes: workerCodes.length > 0 ? workerCodes.join(',') : null },
    );

    this.logger.log(
      workerCodes.length > 0
        ? `설비 현재 작업자 할당: ${equip.equipCode} → ${workerCodes.join(',')}`
        : `설비 현재 작업자 해제: ${equip.equipCode}`,
    );

    return this.findById(equipCode, organizationId);
  }
}
