/**
 * @file src/modules/master/services/prod-line.service.ts
 * @description 생산라인마스터 비즈니스 로직 서비스 - TypeORM
 */

import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProdLineMaster } from '../../../entities/prod-line-master.entity';
import { CreateProdLineDto, UpdateProdLineDto, ProdLineQueryDto } from '../dto/prod-line.dto';

@Injectable()
export class ProdLineService {
  constructor(
    @InjectRepository(ProdLineMaster)
    private readonly prodLineRepository: Repository<ProdLineMaster>,
  ) {}

  private tenantWhere(organizationId?: number) {
    return {
      ...(organizationId != null ? { organizationId } : {}),
    };
  }

  async findAll(query: ProdLineQueryDto, organizationId?: number) {
    const { page = 1, limit = 50, search, useYn } = query;
    const skip = (page - 1) * limit;

    const queryBuilder = this.prodLineRepository.createQueryBuilder('prodLine')

    if (organizationId != null) {
      queryBuilder.andWhere('prodLine.organizationId = :organizationId', { organizationId });
    }

    if (useYn) {
      queryBuilder.andWhere('prodLine.useYn = :useYn', { useYn });
    }

    if (search) {
      const upper = search.toUpperCase();
      queryBuilder.andWhere(
        '(prodLine.lineCode LIKE :search OR prodLine.lineName LIKE :searchRaw)',
        { search: `%${upper}%`, searchRaw: `%${search}%` }
      );
    }

    const [data, total] = await Promise.all([
      queryBuilder
        .orderBy('prodLine.lineCode', 'ASC')
        .skip(skip)
        .take(limit)
        .getMany(),
      queryBuilder.getCount(),
    ]);

    return { data, total, page, limit };
  }

  async findById(lineCode: string, organizationId?: number) {
    const prodLine = await this.prodLineRepository.findOne({
      where: { lineCode, ...this.tenantWhere(organizationId) },
    });
    if (!prodLine) throw new NotFoundException(`생산라인을 찾을 수 없습니다: ${lineCode}`);
    return prodLine;
  }

  async create(dto: CreateProdLineDto, organizationId?: number) {
    const existing = await this.prodLineRepository.findOne({
      where: { lineCode: dto.lineCode, ...this.tenantWhere(organizationId) },
    });
    if (existing) throw new ConflictException(`이미 존재하는 라인 코드입니다: ${dto.lineCode}`);

    const prodLine = this.prodLineRepository.create({
      lineCode: dto.lineCode,
      lineName: dto.lineName,
      whLoc: dto.whLoc,
      erpCode: dto.erpCode,
      oper: dto.oper,
      lineType: dto.lineType,
      remark: dto.remark,
      useYn: dto.useYn ?? 'Y',
      organizationId,
    });

    return this.prodLineRepository.save(prodLine);
  }

  async update(lineCode: string, dto: UpdateProdLineDto, organizationId?: number) {
    await this.findById(lineCode, organizationId);
    const updateData: Partial<ProdLineMaster> = {
      ...(dto.lineName !== undefined ? { lineName: dto.lineName } : {}),
      ...(dto.whLoc !== undefined ? { whLoc: dto.whLoc } : {}),
      ...(dto.erpCode !== undefined ? { erpCode: dto.erpCode } : {}),
      ...(dto.oper !== undefined ? { oper: dto.oper } : {}),
      ...(dto.lineType !== undefined ? { lineType: dto.lineType } : {}),
      ...(dto.remark !== undefined ? { remark: dto.remark } : {}),
      ...(dto.useYn !== undefined ? { useYn: dto.useYn } : {}),
    };
    await this.prodLineRepository.update({ lineCode, ...this.tenantWhere(organizationId) }, updateData);
    return this.findById(lineCode, organizationId);
  }

  async delete(lineCode: string, organizationId?: number) {
    await this.findById(lineCode, organizationId);
    await this.prodLineRepository.delete({ lineCode, ...this.tenantWhere(organizationId) });
    return { lineCode };
  }
}
