/**
 * @file modules/attachment/attachment.dto.ts
 * @description 파일첨부 공통 모듈 DTO — 프론트 공통 컴포넌트(FileAttachment)와 계약.
 */
import { IsArray, IsInt } from 'class-validator';
import { Type } from 'class-transformer';

/** 업로드/조회 응답 — 프론트 AttachedFile 형태 */
export class AttachmentDto {
  id: string; // attachmentId(문자열)
  name: string; // 원본 파일명
  size: number | null;
  url: string; // /uploads/... 서빙 URL
  businessType: string;
  refKey: string | null;
  createdAt: string;
  createdBy: string | null;
}

export class DeleteAttachmentDto {
  @IsArray()
  @IsInt({ each: true })
  @Type(() => Number)
  ids: number[];
}
