/**
 * @file services/sys-config.service.ts
 * @description 시스템 환경설정 서비스
 *
 * 초보자 가이드:
 * 1. findAll: 그룹별/전체 설정 조회 (프론트엔드 관리 페이지용)
 * 2. findAllActive: 활성 설정만 key-value 맵으로 반환 (앱 로딩 시)
 * 3. getValue: 특정 키의 값 조회 (서비스 로직에서 사용)
 * 4. isEnabled: BOOLEAN 타입 설정의 활성 여부 (서비스 로직에서 사용)
 * 5. bulkUpdate: 여러 설정을 한번에 저장 (관리 페이지에서 저장 버튼)
 */
import { BadRequestException, Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, FindOptionsWhere } from 'typeorm';
import { SysConfig } from '../../../entities/sys-config.entity';
import {
  CreateSysConfigDto,
  UpdateSysConfigDto,
  BulkUpdateSysConfigDto,
  SysConfigQueryDto,
} from '../dto/sys-config.dto';

@Injectable()
export class SysConfigService {
  constructor(
    @InjectRepository(SysConfig)
    private readonly sysConfigRepository: Repository<SysConfig>,
  ) {}

  private tenantWhere(organizationId?: number | null) {
    return {
      ...(organizationId != null ? { organizationId } : {}),
    };
  }

  private inferConfigGroup(configKey: string): string {
    const key = configKey.toUpperCase();
    if (key.startsWith('AI_')) return 'AI';
    if (key.startsWith('EMBEDDING_')) return 'AI_EMBEDDING';
    if (
      key.startsWith('MAT') ||
      key.startsWith('MATERIAL') ||
      key.startsWith('WH') ||
      key.startsWith('WAREHOUSE') ||
      key.includes('INVENTORY') ||
      key.includes('FIFO')
    ) {
      return 'MATERIAL';
    }
    if (key.startsWith('PROD') || key.includes('ASSEMBLY') || key.includes('LABEL')) {
      return 'PRODUCTION';
    }
    if (key.startsWith('QC') || key.startsWith('IQC') || key.startsWith('LQC') || key.startsWith('OQC')) {
      return 'QUALITY';
    }
    return 'SYSTEM';
  }

  private inferConfigType(value: string | null): string {
    if (value === 'Y' || value === 'N') return 'BOOLEAN';
    if (value != null && value.trim() !== '' && !Number.isNaN(Number(value))) return 'NUMBER';
    return 'TEXT';
  }

  private toView(row: SysConfig) {
    const label = row.configDescription ?? row.configKey;
    const description = row.configValueDescription ?? row.configDescription ?? null;
    return {
      id: row.configKey,
      configKey: row.configKey,
      configGroup: this.inferConfigGroup(row.configKey),
      configValue: row.configValue ?? '',
      configType: this.inferConfigType(row.configValue),
      label,
      description,
      options: null,
      sortOrder: 0,
      isActive: row.isActive ?? 'Y',
      organizationId: row.organizationId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    };
  }

  private assertSameTenant(
    context: string,
    row: { organizationId?: number | null },
    organizationId?: number | null,
  ) {
    if (organizationId != null && row.organizationId !== organizationId) {
      throw new BadRequestException(
        `${context} 조직 정보가 일치하지 않습니다. request=${organizationId}, row=${row.organizationId ?? 'NULL'}`,
      );
    }
  }

  /** 설정 목록 조회 (관리 페이지용) */
  async findAll(query: SysConfigQueryDto, organizationId?: number) {
    const where: FindOptionsWhere<SysConfig> = {
      ...(organizationId != null && { organizationId }),
    };

    const data = await this.sysConfigRepository.find({
      where,
      order: { configKey: 'ASC' },
    });

    let result = data.map((item) => this.toView(item));
    if (query.configGroup) {
      result = result.filter((c) => c.configGroup === query.configGroup);
    }
    if (query.search) {
      const s = query.search.toLowerCase();
      result = result.filter(
        (c) =>
          c.label.toLowerCase().includes(s) ||
          c.configKey.toLowerCase().includes(s) ||
          c.description?.toLowerCase().includes(s),
      );
    }

    // 그룹별로 묶어서 반환
    const grouped: Record<string, typeof result> = {};
    for (const item of result) {
      if (!grouped[item.configGroup]) grouped[item.configGroup] = [];
      grouped[item.configGroup].push(item);
    }

    return { data: result, grouped, total: result.length };
  }

  /** 활성 설정만 key-value 맵으로 반환 (앱 초기 로딩용) */
  async findAllActive() {
    const configs = await this.sysConfigRepository.find({
      where: { isActive: 'Y' },
      order: { configKey: 'ASC' },
    });

    const map: Record<string, string> = {};
    for (const c of configs) {
      map[c.configKey] = c.configValue ?? '';
    }

    return { data: configs.map((item) => this.toView(item)), map };
  }

  /** 특정 키 값 조회 (다른 서비스에서 호출) */
  async getValue(key: string): Promise<string | null> {
    const config = await this.sysConfigRepository.findOne({
      where: { configKey: key, isActive: 'Y' },
    });
    return config?.configValue ?? null;
  }

  /** BOOLEAN 타입 설정 활성 여부 (다른 서비스에서 호출) */
  async isEnabled(key: string): Promise<boolean> {
    const value = await this.getValue(key);
    return value === 'Y';
  }

  /** 설정 생성 */
  async create(dto: CreateSysConfigDto, organizationId?: number) {
    const existing = await this.sysConfigRepository.findOne({
      where: {
        configKey: dto.configKey,
        ...this.tenantWhere(organizationId),
      },
    });
    if (existing) {
      throw new ConflictException(
        `이미 존재하는 설정입니다: ${dto.configGroup}.${dto.configKey}`,
      );
    }
    const entity = this.sysConfigRepository.create({
      configKey: dto.configKey,
      configValue: dto.configValue,
      configDescription: dto.label ?? dto.description ?? dto.configKey,
      configValueDescription: dto.description ?? dto.options ?? null,
      isActive: 'Y',
      organizationId: organizationId ?? 1,
      createdAt: new Date(),
      updatedAt: new Date(),
    });
    return this.toView(await this.sysConfigRepository.save(entity));
  }

  /** 설정 수정 */
  async update(
    id: string,
    dto: UpdateSysConfigDto,
    organizationId?: number,
  ) {
    const config = await this.sysConfigRepository.findOne({
      where: { configKey: id, ...this.tenantWhere(organizationId) },
    });
    if (!config) throw new NotFoundException(`설정을 찾을 수 없습니다: ${id}`);
    this.assertSameTenant('시스템 설정', config, organizationId);
    const updateData: Partial<SysConfig> = {
      ...(dto.configValue !== undefined ? { configValue: dto.configValue } : {}),
      ...(dto.label !== undefined || dto.description !== undefined
        ? { configDescription: dto.label ?? dto.description ?? config.configDescription }
        : {}),
      ...(dto.description !== undefined || dto.options !== undefined
        ? { configValueDescription: dto.description ?? dto.options ?? null }
        : {}),
      ...(dto.isActive !== undefined ? { isActive: dto.isActive } : {}),
      updatedAt: new Date(),
    };
    await this.sysConfigRepository.update(
      { configKey: id, ...this.tenantWhere(organizationId) },
      updateData,
    );
    const updated = await this.sysConfigRepository.findOne({
      where: { configKey: id, ...this.tenantWhere(organizationId) },
    });
    if (!updated) throw new NotFoundException(`설정을 찾을 수 없습니다: ${id}`);
    return this.toView(updated);
  }

  /** 일괄 수정 (관리 페이지 저장 버튼) */
  async bulkUpdate(
    dto: BulkUpdateSysConfigDto,
    organizationId?: number,
  ) {
    const results = [];
    for (const item of dto.items) {
      await this.sysConfigRepository.update(
        { configKey: item.id, ...this.tenantWhere(organizationId) },
        {
          configValue: item.configValue,
          updatedAt: new Date(),
        },
      );
      const updated = await this.sysConfigRepository.findOne({
        where: { configKey: item.id, ...this.tenantWhere(organizationId) },
      });
      if (updated) results.push(this.toView(updated));
    }
    return results;
  }

  /** 설정 삭제 */
  async remove(id: string, organizationId?: number) {
    const config = await this.sysConfigRepository.findOne({
      where: { configKey: id, ...this.tenantWhere(organizationId) },
    });
    if (!config) throw new NotFoundException(`설정을 찾을 수 없습니다: ${id}`);
    this.assertSameTenant('시스템 설정', config, organizationId);
    await this.sysConfigRepository.delete({
      configKey: id,
      ...this.tenantWhere(organizationId),
    });
    return { id, deleted: true };
  }
}
