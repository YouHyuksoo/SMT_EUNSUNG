import { Column, CreateDateColumn, Entity, Index, PrimaryColumn, UpdateDateColumn } from 'typeorm';

@Entity({ name: 'IP_ROUTING_MATERIALS' })
@Index('UK_IP_RM_CHILD', ['organizationId', 'routingCode', 'childItemCode'], { unique: true })
export class RoutingMaterial {
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number', nullable: false })
  organizationId!: number;

  @PrimaryColumn({ name: 'ROUTING_CODE', type: 'varchar2', length: 50, nullable: false })
  routingCode!: string;

  @PrimaryColumn({ name: 'PROCESS_SEQ', type: 'number', precision: 10, nullable: false })
  processSeq!: number;

  @PrimaryColumn({ name: 'CHILD_ITEM_CODE', type: 'varchar2', length: 20, nullable: false })
  childItemCode!: string;

  @Column({ name: 'ALLOC_QTY', type: 'number', precision: 18, scale: 6, nullable: false })
  allocQty!: number;

  @Column({ name: 'ISSUE_METHOD', type: 'varchar2', length: 20, default: 'BACKFLUSH', nullable: false })
  issueMethod!: string;

  @Column({ name: 'CREATED_BY', type: 'varchar2', length: 50, nullable: true })
  createdBy!: string | null;

  @CreateDateColumn({ name: 'CREATED_AT', type: 'timestamp', precision: 6, default: () => 'SYSTIMESTAMP', nullable: false })
  createdAt!: Date;

  @Column({ name: 'UPDATED_BY', type: 'varchar2', length: 50, nullable: true })
  updatedBy!: string | null;

  @UpdateDateColumn({ name: 'UPDATED_AT', type: 'timestamp', precision: 6, default: () => 'SYSTIMESTAMP', nullable: false })
  updatedAt!: Date;
}
