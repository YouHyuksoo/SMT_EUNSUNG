// 표준시간 관리 — 품목(모델)별 ST/CT/NT/TT 표준시간 마스터 (IP_PRODUCT_ST_MASTER)
import { Entity, PrimaryColumn, Column } from 'typeorm';

@Entity({ name: 'IP_PRODUCT_ST_MASTER' })
export class ProductStMaster {
  @PrimaryColumn({ name: 'ITEM_CODE', length: 20 })
  itemCode: string;

  @PrimaryColumn({ name: 'DATESET', type: 'date' })
  dateset: Date;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId: number;

  @Column({ name: 'DATEEND', type: 'date', nullable: true })
  dateend: Date | null;

  @Column({ name: 'ST_VALUE', type: 'number', nullable: true })
  stValue: number | null;

  @Column({ name: 'CT_VALUE', type: 'number', nullable: true })
  ctValue: number | null;

  @Column({ name: 'NT_VALUE', type: 'number', nullable: true })
  ntValue: number | null;

  @Column({ name: 'TT_VALUE', type: 'number', nullable: true })
  ttValue: number | null;

  @Column({ name: 'REMARK', length: 500, nullable: true })
  remark: string | null;

  @Column({ name: 'ENTER_BY', length: 20, nullable: true })
  enterBy: string | null;

  @Column({ name: 'ENTER_DATE', type: 'date', nullable: true })
  enterDate: Date | null;

  @Column({ name: 'LAST_MODIFY_BY', length: 20, nullable: true })
  lastModifyBy: string | null;

  @Column({ name: 'LAST_MODIFY_DATE', type: 'date', nullable: true })
  lastModifyDate: Date | null;
}
