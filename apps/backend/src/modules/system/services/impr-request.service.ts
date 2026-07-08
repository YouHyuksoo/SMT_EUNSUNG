/**
 * @file services/impr-request.service.ts
 * @description 개선요청 CRUD 서비스
 *
 * 초보자 가이드:
 * 1. create: UUID를 애플리케이션에서 생성하여 PK로 사용
 * 2. findAll: STATUS 필터 + 페이지네이션, 스크린샷 컬럼 제외
 * 3. findOne: 스크린샷 포함 단건 조회
 * 4. updateStatus: PENDING → IN_PROGRESS → DONE 상태 전이
 */
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ImprRequest } from '../../../entities/impr-request.entity';
import {
  CreateImprRequestDto,
  ImprRequestQueryDto,
  UpdateImprStatusDto,
} from '../dto/impr-request.dto';
import { randomUUID } from 'crypto';

@Injectable()
export class ImprRequestService {
  constructor(
    @InjectRepository(ImprRequest)
    private readonly repo: Repository<ImprRequest>,
  ) {}

  async create(
    dto: CreateImprRequestDto,
    requesterId: string,
    requesterNm: string | null,
    organizationId: number,
  ): Promise<ImprRequest> {
    const entity = this.repo.create({
      imprId: randomUUID(),
      pageUrl: dto.pageUrl,
      elementText: dto.elementText ?? null,
      elementTag: dto.elementTag ?? null,
      description: dto.description,
      screenshot: dto.screenshot ?? null,
      status: 'PENDING',
      requesterId,
      requesterNm,
      organizationId,
    });
    return this.repo.save(entity);
  }

  async findAll(query: ImprRequestQueryDto, organizationId: number) {
    const page = Number(query.page) || 1;
    const limit = Number(query.limit) || 20;
    const skip = (page - 1) * limit;

    const qb = this.repo.createQueryBuilder('r')
      .select([
        'r.imprId', 'r.pageUrl', 'r.elementText', 'r.elementTag',
        'r.description', 'r.status', 'r.requesterId', 'r.requesterNm',
        'r.organizationId', 'r.createdAt', 'r.updatedAt',
      ])
      .where('r.organizationId = :organizationId', { organizationId });

    if (query.status && query.status !== 'ALL') {
      qb.andWhere('r.status = :status', { status: query.status });
    }

    if (query.keyword) {
      qb.andWhere(
        '(LOWER(r.description) LIKE :kw OR LOWER(r.pageUrl) LIKE :kw)',
        { kw: `%${query.keyword.toLowerCase()}%` },
      );
    }

    if (query.fromDate) {
      qb.andWhere('r.createdAt >= :fromDate', { fromDate: new Date(query.fromDate) });
    }

    if (query.toDate) {
      const to = new Date(query.toDate);
      to.setDate(to.getDate() + 1);
      qb.andWhere('r.createdAt < :toDate', { toDate: to });
    }

    qb.orderBy('r.createdAt', 'DESC').skip(skip).take(limit);

    const [data, total] = await qb.getManyAndCount();
    return { data, total, page, limit };
  }

  async findOne(imprId: string, organizationId: number): Promise<ImprRequest> {
    const item = await this.repo.findOne({
      where: { imprId, organizationId },
    });
    if (!item) throw new NotFoundException(`ImprRequest ${imprId} not found`);
    return item;
  }

  async updateStatus(
    imprId: string,
    dto: UpdateImprStatusDto,
    organizationId: number,
  ): Promise<ImprRequest> {
    const item = await this.findOne(imprId, organizationId);
    item.status = dto.status;
    return this.repo.save(item);
  }
}
