import { Column, CreateDateColumn, Entity, PrimaryColumn, UpdateDateColumn } from 'typeorm';

@Entity({ name: 'IP_PRODUCT_WORKSTAGE_LINE' })
export class ProcessLine {
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @PrimaryColumn({ name: 'WORKSTAGE_CODE', type: 'varchar2', length: 10 })
  processCode!: string;

  @PrimaryColumn({ name: 'WORKSTAGE_TYPE', type: 'varchar2', length: 1 })
  processType!: string;

  @PrimaryColumn({ name: 'LINE_CODE', type: 'varchar2', length: 20 })
  lineCode!: string;

  @Column({ name: 'ENTER_BY', type: 'varchar2', length: 20, nullable: true })
  enterBy!: string | null;

  @CreateDateColumn({ name: 'ENTER_DATE', type: 'date', default: () => 'SYSDATE' })
  enterDate!: Date;

  @Column({ name: 'LAST_MODIFY_BY', type: 'varchar2', length: 20, nullable: true })
  lastModifyBy!: string | null;

  @UpdateDateColumn({ name: 'LAST_MODIFY_DATE', type: 'date', default: () => 'SYSDATE' })
  lastModifyDate!: Date;
}

