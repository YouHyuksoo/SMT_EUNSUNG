import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { SupplierMaster } from '../../../entities/supplier-master.entity';
import { CreatePartnerDto, PartnerQueryDto, UpdatePartnerDto } from '../dto/partner.dto';

@Injectable()
export class PartnerService {
  constructor(
    @InjectRepository(SupplierMaster)
    private readonly supplierRepository: Repository<SupplierMaster>,
  ) {}

  private tenantWhere(organizationId?: number) {
    return organizationId != null ? { organizationId } : {};
  }

  private toPartner(supplier: SupplierMaster) {
    return {
      partnerCode: supplier.supplierCode,
      partnerName: supplier.supplierName,
      partnerType: 'SUPPLIER',
      bizNo: supplier.businessNo ?? null,
      ceoName: supplier.ownerName ?? null,
      address: supplier.address ?? null,
      tel: supplier.telNo ?? null,
      fax: supplier.faxNo ?? null,
      email: supplier.emailAddress ?? null,
      contactPerson: supplier.supplierChargeName ?? null,
      qualityGrade: null,
      inspectionMode: 'NORMAL',
      remark: null,
      useYn: supplier.businessStatus === 'A' ? 'Y' : 'N',
      organizationId: supplier.organizationId,
      createdBy: supplier.enterBy ?? null,
      updatedBy: supplier.lastModifyBy ?? null,
      createdAt: supplier.enterDate ?? supplier.dateSet,
      updatedAt: supplier.lastModifyDate ?? supplier.dateSet,
    };
  }

  async findAll(query: PartnerQueryDto, organizationId?: number) {
    const { page = 1, limit = 10, partnerType, search, useYn } = query;
    if (partnerType && partnerType !== 'SUPPLIER') return { data: [], total: 0, page, limit };

    const queryBuilder = this.supplierRepository.createQueryBuilder('supplier');
    if (organizationId != null) {
      queryBuilder.andWhere('supplier.organizationId = :organizationId', { organizationId });
    }
    if (useYn) {
      queryBuilder.andWhere('supplier.businessStatus = :businessStatus', {
        businessStatus: useYn === 'Y' ? 'A' : 'I',
      });
    }
    if (search) {
      queryBuilder.andWhere(
        '(UPPER(supplier.supplierCode) LIKE :search OR UPPER(supplier.supplierName) LIKE :search OR UPPER(supplier.businessNo) LIKE :search OR UPPER(supplier.supplierChargeName) LIKE :search)',
        { search: `%${search.toUpperCase()}%` },
      );
    }

    const [suppliers, total] = await Promise.all([
      queryBuilder.orderBy('supplier.supplierCode', 'ASC').skip((page - 1) * limit).take(limit).getMany(),
      queryBuilder.getCount(),
    ]);
    return { data: suppliers.map((supplier) => this.toPartner(supplier)), total, page, limit };
  }

  async findById(partnerCode: string, organizationId?: number) {
    const supplier = await this.supplierRepository.findOne({
      where: { supplierCode: partnerCode, ...this.tenantWhere(organizationId) },
    });
    if (!supplier) throw new NotFoundException(`공급사를 찾을 수 없습니다: ${partnerCode}`);
    return this.toPartner(supplier);
  }

  findByCode(partnerCode: string, organizationId?: number) {
    return this.findById(partnerCode, organizationId);
  }

  async create(dto: CreatePartnerDto, organizationId?: number) {
    const existing = await this.supplierRepository.findOne({
      where: { supplierCode: dto.partnerCode, ...this.tenantWhere(organizationId) },
    });
    if (existing) throw new ConflictException(`이미 존재하는 공급사 코드입니다: ${dto.partnerCode}`);

    const now = new Date();
    const supplier = this.supplierRepository.create({
      supplierCode: dto.partnerCode,
      organizationId,
      supplierName: dto.partnerName,
      supplierNameEng: dto.partnerName,
      dateSet: now,
      dateEnd: new Date('9999-12-31T00:00:00'),
      businessNo: dto.bizNo ?? null,
      businessStatus: dto.useYn === 'N' ? 'I' : 'A',
      businessType: 'S',
      supplierChargeName: dto.contactPerson ?? null,
      paymentType: 'D',
      ownerName: dto.ceoName ?? null,
      address: dto.address ?? null,
      telNo: dto.tel || '-',
      faxNo: dto.fax ?? null,
      emailAddress: dto.email ?? null,
      enterDate: now,
      lastModifyDate: now,
    });
    return this.toPartner(await this.supplierRepository.save(supplier));
  }

  async update(partnerCode: string, dto: UpdatePartnerDto, organizationId?: number) {
    await this.findById(partnerCode, organizationId);
    const updateData: Partial<SupplierMaster> = {
      ...(dto.partnerName !== undefined ? { supplierName: dto.partnerName } : {}),
      ...(dto.bizNo !== undefined ? { businessNo: dto.bizNo || null } : {}),
      ...(dto.ceoName !== undefined ? { ownerName: dto.ceoName || null } : {}),
      ...(dto.address !== undefined ? { address: dto.address || null } : {}),
      ...(dto.tel !== undefined ? { telNo: dto.tel || '-' } : {}),
      ...(dto.fax !== undefined ? { faxNo: dto.fax || null } : {}),
      ...(dto.email !== undefined ? { emailAddress: dto.email || null } : {}),
      ...(dto.contactPerson !== undefined ? { supplierChargeName: dto.contactPerson || null } : {}),
      ...(dto.useYn !== undefined ? { businessStatus: dto.useYn === 'Y' ? 'A' : 'I' } : {}),
      lastModifyDate: new Date(),
    };
    await this.supplierRepository.update(
      { supplierCode: partnerCode, ...this.tenantWhere(organizationId) },
      updateData,
    );
    return this.findById(partnerCode, organizationId);
  }

  async delete(partnerCode: string, organizationId?: number) {
    await this.findById(partnerCode, organizationId);
    await this.supplierRepository.delete({
      supplierCode: partnerCode,
      ...this.tenantWhere(organizationId),
    });
    return { partnerCode };
  }

  async findByType(partnerType: string, organizationId?: number) {
    if (partnerType !== 'SUPPLIER') return [];
    const suppliers = await this.supplierRepository.find({
      where: { businessStatus: 'A', ...this.tenantWhere(organizationId) },
      order: { supplierCode: 'asc' },
    });
    return suppliers.map((supplier) => this.toPartner(supplier));
  }

  async getStatistics(organizationId?: number) {
    const qb = this.supplierRepository
      .createQueryBuilder('supplier')
      .select('COUNT(*)', 'totalCount')
      .addSelect("SUM(CASE WHEN supplier.businessStatus = 'A' THEN 1 ELSE 0 END)", 'activeCount');
    if (organizationId != null) {
      qb.andWhere('supplier.organizationId = :organizationId', { organizationId });
    }
    const stats = await qb.getRawOne();
    return {
      totalCount: Number(stats.totalCount) || 0,
      supplierCount: Number(stats.totalCount) || 0,
      customerCount: 0,
      activeCount: Number(stats.activeCount) || 0,
    };
  }
}
