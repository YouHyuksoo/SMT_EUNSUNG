import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity({ name: 'AQL_STANDARDS' })
export class AqlStandard {
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @PrimaryColumn({ type: 'varchar2', name: 'AQL_CODE', length: 50 })
  aqlCode: string;

  @Column({ type: 'varchar2', name: 'AQL_NAME', length: 100 })
  aqlName: string;

  @Column({ type: 'varchar2', name: 'INSPECTION_LEVEL', length: 20, nullable: true })
  inspectionLevel: string | null;

  @Column({ type: 'number', name: 'AQL_VALUE', precision: 8, scale: 3, nullable: true })
  aqlValue: number | null;

  @Column({ type: 'varchar2', name: 'USE_YN', length: 1, default: 'Y' })
  useYn: string;

  @Column({ type: 'varchar2', name: 'REMARK', length: 500, nullable: true })
  remark: string | null;

  @Column({ type: 'varchar2', name: 'CREATED_BY', length: 50, nullable: true })
  createdBy: string | null;

  @Column({ type: 'varchar2', name: 'UPDATED_BY', length: 50, nullable: true })
  updatedBy: string | null;

  @CreateDateColumn({ name: 'CREATED_AT', type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'UPDATED_AT', type: 'timestamp' })
  updatedAt: Date;
}
