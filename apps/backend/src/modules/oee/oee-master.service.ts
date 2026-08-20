/**
 * @file src/modules/oee/oee-master.service.ts
 * @description OEE 리소스·비가동사유 마스터 CRUD.
 */
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { OeeResource } from '../../entities/oee-resource.entity';
import { OeeDowntimeReason } from '../../entities/oee-downtime-reason.entity';
import { ResourceUpsertDto, ReasonUpsertDto } from './oee.dto';

@Injectable()
export class OeeMasterService {
  constructor(
    @InjectRepository(OeeResource)
    private readonly resourceRepo: Repository<OeeResource>,
    @InjectRepository(OeeDowntimeReason)
    private readonly reasonRepo: Repository<OeeDowntimeReason>,
  ) {}

  async listResources(organizationId?: number): Promise<OeeResource[]> {
    const organization = this.requireOrganization(organizationId);
    return this.resourceRepo.find({
      where: { organizationId: organization, useYn: 'Y' },
      order: { processCode: 'ASC', sortOrder: 'ASC' },
    });
  }

  async upsertResource(dto: ResourceUpsertDto, organizationId?: number): Promise<void> {
    const organization = this.requireOrganization(organizationId);
    const fields = {
      organizationId: organization,
      processCode: dto.processCode,
      resourceType: dto.resourceType,
      refCode: dto.refCode ?? null,
      resourceName: dto.resourceName,
      idealCt: dto.idealCt ?? null,
      useYn: dto.useYn ?? 'Y',
      sortOrder: dto.sortOrder ?? 0,
    };
    if (dto.resourceId) {
      const result = await this.resourceRepo.update(
        { resourceId: dto.resourceId, organizationId: organization },
        fields,
      );
      if (result.affected !== 1) {
        throw new NotFoundException('인증 조직의 OEE 리소스를 찾을 수 없습니다.');
      }
    } else {
      await this.resourceRepo.insert(fields);
    }
  }

  async listReasons(organizationId?: number): Promise<OeeDowntimeReason[]> {
    const organization = this.requireOrganization(organizationId);
    return this.reasonRepo.find({
      where: { organizationId: organization, useYn: 'Y' },
      order: { sortOrder: 'ASC' },
    });
  }

  async upsertReason(dto: ReasonUpsertDto, isUpdate: boolean, organizationId?: number): Promise<void> {
    const organization = this.requireOrganization(organizationId);
    const fields = {
      organizationId: organization,
      processCode: dto.processCode ?? '*',
      reasonName: dto.reasonName,
      lossBucket: dto.lossBucket,
      oeeFactor: dto.oeeFactor,
      useYn: dto.useYn ?? 'Y',
      sortOrder: dto.sortOrder ?? 0,
    };
    if (isUpdate) {
      const result = await this.reasonRepo.update(
        { reasonCode: dto.reasonCode, organizationId: organization },
        fields,
      );
      if (result.affected !== 1) {
        throw new NotFoundException('인증 조직의 OEE 비가동 사유를 찾을 수 없습니다.');
      }
    } else {
      await this.reasonRepo.insert({ reasonCode: dto.reasonCode, ...fields });
    }
  }

  private requireOrganization(organizationId?: number): number {
    if (organizationId == null || !Number.isInteger(organizationId) || organizationId <= 0) {
      throw new BadRequestException('인증 조직 정보가 필요합니다.');
    }
    return organizationId;
  }
}
