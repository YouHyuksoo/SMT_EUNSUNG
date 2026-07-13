/**
 * @file entities/file-attachment.entity.ts
 * @description 파일첨부 공통 메타테이블 (FILE_ATTACHMENTS) 엔티티.
 *  - 실제 파일은 uploads/<연도>/<업무구분>/ 에 저장하고, 본 테이블에 메타를 기록한다.
 *  - FILE_BFILE(BFILE) 컬럼은 DB 스키마에 존재하나 TypeORM 엔티티에는 매핑하지 않는다
 *    (BFILE read는 Oracle DIRECTORY 객체가 필요 — 운영에서 DBA가 생성 후 FILE_PATH로 채운다).
 */
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity({ name: 'FILE_ATTACHMENTS' })
export class FileAttachment {
  @PrimaryGeneratedColumn({ name: 'ATTACHMENT_ID' })
  attachmentId: number;

  /** 업무구분 — 저장 폴더/조회 분류 (예: 무작업사유, 품목) */
  @Column({ name: 'BUSINESS_TYPE', length: 50 })
  businessType: string;

  /** 소속 레코드 키 (예: 사유코드). 미연결 시 null */
  @Column({ name: 'REF_KEY', length: 100, nullable: true })
  refKey: string | null;

  @Column({ name: 'FILE_YEAR', length: 4 })
  fileYear: string;

  @Column({ name: 'ORIGINAL_NAME', length: 300 })
  originalName: string;

  @Column({ name: 'STORED_NAME', length: 300 })
  storedName: string;

  /** uploads 하위 상대경로: <연도>/<업무구분>/<저장명> */
  @Column({ name: 'FILE_PATH', length: 500 })
  filePath: string;

  /** 정적 서빙 URL: /uploads/<상대경로> */
  @Column({ name: 'FILE_URL', length: 600 })
  fileUrl: string;

  @Column({ name: 'FILE_SIZE', type: 'number', nullable: true })
  fileSize: number | null;

  @Column({ name: 'MIME_TYPE', length: 200, nullable: true })
  mimeType: string | null;

  @Column({ name: 'DEL_YN', length: 1, default: 'N' })
  delYn: string;

  @Column({ name: 'CREATED_BY', length: 50, nullable: true })
  createdBy: string | null;

  @CreateDateColumn({ name: 'CREATED_AT', type: 'date' })
  createdAt: Date;
}
