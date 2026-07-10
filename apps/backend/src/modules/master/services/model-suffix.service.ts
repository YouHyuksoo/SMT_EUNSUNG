/**
 * @file src/modules/master/services/model-suffix.service.ts
 * @description 모델접미사 비즈니스 로직 서비스
 *
 * 초보자 가이드:
 * 1. modelCode + suffixCode 복합 PK로 조회/수정/삭제
 */

import { BadRequestException, Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ModelSuffix } from '../../../entities/model-suffix.entity';
import { CreateModelSuffixDto, UpdateModelSuffixDto, ModelSuffixQueryDto } from '../dto/model-suffix.dto';

@Injectable()
export class ModelSuffixService {
  constructor(
    @InjectRepository(ModelSuffix)
    private readonly modelSuffixRepository: Repository<ModelSuffix>,
  ) {}

  private tenantWhere(organizationId?: number) {
    return {
      ...(organizationId != null ? { organizationId } : {}),
    };
  }

  private assertSameTenant(
    context: string,
    row: { organizationId?: number | null },
    organizationId?: number | null,
  ) {
    if (organizationId != null && row.organizationId !== organizationId) {
      throw new BadRequestException(`${context} 조직 정보가 일치하지 않습니다. request=${organizationId}, row=${row.organizationId ?? 'NULL'}`);
    }
  }

  async findAll(query: ModelSuffixQueryDto, organizationId?: number) {
    const { page = 1, limit = 10, modelCode, customer, search, useYn } = query;

    const queryBuilder = this.modelSuffixRepository.createQueryBuilder('suffix');

    if (organizationId != null) {
      queryBuilder.andWhere('suffix.organizationId = :organizationId', { organizationId });
    }

    if (modelCode) {
      queryBuilder.andWhere('suffix.modelCode = :modelCode', { modelCode });
    }

    if (customer) {
      queryBuilder.andWhere('suffix.customer = :customer', { customer });
    }

    if (useYn) {
      queryBuilder.andWhere('suffix.useYn = :useYn', { useYn });
    }

    if (search) {
      queryBuilder.andWhere(
        '(suffix.modelCode LIKE :search OR suffix.suffixCode LIKE :search OR suffix.suffixName LIKE :search)',
        { search: `%${search}%` },
      );
    }

    const [data, total] = await queryBuilder
      .orderBy('suffix.modelCode', 'ASC')
      .addOrderBy('suffix.suffixCode', 'ASC')
      .skip((page - 1) * limit)
      .take(limit)
      .getManyAndCount();

    return { data, total, page, limit };
  }

  async findByCompositeKey(modelCode: string, suffixCode: string, organizationId?: number) {
    const suffix = await this.modelSuffixRepository.findOne({
      where: { modelCode, suffixCode, ...this.tenantWhere(organizationId) },
    });

    if (!suffix) {
      throw new NotFoundException('모델접미사를 찾을 수 없습니다.');
    }
    this.assertSameTenant('모델접미사', suffix, organizationId);

    return suffix;
  }

  async create(dto: CreateModelSuffixDto, organizationId?: number) {
    const existing = await this.modelSuffixRepository.findOne({
      where: {
        modelCode: dto.modelCode,
        suffixCode: dto.suffixCode,
        ...this.tenantWhere(organizationId),
      },
    });

    if (existing) {
      throw new ConflictException('이미 존재하는 모델접미사 조합입니다.');
    }

    const entity = this.modelSuffixRepository.create({
      modelCode: dto.modelCode,
      suffixCode: dto.suffixCode,
      suffixName: dto.suffixName,
      customer: dto.customer ?? null,
      remark: dto.remark ?? null,
      useYn: dto.useYn ?? 'Y',
      organizationId,
    });
    const saved = await this.modelSuffixRepository.save(entity);
    return saved;
  }

  async update(modelCode: string, suffixCode: string, dto: UpdateModelSuffixDto, organizationId?: number) {
    const suffix = await this.findByCompositeKey(modelCode, suffixCode, organizationId);

    Object.assign(suffix, {
      ...(dto.suffixName !== undefined ? { suffixName: dto.suffixName } : {}),
      ...(dto.customer !== undefined ? { customer: dto.customer } : {}),
      ...(dto.remark !== undefined ? { remark: dto.remark } : {}),
      ...(dto.useYn !== undefined ? { useYn: dto.useYn } : {}),
    });

    const updated = await this.modelSuffixRepository.save({
      ...suffix,
      organizationId: suffix.organizationId,
      modelCode,
      suffixCode,
    });

    return updated;
  }

  async delete(modelCode: string, suffixCode: string, organizationId?: number) {
    const suffix = await this.findByCompositeKey(modelCode, suffixCode, organizationId);

    await this.modelSuffixRepository.remove(suffix);

    return { modelCode, suffixCode, deleted: true };
  }
}
