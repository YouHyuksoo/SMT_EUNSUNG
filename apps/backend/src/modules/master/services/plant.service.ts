/**
 * @file src/modules/master/services/plant.service.ts
 * @description 공장/라인 비즈니스 로직 서비스 - TypeORM Repository 패턴
 */

import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, FindOptionsWhere } from 'typeorm';
import { Plant } from '../../../entities/plant.entity';
import { CreatePlantDto, UpdatePlantDto, PlantQueryDto } from '../dto/plant.dto';

@Injectable()
export class PlantService {
  constructor(
    @InjectRepository(Plant)
    private readonly plantRepository: Repository<Plant>,
  ) {}

  async findAll(query: PlantQueryDto, organizationId?: number) {
    const { page = 1, limit = 10, plantType, search, useYn } = query;
    const skip = (page - 1) * limit;

    const queryBuilder = this.plantRepository.createQueryBuilder('plant')

    if (organizationId != null) {
      queryBuilder.andWhere('plant.organizationId = :organizationId', { organizationId });
    }

    if (plantType) {
      queryBuilder.andWhere('plant.plantType = :plantType', { plantType });
    }

    if (useYn) {
      queryBuilder.andWhere('plant.useYn = :useYn', { useYn });
    }

    if (search) {
      const upper = search.toUpperCase();
      queryBuilder.andWhere(
        '(plant.plantCode LIKE :search OR plant.plantName LIKE :searchRaw)',
        { search: `%${upper}%`, searchRaw: `%${search}%` }
      );
    }

    const [data, total] = await Promise.all([
      queryBuilder
        .orderBy('plant.plantType', 'ASC')
        .addOrderBy('plant.sortOrder', 'ASC')
        .skip(skip)
        .take(limit)
        .getMany(),
      queryBuilder.getCount(),
    ]);

    return { data, total, page, limit };
  }

  async findById(plantCode: string, shopCode = '-', lineCode = '-', cellCode = '-', organizationId?: number) {
    const plantEntity = await this.plantRepository.findOne({
      where: {
        plantCode,
        shopCode,
        lineCode,
        cellCode,
        ...(organizationId != null ? { organizationId } : {}),
      },
    });

    if (!plantEntity) throw new NotFoundException(`공장/라인을 찾을 수 없습니다: ${plantCode}/${shopCode}/${lineCode}/${cellCode}`);
    return plantEntity;
  }

  async findHierarchy(plantCode?: string) {
    const where: FindOptionsWhere<Plant> = {};
    if (plantCode) {
      where.plantCode = plantCode;
    }

    return this.plantRepository.find({
      where,
      order: { sortOrder: 'asc' },
    });
  }

  async create(dto: CreatePlantDto, organizationId?: number) {
    const existing = await this.plantRepository.findOne({
      where: {
        plantCode: dto.plantCode,
        shopCode: dto.shopCode ?? '-',
        lineCode: dto.lineCode ?? '-',
        cellCode: dto.cellCode ?? '-',
        ...(organizationId != null ? { organizationId } : {}),
      },
    });

    if (existing) throw new ConflictException(`이미 존재하는 공장/라인입니다`);

    const plantEntity = this.plantRepository.create({
      plantCode: dto.plantCode,
      shopCode: dto.shopCode ?? '-',
      lineCode: dto.lineCode ?? '-',
      cellCode: dto.cellCode ?? '-',
      plantName: dto.plantName,
      plantType: dto.plantType,
      sortOrder: dto.sortOrder ?? 0,
      useYn: dto.useYn ?? 'Y',
      organizationId,
    });

    return this.plantRepository.save(plantEntity);
  }

  async update(plantCode: string, dto: UpdatePlantDto, shopCode = '-', lineCode = '-', cellCode = '-', organizationId?: number) {
    await this.findById(plantCode, shopCode, lineCode, cellCode, organizationId);
    const updateData: Partial<Pick<Plant, 'plantName' | 'plantType' | 'sortOrder' | 'useYn'>> = {
      ...(dto.plantName !== undefined ? { plantName: dto.plantName } : {}),
      ...(dto.plantType !== undefined ? { plantType: dto.plantType } : {}),
      ...(dto.sortOrder !== undefined ? { sortOrder: dto.sortOrder } : {}),
      ...(dto.useYn !== undefined ? { useYn: dto.useYn } : {}),
    };
    await this.plantRepository.update(
      { plantCode, shopCode, lineCode, cellCode, ...(organizationId != null ? { organizationId } : {}) },
      updateData,
    );
    return this.findById(plantCode, shopCode, lineCode, cellCode, organizationId);
  }

  async delete(plantCode: string, shopCode = '-', lineCode = '-', cellCode = '-', organizationId?: number) {
    await this.findById(plantCode, shopCode, lineCode, cellCode, organizationId);

    await this.plantRepository.delete({ plantCode, shopCode, lineCode, cellCode, ...(organizationId != null ? { organizationId } : {}) });
    return { plantCode, shopCode, lineCode, cellCode };
  }

  async findByType(plantType: string) {
    return this.plantRepository.find({
      where: { plantType, useYn: 'Y' },
      order: { sortOrder: 'asc' },
    });
  }

}
