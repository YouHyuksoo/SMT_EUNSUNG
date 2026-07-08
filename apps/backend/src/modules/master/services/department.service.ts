/**
 * @file src/modules/master/services/department.service.ts
 * @description 부서마스터 비즈니스 로직 서비스 - TypeORM Repository 패턴
 */

import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { DepartmentMaster } from '../../../entities/department-master.entity';
import { CreateDepartmentDto, UpdateDepartmentDto, DepartmentQueryDto } from '../dto/department.dto';

export interface DepartmentView {
  deptCode: string;
  deptName: string;
  parentDeptCode: string | null;
  sortOrder: number;
  managerName: string | null;
  remark: string | null;
  useYn: string;
  organizationId?: number;
  createdAt: Date | null;
  updatedAt: Date | null;
}

@Injectable()
export class DepartmentService {
  constructor(
    @InjectRepository(DepartmentMaster)
    private readonly departmentRepository: Repository<DepartmentMaster>,
  ) {}

  private tenantWhere(organizationId?: number) {
    return {
      ...(organizationId != null ? { organizationId } : {}),
    };
  }

  private toView(dept: DepartmentMaster): DepartmentView {
    return {
      deptCode: dept.deptCode,
      deptName: dept.deptName || dept.deptNameLocal || dept.deptNameEng || dept.deptCode,
      parentDeptCode: dept.parentDeptCode === '*' ? null : dept.parentDeptCode,
      sortOrder: 0,
      managerName: null,
      remark: dept.remark,
      useYn: 'Y',
      organizationId: dept.organizationId,
      createdAt: dept.createdAt,
      updatedAt: dept.updatedAt,
    };
  }

  async findAll(query: DepartmentQueryDto, organizationId?: number) {
    const { page = 1, limit = 50, search, useYn } = query;
    const skip = (page - 1) * limit;

    const queryBuilder = this.departmentRepository.createQueryBuilder('dept')

    if (organizationId != null) {
      queryBuilder.andWhere('dept.organizationId = :organizationId', { organizationId });
    }

    if (useYn && useYn !== 'Y') {
      return { data: [], total: 0, page, limit };
    }

    if (search) {
      const upper = search.toUpperCase();
      queryBuilder.andWhere(
        '(UPPER(dept.deptCode) LIKE :search OR dept.deptName LIKE :searchRaw OR dept.deptNameLocal LIKE :searchRaw)',
        { search: `%${upper}%`, searchRaw: `%${search}%` }
      );
    }

    const [rows, total] = await Promise.all([
      queryBuilder
        .orderBy('dept.deptCode', 'ASC')
        .skip(skip)
        .take(limit)
        .getMany(),
      queryBuilder.getCount(),
    ]);

    return { data: rows.map((row) => this.toView(row)), total, page, limit };
  }

  async findById(deptCode: string, organizationId?: number) {
    const dept = await this.departmentRepository.findOne({
      where: { deptCode, ...this.tenantWhere(organizationId) },
    });
    if (!dept) throw new NotFoundException(`부서를 찾을 수 없습니다: ${deptCode}`);
    return this.toView(dept);
  }

  async create(dto: CreateDepartmentDto, organizationId?: number) {
    const existing = await this.departmentRepository.findOne({
      where: { deptCode: dto.deptCode, ...this.tenantWhere(organizationId) },
    });
    if (existing) throw new ConflictException(`이미 존재하는 부서코드입니다: ${dto.deptCode}`);

    const dept = this.departmentRepository.create({
      deptCode: dto.deptCode,
      deptName: dto.deptName,
      deptNameLocal: dto.deptName,
      deptNameEng: dto.deptName,
      parentDeptCode: dto.parentDeptCode || '*',
      remark: dto.remark,
      organizationId,
      createdAt: new Date(),
      updatedAt: new Date(),
    });

    return this.toView(await this.departmentRepository.save(dept));
  }

  async update(id: string, dto: UpdateDepartmentDto, organizationId?: number) {
    await this.findById(id, organizationId);
    const updateData: Partial<DepartmentMaster> = {
      ...(dto.deptName !== undefined ? { deptName: dto.deptName } : {}),
      ...(dto.deptName !== undefined ? { deptNameLocal: dto.deptName } : {}),
      ...(dto.deptName !== undefined ? { deptNameEng: dto.deptName } : {}),
      ...(dto.parentDeptCode !== undefined ? { parentDeptCode: dto.parentDeptCode || '*' } : {}),
      ...(dto.remark !== undefined ? { remark: dto.remark } : {}),
      updatedAt: new Date(),
    };
    await this.departmentRepository.update({ deptCode: id, ...this.tenantWhere(organizationId) }, updateData);
    return this.findById(id, organizationId);
  }

  async delete(id: string, organizationId?: number) {
    await this.findById(id, organizationId);
    await this.departmentRepository.delete({ deptCode: id, ...this.tenantWhere(organizationId) });
    return { id };
  }
}
