import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity({ name: 'AQL_SAMPLING_RULES' })
export class AqlSamplingRule {
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @PrimaryColumn({ type: 'varchar2', name: 'AQL_CODE', length: 50 })
  aqlCode: string;

  @PrimaryColumn({ type: 'number', name: 'LOT_QTY_FROM' })
  lotQtyFrom: number;

  @Column({ type: 'number', name: 'LOT_QTY_TO' })
  lotQtyTo: number;

  @Column({ type: 'number', name: 'SAMPLE_SIZE' })
  sampleSize: number;

  @Column({ type: 'varchar2', name: 'CODE_LETTER', length: 5, nullable: true })
  codeLetter: string | null;

  @Column({ type: 'number', name: 'ACCEPT_QTY' })
  acceptQty: number;

  @Column({ type: 'number', name: 'REJECT_QTY' })
  rejectQty: number;

  @Column({ type: 'number', name: 'SORT_ORDER', nullable: true })
  sortOrder: number | null;

  @Column({ type: 'varchar2', name: 'CREATED_BY', length: 50, nullable: true })
  createdBy: string | null;

  @Column({ type: 'varchar2', name: 'UPDATED_BY', length: 50, nullable: true })
  updatedBy: string | null;

  @CreateDateColumn({ name: 'CREATED_AT', type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'UPDATED_AT', type: 'timestamp' })
  updatedAt: Date;
}
