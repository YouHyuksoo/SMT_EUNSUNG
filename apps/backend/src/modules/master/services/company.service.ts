/**
 * @file src/modules/master/services/company.service.ts
 * @description 회사마스터 비즈니스 로직 서비스 - TypeORM Repository 패턴
 *
 * 초보자 가이드:
 * 1. **findAll**: 페이지네이션 + 검색 지원 목록 조회
 * 2. **findPublic**: 인증 없이 활성 회사 목록 (로그인 페이지용)
 * 3. **CRUD**: 생성/수정/소프트삭제
 */

import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { IsysOrganization } from '../../../entities/isys-organization.entity';
import { CreateCompanyDto, UpdateCompanyDto, CompanyQueryDto } from '../dto/company.dto';

export interface CompanyView {
  companyCode: string;
  plant: string;
  plantName: string | null;
  companyName: string;
  bizNo: string | null;
  ceoName: string | null;
  address: string | null;
  tel: string | null;
  fax: string | null;
  email: string | null;
  remark: string | null;
  useYn: string;
  createdAt: Date | null;
  updatedAt: Date | null;
}

@Injectable()
export class CompanyService {
  constructor(
    @InjectRepository(IsysOrganization)
    private readonly companyRepository: Repository<IsysOrganization>,
  ) {}

  private toView(org: IsysOrganization): CompanyView {
    const organizationId = String(org.organizationId);
    return {
      companyCode: org.companyCode || organizationId,
      plant: organizationId,
      plantName: org.organizationName,
      companyName: org.organizationName || org.organizationFullName || org.companyCode || organizationId,
      bizNo: org.businessNo,
      ceoName: org.ownerName,
      address: org.address,
      tel: org.telNo,
      fax: org.faxNo,
      email: org.emailAddress,
      remark: org.organizationFullName,
      useYn: 'Y',
      createdAt: org.enterDate,
      updatedAt: org.lastModifyDate,
    };
  }

  private decodeId(id: string) {
    const [companyCode, plant] = id.split('::');
    const organizationId = Number(plant || companyCode);
    return {
      companyCode,
      organizationId: Number.isFinite(organizationId) ? organizationId : undefined,
    };
  }

  /** 회사 목록 조회 (페이지네이션 + 검색) */
  async findAll(query: CompanyQueryDto) {
    const { page = 1, limit = 10, search, useYn } = query;
    const skip = (page - 1) * limit;

    const queryBuilder = this.companyRepository.createQueryBuilder('company')

    if (useYn && useYn !== 'Y') {
      return { data: [], total: 0, page, limit };
    }

    if (search) {
      const upper = search.toUpperCase();
      queryBuilder.andWhere(
        '(UPPER(company.companyCode) LIKE :search OR company.organizationName LIKE :searchRaw OR company.businessNo LIKE :search)',
        { search: `%${upper}%`, searchRaw: `%${search}%` }
      );
    }

    const [rows, total] = await Promise.all([
      queryBuilder
        .orderBy('company.organizationId', 'ASC')
        .skip(skip)
        .take(limit)
        .getMany(),
      queryBuilder.getCount(),
    ]);

    return { data: rows.map((row) => this.toView(row)), total, page, limit };
  }

  /** 공개 API — 활성 회사 목록 (로그인 페이지용, 인증 불필요, 중복 제거) */
  async findPublic() {
    const rows = await this.companyRepository
      .createQueryBuilder('c')
      .select('c.companyCode', 'companyCode')
      .addSelect('c.organizationName', 'companyName')
      .addSelect('c.organizationId', 'organizationId')
      .orderBy('c.organizationId', 'ASC')
      .getRawMany();
    return rows.map((row: { companyCode: string | null; companyName: string | null; organizationId: number }) => ({
      companyCode: row.companyCode || String(row.organizationId),
      companyName: row.companyName || row.companyCode || String(row.organizationId),
    }));
  }

  /** 공개 API — 회사별 사업장 목록 (로그인 페이지용, 인증 불필요) */
  async findPlantsByCompany(companyCode: string) {
    const queryBuilder = this.companyRepository.createQueryBuilder('org');
    const numericId = Number(companyCode);
    if (Number.isFinite(numericId)) {
      queryBuilder.where('org.organizationId = :organizationId', { organizationId: numericId });
    } else {
      queryBuilder.where('org.companyCode = :companyCode', { companyCode });
    }
    const rows = await queryBuilder.orderBy('org.organizationId', 'ASC').getMany();
    return rows.map((r) => ({
      plantCode: String(r.organizationId),
      plantName: r.organizationName || String(r.organizationId),
    }));
  }

  /** 상세 조회 */
  async findById(id: string) {
    const { companyCode, organizationId } = this.decodeId(id);
    const company = organizationId != null
      ? await this.companyRepository.findOne({ where: { organizationId } })
      : await this.companyRepository.findOne({ where: { companyCode } });
    if (!company) throw new NotFoundException(`회사를 찾을 수 없습니다: ${id}`);
    return this.toView(company);
  }

  /** 생성 */
  async create(dto: CreateCompanyDto, company?: string, plant?: string) {
    const existing = await this.companyRepository.findOne({
      where: { companyCode: dto.companyCode },
    });
    if (existing) throw new ConflictException(`이미 존재하는 회사 코드입니다: ${dto.companyCode}`);

    const maxRow = await this.companyRepository
      .createQueryBuilder('org')
      .select('MAX(org.organizationId)', 'maxId')
      .getRawOne<{ maxId: number | null }>();
    const nextId = Number(maxRow?.maxId ?? 0) + 1;
    const entity = this.companyRepository.create({
      organizationId: nextId,
      companyCode: dto.companyCode?.slice(0, 10),
      organizationCode: dto.companyCode?.slice(0, 10),
      organizationName: dto.companyName,
      organizationFullName: dto.remark ?? dto.companyName,
      businessNo: dto.bizNo,
      ownerName: dto.ceoName,
      address: dto.address,
      telNo: dto.tel,
      faxNo: dto.fax,
      emailAddress: dto.email,
      enterDate: new Date(),
      enterBy: company ?? null,
      lastModifyDate: new Date(),
      lastModifyBy: plant ?? company ?? null,
    });

    return this.toView(await this.companyRepository.save(entity));
  }

  /** 수정 */
  async update(id: string, dto: UpdateCompanyDto, company?: string, plant?: string) {
    const existing = await this.findById(id);
    const updateData: Partial<IsysOrganization> = {
      ...(dto.companyName !== undefined ? { organizationName: dto.companyName } : {}),
      ...(dto.bizNo !== undefined ? { businessNo: dto.bizNo } : {}),
      ...(dto.ceoName !== undefined ? { ownerName: dto.ceoName } : {}),
      ...(dto.address !== undefined ? { address: dto.address } : {}),
      ...(dto.tel !== undefined ? { telNo: dto.tel } : {}),
      ...(dto.fax !== undefined ? { faxNo: dto.fax } : {}),
      ...(dto.email !== undefined ? { emailAddress: dto.email } : {}),
      ...(dto.remark !== undefined ? { organizationFullName: dto.remark } : {}),
      lastModifyDate: new Date(),
      lastModifyBy: plant ?? company ?? null,
    };
    await this.companyRepository.update({ organizationId: Number(existing.plant) }, updateData);
    return this.findById(id);
  }

  /** 소프트 삭제 */
  async delete(id: string) {
    const existing = await this.findById(id);
    await this.companyRepository.delete({ organizationId: Number(existing.plant) });
    return { id };
  }
}
