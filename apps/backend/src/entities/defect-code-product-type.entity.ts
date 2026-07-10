import { Column, CreateDateColumn, Entity, Index, PrimaryColumn } from 'typeorm';

@Entity({ name: 'DEFECT_CODE_PRODUCT_TYPES' })
@Index(['organizationId', 'productType'])
export class DefectCodeProductType {
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @PrimaryColumn({ type: 'varchar2', name: 'DEFECT_CODE', length: 50 })
  defectCode: string;

  @PrimaryColumn({ type: 'varchar2', name: 'PRODUCT_TYPE', length: 50 })
  productType: string;

  @Column({ type: 'varchar2', name: 'CREATED_BY', length: 50, nullable: true })
  createdBy: string | null;

  @CreateDateColumn({ name: 'CREATED_AT', type: 'timestamp' })
  createdAt: Date;
}
