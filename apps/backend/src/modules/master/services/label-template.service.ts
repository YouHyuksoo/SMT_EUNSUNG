/**
 * @file src/modules/master/services/label-template.service.ts
 * @description 라벨 템플릿 서비스 - DB CRUD + 기본 템플릿 관리
 */
import {
  BadRequestException,
  Injectable,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, FindOptionsWhere } from 'typeorm';
import { LabelTemplate } from '../../../entities/label-template.entity';
import {
  CreateLabelTemplateDto,
  UpdateLabelTemplateDto,
  LabelTemplateQueryDto,
} from '../dto/label-template.dto';

@Injectable()
export class LabelTemplateService {
  constructor(
    @InjectRepository(LabelTemplate)
    private readonly labelTemplateRepository: Repository<LabelTemplate>,
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

  async findAll(query: LabelTemplateQueryDto, organizationId?: number) {
    const { page = 1, limit = 50, category, search } = query;

    const queryBuilder = this.labelTemplateRepository.createQueryBuilder('template');

    if (organizationId != null) {
      queryBuilder.andWhere('template.organizationId = :organizationId', { organizationId });
    }

    if (category) {
      queryBuilder.andWhere('template.category = :category', { category });
    }

    if (search) {
      queryBuilder.andWhere('template.templateName LIKE :search', {
        search: `%${search}%`,
      });
    }

    const [data, total] = await queryBuilder
      .orderBy('template.category', 'ASC')
      .addOrderBy('template.templateName', 'ASC')
      .skip((page - 1) * limit)
      .take(limit)
      .getManyAndCount();

    return { data, total, page, limit };
  }

  async findById(id: string, organizationId?: number) {
    // id는 "templateName::category" 형식 또는 단순 조회용
    const [templateName, category] = id.includes('::') ? id.split('::') : [id, undefined];
    const where: FindOptionsWhere<LabelTemplate> = category
      ? { templateName, category }
      : { templateName };

    const template = await this.labelTemplateRepository.findOne({
      where: { ...where, ...this.tenantWhere(organizationId) },
    });

    if (!template) {
      throw new NotFoundException('라벨 템플릿을 찾을 수 없습니다.');
    }
    this.assertSameTenant('라벨 템플릿', template, organizationId);

    return template;
  }

  async findByKey(templateName: string, category: string, organizationId?: number) {
    const template = await this.labelTemplateRepository.findOne({
      where: { templateName, category, ...this.tenantWhere(organizationId) },
    });

    if (!template) {
      throw new NotFoundException('라벨 템플릿을 찾을 수 없습니다.');
    }
    this.assertSameTenant('라벨 템플릿', template, organizationId);

    return template;
  }

  async create(dto: CreateLabelTemplateDto, organizationId?: number) {
    const existing = await this.labelTemplateRepository.findOne({
      where: { templateName: dto.templateName, category: dto.category, ...this.tenantWhere(organizationId) },
    });
    if (existing) {
      throw new ConflictException(`이미 등록된 라벨 템플릿입니다: ${dto.templateName}/${dto.category}`);
    }

    if (dto.isDefault) {
      await this.clearDefaultByCategory(dto.category, organizationId);
    }

    const entity = this.labelTemplateRepository.create({
      templateName: dto.templateName,
      category: dto.category,
      designData: JSON.stringify(dto.designData),
      isDefault: dto.isDefault ?? false,
      remark: dto.remark ?? null,
      zplCode: dto.zplCode ?? null,
      printMode: dto.printMode ?? 'BROWSER',
      printerId: dto.printerId ?? null,
      useYn: 'Y',
      organizationId,
    });
    const saved = await this.labelTemplateRepository.save(entity);
    return saved;
  }

  async update(id: string, dto: UpdateLabelTemplateDto, organizationId?: number) {
    const template = await this.findById(id, organizationId);

    if (dto.isDefault) {
      await this.clearDefaultByCategory(template.category, organizationId);
    }

    // Build update data manually to handle type conversion
    const updateData: Partial<LabelTemplate> = {
      isDefault: dto.isDefault,
      remark: dto.remark,
      zplCode: dto.zplCode,
      printMode: dto.printMode,
      printerId: dto.printerId,
    };

    if (dto.designData) {
      updateData.designData = JSON.stringify(dto.designData);
    }

    const updated = await this.labelTemplateRepository.save({
      ...template,
      ...updateData,
      templateName: template.templateName,
      category: template.category,
      organizationId: template.organizationId,
    });

    return updated;
  }

  async delete(id: string, organizationId?: number) {
    const template = await this.findById(id, organizationId);

    await this.labelTemplateRepository.remove(template);

    return { templateName: template.templateName, category: template.category, deleted: true };
  }

  private async clearDefaultByCategory(category: string, organizationId?: number): Promise<void> {
    const qb = this.labelTemplateRepository
      .createQueryBuilder()
      .update(LabelTemplate)
      .set({ isDefault: false })
      .where('category = :category', { category })
      .andWhere('isDefault = :isDefault', { isDefault: true });

    if (organizationId != null) qb.andWhere('organizationId = :organizationId', { organizationId });

    await qb.execute();
  }
}
