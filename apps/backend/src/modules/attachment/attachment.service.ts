/**
 * @file modules/attachment/attachment.service.ts
 * @description 파일첨부 공통 서비스 — 업로드 메타 기록, 조회, 삭제. 실제 파일은 uploads/<연도>/<업무구분>/.
 */
import { Injectable, NotFoundException, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import * as fs from 'fs';
import * as path from 'path';
import { FileAttachment } from '../../entities/file-attachment.entity';
import { AttachmentDto } from './attachment.dto';

export const UPLOAD_ROOT = path.join(process.cwd(), 'uploads');

/** 업무구분 폴더명 정규화 (경로 안전) */
export function sanitizeSegment(seg: string): string {
  return (seg || 'common').replace(/[^\w가-힣.-]/g, '_').slice(0, 50);
}

@Injectable()
export class AttachmentService {
  private readonly logger = new Logger(AttachmentService.name);

  constructor(
    @InjectRepository(FileAttachment)
    private readonly repo: Repository<FileAttachment>,
  ) {}

  private toDto(a: FileAttachment): AttachmentDto {
    return {
      id: String(a.attachmentId),
      name: a.originalName,
      size: a.fileSize,
      url: a.fileUrl,
      businessType: a.businessType,
      refKey: a.refKey,
      createdAt: a.createdAt ? new Date(a.createdAt).toISOString() : '',
      createdBy: a.createdBy,
    };
  }

  /** multer가 디스크에 저장한 파일들의 메타를 기록 */
  async saveUploaded(
    files: Express.Multer.File[],
    businessType: string,
    refKey: string | null,
    user: string | null,
  ): Promise<AttachmentDto[]> {
    const bt = sanitizeSegment(businessType);
    const year = String(new Date().getFullYear());
    const saved: FileAttachment[] = [];
    for (const f of files) {
      // 한글 파일명 latin1 → utf8 보정 (multipart 기본 인코딩 이슈)
      const originalName = Buffer.from(f.originalname, 'latin1').toString('utf8');
      const relPath = path.relative(UPLOAD_ROOT, f.path).split(path.sep).join('/');
      const entity = this.repo.create({
        businessType: bt,
        refKey: refKey || null,
        fileYear: year,
        originalName,
        storedName: f.filename,
        filePath: relPath,
        fileUrl: `/uploads/${relPath}`,
        fileSize: f.size,
        mimeType: f.mimetype,
        delYn: 'N',
        createdBy: user,
      });
      saved.push(await this.repo.save(entity));
    }
    this.logger.log(`첨부 ${saved.length}건 저장 (businessType=${bt}, refKey=${refKey ?? '-'})`);
    return saved.map((a) => this.toDto(a));
  }

  /** 업무구분/참조키로 첨부 목록 조회 */
  async list(businessType?: string, refKey?: string): Promise<AttachmentDto[]> {
    const where: Record<string, unknown> = { delYn: 'N' };
    if (businessType) where.businessType = sanitizeSegment(businessType);
    if (refKey) where.refKey = refKey;
    const rows = await this.repo.find({ where, order: { attachmentId: 'ASC' } });
    return rows.map((a) => this.toDto(a));
  }

  /** 단건 조회 (다운로드용) — 디스크 절대경로 포함 */
  async getForDownload(id: number): Promise<{ absPath: string; name: string; mime: string | null }> {
    const a = await this.repo.findOne({ where: { attachmentId: id, delYn: 'N' } });
    if (!a) throw new NotFoundException('첨부파일을 찾을 수 없습니다.');
    const absPath = path.join(UPLOAD_ROOT, a.filePath);
    if (!fs.existsSync(absPath)) throw new NotFoundException('파일 실체가 없습니다.');
    return { absPath, name: a.originalName, mime: a.mimeType };
  }

  /** 일괄 삭제 (소프트 삭제 + 디스크 파일 제거) */
  async remove(ids: number[]): Promise<{ deleted: number }> {
    if (!ids?.length) return { deleted: 0 };
    const rows = await this.repo.find({ where: { attachmentId: In(ids), delYn: 'N' } });
    for (const a of rows) {
      const abs = path.join(UPLOAD_ROOT, a.filePath);
      try {
        if (fs.existsSync(abs)) fs.unlinkSync(abs);
      } catch (e) {
        this.logger.warn(`디스크 파일 삭제 실패: ${abs} (${(e as Error).message})`);
      }
      a.delYn = 'Y';
    }
    await this.repo.save(rows);
    return { deleted: rows.length };
  }
}
