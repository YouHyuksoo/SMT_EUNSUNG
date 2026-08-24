// 작업지시 단위 대표불량 단일 등록 (IP_PRODUCT_WORK_DEFECT) — 실적과 독립
import { Entity, PrimaryColumn, Column } from 'typeorm';

@Entity({ name: 'IP_PRODUCT_WORK_DEFECT' })
export class ProductWorkDefect {
  @PrimaryColumn({ name: 'RUN_NO', length: 30 }) runNo: string;
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' }) organizationId: number;

  @Column({ name: 'BAD_CODE', length: 20, nullable: true }) badCode: string | null;
  @Column({ name: 'BAD_QTY', type: 'number', nullable: true }) badQty: number | null;
  @Column({ name: 'REMARK', length: 500, nullable: true }) remark: string | null;
  @Column({ name: 'ENTER_BY', length: 20, nullable: true }) enterBy: string | null;
  @Column({ name: 'ENTER_DATE', type: 'date', nullable: true }) enterDate: Date | null;
  @Column({ name: 'LAST_MODIFY_BY', length: 20, nullable: true }) lastModifyBy: string | null;
  @Column({ name: 'LAST_MODIFY_DATE', type: 'date', nullable: true }) lastModifyDate: Date | null;
}
