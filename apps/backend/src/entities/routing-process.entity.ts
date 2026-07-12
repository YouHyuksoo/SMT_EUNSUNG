import { Column, CreateDateColumn, Entity, PrimaryColumn, UpdateDateColumn } from 'typeorm';

@Entity({ name: 'IP_ROUTING_PROCESSES' })
export class RoutingProcess {
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number', nullable: false })
  organizationId!: number;

  @PrimaryColumn({ name: 'ROUTING_CODE', type: 'varchar2', length: 50, nullable: false })
  routingCode!: string;

  @PrimaryColumn({ name: 'PROCESS_SEQ', type: 'number', precision: 10, nullable: false })
  processSeq!: number;

  @Column({ name: 'WORKSTAGE_CODE', type: 'varchar2', length: 10, nullable: false })
  workstageCode!: string;

  @Column({ name: 'EXECUTION_TYPE', type: 'varchar2', length: 20, default: 'INTERNAL', nullable: false })
  executionType!: 'INTERNAL' | 'SUBCON';

  @Column({ name: 'JOB_ORDER_YN', type: 'varchar2', length: 1, default: 'Y', nullable: false })
  jobOrderYn!: string;

  @Column({ name: 'SUBCON_SUPPLIER_CODE', type: 'varchar2', length: 20, nullable: true })
  subconSupplierCode!: string | null;

  @Column({ name: 'STANDARD_TIME', type: 'number', precision: 10, scale: 4, nullable: true })
  standardTime!: number | null;

  @Column({ name: 'SETUP_TIME', type: 'number', precision: 10, scale: 4, nullable: true })
  setupTime!: number | null;

  @Column({ name: 'USE_YN', type: 'varchar2', length: 1, default: 'Y', nullable: false })
  useYn!: string;

  @Column({ name: 'CREATED_BY', type: 'varchar2', length: 50, nullable: true })
  createdBy!: string | null;

  @CreateDateColumn({ name: 'CREATED_AT', type: 'timestamp', precision: 6, default: () => 'SYSTIMESTAMP', nullable: false })
  createdAt!: Date;

  @Column({ name: 'UPDATED_BY', type: 'varchar2', length: 50, nullable: true })
  updatedBy!: string | null;

  @UpdateDateColumn({ name: 'UPDATED_AT', type: 'timestamp', precision: 6, default: () => 'SYSTIMESTAMP', nullable: false })
  updatedAt!: Date;
}
