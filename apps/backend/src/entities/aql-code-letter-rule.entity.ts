import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity({ name: 'AQL_CODE_LETTER_RULES' })
export class AqlCodeLetterRule {
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @PrimaryColumn({ type: 'varchar2', name: 'INSPECTION_LEVEL', length: 20 })
  inspectionLevel: string;

  @PrimaryColumn({ type: 'number', name: 'LOT_QTY_FROM' })
  lotQtyFrom: number;

  @Column({ type: 'number', name: 'LOT_QTY_TO' })
  lotQtyTo: number;

  @Column({ type: 'varchar2', name: 'CODE_LETTER', length: 5 })
  codeLetter: string;

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
