/**
 * @file src/modules/master/services/plant.service.ts
 * @description PLANTS 공장/작업장/라인/CELL 비즈니스 로직 서비스.
 */

import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Plant } from '../../../entities/plant.entity';
import { CreatePlantDto, PlantQueryDto, UpdatePlantDto } from '../dto/plant.dto';

const PLANT_ORDER = {
  sortOrder: 'ASC' as const,
  plantCode: 'ASC' as const,
  shopCode: 'ASC' as const,
  lineCode: 'ASC' as const,
  cellCode: 'ASC' as const,
};

@Injectable()
export class PlantService {
  constructor(
    @InjectRepository(Plant)
    private readonly plantRepository: Repository<Plant>,
  ) {}

  private tenantWhere(company: string, plantCd: string) {
    if (!company?.trim() || !plantCd?.trim()) {
      throw new BadRequestException('회사와 사업장 테넌트가 필요합니다.');
    }
    return { company, plantCd };
  }

  async findAll(query: PlantQueryDto, company: string, plantCd: string) {
    const tenantWhere = this.tenantWhere(company, plantCd);
    const { page = 1, limit = 10, plantType, search, useYn } = query;
    const skip = (page - 1) * limit;

    const queryBuilder = this.plantRepository.createQueryBuilder('plant');
    queryBuilder
      .where('plant.company = :company', { company: tenantWhere.company })
      .andWhere('plant.plantCd = :plantCd', { plantCd: tenantWhere.plantCd });

    if (plantType) {
      queryBuilder.andWhere('plant.plantType = :plantType', { plantType });
    }

    if (useYn) {
      queryBuilder.andWhere('plant.useYn = :useYn', { useYn });
    }

    if (search) {
      const upper = search.toUpperCase();
      queryBuilder.andWhere(
        '(UPPER(plant.plantCode) LIKE :search OR UPPER(plant.shopCode) LIKE :search OR UPPER(plant.lineCode) LIKE :search OR UPPER(plant.cellCode) LIKE :search OR UPPER(plant.plantName) LIKE :search)',
        { search: `%${upper}%` },
      );
    }

    const [data, total] = await Promise.all([
      queryBuilder
        .orderBy('plant.sortOrder', 'ASC')
        .addOrderBy('plant.plantCode', 'ASC')
        .addOrderBy('plant.shopCode', 'ASC')
        .addOrderBy('plant.lineCode', 'ASC')
        .addOrderBy('plant.cellCode', 'ASC')
        .skip(skip)
        .take(limit)
        .getMany(),
      queryBuilder.getCount(),
    ]);

    return { data, total, page, limit };
  }

  async findById(
    plantCode: string,
    shopCode: string,
    lineCode: string,
    cellCode: string,
    company: string,
    plantCd: string,
  ) {
    const plantEntity = await this.plantRepository.findOne({
      where: {
        plantCode,
        shopCode,
        lineCode,
        cellCode,
        ...this.tenantWhere(company, plantCd),
      },
    });

    if (!plantEntity) {
      throw new NotFoundException(`공장/라인을 찾을 수 없습니다: ${plantCode}/${shopCode}/${lineCode}/${cellCode}`);
    }
    return plantEntity;
  }

  async findHierarchy(plantCode: string | undefined, company: string, plantCd: string) {
    const where = {
      ...this.tenantWhere(company, plantCd),
      ...(plantCode ? { plantCode } : {}),
    };

    return this.plantRepository.find({
      where,
      order: PLANT_ORDER,
    });
  }

  async create(dto: CreatePlantDto, company: string, plantCd: string) {
    const tenantWhere = this.tenantWhere(company, plantCd);
    const key = {
      plantCode: dto.plantCode,
      shopCode: dto.shopCode ?? '-',
      lineCode: dto.lineCode ?? '-',
      cellCode: dto.cellCode ?? '-',
    };

    const existing = await this.plantRepository.findOne({
      where: { ...key, ...tenantWhere },
    });

    if (existing) throw new ConflictException('이미 존재하는 공장/라인입니다');

    const plantEntity = this.plantRepository.create({
      ...key,
      ...tenantWhere,
      plantName: dto.plantName,
      plantType: dto.plantType ?? null,
      sortOrder: dto.sortOrder ?? 0,
      useYn: dto.useYn ?? 'Y',
    });

    return this.plantRepository.save(plantEntity);
  }

  async update(
    plantCode: string,
    dto: UpdatePlantDto,
    shopCode: string,
    lineCode: string,
    cellCode: string,
    company: string,
    plantCd: string,
  ) {
    const tenantWhere = this.tenantWhere(company, plantCd);
    const key = { plantCode, shopCode, lineCode, cellCode };
    await this.findById(plantCode, shopCode, lineCode, cellCode, company, plantCd);

    const updateData: Partial<Pick<Plant, 'plantName' | 'plantType' | 'sortOrder' | 'useYn'>> = {
      ...(dto.plantName !== undefined ? { plantName: dto.plantName } : {}),
      ...(dto.plantType !== undefined ? { plantType: dto.plantType } : {}),
      ...(dto.sortOrder !== undefined ? { sortOrder: dto.sortOrder } : {}),
      ...(dto.useYn !== undefined ? { useYn: dto.useYn } : {}),
    };

    await this.plantRepository.update({ ...key, ...tenantWhere }, updateData);
    return this.findById(plantCode, shopCode, lineCode, cellCode, company, plantCd);
  }

  async delete(
    plantCode: string,
    shopCode: string,
    lineCode: string,
    cellCode: string,
    company: string,
    plantCd: string,
  ) {
    const tenantWhere = this.tenantWhere(company, plantCd);
    const key = { plantCode, shopCode, lineCode, cellCode };
    await this.findById(plantCode, shopCode, lineCode, cellCode, company, plantCd);

    await this.plantRepository.delete({ ...key, ...tenantWhere });
    return key;
  }

  async findByType(plantType: string, company: string, plantCd: string) {
    return this.plantRepository.find({
      where: { plantType, useYn: 'Y', ...this.tenantWhere(company, plantCd) },
      order: PLANT_ORDER,
    });
  }
}
