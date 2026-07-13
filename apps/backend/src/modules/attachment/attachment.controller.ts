/**
 * @file modules/attachment/attachment.controller.ts
 * @description 파일첨부 공통 컨트롤러 (전역 prefix 포함 시 /api/v1/files).
 *  - POST   /files/upload?businessType=&refKey=   복수 업로드 (multipart field: files)
 *  - GET    /files?businessType=&refKey=           목록 조회
 *  - GET    /files/:id                             단건 다운로드
 *  - DELETE /files                                 일괄 삭제 (body: { ids: number[] })
 *  일괄 내려받기는 프론트 공통 컴포넌트가 GET /files/:id 를 순회 호출.
 */
import { Controller, Post, Get, Delete, Param, Query, Body, Req, Res, UploadedFiles, UseInterceptors, ParseIntPipe, BadRequestException } from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import type { Request, Response } from 'express';
import * as fs from 'fs';
import * as path from 'path';
import { AttachmentService, UPLOAD_ROOT, sanitizeSegment } from './attachment.service';
import { DeleteAttachmentDto } from './attachment.dto';

function currentUser(req: Request): string | null {
  const auth = (req.headers['authorization'] as string) || '';
  return auth.replace(/^Bearer\s+/i, '').trim() || null;
}

@Controller('files')
export class AttachmentController {
  constructor(private readonly service: AttachmentService) {}

  @Post('upload')
  @UseInterceptors(
    FilesInterceptor('files', 20, {
      storage: diskStorage({
        destination: (req, _file, cb) => {
          const bt = sanitizeSegment(String((req.query as Record<string, string>).businessType || 'common'));
          const year = String(new Date().getFullYear());
          const dir = path.join(UPLOAD_ROOT, year, bt);
          fs.mkdirSync(dir, { recursive: true });
          cb(null, dir);
        },
        filename: (_req, file, cb) => {
          const ext = path.extname(file.originalname);
          cb(null, `${Date.now()}_${Math.random().toString(36).slice(2, 8)}${ext}`);
        },
      }),
      limits: { fileSize: 50 * 1024 * 1024 }, // 50MB
    }),
  )
  async upload(
    @UploadedFiles() files: Express.Multer.File[],
    @Query('businessType') businessType: string,
    @Query('refKey') refKey: string,
    @Req() req: Request,
  ) {
    if (!files?.length) throw new BadRequestException('업로드할 파일이 없습니다.');
    if (!businessType) throw new BadRequestException('businessType 은 필수입니다.');
    return this.service.saveUploaded(files, businessType, refKey || null, currentUser(req));
  }

  @Get()
  async list(@Query('businessType') businessType?: string, @Query('refKey') refKey?: string) {
    return this.service.list(businessType, refKey);
  }

  @Get(':id')
  async download(@Param('id', ParseIntPipe) id: number, @Res() res: Response) {
    const { absPath, name } = await this.service.getForDownload(id);
    res.download(absPath, name);
  }

  @Delete()
  async remove(@Body() dto: DeleteAttachmentDto) {
    return this.service.remove(dto?.ids ?? []);
  }
}
