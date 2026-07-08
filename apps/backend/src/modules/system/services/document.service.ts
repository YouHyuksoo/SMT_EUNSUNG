/**
 * @file document.service.ts
 * @description 문서관리 서비스 — IATF 16949 7.5 문서화된 정보
 *
 * 초보자 가이드:
 * 1. **문서 CRUD**: 등록, 조회, 수정, 삭제
 * 2. **상태 흐름**: DRAFT → REVIEW → APPROVED → OBSOLETE
 * 3. **docNo 자동채번**: DOC-YYYYMMDD-NNN
 * 4. **개정(revise)**: 새 개정판 생성 (revisionNo 증가)
 *
 * 주요 메서드:
 * - generateDocNo(): 자동채번
 * - findAll(): 목록 조회 (페이지네이션 + 필터)
 * - findById() / create() / update() / delete()
 * - approve(): 승인 (DRAFT/REVIEW → APPROVED)
 * - revise(): 개정 (APPROVED → 새 DRAFT, revisionNo 증가)
 * - getExpiring(): 만료 예정 문서 조회
 */

import {
  Injectable,
  Logger,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { DocumentMaster } from '../../../entities/document-master.entity';
import {
  CreateDocumentDto,
  UpdateDocumentDto,
  DocumentQueryDto,
} from '../dto/document.dto';

@Injectable()
export class DocumentService {
  private readonly logger = new Logger(DocumentService.name);

  constructor(
    @InjectRepository(DocumentMaster)
    private readonly docRepo: Repository<DocumentMaster>,
  ) {}

  private tenantWhere(organizationId?: number | null) {
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
      throw new BadRequestException(
        `${context} 조직 정보가 일치하지 않습니다. request=${organizationId}, row=${row.organizationId ?? 'NULL'}`,
      );
    }
  }

  // =============================================
  // 문서번호 자동채번
  // =============================================

  /**
   * 문서번호 자동채번: DOC-YYYYMMDD-NNN
   */
  private async generateDocNo(
    organizationId: number,
  ): Promise<string> {
    const today = new Date();
    const dateStr = today.toISOString().slice(0, 10).replace(/-/g, '');
    const prefix = `DOC-${dateStr}-`;

    const last = await this.docRepo
      .createQueryBuilder('d')
      .where('d.organizationId = :organizationId', { organizationId })
      .andWhere('d.docNo LIKE :prefix', { prefix: `${prefix}%` })
      .orderBy('d.docNo', 'DESC')
      .getOne();

    const seq = last ? parseInt(last.docNo.slice(-3), 10) + 1 : 1;
    return `${prefix}${String(seq).padStart(3, '0')}`;
  }

  // =============================================
  // CRUD
  // =============================================

  /**
   * 문서 목록 조회 (페이지네이션 + 필터)
   */
  async findAll(query: DocumentQueryDto, organizationId?: number) {
    const {
      page = 1,
      limit = 50,
      status,
      docType,
      category,
      search,
      fromDate,
      toDate,
    } = query;

    const qb = this.docRepo.createQueryBuilder('d');

    if (organizationId != null) qb.andWhere('d.organizationId = :organizationId', { organizationId });
    if (status) qb.andWhere('d.status = :status', { status });
    if (docType) qb.andWhere('d.docType = :docType', { docType });
    if (category) qb.andWhere('d.category = :category', { category });
    if (search) {
      const upper = search.toUpperCase();
      qb.andWhere(
        '(d.docNo LIKE :sCode OR d.docTitle LIKE :sRaw)',
        { sCode: `%${upper}%`, sRaw: `%${search}%` },
      );
    }
    if (fromDate)
      qb.andWhere("d.createdAt >= TO_DATE(:fromDate, 'YYYY-MM-DD')", { fromDate });
    if (toDate)
      qb.andWhere("d.createdAt < TO_DATE(:toDate, 'YYYY-MM-DD') + INTERVAL '1' DAY", { toDate });

    qb.orderBy('d.createdAt', 'DESC');
    const total = await qb.getCount();
    const data = await qb
      .skip((page - 1) * limit)
      .take(limit)
      .getMany();

    return { data, total, page, limit };
  }

  /**
   * 문서 단건 조회
   */
  async findById(docNo: string, organizationId?: number) {
    const item = await this.docRepo.findOne({
      where: { docNo, ...this.tenantWhere(organizationId) },
    });
    if (!item) {
      throw new NotFoundException('문서를 찾을 수 없습니다.');
    }
    this.assertSameTenant('문서', item, organizationId);
    return item;
  }

  /**
   * 문서 등록 (DRAFT 상태로 생성)
   */
  async create(
    dto: CreateDocumentDto,
    organizationId: number,
    userId: string,
  ) {
    const docNo = await this.generateDocNo(organizationId);
    const entity = this.docRepo.create({
      docNo,
      docTitle: dto.docTitle,
      docType: dto.docType,
      category: dto.category ?? null,
      status: 'DRAFT',
      filePath: dto.filePath ?? null,
      fileSize: dto.fileSize ?? null,
      revisionNo: 1,
      retentionPeriod: dto.retentionPeriod ?? null,
      expiresAt: dto.expiresAt ? new Date(dto.expiresAt) : null,
      description: dto.description ?? null,
      organizationId,
      createdBy: userId,
      updatedBy: userId,
    });
    const saved = await this.docRepo.save(entity);
    this.logger.log(`문서 등록: ${docNo}`);
    return saved;
  }

  /**
   * 문서 수정 (DRAFT 상태에서만 가능)
   */
  async update(
    docNo: string,
    dto: UpdateDocumentDto,
    userId: string,
    organizationId?: number,
  ) {
    const item = await this.findById(docNo, organizationId);
    if (item.status !== 'DRAFT') {
      throw new BadRequestException('초안 상태에서만 수정할 수 있습니다.');
    }
    const updateData: Partial<Pick<DocumentMaster,
      | 'docTitle'
      | 'docType'
      | 'category'
      | 'filePath'
      | 'fileSize'
      | 'retentionPeriod'
      | 'expiresAt'
      | 'description'
    >> = {
      ...(dto.docTitle !== undefined ? { docTitle: dto.docTitle } : {}),
      ...(dto.docType !== undefined ? { docType: dto.docType } : {}),
      ...(dto.category !== undefined ? { category: dto.category } : {}),
      ...(dto.filePath !== undefined ? { filePath: dto.filePath } : {}),
      ...(dto.fileSize !== undefined ? { fileSize: dto.fileSize } : {}),
      ...(dto.retentionPeriod !== undefined ? { retentionPeriod: dto.retentionPeriod } : {}),
      ...(dto.expiresAt !== undefined ? { expiresAt: new Date(dto.expiresAt) } : {}),
      ...(dto.description !== undefined ? { description: dto.description } : {}),
    };
    Object.assign(item, updateData, { updatedBy: userId });
    return this.docRepo.save(item);
  }

  /**
   * 문서 삭제 (DRAFT 상태에서만 가능)
   */
  async delete(docNo: string, organizationId?: number) {
    const item = await this.findById(docNo, organizationId);
    if (item.status !== 'DRAFT') {
      throw new BadRequestException('초안 상태에서만 삭제할 수 있습니다.');
    }
    await this.docRepo.remove(item);
  }

  // =============================================
  // 상태 전이
  // =============================================

  /**
   * 승인 (DRAFT/REVIEW → APPROVED)
   */
  async approve(
    docNo: string,
    userId: string,
    organizationId?: number,
  ) {
    const item = await this.findById(docNo, organizationId);
    if (!['DRAFT', 'REVIEW'].includes(item.status)) {
      throw new BadRequestException(
        '초안 또는 검토 상태에서만 승인할 수 있습니다.',
      );
    }
    item.status = 'APPROVED';
    item.approvedBy = userId;
    item.approvedAt = new Date();
    item.revisionDate = new Date();
    item.updatedBy = userId;
    const saved = await this.docRepo.save(item);
    this.logger.log(`문서 승인: ${item.docNo}`);
    return saved;
  }

  /**
   * 개정 (APPROVED → 새 DRAFT, revisionNo 증가)
   */
  async revise(
    docNo: string,
    userId: string,
    organizationId?: number,
  ) {
    const item = await this.findById(docNo, organizationId);
    if (item.status !== 'APPROVED') {
      throw new BadRequestException(
        '승인된 문서만 개정할 수 있습니다.',
      );
    }

    // 기존 문서를 OBSOLETE 처리
    item.status = 'OBSOLETE';
    item.updatedBy = userId;
    await this.docRepo.save(item);

    // 새 개정판 생성
    const newDoc = this.docRepo.create({
      docNo: item.docNo,
      docTitle: item.docTitle,
      docType: item.docType,
      category: item.category,
      revisionNo: item.revisionNo + 1,
      status: 'DRAFT',
      filePath: item.filePath,
      retentionPeriod: item.retentionPeriod,
      description: item.description,
      organizationId: item.organizationId,
      createdBy: userId,
      updatedBy: userId,
    });

    // 기존 unique 제약 해결: docNo 변경
    item.docNo = `${item.docNo}-R${item.revisionNo}`;
    await this.docRepo.save(item);

    const saved = await this.docRepo.save(newDoc);
    this.logger.log(
      `문서 개정: ${saved.docNo} Rev.${saved.revisionNo}`,
    );
    return saved;
  }

  // =============================================
  // 만료 예정 문서 조회
  // =============================================

  /**
   * 만료 예정 문서 조회 (지정 일수 이내)
   */
  async getExpiring(
    days: number,
    organizationId?: number,
  ) {
    const futureDate = new Date();
    futureDate.setDate(futureDate.getDate() + days);

    const qb = this.docRepo
      .createQueryBuilder('d')
      .where('d.status = :status', { status: 'APPROVED' })
      .andWhere('d.expiresAt IS NOT NULL')
      .andWhere('d.expiresAt <= :futureDate', { futureDate });

    if (organizationId != null) qb.andWhere('d.organizationId = :organizationId', { organizationId });

    qb.orderBy('d.expiresAt', 'ASC');
    return qb.getMany();
  }
}
