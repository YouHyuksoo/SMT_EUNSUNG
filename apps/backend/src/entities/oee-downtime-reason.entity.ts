/**
 * @file entities/oee-downtime-reason.entity.ts
 * @description OEE 비가동사유 코드마스터 — OEE_DOWNTIME_REASON 매핑.
 * 근거: docs/specs/2026-07-06-oee-management-design.md §3-②
 */
import { Entity, PrimaryColumn, Column } from 'typeorm';

@Entity({ name: 'OEE_DOWNTIME_REASON' })
export class OeeDowntimeReason {
  @PrimaryColumn({ name: 'REASON_CODE', length: 20 })
  reasonCode: string;

  @Column({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId: number;

  @Column({ name: 'PROCESS_CODE', length: 20, default: '*' })
  processCode: string; // '*'=공통 또는 공정별

  @Column({ name: 'REASON_NAME', length: 100 })
  reasonName: string;

  @Column({ name: 'LOSS_BUCKET', length: 30 })
  lossBucket: string; // AVAIL_DOWN/SETUP/MATERIAL/PERF_MINOR_STOP/PERF_SPEED

  @Column({ name: 'OEE_FACTOR', length: 20 })
  oeeFactor: string; // AVAILABILITY/PERFORMANCE

  @Column({ name: 'USE_YN', length: 1, default: 'Y' })
  useYn: string;

  @Column({ name: 'SORT_ORDER', type: 'number', default: 0 })
  sortOrder: number;
}
