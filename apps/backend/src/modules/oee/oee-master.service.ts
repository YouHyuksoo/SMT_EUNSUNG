/**
 * @file src/modules/oee/oee-master.service.ts
 * @description OEE 리소스·비가동사유 마스터 CRUD.
 */
import { Injectable } from '@nestjs/common';
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

  listResources(): Promise<OeeResource[]> {
    return this.resourceRepo.find({
      where: { useYn: 'Y' },
      order: { processCode: 'ASC', sortOrder: 'ASC' },
    });
  }

  async upsertResource(dto: ResourceUpsertDto): Promise<void> {
    const fields = {
      organizationId: dto.organizationId,
      processCode: dto.processCode,
      resourceType: dto.resourceType,
      refCode: dto.refCode ?? null,
      resourceName: dto.resourceName,
      idealCt: dto.idealCt ?? null,
      useYn: dto.useYn ?? 'Y',
      sortOrder: dto.sortOrder ?? 0,
    };
    if (dto.resourceId) {
      await this.resourceRepo.update(dto.resourceId, fields);
    } else {
      await this.resourceRepo.insert(fields);
    }
  }

  listReasons(): Promise<OeeDowntimeReason[]> {
    return this.reasonRepo.find({
      where: { useYn: 'Y' },
      order: { sortOrder: 'ASC' },
    });
  }

  async upsertReason(dto: ReasonUpsertDto, isUpdate: boolean): Promise<void> {
    const fields = {
      organizationId: dto.organizationId,
      processCode: dto.processCode ?? '*',
      reasonName: dto.reasonName,
      lossBucket: dto.lossBucket,
      oeeFactor: dto.oeeFactor,
      useYn: dto.useYn ?? 'Y',
      sortOrder: dto.sortOrder ?? 0,
    };
    if (isUpdate) {
      await this.reasonRepo.update(dto.reasonCode, fields);
    } else {
      await this.reasonRepo.insert({ reasonCode: dto.reasonCode, ...fields });
    }
  }
}
