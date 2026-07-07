/**
 * @file entities/oee-resource.entity.ts
 * @description OEE 리소스 마스터 — OEE_RESOURCE 매핑.
 * 근거: docs/specs/2026-07-06-oee-management-design.md §3-①
 */
import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity({ name: 'OEE_RESOURCE' })
export class OeeResource {
  @PrimaryGeneratedColumn('identity', { name: 'RESOURCE_ID' })
  resourceId: number;

  @Column({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId: number;

  @Column({ name: 'PROCESS_CODE', length: 20 })
  processCode: string; // SMT/PERF/COAT/ROUTER/ASSY/PACK

  @Column({ name: 'RESOURCE_TYPE', length: 20 })
  resourceType: string; // MACHINE/LINE/WORKGROUP

  @Column({ name: 'REF_CODE', length: 50, nullable: true })
  refCode: string | null;

  @Column({ name: 'RESOURCE_NAME', length: 100 })
  resourceName: string;

  @Column({ name: 'IDEAL_CT', type: 'number', nullable: true })
  idealCt: number | null;

  @Column({ name: 'USE_YN', length: 1, default: 'Y' })
  useYn: string;

  @Column({ name: 'SORT_ORDER', type: 'number', default: 0 })
  sortOrder: number;
}
