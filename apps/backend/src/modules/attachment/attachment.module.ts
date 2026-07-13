/**
 * @file modules/attachment/attachment.module.ts
 * @description 파일첨부 공통 모듈 — 모든 화면에서 재사용하는 첨부 업로드/조회/삭제.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { FileAttachment } from '../../entities/file-attachment.entity';
import { AttachmentService } from './attachment.service';
import { AttachmentController } from './attachment.controller';

@Module({
  imports: [TypeOrmModule.forFeature([FileAttachment])],
  controllers: [AttachmentController],
  providers: [AttachmentService],
  exports: [AttachmentService],
})
export class AttachmentModule {}
