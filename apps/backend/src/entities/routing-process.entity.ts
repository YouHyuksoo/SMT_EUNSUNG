import { Column, CreateDateColumn, Entity, Index, PrimaryColumn, UpdateDateColumn } from 'typeorm';

@Entity({ name: 'IP_ROUTING_PROCESSES' })
@Index(['organizationId', 'routingCode'])
export class RoutingProcess {
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @PrimaryColumn({ name: 'ROUTING_CODE', type: 'varchar2', length: 50 })
  routingCode!: string;

  @PrimaryColumn({ name: 'PROCESS_SEQ', type: 'number', precision: 10 })
  processSeq!: number;

  @Column({ name: 'WORKSTAGE_CODE', type: 'varchar2', length: 10 })
  workstageCode!: string;

  @Column({ name: 'EXECUTION_TYPE', type: 'varchar2', length: 20, default: 'INTERNAL' })
  executionType!: 'INTERNAL' | 'SUBCON';

  @Column({ name: 'JOB_ORDER_YN', type: 'varchar2', length: 1, default: 'Y' })
  jobOrderYn!: string;

  @Column({ name: 'SUBCON_SUPPLIER_CODE', type: 'varchar2', length: 20, nullable: true })
  subconSupplierCode!: string | null;

  @Column({ name: 'STANDARD_TIME', type: 'number', precision: 10, scale: 4, nullable: true })
  standardTime!: number | null;

  @Column({ name: 'SETUP_TIME', type: 'number', precision: 10, scale: 4, nullable: true })
  setupTime!: number | null;

  @Column({ name: 'USE_YN', type: 'varchar2', length: 1, default: 'Y' })
  useYn!: string;

  @Column({ name: 'CREATED_BY', type: 'varchar2', length: 50, nullable: true })
  createdBy!: string | null;

  @CreateDateColumn({ name: 'CREATED_AT', type: 'timestamp' })
  createdAt!: Date;

  @Column({ name: 'UPDATED_BY', type: 'varchar2', length: 50, nullable: true })
  updatedBy!: string | null;

  @UpdateDateColumn({ name: 'UPDATED_AT', type: 'timestamp' })
  updatedAt!: Date;
}
