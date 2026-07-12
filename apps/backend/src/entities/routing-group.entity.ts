import { Column, CreateDateColumn, Entity, PrimaryColumn, UpdateDateColumn } from 'typeorm';

@Entity({ name: 'IP_ROUTING_GROUPS' })
export class RoutingGroup {
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @PrimaryColumn({ name: 'ROUTING_CODE', type: 'varchar2', length: 50 })
  routingCode!: string;

  @Column({ name: 'ITEM_CODE', type: 'varchar2', length: 20 })
  itemCode!: string;

  @Column({ name: 'ROUTING_NAME', type: 'varchar2', length: 200 })
  routingName!: string;

  @Column({ name: 'DESCRIPTION', type: 'varchar2', length: 500, nullable: true })
  description!: string | null;

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
